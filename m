Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A506BF76C3
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfKKOm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:42:59 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:44412 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbfKKOm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:42:59 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3DE52C003F;
        Mon, 11 Nov 2019 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573483378; bh=D0tldHpoR0/W84EFHc/hsP+fZvOo1J+/4ZOjJ5Rol+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=IW0zEpu9TzHvUaY35am2cd1uyDfdct94Dch/LvnnD2kBYTuEqrKytZOppnJG+KOHT
         nOF5Jp2qYoMwOBKDlflxK0Ggkfi44S1FYqRaGnvkTF53DT9siG+3ZOZ+fueHKdDT7b
         UNbvNilu7Mh8CAv1qayrZLgQJIz4JCam5ciST5VHuo6HAy2PFKCAFpggnHZ2tLh7Gj
         QHhRY+u2T+Qza+6bxuMmH+iAiLVILPqY1tMSeIFuzBU09Kk29SsnVm0HUZZi9jT/GP
         jjYAB5cvEaZ7i5VmA/oq5l1V7qBZ02JY2oSdK1JiLHeQRKMztHn1fw3geeY9SfeILL
         IbErXgyXbqK5Q==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C9076A0243;
        Mon, 11 Nov 2019 14:42:56 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: stmmac: Fix sparse warning
Date:   Mon, 11 Nov 2019 15:42:34 +0100
Message-Id: <7fe3e8eb2269ebbe67c9b924d50a793f5907b7e1.1573482991.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VID is converted to le16 so the variable must be __le16 type.

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: c7ab0b8088d7 ("net: stmmac: Fallback to VLAN Perfect filtering if HASH is not available")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c   | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h          | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   | 5 +++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index a2ecab5dc8c8..40ca00e596dd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -733,7 +733,7 @@ static void dwmac4_set_mac_loopback(void __iomem *ioaddr, bool enable)
 }
 
 static void dwmac4_update_vlan_hash(struct mac_device_info *hw, u32 hash,
-				    u16 perfect_match, bool is_double)
+				    __le16 perfect_match, bool is_double)
 {
 	void __iomem *ioaddr = hw->pcsr;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 9553d2bec1a7..082f5ee9e525 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -556,7 +556,7 @@ static int dwxgmac2_rss_configure(struct mac_device_info *hw,
 }
 
 static void dwxgmac2_update_vlan_hash(struct mac_device_info *hw, u32 hash,
-				      u16 perfect_match, bool is_double)
+				      __le16 perfect_match, bool is_double)
 {
 	void __iomem *ioaddr = hw->pcsr;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 1303d1e9a18f..509daeefdb79 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -357,7 +357,7 @@ struct stmmac_ops {
 			     struct stmmac_rss *cfg, u32 num_rxq);
 	/* VLAN */
 	void (*update_vlan_hash)(struct mac_device_info *hw, u32 hash,
-				 u16 perfect_match, bool is_double);
+				 __le16 perfect_match, bool is_double);
 	void (*enable_vlan)(struct mac_device_info *hw, u32 type);
 	/* TX Timestamp */
 	int (*get_mac_tx_timestamp)(struct mac_device_info *hw, u64 *ts);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 199c4f938bb2..5f40fbb67bac 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4214,6 +4214,7 @@ static u32 stmmac_vid_crc32_le(__le16 vid_le)
 static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
 {
 	u32 crc, hash = 0;
+	__le16 pmatch = 0;
 	int count = 0;
 	u16 vid = 0;
 
@@ -4228,11 +4229,11 @@ static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
 		if (count > 2) /* VID = 0 always passes filter */
 			return -EOPNOTSUPP;
 
-		vid = cpu_to_le16(vid);
+		pmatch = cpu_to_le16(vid);
 		hash = 0;
 	}
 
-	return stmmac_update_vlan_hash(priv, priv->hw, hash, vid, is_double);
+	return stmmac_update_vlan_hash(priv, priv->hw, hash, pmatch, is_double);
 }
 
 static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
-- 
2.7.4

