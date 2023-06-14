Return-Path: <netdev+bounces-10686-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E3272FC49
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65F5D1C20B1F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2155F7499;
	Wed, 14 Jun 2023 11:22:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1616A1FD3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:22:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748C1E55
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686741728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOQy85RO7Cyq9aLHZ/uDXVS6+1lb+U5DF9ksH03CF8Q=;
	b=QM2a6C0a+4dfF2CPfl5gDwCYap5fWgajpi9/VQteRIzgkj2iArm8cJvv5JXUfewBk6oZVR
	3lT3/WB7JZLJuxp6d3LdCHIEWut71jJ24mS9pP3+i+FNjAGFCUa+TqOaZYzjZRjMGLUZOh
	xQAWT556G7kSkhHIVholy09e1+K5zlw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-xIs3YmApN5mQW0HQLevJNA-1; Wed, 14 Jun 2023 07:22:06 -0400
X-MC-Unique: xIs3YmApN5mQW0HQLevJNA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3fb2e6ca6eeso3590011cf.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686741726; x=1689333726;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YOQy85RO7Cyq9aLHZ/uDXVS6+1lb+U5DF9ksH03CF8Q=;
        b=ltAzP5nPfTGxJ64q3D2xsIvUetEs2CU+SmOYmrdSmPMNRXtQVGr4a/Hpm1kKJG4Z36
         mKtKtsvDnAHWaiBTmXQOXpyvnPU+YDuLNHNi23olfCVXl6VU2T+LcHF5X/hrOhvuNDGh
         bWzh3lRvYhlNpYFYLB+sGN2hepBvTBzulmQfO7MTYq5bzqXDINdRtK9tLjqo9OpcGWh7
         pAD0lC/TXv+45uuc+id1Xv/nP4mj1N1JtlDhdcw8nv83jn9PkkTLPfkXpggBwc+TV1Ou
         mWpoedas0tXNm0na2eehRCSmL8f+EqwCqWC7PfM7X9w3lVRLRepqkk4HnmKSmS9zC7yL
         AeCg==
X-Gm-Message-State: AC+VfDzmrtq2AyDb1FMd0SaLRCaJVLsSO7fLJh4Yfwfznwb8YUWvB8kr
	9kEh1GAJRUqXDbcjquVPEGhS3roeHc1XlPd3bmtasYctvnk6iJjkxVS6usXAiePXF4rfj/U1guB
	RC8liQjlvnKegt7lL
X-Received: by 2002:a05:622a:1887:b0:3f9:ab19:714b with SMTP id v7-20020a05622a188700b003f9ab19714bmr20006071qtc.3.1686741726447;
        Wed, 14 Jun 2023 04:22:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5V/N6Pd0BDXabSLy6yB25prqhjDYwFEEsOCZOhLe8QIJ2wjnytdWT8za6rGzFd5QSbiLMWCg==
X-Received: by 2002:a05:622a:1887:b0:3f9:ab19:714b with SMTP id v7-20020a05622a188700b003f9ab19714bmr20006050qtc.3.1686741726199;
        Wed, 14 Jun 2023 04:22:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-67.dyn.eolo.it. [146.241.244.67])
        by smtp.gmail.com with ESMTPSA id h27-20020ac8777b000000b003f6f83de87esm4910905qtu.92.2023.06.14.04.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 04:22:05 -0700 (PDT)
Message-ID: <4c056da27c19d95ffeaba5acf1427ecadfc3f94c.camel@redhat.com>
Subject: Re: [PATCH net-next 04/10] mlxsw: spectrum_router: Access rif->dev
 from params in mlxsw_sp_rif_create()
From: Paolo Abeni <pabeni@redhat.com>
To: Petr Machata <petrm@nvidia.com>, "David S. Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>, 
	mlxsw@nvidia.com
Date: Wed, 14 Jun 2023 13:22:02 +0200
In-Reply-To: <7397c89078f4736857e9f8cbcf41f9b361960cf9.1686581444.git.petrm@nvidia.com>
References: <cover.1686581444.git.petrm@nvidia.com>
	 <7397c89078f4736857e9f8cbcf41f9b361960cf9.1686581444.git.petrm@nvidia.com>
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

On Mon, 2023-06-12 at 17:31 +0200, Petr Machata wrote:
> The previous patch added a helper to access a netdevice given a RIF. Usin=
g
> this helper in mlxsw_sp_rif_create() is unreasonable: the netdevice was
> given in RIF creation parameters. Just take it there.
>=20
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/driv=
ers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index e9183c223575..da582ef8efda 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -8138,7 +8138,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
>  		err =3D -ENOMEM;
>  		goto err_rif_alloc;
>  	}
> -	dev_hold(rif->dev);
> +	dev_hold(params->dev);
>  	mlxsw_sp->router->rifs[rif_index] =3D rif;
>  	rif->mlxsw_sp =3D mlxsw_sp;
>  	rif->ops =3D ops;
> @@ -8166,12 +8166,12 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
>  			goto err_mr_rif_add;
>  	}
> =20
> -	if (netdev_offload_xstats_enabled(rif->dev,
> +	if (netdev_offload_xstats_enabled(params->dev,
>  					  NETDEV_OFFLOAD_XSTATS_TYPE_L3)) {
>  		err =3D mlxsw_sp_router_port_l3_stats_enable(rif);
>  		if (err)
>  			goto err_stats_enable;
> -		mlxsw_sp_router_hwstats_notify_schedule(rif->dev);
> +		mlxsw_sp_router_hwstats_notify_schedule(params->dev);
>  	} else {
>  		mlxsw_sp_rif_counters_alloc(rif);
>  	}
> @@ -8189,7 +8189,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
>  		mlxsw_sp_fid_put(fid);
>  err_fid_get:
>  	mlxsw_sp->router->rifs[rif_index] =3D NULL;
> -	dev_put(rif->dev);
> +	dev_put(params->dev);

Side note: since you are touching this, and dev_{put,hold} are now
deprecated in favour of the tracker-enabled variants netdev_{put,hold},
what about a follow-up introducing the usage of the latter helpers?

Thanks!

Paolo


