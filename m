Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62C754BC4B
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345254AbiFNU7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358510AbiFNU6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:58:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251534FC49
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 13:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655240323; x=1686776323;
  h=from:to:cc:subject:date:message-id;
  bh=6nIqpIYqO/l/4cCUGKdB1M0OQ4Ge4dXz+KlCN8KNgXM=;
  b=QFEuEqsZHHKdaP4JK5tuzPx8r/ARmn24n8fPd340dXT5n8PLjLG6G2db
   96to/4TURCXZLxkwUeb1p3GeNNvNP3ro3EJYOWHdQsqvTWnU1a6BhdJ2h
   N+zwpSCKK2pH0UU7UH6VFVx8hW48V3RemAvUBB2AcvqwpDETZItR7tw8i
   t66Ok3q1FvkwoBdZqIJt2BgaEl8ZGc/c9ziEP0JiTSdQ18DIHc8mq6Wpv
   nnqJfYppgZPzLDBnb6WBV7P5s7uroTwEtVgzMSYlyFolSENjT6BSiZKJM
   BCA4emAZMb8IISnm8bOVmyLA5QFarLUJqiOjFA9QXst7ug/1FRtjWd24j
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="258584107"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="258584107"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 13:58:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="588690805"
Received: from graphael-850g8.amr.corp.intel.com (HELO mveleta-desk1.hsd1.or.comcast.net) ([10.212.142.167])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 13:58:41 -0700
From:   Moises Veleta <moises.veleta@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
Subject: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
Date:   Tue, 14 Jun 2022 13:57:56 -0700
Message-Id: <20220614205756.6792-1-moises.veleta@linux.intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
communicate with AP and Modem processors respectively. So far only
MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
port which requires such channel.

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 17 +++--
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h     |  2 +-
 drivers/net/wwan/t7xx/t7xx_mhccif.h        |  1 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 85 ++++++++++++++++++----
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |  3 +
 drivers/net/wwan/t7xx/t7xx_port.h          | 10 ++-
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c |  8 +-
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 21 ++++++
 drivers/net/wwan/t7xx/t7xx_reg.h           |  2 +-
 drivers/net/wwan/t7xx/t7xx_state_monitor.c | 13 +++-
 drivers/net/wwan/t7xx/t7xx_state_monitor.h |  2 +
 11 files changed, 136 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 6ff30cb8eb16..37cd63d20b45 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -1064,13 +1064,18 @@ static void t7xx_hw_info_init(struct cldma_ctrl *md_ctrl)
 	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
 	u32 phy_ao_base, phy_pd_base;
 
-	if (md_ctrl->hif_id != CLDMA_ID_MD)
-		return;
-
-	phy_ao_base = CLDMA1_AO_BASE;
-	phy_pd_base = CLDMA1_PD_BASE;
-	hw_info->phy_interrupt_id = CLDMA1_INT;
 	hw_info->hw_mode = MODE_BIT_64;
+
+	if (md_ctrl->hif_id == CLDMA_ID_MD) {
+		phy_ao_base = CLDMA1_AO_BASE;
+		phy_pd_base = CLDMA1_PD_BASE;
+		hw_info->phy_interrupt_id = CLDMA1_INT;
+	} else {
+		phy_ao_base = CLDMA0_AO_BASE;
+		phy_pd_base = CLDMA0_PD_BASE;
+		hw_info->phy_interrupt_id = CLDMA0_INT;
+	}
+
 	hw_info->ap_ao_base = t7xx_pcie_addr_transfer(pbase->pcie_ext_reg_base,
 						      pbase->pcie_dev_reg_trsl_addr, phy_ao_base);
 	hw_info->ap_pdn_base = t7xx_pcie_addr_transfer(pbase->pcie_ext_reg_base,
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
index 47a35e552da7..4410bac6993a 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.h
@@ -34,7 +34,7 @@
 /**
  * enum cldma_id - Identifiers for CLDMA HW units.
  * @CLDMA_ID_MD: Modem control channel.
- * @CLDMA_ID_AP: Application Processor control channel (not used at the moment).
+ * @CLDMA_ID_AP: Application Processor control channel.
  * @CLDMA_NUM:   Number of CLDMA HW units available.
  */
 enum cldma_id {
diff --git a/drivers/net/wwan/t7xx/t7xx_mhccif.h b/drivers/net/wwan/t7xx/t7xx_mhccif.h
index 209b386bc088..20c50dce9fc3 100644
--- a/drivers/net/wwan/t7xx/t7xx_mhccif.h
+++ b/drivers/net/wwan/t7xx/t7xx_mhccif.h
@@ -25,6 +25,7 @@
 			 D2H_INT_EXCEPTION_CLEARQ_DONE |	\
 			 D2H_INT_EXCEPTION_ALLQ_RESET |		\
 			 D2H_INT_PORT_ENUM |			\
+			 D2H_INT_ASYNC_AP_HK |			\
 			 D2H_INT_ASYNC_MD_HK)
 
 void t7xx_mhccif_mask_set(struct t7xx_pci_dev *t7xx_dev, u32 val);
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index 3458af31e864..c5a3c95004bd 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -44,6 +44,7 @@
 #include "t7xx_state_monitor.h"
 
 #define RT_ID_MD_PORT_ENUM	0
+#define RT_ID_AP_PORT_ENUM	1
 /* Modem feature query identification code - "ICCC" */
 #define MD_FEATURE_QUERY_ID	0x49434343
 
@@ -296,6 +297,7 @@ static void t7xx_md_exception(struct t7xx_modem *md, enum hif_ex_stage stage)
 	}
 
 	t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_MD], stage);
+	t7xx_cldma_exception(md->md_ctrl[CLDMA_ID_AP], stage);
 
 	if (stage == HIF_EX_INIT)
 		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_EXCEPTION_ACK);
@@ -424,7 +426,7 @@ static int t7xx_parse_host_rt_data(struct t7xx_fsm_ctl *ctl, struct t7xx_sys_inf
 		if (ft_spt_st != MTK_FEATURE_MUST_BE_SUPPORTED)
 			return -EINVAL;
 
-		if (i == RT_ID_MD_PORT_ENUM)
+		if (i == RT_ID_MD_PORT_ENUM || i == RT_ID_AP_PORT_ENUM)
 			t7xx_port_enum_msg_handler(ctl->md, rt_feature->data);
 	}
 
@@ -454,12 +456,12 @@ static int t7xx_core_reset(struct t7xx_modem *md)
 	return 0;
 }
 
-static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_ctl *ctl,
+static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_sys_info *core_info,
+				 struct t7xx_fsm_ctl *ctl,
 				 enum t7xx_fsm_event_state event_id,
 				 enum t7xx_fsm_event_state err_detect)
 {
 	struct t7xx_fsm_event *event = NULL, *event_next;
-	struct t7xx_sys_info *core_info = &md->core_md;
 	struct device *dev = &md->t7xx_dev->pdev->dev;
 	unsigned long flags;
 	int ret;
@@ -529,19 +531,33 @@ static void t7xx_md_hk_wq(struct work_struct *work)
 	t7xx_cldma_start(md->md_ctrl[CLDMA_ID_MD]);
 	t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
 	md->core_md.handshake_ongoing = true;
-	t7xx_core_hk_handler(md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_EXIT);
+	t7xx_core_hk_handler(md, &md->core_md, ctl, FSM_EVENT_MD_HS2, FSM_EVENT_MD_HS2_EXIT);
+}
+
+static void t7xx_ap_hk_wq(struct work_struct *work)
+{
+	struct t7xx_modem *md = container_of(work, struct t7xx_modem, ap_handshake_work);
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+
+	 /* Clear the HS2 EXIT event appended in t7xx_core_reset(). */
+	t7xx_fsm_clr_event(ctl, FSM_EVENT_AP_HS2_EXIT);
+	t7xx_cldma_stop(md->md_ctrl[CLDMA_ID_AP]);
+	t7xx_cldma_switch_cfg(md->md_ctrl[CLDMA_ID_AP]);
+	t7xx_cldma_start(md->md_ctrl[CLDMA_ID_AP]);
+	md->core_ap.handshake_ongoing = true;
+	t7xx_core_hk_handler(md, &md->core_ap, ctl, FSM_EVENT_AP_HS2, FSM_EVENT_AP_HS2_EXIT);
 }
 
 void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
 {
 	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
-	void __iomem *mhccif_base;
 	unsigned int int_sta;
 	unsigned long flags;
 
 	switch (evt_id) {
 	case FSM_PRE_START:
-		t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM);
+		t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM | D2H_INT_ASYNC_MD_HK |
+						   D2H_INT_ASYNC_AP_HK);
 		break;
 
 	case FSM_START:
@@ -554,16 +570,26 @@ void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
 			ctl->exp_flg = true;
 			md->exp_id &= ~D2H_INT_EXCEPTION_INIT;
 			md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+			md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
 		} else if (ctl->exp_flg) {
 			md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
-		} else if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
-			queue_work(md->handshake_wq, &md->handshake_work);
-			md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
-			mhccif_base = md->t7xx_dev->base_addr.mhccif_rc_base;
-			iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
-			t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
+			md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
 		} else {
-			t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
+			void __iomem *mhccif_base = md->t7xx_dev->base_addr.mhccif_rc_base;
+
+			if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
+				queue_work(md->handshake_wq, &md->handshake_work);
+				md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+				iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
+				t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
+			}
+
+			if (md->exp_id & D2H_INT_ASYNC_AP_HK) {
+				queue_work(md->ap_handshake_wq, &md->ap_handshake_work);
+				md->exp_id &= ~D2H_INT_ASYNC_AP_HK;
+				iowrite32(D2H_INT_ASYNC_AP_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
+				t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_AP_HK);
+			}
 		}
 		spin_unlock_irqrestore(&md->exp_lock, flags);
 
@@ -576,6 +602,7 @@ void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
 
 	case FSM_READY:
 		t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
+		t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_AP_HK);
 		break;
 
 	default:
@@ -627,6 +654,19 @@ static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
 	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] &= ~FEATURE_MSK;
 	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] |=
 		FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
+
+	md->ap_handshake_wq = alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
+					      0, "ap_hk_wq");
+	if (!md->ap_handshake_wq) {
+		destroy_workqueue(md->handshake_wq);
+		return NULL;
+	}
+
+	INIT_WORK(&md->ap_handshake_work, t7xx_ap_hk_wq);
+	md->core_ap.feature_set[RT_ID_AP_PORT_ENUM] &= ~FEATURE_MSK;
+	md->core_ap.feature_set[RT_ID_AP_PORT_ENUM] |=
+		FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
+
 	return md;
 }
 
@@ -638,6 +678,7 @@ int t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
 	md->exp_id = 0;
 	t7xx_fsm_reset(md);
 	t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_MD]);
+	t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_AP]);
 	t7xx_port_proxy_reset(md->port_prox);
 	md->md_init_finish = true;
 	return t7xx_core_reset(md);
@@ -667,6 +708,10 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
 	if (ret)
 		goto err_destroy_hswq;
 
+	ret = t7xx_cldma_alloc(CLDMA_ID_AP, t7xx_dev);
+	if (ret)
+		goto err_destroy_hswq;
+
 	ret = t7xx_fsm_init(md);
 	if (ret)
 		goto err_destroy_hswq;
@@ -679,12 +724,16 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
 	if (ret)
 		goto err_uninit_ccmni;
 
-	ret = t7xx_port_proxy_init(md);
+	ret = t7xx_cldma_init(md->md_ctrl[CLDMA_ID_AP]);
 	if (ret)
 		goto err_uninit_md_cldma;
 
+	ret = t7xx_port_proxy_init(md);
+	if (ret)
+		goto err_uninit_ap_cldma;
+
 	ret = t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_START, 0);
-	if (ret) /* fsm_uninit flushes cmd queue */
+	if (ret) /* t7xx_fsm_uninit() flushes cmd queue */
 		goto err_uninit_proxy;
 
 	t7xx_md_sys_sw_init(t7xx_dev);
@@ -694,6 +743,9 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
 err_uninit_proxy:
 	t7xx_port_proxy_uninit(md->port_prox);
 
+err_uninit_ap_cldma:
+	t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_AP]);
+
 err_uninit_md_cldma:
 	t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
 
@@ -705,6 +757,7 @@ int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
 
 err_destroy_hswq:
 	destroy_workqueue(md->handshake_wq);
+	destroy_workqueue(md->ap_handshake_wq);
 	dev_err(&t7xx_dev->pdev->dev, "Modem init failed\n");
 	return ret;
 }
@@ -720,8 +773,10 @@ void t7xx_md_exit(struct t7xx_pci_dev *t7xx_dev)
 
 	t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_PRE_STOP, FSM_CMD_FLAG_WAIT_FOR_COMPLETION);
 	t7xx_port_proxy_uninit(md->port_prox);
+	t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_AP]);
 	t7xx_cldma_exit(md->md_ctrl[CLDMA_ID_MD]);
 	t7xx_ccmni_exit(t7xx_dev);
 	t7xx_fsm_uninit(md);
 	destroy_workqueue(md->handshake_wq);
+	destroy_workqueue(md->ap_handshake_wq);
 }
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
index 7469ed636ae8..c93e870ce696 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.h
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
@@ -66,10 +66,13 @@ struct t7xx_modem {
 	struct cldma_ctrl		*md_ctrl[CLDMA_NUM];
 	struct t7xx_pci_dev		*t7xx_dev;
 	struct t7xx_sys_info		core_md;
+	struct t7xx_sys_info		core_ap;
 	bool				md_init_finish;
 	bool				rgu_irq_asserted;
 	struct workqueue_struct		*handshake_wq;
 	struct work_struct		handshake_work;
+	struct workqueue_struct		*ap_handshake_wq;
+	struct work_struct		ap_handshake_work;
 	struct t7xx_fsm_ctl		*fsm_ctl;
 	struct port_proxy		*port_prox;
 	unsigned int			exp_id;
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
index dc4133eb433a..3d27f04e2a1f 100644
--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -36,9 +36,17 @@
 /* Channel ID and Message ID definitions.
  * The channel number consists of peer_id(15:12) , channel_id(11:0)
  * peer_id:
- * 0:reserved, 1: to sAP, 2: to MD
+ * 0:reserved, 1: to AP, 2: to MD
  */
 enum port_ch {
+	/* to AP */
+	PORT_CH_AP_CONTROL_RX = 0X1000,
+	PORT_CH_AP_CONTROL_TX = 0X1001,
+	PORT_CH_AP_GNSS_RX = 0x1004,
+	PORT_CH_AP_GNSS_TX = 0x1005,
+	PORT_CH_AP_LOG_RX = 0x1008,
+	PORT_CH_AP_LOG_TX = 0x1009,
+
 	/* to MD */
 	PORT_CH_CONTROL_RX = 0x2000,
 	PORT_CH_CONTROL_TX = 0x2001,
diff --git a/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
index 68430b130a67..ae632ef96698 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
@@ -167,8 +167,12 @@ static int control_msg_handler(struct t7xx_port *port, struct sk_buff *skb)
 	case CTL_ID_HS2_MSG:
 		skb_pull(skb, sizeof(*ctrl_msg_h));
 
-		if (port_conf->rx_ch == PORT_CH_CONTROL_RX) {
-			ret = t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2, skb->data,
+		if (port_conf->rx_ch == PORT_CH_CONTROL_RX ||
+		    port_conf->rx_ch == PORT_CH_AP_CONTROL_RX) {
+			int event = port_conf->rx_ch == PORT_CH_CONTROL_RX ?
+				    FSM_EVENT_MD_HS2 : FSM_EVENT_AP_HS2;
+
+			ret = t7xx_fsm_append_event(ctl, event, skb->data,
 						    le32_to_cpu(ctrl_msg_h->data_length));
 			if (ret)
 				dev_err(port->dev, "Failed to append Handshake 2 event");
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index d4de047ff0d4..ef18bcfb649b 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -50,6 +50,15 @@
 
 static const struct t7xx_port_conf t7xx_md_port_conf[] = {
 	{
+		.tx_ch = PORT_CH_AP_GNSS_TX,
+		.rx_ch = PORT_CH_AP_GNSS_RX,
+		.txq_index = Q_IDX_CTRL,
+		.rxq_index = Q_IDX_CTRL,
+		.path_id = CLDMA_ID_AP,
+		.ops = &wwan_sub_port_ops,
+		.name = "t7xx_ap_gnss",
+		.port_type = WWAN_PORT_AT,
+	}, {
 		.tx_ch = PORT_CH_UART2_TX,
 		.rx_ch = PORT_CH_UART2_RX,
 		.txq_index = Q_IDX_AT_CMD,
@@ -77,6 +86,14 @@ static const struct t7xx_port_conf t7xx_md_port_conf[] = {
 		.path_id = CLDMA_ID_MD,
 		.ops = &ctl_port_ops,
 		.name = "t7xx_ctrl",
+	}, {
+		.tx_ch = PORT_CH_AP_CONTROL_TX,
+		.rx_ch = PORT_CH_AP_CONTROL_RX,
+		.txq_index = Q_IDX_CTRL,
+		.rxq_index = Q_IDX_CTRL,
+		.path_id = CLDMA_ID_AP,
+		.ops = &ctl_port_ops,
+		.name = "t7xx_ap_ctrl",
 	},
 };
 
@@ -416,6 +433,9 @@ static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
 		if (port_conf->tx_ch == PORT_CH_CONTROL_TX)
 			md->core_md.ctl_port = port;
 
+		if (port_conf->tx_ch == PORT_CH_AP_CONTROL_TX)
+			md->core_ap.ctl_port = port;
+
 		port->t7xx_dev = md->t7xx_dev;
 		port->dev = &md->t7xx_dev->pdev->dev;
 		spin_lock_init(&port->port_update_lock);
@@ -469,6 +489,7 @@ int t7xx_port_proxy_init(struct t7xx_modem *md)
 	if (ret)
 		return ret;
 
+	t7xx_cldma_set_recv_skb(md->md_ctrl[CLDMA_ID_AP], t7xx_port_proxy_recv_skb);
 	t7xx_cldma_set_recv_skb(md->md_ctrl[CLDMA_ID_MD], t7xx_port_proxy_recv_skb);
 	return 0;
 }
diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
index 7c1b81091a0f..c41d7d094c08 100644
--- a/drivers/net/wwan/t7xx/t7xx_reg.h
+++ b/drivers/net/wwan/t7xx/t7xx_reg.h
@@ -56,7 +56,7 @@
 #define D2H_INT_RESUME_ACK			BIT(12)
 #define D2H_INT_SUSPEND_ACK_AP			BIT(13)
 #define D2H_INT_RESUME_ACK_AP			BIT(14)
-#define D2H_INT_ASYNC_SAP_HK			BIT(15)
+#define D2H_INT_ASYNC_AP_HK			BIT(15)
 #define D2H_INT_ASYNC_MD_HK			BIT(16)
 
 /* Register base */
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index 0bcca08ff2bd..80edb8e75a6a 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -285,8 +285,9 @@ static int fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
 	t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS1);
 	t7xx_md_event_notify(md, FSM_START);
 
-	wait_event_interruptible_timeout(ctl->async_hk_wq, md->core_md.ready || ctl->exp_flg,
-					 HZ * 60);
+	wait_event_interruptible_timeout(ctl->async_hk_wq,
+					 (md->core_md.ready && md->core_ap.ready) ||
+					  ctl->exp_flg, HZ * 60);
 	dev = &md->t7xx_dev->pdev->dev;
 
 	if (ctl->exp_flg)
@@ -297,6 +298,13 @@ static int fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
 		if (md->core_md.handshake_ongoing)
 			t7xx_fsm_append_event(ctl, FSM_EVENT_MD_HS2_EXIT, NULL, 0);
 
+		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
+		return -ETIMEDOUT;
+	} else if (!md->core_ap.ready) {
+		dev_err(dev, "AP handshake timeout\n");
+		if (md->core_ap.handshake_ongoing)
+			t7xx_fsm_append_event(ctl, FSM_EVENT_AP_HS2_EXIT, NULL, 0);
+
 		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
 		return -ETIMEDOUT;
 	}
@@ -335,6 +343,7 @@ static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command
 		return;
 	}
 
+	t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_AP]);
 	t7xx_cldma_hif_hw_init(md->md_ctrl[CLDMA_ID_MD]);
 	fsm_finish_command(ctl, cmd, fsm_routine_starting(ctl));
 }
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
index b1af0259d4c5..b6e76f3903c8 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.h
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
@@ -38,10 +38,12 @@ enum t7xx_fsm_state {
 enum t7xx_fsm_event_state {
 	FSM_EVENT_INVALID,
 	FSM_EVENT_MD_HS2,
+	FSM_EVENT_AP_HS2,
 	FSM_EVENT_MD_EX,
 	FSM_EVENT_MD_EX_REC_OK,
 	FSM_EVENT_MD_EX_PASS,
 	FSM_EVENT_MD_HS2_EXIT,
+	FSM_EVENT_AP_HS2_EXIT,
 	FSM_EVENT_MAX
 };
 
-- 
2.17.1

