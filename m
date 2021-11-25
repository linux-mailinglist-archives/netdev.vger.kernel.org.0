Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F4045DEB0
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhKYQqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhKYQoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 11:44:10 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F14C06137B
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 08:18:20 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id r25so27674273edq.7
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 08:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zk4bXUF1UKgSWVwLOk9BRxInFy3dMGT2T4gSYWoPaOI=;
        b=ZuZ70d3O+W3yTu4a25C5D3Lbgbwp25G9Pb9y8587HXuiC0d4gPJrR3kxovRcWITkIV
         NrB2og35ka8PqyeMdegItRurLpJtnoGXM/Flse4edx/krNTnH1fTA5LZdxOPsSzkVBlp
         15XwxxOnX+/SojOvomjrNLOh/Kqh9LlgB+MuDPCvc4exwaBfszp4+sUuvwuj3wdsx4xJ
         yWQ1MushPb7tw8ejKHyWnLbu9JvDCHH5qljK55ZrCREBhNuRmSMZUqGBJioPcamq60Al
         XUMwHzFx6J66slOELfBeo6jcNaTjjMl+UJymZG/wnnKJhRQ27NovX1VOxYT5XZ7xQZ18
         WvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zk4bXUF1UKgSWVwLOk9BRxInFy3dMGT2T4gSYWoPaOI=;
        b=LmQdg66vIzQQND0df6Vzs6G7oCI0OJbkPY6iPm1TCmY7dBTfyLsE61ApvwGgewOjvk
         GpkZCfah+4Q8VJXzWHi8N5+0H4lMMw9UNmmo8uv1E7BefQzjZ6fyRybpWPpVELsaCMEZ
         C/0y1DXcNgS6eVNbgKXTC5Vu1umyqp6vAsJ8p9HK8Dmc8SYOwmU12FTbLXDbT+D1VFXR
         1imxzU/ylLXl+/jJDQHjWoIsduIR7Ye8hlGKLgrTLTOFPsCgrruwIxi8EnMpPEvACzMQ
         0H6iDhaT9vNVBPY14oF+U6KqrR1Pbhlwa3Z8N9QqXs0m0oBQGDS52k5ppVnYUMPOGVe9
         rcRA==
X-Gm-Message-State: AOAM530erLdGFXeofdjzfdHVYSAqMVIet0WufGrTSGNnz0YI/W+gwGqT
        YbeTTY13XQ8ztNWYUVi6WBo=
X-Google-Smtp-Source: ABdhPJySA1Zr8F6WJupukiYY0XxSoObXctDiZNDnudFGydMAhrDOM0PoN4ugORfrzWt+PVI3po77MA==
X-Received: by 2002:a05:6402:3596:: with SMTP id y22mr40105610edc.297.1637857099160;
        Thu, 25 Nov 2021 08:18:19 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id y19sm2488758edc.17.2021.11.25.08.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 08:18:18 -0800 (PST)
Date:   Thu, 25 Nov 2021 18:18:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 11/12] net: dsa: sja1105: convert to
 phylink_generic_validate()
Message-ID: <20211125161817.xlg7o4expuo7kgzy@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwSN-00D8Lz-GB@rmk-PC.armlinux.org.uk>
 <20211124195339.oa7u4zyintrwr4tx@skbuf>
 <YZ6p0V0ZOEJLhgEH@shell.armlinux.org.uk>
 <20211124223432.w3flpx55hyjxmkwn@skbuf>
 <YZ7I/6i42LMtr2hS@shell.armlinux.org.uk>
 <20211124233200.s77wp6r7cx4okqh4@skbuf>
 <YZ+H95E9iI85mfax@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ+H95E9iI85mfax@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 12:56:23PM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 24, 2021 at 11:32:00PM +0000, Vladimir Oltean wrote:
> > On Wed, Nov 24, 2021 at 11:21:35PM +0000, Russell King (Oracle) wrote:
> > > Clearly, you have stopped listening to me. This can no longer be
> > > productive.
> > 
> > What is wrong with the second patch? You said I should split the change
> > that allows the SERDES protocol to be changed, and I did. You also said
> > I should make the change in behavior be the first patch, but that it's
> > up to me, and I decided not to make that change now at all.
> > 
> > As for why I prefer to send you a patch that I am testing, it is to make
> > the conversion process easier to you. For example you removed a comment
> > that said this MAC doesn't support flow control, and you declared flow
> > control in mac_capabilities anyway.
> > 
> > So no, I have not stopped listening to you, can you please tell me what
> > is not right?
> 
> Let's be clear: I find dealing with you extremely difficult and
> stressful. I don't find that with other people, such as Marek or
> Andrew. I don't know why this is, but every time we interact, it
> quickly becomes confrontational.

I assure you that I am no more confrontational with you than with others.
If I say something that is unpleasant, it isn't to bother you, it is
because it bothers me and I'd rather let you know. If what I am saying is
wrong, it's because I don't know any better. I'm sure it's the same for you.

> I don't want this, and the only way I can see to stop this is to stop
> interacting with you, which is obviously also detrimental.

You have practically stopped interacting with me already, I have phylink
patches for broken NXP boards that have been waiting for at least 2
months for you to review them:
https://patchwork.kernel.org/project/netdevbpf/cover/20210922181446.2677089-1-vladimir.oltean@nxp.com/

So yes, it is a problem that is blocking me as well. In fact, you are
also known to say that you're "getting to the point of wishing that
phylink did not have users except my own":
https://patchwork.kernel.org/project/linux-mediatek/cover/20200217172242.GZ25745@shell.armlinux.org.uk/#23436579

This is not what maintainers do, or say, and I'm not sure how a phylink
user is supposed to feel about it. Personally I am absolutely dreading
it, since phylink and Russell King the person are one and the same
thing, and if you don't share the same views as Russell King you are
effectively limited in what you can do. It is not fun.

I honestly don't know why you keep fabricating these strawmen that
conversations become confrontational due to me, it makes it appear to
the poor people on CC watching us fight that I am being overly
aggressive and you are out of strategies to defend. Do I need to remind
you how I was drawn into a totally unrelated discussion about dpaa2-eth
having a deadlock due to the rtnl_mutex being held at phylink_create()
time, and I tried to be helpful and understand the phylink and sfp-bus
design, and you ended up calling me flat-out stupid?
Here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210901225053.1205571-2-vladimir.oltean@nxp.com/

And you said: "if you think that's a valid approach, then quite frankly
I don't want you touching my code, because you clearly don't know what
you're doing as you aren't willing to put the necessary effort in to
understanding the code."

So if you treat in this way a person who is trying to help, then what
help do you need, and why do you complain that you aren't getting more
attention with your phylink conversions? You are Russell King, you don't
need any help.

> I don't have a solution to this.

I think a good start would be to reply strictly to actual code, and to
read code before replying, and try to avoid using phrases such as
"I don't want you touching my code", "I can bring a horse to water but
can't make it drink", "please stop being a problem", "you constantly
bitch and moan".

You might notice that things will start to improve.

> Now, as for your second patch, it didn't contain a changelog to
> indicate what had changed, and it looked like it was merely a re-post
> of the previously posted patch. Given how noisy the patch is due to
> the size of the changes being made, this is hardly surprising. There
> is a reason why we ask for changelogs when patches are modified, and
> this is *exactly* why.

Yes, it didn't contain a changelog. A non-confrontational reaction to
that would have been either to read the patch before commenting, or to
ask for a changelog if it was so noisy as you say it was. But instead,
your reaction was "Clearly, you have stopped listening to me. This can
no longer be productive." Talk about me being confrontational.

It is not even the first time you attack me personally on a patch
without reading it:
https://patchwork.ozlabs.org/project/netdev/patch/20200625152331.3784018-5-olteanv@gmail.com/
This time I didn't even tell you that it's annoying as I did last time,
I just asked what is wrong.

> Having saved out and diffed the two patches, I can now see the
> changes you've made. Now:
> 
> -       if (priv->info->supports_2500basex[port]) {
> -               phylink_set(mask, 2500baseT_Full);
> -               phylink_set(mask, 2500baseX_Full);
> +       if (phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
> +               config->mac_capabilities = MAC_2500FD;
> +       } else if (phy_interface_mode_is_rgmii(phy_mode) ||
> +                  phy_mode == PHY_INTERFACE_MODE_SGMII) {
> +               config->mac_capabilities = MAC_10FD | MAC_100FD | MAC_1000FD;
> +       } else {
> +               config->mac_capabilities = MAC_10FD | MAC_100FD;
>         }
> 
> This limitation according to the interface mode is done by the generic
> validation, so is unnecessary unless there really is a restriction on
> the capabilities of the MAC.
> 
> Given that the generic validation will only permit the 2.5G ethtool
> link modes, RGMII and SGMII will permit the 10, 100 and 1G ethtool link
> modes, and MII/RevMII/RMII/RevRMII will only permit the 10 and 100
> ethtool link modes, recoding this in the get_caps is rather pointless.

This is nitpicking. The variable is called "mac_capabilities" and that
is what I am reporting - MAC capabilities. I know what this variable is
being used for right now, which is limiting the PHY advertisement, but I
don't know what it is going to be used for in the future. Clearly there
is nothing wrong in reporting only the actual capabilities supported by
the MAC. I don't care if phylink_get_linkmodes() will automagically
remove MAC_2500FD for an RMII port, since RMII ports really do not
support MAC_2500FD I don't see why I would report it, in fact, as I've
explained to you in the comments to the ocelot patch, I believe that
phylink_get_linkmodes(), plus the way in which mac_capabilities is used
(specifically, the way in which we report it without it being a function
of PHY mode) does gratuitously break PAUSE-based rate adaptation if we
were to use the generic phylink implementation. I therefore find the
generic validation function to be of limited use.

> This also becomes less obvious that it is a correct conversion - one
> can't look at the old validate() code and the new get_caps() code and
> check that it's making the same decisions. The old validate code
> did:
> 
> - allow 10 and 100 FD
> - if mii->xmii_mode[port] is XMII_MODE_RGMII or XMII_MODE_SGMII
>   - allow 1000 FD
> - if priv->info->supports_2500basex[port]
>   - allow 2500 FD
> 
> The new code bases it off the PHY interface mode, and now one has to
> refer to the code in sja1105_init_mii_settings() to see what that is
> doing to work out whether it is making equivalent decisions.

And after looking at sja1105_init_mii_settings(), are the decisions
equivalent or not? My point being that even if I create a separate patch
which changes the decision making process from mii->xmii_mode to
priv->phy_mode, you'd still need to look at that function.

The patch has my sign off on it, and I tested it. Nobody will blame you
for any breakage. If you don't want to carry it, don't carry it, you
don't even need a reason to.

> In other words, it's changing how the decisions are made concerning
> which speeds (whether they are the MAC capabilities or ethtool link
> modes) _and_ converting to the new way of specifying those speeds.
> 
> I've made the decision to drop the sja1105 patch from this series as
> well as ocelot. Do whatever you want there, I no longer care, unless
> what you do causes me problems for phylink.

This is perfectly acceptable to me.

> Thanks.

No, thank you!
