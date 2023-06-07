Return-Path: <netdev+bounces-8814-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E95725DDF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1039D2812F9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE8933C87;
	Wed,  7 Jun 2023 11:58:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C169D7488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:58:46 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9161FEA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=oB7biIKgpKIax7oNHTRibqOG2S4goFF6Ody3CttJRV8=; b=nws7d5TAyhytCgkJ0Y4n0o1uBU
	FtUf/KB+Uwlu/D0ob3LWOCYJZ6I6a4evuVJUHKamdwLw9aOucip0jsrO/BHPD9GP3ZtFJkfoEf26l
	KoUDTxdyPyslUTY6284xftEZ+ESx+CNSIPU89YTMnQyvNHXpQKpKs9XTNXCGONWe/At3ZwQmiw4AD
	S6nQLD3URl8UOAktfHVfCGYdmikqW5gD/C0sDhAhj6uXBlz0o31fP5fGJLSUBuK/7U4N3fPE4f9ew
	RyLp2emOt9edZvpmD/P0mxz6r/EqLVDDUnmRaZc1u1D35oD7kJZVdx3Grf4lH8EOW3kLDG+smgJ8Y
	1hYBKpBA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48050 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q6ro0-0007LC-LJ; Wed, 07 Jun 2023 12:58:24 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q6ro0-00CfaI-1T; Wed, 07 Jun 2023 12:58:24 +0100
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
Subject: [PATCH net-next v2 03/11] net: pcs: lynx: remove
 lynx_get_mdio_device()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q6ro0-00CfaI-1T@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 07 Jun 2023 12:58:24 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

lynx_get_mdio_device() is no longer necessary, let's remove it so the
lynx PCS code is always managing the lifetime of the mdiodev.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 8 --------
 include/linux/pcs-lynx.h   | 2 --
 2 files changed, 10 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index f04dc580ffb8..a90f74172f49 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -34,14 +34,6 @@ enum sgmii_speed {
 #define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
 #define lynx_to_phylink_pcs(lynx) (&(lynx)->pcs)
 
-struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs)
-{
-	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
-
-	return lynx->mdio;
-}
-EXPORT_SYMBOL(lynx_get_mdio_device);
-
 static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 				       struct phylink_link_state *state)
 {
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 885b59d10581..25f68a096bfe 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,8 +9,6 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
-
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr);
 
-- 
2.30.2


