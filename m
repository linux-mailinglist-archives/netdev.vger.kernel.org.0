Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76814CAA9A
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389685AbfJCRJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:09:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45278 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393421AbfJCRJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:09:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id c21so4563613qtj.12
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 10:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3PcIEXw/jTjSDo0D2gJ5Oo/H7k5jfF9FWK4owTr+vCM=;
        b=Jy2/dNcTnYEKdxWZmvceFRXitIEMomkQfluHbl1dkA7CC0TT3S80c0rlzNjmSPjeSO
         0l2LXpFj4yOTMPr/fAiX9xDXzJg1F5lLo+EcZ3iRFVJpwhlG1z2+iZ06Hi8rcT3gEZrD
         82fCbG8NKLcqy1vg1QnfRcUa7XcXXb/ytuHOeKpNnxWPbfIke7ZINsfX9Hwb9nceV8Ra
         2NPDP0ePGywAN6wlfyENOTTKwvzfVC/PUwEYqnuHolwbIvOGCKGI5bjIy5DTVawpT+O4
         Kek7ufiCV9BN9VxKqXd9tI9MLxpcuOYBRV7vpB8r7W6dTv75esCdy8R0kIJEeH33CCB7
         fLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3PcIEXw/jTjSDo0D2gJ5Oo/H7k5jfF9FWK4owTr+vCM=;
        b=pDP/vBG3H2KkSpKtKBAsdLKxqeGnsd03lgmBjzh6+ROO4VjYiAET4ZCypHn8f6YKAp
         kUgNlGo6hY+lBBxf0NGyX49qyKoSjx0jOAwlCUQ1x6NCW7yzQ8YaW8PZnMjE82qqDvk7
         wz/c9OCZclO5YN3ZDTmg7XYwCWpwl2Mvw7zayyV59jhF5iRbysF+fqwtAE4Yiupy0GZi
         KDHmFBQ00ap0nevkyII93ZWRPIkA5mHZVoEiSezE1VNs7mk3IYs3MdxTC2feZjfkh3Zk
         KSrjH+aqW1t5hONfRAgI8f6FN6LrMYTkGiUeg2qMfcu95fV6PBbKOfrQ6rqa9pHsMmKd
         Ba9Q==
X-Gm-Message-State: APjAAAXANHGhYLlEvwgeqWGX7Hye2j7p5YNtsoJ8EwbpEEgUVQqxW5j4
        YYd7XwlIzmK+1rY711cIB+Z15ulOF+G0X19EOWE=
X-Google-Smtp-Source: APXvYqyBzmh1fJCVPz6MQFvxNvZtufUthWuIW39n7VM24g2F3hjdn0jyT4sLw6Yn/q5sdvYxf0F3N6INaytlZJE0o8I=
X-Received: by 2002:a05:6214:1590:: with SMTP id m16mr9367262qvw.20.1570122574666;
 Thu, 03 Oct 2019 10:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com> <12EAB90C-827E-4BC5-8CED-08DA510CF566@redhat.com>
In-Reply-To: <12EAB90C-827E-4BC5-8CED-08DA510CF566@redhat.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 3 Oct 2019 10:08:57 -0700
Message-ID: <CALDO+SYW1-Or7z93+qzKvx-wtMAH-h1fpsTcPCXNuWDfOepBnQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next 0/9] optimize openvswitch flow looking up
To:     xiangxia.m.yue@gmail.com
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

Hi Tonghao,

Thanks for the patch.

> On 29 Sep 2019, at 19:09, xiangxia.m.yue@gmail.com wrote:
>
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This series patch optimize openvswitch.
> >
> > Patch 1, 2, 4: Port Pravin B Shelar patches to
> > linux upstream with little changes.
> >

I thought the idea of adding another cache before the flow mask
was rejected before, due to all the potential issue of caches, ex:
cache is exploitable, and performance still suffers when your cache
is full. See David's slides below:
[1] http://vger.kernel.org/~davem/columbia2012.pdf

Do you have a rough number about how many flows this flow mask
cache can handle?

> > Patch 5, 6, 7: Optimize the flow looking up and
> > simplify the flow hash.

I think this is great.
I wonder what's the performance improvement when flow mask
cache is full?

Thanks
William

> >
> > Patch 8: is a bugfix.
> >
> > The performance test is on Intel Xeon E5-2630 v4.
> > The test topology is show as below:
> >
> > +-----------------------------------+
> > |   +---------------------------+   |
> > |   | eth0   ovs-switch    eth1 |   | Host0
> > |   +---------------------------+   |
> > +-----------------------------------+
> >       ^                       |
> >       |                       |
> >       |                       |
> >       |                       |
> >       |                       v
> > +-----+----+             +----+-----+
> > | netperf  | Host1       | netserver| Host2
> > +----------+             +----------+
> >
> > We use netperf send the 64B frame, and insert 255+ flow-mask:
> > $ ovs-dpctl add-flow ovs-switch
> > "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)"
> > 2
> > ...
> > $ ovs-dpctl add-flow ovs-switch
> > "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)"
> > 2
> > $ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18
> >
> > * Without series patch, throughput 8.28Mbps
> > * With series patch, throughput 46.05Mbps
> >
> > Tonghao Zhang (9):
> >   net: openvswitch: add flow-mask cache for performance
> >   net: openvswitch: convert mask list in mask array
> >   net: openvswitch: shrink the mask array if necessary
> >   net: openvswitch: optimize flow mask cache hash collision
> >   net: openvswitch: optimize flow-mask looking up
> >   net: openvswitch: simplify the flow_hash
> >   net: openvswitch: add likely in flow_lookup
> >   net: openvswitch: fix possible memleak on destroy flow table
> >   net: openvswitch: simplify the ovs_dp_cmd_new
> >
> >  net/openvswitch/datapath.c   |  63 +++++----
> >  net/openvswitch/flow.h       |   1 -
> >  net/openvswitch/flow_table.c | 318
> > +++++++++++++++++++++++++++++++++++++------
> >  net/openvswitch/flow_table.h |  19 ++-
> >  4 files changed, 330 insertions(+), 71 deletions(-)
> >
> > --
> > 1.8.3.1
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
