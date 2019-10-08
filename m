Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C363CF8E4
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfJHLuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:50:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51549 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730830AbfJHLuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:50:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A241521731;
        Tue,  8 Oct 2019 07:50:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 08 Oct 2019 07:50:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=VrOAEo8fPhIsF
        bZtqUbj1skBfTPYiCz0Pda7Yzm4W+M=; b=F0GFv3SHAweg9VKRWBWSm49fES2dG
        DiL+MkSrWVl7JEvrPn5q2ebHFq9tIoDLcPOTeD1jL8+rJYrUJUzGU5ft3eLvt/z0
        oeYb2+8elIjzXdljcieL9SbGtsZSfC7D1J2ZdwZJG0Mi/KhWhYFo6ORabsEXANBp
        jueiQl2PF+9MgmT/hqKW6bSRQ4L95cA0USVTm1nkn6utt+R1EMF8tfONSqLjTTPf
        Q6elFtq1UkzPJ7xwi2RJoaCr4zWFlPJsbqlgyb/mvem8TbIxUJrffoZR1o9yzEqe
        6S+OPx7rkk6jX5Ic5DQ9GEdw10M+NFzLsJGYQ75mljExsMgu9e1ESqb+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=VrOAEo8fPhIsFbZtqUbj1skBfTPYiCz0Pda7Yzm4W+M=; b=QYeT+5ty
        bVq8RQ8KHMH7IYLgjjl9m0WyN/o1iD+luGHtgtuAFtsdYKOj8ozmj+qn8iLsJij5
        g3ZSc5K+Nl0gPag46fYzzzXDqOrjkmKsAX+UuyN9Lln9+3Qtlnk+b4Z64++6Uysc
        fxO0XX0Ez2h3MJRLXmOoIi79oW2LP7mx4hugqRH/S7a1CHkDFLNb5UvsTzQHHnJk
        V9LjuFGBIHrx5AolvEo7TTJaDsb096K/3BKYEJhNOT9YCqjDcLA+LXyEBnehGo6M
        ZjVPLaWJpA5gG7PlSZEQqoNwakiD0wRWqOtkcnryrGKDLvo4R4iVO6PHeDwGsZHP
        N3sv/snH3yCLBg==
X-ME-Sender: <xms:GnicXaS8VTXBAB32LzINknBRRVQD5VMtXniwjh9uqJ2b8WNlv8_GJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtfedrheejrddvudehrddujeeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihii
    vgepvd
X-ME-Proxy: <xmx:GnicXd9cW1aJF-3am5rhr-_SE9kCbS5Ko3nuOjj7VB-P10Pn19g0Yg>
    <xmx:GnicXeLJWAwF2uBTDzCd8uM0APmjr28czYULdr6GyPkvxc9OjKJGgw>
    <xmx:GnicXZ7G5wJhD6ZV7qg76dkWlxHhvHIxqVJH_nj1dhA-WVINuk5dlg>
    <xmx:GnicXerjwpMXHNdHXRBeIOpkXrp9amYj3WsDJvcTIg0xrIqTiNrzng>
Received: from mistburn.lan (203-57-215-178.dyn.iinet.net.au [203.57.215.178])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4738D8005A;
        Tue,  8 Oct 2019 07:50:47 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org
Subject: [PATCH 3/3] net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs
Date:   Tue,  8 Oct 2019 22:21:43 +1030
Message-Id: <20191008115143.14149-4-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008115143.14149-1-andrew@aj.id.au>
References: <20191008115143.14149-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 50MHz RCLK has to be enabled before the RMII interface will function.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 35 +++++++++++++++++++-----
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 9b7af94a40bb..9ff791fb0449 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -90,6 +90,9 @@ struct ftgmac100 {
 	struct mii_bus *mii_bus;
 	struct clk *clk;
 
+	/* 2600 RMII clock gate */
+	struct clk *rclk;
+
 	/* Link management */
 	int cur_speed;
 	int cur_duplex;
@@ -1718,12 +1721,14 @@ static void ftgmac100_ncsi_handler(struct ncsi_dev *nd)
 		   nd->link_up ? "up" : "down");
 }
 
-static void ftgmac100_setup_clk(struct ftgmac100 *priv)
+static int ftgmac100_setup_clk(struct ftgmac100 *priv)
 {
-	priv->clk = devm_clk_get(priv->dev, NULL);
-	if (IS_ERR(priv->clk))
-		return;
+	struct clk *clk;
 
+	clk = devm_clk_get(priv->dev, NULL /* MACCLK */);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+	priv->clk = clk;
 	clk_prepare_enable(priv->clk);
 
 	/* Aspeed specifies a 100MHz clock is required for up to
@@ -1732,6 +1737,14 @@ static void ftgmac100_setup_clk(struct ftgmac100 *priv)
 	 */
 	clk_set_rate(priv->clk, priv->use_ncsi ? FTGMAC_25MHZ :
 			FTGMAC_100MHZ);
+
+	/* RCLK is for RMII, typically used for NCSI. Optional because its not
+	 * necessary if it's the 2400 MAC or the MAC is configured for RGMII
+	 */
+	priv->rclk = devm_clk_get_optional(priv->dev, "RCLK");
+	clk_prepare_enable(priv->rclk);
+
+	return 0;
 }
 
 static int ftgmac100_probe(struct platform_device *pdev)
@@ -1853,8 +1866,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 			goto err_setup_mdio;
 	}
 
-	if (priv->is_aspeed)
-		ftgmac100_setup_clk(priv);
+	if (priv->is_aspeed) {
+		err = ftgmac100_setup_clk(priv);
+		if (err)
+			goto err_ncsi_dev;
+	}
 
 	/* Default ring sizes */
 	priv->rx_q_entries = priv->new_rx_q_entries = DEF_RX_QUEUE_ENTRIES;
@@ -1886,8 +1902,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_ncsi_dev:
 err_register_netdev:
+	if (priv->rclk)
+		clk_disable_unprepare(priv->rclk);
+	clk_disable_unprepare(priv->clk);
+err_ncsi_dev:
 	ftgmac100_destroy_mdio(netdev);
 err_setup_mdio:
 	iounmap(priv->base);
@@ -1909,6 +1928,8 @@ static int ftgmac100_remove(struct platform_device *pdev)
 
 	unregister_netdev(netdev);
 
+	if (priv->rclk)
+		clk_disable_unprepare(priv->rclk);
 	clk_disable_unprepare(priv->clk);
 
 	/* There's a small chance the reset task will have been re-queued,
-- 
2.20.1

