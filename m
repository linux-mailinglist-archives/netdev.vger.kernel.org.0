Return-Path: <netdev+bounces-3372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A8B706B80
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 763DC1C20F18
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A043C28FC;
	Wed, 17 May 2023 14:45:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ACC1C26
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:45:11 +0000 (UTC)
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952F383F3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:45:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ac65ab7432so180445ad.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684334707; x=1686926707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eXK4VuEhRrdlXr9s0TGyYpU2HIuaGRvKgTAB1adrGUY=;
        b=QEl775A8qjkIJBIayWit1vzN6pBOAivDeSl5IMBWZR+7gvtFMbxz7UKcBVdnvWSV2v
         ZFUB9SivkD7xYkZiGIKnYfU07YzvNRRwuGjm7mJS/L3YzYOdyobFIbUW0LBo3NSMf0tC
         CA39Y2dB8dXm2/M+fRGPEyME54cvrx6WGcJDE5MK4pRHIId0BUW07avCFEHreB+lpiYo
         Oq6jXVpYJNMOxDFDdbJ9cD2nQSlCkVARlU7fCbWYmFeEwo2lcEsQXSTFXIllcA2b7kEd
         mH38EHmGthR/La1BJf1J499lIhrhRBLo2rm1ARoRQDM0hEbsOZtIghFUCcV2l7ievxcX
         AqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684334707; x=1686926707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eXK4VuEhRrdlXr9s0TGyYpU2HIuaGRvKgTAB1adrGUY=;
        b=hdcdRkOz3ITVj6CAUPgHew1ZVUk2j6ecgfJMT8zfrJAxU6v11LrJ/DoTk4StA8XMn8
         /DvOlWpUdw11ldoCe4WPhnwdZSBPiqsuyigHMoxvhruFWXvTTvH9UN5xsh18KJLP+O1R
         3ZUMlc2V3FBgeyp8nEysxb/K7ZC/QWadKEOTYEprwf0mHIFEUzCEA8bX757H8Zrt/uzL
         LjEuAAGbGC3yK3FKf4rQ+Wv32huVcmY+01HeDl+jM0AXnIulLPs0DG8LIW693+RDEg0y
         5j0jN9izGYBQgwLZxPb+72D+jq74Qd2YRNDXfpueAPAPj8UU3+RhKMBmeLim0CtXt/aR
         IXbQ==
X-Gm-Message-State: AC+VfDyR42L6T9nol/DgjgcdMXrQNQO7Nvrq5Co1YVizb9t64PWZxx7+
	Xqf2OlbDhe2UOP2qkDpCe2UzU2So/ghHco7ztHR5sg==
X-Google-Smtp-Source: ACHHUZ7WeUaPBxc6UaAB56D6XktudU+gpNbeuxx0EJw4PCiBV7GDUq6YBU5J6W2iCWUClO8C0AgqZ0N+byeG6R1Diq8=
X-Received: by 2002:a17:902:c94b:b0:1ac:9cad:1838 with SMTP id
 i11-20020a170902c94b00b001ac9cad1838mr391034pla.10.1684334706449; Wed, 17 May
 2023 07:45:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com> <20230517124201.441634-3-imagedong@tencent.com>
In-Reply-To: <20230517124201.441634-3-imagedong@tencent.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 May 2023 16:44:55 +0200
Message-ID: <CANn89iKGTPHK5wMyP4oRoAuv8f56VY-RrrMPBSb8jRMJSiL5Qg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: tcp: send zero-window when no memory
To: menglong8.dong@gmail.com
Cc: kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com, 
	dsahern@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> For now, skb will be dropped when no memory, which makes client keep
> retrans util timeout and it's not friendly to the users.

Yes, networking needs memory. Trying to deny it is recipe for OOM.

>
> Therefore, now we force to receive one packet on current socket when
> the protocol memory is out of the limitation. Then, this socket will
> stay in 'no mem' status, util protocol memory is available.
>

I think you missed one old patch.

commit ba3bb0e76ccd464bb66665a1941fabe55dadb3ba    tcp: fix
SO_RCVLOWAT possible hangs under high mem pressure



> When a socket is in 'no mem' status, it's receive window will become
> 0, which means window shrink happens. And the sender need to handle
> such window shrink properly, which is done in the next commit.
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/net/sock.h    |  1 +
>  net/ipv4/tcp_input.c  | 12 ++++++++++++
>  net/ipv4/tcp_output.c |  7 +++++++
>  3 files changed, 20 insertions(+)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 5edf0038867c..90db8a1d7f31 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -957,6 +957,7 @@ enum sock_flags {
>         SOCK_XDP, /* XDP is attached */
>         SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
>         SOCK_RCVMARK, /* Receive SO_MARK  ancillary data with packet */
> +       SOCK_NO_MEM, /* protocol memory limitation happened */
>  };
>
>  #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMES=
TAMPING_RX_SOFTWARE))
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index a057330d6f59..56e395cb4554 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5047,10 +5047,22 @@ static void tcp_data_queue(struct sock *sk, struc=
t sk_buff *skb)
>                 if (skb_queue_len(&sk->sk_receive_queue) =3D=3D 0)
>                         sk_forced_mem_schedule(sk, skb->truesize);

I think you missed this part : We accept at least one packet,
regardless of memory pressure,
if the queue is empty.

So your changelog is misleading.

>                 else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
> +                       if (sysctl_tcp_wnd_shrink)

We no longer add global sysctls for TCP. All new sysctls must per net-ns.

> +                               goto do_wnd_shrink;
> +
>                         reason =3D SKB_DROP_REASON_PROTO_MEM;
>                         NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP=
);
>                         sk->sk_data_ready(sk);
>                         goto drop;
> +do_wnd_shrink:
> +                       if (sock_flag(sk, SOCK_NO_MEM)) {
> +                               NET_INC_STATS(sock_net(sk),
> +                                             LINUX_MIB_TCPRCVQDROP);
> +                               sk->sk_data_ready(sk);
> +                               goto out_of_window;
> +                       }
> +                       sk_forced_mem_schedule(sk, skb->truesize);

So now we would accept two packets per TCP socket, and yet EPOLLIN
will not be sent in time ?

packets can consume about 45*4K each, I do not think it is wise to
double receive queue sizes.

What you want instead is simply to send EPOLLIN sooner (when the first
packet is queued instead when the second packet is dropped)
by changing sk_forced_mem_schedule() a bit.

This might matter for applications using SO_RCVLOWAT, but not for
other applications.

