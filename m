Return-Path: <netdev+bounces-6670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 281DC71763D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D816428131E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E8B2113;
	Wed, 31 May 2023 05:32:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1955D186C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:32:38 +0000 (UTC)
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D0A11B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:32:32 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-555536b85a0so2669819eaf.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685511152; x=1688103152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UzD0ZRhLNfuPDroNRE+8ZYwDGYrkY108VvKhdjU7fgw=;
        b=qbOzRZWkiYVootH7mOe/uYBaBtMeTAVjG1DjzuCQ+h6cZ5myXzLSPi5GaaRYNPW+YD
         klK3fSUgGQXdiWse16gZFeLQP2WZdsoWjAeFhG7Vi6Ohyp+gvLAWY73Mwi3OmS5KM+cM
         y4hn/VXt/I6BNIIwQSuiiAwgrVs0N5/oXJr/aN+GEcqLrwi6fQHv8P5UoMICTK+NInVb
         YIvBJCe3ZMN/MQgRYMFlBtrfx4K03A2yN9UL0PtSXrKfSKnox3/N6pv5DCLOg5Wg4t9K
         dwuTWEZU6E9HvM+PHpayqj74nLS7u5FCwdYTyEfjRbTeVMGm0lA67+RQjtqHr01meph6
         twiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685511152; x=1688103152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UzD0ZRhLNfuPDroNRE+8ZYwDGYrkY108VvKhdjU7fgw=;
        b=G+Ufg19zXzR3dxXTBYZXLE7JYu3xeL22EZCsjOB1R0ycGubssb2fX0L42QtA3MyTkc
         jmWviCAATtSl71gGIdCld4xRk0SJWrQE84y4Pb/Vd1RbyaCFixVmvoU4VDdtOOLckgMx
         vsZKNaBD16t/wKsXeINu0u7FIwRQjbJAzoZmIyxdQcQtZoDqmhhCozYy/57t66sVmpm+
         kA2IVXqNimSfyuj/NM9CffhmrjRxYLR1M6LruSwz51BrGCHTrkd+VOGCP8A0oyOja8jg
         4M2+/nSCCivBDHRQKE1TJgc//7ec2RLQWDVOjn/iYupzJ0J9IgHOkPDEpg8q1cDv9hDy
         IRew==
X-Gm-Message-State: AC+VfDwuMPkPBs/ufb7EAHsrid8Ynq0qR2dkRF7VSGfPGkofm9VJnDxy
	h43q4OCOmhPHf3gRqePAEFx8eP0Z8ctiU96edO0=
X-Google-Smtp-Source: ACHHUZ47d8QQK5IuESRSfca4fn4AewbBnCREQFVeygXNAzY8zGcHRY0eCsaLtzz+LigJ5O5xia9eHedE+SAyREvbFdY=
X-Received: by 2002:a05:6808:3092:b0:398:2c02:20a2 with SMTP id
 bl18-20020a056808309200b003982c0220a2mr3077916oib.17.1685511152250; Tue, 30
 May 2023 22:32:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000>
 <CANn89i+HK5vny8qo89_+4PqZj9rBcGi6sVfSgN4HSpqqoUr6fw@mail.gmail.com>
 <CAL+tcoCW7o-RcQ40NdZKwfcoqn5V9K4kjKpYpiT0E38k7yyc2Q@mail.gmail.com>
 <CANn89iKopAb_TGWtqHZB40Gs9VW=UfLj+h2za1=Pr8c6+Lcn=Q@mail.gmail.com>
 <CAL+tcoDYZhDkH+oK+7KrmdWA03aY356UPBOGZOnbUiYKZ5q9YQ@mail.gmail.com> <CANn89iLtzzqHhFtq196AnAer6YoUjQKxHz2_zsqbiavnZAqUjQ@mail.gmail.com>
In-Reply-To: <CANn89iLtzzqHhFtq196AnAer6YoUjQKxHz2_zsqbiavnZAqUjQ@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 31 May 2023 13:31:55 +0800
Message-ID: <CAL+tcoD0hXzymHyGJm2Rfk1hnVieFiAP5SY_WqdwE++APkskFA@mail.gmail.com>
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

On Wed, May 31, 2023 at 12:13=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Wed, May 31, 2023 at 5:50=E2=80=AFAM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > On Tue, May 30, 2023 at 10:51=E2=80=AFPM Eric Dumazet <edumazet@google.=
com> wrote:
> > >
> > > On Tue, May 30, 2023 at 4:32=E2=80=AFPM Jason Xing <kerneljasonxing@g=
mail.com> wrote:
> > > >
> > > > I'm confused. You said in the previous email:
> > > > "As a bonus, no need to send one patch for net, and another in net-=
next,
> > > > trying to 'fix' issues that should have been fixed cleanly in a sin=
gle patch."
> > > >
> > > > So we added "introducing ICSK_ACK_TIMER flag for sack compression" =
to
> > > > fix them on top of the patch you suggested.
> > > >
> > > > I can remove the Suggested-by label. For now, I do care about your
> > > > opinion on the current patch.
> > > >
> > > > Well...should I give up introducing that flag and then leave that
> > > > 'issue' behind? :S
> > >
> > > Please let the fix go alone.
> > >
> > > Then I will look at your patch, but honestly I fail to see the _reaso=
n_ for it.
> > >
> > > In case you missed it, tcp_event_ack_sent() calls
> > > inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);
> >
> > Hello Eric,
> >
> > Sorry, I didn't explain that 'issue' well last night. Let me try it onc=
e more:
> >
> > In the tcp_event_ack_sent(), since we're going to transmit data with
> > ack header, we should cancel those timers which could start before to
> > avoid sending useless/redundant acks. Right?
> >
> > But what if the timer, say, icsk_delack_timer, was triggered before
> > and had to postpone it in the release cb phrase because currently
> > socket (in the tcp sending process) has owned its @owned
> > field(sk->sk_lock.owned =3D=3D 1).
> >
> > We could avoid sending extra useless ack by removing the
> > ICSK_ACK_TIMER flag to stop sending an ack in
> > tcp_delack_timer_handler().
> >
> > In the current logic, see in the tcp_event_ack_sent():
> > 1) hrtimer_try_to_cancel(&tp->compressed_ack_timer)
> > 2) sk_stop_timer(sk, &icsk->icsk_delack_timer)
> > Those two statements can prevent the timers from sending a useless ack
> > but cannot prevent sending a useless ack in the deferred process.
> >
> > Does it make any sense? Like I said, it's not a bug, but more like an
> > improvement.
>
> Your patch adds a bug. An skb allocation can fail, and ACK would not be s=
ent.
>
> Timer handlers are not canceled in TCP stack.
> We do not call sk_stop_timer() because include/net/inet_connection_sock.h=
 says
>
> /* Cancel timers, when they are not required. */
> #undef INET_CSK_CLEAR_TIMERS
>
> So claiming the following is nonsense:
>
> <quote>
>  2) sk_stop_timer(sk, &icsk->icsk_delack_timer)
> Those two statements can prevent ...
> </quote>
>

[...]
> We do not send extra ACK, because icsk->icsk_ack.pending (or icsk->icsk_p=
ending)
> is cleared in inet_csk_clear_xmit_timer()

You're right about this. Thanks for your kind explanation. I missed
this key point again :(

It is a really happy ending cause I only need to focus on the v3
patch. Please help us review that patch if you're available (no rush)
:)

Thanks,
Jason

>
> This clearing is happening already at strategic places.
>
> When tcp_delack_timer_handler() is finally run (when owning socket lock),
> it will return early if icsk->icsk_ack.pending was already cleared.
>
> hrtimer_try_to_cancel(&tp->compressed_ack_timer) has to be called because
> we rely on the hrtimer status (hrtimer_is_queued()) in __tcp_ack_snd_chec=
k()

