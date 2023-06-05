Return-Path: <netdev+bounces-7855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB25721D40
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B997B281036
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC0381A;
	Mon,  5 Jun 2023 04:56:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED0D631
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:56:40 +0000 (UTC)
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C459B0;
	Sun,  4 Jun 2023 21:56:38 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-55ab0f777acso11244eaf.1;
        Sun, 04 Jun 2023 21:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685940998; x=1688532998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4aD60n/0TSmx7CcvEUgffiS69dT1Aei8Xq2Wd0a34x8=;
        b=CEA9yuD9Qdxe+49op9SsMQLBLkwDpQSgCjgHoilBrvcfAslRU5LxDwwK8rKTK4hBYM
         bFOcOgOv1le35dc2EfsOKHVtWh5Ei28iDg2eGBVy2ifCpLFyJXq752T2r7c5JD7S7V20
         4WqC1YKYC3SxGpCFxE/x+91MPmVVU4iKa/d3m9QiwrtNVzr99SIPY/gyiiEPLEJp8H2a
         U5pTrWxZbBIUJwkZtYzfpaZe+2EWPU5V9WKf67p7JJQAGjxA45RkkIIRFlDSgg/JQe9B
         SYXfIXLIbYz266wlRqU9gYFIHoy8hKYCXlEEl4Z3U/5Joav4WUG5nGpahP/6itNp/4sf
         GdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685940998; x=1688532998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4aD60n/0TSmx7CcvEUgffiS69dT1Aei8Xq2Wd0a34x8=;
        b=Nzo7ljPKK6ayNBdh9fmuh9TZK9k0LHIkNf3ChAZkfYhLeJKQzB/gA3u2eQ6hX14qLp
         v1AvxOWtd1kJYJPOq4IoEwNxDxk+N2xVe4ajOSpigzYktohyYQKn5D81pjoJnySeLJG1
         o1xOQ2DmxK5tll+0nGiKR1yfHewLbZCSHPlE2Kc1OYKr79AjOT4oqWxql/+Yr+TLHyEI
         UE/paWbuihBAE5eIIInYZqN0cVKVtNNe1zkpbbClnk99tzEl4mTHbkX1sv7E5GvYj2Qb
         u4rtBf0vWkQkmK4qn6fCdb67GIKB5ht4GUXa47UkjE4iuQxn5hJ2toc7b0pz2SyN9kGC
         4prQ==
X-Gm-Message-State: AC+VfDxKKQsSwTgPIXe3AB+vSoPt8qTLSBp6PIvx/osywqKNYScHMFUp
	ELIIKNbCUZd9QGnouzvIrYSceIrzbRYaFVHq7JQ=
X-Google-Smtp-Source: ACHHUZ4EbJv7Jxt+s8tc87YpiNQGNReWk6saK49fx+O7i3tEKL8Nmsc1OptKLUQM0f5HSfugxdzuzRCKAOC0TjAX6mI=
X-Received: by 2002:a4a:4585:0:b0:555:9b48:93de with SMTP id
 y127-20020a4a4585000000b005559b4893demr9536081ooa.5.1685940997565; Sun, 04
 Jun 2023 21:56:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605035140.89106-1-duanmuquan@baidu.com>
In-Reply-To: <20230605035140.89106-1-duanmuquan@baidu.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Mon, 5 Jun 2023 12:56:01 +0800
Message-ID: <CAL+tcoBqqDAjhVbrm7Yg4m2xgOqOtxCgdQk36Xs-hb9w9AzaOA@mail.gmail.com>
Subject: Re: [PATCH v1] tcp: fix connection reset due to tw hashdance race.
To: Duan Muquan <duanmuquan@baidu.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 12:22=E2=80=AFPM Duan Muquan <duanmuquan@baidu.com> =
wrote:
>
> If the FIN from passive closer and the ACK for active closer's FIN are
> processed on different CPUs concurrently, tw hashdance race may occur.
> On loopback interface, transmit function queues a skb to current CPU's
> softnet's input queue by default. Suppose active closer runs on CPU 0,
> and passive closer runs on CPU 1. If the ACK for the active closer's
> FIN is sent with no delay, it will be processed and tw hashdance will
> be done on CPU 0; The passive closer's FIN will be sent in another
> segment and processed on CPU 1, it may fail to find tw sock in the
> ehash table due to tw hashdance on CPU 0, then get a RESET.
> If application reconnects immediately with the same source port, it
> will get reset because tw sock's tw_substate is still TCP_FIN_WAIT2.
>
> The dmesg to trace down this issue:
>
> .333516] tcp_send_fin: sk 0000000092105ad2 cookie 9 cpu 3
> .333524] rcv_state_process:FIN_WAIT2 sk 0000000092105ad2 cookie 9 cpu 3
> .333534] tcp_close: tcp_time_wait: sk 0000000092105ad2 cookie 9 cpu 3
> .333538] hashdance: tw 00000000690fdb7a added to ehash cookie 9 cpu 3
> .333541] hashdance: sk 0000000092105ad2 removed cookie 9 cpu 3
> .333544] !refcount_inc_not_zero 00000000690fdb7a ref 0 cookie 9 cpu 0
> .333549] hashdance: tw 00000000690fdb7a before add ref 0 cookie 9 cpu 3
> .333552] rcv_state: RST for FIN listen 000000003c50afa6 cookie 0 cpu 0
> .333574] tcp_send_fin: sk 0000000066757bf8 ref 2 cookie 0 cpu 0
> .333611] timewait_state: TCP_TW_RST tw 00000000690fdb7a cookie 9 cpu 0
> .333626] tcp_connect: sk 0000000066757bf8 cpu 0 cookie 0
>
> Here is the call trace map:
>
> CPU 0                                    CPU 1
>
> --------                                 --------
> tcp_close()
> tcp_send_fin()
> loopback_xmit()
> netif_rx()
> tcp_v4_rcv()
> tcp_ack_snd_check()
> loopback_xmit
> netif_rx()                              tcp_close()
> ...                                     tcp_send_fin()
>                                                                          =
       loopback_xmit()
>                                                                          =
       netif_rx()
>                                                                          =
       tcp_v4_rcv()
>                                                                          =
       ...
> tcp_time_wait()
> inet_twsk_hashdance() {
> ...
>                                     <-__inet_lookup_established()
>                                                                         (=
find sk, may fail tw_refcnt check)
> inet_twsk_add_node_tail_rcu(tw, ...)
>                                     <-__inet_lookup_established()
>                                                                         (=
find sk, may fail tw_refcnt check)
> __sk_nulls_del_node_init_rcu(sk)
>                                     <-__inet_lookup_established()
>                                                                     (find=
 tw, may fail tw_refcnt check)
> refcount_set(&tw->tw_refcnt, 3)
>                                     <-__inet_lookup_established()
>                                                                         (=
find tw, tw_refcnt is ok)
> ...
> }
>
> This issue occurs with a small probability on our application working
> on loopback interface, client gets a connection refused error when it
> reconnects. In a reproducing environment, modifying tcp_ack_snd_check()
> to disable delay ack all the time, and let the client bind the same
> source port everytime, it can be reproduced in about 20 minutes.
>
> Brief of the scenario:
>
> 1. Server runs on CPU 0 and Client runs on CPU 1. Server closes
> connection actively and sends a FIN to client. The lookback's driver
> enqueues the FIN segment to backlog queue of CPU 0 via
> loopback_xmit()->netif_rx(), one of the conditions for non-delay ack
> meets in __tcp_ack_snd_check(), and the ACK is sent immediately.
>
> 2. On loopback interface, the ACK is received and processed on CPU 0,
> the 'dance' from original sock to tw sock will perfrom, tw sock will
> be inserted to ehash table, then the original sock will be removed.
>
> 3. On CPU 1, client closes the connection, a FIN segment is sent and
> processed on CPU 1. When it is looking up sock in ehash table (with no
> lock), tw hashdance race may occur, it fails to find the tw sock and
> get a listener sock in the flowing 3 cases:
>
>   (1) Original sock is found, but it has been destroyed and sk_refcnt
>           has become 0 when validating it.
>   (2) tw sock is found, but its tw_refcnt has not been set to 3, it is
>           still 0, validating for sk_refcnt will fail.
>   (3) For versions that tw sock is added to the head of the list.
>           It will be missed if the list is traversed before tw sock added=
.
>           And the original sock is removed before it is found. No
>           established will be found.
>
> The listener sock will reset the FIN segment which has ack bit set.
>
> 4. If client reconnects immediately and is assigned with the same
> source port as previous connection, the tw sock with tw_substate
> TCP_FIN_WAIT2 will reset client's SYN and destroy itself in
> inet_twsk_deschedule_put(). Application gets a connection refused
> error.
>
> 5. If client reconnects again, it will succeed.
>
> Introduce the flowing 2 modifications to solve the above 3 bad cases:
>
> For case (1):
> Set tw_refcnt to 3 before adding it into list.
>
> For case (2) and (3):
> In function tcp_v4_rcv(), if __inet_lookup_skb() returns a listener sock,
> and this segment has FIN bit set, then retry the lookup process one time.
>
> There may be another bad case, if the original sock is found and passes
> validation, but during further process for the passive closer's FIN on
> CPU 1, the sock has been destroyed on CPU 0, then the FIN segment will
> be dropped and retransmitted. This case does not hurt application as
> much as resetting reconnection, and this case has less possibility than
> the other bad cases, it does not occur in on our product or
> experimental environment, so it is not considered in this patch.
>
> Could you please check whether this fix is OK, or any suggestions?
> Looking forward for your precious comments!

Hello Duan,

I would like to know what your kernel version is? Did you encounter
such a case on top of this commit [1]? If I'm correct, Eric and I
fixed this race issue a few months ago.

commit 3f4ca5fafc08881d7a57daa20449d171f2887043
Author: Jason Xing <kernelxing@tencent.com>
Date:   Wed Jan 18 09:59:41 2023 +0800

    tcp: avoid the lookup process failing to get sk in ehash table

    While one cpu is working on looking up the right socket from ehash
    table, another cpu is done deleting the request socket and is about
    to add (or is adding) the big socket from the table. It means that
    we could miss both of them, even though it has little chance.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/=
?id=3D3f4ca5fafc08881d7a57daa20449d171f2887043

Thanks,
Jason

>
> Signed-off-by: Duan Muquan <duanmuquan@baidu.com>
> ---
>  net/ipv4/inet_timewait_sock.c | 15 +++++++--------
>  net/ipv4/tcp_ipv4.c           | 13 +++++++++++++
>  2 files changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.=
c
> index 40052414c7c7..ed1f255c9aa8 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -144,14 +144,6 @@ void inet_twsk_hashdance(struct inet_timewait_sock *=
tw, struct sock *sk,
>
>         spin_lock(lock);
>
> -       inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> -
> -       /* Step 3: Remove SK from hash chain */
> -       if (__sk_nulls_del_node_init_rcu(sk))
> -               sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> -
> -       spin_unlock(lock);
> -
>         /* tw_refcnt is set to 3 because we have :
>          * - one reference for bhash chain.
>          * - one reference for ehash chain.
> @@ -162,6 +154,13 @@ void inet_twsk_hashdance(struct inet_timewait_sock *=
tw, struct sock *sk,
>          * so we are not allowed to use tw anymore.
>          */
>         refcount_set(&tw->tw_refcnt, 3);
> +       inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> +
> +       /* Step 3: Remove SK from hash chain */
> +       if (__sk_nulls_del_node_init_rcu(sk))
> +               sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> +
> +       spin_unlock(lock);
>  }
>  EXPORT_SYMBOL_GPL(inet_twsk_hashdance);
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 06d2573685ca..3e3cef202f76 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2018,6 +2018,19 @@ int tcp_v4_rcv(struct sk_buff *skb)
>         sk =3D __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo,
>                                skb, __tcp_hdrlen(th), th->source,
>                                th->dest, sdif, &refcounted);
> +
> +       /* If tw "dance" is performed on another CPU, the lookup process =
may find
> +        * no tw sock for the passive closer's FIN segment, but a listene=
r sock,
> +        * which will reset the FIN segment. If application reconnects im=
mediately
> +        * with the same source port, it will get reset because the tw so=
ck's
> +        * tw_substate is still TCP_FIN_WAIT2. Try to get the tw sock in =
another try.
> +        */
> +       if (unlikely(th->fin && sk && sk->sk_state =3D=3D TCP_LISTEN)) {
> +               sk =3D __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo=
,
> +                                      skb, __tcp_hdrlen(th), th->source,
> +                                      th->dest, sdif, &refcounted);
> +       }
> +
>         if (!sk)
>                 goto no_tcp_socket;
>
> --
> 2.32.0
>
>

