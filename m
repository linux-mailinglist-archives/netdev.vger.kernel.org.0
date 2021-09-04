Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F57400A41
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 09:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhIDHft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 03:35:49 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:22369 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbhIDHfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 03:35:48 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d51 with ME
        id pjaj2500L3riaq203jaj5z; Sat, 04 Sep 2021 09:34:45 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 04 Sep 2021 09:34:45 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, skori@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] octeontx2-af: Add a 'rvu_free_bitmap()' function
Date:   Sat,  4 Sep 2021 09:34:41 +0200
Message-Id: <37f3e7e21a1c0f29244b807e5b995b2abeec6c3e.1630738450.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to match 'rvu_alloc_bitmap()', add a 'rvu_free_bitmap()' function

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 5 +++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 72de4eca6f67..35836903b7fb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -211,6 +211,11 @@ int rvu_alloc_bitmap(struct rsrc_bmap *rsrc)
 	return 0;
 }
 
+void rvu_free_bitmap(struct rsrc_bmap *rsrc)
+{
+	kfree(rsrc->bmap);
+}
+
 /* Get block LF's HW index from a PF_FUNC's block slot number */
 int rvu_get_lf(struct rvu *rvu, struct rvu_block *block, u16 pcifunc, u16 slot)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index d38e5c980c30..1d9411232f1d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -638,6 +638,7 @@ static inline bool is_rvu_fwdata_valid(struct rvu *rvu)
 }
 
 int rvu_alloc_bitmap(struct rsrc_bmap *rsrc);
+void rvu_free_bitmap(struct rsrc_bmap *rsrc);
 int rvu_alloc_rsrc(struct rsrc_bmap *rsrc);
 void rvu_free_rsrc(struct rsrc_bmap *rsrc, int id);
 bool is_rsrc_free(struct rsrc_bmap *rsrc, int id);
-- 
2.30.2

