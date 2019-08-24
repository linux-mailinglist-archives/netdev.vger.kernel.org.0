Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1819BEA7
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 17:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfHXPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 11:44:57 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35038 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbfHXPo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 11:44:57 -0400
Received: by mail-ed1-f65.google.com with SMTP id t50so18836528edd.2
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 08:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3HMKdcpdaHhDR5z8sgM4kKvkv7yEsVVBV9Bx88Dhoeo=;
        b=MT58un07tTatzx2K7hSwK+hkqP7UF1xpjwxH+Iy2eNWtxUj6d1SKb2xJafRPZOysHi
         IHwBo/mclLpyQq3bu1NdWYwCFlZnQ3E2Bl2dz8gtDXn2JIar1J4N3m2URVRlYCh9pb3h
         TMV6spQk0GukESObuaaA591aef2Smr/cDdXeAhGfB9Y/c7+Rwrgo+73fOIvZzVcMKGhG
         /TjftLF2eDJB+KVWhppUXZV8cNaDHSBoTU/QllCf375wd1RJ2wpmyVWuW0yvmxDPcObQ
         3JyBU9Ti5SjImYHljJEw7excuk+/uiNRuA6WFCfLbH+qXzJt2FBruIER3AP8JIElL/7t
         1f2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3HMKdcpdaHhDR5z8sgM4kKvkv7yEsVVBV9Bx88Dhoeo=;
        b=tnAPqWMZTpTURLSnxkAi5Zzx0L6w7Lx4F+OvB/5Zz5dlF4ziMxg26Wa2bVaoLTvnFQ
         Y5BiPkdQ14bNorgQxaqlPgvX+F5usuCrk7poOi0Pe87sFH88bbgmPSNlyL84845HHjml
         yTd1a9j7i1+hbSalEYi8mmWzlWfoywjlZfOzI4L876eTs0tQE8COMEKnXA5iTq/od5s4
         +G/bh7uMkBZcMmOUNkawfsuyXKNQ5thO8gDoJLW8TBB4g8by1v8RJ9q0Scu0JLaIGqWs
         vHoJ6vLEKyjdChkFDnv1//pfG0UaZ43LFBUv8wNwCGEhhrMwK2svz1eKD2g1KDH7qg6x
         Qp8g==
X-Gm-Message-State: APjAAAVZ9lbMNExxEvVbjQ0MNizJiA+H0L2wk5wr8zPf9bN7TOrVk30q
        I4zwef2VzLSIr8CkeM6nH1lP9xwAETGisabFFhdu6zG5gdU=
X-Google-Smtp-Source: APXvYqzOos2DkH8CLXnhMMNSmp2enZ7Sber5z99Jc+obzShsqK34MWagHEIQ8lWWnWHmGaLOUAjWtO3AWbmJD2IQKYk=
X-Received: by 2002:a17:906:f746:: with SMTP id jp6mr8984002ejb.32.1566661494855;
 Sat, 24 Aug 2019 08:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190824024251.4542-1-marek.behun@nic.cz> <CA+h21hpBKnueT0QrVDL=Hhcp9X0rnaPW8omxiegq4TkcQ18EVQ@mail.gmail.com>
In-Reply-To: <CA+h21hpBKnueT0QrVDL=Hhcp9X0rnaPW8omxiegq4TkcQ18EVQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 24 Aug 2019 18:44:44 +0300
Message-ID: <CA+h21ho=injFxAkm9AByk6An5EzQMOyGVkFA8eKUP-rgGFEW2Q@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Aug 2019 at 18:40, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Marek,
>
> On Sat, 24 Aug 2019 at 05:43, Marek Beh=C3=BAn <marek.behun@nic.cz> wrote=
:
> >
> > Hi,
> > this is my attempt to solve the multi-CPU port issue for DSA.
> >
> > Patch 1 adds code for handling multiple CPU ports in a DSA switch tree.
> > If more than one CPU port is found in a tree, the code assigns CPU port=
s
> > to user/DSA ports in a round robin way. So for the simplest case where
> > we have one switch with N ports, 2 of them of type CPU connected to eth=
0
> > and eth1, and the other ports labels being lan1, lan2, ..., the code
> > assigns them to CPU ports this way:
> >   lan1 <-> eth0
> >   lan2 <-> eth1
> >   lan3 <-> eth0
> >   lan4 <-> eth1
> >   lan5 <-> eth0
> >   ...
> >
> > Patch 2 adds a new operation to the net device operations structure.
> > Currently we use the iflink property of a net device to report to which
> > CPU port a given switch port si connected to. The ip link utility from
> > iproute2 reports this as "lan1@eth0". We add a new net device operation=
,
> > ndo_set_iflink, which can be used to set this property. We call this
> > function from the netlink handlers.
> >
> > Patch 3 implements this new ndo_set_iflink operation for DSA slave
> > device. Thus the userspace can request a change of CPU port of a given
> > port.
> >
> > I am also sending patch for iproute2-next, to add support for setting
> > this iflink value.
> >
> > Marek
> >
>
> The topic is interesting.
> This changeset leaves the reader wanting to see a driver
> implementation of .port_change_cpu_port. (mostly to understand what
> your hardware is capable of)
> Will DSA assume that all CPU ports are equal in terms of tagging
> protocol abilities? There are switches where one of the CPU ports can
> do tagging and the other can't.

Just to be clear. You can argue that such switches are weird, and
that's ok. Just want to understand the general type of hardware for
which such a patch is intended.

> Is the static assignment between slave and CPU ports going to be the
> only use case? What about link aggregation? Flow steering perhaps?
> And like Andrew pointed out, how do you handle the receive case? What
> happens to flooded frames, will the switch send them to both CPU
> interfaces, and get received twice in Linux? How do you prevent that?
>
> > Marek Beh=C3=BAn (3):
> >   net: dsa: allow for multiple CPU ports
> >   net: add ndo for setting the iflink property
> >   net: dsa: implement ndo_set_netlink for chaning port's CPU port
> >
> >  include/linux/netdevice.h |  5 +++
> >  include/net/dsa.h         | 11 ++++-
> >  net/core/dev.c            | 15 +++++++
> >  net/core/rtnetlink.c      |  7 ++++
> >  net/dsa/dsa2.c            | 84 +++++++++++++++++++++++++--------------
> >  net/dsa/slave.c           | 35 ++++++++++++++++
> >  6 files changed, 126 insertions(+), 31 deletions(-)
> >
> > --
> > 2.21.0
> >
>
> Regards,
> -Vladimir
