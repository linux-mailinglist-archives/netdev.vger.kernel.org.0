Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C612B196D14
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgC2Lqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:46:30 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43049 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgC2Lqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:46:30 -0400
Received: by mail-ed1-f67.google.com with SMTP id bd14so17343384edb.10;
        Sun, 29 Mar 2020 04:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kWqBhqN9W4UoJNuckL4CJb3lLsiw0Kie1I4t1l/WfLc=;
        b=hvjEbv9B4eBj4Hq4xeNNYSLh5YGTKm3/Rab7Q0VkqbssGbIel0QLt1BJXvASEfnPUp
         OCRL0U12jYDfseKnSYHf95bcOrnMlvzz1DqUGHriKWnKgMUbxqkmX5EIi2FHhyrIQceJ
         6avqa7Bw9iEbpWFxEaQmI8GRV9wSW8nm5AKURKXbSnfAKS1w8gwYUlK9xUhfNmoDdKZO
         uyZcqKG6Nm4jPHft+X5su/2GVREbIuvBKXBrXFlBuDLPJNv44rMQmHuseJdsVmlHDgGV
         0T8TOi5eXr/+Y2Qe+0s0SNTLufDoL5xc1W2qkIY9KB9afaqU3V1kE8/qLqjpX4Tc31eX
         AyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kWqBhqN9W4UoJNuckL4CJb3lLsiw0Kie1I4t1l/WfLc=;
        b=PFx6gUYydBZT8X5CIJ5umGtZ7rLEwgTj4cLoP4dd0CvaTgiANZ07WzHVFd48ajPM1h
         CxaByvm/u/8gSOYjJ3yW6j2B2uwk6L5t0OWaG/8G22ZgohZrSjJXHOyDpeA4d8SbVoqu
         M58lrA+eVIU3bukPHP9RkexETFjef3+ECwrx7YPezzl9kg7lfcENioezsED62nLBEmLz
         zUP4VA2Bn/kwqwe3SJMPS8JTtE97m0D8grdmXu1gZ3jcP+qi5vd+jxw7qfghx+Geu7cW
         6F0wavOSBsXc8Xr/j8o5UeSkb0kU3ih8CTPjFYeniW6J9iFpR335/nf8f0DNh9WCLT2T
         O75A==
X-Gm-Message-State: ANhLgQ10iA+5rzCmuZQEb+aQGVU2k0RFm24ZN9Hu7cIzTRcpaWhQnYzt
        s4FM7aJeKrLUFvjJ6ym/P4fzm6SqihLCxPjyxrw=
X-Google-Smtp-Source: ADFU+vsD0Mox8k19o8ZLL4i5bopF42KYZQDFmsDhweJ7kA9PqoM3a+j6D7zWl/0Sjdjq6QbBQPUjw/nSpwlmHbykmTw=
X-Received: by 2002:a17:906:449:: with SMTP id e9mr6569538eja.239.1585482387103;
 Sun, 29 Mar 2020 04:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200329005202.17926-1-olteanv@gmail.com> <20200329005202.17926-7-olteanv@gmail.com>
 <20200329095712.GA2188467@splinter> <CA+h21hoybhxhR3KgfRkAaKyPPJPesbGLWDaDp5O_2yTz05y5jQ@mail.gmail.com>
In-Reply-To: <CA+h21hoybhxhR3KgfRkAaKyPPJPesbGLWDaDp5O_2yTz05y5jQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 29 Mar 2020 14:46:16 +0300
Message-ID: <CA+h21hoBp6=Zyc3mX3BVguVs0f8Un6-A3pk9YaZKPgs0efTi3g@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] net: dsa: sja1105: add broadcast and
 per-traffic class policers
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Mar 2020 at 14:37, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sun, 29 Mar 2020 at 12:57, Ido Schimmel <idosch@idosch.org> wrote:
> >
> > + Nik, Roopa
> >
> > On Sun, Mar 29, 2020 at 02:52:02AM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > This patch adds complete support for manipulating the L2 Policing Tables
> > > from this switch. There are 45 table entries, one entry per each port
> > > and traffic class, and one dedicated entry for broadcast traffic for
> > > each ingress port.
> > >
> > > Policing entries are shareable, and we use this functionality to support
> > > shared block filters.
> > >
> > > We are modeling broadcast policers as simple tc-flower matches on
> > > dst_mac. As for the traffic class policers, the switch only deduces the
> > > traffic class from the VLAN PCP field, so it makes sense to model this
> > > as a tc-flower match on vlan_prio.
> > >
> > > How to limit broadcast traffic coming from all front-panel ports to a
> > > cumulated total of 10 Mbit/s:
> > >
> > > tc qdisc add dev sw0p0 ingress_block 1 clsact
> > > tc qdisc add dev sw0p1 ingress_block 1 clsact
> > > tc qdisc add dev sw0p2 ingress_block 1 clsact
> > > tc qdisc add dev sw0p3 ingress_block 1 clsact
> > > tc filter add block 1 flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
> > >       action police rate 10mbit burst 64k
> > >
> > > How to limit traffic with VLAN PCP 0 (also includes untagged traffic) to
> > > 100 Mbit/s on port 0 only:
> > >
> > > tc filter add dev sw0p0 ingress protocol 802.1Q flower skip_sw \
> > >       vlan_prio 0 action police rate 100mbit burst 64k
> > >
> > > The broadcast, VLAN PCP and port policers are compatible with one
> > > another (can be installed at the same time on a port).
> >
> > Hi Vladimir,
> >
> > Some switches have a feature called "storm control". It allows one to
> > police incoming BUM traffic.
>
> Yes, I am aware.
> DPAA2 switches have a single (as far as I am aware) knob for 'flood
> policers', and Ocelot has individual 'storm policers' for unknown
> unicast, for multicast, broadcast and for 'learn frames'.
>
> > See this entry from Cumulus Linux
> > documentation:
> >
> > https://docs.cumulusnetworks.com/cumulus-linux-40/Layer-2/Spanning-Tree-and-Rapid-Spanning-Tree/#storm-control
> >
> > In the past I was thinking about ways to implement this in Linux. The
> > only place in the pipeline where packets are actually classified to
> > broadcast / unknown unicast / multicast is at bridge ingress. Therefore,
>
> Actually I think only 'unknown unicast' is tricky here, and indeed the
> bridge driver is the only place in the software datapath that would
> know that.
> I know very little about frame classification in the Linux network
> stack, but would it be possible to introduce a match key in tc-flower
> for whether packets have a known destination or not?
>
> > my thinking was to implement these storm control policers as a
> > "bridge_slave" operation. It can then be offloaded to capable drivers
> > via the switchdev framework.
> >
>
> I think it would be a bit odd to duplicate tc functionality in the
> bridge sysfs. I don't have a better suggestion though.
>

Not to mention that for hardware like this, to have the same level of
flexibility via a switchdev control would mean to duplicate quite a
lot of tc functionality. On this 5-port switch I can put a shared
broadcast policer on 2 ports (via the ingress_block functionality),
and individual policers on the other 3, and the bandwidth budgeting is
separate. I can only assume that there are more switches out there
that allow this.

> > I think that if we have this implemented in the Linux bridge, then your
> > patch can be used to support the policing of broadcast packets while
> > returning an error if user tries to police unknown unicast or multicast
> > packets.
>
> So even if the Linux bridge gains these knobs for flood policers,
> still have the dst_mac ff:ff:ff:ff:ff:ff as a valid way to configure
> one of those knobs?
>
> > Or maybe the hardware you are working with supports these types
> > as well?
>
> Nope, on this hardware it's just broadcast, I just checked that. Which
> simplifies things quite a bit.
>
> >
> > WDYT?
> >
>
> I don't know.
>
> Thanks,
> -Vladimir

-Vladimir
