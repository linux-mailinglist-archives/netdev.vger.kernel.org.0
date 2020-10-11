Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E2028A67E
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 11:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgJKJKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 05:10:11 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43192 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgJKJKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 05:10:11 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09B99qo1010652;
        Sun, 11 Oct 2020 11:09:52 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Daniel Palmer <daniel@0x0f.com>
Subject: [PATCH net-next 1/3] macb: add RM9200's interrupt flag TBRE
Date:   Sun, 11 Oct 2020 11:09:42 +0200
Message-Id: <20201011090944.10607-2-w@1wt.eu>
X-Mailer: git-send-email 2.9.0
In-Reply-To: <20201011090944.10607-1-w@1wt.eu>
References: <20201011090944.10607-1-w@1wt.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transmit Buffer Register Empty replaces TXERR on RM9200 and signals the
sender may try to send again becase the last queued frame is no longer
in queue (being transmitted or already transmitted).

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ethernet/cadence/macb.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 4f1b41569260..49d347429de8 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -365,6 +365,8 @@
 #define MACB_ISR_RLE_SIZE	1
 #define MACB_TXERR_OFFSET	6 /* EN TX frame corrupt from error interrupt */
 #define MACB_TXERR_SIZE		1
+#define MACB_RM9200_TBRE_OFFSET	6 /* EN may send new frame interrupt (RM9200) */
+#define MACB_RM9200_TBRE_SIZE	1
 #define MACB_TCOMP_OFFSET	7 /* Enable transmit complete interrupt */
 #define MACB_TCOMP_SIZE		1
 #define MACB_ISR_LINK_OFFSET	9 /* Enable link change interrupt */
-- 
2.28.0

