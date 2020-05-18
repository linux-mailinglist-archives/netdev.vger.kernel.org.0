Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4C1D88F2
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgERUOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgERUOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:14:34 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45780C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 13:14:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id v12so13273376wrp.12
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 13:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Z3TZNQtcQXxmUkcnhkiO8lDzHmsZKUXJ1VKTQ0jNGi8=;
        b=LXNRpiCiPcKsyoxnyyrgYb/gLDBu1B4d3tUofu4a85Z8L8aUnVsJA0jrwFxFpM2L5H
         jU9RYduo829PTF27j96sE0M2Ho41dRVaxIEuxjQ9AAEcpRWa8Jyy1atnezEUPsXw5Htp
         PtKnNYGwZnZTkldMM6tT9iVAl5z6T/c006HBXGiSEqnoJ2M8ZTu/W5N4QwsGX5ahPEm8
         9yXftVVHaJ8eQhnkZzAz5HZ+tzyTsESh/VinJyqJwBD0C2nHcl4lcuJXXh6iLciC88fU
         VbhyItbuJEl/lyDfGX8Ytlxpnu3pa8jeceXCjY2kCb6lObvwQyA26SkccNvZssQXwk8a
         jX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Z3TZNQtcQXxmUkcnhkiO8lDzHmsZKUXJ1VKTQ0jNGi8=;
        b=uLgB74YNc2nBUwgLWxu34BMdGUPX1H913o7QFxYWLP3nVWqSUbybOO3UPIw/ubIRyR
         QPEKkZbQfQO2k+ujTCZ520409fCBQVfKh8nsyQpQ+HV+jHnX070RurjngGikdZrFvkUc
         gp0icbxjuQmNpyk6Jd5yWyn0fE90YKMTUN9U96rMVdQt9Sj2oh4OZyiibxthQGCZUlLr
         11ZwFA6sCUQaIG9CcXZNLarqYUvbv6RIVJCuJ4E/mP+pM3fPgB/iut6coI2wkalpaHZD
         /PzXwLtlMHEFJrmIp10EUPJBc0JIcd1UyYtxvUR9iHCA22CUQnL3PwqnO/qNIHclcv54
         ncSQ==
X-Gm-Message-State: AOAM533WkgXSD9xB81eWjYXZU6DLl6Q5P6PdWMvMzXXNQ3Et2+5RjcjD
        lOWnbVsFEbgyw8+78UlGcdGAVk2E
X-Google-Smtp-Source: ABdhPJx8u1D/7yVhifLgGDdTgsAX91DaIx+MlUfizoGuDFWvUY0aN8wefDsokRXo8xQaXyAfHpywQA==
X-Received: by 2002:a5d:4d05:: with SMTP id z5mr21290756wrt.130.1589832872270;
        Mon, 18 May 2020 13:14:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:9de0:f30c:fd06:315c? (p200300ea8f2852009de0f30cfd06315c.dip0.t-ipconnect.de. [2003:ea:8f28:5200:9de0:f30c:fd06:315c])
        by smtp.googlemail.com with ESMTPSA id t129sm954581wmg.27.2020.05.18.13.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 13:14:31 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: make rtl_rx better readable
Message-ID: <bfeb7228-7d03-f7b4-98ce-3671bfa42cc5@gmail.com>
Date:   Mon, 18 May 2020 22:14:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid the goto from the rx error handling branch into the else branch,
and in general avoid having the main rx work in the else branch.
In addition ensure proper reverse xmas tree order of variables in the
for loop.

No functional change intended.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 99 +++++++++++------------
 1 file changed, 48 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e35820c72..e887ee1e3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4413,15 +4413,17 @@ static inline void rtl8169_rx_csum(struct sk_buff *skb, u32 opts1)
 
 static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget)
 {
-	unsigned int cur_rx, rx_left;
-	unsigned int count;
+	unsigned int cur_rx, rx_left, count;
+	struct device *d = tp_to_dev(tp);
 
 	cur_rx = tp->cur_rx;
 
 	for (rx_left = min(budget, NUM_RX_DESC); rx_left > 0; rx_left--, cur_rx++) {
-		unsigned int entry = cur_rx % NUM_RX_DESC;
-		const void *rx_buf = page_address(tp->Rx_databuff[entry]);
+		unsigned int pkt_size, entry = cur_rx % NUM_RX_DESC;
 		struct RxDesc *desc = tp->RxDescArray + entry;
+		struct sk_buff *skb;
+		const void *rx_buf;
+		dma_addr_t addr;
 		u32 status;
 
 		status = le32_to_cpu(desc->opts1);
@@ -4443,62 +4445,57 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 				dev->stats.rx_length_errors++;
 			if (status & RxCRC)
 				dev->stats.rx_crc_errors++;
-			if (status & (RxRUNT | RxCRC) && !(status & RxRWT) &&
-			    dev->features & NETIF_F_RXALL) {
-				goto process_pkt;
-			}
-		} else {
-			unsigned int pkt_size;
-			struct sk_buff *skb;
-
-process_pkt:
-			pkt_size = status & GENMASK(13, 0);
-			if (likely(!(dev->features & NETIF_F_RXFCS)))
-				pkt_size -= ETH_FCS_LEN;
-			/*
-			 * The driver does not support incoming fragmented
-			 * frames. They are seen as a symptom of over-mtu
-			 * sized frames.
-			 */
-			if (unlikely(rtl8169_fragmented_frame(status))) {
-				dev->stats.rx_dropped++;
-				dev->stats.rx_length_errors++;
-				goto release_descriptor;
-			}
 
-			skb = napi_alloc_skb(&tp->napi, pkt_size);
-			if (unlikely(!skb)) {
-				dev->stats.rx_dropped++;
+			if (!(dev->features & NETIF_F_RXALL))
 				goto release_descriptor;
-			}
+			else if (status & RxRWT || !(status & (RxRUNT | RxCRC)))
+				goto release_descriptor;
+		}
 
-			dma_sync_single_for_cpu(tp_to_dev(tp),
-						le64_to_cpu(desc->addr),
-						pkt_size, DMA_FROM_DEVICE);
-			prefetch(rx_buf);
-			skb_copy_to_linear_data(skb, rx_buf, pkt_size);
-			skb->tail += pkt_size;
-			skb->len = pkt_size;
+		pkt_size = status & GENMASK(13, 0);
+		if (likely(!(dev->features & NETIF_F_RXFCS)))
+			pkt_size -= ETH_FCS_LEN;
 
-			dma_sync_single_for_device(tp_to_dev(tp),
-						   le64_to_cpu(desc->addr),
-						   pkt_size, DMA_FROM_DEVICE);
+		/* The driver does not support incoming fragmented frames.
+		 * They are seen as a symptom of over-mtu sized frames.
+		 */
+		if (unlikely(rtl8169_fragmented_frame(status))) {
+			dev->stats.rx_dropped++;
+			dev->stats.rx_length_errors++;
+			goto release_descriptor;
+		}
 
-			rtl8169_rx_csum(skb, status);
-			skb->protocol = eth_type_trans(skb, dev);
+		skb = napi_alloc_skb(&tp->napi, pkt_size);
+		if (unlikely(!skb)) {
+			dev->stats.rx_dropped++;
+			goto release_descriptor;
+		}
 
-			rtl8169_rx_vlan_tag(desc, skb);
+		addr = le64_to_cpu(desc->addr);
+		rx_buf = page_address(tp->Rx_databuff[entry]);
 
-			if (skb->pkt_type == PACKET_MULTICAST)
-				dev->stats.multicast++;
+		dma_sync_single_for_cpu(d, addr, pkt_size, DMA_FROM_DEVICE);
+		prefetch(rx_buf);
+		skb_copy_to_linear_data(skb, rx_buf, pkt_size);
+		skb->tail += pkt_size;
+		skb->len = pkt_size;
+		dma_sync_single_for_device(d, addr, pkt_size, DMA_FROM_DEVICE);
 
-			napi_gro_receive(&tp->napi, skb);
+		rtl8169_rx_csum(skb, status);
+		skb->protocol = eth_type_trans(skb, dev);
+
+		rtl8169_rx_vlan_tag(desc, skb);
+
+		if (skb->pkt_type == PACKET_MULTICAST)
+			dev->stats.multicast++;
+
+		napi_gro_receive(&tp->napi, skb);
+
+		u64_stats_update_begin(&tp->rx_stats.syncp);
+		tp->rx_stats.packets++;
+		tp->rx_stats.bytes += pkt_size;
+		u64_stats_update_end(&tp->rx_stats.syncp);
 
-			u64_stats_update_begin(&tp->rx_stats.syncp);
-			tp->rx_stats.packets++;
-			tp->rx_stats.bytes += pkt_size;
-			u64_stats_update_end(&tp->rx_stats.syncp);
-		}
 release_descriptor:
 		rtl8169_mark_to_asic(desc);
 	}
-- 
2.26.2

