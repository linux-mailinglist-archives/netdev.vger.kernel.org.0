Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC24B162244
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBRI1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:27:09 -0500
Received: from first.geanix.com ([116.203.34.67]:59606 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgBRI1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 03:27:09 -0500
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 919F3C0036;
        Tue, 18 Feb 2020 08:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582014378; bh=HXbPSN1aokLgN/o7DVaUkYTISITHBVBZLKWriZmqQTI=;
        h=From:To:Cc:Subject:Date;
        b=l6+37eJul82C0JKH/GoZU6xqGEE8ZxvXS+hXWp3Ua30HtTpv7p2+dSwQ+rMWLKwaZ
         eHijheFGy20oIEAgBY99LSb2UqKGqh/jtO6fTqTfuT6BZ+l2cHbo1IpIyjhggUx6i8
         Eu/1+DFLaXbYpJx70mplhWMaBIKFT8Mu3UrIqyYUoJvsiMmnNssVjhfl+7WjTh/aui
         Z5a/SjnKhGRpcHlxoM0GdxQI40P06M17g3q6GLP5N2hPVumOUjmIXxGncJKMWjzFS5
         YyddRvPi/Gqcfn8LvAhsbtnxp0NFs/coOqkI4xI7FIkIeCvEVK4FSMAotWb13TT1Xe
         301AtVOhnkAag==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH 5/8] net: ll_temac: Remove unused tx_bd_next struct field
Date:   Tue, 18 Feb 2020 09:27:06 +0100
Message-Id: <20200218082706.7458-1-esben@geanix.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=4.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=disabled
        version=3.4.3
X-Spam-Checker-Version: SpamAssassin 3.4.3 (2019-12-06) on eb9da72b0f73
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tx_bd_next field was included in the initial commit,
commit 92744989533c ("net: add Xilinx ll_temac device driver"),
but has never had any real use.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac.h      | 1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 53fb8141f1a6..463ef9eaf42d 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -372,7 +372,6 @@ struct temac_local {
 	struct cdmac_bd *rx_bd_v;
 	dma_addr_t rx_bd_p;
 	int tx_bd_ci;
-	int tx_bd_next;
 	int tx_bd_tail;
 	int rx_bd_ci;
 	int rx_bd_tail;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 90b486becb5b..7623d09fbd0a 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -387,7 +387,6 @@ static int temac_dma_bd_init(struct net_device *ndev)
 
 	/* Init descriptor indexes */
 	lp->tx_bd_ci = 0;
-	lp->tx_bd_next = 0;
 	lp->tx_bd_tail = 0;
 	lp->rx_bd_ci = 0;
 	lp->rx_bd_tail = RX_BD_NUM - 1;
-- 
2.25.0

