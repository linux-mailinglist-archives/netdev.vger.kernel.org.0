Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACA24BC5F7
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 07:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240579AbiBSGKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 01:10:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237474AbiBSGKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 01:10:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126FD5F4C6
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 22:09:47 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21J4gtcP025544
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 06:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=q0VvUaSLjTZZEdvlFqLKyT71ioEcn7IOWKJmRAwK7BE=;
 b=dphyDvyb9AcA9pl8zdQr0tdi7+KYnE7jaI6nliT4+qCCTLiooPuAry5UiRYleBYefQdA
 Q5q1EYUdwdOFBmYfTejDqEhzGG1YXsOLo/zd6fWyGXsm5ifkgZqc0kWR5DQZrSWkg0Ua
 o8uL/t3X8kaWbk+FKcc8A8HM4V+NOb81F113lkLgDIJ68BfoJiuFshwssssvgbv4Jzea
 6B5sq9zWyh/IV5IdvLVXk7Py+ntxRYa4WsFFlNcRpZDC5VrY52RQj53tFGaKo9kkYA1s
 plUXnvO3bhmrHIH5g6Grvv8FrQyeO5R4em0/vVg8mNpEMubpWFMYqJv2YLtFGZXiXdKT Kw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3easrbs33d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 06:09:46 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21J68T4l028601
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 06:09:45 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 3ear68s62v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 06:09:45 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21J69fjE15598228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 06:09:41 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 139837805C;
        Sat, 19 Feb 2022 06:09:41 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B757F7805F;
        Sat, 19 Feb 2022 06:09:39 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.137.114])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 19 Feb 2022 06:09:39 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com,
        vaish123@in.ibm.com
Subject: [PATCH net-next-internal 1/1] ibmvnic: Drop IBMVNIC_BUFFER_HLEN
Date:   Fri, 18 Feb 2022 22:09:38 -0800
Message-Id: <20220219060938.1297423-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YeqiizWh5-H8i6MbmtdCkSS0BhZw6tLm
X-Proofpoint-GUID: YeqiizWh5-H8i6MbmtdCkSS0BhZw6tLm
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-19_02,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202190032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c26eba03e407 ("ibmvnic: Update reset infrastructure to support
tunable parameters") (Oct 2017) defined/used IBMVNIC_BUFFER_HLEN (500)
in the computation of max_entries but its not clear what the intention
was.  If the macro is needed for the protocol or somewhere else, it
should have been used in some allocation/alignment of the rx buffers
but is not being used.

It also confuses the notion of the number of packets that can fit in
an LTB. For instance with 16MB LTB we should be able to fit in 1849
jumbo frames of 9088 bytes*. But these 500 bytes makes it appear that
we can only fit 16MB / 9514 or 1763 packets in the LTB. Even that
computation is inconsistent as the 9514 size does account for VLAN_HLEN
or the 128-byte alignment.

*MTU to LTB buffer size:

	Header: ETH_HLEN + VLAN_HLEN = 14 + 4 = 18.
	Alignment: 128 (L1_CACHE_BYTES)

	9000 MTU + Header = 9018. Align to 128: 9088.
	1500 MTU + Header = 1518. Align to 128: 1536.

If we adjust this computation and drop the IBMVNIC_BUFFER_HLEN, we can
use a 6MB MAX_ONE_LTB_SIZE and be more be a bit more efficient when
changing MTU sizes. The 6MB size perfectly fits the 4K packets of normal
mtu (1536). With jumbo frames we can use need a set of 6 LTBs of size 6MB
for the 4K*9088 packets. For 32 rx and tx queues (16 each) we need 192
LTBs  and for the 16 TSO pools we need another 16 LTBs for a total of
208 LTBs so we will be within the limit.

Using 6MB LTB rather than 8MB lets us try and reuse the first LTB when
switching MTU sizes (if we use the patch

https://lists.linux.ibm.com/mailinglists/pipermail/ibmvnic-review/2021-December/000155.html

The smaller LTB also further reduces the chance of an allocation failure
during low memory conditions while remaining well within the limit of 255
LTBs per vnic.

Do we need IBMVNIC_BUFFER_HLEN?

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 14 ++++++++------
 drivers/net/ethernet/ibm/ibmvnic.h | 18 ++++++++----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2e5bf27e3e3d..c496f4de1757 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4116,6 +4116,7 @@ static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
 	struct device *dev = &adapter->vdev->dev;
 	union ibmvnic_crq crq;
 	int max_entries;
+	int buff_size;
 	int cap_reqs;
 
 	/* We send out 6 or 7 REQUEST_CAPABILITY CRQs below (depending on
@@ -4153,16 +4154,17 @@ static void send_request_cap(struct ibmvnic_adapter *adapter, int retry)
 			adapter->desired.rx_entries =
 					adapter->max_rx_add_entries_per_subcrq;
 
-		max_entries = IBMVNIC_MAX_LTB_SIZE /
-			      (adapter->req_mtu + IBMVNIC_BUFFER_HLEN);
+		buff_size = adapter->req_mtu + VLAN_HLEN;
+		buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
+		max_entries = IBMVNIC_MAX_LTB_SIZE / buff_size;
 
-		if ((adapter->req_mtu + IBMVNIC_BUFFER_HLEN) *
-			adapter->desired.tx_entries > IBMVNIC_MAX_LTB_SIZE) {
+		if ((buff_size * adapter->desired.tx_entries) >
+		    IBMVNIC_MAX_LTB_SIZE) {
 			adapter->desired.tx_entries = max_entries;
 		}
 
-		if ((adapter->req_mtu + IBMVNIC_BUFFER_HLEN) *
-			adapter->desired.rx_entries > IBMVNIC_MAX_LTB_SIZE) {
+		if ((buff_size * adapter->desired.rx_entries) >
+		    IBMVNIC_MAX_LTB_SIZE) {
 			adapter->desired.rx_entries = max_entries;
 		}
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 8d92ce5a6c5f..1b124f884311 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -45,32 +45,30 @@
  * are of fixed length (IBMVNIC_TSO_BUF_SZ * IBMVNIC_TSO_BUFS) of 4MB.
  *
  * The Rx and Tx pools can have upto 4096 buffers. The max size of these
- * buffers is about 9588 (for jumbo frames, including IBMVNIC_BUFFER_HLEN).
- * So, setting the MAX_LTB_SIZE for a pool to 4096 * 9588 ~= 38MB.
+ * buffers is about 9088 (for jumbo frames). So, setting the MAX_LTB_SIZE
+ * for a pool to 4096 * 9088 ~= 36MB.
  *
  * There is a trade-off in setting MAX_ONE_LTB_SIZE. If it is large, the
  * allocation of the LTB can fail when system is low in memory. If its too
  * small, we would need several mappings for each of the Rx/Tx/TSO pools,
  * but there is a limit of 255 mappings per vnic in the VNIC protocol.
  *
- * Setting MAX_ONE_LTB_SIZE to 8MB. This requires 5 LTBs per Rx and Tx
- * pool for the MAX_LTB_SIZE of 38MB (above) and 1 LTB per TSO pool for
- * the 4MB. Thus the 16 Rx and Tx queues require 32 * 5 = 160 plus 16 for
- * the TSO pools for a total of 176 LTB mappings.
+ * Setting MAX_ONE_LTB_SIZE to 6MB. This requires 6 LTBs per Rx and Tx
+ * pool for the MAX_LTB_SIZE of 36MB (above) and 1 LTB per TSO pool for
+ * the 4MB. Thus the 16 Rx and Tx queues require 32 * 6 = 192 plus 16 for
+ * the TSO pools for a total of 208 LTB mappings.
  *
  * The max size of a single LTB is also limited by the MAX_ORDER in the
  * kernel. Add a compile time check for that.
  */
-#define IBMVNIC_MAX_ONE_LTB_SIZE	(8 << 20)
-#define IBMVNIC_MAX_LTB_SIZE		(38 << 20)
+#define IBMVNIC_MAX_ONE_LTB_SIZE	(6 << 20)
+#define IBMVNIC_MAX_LTB_SIZE		(36 << 20)
 #define IBMVNIC_ONE_LTB_SIZE_LIMIT	((1 << (MAX_ORDER - 1)) * PAGE_SIZE)
 
 #if IBMVNIC_MAX_ONE_LTB_SIZE > IBMVNIC_ONE_LTB_SIZE_LIMIT
 #error
 #endif
 
-#define IBMVNIC_BUFFER_HLEN		500
-
 #define IBMVNIC_RESET_DELAY 100
 
 static const char ibmvnic_priv_flags[][ETH_GSTRING_LEN] = {
-- 
2.27.0

