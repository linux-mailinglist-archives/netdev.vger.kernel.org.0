Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 266D3196D11
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgC2Lhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:37:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38707 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgC2Lhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:37:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id e5so17383061edq.5;
        Sun, 29 Mar 2020 04:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rd2m1h5mwQG84weV855GRjgt7O/a50O012bSvXI4HKc=;
        b=OYQtHhtzrEIDPrNu5goWYFfJf4/Ad4RSVktZvf6pWonTe/AqYXQ6sqnSQi675zFM9y
         pf0LXV23xoIbzDFjwYr4g2dEyBAUC6poIUU9cZilx+0tS1CyqUphDvDvlLjJ4/yAzQyp
         uegcwceViJeFagRDt8Rihhe5YJtk9jebhInaY0wio0q4rFsqo7ujkkSyeF0bDVqmhD22
         LAEXlLjoy2T4pFFw2oRd96nFP1lJnQxH0Cn9zNmC4LbsGPcIMU4Im3LxxJhs89eL4tpl
         LIQfXcL4aVmGXwbx1QMOIM/RPFO6uWPzlr6NaZ4/pQZcBgXm+wDMNk5cUGDIj9FKn9el
         Hrdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rd2m1h5mwQG84weV855GRjgt7O/a50O012bSvXI4HKc=;
        b=lEC/OlXNUx7SRInbwt2raosJKbfkVT2Qo0ZsKPRzDrq6jOr9XmlPExvenDdh1DbidP
         F7aFCqs6LDlUxxKj1smAwxZUKbAFQEx/2mOQsZFoA1r+r+eEnzBru/yX6nvpefkLsG5p
         Ge+gA7rz0om9yO99GUjsHgXF7Nf92aWinjykdeGCiCuM3YPbOvSzevJU/1dsOL9kt+Hq
         K6+eq79vw8gpOxxcXBWFXdQ0QJQ2wMBvk+cqHlp0HNvtLcNRwql7b5B4OvxB/Kpa5Iu5
         sBH0KCLQRyOpDCZ+1r5vP3eCKfxVpjmMWH/o/g2DMjXos2Ub6DWExpDObizIEPr/5o+J
         Dkuw==
X-Gm-Message-State: ANhLgQ2guARqU2UiH5amYMxzlokWF7b44uHrVvjvJuqUC4TFktsmhQNJ
        /O4Ujbb0RSzITuRZM/RXZSlWTPfumiWSy665Ri4=
X-Google-Smtp-Source: ADFU+vswB4t69tp4yKERwzcu+UN/5+yhj79bO/f0dCFFr2kjKtyjeSayYctQd0ugFo/7xwYcMDsj/ML39tD8sy41tcc=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr7185885edc.368.1585481869963;
 Sun, 29 Mar 2020 04:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200329005202.17926-1-olteanv@gmail.com> <20200329005202.17926-7-olteanv@gmail.com>
 <20200329095712.GA2188467@splinter>
In-Reply-To: <20200329095712.GA2188467@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 29 Mar 2020 14:37:38 +0300
Message-ID: <CA+h21hoybhxhR3KgfRkAaKyPPJPesbGLWDaDp5O_2yTz05y5jQ@mail.gmail.com>
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

On Sun, 29 Mar 2020 at 12:57, Ido Schimmel <idosch@idosch.org> wrote:
>
> + Nik, Roopa
>
> On Sun, Mar 29, 2020 at 02:52:02AM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > This patch adds complete support for manipulating the L2 Policing Tables
> > from this switch. There are 45 table entries, one entry per each port
> > and traffic class, and one dedicated entry for broadcast traffic for
> > each ingress port.
> >
> > Policing entries are shareable, and we use this functionality to support
> > shared block filters.
> >
> > We are modeling broadcast policers as simple tc-flower matches on
> > dst_mac. As for the traffic class policers, the switch only deduces the
> > traffic class from the VLAN PCP field, so it makes sense to model this
> > as a tc-flower match on vlan_prio.
> >
> > How to limit broadcast traffic coming from all front-panel ports to a
> > cumulated total of 10 Mbit/s:
> >
> > tc qdisc add dev sw0p0 ingress_block 1 clsact
> > tc qdisc add dev sw0p1 ingress_block 1 clsact
> > tc qdisc add dev sw0p2 ingress_block 1 clsact
> > tc qdisc add dev sw0p3 ingress_block 1 clsact
> > tc filter add block 1 flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
> >       action police rate 10mbit burst 64k
> >
> > How to limit traffic with VLAN PCP 0 (also includes untagged traffic) to
> > 100 Mbit/s on port 0 only:
> >
> > tc filter add dev sw0p0 ingress protocol 802.1Q flower skip_sw \
> >       vlan_prio 0 action police rate 100mbit burst 64k
> >
> > The broadcast, VLAN PCP and port policers are compatible with one
> > another (can be installed at the same time on a port).
>
> Hi Vladimir,
>
> Some switches have a feature called "storm control". It allows one to
> police incoming BUM traffic.

Yes, I am aware.
DPAA2 switches have a single (as far as I am aware) knob for 'flood
policers', and Ocelot has individual 'storm policers' for unknown
unicast, for multicast, broadcast and for 'learn frames'.

> See this entry from Cumulus Linux
> documentation:
>
> https://docs.cumulusnetworks.com/cumulus-linux-40/Layer-2/Spanning-Tree-and-Rapid-Spanning-Tree/#storm-control
>
> In the past I was thinking about ways to implement this in Linux. The
> only place in the pipeline where packets are actually classified to
> broadcast / unknown unicast / multicast is at bridge ingress. Therefore,

Actually I think only 'unknown unicast' is tricky here, and indeed the
bridge driver is the only place in the software datapath that would
know that.
I know very little about frame classification in the Linux network
stack, but would it be possible to introduce a match key in tc-flower
for whether packets have a known destination or not?

> my thinking was to implement these storm control policers as a
> "bridge_slave" operation. It can then be offloaded to capable drivers
> via the switchdev framework.
>

I think it would be a bit odd to duplicate tc functionality in the
bridge sysfs. I don't have a better suggestion though.

> I think that if we have this implemented in the Linux bridge, then your
> patch can be used to support the policing of broadcast packets while
> returning an error if user tries to police unknown unicast or multicast
> packets.

So even if the Linux bridge gains these knobs for flood policers,
still have the dst_mac ff:ff:ff:ff:ff:ff as a valid way to configure
one of those knobs?

> Or maybe the hardware you are working with supports these types
> as well?

Nope, on this hardware it's just broadcast, I just checked that. Which
simplifies things quite a bit.

>
> WDYT?
>

I don't know.

Thanks,
-Vladimir
