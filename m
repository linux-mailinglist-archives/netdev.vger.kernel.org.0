Return-Path: <netdev+bounces-8552-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFDB724857
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 155EB1C20AA8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C1030B81;
	Tue,  6 Jun 2023 15:56:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B2137B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:56:41 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1EB10DE;
	Tue,  6 Jun 2023 08:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=oOb0UwEClDB1Qka6QaDlB5BDDx21uX4az9r2VZIY7OQ=; b=BOBCO+KbEgtJzTxxohFX4kdX1q
	ru624IM0vblq9lILI68ln+63XaMu7FWQQVQvXyGT9Qils+x/Gn6fQMCLAQQ5W/QbxH3rihsst8tuM
	066hB/VKkgSoosdojJTBfm2cXVAMCsEIBmMMqs/fcRYRidPXMza3YHUtpXSKW3bmeUMdcH7LPFnZq
	M7hztsaUzrAcJ7/uppDAvexWWC1qGWa5X4icoYEDuh0YTpA8XE03/oPeJGjwQCTfff6IxRGqFNKnN
	Yiq7razeyv43PNPkwdQe1r/yR6/GbmteYKUKkYxxtd1V0/pUh2X3XJ/YXeut3cUK/PYj+wt5DY9nA
	KZ0DMYNg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56672)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6Z2t-00061Z-AQ; Tue, 06 Jun 2023 16:56:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6Z2p-0007HB-53; Tue, 06 Jun 2023 16:56:27 +0100
Date: Tue, 6 Jun 2023 16:56:27 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 0/5] Followup fixes for the dwmac and altera
 lynx conversion
Message-ID: <ZH9XK5yEGyoDMIs/@shell.armlinux.org.uk>
References: <20230606152501.328789-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606152501.328789-1-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 05:24:56PM +0200, Maxime Chevallier wrote:
> Hello everyone,
> 
> Here's another version of the cleanup series for the TSE PCS replacement
> by PCS Lynx. It includes Kconfig fixups, some missing initialisations
> and a slight rework suggested by Russell for the dwmac cleanup sequence.

Thanks, this is getting there, but now you've now made me read
altera_tse.c, and it suffers the same issue that dwmac-socfpga.c does:

        ret = register_netdev(ndev);
...
        priv->pcs = lynx_pcs_create_mdiodev(pcs_bus, 0);
...
        priv->phylink = phylink_create(&priv->phylink_config,

This means you're publishing before you've finished setup - which is
a racy thing to do, especially if the driver is a module.

Let's think about what could happen. register_netdev() adds the network
device to the net layer and publishes it to userspace. Userspace notices
a new network interface and configures it, causing tse_open() to be
called. However, priv->phylink has not yet been initialised.

tse_open() then does:

        ret = phylink_of_phy_connect(priv->phylink, priv->device->of_node, 0);

and phylink_of_phy_connect() attempts to dereference it's first
argument, resulting in a NULL pointer dereference. Even if that doesn't
get you, then:

        phylink_start(priv->phylink);

will.

Golden rule: setup everything you need first, and only once that's
complete, publish. If you publish before you've completed setup, then
you're giving permission for other stuff to immediately start making
use of what you've published, which may occur before the remainder of
the initialisation has completed.

Lastly, remember that phylink_start() can result in the link coming up
_immediately_ (that means mac_link_up() could be called before it's
returned), so I would hope that the Altera TSE driver is prepared
for that to happen before napi, queues, and rx dma are ready.

Not saying that there's anything wrong with this series (there isn't),
merely that there's more issues that ought to be resolved.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

