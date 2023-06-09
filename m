Return-Path: <netdev+bounces-9686-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 071C072A2F3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60DF01C20D1F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D701951A;
	Fri,  9 Jun 2023 19:16:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F021C766
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:16:22 +0000 (UTC)
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5C62D52
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:16:19 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id a1e0cc1a2514c-78a3e1ed1deso763015241.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 12:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686338178; x=1688930178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUU4mHiCaJnsYdLSLDNDPQbH7EPJVZOkKfM8mpwmd7c=;
        b=3IlUpfMoGnRp8Z9PeqP5F+0Q6bzOTxOgb/Guzl/PVwcqC0562hAJUSqH62tH3HOyH1
         JG0tKzNunIlo8Xqb/ZPCrZ0lWLUwDc/EzmqFtL8x05LzzKgaNMOaP12GZoVAdqfUzuxr
         pDbhk+Gx9t8btwa8ED5UNXdJGFW64pjCs9aBtLCXfcA//S0oaOjNjFvLFKOWDZdi6x5F
         A316dFVbwjvz59unCE4L71AmR2cvSxVHjIc7xURwqRO1QSis9qvWTcpQKMt7kAROYlsp
         2OxpnYKEb/bvcNQtp2oTdva5bCQ7TapQOjIQZZYYizNjGMKDTrH6TINMg5uciCZMyqRP
         MQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686338178; x=1688930178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUU4mHiCaJnsYdLSLDNDPQbH7EPJVZOkKfM8mpwmd7c=;
        b=f0p9XHX1gb+h00Y/oJvhjxd724me5ytTbgxXMFnnNgz4LjGk88jWFLEpfNERwsfxqU
         oi0GJVLjys599fGb6mzK8n9GipIsRSmp34Fi5V7PvGimrHFNzGZx9WgkiuRZFZD/4nju
         SUArGgCjGO0o6N48bIeRqbkhG9Zxs1g59pFErPfeVztgmVQE+dtt57cbwy7x5PtRElG2
         1XcDlwLZ4EY66+qGhZ+s/eud00r4yInDwRC6FO9xiHXRFThq6OdA/56gtNZkhUi2+O0c
         C8ETL4zUW5drnGSxgYC9xCusQf43B43VRzXEoDnLabEytNeElL9JCPsla8QDRNxLM1C4
         JWIw==
X-Gm-Message-State: AC+VfDz7U1cTce4SMPuB7zkCVYcoyf7f7um2hWM1nBUER7lLk2bO+KPD
	U0VwU1b9NXhxL+1QbexhlUXHUhTpaBuIWCkPzTOUzg==
X-Google-Smtp-Source: ACHHUZ67FRH7U3XLkJ0HdCvflbCs+SWsGDKQdcRZArXF2P89dS4FWUjM+kw2HXwxXf/mMMgyDZSwU6MuDExEOxTsy50=
X-Received: by 2002:a05:6102:c7:b0:43d:c2a4:cdd4 with SMTP id
 u7-20020a05610200c700b0043dc2a4cdd4mr1546677vsp.34.1686338177670; Fri, 09 Jun
 2023 12:16:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1686327959-13478-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1686327959-13478-1-git-send-email-haiyangz@microsoft.com>
From: Neal Cardwell <ncardwell@google.com>
Date: Fri, 9 Jun 2023 15:16:00 -0400
Message-ID: <CADVnQykbSQTrNtpFm8YVgGY929mmzY2zSQ2-KxGmNthYyR9GLg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Make pingpong threshold tunable
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, kys@microsoft.com, 
	olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net, weiwan@google.com, 
	tim.gardner@canonical.com, corbet@lwn.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, dsahern@kernel.org, atenart@kernel.org, 
	bagasdotme@gmail.com, ykaliuta@redhat.com, kuniyu@amazon.com, 
	stephen@networkplumber.org, simon.horman@corigine.com, maheshb@google.com, 
	liushixin2@huawei.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yuchung Cheng <ycheng@google.com>, 
	Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 12:26=E2=80=AFPM Haiyang Zhang <haiyangz@microsoft.c=
om> wrote:

Regarding the patch title:
> [PATCH net-next] tcp: Make pingpong threshold tunable

There are many ways to make something tunable these days, including
BPF, setsockopt(), and sysctl. :-) This patch only uses sysctl. Please
consider a more clear/specific title, like:

   [PATCH net-next] tcp: set pingpong threshold via sysctl

> TCP pingpong threshold is 1 by default. But some applications, like SQL D=
B
> may prefer a higher pingpong threshold to activate delayed acks in quick
> ack mode for better performance.
>
> The pingpong threshold and related code were changed to 3 in the year
> 2019, and reverted to 1 in the year 2022.

Please include the specific commit, like:

The pingpong threshold and related code were changed to 3 in the year
 2019 in:
   commit 4a41f453bedf ("tcp: change pingpong threshold to 3")
and reverted to 1 in the year 2022 in:
  commit 4d8f24eeedc5 ("Revert "tcp: change pingpong threshold to 3"")

Then please make sure to use scripts/checkpatch.pl on your resulting
patch to check the formatting of the commit references, among other
things.

> There is no single value that
> fits all applications.
>
> Add net.core.tcp_pingpong_thresh sysctl tunable,

For consistency, TCP sysctls should be in net.ipv4 rather than
net.core. Yes, that is awkward, given IPv6 support. But consistency is
very important here. :-)

> so it can be tuned for
> optimal performance based on the application needs.
>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  Documentation/admin-guide/sysctl/net.rst |  8 ++++++++
>  include/net/inet_connection_sock.h       | 14 +++++++++++---
>  net/core/sysctl_net_core.c               |  9 +++++++++
>  net/ipv4/tcp.c                           |  2 ++
>  net/ipv4/tcp_output.c                    | 17 +++++++++++++++--
>  5 files changed, 45 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/adm=
in-guide/sysctl/net.rst
> index 4877563241f3..16f54be9461f 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -413,6 +413,14 @@ historical importance.
>
>  Default: 0
>
> +tcp_pingpong_thresh
> +-------------------
> +
> +TCP pingpong threshold is 1 by default, but some application may need a =
higher
> +threshold for optimal performance.
> +
> +Default: 1, min: 1, max: 3

If we want to make this tunable, it seems sad to make the max 3. I'd
suggest making the max 255, since we have 8 bits of space anyway in
the inet_csk(sk)->icsk_ack.pingpong field.

> +
>  2. /proc/sys/net/unix - Parameters for Unix domain sockets
>  ----------------------------------------------------------
>
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connec=
tion_sock.h
> index c2b15f7e5516..e84e33ddae49 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -324,11 +324,11 @@ void inet_csk_update_fastreuse(struct inet_bind_buc=
ket *tb,
>
>  struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
>
> -#define TCP_PINGPONG_THRESH    1
> +extern int tcp_pingpong_thresh;

To match most TCP sysctls, this should be per-namespace, rather than global=
.

Please follow a recent example by Eric, perhaps:
 65466904b015f6eeb9225b51aeb29b01a1d4b59c
  tcp: adjust TSO packet sizes based on min_rtt


>
>  static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
>  {
> -       inet_csk(sk)->icsk_ack.pingpong =3D TCP_PINGPONG_THRESH;
> +       inet_csk(sk)->icsk_ack.pingpong =3D tcp_pingpong_thresh;
>  }

  inet_csk(sk)->icsk_ack.pingpong =3D  sock_net(sk)->sysctl_tcp_pingpong_th=
resh;

>  static inline void inet_csk_exit_pingpong_mode(struct sock *sk)
> @@ -338,7 +338,15 @@ static inline void inet_csk_exit_pingpong_mode(struc=
t sock *sk)
>
>  static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
>  {
> -       return inet_csk(sk)->icsk_ack.pingpong >=3D TCP_PINGPONG_THRESH;
> +       return inet_csk(sk)->icsk_ack.pingpong >=3D tcp_pingpong_thresh;
> +}

Again, sock_net(sk)->sysctl_tcp_pingpong_thresh rather than tcp_pingpong_th=
resh.

> +static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
> +{
> +       struct inet_connection_sock *icsk =3D inet_csk(sk);
> +
> +       if (icsk->icsk_ack.pingpong < U8_MAX)
> +               icsk->icsk_ack.pingpong++;
>  }
>
>  static inline bool inet_csk_has_ulp(struct sock *sk)
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 782273bb93c2..b5253567f2bd 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -653,6 +653,15 @@ static struct ctl_table net_core_table[] =3D {

Again, in net.ipv4, not net.core.

>                 .proc_handler   =3D proc_dointvec_minmax,
>                 .extra1         =3D SYSCTL_ZERO,
>         },
> +       {
> +               .procname       =3D "tcp_pingpong_thresh",
> +               .data           =3D &tcp_pingpong_thresh,
> +               .maxlen         =3D sizeof(int),
> +               .mode           =3D 0644,
> +               .proc_handler   =3D proc_dointvec_minmax,
> +               .extra1         =3D SYSCTL_ONE,
> +               .extra2         =3D SYSCTL_THREE,

Please make the max U8_MAX to allow more flexibility (since we have 8
bits of space anyway in the inet_csk(sk)->icsk_ack.pingpong field).

> +       },
>         { }
>  };
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 53b7751b68e1..dcd143193d41 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -308,6 +308,8 @@ EXPORT_SYMBOL(tcp_have_smc);
>  struct percpu_counter tcp_sockets_allocated ____cacheline_aligned_in_smp=
;
>  EXPORT_SYMBOL(tcp_sockets_allocated);
>
> +int tcp_pingpong_thresh __read_mostly =3D 1;
> +

Again, per-network-namespace. You will need to initialize the
per-netns value in tcp_sk_init(). Again, see Eric's
65466904b015f6eeb9225b51aeb29b01a1d4b59c commit for an example.

>   * TCP splice context
>   */
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index cfe128b81a01..576d21621778 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -167,12 +167,25 @@ static void tcp_event_data_sent(struct tcp_sock *tp=
,
>         if (tcp_packets_in_flight(tp) =3D=3D 0)
>                 tcp_ca_event(sk, CA_EVENT_TX_START);
>
> +       /* If tcp_pingpong_thresh > 1, and
> +        * this is the first data packet sent in response to the
> +        * previous received data,
> +        * and it is a reply for ato after last received packet,
> +        * increase pingpong count.
> +        */
> +       if (tcp_pingpong_thresh > 1 &&
> +           before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> +           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> +               inet_csk_inc_pingpong_cnt(sk);
> +

Introducing this new code re-introduces a bug fixed in 4d8f24eeedc5.
As that commit description noted:

    This to-be-reverted commit was meant to apply a stricter rule for the
    stack to enter pingpong mode. However, the condition used to check for
    interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
    jiffy based and might be too coarse, which delays the stack entering
    pingpong mode.
    We revert this patch so that we no longer use the above condition to
    determine interactive session,

>         tp->lsndtime =3D now;
>
> -       /* If it is a reply for ato after last received
> +       /* If tcp_pingpong_thresh =3D=3D 1, and

Please remove the "If tcp_pingpong_thresh =3D=3D 1, and" part, since this
is the correct code path no matter the value of the threshold.

> +        * it is a reply for ato after last received
>          * packet, enter pingpong mode.
>          */
> -       if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> +       if (tcp_pingpong_thresh =3D=3D 1 &&

Please remove the "if (tcp_pingpong_thresh =3D=3D 1 &&" part, since this
is the correct code path no matter the value of the threshold.

> +           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
>                 inet_csk_enter_pingpong_mode(sk);

Please make this call inet_csk_inc_pingpong_cnt(), since this is the
correct code path no matter the value of the threshold.

thanks,
neal

