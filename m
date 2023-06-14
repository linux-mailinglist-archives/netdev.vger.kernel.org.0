Return-Path: <netdev+bounces-10657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDDE72F989
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A56001C20C77
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920806110;
	Wed, 14 Jun 2023 09:43:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D046101
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:43:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B6D296E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686735768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qN+1diYhERNkjXIoa2/XDpR5RGrQlC1FGasx3olZwEM=;
	b=TuPIZsZmnjjhsAmrD3evvT9FP4NM4t/kgruFaOKFJU/PYFQvF7itrQktD4Qj/9DVfIXtQF
	Y3iLO7+3K4bNb3h0Ox6GyF7SKfoMjxsdP6YfumBdGvMqjmBAn7eWhn8DY0uUOHBevoy4ih
	sJIMZ2FPEVWBlqQ3TZFFYKt7/af0NqU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-zsB2rG_lPHWKVrcn7xLkBA-1; Wed, 14 Jun 2023 05:42:46 -0400
X-MC-Unique: zsB2rG_lPHWKVrcn7xLkBA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f7ba550b12so13963265e9.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 02:42:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686735765; x=1689327765;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qN+1diYhERNkjXIoa2/XDpR5RGrQlC1FGasx3olZwEM=;
        b=HFOjxTfu+ZJFfpyp5hA+pkP5lE+6GXZdvTjwqalu9ARF1y6kur8DGlStDXaS7a04Eo
         vMuZ02kQN8lKRrgxze88gJFXjegSd0N/mDNRQFW4jJ6DrOzgWhj9hXZwrY56r91vlfL4
         qCLlldGMYaWoXSUw185vncl2BcmWcZS5olUloY4z3Ia1k+y6N/0wF4b9f8YI2JlJSmmv
         AgrvlKawfGP1paIwFSKZblvuODduH7rHa57+W9vsnJePaqUEaa7usJUWt3ZhBy2zMDK5
         pgjlXTuMQ7A9PIciaa0+GRR+8Dh2nliDo1CURpWdedGCjIAt3Ti+sFJKHx957wymPqZp
         A9Kw==
X-Gm-Message-State: AC+VfDxUHGkFiIsEnVoln3QmxSgxWPiVbDIOwCX5NMcEXtEQDfWFz/Xm
	iTgqIwslragBy2cDwyAjS+fN5j8fbwhLXsyVDygC50Kt7rg30xyN9op3Av1p0FXhBGBxep9V3Z/
	Oehxebvf8y4OQInys
X-Received: by 2002:adf:f642:0:b0:30c:4191:b247 with SMTP id x2-20020adff642000000b0030c4191b247mr10353544wrp.5.1686735765420;
        Wed, 14 Jun 2023 02:42:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ66KndozB3mH6VvltJu6YxrA+IR8sESkB/CE2sAaPLInx38QXIMj0yTlAeCaYNi/KUJG6h8UQ==
X-Received: by 2002:adf:f642:0:b0:30c:4191:b247 with SMTP id x2-20020adff642000000b0030c4191b247mr10353530wrp.5.1686735765049;
        Wed, 14 Jun 2023 02:42:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-67.dyn.eolo.it. [146.241.244.67])
        by smtp.gmail.com with ESMTPSA id i1-20020adfefc1000000b0030647449730sm17895849wrp.74.2023.06.14.02.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:42:44 -0700 (PDT)
Message-ID: <dffbf0474b1352f1eac63125a973c8f8cd7b3e8d.camel@redhat.com>
Subject: Re: [PATCH] net: hsr: Disable promiscuous mode in offload mode
From: Paolo Abeni <pabeni@redhat.com>
To: Ravi Gunasekaran <r-gunasekaran@ti.com>, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, bigeasy@linutronix.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rogerq@kernel.org
Date: Wed, 14 Jun 2023 11:42:43 +0200
In-Reply-To: <20230612093933.13267-1-r-gunasekaran@ti.com>
References: <20230612093933.13267-1-r-gunasekaran@ti.com>
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

On Mon, 2023-06-12 at 15:09 +0530, Ravi Gunasekaran wrote:
> When port-to-port forwarding for interfaces in HSR node is enabled,
> disable promiscuous mode since L2 frame forward happens at the
> offloaded hardware.
>=20
> Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
> ---
>  net/hsr/hsr_device.c |  5 +++++
>  net/hsr/hsr_main.h   |  1 +
>  net/hsr/hsr_slave.c  | 15 +++++++++++----
>  3 files changed, 17 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index 5a236aae2366..306f942c3b28 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -531,6 +531,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, str=
uct net_device *slave[2],
>  	if (res)
>  		goto err_add_master;
> =20
> +	/* HSR forwarding offload supported in lower device? */
> +	if ((slave[0]->features & NETIF_F_HW_HSR_FWD) &&
> +	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
> +		hsr->fwd_offloaded =3D true;
> +
>  	res =3D register_netdevice(hsr_dev);
>  	if (res)
>  		goto err_unregister;
> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> index 5584c80a5c79..0225fabbe6d1 100644
> --- a/net/hsr/hsr_main.h
> +++ b/net/hsr/hsr_main.h
> @@ -195,6 +195,7 @@ struct hsr_priv {
>  	struct hsr_self_node	__rcu *self_node;	/* MACs of slaves */
>  	struct timer_list	announce_timer;	/* Supervision frame dispatch */
>  	struct timer_list	prune_timer;
> +	unsigned int            fwd_offloaded : 1; /* Forwarding offloaded to H=
W */

Please use plain 'bool' instead.

Also there is an hole in 'struct hsr_priv' just after 'net_id', you
could consider moving this new field there.


Thanks!

Paolo


