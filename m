Return-Path: <netdev+bounces-6661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E1B717482
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 957E51C20BDA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 03:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FDC1879;
	Wed, 31 May 2023 03:50:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2F91385
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 03:50:34 +0000 (UTC)
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A3A93
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:50:32 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6af9dcc98f0so4157054a34.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685505032; x=1688097032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeQSMl34qZhCGsb+7RcT49Q0M+b97VQy6FdaAKY2hM8=;
        b=dSuEfqScQjACClFCsC14bBf/reTSsBOgN/9zazNlkKZ//CDU1RDJTi2Q2idJQfA3ul
         2xS48SwfGiX/ue2Bv4giYjCgON+ss6cXLGz2EFhD2o/uDDH/qxHCd+I0Gz62Ra9jlXIS
         fTybKx87teECR9OduE3KKxW3uQJJWwTCJHMw53fvyyX+iJ5ClYfGaleEgxbPKcUO2ZfY
         PHdj09b15mB+2uwnwRA1Y73xKFh434Sj+w0QG/bMdSpXhzejYGruqBU3X0c1ZkNjY3rx
         z5+sfBH62H2vDYZzgUO7q4DvHbSjXTR0AktGQE4B6P0835B0X2z1U0XUQeX3pz1ewVr9
         yt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685505032; x=1688097032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeQSMl34qZhCGsb+7RcT49Q0M+b97VQy6FdaAKY2hM8=;
        b=ELYfZeXb5PiYYlq2K4IlsB6p1b6aBSVv7KKhUhMqmHT7QKwAeKK63NfpExKY+LnO7T
         gqGkHtCQMnDxClR8zIQyNb+sSVg5oheiMXH8e8XMSm2R575q/ImPb55orEgEy6J3x9NJ
         lzXgIHFO7X9PFy9AK3F2fVef/1KFJ2vVYYP+N4T1L7PgGzNI0GozI0134IZ7b+l3304B
         DteYemt7M8bRljdlaNVyg+KEFKlrhDv6OLAecarPegpEdmRp9iyIXKB7etDfLd7PMzD5
         lETZ2+WUy0XJ0xrjDFgSo5KNiSH0s2c6wlWj38ZiARDQ2siPLvEAK8dRZgfB/J5veK9s
         ML6w==
X-Gm-Message-State: AC+VfDyZIH+OWJRkpDoVHm7c9wfLWy958hfTu8W1TA3Y8WJVfq7LyPoC
	i6mZeOEB50QUU5W9tGa41IGzzH6jHS2QGKMNwBjfgO2nLFPFKbq7
X-Google-Smtp-Source: ACHHUZ4DrybPtHmOdYYuKYzsLWC3sjDxdwRKlrGcCnet2XJrb0NCZk3itFJ9bJJAXoo15lFQsdMThdRcfPiXvT02o80=
X-Received: by 2002:a05:6808:4281:b0:394:2868:d51f with SMTP id
 dq1-20020a056808428100b003942868d51fmr2101872oib.4.1685505031898; Tue, 30 May
 2023 20:50:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000>
 <CANn89i+HK5vny8qo89_+4PqZj9rBcGi6sVfSgN4HSpqqoUr6fw@mail.gmail.com>
 <CAL+tcoCW7o-RcQ40NdZKwfcoqn5V9K4kjKpYpiT0E38k7yyc2Q@mail.gmail.com> <CANn89iKopAb_TGWtqHZB40Gs9VW=UfLj+h2za1=Pr8c6+Lcn=Q@mail.gmail.com>
In-Reply-To: <CANn89iKopAb_TGWtqHZB40Gs9VW=UfLj+h2za1=Pr8c6+Lcn=Q@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 31 May 2023 11:49:55 +0800
Message-ID: <CAL+tcoDYZhDkH+oK+7KrmdWA03aY356UPBOGZOnbUiYKZ5q9YQ@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: fix mishandling when the sack compression is deferred
To: Eric Dumazet <edumazet@google.com>
Cc: fuyuanli <fuyuanli@didiglobal.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, toke <toke@toke.dk>, 
	netdev@vger.kernel.org, Weiping Zhang <zhangweiping@didiglobal.com>, 
	Tio Zhang <tiozhang@didiglobal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 10:51=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Tue, May 30, 2023 at 4:32=E2=80=AFPM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > I'm confused. You said in the previous email:
> > "As a bonus, no need to send one patch for net, and another in net-next=
,
> > trying to 'fix' issues that should have been fixed cleanly in a single =
patch."
> >
> > So we added "introducing ICSK_ACK_TIMER flag for sack compression" to
> > fix them on top of the patch you suggested.
> >
> > I can remove the Suggested-by label. For now, I do care about your
> > opinion on the current patch.
> >
> > Well...should I give up introducing that flag and then leave that
> > 'issue' behind? :S
>
> Please let the fix go alone.
>
> Then I will look at your patch, but honestly I fail to see the _reason_ f=
or it.
>
> In case you missed it, tcp_event_ack_sent() calls
> inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);

Hello Eric,

Sorry, I didn't explain that 'issue' well last night. Let me try it once mo=
re:

In the tcp_event_ack_sent(), since we're going to transmit data with
ack header, we should cancel those timers which could start before to
avoid sending useless/redundant acks. Right?

But what if the timer, say, icsk_delack_timer, was triggered before
and had to postpone it in the release cb phrase because currently
socket (in the tcp sending process) has owned its @owned
field(sk->sk_lock.owned =3D=3D 1).

We could avoid sending extra useless ack by removing the
ICSK_ACK_TIMER flag to stop sending an ack in
tcp_delack_timer_handler().

In the current logic, see in the tcp_event_ack_sent():
1) hrtimer_try_to_cancel(&tp->compressed_ack_timer)
2) sk_stop_timer(sk, &icsk->icsk_delack_timer)
Those two statements can prevent the timers from sending a useless ack
but cannot prevent sending a useless ack in the deferred process.

Does it make any sense? Like I said, it's not a bug, but more like an
improvement.

Thanks,
Jason

