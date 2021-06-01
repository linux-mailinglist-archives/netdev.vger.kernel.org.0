Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695F9397B6C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhFAUum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 16:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234756AbhFAUuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 16:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B85A560E0C;
        Tue,  1 Jun 2021 20:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622580539;
        bh=alP6MwNJj6Tz9IWa3CoTduqAUpA0QOW99jGw8zk2njU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RWn1Gby6RnNrr32g8UFmJmfRd5MahcuQZ+zOd8xVMBtrLgDRovGotB9OtbO+5mHlT
         eUa5Bl7atcRLL7oIWawrltnShlo6/e3w/qxCDhWvRw2vm4JKr2EzRKcLYHvmmG8XCq
         +j8tqiqr335SoRdSysnMUbzX75x1eaQXgLYuGEpXhpKRcsPF63E9RR9mLkiZQ2PSr7
         mqPc3kXdHdzh0WvwaKc/GGPp9h8BGFyoEs9lTviAWptf7F4AnGiReDYxWrwW3j4JYl
         3f/v/ImdR9nphGLJF4uezurJkGNB0iwrO/wX5bYutvvcHMHtpzrTi0MN929byBwGKF
         l/PzYctLmkh+A==
Date:   Tue, 1 Jun 2021 13:48:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Yunsheng Lin <yunshenglin0825@gmail.com>, <davem@davemloft.net>,
        <olteanv@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: Re: [Linuxarm] Re: [PATCH net-next 2/3] net: sched: implement
 TCQ_F_CAN_BYPASS for lockless qdisc
Message-ID: <20210601134856.12573333@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <cf75e1f4-7972-8efa-7554-fc528c5da380@huawei.com>
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
        <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
        <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
        <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <ee1a62da-9758-70db-abd3-c5ca2e8e0ce0@huawei.com>
        <20210529114919.4f8b1980@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <9cc9f513-7655-07df-3c74-5abe07ae8321@gmail.com>
        <20210530132111.3a974275@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3c2fbc70-841f-d90b-ca13-1f058169be50@huawei.com>
        <3a307707-9fb5-d73a-01f9-93aaf5c7a437@huawei.com>
        <428f92d8-f4a2-13cf-8dcc-b38d48a42965@huawei.com>
        <20210531215146.5ca802a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <cf75e1f4-7972-8efa-7554-fc528c5da380@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 16:18:54 +0800 Yunsheng Lin wrote:
> > I see, thanks! That explains the need. Perhaps we can rephrase the
> > comment? Maybe:
> > 
> > +			/* Retest nolock_qdisc_is_empty() within the protection
> > +			 * of q->seqlock to protect from racing with requeuing.
> > +			 */  
> 
> Yes if we still decide to preserve the nolock_qdisc_is_empty() rechecking
> under q->seqlock.

Sounds good.

> >> --- a/net/sched/sch_generic.c
> >> +++ b/net/sched/sch_generic.c
> >> @@ -38,6 +38,15 @@ EXPORT_SYMBOL(default_qdisc_ops);
> >>  static void qdisc_maybe_clear_missed(struct Qdisc *q,
> >>                                      const struct netdev_queue *txq)
> >>  {
> >> +       set_bit(__QDISC_STATE_DRAINING, &q->state);
> >> +
> >> +       /* Make sure DRAINING is set before clearing MISSED
> >> +        * to make sure nolock_qdisc_is_empty() always return
> >> +        * false for aoviding transmitting a packet directly
> >> +        * bypassing the requeued packet.
> >> +        */
> >> +       smp_mb__after_atomic();
> >> +
> >>         clear_bit(__QDISC_STATE_MISSED, &q->state);
> >>
> >>         /* Make sure the below netif_xmit_frozen_or_stopped()
> >> @@ -52,8 +61,6 @@ static void qdisc_maybe_clear_missed(struct Qdisc *q,
> >>          */
> >>         if (!netif_xmit_frozen_or_stopped(txq))
> >>                 set_bit(__QDISC_STATE_MISSED, &q->state);
> >> -       else
> >> -               set_bit(__QDISC_STATE_DRAINING, &q->state);
> >>  }  
> > 
> > But this would not be enough because we may also clear MISSING 
> > in pfifo_fast_dequeue()?  
> 
> For the MISSING clearing in pfifo_fast_dequeue(), it seems it
> looks like the data race described in RFC v3 too?
> 
>       CPU1                 CPU2               CPU3
> qdisc_run_begin(q)          .                  .
>         .              MISSED is set           .
>   MISSED is cleared         .                  .
>     q->dequeue()            .                  .
>         .              enqueue skb1     check MISSED # true
> qdisc_run_end(q)            .                  .
>         .                   .         qdisc_run_begin(q) # true
>         .            MISSED is set      send skb2 directly

Not sure what you mean.
