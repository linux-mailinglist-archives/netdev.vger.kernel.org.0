Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8300F6A3D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKJQkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:40:21 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:47047 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfKJQkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:40:21 -0500
Received: by mail-ed1-f66.google.com with SMTP id x11so9985409eds.13
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 08:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jc9FkELxkrtL0hN9e7vnCURVKmW9BRNHKRt3nQc4+U4=;
        b=NOVrEpXPBDFAF/mFrnUyFV/v6aRprAXcPeoiBMA5aFPeQWpvK20FQQX2jZf9rWAB/6
         RlXfh22zgxVFJDgKN3x+2wF7hhtamKUA812iSwXRoFN5r7JGlXW1bDfo6YbdQClCeevt
         LBW5oYqryxf5Y98EtILlOmOI6/9qhoMEVb4Nq6NMU82/YyfEi2vuyPVu02FlFwfSn9Al
         k2/VX+mUqSclKS0hDVUnjK2hVuvHl3o0NX79UvzN6eQoDuhNnyWl9zpRrlpO4lnbx9eL
         xz6Yk6uQiQ9eMLsKHvnHyz3R63XbidelGYdxWKX/3zi0RLqT+N0Brp5nlLsxXHhtyIOX
         sSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jc9FkELxkrtL0hN9e7vnCURVKmW9BRNHKRt3nQc4+U4=;
        b=Fy+NoeGk4j2ZM7I8LqC3riot4OPRIcm8nQSZhr+xBfIDnpb1yoT2RiCIj4TQx0LDOw
         Wqpwqa5vmNfo1F7BnwxI/GDClphD3W+JKN2CGihYvDlUtZqvm4CE6/BCzGNhUVn8QFlT
         H8uieb3fHbJuAW/5qZeRQiPKBax862BS3kEvlFLBs5CAoWi6+veavaFy3Lv9sS6cgcin
         mJl9zFq99swe2zhbk6kSLZc7GvcKQKyzczZBoZETKRgHqT8C0ufiLdTb/XcEEms5VhMq
         GqMzJtsuoBOUJTZWZ2BPL1X4maIshYqxYJt28n+cLGsZcSWULXDdeq8ZBce4nn1jqfOP
         FoIg==
X-Gm-Message-State: APjAAAVxg0Mp5y47wPhQvKEiY3Otc4SYKuesP8c3MoaE9NBh2Ni5SPjL
        uhtCAgSh7PZ2ccTiZsIpVRtxpSi3/3VquhcXuX0=
X-Google-Smtp-Source: APXvYqyMzbgSglpFKJARFHPsNWOKA8lx6JtImZG0p9Z/vBNQZrca342CBlHqem6axG6qjyXltakTWzLlxIjv3TqWXmA=
X-Received: by 2002:a17:906:24d4:: with SMTP id f20mr19464593ejb.182.1573404018270;
 Sun, 10 Nov 2019 08:40:18 -0800 (PST)
MIME-Version: 1.0
References: <20191109130301.13716-1-olteanv@gmail.com> <20191109130301.13716-15-olteanv@gmail.com>
 <20191110163229.GE25889@lunn.ch>
In-Reply-To: <20191110163229.GE25889@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 10 Nov 2019 18:40:07 +0200
Message-ID: <CA+h21hpHBMWWyocg2ZmP-rFFDpFZBWWsAvEAK3MxEoBWxcsPSQ@mail.gmail.com>
Subject: Re: [PATCH net-next 14/15] net: mscc: ocelot: split assignment of the
 cpu port into a separate function
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 at 18:32, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
> > +                      enum ocelot_tag_prefix injection,
> > +                      enum ocelot_tag_prefix extraction)
> > +{
> > +     /* Configure and enable the CPU port. */
> > +     ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
> > +     ocelot_write_rix(ocelot, BIT(cpu), ANA_PGID_PGID, PGID_CPU);
> > +     ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_RECV_ENA |
> > +                      ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
> > +                      ANA_PORT_PORT_CFG, cpu);
> > +
> > +     /* If the CPU port is a physical port, set up the port in Node
> > +      * Processor Interface (NPI) mode. This is the mode through which
> > +      * frames can be injected from and extracted to an external CPU.
> > +      * Only one port can be an NPI at the same time.
> > +      */
> > +     if (cpu < ocelot->num_phys_ports) {
> > +             ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
> > +                          QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
> > +                          QSYS_EXT_CPU_CFG);
> > +     }
>
> If a port is not a physical port, what is it? Is it actually an error
> if the CPU port is not physical? Should we be returning -EINVAL here,
> indicating the device tree is bad?
>
>            Andrew

The Vitesse switches have a number of "physical" ports and a number of
"CPU" ports. By "port", one understands a target in the queuing
subsystem, with learning, flooding, forwarding, etc. The CPU ports
that are not physical don't have an 802.3 MAC. Then frame transfer
happens over DMA from its queues, PIO, etc (depending on SoC
integration). In the LS1028A SoC instantiation of the Felix switch
(which is an instantiation of the Ocelot core with less ports and
support for TSN), the CPU port _is_ physical (aka is a MAC connected
back-to-back to an ENETC DSA master), and that is what is being
understood by NPI mode.
