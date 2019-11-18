Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73521002F3
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfKRKvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 05:51:15 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34739 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfKRKvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:51:15 -0500
Received: by mail-ed1-f67.google.com with SMTP id b72so13122539edf.1
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 02:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yjLnAAXYMU71bQAqnHS2VFt6iUv6VagMVRZILyfxcAY=;
        b=SyFaov+jh9mEpf3YyTpZVg6fBQAskkdLPl+QZq8h01n4LWJU9cr3HbMBtgdBeMM2D2
         sHZzJMHFCjEoJr3qRspy8wx1exGpHK+Wq+T++WiqUuvZrEqSkHYUEzza00NIQLgfJA+R
         doLeDaSG4PS4J73RLFQ0AvgVge9BXxDut0BZR6TvBMIiSS6MNcRAlfRe9FsM3rwe716x
         O9+eavXooszlD0oLp4B7JEomNT87rkt33qGgH2Xo3W8iW+Y+dfUPlG5Im8roGzEQ2ZQV
         Bq4bgTCIyNPEWd+L+1bwbe4M+uNTNfsYEkiXe4ncaoj2Hmw8zjmUJ/WFtCOz72CGwYIh
         KiVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yjLnAAXYMU71bQAqnHS2VFt6iUv6VagMVRZILyfxcAY=;
        b=Q2ZrcLvQH8EylvOLwxYZisTawnd65JgeiZSrFMscGD39CSgeEumlJwKFnsz1hiBEW/
         xV1mzPg//I7bV7ihBuI4k3F1TnOWJ5jPsrxT5wGHzXT8n/Iv6PS7eYo6RD13ciLKKPgn
         U2Hu3qLvjdgntEBitG4O2qO2mgNCH9rhppfFF41bCCLnmz05WNLPQCFjgaEbVA/XBrPm
         dpo0N2Vg1JEfpQ7PWBrZ9LMcCW9L4c7YwMqCveEKHZ53dZB2lZsiwx3l+h+NiXqof8Hx
         cgq+1D9VWQWq0JKMpmUq5M6o8p4vz2+PaRkgESa9X5vJVMkKB+WamL+S62RhSqwGBT8s
         uBEQ==
X-Gm-Message-State: APjAAAUtWN4Ykkiqy/RslJWHaaShs2X3BltO0mVZW3xRR4J+ZfF2kCL1
        LmHu5S7k7ZA2yzsVfhNjE0ckwvEJmuXsVG6KWvo=
X-Google-Smtp-Source: APXvYqwTX2Y+wJ/BzG2nbZjlceg57RZPFPsAEQVWpi3x3pz6k1vHD2C2KPdT57AMzvyV/pC4AkydiO8TanQnt1BFTIA=
X-Received: by 2002:a17:906:2893:: with SMTP id o19mr11059383ejd.32.1574074272524;
 Mon, 18 Nov 2019 02:51:12 -0800 (PST)
MIME-Version: 1.0
References: <20191116172325.13310-1-olteanv@gmail.com> <20191118083624.GA2149@splinter>
In-Reply-To: <20191118083624.GA2149@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 18 Nov 2019 12:51:01 +0200
Message-ID: <CA+h21hrDoTjSvqfpCJRgrzJJ0P1nwfFdxK533dTGSi4y7_-BNA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: Make HOSTPRIO a devlink param
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, jiri@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Mon, 18 Nov 2019 at 10:36, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Sat, Nov 16, 2019 at 07:23:25PM +0200, Vladimir Oltean wrote:
> > Unfortunately with this hardware, there is no way to transmit in-band
> > QoS hints with management frames (i.e. VLAN PCP is ignored). The traffic
> > class for these is fixed in the static config (which in turn requires a
> > reset to change).
> >
> > With the new ability to add time gates for individual traffic classes,
> > there is a real danger that the user might unknowingly turn off the
> > traffic class for PTP, BPDUs, LLDP etc.
> >
> > So we need to manage this situation the best we can. There isn't any
> > knob in Linux for this, so create a driver-specific devlink param which
> > is a runtime u8. The default value is 7 (the highest priority traffic
> > class).
> >
> > Patch is largely inspired by the mv88e6xxx ATU_hash devlink param
> > implementation.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> > Changes in v2:
> > Turned the NET_DSA_SJA1105_HOSTPRIO kernel config into a "hostprio"
> > runtime devlink param.
> >
> >  .../networking/devlink-params-sja1105.txt     |  9 ++
> >  Documentation/networking/dsa/sja1105.rst      | 19 +++-
> >  MAINTAINERS                                   |  1 +
> >  drivers/net/dsa/sja1105/sja1105.h             |  1 +
> >  drivers/net/dsa/sja1105/sja1105_main.c        | 94 +++++++++++++++++++
> >  5 files changed, 122 insertions(+), 2 deletions(-)
> >  create mode 100644 Documentation/networking/devlink-params-sja1105.txt
> >
> > diff --git a/Documentation/networking/devlink-params-sja1105.txt b/Documentation/networking/devlink-params-sja1105.txt
> > new file mode 100644
> > index 000000000000..5096a4cf923c
> > --- /dev/null
> > +++ b/Documentation/networking/devlink-params-sja1105.txt
> > @@ -0,0 +1,9 @@
> > +hostprio             [DEVICE, DRIVER-SPECIFIC]
> > +                     Configure the traffic class which will be used for
> > +                     management (link-local) traffic injected and trapped
> > +                     to/from the CPU. This includes STP, PTP, LLDP etc, as
> > +                     well as hardware-specific meta frames with RX
> > +                     timestamps.  Higher is better as long as you care about
> > +                     your PTP frames.
>
> Vladimir,
>
> I have some concerns about this. Firstly, I'm not sure why you need to
> expose this and who do you expect to be able to configure this? I'm
> asking because once you expose it to users there might not be a way
> back. mlxsw is upstream for over four years and the traffic classes for
> the different packet types towards the CPU are hard coded in the driver
> and based on "sane" defaults. It is therefore surprising to me that you
> already see the need to expose this.
>

WIth tc-taprio, it is up to the user / system administrator which of
the 8 traffic classes has access to the Ethernet media and when (if
ever).
For example, take this command:

sudo tc qdisc replace dev swp3 parent root handle 100 taprio \
        num_tc 8 \
        map 0 1 2 3 4 5 6 7 \
        queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
        base-time $base_time \
        sched-entry S 03 300000 \
        sched-entry S 02 300000 \
        sched-entry S 06 400000 \
        flags 2

It will allow access to traffic classes 0 and 1 (S 03) for 300000 ns,
traffic class 1 (S 02) for another 300000 ns, and to traffic classes 1
and 2 (S 06) for 400000 ns, then repeat the schedule. This is just an
example.
But the base-time is a PTP time, so the switch needs a PTP daemon to
keep track of time. But notice that the traffic class for PTP traffic
(which is hardcoded as 7 in the driver) is not present in the
tc-taprio schedule, so effectively PTP will be denied access to the
media, so it won't work, so it will completely break the schedule. The
user will be horribly confused by this. I also don't want to keep the
PTP traffic class hardcoded at 7, since the system administrator might
have other cyclic traffic schedules that are more time-sensitive than
PTP itself.

> Secondly, I find the name confusing. You call it "hostprio", but the
> description says "traffic class". These are two different things.
> Priority is a packet attribute based on which you can classify the
> packet to a transmission queue (traffic class). And if you have multiple
> transmission queues towards the CPU, how do you configure their
> scheduling and AQM? This relates to my next point.
>

HOSTPRIO is the way it is called in the hardware user guide:
https://www.nxp.com/docs/en/user-guide/UM10944.pdf
I don't see why I should call it something else, especially since it
does not map over any other concept.

And since it is DSA, the Ethernet link between the CPU port and the
DSA master is inherently single queue, even though the switch is
multi-queue and the DSA master is multi-queue. Both the DSA master and
the front-panel switch can have independent qdiscs that operate
independently. It is a separate discussion.

> Thirdly, the fact that "there isn't any knob in Linux for this" does not
> mean that we should not create a proper one. As I see it, the CPU port
> (switch side, not DSA master) is a port like any other and therefore
> should have a netdev. With a netdev you can properly configure its
> different QoS attributes using tc instead of introducing driver-specific
> devlink-params.
>

Right, but let me summarize the hardware operation to understand what
this is really doing.
The switch has 2 MAC filters for link-local management traffic. I
hardcoded them in the driver to 01-80-C2-xx-xx-xx and
01-1B-19-xx-xx-xx so that STP and PTP work by default. The switch
checks the DMAC of frames against these masks very early in the packet
processing pipeline, and if they match, they are trapped to the CPU.
In fact, the match is so early that the analyzer module is bypassed
and the frames do not get classified to a TC based on any QoS
classification rules. The hardware designers recognized that this
might be a problem, so they just invented a knob called HOSTPRIO,
which all frames that are trapped to the CPU get assigned.
On xmit, the MAC filters are active on the CPU port as well. So the
switch wants to trap the link-local frames coming from the CPU and
redirect them to the CPU, which it won't do because it's configured to
avoid hairpinning. So it drops those frames when they come from the
CPU port, due to lack of valid destinations. So the hardware designers
invented another concept called "management routes" which are meant to
bypass the MAC filters (which themselves bypass L2 forwarding). You
pre-program a one-shot "management route" in the switch for a frame
matching a certain DMAC, then you send it, then the switch figures out
it matches this "management route" and properly sends it out the
correct front-panel port. The point is that on xmit, the switch uses
HOSTPRIO for the "management route" frames as well.

Whether the CPU port is a netdev or not does not change the fact that
there is no way to "properly" model this using tc. In hardware, all
frames that match the management routes or the MAC filtering rules get
the fixed and global HOSTPRIO, end of story.

> Yes, I understand that this is a large task compared to just adding this
> devlink-param, but adding a new user interface always scares me and I
> think we should do the right thing here.
>

I don't want to invent a wheel that has any pretense of being generic,
when in reality it isn't generic at all. For traffic that the switch
really classifies based on per-frame rules, I agree with you, but
that's not the case here.

> Thanks

Thanks,
-Vladimir
