Return-Path: <netdev+bounces-6662-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BBA97174F3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 938511C20BE4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 04:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E2661C3B;
	Wed, 31 May 2023 04:13:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332E31C3A
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:13:18 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFE3C9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:13:16 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so22655e9.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685506395; x=1688098395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNiVbhw2xteDmaBVNbo9V7vHcBdQgfi6uIpgzZWQpf4=;
        b=7j4dhSONYGCjyATDr0O4qYYnh6f3mK1LNG7jg1t5ntATwW0UBCK+LVDfwZ8mteZICz
         tOG1YmFAZWZuXgyyVKalB9WelhZhM1dMHWBcNuOLeH5VN4uGhxm/D5KAVXHxcX10KPRZ
         UTALj98bFHnRM+GQj/fKGMBbZ7lgxz4f9X4ldoBBqeq0Huzu87QfLLhIft8OlJL25i4x
         WnUNn8lHCoZ6fGDuZLeRx24pZcYt9gKRsLShXZkoIZ6NDLu01u0MHd1bGpjROG8jOYNp
         thRWKYayeoTbv4ceehMwCzc8OBJIyNbsfKwAoHt8MsiDkleCCQykHsJBgrjP+0lYLEV7
         GQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685506395; x=1688098395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fNiVbhw2xteDmaBVNbo9V7vHcBdQgfi6uIpgzZWQpf4=;
        b=CfQH/M6Wfu46eGlWmpE/iISpDhuyqfUzJrUUIbz8cnEJIGOykkbQhGkr46550NQmS0
         jcInrgyEKtLbOx6nRAQYN9Kj6IVQ1Npji4K10O8QmUF6v9CX2VOGyfip/JpwFQBBjuFS
         TnJ2Wuyy2t2fl1yVCaZbM+FMp31x12+t1crpIJ9r7t2hplvMwyCLt/VtHLy5p9pESyP7
         O+s3pS68nbNZZ9Ame3lrzg4Fo1wN7YH0N0YtJohOn36Szd/oJfKYzH7Jx2XT9ZdnVH9s
         rqrxYPBMVpx7BPnZD6GB5qnfa6aQkCs2BrLZ0ZPnZbrNvsBl0evocxOX5TngMmNxcADE
         4f8A==
X-Gm-Message-State: AC+VfDymtPenXX3AAJEtxZrpbUsMqzsz7I+avQ52/Dc3C3KHDinHO/QJ
	c9K/BRAYxIzNMeE411oGJ5DVm/NfzAC2daEROzARAw==
X-Google-Smtp-Source: ACHHUZ7+M7FrfeigGoVHR6fs2o/cqDBznLrlfl9JQycrT6xEt9DYky9ogckq1LoVyvgox3hKKy4wkKuvoURKfxZyoFI=
X-Received: by 2002:a05:600c:310f:b0:3f1:6fe9:4a95 with SMTP id
 g15-20020a05600c310f00b003f16fe94a95mr93649wmo.4.1685506394739; Tue, 30 May
 2023 21:13:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000>
 <CANn89i+HK5vny8qo89_+4PqZj9rBcGi6sVfSgN4HSpqqoUr6fw@mail.gmail.com>
 <CAL+tcoCW7o-RcQ40NdZKwfcoqn5V9K4kjKpYpiT0E38k7yyc2Q@mail.gmail.com>
 <CANn89iKopAb_TGWtqHZB40Gs9VW=UfLj+h2za1=Pr8c6+Lcn=Q@mail.gmail.com> <CAL+tcoDYZhDkH+oK+7KrmdWA03aY356UPBOGZOnbUiYKZ5q9YQ@mail.gmail.com>
In-Reply-To: <CAL+tcoDYZhDkH+oK+7KrmdWA03aY356UPBOGZOnbUiYKZ5q9YQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 06:13:02 +0200
Message-ID: <CANn89iLtzzqHhFtq196AnAer6YoUjQKxHz2_zsqbiavnZAqUjQ@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: fix mishandling when the sack compression is deferred
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: fuyuanli <fuyuanli@didiglobal.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, toke <toke@toke.dk>, 
	netdev@vger.kernel.org, Weiping Zhang <zhangweiping@didiglobal.com>, 
	Tio Zhang <tiozhang@didiglobal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 5:50=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> On Tue, May 30, 2023 at 10:51=E2=80=AFPM Eric Dumazet <edumazet@google.co=
m> wrote:
> >
> > On Tue, May 30, 2023 at 4:32=E2=80=AFPM Jason Xing <kerneljasonxing@gma=
il.com> wrote:
> > >
> > > I'm confused. You said in the previous email:
> > > "As a bonus, no need to send one patch for net, and another in net-ne=
xt,
> > > trying to 'fix' issues that should have been fixed cleanly in a singl=
e patch."
> > >
> > > So we added "introducing ICSK_ACK_TIMER flag for sack compression" to
> > > fix them on top of the patch you suggested.
> > >
> > > I can remove the Suggested-by label. For now, I do care about your
> > > opinion on the current patch.
> > >
> > > Well...should I give up introducing that flag and then leave that
> > > 'issue' behind? :S
> >
> > Please let the fix go alone.
> >
> > Then I will look at your patch, but honestly I fail to see the _reason_=
 for it.
> >
> > In case you missed it, tcp_event_ack_sent() calls
> > inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);
>
> Hello Eric,
>
> Sorry, I didn't explain that 'issue' well last night. Let me try it once =
more:
>
> In the tcp_event_ack_sent(), since we're going to transmit data with
> ack header, we should cancel those timers which could start before to
> avoid sending useless/redundant acks. Right?
>
> But what if the timer, say, icsk_delack_timer, was triggered before
> and had to postpone it in the release cb phrase because currently
> socket (in the tcp sending process) has owned its @owned
> field(sk->sk_lock.owned =3D=3D 1).
>
> We could avoid sending extra useless ack by removing the
> ICSK_ACK_TIMER flag to stop sending an ack in
> tcp_delack_timer_handler().
>
> In the current logic, see in the tcp_event_ack_sent():
> 1) hrtimer_try_to_cancel(&tp->compressed_ack_timer)
> 2) sk_stop_timer(sk, &icsk->icsk_delack_timer)
> Those two statements can prevent the timers from sending a useless ack
> but cannot prevent sending a useless ack in the deferred process.
>
> Does it make any sense? Like I said, it's not a bug, but more like an
> improvement.

Your patch adds a bug. An skb allocation can fail, and ACK would not be sen=
t.

Timer handlers are not canceled in TCP stack.
We do not call sk_stop_timer() because include/net/inet_connection_sock.h s=
ays

/* Cancel timers, when they are not required. */
#undef INET_CSK_CLEAR_TIMERS

So claiming the following is nonsense:

<quote>
 2) sk_stop_timer(sk, &icsk->icsk_delack_timer)
Those two statements can prevent ...
</quote>

We do not send extra ACK, because icsk->icsk_ack.pending (or icsk->icsk_pen=
ding)
is cleared in inet_csk_clear_xmit_timer()

This clearing is happening already at strategic places.

When tcp_delack_timer_handler() is finally run (when owning socket lock),
it will return early if icsk->icsk_ack.pending was already cleared.

hrtimer_try_to_cancel(&tp->compressed_ack_timer) has to be called because
we rely on the hrtimer status (hrtimer_is_queued()) in __tcp_ack_snd_check(=
)

