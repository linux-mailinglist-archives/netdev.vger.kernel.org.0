Return-Path: <netdev+bounces-6252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB617155D8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBA1F2810B6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645069462;
	Tue, 30 May 2023 06:58:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5759F7E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:58:53 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0455EC
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:58:50 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f60b3f32b4so26379535e9.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 23:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685429929; x=1688021929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0pE84img6VA59mho2/zAPltHLyYNfjO3JeQ9UlXjnQM=;
        b=dN7NfDC947j/cTjvW9YkEwSuGfsquU0rAhPjShJBPobdncvI0/MZiTGkqrEbTO2xv3
         R//69LRcCY7KF1wzmcX4JOGVkmP2THvM7Xj1iYbzWAzpCAkkmUNC92LHcTW7fL5zEQ1D
         UyqJa5h4GTenOuW+hhpSBrj36SBeEc9f1iuCdihiKsVkPKSgb3bfh/dS8BxLH7R0UbyX
         cBYtAqYgCV+zO+2ooll9tIiQncVHepQrpd1npnNnBzmGLVJVuEqsGDsDzv3CnWzBlOlu
         VFQJ4L/xDG2sdq8t0tzsDOPfhA8a/+bWoqYQjMtJ61ir98ti1BFeYTHNXDhnxB284fqI
         /mSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685429929; x=1688021929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pE84img6VA59mho2/zAPltHLyYNfjO3JeQ9UlXjnQM=;
        b=AGC6dhdR3RvHgwh1onFc90i9mlXgk11xMZmGN65kMKn0BW2bd/FnNwMm9YJEQ3AdLp
         qKjhwNrib87SmZfrLUjQKTiUjuW4ddu9JEKwVrrjCk3EjYCSDhurXHYX5UH2TbqS8lJX
         ekiXw9e6q6l23YstSsDilq+K+TbggPnHALsJZcgoTd48f6TwsUOsdGjnHT7SETU3okTi
         HwXlNF4yPvPNa5tU/oD/sJqgvFK8hf45YBnyAAvQdDzHIyONqrp2S+lwL9+Dh1sj1l+I
         sOn+AD27EdiA8Qc+j1DraJr06G7/AjHplfnwBrlfapLOEMqCZMgEXKHuX8GPD3Op6qoq
         TrLQ==
X-Gm-Message-State: AC+VfDyI6rxL3qf10Du074Wk6SBKFEPaVFx0YhXYzD76Z1wwPw1T8QmD
	a+Dx7WavA2oCwHv2wSKY/JaQ+Q==
X-Google-Smtp-Source: ACHHUZ7J06oBlAaY4uMxyexp8qxY0ULISozrcUnEYg8Y+I+4XInZGL8WoUg8DX7WGoCaoAmpx/yH9Q==
X-Received: by 2002:a05:600c:24a:b0:3f6:464:4b22 with SMTP id 10-20020a05600c024a00b003f604644b22mr754989wmj.40.1685429929257;
        Mon, 29 May 2023 23:58:49 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w8-20020a1cf608000000b003f18b942338sm16464730wmc.3.2023.05.29.23.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:58:48 -0700 (PDT)
Date: Tue, 30 May 2023 08:58:47 +0200
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
Message-ID: <ZHWep0dU9gCGJW0d@nanopsycho>
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

Yeah, I had the same problem with that, but after a lots of thinking,
it is a best I could think of. Please see below for the reasoning.


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

Btw, this ifdef is going to go away in a follow-up patchset.


>>  	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>>  	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>>  	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
>
>Is it okay if we deferred the port_del() patch until there's some
>clear benefit?

Well actually, there is a clear benefit even in this patchset:

We have 2 flavours of ports each with different ops in mlx5:
VF:
static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
        .port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
        .port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
        .port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
        .port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
        .port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
        .port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
};

SF:
static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
        .port_del = mlx5_devlink_sf_port_del,
        .port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
        .port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
        .port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
        .port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
        .port_fn_state_get = mlx5_devlink_sf_port_fn_state_get,
        .port_fn_state_set = mlx5_devlink_sf_port_fn_state_set,
};

You can see that the port_del() op is supported only on the SF flavour.
VF does not support it and therefore port_del() is not defined on it.

Without this patch, I would have to have a helper
mlx5_devlink_port_del() that would check if the port is SF and call
mlx5_devlink_sf_port_del() in that case. This patch reduces the
boilerplate.


Btw if you look at the cmd line api, it also aligns:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 101
pci/0000:08:00.0/32768: type eth netdev eth4 flavour pcisf controller 0 pfnum 0 sfnum 101 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached
$ devlink port del pci/0000:08:00.0/32768

You use pci/0000:08:00.0/32768 as a delete handle.

port_del() is basically an object destructor. Would it perhaps help to
rename is to .port_destructor()? That would somehow ease the asymmetry
:) IDK. I would leave the name as it is a and move to port_ops.

