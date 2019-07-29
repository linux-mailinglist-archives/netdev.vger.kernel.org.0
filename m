Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCCA78430
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 06:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfG2Ejj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 00:39:39 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50607 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbfG2Eji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 00:39:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id A763BED3;
        Mon, 29 Jul 2019 00:39:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jul 2019 00:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=0O62JZjgJ5QLr
        L+NrQmOcgmUjOYAyXoPaY3TSYq6NkU=; b=M39QYMfJvmF34m0F092xDjrNlqtey
        TcDrZcHoNVv/DuoUBHTxDnmIj9kLKh8mcII0JfLc0aHjvTN2VP3UcRu/K2Qv9wWP
        8amOEr2Wbin8hkmkvWmvHd5DaQw36yl5NQUrZEAaoaJ4pRRpX7QyWzT8L520cHCl
        LzWcMF0J2H2A55kItjqmkkg94kpnbejOcp2eXvNczx5mp58QPL1w+GHzeCzvjHg4
        R7bfv2orlCT2SrF8jqQNmKXXt/+a8CGvI5Kx1bKaAZNeOeEDlv362JKeueT4pH5C
        OcrgL5NrIpXxa63z+F9c3U5+JUOTEKR27GZcapN3oiQ94OwZOjRzxPOqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0O62JZjgJ5QLrL+NrQmOcgmUjOYAyXoPaY3TSYq6NkU=; b=VqSe5P2v
        1nx4K6Dg1fwueW6zmobY6MbpitDiepCu+bTVe7TETAK+L509AmSHAbA6Jkvkwwhc
        27dxkzGRVA9J9/pWzS5b2AfuhSsFP/sxp8vRqXgfxhJAz64Mc1nNNcFEWElYSFaO
        aheu4LnN2YMnLLi0Y0xN00mfjqr3KJ3l9hOyAUuX/UmYcWKnpLut1esTE3f5h6Uw
        Xg79ziZQA129+sKzpdHZHneQ9j3R5+hKFi+lStu1HToceAadEKzKDuHykda8dbtH
        WwwIws+L74hZz5XLHdOzQ6dyNuy14YeVv1IhmUcQCnrfsZq2VjEimn6eMOANRz1G
        8hTKRSMRP/wK3A==
X-ME-Sender: <xms:iHg-XUDaR7E92R-1oRKC743X3jb5A341mVMuHgkWM-9eG4t353ib3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledtgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtvddrkedurddukedrfedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivgep
    ud
X-ME-Proxy: <xmx:iHg-XcVJ0EA4RGccMtrdT0fSq5b_4yVArVAvuTERKGTHfVFBwYd2mw>
    <xmx:iHg-Xcp5p5RyDLTCpASP-dRbhuEV6mCcMzEypwBS6w-F6v3aG1wqLQ>
    <xmx:iHg-XZxdj2ICCXlZcpZ9ctP9ktyAkUdJxMEn-LpDCXvZ1AMJeLF8Hw>
    <xmx:iHg-XTqqqAAjzldzjkgueTOHJETIMDfkUU1YlVhelcyN-Z13lVh0FQ>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F8218005C;
        Mon, 29 Jul 2019 00:39:32 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, joel@jms.id.au,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] net: ftgmac100: Add support for DT phy-handle property
Date:   Mon, 29 Jul 2019 14:09:25 +0930
Message-Id: <20190729043926.32679-4-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729043926.32679-1-andrew@aj.id.au>
References: <20190729043926.32679-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy-handle is necessary for the AST2600 which separates the MDIO
controllers from the MAC.

I've tried to minimise the intrusion of supporting the AST2600 to the
FTGMAC100 by leaving in place the existing MDIO support for the embedded
MDIO interface. The AST2400 and AST2500 continue to be supported this
way, as it avoids breaking/reworking existing devicetrees.

The AST2600 support by contrast requires the presence of the phy-handle
property in the MAC devicetree node to specify the appropriate PHY to
associate with the MAC. In the event that someone wants to specify the
MDIO bus topology under the MAC node on an AST2400 or AST2500, the
current auto-probe approach is done conditional on the absence of an
"mdio" child node of the MAC.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 37 +++++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 030fed65393e..563384b788ab 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/of.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
@@ -1619,8 +1620,13 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
 	if (!priv->mii_bus)
 		return -EIO;
 
-	if (priv->is_aspeed) {
-		/* This driver supports the old MDIO interface */
+	if (of_device_is_compatible(np, "aspeed,ast2400-mac") ||
+	    of_device_is_compatible(np, "aspeed,ast2500-mac")) {
+		/* The AST2600 has a separate MDIO controller */
+
+		/* For the AST2400 and AST2500 this driver only supports the
+		 * old MDIO interface
+		 */
 		reg = ioread32(priv->base + FTGMAC100_OFFSET_REVR);
 		reg &= ~FTGMAC100_REVR_NEW_MDIO_INTERFACE;
 		iowrite32(reg, priv->base + FTGMAC100_OFFSET_REVR);
@@ -1797,7 +1803,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 	np = pdev->dev.of_node;
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac") ||
-		   of_device_is_compatible(np, "aspeed,ast2500-mac"))) {
+		   of_device_is_compatible(np, "aspeed,ast2500-mac") ||
+		   of_device_is_compatible(np, "aspeed,ast2600-mac"))) {
 		priv->rxdes0_edorr_mask = BIT(30);
 		priv->txdes0_edotr_mask = BIT(30);
 		priv->is_aspeed = true;
@@ -1817,7 +1824,29 @@ static int ftgmac100_probe(struct platform_device *pdev)
 		priv->ndev = ncsi_register_dev(netdev, ftgmac100_ncsi_handler);
 		if (!priv->ndev)
 			goto err_ncsi_dev;
-	} else {
+	} else if (np && of_get_property(np, "phy-handle", NULL)) {
+		struct phy_device *phy;
+
+		phy = of_phy_get_and_connect(priv->netdev, np,
+					     &ftgmac100_adjust_link);
+		if (!phy) {
+			dev_err(&pdev->dev, "Failed to connect to phy\n");
+			goto err_setup_mdio;
+		}
+
+		/* Indicate that we support PAUSE frames (see comment in
+		 * Documentation/networking/phy.txt)
+		 */
+		phy_support_asym_pause(phy);
+
+		/* Display what we found */
+		phy_attached_info(phy);
+	} else if (np && !of_get_child_by_name(np, "mdio")) {
+		/* Support legacy ASPEED devicetree descriptions that decribe a
+		 * MAC with an embedded MDIO controller but have no "mdio"
+		 * child node. Automatically scan the MDIO bus for available
+		 * PHYs.
+		 */
 		priv->use_ncsi = false;
 		err = ftgmac100_setup_mdio(netdev);
 		if (err)
-- 
2.20.1

