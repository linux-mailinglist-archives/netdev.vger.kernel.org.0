Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B591288CF0
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbgJIPik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389286AbgJIPik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 11:38:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE9D422251;
        Fri,  9 Oct 2020 15:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602257920;
        bh=zT2sE1XCFwE3pApduCqd3WuQpSTFzzJfUjyqg47+zvQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QU7FD4YI5dkUmXSNMq3uqfJGS9Y0JUgEDgX+fWKfcuFpQDtaxtLHY3YPLl8H3AKdo
         grxto7Vw8rZkDTf7DUkGU6SnUm9bfC981uobKYYbdViSsR2oZdufoa2gzUGKETBwmE
         5w2WVCR/yVTMCkurbiLaf6x7T5PeM4cTNDihwc5o=
Date:   Fri, 9 Oct 2020 08:38:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>
Subject: Re: [PATCH net-next] net/sched: get rid of qdisc->padded
Message-ID: <20201009083838.0e9e91f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89i+A2wBXmu8kPpJraBsaz3ndGYYuKz8=y_6n=_mL+HzhHg@mail.gmail.com>
References: <20201007165111.172419-1-eric.dumazet@gmail.com>
        <20201008171846.335b435a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+A2wBXmu8kPpJraBsaz3ndGYYuKz8=y_6n=_mL+HzhHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 09:35:03 +0200 Eric Dumazet wrote:
> On Fri, Oct 9, 2020 at 2:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed,  7 Oct 2020 09:51:11 -0700 Eric Dumazet wrote:  
> > > diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> > > index 6c762457122fd0091cb0f2bf41bda73babc4ac12..d8fd8676fc724110630904909f64d7789f3a4b47 100644
> > > --- a/include/net/sch_generic.h
> > > +++ b/include/net/sch_generic.h
> > > @@ -91,7 +91,7 @@ struct Qdisc {
> > >       struct net_rate_estimator __rcu *rate_est;
> > >       struct gnet_stats_basic_cpu __percpu *cpu_bstats;
> > >       struct gnet_stats_queue __percpu *cpu_qstats;
> > > -     int                     padded;
> > > +     int                     pad;
> > >       refcount_t              refcnt;
> > >
> > >       /*  
> >
> > Hi Eric!
> >
> > Why keep the pad field? the member to lines down is
> > __cacheline_aligned, so we shouldn't have to manually
> > push things out?
> >
> >         struct gnet_stats_queue __percpu *cpu_qstats;
> >         int                     pad;  
> 
> I usually prefer adding explicit fields to tell where the holes are,
> for future reuse.
> Not many developers are aware of pahole existence :/
> I renamed it to pad, I could have used padding or something else.

Alright then, applied, thank you!
