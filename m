Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507CA61785
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfGGVAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 17:00:15 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46732 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfGGVAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 17:00:15 -0400
Received: by mail-ed1-f67.google.com with SMTP id d4so12687955edr.13;
        Sun, 07 Jul 2019 14:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fkR+/TIBGJ7pdEK4yHNC0wg1OJDkQWPgTQd8sWHKmTs=;
        b=KX5XrZZHK1/agaweQcF8s3PcLaRoZTwykn2zWjrFAR46HWcXh9sazhak0tayOWcOjg
         T3qAEtU/nV1KpIqYOij80PZug6GuTaEatOlmDw44F0qdL9CeJZ+TQLjzCxtEjFcfx6QB
         yYlWZGcARJNpRwsaOBUyQTxGar9A5Ng49WJHj882NrQdbI81iKCnVUy6uPkmYv+MioOo
         K2TknjbFxp35GdI9rhPRPxZGh3a1OIBvlXOYxiRvqLxcNElJpLZax8EO0a6mAsl6Hrzf
         V1SizKPwxPLPLxhp1P/Yu5CaBfngdsssM4m+6MhSef2y4cjZA+FseV6d6P9cgvJGh38L
         pDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fkR+/TIBGJ7pdEK4yHNC0wg1OJDkQWPgTQd8sWHKmTs=;
        b=MGfa8oPdmLCD+Gsnhc693pOgbNMbCN38txyW1mFYR7p1ZdDKd3+NDTAGAGzAjCUk1l
         5tmzj1qD2U+qdP0q6IZGuxgTvXkVIQ/nfu83qFuW/zcC1sPCwapDtbZlI2Dd2ua9JQHi
         ZLF3Ojx8T5o/QHfKVf0M4D1nLn3H467b1KL6MXW9dcG+DRT+18i9B68eXxGkNhPDV1IB
         AZ0veULhwdDFBp6t9fBI0pGt3l/VxB+gZqM5HTxSp37eyEBkcF2N9MAK+ljWQ/kjliVM
         nlv/4nQvWLj9Rdf+KvB+osB6AxT0hoBZrawJYz3+9OSKgDeT3oSwyblZ3aCXNQmOts+r
         0MwQ==
X-Gm-Message-State: APjAAAU6bXb1lDbIQYx22tMI/DJS2P3whlLJT65D5ot4LklZX3n0TAtM
        p3Vl8shtINUnTC2VVpA2+DKmnHK7qh9imQfTp08=
X-Google-Smtp-Source: APXvYqz2zyWUgNt44NYISgVAThwiY8R8BY2btflpeuq/DMR1ga25hzBVzdiN9I+a6Ep2cjA+A0F8clWOohsYJa3oZAk=
X-Received: by 2002:aa7:c559:: with SMTP id s25mr16386016edr.117.1562533212254;
 Sun, 07 Jul 2019 14:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch> <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net> <20190624142625.GR31306@lunn.ch>
 <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
 <20190624162431.GX31306@lunn.ch> <20190624182614.GC5690@piout.net>
 <CA+h21hqGtA5ou7a3wjSuHxa_4fXk4GZohTAxnUdfLZjV3nq5Eg@mail.gmail.com>
 <20190705044945.GA30115@lunn.ch> <CA+h21hqU1H1PefBWKjnsmkMsLhx0p0HJTsp-UYrSgmVnsfqULA@mail.gmail.com>
 <c60df66a-b3c9-1445-36c6-cad7c6b75550@gmail.com>
In-Reply-To: <c60df66a-b3c9-1445-36c6-cad7c6b75550@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 8 Jul 2019 00:00:01 +0300
Message-ID: <CA+h21hqGEf4hoeBQ-cSGsiOWUD7bVX4=NWcJjwdYHOVonangAw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Jul 2019 at 19:03, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 7/5/2019 2:08 AM, Vladimir Oltean wrote:
> > Hi Andrew,
> >
> > On Fri, 5 Jul 2019 at 07:49, Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> Hi Vladimir
> >>
> >>> - DSA is typically used for discrete switches, switchdev is typically
> >>> used for embedded ones.
> >>
> >> Typically DSA is for discrete switches, but not exclusively. The
> >> b53/SF2 is embedded in a number of Broadcom SoCs. So this is no
> >> different to Ocelot, except ARM vs MIPS. Also, i would disagree that
> >> switchdev is used for embedded ones. Mellonex devices are discrete, on
> >> a PCIe bus. I believe Netronome devices are also discrete PCIe
> >> devices. In fact, i think ocelot is the only embedded switchdev
> >> switch.
> >>
> >> So embedded vs discrete plays no role here at all.
> >>
> >
> > drivers/staging/fsl-dpaa2/ethsw/ is another example of switchdev
> > driver for an embedded switch.
> > I would give it to you that the sample size is probably too small to
> > say 'typically', but my point was that in order to support cascaded
> > switches it makes more sense for those to be discrete.
> >
> >>> - The D in DSA is for cascaded switches. Apart from the absence of
> >>> such a "Ocelot SoC" driver (which maybe can be written, I don't know),
> >>> I think the switching core itself has some fundamental limitations
> >>> that make a DSA implementation questionable:
> >>
> >> There is no requirement to implement D in DSA. In fact, only Marvell
> >> does. None of the other switches do. And you will also find that most
> >> boards with a Marvell switch use a single device. D in DSA is totally
> >> optional. In fact, DSA is built from the ground up that nearly
> >> everything is optional. Take a look at mv88e6060, as an example. It
> >> implements nearly nothing. It cannot even offload a bridge to the
> >> switch.
> >>
> >
> > Let me see if I get your point.
> > The D is optional, and the S is optional. So what's left? :)
> > Also, there's a big difference between "the hardware can't do it" and
> > "the driver doesn't implement it". If I follow your argument, would
> > you write a DSA driver for a device that doesn't do L2 switching?
> > Along that same line, what benefit does the DSA model bring to a
> > switch that can't do cascading, compared to switchdev? I'm asking this
> > as a user, not as a developer.
>
> As an user, I don't think there are compelling arguments to either
> switchdev or DSA because the end result is the same: network devices
> that can offload "stuff". As a developer though, there is much less code
> to write with DSA than with switchdev to get your HW live.
>
> >
> >>> So my conclusion is that DSA for Felix/Ocelot doesn't make a lot of
> >>> sense if the whole purpose is to hide the CPU-facing netdev.
> >>
> >> You actually convinced me the exact opposite. You described the
> >> headers which are needed to implement DSA. The switch sounds like it
> >> can do what DSA requires. So DSA is the correct model.
> >>
> >>      Andrew
> >
> > Somebody actually asked, with the intention of building a board, if
> > it's possible to cascade the LS1028A embedded switch (Felix) with
> > discrete SJA1105 devices - Felix being at the top of the switch tree.
> > Does the DSA model support heterogeneous setups (parsing stacked
> > headers)? I can't tell if that's how EDSA tags work. With switchdev
> > for Felix there wouldn't be any problem - it just wouldn't be part of
> > the DSA tree and its own driver would remove its tags before DSA would
> > look at the rest.
>
> DSA not does not make any particular assumptions about how the stacking
> is done actually because each slave network device is expected to
> provided standard Ethernet frames to the network stack. How you get to
> that point is entirely specific to what the hardware can do.
>
> You do what Andrew described about one of my setup (bcm_sf2 w/ tagging
> enabled and b53 w/o tagging, see more below why [1]]) and both being
> discrete switch trees, with the master netdev of the b53 being a slave
> netdev provided by bcm_sf2. If your tagging protocol supports it you can
> make them part of the same DSA switch tree and just have them have
> different switch identifiers, that is what Marvell switches do and it
> works just great. In your case, I suppose you could even use double VLAN
> tagging to get such cascading to work, that would limit you to a two
> level of cascading, unless you invent something custom.
>
> [1]: The original Broadcom tag format introduced with BCM5325/5365 did
> support cascading in the same way that Marvell did where a switch
> identifier can be added in addition to a port number within the tag. The
> newest Broadcom tag that was introduced with 5395 and newer dropped
> support for the switch identifier and the switch will "terminate" the
> first (from start of Ethernet frame) tag that it receives. This is the
> reason why we need to disable tagging on the outermost B53 device that
> we are connected to. This means those network devices are mainly
> configuration endpoints and not passing data (DSA_TAG_PROTO_NONE),
> though we could use DSA_TAG_PROTO_8021Q and resolve that now.
> --
> Florian

Thanks to both of you for sharing this trick, I don't think it's
written "in the books".
Given that you can choose the boundaries of a DSA tree at will
depending on what suits the setup best (and e.g. turn a DSA link pair
into a master and a CPU port pair which gains back introspection into
that port's ethtool counters etc), I guess DSA doesn't really offer
anything that raw switchdev drivers can't do (by reimplementing part
of it), just that it's is more idiomatic for Ethernet-connected
switches?
If so, it's a bit strange that switchdev and DSA are not in fact
unified, because as it is it creates false dichotomies. What about the
other way around? What are the features that raw switchdev drivers
(nfp, rocker, mlxsw) need that DSA can't offer them without breaking
the general model? (apart from access to the raw ndo_start_xmit and a
NAPI context for rcv)
As for DSA being easier on the driver writer, I totally get that, but
I think it isn't that much of an argument when the switchdev driver is
already said and done, as in this case :)

Regards,
-Vladimir
