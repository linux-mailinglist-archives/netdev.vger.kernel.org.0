Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D03F651698
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 00:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbiLSXFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 18:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiLSXDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 18:03:48 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7722617047;
        Mon, 19 Dec 2022 15:01:20 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJIKvmX015286;
        Mon, 19 Dec 2022 23:00:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=SWJzjgVg9CxBHb/tHJ5rN/ghb1Be0SCQGn7z+gHv/Rw=;
 b=fH3cB2T1WJreeiJ/LAGY71vNdTnLJyvOqSGyObN9BGM7zDLU87yKQ/xEMExPM3HvJmzh
 NAnJRSEX9A98VAA932urzSj6HVTDq7KfRCoDHQUdZm8d3L0ATLdddnBhxcHoker8qmgV
 MHGdpie/Y8/NwFmxH6WeGONd0CLlkhgnd7l+gWTuU9X97AfpW94HO2hMCJ9CQMWfpHKw
 uGqDzuO5wyf/XWpig8+NRpCu71VNVhYs/Z15bi33YJIi1lXzg+VuPugEbFq+/6OIbZRP
 dj/GfsRpJvgRS9M+0ikdc+Ae//Pqe7W5ebkW6WVbAe2Lbj8iPPTf/tM1N8LtuxhWP289 cg== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mh72gd4dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 23:00:46 +0000
Received: from nasanex01b.na.qualcomm.com (corens_vlan604_snip.qualcomm.com [10.53.140.1])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BJN0gBV006331
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 23:00:42 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 19 Dec 2022 15:00:41 -0800
From:   Elliot Berman <quic_eberman@quicinc.com>
To:     Bjorn Andersson <quic_bjorande@quicinc.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
CC:     Elliot Berman <quic_eberman@quicinc.com>,
        Murali Nalajala <quic_mnalajal@quicinc.com>,
        Trilok Soni <quic_tsoni@quicinc.com>,
        "Srivatsa Vaddagiri" <quic_svaddagi@quicinc.com>,
        Carl van Schaik <quic_cvanscha@quicinc.com>,
        Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        "Dmitry Baryshkov" <dmitry.baryshkov@linaro.org>,
        <linux-arm-msm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-acpi@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>
Subject: [PATCH v8 18/28] firmware: qcom_scm: Use fixed width src vm bitmap
Date:   Mon, 19 Dec 2022 14:58:39 -0800
Message-ID: <20221219225850.2397345-19-quic_eberman@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221219225850.2397345-1-quic_eberman@quicinc.com>
References: <20221219225850.2397345-1-quic_eberman@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: rAJFpKPyIcVWf8l1hxpOMIY0DGylboWS
X-Proofpoint-ORIG-GUID: rAJFpKPyIcVWf8l1hxpOMIY0DGylboWS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 suspectscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190202
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum VMID for assign_mem is 63. Use a u64 to represent this
bitmap instead of architecture-dependent "unsigned int" which varies in
size on 32-bit and 64-bit platforms.

Acked-by: Kalle Valo <kvalo@kernel.org> [ath10k]
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 drivers/firmware/qcom_scm.c           | 12 +++++++-----
 drivers/misc/fastrpc.c                |  6 ++++--
 drivers/net/wireless/ath/ath10k/qmi.c |  4 ++--
 drivers/remoteproc/qcom_q6v5_mss.c    |  8 ++++----
 drivers/soc/qcom/rmtfs_mem.c          |  2 +-
 include/linux/qcom_scm.h              |  2 +-
 6 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index cdbfe54c8146..92763dce6477 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -898,7 +898,7 @@ static int __qcom_scm_assign_mem(struct device *dev, phys_addr_t mem_region,
  * Return negative errno on failure or 0 on success with @srcvm updated.
  */
 int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
-			unsigned int *srcvm,
+			u64 *srcvm,
 			const struct qcom_scm_vmperm *newvm,
 			unsigned int dest_cnt)
 {
@@ -915,9 +915,9 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	__le32 *src;
 	void *ptr;
 	int ret, i, b;
-	unsigned long srcvm_bits = *srcvm;
+	u64 srcvm_bits = *srcvm;
 
-	src_sz = hweight_long(srcvm_bits) * sizeof(*src);
+	src_sz = hweight64(srcvm_bits) * sizeof(*src);
 	mem_to_map_sz = sizeof(*mem_to_map);
 	dest_sz = dest_cnt * sizeof(*destvm);
 	ptr_sz = ALIGN(src_sz, SZ_64) + ALIGN(mem_to_map_sz, SZ_64) +
@@ -930,8 +930,10 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	/* Fill source vmid detail */
 	src = ptr;
 	i = 0;
-	for_each_set_bit(b, &srcvm_bits, BITS_PER_LONG)
-		src[i++] = cpu_to_le32(b);
+	for (b = 0; b < BITS_PER_TYPE(u64); b++) {
+		if (srcvm_bits & BIT(b))
+			src[i++] = cpu_to_le32(b);
+	}
 
 	/* Fill details of mem buff to map */
 	mem_to_map = ptr + ALIGN(src_sz, SZ_64);
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 7ff0b63c25e3..2ad388f99fe1 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -299,11 +299,13 @@ static void fastrpc_free_map(struct kref *ref)
 		if (map->attr & FASTRPC_ATTR_SECUREMAP) {
 			struct qcom_scm_vmperm perm;
 			int err = 0;
+			u64 src;
 
+			src = BIT(map->fl->cctx->vmperms[0].vmid);
 			perm.vmid = QCOM_SCM_VMID_HLOS;
 			perm.perm = QCOM_SCM_PERM_RWX;
 			err = qcom_scm_assign_mem(map->phys, map->size,
-				&(map->fl->cctx->vmperms[0].vmid), &perm, 1);
+				&src, &perm, 1);
 			if (err) {
 				dev_err(map->fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d",
 						map->phys, map->size, err);
@@ -744,7 +746,7 @@ static int fastrpc_map_create(struct fastrpc_user *fl, int fd,
 		 * If subsystem VMIDs are defined in DTSI, then do
 		 * hyp_assign from HLOS to those VM(s)
 		 */
-		unsigned int perms = BIT(QCOM_SCM_VMID_HLOS);
+		u64 perms = BIT(QCOM_SCM_VMID_HLOS);
 
 		map->attr = attr;
 		err = qcom_scm_assign_mem(map->phys, (u64)map->size, &perms,
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 66cb7a1e628a..6d1d87e1cdde 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -28,7 +28,7 @@ static int ath10k_qmi_map_msa_permission(struct ath10k_qmi *qmi,
 {
 	struct qcom_scm_vmperm dst_perms[3];
 	struct ath10k *ar = qmi->ar;
-	unsigned int src_perms;
+	u64 src_perms;
 	u32 perm_count;
 	int ret;
 
@@ -60,7 +60,7 @@ static int ath10k_qmi_unmap_msa_permission(struct ath10k_qmi *qmi,
 {
 	struct qcom_scm_vmperm dst_perms;
 	struct ath10k *ar = qmi->ar;
-	unsigned int src_perms;
+	u64 src_perms;
 	int ret;
 
 	src_perms = BIT(QCOM_SCM_VMID_MSS_MSA) | BIT(QCOM_SCM_VMID_WLAN);
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index fddb63cffee0..9e8bde7a7ec4 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -227,8 +227,8 @@ struct q6v5 {
 	bool has_qaccept_regs;
 	bool has_ext_cntl_regs;
 	bool has_vq6;
-	int mpss_perm;
-	int mba_perm;
+	u64 mpss_perm;
+	u64 mba_perm;
 	const char *hexagon_mdt_image;
 	int version;
 };
@@ -404,7 +404,7 @@ static void q6v5_pds_disable(struct q6v5 *qproc, struct device **pds,
 	}
 }
 
-static int q6v5_xfer_mem_ownership(struct q6v5 *qproc, int *current_perm,
+static int q6v5_xfer_mem_ownership(struct q6v5 *qproc, u64 *current_perm,
 				   bool local, bool remote, phys_addr_t addr,
 				   size_t size)
 {
@@ -939,7 +939,7 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw,
 	struct page *page;
 	dma_addr_t phys;
 	void *metadata;
-	int mdata_perm;
+	u64 mdata_perm;
 	int xferop_ret;
 	size_t size;
 	void *vaddr;
diff --git a/drivers/soc/qcom/rmtfs_mem.c b/drivers/soc/qcom/rmtfs_mem.c
index 0feaae357821..69991e47aa23 100644
--- a/drivers/soc/qcom/rmtfs_mem.c
+++ b/drivers/soc/qcom/rmtfs_mem.c
@@ -30,7 +30,7 @@ struct qcom_rmtfs_mem {
 
 	unsigned int client_id;
 
-	unsigned int perms;
+	u64 perms;
 };
 
 static ssize_t qcom_rmtfs_mem_show(struct device *dev,
diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
index f8335644a01a..77f7b5837216 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -96,7 +96,7 @@ extern int qcom_scm_mem_protect_video_var(u32 cp_start, u32 cp_size,
 					  u32 cp_nonpixel_start,
 					  u32 cp_nonpixel_size);
 extern int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
-			       unsigned int *src,
+			       u64 *src,
 			       const struct qcom_scm_vmperm *newvm,
 			       unsigned int dest_cnt);
 
-- 
2.25.1

