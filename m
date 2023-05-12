Return-Path: <netdev+bounces-2236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 447D6700DB6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BF901C212DF
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8511200C7;
	Fri, 12 May 2023 17:10:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FAD200A5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:10:51 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2132.outbound.protection.outlook.com [40.107.223.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36025DC40
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:10:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjp5GJfVOcc5wZ9o/ZL/MWM30LtP4nCSwHSpkCOQXH6iBcmgI+d0f9nh8qYM+acgZWvIwjOQc2II2iDymKetxjjyQPymUQYNULagHHMmQfS17LDIzFfSs2CsUn8O/P2JsyyzBBukey+C/R4jgmPpdiEq//nKGzT4IRDza4VyPepjMGwQRLvqktamw/FW4djHRgGslwUjznpbgMnMCEgFEGdcH+ovH+ezBU/6d3T5+xWd1W0lUBo8bbBqo5cZM+v+5UZnZBNwwQNkGYMvzv73lu9NbLadLCvNBnaYscw32VaqsDVlSihA+bzJUMjDMdODAyIQN5z72Wu9z4fz+PA7aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWfHmgRbAht6S0N48z6c9+1MQXkHGoqGQH/zxJbl4Rk=;
 b=mioLiAXNvG2Cqtocq3M/dEToJ5tS/lAvHEQnSL5eWk5ffiSoRqtRMTn77lCp3D1clhLAETzcV76bf+s53fG8La4g+L1gWYgZ2ssy3Hf0/tnE4k/nuWpejOsIrIXvMftIu2WiJiWbmnXHczapz68tJUXTWFDHEvLF5GuJ5yr4P0XMS8J2exy9rsc1nB5IGytla1PHIRVWlthC64Q1m0fkp1+lsSGKkOTntdDyl2+I4w/H4sREkao+EXQ37Wpdu3hP/zX60CZFUNf3XnTomB9JmaqbuYGdqat23utyUWeWXG2VSkhl/M2Ab+i+vrEeBMxQ784jzbqdpaec3Do1o/Tx4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWfHmgRbAht6S0N48z6c9+1MQXkHGoqGQH/zxJbl4Rk=;
 b=QSm4IOwRpf6aANwJv2Tagz99BXlxcJsEfgBJLc/x2xyXHx2G0C+hXG07tHjHX9EZXyt74UvDwurMb7eDWrYnksm08Dq3LJpyrnNV/c+hdwRbGn3W40fGYTLuIruCNUE3xs7ITDmn0aiJmUM1yNyPvrpD8MlK3PQ0tpx/Jwotg+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6440.namprd13.prod.outlook.com (2603:10b6:610:19d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.7; Fri, 12 May
 2023 17:10:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 17:10:35 +0000
Date: Fri, 12 May 2023 19:10:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next] ping: Convert hlist_nulls to plain hlist.
Message-ID: <ZF5zBHB4NvnquyZg@corigine.com>
References: <20230510215443.67017-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510215443.67017-1-kuniyu@amazon.com>
X-ClientProxiedBy: AM0PR01CA0113.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 095e8f89-481a-4a1b-169b-08db530bccfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZJ0vL0sULZhVHUf/zHdeOwLp5Sfv+ygysfeZjheG+5qHe3QM/wJSrYbnao/omCNedijRkVz8e2LSDb4mtuR3mmY9nrhRe9N/tlcNfLuQzY8IGQiMkeQuR1rqMky6Wkq8C04o1xhycvDOGGCxiFJT0M40bx/kO9N4BE1S/UyokZwAWGqAlIL6DtuUivjX0nMNwy49YN5eDpTyIEanI6UKGw7PPvKNoYjwrL3Piq7pniGUXZSQAJ3auyWb/H/YJWn6B4zqRSFmT5yJDHUr1iilfz2rXHenmWbuM8kAZPkMDVU9a3Rj69KrHB9pkpZTjDxp5wqPo+phTvVvi11rY85vy0+dWh3PEj0j6oaer54sA45XQgCoujmS94szdJq1w8m7BkRRZR/YKrbEqrR5zx9QxBCPX2rSCVEGt9kJ05pJ5V+8J+wiXRtVme9Hu/hCui/zngrn6dekLuEp5ah10bF9gk/9mqCA+437HIhNQY1NYsmwOXMGfcIv7VGLl1XUSCNdpdHv20im63gvp4UuftAiEVcu1PtVzmt0Js0tFwyf5Zs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(39840400004)(396003)(451199021)(2906002)(4744005)(186003)(86362001)(2616005)(41300700001)(6666004)(6512007)(6506007)(54906003)(44832011)(5660300002)(8936002)(8676002)(66556008)(6486002)(38100700002)(478600001)(4326008)(66476007)(36756003)(316002)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4lF+s8SX1fNJGYjBFG+2AZ71vuxAMwI8OCBGhoJ/HteW25hBAFTR56cgWzLT?=
 =?us-ascii?Q?1OMaIaKS+04USVFvltQBF22MCjtrSF4kyGgZQpF7b/+OWF8mNlDtryLYlw7p?=
 =?us-ascii?Q?niaYX0v/B328rBYrpzGT84fanWoMiNln09B0y63oBfLKvYmYy3pEDZNgU7Hf?=
 =?us-ascii?Q?C1Y1eANaJiqzsJ0/hEXJTgvTedO3uJE3dNW3j0XT/+80Nbuu7DAumJaaonNU?=
 =?us-ascii?Q?utUr0ZhSC4mIck0qa6m2oZOJVOlesRCOvEZjMwh0j1Rfc09vBwevPlH6zERt?=
 =?us-ascii?Q?Y+alg3s0UrsnRqDleojCUzNheI2o+TWe4UAgkuXspsoiOpGUDuDiZJTQUIpi?=
 =?us-ascii?Q?zgiLa/Qrmp+sHVrDoTwW+XLvw7ODqG9S4HxcUPuz7RKdePvRsNsCrlv4S/+w?=
 =?us-ascii?Q?gmMZliEM6Lsbj0riMWCfYg1NgpSBfpZO+IXykmPiZ5S8DrnsHPPAIZPnLV1/?=
 =?us-ascii?Q?JqehFC9hFNxlvxJPF+0td6MD2LughqyuSUy9fUqDRjoHkoe20wkiDpBmdx6t?=
 =?us-ascii?Q?bVoOhCry92EGqpCM6IQymboExekI5olOjAFgewRqY9EbTtJrqoueHVcDwXkR?=
 =?us-ascii?Q?EHTHyix7D6QY7KKUTa6BQ2nTPMTrZmTRcoINZShYEuIXxxQNiNttKpEYMk/R?=
 =?us-ascii?Q?BIK28w2+K422l61XxR0SOq0R2/6LbfS5IGoR6XBLJszEScn3N6/YmVq4n4FM?=
 =?us-ascii?Q?rPDjAi+EPpEAv9gXaEws4y2zC5BVXOhxs2PpR6pQw7SyDmLRQR5G0Fyc/mIM?=
 =?us-ascii?Q?YV2FPbkc3f1ORMOIrKQnlbLUYuZoJo8o2DTx+/wldoJxrYIM4fUxx6ZagmDi?=
 =?us-ascii?Q?NHQo6ESfn71mhTMNCpDcr2X/UXTaxJlBf7N89KDlkeLiI3impnYTSSOXeB9e?=
 =?us-ascii?Q?FIK6aGF3EguZm1miVfCvQ4xhSKPdyY/OUxHoiyfMdYbn9XcI2vfkFNh4pZTa?=
 =?us-ascii?Q?slqI1qeUQ5sKroHA59N92UsgqFJJGKVfzf3zF5k5nKDB3KYlb8x8FgWZh5bJ?=
 =?us-ascii?Q?9oO39bzIjJQHHOLPso9TT/e+ctLVSr/nw8+g2n8qtHNqkc/4Y1MTL0h8weyS?=
 =?us-ascii?Q?8FmLKlIGF5+odnSc1uFshd1KOXGTtwf0wV5F0uz9RFuZNm2T0tSzo6MUQSLp?=
 =?us-ascii?Q?wA+A3UrTryYcrdf/CoV80pSGoMdR2xGVV2Al0B5ALTgLx35QN0JPRrFaewW+?=
 =?us-ascii?Q?Kc6+HFFxpmWMnWkHYDrsPdo9l/mPEjcipv1+oPdsyoGB8htiYfLevaPzi0B6?=
 =?us-ascii?Q?5hdDNESukXbtWJdO2zQXeNwPTm3Nq9/2w/r8bUII42SkuLsGXOnxUCI4ykVm?=
 =?us-ascii?Q?2WtpkpiFANkfv+BrKpMLks+WTQR+6AcCDdgHABQDBuD1YZwHKl7FnFI3Nqhr?=
 =?us-ascii?Q?DWPXjyRjKVlZNbCWVUhBDC3AA8Wikm20BHENNScs00EDwvj4ivsFZT4Rscbx?=
 =?us-ascii?Q?ZDUN1YVHAi9NnB4o4Us3aEcxsZy9w57wOSCF9x7uJTNebx3ATImQmVcKNkcA?=
 =?us-ascii?Q?hX8R82xOgkxAqkcs+rSlhoSvehuls/mc7WbCYExSE09tuSeFOz//Je0SrkDA?=
 =?us-ascii?Q?3HALA1VLowZTYdfeCKIoqvvV/HRxHAvQnvlyw54zNAUWBdE/5ltlHhVgy/hH?=
 =?us-ascii?Q?Lk0UJP0yE1fWf+OAB3mW17rm2z2HA48yucQwdGplUQP2da3olWG3tt3UWGD1?=
 =?us-ascii?Q?q6/zrQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 095e8f89-481a-4a1b-169b-08db530bccfd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 17:10:35.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhdieDmtCIU2Gx8e8xwmp/2KGiDy4r3tVB8d5btBWlNxVnDk763HvgXJKsnmjYD7JD/BjFs9GO6mGcNfQd4bHdlyuzNbk0utdqo9pblZ3XQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6440
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 02:54:43PM -0700, Kuniyuki Iwashima wrote:
> Since introduced in commit c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP
> socket kind"), ping socket does not use SLAB_TYPESAFE_BY_RCU nor check
> nulls marker in loops.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


