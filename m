Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3765E473F2F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 10:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhLNJSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 04:18:34 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:43285 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230383AbhLNJSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 04:18:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1639473510;
        bh=iy68C3HP1WA7eLSvr8gNWej+jiLMw9SKingNaHKTRcc=;
        h=From:To:Cc:Subject:Date;
        b=YQ8F2xEF5yQpQd+CO+BL0XV5TnQaD869rTAfEodYloKoGEpk7ew6vrjPYof61ma3E
         n4MjRxBE7MPPfTyS76gK9Oiy395n8unoFvJN4WOCfTz4xPDIPx6uUxw+8r3HzEd/l4
         2OT1RYWU1y8rG/P3faHdtps/TycsOLP0OAE/jq2w=
Received: from localhost.localdomain ([116.199.36.48])
        by newxmesmtplogicsvrszb7.qq.com (NewEsmtp) with SMTP
        id 2C7B1ABA; Tue, 14 Dec 2021 17:11:07 +0800
X-QQ-mid: xmsmtpt1639473067tb2xnc27q
Message-ID: <tencent_39931E47EFB90517A5E15B534DD305606C08@qq.com>
X-QQ-XMAILINFO: M3vv73qU6a4uBOYB15OCUsciYKST1JTqoJ015aQRI5355Sc3ekj1gINRp7UOC6
         5LbaHhsENnTQfPppjU/ZXqHHUIoTRGcHFE+rinva9TldUpWUa55QPISTXBvL3Aet1288idO34MpP
         EdvCtgUO2rsXlXAPgJlEdK6+C1JsHpRqaWgdmj9yxq5o2xeXDZeLcnDvwJsVWEMM8iwB/F5M6QwL
         4OGsQoXeHaxIU/64AO4VKuoUXw8KN9AT+DBEHByBRKrwEuwYLPUZvt06wlETfPuxTczDWHDdK3pj
         1dt14w0wDP692vPqgQbt3K+TIA3RMubJSZpgL8XKAkJbb8CqTrdDUuUfjtPGdVBd7piI+GFl1mq0
         9vS4JTlNMR3N/QLwv8dnMSTMgAESndiQFJIgdXJtev5eysPNf5UFyIyJCYWI1J4KsAp/bemoGZQ+
         6wQsjvZwvyKtmDcbhBweZOVWngCgsqmfixchRLvdabrfogQkKY2YLw5mN612yOjIbg7h/P8iHeuk
         xI4b8bTyb1SUkJ3vB5HyzG4v/pf6M79E4TLKfuJTVgoAvLCbuOVNNtH6YmDfYI22hVrLHSEKWWtI
         46AcNH0EY6FuRYRqQk4O+6lkhbTIuH+FgsxU8WxEAeAf2EqZZxkR3JA76KXvVF4iozXrTGj6VKWj
         z6wIYpcqygGx4rv5S8A8ayGJv6ebBc5rgnTmXXZyH4Frvc6K4cBDNWS66EE/yJR6rV+VyBAqWeis
         r+Dg8pF5ma00+d98dR4xM7EfukPm+yHArqDW4qRQtLdSpi0gw53N4jt28hQMOsdxijLOfLutA4dN
         jx6JMpWXqCuA9FFcOpWxVXYxB92+G97BDV2pO6r6rRTfgaVKqVP2bS/Cmy/rz26v9gQ81zWzKK+z
         4KrVwyaGBYasFuhQMUVJzFsdCpBL9xu4ZHRr6/Q9no1ZWrpiCPDu653KmQdUWr0g==
From:   conleylee@foxmail.com
To:     mripard@kernel.org, wens@csie.org, jernej.skrabec@gmail.com,
        arnd@arndb.de, christophe.jaillet@wanadoo.fr, andrew@lunn.ch,
        netdev@vger.kernel.org
Cc:     Conley Lee <conleylee@foxmail.com>
Subject: [PATCH] sun4i-emac.c: remove unnecessary branch
Date:   Tue, 14 Dec 2021 17:11:06 +0800
X-OQ-MSGID: <20211214091106.25523-1-conleylee@foxmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Conley Lee <conleylee@foxmail.com>

According to the current implementation of emac_rx, every arrived packet
will be processed in the while loop. So, there is no remain packet last
time. The skb_last field and this branch for dealing with it is
unnecessary.

Signed-off-by: Conley Lee <conleylee@foxmail.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 800ee022388f..cccf8a3ead5e 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -76,7 +76,6 @@ struct emac_board_info {
 	void __iomem		*membase;
 	u32			msg_enable;
 	struct net_device	*ndev;
-	struct sk_buff		*skb_last;
 	u16			tx_fifo_stat;
 
 	int			emacrx_completed_flag;
@@ -499,7 +498,6 @@ static void emac_rx(struct net_device *dev)
 	struct sk_buff *skb;
 	u8 *rdptr;
 	bool good_packet;
-	static int rxlen_last;
 	unsigned int reg_val;
 	u32 rxhdr, rxstatus, rxcount, rxlen;
 
@@ -514,22 +512,6 @@ static void emac_rx(struct net_device *dev)
 		if (netif_msg_rx_status(db))
 			dev_dbg(db->dev, "RXCount: %x\n", rxcount);
 
-		if ((db->skb_last != NULL) && (rxlen_last > 0)) {
-			dev->stats.rx_bytes += rxlen_last;
-
-			/* Pass to upper layer */
-			db->skb_last->protocol = eth_type_trans(db->skb_last,
-								dev);
-			netif_rx(db->skb_last);
-			dev->stats.rx_packets++;
-			db->skb_last = NULL;
-			rxlen_last = 0;
-
-			reg_val = readl(db->membase + EMAC_RX_CTL_REG);
-			reg_val &= ~EMAC_RX_CTL_DMA_EN;
-			writel(reg_val, db->membase + EMAC_RX_CTL_REG);
-		}
-
 		if (!rxcount) {
 			db->emacrx_completed_flag = 1;
 			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-- 
2.34.1

