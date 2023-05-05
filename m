Return-Path: <netdev+bounces-574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4176F83AA
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18D7B281070
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F87C12B;
	Fri,  5 May 2023 13:16:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D7A156F3
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:16:20 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2117.outbound.protection.outlook.com [40.107.94.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3F41E98D
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:16:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7yc60bpE2xL8pfa095FYn7xsLFyq3WlLMrkblR5twClC59Gl7m9ES+MfD0J4hWjfnzxbAstAysAfNAlZvKEZUEMpthTQqBxRtNNmHquYo19gyvnj+tZVk+McffiKDxFUbDhwF/vXzTkzxpApKWYKxBVamd+G/g3RGUriG6tVwjyY3nxdMSVEr9kQWr0fH2a9aYw5l1DfRIU9uGOpIxbhiXhhoJNlg8Okv9vGGWZIG5TCmU/ypWTNBMW60aTuNIsUYAyiUzEhgRFFRMKdBi75j5eL4miO7TCRUHAGYGMnTyd1/hjAZlap1/pCPCq6a8I7u5yG32f1tJyTz80KgcM3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fdpu4lEIkLmFKhfV8Z6Qjo5ELkOEeUs9MRNCLbDozeA=;
 b=HKSWP6kLz7rvb4tBiWlDik6oihOhQOsnGyyp6smV4qFm9T8BAtzmNpnY6sPTbCv54B551Wcg5XDeq06UGzHi6Bw3rZDSwMfWLwFMg9hP+fJNhyOw0qf8VHo8YTmyHc+1Cfc0Si0uOisJUl4Cp+PFJp00UjQft8kH9FSe7nO1cRHcoLwk6plV18flyopLow64vj3LLUDQowQc1g+wFRHlfkjX/lFgY+h+NJaeQuLhCdB/ivmIyQtOxsEV/tjUqkcRWO7p+sYQu1AMx2R1HvlanJml/4CVBT6bQPMYsPIOjPBmX0isIoV7ij4GBOm0vrGA7qSNcA6rCMi5LFdftMFc6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fdpu4lEIkLmFKhfV8Z6Qjo5ELkOEeUs9MRNCLbDozeA=;
 b=CsHDmskDAcTMFlAPBBK3FpJhgOqMl6yHUGv3BrqUOOJauDcKKvo4bJXsoTMRix6WY6VdTbVPyOmsUUTVaADnXYLm7Pu8AxdlNehqXgDYSfgwEanH2cmswnUbzZyys5evuvy6YRANh1rCFarwleEUY1kItctxKoDKHTl3zch3nWE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4555.namprd13.prod.outlook.com (2603:10b6:610:61::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 5 May
 2023 13:16:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 13:16:17 +0000
Date: Fri, 5 May 2023 15:16:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 5/5] net/handshake: Enable the SNI extension to work
 properly
Message-ID: <ZFUBm/jRSfmr47CF@corigine.com>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
 <168321397496.16695.17457090959897234928.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168321397496.16695.17457090959897234928.stgit@oracle-102.nfsv4bat.org>
X-ClientProxiedBy: AM4PR0202CA0014.eurprd02.prod.outlook.com
 (2603:10a6:200:89::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e6f7779-df29-456e-17dd-08db4d6ae8fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mii+J3nmr+Bqo0PjzzotO2CZhz0xeo6eWq9HA3jER/DCQl1D5+abjUAIKt16PiGQejux5lE9zstwe6217TUKaWM0WCTjGibz3DlPZJbvYP4cDNtLU4YxEL67zht5NIU5dIWbDoqOxz6CcN/aV/EmMHRgqT6iP8blDhHd1nehFnCc0a7H57MZvp8SQcz5C9etszdT90Jcr8noyMwUpXq7Qf7w/yPs+i6sHN1Nx6hAP2wTSIWv+b/AeWis1pMmtiNobn1oCx4bu12Jek/nAWXzweJYluZC/m0atG0QpguxO5Fagqp6gwfMaX8j0FSciMpuUr+surcAwZCgfS2fmY6sRYZ7dWCU362cuASZB0hb6y6txE/4b8N39JwZ0CXPhvC9Cp3Zk2EE4RcvQpHuAFZU4UIOopHNAesxUNFGr+sIHGo3HxdfOko0+Bcamwvkc50RmmgCBUu5QtLXqzuQSXXdiiVZhAGS4aEjtB7h1JrMetsYiSV8/Ox2v56ucAL6EsflyiFVr88JSiW1VNrQBLEPv0eVH+NchPwEZ5/rsxQag0TioYKqUgnMTCGjK8OxqqSY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(376002)(346002)(136003)(451199021)(2616005)(36756003)(6512007)(8676002)(41300700001)(6506007)(6486002)(6666004)(186003)(83380400001)(8936002)(66476007)(66556008)(66946007)(478600001)(316002)(4326008)(6916009)(86362001)(5660300002)(44832011)(38100700002)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BnlaT/8DxxZuMyuLSGduUrFWtRBvNLVxByn8iW08hBjRNzYvWCe26pGJHtNb?=
 =?us-ascii?Q?4oYbZKKrQ0WKCEG67CL/4OvJoKTVjwOdnTJ0XwvN6z5crjoLSHesmjjCqP4r?=
 =?us-ascii?Q?0t2dxdPYsS5s+xOHa/62MrOu5b43RNlORwjXnDbG7iWHVstzwYO9PM0YvAnB?=
 =?us-ascii?Q?ra25jVPEgRen4eKYO3qg9X9DWjYPy4Y3m/kDgkaHsZMhg73HUi7s89FhoIIP?=
 =?us-ascii?Q?tW6YaDITAitv74Pnxa6iBmF3XUbR34segHGctPb8T7CJSsXB3EuMrySSWAm5?=
 =?us-ascii?Q?YQaGNxdZVusxtCFEQInhOR/Zm4Uqz/0mOO4rq3SY7szwSPBw5nGaSeIj30Zj?=
 =?us-ascii?Q?+K4o5j+Wdj1GQeZpU28W7B5a2TJMhJbTiIJniEJIcBrpIhRXKIxnkmzKLKXM?=
 =?us-ascii?Q?W3ZqAYKqNfP9PACOwq9GlVPgT1PqxOaujIdazTXhEzBYo2nALMFUGvn2I6V6?=
 =?us-ascii?Q?oF1FkE8kQJ4M1MKfbrJGyUs68Js9RQjAicduN2ZcnhKhK3nMxJKQ1EC8zZMb?=
 =?us-ascii?Q?fkdkIIOaoLM3iuM+eD/PmwqyDI/qH4ZxDf0/lmKQn3r8+cl3x07ZMtfU3my2?=
 =?us-ascii?Q?FGu96StaIeHnzflEdnq42WDdswy0fDGKl/ZbQJeKOhQf7cvO1QZbfMIj4gfB?=
 =?us-ascii?Q?gOaU0MolpioZEFXzzHeizNXBxPNRvtH5cpbLNyDk/KLA14qCk3TaDPmpZEa8?=
 =?us-ascii?Q?6FTL4qwYzQHMdbmz1nSRH6KZrUOqQAMlbTZz9Z7DJUbJXRjTm62WjW0nCnRx?=
 =?us-ascii?Q?es5fJmvjIsMrTQJs7uoyu4SBQxdOKgL2hkQjOOFnkBerAj/gwOmg3QII6ap2?=
 =?us-ascii?Q?yBj5cOMMQONPL3n7bgLp/FHdixZhySQWS2x9liLTnb/FYpL59WBWMXECH+zQ?=
 =?us-ascii?Q?+1+5Gcy2KmMNsv5H4cMxrr8cIe5C9+1XSvpTGtp62OEaQh706UImlWX4Kh98?=
 =?us-ascii?Q?oYV3BIGQTyvX7omnclJE+kUF93bmiOHi1KFzcqIWsGRZjm8QhbhEDTckbEZF?=
 =?us-ascii?Q?rh8WiWCWAq+a0OBjQ9f5is5nPgL10jDtP4PjqoBnMIl75BDO9tShQHzglLNH?=
 =?us-ascii?Q?thnJMXmiIvABG0KEdlGn+o5Lvyt+F6ZggS80DwLorQVHjvzLPaq3zgXMrYZI?=
 =?us-ascii?Q?5QzW2RLJJNJtp5pYfEmxLweObALvRpiom1Ml7Ja/XUAZgAQQdmTvGsDR/2D3?=
 =?us-ascii?Q?RdI9vgHJnBYHg8WmPlxP49sC2KxzvJ76VibTsbkNuoV1Ii+WpuJxUMop77Lj?=
 =?us-ascii?Q?wN8l+P2R7T+iLzc6PceUrEoGvve5yrLuLGTXfiDj8xvM3tc/i01CsOa7T7M5?=
 =?us-ascii?Q?+FABvmM9rmp1ihgGfKE5nspF2o5ivbFS0naEpqaqowtiaiH8g9xTWUULwYwi?=
 =?us-ascii?Q?pOvWnmhxiywF0lJ5J1yIGMaD3eBtGRccSAAuzMaI8YVSxSp/4cTtD2HW72xZ?=
 =?us-ascii?Q?4fVxP9Dqzj/pB5KrOxro4ppOKeYNjb2oQMM748sqKgHevWeLInYKFayCFH0g?=
 =?us-ascii?Q?SkXy5P03mhBazPmJgEi+5M3A1CVpNV6kyLvnNjgTJsPjNk8kuVyB8N1CGD/S?=
 =?us-ascii?Q?MVnl+ct9Ck4kNG73Ehi0HhmZVwfI45NQ7WjCdnNRTP5J/bVqcrDsRaMQePq0?=
 =?us-ascii?Q?F2hxvVMz+JkUjQxWr5YRHDsrZowzDvPJgAG3Giq69wurg3MOkGKQZhuvKDbV?=
 =?us-ascii?Q?NVd46w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6f7779-df29-456e-17dd-08db4d6ae8fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 13:16:17.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jYksJWfV1+tbXLC/97tI+/+V8dbUhfRG9lUxf3bxAxhfT/RVV64pnK0ub1BlHcEGuafYWNiwhDiO2h2wZy3Do2jq1Z+YdigcUyrkl7BU2Ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4555
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 11:26:17AM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> Enable the upper layer protocol to specify the SNI peername. This
> avoids the need for tlshd to use a DNS lookup, which can return a
> hostname that doesn't match the incoming certificate's SubjectName.
> 
> Fixes: 2fd5532044a8 ("net/handshake: Add a kernel API for requesting a TLSv1.3 handshake")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


