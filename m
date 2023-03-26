Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3D56C93B2
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 12:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjCZKKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 06:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCZKKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 06:10:41 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECABC83E4;
        Sun, 26 Mar 2023 03:10:39 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ek18so24479775edb.6;
        Sun, 26 Mar 2023 03:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679825438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44FjUDYM2l/hnTk2ARAIkT7XpeiTLM47QeD1JdG1Tfw=;
        b=duJqAtETDF5nByrxWWhSZo2FKGV+5YJIRStzbiOwRhKYtkI0HQ0avpY/7U5wbYjmqE
         k3B02iC2Yv4LiVt2noA/YDcYm5TxqMtDeKGHSLMwOhJfeockwvf7IDvwb9poIKGyubJ0
         5zCYhiOn/3ZVa6QXMVTwfyGmczWYnWTFUBeoDO5m6uQdEx3kpjbMK1RvuGuJ+T60EFmt
         m5gtBV8YIcY+HMisTmMxB7/24oKrFx2fSb5hghbPQ6UYeBVXZtiNBzHZZZnOViwa/9Ft
         nw8ch7aJlku4SAPFcBpD9GHk9/630nfblb7QPGzdmw6M3Z5kdUgCk56fprZ+vdA+IT+d
         G6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679825438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=44FjUDYM2l/hnTk2ARAIkT7XpeiTLM47QeD1JdG1Tfw=;
        b=vtvkZYe6fPxPdoox9lFj0ZMet1fPafb5Z2RTwDUQeQySCnP6iQR7MJ0wNkx2lvwQ/6
         YGslzxwnX9Dsef8XsUHUfJS7l3SX3CsmwG1StjCQX1K9JVEZcaSIERhehU8yvG8vJXIS
         /w/QOL8/Q/tor361Lso4/PAMHNX/GudAuymeOFa65EB2gmpBJc0cHBhtsrvSqQVZqYbX
         w5EVkvp1nYkShXeIyJQ49xcBkDfUh/j+zvFD+r08ryr/O1YCpD/nMJqPywP4lfNvc3rs
         ns2Zemq6YAYAi8IEixohWKzjo/FGdFQEEKpFJl9j0l4j5O4GEbJDbzxroiAF8OJ7Upav
         oJKQ==
X-Gm-Message-State: AAQBX9cJSfedJNCA66QltWzDgXR9jA9Ty9QhwWE7+5haRc8chKW9j26P
        p6W2uqJe3BFO2fMJDIr+oeafuOiJsvXrVw6tQuA=
X-Google-Smtp-Source: AKy350bop1lMFf9FnEfEfqJnHnp6iri08z/Z2sUGsU4ZQ+4SDDytnEvf0jo+5v/gFKFQGFFxcAvCpwmSh4AXiZvN+mY=
X-Received: by 2002:a17:906:eda6:b0:8dd:70a:3a76 with SMTP id
 sa6-20020a170906eda600b008dd070a3a76mr4191168ejb.11.1679825438367; Sun, 26
 Mar 2023 03:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230325152417.5403-1-kerneljasonxing@gmail.com>
 <CANn89iJaVrObJNDC9TrnSUC3XQeo-zfmUXLVrNVcsbRDPuSNtA@mail.gmail.com> <CAL+tcoDVCywXXt0Whnx+o0PcULmdms0osJf0qUb0HKvVwuE6oQ@mail.gmail.com>
In-Reply-To: <CAL+tcoDVCywXXt0Whnx+o0PcULmdms0osJf0qUb0HKvVwuE6oQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sun, 26 Mar 2023 18:10:02 +0800
Message-ID: <CAL+tcoCeyqMif1SDUq4MwfV0bBasgQ4LeYuQjPJYDKYLyof=Rw@mail.gmail.com>
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

On Sun, Mar 26, 2023 at 12:04=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.=
com> wrote:
>
> On Sat, Mar 25, 2023 at 11:57=E2=80=AFPM Eric Dumazet <edumazet@google.co=
m> wrote:
> >
> > On Sat, Mar 25, 2023 at 8:26=E2=80=AFAM Jason Xing <kerneljasonxing@gma=
il.com> wrote:
> > >
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > Since we decide to put the skb into a backlog queue of another
> > > cpu, we should not raise the softirq for the current cpu. When
> > > to raise a softirq is based on whether we have more data left to
> > > process later. As to the current cpu, there is no indication of
> > > more data enqueued, so we do not need this action. After enqueuing
> > > to another cpu, net_rx_action() function will call ipi and then
> > > another cpu will raise the softirq as expected.
> > >
> > > Also, raising more softirqs which set the corresponding bit field
> > > can make the IRQ mechanism think we probably need to start ksoftirqd
> > > on the current cpu. Actually it shouldn't happen.
> > >
> > > Fixes: 0a9627f2649a ("rps: Receive Packet Steering")
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > ---
> > >  net/core/dev.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > >
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 1518a366783b..bfaaa652f50c 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -4594,8 +4594,6 @@ static int napi_schedule_rps(struct softnet_dat=
a *sd)
> > >         if (sd !=3D mysd) {
> > >                 sd->rps_ipi_next =3D mysd->rps_ipi_list;
> > >                 mysd->rps_ipi_list =3D sd;
> > > -
> > > -               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > >                 return 1;
> > >         }
> > >  #endif /* CONFIG_RPS */
> > > --
> > > 2.37.3
> > >
> >
> > This is not going to work in some cases. Please take a deeper look.
> >
> > I have to run, if you (or others) do not find the reason, I will give
> > more details when I am done traveling.
>
> I'm wondering whether we could use @mysd instead of @sd like this:
>
> if (!__test_and_set_bit(NAPI_STATE_SCHED, &mysd->backlog.state))
>     __raise_softirq_irqoff(NET_RX_SOFTIRQ);

Ah, I have to add more precise code because the above codes may mislead peo=
ple.

diff --git a/net/core/dev.c b/net/core/dev.c
index 1518a366783b..9ac9b32e392f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4594,8 +4594,9 @@ static int napi_schedule_rps(struct softnet_data *sd)
        if (sd !=3D mysd) {
                sd->rps_ipi_next =3D mysd->rps_ipi_list;
                mysd->rps_ipi_list =3D sd;
+               if (!__test_and_set_bit(NAPI_STATE_SCHED, &mysd->backlog.st=
ate))
+                       __raise_softirq_irqoff(NET_RX_SOFTIRQ);

-               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
                return 1;
        }
 #endif /* CONFIG_RPS */

Eric, I realized that some paths don't call the ipi to notify another
cpu. If someone grabs the NAPI_STATE_SCHED flag, we know that at the
end of net_rx_action() or the beginning of process_backlog(), the
net_rps_action_and_irq_enable() will handle the information delivery.
However, if no one grabs the flag, in some paths we could not have a
chance immediately to tell another cpu to raise the softirq and then
process those pending data. Thus, I have to make sure if someone owns
the napi poll as shown above.

If I get this wrong, please correct me if you're available. Thanks in advan=
ce.

>
> I traced back to some historical changes and saw some relations with
> this commit ("net: solve a NAPI race"):
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D39e6c8208d7b6fb9d2047850fb3327db567b564b
>
> Thanks,
> Jason
