Return-Path: <netdev+bounces-3549-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 933BB707D7F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B6061C21075
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E6111CAD;
	Thu, 18 May 2023 10:02:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7261811CA0
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:02:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E538F19A3
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684404118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xz4Yzk1FbN4lslQ/05ZU71kF3vRpTJyBu6xKqFUISCQ=;
	b=LWavSo+epuLjNew6MlSAsUa78iqX11mKB3PXpEP+O9TlZPZtSMA4YwKLJCKNo9idpWrF6Z
	8bd9OysJLQTJuDvCoKMzZJY+KDarrWC0jpLj/6xPcC2aOd+J1+50IpysY9Cny+lTg+YTYr
	AzJ4YW1vj+bcCeXTFHEseAajAH11bqY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-24yzOza3NkeOPJlzuhSWwA-1; Thu, 18 May 2023 06:01:57 -0400
X-MC-Unique: 24yzOza3NkeOPJlzuhSWwA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f393bf5546so3709041cf.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684404116; x=1686996116;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xz4Yzk1FbN4lslQ/05ZU71kF3vRpTJyBu6xKqFUISCQ=;
        b=JiKxXjIlshutZIMQXbk8VvUFGc1rcsRMwyVJ5NX1INtxJ1Kz6VdSn4Wj0QZ0sNjXlx
         my+byTVyWYkG7jvQzv1IW1nQqjdJ7gooDWo63+08UdD1mOpFpF2z66TkEQk4VpmMVx2Q
         cPIVxa1jrBcdDS3i/4yZN6bMTMUBgenxO/M5r7OtwbpbrChXuyf7XjAxnOuMLLkj1ydO
         xQkvEHLVFuxaztA/vUpt0EWAUCwuGILXqCqAi4y+maZOKsiVlWxinwZJsxDqEHiY7Tzl
         4FcqM6ggBkfl+nesZQUdg47pWotLMRvuYs7p7eq9l/OU3uzYZiVu6yziV6BrIMesQiml
         LT6A==
X-Gm-Message-State: AC+VfDwWGbAhQQmzKAx7bByZa1WD8pfKoA6mZPsmmLqjRHGuUkN4ysyj
	CXDUlnq+2daiTTR7VwWNZjpT5jB11VAecG8pYeugGYFiRnr29HpR76yBY2WEGYhRW+t+H+D/Ger
	t7Ka0x4DR/PqpTs44
X-Received: by 2002:a05:622a:189e:b0:3f5:99e:d7d4 with SMTP id v30-20020a05622a189e00b003f5099ed7d4mr9400524qtc.1.1684404116574;
        Thu, 18 May 2023 03:01:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5/bpXzMPMDK+f3opJ5CCYN/HiKqJEukqR71H+bovs37wm592r0+VAIa6EG/igPOZa2glSuZA==
X-Received: by 2002:a05:622a:189e:b0:3f5:99e:d7d4 with SMTP id v30-20020a05622a189e00b003f5099ed7d4mr9400499qtc.1.1684404116281;
        Thu, 18 May 2023 03:01:56 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-175.dyn.eolo.it. [146.241.239.175])
        by smtp.gmail.com with ESMTPSA id u5-20020ae9c005000000b0074df51a90b6sm291106qkk.60.2023.05.18.03.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 03:01:55 -0700 (PDT)
Message-ID: <0d282eb6626010afa117ca2f4162d2c147746dc1.camel@redhat.com>
Subject: Re: [PATCH RESEND net] ipv{4,6}/raw: fix output xfrm lookup wrt
 protocol
From: Paolo Abeni <pabeni@redhat.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>, "David S . Miller"
	 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	 <edumazet@google.com>
Cc: Steffen Klassert <klassert@kernel.org>, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Date: Thu, 18 May 2023 12:01:52 +0200
In-Reply-To: <20230516201542.9086-1-nicolas.dichtel@6wind.com>
References: <20230516201542.9086-1-nicolas.dichtel@6wind.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-16 at 22:15 +0200, Nicolas Dichtel wrote:
> With a raw socket bound to IPPROTO_RAW (ie with hdrincl enabled), the
> protocol field of the flow structure, build by raw_sendmsg() /
> rawv6_sendmsg()),  is set to IPPROTO_RAW. This breaks the ipsec policy
> lookup when some policies are defined with a protocol in the selector.
>=20
> For ipv6, the sin6_port field from 'struct sockaddr_in6' could be used to
> specify the protocol. Just accept all values for IPPROTO_RAW socket.
>=20
> For ipv4, the sin_port field of 'struct sockaddr_in' could not be used
> without breaking backward compatibility (the value of this field was neve=
r
> checked). Let's add a new kind of control message, so that the userland
> could specify which protocol is used.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> CC: stable@vger.kernel.org
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>=20
> The first version has been marked 'Awaiting Upstream'. Steffen confirmed
> that the 'net' tree should be the target, thus I resend this patch.
> I also CC stable@vger.kernel.org.
>=20
>  include/net/ip.h        |  2 ++
>  include/uapi/linux/in.h |  1 +
>  net/ipv4/ip_sockglue.c  | 15 ++++++++++++++-
>  net/ipv4/raw.c          |  5 ++++-
>  net/ipv6/raw.c          |  3 ++-
>  5 files changed, 23 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/net/ip.h b/include/net/ip.h
> index c3fffaa92d6e..acec504c469a 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -76,6 +76,7 @@ struct ipcm_cookie {
>  	__be32			addr;
>  	int			oif;
>  	struct ip_options_rcu	*opt;
> +	__u8			protocol;
>  	__u8			ttl;
>  	__s16			tos;
>  	char			priority;
> @@ -96,6 +97,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipc=
m,
>  	ipcm->sockc.tsflags =3D inet->sk.sk_tsflags;
>  	ipcm->oif =3D READ_ONCE(inet->sk.sk_bound_dev_if);
>  	ipcm->addr =3D inet->inet_saddr;
> +	ipcm->protocol =3D inet->inet_num;
>  }
> =20
>  #define IPCB(skb) ((struct inet_skb_parm*)((skb)->cb))
> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> index 4b7f2df66b99..e682ab628dfa 100644
> --- a/include/uapi/linux/in.h
> +++ b/include/uapi/linux/in.h
> @@ -163,6 +163,7 @@ struct in_addr {
>  #define IP_MULTICAST_ALL		49
>  #define IP_UNICAST_IF			50
>  #define IP_LOCAL_PORT_RANGE		51
> +#define IP_PROTOCOL			52
> =20
>  #define MCAST_EXCLUDE	0
>  #define MCAST_INCLUDE	1
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index b511ff0adc0a..ec0fbe874426 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -317,7 +317,17 @@ int ip_cmsg_send(struct sock *sk, struct msghdr *msg=
, struct ipcm_cookie *ipc,
>  			ipc->tos =3D val;
>  			ipc->priority =3D rt_tos2priority(ipc->tos);
>  			break;
> -
> +		case IP_PROTOCOL:
> +			if (cmsg->cmsg_len =3D=3D CMSG_LEN(sizeof(int)))
> +				val =3D *(int *)CMSG_DATA(cmsg);
> +			else if (cmsg->cmsg_len =3D=3D CMSG_LEN(sizeof(u8)))
> +				val =3D *(u8 *)CMSG_DATA(cmsg);

AFAICS the 'dual' u8 support for IP_TOS has been introduce to cope with
asymmetry WRT recvmsg(). Here we don't have (yet) the recvmsg counter-
part, and if/when that will be added we can use the correct data type.

I think we are better off supporting only int, as e.g. IP_TTL does.

Side note, the above code could be factored out in an helper to be used
both for IP_PROTOCOL and IP_TTL (possibly in a net-next patch).

Thanks!

Paolo


