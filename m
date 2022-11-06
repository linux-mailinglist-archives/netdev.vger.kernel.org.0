Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8679561E628
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 22:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiKFVHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 16:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiKFVHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 16:07:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CB6C2E;
        Sun,  6 Nov 2022 13:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667768849; x=1699304849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lY6x5gsAX5a41KCZivFjlGaNatdB1vzlaAiGBzdEo9E=;
  b=v13Rj1Aub3ETNTX2EC1gsIiMDwARymOl5s9YnSz9w+Z78GUiwcEOGlib
   vZdvGT254QUmWx74mqjt5sJNgH4GAgd85+K+vWJmRAyVYTKK9Em4Ql3Ei
   kk1q9YTXsW3bHn1x9efqnPHdgQu7kGz/iW7a08/DDNz6EJKrOvtRoRBQE
   ucKmiEL60oSKnDGXvbRhINPr5n9L7vUxy/ZZZNy29cBbZY4NWs05eqIHl
   jnslVoa4vqu+BL20oTTW4k7WBKoV6v5aSlMPPtFMXx0c9bW6dyawJRAvO
   9EtlFo5Iilbbm37B+7xjSj3y0ozCf+njb9/7cjS2Zctls+Nz/Zcz3YRA0
   g==;
X-IronPort-AV: E=Sophos;i="5.96,142,1665471600"; 
   d="scan'208";a="187885495"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 14:07:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 14:07:28 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 14:07:26 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/4] net: lan966x: Add define IFH_LEN_BYTES
Date:   Sun, 6 Nov 2022 22:11:51 +0100
Message-ID: <20221106211154.3225784-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The total length of IFH(inter frame header) in bytes is calculated as
IFH_LEN * sizeof(u32). Because IFH_LEN describes the length in words
and not in bytes. As the length of IFH in bytes is used quite often,
add a define for this. This is just to simplify the things.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 10 +++++-----
 drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h  |  1 +
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c |  2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index e6948939ccc2b..6c102ee20f1d7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -436,7 +436,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
 			       DMA_ATTR_SKIP_CPU_SYNC);
 
 	skb->dev = lan966x->ports[src_port]->dev;
-	skb_pull(skb, IFH_LEN * sizeof(u32));
+	skb_pull(skb, IFH_LEN_BYTES);
 
 	if (likely(!(skb->dev->features & NETIF_F_RXFCS)))
 		skb_trim(skb, skb->len - ETH_FCS_LEN);
@@ -592,7 +592,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	}
 
 	/* skb processing */
-	needed_headroom = max_t(int, IFH_LEN * sizeof(u32) - skb_headroom(skb), 0);
+	needed_headroom = max_t(int, IFH_LEN_BYTES - skb_headroom(skb), 0);
 	needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 0);
 	if (needed_headroom || needed_tailroom || skb_header_cloned(skb)) {
 		err = pskb_expand_head(skb, needed_headroom, needed_tailroom,
@@ -605,8 +605,8 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	}
 
 	skb_tx_timestamp(skb);
-	skb_push(skb, IFH_LEN * sizeof(u32));
-	memcpy(skb->data, ifh, IFH_LEN * sizeof(u32));
+	skb_push(skb, IFH_LEN_BYTES);
+	memcpy(skb->data, ifh, IFH_LEN_BYTES);
 	skb_put(skb, 4);
 
 	dma_addr = dma_map_single(lan966x->dev, skb->data, skb->len,
@@ -740,7 +740,7 @@ int lan966x_fdma_change_mtu(struct lan966x *lan966x)
 	u32 val;
 
 	max_mtu = lan966x_fdma_get_max_mtu(lan966x);
-	max_mtu += IFH_LEN * sizeof(u32);
+	max_mtu += IFH_LEN_BYTES;
 	max_mtu += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	max_mtu += VLAN_HLEN * 2;
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h b/drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
index ca3314789d18d..f3b1e0d318261 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
@@ -8,6 +8,7 @@
  */
 
 #define IFH_LEN                      7
+#define IFH_LEN_BYTES                (IFH_LEN * sizeof(u32))
 
 /* Timestamp for frame */
 #define IFH_POS_TIMESTAMP            192
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 20ee5b28f70a5..1a27946ccaf44 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -760,7 +760,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 			 NETIF_F_HW_VLAN_STAG_TX |
 			 NETIF_F_HW_TC;
 	dev->hw_features |= NETIF_F_HW_TC;
-	dev->needed_headroom = IFH_LEN * sizeof(u32);
+	dev->needed_headroom = IFH_LEN_BYTES;
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
 
-- 
2.38.0

