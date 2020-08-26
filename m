Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61910252584
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 04:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHZCi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 22:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHZCi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 22:38:56 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FC2C061574;
        Tue, 25 Aug 2020 19:38:55 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id cs12so137096qvb.2;
        Tue, 25 Aug 2020 19:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZfdEeRkGYYJGqA9dRHE+OHZVDWc9//QHNY+B5Tdcg7c=;
        b=BeGWowEwb9tCzzJMFPX4d67otru8ppw6l5bqmwbIc7/9vgRTitRITqEt1dxhubYx8X
         UNDP/LRYicQckoyLd33GxPv9ljUGMUemrcn6aWuBS9rBUaVLANnakDS27y1G9Iac3ChR
         015tRTcDnv6NT9r4FwpQXKh6sDDJ6GJHvz37/OhOSw6wphpCxZD/HLCx17LYGTUNpXQH
         shmDrv6TCFH3zmY15E9CN5zrKvVoznBsxJO+zEmR5wq1rTOPUMNJOlHnh4osacCSo0ZT
         SGqKRJwlVIfbz6zmaayHPfkGX/dFQ9FZ1UFvJp9aDJnz2JBnbZW0uW3a7BSDdSO91PAB
         2GJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZfdEeRkGYYJGqA9dRHE+OHZVDWc9//QHNY+B5Tdcg7c=;
        b=Cgb/ypJsGc7GfcYDhn4JpNW35HVGQ7GNd8QlUXWJTSIiColeq0tZQil+ZkltxUoZsR
         ltZ6xvERWpWve6QQT2OGYs/bLRC9k8gdJiawrNMJN4UkUZTQBUkUdVMt4nRVrfoGx7eQ
         Fx3r/BhaMMfqVAQyIP/uhsOT0tXtOrdok06p2fpbGq4w7ZRLFo1porUfQ9V6LCQz3Fvo
         9yocYxdON/VzAC6TH9IrA7YqN2HMlgy2Avo/7i+C755KHbxtLFKPagMGvm1y8BxeXhpa
         Pt3m8t0xLxqDGOJsaGS2QzD1R1miEH+o8Tt2/ixOXX/azqrjorOnxSwLNbDltdtlpspk
         OXtQ==
X-Gm-Message-State: AOAM53344JFoodrSUCtsqzcOKczT0hy6fiLnOouGnhXaD5AE92VZuEGC
        +x9BDrPuybQuwO33GShUL3sbqzwWRngoPbAElns=
X-Google-Smtp-Source: ABdhPJyryS+THO4tooNNmhvHHlRhElXnGkWzzGY0fyPBKoMaie30LtiYvAFdp8ePYIYtStjn5OLmLJruVBYoeaCrkhM=
X-Received: by 2002:a05:6214:1108:: with SMTP id e8mr12289973qvs.237.1598409534967;
 Tue, 25 Aug 2020 19:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com>
In-Reply-To: <20200825162329.11292-1-hdanton@sina.com>
From:   Kehuan Feng <kehuan.feng@gmail.com>
Date:   Wed, 26 Aug 2020 10:38:43 +0800
Message-ID: <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Hillf Danton <hdanton@sina.com>
Cc:     Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hillf,

Thanks for the patch.
I just tried it and it looks better than previous one. The issue
appeared only once over ~30 mins stressing (without the patch , it
shows up within 1 mins in usual, so I feel like we are getting close
to the final fix)
(pasted the modifications on my tree in case of any missing)

--- ./include/net/sch_generic.h.orig 2020-08-21 15:13:51.787952710 +0800
+++ ./include/net/sch_generic.h 2020-08-26 09:41:04.647173869 +0800
@@ -79,6 +79,7 @@
 #define TCQ_F_INVISIBLE 0x80 /* invisible by default in dump */
 #define TCQ_F_NOLOCK 0x100 /* qdisc does not require locking */
 #define TCQ_F_OFFLOADED 0x200 /* qdisc is offloaded to HW */
+ int                     pkt_seq;
  u32 limit;
  const struct Qdisc_ops *ops;
  struct qdisc_size_table __rcu *stab;
--- ./include/net/pkt_sched.h.orig 2020-08-21 15:13:51.787952710 +0800
+++ ./include/net/pkt_sched.h 2020-08-26 09:42:14.491377514 +0800
@@ -117,8 +117,15 @@
 static inline void qdisc_run(struct Qdisc *q)
 {
  if (qdisc_run_begin(q)) {
+ q->pkt_seq =3D 0;
+
  __qdisc_run(q);
  qdisc_run_end(q);
+
+ /* reschedule qdisc if there are packets enqueued */
+ if (q->pkt_seq !=3D 0)
+ __netif_schedule(q);
+
  }
 }

--- ./net/core/dev.c.orig 2020-03-19 16:31:27.000000000 +0800
+++ ./net/core/dev.c 2020-08-26 09:47:57.783165885 +0800
@@ -2721,6 +2721,7 @@

  local_irq_save(flags);
  sd =3D this_cpu_ptr(&softnet_data);
+ q->pkt_seq =3D 0;
  q->next_sched =3D NULL;
  *sd->output_queue_tailp =3D q;
  sd->output_queue_tailp =3D &q->next_sched;
--- ./net/sched/sch_generic.c.orig 2020-08-24 22:02:04.589830751 +0800
+++ ./net/sched/sch_generic.c 2020-08-26 09:43:40.987852551 +0800
@@ -403,6 +403,9 @@
  */
  quota -=3D packets;
  if (quota <=3D 0 || need_resched()) {
+ /* info caller to reschedule qdisc outside q->seqlock */
+ q->pkt_seq =3D 1;
+
  __netif_schedule(q);
  break;
  }


Hillf Danton <hdanton@sina.com> =E4=BA=8E2020=E5=B9=B48=E6=9C=8826=E6=97=A5=
=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=8812:26=E5=86=99=E9=81=93=EF=BC=9A
>
>
> Hi Feng,
>
> On Tue, 25 Aug 2020 15:14:12 +0800 Fengkehuan Feng wrote:
> > Hi Hillf,
> >
> > I just tried the updated version and the system can boot up now.
>
> Thanks again for your testing.
>
> > It does mitigate the issue a lot but still couldn't get rid of it
> > thoroughly. It seems to me like the effect of Cong's patch.
>
> Your echoes show we're still march in the dark and let's try another
> direction in which qdisc is rescheduled outside seqlock to make sure
> tx softirq is raised when there're more packets on the pfifo_fast to
> be transmitted.
>
>         CPU0                            CPU1
>         ----                            ----
>         seqlock
>         test __QDISC_STATE_SCHED
>                 raise tx softirq
>                                         clear __QDISC_STATE_SCHED
>                                         try seqlock
>                                         __qdisc_run(q);
>                                         sequnlock
>         sequnlock
>
>
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -79,6 +79,7 @@ struct Qdisc {
>  #define TCQ_F_INVISIBLE                0x80 /* invisible by default in d=
ump */
>  #define TCQ_F_NOLOCK           0x100 /* qdisc does not require locking *=
/
>  #define TCQ_F_OFFLOADED                0x200 /* qdisc is offloaded to HW=
 */
> +       int                     pkt_seq;
>         u32                     limit;
>         const struct Qdisc_ops  *ops;
>         struct qdisc_size_table __rcu *stab;
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -118,6 +118,8 @@ void __qdisc_run(struct Qdisc *q);
>  static inline void qdisc_run(struct Qdisc *q)
>  {
>         if (qdisc_run_begin(q)) {
> +               q->pkt_seq =3D 0;
> +
>                 /* NOLOCK qdisc must check 'state' under the qdisc seqloc=
k
>                  * to avoid racing with dev_qdisc_reset()
>                  */
> @@ -125,6 +127,10 @@ static inline void qdisc_run(struct Qdis
>                     likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state=
)))
>                         __qdisc_run(q);
>                 qdisc_run_end(q);
> +
> +               /* reschedule qdisc if there are packets enqueued */
> +               if (q->pkt_seq !=3D 0)
> +                       __netif_schedule(q);
>         }
>  }
>
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -384,6 +384,8 @@ void __qdisc_run(struct Qdisc *q)
>         while (qdisc_restart(q, &packets)) {
>                 quota -=3D packets;
>                 if (quota <=3D 0) {
> +                       /* info caller to reschedule qdisc outside q->seq=
lock */
> +                       q->pkt_seq =3D 1;
>                         __netif_schedule(q);
>                         break;
>                 }
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3031,6 +3031,7 @@ static void __netif_reschedule(struct Qd
>
>         local_irq_save(flags);
>         sd =3D this_cpu_ptr(&softnet_data);
> +       q->pkt_seq =3D 0;
>         q->next_sched =3D NULL;
>         *sd->output_queue_tailp =3D q;
>         sd->output_queue_tailp =3D &q->next_sched;
> --
>
