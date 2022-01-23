Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1383549749D
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239826AbiAWSmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240000AbiAWSl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:41:29 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4D5C06175E;
        Sun, 23 Jan 2022 10:41:28 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i65so13770076pfc.9;
        Sun, 23 Jan 2022 10:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Tg3yHCkGPkAs3t0HGnkJ3DADYUey/EkpuaonLgL/k1o=;
        b=ZFcRyIgejcwmVsRn9uACTkHbRFP1Zze98Yat48GCTiBhpRFGqV+EhNdjoptDiSuBV/
         dvj3ZuDs5x5zOqKJGz4dgUg/bpE7jIhKYWqsuGU8JohMUazDatArKO78k8OfS62hFbG7
         br07lUuskKVknb0qnOkcuQVxKJYz1MBJd4cJVIM0s3WCFCfUeyiLOatWKIvsI6pfk5/T
         D2em8N9PllFscT+6kUGr5skgotgtYRkpFEWyJmcfc3e77qXEOa+gQQ7yVKK5Cl1RW8+x
         H0YkTgJ/FjQ9h7YkPpnNjVdec9Fku25OI8swrUzmnquB2L1IOslvsbuGo+AIYfCvzb6w
         SI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tg3yHCkGPkAs3t0HGnkJ3DADYUey/EkpuaonLgL/k1o=;
        b=eEk1sT4NPRyUc2MQjEJSq/uhR5hiEJya0+X/UWYDQTIJxgLvtWzVNjqH4X5VAy/1NW
         OA8X+KjCgnVYdzuUPe4NL9lMqV1yaX6Yhvh7TZMORLvtZSrEVPC25BIx936KdS5mUpKr
         9jrhx51MeQQGn6r0KHknU+AZ2oDo2HObqS+7OjhCdl76es6cYGncFBl4oDuMLXng4DfP
         tP721J5jZiTE6/4eiQu0CB9ABf7ulu85XKQ8fFrmP+ITCMrx0l5a4ltGca+XJ/PuZMSo
         /lh2nCiQlvUUicbYgcavSD2HakUczRABl4D139pctLfwqpBz/ETwGRfiVgpQ9cj2fpZk
         IugA==
X-Gm-Message-State: AOAM530h5gytmOc5mV4wd668shTbAemMjjoC3PvKASXSuhN96XKV36z4
        p+bXl9PQt/c3IezO0y8ylKI=
X-Google-Smtp-Source: ABdhPJwoTvblvEg2tP4VBIJgYaJdRCS2zp7p/0njGw/SToaljAppp3HKkW/FWj7H2WQKfitLPsuBKQ==
X-Received: by 2002:a05:6a00:1795:b0:4c1:e2f6:d0c8 with SMTP id s21-20020a056a00179500b004c1e2f6d0c8mr10981596pfg.47.1642963288396;
        Sun, 23 Jan 2022 10:41:28 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id mg17sm11154423pjb.19.2022.01.23.10.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:41:28 -0800 (PST)
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
Subject: [PATCH 32/54] net: ethernet: replace bitmap_weight with bitmap_weight_{eq,gt} for OcteonTX2
Date:   Sun, 23 Jan 2022 10:39:03 -0800
Message-Id: <20220123183925.1052919-33-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OcteonTX2 code calls bitmap_weight() to compare the weight of bitmap with
a given number. We can do it more efficiently with bitmap_weight_{eq,gt}
because conditional bitmap_weight may stop traversing the bitmap earlier,
as soon as condition is met.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index d85db90632d6..a55fd1d0c653 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -287,7 +287,7 @@ static int otx2_set_channels(struct net_device *dev,
 	if (!channel->rx_count || !channel->tx_count)
 		return -EINVAL;
 
-	if (bitmap_weight(&pfvf->rq_bmap, pfvf->hw.rx_queues) > 1) {
+	if (bitmap_weight_gt(&pfvf->rq_bmap, pfvf->hw.rx_queues, 1)) {
 		netdev_err(dev,
 			   "Receive queues are in use by TC police action\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 80b2d64b4136..55c899a6fcdd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -1170,8 +1170,8 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
 		 * interface mac address and configure CGX/RPM block in
 		 * promiscuous mode
 		 */
-		if (bitmap_weight(&flow_cfg->dmacflt_bmap,
-				  flow_cfg->dmacflt_max_flows) == 1)
+		if (bitmap_weight_eq(&flow_cfg->dmacflt_bmap,
+				     flow_cfg->dmacflt_max_flows, 1))
 			otx2_update_rem_pfmac(pfvf, DMAC_ADDR_DEL);
 	} else {
 		err = otx2_remove_flow_msg(pfvf, flow->entry, false);
-- 
2.30.2

