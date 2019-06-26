Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9669564DF
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfFZIq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:46:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36216 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbfFZIq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 04:46:29 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so2120182edq.3;
        Wed, 26 Jun 2019 01:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fjn2sDLr8BaQ4nlJ6Hyg2HDDv8IG3PYh78Ty/uhvVI8=;
        b=TxhVURRE2rYNtb5fcwF8krv3gy3AQKBMhIJHdf+I8lbjNQOgbRrnxQK8yGZN4qQ0fh
         k0U6nP1AAtQQVQMr8UGJw3MzOZ1gt5Yan3yO533X6ixp4lgXvWS8F3AoLBUxc4GtXnuy
         01UGpkc8qLP1duJAzBCwQVMxqm9QWucrCBg6550GwS6a7Sbc6TRGwI3MdqF7jP2izLtS
         Uw3B2j+lRQX75CLBBIGGYFFsur69Xh7Y1u6IKJKF4JfLe2CRLlI7mX3yC5Fhb0uXSydD
         cux5I8e0yURsDtXBIA0XHqy05BEaZS3wS1AB8oLxV3y2T/7/ce+3xmXfts6sb7HwPDWV
         Obdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fjn2sDLr8BaQ4nlJ6Hyg2HDDv8IG3PYh78Ty/uhvVI8=;
        b=DrBguax/syQwwrCGB605EwCt2fTcJI61I2OBn38AkC/0ZwguOtbiFa4nZBd2MFz5Qi
         Kv45n+Jam+G7NBeicdstoBwuFNTTRf0OOaPtA7BLSenXpM/Y/na07Su5BGM1L+wCMxct
         GkrCB7QbDom8QDsJoBwN4f1INZy7d54G+oO6TuUdjhQvhXLj8dO2VK58vE2MdEvhzWl1
         FiRGAdFeND+7yzBf+jGJJNYHqBF494R21Ljq6aSK3YUDDJ111VJHz5qQ1BEHY66tOCOk
         4npshUfwBl0nLcmv4zosPwHpl2B4aN75VKA9OeIgFGKxlz7+xtHdJaljDOMfkq/1Av1l
         nFqg==
X-Gm-Message-State: APjAAAWZncnfYrBLGJ0cDQq3lDL6WHQXoWcrVFsGmPK3iJO75omFVOfQ
        Rg1DGoezxl0X8gteURaDBOzt6hcHU1dHXfygwYM=
X-Google-Smtp-Source: APXvYqwf/K/knu0+iM5ES1LSY1PHHZBXEARQ9LCTaNB7G/VOVZVTEpQT69QXOkO4laDn74nJUyTT2IhwG2Hk+djRisA=
X-Received: by 2002:a17:906:19d3:: with SMTP id h19mr2938281ejd.300.1561538786751;
 Wed, 26 Jun 2019 01:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190624145251.4849-1-opensource@vdorst.com> <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk> <6f80325d-4b42-6174-e050-48626f7a3662@gmail.com>
 <20190625215329.5ubixxiwprnubwmv@shell.armlinux.org.uk> <CA+h21hqK0VMtHpZ6eka9ESuMhsFTw2mx+c0GYmxq4_G_YmiVpg@mail.gmail.com>
 <20190625225759.zztqgnwtk4v7milp@shell.armlinux.org.uk> <CA+h21hq_w8-96ehKYxcziSq1TjOjoKduZ+pB3umBfjODaKWd+A@mail.gmail.com>
 <20190626074158.odyrgzie7sv4ovtn@shell.armlinux.org.uk>
In-Reply-To: <20190626074158.odyrgzie7sv4ovtn@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 26 Jun 2019 11:46:15 +0300
Message-ID: <CA+h21hpkjHD07-o7W-5sUf+FqEeks17_W6VUROSDzdGokFvNWQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        sean.wang@mediatek.com, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, matthias.bgg@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        frank-w@public-files.de, netdev <netdev@vger.kernel.org>,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 at 10:42, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Jun 26, 2019 at 02:10:27AM +0300, Vladimir Oltean wrote:
> > On Wed, 26 Jun 2019 at 01:58, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Wed, Jun 26, 2019 at 01:14:59AM +0300, Vladimir Oltean wrote:
> > > > On Wed, 26 Jun 2019 at 00:53, Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> wrote:
> > > > >
> > > > > On Tue, Jun 25, 2019 at 11:24:01PM +0300, Vladimir Oltean wrote:
> > > > > > Hi Russell,
> > > > > >
> > > > > > On 6/24/19 6:39 PM, Russell King - ARM Linux admin wrote:
> > > > > > > This should be removed - state->link is not for use in mac_config.
> > > > > > > Even in fixed mode, the link can be brought up/down by means of a
> > > > > > > gpio, and this should be dealt with via the mac_link_* functions.
> > > > > > >
> > > > > >
> > > > > > What do you mean exactly that state->link is not for use, is that true in
> > > > > > general?
> > > > >
> > > > > Yes.  mac_config() should not touch it; it is not always in a defined
> > > > > state.  For example, if you set modes via ethtool (the
> > > > > ethtool_ksettings_set API) then state->link will probably contain
> > > > > zero irrespective of the true link state.
> > > > >
> > > >
> > > > Experimentally, state->link is zero at the same time as state->speed
> > > > is -1, so just ignoring !state->link made sense. This is not in-band
> > > > AN. What is your suggestion? Should I proceed to try and configure the
> > > > MAC for SPEED_UNKNOWN?
> > >
> > > What would you have done with a PHY when the link is down, what speed
> > > would you have configured in the phylib adjust_link callback?  phylib
> > > also sets SPEED_UNKNOWN/DUPLEX_UNKNOWN when the link is down.
> > >
> >
> > With phylib, I'd make the driver ignore the speed and do nothing.
> > With phylink, I'd make the core not call mac_config.
> > But what happened is I saw phylink call mac_config anyway, said
> > 'weird' and proceeded to ignore it as I would have for phylib.
> > I'm just not understanding your position - it seems like you're
> > implying there's a bug in phylink and the function call with
> > MLO_AN_FIXED, state->link=0 and state->speed=-1 should not have taken
> > place, which is what I wanted to confirm.
>
> It is not a bug.  It is a request to configure the MAC, and what it's
> saying is "we don't know what speed and/or duplex".
>
> Take for instance when the network adapter is brought up initially.
> The link is most likely down, but we should configure the initial MAC
> operating parameters (such as the PHY interface).  Phylink makes a
> mac_config() call with the speed and duplex set to UNKNOWN.
>
> Using your theory, we shouldn't be making that call.  In which case,
> MAC drivers aren't going to initially configure their interface
> settings.
>
> _That_ would be a bug.
>

So you're saying that:
- state->link should not be checked, because it is not guaranteed to be valid
- state->speed, state->duplex, state->pause *should* be checked,
because it is not guaranteed to be valid
Is state->interface always valid?
I don't think I follow the pattern here. Or shouldn't I check speed,
duplex and pause either, and try to pass the MAC UNKNOWN values,
inevitably failing at some point? Do Marvell MACs have an UNKNOWN
setting?


> > It's unlikely that it would switch between SGMII and USXGMII
> > > dynamically, as USXGMII supports speeds from 10G down to 10M.
> > >
> > > Where interface mode switching tends to be used is with modes such
> > > as 10GBASE-R, which doesn't support anything except 10G.  In order
> > > for the PHY to operate at slower speeds, it has a few options:
> > >
> > > 1) perform rate adaption.
> > > 2) dynamically switch interface type to an interface type that
> > >    supports the desired speed.
> > > 3) just not support slower speeds.
> > >
> >
> > So am I reading this correctly - it kind of makes sense for gigabit
> > MAC drivers to not check for the MII interface changing protocol?
>
> Again, that's incorrect in the general case.  Gigabit includes SGMII
> and 802.3z PHY protocols which need to be switched between for SFPs.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Thanks,
-Vladimir
