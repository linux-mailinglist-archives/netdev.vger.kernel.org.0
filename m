Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27450A878B
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfIDN7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:59:23 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:39235 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730414AbfIDN7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:59:22 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id F3C8382181F; Wed,  4 Sep 2019 20:53:18 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249.iskra.kb (unknown [62.213.40.60])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id B86F7821819;
        Wed,  4 Sep 2019 20:53:18 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH 2/4] gianfar: make five functions static
Date:   Wed,  4 Sep 2019 20:52:20 +0700
Message-Id: <20190904135223.31754-3-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904135223.31754-1-asolokha@kb.kras.ru>
References: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
 <20190904135223.31754-1-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make functions that do not have callers outside the translation unit they
are defined in static.

Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
---
 drivers/net/ethernet/freescale/gianfar.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index fc31ba1a8bb8..17fb412e4bb4 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -275,7 +275,7 @@ static void gfar_configure_coalescing(struct gfar_private *priv,
 	}
 }
 
-void gfar_configure_coalescing_all(struct gfar_private *priv)
+static void gfar_configure_coalescing_all(struct gfar_private *priv)
 {
 	gfar_configure_coalescing(priv, 0xFF, 0xFF);
 }
@@ -1063,7 +1063,7 @@ static void gfar_halt_nodisable(struct gfar_private *priv)
 }
 
 /* Halt the receive and transmit queues */
-void gfar_halt(struct gfar_private *priv)
+static void gfar_halt(struct gfar_private *priv)
 {
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
 	u32 tempval;
@@ -1194,7 +1194,7 @@ void stop_gfar(struct net_device *dev)
 	free_skb_resources(priv);
 }
 
-void gfar_start(struct gfar_private *priv)
+static void gfar_start(struct gfar_private *priv)
 {
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
 	u32 tempval;
@@ -2324,7 +2324,7 @@ static void count_errors(u32 lstatus, struct net_device *ndev)
 	}
 }
 
-irqreturn_t gfar_receive(int irq, void *grp_id)
+static irqreturn_t gfar_receive(int irq, void *grp_id)
 {
 	struct gfar_priv_grp *grp = (struct gfar_priv_grp *)grp_id;
 	unsigned long flags;
@@ -2526,7 +2526,8 @@ static void gfar_process_frame(struct net_device *ndev, struct sk_buff *skb)
  * until the budget/quota has been reached. Returns the number
  * of frames handled
  */
-int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit)
+static int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue,
+			      int rx_work_limit)
 {
 	struct net_device *ndev = rx_queue->ndev;
 	struct gfar_private *priv = netdev_priv(ndev);
-- 
2.23.0

