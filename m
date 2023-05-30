Return-Path: <netdev+bounces-6210-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05861715383
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:16:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E3241C20B4B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF62ED6;
	Tue, 30 May 2023 02:15:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E824A3C;
	Tue, 30 May 2023 02:15:57 +0000 (UTC)
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE9AA0;
	Mon, 29 May 2023 19:15:55 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-5559e296433so2730293eaf.0;
        Mon, 29 May 2023 19:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685412954; x=1688004954;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kj6w/nQ+DaN6Ioar2LxJRCroPn6xto7HRGwItvd9JSg=;
        b=BEpmL7AOAAd3XVj1gCkN73QCbSp2WXZAMLWpfCT4K39LSegqmYhDvyNZGcSa4FFnwM
         2I89K07XIFp/UoW0E5/lI1zutGQIwH0xoA2M7FvHiuqE4MCcdXtYrYT1b4Oa1cDirX4z
         ZeR7uIx3SyMHzEilAi3siaZsSnI2cDzaAIMsjIpRTYlmkAjcxBkiieKOmeKy0BnLL/4W
         2nbOAHtGdKZUaCGLWU3L1x2VsjOICI1rymYqTLTWbusn15vj3MgQosc6vSIt6L1j0lS4
         r6g7Zz8TSoUWAOAUYyoF+nOFmJkg5kjgh8tk12RxBqk+iFPaHTWNUDusK2EiZ/mIjbZb
         qqTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685412954; x=1688004954;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kj6w/nQ+DaN6Ioar2LxJRCroPn6xto7HRGwItvd9JSg=;
        b=ZQ/7yPfK+Ex0RWuTWI9oUebeo5i2ryh5+CjPxXkodg2Ae6tafGHax1KZFAKBDqU1eu
         xPQwMchOYXz6VRjiJcMyYgPkSnoGJiPUmsgUhDUokxyFxvoQrj3l5Z5ZEI5D9keIgq3U
         NxRk7JfbGfS4AmOaikdgHWwHam8Lf7BRc+UXjMTTr9skj356HZNR5xlStYf0k4L1AWk4
         UnP4L8pKHsNR1bYT1Cb8yRUs9QqlM8rbAMhSzaxn4ZbVlAS3h0SMAJdvRaskFX1d5qYO
         +w93x94pCIcK+me8J0gaxwx2QJdKsPrpIujuTwtBKTvU6dBsna2ZMdqKpcQxoVHSQx8w
         lWEA==
X-Gm-Message-State: AC+VfDxPcWcyfHT8htchoBiy7u99YATV+CxkM6B7db7YmT1rTw6WYqQt
	mTEymosqNn0+z0l31F7jy3FEjs5IO1kfti09Xzm7AO4Yrg7VmVrz
X-Google-Smtp-Source: ACHHUZ4GYZuV99/EX6AvqaPbK2sGe5kY/pOSlJ4xxNIvyrdsy4NgUbwFhUNT88dVRe+Lm/tKyT457gj8ayhHFUfRRvY=
X-Received: by 2002:a05:6870:a2cb:b0:199:fa90:a62 with SMTP id
 w11-20020a056870a2cb00b00199fa900a62mr5606177oak.8.1685412954613; Mon, 29 May
 2023 19:15:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529113804.GA20300@didi-ThinkCentre-M920t-N000>
In-Reply-To: <20230529113804.GA20300@didi-ThinkCentre-M920t-N000>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 30 May 2023 10:15:18 +0800
Message-ID: <CAL+tcoACOnUZjWLXgs7Yxr0cD31X1AvGtog35XufYhVS_Tzx9Q@mail.gmail.com>
Subject: Re: [PATCH net] tcp: introduce a compack timer handler in sack compression
To: Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org, 
	Jason Xing <kerneljasonxing@gmail.com>, zhangweiping <zhangweiping@didiglobal.com>, 
	tiozhang <tiozhang@didiglobal.com>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	Yuchung Cheng <ycheng@google.com>, toke@toke.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 7:38=E2=80=AFPM fuyuanli <fuyuanli@didiglobal.com> =
wrote:
>
> We've got some issues when sending a compressed ack is deferred to
> release phrase due to the socket owned by another user:
> 1. a compressed ack would not be sent because of lack of ICSK_ACK_TIMER
> flag.
> 2. the tp->compressed_ack counter should be decremented by 1.
> 3. we cannot pass timeout check and reset the delack timer in
> tcp_delack_timer_handler().
> 4. we are not supposed to increment the LINUX_MIB_DELAYEDACKS counter.
> ...
>
> The reason why it could happen is that we previously reuse the delayed
> ack logic when handling the sack compression. With this patch applied,
> the sack compression logic would go into the same function
> (tcp_compack_timer_handler()) whether we defer sending ack or not.
> Therefore, those two issued could be easily solved.
>
> Here are more details in the old logic:
> When sack compression is triggered in the tcp_compressed_ack_kick(),
> if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED and
> then defer to the release cb phrase. Later once user releases the sock,
> tcp_delack_timer_handler() should send a ack as expected, which, however,
> cannot happen due to lack of ICSK_ACK_TIMER flag. Therefore, the receiver
> would not sent an ack until the sender's retransmission timeout. It
> definitely increases unnecessary latency.
>
> This issue happens rarely in the production environment. I used kprobe
> to hook some key functions like tcp_compressed_ack_kick, tcp_release_cb,
> tcp_delack_timer_handler and then found that when tcp_delack_timer_handle=
r
> was called, value of icsk_ack.pending was 1, which means we only had
> flag ICSK_ACK_SCHED set, not including ICSK_ACK_TIMER. It was against
> our expectations.
>
> In conclusion, we chose to separate the sack compression from delayed
> ack logic to solve issues only happening when the process is deferred.
>
> Fixes: 5d9f4262b7ea ("tcp: add SACK compression")
> Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
> Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> ---
>  include/linux/tcp.h   |  2 ++
>  include/net/tcp.h     |  1 +
>  net/ipv4/tcp_output.c |  4 ++++
>  net/ipv4/tcp_timer.c  | 28 +++++++++++++++++++---------
>  4 files changed, 26 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index b4c08ac86983..cd15a9972c48 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -461,6 +461,7 @@ enum tsq_enum {
>         TCP_MTU_REDUCED_DEFERRED,  /* tcp_v{4|6}_err() could not call
>                                     * tcp_v{4|6}_mtu_reduced()
>                                     */
> +       TCP_COMPACK_TIMER_DEFERRED, /* tcp_compressed_ack_kick() found so=
cket was owned */
>  };
>
>  enum tsq_flags {
> @@ -470,6 +471,7 @@ enum tsq_flags {
>         TCPF_WRITE_TIMER_DEFERRED       =3D (1UL << TCP_WRITE_TIMER_DEFER=
RED),
>         TCPF_DELACK_TIMER_DEFERRED      =3D (1UL << TCP_DELACK_TIMER_DEFE=
RRED),
>         TCPF_MTU_REDUCED_DEFERRED       =3D (1UL << TCP_MTU_REDUCED_DEFER=
RED),
> +       TCPF_COMPACK_TIMER_DEFERRED     =3D (1UL << TCP_DELACK_TIMER_DEFE=
RRED),
>  };
>
>  #define tcp_sk(ptr) container_of_const(ptr, struct tcp_sock, inet_conn.i=
csk_inet.sk)
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 18a038d16434..e310d7bf400c 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -342,6 +342,7 @@ void tcp_release_cb(struct sock *sk);
>  void tcp_wfree(struct sk_buff *skb);
>  void tcp_write_timer_handler(struct sock *sk);
>  void tcp_delack_timer_handler(struct sock *sk);
> +void tcp_compack_timer_handler(struct sock *sk);
>  int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg);
>  int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb);
>  void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index cfe128b81a01..1703caab6632 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1110,6 +1110,10 @@ void tcp_release_cb(struct sock *sk)
>                 tcp_delack_timer_handler(sk);
>                 __sock_put(sk);
>         }
> +       if (flags & TCPF_COMPACK_TIMER_DEFERRED) {
> +               tcp_compack_timer_handler(sk);
> +               __sock_put(sk);
> +       }
>         if (flags & TCPF_MTU_REDUCED_DEFERRED) {
>                 inet_csk(sk)->icsk_af_ops->mtu_reduced(sk);
>                 __sock_put(sk);
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index b839c2f91292..069f6442069b 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -318,6 +318,23 @@ void tcp_delack_timer_handler(struct sock *sk)
>         }
>  }
>
> +/* Called with BH disabled */
> +void tcp_compack_timer_handler(struct sock *sk)
> +{
> +       struct tcp_sock *tp =3D tcp_sk(sk);
> +
> +       if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> +               return;
> +
> +       if (tp->compressed_ack) {
> +               /* Since we have to send one ack finally,
> +                * subtract one from tp->compressed_ack to keep
> +                * LINUX_MIB_TCPACKCOMPRESSED accurate.
> +                */
> +               tp->compressed_ack--;
> +               tcp_send_ack(sk);
> +       }
> +}
>
>  /**
>   *  tcp_delack_timer() - The TCP delayed ACK timeout handler
> @@ -757,16 +774,9 @@ static enum hrtimer_restart tcp_compressed_ack_kick(=
struct hrtimer *timer)
>
>         bh_lock_sock(sk);
>         if (!sock_owned_by_user(sk)) {
> -               if (tp->compressed_ack) {
> -                       /* Since we have to send one ack finally,
> -                        * subtract one from tp->compressed_ack to keep
> -                        * LINUX_MIB_TCPACKCOMPRESSED accurate.
> -                        */
> -                       tp->compressed_ack--;
> -                       tcp_send_ack(sk);
> -               }
> +               tcp_compack_timer_handler(sk);
>         } else {
> -               if (!test_and_set_bit(TCP_DELACK_TIMER_DEFERRED,
> +               if (!test_and_set_bit(TCP_COMPACK_TIMER_DEFERRED,
>                                       &sk->sk_tsq_flags))
>                         sock_hold(sk);
>         }
> --
> 2.17.1
>

I checked the patchwork and then found that it warns me because of not
CCing two other maintainers: ycheng and toke. But what made me curious
is I cannot find them in the MAINTAINERS file.

so CC them here and wait for more suggestions about this patch during
this period before fuyuanli submits v2 patch with all the maintainers
CC'ed.

CC:
ycheng@google.com and toke@toke.dk

Thanks,
Jason

