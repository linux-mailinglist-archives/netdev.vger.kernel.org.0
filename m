Return-Path: <netdev+bounces-4070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE89970A733
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 12:41:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F9E61C20A3A
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 10:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7409A812;
	Sat, 20 May 2023 10:41:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6346A624
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 10:41:49 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5AAFA
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 03:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gn+qdmcpH5gbYhLSOFtKboD+n5MA/gddmZotoVWjg+4=; b=qTy9En0kX9e4eLo4SjMxaeGvAf
	isXEV2k30TalVKClFovrGQ5eGL/7Gh8F6R4VFMSWr0U9mT94Md60ljy6nL5S0+Q9fDJHYPYORF4Ey
	z1Q7vLmJIArKof3xcLOXOduN5lLXycw1Knin5vl5WQYZaP7Yt8VOCDeVK4Qs2l7kKlpb22k94MVdy
	+mZVZoSZuaI8fdQsQ9crzwxIRVuVEmZ/kqI8BP/ZXw7UqND66MNkVyCT3+ycnvl+XMZDT0sofU39W
	mYguDb/QJj8kHf3FZPJi5Ya/AO1HnFBPLeg7QSk3oD8mhOo+i0TdKs6OWD6bWbGjc4zZU6Hlow5YB
	4jeP1xzg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51744 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q0K1v-0004DQ-1J; Sat, 20 May 2023 11:41:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q0K1u-006EIP-ET; Sat, 20 May 2023 11:41:42 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: phylink: require supported_interfaces to be
 filled
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q0K1u-006EIP-ET@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Sat, 20 May 2023 11:41:42 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We have been requiring the supported_interfaces bitmap to be filled in
by MAC drivers that have a mac_select_pcs() method. Now that all MAC
drivers fill in the supported_interfaces bitmap, it is time to enforce
this. We have already required supported_interfaces to be set in order
for optical SFPs to be configured in commit f81fa96d8a6c ("net: phylink:
use phy_interface_t bitmaps for optical modules").

Refuse phylink creation if supported_interfaces is empty, and remove
code to deal with cases where this mask is empty.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
I believe what I've said above is indeed the case, but there is always
the chance that something has been missed and this will cause breakage.
I would post as RFC and ask for testing, but in my experience that is
a complete waste of time as it doesn't result in any testing feedback.
So, it's probably better to get it merged into net-next and then wait
for any reports of breakage.

 drivers/net/phy/phylink.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a4dd5197355a..093b7b6e0263 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -712,14 +712,11 @@ static int phylink_validate(struct phylink *pl, unsigned long *supported,
 {
 	const unsigned long *interfaces = pl->config->supported_interfaces;
 
-	if (!phy_interface_empty(interfaces)) {
-		if (state->interface == PHY_INTERFACE_MODE_NA)
-			return phylink_validate_mask(pl, supported, state,
-						     interfaces);
+	if (state->interface == PHY_INTERFACE_MODE_NA)
+		return phylink_validate_mask(pl, supported, state, interfaces);
 
-		if (!test_bit(state->interface, interfaces))
-			return -EINVAL;
-	}
+	if (!test_bit(state->interface, interfaces))
+		return -EINVAL;
 
 	return phylink_validate_mac_and_pcs(pl, supported, state);
 }
@@ -1513,19 +1510,18 @@ struct phylink *phylink_create(struct phylink_config *config,
 	struct phylink *pl;
 	int ret;
 
-	if (mac_ops->mac_select_pcs &&
-	    mac_ops->mac_select_pcs(config, PHY_INTERFACE_MODE_NA) !=
-	      ERR_PTR(-EOPNOTSUPP))
-		using_mac_select_pcs = true;
-
 	/* Validate the supplied configuration */
-	if (using_mac_select_pcs &&
-	    phy_interface_empty(config->supported_interfaces)) {
+	if (phy_interface_empty(config->supported_interfaces)) {
 		dev_err(config->dev,
-			"phylink: error: empty supported_interfaces but mac_select_pcs() method present\n");
+			"phylink: error: empty supported_interfaces\n");
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (mac_ops->mac_select_pcs &&
+	    mac_ops->mac_select_pcs(config, PHY_INTERFACE_MODE_NA) !=
+	      ERR_PTR(-EOPNOTSUPP))
+		using_mac_select_pcs = true;
+
 	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
 	if (!pl)
 		return ERR_PTR(-ENOMEM);
-- 
2.30.2


