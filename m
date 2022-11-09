Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5FC6234C1
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiKIUlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKIUlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:41:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92BD27919;
        Wed,  9 Nov 2022 12:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668026505; x=1699562505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lY6x5gsAX5a41KCZivFjlGaNatdB1vzlaAiGBzdEo9E=;
  b=G7RfQ6gClMG0l0GtL0Q7552axeUpnHObnPvgOmYjwD8c9eP04NzuE9kp
   3RgV7wVGSG7d9CNcVp1tyOaWlbaJcwlJNRt57Gs9j+ahx6lkvtGJ6e6DP
   wLQyTj2ogz4t9TREc2nn84v762xVBrplHVOW67Q7ZiE7S7LehUrQmClkc
   ZFamI3snN8lDGa6mVTypxNUAAqR34LKwOd+oIEcbem7t2u46iNycFIL85
   cwlgVKEZZVVzgWN7SZG3xUD70WD1stY+7yjPRy5vZHcGKWHHUaBGWlUZ/
   8NY+Ec6eRdijf11hRUAUz9tYfRFJwXIYwNfwHy0LOJ9AJKQj8rDcZCwpY
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="122642751"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 13:41:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 13:41:42 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 13:41:39 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.co>,
        <linux@armlinux.org.uk>, <alexandr.lobakin@intel.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 1/4] net: lan966x: Add define IFH_LEN_BYTES
Date:   Wed, 9 Nov 2022 21:46:10 +0100
Message-ID: <20221109204613.3669905-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
References: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

