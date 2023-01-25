Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4C667AB34
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbjAYHtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbjAYHtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:49:22 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A3C4A1D7;
        Tue, 24 Jan 2023 23:49:21 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id j17so13107029wms.0;
        Tue, 24 Jan 2023 23:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wAglRLnbjA0GGYZd+Aa3Wz2YLS4ZzTlHhnzDb35wOY=;
        b=gFSKzeU5MBc7Jjp8JqZwhCje/VmhWMFRYBmMFP61AqJAbghIFyMHYYJ/uWmfn9rxa0
         adQBxiNWRUz70ySJp+xYrDx4NO+UZHbKIYm4jpdmKQFlWWHBMQqd1xeCNAnx8kqSvzB7
         jF0UvBuRaH1gkz0Pvx5brUInnmTTpbT+IN4UuO8duD9Iu+fnFAT0tO9TmHWwRU8XTb8g
         aXFKUyCxxs/2SCx7j35HLjd4FTT+miNGblqXGDDToqFFVch1Q5PTV3EACDeBiib2e4ep
         m6cgs37yg5Xs+yt3+C4uZ06KUvYvIFgI4kIlx2WfI1iS0Hn1M/QF4+A+AYd0w8/9Kf7N
         KNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0wAglRLnbjA0GGYZd+Aa3Wz2YLS4ZzTlHhnzDb35wOY=;
        b=SbSeYeSsaMA0ludrB7fb3+FMf6sx0Jl0Uifz2+HGwpGvQhNGC0iW0P6jvR3uNtxdlp
         xYbaAsS4IjRO0EdeuYowc3TmBFFlhQWiUOKEN3/DvbuFrXsdCYzp8tKOdUlHkMJWJcGW
         UAwenv9Ce1dmwm3rB1zxT28ogr7f1CniaNU1CUuGhsgrgf8Ja+13bChUE+p7FluqfI9t
         2ng98QoTr6CF7hNaPLrTG/2InWoXZPfajHmmY5JNbANdzaG1xopRj1PCDKCvwxREuyDT
         BeLXJKtrKML8QF9D+00HRZU+PYhzdPq/z8ZSERM6sxY4PGlq+7w6gvWxuHolAdUHMp99
         k1aw==
X-Gm-Message-State: AFqh2kqpcymLoIIr8dEYO+vykR5Qk6F98Bw75/HRyRaXa+36u1BI8cBC
        +EELDG+pIYQJdmn/CnMt8E8=
X-Google-Smtp-Source: AMrXdXvL2NOvrRkDpOrzbG9gYDVxdt0ZEqgut4lt6hzDdZyC39SJAIByD5LYIga/xz1SxgDIy6X0tQ==
X-Received: by 2002:a05:600c:2d0b:b0:3da:fcf0:a31d with SMTP id x11-20020a05600c2d0b00b003dafcf0a31dmr30803951wmf.22.1674632959324;
        Tue, 24 Jan 2023 23:49:19 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id n13-20020a05600c500d00b003db2b81660esm1032051wmr.21.2023.01.24.23.49.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:49:18 -0800 (PST)
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
Subject: [PATCH net v2 4/5] dpaa_eth: execute xdp_do_flush() before napi_complete_done()
Date:   Wed, 25 Jan 2023 08:49:00 +0100
Message-Id: <20230125074901.2737-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125074901.2737-1-magnus.karlsson@gmail.com>
References: <20230125074901.2737-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
napi context X on CPU Y will be followed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found following the first link below.

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in the second link below.

Fixes: a1e031ffb422 ("dpaa_eth: add XDP_REDIRECT support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 3f8032947d86..027fff9f7db0 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2410,6 +2410,9 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 
 	cleaned = qman_p_poll_dqrr(np->p, budget);
 
+	if (np->xdp_act & XDP_REDIRECT)
+		xdp_do_flush();
+
 	if (cleaned < budget) {
 		napi_complete_done(napi, cleaned);
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
@@ -2417,9 +2420,6 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
 	}
 
-	if (np->xdp_act & XDP_REDIRECT)
-		xdp_do_flush();
-
 	return cleaned;
 }
 
-- 
2.34.1

