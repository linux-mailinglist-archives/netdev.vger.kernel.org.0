Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9F73DDD80
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhHBQXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:23:14 -0400
Received: from mail-sn1anam02on2098.outbound.protection.outlook.com ([40.107.96.98]:27622
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229805AbhHBQXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:23:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGvGwOwusiJfFGqBXV6g8mrWbvM+jZ1vfBVGFMauegEacbGKttKQfVFXrZSThErba+z1ErClUU9gUR/W83kAWAQL9hff+FIdarBERuUFcFKcEPh+RjsP6AhkMzeuQx2I99BlyHjVfhRavY+ke6I3cyf7HrrRHxlQpGMuksR3+3jOmP9BgprwIq+h0w1lK30MiwGmwMer3zJSgmOwVaq3K8mVJaM0aqcMKWzbUwuwqmKF+5TfAdgeAsHaeAO8asYV5HJ11neZtGGHXyPZhmRlM9Yd+f3ALDW/wik626x4zrbe4cYT2BncMx2UfNQXo+sdBG66TFdD7b8y8c5f7NUvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EP9bkdaag3Sv9K+L4HLYj9OI2LPMVLLzS9ZnYcDo10=;
 b=ivJC7id7XqedBi+32gTeHScmo2XMZ0t1FGxYt+CeVh7XY+f93qpb9zxn/Qfgv+jSFtsCfR1T+XLzB8Wr1lj03Cc31mxCJK62j0X2gc3LTY8ZU/P5SQ1w6XBIBHVqWmIoX7no0t1Yr7uK0se2eZFsEgmdaFcyxBZuo7vrDX1IGUOpijUDUom5ASBDmmhlt+CP9IRDNWUBsZfryXADlF0X+W7QAUVk04F8XPta0NrjSryCLm42WIwXY1Y/llNmI65oskBjW/zvGvcScPcR3wFHkRiYINbDYRoXSk331ldM4QEUGdW+Qa4VFoKCF98a+dZlc80pxHBlXmQBL582imTz2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EP9bkdaag3Sv9K+L4HLYj9OI2LPMVLLzS9ZnYcDo10=;
 b=OwRxRo+b/s7S4LAcZcF5+NUSvaeYU36aAskwuDof06XQus01kZOpUuALcv9RW2lprOlykD2h0KuTndNmNtqLM7y/6/SVSoquMFrRkHmUR7vsrqc+qhZy5HH8qT6pP4H7OQRyWfYNHLkARnMG9vXqSvUvshQz3xoKvI371TPAzYc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5033.namprd13.prod.outlook.com (2603:10b6:510:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.7; Mon, 2 Aug
 2021 16:23:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Mon, 2 Aug 2021
 16:23:00 +0000
Date:   Mon, 2 Aug 2021 18:22:53 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH] switchdev: add Kconfig dependencies for bridge
Message-ID: <20210802162250.GA12345@corigine.com>
References: <20210802144813.1152762-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802144813.1152762-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM4PR0701CA0018.eurprd07.prod.outlook.com
 (2603:10a6:200:42::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM4PR0701CA0018.eurprd07.prod.outlook.com (2603:10a6:200:42::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Mon, 2 Aug 2021 16:22:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cc9fa4b-3388-460a-615a-08d955d1cbd5
X-MS-TrafficTypeDiagnostic: PH0PR13MB5033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50332C686F3EE21485F2FE63E8EF9@PH0PR13MB5033.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZ503cDcOxHFVglv3rk2G+K3Mr7YCihXTel5KNBG8vC5gujlN+ZqJOXY6MKueX3P8v/w9HHYgg5j6geKle1vHJCrW4Yc5sv1sCPy9iZAbRqx5Zc50Noo96gzr8Tzj3PknYYmHVGF8ehwXAh46To2AiLL2H60/f9ffVEYF4OLt5QjKm9Ru9ByT+7aIJ7ApPoyNo3vO186vLljCDtZh70BMvw5EXBxpTECgSfwoSLRl/VCf3eaPXVqikY5MIahQzPq8WkQlWTMT1d3ibbrWdj2tSFkeLhnKhN0YXUFHeGmzgQZmvVZc3GDceRIbNXrBG8qfHL87bb1AsCin6/mdx/gkV/QwuS/HOl1pyKnv6gg2bTWohXoFOAbg1X5uGNiQPga4ijHNvNfQfHSPzGNZo2kXu0XeuVd4IvE2VDh5Rsc9uBdfCKXve2Kv+Wo3PWt2vyTQlH7/HS+JhCeAvFBXQlulGL/uoyWLYdT9+eIATfuw0ziPrg4fKhJShlX+/J3hSPctxtRg9FZO63QgZ52VtoTBms3joQs+Jy1bevSmWqCbGi6aK7yKtf2SVtZZc7TajExB8ic6awadg0Ukn5znPdRr6PCb6JU/HLE6y8/+Zvfzc5iRQvfBQ16x+s6lBwhMnMBPJsnpm0oUqFScxdC3B/dCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39830400003)(136003)(396003)(8676002)(52116002)(33656002)(7416002)(66476007)(6916009)(8886007)(38100700002)(508600001)(66556008)(7696005)(6666004)(2616005)(66946007)(4326008)(83380400001)(54906003)(1076003)(107886003)(36756003)(55016002)(186003)(316002)(2906002)(44832011)(8936002)(5660300002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CyXPNgz3hlYncnp3aJEjLw0bOiuFOYB5bXHO3agk8uNr5pMDeyUBKHhSeNiO?=
 =?us-ascii?Q?ZG/2TahhPFUz61KfpHjyTB25YL05KzT34UGqvm77dt8cwvBvKErnmwXzWugj?=
 =?us-ascii?Q?GZ31ei6a/28O9wZlBhBCkZ6++hkyNozggqYbgOJaXe4SveyUhEQZ96EMQoX9?=
 =?us-ascii?Q?5JQrA1fmxePZuIk3Bd40rnh/Kixs+q03vzGUmYOiofw790MlVWvO1r7jWEDb?=
 =?us-ascii?Q?vTswYGQG16vIrcJpVebm92hCa6V6xc2bkoIM6il2b2BRFvFfdZk01WploG6m?=
 =?us-ascii?Q?4N6e+yIrJ3E5TsrgldZwwgbc9LKugCcm89IrBaiGFPUTwWxSC0AU/IOIWi8a?=
 =?us-ascii?Q?t8mtNx/x9n3kS/y/OQriINssvnyfxr3x0UXj3jgpuOpGoz3y4f4lfIHvIX+B?=
 =?us-ascii?Q?HR1QCzhMRhXMiLllmtYvHcTYkcsFeL+QboDHRkE2Y3zVhsnTuG+wG6pdROlF?=
 =?us-ascii?Q?Sad3pORsqqgPsfUKGYKrakMopPv5TKk15zyOeuhH2RLvotBrQBIs36I0X4AL?=
 =?us-ascii?Q?qF1waUp+zJVUj4tevMqkSiP0LzXafnqLsTOwCqOhIhonXrey5sgfY09xZ7YJ?=
 =?us-ascii?Q?b7bBeG/7dq72Mn7jX93SHFkBMRuMsz7N2XVd9Juq2H3PbS8x/NoJyX+YCOek?=
 =?us-ascii?Q?JF2oFs1Tsn50AfqqEi5ZivWp3BbpU9d++9kIsuGn2FdCAASEhTIuihs5tIz3?=
 =?us-ascii?Q?S0py/CXOU5kHN1Kep2lRqfkiokK1EDElavqCJg6TDJ2r5HIXZ/GzrBwaAEux?=
 =?us-ascii?Q?42l3/Ys0KoSMI4XmC4s8x7SUSEM4C9Z9bNCzG0B8ePEPxnZ0PBb9PE0P8Flw?=
 =?us-ascii?Q?HlAxrT20oTHmo40Jp7EtLXa8dQzajvoi6K9mQuBBZH4ACFCugxx5R7Tg2G1X?=
 =?us-ascii?Q?D60Hh0ST/7MBMmLMQBpP7EUzoJ3maxRBJ18Ma510P0bdLvyy1HP5bRpMY2pX?=
 =?us-ascii?Q?XEl46EcWWg3WcM6pvZPHKpl2N6lUmLURqQTVSNCHnDjgiaAxMjRzaKF49/2q?=
 =?us-ascii?Q?a1wpbIMYOtCAiIuHPFyewCrTJbzAkivyqdOVxJ07l02HjeMddqVerxul5APU?=
 =?us-ascii?Q?YA+NNTNnajr4jd0qWbe5gr3gPtYmS6SyyAWvkohPIoH0EM4WE28TXvCJaQsY?=
 =?us-ascii?Q?eIn3pVEVdhMpdDBddzVS9Cfa35xneEjui2Um02L+1xIcKzJgMBxe18SKNCHW?=
 =?us-ascii?Q?UKrDmmzNxFoFdVPdq504dNq0aBprU40bvROzzI/Dj5FUp9F3SK2TPGVyOpMQ?=
 =?us-ascii?Q?8/1CnWsK/DnGvQSDWEtuODxCqnmLBgleanN8Q3QoO1n0pnmM1PX3fyHxim4k?=
 =?us-ascii?Q?2SiMzoqFDmCn5cvScJHbhGmoU2q4quBlui17vMRLl9K2mYJwRN5vrNSFzHZZ?=
 =?us-ascii?Q?sL9YjPnZN4H3JYdFu6VsjZHpzWsz?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc9fa4b-3388-460a-615a-08d955d1cbd5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 16:23:00.8449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMs5plqBcw6jxaBvygDGMkUWxLDreveSxHQSAl0lgA6MtrseC31dvEmjCPj8ULEwx6KRQ8LFBaSsgDNm1bf/v40t6fISPL+lxhKlj3wo11g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 04:47:28PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Multiple switchdev drivers depend on CONFIG_NET_SWITCHDEV in Kconfig,
> but have also gained a dependency on the bridge driver as they now
> call switchdev_bridge_port_offload():
> 
> drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: In function `sparx5_netdevice_event':
> sparx5_switchdev.c:(.text+0x3cc): undefined reference to `switchdev_bridge_port_offload'
> drivers/net/ethernet/ti/cpsw_new.o: In function `cpsw_netdevice_event':
> cpsw_new.c:(.text+0x1098): undefined reference to `switchdev_bridge_port_offload'
> 
> Some of these drivers already have a 'BRIDGE || !BRIDGE' dependency
> that avoids the link failure, but the 'rocker' driver was missing this
> 
> For MLXSW/MLX5, SPARX5_SWITCH, and TI_K3_AM65_CPSW_NUSS, the
> driver can conditionally use switchdev support, which is then guarded
> by another Kconfig symbol. For these, add a dependency on a new Kconfig
> symbol NET_MAY_USE_SWITCHDEV that is defined to correctly model the
> dependency: if switchdev support is enabled, these drivers cannot be
> built-in when bridge support is in a module, but if either bridge or
> switchdev is disabled, or both are built-in, there is no such restriction.
> 
> Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge ports are offloaded")
> Fixes: b0e81817629a ("net: build all switchdev drivers as modules when the bridge is a module")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This version seems to pass my randconfig builds for the moment,
> but that doesn't mean it's correct either. Please have a closer
> look before this gets applied.
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
>  drivers/net/ethernet/mellanox/mlxsw/Kconfig     | 1 +
>  drivers/net/ethernet/netronome/Kconfig          | 1 +
>  drivers/net/ethernet/ti/Kconfig                 | 1 +
>  net/switchdev/Kconfig                           | 5 +++++
>  5 files changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> index e1a5a79e27c7..3a752e57c1e5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -12,6 +12,7 @@ config MLX5_CORE
>  	depends on MLXFW || !MLXFW
>  	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
>  	depends on PCI_HYPERV_INTERFACE || !PCI_HYPERV_INTERFACE
> +	depends on NET_MAY_USE_SWITCHDEV
>  	help
>  	  Core driver for low level functionality of the ConnectX-4 and
>  	  Connect-IB cards by Mellanox Technologies.

MLX5_CORE does not appear to cover code that calls
switchdev_bridge_port_offload.

> diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> index 12871c8dc7c1..dee3925bdaea 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
> @@ -5,6 +5,7 @@
>  
>  config MLXSW_CORE
>  	tristate "Mellanox Technologies Switch ASICs support"
> +	depends on NET_MAY_USE_SWITCHDEV
>  	select NET_DEVLINK
>  	select MLXFW
>  	help

I think it is MLXSW_SPECTRUM rather than MLXSW_CORE
that controls compilation of spectrum_switchdev.c
which calls switchdev_bridge_port_offload.

But MLXSW_SPECTRUM seems to already depend on BRIDGE || BRIDGE=n

> diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
> index b82758d5beed..a298d19e8383 100644
> --- a/drivers/net/ethernet/netronome/Kconfig
> +++ b/drivers/net/ethernet/netronome/Kconfig
> @@ -21,6 +21,7 @@ config NFP
>  	depends on PCI && PCI_MSI
>  	depends on VXLAN || VXLAN=n
>  	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
> +	depends on NET_MAY_USE_SWITCHDEV
>  	select NET_DEVLINK
>  	select CRC32
>  	help

This seems wrong, the NFP driver doesn't call
switchdev_bridge_port_offload()

> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 07192613256e..a73c6c236b25 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -93,6 +93,7 @@ config TI_CPTS
>  config TI_K3_AM65_CPSW_NUSS
>  	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
>  	depends on OF && TI_K3_UDMA_GLUE_LAYER
> +	depends on NET_MAY_USE_SWITCHDEV
>  	select NET_DEVLINK
>  	select TI_DAVINCI_MDIO
>  	imply PHY_TI_GMII_SEL

I believe this has already been addressed by the following patch in net

b0e81817629a ("net: build all switchdev drivers as modules when the bridge is a module")

> diff --git a/net/switchdev/Kconfig b/net/switchdev/Kconfig
> index 18a2d980e11d..3b0e627a4519 100644
> --- a/net/switchdev/Kconfig
> +++ b/net/switchdev/Kconfig
> @@ -12,3 +12,8 @@ config NET_SWITCHDEV
>  	  meaning of the word "switch". This include devices supporting L2/L3 but
>  	  also various flow offloading chips, including switches embedded into
>  	  SR-IOV NICs.
> +
> +config NET_MAY_USE_SWITCHDEV
> +	def_tristate y
> +	depends on NET_SWITCHDEV || NET_SWITCHDEV=n
> +	depends on BRIDGE || NET_SWITCHDEV=n
> -- 
> 2.29.2
> 
