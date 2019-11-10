Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3601F6A4D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfKJQux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:50:53 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38595 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKJQuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:50:52 -0500
Received: by mail-ed1-f67.google.com with SMTP id s10so10030136edi.5
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 08:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTA2LGf7+Bfnbgj9cZSYVX5Uhpx5hUxorNpArZoAGbc=;
        b=IGKwSvACFgQL5AgIom7IpozccQg+4H1dhDO633mifSGv4Mzh0yBI2BLMT4cOOaXQPX
         8wFNA2LuKZpf0GLhGqMSF+V8CLWScmypeJVgVWe+/0cCposzG6J8cgxacg0orf0IXDhF
         Q6dK5sddiX/7lKmTx7CuNbhYaIh/oGG0+ltLT1J5bKc4pO+Gr3h8iotVs+MaSnk/hpyO
         CwVrk6lSPOri/XJuJVbnnFH5yEND7jUJWSLyQEsYOX7sB6/0yIwYsPbLJ+8eDcIsWvQS
         hk4Qfr+U5n0EJDoFj+wKcZtxVWRHo5uGPNkLdcZjw1aK/AhbdEHoAThAo9A3r3mW3bpy
         DNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTA2LGf7+Bfnbgj9cZSYVX5Uhpx5hUxorNpArZoAGbc=;
        b=j3WtHyVmFMVNlYB6Mc6/tPTPj50u3H04muycucncpdaxcsqEd2zt3JbJhsQEekKCoF
         mHDE6Y/f3ZWWnz9CiMtW+Oh90UcmGQyexWT5Qcl7KuVe/asNxqVrXqmBoNYG+Fu1on5E
         ANe+lR1Jl7jxWNvVQLhKCyuHprJ0//jvyCo3FcLXtLFEaugZwRg9hOPWwntUZPDFp2wG
         vp0gnQKa9hiMzp2gUqqroPGX7OcWJxk+4k223qmSxPmmhmLLt0zyRVzdCMrrnstO/ERt
         CxuYO7/WpH5Nk/0z5pguBRJBjojc5r91x1cWV8BmkkEtJDziZuDE7BaJEG9p/4g9WUdl
         RQLQ==
X-Gm-Message-State: APjAAAWnqYhAuylx87ioRkKcb/idUdeG7o2kKhpdtRht3/c/sugvPPri
        NP3SWjQp5EaS5mI5mOWd4VYLswgVEOGrc+DrLr8=
X-Google-Smtp-Source: APXvYqzwI0tH1RiG1L0NjYpoxz6KF2hOJhr1AZu13z+dmnjjBE+YBS77SGcMDCzTkfSXd00fDCnG5DqXFg+3PZyC/oU=
X-Received: by 2002:a50:c408:: with SMTP id v8mr21812173edf.140.1573404651263;
 Sun, 10 Nov 2019 08:50:51 -0800 (PST)
MIME-Version: 1.0
References: <20191109130301.13716-1-olteanv@gmail.com> <20191109130301.13716-15-olteanv@gmail.com>
 <20191110163229.GE25889@lunn.ch> <CA+h21hpHBMWWyocg2ZmP-rFFDpFZBWWsAvEAK3MxEoBWxcsPSQ@mail.gmail.com>
In-Reply-To: <CA+h21hpHBMWWyocg2ZmP-rFFDpFZBWWsAvEAK3MxEoBWxcsPSQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 10 Nov 2019 18:50:40 +0200
Message-ID: <CA+h21hrsoUmCag15NNxnhKOvhZkiPvX94Zs+21F5pwQj+5kjmg@mail.gmail.com>
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

On Sun, 10 Nov 2019 at 18:40, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sun, 10 Nov 2019 at 18:32, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
> > > +                      enum ocelot_tag_prefix injection,
> > > +                      enum ocelot_tag_prefix extraction)
> > > +{
> > > +     /* Configure and enable the CPU port. */
> > > +     ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
> > > +     ocelot_write_rix(ocelot, BIT(cpu), ANA_PGID_PGID, PGID_CPU);
> > > +     ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_RECV_ENA |
> > > +                      ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
> > > +                      ANA_PORT_PORT_CFG, cpu);
> > > +
> > > +     /* If the CPU port is a physical port, set up the port in Node
> > > +      * Processor Interface (NPI) mode. This is the mode through which
> > > +      * frames can be injected from and extracted to an external CPU.
> > > +      * Only one port can be an NPI at the same time.
> > > +      */
> > > +     if (cpu < ocelot->num_phys_ports) {
> > > +             ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
> > > +                          QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
> > > +                          QSYS_EXT_CPU_CFG);
> > > +     }
> >
> > If a port is not a physical port, what is it? Is it actually an error
> > if the CPU port is not physical? Should we be returning -EINVAL here,
> > indicating the device tree is bad?
> >
> >            Andrew
>
> The Vitesse switches have a number of "physical" ports and a number of
> "CPU" ports. By "port", one understands a target in the queuing
> subsystem, with learning, flooding, forwarding, etc. The CPU ports
> that are not physical don't have an 802.3 MAC. Then frame transfer
> happens over DMA from its queues, PIO, etc (depending on SoC
> integration). In the LS1028A SoC instantiation of the Felix switch
> (which is an instantiation of the Ocelot core with less ports and
> support for TSN), the CPU port _is_ physical (aka is a MAC connected
> back-to-back to an ENETC DSA master), and that is what is being
> understood by NPI mode.

If this is still confusing, take for example Ocelot
(http://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf). The
physical ports are 0-9, and the CPU ports are 10 and 11. So the ocelot
driver was hardcoding the CPU port to 10, which is the first port
outside the num_phys_ports range.

I don't expect any caller to specify an invalid CPU port, so returning
-EINVAL would just be overhead here. Neither of the 2 entry points of
this function (one in mainline, one as a currently downstream patch)
can. The Ocelot SoC driver (ocelot_board.c) always sets port #10 as
CPU port, which is legit, and the Felix driver always sets one of the
physical ports as CPU port, which again is legit.
