Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961D657B637
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 14:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiGTMRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 08:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiGTMRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 08:17:07 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F772A1BB
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:17:05 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id va17so32793829ejb.0
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iei3LcSnLX40SgKJHTegWBrbnKC/AnNrI7G+YvUAZ8M=;
        b=33DCPRYhG8I/pZUTzsuOgPP6Xu0jNucDCT6CYe7X7h2r8ExXQH21Wxhw2bIX19u9tF
         U4kIaJvglaobhOXuS4I41HC7mu34nbTMlnJEThIATsX4hGYXcXI9oep+OG3iUKl6druF
         E0u2N6gisyescRlxHQ4IiklJqo6+t2XO4V/NXMvEj7oLDSMdcrRpI16rfNXgQkuXm9NA
         n4Vp4i4FmgBLEjPsqOVtIOPEZIUfWjMDfd719sIuNxdh3Bks6FjfPEG8N6SSN1Lmh3Xo
         Ty20oza8eHycu+HjhR4UnWrFu2fev8j125Ugf3Usz/5EUn9e1RWZ3rhQWhAITM/TGBYP
         10VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iei3LcSnLX40SgKJHTegWBrbnKC/AnNrI7G+YvUAZ8M=;
        b=s3XXkk7Q+N3cq+Bl7iEOjqE9P8WIUyk263DrzYw+iX0pWQCzYiGo7SgHOnCYCll9xK
         0lj14slqOqFet9tnh35KPwM0fiuBkUAJ0JTvX7/2NSlz+XbAMd7eRyvQigNsaQ6dUmmU
         3Vt3KAaRcXsrn9LLn7Ld+ntBpal2t2wSTZ54k57u5yD7RTNb5K4yCuMpnmy3hC0iO8dd
         voWEe8LBw2LBcJHVpEeFCixeJ60rK8+7RwnUDnH/lnqsqVvBAHeGai4S+TRRGX6jkYJC
         UaX2HRYfu5atG0xlgn/LUdZWR03Df+9i1k26gfRZoBM2XwFMWpW10RkvP94e5LVcZgw1
         IzTA==
X-Gm-Message-State: AJIora/zcN2FUeWAMwwayeqySNlrO5J8BNZCv1NU9SjY53x/KE5cKD9q
        HpMYGbCEKgah5ygPNfnxSNCz70BqAAOoteKeAXo=
X-Google-Smtp-Source: AGRyM1vBA8foaxvZigMr0r3Bz8Utvcc8RbZfWuaPt7cjKTmDwx0ug/ry9frfogaqusFhcYOeE5AuiA==
X-Received: by 2002:a17:907:7e94:b0:72b:53d2:c004 with SMTP id qb20-20020a1709077e9400b0072b53d2c004mr35976285ejc.387.1658319423701;
        Wed, 20 Jul 2022 05:17:03 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id q25-20020a17090676d900b006fece722508sm7903279ejn.135.2022.07.20.05.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 05:17:03 -0700 (PDT)
Date:   Wed, 20 Jul 2022 14:17:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 03/12] mlxsw: core_linecards: Introduce per
 line card auxiliary device
Message-ID: <YtfyPeZO9Q/hgln1@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-4-jiri@resnulli.us>
 <YtfAqmq4v0u9we9Z@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtfAqmq4v0u9we9Z@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 10:45:30AM CEST, idosch@nvidia.com wrote:
>On Tue, Jul 19, 2022 at 08:48:38AM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> In order to be eventually able to expose line card gearbox version and
>> possibility to flash FW, model the line card as a separate device on
>> auxiliary bus.
>
>What is the reason for adding the auxiliary device for the line card
>when it becomes 'provisioned' and not when it becomes 'active'? It needs
>to be explained in the commit message

Okay, done.


>
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>> v1->v2:
>> - added auxdev removal to mlxsw_linecard_fini()
>> - adjusted mlxsw_linecard_bdev_del() to cope with bdev == NULL
>> ---
>>  drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
>>  drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
>>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  13 +-
>>  drivers/net/ethernet/mellanox/mlxsw/core.h    |  10 ++
>>  .../mellanox/mlxsw/core_linecard_dev.c        | 155 ++++++++++++++++++
>>  .../ethernet/mellanox/mlxsw/core_linecards.c  |  11 ++
>>  6 files changed, 189 insertions(+), 3 deletions(-)
>>  create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
>> 
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
>> index 4683312861ac..a510bf2cff2f 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
>> @@ -7,6 +7,7 @@ config MLXSW_CORE
>>  	tristate "Mellanox Technologies Switch ASICs support"
>>  	select NET_DEVLINK
>>  	select MLXFW
>> +	select AUXILIARY_BUS
>>  	help
>>  	  This driver supports Mellanox Technologies Switch ASICs family.
>>  
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
>> index c2d6d64ffe4b..3ca9fce759ea 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
>> @@ -2,7 +2,7 @@
>>  obj-$(CONFIG_MLXSW_CORE)	+= mlxsw_core.o
>>  mlxsw_core-objs			:= core.o core_acl_flex_keys.o \
>>  				   core_acl_flex_actions.o core_env.o \
>> -				   core_linecards.o
>> +				   core_linecards.o core_linecard_dev.o
>>  mlxsw_core-$(CONFIG_MLXSW_CORE_HWMON) += core_hwmon.o
>>  mlxsw_core-$(CONFIG_MLXSW_CORE_THERMAL) += core_thermal.o
>>  obj-$(CONFIG_MLXSW_PCI)		+= mlxsw_pci.o
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>> index 61eb96b93889..831b0d3472c6 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>> @@ -3334,9 +3334,15 @@ static int __init mlxsw_core_module_init(void)
>>  {
>>  	int err;
>>  
>> +	err = mlxsw_linecard_driver_register();
>> +	if (err)
>> +		return err;
>> +
>>  	mlxsw_wq = alloc_workqueue(mlxsw_core_driver_name, 0, 0);
>> -	if (!mlxsw_wq)
>> -		return -ENOMEM;
>> +	if (!mlxsw_wq) {
>> +		err = -ENOMEM;
>> +		goto err_alloc_workqueue;
>> +	}
>>  	mlxsw_owq = alloc_ordered_workqueue("%s_ordered", 0,
>>  					    mlxsw_core_driver_name);
>>  	if (!mlxsw_owq) {
>> @@ -3347,6 +3353,8 @@ static int __init mlxsw_core_module_init(void)
>>  
>>  err_alloc_ordered_workqueue:
>>  	destroy_workqueue(mlxsw_wq);
>> +err_alloc_workqueue:
>> +	mlxsw_linecard_driver_unregister();
>>  	return err;
>>  }
>>  
>> @@ -3354,6 +3362,7 @@ static void __exit mlxsw_core_module_exit(void)
>>  {
>>  	destroy_workqueue(mlxsw_owq);
>>  	destroy_workqueue(mlxsw_wq);
>> +	mlxsw_linecard_driver_unregister();
>>  }
>>  
>>  module_init(mlxsw_core_module_init);
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
>> index a3491ef2aa7e..b22db13fa547 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/core.h
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
>> @@ -12,6 +12,7 @@
>>  #include <linux/skbuff.h>
>>  #include <linux/workqueue.h>
>>  #include <linux/net_namespace.h>
>> +#include <linux/auxiliary_bus.h>
>>  #include <net/devlink.h>
>>  
>>  #include "trap.h"
>> @@ -561,6 +562,8 @@ enum mlxsw_linecard_status_event_type {
>>  	MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION,
>>  };
>>  
>> +struct mlxsw_linecard_bdev;
>> +
>>  struct mlxsw_linecard {
>>  	u8 slot_index;
>>  	struct mlxsw_linecards *linecards;
>> @@ -575,6 +578,7 @@ struct mlxsw_linecard {
>>  	   active:1;
>>  	u16 hw_revision;
>>  	u16 ini_version;
>> +	struct mlxsw_linecard_bdev *bdev;
>>  };
>>  
>>  struct mlxsw_linecard_types_info;
>> @@ -614,4 +618,10 @@ void mlxsw_linecards_event_ops_unregister(struct mlxsw_core *mlxsw_core,
>>  					  struct mlxsw_linecards_event_ops *ops,
>>  					  void *priv);
>>  
>> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard);
>> +void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard);
>> +
>> +int mlxsw_linecard_driver_register(void);
>> +void mlxsw_linecard_driver_unregister(void);
>> +
>>  #endif
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
>> new file mode 100644
>> index 000000000000..bb6068b62df0
>> --- /dev/null
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
>> @@ -0,0 +1,155 @@
>> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>> +/* Copyright (c) 2022 NVIDIA Corporation and Mellanox Technologies. All rights reserved */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/err.h>
>> +#include <linux/types.h>
>> +#include <linux/err.h>
>> +#include <linux/auxiliary_bus.h>
>> +#include <linux/idr.h>
>> +#include <linux/gfp.h>
>> +#include <linux/slab.h>
>> +#include <net/devlink.h>
>> +#include "core.h"
>> +
>> +#define MLXSW_LINECARD_DEV_ID_NAME "lc"
>> +
>> +struct mlxsw_linecard_dev {
>> +	struct mlxsw_linecard *linecard;
>> +};
>> +
>> +struct mlxsw_linecard_bdev {
>> +	struct auxiliary_device adev;
>> +	struct mlxsw_linecard *linecard;
>> +	struct mlxsw_linecard_dev *linecard_dev;
>> +};
>> +
>> +static DEFINE_IDA(mlxsw_linecard_bdev_ida);
>> +
>> +static int mlxsw_linecard_bdev_id_alloc(void)
>> +{
>> +	return ida_alloc(&mlxsw_linecard_bdev_ida, GFP_KERNEL);
>> +}
>> +
>> +static void mlxsw_linecard_bdev_id_free(int id)
>> +{
>> +	ida_free(&mlxsw_linecard_bdev_ida, id);
>> +}
>> +
>> +static void mlxsw_linecard_bdev_release(struct device *device)
>> +{
>> +	struct auxiliary_device *adev =
>> +			container_of(device, struct auxiliary_device, dev);
>> +	struct mlxsw_linecard_bdev *linecard_bdev =
>> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
>> +
>> +	mlxsw_linecard_bdev_id_free(adev->id);
>> +	kfree(linecard_bdev);
>> +}
>> +
>> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
>> +{
>> +	struct mlxsw_linecard_bdev *linecard_bdev;
>> +	int err;
>> +	int id;
>> +
>> +	id = mlxsw_linecard_bdev_id_alloc();
>> +	if (id < 0)
>> +		return id;
>> +
>> +	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
>> +	if (!linecard_bdev) {
>> +		mlxsw_linecard_bdev_id_free(id);
>> +		return -ENOMEM;
>> +	}
>> +	linecard_bdev->adev.id = id;
>> +	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
>> +	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
>> +	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
>> +	linecard_bdev->linecard = linecard;
>> +
>> +	err = auxiliary_device_init(&linecard_bdev->adev);
>> +	if (err) {
>> +		mlxsw_linecard_bdev_id_free(id);
>> +		kfree(linecard_bdev);
>> +		return err;
>> +	}
>> +
>> +	err = auxiliary_device_add(&linecard_bdev->adev);
>> +	if (err) {
>> +		auxiliary_device_uninit(&linecard_bdev->adev);
>> +		return err;
>> +	}
>> +
>> +	linecard->bdev = linecard_bdev;
>> +	return 0;
>> +}
>> +
>> +void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard)
>> +{
>> +	struct mlxsw_linecard_bdev *linecard_bdev = linecard->bdev;
>> +
>> +	if (!linecard_bdev)
>
>This check is needed because of the invocation from
>mlxsw_linecard_fini() ? If so, please add a comment. Something like:
>
>/* Unprovisioned line cards do not have an auxiliary device. */

Okay, added.


>
>> +		return;
>> +	auxiliary_device_delete(&linecard_bdev->adev);
>> +	auxiliary_device_uninit(&linecard_bdev->adev);
>> +	linecard->bdev = NULL;
>> +}
>> +
>> +static const struct devlink_ops mlxsw_linecard_dev_devlink_ops = {
>> +};
>> +
>> +static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
>> +				     const struct auxiliary_device_id *id)
>> +{
>> +	struct mlxsw_linecard_bdev *linecard_bdev =
>> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
>> +	struct mlxsw_linecard_dev *linecard_dev;
>> +	struct devlink *devlink;
>> +
>> +	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
>> +				sizeof(*linecard_dev), &adev->dev);
>> +	if (!devlink)
>> +		return -ENOMEM;
>> +	linecard_dev = devlink_priv(devlink);
>> +	linecard_dev->linecard = linecard_bdev->linecard;
>> +	linecard_bdev->linecard_dev = linecard_dev;
>> +
>> +	devlink_register(devlink);
>> +	return 0;
>> +}
>> +
>> +static void mlxsw_linecard_bdev_remove(struct auxiliary_device *adev)
>> +{
>> +	struct mlxsw_linecard_bdev *linecard_bdev =
>> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
>> +	struct devlink *devlink = priv_to_devlink(linecard_bdev->linecard_dev);
>> +
>> +	devlink_unregister(devlink);
>> +	devlink_free(devlink);
>> +}
>> +
>> +static const struct auxiliary_device_id mlxsw_linecard_bdev_id_table[] = {
>> +	{ .name = KBUILD_MODNAME "." MLXSW_LINECARD_DEV_ID_NAME },
>> +	{},
>> +};
>> +
>> +MODULE_DEVICE_TABLE(auxiliary, mlxsw_linecard_bdev_id_table);
>> +
>> +static struct auxiliary_driver mlxsw_linecard_driver = {
>> +	.name = MLXSW_LINECARD_DEV_ID_NAME,
>> +	.probe = mlxsw_linecard_bdev_probe,
>> +	.remove = mlxsw_linecard_bdev_remove,
>> +	.id_table = mlxsw_linecard_bdev_id_table,
>> +};
>> +
>> +int mlxsw_linecard_driver_register(void)
>> +{
>> +	return auxiliary_driver_register(&mlxsw_linecard_driver);
>> +}
>> +
>> +void mlxsw_linecard_driver_unregister(void)
>> +{
>> +	auxiliary_driver_unregister(&mlxsw_linecard_driver);
>> +}
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
>> index 5c9869dcf674..43696d8badca 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
>> @@ -232,6 +232,7 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>>  {
>>  	struct mlxsw_linecards *linecards = linecard->linecards;
>>  	const char *type;
>> +	int err;
>>  
>>  	type = mlxsw_linecard_types_lookup(linecards, card_type);
>>  	mlxsw_linecard_status_event_done(linecard,
>> @@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>>  	linecard->provisioned = true;
>>  	linecard->hw_revision = hw_revision;
>>  	linecard->ini_version = ini_version;
>> +
>> +	err = mlxsw_linecard_bdev_add(linecard);
>> +	if (err) {
>> +		linecard->provisioned = false;
>> +		mlxsw_linecard_provision_fail(linecard);
>> +		return err;
>> +	}
>> +
>>  	devlink_linecard_provision_set(linecard->devlink_linecard, type);
>>  	return 0;
>>  }
>> @@ -260,6 +269,7 @@ static void mlxsw_linecard_provision_clear(struct mlxsw_linecard *linecard)
>>  {
>>  	mlxsw_linecard_status_event_done(linecard,
>>  					 MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION);
>> +	mlxsw_linecard_bdev_del(linecard);
>>  	linecard->provisioned = false;
>>  	devlink_linecard_provision_clear(linecard->devlink_linecard);
>>  }
>> @@ -885,6 +895,7 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
>>  	mlxsw_core_flush_owq();
>>  	if (linecard->active)
>>  		mlxsw_linecard_active_clear(linecard);
>> +	mlxsw_linecard_bdev_del(linecard);
>>  	devlink_linecard_destroy(linecard->devlink_linecard);
>>  	mutex_destroy(&linecard->lock);
>>  }
>> -- 
>> 2.35.3
>> 
