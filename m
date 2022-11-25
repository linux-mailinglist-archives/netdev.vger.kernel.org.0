Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507246389AC
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiKYMYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiKYMYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:24:19 -0500
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D2D4A59E
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:24:14 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id yXkRoPBKkY4XVyXkaoE21L; Fri, 25 Nov 2022 13:24:13 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 25 Nov 2022 13:24:13 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH 5/5] octeontx2-af: Simplify a size computation in rvu_npc_exact_init()
Date:   Fri, 25 Nov 2022 13:24:01 +0100
Message-Id: <5230dabe27f48948a9fd0f50a62e2437b65e6a6e.1669378798.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1669378798.git.christophe.jaillet@wanadoo.fr>
References: <cover.1669378798.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We know that table_size = table->mem_table.depth * table->mem_table.ways,
so use it instead, it is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index ae34746341c4..00aef8f5ac29 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1913,7 +1913,7 @@ int rvu_npc_exact_init(struct rvu *rvu)
 
 	dev_dbg(rvu->dev, "%s: Allocated bitmap for 32 entry cam\n", __func__);
 
-	table->tot_ids = (table->mem_table.depth * table->mem_table.ways) + table->cam_table.depth;
+	table->tot_ids = table_size + table->cam_table.depth;
 	table->id_bmap = devm_bitmap_zalloc(rvu->dev, table->tot_ids,
 					    GFP_KERNEL);
 
-- 
2.34.1

