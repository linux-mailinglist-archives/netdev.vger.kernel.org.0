Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAEF2F6D87
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbhANVvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728984AbhANVvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:51:54 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4415C0613D6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:50:56 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h19so4665437qtq.13
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KBEOm/Dqc4zeO3nAh0hLjGwijpwL60gm0iMM+qHQq54=;
        b=fRt5oj8zq+dEW5GytqYJpjQxCWsV+0hrGtgbk0yvTr1ymA3bkN9+ELXyhoN79YfTQT
         QaJggwLN5/1A5NMtiMUTrjapQat8Rlvd3rW/kOpG0lO9u58JmcT8pKhiJQZoA14e+8gq
         6u6MVtBhPMONDlRV4ft2p+SE54/qEl/iLqLWXi63S7jlRSsZZOUgUcQBVZs5WraXIvHN
         TKMyZuPOcQkAWbuWl5qRajto3if8/3KIbvhVn0lTlGcRoa3akhqbRRcaM6QybkJJlsuv
         ixOz9pWMKiMVvmh/funFZ5MotCLPRYFP+mKGUATSWHSTgs+IywbGAzGjcjREV4YNcxN3
         Qwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KBEOm/Dqc4zeO3nAh0hLjGwijpwL60gm0iMM+qHQq54=;
        b=rwEcXKpDCkS9aiMVY/IbdqfpgYFTKYfOXHLTcssHBE19wEGwPM1mdBAKrLnAgJhC2a
         f47ukcO4bIM3egBERBxEZcJuT4LvFaT2PbArYijYNJHxNLyuAh7x62+onAVqOWdN8rsG
         fUKyi53JWYRHov1oJ2JzIIF/HMmdmzBGscm0R0ljACWJqQ+VXm0ZpfcEA4+0itbExbca
         02/PJ7aHo3/BIiKiWNtRj4VSW7WW1Tmn+bUgDVvmoZNSwcA5GrKslt08CrVlr3Xbp/eJ
         IDFRaNtUMrbGEjRdbMr5oVhjD5+fBFmiRBlkAHXptbaKzU9Vh87zmEB6jtLDvco8sfJ6
         JyVA==
X-Gm-Message-State: AOAM531pvewAVogCDJBZTLuC6uNvH2xOU4E7Hg15Of5kUMl0ibHe+8El
        N5NJ0E3osf+kI3jDLCBNZiVfSDzOAgRWxg==
X-Google-Smtp-Source: ABdhPJzIBrQGvYUMJwkhQfes6FluXvZ84Jq080SpOJoDKV2oCkaEtIKsGFuGn22egjaaX/M7TNi/Kw==
X-Received: by 2002:ac8:7606:: with SMTP id t6mr8781396qtq.214.1610661055985;
        Thu, 14 Jan 2021 13:50:55 -0800 (PST)
Received: from horizon.localdomain ([177.220.172.93])
        by smtp.gmail.com with ESMTPSA id y10sm3852304qkb.115.2021.01.14.13.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 13:50:55 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id EFAF1C086E; Thu, 14 Jan 2021 18:50:52 -0300 (-03)
Date:   Thu, 14 Jan 2021 18:50:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
Message-ID: <20210114215052.GB2676@horizon.localdomain>
References: <20210108053054.660499-1-saeed@kernel.org>
 <20210108053054.660499-9-saeed@kernel.org>
 <20210108214812.GB3678@horizon.localdomain>
 <c11867d2-6fda-d77c-6b52-f4093c751379@nvidia.com>
 <218258b2-3a86-2d87-dfc6-8b3c1e274b26@nvidia.com>
 <20210111235116.GA2595@horizon.localdomain>
 <f25eee28-4c4a-9036-8c3d-d84b15a8b5e7@nvidia.com>
 <20210114130238.GA2676@horizon.localdomain>
 <d1b5b862-8c30-efb6-1a2f-4f9f0d49ef15@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1b5b862-8c30-efb6-1a2f-4f9f0d49ef15@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 04:03:43PM +0200, Oz Shlomo wrote:
> 
> 
> On 1/14/2021 3:02 PM, Marcelo Ricardo Leitner wrote:
> > On Tue, Jan 12, 2021 at 11:27:04AM +0200, Oz Shlomo wrote:
> > > 
> > > 
> > > On 1/12/2021 1:51 AM, Marcelo Ricardo Leitner wrote:
> > > > On Sun, Jan 10, 2021 at 09:52:55AM +0200, Roi Dayan wrote:
> > > > > 
> > > > > 
> > > > > On 2021-01-10 9:45 AM, Roi Dayan wrote:
> > > > > > 
> > > > > > 
> > > > > > On 2021-01-08 11:48 PM, Marcelo Ricardo Leitner wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > On Thu, Jan 07, 2021 at 09:30:47PM -0800, Saeed Mahameed wrote:
> > > > > > > > From: Roi Dayan <roid@nvidia.com>
> > > > > > > > 
> > > > > > > > Connection tracking associates the connection state per packet. The
> > > > > > > > first packet of a connection is assigned with the +trk+new state. The
> > > > > > > > connection enters the established state once a packet is seen on the
> > > > > > > > other direction.
> > > > > > > > 
> > > > > > > > Currently we offload only the established flows. However, UDP traffic
> > > > > > > > using source port entropy (e.g. vxlan, RoCE) will never enter the
> > > > > > > > established state. Such protocols do not require stateful processing,
> > > > > > > > and therefore could be offloaded.
> > > > > > > 
> > > > > > > If it doesn't require stateful processing, please enlight me on why
> > > > > > > conntrack is being used in the first place. What's the use case here?
> > > > > > > 
> > > > > > 
> > > > > > The use case for example is when we have vxlan traffic but we do
> > > > > > conntrack on the inner packet (rules on the physical port) so
> > > > > > we never get established but on miss we can still offload as normal
> > > > > > vxlan traffic.
> > > > > > 
> > > > > 
> > > > > my mistake about "inner packet". we do CT on the underlay network, i.e.
> > > > > the outer header.
> > > > 
> > > > I miss why the CT match is being used there then. Isn't it a config
> > > > issue/waste of resources? What is CT adding to the matches/actions
> > > > being done on these flows?
> > > > 
> > > 
> > > Consider a use case where the network port receives both east-west
> > > encapsulated traffic and north-south non-encapsulated traffic that requires
> > > NAT.
> > > 
> > > One possible configuration is to first apply the CT-NAT action.
> > > Established north-south connections will successfully execute the nat action
> > > and will set the +est ct state.
> > > However, the +new state may apply either for valid east-west traffic (e.g.
> > > vxlan) due to source port entropy, or to insecure north-south traffic that
> > > the fw should block. The user may distinguish between the two cases, for
> > > example, by matching on the dest udp port.
> > 
> > Sorry but I still don't see the big picture. :-]
> > 
> > What do you consider as east-west and north-south traffic? My initial
> > understanding of east-west is traffic between VFs and north-south
> > would be in and out to the wire. You mentioned that north-south is
> > insecure, it would match, but then, non-encapsulated?
> > 
> > So it seems you referred to the datacenter. East-west is traffic
> > between hosts on the same datacenter, and north-south is traffic that
> > goes out of it. This seems to match.
> 
> Right.
> 
> > 
> > Assuming it's the latter, then it seems that the idea is to work
> > around a config simplification that was done by the user.  As
> > mentioned on the changelog, such protocols do not require stateful
> > processing, and AFAICU this patch twists conntrack so that the user
> > can have simplified rules. Why can't the user have specific rules for
> > the tunnels, and other for dealing with north-south traffic? The fw
> > would still be able to block unwanted traffic.
> 
> We cannot control what the user is doing.

Right, but we can educate and point them towards better configs. With
non-optimal configs it's fair to expect non-optimal effects.

> This is a valid tc configuration and would work using tc software datapath.
> However, in such configurations vxlan packets would not be processed in
> hardware because they are marked as new connections.

Makes sense.

> 
> > 
> > My main problems with this is this, that it is making conntrack do
> > stuff that the user may not be expecting it to do, and that packets
> > may get matched (maybe even unintentionally) and the system won't have
> > visibility on them. Maybe I'm just missing something?
> > 
> 
> This is why we restricted this feature to udp protocols that will never
> enter established state due to source port entropy.
> Do you see a problematic use case that can arise?

For use case, the only one I see is if someone wants to use this
feature for another application/dstport. It's hardcoded to tunnels
ones.

It feels that the problem is not being solved at the right place. It
will work well for hardware processing, while for software it will
work while having a ton of conntrack entries. Different behaviors that
can lead to people wasting time. Like, trying to debug on why srcport
is not getting randomized when offloaded, while in fact they are, it's
just masked.

As this is a fallback (iow, search is done in 2 levels at least), I
wonder what other approaches were considered. I'm thinking two for
now. One is to add a flag to conntrack entries that allow them to be
this generic. Finding the right conntrack entry probably gets harder,
but when the user dumps /proc/net/nf_conntrack, it says something. On
how/when to add this flag, maybe act_ct can do it if dstport matches
something and/or a sysctl specifying a port list.

The other one may sound an overkill, but is to work with conntrack
expectations somehow.

The first one is closer to the current proposal. It basically makes
the port list configurable and move the "do it" decision to outside
the driver, where the admin can have more control. If conntrack itself
can also leverage it and avoid having tons of entries, even better, as
then we have both behaviors in sync.

Thoughts?

> 
> > > 
> > > 
> > > > > 
> > > > > > > > 
> > > > > > > > The change in the model is that a miss on the CT table will be forwarded
> > > > > > > > to a new +trk+new ct table and a miss there will be forwarded to
> > > > > > > > the slow
> > > > > > > > path table.
> > > > > > > 
> > > > > > > AFAICU this new +trk+new ct table is a wildcard match on sport with
> > > > > > > specific dports. Also AFAICU, such entries will not be visible to the
> > > > > > > userspace then. Is this right?
> > > > > > > 
> > > > > > >      Marcelo
> > > > > > > 
> > > > > > 
> > > > > > right.
> > > > 
> > > > Thanks,
> > > > Marcelo
> > > > 
> > > 
> 
