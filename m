Return-Path: <netdev+bounces-6427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D896E7163D8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33E2B1C20B9A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF4D23C6A;
	Tue, 30 May 2023 14:23:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A355521076
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:23:23 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891CB1702;
	Tue, 30 May 2023 07:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JB5w856AbvIstOIyH1LRsT5NgKxcolH3MM5jEqlJpow=; b=Dx/UbQ2+nJfzbKxm5WLF/uKidM
	3kD4QT3lf/3HTuA8Ahtwxt7R6dN2z+nqhxKbhVRbhfR1Doz2TRbqI6DLG1AgdzV8sjzsSk6l4Tkby
	U2Ky6b4JgsTEgUYRa0H40dVQAA6s6EMM1ezaGqZf99S2MA80xE4Dv9WWEiyue2XmyB2rEWLBhPfaj
	9FT/8M6I7Q1OqcYS4J0ykR1k06f2FBQuu9wtPp+8Rr0Zuyb6XCGhtY42JrLAQIIA21n6tH9GJYXLV
	f7HGhc044YMzcADGy618pBpVkY0x4fJ1qHCGVpVkijJ8O0JXROFXaQuTcLoBGIPEmydbrENX0YCre
	Xs4N5zdQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55210)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q40FU-0002vl-PU; Tue, 30 May 2023 15:22:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q40FT-00087Q-2P; Tue, 30 May 2023 15:22:55 +0100
Date: Tue, 30 May 2023 15:22:55 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Lukasz Majewski <lukma@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <ZHYGv7zcJd/Ad4hH@shell.armlinux.org.uk>
References: <20230530122621.2142192-1-lukma@denx.de>
 <ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
 <20230530160743.2c93a388@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530160743.2c93a388@wsk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:07:43PM +0200, Lukasz Majewski wrote:
> Hi Russell,
> 
> > On Tue, May 30, 2023 at 02:26:21PM +0200, Lukasz Majewski wrote:
> > > One can disable in device tree advertising of EEE capabilities of
> > > PHY when 'eee-broken-100tx' property is present in DTS.
> > > 
> > > With DSA switch it also may happen that one would need to disable
> > > EEE due to some network issues.
> > > 
> > > Corresponding switch DTS description:
> > > 
> > >  switch@0 {
> > > 	 ports {
> > > 		port@0 {
> > > 		reg = <0>;
> > > 		label = "lan1";
> > > 		phy-handle = <&switchphy0>;
> > > 		};
> > > 	}
> > > 	mdio {
> > > 		switchphy0: switchphy@0 {
> > > 		reg = <0>;
> > > 		eee-broken-100tx;
> > > 	};
> > > 	};
> > > 
> > > This patch adjusts the content of MDIO_AN_EEE_ADV in MDIO_MMD_AN
> > > "device" so the phydev->eee_broken_modes are taken into account
> > > from the start of the slave PHYs.  
> > 
> > This should be handled by phylib today in recent kernels without the
> > need for any patch (as I describe below, because the config_aneg PHY
> > method should be programming it.) Are you seeing a problem with it
> > in 6.4-rc?
> 
> Unfortunately, for this project I use LTS 5.15.z kernel.
> 
> My impression is that the mv88e6xxx driver is not handling EEE setup
> during initialization (even with v6.4-rc).
> 
> I've tried to replace genphy_config_eee_advert() with phy_init_eee, but
> it lacks the part to program PCS advertise registers.

Firstly, I would advise backporting the EEE changes. The older EEE
implementation was IMHO not particularly good (I think you can find
a record in the archives of me stating that the old interfaces were
just too quirky.)

Secondly, even if you program the PHY for EEE, unless you have
something like an Atheros AR803x PHY with its SmartEEE, EEE needs
the support of both the PHY and the MAC to which its connected to
in order to work. It's the MAC which is the "client" which says
to the PHY "I'm idle" and when both ends tell their PHYs that
they're idle, the media link can then drop into the low power
state.

The 88e6xxx internal PHYs will communicate their EEE negotiation
state back to the MACs, but for an external PHY, that won't happen,
and there is no code in the 88e6xxx driver to configure the MAC to
program the MAC to do EEE.

So, I'm wondering what's actually going on here... can you give
any more details about the hardware setup?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

