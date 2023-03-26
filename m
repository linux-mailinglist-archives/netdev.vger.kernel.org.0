Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE186C95DC
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbjCZO47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjCZO45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:56:57 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C895B95;
        Sun, 26 Mar 2023 07:56:56 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eg48so25763070edb.13;
        Sun, 26 Mar 2023 07:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679842615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9gY3qN/0TbI0QIi8rWv+RCKMQwx1Vl9uKOL6knVa0U=;
        b=Gn3+s7kdMcPDShteR9u+nP+qN5vkLguoYbicJg2JFU/FUiuXHmyKHjKeW3sT6SM+EN
         216oMMdL654WsT+UdJLZcUl43ctdYbAmRObbRePBsA1hir5GMX7hTz34D5IQ69vUY/AZ
         4ur3APia65C2rvcLCq2QJkKEzvurWdzeBSJn4/DgISywrZ8Ml6cPXWHZn3cTRPvI7m0k
         ZSykk4kzsn19zPfDjVawP6MskwIZ9sNoM3ImuGngEFj1dfifInm65traXnzg8S2Xd+7Y
         g/oAaqzfe3cvWOwVKK4aEGtSvCVxT98E+NBD2eHeO656Rliuy07ghEt7/Tj4QfMEeGl6
         oyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679842615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9gY3qN/0TbI0QIi8rWv+RCKMQwx1Vl9uKOL6knVa0U=;
        b=s7es0ESYVS/InlLpwo41E8r+3ayNPM5uLTrVaYuCnY/VB3MZl9nd2z2lz1A3lb/SUt
         CKi5jSC4pPMSRRrbEyUhv7As2IGPmgnc4T0x934UnBmWIX759T0Vw4QifXSPuF046IO3
         rZjLF+wXoTE3hGvlPT2m6E4FA2UsE0NLGdkS1nKJZujyOJt9nqqHagnL//Y52cTE41s1
         HI4qWhOvmBSWz5dIRsnatPW6YjGdUJdbV21ULRz+vouFCMvgesYtvKI4Fcm/ntmCj+YU
         BDAqSkL2mG+TEZlmvX61H7BMbD6ALpSey9Qvcd7Jknuo4Q0QRHyaylv/O197MIbJHY5U
         g1uw==
X-Gm-Message-State: AAQBX9c+Rprq4wUWUC16t5mKXxVtbKJrJam4K9Ljkk+i93/ZKUoL0DP2
        PGYFZOJLV1ZW0EVXbA9oqJJpUEfhs/OOgsJelxk=
X-Google-Smtp-Source: AKy350b5D+CcivAjhuMqpfm72IrnCGNswMlh6TBioWZ6/flZqf1DaxZ7HYiDtUKjLQQlmNxi3H7akQCQ8C5EeHG94kY=
X-Received: by 2002:a17:907:cb86:b0:930:42bd:ef1d with SMTP id
 un6-20020a170907cb8600b0093042bdef1dmr4420205ejc.11.1679842615063; Sun, 26
 Mar 2023 07:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230325152417.5403-1-kerneljasonxing@gmail.com>
 <CANn89iJaVrObJNDC9TrnSUC3XQeo-zfmUXLVrNVcsbRDPuSNtA@mail.gmail.com>
 <CAL+tcoDVCywXXt0Whnx+o0PcULmdms0osJf0qUb0HKvVwuE6oQ@mail.gmail.com> <CAL+tcoCeyqMif1SDUq4MwfV0bBasgQ4LeYuQjPJYDKYLyof=Rw@mail.gmail.com>
In-Reply-To: <CAL+tcoCeyqMif1SDUq4MwfV0bBasgQ4LeYuQjPJYDKYLyof=Rw@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sun, 26 Mar 2023 22:56:18 +0800
Message-ID: <CAL+tcoCFPKpDF+JBN1f74BxDJj9q=9ppoPntnCoT0gT6C0r=PA@mail.gmail.com>
Subject: Re: [PATCH net] net: fix raising a softirq on the current cpu with
 rps enabled
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 6:10=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> On Sun, Mar 26, 2023 at 12:04=E2=80=AFPM Jason Xing <kerneljasonxing@gmai=
l.com> wrote:
> >
> > On Sat, Mar 25, 2023 at 11:57=E2=80=AFPM Eric Dumazet <edumazet@google.=
com> wrote:
> > >
> > > On Sat, Mar 25, 2023 at 8:26=E2=80=AFAM Jason Xing <kerneljasonxing@g=
mail.com> wrote:
> > > >
> > > > From: Jason Xing <kernelxing@tencent.com>
> > > >
> > > > Since we decide to put the skb into a backlog queue of another
> > > > cpu, we should not raise the softirq for the current cpu. When
> > > > to raise a softirq is based on whether we have more data left to
> > > > process later. As to the current cpu, there is no indication of
> > > > more data enqueued, so we do not need this action. After enqueuing
> > > > to another cpu, net_rx_action() function will call ipi and then
> > > > another cpu will raise the softirq as expected.
> > > >
> > > > Also, raising more softirqs which set the corresponding bit field
> > > > can make the IRQ mechanism think we probably need to start ksoftirq=
d
> > > > on the current cpu. Actually it shouldn't happen.
> > > >
> > > > Fixes: 0a9627f2649a ("rps: Receive Packet Steering")
> > > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > > ---
> > > >  net/core/dev.c | 2 --
> > > >  1 file changed, 2 deletions(-)
> > > >
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index 1518a366783b..bfaaa652f50c 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -4594,8 +4594,6 @@ static int napi_schedule_rps(struct softnet_d=
ata *sd)
> > > >         if (sd !=3D mysd) {
> > > >                 sd->rps_ipi_next =3D mysd->rps_ipi_list;
> > > >                 mysd->rps_ipi_list =3D sd;
> > > > -
> > > > -               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > > >                 return 1;
> > > >         }
> > > >  #endif /* CONFIG_RPS */
> > > > --
> > > > 2.37.3
> > > >
> > >
> > > This is not going to work in some cases. Please take a deeper look.
> > >
> > > I have to run, if you (or others) do not find the reason, I will give
> > > more details when I am done traveling.
> >
> > I'm wondering whether we could use @mysd instead of @sd like this:
> >
> > if (!__test_and_set_bit(NAPI_STATE_SCHED, &mysd->backlog.state))
> >     __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>
> Ah, I have to add more precise code because the above codes may mislead p=
eople.
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1518a366783b..9ac9b32e392f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4594,8 +4594,9 @@ static int napi_schedule_rps(struct softnet_data *s=
d)
>         if (sd !=3D mysd) {
>                 sd->rps_ipi_next =3D mysd->rps_ipi_list;
>                 mysd->rps_ipi_list =3D sd;
> +               if (!__test_and_set_bit(NAPI_STATE_SCHED, &mysd->backlog.=
state))

Forgive me. Really I need some coffee. I made a mistake. This line
above should be:

+               if (!test_bit(NAPI_STATE_SCHED, &mysd->backlog.state))

But the whole thing doesn't feel right. I need a few days to dig into
this part until Eric can help me with more of it.

Thanks,
Jason

> +                       __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>
> -               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>                 return 1;
>         }
>  #endif /* CONFIG_RPS */
>
> Eric, I realized that some paths don't call the ipi to notify another
> cpu. If someone grabs the NAPI_STATE_SCHED flag, we know that at the
> end of net_rx_action() or the beginning of process_backlog(), the
> net_rps_action_and_irq_enable() will handle the information delivery.
> However, if no one grabs the flag, in some paths we could not have a
> chance immediately to tell another cpu to raise the softirq and then
> process those pending data. Thus, I have to make sure if someone owns
> the napi poll as shown above.
>
> If I get this wrong, please correct me if you're available. Thanks in adv=
ance.
>
> >
> > I traced back to some historical changes and saw some relations with
> > this commit ("net: solve a NAPI race"):
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D39e6c8208d7b6fb9d2047850fb3327db567b564b
> >
> > Thanks,
> > Jason
