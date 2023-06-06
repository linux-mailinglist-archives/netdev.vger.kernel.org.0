Return-Path: <netdev+bounces-8283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B166E723860
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F2451C20D60
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1BA5668;
	Tue,  6 Jun 2023 07:07:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6453FDF
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:07:47 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C3DE47
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:07:44 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f7e4953107so29615e9.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 00:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686035263; x=1688627263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mh/Q9ExSH8PH6rQafVFdrgOp1kcbGrC6Sma+EsrSOgA=;
        b=DYJEmx4a/tObJALEFG7EuEAwywJTGI6PVfoAUiPhzhBjyCopsRlgJAMUIrOBNrWuv2
         A+XlsU1IvBStPTd/he2Qxd7KBqNwmvt+VVoa81GzKgtWg7KPrHh0q2EkBy7F1ABhUADo
         /k9jv/syrralrl0dOTe/zjzrHSGeFQpd99tRfnEw8ADGVuq9MbAde6IF1EXtR/8QRcn9
         7N663ST82p7mgCLA4Bmd96NTJRiOVb4jHZ5pS5d4io1AeuYsL29riVxcnLI8OfGhRtJB
         WjAaWDFzIwQx69+0lROTDV0NanoWI3Coc3/6CkYHvir//FDx6UaeAKoIzxHZWQSDvX/9
         H7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686035263; x=1688627263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mh/Q9ExSH8PH6rQafVFdrgOp1kcbGrC6Sma+EsrSOgA=;
        b=G8wk5qQXtcR0cx7Bgt0cbWTbkep4w8cjmGa3MhannLBH3vZyNiFI3gHY+kg238KYbj
         I487HX67wnHu7AORDJq7288AM0hMS7mWZLqJuKjjDALjqYkqi/cdVd2ZPf2s2rWzxxFv
         r8dA3E2tVC7Uuy8kHYtwjL/3eN/wG9cg4Ff2JLqA1uOFrdAc68HSWF2RZ/H4t5ZlyT1L
         Emw9GV3P1dGnilPrYjf+LcXvICTgGKlznbpcdoe4+AVq0GUe+Fqqqzl7TC6202VBbn65
         8qdQDnnhVSW3AH4kj7RSykav600TmPadUMnSqs9cPbk9wD+7N7wFXq55eWVUjFVJeww9
         CULA==
X-Gm-Message-State: AC+VfDxV2CAUL6XKiBNGO9f6UtDzvtuuwUZEjqY6ThHopAlk+4dspg80
	HgX4gXDU1Gips9/Gc0Gy9wRmLsMYDyiDtinYRnq87A==
X-Google-Smtp-Source: ACHHUZ4C3vax/6KRqduuNBUvE/SN1iYEdb5YCsbljmN9bLu8N0lPogx1+KHVd03fzB07mISQjkS9fHSsxlxTPHAOeeg=
X-Received: by 2002:a05:600c:1c16:b0:3f1:6fe9:4a95 with SMTP id
 j22-20020a05600c1c1600b003f16fe94a95mr137949wms.4.1686035263064; Tue, 06 Jun
 2023 00:07:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606064306.9192-1-duanmuquan@baidu.com>
In-Reply-To: <20230606064306.9192-1-duanmuquan@baidu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 6 Jun 2023 09:07:30 +0200
Message-ID: <CANn89iKwzEtNWME+1Xb57DcT=xpWaBf59hRT4dYrw-jsTdqeLA@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
To: Duan Muquan <duanmuquan@baidu.com>
Cc: davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 8:43=E2=80=AFAM Duan Muquan <duanmuquan@baidu.com> w=
rote:
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
> .333544] __inet_lookup_established: Failed the refcount check:
>                  !refcount_inc_not_zero 00000000690fdb7a ref 0 cookie 9 c=
pu 0
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
>                                                                 (bad case=
 (1), find sk, may fail tw_refcnt check)
> inet_twsk_add_node_tail_rcu(tw, ...)
>                                     <-__inet_lookup_established()
>                                                                 (bad case=
 (1), find sk, may fail tw_refcnt check)
>
> __sk_nulls_del_node_init_rcu(sk)
>                                     <-__inet_lookup_established()
>                                                                 (bad case=
 (2), find tw, may fail tw_refcnt check)
> refcount_set(&tw->tw_refcnt, 3)
>                                     <-__inet_lookup_established()
>                                                                 (good cas=
e, find tw, tw_refcnt is not 0)
> ...
> }
>
> This issue occurs with a small probability on our application working
> on loopback interface, client gets a connection refused error when it
> reconnects. In reproducing environments on kernel 4.14,5.10 and
> 6.4-rc1, modify tcp_ack_snd_check() to disable delay ack all the
> time; Let client connect server and server sends a message to client
> then close the connection; Repeat this process forever; Let the client
> bind the same source port every time, it can be reproduced in about 20
> minutes.
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
>   (3) For versions without Eric and Jason's commit(3f4ca5fafc08881d7a5
>           7daa20449d171f2887043), tw sock is added to the head of the lis=
t.
>           It will be missed if the list is traversed before tw sock is
>           added. And if the original sock is removed before it is found, =
no
>           established sock will be found.
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
> For bad case (2):
> Set tw_refcnt to 3 before adding it into list.
>
> For bad case (1):
> In function tcp_v4_rcv(), if __inet_lookup_skb() returns a listener
> sock and this segment has FIN bit set, then retry the lookup process
> one time. This fix can cover bad case (3) for the versions without
> Eric and Jason's fix.
>
> There may be another bad case, if the original sock is found and passes
> validation, but during further process for the passive closer's FIN on
> CPU 1, the sock has been destroyed on CPU 0, then the FIN segment will
> be dropped and retransmitted. This case does not hurt application as
> much as resetting reconnection, and this case has less possibility than
> the other bad cases, it does not occur on our product and in
> experimental environment, so it is not considered in this patch.
>
> Could you please check whether this fix is OK, or any suggestions?
> Looking forward for your precious comments!
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

I do not think this fixes anything, there is no barrier between first
and second lookup.
This might reduce race a little bit, but at the expense of extra code
in the fast path.

If you want to fix this properly, I think we need to revisit handling
for non established sockets,
to hold the bucket spinlock over the whole thing.

This will be slightly more complex than this...

