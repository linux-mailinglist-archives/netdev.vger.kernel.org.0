Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F3E396C85
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 06:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhFAExj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 00:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAEx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 00:53:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C51861003;
        Tue,  1 Jun 2021 04:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622523108;
        bh=zbhAZ5uRzbyUXrwLYT5OmvYg1ARvAESaL9haVdymp7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vna5BIvy4FXZPNCyHM133ndFjDqf/tqlanbNXpK9URqQoahBchrt3egQX6mwxBjzy
         1mDuvFqPUBM3vEkwQyNH8t5Xix9fO+epsU2L4e8PV8PR5LkTOIqot54VIwCPOb5QSP
         Og8NDVy0/yqOcp9XPvO9MRiwD4pTPjz4+yqtznfRW9ROF+HcLePIhO4dTYx2PsF2Ha
         bSMsc/ah1pho5GFFJHCUrUY4VoZoGTwq8TL5qQ2NIbH92OaQEwms/zzovyMa5Zk3s1
         OgzExfWoScbv0eZIUIvH2iDYQotgutyUOOiFLUmDoarDAGmSWp7mUelCTPgEIkXFlA
         /CleF295e+3kQ==
Date:   Mon, 31 May 2021 21:51:46 -0700
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
Message-ID: <20210531215146.5ca802a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <428f92d8-f4a2-13cf-8dcc-b38d48a42965@huawei.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 20:40:01 +0800 Yunsheng Lin wrote:
> On 2021/5/31 9:10, Yunsheng Lin wrote:
> > On 2021/5/31 8:40, Yunsheng Lin wrote: =20
> >> On 2021/5/31 4:21, Jakub Kicinski wrote: =20
>  [...] =20
>  [...] =20
>  [...] =20
>  [...] =20
>  [...] =20
>  [...] =20
>  [...] =20
> >>
> >> When nolock_qdisc_is_empty() is not re-checking under q->seqlock, we
> >> may have:
> >>
> >>
> >>         CPU1                                   CPU2
> >>   qdisc_run_begin(q)                            .
> >>           .                                enqueue skb1
> >> deuqueue skb1 and clear MISSED                  .
> >>           .                        nolock_qdisc_is_empty() return true
> >>     requeue skb                                 .
> >>    q->enqueue()                                 .
> >>     set MISSED                                  .
> >>         .                                       .
> >>  qdisc_run_end(q)                               .
> >>         .                              qdisc_run_begin(q)
> >>         .                             transmit skb2 directly
> >>         .                           transmit the requeued skb1
> >>
> >> The problem here is that skb1 and skb2  are from the same CPU, which
> >> means they are likely from the same flow, so we need to avoid this,
> >> right? =20
> >=20
> >=20
> >          CPU1                                   CPU2
> >    qdisc_run_begin(q)                            .
> >            .                                enqueue skb1
> >      dequeue skb1                                .
> >            .                                     .
> > netdevice stopped and MISSED is clear            .
> >            .                        nolock_qdisc_is_empty() return true
> >      requeue skb                                 .
> >            .                                     .
> >            .                                     .
> >            .                                     .
> >   qdisc_run_end(q)                               .
> >            .                              qdisc_run_begin(q)
> >            .                             transmit skb2 directly
> >            .                           transmit the requeued skb1
> >=20
> > The above sequence diagram seems more correct, it is basically about ho=
w to
> > avoid transmitting a packet directly bypassing the requeued packet.

I see, thanks! That explains the need. Perhaps we can rephrase the
comment? Maybe:

+			/* Retest nolock_qdisc_is_empty() within the protection
+			 * of q->seqlock to protect from racing with requeuing.
+			 */

> I had did some interesting testing to show how adjust a small number
> of code has some notiable performance degrade.
>=20
> 1. I used below patch to remove the nolock_qdisc_is_empty() testing
>    under q->seqlock.
>=20
> @@ -3763,17 +3763,6 @@ static inline int __dev_xmit_skb(struct sk_buff *s=
kb, struct Qdisc *q,
>         if (q->flags & TCQ_F_NOLOCK) {
>                 if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(=
q) &&
>                     qdisc_run_begin(q)) {
> -                       /* Retest nolock_qdisc_is_empty() within the prot=
ection
> -                        * of q->seqlock to ensure qdisc is indeed empty.
> -                        */
> -                       if (unlikely(!nolock_qdisc_is_empty(q))) {
> -                               rc =3D q->enqueue(skb, q, &to_free) & NET=
_XMIT_MASK;
> -                               __qdisc_run(q);
> -                               qdisc_run_end(q);
> -
> -                               goto no_lock_out;
> -                       }
> -
>                         qdisc_bstats_cpu_update(q, skb);
>                         if (sch_direct_xmit(skb, q, dev, txq, NULL, true)=
 &&
>                             !nolock_qdisc_is_empty(q))
> @@ -3786,7 +3775,6 @@ static inline int __dev_xmit_skb(struct sk_buff *sk=
b, struct Qdisc *q,
>                 rc =3D q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
>                 qdisc_run(q);
>=20
> -no_lock_out:
>                 if (unlikely(to_free))
>                         kfree_skb_list(to_free);
>                 return rc;
>=20
> which has the below performance improvement:
>=20
>  threads      v1             v1 + above patch          delta
>     1       3.21Mpps            3.20Mpps               -0.3%
>     2       5.56Mpps            5.94Mpps               +4.9%
>     4       5.58Mpps            5.60Mpps               +0.3%
>     8       2.76Mpps            2.77Mpps               +0.3%
>    16       2.23Mpps            2.23Mpps               +0.0%
>=20
> v1 =3D this patchset.
>=20
>=20
> 2. After the above testing, it seems worthwhile to remove the
>    nolock_qdisc_is_empty() testing under q->seqlock, so I used below
>    patch to make sure nolock_qdisc_is_empty() always return false for
>    netdev queue stopped case=E3=80=82
>=20
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -38,6 +38,15 @@ EXPORT_SYMBOL(default_qdisc_ops);
>  static void qdisc_maybe_clear_missed(struct Qdisc *q,
>                                      const struct netdev_queue *txq)
>  {
> +       set_bit(__QDISC_STATE_DRAINING, &q->state);
> +
> +       /* Make sure DRAINING is set before clearing MISSED
> +        * to make sure nolock_qdisc_is_empty() always return
> +        * false for aoviding transmitting a packet directly
> +        * bypassing the requeued packet.
> +        */
> +       smp_mb__after_atomic();
> +
>         clear_bit(__QDISC_STATE_MISSED, &q->state);
>=20
>         /* Make sure the below netif_xmit_frozen_or_stopped()
> @@ -52,8 +61,6 @@ static void qdisc_maybe_clear_missed(struct Qdisc *q,
>          */
>         if (!netif_xmit_frozen_or_stopped(txq))
>                 set_bit(__QDISC_STATE_MISSED, &q->state);
> -       else
> -               set_bit(__QDISC_STATE_DRAINING, &q->state);
>  }

But this would not be enough because we may also clear MISSING=20
in pfifo_fast_dequeue()?

> which has the below performance data:
>=20
>  threads      v1          v1 + above two patch          delta
>     1       3.21Mpps            3.20Mpps               -0.3%
>     2       5.56Mpps            5.94Mpps               +4.9%
>     4       5.58Mpps            5.02Mpps                -10%
>     8       2.76Mpps            2.77Mpps               +0.3%
>    16       2.23Mpps            2.23Mpps               +0.0%
>=20
> So the adjustment in qdisc_maybe_clear_missed() seems to have
> caused about 10% performance degradation for 4 threads case.
>=20
> And the cpu topdown perf data suggested that icache missed and
> bad Speculation play the main factor to those performance difference.
>=20
> I tried to control the above factor by removing the inline function
> and add likely and unlikely tag for netif_xmit_frozen_or_stopped()
> in sch_generic.c.
>=20
> And after removing the inline mark for function in sch_generic.c
> and add likely/unlikely tag for netif_xmit_frozen_or_stopped()
> checking in in sch_generic.c, we got notiable performance improvement
> for 1/2 threads case(some performance improvement for ip forwarding
> test too), but not for 4 threads case.
>=20
> So it seems we need to ignore the performance degradation for 4
> threads case? or any idea?

No ideas, are the threads pinned to CPUs in some particular way?
