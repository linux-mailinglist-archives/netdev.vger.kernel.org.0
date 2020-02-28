Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5490173237
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgB1H5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 02:57:18 -0500
Received: from first.geanix.com ([116.203.34.67]:36196 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbgB1H5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 02:57:18 -0500
Received: from localhost (87-49-45-242-mobile.dk.customer.tdc.net [87.49.45.242])
        by first.geanix.com (Postfix) with ESMTPSA id BCFF1C109A;
        Fri, 28 Feb 2020 07:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582876635; bh=4Cyo9y5q/mldLL3pJH1O8Wl/0n5xEk8ts8a9jNcILNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CTg7JR3SxTdsWgj6JmFMmFx1TBjVm+KcweLEOCsAVysOJJhvWTgnYsAHnuR8+ZFf7
         i6vDWv4c5vy4w8Figd/Vvmah1BLyLXNBYu/0PviGtUSchi06brqc7jL67iup5Q+QbG
         lR8rWSpjt//EJl3JMacuHBJdX6Q1sVL767GH1Mxje1C/OJanZjsFbKx9cabfLN1+fS
         dvWudLF1dM1SvZwkADSPMgUqKUo7zl7rfJJSZaeHNT5DTxDDoJsqmdFR2t84TUfoD2
         0Ql4oFIrkcMUluCOLZ6VkrW87cJSfvcMlBToCs9Xo5g32j/T8nwFyGADC8PW1W6Gql
         usYeN04NvAz+Q==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH net-next 2/4] net: ll_temac: Remove unused start_p variable
Date:   Fri, 28 Feb 2020 08:57:12 +0100
Message-Id: <47799bc364ef24f750d5fa6d608c33c7e34c0b65.1582875715.git.esben@geanix.com>
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

The start_p variable was included in the initial commit,
commit 92744989533c ("net: add Xilinx ll_temac device driver"),
but has never had any real use.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index b0fab9a2056f..d6853c44e672 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -825,14 +825,13 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 	struct cdmac_bd *cur_p;
-	dma_addr_t start_p, tail_p, skb_dma_addr;
+	dma_addr_t tail_p, skb_dma_addr;
 	int ii;
 	unsigned long num_frag;
 	skb_frag_t *frag;
 
 	num_frag = skb_shinfo(skb)->nr_frags;
 	frag = &skb_shinfo(skb)->frags[0];
-	start_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
 	if (temac_check_tx_bd_space(lp, num_frag + 1)) {
-- 
2.25.1

