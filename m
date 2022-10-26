Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CFE60E347
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbiJZO0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiJZO0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:26:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F24C10F8A9
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:26:32 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 21so7790163edv.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=41yLh/1BRnzm5SjfyMcFszPe20OCwlTQMVfdfMxprYY=;
        b=PjZQRWbz9Q5ZLa8c+3uoZWAmM/c+fUbeuR3VV5RvvT2Vx2PHxcsSNsdfisnv2jbYBf
         cgX1D/7Jd6JlQHA1osucJIrhriShHWN+AljFRbzPB5OS9xi/dTMCyAsoOc0hs6pXcCed
         +NTv65RrlmqUpOF7GurhK9RRdJfTJK4qFNKkOpAW56I2LD1XOcEZZljLUiwBDn9jiZRy
         pHcj3G22YSfe9ZkdyLy5mZzv6RMAG2fu+ArVdgIl7i4ekMBJDEkKh9cPMvXMtcFNVeZ/
         RePEAY728FpKR2GqI7oNUPLoVK07S6a94ZYKKXPHM8SE49vH102zL8piABt9Bi1ki0VV
         t3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=41yLh/1BRnzm5SjfyMcFszPe20OCwlTQMVfdfMxprYY=;
        b=CQBBzWy1Eg76rV7Of8xEEuYiv0NJe8jIsGGDc2+4ySw0i8ZLi/N2rX6t1zl/+nEaSz
         e6xxSGQ8Hf/eCOyKKPP03ApRCY72svcevDXNQIZU6WH8NQxFmkCksRQdvQ9cFeQQj9tE
         EdHIi/X2895yjPxXKh8uXVdyzlVbpxb8hUieExvUdApDH/HHDscM/kVGzINXAZ7QHJpB
         m+p4zb3XdMAVnJa1Jf/o4usUFFhKlE4dDEjOct1IrDLqYV3sx7WHc5DzkI9qEJoxM0+6
         uODh7//gtEH5AQDsatJoZgtO9K95LpGgkLxpQvkjyWQmeOM1TPXoU4HelKBSJrT0K4w+
         ulJw==
X-Gm-Message-State: ACrzQf1TOk+pPa70pMf8h0LyqnyOyDSwKiIj7Q0SLS/0tcgeiFql2XKy
        SikDFVKPz9peXs8WqIehCs0=
X-Google-Smtp-Source: AMsMyM6fxMkAtAx0NxPGsdYRCTLs1auvK1Ys1t/nLjv1fj0S+TJk2kej7grp56IaACbUvN7o3kBfJw==
X-Received: by 2002:aa7:dc10:0:b0:440:b446:c0cc with SMTP id b16-20020aa7dc10000000b00440b446c0ccmr40908323edu.34.1666794391025;
        Wed, 26 Oct 2022 07:26:31 -0700 (PDT)
Received: from localhost.lan ([194.187.74.233])
        by smtp.gmail.com with ESMTPSA id et19-20020a170907295300b0073d71792c8dsm2977768ejc.180.2022.10.26.07.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:26:30 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: broadcom: bcm4908_enet: report queued and transmitted bytes
Date:   Wed, 26 Oct 2022 16:26:24 +0200
Message-Id: <20221026142624.19314-1-zajec5@gmail.com>
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

This allows BQL to operate avoiding buffer bloat and reducing latency.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 93ccf549e2ed..e672a9ef4444 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -495,6 +495,7 @@ static int bcm4908_enet_stop(struct net_device *netdev)
 	netif_carrier_off(netdev);
 	napi_disable(&rx_ring->napi);
 	napi_disable(&tx_ring->napi);
+	netdev_reset_queue(netdev);
 
 	bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
 	bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);
@@ -564,6 +565,8 @@ static netdev_tx_t bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_devic
 	enet->netdev->stats.tx_bytes += skb->len;
 	enet->netdev->stats.tx_packets++;
 
+	netdev_sent_queue(enet->netdev, skb->len);
+
 	return NETDEV_TX_OK;
 }
 
@@ -635,6 +638,7 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 	struct bcm4908_enet_dma_ring_bd *buf_desc;
 	struct bcm4908_enet_dma_ring_slot *slot;
 	struct device *dev = enet->dev;
+	unsigned int bytes = 0;
 	int handled = 0;
 
 	while (handled < weight && tx_ring->read_idx != tx_ring->write_idx) {
@@ -645,6 +649,7 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 
 		dma_unmap_single(dev, slot->dma_addr, slot->len, DMA_TO_DEVICE);
 		dev_kfree_skb(slot->skb);
+		bytes += slot->len;
 		if (++tx_ring->read_idx == tx_ring->length)
 			tx_ring->read_idx = 0;
 
@@ -656,6 +661,8 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 		bcm4908_enet_dma_ring_intrs_on(enet, tx_ring);
 	}
 
+	netdev_completed_queue(enet->netdev, handled, bytes);
+
 	if (netif_queue_stopped(enet->netdev))
 		netif_wake_queue(enet->netdev);
 
-- 
2.34.1

