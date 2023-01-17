Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8545366D9E6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbjAQJ2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbjAQJ1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:27:49 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A2C2B0A8;
        Tue, 17 Jan 2023 01:26:08 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so7616037wmc.1;
        Tue, 17 Jan 2023 01:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuCStn9V5oARcXzlZlnENM3b/8Cc1xy/rZz8yfu4umE=;
        b=PJn4IsJGWNquOVoX8uL9scHqVHfzRajzDZEFkK2LdugQseNexbc8pSDFCYwDMLZheg
         Ym7No27ExKWVxoYMOHV2mm9v/bDZrw5umNjsVYLgyhFxg7+e6JO1laoSJFDmZCzjmSKB
         CON13JslubqUQEOxvaKDycXJmc1jjyOqlhfMdEqdoTHUNvXDoO6d2Q3kFwm5qedk2Z+V
         RMs58griQ0c7us6XdvdFYvp0Hmx6Ux5C7rpBM/NIrFhl214Pe9ew9VBvgh2SLGZntBaB
         fqx0XtwcClTYJ3emRj6LZxHQzDYv1zozQndy9bSG4DNs/aMAZ89Srt1O3tggxu1meLEU
         7Ytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xuCStn9V5oARcXzlZlnENM3b/8Cc1xy/rZz8yfu4umE=;
        b=AUMcyYkZzKofBccGybzQs3eBbHGZGvHN9cQVIwRZPC5cJhu+9FM/wrUrH8RX2fBfk0
         w2P+uS5/FAxujdLcsEepZ4Ax4XgvESGhxzbrCUOBYFRmOXZWeUFNG/7Ce58SI9BLSOjR
         MvX6pypqV0XRklDslMxG2qu7RUX0vARWWk6c8Dkp6T+/fXkmI/GkG+uwO/5/TwzzC6UJ
         8/TQ+sqkOK32aHCWlGcwRHXN4EaOexWtTXmUeNaNc2yAyErhffJ17X51rbX21ep7g6qL
         YhuZE+aZl4BxILF8jxzmGnQPdWRQnPj0A/XlxfK5ss311r2D0DOEmFfJlyCeR6acWYX5
         t5VA==
X-Gm-Message-State: AFqh2koc61pEsr0IF6AlVtM/i/2ghjuEJihyvp/yJVoIFqxfOd/v6Bh3
        a9B+RmJcuWhVeZaIsCuPEdg=
X-Google-Smtp-Source: AMrXdXvDjoxt129uWZFHqLVwl/vcOBXNnnJ3Rjx+QizZos3M3OWWOqB8EhGi1c311sBxHjDl+rkofw==
X-Received: by 2002:a05:600c:b54:b0:3c6:e60f:3f6f with SMTP id k20-20020a05600c0b5400b003c6e60f3f6fmr2283961wmr.38.1673947568043;
        Tue, 17 Jan 2023 01:26:08 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id u21-20020a7bc055000000b003d9aa76dc6asm48008881wmc.0.2023.01.17.01.26.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2023 01:26:07 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH net 5/5] dpaa2-eth: execute xdp_do_flush() before napi_complete_done()
Date:   Tue, 17 Jan 2023 10:25:33 +0100
Message-Id: <20230117092533.5804-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117092533.5804-1-magnus.karlsson@gmail.com>
References: <20230117092533.5804-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be follwed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found following the first link below.

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in the second link below.

Fixes: d678be1dc1ec ("dpaa2-eth: add XDP_REDIRECT support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0c35abb7d065..2e79d18fc3c7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1993,10 +1993,15 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		if (rx_cleaned >= budget ||
 		    txconf_cleaned >= DPAA2_ETH_TXCONF_PER_NAPI) {
 			work_done = budget;
+			if (ch->xdp.res & XDP_REDIRECT)
+				xdp_do_flush();
 			goto out;
 		}
 	} while (store_cleaned);
 
+	if (ch->xdp.res & XDP_REDIRECT)
+		xdp_do_flush();
+
 	/* Update NET DIM with the values for this CDAN */
 	dpaa2_io_update_net_dim(ch->dpio, ch->stats.frames_per_cdan,
 				ch->stats.bytes_per_cdan);
@@ -2032,9 +2037,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		txc_fq->dq_bytes = 0;
 	}
 
-	if (ch->xdp.res & XDP_REDIRECT)
-		xdp_do_flush_map();
-	else if (rx_cleaned && ch->xdp.res & XDP_TX)
+	if (rx_cleaned && ch->xdp.res & XDP_TX)
 		dpaa2_eth_xdp_tx_flush(priv, ch, &priv->fq[flowid]);
 
 	return work_done;
-- 
2.34.1

