Return-Path: <netdev+bounces-6260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC5571569D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C39F1C20B68
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73EE111AE;
	Tue, 30 May 2023 07:24:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB752944B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:24:13 +0000 (UTC)
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D57180
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:24:10 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-19f7f41d9dcso985445fac.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685431450; x=1688023450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o22UAQ+UhaPFKGitM97yLiqBmxk7WpyDdVR8/D1AFNY=;
        b=LgCzlA2xXpCLz/b6BjXhKy4KgrxFrAGs4TF+1yCEe8JsJK/hH4/1UnQCi/CPXWJbaL
         1gVFAJjzGHkfmsGaszGzJnO79hjOuWuRlvFFDrW7axngAXZ4FebB3zEE9yJ8LroviAWR
         qiJrjQvVzDAZTurgssh+Zv28DlRQkg7PBA2WxZGBlWXlYKcoSmQIyREbjveBnVWc31yK
         zsIhnKmp+iHY/kIVT1LN7aWUaMedeMx91D7u6xCE2u1XpTkJ8AC6HcEvI560QIm6RHkM
         YRyRwGFeGijVmDb6zcRsG0nWdNOH1cebjZ27AZ7IefSse1Pmw6fvJATk+eszkRzMlEl2
         fgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685431450; x=1688023450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o22UAQ+UhaPFKGitM97yLiqBmxk7WpyDdVR8/D1AFNY=;
        b=DuCbRLuEEolNM6Wu9XHaqbKUOt1C32bnoRedCOb9bs3jI1GatMzYckcisojN0kZ6/c
         +I5nSJ4s8TPTC4KsBkN2bVos/zNG8JNEBcN8rw19d2FfxjsjETrrLWtmYDczBf0IgeEJ
         dktv1X/qQIorPEILRoULyItcAnldgyLBJpGH+7OKJXemywfzNSHyGN/BMiJB89neGVsq
         ysQHWJYV1JNhNo2Q4Vuc4n++AkQHAc5x3MVHJ2JdGjWkUFIMDQWurzjTRsJ2SdBHhGVm
         87EHVTrryN1e2bdPHAZsTO2It5ks+3PMq7c2HaJpdTAobc3L9I0Z/pfpEj5SVuIQb2Kr
         RDig==
X-Gm-Message-State: AC+VfDyLZd3+YJfksUeXoU9U5GghlOq3l8g4BRze4oKyLWpMYUTrLNdq
	33UGrdhXcG8uyb3EIYKoM4ZW/MQxcbsTrA58q5/jSM1cxHu0Ihoc
X-Google-Smtp-Source: ACHHUZ4cXHqLSMcTensi53stKVyXmkwo6SKQwIRO8UWlwYP6t51kpYI/2TLDNlxPHXg0qINM/IvqBTwM44dgK9X9anU=
X-Received: by 2002:a05:6870:e606:b0:18b:1c64:2d3f with SMTP id
 q6-20020a056870e60600b0018b1c642d3fmr665856oag.54.1685431450116; Tue, 30 May
 2023 00:24:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530023737.584-1-kerneljasonxing@gmail.com> <CANn89i+xRVxqx1-tSQaf_Kh7AG07Y2niGROPc0--mGf7_wz7Qw@mail.gmail.com>
In-Reply-To: <CANn89i+xRVxqx1-tSQaf_Kh7AG07Y2niGROPc0--mGf7_wz7Qw@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 30 May 2023 15:23:33 +0800
Message-ID: <CAL+tcoD_pvrJtCs9+whmAL4KXcf7HrBV92dJ9hPqP-4dteEtLw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: handle the deferred sack compression when
 it should be canceled
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	dsahern@kernel.org, ncardwell@google.com, ycheng@google.com, toke@toke.dk, 
	fuyuanli@didiglobal.com, netdev@vger.kernel.org, 
	Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 3:09=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, May 30, 2023 at 4:37=E2=80=AFAM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > In the previous commits, we have not implemented to deal with the case
> > where we're going to abort sending a ack triggered in the timer. So
> > introducing a new flag ICSK_ACK_COMP_TIMER for sack compression only
> > could satisify this requirement.
> >
>
>
> Sorry, I can not parse this changelog.
>
> What is the problem you want to fix ?

In the old logic, we will cancel the timer in order to avoid sending
an ack in those two functions (tcp_sack_compress_send_ack() and
tcp_event_ack_sent()). What if we already triggered the hrtimer and
defer sending an ack to release cb process due to the socket owned by
someone?

My intention is to abort sending an ack here if we defer in the hrtimer han=
dler.

>
>
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > Comment on this:
> > This patch is based on top of a commit[1]. I don't think the current
> > patch is fixing a bug, but more like an improvement. So I would like
> > to target at net-next tree.
> >
> > [1]: https://patchwork.kernel.org/project/netdevbpf/patch/2023052911380=
4.GA20300@didi-ThinkCentre-M920t-N000/
> > ---
> >  include/net/inet_connection_sock.h | 3 ++-
> >  net/ipv4/tcp_input.c               | 6 +++++-
> >  net/ipv4/tcp_output.c              | 3 +++
> >  net/ipv4/tcp_timer.c               | 5 ++++-
> >  4 files changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_conn=
ection_sock.h
> > index c2b15f7e5516..34ff6d27471d 100644
> > --- a/include/net/inet_connection_sock.h
> > +++ b/include/net/inet_connection_sock.h
> > @@ -164,7 +164,8 @@ enum inet_csk_ack_state_t {
> >         ICSK_ACK_TIMER  =3D 2,
> >         ICSK_ACK_PUSHED =3D 4,
> >         ICSK_ACK_PUSHED2 =3D 8,
> > -       ICSK_ACK_NOW =3D 16       /* Send the next ACK immediately (onc=
e) */
> > +       ICSK_ACK_NOW =3D 16,      /* Send the next ACK immediately (onc=
e) */
> > +       ICSK_ACK_COMP_TIMER  =3D 32       /* Used for sack compression =
*/
> >  };
> >
> >  void inet_csk_init_xmit_timers(struct sock *sk,
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index cc072d2cfcd8..3980f77dcdff 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -4540,6 +4540,9 @@ static void tcp_sack_compress_send_ack(struct soc=
k *sk)
> >         if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) =3D=3D 1)
> >                 __sock_put(sk);
> >
> > +       /* It also deal with the case where the sack compression is def=
erred */
> > +       inet_csk(sk)->icsk_ack.pending &=3D ~ICSK_ACK_COMP_TIMER;
> > +
> >         /* Since we have to send one ack finally,
> >          * substract one from tp->compressed_ack to keep
> >          * LINUX_MIB_TCPACKCOMPRESSED accurate.
> > @@ -5555,7 +5558,7 @@ static void __tcp_ack_snd_check(struct sock *sk, =
int ofo_possible)
> >                 goto send_now;
> >         }
> >         tp->compressed_ack++;
> > -       if (hrtimer_is_queued(&tp->compressed_ack_timer))
> > +       if (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_COMP_TIMER)
> >                 return;
>
> I do not see why adding a new bit, while hrtimer() already has one ?

As I mentioned above, testing whether hrtimer is active or not cannot
help us test if we choose to defer before this.

>
> >
> >         /* compress ack timer : 5 % of rtt, but no more than tcp_comp_s=
ack_delay_ns */
> > @@ -5568,6 +5571,7 @@ static void __tcp_ack_snd_check(struct sock *sk, =
int ofo_possible)
> >                       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack=
_delay_ns),
> >                       rtt * (NSEC_PER_USEC >> 3)/20);
> >         sock_hold(sk);
> > +       inet_csk(sk)->icsk_ack.pending |=3D ICSK_ACK_COMP_TIMER;
> >         hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(d=
elay),
> >                                READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_=
comp_sack_slack_ns),
> >                                HRTIMER_MODE_REL_PINNED_SOFT);
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index 02b58721ab6b..83840daad142 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -188,6 +188,9 @@ static inline void tcp_event_ack_sent(struct sock *=
sk, unsigned int pkts,
> >                 tp->compressed_ack =3D 0;
> >                 if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) =
=3D=3D 1)
> >                         __sock_put(sk);
> > +
> > +               /* It also deal with the case where the sack compressio=
n is deferred */
> > +               inet_csk(sk)->icsk_ack.pending &=3D ~ICSK_ACK_COMP_TIME=
R;
>
> This is adding a lot of code in fast path.
>
> >         }
> >
> >         if (unlikely(rcv_nxt !=3D tp->rcv_nxt))
> > diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> > index b3f8933b347c..a970336d1383 100644
> > --- a/net/ipv4/tcp_timer.c
> > +++ b/net/ipv4/tcp_timer.c
> > @@ -323,9 +323,12 @@ void tcp_compack_timer_handler(struct sock *sk)
> >  {
> >         struct tcp_sock *tp =3D tcp_sk(sk);
> >
> > -       if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> > +       if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
> > +           !(inet_csk(sk)->icsk_ack.pending & ICSK_ACK_COMP_TIMER))
> >                 return;
> >
> > +       inet_csk(sk)->icsk_ack.pending &=3D ~ICSK_ACK_COMP_TIMER;
> > +
> >         if (tp->compressed_ack) {
> >                 /* Since we have to send one ack finally,
> >                  * subtract one from tp->compressed_ack to keep
> > --
> > 2.37.3
> >
>
> An ACK is an ACK, I do not see why you need to differentiate them.

Well, actually I was a little bit confused about whether to reuse the
ICSK_ACK_TIMER flag to deal with sack compression. So I added another
new flag to differentiate them :(

Thanks for your reply.

Jason

