Return-Path: <netdev+bounces-6274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2826715793
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16BDA1C20BAC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA4B125C8;
	Tue, 30 May 2023 07:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D4E111AD;
	Tue, 30 May 2023 07:50:23 +0000 (UTC)
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4EC12A;
	Tue, 30 May 2023 00:49:53 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6af86627460so3140552a34.1;
        Tue, 30 May 2023 00:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685432991; x=1688024991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBnKfNedfF8GkKs+JJUwxB53s3qBEZPidNvLcBHzWMs=;
        b=h0KtlLHDpvMJstbjOCBXS/T0XZHkbR7CfRE7rLCJCkzyZUWIlQhnUhis/LQv81j+9R
         RBC5MLdj+l+kYvVq2tvim3pkMQX5GuipyShJs0tyQAfywspRgzk3+7Wktq7z7QeqavMh
         Ujc744bAKa/AUj6IgtH1WfSKMS5TasrzCXlfbq1tA4BbHYMB9fCCPq7+xKO7KuFSfUoU
         ptfRy3EK+mqZ8opR8opZOIfHZvpvOsdd28s7zqNnk04tzZmArcfulnuNfdIJf8mm0LHy
         tOaPk+t2PjmtaYlZDAQj+G7S8TzzuS5QGspuuRxQU0XkPDhHFEEfy8v6t932s+Alumw8
         5K8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685432991; x=1688024991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBnKfNedfF8GkKs+JJUwxB53s3qBEZPidNvLcBHzWMs=;
        b=Zs5mYJ/eCZQJ7F3PJG8pXiCj5BF9QtqImA7CeaM83jbGKdXZw/bbzRKIvTqwPBTV2O
         c/fTWstWHGSpMV7btbKTOTHlH41hBzJyRUp2T511FESMsBNarR43zaMgGvUIoefwxJS+
         FEOL3Eu3W/IhRcFCegBXDmTKhvop9rgUVYPj3UDtqG/cIl0PFcfDNn62TntvmouLQnNB
         TCMJSzf5ZulTOT23BD1z0ylqdcbvuRtpSfmS+OYmhw+Dqw1CCjScVZdCKPXEGZ4Ze39u
         rnzic5E2puz9FbxidQgCYSeD5Vocnob82uvkTpQmo4kwGOfGnmuBhJyj9LwFX/F8YuLF
         xg+w==
X-Gm-Message-State: AC+VfDwQMufCVh9QJcV00lqcibt4ia7pGyyFeRNtThksIUyRQA9Ma7Wb
	MLtJX6qD+IE0/YohO+ZZVL0qnDLKW2aVSuwbp/w=
X-Google-Smtp-Source: ACHHUZ5gj8GQGhaxlK2kzd2sCXXlCOh9ob/Zjku+sVRL/uIP3lA3m/JX7OgRnaw/o6lOh/qTh/f2GesKM0LH9mcQ8qU=
X-Received: by 2002:a05:6808:6185:b0:392:5ce5:d1c with SMTP id
 dn5-20020a056808618500b003925ce50d1cmr663821oib.7.1685432990813; Tue, 30 May
 2023 00:49:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529113804.GA20300@didi-ThinkCentre-M920t-N000>
 <CANn89iJw3Ehoj7GfYnc6Xv5N2wULqNuP3zNBwQx97i-YJD5avg@mail.gmail.com> <CAL+tcoCRgpoYgQXdM2Es0gjRtRZj1hCK-5M04WZ1sy3vt_5JjA@mail.gmail.com>
In-Reply-To: <CAL+tcoCRgpoYgQXdM2Es0gjRtRZj1hCK-5M04WZ1sy3vt_5JjA@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 30 May 2023 15:49:14 +0800
Message-ID: <CAL+tcoAnBEk7tFM8x+VmkBBxmrAFWAG8wMQhoS3efW0hWjuNDw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: introduce a compack timer handler in sack compression
To: Eric Dumazet <edumazet@google.com>, toke@toke.dk, Yuchung Cheng <ycheng@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
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

On Tue, May 30, 2023 at 3:45=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> On Tue, May 30, 2023 at 3:12=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Mon, May 29, 2023 at 1:38=E2=80=AFPM fuyuanli <fuyuanli@didiglobal.c=
om> wrote:
> > >
> > > We've got some issues when sending a compressed ack is deferred to
> > > release phrase due to the socket owned by another user:
> > > 1. a compressed ack would not be sent because of lack of ICSK_ACK_TIM=
ER
> > > flag.
> >
> > Are you sure ? Just add it then, your patch will be a one-liner
> > instead of a complex one adding
> > more code in a fast path.
>
> Honestly, at the very beginning, we just added one line[1] to fix
> this. After I digged more into this part, I started to doubt if we
> should reuse the delayed ack logic.
>
> Because in the sack compression logic there is no need to do more
> things as delayed ack does in the tcp_delack_timer_handler() function.
>
> Besides, here are some things extra to be done if we defer to send an
> ack in sack compression:
> 1) decrease tp->compressed_ack. The same as "tp->compressed_ack--;" in
> tcp_compressed_ack_kick().
> 2) initialize icsk->icsk_ack.timeout. Actually we don't need to do
> this because we don't modify the expiration time in the sack
> compression hrtimer.
> 3) don't need to count the LINUX_MIB_DELAYEDACKS counter.
> 4) I wonder even if those checks about the ack schedule or ping pong
> mode in tcp_delack_timer_handler() for sack compression? I'm not sure
> about it.
>
> So one line cannot solve it perfectly. That's the reason why we
> introduce a new logic which can be clearer.
>
> I'm wondering if adding one check in the fast path is really that
> unacceptable (it may hurt performance?) because a new logic would be
> clearer for the whole sack compression.
>
> [1]
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index cc072d2cfcd8..d9e76d761cc6 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5568,6 +5568,7 @@ static void __tcp_ack_snd_check(struct sock *sk,
> int ofo_possible)
>
> READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
>                       rtt * (NSEC_PER_USEC >> 3)/20);
>         sock_hold(sk);
> +       inet_csk(sk)->icsk_ack.pending |=3D ICSK_ACK_TIMER;

Oh, one more thing I forget to say is adding this flag here would
cause us to handle when and where to remove this flag without messing
up with the delayed ack logic.

Thanks,
Jason

>         hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(del=
ay),
>
> READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns),
>                                HRTIMER_MODE_REL_PINNED_SOFT);
>
> >
> > > 2. the tp->compressed_ack counter should be decremented by 1.
> > > 3. we cannot pass timeout check and reset the delack timer in
> > > tcp_delack_timer_handler().
> > > 4. we are not supposed to increment the LINUX_MIB_DELAYEDACKS counter=
.
> > > ...
> > >
> > > The reason why it could happen is that we previously reuse the delaye=
d
> > > ack logic when handling the sack compression. With this patch applied=
,
> > > the sack compression logic would go into the same function
> > > (tcp_compack_timer_handler()) whether we defer sending ack or not.
> > > Therefore, those two issued could be easily solved.
> > >
> > > Here are more details in the old logic:
> > > When sack compression is triggered in the tcp_compressed_ack_kick(),
> > > if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED a=
nd
> > > then defer to the release cb phrase. Later once user releases the soc=
k,
> > > tcp_delack_timer_handler() should send a ack as expected, which, howe=
ver,
> > > cannot happen due to lack of ICSK_ACK_TIMER flag. Therefore, the rece=
iver
> > > would not sent an ack until the sender's retransmission timeout. It
> > > definitely increases unnecessary latency.
> > >
> > > This issue happens rarely in the production environment. I used kprob=
e
> > > to hook some key functions like tcp_compressed_ack_kick, tcp_release_=
cb,
> > > tcp_delack_timer_handler and then found that when tcp_delack_timer_ha=
ndler
> > > was called, value of icsk_ack.pending was 1, which means we only had
> > > flag ICSK_ACK_SCHED set, not including ICSK_ACK_TIMER. It was against
> > > our expectations.
> > >
> > > In conclusion, we chose to separate the sack compression from delayed
> > > ack logic to solve issues only happening when the process is deferred=
.
> > >
> > > Fixes: 5d9f4262b7ea ("tcp: add SACK compression")
> > > Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
> > > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > > ---
> > >  include/linux/tcp.h   |  2 ++
> > >  include/net/tcp.h     |  1 +
> > >  net/ipv4/tcp_output.c |  4 ++++
> > >  net/ipv4/tcp_timer.c  | 28 +++++++++++++++++++---------
> > >  4 files changed, 26 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> > > index b4c08ac86983..cd15a9972c48 100644
> > > --- a/include/linux/tcp.h
> > > +++ b/include/linux/tcp.h
> > > @@ -461,6 +461,7 @@ enum tsq_enum {
> > >         TCP_MTU_REDUCED_DEFERRED,  /* tcp_v{4|6}_err() could not call
> > >                                     * tcp_v{4|6}_mtu_reduced()
> > >                                     */
> > > +       TCP_COMPACK_TIMER_DEFERRED, /* tcp_compressed_ack_kick() foun=
d socket was owned */
> > >  };
> > >
> > >  enum tsq_flags {
> > > @@ -470,6 +471,7 @@ enum tsq_flags {
> > >         TCPF_WRITE_TIMER_DEFERRED       =3D (1UL << TCP_WRITE_TIMER_D=
EFERRED),
> > >         TCPF_DELACK_TIMER_DEFERRED      =3D (1UL << TCP_DELACK_TIMER_=
DEFERRED),
> > >         TCPF_MTU_REDUCED_DEFERRED       =3D (1UL << TCP_MTU_REDUCED_D=
EFERRED),
> > > +       TCPF_COMPACK_TIMER_DEFERRED     =3D (1UL << TCP_DELACK_TIMER_=
DEFERRED),
> > >  };
> > >
> > >  #define tcp_sk(ptr) container_of_const(ptr, struct tcp_sock, inet_co=
nn.icsk_inet.sk)
> > > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > > index 18a038d16434..e310d7bf400c 100644
> > > --- a/include/net/tcp.h
> > > +++ b/include/net/tcp.h
> > > @@ -342,6 +342,7 @@ void tcp_release_cb(struct sock *sk);
> > >  void tcp_wfree(struct sk_buff *skb);
> > >  void tcp_write_timer_handler(struct sock *sk);
> > >  void tcp_delack_timer_handler(struct sock *sk);
> > > +void tcp_compack_timer_handler(struct sock *sk);
> > >  int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg);
> > >  int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb);
> > >  void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
> > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > index cfe128b81a01..1703caab6632 100644
> > > --- a/net/ipv4/tcp_output.c
> > > +++ b/net/ipv4/tcp_output.c
> > > @@ -1110,6 +1110,10 @@ void tcp_release_cb(struct sock *sk)
> > >                 tcp_delack_timer_handler(sk);
> > >                 __sock_put(sk);
> > >         }
> > > +       if (flags & TCPF_COMPACK_TIMER_DEFERRED) {
> > > +               tcp_compack_timer_handler(sk);
> > > +               __sock_put(sk);
> > > +       }
> >
> > Please do not add another test in the fast path.
> >
> > Just make sure tcp_delack_timer_handler() handles the case (this
> > certainly was my intent)
> >
> >
> > >         if (flags & TCPF_MTU_REDUCED_DEFERRED) {
> > >                 inet_csk(sk)->icsk_af_ops->mtu_reduced(sk);
> > >                 __sock_put(sk);
> > > diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> > > index b839c2f91292..069f6442069b 100644
> > > --- a/net/ipv4/tcp_timer.c
> > > +++ b/net/ipv4/tcp_timer.c
> > > @@ -318,6 +318,23 @@ void tcp_delack_timer_handler(struct sock *sk)
> > >         }
> > >  }
> > >
> > > +/* Called with BH disabled */
> > > +void tcp_compack_timer_handler(struct sock *sk)
> > > +{
> > > +       struct tcp_sock *tp =3D tcp_sk(sk);
> > > +
> > > +       if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> > > +               return;
> > > +
> > > +       if (tp->compressed_ack) {
> > > +               /* Since we have to send one ack finally,
> > > +                * subtract one from tp->compressed_ack to keep
> > > +                * LINUX_MIB_TCPACKCOMPRESSED accurate.
> > > +                */
> > > +               tp->compressed_ack--;
> > > +               tcp_send_ack(sk);
> > > +       }
> > > +}
> > >
> > >  /**
> > >   *  tcp_delack_timer() - The TCP delayed ACK timeout handler
> > > @@ -757,16 +774,9 @@ static enum hrtimer_restart tcp_compressed_ack_k=
ick(struct hrtimer *timer)
> > >
> > >         bh_lock_sock(sk);
> > >         if (!sock_owned_by_user(sk)) {
> > > -               if (tp->compressed_ack) {
> > > -                       /* Since we have to send one ack finally,
> > > -                        * subtract one from tp->compressed_ack to ke=
ep
> > > -                        * LINUX_MIB_TCPACKCOMPRESSED accurate.
> > > -                        */
> > > -                       tp->compressed_ack--;
> > > -                       tcp_send_ack(sk);
> > > -               }
> > > +               tcp_compack_timer_handler(sk);
> > >         } else {
> > > -               if (!test_and_set_bit(TCP_DELACK_TIMER_DEFERRED,
> >
> > See, I was clearly intending to let tcp_delack_timer_handler() deal wit=
h this.
>
> I knew that :)
>
> Thanks,
> Jason
>
> >
> > > +               if (!test_and_set_bit(TCP_COMPACK_TIMER_DEFERRED,
> > >                                       &sk->sk_tsq_flags))
> > >                         sock_hold(sk);
> > >         }
> > > --
> > > 2.17.1
> > >

