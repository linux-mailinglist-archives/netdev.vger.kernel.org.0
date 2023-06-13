Return-Path: <netdev+bounces-10317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9AF372DD64
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F62281218
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8442427213;
	Tue, 13 Jun 2023 09:14:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746FE2915
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:14:05 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C729C1A7
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 02:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=l1Msy63F8MP5MkILBtzlos40USdbJ9LNx3CBnrxbJPI=; b=FUtDuycpWpRZivywX+4h/BVgLN
	NIYnEjgAScr4hEf1eiv26QtjE5udfsGrKEr1x1BIusOyIdXMXhbsfODTt1KoL7q0yruFSMlp+QjuR
	H9m3FsMufHdvJRmDLtYq146myVNw5dLA/YLwtd+OnV9PWaJmgAn80t6kTbNuO8gEB/jhMiqB9eHni
	atcdbN7rc5ajqBE3ktCHgr/X6nZOnU0OsctH8hyNCQptz2AUfJgaOvE7BaImY494lF9axelEm3qE1
	aQM1UNJhp7q4oeVpP6qwuqArbwk8DCTQLMjqRxvDL9eSW+7Cer7cWynPsp+Cbvc/p1Y51AhQKyRAq
	KynNsuLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58036)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q9067-00070u-R2; Tue, 13 Jun 2023 10:13:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q9065-0005tt-8B; Tue, 13 Jun 2023 10:13:53 +0100
Date: Tue, 13 Jun 2023 10:13:53 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 2/4] net: phylink: add EEE management
Message-ID: <ZIgzUZSKW0WsA0AC@shell.armlinux.org.uk>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9R-00DI8g-GF@rmk-PC.armlinux.org.uk>
 <bca7e7ec-3997-4d97-9803-16bfaf05d1f5@lunn.ch>
 <ZIY+szvNDxFCn94b@shell.armlinux.org.uk>
 <50a42dc7-02df-4052-abeb-7d7b9cd7225e@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50a42dc7-02df-4052-abeb-7d7b9cd7225e@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 12:25:29AM +0200, Andrew Lunn wrote:
> On Sun, Jun 11, 2023 at 10:37:55PM +0100, Russell King (Oracle) wrote:
> > On Sun, Jun 11, 2023 at 11:28:32PM +0200, Andrew Lunn wrote:
> > > On Fri, Jun 09, 2023 at 10:11:21AM +0100, Russell King (Oracle) wrote:
> > > > Add EEE management to phylink.
> > > 
> > > Hi Russell
> > > 
> > > I've been working on my EEE patches. I have all pure phylib drivers
> > > converted. I've incorporated these four patches as well, and make use
> > > of the first patch in phylib.
> > > 
> > > Looking at this patch, i don't see a way for the MAC to indicate it
> > > actually does support EEE. Am i missing it?
> > 
> > If a MAC doesn't support EEE, it won't have the necessary calls to
> > phylink_*_eee() in its ethtool ops. As can be seen from the mvpp2
> > patch, mvpp2_ethtool_get_eee() and mvpp2_ethtool_set_eee() are
> > needed to call the phylink methods.
> 
> This is a bit messy for stmmac. Some versions of stmmac have EEE
> support, some don't. Same is true for r8169, but that is a phylib
> driver. I expect there are other examples.

I see what you mean, but I think really what's going on there is
whether the MAC supports LPI or not coupled with whether the PHY has
any "smartEEE" feature meaning overall the system doesn't support
any kind of EEE.

The reason I pick that level of detail is when one comes to a setup
like i.MX6 FEC coupled with an AR8035 with it's SmartEEE, the system
as a whole supports EEE but the MAC doesn't. So, while the FEC would
have a MAC_CAP_EEE flag clear, we don't actually want to disable EEE
support with that setup.

> We also have the same problem with DSA. There is currently one
> phylink_mac_ops structure which has generic methods for all the
> callbacks which then call into the switch driver if the switch driver
> implements the call. And at least with the mv88e6xxx driver, when we
> get around to adding EEE support, some switches will support it, some
> won't, so will we need two different switch op structures?

I'd rather not end up with multiple mac_ops.

> Adding to the mac_capabilities just seems easier.

It does, but I suspect MAC_CAP_EEE is not sufficient because:

a) the issue of PHYs with SmartEEE like features such as AR803x.
b) an interface which has multiple MACs that it switches between
   depending on speed may have differing levels of LPI support,
   so a single property doesn't seem to be suitable.
c) rate adapting PHYs that may connect only with e.g. a 10G MAC that
   doesn't support LPI, but the MAC setup does have a 1G MAC that
   does.

I'm wondering if, rather than adding a bit to mac_capabilities, whether
instead:

1) add eee_capabilities and re-use the existing MAC_CAP_* definitions
   to indicate what speeds the MAC supports LPI. This doesn't seem to
   solve (c).
2) add a phy interface bitmap indicating which interface modes support
   LPI generation.

Phylib already has similar with its supported_eee link mode bitmap,
which presumably MACs can knock out link modes that they know they
wouldn't support.

Hmm.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

