Return-Path: <netdev+bounces-2911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A02227047F4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B82FB281612
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141172C720;
	Tue, 16 May 2023 08:36:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC61C1C26
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:36:55 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2100.outbound.protection.outlook.com [40.107.212.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C416B1BF6;
	Tue, 16 May 2023 01:36:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFmV+LNpTJ02ydPFjyKWDLhepXOMr7QdxqcCtL29rnkZXA9HBwL1pvyMFOKWEzzoZ0hb3Aq4gtPr2B1o7NRf2FcAqcms/TTh5tywHaWH4f9plTZuR2rXlNPBKphQvSgghsbixd9/f7Jdoh32yvSL8QJa6PTmt98kxiy8A8unkhH3vXSVd0HK5Ckb2xICPnzmZCIAZteA1TS83bbUCSw0duPrnjutrDCu0zSCk343nIVHXg6qiALlylZdsKVk+36NrQeEQ+NhDz7IDZmM4kUemLn7MXGVLH4zMolykrwliZtl+kySifC4a5ElS67ObD/wYD9RaqAu67AWwj4QIz2T9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FI62PbpoepcSPSyY0cLOS63vSqX0Od5bgpwdcG7rdu8=;
 b=g/pp2UynZFJ2NxNTfbLhhSrb0AxAo+zgKS3Vy/dqylq/7RWJMzuYvPtf+mj9SV0RcH7Cg9OIwrLk9fe3g14AK74ELY9rDpMA7/kWsTCssu6zz8xgF3n8oQVEko/YYUYbk5fFC8Tp/pLnG0OtkK+eUk47gmFB4dysv59LVgTORRcdjIzEGPVFxny1Q5QrCQunHg+ee7ZSMoKd75JwDutcJrv2q48vOahn4cBKb6K8txZ/pPMPBG272cB+11hqTkFaWbwPoiFLLCd/I9/LGs9/DqVA/uxQhyke+Y4ev3y2ld210t+D7+X3UVXUXUkAc3VyH7VoaB8hoMvaQ6c8MyIswg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FI62PbpoepcSPSyY0cLOS63vSqX0Od5bgpwdcG7rdu8=;
 b=O0bL6/Nx+76d2P3Qtn+bdhr4uPnIm0nr3z81lNmVRAeUx/gySPVLMHVcsx/fYoc1ai418SwahCK/5o/wztQMcTgxnpC+B8/U8+MKnaxUb4XKmY/ooOLERDYY5CKv7kirmCT3gxAoig+cXv1vRkCQFQ1R/SuZDfCzR3YFaWa7+ns=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3669.namprd13.prod.outlook.com (2603:10b6:610:a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 08:36:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:36:51 +0000
Date: Tue, 16 May 2023 10:36:46 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: wil6210: fw: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <ZGNAnu2dRZV6a+40@corigine.com>
References: <ZGKHByxujJoygK+l@work>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKHByxujJoygK+l@work>
X-ClientProxiedBy: AM0PR10CA0120.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3669:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ea294a8-4e84-488a-ac99-08db55e8b26b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DlmHYScSsV27ShOEj9bRN5hkRU8HlGl5gkNExtratePKhkQnKGpU8T8TbDcfMUJqV80g5ZOYouWCdSD7F70B2on81/afXZNDFHmsucZ9bSxZqp0gH9CUdqdni8E6WGPS1Qoc+UB/R4rmDQt4l1f+hoZOYW+a/8gnaMpwFjyxKYhEFL3uwZLBy/SBIklImqR5er9INj07mVDLNEhArrAmgiW43mz3MolD3bKOoROzPvD4VmDoiZmMmNW2AwsFTpyM6mCCp/dFLBGtCX3SSM+O+rnu+aw7pwtXFodWFjl185vN7AiCO0HIZKdMAW3ZjyNWVK9xdS6VGUtL2nGpX+7+v9YjuDpuBn5ybvKqrMThC8bquWPANTDhqq5LKxwjxBrTxY6J7QNkB6+eulFcSnaPKbZ5kdchh0nuIvMf2sjF6zQPgClq8BV5ry7lOmfU1B8rOC3jwjL2TWsviRhV2dRoEx+A0SOm/PIq5j5U39U4Okzs6SIOuvuT97v69BwyW9YMQ7apqw3c6uy5QfCllHky7wtRuSFGjvefpQWuiyfa8GVzn12nqUfOFEslP+Ee34mOh/LYjAGINxMYmLkdauiFoctfrkpmwrfIRGXP3Z/HVYg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(346002)(39840400004)(451199021)(38100700002)(36756003)(86362001)(316002)(6916009)(41300700001)(4326008)(186003)(5660300002)(6506007)(8936002)(8676002)(7416002)(54906003)(6512007)(44832011)(4744005)(2616005)(2906002)(66946007)(66476007)(966005)(66556008)(6666004)(6486002)(478600001)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5NHDy4JxJ1LJftxEp7FHNQ3+o3/++eEmOz/jNPB2CLoeKENQJJO44v4hiNYD?=
 =?us-ascii?Q?4334PaHwLekLUn7qD2r0qYz+aixkpQccgTE5eUq6ezwXKefDuIlsH9MJfroC?=
 =?us-ascii?Q?aGtChO7JM4SlRUORhbbydBkuXxQqhudDX50papgZtRoHY6b0Cl6Mnvy97IRh?=
 =?us-ascii?Q?uNoi7al/trRJPiEAMGVdiDDFOfmIFW9pRfcuIX0qcrHuMSAMg4hdhY5TaBE8?=
 =?us-ascii?Q?vVqmHz0y8XfA3PJBRIX7+y5WyYirgJ+TKa12PNp9IS47M1J+ty1J17m7k5J5?=
 =?us-ascii?Q?IzT1op2RIc/FWzxI1eiK/prvfxxii+wRg3UvyHbadRzNlCFgFviW5sFhrLmX?=
 =?us-ascii?Q?GCVfit51rle6XCXBHMtaqKv7k90dMRnwlCjQuzF1c4WqL1tNpe1Mj2GjfTld?=
 =?us-ascii?Q?MErj4Z6/i7xRkwWm9F31+U8TqWIO8eyg2nqBNYnU/z7Hzd1375slVusnxwKF?=
 =?us-ascii?Q?e+DNoFoIigLwKpZQTJ/eqdo3MRFiLWodnN7FWHtG3aRZVjVpKrYsr5P+gmFV?=
 =?us-ascii?Q?2YUJbCyTy6Cwf0w6gKprqflRXJJWERikxn2sVIeeleRYd/LX2xLyoGh+pS7f?=
 =?us-ascii?Q?oxyL3B+UzbB0HnuoXSSVA2/auoKpEd1NE6V2LPw6O+JM52TXvSt5sY4dcl5V?=
 =?us-ascii?Q?JUko28A41HfuDXSCI3FwE7Dzm6fxEDXHwPENr7EPSOxl1KE6aJ7FTO4CteDj?=
 =?us-ascii?Q?82HpH3LzXkNf7NREzsyB74ETW+R6zZfvMaT/OrWDK4L8rusYyIhuX7KTOHUu?=
 =?us-ascii?Q?brJP9UcR2kGzF8jjCs62edm1EkGUJFusI2A57nse26jELV2JeEgHvcdyXRVw?=
 =?us-ascii?Q?WRlJLePUB5EPpqfU0URWKx1GKO2uDZc24P4rnn9bmIIYrNyS4V6PfxSo+TTV?=
 =?us-ascii?Q?POE+H497eMtSET424ma+M6n/iWCWksVT/XcaMpIRhkRCGOZ0YaNV6qBTNcoh?=
 =?us-ascii?Q?JyL0kAApJrlQ6DcYwzuIG4pKt1RUStNTUQrchi/01VgHtnjXEVm7BCOk7HgS?=
 =?us-ascii?Q?GkVllyDrbHTY61TzaH20okVvFKmnfQrcPsy2Jww6Nqznc/2j51TL7vXGOHuW?=
 =?us-ascii?Q?kFgz0Oec0Of+ngZeSTsgM9ntgtX9QkPUt7YOx2ahdCr5mJPdlDLv8/UiYUtc?=
 =?us-ascii?Q?uOmrAH9F2h/OXk54D8tCjVUCe8eN4wbapxYHRt6JghdzCjmi9Lgy9EHyQHyl?=
 =?us-ascii?Q?4niNPlXge2FImVqK/dG8HUGqEGrjT04aMLbfGfhOTauCZeDeNT+/gVphwuoZ?=
 =?us-ascii?Q?j5X4K8TbQq9qlGgIiEQ7e8gN6a1pPgO6OwIBAJpTkkiu0MZ5gw3Uxd5ppvp1?=
 =?us-ascii?Q?YeQER+PvJ98u3RsE1OsziyWREyjHaaLMrTKTWQFE/UAAQ8IbAGZ2Br2Lmj2j?=
 =?us-ascii?Q?qFGr+5FLOJvMYAq/n89soYi5yFNyRn6IcIUHjANHoKmbfMD0Y5nAQ/Msc452?=
 =?us-ascii?Q?k0105ZjyKcPif1T7E+g51tCaLuVE7XqytH9lpixX2414FK1zGg4KwD+U9YSF?=
 =?us-ascii?Q?v1cShCeECyBe9UV/6Puu1dBy9LHUeEYEK87l0TGoZFokOqeZ3eHTeCl9uMpQ?=
 =?us-ascii?Q?aPZvV0Bqz20Quavg5UYRxrv59VpO5CK+/BHt6jf0B6/zhqnZSoyA0oUyJ/8X?=
 =?us-ascii?Q?dO57nRVpGUswa5dxDNz11Cbzo5DmZms97mi7CH2rxUIDdRuX0nH6EFA+mplJ?=
 =?us-ascii?Q?aTMrcg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea294a8-4e84-488a-ac99-08db55e8b26b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:36:51.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INC9M7VlW2gXOpLZ2BKhys8reFopYgny7Z8CAH2sZooXWC3KkaFere6ZQYroTb1OeLxNV/efg7MMV+QWBxBJInqwntipOIXwpqcjQW1JIiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:24:55PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated, and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/287
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


