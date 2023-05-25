Return-Path: <netdev+bounces-5255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C50710702
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F752281480
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35D3C150;
	Thu, 25 May 2023 08:12:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF54BE78
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:12:33 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2113.outbound.protection.outlook.com [40.107.92.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BECC1A6;
	Thu, 25 May 2023 01:12:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwLRWsUU4VhIfZj8dexxfw++QAJa3b+C9vYRp9RdQEVVXFijYcsOpneEz36i2diCJbjeOu3n4A7tYNtvZo2J6h+W1Eqn45zItF2uhFoukvjSeaauynV1A68H4ZTPCFIFXuSRIxYGu1rI3s+KMWPmmQ+p/pIbJUwbrvr/Kn2E08QlDQMT8csiRwTY46f21IQBlHAIIKFVKmOS2R2bagLdUPJNilztlFrJw529VHSUkVfdahLNPon73Il5z9f4+Rox+Y6xj7E4c1pKZMONtxdoQj62p3P0CJDJxXtqjL84qcDk2E7fSp1ATQO5GFXuMjx7GNshHr4vKPsdAbwo3R5Qqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0fAlMIZAxgukyNINM+zUAWlgyHggETYvrKLHpoDlig=;
 b=S0nna07uNQtVVkF/scqFEsbTuYP3CYyvkN9E4QtC51uCX/S9d6Oi1Toxx3iiDGbnSoYOg+oJrNySE95/ZzzIZO83BgfTV9A3/jSjdDDGsGcFFW5UyCpECUoCmmUQMWycBzdh+dvmyXvxVpupX3P9pzIwF6+YX//n0LKsU7JDUn01tROnz9br0wdGPf5FWIzcLoNH1OsLulsc/rjbZyGB1Ta8hjmTRTt6ssc3AbSsDa6N+K9dWNLkh2B4Mjk8KNdWsGid80YZiU7p7cwes7Z3nlmC1wUviIaubJxXFClrPitmMHIUXzxwhnx+gliXMmMSgzAZGjNmZr77o9aqfVwrlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0fAlMIZAxgukyNINM+zUAWlgyHggETYvrKLHpoDlig=;
 b=gu/1LVjJB4AS8JvhNvO2ad70nUQ2n5N575+jb9TQe1UA41FlXhx5TxthoU1Okx8pXBrPN3Oo8swigthKMkXivkAqYeBd/k16Xno/Y7Y0bKhdgVELO2WJXZoNHAUpt7y7kkwW2ssSNsz0uTYLs7ISgy/f5+cxqOl7ysO0ce3sg4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6528.namprd13.prod.outlook.com (2603:10b6:408:1a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 08:12:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 08:12:26 +0000
Date: Thu, 25 May 2023 10:12:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Osama Muhammad <osmtendev@gmail.com>
Cc: krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, nbd@nbd.name, ryder.lee@mediatek.com,
	lorenzo@kernel.org, shayne.chen@mediatek.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] nfcsim.c: Fix error checking for debugfs_create_dir
Message-ID: <ZG8YY/r8BLCzw93q@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524160352.19704-1-osmtendev@gmail.com>
 <20230524155506.19353-1-osmtendev@gmail.com>
X-ClientProxiedBy: AS4P191CA0043.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 93edf731-1e9f-4ef3-9db4-08db5cf7c699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Cr9ILz4Km0JXZJ4dvWwvRAPKRHhIyj+GHaYeiyEri1i7+/l37ZVTcoSjKKz2CibKcgLV1GWMRtmo5OjKR3oNhUoPXfxbMsUS5YiGo6Xdq/S0OtjVO7X9lkUkUZE4REMut83PO+Hxr1LBwekBBroByPrUCJId5s072nPL5UFWvkNQZL2f5mh2OP85BAXXUpL8XjigVC5m5XSlHrd0BjJnY4eZGhf0P6wciCSJ96KV6iVlRuRpnSSp6sJJPOuA5bXXn8Q/VEc1zu45ozL7EVK0lsYDS4LhIzeksXKLqYaDG7Q9pFb60QzbzuSK5HlsrRfQIQqRxsjB3gob7YAyTEoY7T1wV57iLzIBt211ra0zGzqlF0+dqNNKgGxdSi0qg/InDpFwaigZPVye8uq954UVC/jJs7eYwzSVqil6LRaLwG9j+84HsM8mlxOrOdxkzVgU85W82gm8k5u+O5pX7w0/LAQHFDLq02reI/IuqVYCEGCv++K34llMvp6G7PgbgxE+gnCnFJB2/LXE3bz3EuDN76NNufERlIymsWOUK7C0TNI1kZaSLuynjqPTIROBqGBu6kXqhWntjpACW4tyHTDgSFrc8qUX2ofqMkHjsMH/IIs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(366004)(136003)(376002)(396003)(451199021)(66946007)(66556008)(66476007)(36756003)(83380400001)(2906002)(8936002)(8676002)(7416002)(6666004)(6486002)(41300700001)(4326008)(316002)(6916009)(2616005)(44832011)(5660300002)(478600001)(6506007)(6512007)(186003)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mwXNdBD5HPS2eCdpuNJ6KcmRoXNHNqTihZzaTfH72R/pCNbOuJ/efnhENG9G?=
 =?us-ascii?Q?vZk3NiWw+htk38vELLXHwFfwz3KyB167svr+vLfb2nHNpKHfnhPpJm0zL+a9?=
 =?us-ascii?Q?YjPlQp9kmK0jf+IzjcFo2qxLXP/9AWBHMzIR0UPlGfhCRfDNWnvkPstphZ/2?=
 =?us-ascii?Q?WzKLWJedfLWxuzwN4yUayRCSR29QkDWmeqctMTru92fhL0IiTfZZH5xJvOFa?=
 =?us-ascii?Q?T3zxf1wksfaQLNSuFnZhFGIKJ/ab8swM7buU0rqRCVBh8Wc2CEuNODsLTXyH?=
 =?us-ascii?Q?vL3g1X8DljNxiOZ9uIpqs2gCTnbvfnKJaKT/qjLdLiH+7Tc1dlYvoaBUr610?=
 =?us-ascii?Q?Yp5/7SmWufVe8ZQLSKt7x4qVOjLgFj8h9ZpUYysuWCoIm5+duaH7EB9eWqZ8?=
 =?us-ascii?Q?J9Wbj6z2OfmSUN++EbGPf7yK1PX0KaoPQ4sIrPfFQDneFtaB8x5oYIHaF5kq?=
 =?us-ascii?Q?sXwQi9tFMf0YTS5ALoRH6sU4TT1x9SEM+Zv3ZBxczNVjr3WWmC31jKe+c+LI?=
 =?us-ascii?Q?MXVCkzKC1KRS4aUvORhnbA3SOyLzaqxI0ZAUFMecVX+uCg4eNfXCPaQfSODV?=
 =?us-ascii?Q?W/tgQFLYbpBhU6XRqJeION+CsM8slq2k8BAs/KkddFJmCAJi82xMUJGpyNQh?=
 =?us-ascii?Q?uwaZB/YWytDjsVORalbG1Q3SjjkcFoEzBQzcDTlD4aru10f7HiXBSOi23HD0?=
 =?us-ascii?Q?vkQ8rGwfVOyQxk4/CsLwnTf4pBVkNZXTxxqndkuFqts+7Xu7MQjjEbMguvO9?=
 =?us-ascii?Q?35DFPGRxbFi5QIGvQHCI0mq5SXGkSFlSItUNYKiI/UWnIC9fFOYoHnZ1z2aM?=
 =?us-ascii?Q?RLDPzW3fb0sgqNnHHbgK0vpbn/MdkS7UD1OFR4+Y0G25SXpXilscL/XMwc60?=
 =?us-ascii?Q?M1K+alljQoj3sC1NhJRRCkaOxINqraeR/Wz1L13HZ3wTtY4So5Ceri75I35C?=
 =?us-ascii?Q?0kV4t23Ua/uC0Ei2xyPCZhvKyn+Ia9ZDpz13yCmOq4pL1z9Ngz5QTQLiiE3L?=
 =?us-ascii?Q?IdAN2Lw9WBGf5XoTEjcLAnt4DfxECScGbc8Hppa7DRnww8PdYWg3BhxFj4x6?=
 =?us-ascii?Q?il7KQdOTFCqnXchf0P0aNp1DlO25tivbfhsy16U86RBJMAlQXpPTR5CZLQtx?=
 =?us-ascii?Q?LYvtQd0jiPu8/bJpuid9mftV4gQwGAytEel7DDnhjaWIn5Yx4uQHZNs41yh2?=
 =?us-ascii?Q?wyjtpING1k6oG2hzVy8cFqDX/AFhwprD0Fbsi1elW9iUnShzAxyjaP/eWTli?=
 =?us-ascii?Q?t6V99/Ktodjnw8Lb8sjXfPF7DwjCSRBgiX+6GA7gwZcH2oMiL0xsS1K0uSYP?=
 =?us-ascii?Q?JXS+xWxPy3ojV2DJXgAJC1tDWvlXPeCkz9z+gZ4CiumM0WO7my90JB5LeLDt?=
 =?us-ascii?Q?KqGW4qbgXHW0ykgME9bBbOONw395wRFL7xeEF5D4LstGPILR0yFVDD8dmLsY?=
 =?us-ascii?Q?srZ3YvhOGHmVU+krVP3r4Y6/Zl4nGPMnCqqzhJgHetE3aKrYKJHhTSfGH0Qd?=
 =?us-ascii?Q?WZy/s2dvTvF7HW9QHULEuEOTKSZ//fSPSw50LNkn5CDEUPbCUNDPwQJ5RRN2?=
 =?us-ascii?Q?up9qgNHHcq+agEJRUPL5TvntImuIbUk8P+C4iMuj8BSIzu3AqlxdlmLW+f2q?=
 =?us-ascii?Q?FSYqozWq564Wy85EHlMzheZVEnLIHke08Zbn4yX3c5bi8PpLqJlNFn6PBm2R?=
 =?us-ascii?Q?Sdu5Xg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93edf731-1e9f-4ef3-9db4-08db5cf7c699
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 08:12:26.4396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6tyFjxUxmCw2ch/kbbQ+KVNQPhm6Na0JGUFxp9CdaAkgw/KSLoLgMmwNWoqIhoGdvYPj7E4Iw8xT1fjDigIkgWSH1/HkbnIB3MNCsRNOez0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6528
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:55:06PM +0500, Osama Muhammad wrote:
> This patch fixes the error checking in nfcsim.c in
> debugfs_create_dir. The correct way to check if an error occurred
> is using 'IS_ERR' inline function.
> 
> Signed-off-by: Osama Muhammad <osmtendev@gmail.com>

...

On Wed, May 24, 2023 at 09:03:52PM +0500, Osama Muhammad wrote:
> This patch fixes the error checking in debugfs.c in
> debugfs_create_dir. The correct way to check if an error occurred
> is using 'IS_ERR' inline function.
> 
> Signed-off-by: Osama Muhammad <osmtendev@gmail.com>

...

The comment above debugfs_create_dir includes the following text.

 * NOTE: it's expected that most callers should _ignore_ the errors returned
 * by this function. Other debugfs functions handle the fact that the "dentry"
 * passed to them could be an error and they don't crash in that case.
 * Drivers should generally work fine even if debugfs fails to init anyway.

And I notice that in this same file there are calls to debugfs_create_dir()
where that advice is followed: the return value is ignored.

So I think the correct approaches here are to either:

1. Do nothing, the code isn't really broken
2. Remove the error checking

-- 
pw-bot: cr


