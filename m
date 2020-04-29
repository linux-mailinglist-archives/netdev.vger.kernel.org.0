Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83FB1BE79C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgD2TrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726973AbgD2Tqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:46:44 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E6EC03C1AE;
        Wed, 29 Apr 2020 12:46:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c21so1228549plz.4;
        Wed, 29 Apr 2020 12:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lt2wsDTP1dZbAx86w3ZjTWR6LwcLzUhJBjuXStdHEjY=;
        b=UheWzZBz8o0kciqxYn1f97iVzSoVbEGfJcBd8Kn2t+62oFg9BhT34nbmxV9u0c5FwY
         LdsPopPJz8/Ne1hV05osjNhgDjhgfie9L6H/6zdQ+iMZgRdaLhqOzSVwcMUUULBtaAI4
         5bTklBHjI6b1kkkPb6xzBl0Sf5VxcxtWYiO2tG128wGurCGlHQ6bElgVi9jk/JNmvRiK
         8pWg+rhEEcA7nkyD/3vfVCs2I+E4RXPKuVRQz93z5PWFmi/mhjLqArXvaRUFzTHHRHDW
         PkbIOBrrUBnF9nwzeaqrrkokkAQ3ILHvtMW3e1oKerK2XmrTNlG8AjxmToR8y8Z1SYCd
         4umg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lt2wsDTP1dZbAx86w3ZjTWR6LwcLzUhJBjuXStdHEjY=;
        b=mQl4NLJdmCi3UjD7OaJjPjipoPTFWBQwhb4nTUAA1i4VxzhTHIyN/E1Kv0k7jCW4ts
         txjjY6L851kDBcmVk4B+9RrMqhBo6P+8jB6thYFH30bJlRgirep0IsDsXyL42/Sa/2GK
         ry3SVY9S0fbgNHnu7+3qUvMvChqMFDLBZLAn0GaWNR9E4WjQ0IeVVSq/1PpeJvAugm55
         OE14CL9ifdeIuftC5ad4q7hRJS3jHw5neWoGeilTh42K8zgblr2Ld91UOyzj7MpBpA6S
         KhC3WXZAwPb5a5XcoR0LA0MMKi3p1okrquSdMv47zx8tk4EdXn65k2VBVyQKOAUhIGKp
         OyGg==
X-Gm-Message-State: AGi0PuaudzDEDGEKC6c/IMDq5AjHOLzkY+1rAg0APOeh/WaC8bsXGQG6
        g2p7KWqagaEeuOir5K7t0iPeLqJM
X-Google-Smtp-Source: APiQypKZimHu7MbpgtNlRJMCGYBqNwbRdEXuWS9ZlQiA0agciasR0JsSFlB2r8C6Wu194pFR8fiqqw==
X-Received: by 2002:a17:902:b097:: with SMTP id p23mr35858246plr.195.1588189603626;
        Wed, 29 Apr 2020 12:46:43 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z15sm87956pjt.20.2020.04.29.12.46.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:46:43 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 5/7] net: bcmgenet: code movement
Date:   Wed, 29 Apr 2020 12:45:50 -0700
Message-Id: <1588189552-899-6-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588189552-899-1-git-send-email-opendmb@gmail.com>
References: <1588189552-899-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Hardware Filter Block code will be used by ethtool functions
when defining flow types so this commit moves the functions in the
file to prevent the need for prototype declarations.

This is broken out to facilitate review.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 308 ++++++++++++-------------
 1 file changed, 154 insertions(+), 154 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b37ef05c5083..ad41944d2cc0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -459,6 +459,160 @@ static inline void bcmgenet_rdma_ring_writel(struct bcmgenet_priv *priv,
 			genet_dma_ring_regs[r]);
 }
 
+static bool bcmgenet_hfb_is_filter_enabled(struct bcmgenet_priv *priv,
+					   u32 f_index)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	return !!(reg & (1 << (f_index % 32)));
+}
+
+static void bcmgenet_hfb_enable_filter(struct bcmgenet_priv *priv, u32 f_index)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg |= (1 << (f_index % 32));
+	bcmgenet_hfb_reg_writel(priv, reg, offset);
+}
+
+static void bcmgenet_hfb_set_filter_rx_queue_mapping(struct bcmgenet_priv *priv,
+						     u32 f_index, u32 rx_queue)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = f_index / 8;
+	reg = bcmgenet_rdma_readl(priv, DMA_INDEX2RING_0 + offset);
+	reg &= ~(0xF << (4 * (f_index % 8)));
+	reg |= ((rx_queue & 0xF) << (4 * (f_index % 8)));
+	bcmgenet_rdma_writel(priv, reg, DMA_INDEX2RING_0 + offset);
+}
+
+static void bcmgenet_hfb_set_filter_length(struct bcmgenet_priv *priv,
+					   u32 f_index, u32 f_length)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_LEN_V3PLUS +
+		 ((priv->hw_params->hfb_filter_cnt - 1 - f_index) / 4) *
+		 sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg &= ~(0xFF << (8 * (f_index % 4)));
+	reg |= ((f_length & 0xFF) << (8 * (f_index % 4)));
+	bcmgenet_hfb_reg_writel(priv, reg, offset);
+}
+
+static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
+{
+	u32 f_index;
+
+	for (f_index = 0; f_index < priv->hw_params->hfb_filter_cnt; f_index++)
+		if (!bcmgenet_hfb_is_filter_enabled(priv, f_index))
+			return f_index;
+
+	return -ENOMEM;
+}
+
+/* bcmgenet_hfb_add_filter
+ *
+ * Add new filter to Hardware Filter Block to match and direct Rx traffic to
+ * desired Rx queue.
+ *
+ * f_data is an array of unsigned 32-bit integers where each 32-bit integer
+ * provides filter data for 2 bytes (4 nibbles) of Rx frame:
+ *
+ * bits 31:20 - unused
+ * bit  19    - nibble 0 match enable
+ * bit  18    - nibble 1 match enable
+ * bit  17    - nibble 2 match enable
+ * bit  16    - nibble 3 match enable
+ * bits 15:12 - nibble 0 data
+ * bits 11:8  - nibble 1 data
+ * bits 7:4   - nibble 2 data
+ * bits 3:0   - nibble 3 data
+ *
+ * Example:
+ * In order to match:
+ * - Ethernet frame type = 0x0800 (IP)
+ * - IP version field = 4
+ * - IP protocol field = 0x11 (UDP)
+ *
+ * The following filter is needed:
+ * u32 hfb_filter_ipv4_udp[] = {
+ *   Rx frame offset 0x00: 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+ *   Rx frame offset 0x08: 0x00000000, 0x00000000, 0x000F0800, 0x00084000,
+ *   Rx frame offset 0x10: 0x00000000, 0x00000000, 0x00000000, 0x00030011,
+ * };
+ *
+ * To add the filter to HFB and direct the traffic to Rx queue 0, call:
+ * bcmgenet_hfb_add_filter(priv, hfb_filter_ipv4_udp,
+ *                         ARRAY_SIZE(hfb_filter_ipv4_udp), 0);
+ */
+int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
+			    u32 f_length, u32 rx_queue)
+{
+	int f_index;
+	u32 i;
+
+	f_index = bcmgenet_hfb_find_unused_filter(priv);
+	if (f_index < 0)
+		return -ENOMEM;
+
+	if (f_length > priv->hw_params->hfb_filter_size)
+		return -EINVAL;
+
+	for (i = 0; i < f_length; i++)
+		bcmgenet_hfb_writel(priv, f_data[i],
+			(f_index * priv->hw_params->hfb_filter_size + i) *
+			sizeof(u32));
+
+	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
+	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
+	bcmgenet_hfb_enable_filter(priv, f_index);
+	bcmgenet_hfb_reg_writel(priv, 0x1, HFB_CTRL);
+
+	return 0;
+}
+
+/* bcmgenet_hfb_clear
+ *
+ * Clear Hardware Filter Block and disable all filtering.
+ */
+static void bcmgenet_hfb_clear(struct bcmgenet_priv *priv)
+{
+	u32 i;
+
+	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_CTRL);
+	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS);
+	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS + 4);
+
+	for (i = DMA_INDEX2RING_0; i <= DMA_INDEX2RING_7; i++)
+		bcmgenet_rdma_writel(priv, 0x0, i);
+
+	for (i = 0; i < (priv->hw_params->hfb_filter_cnt / 4); i++)
+		bcmgenet_hfb_reg_writel(priv, 0x0,
+					HFB_FLT_LEN_V3PLUS + i * sizeof(u32));
+
+	for (i = 0; i < priv->hw_params->hfb_filter_cnt *
+			priv->hw_params->hfb_filter_size; i++)
+		bcmgenet_hfb_writel(priv, 0x0, i * sizeof(u32));
+}
+
+static void bcmgenet_hfb_init(struct bcmgenet_priv *priv)
+{
+	if (GENET_IS_V1(priv) || GENET_IS_V2(priv))
+		return;
+
+	bcmgenet_hfb_clear(priv);
+}
+
 static int bcmgenet_begin(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
@@ -2759,160 +2913,6 @@ static void bcmgenet_enable_dma(struct bcmgenet_priv *priv, u32 dma_ctrl)
 	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
 }
 
-static bool bcmgenet_hfb_is_filter_enabled(struct bcmgenet_priv *priv,
-					   u32 f_index)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
-	reg = bcmgenet_hfb_reg_readl(priv, offset);
-	return !!(reg & (1 << (f_index % 32)));
-}
-
-static void bcmgenet_hfb_enable_filter(struct bcmgenet_priv *priv, u32 f_index)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
-	reg = bcmgenet_hfb_reg_readl(priv, offset);
-	reg |= (1 << (f_index % 32));
-	bcmgenet_hfb_reg_writel(priv, reg, offset);
-}
-
-static void bcmgenet_hfb_set_filter_rx_queue_mapping(struct bcmgenet_priv *priv,
-						     u32 f_index, u32 rx_queue)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = f_index / 8;
-	reg = bcmgenet_rdma_readl(priv, DMA_INDEX2RING_0 + offset);
-	reg &= ~(0xF << (4 * (f_index % 8)));
-	reg |= ((rx_queue & 0xF) << (4 * (f_index % 8)));
-	bcmgenet_rdma_writel(priv, reg, DMA_INDEX2RING_0 + offset);
-}
-
-static void bcmgenet_hfb_set_filter_length(struct bcmgenet_priv *priv,
-					   u32 f_index, u32 f_length)
-{
-	u32 offset;
-	u32 reg;
-
-	offset = HFB_FLT_LEN_V3PLUS +
-		 ((priv->hw_params->hfb_filter_cnt - 1 - f_index) / 4) *
-		 sizeof(u32);
-	reg = bcmgenet_hfb_reg_readl(priv, offset);
-	reg &= ~(0xFF << (8 * (f_index % 4)));
-	reg |= ((f_length & 0xFF) << (8 * (f_index % 4)));
-	bcmgenet_hfb_reg_writel(priv, reg, offset);
-}
-
-static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
-{
-	u32 f_index;
-
-	for (f_index = 0; f_index < priv->hw_params->hfb_filter_cnt; f_index++)
-		if (!bcmgenet_hfb_is_filter_enabled(priv, f_index))
-			return f_index;
-
-	return -ENOMEM;
-}
-
-/* bcmgenet_hfb_add_filter
- *
- * Add new filter to Hardware Filter Block to match and direct Rx traffic to
- * desired Rx queue.
- *
- * f_data is an array of unsigned 32-bit integers where each 32-bit integer
- * provides filter data for 2 bytes (4 nibbles) of Rx frame:
- *
- * bits 31:20 - unused
- * bit  19    - nibble 0 match enable
- * bit  18    - nibble 1 match enable
- * bit  17    - nibble 2 match enable
- * bit  16    - nibble 3 match enable
- * bits 15:12 - nibble 0 data
- * bits 11:8  - nibble 1 data
- * bits 7:4   - nibble 2 data
- * bits 3:0   - nibble 3 data
- *
- * Example:
- * In order to match:
- * - Ethernet frame type = 0x0800 (IP)
- * - IP version field = 4
- * - IP protocol field = 0x11 (UDP)
- *
- * The following filter is needed:
- * u32 hfb_filter_ipv4_udp[] = {
- *   Rx frame offset 0x00: 0x00000000, 0x00000000, 0x00000000, 0x00000000,
- *   Rx frame offset 0x08: 0x00000000, 0x00000000, 0x000F0800, 0x00084000,
- *   Rx frame offset 0x10: 0x00000000, 0x00000000, 0x00000000, 0x00030011,
- * };
- *
- * To add the filter to HFB and direct the traffic to Rx queue 0, call:
- * bcmgenet_hfb_add_filter(priv, hfb_filter_ipv4_udp,
- *                         ARRAY_SIZE(hfb_filter_ipv4_udp), 0);
- */
-int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
-			    u32 f_length, u32 rx_queue)
-{
-	int f_index;
-	u32 i;
-
-	f_index = bcmgenet_hfb_find_unused_filter(priv);
-	if (f_index < 0)
-		return -ENOMEM;
-
-	if (f_length > priv->hw_params->hfb_filter_size)
-		return -EINVAL;
-
-	for (i = 0; i < f_length; i++)
-		bcmgenet_hfb_writel(priv, f_data[i],
-			(f_index * priv->hw_params->hfb_filter_size + i) *
-			sizeof(u32));
-
-	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
-	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
-	bcmgenet_hfb_enable_filter(priv, f_index);
-	bcmgenet_hfb_reg_writel(priv, 0x1, HFB_CTRL);
-
-	return 0;
-}
-
-/* bcmgenet_hfb_clear
- *
- * Clear Hardware Filter Block and disable all filtering.
- */
-static void bcmgenet_hfb_clear(struct bcmgenet_priv *priv)
-{
-	u32 i;
-
-	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_CTRL);
-	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS);
-	bcmgenet_hfb_reg_writel(priv, 0x0, HFB_FLT_ENABLE_V3PLUS + 4);
-
-	for (i = DMA_INDEX2RING_0; i <= DMA_INDEX2RING_7; i++)
-		bcmgenet_rdma_writel(priv, 0x0, i);
-
-	for (i = 0; i < (priv->hw_params->hfb_filter_cnt / 4); i++)
-		bcmgenet_hfb_reg_writel(priv, 0x0,
-					HFB_FLT_LEN_V3PLUS + i * sizeof(u32));
-
-	for (i = 0; i < priv->hw_params->hfb_filter_cnt *
-			priv->hw_params->hfb_filter_size; i++)
-		bcmgenet_hfb_writel(priv, 0x0, i * sizeof(u32));
-}
-
-static void bcmgenet_hfb_init(struct bcmgenet_priv *priv)
-{
-	if (GENET_IS_V1(priv) || GENET_IS_V2(priv))
-		return;
-
-	bcmgenet_hfb_clear(priv);
-}
-
 static void bcmgenet_netif_start(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-- 
2.7.4

