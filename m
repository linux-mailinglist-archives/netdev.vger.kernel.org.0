Return-Path: <netdev+bounces-6866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7DE8718771
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:33:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F3092815B8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C653B14AAD;
	Wed, 31 May 2023 16:33:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41A414A82
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:33:39 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2133.outbound.protection.outlook.com [40.107.94.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BD412B;
	Wed, 31 May 2023 09:33:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFyrG+8KaWQb1dD+iNSO7BO2/Tkfhm9u2LbbZQWrqE3AjtUAdZG/vhfgVKeVo/zzVSGTM5jKBnpQWT7V54zudibZtLWXdcDjiyqpjS+Lhd2ptT3TLVFEFAR1a3H88pMWo3fNbEVf0LLpzkif8j/8HSyRqpx9OtpbeAnKLNJCYIlt7DnZQW5QKZ0FEdgjkCPoHtvmjNcpwdlfnt830RZ6mlH1alCnZF0sVmK+15eF/WNBniFQlj8VSHS2PKWneokd8KhhCYytd/6ED+PayUqAYYDr+jMAn29vNKQw7Bqgi1B2EVDCQwYNBHUTVvHkOW0b1P+HbfYvAIChsdMJSfwLxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m7r1KMaVj0PA6k8wxBST9P7WOL/uTFPVYBPIWANDboY=;
 b=EOWA5AbkU4wCc3JUXFe+sDG4n9ejY2BZZnIzglbr3d166QLCoSePVubj66x7Yvo62o8n5pFaDnil8yoCcooL1iYhBIU81M6wk0dQuzgPGgccp06T90Pq5hZNoXrlI4bKadtmYD6k0OH/R8wG66aI+Oc5maAqpjt4yHB8bqzCatCXNSQ6aC7OUGpKdgT5VQPrd5ZLgfUHxXtrdhZOA5uZhExSKQ+y7n/kU95CO6gUhqGxEl1/LzJXCsFaASvO61eV/Tevz8fhHtCJxeqYMiu1z0vRBwrWTBA9zLbkJRsQAMeogE/VJgvb4+p7CdSD3DLU7lag5pU4oE4zTAlKcv0rWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m7r1KMaVj0PA6k8wxBST9P7WOL/uTFPVYBPIWANDboY=;
 b=V5SY3Ta30vBLIMHeVB/HSPvgxD7Y1uAJSMkQ7OBxMswkCn/sUM4HzvnAltE9T7IuqIGowFVKeRHnGPum6OmmMruV+57qNqmfRE4rsVOt8nGwzw37Wwot8zTTrkxLrBKTZjQMdMBI19et2ECO6Uik2Z7Xlp0iFJybHWlOY7EE0s8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4429.namprd13.prod.outlook.com (2603:10b6:5:1b7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 16:33:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:33:32 +0000
Date: Wed, 31 May 2023 18:33:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v4] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <ZHd21sKJ+k/P0c9r@corigine.com>
References: <1685502893-29311-1-git-send-email-shradhagupta@linux.microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685502893-29311-1-git-send-email-shradhagupta@linux.microsoft.com>
X-ClientProxiedBy: AM0PR07CA0021.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4429:EE_
X-MS-Office365-Filtering-Correlation-Id: ac6068b4-3224-4511-7298-08db61f4c604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Q0CfSZ2rwPI4pJkeolk0Aev/JLykLuI7tY+I4Sz/BjU4uJKNumtNI0iloxosvOfjs4w1BkwvE17lxXViX3YDZYduz8IfResoSNaP3mgMvt8YOVJtU5xsv5Hiem9TrShwNwwYL2fhgVPsmNOealJIhvxYvD5v0Vl3TVkUEE64vObs3e+hrzIgujuHjSYU2PUPpjxslsIdRM6EHrcCjlIw3mifpyRzma0qHvdrtHsRlZxydvG8ptShFZFVUxEPMotsk0WbtgjzcovT0qfMuxIRXtqCivDHAx4HLD38Rkndik4k9HjSTbIQsDWpLK77x543tovFux6mPCKlitpcZ/Rd9EFLiD0nwT/vxzR1ald9RuEJs2EUkcABa+sA5EXQdro2qyBskFA7eRwd5h0mZ1BQQV0uaxDvHvlfavSR1MbRBYYZENVcr2JojPQQjXZw/lgB4c6fy0fHcb9YogPbY/wuc3EreA/DGaZfSYgrE5t9Mvc21iJBk8L+V9+CtMGhTFRnAvBKDs3NpdDDGMb0J6Im3CdE1yUB1EICJhByRroh8L7bglqu3BThGMTfosyG/My1vuYitfUCsYpSExYZqZkwVDawEm871S4tl7+WEj3P20w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(136003)(376002)(396003)(366004)(451199021)(66556008)(66476007)(66946007)(4326008)(6486002)(6916009)(38100700002)(316002)(186003)(2616005)(6512007)(6506007)(86362001)(83380400001)(478600001)(54906003)(36756003)(45080400002)(6666004)(8676002)(8936002)(2906002)(44832011)(5660300002)(41300700001)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dsKvJLZg+jj91Wj/QkSKCncHH2qbjVxhG3mkZaTqqlsT1KzZ06DlKCbRComx?=
 =?us-ascii?Q?U/+34kswGoYdpv3AsXioaXt8ORyZwwJqRI82C+FV3pvPRIia9EdcbtrCBM+8?=
 =?us-ascii?Q?lsrDKJWj16abFdFRl9IhNxRtTyMQBs8DyiN9jZn8ucJxl/yD/LHZq62LBGew?=
 =?us-ascii?Q?vpO4fdpS3DhEQS/RKqbJvPTYkbJelHySkQGvxEkSxDtox9pfXPM6LABHIvy+?=
 =?us-ascii?Q?96fioFObZbB8hCXojODUXpNnemen/tO18GHynZl2IEjOx16gtgtb8XtnCVBC?=
 =?us-ascii?Q?Q9JNVUOjxlYIcbRrrUtG20lesT6L1eqiynMA7gxf/Vk9nCl97HxixhC6RiLm?=
 =?us-ascii?Q?yWu6OQJTR/DqMpfRbK/6HfQIdqMtHnwkduPcGA1J8XIC2Ix6bOKDe8pVUy7Y?=
 =?us-ascii?Q?aGm5KPqGwP2TGPAoSjffHrelYea565QGkHtduzvecLgimfloNmKaFunKmKFD?=
 =?us-ascii?Q?es7cD8z9r38V/u9Xg/lBxVjESQq680E1zrmO6zbcpkBr42W6dyCsi50YbZNk?=
 =?us-ascii?Q?xSzIIObxfsL/qU6W1hZtEstb5K9AD+nD8MnvSo1bUuSimSz+4RIr0L9K5aiW?=
 =?us-ascii?Q?W8tAE62YTWBG4IGy/9vZOC3kTuThXPeVJXELVsECFrgJDMF6RmKi5JCfKatq?=
 =?us-ascii?Q?24iRrW103DiKNfiiGnS+ILoESBa515hbZPMTr+Eg3EE7qTNFzviYmzP1zxPJ?=
 =?us-ascii?Q?/CXIL4Gg/3RPSkgXRMC6WrbjKB1eInrs409TibzcRCokRKyvapybOF9NHjhD?=
 =?us-ascii?Q?cHSH++kL+foVcGKeaqXvAu5Cbmy3ddOLnuItcWWKtxr+8h6phFa2NRMaGtxw?=
 =?us-ascii?Q?pCw4Wgb6Zh8FB/YEL5DCgKTPMoQ7BjMb31V2AjL0Ld+gjQRJ3EEnIrhPKteo?=
 =?us-ascii?Q?i7hyHOxXZOiiks0ajZyqRRLJf6pgP63A+WcmMHRguaaZXmqcO/uzbkFui4Lr?=
 =?us-ascii?Q?kn5b9JpQcYx8IWv47jdSYCi8qbTP55QqTjtmGSDfUDWna8IrsOh3vYI6/AbY?=
 =?us-ascii?Q?WpEDJPUuOhXbllzaDRv499pqpMqdcAhADI2EIOMxLhXk/a93fUBE0XfNwP4W?=
 =?us-ascii?Q?5fKeDw/PkM9V/5OjtpCYdkxBAi6KMnsxAPj2jwgsnEr4r1Kxu9KsNgdL8ilK?=
 =?us-ascii?Q?Y1oRxfWWmZjDWNjBws1X4+GdJfIs5pMmwQzxUssnipKax4u1x0+/jpm3jhtB?=
 =?us-ascii?Q?5vi1yXN0E8S34wvFezWXL+H3FCZnq6db02FSHllJzS7bbrKJ7fvrnwftrhVS?=
 =?us-ascii?Q?j9ObU21Xk5+M11Tjs9F2jdngJg/RwlcRV/98pk5qscVNPaXSb31dP+/I2gID?=
 =?us-ascii?Q?RsCNuwrVg/9mdLeC+o7WP97c+qINuK61UHeUtLDnFQoWJKqVwyy6rTB8Fb5D?=
 =?us-ascii?Q?523otYClkiSC4HnePPSLWOlNvQuc3vp83TMTm41zCVrYVjKWob5S+kRYed/x?=
 =?us-ascii?Q?Tz0lURGZ9ccGsPbVK+5yxrwYqhd2i11dO/us33LZq8X5Q2PZd/RST4CFUSmZ?=
 =?us-ascii?Q?6I06vMRn9im7SHUAW9ByaAa38pB628w0HwWh55nuF2vSsGLtcQxN99ad1P8w?=
 =?us-ascii?Q?N6mG9/MPSsjRFnGThrsXzqFRbQ4qd2UYffSTLp+ezYcZJshToyJ63vDhnERG?=
 =?us-ascii?Q?jNIzLSFWZAQ5gDPbtfGsGzhCCwhIK1QAutYTYvOMmao92Yo0MRRKYvYIDR6V?=
 =?us-ascii?Q?OtHliQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac6068b4-3224-4511-7298-08db61f4c604
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 16:33:32.6585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KWA3XT9lK2W8w8Mfy9PMxv+4qGsIoNr9ralbS86nhO8wWxkXiTJl+v8j5BC11EE21Tvc7r5BZXw7zsMbbUzbWDhd4+ZRW0beyVbkEnXJFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4429
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 08:14:53PM -0700, Shradha Gupta wrote:
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
> 
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Tested-on: Ubuntu22 (azure VM, SKU size: Standard_F72s_v2)
> Testcases:
> 1. ethtool -x eth0 output
> 2. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-Synthetic

...

> @@ -1596,11 +1609,17 @@ void rndis_filter_device_remove(struct hv_device *dev,
>  				struct netvsc_device *net_dev)
>  {
>  	struct rndis_device *rndis_dev = net_dev->extension;
> +	struct net_device *net = hv_get_drvdata(dev);
> +	struct net_device_context *ndc = netdev_priv(net);

nit: I know this file doesn't follow the scheme very closely,
     but I'd preferred if it moved towards it.

     Please use reverse xmas tree - longest line to shortest -
     for local variable declarations in networking code.

	struct rndis_device *rndis_dev = net_dev->extension;
	struct net_device *net = hv_get_drvdata(dev);
	struct net_device_context *ndc;

	ndc = netdev_priv(net);

>  
>  	/* Halt and release the rndis device */
>  	rndis_filter_halt_device(net_dev, rndis_dev);
>  
>  	netvsc_device_remove(dev);
> +
> +	ndc->rx_table_sz = 0;
> +	kfree(ndc->rx_table);
> +	ndc->rx_table = NULL;
>  }

-- 
pw-bot: cr


