Return-Path: <netdev+bounces-6560-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF9C716EA5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1111D1C20D09
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855BD31F01;
	Tue, 30 May 2023 20:28:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78382200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:28:40 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F389F7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=FfZ7cjg6jP2cUC84njeyJaiBUPGjE57tY7swC6z7VRM=; b=rg7DmniTVFJ5Lytrfaaq2BjtBE
	3WbQxcc4QFap8eS2Xz8fsc9S05VLRF+FrEG5BzWlyQ2YpggIP2g4IkTj7gkINY8gtMeNpMDw/qx+u
	fxHuDEcZAQCHjCLcxrVM1uONUlo6ifNw1eZ/V+gkmwm50IPNyjAQ/tjauuUTfv55fw6tr5/yIOj4E
	6O4ulup35wNfSVa8G/xtdi6bcmecGw/QKtvUyoSAN5vGHr/NnSTyRDbpskLbxUUeNZUJNaZ/rocu9
	UM+BEvhFz5wph4rMR+ZfAR6ucqenpGq0NSjM2DDV4R2SQYSVZccwrgkVM84h7feyU3qVkOY1ZvMxC
	jiuJ2AUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59352)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q45xM-0003RV-Da; Tue, 30 May 2023 21:28:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q45xL-0008Mo-95; Tue, 30 May 2023 21:28:35 +0100
Date: Tue, 30 May 2023 21:28:35 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	netdev <netdev@vger.kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Message-ID: <ZHZcc/E/Hx1bnjcx@shell.armlinux.org.uk>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
 <d753d72c-6b7a-4014-b515-121dd6ff957b@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d753d72c-6b7a-4014-b515-121dd6ff957b@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 09:48:00PM +0200, Andrew Lunn wrote:
> On Tue, May 30, 2023 at 11:31:04AM -0700, Florian Fainelli wrote:
> > Hi Andrew, Russell,
> > 
> > On 3/30/23 17:54, Andrew Lunn wrote:
> > > Most MAC drivers get EEE wrong. The API to the PHY is not very
> > > obvious, which is probably why. Rework the API, pushing most of the
> > > EEE handling into phylib core, leaving the MAC drivers to just
> > > enable/disable support for EEE in there change_link call back, or
> > > phylink mac_link_up callback.
> > > 
> > > MAC drivers are now expect to indicate to phylib/phylink if they
> > > support EEE. If not, no EEE link modes are advertised. If the MAC does
> > > support EEE, on phy_start()/phylink_start() EEE advertisement is
> > > configured.
> > 
> > Thanks for doing this work, because it really is a happy mess out there. A
> > few questions as I have been using mvneta as the reference for fixing GENET
> > and its shortcomings.
> > 
> > In your new patches the decision to enable EEE is purely based upon the
> > eee_active boolean and not eee_enabled && tx_lpi_enabled unlike what mvneta
> > useed to do.
> 
> I don't really care much what we decide means 'enabled'. I just want
> it moved out of MAC drivers and into the core so it is consistent.
> 
> Russel, if you want to propose something which works for both Copper
> and Fibre, i'm happy to implement it. But as you pointed out, we need
> to decide where. Maybe phylib handles copper, and phylink is layered
> on top and handles fibre?

Phylib also handles fibre too with dual-media PHYs (such as 88E151x
and 88X3310), and as I've just pointed out, the recent attempts at
"fixing" phylib's handling particularly with eee_enabled have made it
rather odd.

That said, the 88E151x resolution of 1000BASE-X negotiation is also
rather odd, particularly with pause modes. So I don't trust one bit
that anyone is even using 88E151x in fibre setups - or if they are
they don't care about this odd behaviour.

Before we go any further, I think we need to hammer out eactly how the
ethtool EEE interface is supposed to work, because right now I can't
say that I fully understand it - and as I've said in my replies to
Florian recently, phylib's EEE implementation becomes utterly silly
when it comes to fibre.

In particular, we need to hammer out what the difference exactly is
between "eee_enabled" and "tx_lpi_enabled", and what they control,
and I suggest we look at it from the point of view of both copper
(where EEE is negotiated) and fibre (were EEE is optional, no
capability bits, no negotiation, so no advertisement.)

It seems fairly obvious to me that tx_lpi* are about the MAC
configuration, since that's the entity which is responsible for
signalling LPI towards the PHY(PCS) over GMII.

eee_active... what does "active" actually mean? From the API doc, it
means the "Result of the eee negotiation" which is fine for copper
links where EEE is negotiated, but in the case of fibre, there isn't
EEE negotiation, and EEE is optionally implemented in the PCS.

eee_enabled... doesn't seem to have a meaning as far as IEEE 802.3
goes, it's a Linux invention. Documentation says "EEE configured mode"
which is just as useful as a chocolate teapot for making tea, that
comment might as well be deleted for what use it is. To this day, I
have no idea what this setting is actually supposed to be doing.
It seemed sane to me that if eee_enabled is false, then we should
not report eee_active as true, nor should we allow the MAC to
generate LPI. Whether the advertisement gets programmed into the PHY
or not is something I never thought about, and I can't remember
phylib's old behaviour. Modern phylib treats eee_enabled = false to
program a zero advertisement, which means when reading back via
get_eee(), you get a zero advertisement back. Effectively, eee_active
in modern phylib means "allow the advertisement to be programmed
if enabled, otherwise clear the advertisement".

If it's simply there to zero the advertisement, then what if the
media type has no capability for EEE advertisement, but intrinsically
supports EEE. That's where phylib's interpretation falls down IMHO.

Maybe this ethtool interface doesn't work very well for cases where
there is EEE ability but no EEE advertisement? Not sure.

Until we get that settled, we can't begin to fathom how phylib (or
phylink) should make a decision as to whether the MAC should signal
LPI towards the media or not.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

