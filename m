Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E5256512
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbfFZJEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:04:55 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38632 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZJEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 05:04:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3fcGHGnGX2V74bhIeEY8hWorkhuv6lOMdsSjSB+ZTm4=; b=dfMMZqgQwuvbvu6f/byZxgiSw
        OKoCErik3sXO4kJTr2a/9z+zfQaBxW3OPsN42gS6UGF79jzrd36IskpLGb6ypD6xzpR1mflY75mhf
        wG17dXkFMIonU4wzzG9aNfIG8NMj15WHsR4KhiiyX62EB/B60iy/ZgJG24LWE/J0TkapiI2la4V25
        yCreoShopKkuBJCfPGS8F0IAbZ4LrcFtoKUaDCqJVj264ApGj85mg0VFYOAJI3DReifd6hVlOrbep
        BndbUOQiJuNLjEMlgBag95OIh07C62/siRFH4WfNn0hi6yZj4m0X8w+mUTANTEVnhIQsPO/+n4b9l
        73djpMzNQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60022)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hg3rC-0003t3-MO; Wed, 26 Jun 2019 10:04:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hg3r5-00082b-84; Wed, 26 Jun 2019 10:04:39 +0100
Date:   Wed, 26 Jun 2019 10:04:39 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        sean.wang@mediatek.com, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, matthias.bgg@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        frank-w@public-files.de, netdev <netdev@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Message-ID: <20190626090439.fwv6fh6thg2j4t74@shell.armlinux.org.uk>
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <6f80325d-4b42-6174-e050-48626f7a3662@gmail.com>
 <20190625215329.5ubixxiwprnubwmv@shell.armlinux.org.uk>
 <CA+h21hqK0VMtHpZ6eka9ESuMhsFTw2mx+c0GYmxq4_G_YmiVpg@mail.gmail.com>
 <20190625225759.zztqgnwtk4v7milp@shell.armlinux.org.uk>
 <CA+h21hq_w8-96ehKYxcziSq1TjOjoKduZ+pB3umBfjODaKWd+A@mail.gmail.com>
 <20190626074158.odyrgzie7sv4ovtn@shell.armlinux.org.uk>
 <CA+h21hpkjHD07-o7W-5sUf+FqEeks17_W6VUROSDzdGokFvNWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpkjHD07-o7W-5sUf+FqEeks17_W6VUROSDzdGokFvNWQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 11:46:15AM +0300, Vladimir Oltean wrote:
> On Wed, 26 Jun 2019 at 10:42, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Wed, Jun 26, 2019 at 02:10:27AM +0300, Vladimir Oltean wrote:
> > > On Wed, 26 Jun 2019 at 01:58, Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Wed, Jun 26, 2019 at 01:14:59AM +0300, Vladimir Oltean wrote:
> > > > > On Wed, 26 Jun 2019 at 00:53, Russell King - ARM Linux admin
> > > > > <linux@armlinux.org.uk> wrote:
> > > > > >
> > > > > > On Tue, Jun 25, 2019 at 11:24:01PM +0300, Vladimir Oltean wrote:
> > > > > > > Hi Russell,
> > > > > > >
> > > > > > > On 6/24/19 6:39 PM, Russell King - ARM Linux admin wrote:
> > > > > > > > This should be removed - state->link is not for use in mac_config.
> > > > > > > > Even in fixed mode, the link can be brought up/down by means of a
> > > > > > > > gpio, and this should be dealt with via the mac_link_* functions.
> > > > > > > >
> > > > > > >
> > > > > > > What do you mean exactly that state->link is not for use, is that true in
> > > > > > > general?
> > > > > >
> > > > > > Yes.  mac_config() should not touch it; it is not always in a defined
> > > > > > state.  For example, if you set modes via ethtool (the
> > > > > > ethtool_ksettings_set API) then state->link will probably contain
> > > > > > zero irrespective of the true link state.
> > > > > >
> > > > >
> > > > > Experimentally, state->link is zero at the same time as state->speed
> > > > > is -1, so just ignoring !state->link made sense. This is not in-band
> > > > > AN. What is your suggestion? Should I proceed to try and configure the
> > > > > MAC for SPEED_UNKNOWN?
> > > >
> > > > What would you have done with a PHY when the link is down, what speed
> > > > would you have configured in the phylib adjust_link callback?  phylib
> > > > also sets SPEED_UNKNOWN/DUPLEX_UNKNOWN when the link is down.
> > > >
> > >
> > > With phylib, I'd make the driver ignore the speed and do nothing.
> > > With phylink, I'd make the core not call mac_config.
> > > But what happened is I saw phylink call mac_config anyway, said
> > > 'weird' and proceeded to ignore it as I would have for phylib.
> > > I'm just not understanding your position - it seems like you're
> > > implying there's a bug in phylink and the function call with
> > > MLO_AN_FIXED, state->link=0 and state->speed=-1 should not have taken
> > > place, which is what I wanted to confirm.
> >
> > It is not a bug.  It is a request to configure the MAC, and what it's
> > saying is "we don't know what speed and/or duplex".
> >
> > Take for instance when the network adapter is brought up initially.
> > The link is most likely down, but we should configure the initial MAC
> > operating parameters (such as the PHY interface).  Phylink makes a
> > mac_config() call with the speed and duplex set to UNKNOWN.
> >
> > Using your theory, we shouldn't be making that call.  In which case,
> > MAC drivers aren't going to initially configure their interface
> > settings.
> >
> > _That_ would be a bug.
> >
> 
> So you're saying that:
> - state->link should not be checked, because it is not guaranteed to be valid

state->link is undefined.

> - state->speed, state->duplex, state->pause *should* be checked,

These will always be valid for FIXED and PHY modes, but _may_ be
UNKNOWN, meaning phylink does not have any information about what
the speed should be.

speed and duplex are not defined for inband modes, since the purpose
of inband modes is to communicate this information through... inband
information, which the MAC driver already has access to.  pause is
a different matter because it is present in some inband modes but
not others.

Which fields may be examined are now documented in the phylink
documentation in mainline kernels.

> Is state->interface always valid?

Yes.

> I don't think I follow the pattern here. Or shouldn't I check speed,
> duplex and pause either, and try to pass the MAC UNKNOWN values,
> inevitably failing at some point? Do Marvell MACs have an UNKNOWN
> setting?

Why do you think that just because state->speed is SPEED_UNKNOWN you
have to dream up some weird "unknown" value for the MAC?  Default it
to something sensible, just like you would do if phylib reports
SPEED_UNKNOWN during link-down.  I really don't get what the problem
is here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
