Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF4A497470
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbiAWSkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239692AbiAWSkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:40:17 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28765C06173B;
        Sun, 23 Jan 2022 10:40:17 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a8so8429996pfa.6;
        Sun, 23 Jan 2022 10:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=p8QTRt3d7sePwL1Za7J+vXKVGF1Vcf9Dz8ECUX4YRaU=;
        b=kSGsBEjEhAy4ULYE8qToeMFrZ5GiZfr/HXBxXdnWrnJkuneYffzb9IfBYrjnabzgmu
         bQWPkMXab2fQ9EaV1nt5r+U8sE7GzTGBRdbOtiVhKrZ5XSK3W8jCWLhKf4M3tPPenrQd
         f4qF3ZUi/P6ID4y0yDSX8V35SSSCglIvWzd+uyYOcyv6zuzWmX6lnFpmfHASEgBqUQXd
         1TUUPspx0Zbc1LlTY26uxgvmldx+2g/XNHHVQvBYvM+BDv3yt/SpDeOES8VpXQTsh1jW
         SHrKxQd+6ZQ0sDVq0B2fdCtaUfTjmagsqen6Tg/u4mKxbGYE411kjF8umErW0yq0NpVM
         6YYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p8QTRt3d7sePwL1Za7J+vXKVGF1Vcf9Dz8ECUX4YRaU=;
        b=AbybGlsdA+Pxtuk5v5cqR3vcMUlXQjxLD6ShnS54+uZ5kD8Khu8u63llbljz88azmg
         W94u6+sKBnF/K/gjZWMXCMM9/ex2j7XT7qL4WdXvcMTjU9dtfykvzExyYeYiWvvrtZ5w
         JpEySH+v8q4IOTYV2OF6Fk6cLWlZkrg2PFXbfRzeD51YMUfzJhwmoYWoD1v8rT6YEN3i
         oELCrnV8MuEBMDxH8IrtplxN43B4ls9JPp/IsWP+1tS4+rZGf6PXU4mAXVQ+Rbh19maU
         +4GanVa+17U++1ZkN/IG7HwRwDxXyTVCGOBqMrp2j0n6EAK3yaYD01z8B22xsEdJVovv
         +6WA==
X-Gm-Message-State: AOAM530d+Qohfnxie3fpmO1VIAk/X1PGJ/KwFXZtPmarfu3wrVNys5N1
        nuvv6N7SB8dnaqAMTQ/Gxn8=
X-Google-Smtp-Source: ABdhPJxPEJs66727LmyAS5olRhoXIbWw8yvPTo3V487TVxqjG3bhda6a1xhG1HMlracKriT/z0m5AQ==
X-Received: by 2002:a63:7251:: with SMTP id c17mr7591981pgn.579.1642963216638;
        Sun, 23 Jan 2022 10:40:16 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id mh11sm11502854pjb.3.2022.01.23.10.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:40:16 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 09/54] net: ethernet: replace bitmap_weight with bitmap_empty for Marvell
Date:   Sun, 23 Jan 2022 10:38:40 -0800
Message-Id: <20220123183925.1052919-10-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some places, octeontx2 code calls bitmap_weight() to check if any bit of
a given bitmap is set. It's better to use bitmap_empty() in that case
because bitmap_empty() stops traversing the bitmap as soon as it finds
first set bit, while bitmap_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 77a13fb555fb..80b2d64b4136 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -353,7 +353,7 @@ int otx2_add_macfilter(struct net_device *netdev, const u8 *mac)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 
-	if (bitmap_weight(&pf->flow_cfg->dmacflt_bmap,
+	if (!bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
 			  pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(netdev,
 			    "Add %pM to CGX/RPM DMAC filters list as well\n",
@@ -436,7 +436,7 @@ int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
 		return 0;
 
 	if (flow_cfg->nr_flows == flow_cfg->max_flows ||
-	    bitmap_weight(&flow_cfg->dmacflt_bmap,
+	    !bitmap_empty(&flow_cfg->dmacflt_bmap,
 			  flow_cfg->dmacflt_max_flows))
 		return flow_cfg->max_flows + flow_cfg->dmacflt_max_flows;
 	else
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6080ebd9bd94..3d369ccc7ab9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1115,7 +1115,7 @@ static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
 	struct msg_req *msg;
 	int err;
 
-	if (enable && bitmap_weight(&pf->flow_cfg->dmacflt_bmap,
+	if (enable && !bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
 				    pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(pf->netdev,
 			    "CGX/RPM internal loopback might not work as DMAC filters are active\n");
-- 
2.30.2

