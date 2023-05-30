Return-Path: <netdev+bounces-6248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A58DB715585
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:33:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008972810CC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235AB1110;
	Tue, 30 May 2023 06:33:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156D67E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:33:25 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37169E8
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:33:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-3094910b150so4047139f8f.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685428400; x=1688020400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0CaTbkqipKHF/4cgQK7m5sFsqW1/AiCE4xcl9QWDCkE=;
        b=VIJROpdqecRKPKO18kI/qvkZLAL2G0dvztOP7r7F9T+EGaNpkWXI1RDHSrxALmotZm
         32Favjr9fdsFiVLdaulzWULqvj9yoeE45sE9kmNtoOdot+CaeJwfa0ZTUKRcMjJacGgx
         j85OP0/bWH4yQLJgzdXm6XMfpW4nv5nVc8H/OeI6oox1TnZ+uR9U942cfSlxnbmddp5b
         mZpt55FCNvPOXIpK0vcl/gFWeAHjgoTFSt3Cx+KYd6g5Mtg7NPZOgX3X3bA9GvjqNGQG
         pI5gfpmhIkC2P4NSxn7fqxWDAkNH8/AGwopofi/ILzWQZxqHxXOCHI00M9kJZiYHK3wT
         FJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685428400; x=1688020400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CaTbkqipKHF/4cgQK7m5sFsqW1/AiCE4xcl9QWDCkE=;
        b=VhyONB0snLJ/24RLiS5uTwfdTq1LWuCEHDjtBau2VxONeB4sIBwIn/3ethngc5PV7y
         uX+I2NnfDW7d9Hc6R59jCZzs26fxOqOUnVYy58+iDA6HxARNRsYbVPul+zhYybsUFMjy
         N9jPqy/6kundOlVjf/uYDeG/1lGw9uirAUZNZOP6A4HOz5SYwUabYE9Wz9jxYbkV6G43
         QJ8io/gIqA0LbEYzDvlrcNB7hULuP9+kcMLpwCuOoBLieM1TvnvhGBjv8vFfDw60cb4s
         hFFPy/r0YHM7lWiNVE6EwBKRGnl36gAyFC40eypL7Rl9RSjybCjWYV5KtCedwFQ8Yf1S
         QHkA==
X-Gm-Message-State: AC+VfDyMBWvjZ96eM2DCatNFBZPKkFQ/ID/wQhtNPJ+ySQdBO6jGGMhD
	qSs5Xt0e3f8IuE7jGLEYue8oMw==
X-Google-Smtp-Source: ACHHUZ5Pks+fKBdU2dJorWFfP9tr2Eu4zIO2oPrV1EAz0MWD0FXMujNCp8r0yZ6JrDLVDensddZ8tQ==
X-Received: by 2002:a5d:67c3:0:b0:30a:dfe1:ed02 with SMTP id n3-20020a5d67c3000000b0030adfe1ed02mr592387wrw.34.1685428400506;
        Mon, 29 May 2023 23:33:20 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h4-20020adfe984000000b002fe96f0b3acsm2113468wrm.63.2023.05.29.23.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:33:19 -0700 (PDT)
Date: Tue, 30 May 2023 08:33:18 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 14/15] devlink: move port_del() to
 devlink_port_ops
Message-ID: <ZHWYrgyi/GofFf8s@nanopsycho>
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-15-jiri@resnulli.us>
 <20230526211008.7b06ac3e@kernel.org>
 <ZHG0dSuA7s0ggN0o@nanopsycho>
 <20230528233334.77dc191d@kernel.org>
 <ZHRi0qZD/Hsjn0Fq@nanopsycho>
 <20230529184119.414d62f3@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529184119.414d62f3@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 30, 2023 at 03:41:19AM CEST, kuba@kernel.org wrote:
>On Mon, 29 May 2023 10:31:14 +0200 Jiri Pirko wrote:
>> >One could argue logically removing a port is also an operation of 
>> >the parent (i.e. the devlink instance). The fact that the port gets
>> >destroyed in the process is secondary. Ergo maybe we should skip 
>> >this patch?  
>> 
>> Well, the port_del() could differ for different port flavours. The
>> embedding structure of struct devlink_port is also different.
>> 
>> Makes sense to me to skip the flavour switch and have one port_del() for
>> each port.
>
>The asymmetry bothers me. It's hard to comment on what the best
>approach is given this series shows no benefit of moving port_del().
>Maybe even a loss, as mlx5 now has an ifdef in two places:
>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> index e39fd85ea2f9..63635cc44479 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> @@ -320,7 +320,6 @@ static const struct devlink_ops mlx5_devlink_ops = {
>>  #endif
>>  #ifdef CONFIG_MLX5_SF_MANAGER
>>  	.port_new = mlx5_devlink_sf_port_new,
>> -	.port_del = mlx5_devlink_sf_port_del,
>>  #endif
>>  	.flash_update = mlx5_devlink_flash_update,
>>  	.info_get = mlx5_devlink_info_get,
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
>> index 76c5d6e9d47f..f370f67d9e33 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
>> @@ -145,6 +145,9 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
>>  }
>>  
>>  static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
>> +#ifdef CONFIG_MLX5_SF_MANAGER
>> +	.port_del = mlx5_devlink_sf_port_del,
>> +#endif
>>  	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>>  	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>>  	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
>
>Is it okay if we deferred the port_del() patch until there's some
>clear benefit?

Sure.

