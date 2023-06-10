Return-Path: <netdev+bounces-9777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 616D872A7CB
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1A051C209AA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF681C07;
	Sat, 10 Jun 2023 01:44:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EED1860
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:44:10 +0000 (UTC)
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC2D26B9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:44:08 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-33bf12b5fb5so23825ab.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 18:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686361448; x=1688953448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXbPi+PetY1hYCaf5zW8aQavhoMsH2ojZAhY0xAMuSM=;
        b=0IKCFWcm04Kuh8pNDmPqlefaFoDfukQ0EMCG28jHWSgWJ7c60vbwVSYiZsK3QJyLxK
         gmItPf4OjGEX9poidwMdOnfCCvqAqPxoJD+uWoAxPe45u2g0eMy7ltp+1ntWc31n1YWQ
         sbJScPwvylu47x5YkHSHNYE8aykfla1ADwreLLJ9wf5fAtwYoxksXUbkBaLXcTee2/Ip
         7XowbwIuUQP5RHUB17V8MtuUIWczVMkqNgIHvD0PrF6sjmKRRVMN4BIXaNqdUnyX9Dti
         FXsXoPp0173hcPzI+oG9cFAhwHqTdb5CD6dLtnuDhmdWD1jZRtjQQQs/bdhvtnIMamRk
         7dGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686361448; x=1688953448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fXbPi+PetY1hYCaf5zW8aQavhoMsH2ojZAhY0xAMuSM=;
        b=ewi/x9+Zrbln4/YBvXEgbPEBf+sTWZtNvUr+O6EDH70IpH1vo29LScwSiUcE58J4lY
         Pjl6zWd7x5yJCWROs7hOpSkfyqKTgGAsa0IMA26pWfbdr/d0/C12LheCSZHWuP9cENdR
         mZTXxHGvWkLIuIFRraC2srkzqdeeh8FzqigLazrUtK65o3L/VObS4AAZ1GfHlgg5iBi4
         t7qIkvP0k2WqK4EBuC+hqFm9CNUj+DVbAni9/IwEOVVpB+fnxrXloFyn9B7Y5HKs7qqr
         ikAszz9XCw9IM+WP+Uvv4iAIZVcrTe9mPflba5AOf5AGU613+dW4/YEh286oMseFjHnc
         /NrA==
X-Gm-Message-State: AC+VfDyqYIRQIbqvlNQhAEa6u4PMBprS5n5YVKMFyOJyf9CsxX8+/iML
	8awAuui7snp6ppmnF8nZum6n0iS9DPtxUntVtbw7hSiOkO6y+TT+mjT+9g==
X-Google-Smtp-Source: ACHHUZ6BOEPzQ7ZbRPOdffK/TXLW0pzm/c48CEYgxL8c7F/K/B43qIC68npzMI/5vLa8YTQjHNXnmF/JML3fxjbgzoQ=
X-Received: by 2002:a92:c261:0:b0:33a:e716:a76a with SMTP id
 h1-20020a92c261000000b0033ae716a76amr53574ild.24.1686361447578; Fri, 09 Jun
 2023 18:44:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609204706.2044591-1-mfreemon@cloudflare.com>
In-Reply-To: <20230609204706.2044591-1-mfreemon@cloudflare.com>
From: Eric Dumazet <edumazet@google.com>
Date: Sat, 10 Jun 2023 03:43:55 +0200
Message-ID: <CANn89iK+Zged71Hc74Rwk31XdTNiakUnf+yqHDrx1pYKgrnaRw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] tcp: enforce receive buffer memory limits by
 allowing the tcp window to shrink
To: Mike Freemon <mfreemon@cloudflare.com>, Neal Cardwell <ncardwell@google.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 10:47=E2=80=AFPM Mike Freemon <mfreemon@cloudflare.c=
om> wrote:
>
> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
>
> Under certain circumstances, the tcp receive buffer memory limit
> set by autotuning (sk_rcvbuf) is increased due to incoming data
> packets as a result of the window not closing when it should be.
> This can result in the receive buffer growing all the way up to
> tcp_rmem[2], even for tcp sessions with a low BDP.
>
> To reproduce:  Connect a TCP session with the receiver doing
> nothing and the sender sending small packets (an infinite loop
> of socket send() with 4 bytes of payload with a sleep of 1 ms
> in between each send()).  This will cause the tcp receive buffer
> to grow all the way up to tcp_rmem[2].
>
> As a result, a host can have individual tcp sessions with receive
> buffers of size tcp_rmem[2], and the host itself can reach tcp_mem
> limits, causing the host to go into tcp memory pressure mode.
>
> The fundamental issue is the relationship between the granularity
> of the window scaling factor and the number of byte ACKed back
> to the sender.  This problem has previously been identified in
> RFC 7323, appendix F [1].
>
> The Linux kernel currently adheres to never shrinking the window.
>
> In addition to the overallocation of memory mentioned above, the
> current behavior is functionally incorrect, because once tcp_rmem[2]
> is reached when no remediations remain (i.e. tcp collapse fails to
> free up any more memory and there are no packets to prune from the
> out-of-order queue), the receiver will drop in-window packets
> resulting in retransmissions and an eventual timeout of the tcp
> session.  A receive buffer full condition should instead result
> in a zero window and an indefinite wait.
>
> In practice, this problem is largely hidden for most flows.  It
> is not applicable to mice flows.  Elephant flows can send data
> fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
> triggering a zero window.
>
> But this problem does show up for other types of flows.  Examples
> are websockets and other type of flows that send small amounts of
> data spaced apart slightly in time.  In these cases, we directly
> encounter the problem described in [1].
>
> RFC 7323, section 2.4 [2], says there are instances when a retracted
> window can be offered, and that TCP implementations MUST ensure
> that they handle a shrinking window, as specified in RFC 1122,
> section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
> management have made clear that sender must accept a shrunk window
> from the receiver, including RFC 793 [4] and RFC 1323 [5].
>
> This patch implements the functionality to shrink the tcp window
> when necessary to keep the right edge within the memory limit by
> autotuning (sk_rcvbuf).  This new functionality is enabled with
> the new sysctl: net.ipv4.tcp_shrink_window
>
> Additional information can be found at:
> https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-buf=
fers-and-how-we-fixed-it/
>
> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> [4] https://www.rfc-editor.org/rfc/rfc793
> [5] https://www.rfc-editor.org/rfc/rfc1323
>
> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 13 +++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/sysctl_net_ipv4.c             |  9 ++++
>  net/ipv4/tcp_ipv4.c                    |  2 +
>  net/ipv4/tcp_output.c                  | 73 ++++++++++++++++++++++++--
>  5 files changed, 93 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/netwo=
rking/ip-sysctl.rst
> index 366e2a5097d9..ddb895e8af56 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -981,6 +981,19 @@ tcp_tw_reuse - INTEGER
>  tcp_window_scaling - BOOLEAN
>         Enable window scaling as defined in RFC1323.
>
> +tcp_shrink_window - BOOLEAN
> +       This changes how the TCP receive window is calculated.
> +
> +       RFC 7323, section 2.4, says there are instances when a retracted
> +       window can be offered, and that TCP implementations MUST ensure
> +       that they handle a shrinking window, as specified in RFC 1122.
> +
> +       - 0 - Disabled. The window is never shrunk.
> +       - 1 - Enabled.  The window is shrunk when necessary to remain wit=
hin
> +                       the memory limit set by autotuning (sk_rcvbuf).
> +
> +       Default: 0
> +
>  tcp_wmem - vector of 3 INTEGERs: min, default, max
>         min: Amount of memory reserved for send buffers for TCP sockets.
>         Each TCP socket has rights to use it due to fact of its birth.
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index a4efb7a2796c..f00374718159 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -65,6 +65,7 @@ struct netns_ipv4 {
>  #endif
>         bool                    fib_has_custom_local_routes;
>         bool                    fib_offload_disabled;
> +       u8                      sysctl_tcp_shrink_window;
>  #ifdef CONFIG_IP_ROUTE_CLASSID
>         atomic_t                fib_num_tclassid_users;
>  #endif
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 356afe54951c..2afb0870648b 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -1480,6 +1480,15 @@ static struct ctl_table ipv4_net_table[] =3D {
>                 .extra1         =3D SYSCTL_ZERO,
>                 .extra2         =3D &tcp_syn_linear_timeouts_max,
>         },
> +       {
> +               .procname       =3D "tcp_shrink_window",
> +               .data           =3D &init_net.ipv4.sysctl_tcp_shrink_wind=
ow,
> +               .maxlen         =3D sizeof(u8),
> +               .mode           =3D 0644,
> +               .proc_handler   =3D proc_dou8vec_minmax,
> +               .extra1         =3D SYSCTL_ZERO,
> +               .extra2         =3D SYSCTL_ONE,
> +       },
>         { }
>  };
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 84a5d557dc1a..9213804b034f 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -3281,6 +3281,8 @@ static int __net_init tcp_sk_init(struct net *net)
>                 net->ipv4.tcp_congestion_control =3D &tcp_reno;
>
>         net->ipv4.sysctl_tcp_syn_linear_timeouts =3D 4;
> +       net->ipv4.sysctl_tcp_shrink_window =3D 0;
> +
>         return 0;
>  }
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index f8ce77ce7c3e..5c86873e2193 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -260,8 +260,8 @@ static u16 tcp_select_window(struct sock *sk)
>         u32 old_win =3D tp->rcv_wnd;
>         u32 cur_win =3D tcp_receive_window(tp);
>         u32 new_win =3D __tcp_select_window(sk);
> +       struct net *net =3D sock_net(sk);

Here you cache sock_net() in @net variable.

>
> -       /* Never shrink the offered window */
>         if (new_win < cur_win) {
>                 /* Danger Will Robinson!
>                  * Don't update rcv_wup/rcv_wnd here or else
> @@ -270,11 +270,15 @@ static u16 tcp_select_window(struct sock *sk)
>                  *
>                  * Relax Will Robinson.
>                  */
> -               if (new_win =3D=3D 0)
> -                       NET_INC_STATS(sock_net(sk),
> -                                     LINUX_MIB_TCPWANTZEROWINDOWADV);
> -               new_win =3D ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
> +               if (!READ_ONCE(net->ipv4.sysctl_tcp_shrink_window)) {
> +                       /* Never shrink the offered window */
> +                       if (new_win =3D=3D 0)
> +                               NET_INC_STATS(sock_net(sk),

You then can replace sock_net(sk) by @net here.

> +                                             LINUX_MIB_TCPWANTZEROWINDOW=
ADV);
> +                       new_win =3D ALIGN(cur_win, 1 << tp->rx_opt.rcv_ws=
cale);
> +               }
>         }
> +
>         tp->rcv_wnd =3D new_win;
>         tp->rcv_wup =3D tp->rcv_nxt;
>
> @@ -3003,6 +3007,7 @@ u32 __tcp_select_window(struct sock *sk)
>  {
>         struct inet_connection_sock *icsk =3D inet_csk(sk);
>         struct tcp_sock *tp =3D tcp_sk(sk);
> +       struct net *net =3D sock_net(sk);
>         /* MSS for the peer's data.  Previous versions used mss_clamp
>          * here.  I don't know if the value based on our guesses
>          * of peer's MSS is better for the performance.  It's more correc=
t
> @@ -3024,6 +3029,12 @@ u32 __tcp_select_window(struct sock *sk)
>                 if (mss <=3D 0)
>                         return 0;
>         }
> +
> +       if (READ_ONCE(net->ipv4.sysctl_tcp_shrink_window))
> +               goto shrink_window_allowed;
> +
> +       /* do not allow window to shrink */
> +
>         if (free_space < (full_space >> 1)) {
>                 icsk->icsk_ack.quick =3D 0;
>
> @@ -3077,6 +3088,58 @@ u32 __tcp_select_window(struct sock *sk)
>                         window =3D free_space;
>         }
>
> +       return window;
> +
> +shrink_window_allowed:
> +       /* new window should always be an exact multiple of scaling facto=
r */
> +       free_space =3D round_down(free_space, 1 << tp->rx_opt.rcv_wscale)=
;
> +
> +       if (free_space < (full_space >> 1)) {
> +               icsk->icsk_ack.quick =3D 0;
> +
> +               if (tcp_under_memory_pressure(sk))
> +                       tcp_adjust_rcv_ssthresh(sk);
> +
> +               /* if free space is too low, return a zero window */
> +               if (free_space < (allowed_space >> 4) || free_space < mss=
 ||
> +                       free_space < (1 << tp->rx_opt.rcv_wscale))
> +                       return 0;

Are you sure this block can not be shared with the existing one ?

Existing one has this added part:

free_space =3D round_down(free_space, 1 << tp->rx_opt.rcv_wscale);

Not sure why this would break the tcp_shrink_window =3D=3D 1 case.


> +       }
> +
> +       if (free_space > tp->rcv_ssthresh) {
> +               free_space =3D tp->rcv_ssthresh;
> +               /* new window should always be an exact multiple of scali=
ng factor
> +                *
> +                * For this case, we ALIGN "up" (increase free_space) bec=
ause
> +                * we know free_space is not zero here, it has been reduc=
ed from
> +                * the memory-based limit, and rcv_ssthresh is not a hard=
 limit
> +                * (unlike sk_rcvbuf).
> +                */
> +               free_space =3D ALIGN(free_space, (1 << tp->rx_opt.rcv_wsc=
ale));
> +       }
> +
> +       /* Don't do rounding if we are using window scaling, since the
> +        * scaled window will not line up with the MSS boundary anyway.
> +        */
> +       if (tp->rx_opt.rcv_wscale) {
> +               window =3D free_space;
> +       } else {
> +               window =3D tp->rcv_wnd;
> +               /* Get the largest window that is a nice multiple of mss.
> +                * Window clamp already applied above.
> +                * If our current window offering is within 1 mss of the
> +                * free space we just keep it. This prevents the divide
> +                * and multiply from happening most of the time.
> +                * We also don't do any window rounding when the free spa=
ce
> +                * is too small.
> +                */
> +               if (window <=3D free_space - mss || window > free_space)
> +                       window =3D rounddown(free_space, mss);
> +               else if (mss =3D=3D full_space &&
> +                        free_space > window + (full_space >> 1))
> +                       window =3D free_space;
> +       }
> +

I am a bit surprised we can not come up with something simpler.

I was suggesting to look at the sysctl only if we were in a dangerous opera=
tion,


Neal, can you have a look ?

Thanks.

