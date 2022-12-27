Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED30C65695B
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 11:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiL0KWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 05:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiL0KWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 05:22:50 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239FD9FD7
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 02:22:48 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id r3so5884581vkq.13
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 02:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5/0JksOM2lGuEYSzF1Qu3MnIOgzw58Ul9AktACBNVI=;
        b=NoTyXYNTcm9i+GC7/+I09XJcPjGPm2toisrvYx3dF44c57grwNAzYz5vVRbhRnJA9S
         B34KZz4oVKrZN6wpBQ+QnVG35XqSCtcpouGuyB3/fUIXDDIpvt2o1dete8IQ4jhB2VK4
         pTiaILZwM41NBdToO6kueGNZ1CXaHt5GRY3XI59BNUIdJR6mN615Mf+88Gmm6QxHb95p
         U2SNRsXu3eqo5n5Smjbcca054NvBvgIuwPw6R1Xds9lzkojAc2OLtCvD9hN5aBTgkIPV
         WpOHVwYJ4HgifzdLK3a+ewkHHdUb5DUt4wNyHa5aVn0xUqXEJ4EnpoZHjRQsUqZ3yip/
         TFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5/0JksOM2lGuEYSzF1Qu3MnIOgzw58Ul9AktACBNVI=;
        b=ddUPJ3XIkqIWZGzLs3Ao5WA39tptvLaK4yA18DDcnN3aA4rvuESq7uf4rw2njpp+0H
         X2bfSrC5sRi6aIRvcW84F6U0yZpHEDapgRmtXSQwq5KWa955A2hVgRiaSIszYjAOW+/j
         n/8AMbj2CT4P2tgSovcBX3Ii6XP35Z0UV/+CyJx7+Xyl8bnSEATt2HCkD5k0Uj53SY87
         3vFbxecRDtt7DSmB7OlopI1lnJg4hM/4dbQwRryZjrPr6Crp8OpdJhPJvsR4c+Mx745r
         W36OPTTn13JiYEQ3sc/hqpzHx4vGvHG4Z7qH4L2XM4eUpTsTOeqIs3pWwgoB4wJO24gl
         vmtg==
X-Gm-Message-State: AFqh2kpG6zuNapStwbA5BWjba4s8YLosRHY6/rNPJkzc4EAPALMrCXWG
        pm2dxQ0lYD7RMSM9RXjbsQrN5/+1srDKcB9hCBpdQQ==
X-Google-Smtp-Source: AMrXdXuBs2JliWerOZZXmJNVHzg/xf71Hb0VEHnA0XGAF1ihq/iN1gmrkZTToN9EzxIyzAeEgwTxu37dmgcPKXEXKFI=
X-Received: by 2002:a1f:2016:0:b0:3d5:53d8:aa10 with SMTP id
 g22-20020a1f2016000000b003d553d8aa10mr872944vkg.21.1672136567160; Tue, 27 Dec
 2022 02:22:47 -0800 (PST)
MIME-Version: 1.0
References: <20221227022528.609839-1-mie@igel.co.jp> <20221227022528.609839-5-mie@igel.co.jp>
 <20221227020007-mutt-send-email-mst@kernel.org> <CANXvt5pRy-i7=_ikNkZPp2HcRmWZYNJYpjO_ieBJJVc90nds+A@mail.gmail.com>
In-Reply-To: <CANXvt5pRy-i7=_ikNkZPp2HcRmWZYNJYpjO_ieBJJVc90nds+A@mail.gmail.com>
From:   Shunsuke Mie <mie@igel.co.jp>
Date:   Tue, 27 Dec 2022 19:22:36 +0900
Message-ID: <CANXvt5qUUOqB1CVgAk5KyL9sV+NsnJSKhatvdV12jH5=kBjjJw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/9] vringh: unify the APIs for all accessors
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=E5=B9=B412=E6=9C=8827=E6=97=A5(=E7=81=AB) 16:49 Shunsuke Mie <mie@igel=
.co.jp>:
>
> 2022=E5=B9=B412=E6=9C=8827=E6=97=A5(=E7=81=AB) 16:04 Michael S. Tsirkin <=
mst@redhat.com>:
> >
> > On Tue, Dec 27, 2022 at 11:25:26AM +0900, Shunsuke Mie wrote:
> > > Each vringh memory accessors that are for user, kern and iotlb has ow=
n
> > > interfaces that calls common code. But some codes are duplicated and =
that
> > > becomes loss extendability.
> > >
> > > Introduce a struct vringh_ops and provide a common APIs for all acces=
sors.
> > > It can bee easily extended vringh code for new memory accessor and
> > > simplified a caller code.
> > >
> > > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> > > ---
> > >  drivers/vhost/vringh.c | 667 +++++++++++----------------------------=
--
> > >  include/linux/vringh.h | 100 +++---
> > >  2 files changed, 225 insertions(+), 542 deletions(-)
> > >
> > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > index aa3cd27d2384..ebfd3644a1a3 100644
> > > --- a/drivers/vhost/vringh.c
> > > +++ b/drivers/vhost/vringh.c
> > > @@ -35,15 +35,12 @@ static __printf(1,2) __cold void vringh_bad(const=
 char *fmt, ...)
> > >  }
> > >
> > >  /* Returns vring->num if empty, -ve on error. */
> > > -static inline int __vringh_get_head(const struct vringh *vrh,
> > > -                                 int (*getu16)(const struct vringh *=
vrh,
> > > -                                               u16 *val, const __vir=
tio16 *p),
> > > -                                 u16 *last_avail_idx)
> > > +static inline int __vringh_get_head(const struct vringh *vrh, u16 *l=
ast_avail_idx)
> > >  {
> > >       u16 avail_idx, i, head;
> > >       int err;
> > >
> > > -     err =3D getu16(vrh, &avail_idx, &vrh->vring.avail->idx);
> > > +     err =3D vrh->ops.getu16(vrh, &avail_idx, &vrh->vring.avail->idx=
);
> > >       if (err) {
> > >               vringh_bad("Failed to access avail idx at %p",
> > >                          &vrh->vring.avail->idx);
> >
> > I like that this patch removes more lines of code than it adds.
> >
> > However one of the design points of vringh abstractions is that they we=
re
> > carefully written to be very low overhead.
> > This is why we are passing function pointers to inline functions -
> > compiler can optimize that out.
> >
> > I think that introducing ops indirect functions calls here is going to =
break
> > these assumptions and hurt performance.
> > Unless compiler can somehow figure it out and optimize?
> > I don't see how it's possible with ops pointer in memory
> > but maybe I'm wrong.
> I think your concern is correct. I have to understand the compiler
> optimization and redesign this approach If it is needed.
> > Was any effort taken to test effect of these patches on performance?
> I just tested vringh_test and already faced little performance reduction.
> I have to investigate that, as you said.
I attempted to test with perf. I found that the performance of patched code
is almost the same as the upstream one. However, I have to investigate way
this patch leads to this result, also the profiling should be run on
more powerful
machines too.

environment:
$ grep 'model name' /proc/cpuinfo
model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz
model name      : Intel(R) Core(TM) i3-7020U CPU @ 2.30GHz

results:
* for patched code
 Performance counter stats for 'nice -n -20 ./vringh_test_patched
--parallel --eventidx --fast-vringh --indirect --virtio-1' (20 runs):

          3,028.05 msec task-clock                #    0.995 CPUs
utilized            ( +-  0.12% )
            78,150      context-switches          #   25.691 K/sec
               ( +-  0.00% )
                 5      cpu-migrations            #    1.644 /sec
               ( +-  3.33% )
               190      page-faults               #   62.461 /sec
               ( +-  0.41% )
     6,919,025,222      cycles                    #    2.275 GHz
               ( +-  0.13% )
     8,990,220,160      instructions              #    1.29  insn per
cycle           ( +-  0.04% )
     1,788,326,786      branches                  #  587.899 M/sec
               ( +-  0.05% )
         4,557,398      branch-misses             #    0.25% of all
branches          ( +-  0.43% )

           3.04359 +- 0.00378 seconds time elapsed  ( +-  0.12% )

* for upstream code
 Performance counter stats for 'nice -n -20 ./vringh_test_base
--parallel --eventidx --fast-vringh --indirect --virtio-1' (10 runs):

          3,058.41 msec task-clock                #    0.999 CPUs
utilized            ( +-  0.14% )
            78,149      context-switches          #   25.545 K/sec
               ( +-  0.00% )
                 5      cpu-migrations            #    1.634 /sec
               ( +-  2.67% )
               194      page-faults               #   63.414 /sec
               ( +-  0.43% )
     6,988,713,963      cycles                    #    2.284 GHz
               ( +-  0.14% )
     8,512,533,269      instructions              #    1.22  insn per
cycle           ( +-  0.04% )
     1,638,375,371      branches                  #  535.549 M/sec
               ( +-  0.05% )
         4,428,866      branch-misses             #    0.27% of all
branches          ( +- 22.57% )

           3.06085 +- 0.00420 seconds time elapsed  ( +-  0.14% )

> Thank you for your comments.
> > Thanks!
> >
> >
> Best,
> Shunsuke.
