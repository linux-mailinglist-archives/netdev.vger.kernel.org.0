Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028E45BF186
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiITXu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiITXuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:50:25 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04F22E9DC;
        Tue, 20 Sep 2022 16:50:23 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id c6so3277883qvn.6;
        Tue, 20 Sep 2022 16:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WvtuIC2+7UN+fsO1GntQ4dE7hCbVNiKYWo69DvPZRd0=;
        b=Dx42PJJUwrlyYFbJdex7467PazS9KGMhPITrZNJzBcVmyZHKWnMXiiwvjrXJHY1Kj+
         J+zL5FfP8BNnwrPN5XHeQrMbGrVAaLCmQlaeMfbQnX+ybXPbJ3OaT1e/5rUMc+VwH959
         5jOmSPtok1i6ftZ3OJUKqakrNirwWjHep6g/iR23+mTGEdZGR7elJ6Y0peHsgUjij5Ko
         c0+Mfvi5zOc3VTQa0Nqdbkx2L9y4/MCBNJ2xeR7E+1L8UOlPw6wZJtUVtf+ND1P2Zc5I
         +Uq1gXA1awz4RMHMASeNEPJCnyNIQKA2bYhucxuU++EBe8DQfPWgKv4hoZTWQygVtAn5
         /ulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WvtuIC2+7UN+fsO1GntQ4dE7hCbVNiKYWo69DvPZRd0=;
        b=BWPMzw1yHnjjrh5DXjFh9/wa5TFPIRGqkAFabPIJWrKMZS+r1y1wpSDD4NVhVThEFU
         r09TTaHvjao0MXiDJbNi9ViZ4fxT+iUUQs4glYlBAWo9pm/i47NNWif16dWK5Ntiu1xx
         4QE7cOZpOBDa25NAMsZdzc4NY1CgcrgkKPN2a1ZEt1p7pD5r89LxKuDXknp2AqkD3UmN
         MSyOGVCMJqGpfKDvyOdgHJ0oSOvU0bMxA3D3Ol50B5VvfX/AmzhQdERCp5L5D9jfdZXB
         1ctb17+bKvTmmQOrOqRiJ90FnHXaRe9ATfK042YnxHF5tqxcwBx19ZIdB/T91tdTk0j9
         Xe9A==
X-Gm-Message-State: ACrzQf02BAmMUNZyK2Qk+aNOBMamo55wpKw+knB5K9BNckZ1WuWqvNhn
        ySsPWjXZ9J90wJpwmpmfyGs=
X-Google-Smtp-Source: AMsMyM6z06rla6uLCee8sOPjMiOXLd1W9jUBBIsYwltKTar58D9TgH85MPasBFj1ae+iac1+B+gshg==
X-Received: by 2002:a05:6214:2303:b0:4ad:58f2:7ca4 with SMTP id gc3-20020a056214230300b004ad58f27ca4mr5207138qvb.89.1663717822500;
        Tue, 20 Sep 2022 16:50:22 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id o13-20020a05620a2a0d00b006baef6daa45sm806039qkp.119.2022.09.20.16.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 16:50:21 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        Sean Anderson <seanga2@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net v2] net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD
Date:   Tue, 20 Sep 2022 19:50:18 -0400
Message-Id: <20220920235018.1675956-1-seanga2@gmail.com>
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
of every packet. I believe these are inserted in order to allow aligned DMA
and IP headers. We skip over them using skb_reserve. Before copying over
the data, we must use a barrier to ensure we see the whole packet. The
current code only synchronizes len bytes, starting from the beginning of
the packet, including the junk bytes. However, this leaves off the final
two bytes in the packet. Synchronize the whole packet.

To reproduce this problem, ping a HME with a payload size between 17 and
214

	$ ping -s 17 <hme_address>

which will complain rather loudly about the data mismatch. Small packets
(below 60 bytes on the wire) do not have this issue. I suspect this is
related to the padding added to increase the minimum packet size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

Changes in v2:
- Add Fixes tag

 drivers/net/ethernet/sun/sunhme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1921054b7f7d..e660902cfdf7 100644
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

