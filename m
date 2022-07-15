Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271735764F9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 18:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiGOQCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 12:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiGOQBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 12:01:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346A27392E;
        Fri, 15 Jul 2022 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5XcgCX5IEnr5TgMlYC+cQseNSP2R9E/qzSlMeqbtQYw=; b=eAEe1dZ3dEKHvCC5x6n3Pkepcg
        4gsGy+Jcx5PFGq1jVI95XyMZoQ1qfUKvLAzMaJHHHnzHoV5PI6Q9If6eEvxRLH1AvWYF5PMhK4Nh0
        T6mCY30xODECmugUBgUp0Rcz9/ui0QRr7Nas1aRUaQPWZcUCIKSLNApXo0WcCwDxNOgzTlvW8T/fP
        ENn20uelVEro+PJ+kw4iNiexW7BWXh3Wc1oty0mQV438h0z/wj4XByw7mwDoaAaY2nVEWv1j21RqZ
        St36PWhGLazvW/1oy7zsxgUtQFsID21vU/CCanEltavXYBK2xyv5MpiIKR4914QLEYuS94t/RerIT
        +XnvAR7g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46048 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oCNkz-0007Cj-F1; Fri, 15 Jul 2022 17:01:33 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oCNky-006e3g-KA; Fri, 15 Jul 2022 17:01:32 +0100
In-Reply-To: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: [PATCH net-next 2/6] software node: allow named software node to be
 created
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 15 Jul 2022 17:01:32 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Allow a named software node to be created, which is needed for software
nodes for a fixed-link specification for DSA.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/base/swnode.c    | 14 ++++++++++++--
 include/linux/property.h |  4 ++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 0a482212c7e8..b2ea08f0e898 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -972,8 +972,9 @@ void software_node_unregister(const struct software_node *node)
 EXPORT_SYMBOL_GPL(software_node_unregister);
 
 struct fwnode_handle *
-fwnode_create_software_node(const struct property_entry *properties,
-			    const struct fwnode_handle *parent)
+fwnode_create_named_software_node(const struct property_entry *properties,
+				  const struct fwnode_handle *parent,
+				  const char *name)
 {
 	struct fwnode_handle *fwnode;
 	struct software_node *node;
@@ -991,6 +992,7 @@ fwnode_create_software_node(const struct property_entry *properties,
 		return ERR_CAST(node);
 
 	node->parent = p ? p->node : NULL;
+	node->name = name;
 
 	fwnode = swnode_register(node, p, 1);
 	if (IS_ERR(fwnode))
@@ -998,6 +1000,14 @@ fwnode_create_software_node(const struct property_entry *properties,
 
 	return fwnode;
 }
+EXPORT_SYMBOL_GPL(fwnode_create_named_software_node);
+
+struct fwnode_handle *
+fwnode_create_software_node(const struct property_entry *properties,
+			    const struct fwnode_handle *parent)
+{
+	return fwnode_create_named_software_node(properties, parent, NULL);
+}
 EXPORT_SYMBOL_GPL(fwnode_create_software_node);
 
 void fwnode_remove_software_node(struct fwnode_handle *fwnode)
diff --git a/include/linux/property.h b/include/linux/property.h
index a5b429d623f6..23330ae2b1fa 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -492,6 +492,10 @@ void software_node_unregister(const struct software_node *node);
 struct fwnode_handle *
 fwnode_create_software_node(const struct property_entry *properties,
 			    const struct fwnode_handle *parent);
+struct fwnode_handle *
+fwnode_create_named_software_node(const struct property_entry *properties,
+				  const struct fwnode_handle *parent,
+				  const char *name);
 void fwnode_remove_software_node(struct fwnode_handle *fwnode);
 
 int device_add_software_node(struct device *dev, const struct software_node *node);
-- 
2.30.2

