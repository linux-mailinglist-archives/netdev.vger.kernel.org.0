Return-Path: <netdev+bounces-1353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB9C66FD90C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E206281163
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5163512B71;
	Wed, 10 May 2023 08:16:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB352F37
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:16:41 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::70a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C825448D;
	Wed, 10 May 2023 01:16:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZVPOTRmyIJwzhaSmLmiHg+/0kNmp+hThWZkzriZ48ImKqZoNukBiqsVOCqm8B86gqDoHpw6nrXTehCODNGzYpzXIBxzttST0RxC+y3fJ1OXbsHw0vZB7irjYC3/Tk5Ga3axpFyoer8bQTvePbCMSLj8jEo4zeZV/Ke3dli3pUaAR9EkZfgvzFJ6sOsgv52kd+NKMaLz7IZSnLit0t3VBf1GXMH+d3yQirOKvExIk3EVcyFwNWQNYRRb4DF4lunVK0s9nJjkaPyKpr6vIk4N9ylBqs7E53Zz1f9C4ffiZUFLkSJPGMNt1YqgMCmKpN+jnjObY4fDZ5mNxAB35GhleQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIIHqsVlfQNbdl7fuWWFHc1kHH7SEpf3b3rMhHXM9X4=;
 b=aGNjAOrHWMTN5I0uR2ZTa56FnXTYUv5g4bM4e9K4oQXTLHG0ZLiulgs/CfPrrJCJ6cnv7vzzjObtqShc47FC7UCxQGRb5g1m03XdA5yzZLnndyrOTMhGveAdrpCfVD0elAGcu464Xk5V5uAnPCP+5c+4bZto+h3U0hMv0L7DR1b4to55SK8MvFz8T7T92JxvzXwhaGRQcqNrgk8++SqxbrMpa9bjO7u0cRaZYq+Ht6aF46RKX53ycvZcyVJ2Nd/YWCS1iWzkSs0BhOX48F9FONVFlqBWNzd99iJb2yB9ZNk97qIOcyONI17jSm7LiQIH5Ghp+oa9Q4jsAZKGF/8lLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIIHqsVlfQNbdl7fuWWFHc1kHH7SEpf3b3rMhHXM9X4=;
 b=cIMglCJKxkdPA1ryzjRSt1cOLJJES6IwJjX2BAc3SjUCrMOK/u+MgI3/STN0xzn6ee8T74NHaDR2gejzH54HHrF5JSHmgyL0dYfedSFvq/LdPg8LcCydfFcCkjnegz0BSmZDeML0fvDXPpZRuSAwofXuFJzduLO2wVgsFp4c2Ps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3690.namprd13.prod.outlook.com (2603:10b6:5:24e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 08:16:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 08:16:29 +0000
Date: Wed, 10 May 2023 10:16:23 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/2] net: remove __skb_frag_set_page()
Message-ID: <ZFtS1zfi+zrI0KJu@corigine.com>
References: <20230509114634.21079-1-linyunsheng@huawei.com>
 <2345b39d-366d-cd37-1026-2663679b4bed@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2345b39d-366d-cd37-1026-2663679b4bed@intel.com>
X-ClientProxiedBy: AM8P189CA0002.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3690:EE_
X-MS-Office365-Filtering-Correlation-Id: fc394d39-fe3e-4ef5-aadd-08db512edb50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xwrkkjLScgFA7q0cW8lyinVQ/7asSXKeYgk4VCuaONx/DLG4VkrkxTPQ9PT1Jluocw4QpV5eWxRimPQOSEnGDw/QU9gDdrqG5Hq1C8utJzmJ6nRef9gnP0JH+b4k5evV7+dqCZpI2mgs4/bNQGgTMCI6DZ4vJsRBDAZKWsofW0ieJCkKuXaDiE+9Auq3Fx5Y0i1xarZEMP3ZT5LUaz7FCeQ8UKm6skKE5HPkBs22fFNSOvhHFwkimcViFUc1IAQrNbxr21MjbaK24d2QDcc6Fcfp4sHzIFBAjyCi6lxP31YcKbksUYJIDfpEkQWwaZDO5amsrda2/FnE1IRYqNKYG17iTAnGpbse1Q2/9M91wF3yc6/ZuUr40C/ilCUqyqOD9p0m1zj0chz1aT080Xqo8coRyI+1QF/E8LuOzLjtSyCPxXwbVI/Fe52kIoah5BTeUq3l/Ub2MFoeKwVAO+sTCn6OVeYrxIMA4OFEZRyk/Wdq7gK5+ykCGmnILk6xuqcCSDCs1dU3nB7u9Ydu0DYZp6REYRG32MlM7WODDcmBJtULJLGJfamcUQsfypLmjdS/aHPHexK5jir8BEpo1tsu6k4lm8X4MxES8SJ+arUdb8U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(366004)(39840400004)(396003)(451199021)(36756003)(478600001)(6486002)(2616005)(41300700001)(38100700002)(6512007)(6506007)(53546011)(66476007)(66946007)(86362001)(66556008)(4326008)(6666004)(5660300002)(44832011)(316002)(6916009)(8936002)(8676002)(186003)(2906002)(4744005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MfSqrxfudzIGmGzgI707EBNjuEh+5s40EsVFvFysvjJAg5m1vx2n0ZBiX8ho?=
 =?us-ascii?Q?NsMDfS3ooa2lshcphg5eHcy0jM16+mnOZvsYdlswcf8hI25wNKUtr9iJqM3w?=
 =?us-ascii?Q?XY3szAByRPN+QZ2ZVgb5foUPSRy5zmQSP99YxTdA8hIUFE4c8qOui96OCVXn?=
 =?us-ascii?Q?9gAW8xTgG5XseUx6qPx3sV+IAbkXqntlIp6pqNddi+ZhrovBad7rmofopDqP?=
 =?us-ascii?Q?0a7unAztGXgsAHK+7DeYqpRgCW4EPRaSyRgzd67orrms5tfzNIhkjNBjKrxo?=
 =?us-ascii?Q?x7G2x5+XGmWhRksgbOTgtb34FoXjszqwy3E+hnE0F0OneYqHOCtKsYtj9twQ?=
 =?us-ascii?Q?UPdEibOLDCpKsWUyN5weLTNNCFvvzHkG8Pb2iCGB4ogkYGQqXLYfbd3JeOZc?=
 =?us-ascii?Q?NrMYbpa/FvD+sqXmTZdQpO5DgC6l1j/i1ub2jQ6QVLPsXsIXz+n7pn5u7RCc?=
 =?us-ascii?Q?dVHlaFrGvc4wsosS2Bw/wvlM7jF59GWRoy9LxA36XuVozdv2qJBGBq+7flpt?=
 =?us-ascii?Q?dvndIZipRIWCe1FRGEPnYaUWtm1D2zP5Yj/7sBxSFx24D35zSuYPDKnwAsxp?=
 =?us-ascii?Q?HasSu4zhgOsk8mJHAn+MAy104mE0b77T5SLxtAwz+t9mprbZwqSV7VllzrYj?=
 =?us-ascii?Q?HIt843QpWi/fDBSt0dJwNSvt2HbSMt/FwRw2oop4YsCesjp7gFmXqf8voGjB?=
 =?us-ascii?Q?FQKsR3Gw81xeQ4uvlG9S2ssM+Z8WqonYTNrmGpUQwDaNabujvyy4YQDirgpr?=
 =?us-ascii?Q?xrWfKBgT2IVViAns4bms0a78oSBb97IMekZxY0AJZoOqNMpihsseROTbols5?=
 =?us-ascii?Q?HgpcU6XZZKDBO3flle/P2Zm2sBucpuqP8PqWukEgW/lliGoKY4Qm+6WKVk0l?=
 =?us-ascii?Q?ES58ImeEqY+wqEqS0vz+YKKREuDA39CW9iBZgbNPPr2owr2YvFsxJW++mo7H?=
 =?us-ascii?Q?Vd3QpPSsrPwIfnPc++kZ51d9s2g6anVVyqWaBSckOop8TjK5+mWvAZE8NB0w?=
 =?us-ascii?Q?npSLtj8RM8NwFr76xXSEzegaPRrtaPKegk6hs1t403DBiYe5PyuVyyz0aw9/?=
 =?us-ascii?Q?l2emVBTcM5hbHdu8SxQI56M5B0HecwHYMLVs0GH6p6Lye0uDSmne3VbILQGd?=
 =?us-ascii?Q?nVLC8tQE0he3whE+Fc8A1TafIbAJOLii9k41pI0EMxL7cuoZlKwgwN7AM9Xs?=
 =?us-ascii?Q?RRFHGJu01+uCU641okfGSPGh87KSc1TtH4SXiGi+uFRY5bIJKVPSdxUHfHu5?=
 =?us-ascii?Q?9DCtW4nnXt546OwtwBkmii5g14ZARj38xsnGRaQCfTmGG0q4xCSK7DZ1M9f1?=
 =?us-ascii?Q?6tRMJdBM2Lse+Jdx7gUoiizq5qUics/k8S/byOw0ft/inyzsLw9T2adzD+qK?=
 =?us-ascii?Q?KlqTblz9oBPq+FLeCzBlTJ7Ds7HmlijnJnjPgceFtZaKutRqbw0XFwahIEWx?=
 =?us-ascii?Q?zsiFMu2RpdoDevVF6rA/OUO6QprTbs0Ow/JbSUyxKYeCODgzYCHW34Tbg03s?=
 =?us-ascii?Q?h0mGAXRhObAZcUpdO9iBE3fp42oYUCUjXmcpLBc4DUL+HR3fTR6LZA2IfAdB?=
 =?us-ascii?Q?7SEpGc9tcjsYwfECx1gtwWzRV4i1T9r1Nu+llD7ZSyiSRkeB6Y3QXQoYN/oH?=
 =?us-ascii?Q?aqiwmeULXZcbLlunxpILLlusiVPG0IhotcsVV/QcCfscVK19hC1IGvdHztrY?=
 =?us-ascii?Q?Mw3Gag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc394d39-fe3e-4ef5-aadd-08db512edb50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:16:29.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMj3gigSWn7Egd0NtYUOdOTxPi8J/D7q7ZQ9I+sJdtxl7KarBD7N0yPBVyj2hKPtsuHeoAIuZ7LcNZdTD55KrQcVtepktg+NVX7D/S0409k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3690
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 04:49:46PM -0700, Jesse Brandeburg wrote:
> On 5/9/2023 4:46 AM, Yunsheng Lin wrote:
> > The remaining users calling __skb_frag_set_page() with
> > page being NULL seems to be doing defensive programming,
> > as shinfo->nr_frags is already decremented, so remove
> > them.
> > 
> > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > ---
> > RFC: remove a local variable as pointed out by Simon.
> 
> Makes sense.
> 
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> CC: Simon

Thanks Yunsheng and Jessee,

this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


