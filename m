Return-Path: <netdev+bounces-8818-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A7FF725DE5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98B641C20E1B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56DD333CA5;
	Wed,  7 Jun 2023 11:59:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D42D7488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:59:08 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4881FDE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5Yri5zTLMwqtY189y122EOnnzmFonxPfU7xL3miev/k=; b=CPx/htQGv81tyuwhMmiFi7aorj
	Si+BSN/OUuM5sLvpFmaVQ774T1x3HqKdJkAEwGW5cjoz+j23Cfy91kFYBxBkzpye8hwx1lKLAdPHu
	fpqbgCOPeyEaw+DMzvsy1UswlGTRnflrb5WCRvpfIGtoyKcNZFMGvYY7y5R8kItk4uOMYSI7hqBwk
	9Dgh4M1CG4q/j4saUJ5zE1QpftvhqwQKNkpDerEEDqFxoeLnJz8PXyLIzzhSVbz9Swu71Sic2cU0+
	GAK6xHjEehL/EL6+BdeVRhyQzFskxMSCjUdIvxEbXQKzeTDkSjeFHuhk+oTKW9JB5J0mUGi4rkv7S
	W/SS+NMg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55500 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q6roL-0007MU-3f; Wed, 07 Jun 2023 12:58:45 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q6roK-00Cfai-Gf; Wed, 07 Jun 2023 12:58:44 +0100
In-Reply-To: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
References: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Madalin Bucur <madalin.bucur@nxp.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 07/11] net: pcs: lynx: make lynx_pcs_create()
 static
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q6roK-00Cfai-Gf@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 07 Jun 2023 12:58:44 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We no longer need to export lynx_pcs_create() for drivers to use as we
now have all the functionality we need in the two new creation helpers.
Remove the export and prototype, and make it static.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 3 +--
 include/linux/pcs-lynx.h   | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index b0907c67d469..b8c66137e28d 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -307,7 +307,7 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 	.pcs_link_up = lynx_pcs_link_up,
 };
 
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
+static struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 {
 	struct lynx_pcs *lynx;
 
@@ -322,7 +322,6 @@ struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 
 	return lynx_to_phylink_pcs(lynx);
 }
-EXPORT_SYMBOL(lynx_pcs_create);
 
 struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr)
 {
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 123e813df771..7958cccd16f2 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,7 +9,6 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr);
 struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node);
 
-- 
2.30.2


