Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A008E250EE1
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 04:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgHYCSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 22:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHYCSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 22:18:17 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65598C061574;
        Mon, 24 Aug 2020 19:18:17 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id s16so7995642qtn.7;
        Mon, 24 Aug 2020 19:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Phyhm1RuVOSQlCYg02P1MvgHrWuSzzzM1hfPQJKvqSs=;
        b=mMr+ptH8K2CskCa5ieMLB8ndmINy4rSZTCoU8xFIVzORLrFhqC5WR3nW8SvAv95a4j
         vx3gITI9yRtYxtfKuSvRohQRJm0R3zHBHEnC9+VODGE9w8jT7+A3niZwkPxVeRdVfa1O
         4NrkzMCZOgpCdIIrV7f20UMugLU8XiX5kSq2fnt5PLa+N/D8QB+Tyfe1tc3N26zm9cDy
         EM+UTMip0hOHZeou6YI2jjRQsEImKgrc7+LYJZWvDMPARe3/SmrU8tweKwBLVfbs/byc
         q820B2SuKyQd6xrTb57gHURV7NXubgARF5vRNe7EF8Idbta3bU0l6E+5/VEvkTawgBBY
         QZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Phyhm1RuVOSQlCYg02P1MvgHrWuSzzzM1hfPQJKvqSs=;
        b=fJlvGDF241oxWPduYC32ZoKmNo+iPAodzYApojK+AoWVTsGMNzeb+V+kVCyM7ASUDF
         kPnKqMIDvLPV4WjnwbSceZWxBpO88dGwM4H9omcNzpEb5panWh8gO/vNGZo7nNB7wkTE
         f05W1Ixe7soDE6XRLHml0YAXaE00MPAc9ogMl4VX4xXMivHu9iqJjS7QavvZqXxFP5ue
         yIRyrgXR/piZB7USQS1kk6csfc33neIjsp7t69Sr9FCT5Q+rrRZGH4iibHh+CLkhwJj0
         X5e7xw285RxFnNT0GEd5Qg2dYPA58REdMzcbKt8o7zSarL8Yp7dMjSNbyhJZ4m6D1TRK
         24dw==
X-Gm-Message-State: AOAM530/KtHB5mGNrSGIFNfUqNwtOUlDvv76aRrzZxUiP+q22e3l4cbp
        JDl2//xpgjy9qTZjbzSAZPBAMZyKL8izVeiUUmc=
X-Google-Smtp-Source: ABdhPJzacbWYWDAeBqrt7LDvkLIAJbCf6dwhghPuERBYdC24MbCpT12zrS7QllHUJnlk2SftNhm187H0qiHD57dGJ5s=
X-Received: by 2002:ac8:349a:: with SMTP id w26mr7712076qtb.263.1598321896494;
 Mon, 24 Aug 2020 19:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com>
In-Reply-To: <20200822032800.16296-1-hdanton@sina.com>
From:   Fengkehuan Feng <kehuan.feng@gmail.com>
Date:   Tue, 25 Aug 2020 10:18:05 +0800
Message-ID: <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="000000000000e0bdf705adaa50c8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e0bdf705adaa50c8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hillf,

With the latest version (attached what I have changed on my tree), the
system failed to start up with cpu stalled.


Hillf Danton <hdanton@sina.com> =E4=BA=8E2020=E5=B9=B48=E6=9C=8822=E6=97=A5=
=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=8811:30=E5=86=99=E9=81=93=EF=BC=9A
>
>
> On Thu, 20 Aug 2020 20:43:17 +0800 Hillf Danton wrote:
> > Hi Jike,
> >
> > On Thu, 20 Aug 2020 15:43:17 +0800 Jike Song wrote:
> > > Hi Josh,
> > >
> > > On Fri, Jul 3, 2020 at 2:14 AM Josh Hunt <johunt@akamai.com> wrote:
> > > {snip}
> > > > Initial results with Cong's patch look promising, so far no stalls.=
 We
> > > > will let it run over the long weekend and report back on Tuesday.
> > > >
> > > > Paolo - I have concerns about possible performance regression with =
the
> > > > change as well. If you can gather some data that would be great. If
> > > > things look good with our low throughput test over the weekend we c=
an
> > > > also try assessing performance next week.
> > > >
> > >
> > > We met possibly the same problem when testing nvidia/mellanox's
> >
> > Below is what was sent in reply to this thread early last month with
> > minor tuning, based on the seqlock. Feel free to drop an echo if it
> > makes ant-antenna-size sense in your tests.
> >
> > > GPUDirect RDMA product, we found that changing NET_SCH_DEFAULT to
> > > DEFAULT_FQ_CODEL mitigated the problem, having no idea why. Maybe you
> > > can also have a try?
> > >
> > > Besides, our testing is pretty complex, do you have a quick test to
> > > reproduce it?
> > >
> > > --
> > > Thanks,
> > > Jike
> >
> >
> > --- a/include/net/sch_generic.h
> > +++ b/include/net/sch_generic.h
> > @@ -79,6 +79,7 @@ struct Qdisc {
> >  #define TCQ_F_INVISIBLE              0x80 /* invisible by default in d=
ump */
> >  #define TCQ_F_NOLOCK         0x100 /* qdisc does not require locking *=
/
> >  #define TCQ_F_OFFLOADED              0x200 /* qdisc is offloaded to HW=
 */
> > +     int                     pkt_seq;
> >       u32                     limit;
> >       const struct Qdisc_ops  *ops;
> >       struct qdisc_size_table __rcu *stab;
> > @@ -156,6 +157,7 @@ static inline bool qdisc_is_empty(const
> >  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
> >  {
> >       if (qdisc->flags & TCQ_F_NOLOCK) {
> > +             qdisc->pkt_seq++;
> >               if (!spin_trylock(&qdisc->seqlock))
> >                       return false;
> >               WRITE_ONCE(qdisc->empty, false);
> > --- a/include/net/pkt_sched.h
> > +++ b/include/net/pkt_sched.h
> > @@ -117,7 +117,9 @@ void __qdisc_run(struct Qdisc *q);
> >
> >  static inline void qdisc_run(struct Qdisc *q)
> >  {
> > -     if (qdisc_run_begin(q)) {
> > +     while (qdisc_run_begin(q)) {
> > +             int seq =3D q->pkt_seq;
> > +
> >               /* NOLOCK qdisc must check 'state' under the qdisc seqloc=
k
> >                * to avoid racing with dev_qdisc_reset()
> >                */
> > @@ -125,6 +127,9 @@ static inline void qdisc_run(struct Qdis
> >                   likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state=
)))
> >                       __qdisc_run(q);
> >               qdisc_run_end(q);
> > +
> > +             if (!(q->flags & TCQ_F_NOLOCK) || seq =3D=3D q->pkt_seq)
> > +                     return;
> >       }
> >  }
>
> The echo from Feng indicates that it's hard to conclude that TCQ_F_NOLOCK
> is the culprit, lets try again with it ignored for now.
>
> Every pkt enqueued on pfifo_fast is tracked in the below diff, and those
> pkts enqueued while we're running qdisc are detected and handled to cut
> the chance for the stuck pkts reported.
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
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -631,6 +631,7 @@ static int pfifo_fast_enqueue(struct sk_
>                         return qdisc_drop(skb, qdisc, to_free);
>         }
>
> +       qdisc->pkt_seq++;
>         qdisc_update_stats_at_enqueue(qdisc, pkt_len);
>         return NET_XMIT_SUCCESS;
>  }
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -117,7 +117,8 @@ void __qdisc_run(struct Qdisc *q);
>
>  static inline void qdisc_run(struct Qdisc *q)
>  {
> -       if (qdisc_run_begin(q)) {
> +       while (qdisc_run_begin(q)) {
> +               int seq =3D q->pkt_seq;
>                 /* NOLOCK qdisc must check 'state' under the qdisc seqloc=
k
>                  * to avoid racing with dev_qdisc_reset()
>                  */
> @@ -125,6 +126,12 @@ static inline void qdisc_run(struct Qdis
>                     likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state=
)))
>                         __qdisc_run(q);
>                 qdisc_run_end(q);
> +
> +               /* go another round if there are pkts enqueued after
> +                * taking seq_lock
> +                */
> +               if (seq !=3D q->pkt_seq)
> +                       continue;
>         }
>  }
>
>

--000000000000e0bdf705adaa50c8
Content-Type: application/octet-stream; name="fix_nolock_from_hillf.patch"
Content-Disposition: attachment; filename="fix_nolock_from_hillf.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ke9bk0mv0>
X-Attachment-Id: f_ke9bk0mv0

LS0tIGluY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmgub3JpZwkyMDIwLTA4LTIxIDE1OjEzOjUxLjc4
Nzk1MjcxMCArMDgwMAorKysgaW5jbHVkZS9uZXQvc2NoX2dlbmVyaWMuaAkyMDIwLTA4LTI0IDIy
OjAxOjQ2LjcxODcwOTkxMiArMDgwMApAQCAtNzksNiArNzksNyBAQAogI2RlZmluZSBUQ1FfRl9J
TlZJU0lCTEUJCTB4ODAgLyogaW52aXNpYmxlIGJ5IGRlZmF1bHQgaW4gZHVtcCAqLwogI2RlZmlu
ZSBUQ1FfRl9OT0xPQ0sJCTB4MTAwIC8qIHFkaXNjIGRvZXMgbm90IHJlcXVpcmUgbG9ja2luZyAq
LwogI2RlZmluZSBUQ1FfRl9PRkZMT0FERUQJCTB4MjAwIC8qIHFkaXNjIGlzIG9mZmxvYWRlZCB0
byBIVyAqLworCWludCAgICAgICAgICAgICAgICAgICAgIHBrdF9zZXE7CiAJdTMyCQkJbGltaXQ7
CiAJY29uc3Qgc3RydWN0IFFkaXNjX29wcwkqb3BzOwogCXN0cnVjdCBxZGlzY19zaXplX3RhYmxl
CV9fcmN1ICpzdGFiOwotLS0gbmV0L3NjaGVkL3NjaF9nZW5lcmljLmMub3JpZwkyMDIwLTA4LTI0
IDIyOjAyOjA0LjU4OTgzMDc1MSArMDgwMAorKysgbmV0L3NjaGVkL3NjaF9nZW5lcmljLmMJMjAy
MC0wOC0yNCAyMjowMzo0OC4wMTA3MjgzODEgKzA4MDAKQEAgLTYzOCw2ICs2MzgsOCBAQAogCSAq
IHNvIHdlIGJldHRlciBub3QgdXNlIHFkaXNjX3FzdGF0c19jcHVfYmFja2xvZ19pbmMoKQogCSAq
LwogCXRoaXNfY3B1X2FkZChxZGlzYy0+Y3B1X3FzdGF0cy0+YmFja2xvZywgcGt0X2xlbik7CisK
KwlxZGlzYy0+cGt0X3NlcSsrOwogCXJldHVybiBORVRfWE1JVF9TVUNDRVNTOwogfQogCi0tLSBp
bmNsdWRlL25ldC9wa3Rfc2NoZWQuaC5vcmlnCTIwMjAtMDgtMjEgMTU6MTM6NTEuNzg3OTUyNzEw
ICswODAwCisrKyBpbmNsdWRlL25ldC9wa3Rfc2NoZWQuaAkyMDIwLTA4LTI0IDIyOjA2OjU4Ljg1
NjAwNTIxMyArMDgwMApAQCAtMTE2LDkgKzExNiwxNiBAQAogCiBzdGF0aWMgaW5saW5lIHZvaWQg
cWRpc2NfcnVuKHN0cnVjdCBRZGlzYyAqcSkKIHsKLQlpZiAocWRpc2NfcnVuX2JlZ2luKHEpKSB7
CisJd2hpbGUgKHFkaXNjX3J1bl9iZWdpbihxKSkgeworCQlpbnQgc2VxID0gcS0+cGt0X3NlcTsK
IAkJX19xZGlzY19ydW4ocSk7CiAJCXFkaXNjX3J1bl9lbmQocSk7CisKKwkJLyogZ28gYW5vdGhl
ciByb3VuZCBpZiB0aGVyZSBhcmUgcGt0cyBlbnF1ZXVlZCBhZnRlcgorIAkJKiB0YWtpbmcgc2Vx
X2xvY2sKKyAJCSovCisgCQlpZiAoc2VxICE9IHEtPnBrdF9zZXEpCisJCQljb250aW51ZTsKIAl9
CiB9CiAK
--000000000000e0bdf705adaa50c8--
