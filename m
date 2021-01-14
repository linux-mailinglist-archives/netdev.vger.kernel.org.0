Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4316D2F6172
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbhANND2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbhANND1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 08:03:27 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8D5C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:02:46 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id a1so2192167qvd.13
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xzPHBW0D96+i1o+zibKliDP4tsSymWHWUeXWzkraY0g=;
        b=XDGxdLIqlg2CWaQUwlJYWIWYDuddvDOyWX2W7IPNxZmqco0svOYSax/v77vnuU8QZv
         xCUmB13DE0dn8C7duiHhTIo+J36OONCxKBP8i4pODgGkd5lZYhSuVqDhic4v7+5Z5RBq
         FVPQNKQiNEETUhWTcZRqyq7mWfcRnTc1DcHlGU9f1nCNXriT5gQwCiIwWoEVXBaOqH4I
         HfyqYMKPyyvFzhqDtByRdHViiH2SkSij22xTEIXYjwyFeegeBPIbrxP++BCDbWwfuQl6
         ltRaXfDSHQOpvmlvgO1HSsYz1siKswA/EJWIggVZ+BH6esn8pkMJuEXCCw8PS0FE3YVb
         ziZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xzPHBW0D96+i1o+zibKliDP4tsSymWHWUeXWzkraY0g=;
        b=D62hrS/b5jTXnwGapAZxCA+gngl2iwM/mBTqFn8Cm7QIavkn/m1OfFFNKu/mla+ucj
         YKodBwmBE71CI3XgSrvH0ZZAqW8cgJ1e4KE+Iiw4oMx4aRqmRJw7f6Lgj2oEjCSLP/wT
         yDEqcgSYAydrArUHICTT3fXwaq8jKm8jJ7aK5aH3sqNSSUrGlkKAlGFqzIBrU//7gDdj
         MXbkP+Z0OPSPz4TdmVoHS1z2gi6cUCWD4oLhy8IaFGXaz4II98rAPG3JMhYQxiotYaqZ
         diNAkShpPcmEvLGoC0+1ol+DQjSeyEQGktdR2xN0vJcsbe4lj+q4RzCyeKr2vlCuLdfE
         BAfA==
X-Gm-Message-State: AOAM532hDXuHUrmMVwoRkVxk+W1ttgdE/ai3QyHKCUk92QIMPKS5tumx
        Azd7UOe3jd59wk9GwwiUTOQ/WP31QYikEA==
X-Google-Smtp-Source: ABdhPJy5yu5BW6cuWVEezAJs94miG2EsyWHjiwCjHUScAYloNn5yRJqKDPTXPyFfASCHvRnLZj6iFg==
X-Received: by 2002:ad4:580f:: with SMTP id dd15mr6928246qvb.40.1610629365856;
        Thu, 14 Jan 2021 05:02:45 -0800 (PST)
Received: from horizon.localdomain ([177.220.172.93])
        by smtp.gmail.com with ESMTPSA id n4sm2790081qtl.22.2021.01.14.05.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 05:02:42 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id B353EC086E; Thu, 14 Jan 2021 10:02:38 -0300 (-03)
Date:   Thu, 14 Jan 2021 10:02:38 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
Message-ID: <20210114130238.GA2676@horizon.localdomain>
References: <20210108053054.660499-1-saeed@kernel.org>
 <20210108053054.660499-9-saeed@kernel.org>
 <20210108214812.GB3678@horizon.localdomain>
 <c11867d2-6fda-d77c-6b52-f4093c751379@nvidia.com>
 <218258b2-3a86-2d87-dfc6-8b3c1e274b26@nvidia.com>
 <20210111235116.GA2595@horizon.localdomain>
 <f25eee28-4c4a-9036-8c3d-d84b15a8b5e7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f25eee28-4c4a-9036-8c3d-d84b15a8b5e7@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 11:27:04AM +0200, Oz Shlomo wrote:
> 
> 
> On 1/12/2021 1:51 AM, Marcelo Ricardo Leitner wrote:
> > On Sun, Jan 10, 2021 at 09:52:55AM +0200, Roi Dayan wrote:
> > > 
> > > 
> > > On 2021-01-10 9:45 AM, Roi Dayan wrote:
> > > > 
> > > > 
> > > > On 2021-01-08 11:48 PM, Marcelo Ricardo Leitner wrote:
> > > > > Hi,
> > > > > 
> > > > > On Thu, Jan 07, 2021 at 09:30:47PM -0800, Saeed Mahameed wrote:
> > > > > > From: Roi Dayan <roid@nvidia.com>
> > > > > > 
> > > > > > Connection tracking associates the connection state per packet. The
> > > > > > first packet of a connection is assigned with the +trk+new state. The
> > > > > > connection enters the established state once a packet is seen on the
> > > > > > other direction.
> > > > > > 
> > > > > > Currently we offload only the established flows. However, UDP traffic
> > > > > > using source port entropy (e.g. vxlan, RoCE) will never enter the
> > > > > > established state. Such protocols do not require stateful processing,
> > > > > > and therefore could be offloaded.
> > > > > 
> > > > > If it doesn't require stateful processing, please enlight me on why
> > > > > conntrack is being used in the first place. What's the use case here?
> > > > > 
> > > > 
> > > > The use case for example is when we have vxlan traffic but we do
> > > > conntrack on the inner packet (rules on the physical port) so
> > > > we never get established but on miss we can still offload as normal
> > > > vxlan traffic.
> > > > 
> > > 
> > > my mistake about "inner packet". we do CT on the underlay network, i.e.
> > > the outer header.
> > 
> > I miss why the CT match is being used there then. Isn't it a config
> > issue/waste of resources? What is CT adding to the matches/actions
> > being done on these flows?
> > 
> 
> Consider a use case where the network port receives both east-west
> encapsulated traffic and north-south non-encapsulated traffic that requires
> NAT.
> 
> One possible configuration is to first apply the CT-NAT action.
> Established north-south connections will successfully execute the nat action
> and will set the +est ct state.
> However, the +new state may apply either for valid east-west traffic (e.g.
> vxlan) due to source port entropy, or to insecure north-south traffic that
> the fw should block. The user may distinguish between the two cases, for
> example, by matching on the dest udp port.

Sorry but I still don't see the big picture. :-]

What do you consider as east-west and north-south traffic? My initial
understanding of east-west is traffic between VFs and north-south
would be in and out to the wire. You mentioned that north-south is
insecure, it would match, but then, non-encapsulated?

So it seems you referred to the datacenter. East-west is traffic
between hosts on the same datacenter, and north-south is traffic that
goes out of it. This seems to match.

Assuming it's the latter, then it seems that the idea is to work
around a config simplification that was done by the user.  As
mentioned on the changelog, such protocols do not require stateful
processing, and AFAICU this patch twists conntrack so that the user
can have simplified rules. Why can't the user have specific rules for
the tunnels, and other for dealing with north-south traffic? The fw
would still be able to block unwanted traffic.

My main problems with this is this, that it is making conntrack do
stuff that the user may not be expecting it to do, and that packets
may get matched (maybe even unintentionally) and the system won't have
visibility on them. Maybe I'm just missing something?

> 
> 
> > > 
> > > > > > 
> > > > > > The change in the model is that a miss on the CT table will be forwarded
> > > > > > to a new +trk+new ct table and a miss there will be forwarded to
> > > > > > the slow
> > > > > > path table.
> > > > > 
> > > > > AFAICU this new +trk+new ct table is a wildcard match on sport with
> > > > > specific dports. Also AFAICU, such entries will not be visible to the
> > > > > userspace then. Is this right?
> > > > > 
> > > > >     Marcelo
> > > > > 
> > > > 
> > > > right.
> > 
> > Thanks,
> > Marcelo
> > 
> 
