Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6B1CF095
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbfJHBlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:41:09 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41062 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfJHBlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 21:41:09 -0400
Received: by mail-oi1-f195.google.com with SMTP id w65so13462754oiw.8
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 18:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nzcz1jutyNJ8aFn99RHhwDj0lIp4V/GntaNScBpz/Ak=;
        b=tBYPE2TqdmhIz/wS3kK4ojRrIBCbBtaokELxyT06pzAU6jc40u2rBYs1vsQHULq9u2
         7/W7NtF6FL3qx03aOq4VsdeJEF01cToDnv9+oIb+URayp1c8/TImBsDWJJOxtQdnUdO8
         htMvYfHGCW6X9nL+h9LZ9PRxFDj2yctcR2PoX0TNMivpsb6MzdzctR3rc2ktkFQy8GfW
         MVesrDPC5EhrTyE6lb5q907AbBp0rqW7b53gcGIwU8+78ZOqn0VlXN2kxXETQwZ02zY2
         REOTdpadzE05UlWSXeh9FLihG2gyjTYzp7zLsw7dYmqSCOawKpTV0ufTK9jFuZRNhb2K
         Y5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nzcz1jutyNJ8aFn99RHhwDj0lIp4V/GntaNScBpz/Ak=;
        b=PdJUpNv02SCVcO+/LRAemz4jZxvfk4GK+G0SUpchINFsHZ7/acCBzp18JxTvi05IlK
         dVsJZ5cMFdn5u8DS2nxn3vARiuzLU0Suud8W6JF4KyI96tTiK/xaIqxqsmF9WhN493HL
         eGhRsrimqcqMu6WwPIF+T2i3klVoTU6uaLbYopGgKIg/w9Yme/QijZYZ+9W6g9JUJHL7
         ETo0pp01gXZn7TrsOfYmsCZgmeUjKjidESkKnHzg4weHwy9bemDdEzgoHs8WQGqFXKNk
         fYXS6dGk/7ournrPxMUWGP8ZCgkDphVVFaUEOE0/o8WmsmaNtaMj28xFmhPiugCPHxbB
         BiUA==
X-Gm-Message-State: APjAAAWiyYYEVNdlSbvGabNryFXwE/9x7BAsKLex1D+4ysoixTDOyxzk
        vxJ8tTi/qRrLqsPVYx+kfW04hknNnPVZNmpFlFI=
X-Google-Smtp-Source: APXvYqw4xY0wLDvhWN6yr0OBM0bxkY5xyllRjUxnIRIK2wizfGGr2MK+2FGMiH/oa/4tfR1J/ciklFLq62KNgaz03nI=
X-Received: by 2002:a05:6808:2c3:: with SMTP id a3mr1846752oid.40.1570498868512;
 Mon, 07 Oct 2019 18:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
 <12EAB90C-827E-4BC5-8CED-08DA510CF566@redhat.com> <CALDO+SYW1-Or7z93+qzKvx-wtMAH-h1fpsTcPCXNuWDfOepBnQ@mail.gmail.com>
In-Reply-To: <CALDO+SYW1-Or7z93+qzKvx-wtMAH-h1fpsTcPCXNuWDfOepBnQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 8 Oct 2019 09:41:09 +0800
Message-ID: <CAMDZJNX6vmouP_EDx2JMyXb6qOnXKk6XjwNDaz8mjWYVtvw7nA@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next 0/9] optimize openvswitch flow looking up
To:     William Tu <u9012063@gmail.com>
Cc:     ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Rose <gvrose8192@gmail.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        pravin shelar <pshelar@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 1:09 AM William Tu <u9012063@gmail.com> wrote:
>
> Hi Tonghao,
>
> Thanks for the patch.
>
> > On 29 Sep 2019, at 19:09, xiangxia.m.yue@gmail.com wrote:
> >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > This series patch optimize openvswitch.
> > >
> > > Patch 1, 2, 4: Port Pravin B Shelar patches to
> > > linux upstream with little changes.
> > >
>
> I thought the idea of adding another cache before the flow mask
> was rejected before, due to all the potential issue of caches, ex:
> cache is exploitable, and performance still suffers when your cache
> is full. See David's slides below:
> [1] http://vger.kernel.org/~davem/columbia2012.pdf
>
> Do you have a rough number about how many flows this flow mask
> cache can handle?
Now we can cache 256 flows on a CPU, so if there are 40 CPUs, 256*10
flows will be cached.
the value of flow-mask is defined using MC_HASH_ENTRIES macro define.
We can change the value
according to different use case and CPU L1d cache.

> > > Patch 5, 6, 7: Optimize the flow looking up and
> > > simplify the flow hash.
>
> I think this is great.
> I wonder what's the performance improvement when flow mask
> cache is full?
I will test the case, I think this feature should work well with RSS
and irq affinity.
> Thanks
> William
>
> > >
> > > Patch 8: is a bugfix.
> > >
> > > The performance test is on Intel Xeon E5-2630 v4.
> > > The test topology is show as below:
> > >
> > > +-----------------------------------+
> > > |   +---------------------------+   |
> > > |   | eth0   ovs-switch    eth1 |   | Host0
> > > |   +---------------------------+   |
> > > +-----------------------------------+
> > >       ^                       |
> > >       |                       |
> > >       |                       |
> > >       |                       |
> > >       |                       v
> > > +-----+----+             +----+-----+
> > > | netperf  | Host1       | netserver| Host2
> > > +----------+             +----------+
> > >
> > > We use netperf send the 64B frame, and insert 255+ flow-mask:
> > > $ ovs-dpctl add-flow ovs-switch
> > > "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)"
> > > 2
> > > ...
> > > $ ovs-dpctl add-flow ovs-switch
> > > "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)"
> > > 2
> > > $ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18
> > >
> > > * Without series patch, throughput 8.28Mbps
> > > * With series patch, throughput 46.05Mbps
> > >
> > > Tonghao Zhang (9):
> > >   net: openvswitch: add flow-mask cache for performance
> > >   net: openvswitch: convert mask list in mask array
> > >   net: openvswitch: shrink the mask array if necessary
> > >   net: openvswitch: optimize flow mask cache hash collision
> > >   net: openvswitch: optimize flow-mask looking up
> > >   net: openvswitch: simplify the flow_hash
> > >   net: openvswitch: add likely in flow_lookup
> > >   net: openvswitch: fix possible memleak on destroy flow table
> > >   net: openvswitch: simplify the ovs_dp_cmd_new
> > >
> > >  net/openvswitch/datapath.c   |  63 +++++----
> > >  net/openvswitch/flow.h       |   1 -
> > >  net/openvswitch/flow_table.c | 318
> > > +++++++++++++++++++++++++++++++++++++------
> > >  net/openvswitch/flow_table.h |  19 ++-
> > >  4 files changed, 330 insertions(+), 71 deletions(-)
> > >
> > > --
> > > 1.8.3.1
> > _______________________________________________
> > dev mailing list
> > dev@openvswitch.org
> > https://mail.openvswitch.org/mailman/listinfo/ovs-dev
