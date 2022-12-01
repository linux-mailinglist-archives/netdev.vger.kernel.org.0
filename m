Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F26963F705
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiLASBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiLASBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:01:06 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F153B3905;
        Thu,  1 Dec 2022 10:01:03 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1DGjKj014892;
        Thu, 1 Dec 2022 10:00:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=bPE4OdvmsWxfPMVI5QVP2HWGItHFOOsD4H09tD+WEFc=;
 b=NlZgz2gy77vOkUUWSd0hynaDHPeUaPCwKV6a2zVfqU7h8YoUI43WhP5MFxoX7Akm2Srn
 E5XusfKKxN8ki/W3EQyUhsB8PbwRRWD7E0VFyYDAGQ0bjR2TrD9py8a/W5Mq2NmQLyPR
 kD+PFiJPLbL2GiifLIC65fX5vfb85ROq0ubuSGcrI3/KyJz0uAKx/XHIpoNiwKkdgJV4
 klPWRzuThKJbwo5/ZYozI13f30Jn9Qi1hXe419rgF2yveQGL0IWrj43ax+I9KnYgUjfy
 QPEzP0DHXlAW85knj+ub4QSh/u1ItB5UMNsWE+/JLMhKq+ZnV/h1w0NE4CBi3t7dTXja 6w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m6k712xxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 10:00:54 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Dec
 2022 10:00:52 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 1 Dec 2022 10:00:52 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 1417C3F7045;
        Thu,  1 Dec 2022 10:00:48 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH v3 2/4] octeontx2-af: cn10kb: Add RPM_USX MAC support
Date:   Thu, 1 Dec 2022 23:30:38 +0530
Message-ID: <20221201180040.14147-3-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221201180040.14147-1-hkelam@marvell.com>
References: <20221201180040.14147-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: J4SVJI97srhBVuM4FJ3Iq0-SOl6M3P2Z
X-Proofpoint-GUID: J4SVJI97srhBVuM4FJ3Iq0-SOl6M3P2Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_12,2022-12-01_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OcteonTx2's next gen platform the CN10KB has RPM_USX MAC which has a
different serdes when compared to RPM MAC. Though the underlying
HW is different, the CSR interface has been designed largely inline
with RPM MAC, with few exceptions though. So we are using the same
CGX driver for RPM_USX MAC as well and will have a different set of APIs
for RPM_USX where ever necessary.

The RPM and RPM_USX blocks support a different number of LMACS.
RPM_USX support 8 LMACS per MAC block whereas legacy RPM supports only 4
LMACS per MAC. with this RPM_USX support double the number of DMAC filters
and fifo size.

This patch adds initial support for CN10KB's RPM_USX  MAC i.e registering
the driver and defining MAC operations (mac_ops). Adds the logic to
configure internal loopback and pause frames and assign FIFO length to
LMACS.

Kernel reads lmac features like lmac type, autoneg, etc from shared
firmware data this structure only supports 4 lmacs per MAC, this patch
extends this structure to accommodate 8 lmacs.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |  38 +++-
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |   3 +-
 .../marvell/octeontx2/af/lmac_common.h        |   7 +-
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 204 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/rpm.h   |  22 ++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  10 +-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |  19 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   8 +-
 8 files changed, 270 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fa5a1e88cb84..242c5b0eb15d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -64,6 +64,7 @@ static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool en);
 static const struct pci_device_id cgx_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_CGX) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_RPM) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10KB_RPM) },
 	{ 0, }  /* end of table */
 };
 
@@ -73,7 +74,8 @@ static bool is_dev_rpm(void *cgxd)
 {
 	struct cgx *cgx = cgxd;
 
-	return (cgx->pdev->device == PCI_DEVID_CN10K_RPM);
+	return (cgx->pdev->device == PCI_DEVID_CN10K_RPM) ||
+	       (cgx->pdev->device == PCI_DEVID_CN10KB_RPM);
 }
 
 bool is_lmac_valid(struct cgx *cgx, int lmac_id)
@@ -485,7 +487,7 @@ int cgx_set_pkind(void *cgxd, u8 lmac_id, int pkind)
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 
-	cgx_write(cgx, lmac_id, CGXX_CMRX_RX_ID_MAP, (pkind & 0x3F));
+	cgx_write(cgx, lmac_id, cgx->mac_ops->rxid_map_offset, (pkind & 0x3F));
 	return 0;
 }
 
@@ -1224,7 +1226,7 @@ static inline void link_status_user_format(u64 lstat,
 	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
 	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
 	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
-	linfo->lmac_type_id = cgx_get_lmac_type(cgx, lmac_id);
+	linfo->lmac_type_id = FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
 	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
 	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
 }
@@ -1599,8 +1601,14 @@ static int cgx_lmac_init(struct cgx *cgx)
 	/* lmac_list specifies which lmacs are enabled
 	 * when bit n is set to 1, LMAC[n] is enabled
 	 */
-	if (cgx->mac_ops->non_contiguous_serdes_lane)
-		lmac_list = cgx_read(cgx, 0, CGXX_CMRX_RX_LMACS) & 0xFULL;
+	if (cgx->mac_ops->non_contiguous_serdes_lane) {
+		if (is_dev_rpm2(cgx))
+			lmac_list =
+				cgx_read(cgx, 0, RPM2_CMRX_RX_LMACS) & 0xFFULL;
+		else
+			lmac_list =
+				cgx_read(cgx, 0, CGXX_CMRX_RX_LMACS) & 0xFULL;
+	}
 
 	if (cgx->lmac_count > cgx->max_lmac_per_mac)
 		cgx->lmac_count = cgx->max_lmac_per_mac;
@@ -1624,7 +1632,9 @@ static int cgx_lmac_init(struct cgx *cgx)
 
 		lmac->cgx = cgx;
 		lmac->mac_to_index_bmap.max =
-				MAX_DMAC_ENTRIES_PER_CGX / cgx->lmac_count;
+				cgx->mac_ops->dmac_filter_count /
+				cgx->lmac_count;
+
 		err = rvu_alloc_bitmap(&lmac->mac_to_index_bmap);
 		if (err)
 			goto err_name_free;
@@ -1711,6 +1721,15 @@ static void cgx_populate_features(struct cgx *cgx)
 				    RVU_LMAC_FEAT_PTP | RVU_LMAC_FEAT_DMACF);
 }
 
+static u8 cgx_get_rxid_mapoffset(struct cgx *cgx)
+{
+	if (cgx->pdev->subsystem_device == PCI_SUBSYS_DEVID_CNF10KB_RPM ||
+	    is_dev_rpm2(cgx))
+		return 0x80;
+	else
+		return 0x60;
+}
+
 static struct mac_ops	cgx_mac_ops    = {
 	.name		=       "cgx",
 	.csr_offset	=       0,
@@ -1723,6 +1742,7 @@ static struct mac_ops	cgx_mac_ops    = {
 	.non_contiguous_serdes_lane = false,
 	.rx_stats_cnt   =       9,
 	.tx_stats_cnt   =       18,
+	.dmac_filter_count =    32,
 	.get_nr_lmacs	=	cgx_get_nr_lmacs,
 	.get_lmac_type  =       cgx_get_lmac_type,
 	.lmac_fifo_len	=	cgx_get_lmac_fifo_len,
@@ -1754,11 +1774,13 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, cgx);
 
 	/* Use mac_ops to get MAC specific features */
-	if (pdev->device == PCI_DEVID_CN10K_RPM)
-		cgx->mac_ops = rpm_get_mac_ops();
+	if (is_dev_rpm(cgx))
+		cgx->mac_ops = rpm_get_mac_ops(cgx);
 	else
 		cgx->mac_ops = &cgx_mac_ops;
 
+	cgx->mac_ops->rxid_map_offset = cgx_get_rxid_mapoffset(cgx);
+
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(dev, "Failed to enable PCI device\n");
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index ce66c7271e3a..fb2d37676d84 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -19,7 +19,6 @@
 #define PCI_CFG_REG_BAR_NUM		0
 
 #define CGX_ID_MASK			0xF
-#define MAX_DMAC_ENTRIES_PER_CGX	32
 
 /* Registers */
 #define CGXX_CMRX_CFG			0x00
@@ -53,7 +52,7 @@
 #define CGXX_SCRATCH0_REG		0x1050
 #define CGXX_SCRATCH1_REG		0x1058
 #define CGX_CONST			0x2000
-#define CGX_CONST_RXFIFO_SIZE	        GENMASK_ULL(23, 0)
+#define CGX_CONST_RXFIFO_SIZE	        GENMASK_ULL(55, 32)
 #define CGX_CONST_MAX_LMACS	        GENMASK_ULL(31, 24)
 #define CGXX_SPUX_CONTROL1		0x10000
 #define CGXX_SPUX_LNX_FEC_CORR_BLOCKS	0x10700
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 697cfec74aa1..386fb73ad366 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -75,6 +75,11 @@ struct mac_ops {
 	/* RPM & CGX differs in number of Receive/transmit stats */
 	u8			rx_stats_cnt;
 	u8			tx_stats_cnt;
+	/* Unlike CN10K which shares same CSR offset with CGX
+	 * CNF10KB has different csr offset
+	 */
+	u64			rxid_map_offset;
+	u8			dmac_filter_count;
 	/* Incase of RPM get number of lmacs from RPMX_CMR_RX_LMACS[LMAC_EXIST]
 	 * number of setbits in lmac_exist tells number of lmacs
 	 */
@@ -153,6 +158,6 @@ struct lmac *lmac_pdata(u8 lmac_id, struct cgx *cgx);
 int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac);
 int cgx_fwi_cmd_generic(u64 req, u64 *resp, struct cgx *cgx, int lmac_id);
 bool is_lmac_valid(struct cgx *cgx, int lmac_id);
-struct mac_ops *rpm_get_mac_ops(void);
+struct mac_ops *rpm_get_mac_ops(struct cgx *cgx);
 
 #endif /* LMAC_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index a70e1153fa04..a15a59d5dff8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -8,7 +8,7 @@
 #include "cgx.h"
 #include "lmac_common.h"
 
-static struct mac_ops	rpm_mac_ops   = {
+static struct mac_ops		rpm_mac_ops   = {
 	.name		=       "rpm",
 	.csr_offset     =       0x4e00,
 	.lmac_offset    =       20,
@@ -20,6 +20,7 @@ static struct mac_ops	rpm_mac_ops   = {
 	.non_contiguous_serdes_lane = true,
 	.rx_stats_cnt   =       43,
 	.tx_stats_cnt   =       34,
+	.dmac_filter_count =	32,
 	.get_nr_lmacs	=	rpm_get_nr_lmacs,
 	.get_lmac_type  =       rpm_get_lmac_type,
 	.lmac_fifo_len	=	rpm_get_lmac_fifo_len,
@@ -37,9 +38,49 @@ static struct mac_ops	rpm_mac_ops   = {
 	.mac_get_pfc_frm_cfg   =        rpm_lmac_get_pfc_frm_cfg,
 };
 
-struct mac_ops *rpm_get_mac_ops(void)
+static struct mac_ops		rpm2_mac_ops   = {
+	.name		=       "rpm",
+	.csr_offset     =       RPM2_CSR_OFFSET,
+	.lmac_offset    =       20,
+	.int_register	=       RPM2_CMRX_SW_INT,
+	.int_set_reg    =       RPM2_CMRX_SW_INT_ENA_W1S,
+	.irq_offset     =       1,
+	.int_ena_bit    =       BIT_ULL(0),
+	.lmac_fwi	=	RPM_LMAC_FWI,
+	.non_contiguous_serdes_lane = true,
+	.rx_stats_cnt   =       43,
+	.tx_stats_cnt   =       34,
+	.dmac_filter_count =	64,
+	.get_nr_lmacs	=	rpm2_get_nr_lmacs,
+	.get_lmac_type  =       rpm_get_lmac_type,
+	.lmac_fifo_len	=	rpm2_get_lmac_fifo_len,
+	.mac_lmac_intl_lbk =    rpm_lmac_internal_loopback,
+	.mac_get_rx_stats  =	rpm_get_rx_stats,
+	.mac_get_tx_stats  =	rpm_get_tx_stats,
+	.mac_enadis_rx_pause_fwding =	rpm_lmac_enadis_rx_pause_fwding,
+	.mac_get_pause_frm_status =	rpm_lmac_get_pause_frm_status,
+	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
+	.mac_pause_frm_config =		rpm_lmac_pause_frm_config,
+	.mac_enadis_ptp_config =	rpm_lmac_ptp_config,
+	.mac_rx_tx_enable =		rpm_lmac_rx_tx_enable,
+	.mac_tx_enable =		rpm_lmac_tx_enable,
+	.pfc_config =                   rpm_lmac_pfc_config,
+	.mac_get_pfc_frm_cfg   =        rpm_lmac_get_pfc_frm_cfg,
+};
+
+bool is_dev_rpm2(void *rpmd)
+{
+	rpm_t *rpm = rpmd;
+
+	return (rpm->pdev->device == PCI_DEVID_CN10KB_RPM);
+}
+
+struct mac_ops *rpm_get_mac_ops(rpm_t *rpm)
 {
-	return &rpm_mac_ops;
+	if (is_dev_rpm2(rpm))
+		return &rpm2_mac_ops;
+	else
+		return &rpm_mac_ops;
 }
 
 static void rpm_write(rpm_t *rpm, u64 lmac, u64 offset, u64 val)
@@ -52,6 +93,16 @@ static u64 rpm_read(rpm_t *rpm, u64 lmac, u64 offset)
 	return	cgx_read(rpm, lmac, offset);
 }
 
+/* Read HW major version to determine RPM
+ * MAC type 100/USX
+ */
+static bool is_mac_rpmusx(void *rpmd)
+{
+	rpm_t *rpm = rpmd;
+
+	return rpm_read(rpm, 0, RPMX_CONST1) & 0x700ULL;
+}
+
 int rpm_get_nr_lmacs(void *rpmd)
 {
 	rpm_t *rpm = rpmd;
@@ -59,6 +110,13 @@ int rpm_get_nr_lmacs(void *rpmd)
 	return hweight8(rpm_read(rpm, 0, CGXX_CMRX_RX_LMACS) & 0xFULL);
 }
 
+int rpm2_get_nr_lmacs(void *rpmd)
+{
+	rpm_t *rpm = rpmd;
+
+	return hweight8(rpm_read(rpm, 0, RPM2_CMRX_RX_LMACS) & 0xFFULL);
+}
+
 int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable)
 {
 	rpm_t *rpm = rpmd;
@@ -222,6 +280,46 @@ static void rpm_cfg_pfc_quanta_thresh(rpm_t *rpm, int lmac_id,
 	}
 }
 
+static void rpm2_lmac_cfg_bp(rpm_t *rpm, int lmac_id, u8 tx_pause, u8 rx_pause)
+{
+	u64 cfg;
+
+	cfg = rpm_read(rpm, lmac_id, RPM2_CMR_RX_OVR_BP);
+	if (tx_pause) {
+		/* Configure CL0 Pause Quanta & threshold
+		 * for 802.3X frames
+		 */
+		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 1, true);
+		cfg &= ~RPM2_CMR_RX_OVR_BP_EN;
+	} else {
+		/* Disable all Pause Quanta & threshold values */
+		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 0xffff, false);
+		cfg |= RPM2_CMR_RX_OVR_BP_EN;
+		cfg &= ~RPM2_CMR_RX_OVR_BP_BP;
+	}
+	rpm_write(rpm, lmac_id, RPM2_CMR_RX_OVR_BP, cfg);
+}
+
+static void rpm_lmac_cfg_bp(rpm_t *rpm, int lmac_id, u8 tx_pause, u8 rx_pause)
+{
+	u64 cfg;
+
+	cfg = rpm_read(rpm, 0, RPMX_CMR_RX_OVR_BP);
+	if (tx_pause) {
+		/* Configure CL0 Pause Quanta & threshold for
+		 * 802.3X frames
+		 */
+		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 1, true);
+		cfg &= ~RPMX_CMR_RX_OVR_BP_EN(lmac_id);
+	} else {
+		/* Disable all Pause Quanta & threshold values */
+		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 0xffff, false);
+		cfg |= RPMX_CMR_RX_OVR_BP_EN(lmac_id);
+		cfg &= ~RPMX_CMR_RX_OVR_BP_BP(lmac_id);
+	}
+	rpm_write(rpm, 0, RPMX_CMR_RX_OVR_BP, cfg);
+}
+
 int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 			      u8 rx_pause)
 {
@@ -243,18 +341,11 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 	cfg |= tx_pause ? 0x0 : RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
 	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 
-	cfg = rpm_read(rpm, 0, RPMX_CMR_RX_OVR_BP);
-	if (tx_pause) {
-		/* Configure CL0 Pause Quanta & threshold for 802.3X frames */
-		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 1, true);
-		cfg &= ~RPMX_CMR_RX_OVR_BP_EN(lmac_id);
-	} else {
-		/* Disable all Pause Quanta & threshold values */
-		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 0xffff, false);
-		cfg |= RPMX_CMR_RX_OVR_BP_EN(lmac_id);
-		cfg &= ~RPMX_CMR_RX_OVR_BP_BP(lmac_id);
-	}
-	rpm_write(rpm, 0, RPMX_CMR_RX_OVR_BP, cfg);
+	if (is_dev_rpm2(rpm))
+		rpm2_lmac_cfg_bp(rpm, lmac_id, tx_pause, rx_pause);
+	else
+		rpm_lmac_cfg_bp(rpm, lmac_id, tx_pause, rx_pause);
+
 	return 0;
 }
 
@@ -278,13 +369,16 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
 	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 
+	/* Enable channel mask for all LMACS */
+	if (is_dev_rpm2(rpm))
+		rpm_write(rpm, lmac_id, RPM2_CMR_CHAN_MSK_OR, 0xffff);
+	else
+		rpm_write(rpm, 0, RPMX_CMR_CHAN_MSK_OR, ~0ULL);
+
 	/* Disable all PFC classes */
 	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL);
 	cfg = FIELD_SET(RPM_PFC_CLASS_MASK, 0, cfg);
 	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, cfg);
-
-	/* Enable channel mask for all LMACS */
-	rpm_write(rpm, 0, RPMX_CMR_CHAN_MSK_OR, ~0ULL);
 }
 
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat)
@@ -292,7 +386,7 @@ int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat)
 	rpm_t *rpm = rpmd;
 	u64 val_lo, val_hi;
 
-	if (!rpm || lmac_id >= rpm->lmac_count)
+	if (!is_lmac_valid(rpm, lmac_id))
 		return -ENODEV;
 
 	mutex_lock(&rpm->lock);
@@ -320,7 +414,7 @@ int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat)
 	rpm_t *rpm = rpmd;
 	u64 val_lo, val_hi;
 
-	if (!rpm || lmac_id >= rpm->lmac_count)
+	if (!is_lmac_valid(rpm, lmac_id))
 		return -ENODEV;
 
 	mutex_lock(&rpm->lock);
@@ -380,13 +474,71 @@ u32 rpm_get_lmac_fifo_len(void *rpmd, int lmac_id)
 	return 0;
 }
 
+static int rpmusx_lmac_internal_loopback(rpm_t *rpm, int lmac_id, bool enable)
+{
+	u64 cfg;
+
+	cfg = rpm_read(rpm, lmac_id, RPM2_USX_PCSX_CONTROL1);
+
+	if (enable)
+		cfg |= RPM2_USX_PCS_LBK;
+	else
+		cfg &= ~RPM2_USX_PCS_LBK;
+	rpm_write(rpm, lmac_id, RPM2_USX_PCSX_CONTROL1, cfg);
+
+	return 0;
+}
+
+u32 rpm2_get_lmac_fifo_len(void *rpmd, int lmac_id)
+{
+	u64 hi_perf_lmac, lmac_info;
+	rpm_t *rpm = rpmd;
+	u8 num_lmacs;
+	u32 fifo_len;
+
+	lmac_info = rpm_read(rpm, 0, RPM2_CMRX_RX_LMACS);
+	/* LMACs are divided into two groups and each group
+	 * gets half of the FIFO
+	 * Group0 lmac_id range {0..3}
+	 * Group1 lmac_id range {4..7}
+	 */
+	fifo_len = rpm->mac_ops->fifo_len / 2;
+
+	if (lmac_id < 4) {
+		num_lmacs = hweight8(lmac_info & 0xF);
+		hi_perf_lmac = (lmac_info >> 8) & 0x3ULL;
+	} else {
+		num_lmacs = hweight8(lmac_info & 0xF0);
+		hi_perf_lmac = (lmac_info >> 10) & 0x3ULL;
+		hi_perf_lmac += 4;
+	}
+
+	switch (num_lmacs) {
+	case 1:
+		return fifo_len;
+	case 2:
+		return fifo_len / 2;
+	case 3:
+		/* LMAC marked as hi_perf gets half of the FIFO
+		 * and rest 1/4th
+		 */
+		if (lmac_id == hi_perf_lmac)
+			return fifo_len / 2;
+		return fifo_len / 4;
+	case 4:
+	default:
+		return fifo_len / 4;
+	}
+	return 0;
+}
+
 int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
 {
 	rpm_t *rpm = rpmd;
 	u8 lmac_type;
 	u64 cfg;
 
-	if (!rpm || lmac_id >= rpm->lmac_count)
+	if (!is_lmac_valid(rpm, lmac_id))
 		return -ENODEV;
 	lmac_type = rpm->mac_ops->get_lmac_type(rpm, lmac_id);
 
@@ -395,6 +547,9 @@ int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable)
 		return 0;
 	}
 
+	if (is_dev_rpm2(rpm) && is_mac_rpmusx(rpm))
+		return rpmusx_lmac_internal_loopback(rpm, lmac_id, enable);
+
 	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_PCS100X_CONTROL1);
 
 	if (enable)
@@ -439,8 +594,8 @@ void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable)
 
 int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 pfc_en)
 {
+	u64 cfg, class_en, pfc_class_mask_cfg;
 	rpm_t *rpm = rpmd;
-	u64 cfg, class_en;
 
 	if (!is_lmac_valid(rpm, lmac_id))
 		return -ENODEV;
@@ -476,7 +631,10 @@ int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 p
 
 	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 
-	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, class_en);
+	pfc_class_mask_cfg = is_dev_rpm2(rpm) ? RPM2_CMRX_PRT_CBFC_CTL :
+						RPMX_CMRX_PRT_CBFC_CTL;
+
+	rpm_write(rpm, lmac_id, pfc_class_mask_cfg, class_en);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 77f2ef9e1425..fc20a35bd8f9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -12,11 +12,14 @@
 
 /* PCI device IDs */
 #define PCI_DEVID_CN10K_RPM		0xA060
+#define PCI_SUBSYS_DEVID_CNF10KB_RPM	0xBC00
+#define PCI_DEVID_CN10KB_RPM		0xA09F
 
 /* Registers */
 #define RPMX_CMRX_CFG			0x00
 #define RPMX_RX_TS_PREPEND              BIT_ULL(22)
 #define RPMX_TX_PTP_1S_SUPPORT          BIT_ULL(17)
+#define RPMX_CMRX_RX_ID_MAP		0x80
 #define RPMX_CMRX_SW_INT                0x180
 #define RPMX_CMRX_SW_INT_W1S            0x188
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
@@ -76,11 +79,28 @@
 #define RPMX_MTI_MAC100X_XIF_MODE		        0x8100
 #define RPMX_ONESTEP_ENABLE				BIT_ULL(5)
 #define RPMX_TS_BINARY_MODE				BIT_ULL(11)
+#define RPMX_CONST1					0x2008
+
+/* CN10KB CSR Declaration */
+#define  RPM2_CMRX_SW_INT				0x1b0
+#define  RPM2_CMRX_SW_INT_ENA_W1S			0x1b8
+#define  RPM2_CMR_CHAN_MSK_OR				0x3120
+#define  RPM2_CMR_RX_OVR_BP_EN				BIT_ULL(2)
+#define  RPM2_CMR_RX_OVR_BP_BP				BIT_ULL(1)
+#define  RPM2_CMR_RX_OVR_BP				0x3130
+#define  RPM2_CSR_OFFSET				0x3e00
+#define  RPM2_CMRX_PRT_CBFC_CTL				0x6510
+#define  RPM2_CMRX_RX_LMACS				0x100
+#define  RPM2_CMRX_RX_LOGL_XON				0x3100
+#define  RPM2_CMRX_RX_STAT2				0x3010
+#define  RPM2_USX_PCSX_CONTROL1				0x80000
+#define  RPM2_USX_PCS_LBK				BIT_ULL(14)
 
 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
 u8 rpm_get_lmac_type(void *rpmd, int lmac_id);
 u32 rpm_get_lmac_fifo_len(void *rpmd, int lmac_id);
+u32 rpm2_get_lmac_fifo_len(void *rpmd, int lmac_id);
 int rpm_lmac_internal_loopback(void *rpmd, int lmac_id, bool enable);
 void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_get_pause_frm_status(void *cgxd, int lmac_id, u8 *tx_pause,
@@ -97,4 +117,6 @@ int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause,
 			u16 pfc_en);
 int rpm_lmac_get_pfc_frm_cfg(void *rpmd, int lmac_id, u8 *tx_pause,
 			     u8 *rx_pause);
+int rpm2_get_nr_lmacs(void *rpmd);
+bool is_dev_rpm2(void *rpmd);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 04333f127282..7f0a64731c67 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -410,9 +410,15 @@ struct rvu_fwdata {
 	u32 ptp_ext_tstamp;
 #define FWDATA_RESERVED_MEM 1022
 	u64 reserved[FWDATA_RESERVED_MEM];
-#define CGX_MAX         5
+#define CGX_MAX         9
 #define CGX_LMACS_MAX   4
-	struct cgx_lmac_fwdata_s cgx_fw_data[CGX_MAX][CGX_LMACS_MAX];
+#define CGX_LMACS_USX   8
+	union {
+		struct cgx_lmac_fwdata_s
+			cgx_fw_data[CGX_MAX][CGX_LMACS_MAX];
+		struct cgx_lmac_fwdata_s
+			cgx_fw_data_usx[CGX_MAX][CGX_LMACS_USX];
+	};
 	/* Do not add new fields below this line */
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 8d9f9bbc262b..53580e0381c9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -472,6 +472,7 @@ void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc)
 {
 	int pf = rvu_get_pf(pcifunc);
 	int i = 0, lmac_count = 0;
+	struct mac_ops *mac_ops;
 	u8 max_dmac_filters;
 	u8 cgx_id, lmac_id;
 	void *cgx_dev;
@@ -487,7 +488,12 @@ void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc)
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	cgx_dev = cgx_get_pdata(cgx_id);
 	lmac_count = cgx_get_lmac_cnt(cgx_dev);
-	max_dmac_filters = MAX_DMAC_ENTRIES_PER_CGX / lmac_count;
+
+	mac_ops = get_mac_ops(cgx_dev);
+	if (!mac_ops)
+		return;
+
+	max_dmac_filters = mac_ops->dmac_filter_count / lmac_count;
 
 	for (i = 0; i < max_dmac_filters; i++)
 		cgx_lmac_addr_del(cgx_id, lmac_id, i);
@@ -1114,8 +1120,15 @@ int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
-	memcpy(&rsp->fwdata, &rvu->fwdata->cgx_fw_data[cgx_id][lmac_id],
-	       sizeof(struct cgx_lmac_fwdata_s));
+	if (rvu->hw->lmac_per_cgx == CGX_LMACS_USX)
+		memcpy(&rsp->fwdata,
+		       &rvu->fwdata->cgx_fw_data_usx[cgx_id][lmac_id],
+		       sizeof(struct cgx_lmac_fwdata_s));
+	else
+		memcpy(&rsp->fwdata,
+		       &rvu->fwdata->cgx_fw_data[cgx_id][lmac_id],
+		       sizeof(struct cgx_lmac_fwdata_s));
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index de489e7366da..6b8747ebc08c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3197,8 +3197,12 @@ static void rvu_get_lbk_link_max_frs(struct rvu *rvu,  u16 *max_mtu)
 
 static void rvu_get_lmac_link_max_frs(struct rvu *rvu, u16 *max_mtu)
 {
-	/* RPM supports FIFO len 128 KB */
-	if (rvu_cgx_get_fifolen(rvu) == 0x20000)
+	int fifo_size = rvu_cgx_get_fifolen(rvu);
+
+	/* RPM supports FIFO len 128 KB and RPM2 supports double the
+	 * FIFO len to accommodate 8 LMACS
+	 */
+	if (fifo_size == 0x20000 || fifo_size == 0x40000)
 		*max_mtu = CN10K_LMAC_LINK_MAX_FRS;
 	else
 		*max_mtu = NIC_HW_MAX_FRS;
-- 
2.17.1

