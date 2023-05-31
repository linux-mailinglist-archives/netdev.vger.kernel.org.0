Return-Path: <netdev+bounces-6821-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A36171852C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E94F128150A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3212154B8;
	Wed, 31 May 2023 14:41:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA70FC8E6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:41:58 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC3711D
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=piKNaxGg1s627bAcIW7du+Jjmzx1cpqhDBH6+PlTHZ4=; b=DU7QuKY/EBGGwQ0EujX5hEPsMJ
	k5zVvc4uJDlvrnXnyaI9+3LpZMOdPNJKwNetuIjJ8Oe79b/9dnA1iGMPrO6TLSw2YSV+nyiRXwsjW
	8yVgfBu8DARi8KE6x0eWDgH6vwUTLqRfECBwclYiRWH+2NJPMSOZgxOam730KjjaROUtCg1m8x9Pk
	Pvzl6qHe9OMq3mTFeSfUVm9ll5pFIPl3CfqGgwNfhL98hejUdtDGW63lE6I1LLGWyBdd1KFMo94kF
	AGo6mZQrVQZczVpQBJMom4M0g+nS2tc599Tosr32vVjE/JVpkhv4IlDjvqw6eSbhA/bMLD6VAT0Zm
	MW4M4cgw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58806)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q4N1M-0004bG-P3; Wed, 31 May 2023 15:41:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q4N1K-0000lc-PY; Wed, 31 May 2023 15:41:50 +0100
Date: Wed, 31 May 2023 15:41:50 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	netdev <netdev@vger.kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Message-ID: <ZHdcrjANi/Uo0nLf@shell.armlinux.org.uk>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
 <ZHZQG+O9HkQ+5K62@shell.armlinux.org.uk>
 <ZHZTXjnvw5nt2rSl@shell.armlinux.org.uk>
 <20230531071419.GB17237@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531071419.GB17237@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 09:14:19AM +0200, Oleksij Rempel wrote:
> Hi Russell,
> 
> On Tue, May 30, 2023 at 08:49:50PM +0100, Russell King (Oracle) wrote:
> > On Tue, May 30, 2023 at 08:35:55PM +0100, Russell King (Oracle) wrote:
> > > Going back to phylib, given this, things get even more "fun" if you have
> > > a dual-media PHY. As there's no EEE capability bits for 1000base-X, but
> > > a 1000base-X PCS optionally supports EEE. So, even with a zero EEE
> > > advertisement with a dual-media PHY that would only affect the copper
> > > side, and EEE may still be possible in the fibre side... which makes
> > > phylib's new interpretation of "eee_enabled" rather odd.
> > > 
> > > In any case, "eee_enabled" I don't think has much meaning for the fibre
> > > case because there's definitely no control beyond what "tx_lpi_enabled"
> > > already offers.
> > > 
> > > I think this is a classic case where the EEE interface has been designed
> > > solely around copper without checking what the situation is for fibre!
> > 
> > Let me be a bit more explicit on this. If one does (e.g.) this:
> > 
> > # ethtool --set-eee eth0 advertise 0 tx-lpi on tx-timer 100
> > 
> > with a dual-media PHY, if the MAC is programmed to enable LPI, the
> > dual-media PHY is linked via fibre, and the remote end supports fibre
> > EEE, phylib will force "eee" to "off" purely on the grounds that the
> > advertisement was empty.
> > 
> > If one looks at the man page for ethtool, it says:
> > 
> >            eee on|off
> >                   Enables/disables the device support of EEE.
> > 
> > What does that mean, exactly, and how is it different from:
> > 
> >            tx-lpi on|off
> >                   Determines whether the device should assert its Tx LPI.
> > 
> > since the only control at the MAC is whether LPI can be asserted or
> > not and what the timer is.
> > 
> > The only control at the PHY end of things is what the advertisement
> > is, if an advertisement even exists for the media type in use.
> > 
> > So, honestly, I don't get what this ethtool interface actually intends
> > the "eee_enabled" control to do.
> 
> Thank you for your insightful observations on the EEE interface and its
> related complexities, particularly in the case of fiber interfaces.
> 
> Your comments regarding the functionality of eee_enabled and
> tx_lpi_enabled commands have sparked a good amount of thought on the
> topic. Based on my understanding and observations, I've put together a
> table that outlines the interactions between these commands, and their
> influence on the MAC LPI status, PHY EEE advertisement, and the overall
> EEE status on the link level.
> 
> For Copper assuming link partner advertise EEE as well:
> +------+--------+------------+----------------+--------------------------------+---------------------------------+
> | eee  | tx-lpi | advertise  | MAC LPI Status | PHY EEE Advertisement Status  | EEE Status on Link Level        |
> +------+--------+------------+----------------+--------------------------------+---------------------------------+
> | on   | on     |   !=0      | Enabled        | Advertise EEE for supported   | EEE enabled for supported       |
> |      |        |            |                | speeds                        | speeds (Full EEE operation)     |
> | on   | off    |   !=0      | Disabled       | Advertise EEE for supported   | EEE enabled for RX, disabled    |
> |      |        |            |                | speeds                        | for TX (Partial EEE operation)  |
> | off  | on     |   !=0      | Disabled       | No EEE advertisement          | EEE disabled                    |
> | off  | off    |   !=0      | Disabled       | No EEE advertisement          | EEE disabled                    |
> | on   | on     |    0       | Enabled        | No EEE advertisement          | EEE TX enabled, RX depends on   |
> |      |        |            |                |                               | link partner                    |
> | on   | off    |    0       | Disabled       | No EEE advertisement          | EEE disabled                    |
> | off  | on     |    0       | Disabled       | No EEE advertisement          | EEE disabled                    |
> | off  | off    |    0       | Disabled       | No EEE advertisement          | EEE disabled                    |
> +------+--------+------------+----------------+--------------------------------+---------------------------------+
> 
> For Fiber:
> +-----------+-----------+-----------------+---------------------+-------------------------+
> |     eee   |   tx-lpi  | PHY EEE Adv.    | MAC LPI Status      | EEE Status on Link Level|
> +-----------+-----------+-----------------+---------------------+-------------------------+
> |     on    |     on    |         NA      | Enabled             | EEE supported           |
> |     on    |     off   |         NA      | Disabled            | EEE not supported       |
> |     off   |     on    |         NA      | Disabled            | EEE not supported       |
> |     off   |     off   |         NA      | Disabled            | EEE not supported       |
> +-----------+-----------+-----------------+---------------------+-------------------------+
> 
> In my perspective, eee_enabled serves as a global administrative control for
> all EEE properties, including PHY EEE advertisement and MAC LPI status. When
> EEE is turned off (eee_enabled = off), both PHY EEE advertisement and MAC LPI
> status should be disabled, regardless of the tx_lpi_enabled setting.
> 
> On the other hand, advertise retains the EEE advertisement configuration, even
> when EEE is turned off. This way, users can temporarily disable EEE without
> losing their specific advertisement settings, which can then be reinstated when
> EEE is turned back on.

I agree. I've found phylib's interpretation to be weird, particularly
that the advertisement settings are lost if one sets eee_enabled to be
false. That alone makes eee_enabled entirely redundant.

To me, sane behaviour is exactly as you describe - if the user sets
eee_enabled false, but sets an advertisement, the kernel should store
the advertisement setting so it can be retrieved via get_eee(), ready
for use when eee_enabled is subsequently set true.

> In the context of fiber interfaces, where there is no concept of advertisement,
> the eee and tx-lpi commands may appear redundant. However, maintaining both
> commands could offer consistency across different media types in the ethtool
> interface.

Yes, because having a consistent behaviour is important for a user API.
Having a user API randomly change behaviour depending on what's behind
it leads to user confusion.

Consider the case of a dual-media PHY - should the behaviour of the
EEE setter/getter change depending on what media is in use? Clearly
not, since one normally configures the EEE _policy_ when configuring
the network device, rather than each time the link comes up.

Thanks for your input. I now have some patches that add:

1. generic EEE configuration helpers, which I hope phylib and phylink
   can both use for consistent behaviour.
2. phylink gaining infrastructure for EEE management both of existing
   phylib and also fibre setups.
3. mvneta converted to use phylink's implementation. I may also do
   mvpp2 as well as I have patches for EEE support there as well.

I hope to post the patches later today.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

