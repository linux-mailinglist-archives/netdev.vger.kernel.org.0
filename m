Return-Path: <netdev+bounces-4317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC65570C09B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:02:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78175280FE5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB9D1426F;
	Mon, 22 May 2023 14:01:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623631426A;
	Mon, 22 May 2023 14:01:57 +0000 (UTC)
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B73819A6;
	Mon, 22 May 2023 07:01:54 -0700 (PDT)
Received: from relay8-d.mail.gandi.net (unknown [217.70.183.201])
	by mslow1.mail.gandi.net (Postfix) with ESMTP id 26CB9C0931;
	Mon, 22 May 2023 13:58:38 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 9B1BC1BF216;
	Mon, 22 May 2023 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684763796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=idH/1frPrIip63cZCQnGf3/2ciwKL3/yzbQjgoMvysU=;
	b=KfD71gf6rj+7VqnudQ3hMHflZh/tS+faJ2vkaa6Gs7BYmikYGDPr8XCxuyoGNWi9CoPh6j
	gkqbQNX3MUdInWLbrJ1bVbBp5xSZupewfC3L2WUGO1tb54VDzbmW0khW1guRl7wgYUMrVC
	UO1jWB9EYHURYd9C/o2SmdXooVCOGR5FAl0WQibtfh//po5jqHRXrXcEFG2FLrNwzaTrmW
	nK/cJCYxzVhgbuNDFmljohabTQDdTZVa+zUXjmlDEvLLyPquPfx7pVLGTUta/KN3926Xc3
	JNYXAA5RciLh1z/nZvriT+s9lVz1w9oG3JDU0hYuRvd8pDdCn6Hfn1rPMvnPYg==
Date: Mon, 22 May 2023 15:56:32 +0200
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Christian =?UTF-8?B?R8O2dHRzY2hl?= <cgzones@googlemail.com>
Cc: selinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Alexander Aring <alex.aring@gmail.com>, Stefan
 Schmidt <stefan@datenfreihafen.org>, David Ahern <dsahern@kernel.org>,
 Keith Busch <kbusch@kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Alexei Starovoitov
 <ast@kernel.org>, Martin KaFai Lau <martin.lau@kernel.org>, Xin Long
 <lucien.xin@gmail.com>, Alexander Duyck <alexanderduyck@fb.com>, Jason Xing
 <kernelxing@tencent.com>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov
 <asml.silence@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
 bpf@vger.kernel.org
Subject: Re: [PATCH v4 9/9] net: use new capable_any functionality
Message-ID: <20230522155632.205ac884@xps-13>
In-Reply-To: <20230511142535.732324-9-cgzones@googlemail.com>
References: <20230511142535.732324-1-cgzones@googlemail.com>
	<20230511142535.732324-9-cgzones@googlemail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Christian,

cgzones@googlemail.com wrote on Thu, 11 May 2023 16:25:32 +0200:

> Use the new added capable_any function in appropriate cases, where a
> task is required to have any of two capabilities.
>=20
> Add sock_ns_capable_any() wrapper similar to existing sock_ns_capable()
> one.
>=20
> Reorder CAP_SYS_ADMIN last.
>=20
> Signed-off-by: Christian G=C3=B6ttsche <cgzones@googlemail.com>
> ---
> v4:
>   - introduce sockopt_ns_capable_any()
> v3:
>   - rename to capable_any()
>   - make use of ns_capable_any
> Signed-off-by: Christian G=C3=B6ttsche <cgzones@googlemail.com>
> ---
>  include/net/sock.h       |  1 +
>  net/caif/caif_socket.c   |  2 +-
>  net/core/sock.c          | 18 ++++++++++--------
>  net/ieee802154/socket.c  |  6 ++----
>  net/ipv4/ip_sockglue.c   |  4 ++--
>  net/ipv6/ipv6_sockglue.c |  3 +--
>  net/unix/scm.c           |  2 +-
>  7 files changed, 18 insertions(+), 18 deletions(-)
>=20

[...]

> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index 1fa2fe041ec0..f9bc6cae4af9 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -904,8 +904,7 @@ static int dgram_setsockopt(struct sock *sk, int leve=
l, int optname,
>  		ro->want_lqi =3D !!val;
>  		break;
>  	case WPAN_SECURITY:
> -		if (!ns_capable(net->user_ns, CAP_NET_ADMIN) &&
> -		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
> +		if (!ns_capable_any(net->user_ns, CAP_NET_ADMIN, CAP_NET_RAW)) {
>  			err =3D -EPERM;
>  			break;
>  		}
> @@ -928,8 +927,7 @@ static int dgram_setsockopt(struct sock *sk, int leve=
l, int optname,
>  		}
>  		break;
>  	case WPAN_SECURITY_LEVEL:
> -		if (!ns_capable(net->user_ns, CAP_NET_ADMIN) &&
> -		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
> +		if (!ns_capable_any(net->user_ns, CAP_NET_ADMIN, CAP_NET_RAW)) {
>  			err =3D -EPERM;
>  			break;
>  		}

I was not noticed this was applied already, so, for ieee802154:

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

Thanks,
Miqu=C3=A8l

