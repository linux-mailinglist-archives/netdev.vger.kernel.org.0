Return-Path: <netdev+bounces-2601-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7135C702A65
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45D1E1C20A4F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592F6C2E4;
	Mon, 15 May 2023 10:22:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CCCC148
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:22:23 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C604184;
	Mon, 15 May 2023 03:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684146141; x=1715682141;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oj77dpI5zZ/7MSOkB81a1dvwjCTpJxVbx9+s4bsPgSY=;
  b=nLBzjsUQXOZYwFVIOL7n35ecampgXi5tZjL3WZUtDA8FBFwDkMP5fIO5
   IFLVcD6EoCfeeGQHpBCq9fljQZyFx/B0iPu749wTaOYVtDqCT7I4Tx6L3
   HtsR8lh2XLaJz1SWXnq/UDIeL1sDOKBEuZwg0+p4FCH/38Yk8CNvJHJfA
   8+HQS491Kp35Jr6Bn/iMjSleOPT03InZKnDNCX667nOdlhbP7nqccTNpA
   mVTy7+opTZa0oy0DGXE2Bx+2wVGPZx/NtVuxcYlieAbve75/iJp+GkP9V
   if1tYCrUP/T7zff0kwz8SpaOjq4xHLlwD9a7niW/kJMzE2hEwxIT5pDpO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="351198336"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="351198336"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 03:22:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="812888971"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="812888971"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 15 May 2023 03:22:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 03:22:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 03:22:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 03:22:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipQiUxga+58pXd9beaNZCkN9m2WbbRZnP6KQKyJTw8uiSrCtBPGn6iAH9YcZzN5f1R3muP41MT1FyPvU5yqKeOXTTpQ98sKAs4yD8pgeXQ3Y24EUCG+ROYHRwIFTXgkRYfXOG9uF29ABQOdUMRBQ71VjHizJsS2vA5ByUp4m6DB4b9RxP9dbNCLAdOpBohInm/dEJyW6QUQNc95bRhQVM26Q1Mw82k46S8CRPdSgm6tH4gch44oVK7mHnJYN+h6TMjq9/iaMJDBAiS0Z9PPSsxugenHU45beHX9pjVzlR8JepEIS37BhZDknok5/n+QDIBMCpVvN3UATd0K3Wi8UzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyFHzSft+Hu+SAuHdX5yCofTjVZraNQ+0kEzNEieZfQ=;
 b=BM6L/qicZva6Yz2MDhGQ6lP+Cp9aYf+HJDJiPAhruDJujujyotsOBY94B0jtJU4+bAuegOcDw0mgx3pYpwEjI6LpznzMbhae3abDTDXXjW031RIY32lOgYXL2bdle9BY6U5T4jaq0gz9mLB+sYONmPzxNukCq1G+8dfayA3AdAKlv0SBIUY3hpOyMW+O42gjg+oZWdfydyO477CgWevEx2S89Ot811dIP73JV/LbXZSRtHyHHWQlj88xAQZ2fCqQyFXiRAQp2t7pyX1I09H7eJeU5hmykPoTOPAyUfv6ebgG0yo0x4NpNwpBekrn9wvznRMmd0wppQDrYGRsXB0+0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by DS0PR11MB8181.namprd11.prod.outlook.com (2603:10b6:8:159::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 10:22:15 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 10:22:15 +0000
Date: Mon, 15 May 2023 12:22:10 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 4/7] net: lan966x: Add support for offloading
 dscp table
Message-ID: <ZGIH0obdPl+cTNOe@nimitz>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
 <20230514201029.1867738-5-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230514201029.1867738-5-horatiu.vultur@microchip.com>
X-ClientProxiedBy: LO2P123CA0088.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::21) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|DS0PR11MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: 65107fee-81bd-4c5f-97e7-08db552e4101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HmXZJi2mtATAXLvCqiaMARIeI/DyR/y/B0Je/FFD7jBn3yOXc0nqg0/twJ/wuGyFHI47vDx9Ahx5+SiHcpLqN3GO3bsLA13nYa/D5O8KxSOVoYxVm1UfxkQ8Nd4L4uo7AtWIsqj4yRwCqumLpFiI4pcwm2lz3FPMF/ncZmWozMYapgVfIRHgLBwsdK1hIWqoOM0POAQZzlVEINMZnfgX2pzFBEYnKKueIXLBKBjmvQtc4pcpqgl75baNrwEP9PaGFlvot8Ib8q6JjrbBPMahkfsW3w6VOT4vnaSGbiqkLVJEDq1v7OOSBnjuBcl0maqn77bW7kCnCvNZ8/6X9seQiON+ddY/qvrS2XSHnqGypcNJHhOCFY9gnf5FE5h1iz4swPBU4CN+3+5Up4bmESxRsR78+znvJyHA1THQNu6S/+PW/XHyEHa65WKDoiJhRjXhfodwjQ5ngdeZmoYrFj1F3U4/t1XNiMrAX/6MSPvj0v2t7PUjCPTQheKD0jBKGNiCzPPe5QKeu3n8gDRSXngIvIFSKxoZIBLTpooz7CIr3SsgTYsabNzYLpDVQfYiNGXEEpcSeoz+JTyeTxN/Ave6r1gxcd1HF3TVEYP0n8T6gQA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(66946007)(66476007)(66556008)(6666004)(8936002)(83380400001)(6512007)(26005)(6506007)(6486002)(82960400001)(6916009)(4326008)(8676002)(2906002)(5660300002)(316002)(38100700002)(41300700001)(44832011)(86362001)(478600001)(33716001)(186003)(9686003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G23TmrCaJzfkHk+P9iIta0aK5SCK2N5xKyHnOPlunf5pUd7uR+f8BOtJin/U?=
 =?us-ascii?Q?Tvb1B6HN+zuFdDdbaTabarPUwXUgbWqP9ftOFCSb5/c7CBYUmYPr99kdnlN3?=
 =?us-ascii?Q?8OVoMUkdADY5MA49UR3V4beNzTVz+YHl37Nk8tM1laov7CjYY8mfBRjO6lws?=
 =?us-ascii?Q?gmd8Jlr2XKKNDwaBMyLjyeKqlLsezjd/AARQCx9MDJPWdkT8MynYpPoG0kZs?=
 =?us-ascii?Q?gfHagr0cGkKLVCWQ0elI5nn9tw8fcSokZLbWcy8sjMSUo7phWRZz+x8qRRJ8?=
 =?us-ascii?Q?sMZEEB7W5jgblHh8x7x1ottlbq1Cuh7RE1i091Jd5BfEL4cFoiWrL98QhGxT?=
 =?us-ascii?Q?vnsd+AGTM/+cLtxclLjR3iJ3flQkgNvyx/UgqUdGyQPxpLCdgBB5ZXMqWcT/?=
 =?us-ascii?Q?6S7WQdI4vJOonDiLLleL/Xto6CkJPOctxtujzMDrVk5gJ9XunHKhaGs41REf?=
 =?us-ascii?Q?eHS5KPX5gwHWGLqo8oFDmOfDHGaE4BY7gR1RPc3xeiLW0JjK1Z8kPyjyOiin?=
 =?us-ascii?Q?RcvdAlf41P2mzlsYpQQq0YWKjrtzUCX7thsUwTFWg6kwK8jHwaDPsDPF5C25?=
 =?us-ascii?Q?Q7rRJN1leQVhU4guhp2weKs+P7ae/F0/WVuSbi31WYisAdvCzLPw5luLDYO9?=
 =?us-ascii?Q?OhYNMnMWEpeBy20FUYX7Qe8Oe5iudL2I/6Uqd9wFH73z01VuRLfJhQ1NtKKl?=
 =?us-ascii?Q?zDLSsTrrpM0VsummPZ0EQfm8rmRR2EvlbW+lHxcACzzUC5CqUpn6zc+zPAda?=
 =?us-ascii?Q?8F3eINE5orhsaW7Ur0hpw2QlN7b/ZvLhDfqTjEdVsGavZB4uDIgrQRC+i6nC?=
 =?us-ascii?Q?0QFQvQ6WdSmDTFPFF8Xqf6Bd6XW4+AU9AyyJYhcpHW20zgk17BTqVC12PIqW?=
 =?us-ascii?Q?BgwlRV4R/TWrl9eaQ3IlGMJv6/qKRqsAy+UOn6CEuGmEL8pWcwKRw2RU3Mw9?=
 =?us-ascii?Q?34l6oXw0HcogW4iSJg5LCF15hJtOTs3EDi1PwgL4izS4JQWEKvgsTDDDdqNM?=
 =?us-ascii?Q?ztyfQ2bPsCM5V23A1asTznkhy16BzmHswGs3qH0D39mh17teVsrJp5z4BgRM?=
 =?us-ascii?Q?NTcAMqVh/gZi798urVzTDj+ouzqIfpRVelloexZuL9J2QvWDJtLTK+lAVI2J?=
 =?us-ascii?Q?bkB7a8WbbNoWM1HFL0XoIAEUMvIKTKouX75y+v50jq504ZZMVvtaV9bX2IHm?=
 =?us-ascii?Q?zmJDrFwwdZhbZ9f5tSAVV2rFRP1mZI9tsrnEZTNuDJv3tWhWmT/gWojz+fa4?=
 =?us-ascii?Q?eb2cU/8XYxZr3yubbVP8vXizU8Sr2K9ZNnsR0Lc+JbC1yR993wQDkuL59W2k?=
 =?us-ascii?Q?YsQjqG4nn2pSRBUcHdpZC+GX6m/z5QUP82Jz+P0L6PhB33uMH7o1yrxy/8N1?=
 =?us-ascii?Q?wmZpguzoR9KToArLGu34yQvkVYSkcaE3pIMN5ETxFJ5NZlr44D+SpNM1g3ng?=
 =?us-ascii?Q?qV4MrkY6LGFLMqmr0bg9g73S6rjEhUVq5/Bt2H3QMJZ/MXWnchELQMfnlSmh?=
 =?us-ascii?Q?t0hjgtE0IGbZJ5R/KABnRZ7urFKknvwf3Jw2kvWkTwx5v/aF9OG8n35YuEys?=
 =?us-ascii?Q?kgGAfnx/oxn2bGHIVUu+mQwIuulvSeNVd9bcxZ6K4RTIZr3hZKgGZ/6xLOdI?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65107fee-81bd-4c5f-97e7-08db552e4101
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 10:22:15.3048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRnuriTZkWSHZtWaVYTVManD44vFfnS0e0JXQCT4iIvPA9pS4duLRvDhF/BXM9VBZLpqVObtOE6H01V3Tu2pvrH/OcIbtijAMqxQAzeP4x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 10:10:26PM +0200, Horatiu Vultur wrote:
> Add support for offloading dscp app entries. The dscp values are global
> for all lan966x ports.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_dcb.c  | 61 +++++++++++++++++--
>  .../ethernet/microchip/lan966x/lan966x_main.h |  8 +++
>  .../ethernet/microchip/lan966x/lan966x_port.c | 26 ++++++++
>  3 files changed, 90 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
> index c149f905fe9e3..2b518181b7f08 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_dcb.c
> @@ -57,19 +57,62 @@ static void lan966x_dcb_app_update(struct net_device *dev)
>  		qos.pcp.map[i] = dcb_getapp(dev, &app_itr);
>  	}
>  
> +	/* Get dscp ingress mapping */
> +	for (int i = 0; i < ARRAY_SIZE(qos.dscp.map); i++) {
> +		app_itr.selector = IEEE_8021QAZ_APP_SEL_DSCP;
> +		app_itr.protocol = i;
> +		qos.dscp.map[i] = dcb_getapp(dev, &app_itr);
> +	}
> +
>  	/* Enable use of pcp for queue classification */
>  	if (lan966x_dcb_apptrust_contains(port->chip_port, DCB_APP_SEL_PCP))
>  		qos.pcp.enable = true;
>  
> +	/* Enable use of dscp for queue classification */
> +	if (lan966x_dcb_apptrust_contains(port->chip_port, IEEE_8021QAZ_APP_SEL_DSCP))
> +		qos.dscp.enable = true;
> +
>  	lan966x_port_qos_set(port, &qos);
>  }
>  
> +/* DSCP mapping is global for all ports, so set and delete app entries are
> + * replicated for each port.
> + */
> +static int lan966x_dcb_ieee_dscp_setdel(struct net_device *dev,
> +					struct dcb_app *app,
> +					int (*setdel)(struct net_device *,
> +						      struct dcb_app *))
> +{
> +	struct lan966x_port *port = netdev_priv(dev);
> +	struct lan966x *lan966x = port->lan966x;
> +	int err;
> +
> +	for (int i = 0; i < NUM_PHYS_PORTS; i++) {
> +		port = lan966x->ports[i];
> +		if (!port)
> +			continue;
> +
> +		err = setdel(port->dev, app);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
>  static int lan966x_dcb_app_validate(struct net_device *dev,
>  				    const struct dcb_app *app)
>  {
>  	int err = 0;
>  
>  	switch (app->selector) {
> +	/* Dscp checks */
> +	case IEEE_8021QAZ_APP_SEL_DSCP:
> +		if (app->protocol >= LAN966X_PORT_QOS_DSCP_COUNT)
> +			err = -EINVAL;
> +		else if (app->priority >= NUM_PRIO_QUEUES)
> +			err = -ERANGE;
> +		break;
>  	/* Pcp checks */
>  	case DCB_APP_SEL_PCP:
>  		if (app->protocol >= LAN966X_PORT_QOS_PCP_DEI_COUNT)
> @@ -93,8 +136,12 @@ static int lan966x_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
>  {
>  	int err;
>  
> -	err = dcb_ieee_delapp(dev, app);
> -	if (err < 0)
> +	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
> +		err = lan966x_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_delapp);
> +	else
> +		err = dcb_ieee_delapp(dev, app);
> +
> +	if (err)
>  		return err;
>  
>  	lan966x_dcb_app_update(dev);
> @@ -117,12 +164,16 @@ static int lan966x_dcb_ieee_setapp(struct net_device *dev, struct dcb_app *app)
>  	if (prio) {
>  		app_itr = *app;
>  		app_itr .priority = prio;
> -		dcb_ieee_delapp(dev, &app_itr);
> +		lan966x_dcb_ieee_delapp(dev, &app_itr);
>  	}
>  
> -	err = dcb_ieee_setapp(dev, app);
> +	if (app->selector == IEEE_8021QAZ_APP_SEL_DSCP)
> +		err = lan966x_dcb_ieee_dscp_setdel(dev, app, dcb_ieee_setapp);
> +	else
> +		err = dcb_ieee_setapp(dev, app);
> +
>  	if (err)
> -		goto out;
> +		return err;
Looks like you can alco completely remove goto and out, just return err
in other cases in this function.

>  
>  	lan966x_dcb_app_update(dev);
>  
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index b9ca47ab6e8be..8213440e08672 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -109,6 +109,8 @@
>  #define LAN966X_PORT_QOS_PCP_DEI_COUNT \
>  	(LAN966X_PORT_QOS_PCP_COUNT + LAN966X_PORT_QOS_DEI_COUNT)
>  
> +#define LAN966X_PORT_QOS_DSCP_COUNT	64
> +
>  /* MAC table entry types.
>   * ENTRYTYPE_NORMAL is subject to aging.
>   * ENTRYTYPE_LOCKED is not subject to aging.
> @@ -402,8 +404,14 @@ struct lan966x_port_qos_pcp {
>  	bool enable;
>  };
>  
> +struct lan966x_port_qos_dscp {
> +	u8 map[LAN966X_PORT_QOS_DSCP_COUNT];
> +	bool enable;
> +};
> +
>  struct lan966x_port_qos {
>  	struct lan966x_port_qos_pcp pcp;
> +	struct lan966x_port_qos_dscp dscp;
>  };
>  
>  struct lan966x_port {
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> index 0cee8127c48eb..11c552e87ee44 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
> @@ -418,10 +418,36 @@ static void lan966x_port_qos_pcp_set(struct lan966x_port *port,
>  	}
>  }
>  
> +static void lan966x_port_qos_dscp_set(struct lan966x_port *port,
> +				      struct lan966x_port_qos_dscp *qos)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +
> +	/* Enable/disable dscp for qos classification. */
> +	lan_rmw(ANA_QOS_CFG_QOS_DSCP_ENA_SET(qos->enable),
> +		ANA_QOS_CFG_QOS_DSCP_ENA,
> +		lan966x, ANA_QOS_CFG(port->chip_port));
> +
> +	/* Map each dscp value to priority and dp */
> +	for (int i = 0; i < ARRAY_SIZE(qos->map); i++)
> +		lan_rmw(ANA_DSCP_CFG_DP_DSCP_VAL_SET(0) |
> +			ANA_DSCP_CFG_QOS_DSCP_VAL_SET(*(qos->map + i)),
> +			ANA_DSCP_CFG_DP_DSCP_VAL |
> +			ANA_DSCP_CFG_QOS_DSCP_VAL,
> +			lan966x, ANA_DSCP_CFG(i));
> +
> +	/* Set per-dscp trust */
> +	for (int i = 0; i <  ARRAY_SIZE(qos->map); i++)
> +		lan_rmw(ANA_DSCP_CFG_DSCP_TRUST_ENA_SET(qos->enable),
> +			ANA_DSCP_CFG_DSCP_TRUST_ENA,
> +			lan966x, ANA_DSCP_CFG(i));
> +}
> +
>  void lan966x_port_qos_set(struct lan966x_port *port,
>  			  struct lan966x_port_qos *qos)
>  {
>  	lan966x_port_qos_pcp_set(port, &qos->pcp);
> +	lan966x_port_qos_dscp_set(port, &qos->dscp);
>  }
>  
>  void lan966x_port_init(struct lan966x_port *port)
> -- 
> 2.38.0
> 
> 

