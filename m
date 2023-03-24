Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA7F6C7B38
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjCXJXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjCXJXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:23:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00CCAF1A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xvAqmM42XUONYz3hc3otDslJ4EN+c042aujwLDsZTWI=; b=nlbw7i83cgAhj4VpfAKNAJTqya
        3hJvj5fuvn9Z0fqLtAspPS6YEcDVTi5UJWtHKvDqRXFEk9W7HQeRqsMzgJr1dzRdUxP55pd6ujuyD
        9X6zTzbxWF9LSvcoYRAXN+5cEiJ+89QmmghSxo548UWw32asZFjp9NLBoG3Ge0O/ogmtISP2rvflH
        YHj2CzfWvkLWJVHBtwhvhAZm3GzdhgbmHUzgkM5cm0phT0yRKK+1b0m5QrDWBCKuNHnt7Q6WaC5+2
        jmW4vbHX2Yd2ayGo+MWF1d404nF1ei3TiUY2ukTY88igbv6qlLLAcuKdv3Q1MjXeOrzx9keZwCFqK
        2TnCXjEw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38968 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pfdeG-0006jo-Lz; Fri, 24 Mar 2023 09:23:48 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pfdeG-00EQ6Q-0f; Fri, 24 Mar 2023 09:23:48 +0000
In-Reply-To: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
References: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/3] net: sfp: constify sfp-bus internal fwnode uses
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pfdeG-00EQ6Q-0f@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Mar 2023 09:23:48 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constify sfp-bus internal fwnode uses, since we do not modify the
fwnode structures.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index b4680f859269..9372e5a4cadc 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -17,7 +17,7 @@ struct sfp_bus {
 	/* private: */
 	struct kref kref;
 	struct list_head node;
-	struct fwnode_handle *fwnode;
+	const struct fwnode_handle *fwnode;
 
 	const struct sfp_socket_ops *socket_ops;
 	struct device *sfp_dev;
@@ -390,7 +390,7 @@ static const struct sfp_upstream_ops *sfp_get_upstream_ops(struct sfp_bus *bus)
 	return bus->registered ? bus->upstream_ops : NULL;
 }
 
-static struct sfp_bus *sfp_bus_get(struct fwnode_handle *fwnode)
+static struct sfp_bus *sfp_bus_get(const struct fwnode_handle *fwnode)
 {
 	struct sfp_bus *sfp, *new, *found = NULL;
 
-- 
2.30.2

