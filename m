Return-Path: <netdev+bounces-6256-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D33C71563F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 245AF2810C6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C1010944;
	Tue, 30 May 2023 07:09:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE0B11181
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:09:57 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A9A9C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:09:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f7024e66adso62875e9.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685430584; x=1688022584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XToQfPoyMfa9lUOji+dAs7YP299kCUM2WPOSBWoNIrI=;
        b=EdLEK3+j0bcyUsVw6BeZiQut/fJJ1m+4DZ+XQS82ZpNlYSepkQBNSVUemdRs19Ga5S
         pwZGlFKVsbEOAk3Ts35u5Up1K7cIlEFYZcyqXHvFXsRX8FNkKoZTaIB5z+mgY7cX+ICs
         urbUMBgY5xD6VueXpUqsn8mufju5pC8f5CStvgAYdHObIn7MvemgfieKVG5epZAucr24
         w0pamH+8UQYdGQgkZHhLnsNY2Ou/Nb7e+dFERWtBK5M1pqUguQCRNckzW/PbLB5Wa4Jh
         2h2rlHRlT2YiY9XOrmuKI2ZFFa26HvijAKzEyPqHSBO5GqPc53JtFF/zfwiXVdRCN4hu
         Ji+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685430584; x=1688022584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XToQfPoyMfa9lUOji+dAs7YP299kCUM2WPOSBWoNIrI=;
        b=WsSwYv98/j4sG4Kb5P1oT64gD5pgGrHQPkt7zOfUVBdDlTQcAwSoAyra/xuLZfuLnc
         kfCSCajY95fl22WXuMqP4Z9zQ3bCvNaYHsGk17BrE9XHpSCL5x5ZpRXG6wppn5ozwy2U
         40ShEvCrR54oIEUA/S45TSbprtnrvFmZzwGIKIVRhfp8utB4MZJvaVTE0OzAj/ZjOVUR
         lawrufbzce2L7uSyw47fcuGgNMm+5YFiLPaShVQxDwYa07YhO0FpJgu1Cjb/dEyRVccB
         1r1n3Q4nhDL9twRo2SVfpmyOhj/XZheZSZbMTG465RFDgMikyL2DIajml8tejIqLFvlc
         DGLQ==
X-Gm-Message-State: AC+VfDzteHKTmp4+66iy4D5GC0VoAPQBERh64i9RfETbkQCOLiTlaoKB
	7rSaRliH9OrJ32SX3iovLuty9sV237fdsV87fwUKxw==
X-Google-Smtp-Source: ACHHUZ6OlRBm2P/YqD+ZLwYsU1pFb7+lLA+xyyD1MCwUizNvjRcAAa908cCd20syH2CLyL1fHY5PHwEfEf3uyIOJnTU=
X-Received: by 2002:a05:600c:8512:b0:3f5:f63:d490 with SMTP id
 gw18-20020a05600c851200b003f50f63d490mr61912wmb.5.1685430584017; Tue, 30 May
 2023 00:09:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530023737.584-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230530023737.584-1-kerneljasonxing@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 May 2023 09:09:32 +0200
Message-ID: <CANn89i+xRVxqx1-tSQaf_Kh7AG07Y2niGROPc0--mGf7_wz7Qw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: handle the deferred sack compression when
 it should be canceled
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	dsahern@kernel.org, ncardwell@google.com, ycheng@google.com, toke@toke.dk, 
	fuyuanli@didiglobal.com, netdev@vger.kernel.org, 
	Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 4:37=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> In the previous commits, we have not implemented to deal with the case
> where we're going to abort sending a ack triggered in the timer. So
> introducing a new flag ICSK_ACK_COMP_TIMER for sack compression only
> could satisify this requirement.
>


Sorry, I can not parse this changelog.

What is the problem you want to fix ?


> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> Comment on this:
> This patch is based on top of a commit[1]. I don't think the current
> patch is fixing a bug, but more like an improvement. So I would like
> to target at net-next tree.
>
> [1]: https://patchwork.kernel.org/project/netdevbpf/patch/20230529113804.=
GA20300@didi-ThinkCentre-M920t-N000/
> ---
>  include/net/inet_connection_sock.h | 3 ++-
>  net/ipv4/tcp_input.c               | 6 +++++-
>  net/ipv4/tcp_output.c              | 3 +++
>  net/ipv4/tcp_timer.c               | 5 ++++-
>  4 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connec=
tion_sock.h
> index c2b15f7e5516..34ff6d27471d 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -164,7 +164,8 @@ enum inet_csk_ack_state_t {
>         ICSK_ACK_TIMER  =3D 2,
>         ICSK_ACK_PUSHED =3D 4,
>         ICSK_ACK_PUSHED2 =3D 8,
> -       ICSK_ACK_NOW =3D 16       /* Send the next ACK immediately (once)=
 */
> +       ICSK_ACK_NOW =3D 16,      /* Send the next ACK immediately (once)=
 */
> +       ICSK_ACK_COMP_TIMER  =3D 32       /* Used for sack compression */
>  };
>
>  void inet_csk_init_xmit_timers(struct sock *sk,
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index cc072d2cfcd8..3980f77dcdff 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4540,6 +4540,9 @@ static void tcp_sack_compress_send_ack(struct sock =
*sk)
>         if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) =3D=3D 1)
>                 __sock_put(sk);
>
> +       /* It also deal with the case where the sack compression is defer=
red */
> +       inet_csk(sk)->icsk_ack.pending &=3D ~ICSK_ACK_COMP_TIMER;
> +
>         /* Since we have to send one ack finally,
>          * substract one from tp->compressed_ack to keep
>          * LINUX_MIB_TCPACKCOMPRESSED accurate.
> @@ -5555,7 +5558,7 @@ static void __tcp_ack_snd_check(struct sock *sk, in=
t ofo_possible)
>                 goto send_now;
>         }
>         tp->compressed_ack++;
> -       if (hrtimer_is_queued(&tp->compressed_ack_timer))
> +       if (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_COMP_TIMER)
>                 return;

I do not see why adding a new bit, while hrtimer() already has one ?

>
>         /* compress ack timer : 5 % of rtt, but no more than tcp_comp_sac=
k_delay_ns */
> @@ -5568,6 +5571,7 @@ static void __tcp_ack_snd_check(struct sock *sk, in=
t ofo_possible)
>                       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_d=
elay_ns),
>                       rtt * (NSEC_PER_USEC >> 3)/20);
>         sock_hold(sk);
> +       inet_csk(sk)->icsk_ack.pending |=3D ICSK_ACK_COMP_TIMER;
>         hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(del=
ay),
>                                READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_co=
mp_sack_slack_ns),
>                                HRTIMER_MODE_REL_PINNED_SOFT);
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 02b58721ab6b..83840daad142 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -188,6 +188,9 @@ static inline void tcp_event_ack_sent(struct sock *sk=
, unsigned int pkts,
>                 tp->compressed_ack =3D 0;
>                 if (hrtimer_try_to_cancel(&tp->compressed_ack_timer) =3D=
=3D 1)
>                         __sock_put(sk);
> +
> +               /* It also deal with the case where the sack compression =
is deferred */
> +               inet_csk(sk)->icsk_ack.pending &=3D ~ICSK_ACK_COMP_TIMER;

This is adding a lot of code in fast path.

>         }
>
>         if (unlikely(rcv_nxt !=3D tp->rcv_nxt))
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index b3f8933b347c..a970336d1383 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -323,9 +323,12 @@ void tcp_compack_timer_handler(struct sock *sk)
>  {
>         struct tcp_sock *tp =3D tcp_sk(sk);
>
> -       if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> +       if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
> +           !(inet_csk(sk)->icsk_ack.pending & ICSK_ACK_COMP_TIMER))
>                 return;
>
> +       inet_csk(sk)->icsk_ack.pending &=3D ~ICSK_ACK_COMP_TIMER;
> +
>         if (tp->compressed_ack) {
>                 /* Since we have to send one ack finally,
>                  * subtract one from tp->compressed_ack to keep
> --
> 2.37.3
>

An ACK is an ACK, I do not see why you need to differentiate them.

