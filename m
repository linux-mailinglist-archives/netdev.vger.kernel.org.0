Return-Path: <netdev+bounces-1066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A926FC0C4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EACB71C20ADC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CDF171CC;
	Tue,  9 May 2023 07:52:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D743C38C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:52:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEF9E49
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683618759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hq9XOb+LYS7v46jM7SOsafcU6iQdpNEsWNBu53l8jpc=;
	b=ANbjMV+W00s5xjXFg2z9iQh4c2oURVtZM6gigZtFC6Q1bqsONvcI2ypD6pX2YdKLsGA5hy
	QkUfyae4CZbrULFxTJYb0q4t41KBq/H5N3xgrMWjcmAMGMXAW/DlAaWgIFBpfKtIZEr0/K
	tNVRF/DcPewqV0U6crQIs1sademjAeU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-oRaMMALyMRWO1msJ9qoFJQ-1; Tue, 09 May 2023 03:52:31 -0400
X-MC-Unique: oRaMMALyMRWO1msJ9qoFJQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-306415cca9eso29408f8f.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 00:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683618750; x=1686210750;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hq9XOb+LYS7v46jM7SOsafcU6iQdpNEsWNBu53l8jpc=;
        b=k58yOZ57X2aVapDdIwitFNPVGg/9LssrkUgEUeZg3g87WRMXIJ/5zG42CnPXPq/cag
         j3W2TH/hjeJ8xhXhquoSZmc/KF94pJkWHpRTtEi4E8UObWA/ri6ohfFd8ASlBnWp/vay
         e6JXteSFdZFgIQm5XGRFMs6uZSC5CHjP/4xVgNOujAZC/vBMGGunhgrc9vLjrslWgOuV
         yy7Q3f2rDxej6eeNN/hjNdExUV6uY3MGkLW2/hf18BA9e8/sXkuwFIjWhuSWVxaqrAPz
         6bOcGNXkDgZi8lC/zSaw6wTUoJtlg4zA3eR+pRmTZ7T1HzizioCcXhM/pZ8IG50dNz3m
         vWAw==
X-Gm-Message-State: AC+VfDz4drb4ukc87aM6Ab/zo8aX9/bSTu+C8ZMqfDmge14lLRiTSMzR
	W/k1i5Oz26X7FbmTvAXhFgvil4GOyN93n78QoXwlePzP07tVPMphBROFH6PDuTQwuEMjC63EA+R
	7Pow5Z6TnjGghdBZd
X-Received: by 2002:a5d:67c6:0:b0:2e4:aa42:7872 with SMTP id n6-20020a5d67c6000000b002e4aa427872mr7692568wrw.4.1683618750386;
        Tue, 09 May 2023 00:52:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4H4IfkEQuX9n/ueDeNBX8m3xSSf2wAl4ge9AgLHxQsyhBchYvRkFhX7uFEBEr7GhEbh5UJqQ==
X-Received: by 2002:a5d:67c6:0:b0:2e4:aa42:7872 with SMTP id n6-20020a5d67c6000000b002e4aa427872mr7692557wrw.4.1683618749972;
        Tue, 09 May 2023 00:52:29 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-255-65.dyn.eolo.it. [146.241.255.65])
        by smtp.gmail.com with ESMTPSA id e7-20020a5d65c7000000b00307925ff35bsm6816071wrw.49.2023.05.09.00.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 00:52:29 -0700 (PDT)
Message-ID: <588689343dcd6c904e7fc142a001043015e5b14e.camel@redhat.com>
Subject: Re: [PATCH] sock: Fix misuse of sk_under_memory_pressure()
From: Paolo Abeni <pabeni@redhat.com>
To: Abel Wu <wuyun.abel@bytedance.com>, "David S . Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 09 May 2023 09:52:28 +0200
In-Reply-To: <20230506085903.96133-1-wuyun.abel@bytedance.com>
References: <20230506085903.96133-1-wuyun.abel@bytedance.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, 2023-05-06 at 16:59 +0800, Abel Wu wrote:
> The commit 180d8cd942ce ("foundations of per-cgroup memory pressure
> controlling") wrapped proto::memory_pressure status into an accessor
> named sk_under_memory_pressure(), and in the next commit e1aab161e013
> ("socket: initial cgroup code") added the consideration of net-memcg
> pressure into this accessor.
>=20
> But with the former patch applied, not all of the call sites of
> sk_under_memory_pressure() are interested in net-memcg's pressure.
> The __sk_mem_{raise,reduce}_allocated() only focus on proto/netns
> pressure rather than net-memcg's.=C2=A0

Why do you state the above? The current behavior is established since
~12y, arguably we can state quite the opposite.

I think this patch should at least target net-next, and I think we need
a more detailed reasoning to introduce such behavior change.

> IOW this accessor are generally
> used for deciding whether should reclaim or not.
>=20
> Fixes: e1aab161e013 ("socket: initial cgroup code")
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> ---
>  include/net/sock.h |  5 -----
>  net/core/sock.c    | 17 +++++++++--------
>  2 files changed, 9 insertions(+), 13 deletions(-)
>=20
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 8b7ed7167243..752d51030c5a 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1404,11 +1404,6 @@ static inline int sk_under_cgroup_hierarchy(struct=
 sock *sk,
>  #endif
>  }
> =20
> -static inline bool sk_has_memory_pressure(const struct sock *sk)
> -{
> -	return sk->sk_prot->memory_pressure !=3D NULL;
> -}
> -
>  static inline bool sk_under_memory_pressure(const struct sock *sk)
>  {
>  	if (!sk->sk_prot->memory_pressure)
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 5440e67bcfe3..8d215f821ea6 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3017,13 +3017,14 @@ int __sk_mem_raise_allocated(struct sock *sk, int=
 size, int amt, int kind)
>  		}
>  	}
> =20
> -	if (sk_has_memory_pressure(sk)) {
> -		u64 alloc;
> -
> -		if (!sk_under_memory_pressure(sk))
> -			return 1;
> -		alloc =3D sk_sockets_allocated_read_positive(sk);
> -		if (sk_prot_mem_limits(sk, 2) > alloc *
> +	if (prot->memory_pressure) {
> +		/*
> +		 * If under global pressure, allow the sockets that are below
> +		 * average memory usage to raise, trying to be fair between all
> +		 * the sockets under global constrains.
> +		 */
> +		if (!*prot->memory_pressure ||
> +		    sk_prot_mem_limits(sk, 2) > sk_sockets_allocated_read_positive(sk)=
 *

The above introduces unrelated changes that makes the code IMHO less
readable - I don't see a good reason to drop the 'alloc' variable.

Cheers,

Paolo


