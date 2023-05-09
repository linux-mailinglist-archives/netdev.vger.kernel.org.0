Return-Path: <netdev+bounces-1166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7496FC694
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F8DC1C20B57
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FA8125A7;
	Tue,  9 May 2023 12:39:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4C9AD47
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:39:03 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF29C469A;
	Tue,  9 May 2023 05:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683635940; x=1715171940;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xzdk72KbUe+yYCAi7WYxzDZUHKcsZ1rtLocbpgNiAd8=;
  b=XVzxpyW45X0aVIsnsNs3D7N71p2F/kPVReDwAJRzrXG3vtCl/guQVw5K
   pWvB+Gk3ULdeFbhyfM1FGbEmcySf17FKsalDC8yOq/7+sZE5CCZ0HWD7I
   wjRKyhR1/4IjGW9k3dRg/Q1+JjEE/ChSeDPZ6aoCR/iIFg7XzNzXN8yCy
   jNdHOe0e4qqP2MKzyw4BiPVMoEk3LnJ3xNal3bd2QXRMeqUyxvdYKCU3Z
   OxTtcGhAjoGnF70ialdaNBp/h8lx3C+0J/rI5aVvT2fQ415yVNcJopsrv
   SdlyZNHcH7QyK8Ek2S5MapxWLNULMe8DddktsSpRHhb93P6mYTBcbqIfj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="329536230"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="329536230"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 05:38:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="810659266"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="810659266"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 09 May 2023 05:38:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 05:38:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 05:38:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 05:38:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 05:38:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEaxEOXHj797ymJ0Heu2z2KHrCtXbcne+NcN0XRwsq+/MqtqUeRcj8q/5dZKcsRVf0CnPPR004FVWSt8gWH62Vszvf++edCcuNTkW0vyE2FKZRSHEAxyZgY9n0EfhcmGc2bcpFTXnf+/E2nC6tQ4Ct2l4vooYa99ry3bPJeVvtOYy8xP/EwQ8ejsJj816Z+ognFJjRGOeAOpkrr6CmuUhJu3bNCx/vBE5ObWNiUJ7GV5mak7Ilm+1VtQnUMwa2WenP5BpfRrpTCKjKWvhUVtAY3WcNOeZyfTT95khmRzK/4CcRW5myhov4XpBE+vqee60/jo6fEA4ulpTu/mUFUECg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgxHxTMEnsbsRw5yyuYYMwslSn/tQ0w1K3guacXUyqQ=;
 b=Np2A3+fwfOdusHjvnahWBdqbJqRWY3PcwZNwMro3hqphsF/MonR5wsT6SpFBXhtE6zsLl5a3beyNPAq7WSRtEAS6HbIyHzKv/RF4xPCz93xn0MtscHThAo4Hbk6ngytdcbSDAxcEPoeW7iO1POtv8ljSifQw2wReYwpcybFYDwXuCXkNt4qbeiHEQq283gL7Y+ly+WAjKVulVy4K4/R/aO+qtvKhygCb3/euvSWIoKQbPJVH8qtZ8kuYH/KICaGTqaitGTKSnPib6hsdUqPBbi5bmHzyjJyt3sSRcDhWySFvWeVThHmQic30ztQ6v1ayeECQRvi9fF5+WHwwd1eGnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH8PR11MB6753.namprd11.prod.outlook.com (2603:10b6:510:1c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 12:38:37 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 12:38:37 +0000
Date: Tue, 9 May 2023 14:38:27 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
CC: <netdev@vger.kernel.org>, <jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>, <mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>, <Jose.Abreu@synopsys.com>, <andrew@lunn.ch>,
	<hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next v7 1/9] net: txgbe: Add software nodes to
 support phylink
Message-ID: <ZFo+w43/kIAN4ite@nimitz>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-2-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230509022734.148970-2-jiawenwu@trustnetic.com>
X-ClientProxiedBy: LO2P265CA0393.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::21) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH8PR11MB6753:EE_
X-MS-Office365-Filtering-Correlation-Id: 35f68dd5-3590-4106-e807-08db508a4f2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96aXeDNb3ny9rwH0+yhher04KOveXi7ms5Ijr14Z8JEYD8qKdDyTp8lIQ6mBd3IzZHACMrADCanaADdMxbKKw47swwZq+zoOuM3hI7v+X9/JkbLAcEZWG9igetosF4DSU3J/D9HJ9aCZkVMzUKQwSwUTFURBYouL3KmurTFeuQ12gKZ4eOgStxD+dvcH7ptSxDZNuAgFuh1dqkmCLkttIOPIXSAXvxxw4TUSGrFpMW42Of8Ow2LVSF+R1k+ZsQcHAYLUGOQQWlcl93xGvQsaOp+J/vkUA/FxrutpX1kI45+mXVJBZAiDn9XS79mfZR3jjIPm2/KLW19TtKXE1OiGNZMNglovqG5eG4BR5hOVgF5dbHss9QMM93sTy+FzrMrE+wQYg0A1MXZEApm+7fMKDc5K03657EGlMMmCK/5pFQoKwQLhPU9nvMeMyPK1HXT5suXBsYH3tFeS3xfm/lMjebnMcQXz1RnnUx4Wboq/wMbirJ283ElAEupSxSf7wHhJymc49y37tok+j3lr0sAHH6s+p8sfhY7TDMX3C2bPuxIhM00DLXyS8NGHHVlrXFU+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(86362001)(478600001)(66476007)(316002)(6916009)(4326008)(66556008)(6486002)(6666004)(66946007)(33716001)(5660300002)(8676002)(30864003)(8936002)(2906002)(7416002)(41300700001)(44832011)(82960400001)(38100700002)(186003)(6512007)(9686003)(26005)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sl2wxpx7QII3Sr4b4gU8JRYsfOF+8qJ2HLNlD8S64vDg4TJvtSai5KVmb0Jk?=
 =?us-ascii?Q?gvfliC+3fHhtPVI5AHvCIowQ9rT405aGEMADUYWAGJZJmNn+2uCycsgCRGxx?=
 =?us-ascii?Q?gSbd2RptYkslxYgbE8Slc8eD9zrbNZ+VrL6GCRy5kMSC+NgkOoQcWcTxvILI?=
 =?us-ascii?Q?kqIeyuCWQsJQiOSPLh/jUv3NuiMXzuK1OLuNfaPKSL8ws77UAHXD4HSJOhsT?=
 =?us-ascii?Q?B+ZIH5ddHH6ey3vBBKYS8NitUFgNq66md9GBkCh2dcVs9vQc+YBlp+s6WIzX?=
 =?us-ascii?Q?ruyvQjKGQsSiPTgssRqNBhjQbOhe8ESnWE74Tqu4amSUc2Yo65FvWn86/STB?=
 =?us-ascii?Q?jEWZ6LJGOphUMT4WJZCBqEUTSqnUcOmcG+hhEu7wIq5xdwLKx+ejhdga/jZn?=
 =?us-ascii?Q?rqBraU2FbL/q4kxfj8334IUNSEizUdmpcb9rodeNV1Nruec3WvwgNZ+EPz8y?=
 =?us-ascii?Q?0fpE9TpXx1FVLu/7U+fJAcV4JJWCLtG1u7EiLaMmzMLSz/dy/CSZo2WlKjL2?=
 =?us-ascii?Q?LNlzeAdQcYmi9t5wDY+6S130uzgu/sAZ6d0PuXqjrYHOk1fMuIIibT5FiczM?=
 =?us-ascii?Q?w+Mp51zot8qhWbFq4zcydq+Jra2JaisnVV/zX9hz0Mfxe8TeMW+7gRoUs2ey?=
 =?us-ascii?Q?1M4+Xmx3V4bnMM8EThN91dCxIJCyc9vPTIGLMzOx97ZSo3ImgoAXqstaVo5u?=
 =?us-ascii?Q?U/FlpqGYWCsiHQGI2dhqgIHzyBR1DKRlcj6xb9gOpOR223LKDhhiFApWETdr?=
 =?us-ascii?Q?5l5fc0FlrvYmtaeSBd1R8yYyrrDMGi8H3vEc3jedQS1FnP+lkZAe8AJGh8Vs?=
 =?us-ascii?Q?DgqPEXVKvysx3+CsVA0n1b6I0uo3+pNMYu76gCR4clKmBRxq/o+JOSQ1nOK8?=
 =?us-ascii?Q?0DYFlVJuy2NtiFC2s+pt5zQxR/WTVLn4uqH4nw2LSxjz8ftEQy6PkPB0XljI?=
 =?us-ascii?Q?yvVwnmSbc9WY9MnbsRnn8kpZUgbKVFJZBr6C9qifXPFoeou59D+lfx1Lmn/X?=
 =?us-ascii?Q?66N0J3jR1yw0VjfcfyggMig/csGvw/AKhJBrcdAyjptyzptUaottB1Z7OASZ?=
 =?us-ascii?Q?/pzBM159jSL9WPm5aIflJHtdfrnOq7N4VNmuYzhgUZF7zq94hboJ2lEhuVaX?=
 =?us-ascii?Q?StGbTreYXgOMb0cXeW6PPwMBtSTtHe94PdmgTFuy956kFaVIunitF2xgK9rY?=
 =?us-ascii?Q?UhqgobIpjLYjltGVkQ7dOfKkxAY8e2YEZDBodFjoIxp6tfBXN0r9VanE5ga+?=
 =?us-ascii?Q?npxDc6uWUNGsQ/Eatair+uJyO4cnlB6iyPYlt/kYPBtil0xEtq2iYfkrQPHW?=
 =?us-ascii?Q?efc50p/GrHg+Hb4nsVktkipmcjkAw8yVvbO+T03IQ4h/WdKNfCrSfwK9a3XQ?=
 =?us-ascii?Q?uzEBURwJWnDMcVAPvk0Ad1befJWKDp+EI2DxRtKmWc6jJ8ltUhsyC50OgxNB?=
 =?us-ascii?Q?xPfAZq5RHieYepDlruyBA5phtf7GzmPkr5ygvyvwg4CTBJtfAavr1uVNO4HZ?=
 =?us-ascii?Q?m+SnqOSdkKHI5Ggx/txarkE1xFKBbV55CV/X032Pd+03ohrJrKJ/g0eYD7Ly?=
 =?us-ascii?Q?ORK7Z6BbofrBOWU0+/Nfijd1YP17jVZKNVU23k+aUbZgo7U1N9R+Lr82rCgx?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35f68dd5-3590-4106-e807-08db508a4f2a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 12:38:36.9487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ReeLsA/DRxuNAloWm3EJcHOsY4eRfs302tXJLe70rZxzjCN3U3G+NiYx14ggU1Y4EDBaCwzcM1y0hIC+v3ekohdafaawLalaudnUFGU2JbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6753
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:27:26AM +0800, Jiawen Wu wrote:
> Register software nodes for GPIO, I2C, SFP and PHYLINK. Define the
> device properties.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
LGTM, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
>  drivers/net/ethernet/wangxun/txgbe/Makefile   |  1 +
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 22 ++++-
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 89 +++++++++++++++++++
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.h    | 10 +++
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 49 ++++++++++
>  6 files changed, 171 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
> 
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> index 32f952d93009..97bce855bc60 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -611,6 +611,7 @@ enum wx_isb_idx {
>  
>  struct wx {
>  	u8 __iomem *hw_addr;
> +	void *priv;
>  	struct pci_dev *pdev;
>  	struct net_device *netdev;
>  	struct wx_bus_info bus;
> diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
> index 6db14a2cb2d0..7507f762edfe 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/Makefile
> +++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
> @@ -8,4 +8,5 @@ obj-$(CONFIG_TXGBE) += txgbe.o
>  
>  txgbe-objs := txgbe_main.o \
>                txgbe_hw.o \
> +              txgbe_phy.o \
>                txgbe_ethtool.o
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> index 5b8a121fb496..e10296abf5b4 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> @@ -15,6 +15,7 @@
>  #include "../libwx/wx_hw.h"
>  #include "txgbe_type.h"
>  #include "txgbe_hw.h"
> +#include "txgbe_phy.h"
>  #include "txgbe_ethtool.h"
>  
>  char txgbe_driver_name[] = "txgbe";
> @@ -513,6 +514,7 @@ static int txgbe_probe(struct pci_dev *pdev,
>  	struct net_device *netdev;
>  	int err, expected_gts;
>  	struct wx *wx = NULL;
> +	struct txgbe *txgbe;
>  
>  	u16 eeprom_verh = 0, eeprom_verl = 0, offset = 0;
>  	u16 eeprom_cfg_blkh = 0, eeprom_cfg_blkl = 0;
> @@ -663,10 +665,23 @@ static int txgbe_probe(struct pci_dev *pdev,
>  			 "0x%08x", etrack_id);
>  	}
>  
> -	err = register_netdev(netdev);
> +	txgbe = devm_kzalloc(&pdev->dev, sizeof(*txgbe), GFP_KERNEL);
> +	if (!txgbe) {
> +		err = -ENOMEM;
> +		goto err_release_hw;
> +	}
> +
> +	txgbe->wx = wx;
> +	wx->priv = txgbe;
> +
> +	err = txgbe_init_phy(txgbe);
>  	if (err)
>  		goto err_release_hw;
>  
> +	err = register_netdev(netdev);
> +	if (err)
> +		goto err_remove_phy;
> +
>  	pci_set_drvdata(pdev, wx);
>  
>  	netif_tx_stop_all_queues(netdev);
> @@ -694,6 +709,8 @@ static int txgbe_probe(struct pci_dev *pdev,
>  
>  	return 0;
>  
> +err_remove_phy:
> +	txgbe_remove_phy(txgbe);
>  err_release_hw:
>  	wx_clear_interrupt_scheme(wx);
>  	wx_control_hw(wx, false);
> @@ -719,11 +736,14 @@ static int txgbe_probe(struct pci_dev *pdev,
>  static void txgbe_remove(struct pci_dev *pdev)
>  {
>  	struct wx *wx = pci_get_drvdata(pdev);
> +	struct txgbe *txgbe = wx->priv;
>  	struct net_device *netdev;
>  
>  	netdev = wx->netdev;
>  	unregister_netdev(netdev);
>  
> +	txgbe_remove_phy(txgbe);
> +
>  	pci_release_selected_regions(pdev,
>  				     pci_select_bars(pdev, IORESOURCE_MEM));
>  
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> new file mode 100644
> index 000000000000..3476074869cb
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> @@ -0,0 +1,89 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
> +
> +#include <linux/gpio/property.h>
> +#include <linux/i2c.h>
> +#include <linux/pci.h>
> +
> +#include "../libwx/wx_type.h"
> +#include "txgbe_type.h"
> +#include "txgbe_phy.h"
> +
> +static int txgbe_swnodes_register(struct txgbe *txgbe)
> +{
> +	struct txgbe_nodes *nodes = &txgbe->nodes;
> +	struct pci_dev *pdev = txgbe->wx->pdev;
> +	struct software_node *swnodes;
> +	u32 id;
> +
> +	id = (pdev->bus->number << 8) | pdev->devfn;
> +
> +	snprintf(nodes->gpio_name, sizeof(nodes->gpio_name), "txgbe_gpio-%x", id);
> +	snprintf(nodes->i2c_name, sizeof(nodes->i2c_name), "txgbe_i2c-%x", id);
> +	snprintf(nodes->sfp_name, sizeof(nodes->sfp_name), "txgbe_sfp-%x", id);
> +	snprintf(nodes->phylink_name, sizeof(nodes->phylink_name), "txgbe_phylink-%x", id);
> +
> +	swnodes = nodes->swnodes;
> +
> +	/* GPIO 0: tx fault
> +	 * GPIO 1: tx disable
> +	 * GPIO 2: sfp module absent
> +	 * GPIO 3: rx signal lost
> +	 * GPIO 4: rate select, 1G(0) 10G(1)
> +	 * GPIO 5: rate select, 1G(0) 10G(1)
> +	 */
> +	nodes->gpio_props[0] = PROPERTY_ENTRY_STRING("pinctrl-names", "default");
> +	swnodes[SWNODE_GPIO] = NODE_PROP(nodes->gpio_name, nodes->gpio_props);
> +	nodes->gpio0_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 0, GPIO_ACTIVE_HIGH);
> +	nodes->gpio1_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 1, GPIO_ACTIVE_HIGH);
> +	nodes->gpio2_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 2, GPIO_ACTIVE_LOW);
> +	nodes->gpio3_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 3, GPIO_ACTIVE_HIGH);
> +	nodes->gpio4_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 4, GPIO_ACTIVE_HIGH);
> +	nodes->gpio5_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 5, GPIO_ACTIVE_HIGH);
> +
> +	nodes->i2c_props[0] = PROPERTY_ENTRY_STRING("compatible", "snps,designware-i2c");
> +	nodes->i2c_props[1] = PROPERTY_ENTRY_BOOL("snps,i2c-platform");
> +	nodes->i2c_props[2] = PROPERTY_ENTRY_U32("clock-frequency", I2C_MAX_STANDARD_MODE_FREQ);
> +	swnodes[SWNODE_I2C] = NODE_PROP(nodes->i2c_name, nodes->i2c_props);
> +	nodes->i2c_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_I2C]);
> +
> +	nodes->sfp_props[0] = PROPERTY_ENTRY_STRING("compatible", "sff,sfp");
> +	nodes->sfp_props[1] = PROPERTY_ENTRY_REF_ARRAY("i2c-bus", nodes->i2c_ref);
> +	nodes->sfp_props[2] = PROPERTY_ENTRY_REF_ARRAY("tx-fault-gpios", nodes->gpio0_ref);
> +	nodes->sfp_props[3] = PROPERTY_ENTRY_REF_ARRAY("tx-disable-gpios", nodes->gpio1_ref);
> +	nodes->sfp_props[4] = PROPERTY_ENTRY_REF_ARRAY("mod-def0-gpios", nodes->gpio2_ref);
> +	nodes->sfp_props[5] = PROPERTY_ENTRY_REF_ARRAY("los-gpios", nodes->gpio3_ref);
> +	nodes->sfp_props[6] = PROPERTY_ENTRY_REF_ARRAY("rate-select1-gpios", nodes->gpio4_ref);
> +	nodes->sfp_props[7] = PROPERTY_ENTRY_REF_ARRAY("rate-select0-gpios", nodes->gpio5_ref);
> +	swnodes[SWNODE_SFP] = NODE_PROP(nodes->sfp_name, nodes->sfp_props);
> +	nodes->sfp_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_SFP]);
> +
> +	nodes->phylink_props[0] = PROPERTY_ENTRY_STRING("managed", "in-band-status");
> +	nodes->phylink_props[1] = PROPERTY_ENTRY_REF_ARRAY("sfp", nodes->sfp_ref);
> +	swnodes[SWNODE_PHYLINK] = NODE_PROP(nodes->phylink_name, nodes->phylink_props);
> +
> +	nodes->group[SWNODE_GPIO] = &swnodes[SWNODE_GPIO];
> +	nodes->group[SWNODE_I2C] = &swnodes[SWNODE_I2C];
> +	nodes->group[SWNODE_SFP] = &swnodes[SWNODE_SFP];
> +	nodes->group[SWNODE_PHYLINK] = &swnodes[SWNODE_PHYLINK];
> +
> +	return software_node_register_node_group(nodes->group);
> +}
> +
> +int txgbe_init_phy(struct txgbe *txgbe)
> +{
> +	int ret;
> +
> +	ret = txgbe_swnodes_register(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to register software nodes\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +void txgbe_remove_phy(struct txgbe *txgbe)
> +{
> +	software_node_unregister_node_group(txgbe->nodes.group);
> +}
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
> new file mode 100644
> index 000000000000..1ab592124986
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
> +
> +#ifndef _TXGBE_PHY_H_
> +#define _TXGBE_PHY_H_
> +
> +int txgbe_init_phy(struct txgbe *txgbe);
> +void txgbe_remove_phy(struct txgbe *txgbe);
> +
> +#endif /* _TXGBE_NODE_H_ */
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> index 63a1c733718d..5bef0f9df523 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> @@ -4,6 +4,8 @@
>  #ifndef _TXGBE_TYPE_H_
>  #define _TXGBE_TYPE_H_
>  
> +#include <linux/property.h>
> +
>  /* Device IDs */
>  #define TXGBE_DEV_ID_SP1000                     0x1001
>  #define TXGBE_DEV_ID_WX1820                     0x2001
> @@ -99,4 +101,51 @@
>  
>  extern char txgbe_driver_name[];
>  
> +static inline struct txgbe *netdev_to_txgbe(struct net_device *netdev)
> +{
> +	struct wx *wx = netdev_priv(netdev);
> +
> +	return wx->priv;
> +}
> +
> +#define NODE_PROP(_NAME, _PROP)			\
> +	(const struct software_node) {		\
> +		.name = _NAME,			\
> +		.properties = _PROP,		\
> +	}
> +
> +enum txgbe_swnodes {
> +	SWNODE_GPIO = 0,
> +	SWNODE_I2C,
> +	SWNODE_SFP,
> +	SWNODE_PHYLINK,
> +	SWNODE_MAX
> +};
> +
> +struct txgbe_nodes {
> +	char gpio_name[32];
> +	char i2c_name[32];
> +	char sfp_name[32];
> +	char phylink_name[32];
> +	struct property_entry gpio_props[1];
> +	struct property_entry i2c_props[3];
> +	struct property_entry sfp_props[8];
> +	struct property_entry phylink_props[2];
> +	struct software_node_ref_args i2c_ref[1];
> +	struct software_node_ref_args gpio0_ref[1];
> +	struct software_node_ref_args gpio1_ref[1];
> +	struct software_node_ref_args gpio2_ref[1];
> +	struct software_node_ref_args gpio3_ref[1];
> +	struct software_node_ref_args gpio4_ref[1];
> +	struct software_node_ref_args gpio5_ref[1];
> +	struct software_node_ref_args sfp_ref[1];
> +	struct software_node swnodes[SWNODE_MAX];
> +	const struct software_node *group[SWNODE_MAX + 1];
> +};
> +
> +struct txgbe {
> +	struct wx *wx;
> +	struct txgbe_nodes nodes;
> +};
> +
>  #endif /* _TXGBE_TYPE_H_ */
> -- 
> 2.27.0
> 
> 

