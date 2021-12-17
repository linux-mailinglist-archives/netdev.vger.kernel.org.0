Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9822C47920A
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbhLQQ4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:56:25 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55190 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239432AbhLQQ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 11:56:24 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BHAhntX030897;
        Fri, 17 Dec 2021 08:56:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Ydn6MjMEyHShq+mI7krCnf3Bm774HEbNxphr51cYbYo=;
 b=JCW/vTJBv6Sq5Zgho/SsitoHC2RMWv4eejiOAbPXSKHmpAbm8VRlt857xGVcHT3jyrnL
 Tm0dICNvlZ0UVtkKWkshnhPnjr0SSX7K74GUgBUwFzBoim032c5GJU9dqo5UNR63983H
 y5qvA8L06SDcyPNKv64SZXSN5ikVQ5wxNrvo004D/TnRdFEu/rIvVnFGxSxxf9hN3Ilc
 GhAzKNufINqipoSmTwF3c/jtuMgb5Burxduu3fgVO3g7ZOvxTEd/Z6yj9R0U/xHXZpC2
 zBfu6EFJkLR6wJRndyUhxG19Disp7pxFVMYyFARq31Egra96P5hYgZPdb/P+yxQzEdRv gQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3d0s28h7dc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 08:56:17 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Dec
 2021 08:56:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 17 Dec 2021 08:56:14 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AE96A3F70A7;
        Fri, 17 Dec 2021 08:56:14 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BHGuBF6000814;
        Fri, 17 Dec 2021 08:56:11 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BHGtuta000813;
        Fri, 17 Dec 2021 08:55:56 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware 7.13.21.0
Date:   Fri, 17 Dec 2021 08:55:51 -0800
Message-ID: <20211217165552.746-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 3a0oYtOV5Jm1JakYhd8lCyaQRdaeoyeX
X-Proofpoint-ORIG-GUID: 3a0oYtOV5Jm1JakYhd8lCyaQRdaeoyeX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_06,2021-12-16_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new firmware addresses few important issues and enhancements
as mentioned below -

- Support direct invalidation of FP HSI Ver per function ID, required for
  invalidating FP HSI Ver prior to each VF start, as there is no VF start
- BRB hardware block parity error detection support for the driver
- Fix the FCOE underrun flow
- Fix PSOD during FCoE BFS over the NIC ports after preboot driver
- Maintains backward compatibility

This patch incorporates this new firmware 7.13.21.0 in bnx2x driver.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---

v1->v2:
------------
* Modified the patch such that driver to be backward compatible
  with older firmware too (New fw v7.13.21.0 on linux-firmware.git
  enables driver to maintain backward compatibility)
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        | 11 +++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    |  2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |  3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 75 +++++++++++++++-------
 5 files changed, 69 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index 2b06d78b..a19dd67 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1850,6 +1850,14 @@ struct bnx2x {
 
 	/* Vxlan/Geneve related information */
 	u16 udp_tunnel_ports[BNX2X_UDP_PORT_MAX];
+
+#define FW_CAP_INVALIDATE_VF_FP_HSI	BIT(0)
+	u32 fw_cap;
+
+	u32 fw_major;
+	u32 fw_minor;
+	u32 fw_rev;
+	u32 fw_eng;
 };
 
 /* Tx queues may be less or equal to Rx queues */
@@ -2525,5 +2533,6 @@ enum {
  * Meant for implicit re-load flows.
  */
 int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
-
+int bnx2x_init_firmware(struct bnx2x *bp);
+void bnx2x_release_firmware(struct bnx2x *bp);
 #endif /* bnx2x.h */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 54a2334..8d36ebb 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2365,10 +2365,8 @@ int bnx2x_compare_fw_ver(struct bnx2x *bp, u32 load_code, bool print_err)
 	if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
 	    load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
 		/* build my FW version dword */
-		u32 my_fw = (BCM_5710_FW_MAJOR_VERSION) +
-			(BCM_5710_FW_MINOR_VERSION << 8) +
-			(BCM_5710_FW_REVISION_VERSION << 16) +
-			(BCM_5710_FW_ENGINEERING_VERSION << 24);
+		u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
+				(bp->fw_rev << 16) + (bp->fw_eng << 24);
 
 		/* read loaded FW from chip */
 		u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
index 3f84352..a84d015 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
@@ -241,6 +241,8 @@
 	IRO[221].m2))
 #define XSTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[48].base + ((funcId) * IRO[48].m1))
+#define XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(fid)	\
+	(IRO[386].base + ((fid) * IRO[386].m1))
 #define COMMON_ASM_INVALID_ASSERT_OPCODE 0x0
 
 /* eth hsi version */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
index 622fadc..611efee 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
@@ -3024,7 +3024,8 @@ struct afex_stats {
 
 #define BCM_5710_FW_MAJOR_VERSION			7
 #define BCM_5710_FW_MINOR_VERSION			13
-#define BCM_5710_FW_REVISION_VERSION		15
+#define BCM_5710_FW_REVISION_VERSION		21
+#define BCM_5710_FW_REVISION_VERSION_V15	15
 #define BCM_5710_FW_ENGINEERING_VERSION		0
 #define BCM_5710_FW_COMPILE_FLAGS			1
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index aec666e..125dafe 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -74,9 +74,19 @@
 	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
 	__stringify(BCM_5710_FW_REVISION_VERSION) "."	\
 	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
+
+#define FW_FILE_VERSION_V15				\
+	__stringify(BCM_5710_FW_MAJOR_VERSION) "."      \
+	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
+	__stringify(BCM_5710_FW_REVISION_VERSION_V15) "."	\
+	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
+
 #define FW_FILE_NAME_E1		"bnx2x/bnx2x-e1-" FW_FILE_VERSION ".fw"
 #define FW_FILE_NAME_E1H	"bnx2x/bnx2x-e1h-" FW_FILE_VERSION ".fw"
 #define FW_FILE_NAME_E2		"bnx2x/bnx2x-e2-" FW_FILE_VERSION ".fw"
+#define FW_FILE_NAME_E1_V15	"bnx2x/bnx2x-e1-" FW_FILE_VERSION_V15 ".fw"
+#define FW_FILE_NAME_E1H_V15	"bnx2x/bnx2x-e1h-" FW_FILE_VERSION_V15 ".fw"
+#define FW_FILE_NAME_E2_V15	"bnx2x/bnx2x-e2-" FW_FILE_VERSION_V15 ".fw"
 
 /* Time in jiffies before concluding the transmitter is hung */
 #define TX_TIMEOUT		(5*HZ)
@@ -747,9 +757,7 @@ static int bnx2x_mc_assert(struct bnx2x *bp)
 		  CHIP_IS_E1(bp) ? "everest1" :
 		  CHIP_IS_E1H(bp) ? "everest1h" :
 		  CHIP_IS_E2(bp) ? "everest2" : "everest3",
-		  BCM_5710_FW_MAJOR_VERSION,
-		  BCM_5710_FW_MINOR_VERSION,
-		  BCM_5710_FW_REVISION_VERSION);
+		  bp->fw_major, bp->fw_minor, bp->fw_rev);
 
 	return rc;
 }
@@ -12308,6 +12316,15 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 	bnx2x_read_fwinfo(bp);
 
+	if (IS_PF(bp)) {
+		rc = bnx2x_init_firmware(bp);
+
+		if (rc) {
+			bnx2x_free_mem_bp(bp);
+			return rc;
+		}
+	}
+
 	func = BP_FUNC(bp);
 
 	/* need to reset chip if undi was active */
@@ -12320,6 +12337,7 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 		rc = bnx2x_prev_unload(bp);
 		if (rc) {
+			bnx2x_release_firmware(bp);
 			bnx2x_free_mem_bp(bp);
 			return rc;
 		}
@@ -13317,16 +13335,11 @@ static int bnx2x_check_firmware(struct bnx2x *bp)
 	/* Check FW version */
 	offset = be32_to_cpu(fw_hdr->fw_version.offset);
 	fw_ver = firmware->data + offset;
-	if ((fw_ver[0] != BCM_5710_FW_MAJOR_VERSION) ||
-	    (fw_ver[1] != BCM_5710_FW_MINOR_VERSION) ||
-	    (fw_ver[2] != BCM_5710_FW_REVISION_VERSION) ||
-	    (fw_ver[3] != BCM_5710_FW_ENGINEERING_VERSION)) {
+	if (fw_ver[0] != bp->fw_major || fw_ver[1] != bp->fw_minor ||
+	    fw_ver[2] != bp->fw_rev || fw_ver[3] != bp->fw_eng) {
 		BNX2X_ERR("Bad FW version:%d.%d.%d.%d. Should be %d.%d.%d.%d\n",
-		       fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
-		       BCM_5710_FW_MAJOR_VERSION,
-		       BCM_5710_FW_MINOR_VERSION,
-		       BCM_5710_FW_REVISION_VERSION,
-		       BCM_5710_FW_ENGINEERING_VERSION);
+			  fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
+			  bp->fw_major, bp->fw_minor, bp->fw_rev, bp->fw_eng);
 		return -EINVAL;
 	}
 
@@ -13404,34 +13417,51 @@ static void be16_to_cpu_n(const u8 *_source, u8 *_target, u32 n)
 	     (u8 *)bp->arr, len);					\
 } while (0)
 
-static int bnx2x_init_firmware(struct bnx2x *bp)
+int bnx2x_init_firmware(struct bnx2x *bp)
 {
-	const char *fw_file_name;
+	const char *fw_file_name, *fw_file_name_v15;
 	struct bnx2x_fw_file_hdr *fw_hdr;
 	int rc;
 
 	if (bp->firmware)
 		return 0;
 
-	if (CHIP_IS_E1(bp))
+	if (CHIP_IS_E1(bp)) {
 		fw_file_name = FW_FILE_NAME_E1;
-	else if (CHIP_IS_E1H(bp))
+		fw_file_name_v15 = FW_FILE_NAME_E1_V15;
+	} else if (CHIP_IS_E1H(bp)) {
 		fw_file_name = FW_FILE_NAME_E1H;
-	else if (!CHIP_IS_E1x(bp))
+		fw_file_name_v15 = FW_FILE_NAME_E1H_V15;
+	} else if (!CHIP_IS_E1x(bp)) {
 		fw_file_name = FW_FILE_NAME_E2;
-	else {
+		fw_file_name_v15 = FW_FILE_NAME_E2_V15;
+	} else {
 		BNX2X_ERR("Unsupported chip revision\n");
 		return -EINVAL;
 	}
+
 	BNX2X_DEV_INFO("Loading %s\n", fw_file_name);
 
 	rc = request_firmware(&bp->firmware, fw_file_name, &bp->pdev->dev);
 	if (rc) {
-		BNX2X_ERR("Can't load firmware file %s\n",
-			  fw_file_name);
-		goto request_firmware_exit;
+		BNX2X_DEV_INFO("Trying to load older fw %s\n", fw_file_name_v15);
+
+		/* try to load prev version */
+		rc = request_firmware(&bp->firmware, fw_file_name_v15, &bp->pdev->dev);
+
+		if (rc)
+			goto request_firmware_exit;
+
+		bp->fw_rev = BCM_5710_FW_REVISION_VERSION_V15;
+	} else {
+		bp->fw_cap |= FW_CAP_INVALIDATE_VF_FP_HSI;
+		bp->fw_rev = BCM_5710_FW_REVISION_VERSION;
 	}
 
+	bp->fw_major = BCM_5710_FW_MAJOR_VERSION;
+	bp->fw_minor = BCM_5710_FW_MINOR_VERSION;
+	bp->fw_eng = BCM_5710_FW_ENGINEERING_VERSION;
+
 	rc = bnx2x_check_firmware(bp);
 	if (rc) {
 		BNX2X_ERR("Corrupt firmware file %s\n", fw_file_name);
@@ -13487,7 +13517,7 @@ static int bnx2x_init_firmware(struct bnx2x *bp)
 	return rc;
 }
 
-static void bnx2x_release_firmware(struct bnx2x *bp)
+void bnx2x_release_firmware(struct bnx2x *bp)
 {
 	kfree(bp->init_ops_offsets);
 	kfree(bp->init_ops);
@@ -14004,6 +14034,7 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 	return 0;
 
 init_one_freemem:
+	bnx2x_release_firmware(bp);
 	bnx2x_free_mem_bp(bp);
 
 init_one_exit:
-- 
1.8.3.1

