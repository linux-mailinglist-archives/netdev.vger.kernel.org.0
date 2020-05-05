Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F9A1C5F6A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgEER4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:56:49 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:55852 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbgEER4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588701409; x=1620237409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=BZbaV+a4U8fFiIaIlrZCfbC3DcKGOdw37Xx/FKA1f8w=;
  b=RppM4StihQtn6BWRxdZ5FC5vrlO0lOo2yHzAPWMw5j1zVyqJ8QX+/Pgu
   Kllyrtlknn4NR0/6dFZ+UdUrx29imIgEJ7cJ9RvUZCP63Jv4XYe13r/n8
   7Eplsekk3l+quNjNh7xMk2nB38auh+uzxQd8ZuxkhGTu12VagKoVBNSSG
   Y=;
IronPort-SDR: G2mMMqyG1afU1/6i2loosHO4zzSo6fqmgFiJhpl6u0s8Jrh+UgW6IAkqpxpGXjZvRSSG9lLyVy
 BI0+yfKVsPzQ==
X-IronPort-AV: E=Sophos;i="5.73,356,1583193600"; 
   d="scan'208";a="42847329"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 May 2020 17:56:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id A6B97A1D89;
        Tue,  5 May 2020 17:56:43 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 17:56:42 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.38) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 17:56:35 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
CC:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <sj38.park@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>
Subject: Re: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 19:56:05 +0200
Message-ID: <20200505175605.12015-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505173036.GE2869@paulmck-ThinkPad-P72> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D18UWC004.ant.amazon.com (10.43.162.77) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 10:30:36 -0700 "Paul E. McKenney" <paulmck@kernel.org> wrote:

> On Tue, May 05, 2020 at 07:05:53PM +0200, SeongJae Park wrote:
> > On Tue, 5 May 2020 09:37:42 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > 
> > > 
> > > 
> > > On 5/5/20 9:31 AM, Eric Dumazet wrote:
> > > > 
> > > > 
> > > > On 5/5/20 9:25 AM, Eric Dumazet wrote:
> > > >>
> > > >>
> > > >> On 5/5/20 9:13 AM, SeongJae Park wrote:
> > > >>> On Tue, 5 May 2020 09:00:44 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > > >>>
> > > >>>> On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
> > > >>>>>
> > > >>>>> On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >>>>>
> > > >>>>>>
> > > >>>>>>
> > > >>>>>> On 5/5/20 8:07 AM, SeongJae Park wrote:
> > > >>>>>>> On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > > >>>>>>>
> > > >>>>>>
> > [...]
> > > >>
> > > >> I would ask Paul opinion on this issue, because we have many objects
> > > >> being freed after RCU grace periods.
> > > >>
> > > >> If RCU subsystem can not keep-up, I guess other workloads will also suffer.
> > > >>
> > > >> Sure, we can revert patches there and there trying to work around the issue,
> > > >> but for objects allocated from process context, we should not have these problems.
> > > >>
> > > > 
> > > > I wonder if simply adjusting rcu_divisor to 6 or 5 would help 
> > > > 
> > > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > > index d9a49cd6065a20936edbda1b334136ab597cde52..fde833bac0f9f81e8536211b4dad6e7575c1219a 100644
> > > > --- a/kernel/rcu/tree.c
> > > > +++ b/kernel/rcu/tree.c
> > > > @@ -427,7 +427,7 @@ module_param(qovld, long, 0444);
> > > >  static ulong jiffies_till_first_fqs = ULONG_MAX;
> > > >  static ulong jiffies_till_next_fqs = ULONG_MAX;
> > > >  static bool rcu_kick_kthreads;
> > > > -static int rcu_divisor = 7;
> > > > +static int rcu_divisor = 6;
> > > >  module_param(rcu_divisor, int, 0644);
> > > >  
> > > >  /* Force an exit from rcu_do_batch() after 3 milliseconds. */
> > > > 
> > > 
> > > To be clear, you can adjust the value without building a new kernel.
> > > 
> > > echo 6 >/sys/module/rcutree/parameters/rcu_divisor
> > 
> > I tried value 6, 5, and 4, but none of those removed the problem.
> 
> Thank you for checking this!
> 
> Was your earlier discussion on long RCU readers speculation, or do you
> have measurements?

It was just a guess without any measurement or dedicated investigation.


Thanks,
SeongJae Park

> 
> 							Thanx, Paul
