Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA5C571B5E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiGLNdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiGLNdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:33:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48879B656C
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 06:33:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oC3MvvkoxGckqqkV9z6iCgy/EDkpEdGUHzY2CLTNjwfQoGNnBcFW7Slt2LwXg1Wvmg8tvEwuzJHhC0nnNqUXuJ8BQ67fuLqN9VTTs11FBchjf+OxT8HznOh0AR3pQ+ulZKKL3Q1jUJ9y+ySLViMY7eLqV2M3+TfFRcdEiA8rAe/q/PJDalZhNkrnxLiO8HLAzusTOHe8X+FDBDY07HBPtdwTx88cR2qU+DmLKnPPulyDxAz2rMzsNeOmJuyMoAChOYAAXXC/dadyMrb+fv4AqP8J1VsNFmIpzzyNMLS3KcIDcFg68puE0ErzybKXCyW3/MXGldpKh8h6isiC4pEEXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGfp3EG9AaLhy6UY4kGt45S8AJprh0tx3MNVu4rM/M8=;
 b=Tujhocl4xkA/UoCQNVYHpvhybWhhxMCbjhYGsjNSusgnyIsgueehzwlOO7+eJ195+MKNIE+THLcDfl1DfvyDFUFjKLoGzlTN48zl6/QE15mvYrY7C/Otd6L+ESQtay0cQB6D/xlcad8M0QYvnRKt7UV9taIXWoY5mncardt1SJUf/GPoVfL8SwNXc79Tr2NICitQfgzlZkftcOnG9O1skTHCHGfHElLGKifimoe6LMAJ7szXGUBpnPoe4jUXvH0W2GXoS7FuDL9jBfw7l+x2wdniPpHlEVgeW3jLI39WAiPmvqnACKa8K95c8m0MBDsCiRTMuiGUz85DES5lJTIvCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGfp3EG9AaLhy6UY4kGt45S8AJprh0tx3MNVu4rM/M8=;
 b=RJU3YS9uwUaSaDDuqnGZWo5+JVDx/7cAgc8Crrde0aeEIoZx/GarLyboe6UDGShkF8/Z0ncRUd54INgOYIa4iRuzIIW5Fwk96wVSDgkdGBguJysya04DT3bhDs5v3W1GzceuptDCDa0ImPYm3/+jf8uz2pkiropMPTASyc+JG6whlbUpcEkuShRMyaYyVVj20iuimUPJUv+kzoYj+tx4KgXs/y9d2Ocw8ATWdsLl+J9o5KesVp4QWvIPA2JI+xHZwy46TsLZYXV5PY9wxRIXF9sXngE7BgkrSJsKd+XU3Cblrpa8QH/SfjgRWqHj7uwvigrwC6Za7L5/jCHTa0rL7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5232.namprd12.prod.outlook.com (2603:10b6:5:39c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 13:33:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 13:33:19 +0000
Date:   Tue, 12 Jul 2022 16:33:14 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next RFC 07/10] mlxsw: convert driver to use unlocked
 devlink API during init/fini
Message-ID: <Ys14Gorcg1JV5UIF@shredder>
References: <20220712110511.2834647-1-jiri@resnulli.us>
 <20220712110511.2834647-8-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712110511.2834647-8-jiri@resnulli.us>
X-ClientProxiedBy: LO6P123CA0031.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92d07a24-1c56-44e0-dc3e-08da640b1526
X-MS-TrafficTypeDiagnostic: DM4PR12MB5232:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HeBKo5Td6KPlYVas0DlcFRZ61xAvgwjEdAE5t1EhNyrmk0H8tJ2xxBXeROZqBiut0zaijhYVahNA+mrtDBtuEoeLXE0st0dvSNLRbgooBKHifNH2wYLcpTijpOCWc96giwXgMyh8T1brCozZ4QNBjvftuJwRO3NNzSuI0n+/KD07ApDv6huk+896Q8ZDSV/vBGwFA7uBYutU/+I0EgdxgBf4R0piKgpj4DIN2vjdvm9YPUi0Dvm96RDsWw4qdJ2VfPmkW1RNZRm2BJ7ICfGopECczzVp0MytwF7ur2IIbJFbc8HkNKFlx6u9IunKxXCMQ1W3UrxE3PeuFjjIcL+bKCww/TwsPwsrsCsApgq6CU4JbxxM2DzYI1eQH7t7T1XlzH0rlvAzoBBCveB4fWzpKLz3VB0McNhojfvwb8EUkUPySwzgJiVHjzi/Px0sXVjVw9BSYb8cGTyG9mvr+L8pO/7yGaq8cCqOIf+kiElLGgzMBvLRWqQJ+Sw0aHcyEkjeywytMmUMZIVNMiuW+RkASDefAi/tTg/kOBL9paRTqdPUYeBaTmKE7uE2ZAJ662ByAv0FyAVttt8w3+S4W+cvxn4HPwU/KGNPf482owBhaCODERoIQgu1clGStquOcwpgWtpuOdswTkEpNZm5xYe6x72RPAeGL/ZWwhK23t8H0dVwkgLn6ZJ7wjy7QqzvOPYzigX+C5k9q+wlwK6nPyKPmZTwc47yMUdRGQH2PbWU5aHzEoNf0/BEaaqBh3/G8Mxd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(39860400002)(376002)(396003)(346002)(5660300002)(6506007)(6512007)(8936002)(33716001)(26005)(83380400001)(9686003)(2906002)(38100700002)(478600001)(6916009)(6486002)(4326008)(66476007)(66556008)(86362001)(8676002)(66946007)(316002)(6666004)(41300700001)(186003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cwq5VlKIHrTiK07Hsq1iK0Gaq1UC5HuB8IZcBczjTcAwc1hMV8/ZYbeauxMj?=
 =?us-ascii?Q?BsCzng95jwDWa0zb+xMKPuiVYphrAd4F2VenWwnec0Yz1PfySYAjSrfiVM0h?=
 =?us-ascii?Q?bE0ST4vAwXzlQeyqMs1Y/OQiDIM85G2HXCimRc9mFRxEQJiWm96XJ44+Tk5z?=
 =?us-ascii?Q?MExCcuWCq0mx5DvgMaQRhA4qDvgESyPqOcdbmobauZKMdBlAGTPsz1HwXo9H?=
 =?us-ascii?Q?WopMXh/h2WmgN7ngmX0tgavz55wORS34zJCPNf7oZ1MUvvMjnpj3YtTmVibc?=
 =?us-ascii?Q?AGkxuIe1dPCExJCc/n8E68Iv8khD3UFeBF+vSRXME5ZZA35KeZ4q0hcvojFN?=
 =?us-ascii?Q?qNxrvMnqusls9BNd0d5P7dkD/sb/GnI44EFJ1vqyxDa4GxJPMUMtOq6M5XaK?=
 =?us-ascii?Q?TdDKSYORq5vx0JLzZFgWQfN10Oz7pjgR+63zQ9OqN54Mg9OSuANN03q+Q3NG?=
 =?us-ascii?Q?XQIb9doaQwiQonXC+aqbHzpOpELRwY/NW4BjDJ3aO1kXQ4UhvJD5rVted6Vy?=
 =?us-ascii?Q?1lO+7I8T53CbG8E9jkhq9tUFn94ZBvGt2be4cMCZeMGdda+RS5qrGVJUc4ue?=
 =?us-ascii?Q?4kZmp8LnSYlqrX9fTd2G04cO0+TkHNGS9xb/jgmBZO5QdM5dY5hDG0LQavFf?=
 =?us-ascii?Q?S1ePJVLPokFG6Mx1E4A6dOvz1GCnUwjeJqYUnZA9W3BtLAX9W8ct+NkoR4fZ?=
 =?us-ascii?Q?gEtfu7+Qjka3GVqbvXMyX7OawvacXUuKsJm/EaE2yFJeONFPrBPIKkNuVPe9?=
 =?us-ascii?Q?G+3FoAQ2oqv684JPhWRNT1B+p/c1XpWIQE1cOsUDiv1ey8u6P0q5+ObUjYwP?=
 =?us-ascii?Q?RreDTQarMilONQYam3LEcWwkEVLsCa37V9eKpf2rPf4np8amWzuXHGCid0lj?=
 =?us-ascii?Q?jlRnQVd2i1yaElJnCtqY8uASpGnaHjrsPiicNhiBYf8EUeXKJ5x+sPoxwVZx?=
 =?us-ascii?Q?SH8YRpzMWZ+llb+zmHE2WL9jkVo7+0hnXAJtf98SqHsiT6GxYmEEbRwYxThb?=
 =?us-ascii?Q?Ip2N8Ge230MWsc6GKsLHNYrfBORiidnd/AH0RoM8ccQRNbgsdYmSL7G+7QJ9?=
 =?us-ascii?Q?YUz5C8cc1nhwM3XvqFvtejgwM68/vQ5YtgLHfQjBVZ+qXfIRgAyPFZbjRgEE?=
 =?us-ascii?Q?tEs6c/sdqwtyLMJAc8hdBmIdDrSvTfj1zoChdlOk3scm3SPfJTuujHvO64rF?=
 =?us-ascii?Q?M3drxhAKi1SDKaZCyhiFSAmLiioCan8So03hOJe92E9IpJtFP1/0pZZFz58Q?=
 =?us-ascii?Q?E4d4TNjDJ6AJKOXV553WMGoK2OoC/ry9mn4OGXcGcjYg3TlOxWm7//blbO/U?=
 =?us-ascii?Q?qPn3+yEqzqO+l4goBDVWtHPzaZnBRSky0bni78GHxWRAXfTKYDTdQ+gyTVex?=
 =?us-ascii?Q?YaRO7zt1IuLiWZq9PlJ6HC71t+7954bNRmer1itZEHcKHh+2YlT/Upn3H7bF?=
 =?us-ascii?Q?oJ84PV6jhYN1qjeQmnL8LFHSHTkBrvKZ/GSFl+lkxTwoacUz/dTYxc8O0QJl?=
 =?us-ascii?Q?fmJ6uz1DtnsXgwDIoyT4AL8wrWZ398p4DbyWm+n9oel8b/zsBK7PzIiSf3jE?=
 =?us-ascii?Q?4ZUea1wK/OqnMGjibZVFD+6KWr3R9YsCJrnOgieL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d07a24-1c56-44e0-dc3e-08da640b1526
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 13:33:18.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okOoaF9rxpoXLUGyFd4KeHJ4t1oboPx11oqhxFDjPsb6TytIDumnf50gB2EmvO3EkyCZ4CGVlCY07i3xDSlAQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5232
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 01:05:08PM +0200, Jiri Pirko wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index ab1cebf227fb..b0267e4dca27 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -127,11 +127,11 @@ static int mlxsw_core_resources_ports_register(struct mlxsw_core *mlxsw_core)
>  					  max_ports, 1,
>  					  DEVLINK_RESOURCE_UNIT_ENTRY);
>  
> -	return devlink_resource_register(devlink,
> -					 DEVLINK_RESOURCE_GENERIC_NAME_PORTS,
> -					 max_ports, MLXSW_CORE_RESOURCE_PORTS,
> -					 DEVLINK_RESOURCE_ID_PARENT_TOP,
> -					 &ports_num_params);
> +	return devl_resource_register(devlink,
> +				      DEVLINK_RESOURCE_GENERIC_NAME_PORTS,
> +				      max_ports, MLXSW_CORE_RESOURCE_PORTS,
> +				      DEVLINK_RESOURCE_ID_PARENT_TOP,
> +				      &ports_num_params);
>  }
>  
>  static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core, bool reload)
> @@ -157,8 +157,8 @@ static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core, bool reload)
>  			goto err_resources_ports_register;
>  	}
>  	atomic_set(&mlxsw_core->active_ports_count, 0);
> -	devlink_resource_occ_get_register(devlink, MLXSW_CORE_RESOURCE_PORTS,
> -					  mlxsw_ports_occ_get, mlxsw_core);
> +	devl_resource_occ_get_register(devlink, MLXSW_CORE_RESOURCE_PORTS,
> +				       mlxsw_ports_occ_get, mlxsw_core);
>  
>  	return 0;
>  
> @@ -171,9 +171,9 @@ static void mlxsw_ports_fini(struct mlxsw_core *mlxsw_core, bool reload)
>  {
>  	struct devlink *devlink = priv_to_devlink(mlxsw_core);
>  
> -	devlink_resource_occ_get_unregister(devlink, MLXSW_CORE_RESOURCE_PORTS);
> +	devl_resource_occ_get_unregister(devlink, MLXSW_CORE_RESOURCE_PORTS);
>  	if (!reload)
> -		devlink_resources_unregister(priv_to_devlink(mlxsw_core));
> +		devl_resources_unregister(priv_to_devlink(mlxsw_core));
>  
>  	kfree(mlxsw_core->ports);
>  }
> @@ -1485,10 +1485,12 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>  {
>  	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>  
> +	devl_lock(devlink);
>  	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_RESET))
>  		return -EOPNOTSUPP;

Not releasing the lock. You can take it after this check as these
features do not change

>  
>  	mlxsw_core_bus_device_unregister(mlxsw_core, true);
> +	devl_unlock(devlink);
>  	return 0;
>  }
>  
> @@ -1498,13 +1500,17 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_re
>  					struct netlink_ext_ack *extack)
>  {
>  	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
> +	int err;
>  
> +	devl_lock(devlink);
>  	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>  			     BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
> -	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
> -					      mlxsw_core->bus,
> -					      mlxsw_core->bus_priv, true,
> -					      devlink, extack);
> +	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
> +					     mlxsw_core->bus,
> +					     mlxsw_core->bus_priv, true,
> +					     devlink, extack);
> +	devl_unlock(devlink);
> +	return err;
>  }
>  
>  static int mlxsw_devlink_flash_update(struct devlink *devlink,
> @@ -2102,6 +2108,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
>  			err = -ENOMEM;
>  			goto err_devlink_alloc;
>  		}
> +		devl_lock(devlink);

Why not just take it in mlxsw_core_bus_device_register() if '!reload' ?
Easier to read and also consistent with the change in
mlxsw_core_bus_device_unregister()


>  	}
>  
>  	mlxsw_core = devlink_priv(devlink);
> @@ -2188,6 +2195,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
>  	if (!reload) {
>  		devlink_set_features(devlink, DEVLINK_F_RELOAD);
>  		devlink_register(devlink);
> +		devl_unlock(devlink);

Did you check this with lockdep? devlink_register() now acquires the
global devlink mutex under the per-instance lock, but devlink core uses
the reverse order.

>  	}
>  	return 0;
>  
> @@ -2214,12 +2222,14 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
>  	mlxsw_ports_fini(mlxsw_core, reload);
>  err_ports_init:
>  	if (!reload)
> -		devlink_resources_unregister(devlink);
> +		devl_resources_unregister(devlink);
>  err_register_resources:
>  	mlxsw_bus->fini(bus_priv);
>  err_bus_init:
> -	if (!reload)
> +	if (!reload) {
> +		devl_unlock(devlink);
>  		devlink_free(devlink);
> +	}
>  err_devlink_alloc:
>  	return err;
>  }
> @@ -2255,8 +2265,10 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
>  {
>  	struct devlink *devlink = priv_to_devlink(mlxsw_core);
>  
> -	if (!reload)
> +	if (!reload) {
> +		devl_lock(devlink);
>  		devlink_unregister(devlink);
> +	}
>  
>  	if (devlink_is_reload_failed(devlink)) {
>  		if (!reload)
> @@ -2281,17 +2293,20 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
>  	kfree(mlxsw_core->lag.mapping);
>  	mlxsw_ports_fini(mlxsw_core, reload);
>  	if (!reload)
> -		devlink_resources_unregister(devlink);
> +		devl_resources_unregister(devlink);
>  	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
> -	if (!reload)
> +	if (!reload) {
>  		devlink_free(devlink);
> +		devl_unlock(devlink);
> +	}
>  
>  	return;
>  
>  reload_fail_deinit:
>  	mlxsw_core_params_unregister(mlxsw_core);
> -	devlink_resources_unregister(devlink);
> +	devl_resources_unregister(devlink);
>  	devlink_free(devlink);
> +	devl_unlock(devlink);
>  }
>  EXPORT_SYMBOL(mlxsw_core_bus_device_unregister);
