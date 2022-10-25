Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E0860CD52
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiJYNXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiJYNW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:22:59 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E9F165508
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 06:22:58 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id fy4so12436582ejc.5
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 06:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NT2aaehtSc2SC1SWO0/davHSOjgMEvrDOgp6DFABMus=;
        b=IXtgww27pMuFtL64nfF9hs7B0R4d2ja+QE6K3c52m1txyK3XQ1KkPAm8KQOReA+FCT
         qWGkA+uofY88I03tK4/IMvuwTgjAOMR3uU0nEKYRXhMKLdF6AFOwH8dvFKQK48tMbo9u
         uJW/V15I9S9bv1D986ILuYV+qfcnar071CCfyO8EMDgyM1BNlleF+DeZMgIQkTNFyKje
         RoWsz4Gx2Jc6mLX/y0z2qLafdOJvr1Ydj1F3PDc69usLRJ5lTPLV/4BjVKyp3tzO6Nyl
         U8ABcW5CDqCnF5stZygSM/RFdhOcrtoCcXqDrFdHy1QyrJQTWB3mSs3ERd0SLbeRWTi6
         HlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NT2aaehtSc2SC1SWO0/davHSOjgMEvrDOgp6DFABMus=;
        b=N+HtreBTyUWxCCIkx1P9G9VoGm3aT/gwIymXvopCxRc7Cils/QUKdVb2IeVAwN6obC
         Y8tiRGuWkBdlsYjLwaAU5BG5QwnEsXaHksINmyYmb0f+jzqvnq1YBWbl896OEcgVd5B2
         PYAbx4fGa3QiXA2qLTitsyrjrZZYuIeXqSQ33oNw8UFe8/PiT/ZsKtMPV8OU9rpzlgAN
         fZAQ0+hQo8NtbLFq4SLGFgR+0ZK6N+EdohIWo5OCzh+MTHlPOlLAMAsAd87X/9siKd4o
         r7Q4XQl3dncn0Pq+DKmPRSN6MC1dRTZKUJnohDaTvRQqUO7EnHBzStsJksuJPmhQeKMu
         YFYA==
X-Gm-Message-State: ACrzQf2UF6kEYCR7vzymMWJj101lQkgsgHb2/nLK4G6zcks/dLABeT29
        KlNdc0iT+Xj64NNYIg8ToQ8=
X-Google-Smtp-Source: AMsMyM5snBVr8nMNRgRUY459drv3UKAFrQ+fZOVkUZK5AfzS5f9/tz/mUTmTufM2SB3Ve5ShdYtSMA==
X-Received: by 2002:a17:907:9688:b0:7a5:74eb:d12b with SMTP id hd8-20020a170907968800b007a574ebd12bmr11019924ejc.60.1666704176981;
        Tue, 25 Oct 2022 06:22:56 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id eh2-20020a0564020f8200b0044ef2ac2650sm1602228edb.90.2022.10.25.06.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 06:22:56 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: broadcom: bcm4908_enet: use build_skb()
Date:   Tue, 25 Oct 2022 15:22:45 +0200
Message-Id: <20221025132245.22871-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

RX code can be more efficient with the build_skb(). Allocating actual
SKB around eth packet buffer - right before passing it up - results in
a better cache usage.

Without RPS (echo 0 > rps_cpus) BCM4908 NAT masq performance "jumps"
between two speeds: ~900 Mbps and 940 Mbps (it's a 4 CPUs SoC). This
change bumps the lower speed from 905 Mb/s to 918 Mb/s (tested using
single stream iperf 2.0.5 traffic).

There are more optimizations to consider. One obvious to try is GRO
however as BCM4908 doesn't do hw csum is may actually lower performance.
Sometimes. Some early testing:

┌─────────────────────────────────┬─────────────────────┬────────────────────┐
│                                 │ netif_receive_skb() │ napi_gro_receive() │
├─────────────────────────────────┼─────────────────────┼────────────────────┤
│ netdev_alloc_skb()              │            905 Mb/s │           892 Mb/s │
│ napi_alloc_frag() + build_skb() │            918 Mb/s │           917 Mb/s │
└─────────────────────────────────┴─────────────────────┴────────────────────┘

Another ideas:
1. napi_build_skb()
2. skb_copy_from_linear_data() for small packets

Those need proper testing first though. That can be done later.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 53 +++++++++++++-------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 93ccf549e2ed..ca8c86ee44c0 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -36,13 +36,24 @@
 #define ENET_MAX_ETH_OVERHEAD			(ETH_HLEN + BRCM_MAX_TAG_LEN + VLAN_HLEN + \
 						 ETH_FCS_LEN + 4) /* 32 */
 
+#define ENET_RX_SKB_BUF_SIZE			(NET_SKB_PAD + NET_IP_ALIGN + \
+						 ETH_HLEN + BRCM_MAX_TAG_LEN + VLAN_HLEN + \
+						 ENET_MTU_MAX + ETH_FCS_LEN + 4)
+#define ENET_RX_SKB_BUF_ALLOC_SIZE		(SKB_DATA_ALIGN(ENET_RX_SKB_BUF_SIZE) + \
+						 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+#define ENET_RX_BUF_DMA_OFFSET			(NET_SKB_PAD + NET_IP_ALIGN)
+#define ENET_RX_BUF_DMA_SIZE			(ENET_RX_SKB_BUF_SIZE - ENET_RX_BUF_DMA_OFFSET)
+
 struct bcm4908_enet_dma_ring_bd {
 	__le32 ctl;
 	__le32 addr;
 } __packed;
 
 struct bcm4908_enet_dma_ring_slot {
-	struct sk_buff *skb;
+	union {
+		void *buf;			/* RX */
+		struct sk_buff *skb;		/* TX */
+	};
 	unsigned int len;
 	dma_addr_t dma_addr;
 };
@@ -260,22 +271,21 @@ static int bcm4908_enet_dma_alloc_rx_buf(struct bcm4908_enet *enet, unsigned int
 	u32 tmp;
 	int err;
 
-	slot->len = ENET_MTU_MAX + ENET_MAX_ETH_OVERHEAD;
-
-	slot->skb = netdev_alloc_skb(enet->netdev, slot->len);
-	if (!slot->skb)
+	slot->buf = napi_alloc_frag(ENET_RX_SKB_BUF_ALLOC_SIZE);
+	if (!slot->buf)
 		return -ENOMEM;
 
-	slot->dma_addr = dma_map_single(dev, slot->skb->data, slot->len, DMA_FROM_DEVICE);
+	slot->dma_addr = dma_map_single(dev, slot->buf + ENET_RX_BUF_DMA_OFFSET,
+					ENET_RX_BUF_DMA_SIZE, DMA_FROM_DEVICE);
 	err = dma_mapping_error(dev, slot->dma_addr);
 	if (err) {
 		dev_err(dev, "Failed to map DMA buffer: %d\n", err);
-		kfree_skb(slot->skb);
-		slot->skb = NULL;
+		skb_free_frag(slot->buf);
+		slot->buf = NULL;
 		return err;
 	}
 
-	tmp = slot->len << DMA_CTL_LEN_DESC_BUFLENGTH_SHIFT;
+	tmp = ENET_RX_BUF_DMA_SIZE << DMA_CTL_LEN_DESC_BUFLENGTH_SHIFT;
 	tmp |= DMA_CTL_STATUS_OWN;
 	if (idx == enet->rx_ring.length - 1)
 		tmp |= DMA_CTL_STATUS_WRAP;
@@ -315,11 +325,11 @@ static void bcm4908_enet_dma_uninit(struct bcm4908_enet *enet)
 
 	for (i = rx_ring->length - 1; i >= 0; i--) {
 		slot = &rx_ring->slots[i];
-		if (!slot->skb)
+		if (!slot->buf)
 			continue;
 		dma_unmap_single(dev, slot->dma_addr, slot->len, DMA_FROM_DEVICE);
-		kfree_skb(slot->skb);
-		slot->skb = NULL;
+		skb_free_frag(slot->buf);
+		slot->buf = NULL;
 	}
 }
 
@@ -577,6 +587,7 @@ static int bcm4908_enet_poll_rx(struct napi_struct *napi, int weight)
 	while (handled < weight) {
 		struct bcm4908_enet_dma_ring_bd *buf_desc;
 		struct bcm4908_enet_dma_ring_slot slot;
+		struct sk_buff *skb;
 		u32 ctl;
 		int len;
 		int err;
@@ -600,16 +611,24 @@ static int bcm4908_enet_poll_rx(struct napi_struct *napi, int weight)
 
 		if (len < ETH_ZLEN ||
 		    (ctl & (DMA_CTL_STATUS_SOP | DMA_CTL_STATUS_EOP)) != (DMA_CTL_STATUS_SOP | DMA_CTL_STATUS_EOP)) {
-			kfree_skb(slot.skb);
+			skb_free_frag(slot.buf);
 			enet->netdev->stats.rx_dropped++;
 			break;
 		}
 
-		dma_unmap_single(dev, slot.dma_addr, slot.len, DMA_FROM_DEVICE);
+		dma_unmap_single(dev, slot.dma_addr, ENET_RX_BUF_DMA_SIZE, DMA_FROM_DEVICE);
+
+		skb = build_skb(slot.buf, ENET_RX_SKB_BUF_ALLOC_SIZE);
+		if (unlikely(!skb)) {
+			skb_free_frag(slot.buf);
+			enet->netdev->stats.rx_dropped++;
+			break;
+		}
+		skb_reserve(skb, ENET_RX_BUF_DMA_OFFSET);
+		skb_put(skb, len - ETH_FCS_LEN);
+		skb->protocol = eth_type_trans(skb, enet->netdev);
 
-		skb_put(slot.skb, len - ETH_FCS_LEN);
-		slot.skb->protocol = eth_type_trans(slot.skb, enet->netdev);
-		netif_receive_skb(slot.skb);
+		netif_receive_skb(skb);
 
 		enet->netdev->stats.rx_packets++;
 		enet->netdev->stats.rx_bytes += len;
-- 
2.34.1

