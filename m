Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8478316224D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgBRI1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:27:22 -0500
Received: from first.geanix.com ([116.203.34.67]:59622 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgBRI1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 03:27:21 -0500
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 26D2CC0037;
        Tue, 18 Feb 2020 08:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1582014390; bh=kbvwE50gIASa8SU+yAUXLLrpLRJAinam1Rq+k74pvLE=;
        h=From:To:Cc:Subject:Date;
        b=TVgaMOgXxuLlwPA+ON7VdDkmYrtnDjUU5QSUVmVxiQ8NLbgSpo6gM/mWZ5yLBg0Cl
         xZ6vAurg/duUvtvFYrMucVNWmVItOqkAS1Rn2LEKyfeeBdmIQ3B5sOEnJN6zrBTFwk
         WS72u9qZpCjWQYfplO2lNefjeB6Iyt6hSNl23b37l3SzYLNguV9QLDpXwVockJUEj/
         9Rb0ryWABrz7JHeFyDk69HsJVmXqXLtOpxjn+TFBMGlGRQVACHeR9CDiZqE2FzvdgJ
         JXaaNnEM9NAvWEEncD6lQ6bT9ZQZnzbne/UWNdO7cM17g/MKEjuV7HAGrb8QpnoWwP
         cBERntLjl88qg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH 6/8] net: ll_temac: Remove unused start_p variable
Date:   Tue, 18 Feb 2020 09:27:17 +0100
Message-Id: <20200218082717.7542-1-esben@geanix.com>
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

The start_p variable was included in the initial commit,
commit 92744989533c ("net: add Xilinx ll_temac device driver"),
but has never had any real use.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 7623d09fbd0a..baf05a2b7551 100644
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
2.25.0

