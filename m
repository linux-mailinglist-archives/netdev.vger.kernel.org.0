Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB835173235
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgB1H5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 02:57:03 -0500
Received: from first.geanix.com ([116.203.34.67]:36174 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgB1H5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 02:57:03 -0500
Received: from localhost (87-49-45-242-mobile.dk.customer.tdc.net [87.49.45.242])
        by first.geanix.com (Postfix) with ESMTPSA id 1BF4FC109A;
        Fri, 28 Feb 2020 07:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582876621; bh=pG1PPN8R1vtOo1QlkRHqdfs8dt6LaZxNLynXIIMrI8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RoVANOg68gVM7fGAozKvDMU4aMj4QokQ23Br/pmHLraEAX5gSs4tc7miM+dnleT36
         yElofHVBNnoY/ni4MNCsrY8GGLL6Y8HIc42W0Rra1t/57anBs72iuzxU4UZlSHGsWF
         P/UDLbbfvHAyNQgMHna/3oiDr/jUGCNEy7NO+EidKv7w9XmdBboMycgo9OzSg+N3UG
         AkhYAtPGJ7a5Lg2HpGx0xq1DCrnT+xkOjJiGvSmxS6/rVPgOo8nGHud3JDdjX0025W
         /rlHtPoNGyvPZUIkKEau1AYhZziDpEzR77yHC+euvrdq87hXtMNenQBycYnWbC/yjv
         yiNPxR7NQtJyQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net-next 1/4] net: ll_temac: Remove unused tx_bd_next struct field
Date:   Fri, 28 Feb 2020 08:56:57 +0100
Message-Id: <1ac0e2037c91d9fd19e094e3205ca237554ef010.1582875715.git.esben@geanix.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1582875715.git.esben@geanix.com>
References: <cover.1582875715.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 05ff821c8cf1
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
index 9461acec6f70..b0fab9a2056f 100644
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
2.25.1

