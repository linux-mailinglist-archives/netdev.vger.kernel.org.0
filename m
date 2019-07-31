Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860EB7B924
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfGaFkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:40:11 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50017 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726982AbfGaFkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 01:40:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B12C42D48;
        Wed, 31 Jul 2019 01:40:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 31 Jul 2019 01:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=0O62JZjgJ5QLr
        L+NrQmOcgmUjOYAyXoPaY3TSYq6NkU=; b=PeUY4OthXsQELTNecq8gvuEu8NrQ1
        B8Yx8cbUXcO9sI4NbDpAvPFRHlVoe9Bk+uuzoZlwjYh08Q+YCiALoTJCg66Deb8H
        zwU8K9JfXdl62aJqMyhE5NLi1Q0xx5BlRwfd/m15qswoS0CVw6EuHUBal/tX1H3t
        NcwkbqPAQEoc6Om/f2rUAwQk/e932trLP2KusOvbr8YXnxRq/pUlmU5+2R0uK3sS
        VveF2cQix/mH7ifTk48km4BUPbbI+jyfdJ5bn8kz+0QjZT2Y7cHUwV6Sa04ntORO
        +xvrUVkyYqmdieC02NRe2N3P8cFsB0HkYTZdd/tzFqhorugK3XkSyXKrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0O62JZjgJ5QLrL+NrQmOcgmUjOYAyXoPaY3TSYq6NkU=; b=l9y9hjBc
        W01fem2UFgQ7LPLCXE9JzoZX9af+uDJpYhonlItmeJ5H9KCvibgyXhgisOmju11Q
        Po34R9vvzdARl1J235y74YN+RyTq3h21eNs7gQWcDbalCPdH9XcGe+d16SUKC5qS
        1wMFHKk/h5bfPhQpqOTFRxNDgHprp/8cfVs/PYMgvmhNbDKkYjjTjgutA+P+nO93
        PEdI0jpn0gQAFaFr8tOR6pWVcCCcFztGdomBi5+XBGn9+B9IAibqRKPA2Vqtd1J3
        yq8JyeqbnfUsg+eKzgEtdBdBZK8vaqCAtOB48GcjHxouTHhWmH9eBP/HRMGs5Ajz
        xGd+9BW3P3Ac1w==
X-ME-Sender: <xms:tSlBXYoCaoCGTP5YseUw3k970Pdca3D1phAZpM3EOBqPWrJyTztfsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtvddrkedurddukedrfedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivgep
    ud
X-ME-Proxy: <xmx:tSlBXW1ja71Z78rQxUX_xpEFaGKgaDUzm5na89isVHxX8mfBNONlLA>
    <xmx:tSlBXUhV0k-BVCUG5o2m-zzlVEb3N3x8HpAGly0Ltu3ok9P47OtwhA>
    <xmx:tSlBXdklflOkqoWdXq7hhrX99H0UxNdf5-Gm5H12Nsdjt3WC1aQLRg>
    <xmx:tSlBXcycFBRGV7WRuMydgA4RR_X2Ry8hPov50qg_EhF3Ussntp65eg>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52EC180059;
        Wed, 31 Jul 2019 01:40:01 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, joel@jms.id.au,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/4] net: ftgmac100: Add support for DT phy-handle property
Date:   Wed, 31 Jul 2019 15:09:58 +0930
Message-Id: <20190731053959.16293-4-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731053959.16293-1-andrew@aj.id.au>
References: <20190731053959.16293-1-andrew@aj.id.au>
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

