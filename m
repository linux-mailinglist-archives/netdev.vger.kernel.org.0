Return-Path: <netdev+bounces-8441-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 051B572410B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:37:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 456A5281510
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53E815AF2;
	Tue,  6 Jun 2023 11:37:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A58315ADB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:37:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BCEE9
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686051433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S4hpUfKMrc5ygmOuWe+sx1PausmBgz6oBl+uC1M99eQ=;
	b=IsMDjjbTfEYLrKu3/hilF/P5HIu8+wvryocXZ38alx5yR4hxKPeRh4uOgTENnhFfRYaNha
	C7xA6IKtxOWt6ZrS+u0oZas9VJpHf2jvZylAmMqkSZQuy62oDZoSFofW06rqQMNmA6cCqm
	6lSRD9ANtuF1zXwSNRPcO4LvCYMo5jo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-4tgvkiOdOEGLRAqXFPqA2Q-1; Tue, 06 Jun 2023 07:37:12 -0400
X-MC-Unique: 4tgvkiOdOEGLRAqXFPqA2Q-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-62b67ff6943so221366d6.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686051431; x=1688643431;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4hpUfKMrc5ygmOuWe+sx1PausmBgz6oBl+uC1M99eQ=;
        b=RniPIpORHaCEgLqMTqD3Dnq5HGArwsHotNOYPL//d9ojYjoS3nM/Vdu4Wmxy9cjDht
         YlXQLriSQyhwQcqfj8XQO6l4R9OGyi/vJd3M4/ss1B071hotvOsULjrr9rCOUqltB++Y
         J52CijbOP5EObY2ijDZTPQFl/Ju8qfhawX40dSNL/0D7Bpu4L9Dt9dT6K5nbSdDqb3+K
         VBDjogriVTShYpyuRCnd8KgipXLl+mmhv0Gb2n/7jyojKxkKXYntclp2AueVw34FqChj
         6QxV+8llWASpbfwa79VA44To7MUGEzFELgmoYe70tcyqN1YAyU9KcygbL4s/qDgllFS1
         BXZA==
X-Gm-Message-State: AC+VfDwnkJqaZ7GFWZkkDEfoZUwYr1mZLLhp5/SMfvlfpADAEoNsnNBc
	oAofYpoQzjmMEVSg6xK0Tv0wDceiDtZm5KskclAmSTWMwOtl3Ak8b3ujY5LeN2lpXfn/wG25hSV
	f6jUeiqKRN+2Bh3yF
X-Received: by 2002:a05:6214:2a84:b0:625:8eef:1e71 with SMTP id jr4-20020a0562142a8400b006258eef1e71mr1938054qvb.0.1686051431462;
        Tue, 06 Jun 2023 04:37:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6wt6nV/4akZVmxHryuHq0PBMb3zlDO2O7C5SLsP3nbKa3w5BkrwLE4bmWQ2Pqj+0hiC21IHQ==
X-Received: by 2002:a05:6214:2a84:b0:625:8eef:1e71 with SMTP id jr4-20020a0562142a8400b006258eef1e71mr1938043qvb.0.1686051431148;
        Tue, 06 Jun 2023 04:37:11 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id bt17-20020ad455d1000000b005e750d07153sm5323750qvb.135.2023.06.06.04.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 04:37:10 -0700 (PDT)
Message-ID: <7915b31f96108bee8dd92a229df6823ebe9c55b0.camel@redhat.com>
Subject: Re: [PATCH] net: revert "align SO_RCVMARK required privileges with
 SO_MARK"
From: Paolo Abeni <pabeni@redhat.com>
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>, Maciej
	=?UTF-8?Q?=C5=BBenczykowski?=
	 <zenczykowski@gmail.com>
Cc: Linux Network Development Mailing List <netdev@vger.kernel.org>, Eyal
 Birger <eyal.birger@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Eric
 Dumazet <edumazet@google.com>, Patrick Rohr <prohr@google.com>
Date: Tue, 06 Jun 2023 13:37:07 +0200
In-Reply-To: <20230605081218.113588-1-maze@google.com>
References: <20230605081218.113588-1-maze@google.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-06-05 at 01:12 -0700, Maciej =C5=BBenczykowski wrote:
> This reverts:
>     commit 1f86123b97491cc2b5071d7f9933f0e91890c976
>     net: align SO_RCVMARK required privileges with SO_MARK
>=20
>     The commit referenced in the "Fixes" tag added the SO_RCVMARK socket
>     option for receiving the skb mark in the ancillary data.
>=20
>     Since this is a new capability, and exposes admin configured details
>     regarding the underlying network setup to sockets, let's align the
>     needed capabilities with those of SO_MARK.
>=20
> This reasoning is not really correct:
>   SO_RCVMARK is used for 'reading' incoming skb mark (via cmsg), as such
>   it is more equivalent to 'getsockopt(SO_MARK)' which has no priv check
>   and retrieves the socket mark, rather than 'setsockopt(SO_MARK) which
>   sets the socket mark and does require privs.
>=20
>   Additionally incoming skb->mark may already be visible if
>   sysctl_fwmark_reflect and/or sysctl_tcp_fwmark_accept are enabled.
>=20
>   Furthermore, it is easier to block the getsockopt via bpf
>   (either cgroup setsockopt hook, or via syscall filters)
>   then to unblock it if it requires CAP_NET_RAW/ADMIN.
>=20
> On Android the socket mark is (among other things) used to store
> the network identifier a socket is bound to.  Setting it is privileged,
> but retrieving it is not.  We'd like unprivileged userspace to be able
> to read the network id of incoming packets (where mark is set via iptable=
s
> [to be moved to bpf])...
>=20
> An alternative would be to add another sysctl to control whether
> setting SO_RCVMARK is privilged or not.
> (or even a MASK of which bits in the mark can be exposed)
> But this seems like over-engineering...
>=20
> Note: This is a non-trivial revert, due to later merged:
>   commit e42c7beee71d0d84a6193357e3525d0cf2a3e168
>   bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_s=
etsockopt()

When you repost, please additionally change the above with the usual
commit reference, e.g. commit <12# hash> ("<title>")

> which changed both 'ns_capable' into 'sockopt_ns_capable' calls.
>=20
> Fixes: 1f86123b9749 ("align SO_RCVMARK required privileges with SO_MARK")
> Cc: Eyal Birger <eyal.birger@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Patrick Rohr <prohr@google.com>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  net/core/sock.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 24f2761bdb1d..6e5662ca00fe 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1362,12 +1362,6 @@ int sk_setsockopt(struct sock *sk, int level, int =
optname,
>  		__sock_set_mark(sk, val);
>  		break;
>  	case SO_RCVMARK:
> -		if (!sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
> -		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
> -			ret =3D -EPERM;
> -			break;
> -		}
> -
>  		sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
>  		break;
> =20


