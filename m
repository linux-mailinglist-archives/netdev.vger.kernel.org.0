Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BCF1C5E56
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbgEERGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:06:25 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:42596 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729553AbgEERGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588698385; x=1620234385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=hyqx3sEx0HkM4cRvxyLFgm0m8+qZ9wy5z5vRYYMS0v8=;
  b=bqIIKFLne/cfHFTgbQB2MnJo8Gvh1as7T1D9EDayzhyBHlfJY+BOYb7e
   OsW/C5ba9dZHGh1TTIgzy07IVaSBphBSXOy0Gt5jYGMPyl4dXcr12Uhw/
   x5zLfm+64OwHH+HWXEC3ovQZ3GIyHGvGMckss0HfNH2Z1plm9ryJ+OyWD
   c=;
IronPort-SDR: jhgWSVz5jwTYo4yq3w9Qga/bGerZXAMJqPWrkL80dbu2OKh46ZpUZ9UuexC7wzHQtQe+rK3/qi
 F4LZtCWE8enw==
X-IronPort-AV: E=Sophos;i="5.73,356,1583193600"; 
   d="scan'208";a="42833981"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 May 2020 17:06:23 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id DC9D6A2115;
        Tue,  5 May 2020 17:06:21 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 17:06:21 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.180) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 17:06:11 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <sj38.park@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>,
        Paul McKenney <paulmck@kernel.org>
Subject: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 19:05:53 +0200
Message-ID: <20200505170553.24056-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <67bdfac9-0d7d-0bbe-dc7a-d73979fd8ed9@gmail.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 09:37:42 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> 
> 
> On 5/5/20 9:31 AM, Eric Dumazet wrote:
> > 
> > 
> > On 5/5/20 9:25 AM, Eric Dumazet wrote:
> >>
> >>
> >> On 5/5/20 9:13 AM, SeongJae Park wrote:
> >>> On Tue, 5 May 2020 09:00:44 -0700 Eric Dumazet <edumazet@google.com> wrote:
> >>>
> >>>> On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
> >>>>>
> >>>>> On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 5/5/20 8:07 AM, SeongJae Park wrote:
> >>>>>>> On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> >>>>>>>
> >>>>>>
[...]
> >>
> >> I would ask Paul opinion on this issue, because we have many objects
> >> being freed after RCU grace periods.
> >>
> >> If RCU subsystem can not keep-up, I guess other workloads will also suffer.
> >>
> >> Sure, we can revert patches there and there trying to work around the issue,
> >> but for objects allocated from process context, we should not have these problems.
> >>
> > 
> > I wonder if simply adjusting rcu_divisor to 6 or 5 would help 
> > 
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index d9a49cd6065a20936edbda1b334136ab597cde52..fde833bac0f9f81e8536211b4dad6e7575c1219a 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -427,7 +427,7 @@ module_param(qovld, long, 0444);
> >  static ulong jiffies_till_first_fqs = ULONG_MAX;
> >  static ulong jiffies_till_next_fqs = ULONG_MAX;
> >  static bool rcu_kick_kthreads;
> > -static int rcu_divisor = 7;
> > +static int rcu_divisor = 6;
> >  module_param(rcu_divisor, int, 0644);
> >  
> >  /* Force an exit from rcu_do_batch() after 3 milliseconds. */
> > 
> 
> To be clear, you can adjust the value without building a new kernel.
> 
> echo 6 >/sys/module/rcutree/parameters/rcu_divisor
> 

I tried value 6, 5, and 4, but none of those removed the problem.


Thanks,
SeongJae Park
