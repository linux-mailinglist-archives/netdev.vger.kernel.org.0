Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35881DBB6D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgETR1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:27:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43318 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETR1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:27:53 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jbSVN-0000Gh-9u; Wed, 20 May 2020 17:27:45 +0000
Date:   Wed, 20 May 2020 19:27:44 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ipv6/route: inherit max_sizes from current netns
Message-ID: <20200520172744.fytw6aojounuf735@wittgenstein>
References: <20200520145806.3746944-1-christian.brauner@ubuntu.com>
 <4b22a3bc-9dae-3f49-6748-ec45deb09a01@gmail.com>
 <20200520172417.4m7pyalpftdd2xrm@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200520172417.4m7pyalpftdd2xrm@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 07:24:18PM +0200, Christian Brauner wrote:
> On Wed, May 20, 2020 at 10:54:21AM -0600, David Ahern wrote:
> > On 5/20/20 8:58 AM, Christian Brauner wrote:
> > > During NorthSec (cf. [1]) a very large number of unprivileged
> > > containers and nested containers are run during the competition to
> > > provide a safe environment for the various teams during the event. Every
> > > year a range of feature requests or bug reports come out of this and
> > > this year's no different.
> > > One of the containers was running a simple VPN server. There were about
> > > 1.5k users connected to this VPN over ipv6 and the container was setup
> > > with about 100 custom routing tables when it hit the max_sizes routing
> > > limit. After this no new connections could be established anymore,
> > > pinging didn't work anymore; you get the idea.
> > > 
> > 
> > should have been addressed by:
> > 
> > commit d8882935fcae28bceb5f6f56f09cded8d36d85e6
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Fri May 8 07:34:14 2020 -0700
> >     ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
> >     We currently have to adjust ipv6 route gc_thresh/max_size depending
> >     on number of cpus on a server, this makes very little sense.
> > 
> > 
> > Did your tests include this patch?
> 
> No, it's also pretty hard to trigger. The conference was pretty good for
> this.
> I tested on top of rc6. I'm probably missing the big picture here, could
> you briefy explain how this commit fixes the problem we ran into?

Hm, and it'd be great if we could expose the file - even just read-only
- to network namespaces owned by non-initial user namespaces. It doesn't
contain sensitive information and could probably be used to limit
connections etc.

Christian
