Return-Path: <netdev+bounces-2598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4481702A5A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63B532810BE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4FAC2DD;
	Mon, 15 May 2023 10:18:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35039A938
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:18:02 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA101FD3;
	Mon, 15 May 2023 03:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684145854; x=1715681854;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zXP5EGvg6yDn+koQpGt8F1diigG9+u9TYmXlbctjnQY=;
  b=mZw37gxHPvVuLAdS0Hl1sjYAdFymdN5lABPvyYMDkpO0Kv9FNcJxO0CD
   O07E6nOLmcwQd2WtWWawns5xZmFr48Q6CsdCtolIYw8ZVNZ79MiSnf1jr
   WdHKu1BZ5RVyJW0fmK3gN+JTOPFQMXOEeOuVTu5SKnEekoYurRsy9DxyY
   0VorMOr19rfPmWbsB/4T2X9b6YFCUkAaqOg3Gb9wa2yixfBToWiCDf88Q
   +0B+wKWVlrgcq0J1WAdQIYOhyd0zJXGVymV0zuTyf5uvCqqJN53vhOwM6
   E2OvKPWylVbfrXL2mKZL6DGDivlp8fVKyJsbqhxCZXTJXWFHgI85EV/jn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="354320989"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="354320989"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 03:17:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="731581481"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="731581481"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 15 May 2023 03:16:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 03:16:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 03:16:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 03:16:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 03:16:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKon+QltOT2PVBz8ggBjmwki6lGdsKbfiyStRbMNa5UY1rY87lplM25nhsRR7iqDIaj38nysy7CKStMOlREA5gc38hjY6Auua2gPH0acpV7U1rMwYvFrDEb2HqcMrCEiANpP5K54G9PZYGL9GwmN7EXPx7BU8jSfkqTcZsSqD4RxEb3fZIWJonRLRZaNZh2zD/hecfxTW0ND4dCf/xAnXCG/y7cYInE9OuW22rjnuiHBUSEiSFGtj3WN4G3jNa2rnqI5cvbqc4gV3qPFs8MDabUNrfNLmbJN3ymXQvTcOCjoJZoU9GnDSyPb1UpbX4EYNv+Ze1lXzBmX1c45nyCNYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOppTF8ndnwZYRRJxw+Wt8YFV3xXA2uKS0IdcQCaafg=;
 b=WIJoXNeSJ6pnWeIUp5D0zXMG31BcuuC1nGuMs2vWoLXZXzc1GPYbLdGtL4sP4kVMPIV50nFq9DHJaPxEjbefBK6w/6w57xW7hLegQjDbirB2iGeMTcwKfgFYsz1VsNawYfuWhbKRLrH/MXs9z+KyUvTIeGq5SyQdGo/6ePCiEwV6sUY03AJwQE8PwDEP5+IjBv4xVYL5RFr6jGcckuavbVMIYEaWTc8WyOHA6Kc+Lv791s5OwCtJrDhP3mQakMi31fDz5zQqSufnTEpvmJlj9IP/+jpz+SyKb+M86G+jB9KpKf8z5jWBIbn6OfCgJmIKqoa9SmPIw7/G8uxFgQ8YJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SA3PR11MB7434.namprd11.prod.outlook.com (2603:10b6:806:306::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 10:16:57 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 10:16:57 +0000
Date: Mon, 15 May 2023 12:16:49 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 2/7] net: lan966x: Add support for offloading
 pcp table
Message-ID: <ZGIGkZDW84tHr04f@nimitz>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
 <20230514201029.1867738-3-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230514201029.1867738-3-horatiu.vultur@microchip.com>
X-ClientProxiedBy: LO4P123CA0164.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::7) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SA3PR11MB7434:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b11ec95-ae61-4b67-c0cd-08db552d8330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1SLNF9YI08HLgRaLMa/SGrKewxAd6O9QrESvmT3sCWRrS2JR7IydO/skCaByfwPSZY9uov5o3+fgoD+iiLyyrFgahXy8/37qYq7Xkzmez9K6DgxKV0NGo+txVjp+h6DG2YMumkozNT+Sh7GNMP0KzIy3c/baXXfCBKVTaPyEc+yIWMmVgAv9YRRNIZdC2hiZP41Wz3eJjMmahc76X9AgMgYqZb1/KzsXqomp3SE2BhpHya+/2q3f4feheoI+crCr0FFabq9ayg0lNfQwkrxW4jTI1ancbd/XfZVnGRjhwSYSaDOv6IEOmuLn1drfoUO6mzss7Z8Sg3dJn3UX8Qsatjuprcro81M/qD4IYor7wlJNHnBp47H6nQvrfk7f2oJ7qxq3nXrCMA/3+6nbxc/BKDnl8biwkY/cnEfPcpUfktDT+6nAqGgeW2jGTEN9WXkZrMn5LXGRU7OUYE5DqC0WO4F7tmaJf0gNPUgQdW5WPsHEpfqofvO003oUQY4QT5FKaKpgEjzkkw9xWS58avufpd8aZxZmVnYJqW1w+XX/EgbmrePzV3QTKVELLIfq1XxO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199021)(9686003)(6506007)(26005)(6512007)(83380400001)(38100700002)(41300700001)(6486002)(6666004)(186003)(478600001)(6916009)(82960400001)(4326008)(316002)(66556008)(66476007)(66946007)(5660300002)(44832011)(8676002)(8936002)(33716001)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LnsoasW65d3CFaO+FIxByVQkAndSUjKRZD1cL0IuK9y4BDmVUr1S7W+ZTf6P?=
 =?us-ascii?Q?UnJbblakF2QrmpTzVOwivZqInSL8XzHy1zppYUxyf8TwlzwBM2FTFDpYXwnd?=
 =?us-ascii?Q?9HwVtRCqZLbm1vl/8aN9Vya/x8R0ISLgyYvv/N7fk/E1UHbk7zlALniIEfP/?=
 =?us-ascii?Q?ppzpC9DJNZXMwNDmDv+7xxT2gwswSh2jfL9KSu87gn9nzD9c3r6WViW26+oI?=
 =?us-ascii?Q?G9SKU4yizq6I0YhnPKygPuOHuSqli8iYNtXdAYAaFugnFYBMe3jydi4qbvoZ?=
 =?us-ascii?Q?kXHN+TELihuZZCqwVHGAMmVrRohEG3Q5Nae+MS7XemyIVT0kz8iPZoDv9/dT?=
 =?us-ascii?Q?vZQD6kemFE/8J9Caw1pIhKavrFuWbdWbi6t07TxjuXPTdxoMdxWzxNYvpLbn?=
 =?us-ascii?Q?vwOZGb1N6l09Pftj3Mse+Uy2X2Q57hbiH0QNEfpry4oKa7uF7DAyrsgmJKLt?=
 =?us-ascii?Q?rAPQC6Qni21dSwTkeLQkbjnxUDVLQNTxMe7M+1x7AtovYSCeNt9k3s8KVhEj?=
 =?us-ascii?Q?CGHahuPx51mQq7jxZTNsnoA9LyiB5RsOfkkiU94Y3yBBkXGnNWEr6xglY82v?=
 =?us-ascii?Q?Uu6aU0p0nQHbTjLqxsBVBXuDodU+OmeHSAQZ5EmNSx4hugVUgGKi7xmP1mQw?=
 =?us-ascii?Q?aJiIyWzfUDhlS1c1jE6gpOzanYSPXktjtPiJuxpLKBAXN5shwjGcUbXXae/z?=
 =?us-ascii?Q?L1bTlc9k76s8FkyY5bKMoE744+qmfMhcDDNMe0MOGe0iD7QqwoxL9PrMB1lI?=
 =?us-ascii?Q?bh9gPPX/u9qQQX0r3OfqaamlkhO1/u8mVd682OUSeKRknh/Sj8CGKtEUFjBl?=
 =?us-ascii?Q?dcpZ2yFw7cnDBLEN2WiAym+3w1s9UDq1hgn1ggnlaECFnxtdCxWCxeaFVjwI?=
 =?us-ascii?Q?A2ibjMROLhRVYBCkb4JJzk1fJdmp3hKX+2Flf9CfAGWKs8kmT6NVQM90yJgp?=
 =?us-ascii?Q?wXsBn58NPIsJuHpn+IJX277JWYhQzPe/N6fPlOxVv+MK/sqHP8EcvhRZYMHk?=
 =?us-ascii?Q?cDk4JXoL9mLOvyYMkZe5HReMXJi/0x1LIAtF4/hZWCMtjFqNi9876oV7ylu3?=
 =?us-ascii?Q?XS6NAZmOGzobEQ5iYImhfgFATWq5ayjTwbVOBtbK6DSreC9UNNxK6y1tXQQO?=
 =?us-ascii?Q?whWrRapb+oDq465LpZQWK6BhuXdCEEfCDMygdBRRDGwATtxaOJrpy9PM0owB?=
 =?us-ascii?Q?agEVUpxVcr2XP8YY02ZyVhuFgTALCYS4IxCLp0DGaX7qqYJX9RcaLJjT9h+8?=
 =?us-ascii?Q?QjkKwytDuEnrKSIXpd5y8r8vIOr3T07BM8dp2eA7Fb3Vph0xyjmvSv9A2bNa?=
 =?us-ascii?Q?qFBlrMcChw3ns/K2N8uYEoOV5roKXtkVC/t8SvU0EhfGVaWpepnsH/b0NcXn?=
 =?us-ascii?Q?yxHtg+2RxspwWG4ykkEjNkkZe54hpOqTNRPw/GpGnbWGl7LVjB448PVStUHZ?=
 =?us-ascii?Q?et4vf3fXTtZU8YfFjxxm3VxbjXxI3LLmDFdwYLmlSws4CLa/aCpZjNSZpIWM?=
 =?us-ascii?Q?TRZu5Rj2sLwqWa8cW7IL4/Xa0uuWNZM5UFr8DeaBRFQFkyUfGqkRVCI7SaOv?=
 =?us-ascii?Q?bdmB+SBlqWYfEguNkkdfW2NyyZlE+NW/sJ35l0psFGCEWr02LlhaLp3QCtQu?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b11ec95-ae61-4b67-c0cd-08db552d8330
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 10:16:56.8547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZE1YJ8sqezVeeF2LMtFmRXxpgyoahY9gWFGFAWWm0meeLEbNnMo2Zk/RSQQoKUEs7iQJhAfl4vkSM+s3nf4ckgFBgwb7P9n3+/j2s9w3E8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7434
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 10:10:24PM +0200, Horatiu Vultur wrote:
> Add support for offloading pcp app entries. Lan966x has 8 priority
> queues per port and for each priority it also has a drop precedence.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Kconfig    |  11 ++
>  .../net/ethernet/microchip/lan966x/Makefile   |   1 +
>  .../ethernet/microchip/lan966x/lan966x_dcb.c  | 104 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_main.c |   2 +
>  .../ethernet/microchip/lan966x/lan966x_main.h |  25 +++++
>  .../ethernet/microchip/lan966x/lan966x_port.c |  30 +++++
>  6 files changed, 173 insertions(+)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
> index 571e6d4da1e9d..f9ebffc04eb85 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Kconfig
> +++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
> @@ -10,3 +10,14 @@ config LAN966X_SWITCH
>  	select VCAP
>  	help
>  	  This driver supports the Lan966x network switch device.
> +
> +config LAN966X_DCB
> +	bool "Data Center Bridging (DCB) support"
> +	depends on LAN966X_SWITCH && DCB
> +	default y
> +	help
> +	  Say Y here if you want to use Data Center Bridging (DCB) in the
> +	  driver. This can be used to assign priority to traffic, based on
> +	  DSCP and PCP.
> +
> +	  If unsure, set to Y.
> diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
> index 7b0cda4ffa6b5..3b6ac331691d0 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> @@ -15,6 +15,7 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
>  			lan966x_xdp.o lan966x_vcap_impl.o lan966x_vcap_ag_api.o \
>  			lan966x_tc_flower.o lan966x_goto.o
>  
> +lan966x-switch-$(CONFIG_LAN966X_DCB) += lan966x_dcb.o
>  lan966x-switch-$(CONFIG_DEBUG_FS) += lan966x_vcap_debugfs.o
>  
>  # Provide include files
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
> new file mode 100644
> index 0000000000000..8ec64336abd5f
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
> @@ -0,0 +1,104 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include "lan966x_main.h"
> +
> +static void lan966x_dcb_app_update(struct net_device *dev, bool enable)
> +{
> +	struct lan966x_port *port = netdev_priv(dev);
> +	struct lan966x_port_qos qos = {0};
> +	struct dcb_app app_itr;
> +
> +	/* Get pcp ingress mapping */
> +	for (int i = 0; i < ARRAY_SIZE(qos.pcp.map); i++) {
> +		app_itr.selector = DCB_APP_SEL_PCP;
> +		app_itr.protocol = i;
> +		qos.pcp.map[i] = dcb_getapp(dev, &app_itr);
> +	}
> +
> +	qos.pcp.enable = enable;
> +	lan966x_port_qos_set(port, &qos);
> +}
> +
> +static int lan966x_dcb_app_validate(struct net_device *dev,
> +				    const struct dcb_app *app)
> +{
> +	int err = 0;
> +
> +	switch (app->selector) {
> +	/* Pcp checks */
> +	case DCB_APP_SEL_PCP:
> +		if (app->protocol >= LAN966X_PORT_QOS_PCP_DEI_COUNT)
> +			err = -EINVAL;
> +		else if (app->priority >= NUM_PRIO_QUEUES)
> +			err = -ERANGE;
> +		break;
> +	default:
> +		err = -EINVAL;
> +		break;
> +	}
> +
> +	if (err)
> +		netdev_err(dev, "Invalid entry: %d:%d\n", app->protocol,
> +			   app->priority);
> +
> +	return err;
> +}
> +
> +static int lan966x_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
> +{
> +	int err;
> +
> +	err = dcb_ieee_delapp(dev, app);
> +	if (err < 0)
> +		return err;
> +
> +	lan966x_dcb_app_update(dev, false);
> +
> +	return 0;
> +}
> +
> +static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
> +{
> +	struct dcb_app app_itr;
> +	int err;
> +	u8 prio;
> +
> +	err = lan966x_dcb_app_validate(dev, app);
> +	if (err)
> +		goto out;
> +
> +	/* Delete current mapping, if it exists */
> +	prio = dcb_getapp(dev, app);
> +	if (prio) {
> +		app_itr = *app;
> +		app_itr .priority = prio;
Compiles OK, still looks little weird :).

> +		dcb_ieee_delapp(dev, &app_itr);
> +	}
> +
> +	err = dcb_ieee_setapp(dev, app);
> +	if (err)
> +		goto out;
> +
> +	lan966x_dcb_app_update(dev, true);
> +
> +out:
> +	return err;
> +}
> +
> +static const struct dcbnl_rtnl_ops lan966x_dcbnl_ops = {
> +	.ieee_setapp = lan966x_dcb_ieee_setapp,
> +	.ieee_delapp = lan966x_dcb_ieee_delapp,
> +};
> +
> +void lan966x_dcb_init(struct lan966x *lan966x)
> +{
> +	for (int p = 0; p < lan966x->num_phys_ports; ++p) {
> +		struct lan966x_port *port;
> +
> +		port = lan966x->ports[p];
> +		if (!port)
> +			continue;
> +
> +		port->dev->dcbnl_ops = &lan966x_dcbnl_ops;
> +	}
> +}
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index ee2698698d71a..f6931dfb3e68e 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -1223,6 +1223,8 @@ static int lan966x_probe(struct platform_device *pdev)
>  	if (err)
>  		goto cleanup_fdma;
>  
> +	lan966x_dcb_init(lan966x);
> +
>  	return 0;
>  
>  cleanup_fdma:
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 882d5a08e7d51..b9ca47ab6e8be 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -104,6 +104,11 @@
>  #define LAN966X_VCAP_CID_ES0_L0 VCAP_CID_EGRESS_L0 /* ES0 lookup 0 */
>  #define LAN966X_VCAP_CID_ES0_MAX (VCAP_CID_EGRESS_L1 - 1) /* ES0 Max */
>  
> +#define LAN966X_PORT_QOS_PCP_COUNT	8
> +#define LAN966X_PORT_QOS_DEI_COUNT	8
> +#define LAN966X_PORT_QOS_PCP_DEI_COUNT \
> +	(LAN966X_PORT_QOS_PCP_COUNT + LAN966X_PORT_QOS_DEI_COUNT)
> +
>  /* MAC table entry types.
>   * ENTRYTYPE_NORMAL is subject to aging.
>   * ENTRYTYPE_LOCKED is not subject to aging.
> @@ -392,6 +397,15 @@ struct lan966x_port_tc {
>  	struct flow_stats mirror_stat;
>  };
>  
> +struct lan966x_port_qos_pcp {
> +	u8 map[LAN966X_PORT_QOS_PCP_DEI_COUNT];
> +	bool enable;
> +};
> +
> +struct lan966x_port_qos {
> +	struct lan966x_port_qos_pcp pcp;
> +};
> +
>  struct lan966x_port {
>  	struct net_device *dev;
>  	struct lan966x *lan966x;
> @@ -456,6 +470,9 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
>  			 struct lan966x_port_config *config);
>  void lan966x_port_init(struct lan966x_port *port);
>  
> +void lan966x_port_qos_set(struct lan966x_port *port,
> +			  struct lan966x_port_qos *qos);
> +
>  int lan966x_mac_ip_learn(struct lan966x *lan966x,
>  			 bool cpu_copy,
>  			 const unsigned char mac[ETH_ALEN],
> @@ -680,6 +697,14 @@ int lan966x_goto_port_del(struct lan966x_port *port,
>  			  unsigned long goto_id,
>  			  struct netlink_ext_ack *extack);
>  
> +#ifdef CONFIG_LAN966X_DCB
> +void lan966x_dcb_init(struct lan966x *lan966x);
> +#else
> +static inline void lan966x_dcb_init(struct lan966x *lan966x)
> +{
> +}
> +#endif
> +
>  static inline void __iomem *lan_addr(void __iomem *base[],
>  				     int id, int tinst, int tcnt,
>  				     int gbase, int ginst,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> index 0050fcb988b75..0cee8127c48eb 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> @@ -394,6 +394,36 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
>  	return 0;
>  }
>  
> +static void lan966x_port_qos_pcp_set(struct lan966x_port *port,
> +				     struct lan966x_port_qos_pcp *qos)
> +{
> +	u8 *pcp_itr = qos->map;
> +	u8 pcp, dp;
> +
> +	lan_rmw(ANA_QOS_CFG_QOS_PCP_ENA_SET(qos->enable),
> +		ANA_QOS_CFG_QOS_PCP_ENA,
> +		port->lan966x, ANA_QOS_CFG(port->chip_port));
> +
> +	/* Map PCP and DEI to priority */
> +	for (int i = 0; i < ARRAY_SIZE(qos->map); i++) {
> +		pcp = *(pcp_itr + i);
> +		dp = (i < LAN966X_PORT_QOS_PCP_COUNT) ? 0 : 1;
> +
> +		lan_rmw(ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL_SET(pcp) |
> +			ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL_SET(dp),
> +			ANA_PCP_DEI_CFG_QOS_PCP_DEI_VAL |
> +			ANA_PCP_DEI_CFG_DP_PCP_DEI_VAL,
> +			port->lan966x,
> +			ANA_PCP_DEI_CFG(port->chip_port, i));
> +	}
> +}
> +
> +void lan966x_port_qos_set(struct lan966x_port *port,
> +			  struct lan966x_port_qos *qos)
> +{
> +	lan966x_port_qos_pcp_set(port, &qos->pcp);
> +}
> +
>  void lan966x_port_init(struct lan966x_port *port)
>  {
>  	struct lan966x_port_config *config = &port->config;
> -- 
> 2.38.0
> 
> 

