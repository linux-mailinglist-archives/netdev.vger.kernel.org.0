Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BB825CFBC
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 05:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgIDDVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 23:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbgIDDVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 23:21:10 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FD9C061244;
        Thu,  3 Sep 2020 20:21:09 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id w12so5192530qki.6;
        Thu, 03 Sep 2020 20:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6hYi34ob3yfMnT49IleZhiiluAmD9jKrV2EhCD+6b4w=;
        b=nt6xVnowaZ8RycJN+9zbovKpwmtkgnPAshpgJnlazwCelqKtdJMxmOAdYaSy4gaZGv
         TYqNUAHk253lrKA6TZ4RvDNK+PMPAPqJRMcHivzGl1m3A2qMMz5fziVAERQaPubUH8aF
         ln42T4sYGKhPRcqtPeH+988jvwKDFjxkOWVgg8sLxX4B51up4mi6p/5cGZ+to7E3IgMP
         kPWlcKnsfA5itBFFJANSS7NUSltCN/nCetg7chCbaWWxl6ecgyC7s5iX2acRSe7DHypF
         1xHXGMYT05WquGLaLfBc0Ykhp4CPspWJcd6ASvV3lDw2WUG4yVdNRXGFVQDsmRuMLV2I
         fLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6hYi34ob3yfMnT49IleZhiiluAmD9jKrV2EhCD+6b4w=;
        b=pCYC+G80mvgOk3yzdVGNxuzbySNWiNO4eKDu82VoEPy4FVsP6fdzUuOG024iJPXdXZ
         yvpdFoKMTzselU9YLB+rpw8isQM4CUj1iXj5teCFTQf0ueli6qmzj7XjgZSgVvxT0KaP
         P/6y+Z+XIlZMx0UJKJqgH/p8a1uFhiKau57PYCN0PAnVztpNXTRl9g9yRa5AEf87BEZk
         QLQQDx9yau8lKjG+lYT5dQ/cfycxY/NH/TxR4VHFhpnc4ls92lYIqbNsUrix1qN7fdav
         sxM9eroxWul9a+Zrhj3Voha82i0WAJAH3tSVHe7TOaRvTEk36EIphCTU3WHAzxavDYXO
         absw==
X-Gm-Message-State: AOAM5316jQeVtHtJMm8SNqO1L1spk5MEjxfaIvHxA1S2lw43AF6w2NZV
        wMch4Zj8A4gW6EdNjn2DP3NOw94Ri2D3KSVfjoE=
X-Google-Smtp-Source: ABdhPJzSLjofA1DGuOy2KaFcmYwrH5Pkf8hwsnucFEGrWi2LQLkr/Sh9fSVTLbzCJq6/r8xViZY9xzAQ7Llv7X/1XjM=
X-Received: by 2002:a37:e105:: with SMTP id c5mr6067059qkm.150.1599189669063;
 Thu, 03 Sep 2020 20:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AM7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com> <20200903101957.428-1-hdanton@sina.com>
In-Reply-To: <20200903101957.428-1-hdanton@sina.com>
From:   Kehuan Feng <kehuan.feng@gmail.com>
Date:   Fri, 4 Sep 2020 11:20:57 +0800
Message-ID: <CACS=qqLKSpnRrgROm8jzzFid3MH97phPXWsk28b371dfu0mnVA@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Hillf Danton <hdanton@sina.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
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

Hi Hillf, Cong, Paolo,

Sorry for the late reply due to other urgent task.

I tried Hillf's patch (shown below on my tree) and it doesn't help and
the jitter shows up very quickly.

--- ./include/net/sch_generic.h.orig 2020-08-21 15:13:51.787952710 +0800
+++ ./include/net/sch_generic.h 2020-09-04 10:48:32.081217156 +0800
@@ -108,6 +108,7 @@

  spinlock_t busylock ____cacheline_aligned_in_smp;
  spinlock_t seqlock;
+ int run, seq;
 };

 static inline void qdisc_refcount_inc(struct Qdisc *qdisc)
@@ -127,8 +128,11 @@
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 {
  if (qdisc->flags & TCQ_F_NOLOCK) {
+ qdisc->run++;
+ smp_wmb();
  if (!spin_trylock(&qdisc->seqlock))
  return false;
+ qdisc->seq =3D qdisc->run;
  } else if (qdisc_is_running(qdisc)) {
  return false;
  }
@@ -143,8 +147,15 @@
 static inline void qdisc_run_end(struct Qdisc *qdisc)
 {
  write_seqcount_end(&qdisc->running);
- if (qdisc->flags & TCQ_F_NOLOCK)
+ if (qdisc->flags & TCQ_F_NOLOCK) {
+ int seq =3D qdisc->seq;
+
  spin_unlock(&qdisc->seqlock);
+ smp_rmb();
+ if (seq !=3D qdisc->run)
+ __netif_schedule(qdisc);
+
+ }
 }


I also tried Cong's patch (shown below on my tree) and it could avoid
the issue (stressing for 30 minutus for three times and not jitter
observed).

--- ./include/net/sch_generic.h.orig 2020-08-21 15:13:51.787952710 +0800
+++ ./include/net/sch_generic.h 2020-09-03 21:36:11.468383738 +0800
@@ -127,8 +127,7 @@
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 {
  if (qdisc->flags & TCQ_F_NOLOCK) {
- if (!spin_trylock(&qdisc->seqlock))
- return false;
+ spin_lock(&qdisc->seqlock);
  } else if (qdisc_is_running(qdisc)) {
  return false;
  }

I am not actually know what you are discussing above. It seems to me
that Cong's patch is similar as disabling lockless feature.

Anyway, we are going to use fq_codel instead, since CentOS 8/kernel
4.18 also uses fq_codel as the default qdisc, not sure whehter they
found some thing related to this.

Thanks,
Kehuan

Hillf Danton <hdanton@sina.com> =E4=BA=8E2020=E5=B9=B49=E6=9C=883=E6=97=A5=
=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=886:20=E5=86=99=E9=81=93=EF=BC=9A
>
>
> On Thu, 03 Sep 2020 10:39:54 +0200 Paolo Abeni wrote:
> > On Wed, 2020-09-02 at 22:01 -0700, Cong Wang wrote:
> > > Can you test the attached one-line fix? I think we are overthinking,
> > > probably all
> > > we need here is a busy wait.
> >
> > I think that will solve, but I also think that will kill NOLOCK
> > performances due to really increased contention.
> >
> > At this point I fear we could consider reverting the NOLOCK stuff.
> > I personally would hate doing so, but it looks like NOLOCK benefits are
> > outweighed by its issues.
> >
> > Any other opinion more than welcome!
>
> Hi Paolo,
>
> I suspect it's too late to fix the -27% below.
> Surgery to cut NOLOCK seems too early before the fix.
>
> Hillf
>
> >pktgen threads vanilla         patched[II]     delta
> >nr             kpps            kpps            %
> >1              3240            3240            0
> >2              3910            2830            -27%
> >4              5140            5140            0
>
