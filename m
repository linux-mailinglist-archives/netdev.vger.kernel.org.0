Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63949571BE3
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiGLOB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiGLOBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:01:43 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0670723163
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:01:34 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d13-20020a05600c34cd00b003a2dc1cf0b4so4861828wmq.4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iB+iO3Y9bbOwcRGmvCAR8s5mgXRQeD2XmHCLNfGVqag=;
        b=nKeVnXYcAd6DMKqOw5Ae99BOriljcty1bpe/swUEnGp92FVPGn3RtrNqlMncdKnBHK
         oe2zizFI2nsE1lXYcWT5uJlAqKczJG+aFhC1IAaxVYV7nEm/zdQs2IL6/eFdOCrGxxIY
         X1qevKmkig5w/Gc7pmNPzWD1tFbWZAvmjM/HeRvgmonx/Cy58aEZGP1aVvdDS4LNKhU1
         S93RJPMgcD1Tdxmqw6T6Q9Liuu+40dvhL6jC1wj3vR92Qhs2FUW9RLQBJD+FSl5JpAFY
         4SAxdBTdNHusjdIKYgG/xbNwYT7iu+goDryzwMOkWjBav9jDubj5DQNGLDs/EsV2tSwf
         4lkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iB+iO3Y9bbOwcRGmvCAR8s5mgXRQeD2XmHCLNfGVqag=;
        b=KKak5rkOPHWpk5tJW8yd94XBlZRq44wh42NVCfWVGIBV1lfis8c7Q8hYn2Kq1Df0H9
         Vs+xls/N+QE+Vjvc/UFYNjCGtN3mw8SWwR4nY6KYhzXUOz9pWpuJKCy/bl6LM1BMQKMc
         nbUQ0GbC8FuiTll+Ncct+kBCmysAx+iJWfGO06NXBkAJMeRhK9mftdrxNS/lZEMlWbCE
         aw+lWvpGllxx5Ky6nJiTgy3WXM9h4jXnwD3ybGtkp05KskP/e/I3RB+Yu91AgFkcnGXD
         /Uz8aK0GKItpc/rK5ZDgYSWMjAE0jMQLytqf7FDux46D/gPBM8kxNJPncaqbsVQq/3v5
         smGg==
X-Gm-Message-State: AJIora++IHQBeYQNFWuY7f5GX0jx8COhtMEMa+p+q8y2acGwwyQCPWCr
        jwSXLf4E9tSEmgbH6QH9YLeE+Q==
X-Google-Smtp-Source: AGRyM1uaZ9F7g4JFnDk1+etvAuWCVSyu5sImblrNKeTSw7a87s3RZvOypHFy+7LkwJHqR1nAQgHwSw==
X-Received: by 2002:a7b:cd09:0:b0:3a2:e395:5cd1 with SMTP id f9-20020a7bcd09000000b003a2e3955cd1mr4034113wmj.132.1657634493174;
        Tue, 12 Jul 2022 07:01:33 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q1-20020a056000136100b00210320d9fbfsm10231500wrz.18.2022.07.12.07.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:01:32 -0700 (PDT)
Date:   Tue, 12 Jul 2022 16:01:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next RFC 07/10] mlxsw: convert driver to use unlocked
 devlink API during init/fini
Message-ID: <Ys1+ujEnt+dvNw2y@nanopsycho>
References: <20220712110511.2834647-1-jiri@resnulli.us>
 <20220712110511.2834647-8-jiri@resnulli.us>
 <Ys14Gorcg1JV5UIF@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys14Gorcg1JV5UIF@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 12, 2022 at 03:33:14PM CEST, idosch@nvidia.com wrote:
>On Tue, Jul 12, 2022 at 01:05:08PM +0200, Jiri Pirko wrote:
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>> index ab1cebf227fb..b0267e4dca27 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>> @@ -127,11 +127,11 @@ static int mlxsw_core_resources_ports_register(struct mlxsw_core *mlxsw_core)
>>  					  max_ports, 1,
>>  					  DEVLINK_RESOURCE_UNIT_ENTRY);
>>  
>> -	return devlink_resource_register(devlink,
>> -					 DEVLINK_RESOURCE_GENERIC_NAME_PORTS,
>> -					 max_ports, MLXSW_CORE_RESOURCE_PORTS,
>> -					 DEVLINK_RESOURCE_ID_PARENT_TOP,
>> -					 &ports_num_params);
>> +	return devl_resource_register(devlink,
>> +				      DEVLINK_RESOURCE_GENERIC_NAME_PORTS,
>> +				      max_ports, MLXSW_CORE_RESOURCE_PORTS,
>> +				      DEVLINK_RESOURCE_ID_PARENT_TOP,
>> +				      &ports_num_params);
>>  }
>>  
>>  static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core, bool reload)
>> @@ -157,8 +157,8 @@ static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core, bool reload)
>>  			goto err_resources_ports_register;
>>  	}
>>  	atomic_set(&mlxsw_core->active_ports_count, 0);
>> -	devlink_resource_occ_get_register(devlink, MLXSW_CORE_RESOURCE_PORTS,
>> -					  mlxsw_ports_occ_get, mlxsw_core);
>> +	devl_resource_occ_get_register(devlink, MLXSW_CORE_RESOURCE_PORTS,
>> +				       mlxsw_ports_occ_get, mlxsw_core);
>>  
>>  	return 0;
>>  
>> @@ -171,9 +171,9 @@ static void mlxsw_ports_fini(struct mlxsw_core *mlxsw_core, bool reload)
>>  {
>>  	struct devlink *devlink = priv_to_devlink(mlxsw_core);
>>  
>> -	devlink_resource_occ_get_unregister(devlink, MLXSW_CORE_RESOURCE_PORTS);
>> +	devl_resource_occ_get_unregister(devlink, MLXSW_CORE_RESOURCE_PORTS);
>>  	if (!reload)
>> -		devlink_resources_unregister(priv_to_devlink(mlxsw_core));
>> +		devl_resources_unregister(priv_to_devlink(mlxsw_core));
>>  
>>  	kfree(mlxsw_core->ports);
>>  }
>> @@ -1485,10 +1485,12 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>>  {
>>  	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>>  
>> +	devl_lock(devlink);
>>  	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_RESET))
>>  		return -EOPNOTSUPP;
>
>Not releasing the lock. You can take it after this check as these
>features do not change

Yep.


>
>>  
>>  	mlxsw_core_bus_device_unregister(mlxsw_core, true);
>> +	devl_unlock(devlink);
>>  	return 0;
>>  }
>>  
>> @@ -1498,13 +1500,17 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_re
>>  					struct netlink_ext_ack *extack)
>>  {
>>  	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>> +	int err;
>>  
>> +	devl_lock(devlink);
>>  	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>>  			     BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
>> -	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
>> -					      mlxsw_core->bus,
>> -					      mlxsw_core->bus_priv, true,
>> -					      devlink, extack);
>> +	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
>> +					     mlxsw_core->bus,
>> +					     mlxsw_core->bus_priv, true,
>> +					     devlink, extack);
>> +	devl_unlock(devlink);
>> +	return err;
>>  }
>>  
>>  static int mlxsw_devlink_flash_update(struct devlink *devlink,
>> @@ -2102,6 +2108,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
>>  			err = -ENOMEM;
>>  			goto err_devlink_alloc;
>>  		}
>> +		devl_lock(devlink);
>
>Why not just take it in mlxsw_core_bus_device_register() if '!reload' ?
>Easier to read and also consistent with the change in
>mlxsw_core_bus_device_unregister()

Will check.


>
>
>>  	}
>>  
>>  	mlxsw_core = devlink_priv(devlink);
>> @@ -2188,6 +2195,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
>>  	if (!reload) {
>>  		devlink_set_features(devlink, DEVLINK_F_RELOAD);
>>  		devlink_register(devlink);
>> +		devl_unlock(devlink);
>
>Did you check this with lockdep? devlink_register() now acquires the
>global devlink mutex under the per-instance lock, but devlink core uses
>the reverse order.

Correct. I have another patch in queue which removes devlink_mutex from
register/unregister, so that fixed it for me.


>
>>  	}
>>  	return 0;
>>  
>> @@ -2214,12 +2222,14 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
>>  	mlxsw_ports_fini(mlxsw_core, reload);
>>  err_ports_init:
>>  	if (!reload)
>> -		devlink_resources_unregister(devlink);
>> +		devl_resources_unregister(devlink);
>>  err_register_resources:
>>  	mlxsw_bus->fini(bus_priv);
>>  err_bus_init:
>> -	if (!reload)
>> +	if (!reload) {
>> +		devl_unlock(devlink);
>>  		devlink_free(devlink);
>> +	}
>>  err_devlink_alloc:
>>  	return err;
>>  }
>> @@ -2255,8 +2265,10 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
>>  {
>>  	struct devlink *devlink = priv_to_devlink(mlxsw_core);
>>  
>> -	if (!reload)
>> +	if (!reload) {
>> +		devl_lock(devlink);
>>  		devlink_unregister(devlink);
>> +	}
>>  
>>  	if (devlink_is_reload_failed(devlink)) {
>>  		if (!reload)
>> @@ -2281,17 +2293,20 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
>>  	kfree(mlxsw_core->lag.mapping);
>>  	mlxsw_ports_fini(mlxsw_core, reload);
>>  	if (!reload)
>> -		devlink_resources_unregister(devlink);
>> +		devl_resources_unregister(devlink);
>>  	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
>> -	if (!reload)
>> +	if (!reload) {
>>  		devlink_free(devlink);
>> +		devl_unlock(devlink);
>> +	}
>>  
>>  	return;
>>  
>>  reload_fail_deinit:
>>  	mlxsw_core_params_unregister(mlxsw_core);
>> -	devlink_resources_unregister(devlink);
>> +	devl_resources_unregister(devlink);
>>  	devlink_free(devlink);
>> +	devl_unlock(devlink);
>>  }
>>  EXPORT_SYMBOL(mlxsw_core_bus_device_unregister);
