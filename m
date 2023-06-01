Return-Path: <netdev+bounces-7022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CDCE7194AA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5F991C20FDD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0F1BE7F;
	Thu,  1 Jun 2023 07:46:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6B8539B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 07:46:47 +0000 (UTC)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3B5E46
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 00:46:45 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-30ae3a399aaso84152f8f.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 00:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685605603; x=1688197603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UDvuyGKcE4u2rB8/mp0V+EeyHQy6wBtC2SMaZnT20Uw=;
        b=NI/JOH7aY0yZWpzrD1bPO9PDnk6QZrho8b5HQ6h6l7SKFqEqpWOjJibfJ8shwSVL7L
         QIqOl9+OW0d86Sr0awwMMua9B+9L/IPUBgolxGCORQBkJbceM19r1ie2rk2G0MhHvBxz
         Z8NbJGxV2JFF8zjpYF0OoWTxRUVrJvc3n0riAMuf4u/V2RyxEARh2h8g5NhpTUgb2pYt
         RqpEJQ3u4Xlt0rV2ntkwomvmneW/wwPLfYic1PZ2RjKPq3TJTnSi4vYZyma45ERtRrrV
         eVKp8XdjWzPUaHF5a4JgR5myFEMFtZMFod1I5fZ887nHgYr0Bl2M0LysnGt+DvIsJPou
         +SvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685605603; x=1688197603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UDvuyGKcE4u2rB8/mp0V+EeyHQy6wBtC2SMaZnT20Uw=;
        b=RNu2Oa8ECSCkSNnk2z2Go0uc/Ujq5N3oEv0DidT5oSq9zS7yjC83OXJHp4YlulN3QP
         mPeU8MCUXzhhmFWiDNmkdh64lkKED5oU1Bdklbv2iWff3HMytSyHTGn36XGc9H0eQ9OC
         NnHX6qQprrhqodiqddZITHzMHAtto00DKIXOpCaczVyo2de/zX0UbYOLHtT4CVSoOjhy
         bjUvgZAUZdvaxddthMP/yWM8dVyUe1+pnfFHclEts56MMbCg05Z1FP8q+O2KIEy4ubLb
         AhI5E/1Irvjg+XlWXOOuRmOe2qQ04HipvnC074+XQg3ElQv8DHg7m7BC4Rms/f3f7bkO
         dO1Q==
X-Gm-Message-State: AC+VfDyOxo/vER4+xzCWbGj6AQiKT83o5LNF9gxQk9KRO4CRhRdWhkRn
	a1W75trRKXLQreRJk9Us1k1xBWRCuhtump9RlNI=
X-Google-Smtp-Source: ACHHUZ5ao6C+5pz+zF550bM9Hzn7MZh6x3oNgeWCAz8f8fCyHhR3KaBEgRmtv7zz3EnE8gZWMkPyiw==
X-Received: by 2002:a5d:680b:0:b0:2f9:ee11:e5c3 with SMTP id w11-20020a5d680b000000b002f9ee11e5c3mr5807970wru.2.1685605603177;
        Thu, 01 Jun 2023 00:46:43 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id p12-20020adfcc8c000000b0030adfa48e1esm9350795wrj.29.2023.06.01.00.46.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jun 2023 00:46:42 -0700 (PDT)
From: Magnus Karlsson <magnus.karlsson@gmail.com>
To: magnus.karlsson@intel.com,
	intel-wired-lan@lists.osuosl.org,
	anthony.l.nguyen@intel.com,
	maciej.fijalkowski@intel.com,
	hao.ma@intel.com
Cc: netdev@vger.kernel.org
Subject: [PATCH iwl-next] ixgbe: allow toggling loopback mode via ndo_set_features callback
Date: Thu,  1 Jun 2023 09:46:21 +0200
Message-Id: <20230601074621.14755-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Hao Ma <hao.ma@intel.com>

Add support for NETIF_F_LOOPBACK. This feature can be set via: $
ethtool -K eth0 loopback <on|off>. This sets the MAC Tx->Rx loopback
used by selftests/bpf/xskxceiver.

Signed-off-by: Hao Ma <hao.ma@intel.com>
---
 .../net/ethernet/intel/ixgbe/ixgbe_common.c   |  4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 73 +++++++++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  1 +
 3 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 878dd8dff528..b8998a56ad24 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3337,7 +3337,7 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
 
 	if (link_up_wait_to_complete) {
 		for (i = 0; i < IXGBE_LINK_UP_TIME; i++) {
-			if (links_reg & IXGBE_LINKS_UP) {
+			if (links_reg & IXGBE_LINKS_UP || hw->loopback_on) {
 				*link_up = true;
 				break;
 			} else {
@@ -3347,7 +3347,7 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
 			links_reg = IXGBE_READ_REG(hw, IXGBE_LINKS);
 		}
 	} else {
-		if (links_reg & IXGBE_LINKS_UP) {
+		if (links_reg & IXGBE_LINKS_UP || hw->loopback_on) {
 			if (crosstalk_fix_active) {
 				/* Check the link state again after a delay
 				 * to filter out spurious link up
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 5d83c887a3fc..70b34b7b5cb0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8864,6 +8864,57 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int ixgbe_force_loopback(struct ixgbe_adapter *adapter, bool on)
+{	struct ixgbe_hw *hw = &adapter->hw;
+	u32 reg_data;
+
+	hw->loopback_on = on;
+	/* Setup MAC loopback */
+	reg_data = IXGBE_READ_REG(hw, IXGBE_HLREG0);
+	if (on)
+		reg_data |= IXGBE_HLREG0_LPBK;
+	else
+		reg_data &= ~IXGBE_HLREG0_LPBK;
+	IXGBE_WRITE_REG(hw, IXGBE_HLREG0, reg_data);
+
+	reg_data = IXGBE_READ_REG(hw, IXGBE_FCTRL);
+	if (on)
+		reg_data |= IXGBE_FCTRL_SBP | IXGBE_FCTRL_MPE;
+	else
+		reg_data &= ~(IXGBE_FCTRL_SBP | IXGBE_FCTRL_MPE);
+	reg_data &= ~(IXGBE_FCTRL_BAM);
+	IXGBE_WRITE_REG(hw, IXGBE_FCTRL, reg_data);
+
+	/* X540 and X550 needs to set the MACC.FLU bit to force link up */
+	switch (adapter->hw.mac.type) {
+	case ixgbe_mac_X540:
+	case ixgbe_mac_X550:
+	case ixgbe_mac_X550EM_x:
+	case ixgbe_mac_x550em_a:
+		reg_data = IXGBE_READ_REG(hw, IXGBE_MACC);
+		if (on)
+			reg_data |= IXGBE_MACC_FLU;
+		else
+			reg_data &= ~IXGBE_MACC_FLU;
+		IXGBE_WRITE_REG(hw, IXGBE_MACC, reg_data);
+		break;
+	default:
+		if (hw->mac.orig_autoc) {
+			if (on)
+				reg_data = hw->mac.orig_autoc | IXGBE_AUTOC_FLU;
+			else
+				reg_data = hw->mac.orig_autoc & ~IXGBE_AUTOC_FLU;
+			IXGBE_WRITE_REG(hw, IXGBE_AUTOC, reg_data);
+		} else {
+			return 10;
+		}
+	}
+
+	IXGBE_WRITE_FLUSH(hw);
+
+	return 0;
+}
+
 static netdev_tx_t __ixgbe_xmit_frame(struct sk_buff *skb,
 				      struct net_device *netdev,
 				      struct ixgbe_ring *ring)
@@ -9915,6 +9966,15 @@ static int ixgbe_set_features(struct net_device *netdev,
 	if (changed & NETIF_F_RXALL)
 		need_reset = true;
 
+	if (changed & NETIF_F_LOOPBACK) {
+		if (features & NETIF_F_LOOPBACK) {
+			ixgbe_force_loopback(adapter, true);
+		} else {
+			ixgbe_force_loopback(adapter, false);
+			need_reset = true;
+			}
+	}
+
 	netdev->features = features;
 
 	if ((changed & NETIF_F_HW_L2FW_DOFFLOAD) && adapter->num_rx_pools > 1)
@@ -10286,6 +10346,17 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 			/* Wait until ndo_xsk_wakeup completes. */
 			synchronize_rcu();
 		err = ixgbe_setup_tc(dev, adapter->hw_tcs);
+		if (adapter->hw.loopback_on) {
+			u32 reg_data;
+
+			reg_data = IXGBE_READ_REG(&adapter->hw, IXGBE_HLREG0);
+			reg_data |= IXGBE_HLREG0_LPBK;
+			IXGBE_WRITE_REG(&adapter->hw, IXGBE_HLREG0, reg_data);
+
+			reg_data = IXGBE_READ_REG(&adapter->hw, IXGBE_MACC);
+			reg_data |= IXGBE_MACC_FLU;
+			IXGBE_WRITE_REG(&adapter->hw, IXGBE_MACC, reg_data);
+		}
 
 		if (err)
 			return -EINVAL;
@@ -10969,6 +11040,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hw->mac.type >= ixgbe_mac_82599EB)
 		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
 
+	netdev->features |= NETIF_F_LOOPBACK;
+
 #ifdef CONFIG_IXGBE_IPSEC
 #define IXGBE_ESP_FEATURES	(NETIF_F_HW_ESP | \
 				 NETIF_F_HW_ESP_TX_CSUM | \
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 2b00db92b08f..ca50ccd59b50 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -3652,6 +3652,7 @@ struct ixgbe_hw {
 	bool				allow_unsupported_sfp;
 	bool				wol_enabled;
 	bool				need_crosstalk_fix;
+	bool				loopback_on;
 };
 
 struct ixgbe_info {

base-commit: 735c9ee9a374769b78c716de3c19a6c9440ede85
-- 
2.34.1


