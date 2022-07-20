Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A64657B332
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiGTIpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiGTIpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:45:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C185D128
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:45:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chLjsec52IS4U/iaCPE71adJH+xUsqeZVA9YoF7PFKkTvlKL/oqDaaDG/Wl9OVI0U3Cj8B/24egI8fl+T1kDnwAQ9ARlImT7A07O+Rqcq21/NjaIdWwVx9fO6+WQLyxFrbsy0myhd/vLn2qvY93q7NfBs6Er1PQA1VFmWsZGoMZ5jz4XK31nov3GwWTNPZtssLyYh1DI+v3xXUz0l9oI4W5jdHxQuw/nXnpTeTmugMPuXB0HOucdV1g0Ps6ckq7g1mMytqyqHWLu6f+VPRUUhAC2wYUT/4dmMMSR5/K9d16hjyswYNIFXgML+IrpY+SJSlXJRCcNb3bvU60J1IcM6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6lhx2Ym5RifI5OpW8TIPKrERpSe/uRaA/oJYc5nIvM=;
 b=CbrssivnhQBu2aF2mJvL/WNzUt3sTX/v4C4b+m2tUB8St52A0hiedke88yuvfzyTzZPg0gnCnLBb/jnz/8VKGHWPii5ddyooUMAGgXtFkeAqz6agkdM9NTl1FTVq8Us4VtJmjQ5yNjOyKe1czWikk7TG3f9qDw/hyv2i7h1Sl6K3JHHJaF05fKbNz6wP6+w1w0osEYZKbjNksn3FArDhEZ11+YB4xvHjblJ4zkbbAaydvZbal15CQBr+Pu4FEJ3RYwhMZTiyvjDrJVsFhAPLLNsZosZdqteqNW36P4W9lQU2g/QHgrwkgg5SsFtIVhRRxDv5LMftKkMEMkG1RPa4+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6lhx2Ym5RifI5OpW8TIPKrERpSe/uRaA/oJYc5nIvM=;
 b=VrUCC+6lulFwBasVtHhgHuIsLWNjRs4THnrJDt8z9GDoTRfQCcp3kUFx6ELOAOvHSePhsjd1ppFwR6dKLHfTHGmDuDhDRmgWe3WSzOLsl8UKb/TLSMIpC0mPY0uw4wMX3Z/Atjc6IV3o0t46q6qv0JOlRMU1l4BeoS6kfT1kv1lSGoIsFXksk9RoMAgFLgtiWrNEpDdvtfqUxTloOssywi8Et89GTaRMU3qIlqPPAtEgqt4auR48MKLsx8Hj/N/ANrvU681bLr0gIHVzeE+F+K+4orr55wmqal63orwepYXGm2cCKcF81HSYU1Br4yx17hBoMmv3E3oQlfn3cucqMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB4054.namprd12.prod.outlook.com (2603:10b6:610:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 08:45:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 08:45:37 +0000
Date:   Wed, 20 Jul 2022 11:45:30 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 03/12] mlxsw: core_linecards: Introduce per
 line card auxiliary device
Message-ID: <YtfAqmq4v0u9we9Z@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-4-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-4-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0802CA0006.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40e25477-f545-418b-cf51-08da6a2c37a9
X-MS-TrafficTypeDiagnostic: CH2PR12MB4054:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mPVL60fpGXWwhJtcu43kAXsB1qwMSsa1J4STb/3qGxNh3kWtJRVo+qG8M+0d0HtopnsengYXl0g1ApAmp0WXtek9ADc8AvNuNspTQtz2eQSQ9+V2b0y347Ja+WxOANOeG2fNXFpVeKuMNjKixfMkSDPT17oE9pD+VR8NGaPqlKMpb9b4T42mSAcQIMKXKnYnJdkWSGwCm/VN0tZFIdGgVnB0ACX2qGDvxMV+6PCc4uh6bSy4SitxT/9icRTMKj0TUKhNsPrH63lfQYJ7AjXuXq8lHEKWO6mxvAOWT3qhH9dnayh7qa+YytUv55keLa2c2ripGPeZcv1zFoNVOj/wV1AY6tUwuVDzib3IGFmd2bKGx9ypaMA2v2WtAbJVb3+TLcGqgpDDvwQskF+1p0/m02oQkp0XffHlC/0qO2/BIpS/mlfowCZRYrBzrdI+R6KFfn4qDZFKz44XKkSrmOmwga7/wY3PEJ4u7EZL61n2ZTPxKrf2mKjnei0q1bmVJ9Xua50uyuEKh68V/Ga84xcZIOK5mG77rD9C7ufUYMOdz8aAoAaAkUx+C28FySwdRJGqu+4pUb8ypsY0O5+GT4CL1odsOfrP/FlW0JUmL2kk4N14GmkMzBN/EGsGmot+Spb1QBICjWhxFQ83qyjlRILZoRFGnWqI7Byu7IAPmouWvPeMMMKbwYBBKop8EaVHhay58LbsTrq8MM1JbcSNHK0KYoXeFCFkuEeVS/fizxhum/D/aUplDvb6EIup5QGvcXld
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(396003)(366004)(136003)(346002)(376002)(478600001)(6486002)(26005)(33716001)(6506007)(2906002)(6916009)(41300700001)(6666004)(86362001)(316002)(4326008)(8676002)(66946007)(6512007)(83380400001)(9686003)(66476007)(66556008)(8936002)(5660300002)(30864003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sdLOlEGc5P3KB7B0+KgWCGgkdIvFrK83VRqjRPj+EPmbHqthyg4C1m4OOI3u?=
 =?us-ascii?Q?W4QYbw6FPCRvZUF4SBVkfpUtp/LWwEIQciQmYEnwg1xzEvB4RsRYCL44rZ+K?=
 =?us-ascii?Q?YlFncaiPgF8nDbsUMSMLplLRIGxjECy4gz4Q1FaWjV3Cq3kp3kQ1ed6ZPwh0?=
 =?us-ascii?Q?wUFPwM2hfK07DsJj4PTtMKPl7AJjzDo/Q3B6N6R/mCRbsex1dawLiPD4qHHc?=
 =?us-ascii?Q?khtv3OMIkEo6B31XVW4/4DLsTJ5+iSt7zzv67bIhxYd1JiWb3HP1o2+KJZ/x?=
 =?us-ascii?Q?9M0sG99awCrTvkwzT+Cn6p8U4m/XwUtHtHAMn2V6K6xf/1gprWmEQ1GGFX2p?=
 =?us-ascii?Q?zIuX4trlxXMyuJFCBbbSop//mBFUcwjsQcpdQVLEuHtdijfx81OMv8RqnKIm?=
 =?us-ascii?Q?r/S/OYhmEceZIf9QRN+zyQrWqNgphI9S/yLP9BKnkiw15zWOzPgRWeIJWh9n?=
 =?us-ascii?Q?LF9B3cPTUtbZrSkpz8lvbSzMgzbSxNdyByPr941JIIjSb3QvVJCwazaOTL+E?=
 =?us-ascii?Q?Zl5yHAM7yPinii6/A+G+/yLuUVulo5NflK72XeEl3UAPp8mdkrsSUKXcRr30?=
 =?us-ascii?Q?5v9ze6qk9RKkGCpBxMD/EIukhKPe/ZuiCsPeyegjCn49Bk2Qy+YMTjV8herF?=
 =?us-ascii?Q?yuY93S2SWpkORDLknD9zh8e4rp5LIEmfvFgNsvDvUrBeusTV3oIr2QbFF12E?=
 =?us-ascii?Q?yhocsq5BSfh4ZijFGoogQBAHrathUZk9bds2sIEkrZn6c8LI/aDb2logpEoA?=
 =?us-ascii?Q?1zUEtBXVCPEP4Q1dSwmN/llP5VBSAZNdjzkhgL6FtkAUN1SY/d/R7Kz4Sidw?=
 =?us-ascii?Q?t8TyMAVgqkpj/coeGpZlI58HfHZAsuVvM93sYJyxxnCKAZjDoBiMBzfgJD4Z?=
 =?us-ascii?Q?Adj8nqM2oyC9srDwLxi7GKxcJMHac8SjNepUsr0F9wFyL6AFSROQwkkFa/4m?=
 =?us-ascii?Q?7Pw2PJ0GcURX0Nvn95uAvCMN2IB8+wBJbZr8ipT6Wl4s/bVG/1RU0GPltmLL?=
 =?us-ascii?Q?WXWPcTGNwkLAmase9mAWUMM/1sLZe9M2YourFr09a4Fhhc0Sxt97Thzw7ZXu?=
 =?us-ascii?Q?RYiQ+vzwansmiRHNbRy2a9eORDV1ew7BQtYr8J5cBgNQHb7R5/TQatvjyGqe?=
 =?us-ascii?Q?QeanASx74bkvHt1g+7sA8kkU6QYpw/63Te4l2ci1cLOWIjApVgzfgZCCeju7?=
 =?us-ascii?Q?wuHv+pic1/2z9kiXXaiLoiLS6c/iTkDkl4RVQ9RW9vkn4c1kDq17kUj1E1SX?=
 =?us-ascii?Q?X3/lIpXHZUlrHyWR1Xn0Io2n4YkV7VBIPtcc6448bzrE7s5xFUDggXs/4pvg?=
 =?us-ascii?Q?xh5FXWmps5xD3ja6HSQn4sEsoz7ys/RRJ+HgUfkltv9ezYoGW/vnM4A7d5jn?=
 =?us-ascii?Q?tawqFpAvV6Xz9oNb+Z4uM2BhK3i2yFwRp1EC1p1UAzZamUaZDVPR1XF7kpSl?=
 =?us-ascii?Q?WHa0ebtw6OS+/XJCMUUXwGECKF1ZNUKwzKSw4NM/X+ar08gpR1+o1KkYU9mf?=
 =?us-ascii?Q?qCh+nzRdPSUDPLTKEzAeCNl4KmhXobdRvg3NMR3KeAuD/ojwc+ISpLUaIKFl?=
 =?us-ascii?Q?m8DQyLF9lK66j4o55yBfHxPVj71ZFxKvy0LEu+RT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e25477-f545-418b-cf51-08da6a2c37a9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:45:37.3826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNTjRb7p/xgeYdI7j1uyEKVJTH6u75LY3LrbvBdaTlMT5xI1sHa8aZf1kQ7glkV+EkqVPaYZFDLAYuexbvFOUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4054
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:38AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In order to be eventually able to expose line card gearbox version and
> possibility to flash FW, model the line card as a separate device on
> auxiliary bus.

What is the reason for adding the auxiliary device for the line card
when it becomes 'provisioned' and not when it becomes 'active'? It needs
to be explained in the commit message

> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
> v1->v2:
> - added auxdev removal to mlxsw_linecard_fini()
> - adjusted mlxsw_linecard_bdev_del() to cope with bdev == NULL
> ---
>  drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
>  drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  13 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.h    |  10 ++
>  .../mellanox/mlxsw/core_linecard_dev.c        | 155 ++++++++++++++++++
>  .../ethernet/mellanox/mlxsw/core_linecards.c  |  11 ++
>  6 files changed, 189 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> index 4683312861ac..a510bf2cff2f 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> @@ -7,6 +7,7 @@ config MLXSW_CORE
>  	tristate "Mellanox Technologies Switch ASICs support"
>  	select NET_DEVLINK
>  	select MLXFW
> +	select AUXILIARY_BUS
>  	help
>  	  This driver supports Mellanox Technologies Switch ASICs family.
>  
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
> index c2d6d64ffe4b..3ca9fce759ea 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
> +++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
> @@ -2,7 +2,7 @@
>  obj-$(CONFIG_MLXSW_CORE)	+= mlxsw_core.o
>  mlxsw_core-objs			:= core.o core_acl_flex_keys.o \
>  				   core_acl_flex_actions.o core_env.o \
> -				   core_linecards.o
> +				   core_linecards.o core_linecard_dev.o
>  mlxsw_core-$(CONFIG_MLXSW_CORE_HWMON) += core_hwmon.o
>  mlxsw_core-$(CONFIG_MLXSW_CORE_THERMAL) += core_thermal.o
>  obj-$(CONFIG_MLXSW_PCI)		+= mlxsw_pci.o
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index 61eb96b93889..831b0d3472c6 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -3334,9 +3334,15 @@ static int __init mlxsw_core_module_init(void)
>  {
>  	int err;
>  
> +	err = mlxsw_linecard_driver_register();
> +	if (err)
> +		return err;
> +
>  	mlxsw_wq = alloc_workqueue(mlxsw_core_driver_name, 0, 0);
> -	if (!mlxsw_wq)
> -		return -ENOMEM;
> +	if (!mlxsw_wq) {
> +		err = -ENOMEM;
> +		goto err_alloc_workqueue;
> +	}
>  	mlxsw_owq = alloc_ordered_workqueue("%s_ordered", 0,
>  					    mlxsw_core_driver_name);
>  	if (!mlxsw_owq) {
> @@ -3347,6 +3353,8 @@ static int __init mlxsw_core_module_init(void)
>  
>  err_alloc_ordered_workqueue:
>  	destroy_workqueue(mlxsw_wq);
> +err_alloc_workqueue:
> +	mlxsw_linecard_driver_unregister();
>  	return err;
>  }
>  
> @@ -3354,6 +3362,7 @@ static void __exit mlxsw_core_module_exit(void)
>  {
>  	destroy_workqueue(mlxsw_owq);
>  	destroy_workqueue(mlxsw_wq);
> +	mlxsw_linecard_driver_unregister();
>  }
>  
>  module_init(mlxsw_core_module_init);
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
> index a3491ef2aa7e..b22db13fa547 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.h
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
> @@ -12,6 +12,7 @@
>  #include <linux/skbuff.h>
>  #include <linux/workqueue.h>
>  #include <linux/net_namespace.h>
> +#include <linux/auxiliary_bus.h>
>  #include <net/devlink.h>
>  
>  #include "trap.h"
> @@ -561,6 +562,8 @@ enum mlxsw_linecard_status_event_type {
>  	MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION,
>  };
>  
> +struct mlxsw_linecard_bdev;
> +
>  struct mlxsw_linecard {
>  	u8 slot_index;
>  	struct mlxsw_linecards *linecards;
> @@ -575,6 +578,7 @@ struct mlxsw_linecard {
>  	   active:1;
>  	u16 hw_revision;
>  	u16 ini_version;
> +	struct mlxsw_linecard_bdev *bdev;
>  };
>  
>  struct mlxsw_linecard_types_info;
> @@ -614,4 +618,10 @@ void mlxsw_linecards_event_ops_unregister(struct mlxsw_core *mlxsw_core,
>  					  struct mlxsw_linecards_event_ops *ops,
>  					  void *priv);
>  
> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard);
> +void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard);
> +
> +int mlxsw_linecard_driver_register(void);
> +void mlxsw_linecard_driver_unregister(void);
> +
>  #endif
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
> new file mode 100644
> index 000000000000..bb6068b62df0
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> +/* Copyright (c) 2022 NVIDIA Corporation and Mellanox Technologies. All rights reserved */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/types.h>
> +#include <linux/err.h>
> +#include <linux/auxiliary_bus.h>
> +#include <linux/idr.h>
> +#include <linux/gfp.h>
> +#include <linux/slab.h>
> +#include <net/devlink.h>
> +#include "core.h"
> +
> +#define MLXSW_LINECARD_DEV_ID_NAME "lc"
> +
> +struct mlxsw_linecard_dev {
> +	struct mlxsw_linecard *linecard;
> +};
> +
> +struct mlxsw_linecard_bdev {
> +	struct auxiliary_device adev;
> +	struct mlxsw_linecard *linecard;
> +	struct mlxsw_linecard_dev *linecard_dev;
> +};
> +
> +static DEFINE_IDA(mlxsw_linecard_bdev_ida);
> +
> +static int mlxsw_linecard_bdev_id_alloc(void)
> +{
> +	return ida_alloc(&mlxsw_linecard_bdev_ida, GFP_KERNEL);
> +}
> +
> +static void mlxsw_linecard_bdev_id_free(int id)
> +{
> +	ida_free(&mlxsw_linecard_bdev_ida, id);
> +}
> +
> +static void mlxsw_linecard_bdev_release(struct device *device)
> +{
> +	struct auxiliary_device *adev =
> +			container_of(device, struct auxiliary_device, dev);
> +	struct mlxsw_linecard_bdev *linecard_bdev =
> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
> +
> +	mlxsw_linecard_bdev_id_free(adev->id);
> +	kfree(linecard_bdev);
> +}
> +
> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
> +{
> +	struct mlxsw_linecard_bdev *linecard_bdev;
> +	int err;
> +	int id;
> +
> +	id = mlxsw_linecard_bdev_id_alloc();
> +	if (id < 0)
> +		return id;
> +
> +	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
> +	if (!linecard_bdev) {
> +		mlxsw_linecard_bdev_id_free(id);
> +		return -ENOMEM;
> +	}
> +	linecard_bdev->adev.id = id;
> +	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
> +	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
> +	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
> +	linecard_bdev->linecard = linecard;
> +
> +	err = auxiliary_device_init(&linecard_bdev->adev);
> +	if (err) {
> +		mlxsw_linecard_bdev_id_free(id);
> +		kfree(linecard_bdev);
> +		return err;
> +	}
> +
> +	err = auxiliary_device_add(&linecard_bdev->adev);
> +	if (err) {
> +		auxiliary_device_uninit(&linecard_bdev->adev);
> +		return err;
> +	}
> +
> +	linecard->bdev = linecard_bdev;
> +	return 0;
> +}
> +
> +void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard)
> +{
> +	struct mlxsw_linecard_bdev *linecard_bdev = linecard->bdev;
> +
> +	if (!linecard_bdev)

This check is needed because of the invocation from
mlxsw_linecard_fini() ? If so, please add a comment. Something like:

/* Unprovisioned line cards do not have an auxiliary device. */

> +		return;
> +	auxiliary_device_delete(&linecard_bdev->adev);
> +	auxiliary_device_uninit(&linecard_bdev->adev);
> +	linecard->bdev = NULL;
> +}
> +
> +static const struct devlink_ops mlxsw_linecard_dev_devlink_ops = {
> +};
> +
> +static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
> +				     const struct auxiliary_device_id *id)
> +{
> +	struct mlxsw_linecard_bdev *linecard_bdev =
> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
> +	struct mlxsw_linecard_dev *linecard_dev;
> +	struct devlink *devlink;
> +
> +	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
> +				sizeof(*linecard_dev), &adev->dev);
> +	if (!devlink)
> +		return -ENOMEM;
> +	linecard_dev = devlink_priv(devlink);
> +	linecard_dev->linecard = linecard_bdev->linecard;
> +	linecard_bdev->linecard_dev = linecard_dev;
> +
> +	devlink_register(devlink);
> +	return 0;
> +}
> +
> +static void mlxsw_linecard_bdev_remove(struct auxiliary_device *adev)
> +{
> +	struct mlxsw_linecard_bdev *linecard_bdev =
> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
> +	struct devlink *devlink = priv_to_devlink(linecard_bdev->linecard_dev);
> +
> +	devlink_unregister(devlink);
> +	devlink_free(devlink);
> +}
> +
> +static const struct auxiliary_device_id mlxsw_linecard_bdev_id_table[] = {
> +	{ .name = KBUILD_MODNAME "." MLXSW_LINECARD_DEV_ID_NAME },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(auxiliary, mlxsw_linecard_bdev_id_table);
> +
> +static struct auxiliary_driver mlxsw_linecard_driver = {
> +	.name = MLXSW_LINECARD_DEV_ID_NAME,
> +	.probe = mlxsw_linecard_bdev_probe,
> +	.remove = mlxsw_linecard_bdev_remove,
> +	.id_table = mlxsw_linecard_bdev_id_table,
> +};
> +
> +int mlxsw_linecard_driver_register(void)
> +{
> +	return auxiliary_driver_register(&mlxsw_linecard_driver);
> +}
> +
> +void mlxsw_linecard_driver_unregister(void)
> +{
> +	auxiliary_driver_unregister(&mlxsw_linecard_driver);
> +}
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
> index 5c9869dcf674..43696d8badca 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
> @@ -232,6 +232,7 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>  {
>  	struct mlxsw_linecards *linecards = linecard->linecards;
>  	const char *type;
> +	int err;
>  
>  	type = mlxsw_linecard_types_lookup(linecards, card_type);
>  	mlxsw_linecard_status_event_done(linecard,
> @@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>  	linecard->provisioned = true;
>  	linecard->hw_revision = hw_revision;
>  	linecard->ini_version = ini_version;
> +
> +	err = mlxsw_linecard_bdev_add(linecard);
> +	if (err) {
> +		linecard->provisioned = false;
> +		mlxsw_linecard_provision_fail(linecard);
> +		return err;
> +	}
> +
>  	devlink_linecard_provision_set(linecard->devlink_linecard, type);
>  	return 0;
>  }
> @@ -260,6 +269,7 @@ static void mlxsw_linecard_provision_clear(struct mlxsw_linecard *linecard)
>  {
>  	mlxsw_linecard_status_event_done(linecard,
>  					 MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION);
> +	mlxsw_linecard_bdev_del(linecard);
>  	linecard->provisioned = false;
>  	devlink_linecard_provision_clear(linecard->devlink_linecard);
>  }
> @@ -885,6 +895,7 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
>  	mlxsw_core_flush_owq();
>  	if (linecard->active)
>  		mlxsw_linecard_active_clear(linecard);
> +	mlxsw_linecard_bdev_del(linecard);
>  	devlink_linecard_destroy(linecard->devlink_linecard);
>  	mutex_destroy(&linecard->lock);
>  }
> -- 
> 2.35.3
> 
