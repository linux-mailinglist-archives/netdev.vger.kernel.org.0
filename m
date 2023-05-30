Return-Path: <netdev+bounces-6380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A76716094
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64CBC281110
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB9F19E5B;
	Tue, 30 May 2023 12:53:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DFE1993C;
	Tue, 30 May 2023 12:53:32 +0000 (UTC)
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E52E63;
	Tue, 30 May 2023 05:53:09 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-38c35975545so2970825b6e.1;
        Tue, 30 May 2023 05:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685451187; x=1688043187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gy495w7hzc4hUmERgvqWVDar3q/n3sqHlrrfq6GjSMM=;
        b=J1bSSI3zdsG+GproejU5oGsL8pfinLIMzoVp7nBY0PJTRT7UIBfX2mt7gjZGiVep0/
         j7H3Cb8c8b0Mn9Rxx0ca/5Rv7hYPnPLBI+HyNFvRVKjd+eWHPoJX/kH2xIGzKjui0Ndh
         m8hptRO79Y7YtzrLkwTDV9bN+ogO9oifJhc8piO9R2BjXVCRIA+qZKBEt+aZ23hIqOxI
         HWV5/HG/5ZmSHQcdtB9xNLj8BhK0hJ4WHGQvd/g/IpSTn9+U0MRTU5NphX57vSS5RmoR
         klFGhE9k9mqoAudreOQwXxEkmfG4tlyN6ilJbGmIa7/Xg2PE/iuHWfTLKtoMulSVdUZQ
         P/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685451187; x=1688043187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gy495w7hzc4hUmERgvqWVDar3q/n3sqHlrrfq6GjSMM=;
        b=mE5cNP6g/8JG4lZ59vOcPba25vbWiE5sRgYyRbfw/oHyoFHmR5QXzr+oQ6mKEYlKEZ
         5/uDSMkhzUXA4CAgCs61ZBb7Dc71jJxn/dScinX5MOTfnULnEK4jPrNkWy8M5drqjnLd
         nZ4jtsMNNVJKP3O60v5KfPSMVcMROyCcClt/UYJ3druznqdvsAIjnRVr9ikdq1cwUW/3
         7jPNAzyPQrwo78N7Uo13pZKTYK/nsx5qE3PKXy5WhZh0MLi8vFA9oZIHsjLvMSt7Wx+6
         tcU88V+0MbaoGb+pduN9wuKLPgjvkKMiR7SHH9WzLIaQxIcb8333aU3AVA3upARGXmuS
         LDGQ==
X-Gm-Message-State: AC+VfDw3wW6wCMH8GxWfMPeTG7E3UAN9NdgLHyTT6r+P5pd3i7fMgqRR
	9mdcoGFB0uY5tNX2jM7gL6v4f/V/1DccoxY3BMppcshCEF4pEAxE
X-Google-Smtp-Source: ACHHUZ5MLuVOLOBdZC/hUgmFSmbsAx3WDPWQkF6Q8rL9efe7+4W7bj9s+NQsSfUFjJyTfYy64mv1z9WQHSzjLZQf/5I=
X-Received: by 2002:a05:6808:305:b0:398:2f92:65ca with SMTP id
 i5-20020a056808030500b003982f9265camr1244771oie.7.1685451186841; Tue, 30 May
 2023 05:53:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529113804.GA20300@didi-ThinkCentre-M920t-N000>
 <CANn89iJw3Ehoj7GfYnc6Xv5N2wULqNuP3zNBwQx97i-YJD5avg@mail.gmail.com>
 <CAL+tcoCRgpoYgQXdM2Es0gjRtRZj1hCK-5M04WZ1sy3vt_5JjA@mail.gmail.com>
 <CANn89iKCKTg0ExMRAxXWK200Q6UX2DeuUQzZzbZevt5kST7qQA@mail.gmail.com> <CAL+tcoDd5M0=SzDVcuFnu_ntC7HASq9rrS_pZ5FXNyMa2aQrHQ@mail.gmail.com>
In-Reply-To: <CAL+tcoDd5M0=SzDVcuFnu_ntC7HASq9rrS_pZ5FXNyMa2aQrHQ@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 30 May 2023 20:52:30 +0800
Message-ID: <CAL+tcoBYvV58rz9KcrH5QTdc1jPi=H1VXt1yUj-pYwA1FE9CEg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: introduce a compack timer handler in sack compression
To: Eric Dumazet <edumazet@google.com>
Cc: toke@toke.dk, Yuchung Cheng <ycheng@google.com>, 
	"David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org, 
	zhangweiping <zhangweiping@didiglobal.com>, tiozhang <tiozhang@didiglobal.com>, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, fuyuanli@didiglobal.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 7:10=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> On Tue, May 30, 2023 at 6:01=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Tue, May 30, 2023 at 9:45=E2=80=AFAM Jason Xing <kerneljasonxing@gma=
il.com> wrote:
> > >
> > > On Tue, May 30, 2023 at 3:12=E2=80=AFPM Eric Dumazet <edumazet@google=
.com> wrote:
> > > >
> > > > On Mon, May 29, 2023 at 1:38=E2=80=AFPM fuyuanli <fuyuanli@didiglob=
al.com> wrote:
> > > > >
> > > > > We've got some issues when sending a compressed ack is deferred t=
o
> > > > > release phrase due to the socket owned by another user:
> > > > > 1. a compressed ack would not be sent because of lack of ICSK_ACK=
_TIMER
> > > > > flag.
> > > >
> > > > Are you sure ? Just add it then, your patch will be a one-liner
> > > > instead of a complex one adding
> > > > more code in a fast path.
> > >
> > > Honestly, at the very beginning, we just added one line[1] to fix
> > > this. After I digged more into this part, I started to doubt if we
> > > should reuse the delayed ack logic.
> > >
> > > Because in the sack compression logic there is no need to do more
> > > things as delayed ack does in the tcp_delack_timer_handler() function=
.
> > >
> > > Besides, here are some things extra to be done if we defer to send an
> > > ack in sack compression:
> > > 1) decrease tp->compressed_ack. The same as "tp->compressed_ack--;" i=
n
> > > tcp_compressed_ack_kick().
> > > 2) initialize icsk->icsk_ack.timeout. Actually we don't need to do
> > > this because we don't modify the expiration time in the sack
> > > compression hrtimer.
> >
> > Yes, we do not need this, see my following comment.
> >
> > > 3) don't need to count the LINUX_MIB_DELAYEDACKS counter.
> > > 4) I wonder even if those checks about the ack schedule or ping pong
> > > mode in tcp_delack_timer_handler() for sack compression? I'm not sure
> > > about it.
> > >
> > > So one line cannot solve it perfectly. That's the reason why we
> > > introduce a new logic which can be clearer.
> > >
> > > I'm wondering if adding one check in the fast path is really that
> > > unacceptable (it may hurt performance?) because a new logic would be
> > > clearer for the whole sack compression.
> >
> > We definitely can solve the minor issue by not polluting the fast path.
> >
> > We also want simple/localised fixes, not something invasive (and risky)=
.
>
> Now I got it :)
>
> >
> > >
> > > [1]
> > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > index cc072d2cfcd8..d9e76d761cc6 100644
> > > --- a/net/ipv4/tcp_input.c
> > > +++ b/net/ipv4/tcp_input.c
> > > @@ -5568,6 +5568,7 @@ static void __tcp_ack_snd_check(struct sock *sk=
,
> > > int ofo_possible)
> > >
> > > READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
> > >                       rtt * (NSEC_PER_USEC >> 3)/20);
> > >         sock_hold(sk);
> > > +       inet_csk(sk)->icsk_ack.pending |=3D ICSK_ACK_TIMER;
> >
> > Why not simply use existing storage/variables (tp->compressed_ack),
> > instead of trying
> > to reuse something else or add another bit, then complain that this
> > does not work well ?
> >
> > Again, just fix tcp_delack_timer_handler(), it already can fetch existi=
ng state.
> >
> > As a bonus, no need to send one patch for net, and another in net-next,
> > trying to 'fix' issues that should have been fixed cleanly in a single =
patch.
> >
> > Something like:
> >
> > diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> > index b839c2f91292f7346f33d6dcbf597594473a5aca..16bc4cedceb8a5e88f61f9a=
bc2c0a8cc9322676a
> > 100644
> > --- a/net/ipv4/tcp_timer.c
> > +++ b/net/ipv4/tcp_timer.c
> > @@ -290,10 +290,20 @@ static int tcp_write_timeout(struct sock *sk)
> >  void tcp_delack_timer_handler(struct sock *sk)
> >  {
> >         struct inet_connection_sock *icsk =3D inet_csk(sk);
> > +       struct tcp_sock *tp =3D tcp_sk(sk);
> >
> > -       if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
> > -           !(icsk->icsk_ack.pending & ICSK_ACK_TIMER))
> > +       if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))
> > +               return;
> > +
> > +       if (!(icsk->icsk_ack.pending & ICSK_ACK_TIMER) &&
> > +           !tp->compressed_ack)
> > +               return;
> > +
> > +       if (tp->compressed_ack) {
> > +               tcp_mstamp_refresh(tp);
> > +               tcp_sack_compress_send_ack(sk);
>
> I wonder if we could use this combination as below instead since the
> above function counts the snmp counter and clears the @compressed_ack,
> which is against what we normally do in tcp_compressed_ack_kick() if
> the socket is not owned?

I take it back. After I considered it for a while, I think it's
working because @compressed_ack and snmp counter are a pair which
means we can do both of them together.
It doesn't have any impact though it looks a bit different from before.

Thanks,
Jason

>
> "
> if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) =3D=3D 1)
>     __sock_put(sk);
> tcp_send_ack(sk);
> "
>
> Above is extracted from tcp_sack_compress_send_ack()
>
> >                 return;
> > +       }
> >
> >         if (time_after(icsk->icsk_ack.timeout, jiffies)) {
> >                 sk_reset_timer(sk, &icsk->icsk_delack_timer,
> > icsk->icsk_ack.timeout);
> > @@ -312,7 +322,7 @@ void tcp_delack_timer_handler(struct sock *sk)
> >                         inet_csk_exit_pingpong_mode(sk);
> >                         icsk->icsk_ack.ato      =3D TCP_ATO_MIN;
> >                 }
> > -               tcp_mstamp_refresh(tcp_sk(sk));
> > +               tcp_mstamp_refresh(tp);
> >                 tcp_send_ack(sk);
> >                 __NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKS);
> >         }
>
> Thank you so much, Eric.
>
> I will let fuyuanli submit a v2 patch including that one without
> introducing a new logic/flag.
>
> Thanks again,
> Jason

