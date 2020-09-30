Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DDC27E28C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 09:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgI3HZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 03:25:36 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51905 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbgI3HZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 03:25:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 790C75800D1;
        Wed, 30 Sep 2020 03:25:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Sep 2020 03:25:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=44Dd05
        leTjDWONi5AFHYRdQFsFgVavGpzQquHVI0sV8=; b=KskhIYxBycxjceuzY5+J2P
        3LZIZl8TmZysgj/4mSQrjZYIZk9PwvHeAl1kY+ne1oVzxpkA1ncGPBad4dr1SL2I
        6E7JTG+A5ac01k5JMH6xCZarqznlRYDR3OootaecFiHCUZswUDMmIzDUyjqzehL6
        TgiNWQrEMiumx9pkA8M4/zDHSZvyo78WKXdUb93Kk3HDIaDoyCpe4jNtiFL/GtPA
        1vHZ+i0OQLLW77TyvWX72237vr3kfQKNS1QQT0VQUv8gMZFvy2F0Y4JV8Cwm8p50
        Bf5dDEOQQ0k6lnRszmk8woxjFRsu4r++TuBoSMd155zFOq13McNSBqcNwkW4dgOQ
        ==
X-ME-Sender: <xms:7TJ0X2zYhelW5wXx_giTPk5HdSor-s4PuZSLdR0HW7nTIDVv4L5zvQ>
    <xme:7TJ0XyRK9CFdkHUB2OMbW5pMfaV0BGNGBh_7p50lHNT3cBStoz1xXlReoc-acwboZ
    oYrmt-f1vGBnek>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfedtgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvddvledrfeejrd
    dugeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7TJ0X4VBMHjZCS98kOSyhQddnynZhHPsJSpOE3-y73n6548cAMrTBQ>
    <xmx:7TJ0X8jP6Ij0i9CNejXGzJXXrzcw3x7KHTtYOOOJqxaX4oavERmhQw>
    <xmx:7TJ0X4Dsca4ZJUeMhcpSO0Qpp5aDHbsdmqwCkHBblARMnAiNYTCZpw>
    <xmx:7jJ0X2ClVJIMzy63COyXfPdnADoDEAylq0zA9ee96VQuh8Idzdvz0w>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FDDD3064610;
        Wed, 30 Sep 2020 03:25:32 -0400 (EDT)
Date:   Wed, 30 Sep 2020 10:25:29 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, ayal@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net] ethtool: Fix incompatibility between netlink and
 ioctl interfaces
Message-ID: <20200930072529.GA1788067@shredder>
References: <20200929160247.1665922-1-idosch@idosch.org>
 <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 06:44:55PM +0200, Michal Kubecek wrote:
> On Tue, Sep 29, 2020 at 07:02:47PM +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > With the ioctl interface, when autoneg is enabled, but without
> > specifying speed, duplex or link modes, the advertised link modes are
> > set to the supported link modes by the ethtool user space utility.
> > 
> [...] 
> > 
> > With the netlink interface, the same thing is done by the kernel, but
> > only if speed or duplex are specified. In which case, the advertised
> > link modes are set by traversing the supported link modes and picking
> > the ones matching the specified speed or duplex.
> > 
> > However, if speed nor duplex are specified, the driver is passed an
> > empty advertised link modes bitmap. This causes the mlxsw driver to
> > return an error. Other drivers might also be affected. Example:
> 
> This is not completely correct. What actually happens is that the
> advertised modes bitmap is left untouched. The reason why advertised
> modes are cleared for mlxsw is that this driver reports empty advertised
> modes whenever autonegotiation is disabled.

Correct. I'll reword.

> 
> This is similar to recent discussions about distinguishing between
> configuration and state. One of them was related to EEE settings, one to
> pause settings, one to WoL settings vs. general wakeup enable/disable:
> 
>   http://lkml.kernel.org/r/20200511132258.GT1551@shell.armlinux.org.uk
>   http://lkml.kernel.org/r/20200512185503.GD1551@shell.armlinux.org.uk
>   http://lkml.kernel.org/r/20200521192342.GE8771@lion.mk-sys.cz
> 
> All of these are about common problem: we have a settings A and B such
> that B is only effective if A is enabled. Should we report B as disabled
> whenever A is disabled? I believe - and the consensus in those
> discussions seemed to be - that we should report and set A and B
> independently to distinguish between configuration (what user wants) and
> state (how the device behaves). There is also practical aspect: (1) if
> we don't do this, switching A off and on would reset the value of B even
> if no change of B was requested and (2) commands setting A and B must be
> issued in a specific order for changes of B to take effect.
> 
> Unfortunately there are drivers like mlxsw (I'm not sure how many) which
> report zero advertised bitmap whenever autonegotiation is off.
> 
> > diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
> > index 7044a2853886..a9458c76209e 100644
> > --- a/net/ethtool/linkmodes.c
> > +++ b/net/ethtool/linkmodes.c
> > @@ -288,9 +288,9 @@ linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
> >  };
> >  
> >  /* Set advertised link modes to all supported modes matching requested speed
> > - * and duplex values. Called when autonegotiation is on, speed or duplex is
> > - * requested but no link mode change. This is done in userspace with ioctl()
> > - * interface, move it into kernel for netlink.
> > + * and duplex values, if specified. Called when autonegotiation is on, but no
> > + * link mode change. This is done in userspace with ioctl() interface, move it
> > + * into kernel for netlink.
> >   * Returns true if advertised modes bitmap was modified.
> >   */
> >  static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
> > @@ -381,7 +381,6 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
> >  	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
> >  
> >  	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
> > -	    (req_speed || req_duplex) &&
> >  	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
> >  		*mod = true;
> 
> I'm afraid we will have to cope with existing drivers hiding advertised
> mode setting when autonegotiation is off. Could we at least limit the
> call to such drivers, i.e. replacing that line with something like
> 
> 	(req_speed || req_duplex || (!old_autoneg && advertised_empty))
> 
> where old_autoneg would be the original value of lsettings->autoneg and
> advertised_empty would be set if currently reported advertised modes are
> zero?

I don't think so. Doing:

# ethtool -s eth0 autoneg

Is a pretty established behavior to enable all the supported advertise
bits. Here is an example with an unpatched kernel, two ethtool versions
(ioctl & netlink) and e1000 in QEMU.

Ioctl:

# ethtool --version
ethtool version 5.4

# ethtool -s eth0 advertise 0xC autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Half 100baseT/Full 
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: off (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes

# ethtool -s eth0 autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: off (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes

Netlink:

# ethtool --version
ethtool version 5.8

# ethtool -s eth0 advertise 0xC autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Half 100baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: off (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes

# ethtool -s eth0 autoneg on

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  100baseT/Half 100baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: off (auto)
        Supports Wake-on: umbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes
