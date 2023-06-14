Return-Path: <netdev+bounces-10650-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D66D72F8D4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA4781C20CAF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFA753A7;
	Wed, 14 Jun 2023 09:16:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781E63D6C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:16:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4925110C2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686734166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3UnpM1hYXHgi+RACcSHlHZK3M8/2f7XZo9VS6GGF8FY=;
	b=SNRtKMzpBC8aQ7V3RAMNdBckvOPylEgfQAUU5CoXvASXF80b5twvvjjFxwje/s2g1rJ+n/
	GhMM/fkdwi73CiDALd0iLEAP/2Eh1bpu/AsqmxDBSoW2pj6eRbRnbH21NXlhIhcIfDstLR
	sWyR56VKf+l+4JR/AbaiUvM71VGyPQQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-4PP9_EHzONGA1nsoTLkivw-1; Wed, 14 Jun 2023 05:16:05 -0400
X-MC-Unique: 4PP9_EHzONGA1nsoTLkivw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-75d54053a76so86070985a.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686734165; x=1689326165;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3UnpM1hYXHgi+RACcSHlHZK3M8/2f7XZo9VS6GGF8FY=;
        b=db3p59Wjd5GkNhePqfyzG7or01b/XX/Ya6xMVv8/+40PLaTVmCWRYuICHZ+bX0AqjM
         oy5AJa8cbsk6rWJrgDiTsccZavzlXAQwu529krvyFCNPBxOM0iMkOQWJPxdvWiP9Pu9M
         oKQuhzWyJ+mJMc0OFN01JXaNmvBZDQ/eQYf2YNQoTHFEm+7EABr3n7jcjyE11goSdFzh
         ywqSpwlG/w5f+tIIyc0Pf6LX6DptgF8xFwYv+2qpCjGrOj5QDPTXHIVPTSSZPQ0Df6Mi
         /S13tBkl72WGu99Fs4hBp1pP52tGF2vuiJg6OOGXWUzxFg2suV5UH3MAQXPkmzGIdDzO
         j7aw==
X-Gm-Message-State: AC+VfDxhU19brS9xouKpOklwbd5gyVF/N0d1HR1Tm4jXpspB7a4M4S4B
	H9NLBa/xoTCBoWqKVP8NjQEUXlqaIge67vIfbNpzRvcUlZOYmEwWHIGD8FTFjrCSXpEZvS5hZAv
	vxcaoma/qBI283qbW
X-Received: by 2002:a05:620a:6003:b0:760:731d:7961 with SMTP id dw3-20020a05620a600300b00760731d7961mr10699920qkb.6.1686734164722;
        Wed, 14 Jun 2023 02:16:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Po1Dvx/goQfpYobqvBDXA0bnXoielLkcgjWFleNiIXLQP02pJqdcr4lhYm9wrip4Fi4eWRQ==
X-Received: by 2002:a05:620a:6003:b0:760:731d:7961 with SMTP id dw3-20020a05620a600300b00760731d7961mr10699905qkb.6.1686734164367;
        Wed, 14 Jun 2023 02:16:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-67.dyn.eolo.it. [146.241.244.67])
        by smtp.gmail.com with ESMTPSA id g17-20020ae9e111000000b0075d49ce31c3sm4140500qkm.91.2023.06.14.02.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:16:03 -0700 (PDT)
Message-ID: <16d3a8ee633ffe9c452037cf2e4cc0fca04b1dfb.camel@redhat.com>
Subject: Re: [PATCH net-next v5] tcp: enforce receive buffer memory limits
 by allowing the tcp window to shrink
From: Paolo Abeni <pabeni@redhat.com>
To: Mike Freemon <mfreemon@cloudflare.com>, netdev@vger.kernel.org
Cc: kernel-team@cloudflare.com, edumazet@google.com, ncardwell@google.com
Date: Wed, 14 Jun 2023 11:16:01 +0200
In-Reply-To: <20230612030524.60537-1-mfreemon@cloudflare.com>
References: <20230612030524.60537-1-mfreemon@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, 2023-06-11 at 22:05 -0500, Mike Freemon wrote:
> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
>=20
> Under certain circumstances, the tcp receive buffer memory limit
> set by autotuning (sk_rcvbuf) is increased due to incoming data
> packets as a result of the window not closing when it should be.
> This can result in the receive buffer growing all the way up to
> tcp_rmem[2], even for tcp sessions with a low BDP.
>=20
> To reproduce:  Connect a TCP session with the receiver doing
> nothing and the sender sending small packets (an infinite loop
> of socket send() with 4 bytes of payload with a sleep of 1 ms
> in between each send()).  This will cause the tcp receive buffer
> to grow all the way up to tcp_rmem[2].
>=20
> As a result, a host can have individual tcp sessions with receive
> buffers of size tcp_rmem[2], and the host itself can reach tcp_mem
> limits, causing the host to go into tcp memory pressure mode.
>=20
> The fundamental issue is the relationship between the granularity
> of the window scaling factor and the number of byte ACKed back
> to the sender.  This problem has previously been identified in
> RFC 7323, appendix F [1].
>=20
> The Linux kernel currently adheres to never shrinking the window.
>=20
> In addition to the overallocation of memory mentioned above, the
> current behavior is functionally incorrect, because once tcp_rmem[2]
> is reached when no remediations remain (i.e. tcp collapse fails to
> free up any more memory and there are no packets to prune from the
> out-of-order queue), the receiver will drop in-window packets
> resulting in retransmissions and an eventual timeout of the tcp
> session.  A receive buffer full condition should instead result
> in a zero window and an indefinite wait.
>=20
> In practice, this problem is largely hidden for most flows.  It
> is not applicable to mice flows.  Elephant flows can send data
> fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
> triggering a zero window.
>=20
> But this problem does show up for other types of flows.  Examples
> are websockets and other type of flows that send small amounts of
> data spaced apart slightly in time.  In these cases, we directly
> encounter the problem described in [1].
>=20
> RFC 7323, section 2.4 [2], says there are instances when a retracted
> window can be offered, and that TCP implementations MUST ensure
> that they handle a shrinking window, as specified in RFC 1122,
> section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
> management have made clear that sender must accept a shrunk window
> from the receiver, including RFC 793 [4] and RFC 1323 [5].
>=20
> This patch implements the functionality to shrink the tcp window
> when necessary to keep the right edge within the memory limit by
> autotuning (sk_rcvbuf).  This new functionality is enabled with
> the new sysctl: net.ipv4.tcp_shrink_window

Perhaps worth to note somewhere that the new knob fills an existing
hole in netns_ipv4.
>=20
> Additional information can be found at:
> https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-buf=
fers-and-how-we-fixed-it/
>=20
> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> [4] https://www.rfc-editor.org/rfc/rfc793
> [5] https://www.rfc-editor.org/rfc/rfc1323
>=20
> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
> ---

Including a changelog after the '---' separator would help the
reviewer, please add it to the next revisions, if any.

>  Documentation/networking/ip-sysctl.rst | 15 +++++++
>  include/net/netns/ipv4.h               |  1 +
>  net/ipv4/sysctl_net_ipv4.c             |  9 ++++
>  net/ipv4/tcp_ipv4.c                    |  2 +
>  net/ipv4/tcp_output.c                  | 60 ++++++++++++++++++++++----
>  5 files changed, 78 insertions(+), 9 deletions(-)
>=20
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/netwo=
rking/ip-sysctl.rst
> index 366e2a5097d9..4a010a7cde7f 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -981,6 +981,21 @@ tcp_tw_reuse - INTEGER
>  tcp_window_scaling - BOOLEAN
>  	Enable window scaling as defined in RFC1323.
> =20
> +tcp_shrink_window - BOOLEAN
> +	This changes how the TCP receive window is calculated.
> +
> +	RFC 7323, section 2.4, says there are instances when a retracted
> +	window can be offered, and that TCP implementations MUST ensure
> +	that they handle a shrinking window, as specified in RFC 1122.
> +
> +	- 0 - Disabled.	The window is never shrunk.
> +	- 1 - Enabled.	The window is shrunk when necessary to remain within
> +			the memory limit set by autotuning (sk_rcvbuf).
> +			This only occurs if a non-zero receive window
> +			scaling factor is also in effect.
> +
> +	Default: 0
> +
>  tcp_wmem - vector of 3 INTEGERs: min, default, max
>  	min: Amount of memory reserved for send buffers for TCP sockets.
>  	Each TCP socket has rights to use it due to fact of its birth.
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index a4efb7a2796c..f00374718159 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -65,6 +65,7 @@ struct netns_ipv4 {
>  #endif
>  	bool			fib_has_custom_local_routes;
>  	bool			fib_offload_disabled;
> +	u8			sysctl_tcp_shrink_window;
>  #ifdef CONFIG_IP_ROUTE_CLASSID
>  	atomic_t		fib_num_tclassid_users;
>  #endif
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 356afe54951c..2afb0870648b 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -1480,6 +1480,15 @@ static struct ctl_table ipv4_net_table[] =3D {
>  		.extra1		=3D SYSCTL_ZERO,
>  		.extra2		=3D &tcp_syn_linear_timeouts_max,
>  	},
> +	{
> +		.procname	=3D "tcp_shrink_window",
> +		.data		=3D &init_net.ipv4.sysctl_tcp_shrink_window,
> +		.maxlen		=3D sizeof(u8),
> +		.mode		=3D 0644,
> +		.proc_handler	=3D proc_dou8vec_minmax,
> +		.extra1		=3D SYSCTL_ZERO,
> +		.extra2		=3D SYSCTL_ONE,
> +	},
>  	{ }
>  };
> =20
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 84a5d557dc1a..9213804b034f 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -3281,6 +3281,8 @@ static int __net_init tcp_sk_init(struct net *net)
>  		net->ipv4.tcp_congestion_control =3D &tcp_reno;
> =20
>  	net->ipv4.sysctl_tcp_syn_linear_timeouts =3D 4;
> +	net->ipv4.sysctl_tcp_shrink_window =3D 0;
> +
>  	return 0;
>  }
> =20
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index f8ce77ce7c3e..5784f8a99381 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -260,8 +260,8 @@ static u16 tcp_select_window(struct sock *sk)
>  	u32 old_win =3D tp->rcv_wnd;
>  	u32 cur_win =3D tcp_receive_window(tp);
>  	u32 new_win =3D __tcp_select_window(sk);
> +	struct net *net =3D sock_net(sk);
> =20
> -	/* Never shrink the offered window */
>  	if (new_win < cur_win) {
>  		/* Danger Will Robinson!
>  		 * Don't update rcv_wup/rcv_wnd here or else
> @@ -270,11 +270,14 @@ static u16 tcp_select_window(struct sock *sk)
>  		 *
>  		 * Relax Will Robinson.
>  		 */
> -		if (new_win =3D=3D 0)
> -			NET_INC_STATS(sock_net(sk),
> -				      LINUX_MIB_TCPWANTZEROWINDOWADV);
> -		new_win =3D ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
> +		if (!READ_ONCE(net->ipv4.sysctl_tcp_shrink_window) || !tp->rx_opt.rcv_=
wscale) {
> +			/* Never shrink the offered window */
> +			if (new_win =3D=3D 0)
> +				NET_INC_STATS(net, LINUX_MIB_TCPWANTZEROWINDOWADV);
> +			new_win =3D ALIGN(cur_win, 1 << tp->rx_opt.rcv_wscale);
> +		}
>  	}
> +
>  	tp->rcv_wnd =3D new_win;
>  	tp->rcv_wup =3D tp->rcv_nxt;
> =20
> @@ -282,7 +285,7 @@ static u16 tcp_select_window(struct sock *sk)
>  	 * scaled window.
>  	 */
>  	if (!tp->rx_opt.rcv_wscale &&
> -	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows))
> +	    READ_ONCE(net->ipv4.sysctl_tcp_workaround_signed_windows))
>  		new_win =3D min(new_win, MAX_TCP_WINDOW);
>  	else
>  		new_win =3D min(new_win, (65535U << tp->rx_opt.rcv_wscale));
> @@ -294,10 +297,9 @@ static u16 tcp_select_window(struct sock *sk)
>  	if (new_win =3D=3D 0) {
>  		tp->pred_flags =3D 0;
>  		if (old_win)
> -			NET_INC_STATS(sock_net(sk),
> -				      LINUX_MIB_TCPTOZEROWINDOWADV);
> +			NET_INC_STATS(net, LINUX_MIB_TCPTOZEROWINDOWADV);
>  	} else if (old_win =3D=3D 0) {
> -		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPFROMZEROWINDOWADV);
> +		NET_INC_STATS(net, LINUX_MIB_TCPFROMZEROWINDOWADV);
>  	}
> =20
>  	return new_win;
> @@ -3003,6 +3005,7 @@ u32 __tcp_select_window(struct sock *sk)
>  {
>  	struct inet_connection_sock *icsk =3D inet_csk(sk);
>  	struct tcp_sock *tp =3D tcp_sk(sk);
> +	struct net *net =3D sock_net(sk);
>  	/* MSS for the peer's data.  Previous versions used mss_clamp
>  	 * here.  I don't know if the value based on our guesses
>  	 * of peer's MSS is better for the performance.  It's more correct
> @@ -3024,6 +3027,15 @@ u32 __tcp_select_window(struct sock *sk)
>  		if (mss <=3D 0)
>  			return 0;
>  	}
> +
> +	/* Only allow window shrink if the sysctl is enabled and we have
> +	 * a non-zero scaling factor in effect.
> +	 */
> +	if (READ_ONCE(net->ipv4.sysctl_tcp_shrink_window) && tp->rx_opt.rcv_wsc=
ale)

I'm wondering if an unlikely() here is worthy.


Cheers,

Paolo


