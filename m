Return-Path: <netdev+bounces-1403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE93D6FDAFA
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A707F28134B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0896139;
	Wed, 10 May 2023 09:43:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753D66FAF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:43:10 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586893A88
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:43:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXuGH3EyJqu4jhhYiTNLS1vA9iaSImCNs62VUn2mZ3Oh5nfmx+2xcL44Xvou/g4l+3khSicpyQ6SdaFf2aA8sfizq8Woa3g/Z+sfKXkjtlyiC21cUD8rOPT837Y/qOhYsO1NlV0TNuqUttMTRlaUJ8h4Rf4RILwXYpTMF2cR3SsiUjxuPyLdMtt4qOK6LNXiHmDL9qu2+a28HRowcgPk947ZkIf5EN4sRRDZf7pyWSuSa9YdntnfezYe/pXWr9U+A7NT+8+jM40mmCsKwOii8EsFuOksu/3rfn/673fUjxr25QpB+0IT5gpIeVfmoNRg5DSGIh/Ffy2vKFnNXK+72Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFQpZIZGcMdWYuhsuXyTB+VQXia/zQ7tKM8VnizV9UY=;
 b=c1b96vCIMH6sX/McejDJfnMq4suki5VirvUgz+bZ/1+uhIym2Qj6HwqUPOCN+cVSg/luD9PL6/OL2d4AxfnGeEJbcE1EVNeUNOfoUQA552GAGCBlmF+lSU3yKbKPixIFKhjUyrAoccBQLsuzm0ITeFBmD3OJKHATvyGeeWcc4an7v36Lq6V8+nB2oVRD5kVK/sUA2nbiU6b0f7gj0WyBI4QFQ8r8MocVwYc2iJCRcIkPhaIDOWDgEwSHWV0IriGzDwyN+9oux8j4a6i5oQ2LsBc7AWirNUbvQo9W76XYPVg0Saqu1AjAreXkNqADInaYN4bkz46HIOTY28bw6hngLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFQpZIZGcMdWYuhsuXyTB+VQXia/zQ7tKM8VnizV9UY=;
 b=eHjm7vZ9RacleVaQE3J8E1sKe7UcAD55xKEdCQHbWMpctLYlIbnO3B1h6cBapBu4tGnyQc8uAUGBYutkAk8Tqyd7PhsIFM5WQmYu84nAr+FOvjcm6hy4uBJHu3Qzrjbsuk3OxdJJ+S5LAWlA9Z/DBPus+oU2ZY1yLVMyCq7W2xs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5417.namprd13.prod.outlook.com (2603:10b6:806:230::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 09:43:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:43:07 +0000
Date: Wed, 10 May 2023 11:43:01 +0200
From: Simon Horman <simon.horman@corigine.com>
To: m.chetan.kumar@linux.intel.com
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
	johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
	loic.poulain@linaro.org, linuxwwan@intel.com,
	m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: wwan: iosm: remove unused macro
 definition
Message-ID: <ZFtnJaCMMFVN/ju9@corigine.com>
References: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
X-ClientProxiedBy: AM0PR07CA0019.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5417:EE_
X-MS-Office365-Filtering-Correlation-Id: 921a76be-a7ff-4592-8c67-08db513af5a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AHhqCKehTnQ0SwAypFaEC9XKiAhFtAZSr0GSi0tckgutnLqvdqlHQ9mo1tbJ5DoIQ+KbJLbZ7Eb6/+ncP7bX56Kwim/bq2X90fo/UfGQYxSTZbyeE7EEQvVSaMrfeDuNrCNfvZrEbank3KhKZbAMwQQ3AoaLgckSxLlcJLfMoWsbkXNUXLkm8rTsV5AetWmDqiySES96KJgHUCNVfVG99tsfekySerA+t0lMxkRgx7b+/7/K7NhEZIDrJp8OYRcBzWHGolFHkRT+7kLWEbBiUmgU39S72Fg8SElj7IEKA4CqfcGnLXTg2tyq85cKiRT+QZqEwyw17VVTmYmpNht+uOQni1HbKWYtWy7QVA2R8YvPmEcgxuw37e8YFf2FRXJvQyr+DvwpvjeGlyQ4Kp6YStk87LEjnSfPBtUGlY5S6FzhXBBU3ViID+PkuRcSaYQX1B8hvV9FeKMN9Fr+Q4ptqQYTAHm/ghz68RUCS6jpUfPfWojTuxNdX3RDeNcIhuh4JpPRquzZTSLNfkN7wB4aT81K5fRA+lheiWtv/TyyKN2b3h6WpMYDT6EExCQBOgpA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(136003)(366004)(376002)(451199021)(6916009)(66476007)(41300700001)(4326008)(8676002)(36756003)(38100700002)(8936002)(6512007)(6506007)(6486002)(478600001)(66946007)(2616005)(66556008)(5660300002)(7416002)(86362001)(44832011)(2906002)(186003)(316002)(4744005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0q5bNFdHViWkY1J8F0/pST0qq8LrRtGQ3eg+ubNos5wlWRcON4uS7AT53+ec?=
 =?us-ascii?Q?g/Q+uG+XuuWHuIBIl+85CECzR+OXL4ZIJP7mEici2rTazXdjPOsFRhEU6FgH?=
 =?us-ascii?Q?YdRtndjx7jklQyOCzOQlEvD+KzsF6TVN2rkYYPVTU6g8dj8FIS3/yKEOKpy9?=
 =?us-ascii?Q?3h5kbG2pi3s1eVZE8H0dAMmRjUDxfQLoZQK6Gw4ze4Tq5TN2/tHXl1MVZonO?=
 =?us-ascii?Q?RoOA9vGjcs5tpyO0wQU5LG9RuImcicDzCbegIbh48PCne3UvZCviSQHVck3K?=
 =?us-ascii?Q?LGIlWWhxixNFbb71tGZEOpsRdIPnfHxzHOIxFD72+xyZ9ASjZNIm0sbnLpjZ?=
 =?us-ascii?Q?JMd8bKQFhkpkps5T4HecqugodnO6wzUgNTrn75BH9YuRZrwA+wxxIAe7eQBQ?=
 =?us-ascii?Q?OvVLzGeZLfwvq8VzLx65IMJKe5JLrtL+iCopx9Lp3U/Kxz3qLQMbhMGsjO5I?=
 =?us-ascii?Q?+MpQdzpPNSH++q9hEWmH8443uW09r0+DOn5U5urM1BQNhkuJIsX0u5Tz/9kL?=
 =?us-ascii?Q?a4s8kR+Ited0q8JOxAeazUqqba2/XkkI4rXBCiBoKzx6PMra2UXx2toMNKC4?=
 =?us-ascii?Q?yu0HxQnHesPVQf7VldFKP04mRn1wR4ygq09r0te+e4LEukGS1gU52Q8Zq1QD?=
 =?us-ascii?Q?kYtpN4flgYI+gOz95ZFfyn3+/aCO84pao9Y9opU5R/spfzp8hq2HH9dW64IY?=
 =?us-ascii?Q?GOEQsMFwQAp1BzQka4wOt7Ii9xrQFKUjF2d8SxvcqQKMAVodMNul5Tr9Gv9Q?=
 =?us-ascii?Q?0gariZszvn4dp7sjl+YPN0vBkk7l4moqTbVpuqAY5nK4s+W2sontlrMyvy3X?=
 =?us-ascii?Q?24cMA0G0+sPOn0CPWUTQVzidKQT+XgAr43crZxBqcEtmhoE6cfMcHNA30NDW?=
 =?us-ascii?Q?OTvBaQyqBqO2yFY9qMHRNCGmmU1+mdfx21WRAgkhRQS+ZP59SsIoBrmjgDGR?=
 =?us-ascii?Q?+Aomf9FWwBhpClkNVjgtrpWXsrQclNdfsi0o+aTUKRYzl4NJ9ySfvanVF1ah?=
 =?us-ascii?Q?GEpQWq5H5uNq9dCy6UvXaNn4LyX0vcviOerUDZXet32WrpMKlGbUeIulXGT4?=
 =?us-ascii?Q?4qmnsmMmobasdwoLjkL7dIxkYHoRgbuYR0qEh8EGRdPM8cqvFgZXwGOQkn4z?=
 =?us-ascii?Q?7dwG+sKEJ81uZQz4tDNi5TAV7GMUnQckY/i+CyDL6EcRWuJLXP0hpFdUiLNV?=
 =?us-ascii?Q?i91CZuUt/bJuhWVLDLDmjBkwsiFF5FIC3mU66M17Npmra3RN8zCOQyAR0+tt?=
 =?us-ascii?Q?y9cE/1TdU52fg+ftes1YAXAxI6yiVf0R2xbnO5IRifkZw6ltHiprESnG5Etr?=
 =?us-ascii?Q?SvaAoygs4VF3Eluu87HzRLk4IWMUS98GxCoFRmmTJM6Rs0mTDYlYFCz5DFOq?=
 =?us-ascii?Q?uVLdgFHRlZND9pjoK0WoBWi5hjtryZbosiAA2dIfoLN2MM/VNPH/iQygaQtq?=
 =?us-ascii?Q?XSiD2Fjorpuvx4u+zitVg5SGZZLqAOjuN6WYezckjTobwEcv16m0F3QcD1wG?=
 =?us-ascii?Q?lT5NTKI9JdtVx/1CSZGnYLo+ohdJatbtbcvaRATJvfJr9JnVIkzbjwlN4Uj6?=
 =?us-ascii?Q?dE4y4u6ApSU3taCS+MXaDxJQF18NDrQuUgWmnDe+47+1cQof8xVvez7o9FF+?=
 =?us-ascii?Q?CSYt/xDd4UFgZUpd6+pW5k85OaW/GHtvJo6c5otcuY+7HWEnLLMVD1TA9uKd?=
 =?us-ascii?Q?d6aeIA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 921a76be-a7ff-4592-8c67-08db513af5a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:43:07.5511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztH6sd8mrZ0JL0+Euezj4IRUC8hO4N4Q1tBDOdMz4J8L99FntNTmU7grBKUOOEYCMGzuUqtEFmenSciQbIHvd3Z0GH90kXHraKv8PwAdlnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5417
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:05:55PM +0530, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> IOSM_IF_ID_PAYLOAD is defined but not used.
> Remove it to avoid unexpected usage.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


