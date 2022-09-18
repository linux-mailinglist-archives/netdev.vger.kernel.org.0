Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59315BC034
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 23:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIRVzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 17:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIRVzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 17:55:39 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC84C13D67;
        Sun, 18 Sep 2022 14:55:38 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id c6so20662636qvn.6;
        Sun, 18 Sep 2022 14:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=z0B/eW5XdmdQCHytKnRy9T9V8L1fTqHGR2VXSGfuq4I=;
        b=ltK6KC15zGQUC9Lw70LjnFqZjNPrfIX+TMuW8tMBmsHN7UPzHasBO5dW87D7S893S3
         LlsUUANfPgJVqKjn4vzrR2JILxzqawVFobYr7CB9LWDiT+2Dg7Hv9e8PctQ5/ZsXQwmt
         Li53kzoT/jeRa5eO9FrILsRSHLT7l/zNiQa7AFKG+lRsJXoJY+MsTLSpGKF3fhy7RKdA
         vh8fYiKPWq9zddTHUfx8Dh9K/I9H0yJMC1vxxED3U0/ub8D+DF5LsJSYaD4T3kzplrJV
         Bb542dZOZj8a/1THY+orbiASDoVbDbhDrJWoXcugsoiOtsTCIgYMJtq9azU3dUGfY2S+
         yxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=z0B/eW5XdmdQCHytKnRy9T9V8L1fTqHGR2VXSGfuq4I=;
        b=qbf1RsHjmFxnrQB/HVpTLW52G+9Xzb66G3FS4rfI+b4HgAYZeuRwtKFxq9Lxqis2XJ
         aeh16+j6ua7MqEg8P9gM9saidtMkra7EZMrK0Pk2W4FoBQQYkQEWuds6C7chu1nin1QV
         WygZXcqujDrGMMRH9VC0gNI4QnPYQlQzkwMhfKjc2hmvMQNv14LTPcwD0l262UAgccH8
         p1bdDVbNoSgpL9Nzagj2HduF75nM28ThkBwr1274Xlpg+Re4oB1ggoarOY6z7DTE+fqn
         IWD7j/jZefvEOwtEItb4E3caknPsptozfKf9FA1oKkwsOz8uP1xAdGuVQJW33CTXLAkZ
         Kdwg==
X-Gm-Message-State: ACrzQf1W+kgl0xaOxcyeIZI6e7tjIIczcniPHPyEJBwcvZmD6ER7Wdra
        ruZkuvNKJwiQZuAs0/aToAN8uwm4FmUJOw==
X-Google-Smtp-Source: AMsMyM57YmEW/05lyG/l5PA9erb2kucmW8I4oaTxFKfSvMsUHJUPv3Rtt+rAVdXLWC5/oRvStPNaug==
X-Received: by 2002:a05:6214:519e:b0:4ad:25c4:cb21 with SMTP id kl30-20020a056214519e00b004ad25c4cb21mr6175544qvb.41.1663538137919;
        Sun, 18 Sep 2022 14:55:37 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id j15-20020a05620a410f00b006b5df4d2c81sm12100134qko.94.2022.09.18.14.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 14:55:37 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Nick Bowler <nbowler@draconx.ca>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH] net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD
Date:   Sun, 18 Sep 2022 17:55:34 -0400
Message-Id: <20220918215534.1529108-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
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

There is a separate receive path for small packets (under 256 bytes).
Instead of allocating a new dma-capable skb to be used for the next packet,
this path allocates a skb and copies the data into it (reusing the existing
sbk for the next packet). There are two bytes of junk data at the beginning
of every packet. I believe these are inserted in order to allow aligned
DMA and IP headers. We skip over them using skb_reserve. Before copying
over the data, we must use a barrier to ensure we see the whole packet. The
current code only synchronizes len bytes, starting from the beginning of
the packet, including the junk bytes. However, this leaves off the final
two bytes in the packet. Synchronize the whole packet.

To reproduce this problem, ping a HME with a payload size between 17 and 214

	$ ping -s 17 <hme_address>

which will complain rather loudly about the data mismatch. Small packets
(below 60 bytes on the wire) do not have this issue. I suspect this is
related to the padding added to increase the minimum packet size.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Patch-prefix: net
---

 drivers/net/ethernet/sun/sunhme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 8594ee839628..88aa0d310aee 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2020,9 +2020,9 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 
 			skb_reserve(copy_skb, 2);
 			skb_put(copy_skb, len);
-			dma_sync_single_for_cpu(hp->dma_dev, dma_addr, len, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(hp->dma_dev, dma_addr, len + 2, DMA_FROM_DEVICE);
 			skb_copy_from_linear_data(skb, copy_skb->data, len);
-			dma_sync_single_for_device(hp->dma_dev, dma_addr, len, DMA_FROM_DEVICE);
+			dma_sync_single_for_device(hp->dma_dev, dma_addr, len + 2, DMA_FROM_DEVICE);
 			/* Reuse original ring buffer. */
 			hme_write_rxd(hp, this,
 				      (RXFLAG_OWN|((RX_BUF_ALLOC_SIZE-RX_OFFSET)<<16)),
-- 
2.37.1

