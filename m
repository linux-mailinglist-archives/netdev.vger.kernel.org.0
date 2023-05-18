Return-Path: <netdev+bounces-3724-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2107E70872C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F40BD1C210BB
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAA127709;
	Thu, 18 May 2023 17:47:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C7D182B8;
	Thu, 18 May 2023 17:47:18 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2138.outbound.protection.outlook.com [40.107.244.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3673E10C1;
	Thu, 18 May 2023 10:47:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWq3DTmMixnWXR7DXGhv+gU/ndRrbzSBqMHuoveQRe2cvWsFu89cizmOJFI+SvmhcSXddXgCoNy1TkR5rP9IVzzWEcfLoHrCs4OklIm2P9bOQ8T4QsyvPAkamqkqWu37ijrKg903fSxO8BoYDPH81UcGiAtQoXiCe2s6aXE0h087iOyw5+OI2d3H7e2fTS0sV4Q5RPRVSzUgEfVFqeMPxUKgVNEU/ZeVpEAsPfbhwZVSMQjGR1HDR1gxIuF4gVvRwCqTgOTcRo06/6ysMm6PIV0kCdiRFdtxPRr2ldwdXCoVF20hBhSmk4aUAidAleqcfGXb+zR4aB0iREfhsCGpRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ionh9n9SdqJHPhwGCN6eSqa6e/QqYYGrgK+/5CABsr0=;
 b=EXuwTHKLf/zjrpttTdDPq5nPTqmorJyFCensqF0VdM1jUYrZHrkQXXNJNqk+UBqQqRIj3nX8rVBY/m9lT4KhYizgWsyYbjVHfZbf0xfrkpv/pqfqEaH4C+cIEFApCXs2VK2b2hiV14wyW66Lm/BCVnTdH3oVLc7kvNPv1LtcgXenfDIN25Ro8n64yDfs1j22LHPjWn2bOffRl91vMoreHFJPKqvhFJ8ska5erS5asrfNA2sCV7aWDXT1O++1gxxpf+b5Uvk6DIFMp/aor896MVizV8DSTBck50rIwderkUrffak9Wu6HawCQHIFDOzA5JX0yCPV5uoAnfmKAW6syrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ionh9n9SdqJHPhwGCN6eSqa6e/QqYYGrgK+/5CABsr0=;
 b=qqX5C2FzjnQfgA1GL/B19pUNqRvLY4WalERCVZX3icuv1TwfbVgSN/T1i3Po2mwRMwSns+FdzT47ciU7/S3TzWRsY4GboVoZC4tC5Q49bTc0y0OnMXkmGaEaT4ZA3vd75yP9uKGFMvYRSnczFoXMgldLQLUCNTlbYcn19BqNCeA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3811.namprd13.prod.outlook.com (2603:10b6:a03:22e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 17:47:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 17:47:13 +0000
Date: Thu, 18 May 2023 19:47:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: wei.fang@nxp.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
	hawk@kernel.org, john.fastabend@gmail.com, shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-imx@nxp.com, Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: fec: turn on XDP features
Message-ID: <ZGZkmvX0OLI+4fqY@corigine.com>
References: <20230518143236.1638914-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518143236.1638914-1-wei.fang@nxp.com>
X-ClientProxiedBy: AM0PR05CA0082.eurprd05.prod.outlook.com
 (2603:10a6:208:136::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3811:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a0ceb0e-d66b-4a0d-fc58-08db57c7e9ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hJf9knSS3DAJ0vXa7HSKA++OSm4LWENdNCAZSMBbs8b79NKBxP0jUHUi1mR+lF726yttA3a2hOmIwf97AMUlJ1V/1keGKJCS5khQPSJdQpQs9mFGwznYCgdqcq28UWjmbManOOUiKyG3WbeSh6TKP5tlqsX+64WqASaE5TgHVqHnMlLHqQ/zfU12tV/X/XbvIWbqxD7cCzoAT1QA36njm27enYhosNIbZUCroIexAmt5JajoJibVysUYGkcsNCT6pIyJ6unR/oOMiyzY8+MEZzgfDblO9j/gYAyPeTfxyW46Qi5Cuyoc0DHowoXmDvCp8jJ+Se1x/CMp71Bohc9GM46/rc9QFxkG1TMByPkyx1DcpnXxIMTu3b+HZcFT5dA7XnE+DRBPbCvDMxyHslEgyxPqaULQEtQ/4ECaIcfCAcu8DaZVLI5wzJHfKdAl1xKCYQM+DWYyOhIjQl+BR0qpCb9WnXleMK4Fr/ppEiedPhnoT8U6aFvZpWpJcg4gsQoFK5xyUzAc+go7kcWIRAqtIHgjIwz2/5Mk+sUW76LnLuP0VuW66Hlnm4H7UDECuHbuKDVEfzEf/dsWvW5JbaZEzV1GpS9RvuKjviGyj6PEREw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(396003)(346002)(39830400003)(451199021)(44832011)(186003)(2616005)(478600001)(6666004)(6486002)(6512007)(6506007)(8936002)(8676002)(5660300002)(36756003)(7416002)(38100700002)(6916009)(41300700001)(66556008)(66946007)(66476007)(2906002)(4326008)(316002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?933zFM+SRVMFLOQrEKrVKc6V9U6JtTGNpORBlP0rMeoyejCbPKQ7FvHU4YE4?=
 =?us-ascii?Q?Bb7RpANcjNRIDvY9guawyvc4XkhLowFXxEU5LYd/FhDBIig8dfDDQmDBW3Sw?=
 =?us-ascii?Q?N2GhpJW/4lSQwy1fm9LxzOTz9CjNmMM+j/BSgKB0jloR1DdCBX9iL+5e2rFG?=
 =?us-ascii?Q?Lj5mp96I8ijhL6ZvGLM/9CNaDSHWVbSkgzYrHrkFgR9D2s9gBz4y1Cjen6W9?=
 =?us-ascii?Q?PlJ4AGxOhWsrFCyPnd7WL2awNvfIVjXJDSNwXQl4+haQWQJGctmjB3eFiTbv?=
 =?us-ascii?Q?G53FnOIsqQ7SFZeJcOT6pyXu8Vv2SaYhONCezrfvMxANjePQmGD30PC+N9NG?=
 =?us-ascii?Q?evwtj+b2CdAI0rYgkscRwQI7LOY2OCLQFyj3712aCE7ZpiOo1E4pxUZlRop7?=
 =?us-ascii?Q?d9Duw3jYHn2GiIX7dlBsFavfq+BEIiKouIbmdNjKYYIG0Ir99/unTr5Am8Pe?=
 =?us-ascii?Q?fT+/MbRH0Y7t5etZIGvloJnpAHs5n5U1uZ0bRRIBXhhnYbYvPQDJmTlweF0E?=
 =?us-ascii?Q?xFU1C2HKbyxu9bNvbCXj4qRhTB9pUnm2NyTPPl6Gr/WMv6+mj8ucklOU5OwZ?=
 =?us-ascii?Q?EgC4LBVO0WDNpQCowPZlz+MdQkepNKTHjsrdUAHUr5hDazWYWiyLmy83c8nS?=
 =?us-ascii?Q?pCdP41BzQ7yv5twNi/lUZ0JWot4mu4aEjdxeZ2aQ1ROIPmz0BCnA7D+oAXV5?=
 =?us-ascii?Q?dj1APbDJKlNDuqHYss+rWxqqoL+s4TIFoC6guReoO+CfbY3c4dh+GPlD24q+?=
 =?us-ascii?Q?b+LyZ+IIkVCvJfy2e51aXFoRtx+jhuI1YKtbG1zesHMuFLTHXEsmwfqbJ4lX?=
 =?us-ascii?Q?rqcrxFfD//ZkC/l5NK/TLGPEgXhNNyCErXB3HDRWUyIZ4n8uPayeqoHBWNfQ?=
 =?us-ascii?Q?2jI2xFPLzgqrjTLTmTnRqvBW2JFYAM1zI9cdKEa40XSivtxblkaRxirfvm4s?=
 =?us-ascii?Q?GCDn3cl7jaJvxsIdsbwZtaBwqohGsLguoLv0da2R3lQKAZEaTRATtiRCFWqd?=
 =?us-ascii?Q?fLIA5+DA8GTLvtjfKIQ3AGKOghW087ZYBd/8zo+YU49OVKA/k/TcVMVlaVyR?=
 =?us-ascii?Q?nG17siXbrlCQoKUQzsUpnKXIxXJR67LUhFqxFoai9u5Ox93eq4aJLxm1rsPO?=
 =?us-ascii?Q?RY28WY0A8Y0pW1HBadBmOqzfQzriiNI4MNQI2c1tP0YW3VqU9oHmBNKW+qBh?=
 =?us-ascii?Q?CAzU6tOU6SHA0jpWw7J4/kbesvBCBbJwzgNehIJZV77d8frWr2mWbrOnEg0m?=
 =?us-ascii?Q?mbLjJT9oKS/gM5mcZNE8vV1RXurgVBal/t6ikxu30pZZXg0qu0QCRlKKyhfi?=
 =?us-ascii?Q?V1j8vInMogByUawrb+idt7jipBXfr0p7IwVcqoEuJom+PHEJbL9obeWdDQCt?=
 =?us-ascii?Q?fobrzhVlURas+oMz0roPRv6Di6QQH1KuzqxZQOC20ABd1tpNpvzlZtw9lZG6?=
 =?us-ascii?Q?IZK47/qpZOWVAM175SqDvo4hokxE+CH81lx+h8Rbq9U8//StxVVOu0PHx2WF?=
 =?us-ascii?Q?ZA988TjWBSbWrVbQ5Ry4F+5Qu0rgMNcOjqDTQtjy9LM3OorFMmqEeCOcyxUF?=
 =?us-ascii?Q?ap7m6/IzHBYespvhmhxZF58sVWo/0FB2arsZ+qnD0csHs1MNLLj1a7byk8X1?=
 =?us-ascii?Q?/v18++HSccv7TGhvkWDl9mlP7B9o0uGsUx6ulw4Mn2H92v+XhsCJeyE1veQ4?=
 =?us-ascii?Q?8TdlBg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0ceb0e-d66b-4a0d-fc58-08db57c7e9ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 17:47:13.7880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WA762I8edhcwx/mXohgpiSAjdftgc/MIu9YOMoxG7uFPxddMRwOCG5D+VtPLLn9Mw5WadB/I4+1SjkstYRL22DneGr2QY+5vrdewGvGEEPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3811
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+Lorenzo

On Thu, May 18, 2023 at 10:32:36PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The XDP features are supported since the commit 66c0e13ad236
> ("drivers: net: turn on XDP features"). Currently, the fec
> driver supports NETDEV_XDP_ACT_BASIC, NETDEV_XDP_ACT_REDIRECT
> and NETDEV_XDP_ACT_NDO_XMIT. So turn on these XDP features
> for fec driver.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index cd215ab20ff9..577affda6efa 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -4030,6 +4030,8 @@ static int fec_enet_init(struct net_device *ndev)
>  	}
>  
>  	ndev->hw_features = ndev->features;
> +	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> +			     NETDEV_XDP_ACT_NDO_XMIT;
>  
>  	fec_restart(ndev);
>  
> -- 
> 2.25.1
> 
> 

