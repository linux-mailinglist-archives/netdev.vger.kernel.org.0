Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906602512D2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 09:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgHYHOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 03:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729194AbgHYHOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 03:14:25 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D965AC061574;
        Tue, 25 Aug 2020 00:14:24 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id p4so10098199qkf.0;
        Tue, 25 Aug 2020 00:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EM/9NVrmvXUFHUFdTlwMkxMxioJofdUIxRyHRgsK3Z8=;
        b=NLxzxEeiO4+AZhC2eQ3YTH+YmUbHpNJDFHqvh5LgtsiAOh8/pf+T7/5gnFMdgA3bSJ
         sdjmbiMwKl0ksKwpGJP4nJ+LmH6jz+ibNlTErodqD5ssIbeVpRnDQP//3SvVbThTG8cy
         HhaTggw+95cgNZWgOe7BurbJLRBVdL0PkIvO38BQ83BWB4snLFdpAMvFBGnIfc5bXl2m
         3tU/QCsCxQA8V4cEdwBYkwfpei2U3WAnJS4a806QnfvwPFsJkOtQk5blDBDPt9NIWaAO
         uDnfxZazpbr1F0v2qOgGKSSoTFEaTw/cwkYaU+pK3VA0hLdmhVMKEgp53A89Hlhj/ZVL
         v5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EM/9NVrmvXUFHUFdTlwMkxMxioJofdUIxRyHRgsK3Z8=;
        b=okRgMlCzR7XvzavCLQdTBanfb2u3p4opoM4R1FeDLagf/+ci0jl20XaJ9lNMVbqFTt
         /zTYJTwcHkBqkAzCuJrRZ9pLQzPAqqQgxnvYpzf6mJ1K217Ho19Y24TKah+s+h+Mk0MC
         ExI7Y6F5nU3Qmq1pXdM3vovTSfNQFy3YyxrOWJidvOowzoL62L4xIY0DgZDCIsyrZppP
         HtxpUkUC5S+FuuUJ6aYxfly7rdwiP00n+0miB1aY0r9KfLR2VJtFvyWttwtpmLHg8yXm
         UWLLqzNPhxitXbiTsnCmw3xIK6tltH8f4eEBzePdnVFKwRo6ctb/0JgpSllLhihCuJt3
         4gLQ==
X-Gm-Message-State: AOAM530/0ceKABYj2OaQzXLJD1GyIzw+xUwa+ObVHziOLqNDWTyhh/lO
        YhRfqhwKov1L0K0IUr9oGQAd1Dk3rmdbokOtZrI=
X-Google-Smtp-Source: ABdhPJz3gbXaBvdrdhHYipKiFWAOdiazLMLbsG7bjfsvnshjEdgujhC89BlYhCnSO+2jLGo7qt4ericSFJxGTTvaf7A=
X-Received: by 2002:a37:a3d4:: with SMTP id m203mr4278032qke.91.1598339664083;
 Tue, 25 Aug 2020 00:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com>
In-Reply-To: <20200825032312.11776-1-hdanton@sina.com>
From:   Fengkehuan Feng <kehuan.feng@gmail.com>
Date:   Tue, 25 Aug 2020 15:14:12 +0800
Message-ID: <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
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

I just tried the updated version and the system can boot up now.
It does mitigate the issue a lot but still couldn't get rid of it
thoroughly. It seems to me like the effect of Cong's patch.


Hillf Danton <hdanton@sina.com> =E4=BA=8E2020=E5=B9=B48=E6=9C=8825=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=8811:23=E5=86=99=E9=81=93=EF=BC=9A
>
>
> Hi Feng,
>
> On Tue, 25 Aug 2020 10:18:05 +0800 Fengkehuan Feng wrote:
> > Hillf,
> >
> > With the latest version (attached what I have changed on my tree), the
> > system failed to start up with cpu stalled.
>
> My fault.
>
> There is a missing break while running qdisc and it's fixed
> in the diff below for Linux-5.x.
>
> If it is Linux-4.x in your testing, running qdisc looks a bit
> different based on your diff(better if it's in the message body):
>
>  static inline void qdisc_run(struct Qdisc *q)
>  {
> -       if (qdisc_run_begin(q)) {
> +       while (qdisc_run_begin(q)) {
> +               int seq =3D q->pkt_seq;
>                 __qdisc_run(q);
>                 qdisc_run_end(q);
> +
> +               /* go another round if there are pkts enqueued after
> +                * taking seq_lock
> +                */
> +               if (seq !=3D q->pkt_seq)
> +                       continue;
> +               else
> +                       return;
>         }
>  }
>
>
> Hillf
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
> @@ -117,14 +117,27 @@ void __qdisc_run(struct Qdisc *q);
>
>  static inline void qdisc_run(struct Qdisc *q)
>  {
> -       if (qdisc_run_begin(q)) {
> +       while (qdisc_run_begin(q)) {
> +               int seq =3D q->pkt_seq;
> +               bool check_seq =3D false;
> +
>                 /* NOLOCK qdisc must check 'state' under the qdisc seqloc=
k
>                  * to avoid racing with dev_qdisc_reset()
>                  */
>                 if (!(q->flags & TCQ_F_NOLOCK) ||
> -                   likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state=
)))
> +                   likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state=
))) {
>                         __qdisc_run(q);
> +                       check_seq =3D true;
> +               }
>                 qdisc_run_end(q);
> +
> +               /* go another round if there are pkts enqueued after
> +                * taking seq_lock
> +                */
> +               if (check_seq && seq !=3D q->pkt_seq)
> +                       continue;
> +               else
> +                       return;
>         }
>  }
>
> --
>
