Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67488D1E54
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 04:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbfJJCKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 22:10:06 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35361 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbfJJCIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 22:08:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 063B921C24;
        Wed,  9 Oct 2019 22:07:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Oct 2019 22:07:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=/ZpOKiZozizLe
        7jyQflbx5yKpx8pRHgLZdXkZKFa2Hg=; b=dZgCLK1cVP859GF3NSW/Y0RSrwbC+
        FN6WHktScdyypzOyLWvLPfer0xRg+AccUNGHtweQbl0V/7rEA6A2z8RgwxWlRppf
        8S8oQR1B+zrbyMIf8BOWXeyVLjJWpVcoP5tp1Kl2zW1UVM6BiPrN1tC8C/T3EPbJ
        zoH+XdMD4RNeL2vj/WCVYPPERAXhPee3x1xABwjcYtyMHQ5MpO4GgALNv7vLNAfJ
        WoGSeTEuUTuDBRahmsFtEp1ACAPzIXPeh8p6RIrahJZMUrwuqUyBmm1fPGaCmD/Q
        kS9g/whN7xNNayUDLGIDx2cTd+UkAnkk1d/YHUSY47PqqjPjn5jSY5BNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/ZpOKiZozizLe7jyQflbx5yKpx8pRHgLZdXkZKFa2Hg=; b=GWl/lLxc
        bDwDADwW7Gay8uPl9LYFTy/HJmEiOslDOI7Ya6VxBCzU1anE7GzrKA5/bgU7XKmi
        MYRJa/+z0xg7z+u7ZVU7JRnWRplo1BK/YqhSvTxFwKt08o569jAaJZlboXxRCIC2
        5fvVbsGfe+aji3txbJcfMZfbeoGXVZTy8TQ6kGSztUFh7G16s/zbHTwxDHPgRVYF
        IEpCo1RsN0JKLc7z63ihfSU36419lAi6YyDpAiVB9vWV66CP4g2DjRV8QfP8ZSV0
        ekWJ8sjUUbAlaawn/E0AGkUFMdq2LK5jP3brOdCJhLJkv4WN3YFCN1+ovESHkY3/
        Tb5OvO3WwiRMhg==
X-ME-Sender: <xms:SJKeXRCDD2boWRBZ06LxfDjlEw_q9PncQjxGkElCbdhbBVBYTOkHDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtvddrkedurddukedrfedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivgep
    he
X-ME-Proxy: <xmx:SZKeXb4ML-jLRL_CgJSaGQz-KUMz2dttoul9go8GTa6Xks3FUKnWPA>
    <xmx:SZKeXfYNjeSU9jK663vzR-J5NZG5PbGSa0Sc9TKHw3AE3tOizsMu2Q>
    <xmx:SZKeXa3rV6bSfAAbSxYoiVckK-CUyJnghswk9lTdZFR0KK2AJIj_bQ>
    <xmx:SZKeXUAV6NAvOGMh1n6aLPgOSbYNwieJ8c5gYee5QWfC6XVgLr_CsQ>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECAA080059;
        Wed,  9 Oct 2019 22:07:01 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH v2 3/3] net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs
Date:   Thu, 10 Oct 2019 12:37:56 +1030
Message-Id: <20191010020756.4198-4-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191010020756.4198-1-andrew@aj.id.au>
References: <20191010020756.4198-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 50MHz RCLK has to be enabled before the RMII interface will function.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
---
v2: Mainly a rework of error case handling, some changes to comments

 drivers/net/ethernet/faraday/ftgmac100.c | 50 +++++++++++++++++++-----
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 9b7af94a40bb..824310253099 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -90,6 +90,9 @@ struct ftgmac100 {
 	struct mii_bus *mii_bus;
 	struct clk *clk;
 
+	/* AST2500/AST2600 RMII ref clock gate */
+	struct clk *rclk;
+
 	/* Link management */
 	int cur_speed;
 	int cur_duplex;
@@ -1718,20 +1721,41 @@ static void ftgmac100_ncsi_handler(struct ncsi_dev *nd)
 		   nd->link_up ? "up" : "down");
 }
 
-static void ftgmac100_setup_clk(struct ftgmac100 *priv)
+static int ftgmac100_setup_clk(struct ftgmac100 *priv)
 {
-	priv->clk = devm_clk_get(priv->dev, NULL);
-	if (IS_ERR(priv->clk))
-		return;
+	struct clk *clk;
+	int rc;
 
-	clk_prepare_enable(priv->clk);
+	clk = devm_clk_get(priv->dev, NULL /* MACCLK */);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+	priv->clk = clk;
+	rc = clk_prepare_enable(priv->clk);
+	if (rc)
+		return rc;
 
 	/* Aspeed specifies a 100MHz clock is required for up to
 	 * 1000Mbit link speeds. As NCSI is limited to 100Mbit, 25MHz
 	 * is sufficient
 	 */
-	clk_set_rate(priv->clk, priv->use_ncsi ? FTGMAC_25MHZ :
-			FTGMAC_100MHZ);
+	rc = clk_set_rate(priv->clk, priv->use_ncsi ? FTGMAC_25MHZ :
+			  FTGMAC_100MHZ);
+	if (rc)
+		goto cleanup_clk;
+
+	/* RCLK is for RMII, typically used for NCSI. Optional because its not
+	 * necessary if it's the AST2400 MAC, or the MAC is configured for
+	 * RGMII, or the controller is not an ASPEED-based controller.
+	 */
+	priv->rclk = devm_clk_get_optional(priv->dev, "RCLK");
+	rc = clk_prepare_enable(priv->rclk);
+	if (!rc)
+		return 0;
+
+cleanup_clk:
+	clk_disable_unprepare(priv->clk);
+
+	return rc;
 }
 
 static int ftgmac100_probe(struct platform_device *pdev)
@@ -1853,8 +1877,11 @@ static int ftgmac100_probe(struct platform_device *pdev)
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
@@ -1886,8 +1913,10 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_ncsi_dev:
 err_register_netdev:
+	clk_disable_unprepare(priv->rclk);
+	clk_disable_unprepare(priv->clk);
+err_ncsi_dev:
 	ftgmac100_destroy_mdio(netdev);
 err_setup_mdio:
 	iounmap(priv->base);
@@ -1909,6 +1938,7 @@ static int ftgmac100_remove(struct platform_device *pdev)
 
 	unregister_netdev(netdev);
 
+	clk_disable_unprepare(priv->rclk);
 	clk_disable_unprepare(priv->clk);
 
 	/* There's a small chance the reset task will have been re-queued,
-- 
2.20.1

