Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C9023573E
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgHBNxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:53:52 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:25227 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgHBNxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 09:53:52 -0400
Received: from localhost.localdomain ([93.22.148.198])
        by mwinf5d42 with ME
        id Adtq230054H42jh03dtqkR; Sun, 02 Aug 2020 15:53:51 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 02 Aug 2020 15:53:51 +0200
X-ME-IP: 93.22.148.198
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kou.ishizaki@toshiba.co.jp, davem@davemloft.net, kuba@kernel.org,
        linas@austin.ibm.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] net: spider_net: Remove a useless memset
Date:   Sun,  2 Aug 2020 15:53:48 +0200
Message-Id: <20200802135348.691046-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a memset after a call to 'dma_alloc_coherent()'.
This is useless since
commit 518a2f1925c3 ("dma-mapping: zero memory returned from dma_alloc_*")

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
NOT compile tested, because I don't have the configuration for that
---
 drivers/net/ethernet/toshiba/spider_net.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 2d61400144a2..e1a2057fbf21 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -314,8 +314,6 @@ spider_net_init_chain(struct spider_net_card *card,
 	if (!chain->hwring)
 		return -ENOMEM;
 
-	memset(chain->ring, 0, chain->num_desc * sizeof(struct spider_net_descr));
-
 	/* Set up the hardware pointers in each descriptor */
 	descr = chain->ring;
 	hwdescr = chain->hwring;
-- 
2.25.1

