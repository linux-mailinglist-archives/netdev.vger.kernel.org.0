Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2686160F622
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbiJ0LYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiJ0LYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:24:46 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47386140F9
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:24:44 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id n12so3529693eja.11
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mk55RQ4aT3LbgSxJAAjr7FgI6rC7acvlyBGCaYF+3AA=;
        b=cHEt4f4lRqvOQnP8ezcKGk2ug27gAIvRqkl/80N/6Y0/2J1UTUSYYUdiVGQM2JmHlL
         T9EwtV7wEma3mRwWgW6VEUAT0y809PJJHpMf/3kXsnJ4IjvHn+Qa0Aop4fXK76LuNtbw
         LYNRDS+uD67Eb/8qQiKddX8GXLWZKFQYJ3Mq/6BxFpaurU4KGagrj6prF9EU+kK6CiYF
         ES6xBamP7zI+byZ9oqwmO6eGWlvarR99nRnRtubZxZHXIMWiBiAvhMlnCFbtSnrxocWY
         zZH1KkLFUjMUegG7C04aq7b38pL6y/QbSo+imSh3VgBfOOCHeLHeL8XXCGVtCtab7jEJ
         GYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mk55RQ4aT3LbgSxJAAjr7FgI6rC7acvlyBGCaYF+3AA=;
        b=HsA4mYr8VtFIAyF6Pm1b4dsvCrK9YtumYVmDE4vczFQYx+9l3usZ2bvbBvOcNt61CY
         B6iJsZE2uyJty5MUgSpir2hx4DNqZWi0kt701qu/gBq8g3T+Gm/703aRD6LBWkDB36EY
         bTF+4V/9a31GTimxHrg0sYh29ZBmlhroQrtWeqstUO+gDsiCLq0Vv4CJKTJOhOVQrCL9
         X/mkd190VjhE1ECy0naejXhoBR5jubrPylfx/3wlbNe/p/vSfcIYbPrFEzQSyHj92sUs
         QS1PaYrmGK4VA+DOQCSJC6F2QTUrvr/AnlS3OWGSGtVKL+gaf6yDF+9DX2ObTMPJDcP6
         AT7w==
X-Gm-Message-State: ACrzQf2HA52RwPgLwE/7/EOwDx5m9vpOZWm/SK37og4Nj80DWkB6Mugg
        gvzHluZPUMtxTBxNrzJERyw=
X-Google-Smtp-Source: AMsMyM4+UNGAUamX1KCfMaOSeD4u8FZx/SUdtNtQ5qCRp/XWMUqJfTLSaxf36yE21Mx1fx0NxIwreQ==
X-Received: by 2002:a17:907:3f28:b0:7ad:88f8:7644 with SMTP id hq40-20020a1709073f2800b007ad88f87644mr3654882ejc.738.1666869883378;
        Thu, 27 Oct 2022 04:24:43 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id ek14-20020a056402370e00b00458a03203b1sm818171edb.31.2022.10.27.04.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 04:24:42 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] net: broadcom: bcm4908_enet: update TX stats after actual transmission
Date:   Thu, 27 Oct 2022 13:24:30 +0200
Message-Id: <20221027112430.8696-1-zajec5@gmail.com>
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

Queueing packets doesn't guarantee their transmission. Update TX stats
after hardware confirms consuming submitted data.

This also fixes a possible race and NULL dereference.
bcm4908_enet_start_xmit() could try to access skb after freeing it in
the bcm4908_enet_poll_tx().

Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This fixes a potential NULL dereference. It was never seen in real usage
though. I'm not sure if it makes this net-next or net material.
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index ca8c86ee44c0..b0aac0bcb060 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -571,8 +571,6 @@ static netdev_tx_t bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_devic
 
 	if (++ring->write_idx == ring->length - 1)
 		ring->write_idx = 0;
-	enet->netdev->stats.tx_bytes += skb->len;
-	enet->netdev->stats.tx_packets++;
 
 	return NETDEV_TX_OK;
 }
@@ -654,6 +652,7 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 	struct bcm4908_enet_dma_ring_bd *buf_desc;
 	struct bcm4908_enet_dma_ring_slot *slot;
 	struct device *dev = enet->dev;
+	unsigned int bytes = 0;
 	int handled = 0;
 
 	while (handled < weight && tx_ring->read_idx != tx_ring->write_idx) {
@@ -664,12 +663,17 @@ static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
 
 		dma_unmap_single(dev, slot->dma_addr, slot->len, DMA_TO_DEVICE);
 		dev_kfree_skb(slot->skb);
-		if (++tx_ring->read_idx == tx_ring->length)
-			tx_ring->read_idx = 0;
 
 		handled++;
+		bytes += slot->len;
+
+		if (++tx_ring->read_idx == tx_ring->length)
+			tx_ring->read_idx = 0;
 	}
 
+	enet->netdev->stats.tx_packets += handled;
+	enet->netdev->stats.tx_bytes += bytes;
+
 	if (handled < weight) {
 		napi_complete_done(napi, handled);
 		bcm4908_enet_dma_ring_intrs_on(enet, tx_ring);
-- 
2.34.1

