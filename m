Return-Path: <netdev+bounces-9145-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89465727814
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B1D21C20EFE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E7A6AAC;
	Thu,  8 Jun 2023 07:04:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07A963DC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:04:02 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379E82D5F
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:03:31 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f7e4953107so30005e9.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 00:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686207809; x=1688799809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBLBlBRZraZFsuuWROzlsAO1fKZv6A+p2FYudFh+qNo=;
        b=uzTvVquSTc0fr/KBMmQTnBe7QWeGIgaa7r7/LdeMoX5G9F55eM3v73OhPwug8wKhrk
         MdhT+hLAYz81ywh2mj+sTWE2j7RN0igoSiVNwxpFtNdUagtGVySw2D9i+m7XO28yywYi
         V+mQdKP254XI4TX3WpbOasoV2HwpnRC/dMEJWGyvgbctEq140l041PG3Z5Nxmsatns1u
         JgfeXMZYONpRBg88AZIZij8h+SyAzCL++VxyobWrKGU+e0o++ZuG5b0bVTU2YuSYBNcJ
         bQLzB6PhHnlDFMKGZwix7NBi9kvaN6CNeiXFe7U8SSU9ddE8L51K1QDaZNFKew1DOhoW
         FwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686207809; x=1688799809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hBLBlBRZraZFsuuWROzlsAO1fKZv6A+p2FYudFh+qNo=;
        b=TGZ/Bh7Sy1wnTYHvMdGaiDD9D6TaWn70ntCurMQW3Brq4bIVegQ1u9iIVS5tF8gKrS
         Q0DMvaS0JmhsQMZcoUrGlERZeMFleia8X2uCxxJGS3HutsswrTGybXkQbtsJB3wF3lX1
         uLrX7yaU5jb+ekCGCCXO7KW2j6fc2r+NJXcgj/e6T3M3nsClm7ceJ8qdLrC9iDhTIF7a
         o0yelxoIivIi6yboRYxNVUq+ewmXotwzgT4tlDqh+RxGSW4VX9X9a4XfFcGmzLTOpgAz
         IkKgMY0cCs3ybb8ck2zTmT2G0elBpy1WRCv+3xdtL8UK/6ENU8rTDyTOUawUiNEmg0cH
         a9hA==
X-Gm-Message-State: AC+VfDyCYLZ2AzZkAw/V+dbDN4FYW7ONYYb5A3k6lp+yIkz5W0zGf5iD
	s3Iu5xm4s5Mg7yoTJGlzim9G2uJ6gmqx873ONERXQ30dLFmG7hDlhCHREg==
X-Google-Smtp-Source: ACHHUZ7OUC+DlWO9g9IVxYpVtY+uLFfKU3EtD88DretuyjUkKFnBUy/s7K2R5a0wgfLbjoXUD15/3TMKdRJZd+KgzYQ=
X-Received: by 2002:a05:600c:3b9d:b0:3f7:7bd4:3b9d with SMTP id
 n29-20020a05600c3b9d00b003f77bd43b9dmr112555wms.6.1686207808658; Thu, 08 Jun
 2023 00:03:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606165726.1749783-1-mfreemon@cloudflare.com>
In-Reply-To: <20230606165726.1749783-1-mfreemon@cloudflare.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 8 Jun 2023 09:03:16 +0200
Message-ID: <CANn89iJLowhoLUNZAQWoo2XbwUJzvL3oBXXeMx1LYG=cYqPf-g@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: enforce receive buffer memory limits by allowing
 the tcp window to shrink
To: Mike Freemon <mfreemon@cloudflare.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 6:58=E2=80=AFPM Mike Freemon <mfreemon@cloudflare.co=
m> wrote:
>
> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
>
> Under certain circumstances, the tcp receive buffer memory limit
> set by autotuning is ignored, and the receive buffer can grow
> unrestrained until it reaches tcp_rmem[2].

tcp_rmem[2] _is_ the limit.

 'unrestrained' seems a bogus claim to me.


>
> To reproduce:  Connect a TCP session with the receiver doing
> nothing and the sender sending small packets (an infinite loop
> of socket send() with 4 bytes of payload with a sleep of 1 ms
> in between each send()).  This will fill the tcp receive buffer
> all the way to tcp_rmem[2], ignoring the autotuning limit
> (sk_rcvbuf).

autotuning means : sk_rcvbuf can grow up to tcp_rmem[2], if needed.

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
> In addition to the overallocation of memory mentioned above, this
> is also functionally incorrect, because once tcp_rmem[2] is
> reached, the receiver will drop in-window packets resulting in
> retransmissions and an eventual timeout of the tcp session.  A
> receive buffer full condition should instead result in a zero
> window and an indefinite wait.
>

I think that it is also a bogus claim.

linux TCP stack will then collapse all small buffers in receiver queue
to make room.

Look at tcp_collapse_one(), tcp_collapse(), tcp_collapse_ofo_queue(),
tcp_prune_queue(),


> In practice, this problem is largely hidden for most flows.  It
> is not applicable to mice flows.  Elephant flows can send data
> fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
> triggering a zero window.
>
> But this problem does show up for other types of flows.  A good
> example are websockets and other type of flows that send small
> amounts of data spaced apart slightly in time.  In these cases,
> we directly encounter the problem described in [1].
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
> the following sysctl:
>
> sysctl: net.ipv4.tcp_shrink_window
>
> This sysctl changes how the TCP window is calculated.
>
> If sysctl tcp_shrink_window is zero (the default value), then the
> window is never shrunk.
>
> If sysctl tcp_shrink_window is non-zero, then the memory limit
> set by autotuning is honored.  This requires that the TCP window
> be shrunk ("retracted") as described in RFC 1122.
>
> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> [4] https://www.rfc-editor.org/rfc/rfc793
> [5] https://www.rfc-editor.org/rfc/rfc1323
>
> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 14 ++++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/sysctl_net_ipv4.c             |  9 ++++
>  net/ipv4/tcp_ipv4.c                    |  2 +
>  net/ipv4/tcp_output.c                  | 59 +++++++++++++++++++-------
>  5 files changed, 70 insertions(+), 15 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/netwo=
rking/ip-sysctl.rst
> index 3f6d3d5f56..96cd82b3c9 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -981,6 +981,20 @@ tcp_tw_reuse - INTEGER
>  tcp_window_scaling - BOOLEAN
>         Enable window scaling as defined in RFC1323.
>
> +tcp_shrink_window - BOOLEAN
> +       This changes how the TCP receive window is calculated when window
> +       scaling is in effect.
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
> index a4efb7a279..f003747181 100644
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
> index 6ae3345a3b..c1fe66b32e 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -1480,6 +1480,15 @@ static struct ctl_table ipv4_net_table[] =3D {
>                 .extra1 =3D SYSCTL_ZERO,
>                 .extra2 =3D &tcp_syn_linear_timeouts_max,
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
> index 53e9ce2f05..637f112296 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -3280,6 +3280,8 @@ static int __net_init tcp_sk_init(struct net *net)
>                 net->ipv4.tcp_congestion_control =3D &tcp_reno;
>
>         net->ipv4.sysctl_tcp_syn_linear_timeouts =3D 4;
> +       net->ipv4.sysctl_tcp_shrink_window =3D 0;
> +
>         return 0;
>  }
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index cfe128b81a..6bdd597160 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -260,8 +260,8 @@ static u16 tcp_select_window(struct sock *sk)
>         u32 old_win =3D tp->rcv_wnd;
>         u32 cur_win =3D tcp_receive_window(tp);
>         u32 new_win =3D __tcp_select_window(sk);
> +       struct net *net =3D sock_net(sk);
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
> +               if (!net->ipv4.sysctl_tcp_shrink_window) {


if (!READ_ONCE(...)) {

> +                       /* Never shrink the offered window */
> +                       if (new_win =3D=3D 0)
> +                               NET_INC_STATS(sock_net(sk),
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
> @@ -2947,6 +2951,7 @@ u32 __tcp_select_window(struct sock *sk)
>  {
>         struct inet_connection_sock *icsk =3D inet_csk(sk);
>         struct tcp_sock *tp =3D tcp_sk(sk);
> +       struct net *net =3D sock_net(sk);
>         /* MSS for the peer's data.  Previous versions used mss_clamp
>          * here.  I don't know if the value based on our guesses
>          * of peer's MSS is better for the performance.  It's more correc=
t
> @@ -2968,16 +2973,24 @@ u32 __tcp_select_window(struct sock *sk)
>                 if (mss <=3D 0)
>                         return 0;
>         }
> +
> +       if (net->ipv4.sysctl_tcp_shrink_window) {

READ_ONCE()

> +               /* new window should always be an exact multiple of scali=
ng factor */
> +               free_space =3D round_down(free_space, 1 << tp->rx_opt.rcv=
_wscale);
> +       }
> +
>         if (free_space < (full_space >> 1)) {
>                 icsk->icsk_ack.quick =3D 0;
>
>                 if (tcp_under_memory_pressure(sk))
>                         tcp_adjust_rcv_ssthresh(sk);
>
> -               /* free_space might become our new window, make sure we d=
on't
> -                * increase it due to wscale.
> -                */
> -               free_space =3D round_down(free_space, 1 << tp->rx_opt.rcv=
_wscale);
> +               if (!net->ipv4.sysctl_tcp_shrink_window) {

READ_ONCE()

hint : really read once this sysctl in __tcp_select_window() and cache
its value in an auto variable.

> +                       /* free_space might become our new window, make s=
ure we don't
> +                        * increase it due to wscale.
> +                        */
> +                       free_space =3D round_down(free_space, 1 << tp->rx=
_opt.rcv_wscale);
> +               }
>
>                 /* if free space is less than mss estimate, or is below 1=
/16th
>                  * of the maximum allowed, try to move to zero-window, el=
se
> @@ -2988,10 +3001,24 @@ u32 __tcp_select_window(struct sock *sk)
>                  */
>                 if (free_space < (allowed_space >> 4) || free_space < mss=
)
>                         return 0;
> +
> +               if (net->ipv4.sysctl_tcp_shrink_window && free_space < (1=
 << tp->rx_opt.rcv_wscale))

Use the cached value

> +                       return 0;
>         }
>
> -       if (free_space > tp->rcv_ssthresh)
> +       if (free_space > tp->rcv_ssthresh) {
>                 free_space =3D tp->rcv_ssthresh;
> +               if (net->ipv4.sysctl_tcp_shrink_window) {

You added too much code in the fast path.

I would prefer you refactor your patch to test the sysctl once, only
in the 'danger' zone
and eventually copy paste the relevant code, instead of adding many
conditional tests
and slow down the fast path.

> +                       /* new window should always be an exact multiple =
of scaling factor
> +                        *
> +                        * For this case, we ALIGN "up" (increase free_sp=
ace) because
> +                        * we know free_space is not zero here, it has be=
en reduced from
> +                        * the memory-based limit, and rcv_ssthresh is no=
t a hard limit
> +                        * (unlike sk_rcvbuf).
> +                        */
> +                       free_space =3D ALIGN(free_space, (1 << tp->rx_opt=
.rcv_wscale));
> +               }
> +       }
>
>         /* Don't do rounding if we are using window scaling, since the
>          * scaled window will not line up with the MSS boundary anyway.
> @@ -2999,11 +3026,13 @@ u32 __tcp_select_window(struct sock *sk)
>         if (tp->rx_opt.rcv_wscale) {
>                 window =3D free_space;
>
> -               /* Advertise enough space so that it won't get scaled awa=
y.
> -                * Import case: prevent zero window announcement if
> -                * 1<<rcv_wscale > mss.
> -                */
> -               window =3D ALIGN(window, (1 << tp->rx_opt.rcv_wscale));
> +               if (!net->ipv4.sysctl_tcp_shrink_window) {
> +                       /* Advertise enough space so that it won't get sc=
aled away.
> +                        * Import case: prevent zero window announcement =
if
> +                        * 1<<rcv_wscale > mss.
> +                        */
> +                       window =3D ALIGN(window, (1 << tp->rx_opt.rcv_wsc=
ale));
> +               }
>         } else {
>                 window =3D tp->rcv_wnd;
>                 /* Get the largest window that is a nice multiple of mss.
> --
> 2.40.0
>

Thanks.

