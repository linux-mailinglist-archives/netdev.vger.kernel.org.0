Return-Path: <netdev+bounces-2905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D817047C3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A79B21C20DB6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF95520980;
	Tue, 16 May 2023 08:27:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E6E1FB0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:27:44 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D611BFD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:27:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/eabD9rDQ/15vdMQ/txlFgrC5gLk9dCfStUNyl63CCOPoIKaI7HQPXczQytcRKqfHTp7yHSbVI/OccgACnVzuXQoe17CONfAskRiE2pVXknAVcEI5MrzMcuZGLsOc1uCCnhm2dX2Q25HCr7CiCoPp0KMty5KMQ2wt9/tPHrFyT3pGdzQBCC0x2pQ8U+hflcNvPkgsIGWmcZNBSz2YXalLZsJgc8Vw70WCqgzwKEB/cUNGUTlyrAO0EWTTRJEPZJZ59fG4SE4eb0G9KiowNm37FGRQUtTcpfaguVdr9zYhdQt2xJZRCtyL1HvlOkKMjUdUbLdNyGRi8Y7w9zibYI3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+EkCngK7pYS4ysBNdiSqkaPnUUm2HZQGkocgJ93kZY=;
 b=M7dVfBhnaB9xavMohMKOdZFYqB/0inbkmd3zZNAzX1eXoiG0Yw7hvVqVbdn8gChzl09c2RNYmA4BbQAZn/oRiJ9LsJ2VTGhxf0++Ej9aftgz3b9zSXIpw6Tor96MmhF+4icaElzMpYhaW5ftunSk/pBt0eg6ud5v+sC22/6Io9QvjbbQNvhl1ZpIZ9hRmaVA0cJG+gXgUrH850DaFiPlAlifoKFnBRrdpCssq/aH0XOO9vMo7G3v9xnTeqQMGwcnvMTJUexE8uY3KiFKjtjuFI/Twe3I/yT5X9K6P6mxER68/MWSPJn5ZxwwBUdteFR+lhEe2VrNToiOcZ3AOi5f9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+EkCngK7pYS4ysBNdiSqkaPnUUm2HZQGkocgJ93kZY=;
 b=aJVtXQAiRm/Y2xErSaWvyQ9QNi8hBCnt97QCvjbdX4meG5hRsPgF9DKc8ndlHo5IM3xwxA4oU83JZgrAw0USruaspQsSFBAT5QV4sVxMamFvpdiyAA4H4u/ejMvbclP5y80jY5hjh6xcETLwstKEQtp+ivJX+ARyrEZZsZRNjxU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5774.namprd13.prod.outlook.com (2603:10b6:806:216::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 08:27:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:27:40 +0000
Date: Tue, 16 May 2023 10:27:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v5 4/8] net: libwx: Implement xx_set_features ops
Message-ID: <ZGM+dmZWidau5fsn@corigine.com>
References: <20230515120829.74861-1-mengyuanlou@net-swift.com>
 <20230515120829.74861-5-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515120829.74861-5-mengyuanlou@net-swift.com>
X-ClientProxiedBy: AM3PR05CA0144.eurprd05.prod.outlook.com
 (2603:10a6:207:3::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: d6cadcce-a13a-49e5-0082-08db55e769b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6RljiXKHw3NSEvD4rwR0R6UN71+eArjXgsxTWByVXQZj2aBn0cu5QIlAtMrHDcvtU4dnxZBTN/JFVp1JI/RirDKmtXp2tmo7SeVr9eGJd0tMYqllwKrl7B97Vxkx8GlFDj7rdKmx4IZR14lFWiU8TQHCrN0oQt8xH6wZlNIVqL8/lhWOUTf2eV1PkdRQE7gBWcgCWw2brV/1kToPqiio+qmraLA9rq7iYBLi27BJrvaTsancOaGjqOW/5ZhwgvJwTHdkhHbsUCV9rN5Bd/0SKEPPMSkIf0Z/oO6RPyHBNtthtLMnvfonXR/o+Cz0B6clYYJrcZB7beuBE3RPcO7IcIyh5DB9Us24KK12d81Qed4AY4A0ObOTpH07yBZPtWoONeEHvZmWhaEv01lUAKVVezD53AI75hi8/UUyVCHWS0rjWEdS3O/p7rl5psaDa1GChIfvjIJT6MBmdo/XetXVHwv1IvgMCteLwOfA5+RA/tpg+NHn1voyRnThTSvSBT59ruaOdvDOQzzvhUI6t85YvrNJbnZESiZCPvY4A1oW9V38dBPn7Ih9gOuc+gJxBhNJelaRKr3Ci/GyJzguvxx0ow95NI8h08NzLVoYk33VLftyEdWV6pwyBsxj4bThoyqy8QShBWYsMjH2u6yT1cO1gw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(346002)(136003)(39840400004)(451199021)(6506007)(6512007)(186003)(2616005)(8676002)(8936002)(4744005)(2906002)(83380400001)(38100700002)(66556008)(66476007)(66946007)(6666004)(4326008)(316002)(6486002)(478600001)(41300700001)(5660300002)(6916009)(36756003)(44832011)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ke1fueva0/j17Vcr3kqmbrvRmF7cEU2Q96lwxS9gD8cVfPIBfEL5WyK0E7vP?=
 =?us-ascii?Q?QEpjNrbmsZ2EsK6aI4DsRFd6t1Dt507012CWKvcOWjR77sgSwZpznj5IhzDa?=
 =?us-ascii?Q?i/sHDJIvS+Hb7g1r25/0e7SkXJOPKgChKpWqPI6cR+OJm0P59WE/ok5Szw4+?=
 =?us-ascii?Q?+hbyDkpLY46v5w3Z7Mt66FgYNhdULyizw6vkoF1LMvlLkXJs6Bx8yyoI1gZf?=
 =?us-ascii?Q?udwcZz2Qk170VI6u13qKG1rzNV80RBS2w1uqB0l4WQmrnoelU7m4B2t47zcH?=
 =?us-ascii?Q?LhEA6ygwj0Z/N0qKCUEdyZ2ExP09AbmniHHV/+7UTSWN77gIplcLLN5bnYaw?=
 =?us-ascii?Q?6V7lz+53f4otx7hrl4ubTcmwHi7C68uqayUq0st+SZ6+TnyFWlP7UZbwolk4?=
 =?us-ascii?Q?72wglPn7xtcFlNilNPx0qZ+I+MTz99RHdlhZ5xsQr7PflVKiNFjZsnoKLep9?=
 =?us-ascii?Q?zeeHmgL6LWLm+Rzjddl+SZFLYTMgdICCx/zqs5btNYcQFTLkbf85tG/fmJhd?=
 =?us-ascii?Q?fCShi8cym0exLiPnKufjNX/IWI857+rwcG/GwjtH0eLqWq9jp34IfHMuwRxu?=
 =?us-ascii?Q?ERxvcWgcrVgn84C5DJ4bhWMS9RH5vu60mK7oPi+8rQLkNP4MoPVbOdjP/rju?=
 =?us-ascii?Q?gWnoNmB0pi9vrSsVxEdVodX++49LqV93jJbuAKAat4QDm00j/x8Qh6Q+8dY5?=
 =?us-ascii?Q?xBxuoRFV/Its9Y7HbfpUxQDb8K6hkiTgceROkfV4tIoCJ/WhlnS+2qK8VBZJ?=
 =?us-ascii?Q?0VbYlMej6wcm20ujUt1NbR9e+RGGvXH9Qk7fSMDowE/wOGpIUv2McJDT3M9C?=
 =?us-ascii?Q?vBPIn4lLlaQLh6zwJzz1jsAStbd27flwRxuNC/wPPDV7gsBQfXUg/kydAQS9?=
 =?us-ascii?Q?phTfG/OKUpCgiJLTIvWzBfqRJVAgMZgLJE880JXb7ZtVzugCBXy+rJ2Hv2Ux?=
 =?us-ascii?Q?7YDCxa3Op8v0Vzou7Fpifarb0Q0t3dcM0s5IphEdS0kpeatP+Tnl0viXYcfg?=
 =?us-ascii?Q?TNcxyIsm/aG/pSeEXG21EBmvZUP0CRjBcga3SiiI4XQoPZNb7WqUuT34do72?=
 =?us-ascii?Q?IZygqNhg0OddhFh6iOkPw/iiql7E+Yu91+XTPQGgEzsxrIH/RSeF334F/gSq?=
 =?us-ascii?Q?XoaHhOyGf7IPsYKyStEoh/fZNIEbQ73zvjydOiAgsyIUrDX8pgdvESFeFn8x?=
 =?us-ascii?Q?9C+Ywg2sbIXNT69r6d8nYUB+WiHGLNDyb5A2UDKcKGvaZ6koF2YnTEDeyW17?=
 =?us-ascii?Q?BxbBBTNq/rkaiPZkA29wOwDxhxMygHpQr4ZsOHMNF5KUENzlPmkx9X60Lst7?=
 =?us-ascii?Q?76g6oR9R9DXQxgIZ0MKxD7etdo7EvOdbT3okArpiXvIWPJm8c7QiRwqASFIA?=
 =?us-ascii?Q?u3R2G0hLf1mIWyWBYGMa6h4iC4qidfaBK6lquq7Dqo0qSIIIRxBtXxMusnzr?=
 =?us-ascii?Q?7AXsCCCYEHqTEu7zC7J+Rn/9+fqzLc07km1j6SNmhXGOuTnA8dPbwOfIYxt+?=
 =?us-ascii?Q?1bf6q1F69PT97mKlL1SQ3DbsTDxQ851laaVGB8YpyqEgjV8pUo5WNcMwT4DM?=
 =?us-ascii?Q?puhmTbRp5VWEgry5IaQLXaJhbQkiGTCHrdK3l+pXz74EjLn27BgX6fUTsBo5?=
 =?us-ascii?Q?rfKGAam9QSIzxCaEZUqnbP+xXqO7mavQ4VbD57QcxotdG5z+iwC33D22aSyj?=
 =?us-ascii?Q?2LSPxQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6cadcce-a13a-49e5-0082-08db55e769b9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:27:40.4687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5J9B6qflV3oesl0yDdDMXp9jZsbHkY/ExAjXlX/fhqJ/KjPW0aW6IGucf/x3vBVsIoWfoRCr3b3O6e0ur0kaDot3cSo0+736jINTToq2ZGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5774
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 08:08:25PM +0800, Mengyuan Lou wrote:
> Implement wx_set_features fuction which to support
> ndo_set_features.

Hi Mengyuan,

function seems to be misspelt.

$ ./scripts/checkpatch.pl --codespell
WARNING: 'fuction' may be misspelled - perhaps 'function'?
#6: 
Implement wx_set_features fuction which to support

