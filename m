Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A901AFB43
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 16:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgDSONF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgDSONF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 10:13:05 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5681C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 07:13:04 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id j20so5269283edj.0
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 07:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jsEvy6vdo/azPNMPdc9WAMNjMSAW6sUuG0n0GkdqZok=;
        b=k3N3HNzfe/3tHejtr4x5hVjar6hKLG6GWgSJj5F92QhYxkHldhKQFkRpRfZfEnYCTI
         FXxAkAw31dYeaEjeyHePmVwSEgkZkHKzhXFfD7m9sODjLR0lpI9JwacWU04Mh6dO7ocN
         ZEl2COd2PP+bHXtr+SyRi/MxQ4snc6LKJVifcGVslvwOz369HLEbvj8K4pMLWLlQAoMP
         cOchxrlLCbOvSZuA9YyFJhQAn5HgT53qg7itov1omCnt7Lv1nshQERKTUDcSCiO3vWVg
         FlwEENPLWIm8JSzxeKbku8lygpUM+kryGunkMqzsem7wWksDJccFO5W5dwSXXu2Zs6fm
         jNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jsEvy6vdo/azPNMPdc9WAMNjMSAW6sUuG0n0GkdqZok=;
        b=dq7XOaImCy8iDryIx2c9VhKQzBNGaERuUfjoe7S2OQiEMiLRFVafin+YaFF1bdzWya
         kBGv3u/ufIs+5Pb2wVsKa2PkAa9bERNcBRIcznlaM3t/LigndaLl/fyYjOvw2qPTs6Gq
         s3uJBcaLoxawxSczm9hGn/4JXALVSYDmQgOH3ayU6pb8EvFPpiGkF5DcHc2TqwqQC0X3
         JQmvc3Ee04Av8qL3g4vP3JAKqX2grMvwIXU0eK1hqqk3zpkTgLwAf5uw9nhKd3K/Oxz3
         JBBbrryNnwBpDfJ5RrM3Fp/vMeEu9EXEj3Pnwf8jxO/uP0yei2/mOcftRqxySHQc3rqT
         5g8Q==
X-Gm-Message-State: AGi0PuYIcH3RskaSYaICCldQyo4tjzj806WN6R0y6etv6xGE6QsjRx0r
        CmH2QubW5b0itxky8c4riYKos3gN1m0op5AUtx8=
X-Google-Smtp-Source: APiQypLLEDZOlrU+OUf9OjY9Z9Mnle6DkWM/gt1OR4eWTFJJkq+iROyl2nJPaQmqRc9Q7TaqKKWkyVTLiLGrP1ttf3I=
X-Received: by 2002:a05:6402:1422:: with SMTP id c2mr4669901edx.179.1587305582885;
 Sun, 19 Apr 2020 07:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200417190308.32598-1-olteanv@gmail.com> <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
 <20200419083032.GA3479405@splinter> <CA+h21hrqjXGUERKUXCWiciP7ZGnjhTeq=+ocMyP5msrKZ3pGSw@mail.gmail.com>
 <20200419135143.GA3487966@splinter>
In-Reply-To: <20200419135143.GA3487966@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 19 Apr 2020 17:12:51 +0300
Message-ID: <CA+h21hrmcGFH1BhGygrhz2DxfoL1tKAT0hhZOkmAnxhcXxZdsw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, Po Liu <po.liu@nxp.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Apr 2020 at 16:51, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Sun, Apr 19, 2020 at 03:47:01PM +0300, Vladimir Oltean wrote:
> > Hi Ido, Allan,
> >
> > On Sun, 19 Apr 2020 at 11:30, Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > On Sun, Apr 19, 2020 at 09:33:07AM +0200, Allan W. Nielsen wrote:
> > > > Hi,
> > > >
> > > > Sorry I did not manage to provide feedback before it was merged (I will
> > > > need to consult some of my colleagues Monday before I can provide the
> > > > foll feedback).
> > > >
> > > > There are many good things in this patch, but it is not only good.
> > > >
> > > > The problem is that these TCAMs/VCAPs are insanely complicated and it is
> > > > really hard to make them fit nicely into the existing tc frame-work
> > > > (being hard does not mean that we should not try).
> > > >
> > > > In this patch, you try to automatic figure out who the user want the
> > > > TCAM to be configured. It works for 1 use-case but it breaks others.
> > > >
> > > > Before this patch you could do a:
> > > >     tc filter add dev swp0 ingress protocol ipv4 \
> > > >             flower skip_sw src_ip 10.0.0.1 action drop
> > > >     tc filter add dev swp0 ingress \
> > > >             flower skip_sw src_mac 96:18:82:00:04:01 action drop
> > > >
> > > > But the second rule would not apply to the ICMP over IPv4 over Ethernet
> > > > packet, it would however apply to non-IP packets.
> > > >
> > > > With this patch it not possible. Your use-case is more common, but the
> > > > other one is not unrealistic.
> > > >
> > > > My concern with this, is that I do not think it is possible to automatic
> > > > detect how these TCAMs needs to be configured by only looking at the
> > > > rules installed by the user. Trying to do this automatic, also makes the
> > > > TCAM logic even harder to understand for the user.
> > > >
> > > > I would prefer that we by default uses some conservative default
> > > > settings which are easy to understand, and then expose some expert
> > > > settings in the sysfs, which can be used to achieve different
> > > > behavioral.
> > > >
> > > > Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
> > > > understand default.
> > > >
> > > > But I do seem to recall that there is a way to allow matching on both
> > > > SMAC and SIP (your original motivation). This may be a better default
> > > > (despite that it consumes more TCAM resources). I will follow up and
> > > > check if this is possible.
> > > >
> > > > Vladimir (and anyone else whom interested): would you be interested in
> > > > spending some time discussion the more high-level architectures and
> > > > use-cases on how to best integrate this TCAM architecture into the Linux
> > > > kernel. Not sure on the outlook for the various conferences, but we
> > > > could arrange some online session to discuss this.
> > >
> > > Not sure I completely understand the difficulties you are facing, but it
> > > sounds similar to a problem we had in mlxsw. You might want to look into
> > > "chain templates" [1] in order to restrict the keys that can be used
> > > simultaneously.
> > >
> > > I don't mind participating in an online discussion if you think it can
> > > help.
> > >
> > > [1] https://github.com/Mellanox/mlxsw/wiki/ACLs#chain-templates
> >
> > I think it is worth giving a bit of context on what motivated me to
> > add this patch. Luckily I believe I can summarize it in a paragraph
> > below.
> >
> > I am trying to understand practical ways in which IEEE 802.1CB can be
> > used - an active redundancy mechanism similar to HSR/PRP which relies
> > on sending sequence-numbered frame duplicates and eliminating those
> > duplicates at the destination (as opposed to passive redundancy
> > mechanisms such as RSTP, MRP etc which rely on BLOCKING port states to
> > stop L2 forwarding loops from killing the network). So since 802.1CB
> > needs a network where none of the port states can be put to BLOCKING
> > (as that would break the forwarding of some of the replicated
> > streams), I need a way to limit the impact of L2 loops. Currently I am
> > using, rather successfully, an idea borrowed from HSR called
> > "self-address filtering". It says that received packets can be dropped
> > if their source MAC address matches the device's MAC address. This
> > feature is useful for ensuring that packets never traverse a ring
> > network more than once.
> > To implement this idea, I use an offloaded tc-flower rule matching on
> > src_mac with an action of "drop".
> >
> > To my surprise, such a src_mac rule does not do what's written on the
> > box with the Ocelot switch flow classification engine called VCAP IS2.
> > That is, packets having that src_mac would only get dropped if their
> > protocol is not ARP, SNAP, IPv4, IPv6 and maybe others. Clearly such a
> > rule is less than useful for the purpose we want it to.
> > I did raise this concern here, and the suggestion that I got is to
> > implement something like this patch, aka enable a port setting which
> > forces matches on MAC_ETYPE keys only, regardless of higher-layer
> > protocol information:
> > https://lkml.org/lkml/2020/2/24/489
> > So the default (pre-patch) behavior is for IP (and other) matches to
> > be sane, at the expense of MAC matches being insane.
> > Whereas the current behavior is for MAC matches to be sane, at the
> > expense of IP matches becoming impossible as long as MAC rules are
> > also present.
> > In this context, Allan's complaint seems to be that the MAC matches
> > were "good enough" for them, even if not all MAC address matches were
> > caught, at least it did not prevent them from installing IP matching
> > rules on the same port.
> >
> > I may not have completely understood Ido's suggestion to use
> > FLOW_CLS_TMPLT_CREATE (I might lack the imagination of how it can be
> > put to practical use to solve the clash here), but I do believe that
> > it is only a way for the driver to eliminate the guesswork out of the
> > user's intention.
>
> I was under the impression that you can't mix different keys (e.g.,
> src_mac + src_ip), but now I understand that you can't mix different
> keys in case of specific key *values*. This will work correctly:
>
> $ tc filter add dev swp0 ingress proto ip \
>         flower src_ip 192.0.2.1 action drop
> $ tc filter add dev swp0 ingress proto 0x88f7 \
>         flower src_mac 00:11:22:33:44:55 action drop
>

Yes.

> This will not work correctly:
>
> $ tc filter add dev swp0 ingress proto ip \
>         flower src_ip 192.0.2.1 action drop
> $ tc filter add dev swp0 ingress proto all \
>         flower src_mac 00:11:22:33:44:55 action drop
>

Yes.

> Correct? If so, I don't think the templates can help you. They are about
> forcing only specific keys, regardless of value.
>

Looking at mlxsw_sp_flower_tmplt_create, I'm not quite sure how it
works (what are the function's effects), but from the verbal
description it doesn't look like they help here.

> > In this case, my personal opinion is that the intention is absolutely
> > clear: a classifier with src_mac should match on all frames having
> > that src_mac (if that is not commonly agreed here, a good rule of
> > thumb is to compare with what a non-offloaded tc filter rule does).
>
> I agree.
>
> > Whereas the "non-problematic" MAC matches that the VCAP IS2 _is_ able
> > to still perform [ without calling ocelot_match_all_as_mac_etype ]
> > should be expressed in terms of a more specific classification key to
> > tc, such as:
>
> Yes.
>
> >
> > tc filter add dev swp0 ingress *protocol 0x88f7* flower src_mac
> > 96:18:82:00:04:01 action drop
> >
> > In the above case, because "protocol" is not ipv4, ipv6, arp, snap,
> > then these rules can happily live together without ever needing to
> > call ocelot_match_all_as_mac_etype. If we agree on this solution, I
> > can send a patch that refines the ocelot_ace_is_problematic_mac_etype
> > function.
>
> I think it makes sense. You are basically being explicit about the
> hardware limitations and denying configurations that cannot always work.
> Previous approach was to allow configurations that sometimes work.

And current approach is to deny some configurations that do work. I
should fix that.

Thanks,
-Vladimir
