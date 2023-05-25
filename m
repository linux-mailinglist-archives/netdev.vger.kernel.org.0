Return-Path: <netdev+bounces-5281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2693C7108C7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C35322814FB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90AFD53E;
	Thu, 25 May 2023 09:24:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2DA2CAB
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:24:21 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2098.outbound.protection.outlook.com [40.107.94.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC36195
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 02:24:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/JhkFGGLMY6XnODzXVvHIAToeVGJjuRE3MLINC3BYc2ZektAM8HlZDy7E7A2R7Lk2ZeLTSHT/hRBt1r1fL1ANpUPmr/3PwISwTsL/zloo1D9d1pjW32TccP8+WBRdwM+AL28RyjnRCbZ4C3r9Zghw1OX/H8+6b+oazJb9kZzhlln/c2qGJuybXdvinI+RNThDqoz1KkbCXmoW7b5RYfrJBx7EkL+iqpntpLxcLLPnyQZx5dFpc0V0dHdKo/dwz5hfQpp1ohZoVuYXfQujA+t6bfT7FzBjBMtyuuSen6omMd4KFF6SosgJIRD0yh5UnRp2zNeDea0IGYP0do2pjjPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+g9D8CtxkPTN838GSW0CVoaLUKfBARUmjs2YuxHdd8=;
 b=iypGZ4xoNeLM2ky/7GBmlqV7jn3UEx2Za1RpCGi6IzXiAPihekAG+1XsbCUQXMVKbd/mQXcbS+CHPCdHlqSTMz20iA9tFrHcYk16qwV5An0G+vM5QZDU+n3g/oAgCNwjB+O/Cch7QqSxke3MhX096gN4+EUImce1Yq3rxCFiDPsZGWq4Xpr5x3qwvKTaxghSYmAulOosGkUsDJg3IZ353AHBcFwrATYjNHB33Z7A14JU/NIQTTFbUpWpMMAOZkxMyKPiXPlgfluyDuH8JcxuJ54Ch/GBsPJ1ky74mAITwgeb/FCnYyODVAynmDTDfEPKxrmwrGXoNVhypJsVgfwefw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+g9D8CtxkPTN838GSW0CVoaLUKfBARUmjs2YuxHdd8=;
 b=Ma3qOPNKIsMNcufPUb//ypFHSFEOqfYyrPkoIT3rE5UO2+BP6O6au2llLXtwyGNRIigw/Pubub2fp/TrfjzLry2o3sGGWmSY8LDLQxDRvTm4Kh3Q/F+Gr6IxuDJReiKocteIl6cDGI9DcZ+t52DLZmB1Y2akMKedJ21uYE/vxhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH0PR13MB6085.namprd13.prod.outlook.com (2603:10b6:510:29b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 09:24:16 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 09:24:16 +0000
Date: Thu, 25 May 2023 11:24:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, chuck.lever@oracle.com
Subject: Re: [PATCH net-next] net: ynl: prefix uAPI header include with uapi/
Message-ID: <ZG8pOlWPDBrxkyD/@corigine.com>
References: <20230524170901.2036275-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524170901.2036275-1-kuba@kernel.org>
X-ClientProxiedBy: AM3PR05CA0101.eurprd05.prod.outlook.com
 (2603:10a6:207:1::27) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH0PR13MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: e84e0016-1acd-48fb-6503-08db5d01cfda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dgltPQYsE2gBwzsnp/A8wRbQAE/+edGqfaC7t4H6fjXDiUDMT14hAMrOMXWs+eVAndbm5UB+OjXlADFUlH+XfHneTynUaysqRQzRjPWxCJ6id5OD+g5Q3WOOwzyc4INQSoFzb3/FAnheZA6262vJxT6uzaIwRGSsgBScHQ9p0bYiLGipAhMSOoN1uGVUZlnywWsntf9T7Wyv+vccpa/kpunHCqXH4XHltrlLGHKCZzEyMJ6m3o7RtkC72Xm3znGTY7I+MdGoh4OzEZGDrFwawjTpya12RQmiOtqC6FKFCURzycWSfK9EiO7m7fv84d2Xg1T31ivGhWCpV69cbrKchqkBu1MViRCdDfzNkDIWme3ogxySPxqpPkE6EWUfkAwC/qZNT2f9p8cxGJLde3FSzVgnQADoKoDv40MX63/7T5Ne0XCdyZHXM1+UVgDegjLjVx+c4pVXfo75LVgkcNk0NAErcImJKCad21+AVplTXDQTGfP0MyxEHS5k8PjxC/F6+Nrr6o25OHPMVvFRkUy4hHD/HVt46gh31OmHahiw4ezIWhMnnbXZ4eCJZJztFi0bWhDKWogfw1I5y/xnaM7HAD5liWsllZPyh+lkGjwWQZw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39830400003)(346002)(366004)(396003)(136003)(451199021)(186003)(83380400001)(316002)(4744005)(2906002)(2616005)(6486002)(4326008)(66476007)(6916009)(66946007)(66556008)(41300700001)(6666004)(478600001)(44832011)(6512007)(6506007)(5660300002)(8936002)(8676002)(38100700002)(36756003)(86362001)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/+xvFfPMxQVQBJYtCiwyBw0MvLfL6V4IWpyyFmZKLemRmu1DFuI9wk9PPE9W?=
 =?us-ascii?Q?Wylp6m/43hVdz74/CoK3uvgliDr6hwj+wKiRoRR5U823/carHAukdXQwdv4Q?=
 =?us-ascii?Q?CSqOmZOBCe2n5PK2t3wSCk26HZwLVt5Tm4Ss/SVXOEkVI/6xwB/tD1sMEYmi?=
 =?us-ascii?Q?oPopzGy8aMKWHD1YP3VEA1CZw0zBbBY0uXOrHQ2ke8cL1+pyCUpho3caigs7?=
 =?us-ascii?Q?3aNBVKfVEm2EpJJycDRoA0qTFWIAqRvsPY8sWTTdmJZVjZCtGzJKA8fLp0rs?=
 =?us-ascii?Q?3Mt/uosu0VuBC63F5+6ZaOIHJNq06w0FieRpbJ920xqcq8eNyxI2CO3T4vqy?=
 =?us-ascii?Q?EkBg5aHEj5+EFbLhhG/XYkfk7l/8bRAaF/Mi1if4oe6Qcj5rDpVOPp1+9qI4?=
 =?us-ascii?Q?iyvOu7kVNsdRlAaTmpK6IW5ymJOCNnc2bB9tAIukxt403hnUriXTv9s8poqh?=
 =?us-ascii?Q?EmI/KRmSokgubl15I0X3mICECm2yCeMM3pl2ChEo6QTTDjk+Rsw6t56tLgH2?=
 =?us-ascii?Q?XnXSvuRvRctRo1nCB5y/8RrjPOM3PPKJP+BfWqQ4Ywlwc/g9v5oPv1AiAuXX?=
 =?us-ascii?Q?a5NO3TrheVlcp4QcKTAJV/lb25TJqVq4r6ry/6e/JFBJonmALoy89YQrHPbF?=
 =?us-ascii?Q?ytehxAQH+6MsBQcC9TJJ64IpPOK1URREmeUjB33vnWAj5Be18jjBahSK+LFi?=
 =?us-ascii?Q?FJoL5pA/lgo1yDAdOvkyNFHnpEpR71yo2z+ancVH5kwfkzQBvCXFfPdW9R3w?=
 =?us-ascii?Q?B3J5DbxsRjPyAS70eH7w0umbeo7rw3yI9CfGsxzqiBLFFPwr+umUYpCLgeZS?=
 =?us-ascii?Q?bQf1hc959KSrmkDEtEFywEllYv7o7GdXM4RSHKB/cjL2OoO39Gpehzw+k/76?=
 =?us-ascii?Q?50nCwWv8Xyz90rZb+x9v2Wx6kJ17twWurBkhGYp1qVjAuOB4/YAis038yD2B?=
 =?us-ascii?Q?ZHIE7UEDsg5eNrwbuRmj+ny6wQYljdpfTzLmWaCCqenD4uh04/t/M4RO5WI4?=
 =?us-ascii?Q?i7sH41LXUJwHGJmMlJ3emDuuyFQOYhpBIQILq3SyPlXUJVcXi084Mz1935gF?=
 =?us-ascii?Q?7OVlnbBH1SpSJwI60QpoOU+nwkIWmKDNSUfoZijvOO0DpKcvMFov6RIpwe1P?=
 =?us-ascii?Q?lSwvDMi0yc/7EqPfdJusFCwZTetx3FIIB1O1Y+dmt44Ygg8b2MymqbmBbRKV?=
 =?us-ascii?Q?K6xJKEc9P5sI8MjCyQoB/lT5mDrbP8u5cBE/tPqMBucdh8J2rdXKrfrOBVnS?=
 =?us-ascii?Q?fOyvw0EJZskYBpbk1qEy9vEAih4Mx4zTTwOD9xGLYpxKZDo6b47ww9BEEyHK?=
 =?us-ascii?Q?sDJ038jpOv79gzK4ow/ad4eUXjgYppMe2VGysrKkFT9fthdrdQu96nrZluMN?=
 =?us-ascii?Q?lrXtSXN2IVcBkzcZLcWVKmaN+s/EO1TbFuG2auiUcAGcpeXqOfhIUBTqS/YT?=
 =?us-ascii?Q?ypiWzTX/9ow88Mn78SsAApwQ+ZuWshOI7OaqRaU0EB48BlE88ulXbLaK0RqV?=
 =?us-ascii?Q?8ullyHbiSpKEGQlXgQVSZAv918hsdAqo+Y/dMfT2LwUTLfTuFPa7/A70vl6X?=
 =?us-ascii?Q?GfWeBVF1drZaZmtM+g+6p9tn55mYrsGP2EX4JmPIMtApJ2lKEGBuv39K/AFG?=
 =?us-ascii?Q?yCWHclaY1BOISMFAuHe+2jYxQcDekuIUjs/3neiJpqOkPtbFlb8Va+CBenpd?=
 =?us-ascii?Q?F/2wAw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e84e0016-1acd-48fb-6503-08db5d01cfda
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 09:24:16.8019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWt0gp18VTwX6YHPjyzI8+Y4RSQ+akpHBwB+wm23jl+Z+AHBAUW6bAQwtRlj2Ori8IcKUd0woF1gaZjGN3zjcSw7eMm7HCZy5icwgVO3u9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6085
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 10:09:01AM -0700, Jakub Kicinski wrote:
> To keep things simple we used to include the uAPI header
> in the kernel in the #include <linux/$family.h> format.
> This works well enough, most of the genl families should
> have headers in include/net/ so linux/$family.h ends up
> referring to the uAPI header, anyway. And if it doesn't
> no big deal, we'll just include more info than we need.
> 
> Unless that is there is a naming conflict. Someone recently
> created include/linux/psp.h which will be a problem when
> supporting the PSP protocol. (I'm talking about
> work-in-progress patches, but it's just a proof that assuming
> lack of name conflicts was overly optimistic.)
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


