Return-Path: <netdev+bounces-3451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 015657072D1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E56E1C20F86
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC948449A7;
	Wed, 17 May 2023 20:15:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92099111AD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:15:03 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2116.outbound.protection.outlook.com [40.107.93.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217AD2D55;
	Wed, 17 May 2023 13:15:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7ncUzdTNBFpfmJK7Nv5Dfvs83Dl43HXkoOqQPOPnZ+B9eEosF56IJ1EwHlS6yL4IdizxmufH1kQI5peJePA0Jz9DS1lN59WsTL0bQAnT8f84zxSqepHkPhsUmCZn1H2JBMEKONsJ6cEbTuSFSBQ0stnZqr5yPcjiKT2glS5s49iIS4hjeieOJi5uB5D22xim3BfpX6dPA4zaIqpt0Hydgeek4164VS5/pFcqdagCpXY1YExj00sW7seQNnjYe1/FCiEtmET1uxvUshn59TQxHRQoCrWe5pJGtPpDKGlCpD+uWioT7KqW4RblW+Q8hcHKKz/esuTsktI0kXb1oK24A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZd55nlI8dxxnL1UXftH5wzxKvaXbTq7gytNqMqAvJY=;
 b=be6KGBIQb+nD6eMhYTYf8F8vM44xn6BwA+ThDKpJtjNkJoyPC4q+ZmIU7NznEDhuaCW2MFNxWWDe1/Eb8Sdt0lOjeyTvwCClp+LcV3enK6FQTl/RllttptB8F67Te1NyNpqd8M5Mpy8yn0ty+evxzOi9PxY8A3X6pLilMlRC3BfWvkB+CbyidT0yZtRbvAyQ80gOtl/8UmHs7pkuYv5KnMAet3mZLLmqHI5IYkslCMYVDWsrkxfFttzIuRdYMlkyBLn6x+xq6KYR+hE+Me1TPLZ5zL5MsU5fA8yh3xm9J9qJd7LpzHKAiVUpPkXhId7Cg9NcZBmBDSod9J498qIfgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZd55nlI8dxxnL1UXftH5wzxKvaXbTq7gytNqMqAvJY=;
 b=Xr8whOPK4aRz1YtaYFkpqMVCKoZdeUD/dSG0FCgWokvNV1ne8nQpDAolfDqaWTaAZeo/lQoOsa3NGuos4SSjJW897ZS/2oLt0WgzZbrKmWQEg30HtIkCGMqyAFVxUkGV4I3iD9ylcl4iYCdPoqBIQoZPLwIWV7g6VtQcyeqxyKA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB6047.namprd13.prod.outlook.com (2603:10b6:303:14e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 20:14:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 20:14:56 +0000
Date: Wed, 17 May 2023 22:14:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yeqi Fu <asuk4.q@gmail.com>
Cc: mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: Re: [PATCH] net: mvpp2: Fix error checking
Message-ID: <ZGU1uVuP7nJvigtr@corigine.com>
References: <20230517190811.367461-1-asuk4.q@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517190811.367461-1-asuk4.q@gmail.com>
X-ClientProxiedBy: AM0PR01CA0156.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: bcf7454e-baf3-4f9d-73b5-08db571361ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pE6yMMlRdcPuELYfoSMONVdclSB0froHqI4wuy3SezrIzyaRnAY3G+yy26SEQTWsoJfgw2ECkgyOdGQt1Degtb53WW7erKvAusw3l72l+9u5JodLgL2eXby49+zMzg0torSh23SMKkgflk7Gb8W5KeoefZNkGQLW/9AT9K08K/bQjTDO3dtnhaR+GH3y78ak50jSBde56nwI1IaK+zUi5NMFTbOkCRJiRyiDllfSieoXxkiaX6xxtM5DcZJpkfoJXzZWvXg5MMSYJ9Ps7aWlSG27QjfktSG6oUDgp3zvvhbVgPS/2/HSlTWI9HhHV5aPYLie5SBwC6DajYvunCEdHLltKUOz6BMa0Gk03OfLWSAZjqjfZMiW1GKajySq4FTGgUCMN5+qZ2ffzzbNgXTM/3V9roG5Ctb05c4t9rJPWDXwvI2e9+db+zqb7/I66x78UawRTP1F4KFaJJrYQztbJwanS1H+OGQAwzXspXEzklRg7vRxjNXXMptWPOmyGqF1mXGJdvAygNC1ZFyQkmsNtwRjBqUtmmi9IQApxSjEc3BKpLnholtbV9ntp3H5534j
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(376002)(39840400004)(346002)(451199021)(478600001)(6486002)(6666004)(6512007)(2616005)(86362001)(36756003)(6506007)(83380400001)(316002)(4326008)(38100700002)(186003)(6916009)(2906002)(66556008)(8936002)(5660300002)(66946007)(8676002)(7416002)(44832011)(66476007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bjWWW+LEU434nDa/8iaP/b+e2QeGUApQe/35E8QsbyCv0XnS+TGQmwIVL4T2?=
 =?us-ascii?Q?xeJpYRTUyZ5vwKOJ4CACgdvIlVvPjrJP6om4I14QeHiOcJrJ1vOVxE+sG1Ik?=
 =?us-ascii?Q?bPx5hRG5oH7QXpNP1pLJqGnigqXOrVkQkMmPI3Dg9bCKN2i3eraA7FkinrgN?=
 =?us-ascii?Q?OKSvEF0So5AC6d+hSaxmVjgrSXWGYjlUxvlfpXJqJOjZrSOLVaczHinXRWXZ?=
 =?us-ascii?Q?NXVWB4pY3H+5y5TRaPk0dv3EtxZp/UPTb54fBT4T2TLs5F8vrWHPnzt4ZbAT?=
 =?us-ascii?Q?mk4SI/+1bLJgWbEMI7YzfmKLmaAV0Fz4EEOFmgLj2ZIeCORuA0xw+tv3yyfs?=
 =?us-ascii?Q?w9q6z5vveRrqp7HGDqdIJmwrf2SHywLLyapbO3s97B107E4ffOkhyPEIlnFN?=
 =?us-ascii?Q?/fFQIox+iO9H5BHUBZD2gxzCofGIb8/ZXb0Ic8wefDak5v7heo1MA9n2KZf4?=
 =?us-ascii?Q?kAauOH3B2KioTK4HhvRxHr1zBjTPu9AdnuHr4sqIBJnMbNRXVJVubRfsDYKw?=
 =?us-ascii?Q?kBufqW4UqYCzchy5zSTRyK7Cn0ZpjLgnSWe7trCyeqL+6S8Y92wg2xKps2/P?=
 =?us-ascii?Q?6Xm75Gt2Tn/wtBoECYTSXZmP1jXRhYemeC0Il9IouBP8Xp6XrLB07axlZYMQ?=
 =?us-ascii?Q?/ojfz22jBProSHo1W3FIrNDbJx8BR5r4tOWR2lpeYqz1bKo/IdWfqEa2AyAn?=
 =?us-ascii?Q?uhiTF7KnCphJed8Mk1OalAGxledtR36+VVEASf78iIV5ayFWntsY/vr7bEg1?=
 =?us-ascii?Q?Xq5ZatD8iAQ2lmy5Qn9aHN32hysW1kf9oNeSjca1gIyOMOd4qMJI3+37Pl5v?=
 =?us-ascii?Q?OSJKzyIa1yy31VFiINNHI7Boi9yDlXCV5mdpi2HTnzWJWLERBTXQ8uZxNkkF?=
 =?us-ascii?Q?+0i5wyBlpEgLD20/YLqD0mDg3Eh57Y7oVmVQGIX/VKO3PktlwgnwwOGcLhfy?=
 =?us-ascii?Q?b2NzeAMGFolWJSdhOrWL/ukPXj320nuWB0OWZf8YqBrO8yCWd4OQAk2Qd6v+?=
 =?us-ascii?Q?3WMQDeBObLBHmj08KvMmEhuNpA3QpbFxkj0sz/aAQq8FJt6vCgC4sO3KDYGQ?=
 =?us-ascii?Q?mVnqjjXyWucTIHwOFFgiLEa4R49luGC5CHO9ICchSe/3UfMj5+IQMOYDj4Et?=
 =?us-ascii?Q?vuUhe1uPSzLkEwOFHBYsbVch2ALSBupd6HBakzI9NI12+PNWjv4XMFA2NARQ?=
 =?us-ascii?Q?gT/bz2ovHh1wjjdqw340cQiGfKIXpr2baqpnF4dFQrM74zsnmKLlI8MsfRAF?=
 =?us-ascii?Q?7UQK0QrNee9H9SptuefZJ3HtWBksP55FFxbDKzMh85Ufw6HEJ9H+ILMxZRBt?=
 =?us-ascii?Q?CJPiov3H1983dN8WNXcsBxnu59zpcOKNkeGPai1al/8UK4Kw6tSWMWDodXjf?=
 =?us-ascii?Q?7JHFUNIojuiYrnq5LYf1/8M+/YHsUv3Oe1bfRTF2u0d9gkYqKDXL35DNUVvZ?=
 =?us-ascii?Q?FIMiefcrB9SCYBiDGxDA6tZpsm5YbCFQ6rt7W/GtRBpjXH7SBRUIQWdSIa6h?=
 =?us-ascii?Q?QwEcSgGHw8LvQj/Rue/w03ZikOlKFc7xzbMbGe+nQQBAiiKKZRcwolGTCFci?=
 =?us-ascii?Q?5kCv8DDcaHJBpaYqlSMV7WIBPht8mirZcOmYNRORGFRebwiVcl89CLfpUVUw?=
 =?us-ascii?Q?xUArmBvwUol7Q9iGAhNa30bWunn/BFVKHezvKUk3MU62/ci23qAVVvCCwTPK?=
 =?us-ascii?Q?qglx7A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf7454e-baf3-4f9d-73b5-08db571361ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 20:14:56.5024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: El4fmWMiLzxsnLGzON8+6MXKs0vo91CMYiVIJtCgE70/mpWG9n65Q18BfRIHQ41CGaS+n7CkfzZLiTexFqolXmXrE386fXIqqlUhHxzIzGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB6047
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 03:08:11AM +0800, Yeqi Fu wrote:
> The function debugfs_create_dir returns ERR_PTR if an error occurs,
> and the appropriate way to verify for errors is to use the inline
> function IS_ERR. The patch will substitute the null-comparison with
> IS_ERR.

The comment above debugfs_create_dir includes the following text.

 * NOTE: it's expected that most callers should _ignore_ the errors returned
 * by this function. Other debugfs functions handle the fact that the "dentry"
 * passed to them could be an error and they don't crash in that case.
 * Drivers should generally work fine even if debugfs fails to init anyway.

And I notice that in this same file there are calls to debugfs_create_dir()
where that advice is followed: the return value is ignored.

So I think the correct approach here is to simply remove the error
checking.

And, to answer my own question while reviewing this. I don't think
Fixes tags are warranted, as debugfs_create_dir() is not expected
to return errors, so there shouldn't be a but in practice. At least
that is my reasoning.

--
pw-bot: cr


