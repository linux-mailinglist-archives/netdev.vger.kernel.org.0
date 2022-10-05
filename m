Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7490D5F542C
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 14:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJEMFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 08:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiJEMFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 08:05:13 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44CB29352
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 05:05:11 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 130-20020a1c0288000000b003b494ffc00bso934113wmc.0
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 05:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LRX7GpLdgFvRfe1C5DKcxd/ZrRqJlQC6DhuQ385RIqQ=;
        b=wY/qUjaA3apGo0Gn3YoQSlP+i/rJrR6NFQzrjw3Ks9dgh1lZdAbtAA02eY3deSRwJu
         YwX3UF9uJO+wgUbNA/sCaSgvKK1/8+rkenZVDL/cSEtKA9loqiZ8YM8qUm4p7Y1Jst7K
         mhw/UWardrSVYcqSH5GO2QtYAsEKAmcHgiaZ05pGz0vclD0jBFb/svUHz3Yc1SSUYJVt
         Q8iQjM4gmHtH72gcm4ukqE5qjDpBHpF1NUK3xlW0QddylLtLK13WG/BB/fjJZOXYfuFr
         rknTWHsL7IpSCfhU+IadnVmo0CAecCa2pXlSHqQxXeqJIZBdGgvODgxR97aXBxJsQjhM
         kHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LRX7GpLdgFvRfe1C5DKcxd/ZrRqJlQC6DhuQ385RIqQ=;
        b=UHftdz+H3im7Sq0VsqE8y7sQoE+KRWKs+NoduK2rguEcY13UauxKfwTclKy2oQAKeN
         NFKZcEOo46yldRroI26rPE0pOeeUe4OsTLsz+uGZGr2jjBEvTDPizQG5cIYMp6aTgR35
         lc6r0Ccl17f2kwOb7yXO0lCpgvYlkLqPezokqXgBc/koGft6huO3x0+4gp8TjXSq9ZXV
         R4gBdrqXtLfweB9FvEDmPkCtIM9kVSINryoCICqw65wrPmAarkthR0OgfrrdLK6E6Ilt
         XGQDkBBVPl62jaLBP33q4O45JPFW+xjrEKXAq1+jZkZOz6HQyQjdxLnp7SQFIXwVGzMd
         THHA==
X-Gm-Message-State: ACrzQf0x2ugo28LNlpGQ9N4alTvBmYS0CvjhyS0xiaD2+XE0jnkgOBjz
        U3TTnwXyM8Zl7v75Q3zY9j6WWw==
X-Google-Smtp-Source: AMsMyM7Yk3vdlh17NVAK2oPOvU3tuGQHb5qFBVbuApIzXz+EL8rx7HRn0PP3bIYV5aleBURRZ57r2Q==
X-Received: by 2002:a05:600c:1c19:b0:3b4:c1cb:d46d with SMTP id j25-20020a05600c1c1900b003b4c1cbd46dmr3055730wms.172.1664971510379;
        Wed, 05 Oct 2022 05:05:10 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v16-20020a5d6790000000b0022e3e7813f0sm7799583wru.107.2022.10.05.05.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 05:05:10 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, edumazet@google.com, khalasa@piap.pl,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 4/4] net: ethernet: xscale: fix easy remaining style issues
Date:   Wed,  5 Oct 2022 12:05:01 +0000
Message-Id: <20221005120501.3527435-4-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221005120501.3527435-1-clabbe@baylibre.com>
References: <20221005120501.3527435-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix all easy remaining styles issues.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 11e5c00f638d..f3732b67cc44 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -356,8 +356,7 @@ static void ixp_tx_timestamp(struct port *port, struct sk_buff *skb)
 
 	regs = port->timesync_regs;
 
-	/*
-	 * This really stinks, but we have to poll for the Tx time stamp.
+	/* This really stinks, but we have to poll for the Tx time stamp.
 	 * Usually, the time stamp is ready after 4 to 6 microseconds.
 	 */
 	for (cnt = 0; cnt < 100; cnt++) {
@@ -653,7 +652,8 @@ static inline void queue_put_desc(unsigned int queue, u32 phys,
 	BUG_ON(phys & 0x1F);
 	qmgr_put_entry(queue, phys);
 	/* Don't check for queue overflow here, we've allocated sufficient
-	   length and queues >= 32 don't support this check anyway. */
+	 * length and queues >= 32 don't support this check anyway.
+	 */
 }
 
 static inline void dma_unmap_tx(struct port *port, struct desc *desc)
@@ -893,7 +893,8 @@ static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	port->tx_buff_tab[n] = mem;
 #endif
 	desc->data = phys + offset;
-	desc->buf_len = desc->pkt_len = len;
+	desc->buf_len = len;
+	desc->pkt_len = len;
 
 	/* NPE firmware pads short frames with zeros internally */
 	wmb();
@@ -941,7 +942,7 @@ static void eth_set_mcast_list(struct net_device *dev)
 			__raw_writel(allmulti[i], &port->regs->mcast_mask[i]);
 		}
 		__raw_writel(DEFAULT_RX_CNTRL0 | RX_CNTRL0_ADDR_FLTR_EN,
-			&port->regs->rx_control[0]);
+			     &port->regs->rx_control[0]);
 		return;
 	}
 
@@ -1321,7 +1322,8 @@ static int eth_close(struct net_device *dev)
 			BUG_ON(n < 0);
 			desc = tx_desc_ptr(port, n);
 			phys = tx_desc_phys(port, n);
-			desc->buf_len = desc->pkt_len = 1;
+			desc->buf_len = 1;
+			desc->pkt_len = 1;
 			wmb();
 			queue_put_desc(TX_QUEUE(port->id), phys, desc);
 		}
-- 
2.35.1

