Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB1515DA32
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgBNPDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:42 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23558 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729577AbgBNPDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF17wY013967;
        Fri, 14 Feb 2020 07:03:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=G3RJ/Hz+byIuc5boKI7UkVkvuRBC/IUcNemucHyQbFE=;
 b=OYByrszi8HW44wtItaRuZ7savE2eMUpUALVnbXbUEERe+S8YhL0PnwEc3Jbx+QGVBeQc
 xEdl9pGKqj9izB5CluJ0ElO7mzO7n4JQXwHouXwmdJVjegqAirT0nv/K4etGGnk5oAok
 QcV6xUU9+SR/LaFyscZuFq/9bkHB5CCQGBle90HwfNnoKwKgweLHzyF39ZMA9p3WJdJF
 qMVz6oJ+vn4oxpVloE+uex6StY1ouexEWsUxw9G3O5hdufgALfAi2xFoJG7UzBCWszn/
 QkHMf0nRsjLAEIjF5pC5fGxwNkqJ45ZxlQ/d8q716MzOHKq7Bhe7XPUPiB+EN480kKWz iA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5k3gtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:36 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:35 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:34 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:33 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 735523F7040;
        Fri, 14 Feb 2020 07:03:32 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 12/18] net: atlantic: MACSec offload skeleton
Date:   Fri, 14 Feb 2020 18:02:52 +0300
Message-ID: <20200214150258.390-13-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds basic functionality for MACSec offloading for Atlantic
NICs.

MACSec offloading functionality is enabled if network card has
appropriate FW that has MACSec offloading enabled in config.

Actual functionality (ingress, egress, etc) will be added in follow-up
patches.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |   3 +
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   6 +
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 181 ++++++++++++++++++
 .../ethernet/aquantia/atlantic/aq_macsec.h    |  56 ++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  16 ++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   4 +
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |   5 +
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  51 ++++-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  69 +++++++
 9 files changed, 383 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/ethernet/aquantia/atlantic/Makefile
index 6e0a6e234483..ca2bf1f069d5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -8,6 +8,8 @@
 
 obj-$(CONFIG_AQTION) += atlantic.o
 
+ccflags-y += -I$(src)
+
 atlantic-objs := aq_main.o \
 	aq_nic.o \
 	aq_pci_func.o \
@@ -18,6 +20,7 @@ atlantic-objs := aq_main.o \
 	aq_drvinfo.o \
 	aq_filters.o \
 	aq_phy.o \
+	aq_macsec.o \
 	hw_atl/hw_atl_a0.o \
 	hw_atl/hw_atl_b0.o \
 	hw_atl/hw_atl_utils.o \
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index cc70c606b6ef..e854ffea41f9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -341,6 +341,12 @@ struct aq_fw_ops {
 
 	int (*get_eee_rate)(struct aq_hw_s *self, u32 *rate,
 			    u32 *supported_rates);
+
+	u32 (*get_link_capabilities)(struct aq_hw_s *self);
+
+	int (*send_macsec_req)(struct aq_hw_s *self,
+			       struct macsec_msg_fw_request *msg,
+			       struct macsec_msg_fw_response *resp);
 };
 
 #endif /* AQ_HW_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
new file mode 100644
index 000000000000..5b074449d70a
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "aq_macsec.h"
+#if IS_ENABLED(CONFIG_MACSEC)
+#include "aq_nic.h"
+#include <linux/rtnetlink.h>
+
+static int aq_mdo_dev_open(struct macsec_context *ctx)
+{
+	return 0;
+}
+
+static int aq_mdo_dev_stop(struct macsec_context *ctx)
+{
+	return 0;
+}
+
+static int aq_mdo_add_secy(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_upd_secy(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_del_secy(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_add_txsa(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_upd_txsa(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_del_txsa(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_add_rxsc(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_upd_rxsc(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_del_rxsc(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_add_rxsa(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_upd_rxsa(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int aq_mdo_del_rxsa(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static void aq_check_txsa_expiration(struct aq_nic_s *nic)
+{
+}
+
+const struct macsec_ops aq_macsec_ops = {
+	.mdo_dev_open = aq_mdo_dev_open,
+	.mdo_dev_stop = aq_mdo_dev_stop,
+	.mdo_add_secy = aq_mdo_add_secy,
+	.mdo_upd_secy = aq_mdo_upd_secy,
+	.mdo_del_secy = aq_mdo_del_secy,
+	.mdo_add_rxsc = aq_mdo_add_rxsc,
+	.mdo_upd_rxsc = aq_mdo_upd_rxsc,
+	.mdo_del_rxsc = aq_mdo_del_rxsc,
+	.mdo_add_rxsa = aq_mdo_add_rxsa,
+	.mdo_upd_rxsa = aq_mdo_upd_rxsa,
+	.mdo_del_rxsa = aq_mdo_del_rxsa,
+	.mdo_add_txsa = aq_mdo_add_txsa,
+	.mdo_upd_txsa = aq_mdo_upd_txsa,
+	.mdo_del_txsa = aq_mdo_del_txsa,
+};
+
+int aq_macsec_init(struct aq_nic_s *nic)
+{
+	struct aq_macsec_cfg *cfg;
+	u32 caps_lo;
+
+	if (!nic->aq_fw_ops->get_link_capabilities)
+		return 0;
+
+	caps_lo = nic->aq_fw_ops->get_link_capabilities(nic->aq_hw);
+
+	if (!(caps_lo & BIT(CAPS_LO_MACSEC)))
+		return 0;
+
+	nic->macsec_cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!nic->macsec_cfg)
+		return -ENOMEM;
+
+	nic->ndev->features |= NETIF_F_HW_MACSEC;
+	nic->ndev->macsec_ops = &aq_macsec_ops;
+
+	return 0;
+}
+
+void aq_macsec_free(struct aq_nic_s *nic)
+{
+	kfree(nic->macsec_cfg);
+	nic->macsec_cfg = NULL;
+}
+
+int aq_macsec_enable(struct aq_nic_s *nic)
+{
+	struct macsec_msg_fw_response resp = { 0 };
+	struct macsec_msg_fw_request msg = { 0 };
+	struct aq_hw_s *hw = nic->aq_hw;
+	int ret = 0;
+
+	if (!nic->macsec_cfg)
+		return 0;
+
+	rtnl_lock();
+
+	if (nic->aq_fw_ops->send_macsec_req) {
+		struct macsec_cfg_request cfg = { 0 };
+
+		cfg.enabled = 1;
+		cfg.egress_threshold = 0xffffffff;
+		cfg.ingress_threshold = 0xffffffff;
+		cfg.interrupts_enabled = 1;
+
+		msg.msg_type = macsec_cfg_msg;
+		msg.cfg = cfg;
+
+		ret = nic->aq_fw_ops->send_macsec_req(hw, &msg, &resp);
+		if (ret)
+			goto unlock;
+	}
+
+unlock:
+	rtnl_unlock();
+	return ret;
+}
+
+void aq_macsec_work(struct aq_nic_s *nic)
+{
+	if (!nic->macsec_cfg)
+		return;
+
+	if (!netif_carrier_ok(nic->ndev))
+		return;
+
+	rtnl_lock();
+	aq_check_txsa_expiration(nic);
+	rtnl_unlock();
+}
+#endif
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
new file mode 100644
index 000000000000..ba0cdbed288c
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef AQ_MACSEC_H
+#define AQ_MACSEC_H
+
+#include <linux/netdevice.h>
+#if IS_ENABLED(CONFIG_MACSEC)
+
+#include "net/macsec.h"
+
+struct aq_nic_s;
+
+#define AQ_MACSEC_MAX_SC 32
+#define AQ_MACSEC_MAX_SA 32
+
+enum aq_macsec_sc_sa {
+	aq_macsec_sa_sc_4sa_8sc,
+	aq_macsec_sa_sc_not_used,
+	aq_macsec_sa_sc_2sa_16sc,
+	aq_macsec_sa_sc_1sa_32sc,
+};
+
+struct aq_macsec_txsc {
+};
+
+struct aq_macsec_rxsc {
+};
+
+struct aq_macsec_cfg {
+	enum aq_macsec_sc_sa sc_sa;
+	/* Egress channel configuration */
+	unsigned long txsc_idx_busy;
+	struct aq_macsec_txsc aq_txsc[AQ_MACSEC_MAX_SC];
+	/* Ingress channel configuration */
+	unsigned long rxsc_idx_busy;
+	struct aq_macsec_rxsc aq_rxsc[AQ_MACSEC_MAX_SC];
+};
+
+extern const struct macsec_ops aq_macsec_ops;
+
+int aq_macsec_init(struct aq_nic_s *nic);
+void aq_macsec_free(struct aq_nic_s *nic);
+int aq_macsec_enable(struct aq_nic_s *nic);
+void aq_macsec_work(struct aq_nic_s *nic);
+
+#endif
+
+#endif /* AQ_MACSEC_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index c85e3e29012c..c2c221fe9534 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -11,6 +11,7 @@
 #include "aq_vec.h"
 #include "aq_hw.h"
 #include "aq_pci_func.h"
+#include "aq_macsec.h"
 #include "aq_main.h"
 #include "aq_phy.h"
 #include "aq_ptp.h"
@@ -176,6 +177,9 @@ static int aq_nic_update_link_status(struct aq_nic_s *self)
 		aq_utils_obj_clear(&self->flags,
 				   AQ_NIC_LINK_DOWN);
 		netif_carrier_on(self->ndev);
+#if IS_ENABLED(CONFIG_MACSEC)
+		aq_macsec_enable(self);
+#endif
 		netif_tx_wake_all_queues(self->ndev);
 	}
 	if (netif_carrier_ok(self->ndev) && !self->link_status.mbps) {
@@ -217,6 +221,10 @@ static void aq_nic_service_task(struct work_struct *work)
 	if (err)
 		return;
 
+#if IS_ENABLED(CONFIG_MACSEC)
+	aq_macsec_work(self);
+#endif
+
 	mutex_lock(&self->fwreq_mutex);
 	if (self->aq_fw_ops->update_stats)
 		self->aq_fw_ops->update_stats(self->aq_hw);
@@ -262,6 +270,10 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 	if (err)
 		goto err_exit;
 
+#if IS_ENABLED(CONFIG_MACSEC)
+	aq_macsec_init(self);
+#endif
+
 	mutex_lock(&self->fwreq_mutex);
 	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw,
 			    self->ndev->dev_addr);
@@ -296,6 +308,10 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 		goto err_exit;
 
 err_exit:
+#if IS_ENABLED(CONFIG_MACSEC)
+	if (err)
+		aq_macsec_free(self);
+#endif
 	return err;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index a752f8bb4b08..011db4094c93 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -17,6 +17,7 @@ struct aq_ring_s;
 struct aq_hw_ops;
 struct aq_fw_s;
 struct aq_vec_s;
+struct aq_macsec_cfg;
 struct aq_ptp_s;
 enum aq_rx_filter_type;
 
@@ -129,6 +130,9 @@ struct aq_nic_s {
 	u32 irqvecs;
 	/* mutex to serialize FW interface access operations */
 	struct mutex fwreq_mutex;
+#if IS_ENABLED(CONFIG_MACSEC)
+	struct aq_macsec_cfg *macsec_cfg;
+#endif
 	/* PTP support */
 	struct aq_ptp_s *aq_ptp;
 	struct aq_hw_rx_fltrs_s aq_hw_rx_fltrs;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 6b27af0db499..93ff3dd02d99 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -18,6 +18,7 @@
 #include "hw_atl/hw_atl_b0.h"
 #include "aq_filters.h"
 #include "aq_drvinfo.h"
+#include "aq_macsec.h"
 
 static const struct pci_device_id aq_pci_tbl[] = {
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_0001), },
@@ -324,6 +325,10 @@ static void aq_pci_remove(struct pci_dev *pdev)
 		aq_clear_rxnfc_all_rules(self);
 		if (self->ndev->reg_state == NETREG_REGISTERED)
 			unregister_netdev(self->ndev);
+
+#if IS_ENABLED(CONFIG_MACSEC)
+		aq_macsec_free(self);
+#endif
 		aq_nic_free_vectors(self);
 		aq_pci_free_irq_vectors(self);
 		iounmap(self->aq_hw->mmio);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 42f0c5c6ec2d..0a88a2cdbc4d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -319,6 +319,32 @@ struct __packed hw_atl_utils_settings {
 	u32 media_detect;
 };
 
+enum macsec_msg_type {
+	macsec_cfg_msg = 0,
+	macsec_add_rx_sc_msg,
+	macsec_add_tx_sc_msg,
+	macsec_add_rx_sa_msg,
+	macsec_add_tx_sa_msg,
+	macsec_get_stats_msg,
+};
+
+struct __packed macsec_cfg_request {
+	u32 enabled;
+	u32 egress_threshold;
+	u32 ingress_threshold;
+	u32 interrupts_enabled;
+};
+
+struct __packed macsec_msg_fw_request {
+	u32 msg_id; /* not used */
+	u32 msg_type;
+	struct macsec_cfg_request cfg;
+};
+
+struct __packed macsec_msg_fw_response {
+	u32 result;
+};
+
 enum hw_atl_rx_action_with_traffic {
 	HW_ATL_RX_DISCARD,
 	HW_ATL_RX_HOST,
@@ -437,34 +463,43 @@ enum hw_atl_fw2x_caps_lo {
 	CAPS_LO_2P5GBASET_FD,
 	CAPS_LO_5GBASET_FD        = 10,
 	CAPS_LO_10GBASET_FD,
+	CAPS_LO_AUTONEG,
+	CAPS_LO_SMBUS_READ,
+	CAPS_LO_SMBUS_WRITE,
+	CAPS_LO_MACSEC            = 15,
+	CAPS_LO_RESERVED1,
+	CAPS_LO_WAKE_ON_LINK_FORCED,
+	CAPS_LO_HIGH_TEMP_WARNING = 29,
+	CAPS_LO_DRIVER_SCRATCHPAD = 30,
+	CAPS_LO_GLOBAL_FAULT      = 31
 };
 
 /* 0x374
  * Status register
  */
 enum hw_atl_fw2x_caps_hi {
-	CAPS_HI_RESERVED1         = 0,
+	CAPS_HI_TPO2EN            = 0,
 	CAPS_HI_10BASET_EEE,
 	CAPS_HI_RESERVED2,
 	CAPS_HI_PAUSE,
 	CAPS_HI_ASYMMETRIC_PAUSE,
 	CAPS_HI_100BASETX_EEE     = 5,
-	CAPS_HI_RESERVED3,
-	CAPS_HI_RESERVED4,
+	CAPS_HI_PHY_BUF_SEND,
+	CAPS_HI_PHY_BUF_RECV,
 	CAPS_HI_1000BASET_FD_EEE,
 	CAPS_HI_2P5GBASET_FD_EEE,
 	CAPS_HI_5GBASET_FD_EEE    = 10,
 	CAPS_HI_10GBASET_FD_EEE,
 	CAPS_HI_FW_REQUEST,
-	CAPS_HI_RESERVED6,
-	CAPS_HI_RESERVED7,
-	CAPS_HI_RESERVED8         = 15,
-	CAPS_HI_RESERVED9,
+	CAPS_HI_PHY_LOG,
+	CAPS_HI_EEE_AUTO_DISABLE_SETTINGS,
+	CAPS_HI_PFC               = 15,
+	CAPS_HI_WAKE_ON_LINK,
 	CAPS_HI_CABLE_DIAG,
 	CAPS_HI_TEMPERATURE,
 	CAPS_HI_DOWNSHIFT,
 	CAPS_HI_PTP_AVB_EN_FW2X   = 20,
-	CAPS_HI_MEDIA_DETECT,
+	CAPS_HI_THERMAL_SHUTDOWN,
 	CAPS_HI_LINK_DROP,
 	CAPS_HI_SLEEP_PROXY,
 	CAPS_HI_WOL,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 97ebf849695f..d38879ee76c2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -52,6 +52,8 @@
 #define HW_ATL_FW2X_CAP_EEE_5G_MASK      BIT(CAPS_HI_5GBASET_FD_EEE)
 #define HW_ATL_FW2X_CAP_EEE_10G_MASK     BIT(CAPS_HI_10GBASET_FD_EEE)
 
+#define HW_ATL_FW2X_CAP_MACSEC           BIT(CAPS_LO_MACSEC)
+
 #define HAL_ATLANTIC_WOL_FILTERS_COUNT   8
 #define HAL_ATLANTIC_UTILS_FW2X_MSG_WOL  0x0E
 
@@ -83,6 +85,7 @@ static int aq_fw2x_set_state(struct aq_hw_s *self,
 static u32 aq_fw2x_mbox_get(struct aq_hw_s *self);
 static u32 aq_fw2x_rpc_get(struct aq_hw_s *self);
 static int aq_fw2x_settings_get(struct aq_hw_s *self, u32 *addr);
+static u32 aq_fw2x_state_get(struct aq_hw_s *self);
 static u32 aq_fw2x_state2_get(struct aq_hw_s *self);
 
 static int aq_fw2x_init(struct aq_hw_s *self)
@@ -608,11 +611,75 @@ static int aq_fw2x_settings_get(struct aq_hw_s *self, u32 *addr)
 	return err;
 }
 
+static u32 aq_fw2x_state_get(struct aq_hw_s *self)
+{
+	return aq_hw_read_reg(self, HW_ATL_FW2X_MPI_STATE_ADDR);
+}
+
 static u32 aq_fw2x_state2_get(struct aq_hw_s *self)
 {
 	return aq_hw_read_reg(self, HW_ATL_FW2X_MPI_STATE2_ADDR);
 }
 
+static u32 aq_fw2x_get_link_capabilities(struct aq_hw_s *self)
+{
+	int err = 0;
+	u32 offset;
+	u32 val;
+
+	offset = self->mbox_addr +
+		 offsetof(struct hw_atl_utils_mbox, info.caps_lo);
+
+	err = hw_atl_utils_fw_downld_dwords(self, offset, &val, 1);
+
+	if (err)
+		return 0;
+
+	return val;
+}
+
+static int aq_fw2x_send_macsec_req(struct aq_hw_s *hw,
+				   struct macsec_msg_fw_request *req,
+				   struct macsec_msg_fw_response *response)
+{
+	u32 low_status, low_req = 0;
+	u32 dword_cnt;
+	u32 caps_lo;
+	u32 offset;
+	int err;
+
+	if (!req || !response)
+		return -EINVAL;
+
+	caps_lo = aq_fw2x_get_link_capabilities(hw);
+	if (!(caps_lo & BIT(CAPS_LO_MACSEC)))
+		return -EOPNOTSUPP;
+
+	/* Write macsec request to cfg memory */
+	dword_cnt = (sizeof(*req) + sizeof(u32) - 1) / sizeof(u32);
+	err = hw_atl_write_fwcfg_dwords(hw, (void *)req, dword_cnt);
+	if (err < 0)
+		return err;
+
+	/* Toggle 0x368.CAPS_LO_MACSEC bit */
+	low_req = aq_hw_read_reg(hw, HW_ATL_FW2X_MPI_CONTROL_ADDR);
+	low_req ^= HW_ATL_FW2X_CAP_MACSEC;
+	aq_hw_write_reg(hw, HW_ATL_FW2X_MPI_CONTROL_ADDR, low_req);
+
+	/* Wait FW to report back */
+	err = readx_poll_timeout_atomic(aq_fw2x_state_get, hw, low_status,
+		low_req != (low_status & BIT(CAPS_LO_MACSEC)), 1U, 10000U);
+	if (err)
+		return -EIO;
+
+	/* Read status of write operation */
+	offset = hw->rpc_addr + sizeof(u32);
+	err = hw_atl_utils_fw_downld_dwords(hw, offset, (u32 *)(void *)response,
+					    sizeof(*response) / sizeof(u32));
+
+	return err;
+}
+
 const struct aq_fw_ops aq_fw_2x_ops = {
 	.init               = aq_fw2x_init,
 	.deinit             = aq_fw2x_deinit,
@@ -633,4 +700,6 @@ const struct aq_fw_ops aq_fw_2x_ops = {
 	.enable_ptp         = aq_fw3x_enable_ptp,
 	.led_control        = aq_fw2x_led_control,
 	.set_phyloopback    = aq_fw2x_set_phyloopback,
+	.get_link_capabilities = aq_fw2x_get_link_capabilities,
+	.send_macsec_req    = aq_fw2x_send_macsec_req,
 };
-- 
2.17.1

