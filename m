Return-Path: <netdev+bounces-9213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F131727F5F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3580E2813AD
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8B9125B5;
	Thu,  8 Jun 2023 11:48:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0B610960
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:48:58 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3830BE46
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 04:48:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFFEfnuOw1zSNdo1ySQxGCZxndOK1qXboczbGIYTWpRL6t3PZhVYHcLwekB67qy2WDU7FcYxG8zxW+ywoHeD/hZlJIcKs95B+stNPhCo5YOcHM+ACrnuYz/mOON0+wuqtrVZjt6SSG9otmW1ZtUqzpjOt+3xzjqPrO+9duhczHzO8VnB/NJlBT3KZkvzuF+vgiy37NNtWbP5C1MDz44LOMAM7wFaot48BRnQHoAMHp24ib11+UMTFyDCMuTZGKHsdfkfGDsrWUc6sLb0ZHy1kNkexXlgOrLb+2FTB9Df6bt1y2nFGWMThqnxaguWSorOYeJTYu2AH4mJ4X53hxnJ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+LyLHaUZc72dKE4Plzujfp+JFUCsfIyixtR7EpKrl0=;
 b=IujX1gHaGVDEYIPBGawg/Ka9V58VFFEK7pKwhqu1UyEbY5XXs6/lTBno1Gi3c5H7nsqWaHp8GpE9y4AKUut64mXe158iSIRGtsJjJz9U98EMNrWFZ8W9GhZ1cp3tSRJMyeosxXDPEV6vjKgNbuHEqGlZLl2Fxu+p/fdMSwDG1Tf3ol4qQHiAU/8jCSRkdJo24AVpkZEBUdQwDwJJGCRPFhddxSfwAs0yNeh+kDITmyNfxFfGpeNtX+aBGV1BVxjf0z5+vU97hMvA2XJk9d5qm22//tXPWObQUfQIx8KZU21BsTz2k0h3kXGgmq4GrhnEVPT0bbXxVfQ7vUDQOS5WUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+LyLHaUZc72dKE4Plzujfp+JFUCsfIyixtR7EpKrl0=;
 b=ZiwLMWD7yGPhGLDMmjde/tLoY6KdziHl2qrozhUQhWuiU2f4bMzg0+0brHhyV9nOS19u+G8Q5w0EmMoovmebx1NfMW0CdiAyytnRPW1Okns1YMdWkOlBwIQur8kSn5Ol4hKFcAckWXYvvwFAhuSpuv8ami54OaU1dUzW4Tgnupc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5179.namprd13.prod.outlook.com (2603:10b6:208:342::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Thu, 8 Jun
 2023 11:48:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 11:48:54 +0000
Date: Thu, 8 Jun 2023 13:48:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 10/11] tools: ynl: generate code for the devlink
 family
Message-ID: <ZIHAIdzVJVMB7jDN@corigine.com>
References: <20230607202403.1089925-1-kuba@kernel.org>
 <20230607202403.1089925-11-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607202403.1089925-11-kuba@kernel.org>
X-ClientProxiedBy: AM0PR03CA0022.eurprd03.prod.outlook.com
 (2603:10a6:208:14::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5179:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c6ca0dd-58ce-48f1-d04a-08db681655b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RA6/Y+B8orwvhmCaCsU+Ae+fsylQdl7/UchrNzSwT7v4XgPDVTEVp1cV2y38lim4WmIpxr9S5JScs6DwensgmLsbIMADm70/5XtxapzR0lQl5M4TAJDRfc0wh9tmcm+2z4wEpie4JcWK8sQqM9pE006ueoxidYg3TwUjSKIhxJyeTt87WlAu+pDwC5LAYRJoy+lwZWwxrCvB9GP83k5v3dvDeLVqdqvpHQDF3OcKuNXRnFTwn7AIh/du+j9wmQHN0qOdJqKs4D86v7rnTMnaT0KFr0cIrb6QwahDSiJ6187sbgyC6tg5Fbvyy1gNLlICJYBY9yJUG7iBzlA4KtA/wAPaBt3h9Lze7vjuQhOGIjgPivMo6q8yzDT0a9PPb7tDhFk/4Qa6+MKR/OfgW0c/TwLqTdrC3hCA6HMyop+eu0qJasYLJcpO9xgbRhFczec7LbvTFFVyRy09r0HiFoS+aSWQbbilu9Pu5MWn6qKOR8db+bJQTkb2TcXmR7jxxhwVBqbxHlY6ukN/29bNNOP3ufnBRspErKQKz55SZeB1tKcF4W0ugd0sJzoJZNLEYcnzewieVP+cw36PqtS5OKoynMi6dmoHUBsIwFCv+QuzPJw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39840400004)(376002)(346002)(396003)(451199021)(316002)(6486002)(41300700001)(2616005)(83380400001)(86362001)(6506007)(186003)(44832011)(2906002)(6512007)(4744005)(38100700002)(8936002)(5660300002)(36756003)(8676002)(66946007)(478600001)(6666004)(66556008)(4326008)(6916009)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9STHp9aLsUmPZctnkAgqTojY8CtNqdCgt7eKhLfrS0chQ0ZJyAcqNvH+iq9S?=
 =?us-ascii?Q?lSXUyhp3aG+pEV4PhOjFnGHNJk2NFmQ2qunmhMYjhBAM5uPxlvfBslJm/9FP?=
 =?us-ascii?Q?/GTcRTSwjVbtOWpFUZj1Wx2F6MrIM9p1JW7slum+6Y9xjDHc8RpOsUdH0Vw9?=
 =?us-ascii?Q?rrdaZPieIFMZRf6LmmOMf6+tOFg4wSbL02/6Z3I6q1lZrmNix7fmldFhQq3S?=
 =?us-ascii?Q?95wmBGDRDChSHU1FxmPZknH3wTFZ6IlbV4FVouQSr1JL4oUPFcTEpQBFUjXK?=
 =?us-ascii?Q?NphvvBLXW5y3ALyX4oSiySoCOeC/HmqEVhdvBqTf0UggpeRLf16j3mjZAd1Q?=
 =?us-ascii?Q?gdkUDytzGogreGljOCN4QgME9vwPYvIMvCz1gSl0fJqcy3SYBIUSnIf6uAFX?=
 =?us-ascii?Q?lWWRDGj5m0ath0UR4rxAskf6fkA6SLzwdu2rb2Ow8MLxnBi/uJVDDJSlOmTK?=
 =?us-ascii?Q?Gz4eBYZu6D7h1uFJN/YAOdRCJbFFPRR9wVZyh8K7JOCOGIjt6zEiOumDOMkn?=
 =?us-ascii?Q?ZqkWyYJXVSr60LD7jHRlAQiQex5Yfz+yY4c0YraTH1YEd/8bcAnXdx8C4c2y?=
 =?us-ascii?Q?MhgD4HHl1+5gqQvURv9r/pTUAZRxD064ZeXxbm0JVePYK16Cg4cONADGxeSF?=
 =?us-ascii?Q?RDNwPoxQ0iHY0mKGy7IlgUXn4AuAYAix/KiT+s+DPToN5B/R36qUZ2krO7Sj?=
 =?us-ascii?Q?/+GM/JftNjy+7RZRBQ/9zHa8PjqcQJbVM+oevH73h3A7OpIQhJ0o3toaKSVK?=
 =?us-ascii?Q?bGrrepvBzB0Nwqidn1RcoKQWgLK7F2EIPVu0El3PjVx/dV1dwZxRSVWqDTXU?=
 =?us-ascii?Q?ak7XMiuSBJSN7FgVEuAV2loT6N9xTSblJ04XydY3+m4Kk+RI+zxcp73WO8gl?=
 =?us-ascii?Q?cxHMTfTq5eCysahq5/VOtS8anSbg10PmbhJT1c3VY7SRwtuPe1/XNJbgpAjF?=
 =?us-ascii?Q?NUS3kiqlBCayBHW7/BzYS9EZmbv37UGlxoU6QCOdzs9QWTOxZ+xJSirSyvm8?=
 =?us-ascii?Q?bBdfZBT+2KlDyHBvS3TR1bZ66CXC9+P1nXE1oBqOO1drT1tsZC1SXJG/NXvE?=
 =?us-ascii?Q?seSynAl+p24BW/khFexD9xg+cMJj0hGdSfSlWrwukNNPcfMHWn/YhRtXXKqw?=
 =?us-ascii?Q?qazgWa9cBfvFn5uLmpd6oPhWlvjJ0cNZlqVb28eKg187yhSgnTMI6X37JSEV?=
 =?us-ascii?Q?aRKZ4vwTeQkJX1gDhsx+lL1/rVCIYc9KCvkAsQFefN1GbudLPbUlKBndc02x?=
 =?us-ascii?Q?Upub1MX+ohIBVjiXlotjd99o0pk8Yad5e0aiK21GVaysvx+ZuobD1An2QHOp?=
 =?us-ascii?Q?wwhGYhu5vdzyHo1eTC6J4JQ1j1+Se/WmJMTd0HnznbhAIeRbG7+2Rm0VwAGB?=
 =?us-ascii?Q?O3yjEekcM2XU092kD+XFvA9r0GWKBo/bQDoIZKREK2hTLwcXsuh8oYiJ3KbV?=
 =?us-ascii?Q?ovvnjPOeOjHVoWV2HlSwGb9BVD6Z19BBQnxkTRviU+cboulkf2YdI1GE5LGS?=
 =?us-ascii?Q?0ogvak0US9mn2SFrqI8LNgW1Oh5PaQu7x6u3LyQ1TLt8fPzE+ZCVf0/WrxAr?=
 =?us-ascii?Q?wk2OuQnoaoVUGf0mTW+6Bs7Wa3hYdy6AOsm/ZxkIo64yquZvSC1UljuZljCA?=
 =?us-ascii?Q?aFusBrHSlQNW69WLQh4JAKraroYhZE+Xe31gIXaO97T/63uC+nPUl+9+7EIR?=
 =?us-ascii?Q?SN8iZg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c6ca0dd-58ce-48f1-d04a-08db681655b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 11:48:54.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeBOC1o/VLcHiNpBaYgiJ1McBLqtENyZFV/QsV4QFe+mlgLUV/Yn1mbs9udlmPpKdvgOQckM/t7hPDWRoTGt7ju7se6FuLrv0+Jfu1/ZzsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5179
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 01:24:02PM -0700, Jakub Kicinski wrote:
> Admittedly the devlink.yaml spec is fairly limitted,

nit: limitted -> limited

> it only covers basic device get and info-get ops.
> That's sufficient to be useful (monitoring FW versions
> in the fleet). Plus it gives us a chance to exercise
> deep nesting and directional messaging in YNL.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

...

