Return-Path: <netdev+bounces-3381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A366D706C4E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E1A81C20F38
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C38FD8BED;
	Wed, 17 May 2023 15:12:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B141B3FFB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:12:11 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2090.outbound.protection.outlook.com [40.107.100.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BA5AF;
	Wed, 17 May 2023 08:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LN1kVSuJ12eCWkFuB/F5jhjpfyLWkY2yepNb22fjLw11VM5SWYF/agjtw6IDCZMPB17S9aNqM3GcNxAJ6RnIFqr4Z+e4n8rU+FkjpkiYqF8uuLYV45o8+GWJYM2bGgyfQL1avWUoVZ9T7l8vtKX3jLxNTQGIMFU/AJ8q+AXiKTKbhB9Ok6peI+xmIeLBFusqzaignp9vYnzaGvGqXStOP0kV0HA0N4FJMxg1OzIQN0mOBsPi8O6AcubiUXIBtN6nHkgA0w4YVd1NXJrIKKaUgc3BDDjYLsYx/K9Ej8I97ugWGm5GoQ7hOYdtz+wFagsVOrgU8fhSWETQfjtKCwT44w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHwHw/yL66Vte5LMrPY0uSc4EHT25UDHBGv0iNB2l2g=;
 b=RF9j0S+15G6i1KnF2fgAAA+TfqoqCvrt9sGQUll4Ewr/cv0jfxc+rsrrto3MKbIm3/pYrFNyptNwXaP5NBfMI356/aF1YWCZ4V392Hh0n9DvjARwD3Z2kSFkgp6+hpmauuPQFvDh72hWISkkX0hrB6GSkMkQ311jl/mjENM+16a0YlKyxfE8mRiqYf9EImtirEnynSMjQaIp3o5KIJRmDcICxfkvmbBpbx9eHKFRAvOgUkntq2bN4NoWdXl7vO5CM4tdq1vX3E4pM6ViKqjOeLze8dMTmk2lwr9bKkLGUKp7nVwk6SG2OI8CWZ5YJ89OSOBR7M1bOB+4nXZ0CxU+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHwHw/yL66Vte5LMrPY0uSc4EHT25UDHBGv0iNB2l2g=;
 b=FCppwAxpILTgDxcgjE+2VNQ/oxq+aBdyNWolp6VVRBKtc1Q78ffrkhByplwrfHc2FHDaoMqPRfOl1FIxYQC83pCWSUrv54aEl+7jf/6Du7qhV2H6eL3bilrRUvaL4SByYuKDK2NMA9C83jN3EtbPOsdqDFuNeEWSHa1z46j/QEs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4707.namprd13.prod.outlook.com (2603:10b6:208:30f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 15:12:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 15:12:06 +0000
Date: Wed, 17 May 2023 17:11:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tom Rix <trix@redhat.com>
Cc: johannes@sipsolutions.net, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
	ndesaulniers@google.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] lib80211: remove unused variables iv32 and iv16
Message-ID: <ZGTuv7ZAMyvELMqK@corigine.com>
References: <20230517123310.873023-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517123310.873023-1-trix@redhat.com>
X-ClientProxiedBy: AS4P250CA0029.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4707:EE_
X-MS-Office365-Filtering-Correlation-Id: 299991e7-f918-41e7-8f17-08db56e91384
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zCvup1TzgDjsOipRoUWF+XC6sbQbrk/zStBXtjp6HmKsHLAX2CWe/f/pstmJlwstH9DipnGLJxf1KC+gANCDlov2FA9y/O9/x0kkYLfSJP+BC+CvaoSWn9u+p4NemSNWTE5vt7AoDhk03XwHz8vUZn4HWlaFSKj82L1aNhI1S3NuB+F3mkgB5zBeq8PPBEyOuj5goo3a25pCPpC6qDV8W1Pf0I0+JfYtYadGrQJxG6FYi63gatHRhtDESbwl9HTbAx2sPJoEeCoFDkvT3q5rijwc2MImiB0TYXdvNUOA6uJYipETM4OSjJ5yAnAQ5KDs9C6AwPsRlAn1yElSN1eNTMqH3rXP93vzYYqDczfDcsPMutveqCT6pEAHmSV4H26KUNIP8fyZIcTho0qPAIkGRJghusEia9cWJ7iDjr7PEIWhXSPSi+5pknV2RB0fcbA5lP/Jk5cn3mexANSOsXTkKRmeRZvF/5o66NCFNBZvMzdH5F9/eVoHZCiwXVjgN0TdFBjhe3+VABuDAiy9PEyO8Q0CdqztKpNuZMlezLChhzIFjQXJnxolMWKL/3sjYnCh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39830400003)(346002)(366004)(136003)(396003)(451199021)(5660300002)(7416002)(44832011)(8936002)(6512007)(6506007)(2616005)(38100700002)(186003)(8676002)(6666004)(41300700001)(6486002)(478600001)(86362001)(316002)(66476007)(66946007)(66556008)(36756003)(4326008)(6916009)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hAPfA2K0wk8iyv8v5RjjxrIy4RD/RXnsbTv01gVC+TkizTP/DXse2gA2+IP5?=
 =?us-ascii?Q?//r+IcTk59W27Do3NXjNllQ7o7FeKw75w9Vv5cnMu3BYVq/DoygTVPO7FFfT?=
 =?us-ascii?Q?fcvsBCCiU8bsaCFZ3eB6O2A825E3RF0BX+uizhLXrEkCWAIff1LDt5hf4R6j?=
 =?us-ascii?Q?NhQ7r/a2EyNRSjnr+Say/R7vGkeM7w0biYmFLqTCogM2WtewrgWbFg54gma8?=
 =?us-ascii?Q?ykXh8Rg4B0eCnE5rXeIeoSTMKKqddmJCmTZfmvOEWWMg8dR0ImKOvWKyaV9s?=
 =?us-ascii?Q?Di66AclXQpCzb9dukXZPEYErxNWbu99DulqEA2+WyLWjFANo1B+TiU8mYwVH?=
 =?us-ascii?Q?FhLN93/gLG16XnVPQ1TAwKzyosyFoVJy/ewloDja2yowLJRA/K0Sr0URyNmD?=
 =?us-ascii?Q?FlvsPIu8UbeBZvm7gH4EP+Znn5nj5rsvrVTbW9M8y3ALvIFV9XArCt7Cn+xM?=
 =?us-ascii?Q?hC3sWHzmaPZpPvadMgUg8WrZw/qAbIJy2q2s3+n3N2T4zpmgALeJN1SPpj6k?=
 =?us-ascii?Q?vAoFE8ns0NMTQlI88zKGtTiHKFQ0aO/vQrii2UxK1wIulJa+OyIHOr5F/v+2?=
 =?us-ascii?Q?1NEb3SayS2U3Gfc9JQ43b8LNvsWdfJ9oyTBohiKQCDD1U4PQ2uNojPQIGjEz?=
 =?us-ascii?Q?B76+wAEp3wOAXVJphaKykSoH9D6XIEfgT3jQ6/fcZDi26tAigJc3+DGGs52f?=
 =?us-ascii?Q?Ua7iY8e1l9oPGt0P3JUDlikqrlrXdCIi2Oml20gPRl2dnQ4gpcALo/Sb8EJ+?=
 =?us-ascii?Q?/MKc6vKrXVk+DNLY3gyX54SE3qJOio3ug7f4yPzmq8OJ9/mh/eDB9vq9G0j4?=
 =?us-ascii?Q?wgBsNs8lGccAOgLIbNWvHIv+BKx8clQrAn/h8H8YgD9/5CYS0x5CfoOw/D3v?=
 =?us-ascii?Q?j6+gy4SDGR+jI8gEWgNOdbzPjh07udZuz3jfCnqun52sGnnwJgbfR4yNyK7C?=
 =?us-ascii?Q?G2qPcRqoKW1UxCnUtkTnkDA+OjdH2GSKE0oHMAgsRPLG9As+nrCiZGW8rWd8?=
 =?us-ascii?Q?DFS7A8Lv65lrpO0K0foqUTThBOfdGXw8ntpeI3wIM5QgEH7j8KCa/F8HaIeC?=
 =?us-ascii?Q?T+zC0lOov2l32IN9yUGQPlJ8eRgj4B/ddBjadPbAIg89XBuxleoyPkyYYyub?=
 =?us-ascii?Q?7MyfkeIXelnNjJ+hMXs7MZ7sunOslXAtFCui17iPg36jGl7swn+3i37CotQY?=
 =?us-ascii?Q?k59JXbiJkmz6D52hP7G+j7/ISWSolV28DCjzfEgK9COIm7fN3k5sDlAazQ3x?=
 =?us-ascii?Q?gSiyGfd8qAhJ4AqeO8HUAQIOUM9u1Hsw5WoYA55sMjRRQNcy01VJnQekf84c?=
 =?us-ascii?Q?M349oc2nkBJbExLS0xtHsw6ctChDkC0czVxBYdbxD4bswQc7X0HwV8aHiwPD?=
 =?us-ascii?Q?rt/rB+u/8IHCcHZRcHUaPqbx9/7COUEMzOZ1v5gpp3S/erWj4Wzhqv++K1zp?=
 =?us-ascii?Q?/bSmJHvnH60iNNgQdblqB8QtHFJaXcZpLTlbG7ublFe8bz9oejsswk0KFuUI?=
 =?us-ascii?Q?VJNV1jdjmKUdQkGXlFA4wpCYoFGt5AMb29UTuqJNHih8S+6DT2A1jUg4Gwux?=
 =?us-ascii?Q?gR/oPzbr0/ZqrgG8IksLyee7GeUgLMZ08zpeIbYRqtrJ7J9VaTxBtY0UOOTz?=
 =?us-ascii?Q?qIa92A3VU1jM9nGMGeWMQ8aspVyrr1MnnF+uMkFbvG4FuJCjETOApvCZbv7y?=
 =?us-ascii?Q?KmwwrA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 299991e7-f918-41e7-8f17-08db56e91384
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 15:12:05.9964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nnurj3uh/pzRymRdUydJ8oGRjCZxNvYXP0FtT4aOy/1YILwG5GJ+a2FHlnXqIDGw/SyX3l3B+nj097Ymbv9B/49kOiOLqQJ/6dLqWk5R4kw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4707
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 08:33:10AM -0400, Tom Rix wrote:
> clang with W=1 reports
> net/wireless/lib80211_crypt_tkip.c:667:7: error: variable 'iv32'
>   set but not used [-Werror,-Wunused-but-set-variable]
>                 u32 iv32 = tkey->tx_iv32;
>                     ^
> This variable not used so remove it.
> Then remove a similar iv16 variable.
> Remove the comment because the length is returned.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


