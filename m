Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A922510FF
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 06:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgHYE5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 00:57:23 -0400
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:45648 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728043AbgHYE5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 00:57:16 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 57804837F24D;
        Tue, 25 Aug 2020 04:57:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1311:1314:1345:1359:1515:1534:1541:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3351:3868:4321:4385:5007:6119:6261:10004:10848:11026:11473:11657:11658:11914:12043:12296:12297:12555:12895:12986:13069:13311:13357:13894:14096:14181:14384:14394:14721:21080:21627:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: rings03_320fcc527059
X-Filterd-Recvd-Size: 1890
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 04:57:13 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/29] fs_enet: Avoid comma separated statements
Date:   Mon, 24 Aug 2020 21:56:14 -0700
Message-Id: <418850ae2026b293ea6ba3b8b19b8a7f8dfcaf3d.1598331149.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1598331148.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use semicolons and braces.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index bf846b42bc74..78e008b81374 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -562,10 +562,13 @@ fs_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			BD_ENET_TX_TC);
 		CBDS_SC(bdp, BD_ENET_TX_READY);
 
-		if ((CBDR_SC(bdp) & BD_ENET_TX_WRAP) == 0)
-			bdp++, curidx++;
-		else
-			bdp = fep->tx_bd_base, curidx = 0;
+		if ((CBDR_SC(bdp) & BD_ENET_TX_WRAP) == 0) {
+			bdp++;
+			curidx++;
+		} else {
+			bdp = fep->tx_bd_base;
+			curidx = 0;
+		}
 
 		len = skb_frag_size(frag);
 		CBDW_BUFADDR(bdp, skb_frag_dma_map(fep->dev, frag, 0, len,
-- 
2.26.0

