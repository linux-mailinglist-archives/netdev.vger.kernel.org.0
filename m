Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE4B4B1931
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345468AbiBJXN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:13:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243041AbiBJXN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:13:58 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF2555A4;
        Thu, 10 Feb 2022 15:13:58 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id j12so7208355qtr.2;
        Thu, 10 Feb 2022 15:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7FL52FrXNIHTozrcS4UAHCYMPxTzl2RTxQeoy1tQzZU=;
        b=AGBuTbR1DDTmbip/u/WZx2mNt0jPGvuO3BycAp6q2VmWJ1XpinqhZGjzxMYykQs1+h
         9ZwK9nV2Hza30UOMDXrLFK15LOSULvD7ZjJxE9dsXejT1uWe+NyRJMgTaXeV1WmNgel9
         eLii97p7+4ojaqGef/1vF3/S8W8Rgtj6O0GJTl0T6A2RIPF7e9C9EPh0fpAZj0VOPEjo
         nwjqptD59NnDlqInCC5Xcz7zI6Zdwo+X80xnVSm9eNlJ/x+5G4Rsb0PAvF1FL5QnrdSm
         ZkZCUR0Del2ERA0vC9l/qhTmRfA93zM+A7aiM1dWPj88KXvNexP7raFIi+zqIMF7LFdx
         3osA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7FL52FrXNIHTozrcS4UAHCYMPxTzl2RTxQeoy1tQzZU=;
        b=roIilZ70b7b4OqHEr5LH/sdm2zdzv0llS/qx3vWCE0K5Q9r3vv0NaQoOtCTRaEDDcp
         MD4zKXl9cbFqiiSIcQsplDZB/8G7DdgX1g/qpecw0cyQHRmOsoHKZ/Wmn0QAz2l249DV
         tuRCi97OKpi9JeJFxCMVSrIulbqgB5mjbhWDQ9g7WSwIr5jkhTpqIIpnht0/Ix5b45ph
         Wg8Llp1KK6nyMAW3mk+nkTh/nw0B71xDLmCW6xB4943bAMKjSasGBk7rGbGGolXDsQH+
         xSpuq8cl+A8obCygamYOiRVJheSsmjFjy/oIPhKRZnLH5/r1MGfx9tzeCsro0kTabTXP
         Xlhw==
X-Gm-Message-State: AOAM532xIJDxukIp8LSDs4D3h68EkPIZ7NwbP+Th7W9KdVq/wPeorcHm
        7PpA8HcXgTZPxLPH5da9SVc=
X-Google-Smtp-Source: ABdhPJyziDNVK4gHlSQTL8oiGDJLo7w3dJcb5KZC+Jm81CQxXWEXD3+ANBnrP6vi6uDJfSyzoSW4VA==
X-Received: by 2002:ac8:7d16:: with SMTP id g22mr6640405qtb.180.1644534837689;
        Thu, 10 Feb 2022 15:13:57 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id u6sm10751221qki.136.2022.02.10.15.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:13:57 -0800 (PST)
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
Subject: [PATCH 10/49] octeontx2-pf: replace bitmap_weight with bitmap_empty where appropriate
Date:   Thu, 10 Feb 2022 14:48:54 -0800
Message-Id: <20220210224933.379149-11-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 86c1c2f77bd7..0f671df46694 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1120,7 +1120,7 @@ static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
 	struct msg_req *msg;
 	int err;
 
-	if (enable && bitmap_weight(&pf->flow_cfg->dmacflt_bmap,
+	if (enable && !bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
 				    pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(pf->netdev,
 			    "CGX/RPM internal loopback might not work as DMAC filters are active\n");
-- 
2.32.0

