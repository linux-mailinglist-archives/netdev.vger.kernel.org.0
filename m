Return-Path: <netdev+bounces-2222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B07700C2D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B681A1C20F80
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FD71428F;
	Fri, 12 May 2023 15:44:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BD624129;
	Fri, 12 May 2023 15:44:44 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2129.outbound.protection.outlook.com [40.107.101.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33E440CD;
	Fri, 12 May 2023 08:44:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxELYTbiK2QwClKy7aBbv6FUJoVa5zd+nlEntu39QNIcIDrXmUixBzhYCGhV8MSvR/N6ndsj/MGimhF93BciPqQ4Jq18A0JXfZWj9M3QQ/yEBrgCSQ36UgbhW5LxbF09wNlYBpljTGSukpSoyONRye5E6TR2lPUYH8h4LbVLs1E41nK0LLEK1ttRXzA49g4vLLaQ+liKopKCTkaeA6cIePE4UyQJSGLPZpBVfylmcTxS7CH2WFdl7IY17YMExGx2yE5TR+0BQJNKxCC5B/89WIpo9fAuF9RZtNko1l5VWVVpv/y3pGKOpan7BSPAA/in4zgw0ynXyLThv4dEjv2dFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sORp4VGiicle8t090dYBYejx5kDllFnwr3al4Hq+RWQ=;
 b=FP0tsj7/Av54SCcpmfKFcavZBoxlSR/0a9Mi5uN7RW61ZxaIw+uaxuuN2rXX4lNzcd9oXWZvpxVYyJs5ZnF4cAXRfisJSytbNF68BboMpHv0Vd+vTK5lwsya7M40qs+w/fZSR6EYkm6INfgvmyRXctLupGrqe36LJjawnicqQ9Abjyqd5iEJu0mFEhYmaazmhEwzz/Krv5fAjN+JwSc+/K2dtTxhcjFAgTmAcmavsVkQuChmUnBgSh3wtX8LNIv8xFlbQCkL/9rB6b0X2ycnWRxEV16PD6KWh8Fv/AkTxoDMhVJy0uggI8pNyqejn8R2BQsW28m8jST/J32eLyy+iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sORp4VGiicle8t090dYBYejx5kDllFnwr3al4Hq+RWQ=;
 b=i7VZDS7YIQeljun+YPywUpNmtQsYIBuFpwbvVJEPY/JWsekALzFH9ZPqh5CJTekShvbBInZfegmillhhgrSIiF+WzsukZWh6Vq0hXlRGqWVd4qWiUGpwmVlKtBuDNs/iNLFswkIZA/Cz9tTm8rLdGyHaoxwW8pvXG92WUm/JtdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4491.namprd13.prod.outlook.com (2603:10b6:610:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 15:44:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 15:44:37 +0000
Date: Fri, 12 May 2023 17:44:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
	daniel@iogearbox.net, netdev@vger.kernel.org,
	maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
	haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Subject: Re: [PATCH bpf-next 06/10] selftests/xsk: store offset in pkt
 instead of addr
Message-ID: <ZF5e3t+8yWePd1Lj@corigine.com>
References: <20230512092043.3028-1-magnus.karlsson@gmail.com>
 <20230512092043.3028-7-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512092043.3028-7-magnus.karlsson@gmail.com>
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4491:EE_
X-MS-Office365-Filtering-Correlation-Id: e5106c20-81d2-4355-7691-08db52ffca7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RN5fy2CHZj7rVdyKN7ZRq3lMhvuDvAqb08sT0jIcI9tnOgk69KQZUxlB8dJ2D/IFu9A1I4u8BNQEElYo7fqts7ZppKmw0chMBwiKSiwb54VnDalUR/EV15JO9iMwXLjUYtKTlBLJEYH2ja1HL72tjnYCshZ/hDgnSRinW+S2n6dV7M8l7eOPhorjAb6wjoWw+Kmcc3tf9IsLLh8aQ3tb2K6CoWUnIgWWcjvp0TT7aym9zqF6lSBeow2drSru9tjKX2jKKI6i/rNn7McVuVrYYl88VORgaZvTiJryzRrImmUgl1dn5VkCBLrftulGX0RA8P/xCeuD+fO7CMPSGZDBRwbruFcHZ4YuIUKIKiZlp5Ko0gCosCLkqF51k5KQe3H9y1JVMNjNtZ0aNO6xPrQKahHaFGkHjAcerQo9d+gvxaoVc02Gf0azYDyp1vd6819m5mYV3qODFeD2vxcgsOhwczVEOJsbRN6Tpf4C+F65/1QxXh9hOs1jSL6aDl8FNskHkIGpKkmbf93tyVIZaxEP36uW3j88uHIaPt7E7L/mtSyswdt7TH/wppRMHirIjWd3wrXoRCeJiGQBovw/hPhcZX9RCouoX8YWWKZtz9+AP0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39830400003)(396003)(376002)(346002)(451199021)(8936002)(8676002)(44832011)(5660300002)(7416002)(86362001)(2906002)(2616005)(36756003)(83380400001)(6666004)(6486002)(186003)(6512007)(6506007)(66946007)(4326008)(66476007)(66556008)(6916009)(41300700001)(38100700002)(316002)(478600001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PUH8+FjMrF5UYpZfGhh1f1e20NbJ+6pLPHcbZhWow4lloEbm7yMA4zjgHyeA?=
 =?us-ascii?Q?HIlLwEdewvRMBziklSAUYn16F4n15A5U+I+kAdZj+nnnJ2sIQdp+woIc1guG?=
 =?us-ascii?Q?9gQsxesqG0qBISeXxuJ1gdFd5V2iZkUZ2q8gFSmdFrwd/EUqdYDMixlwB7R4?=
 =?us-ascii?Q?gsAMnIOYaZ7wmvypxG5PkWvcQ/FyFj2YWHGByQKrC8UU4JZh6WfqSGad7kID?=
 =?us-ascii?Q?XbAVlQYfWxgoDfWazg+U3dRfJOl9Mw85CfMbkhK0N4FVhNrICj4Gc2PceJVj?=
 =?us-ascii?Q?1V+fPhUuIWtUOtcpy76u+y9Y8DLsTs+lhqrPIbkeZ1guxLyXXGrtMXC/J4Qb?=
 =?us-ascii?Q?ndWeKCRLWyRyVjsuhV08r62kFGahF9zEuGLsXfBklqJL9DWx/sJ+IB9nK8WZ?=
 =?us-ascii?Q?orZeeBv+9eYRwnnS66l33TfoA8So1ZfNcb0CT6K0nHLRIl/mIkY7cFmrOOnA?=
 =?us-ascii?Q?7ootLUMzzoeFj+FkuXjlGhnnd9+JhwUaUkJ+uFbMC9e37fztpevFf3PZPP6a?=
 =?us-ascii?Q?exViv4WLJzBmsRmIWm7SjMnOKED6pU1+IWAd7IEpx/QsX/Ldq8PBJDKeiDwL?=
 =?us-ascii?Q?oAH7V8aDJFoB9M3ghUGEdMXq4OZAioOh/qWMzHu4bjLAc+6e5JUO/xoavm1J?=
 =?us-ascii?Q?iCzgb4udc7lJGByPDssCHKVqipBDnFcRTvHzDoEbGCcI/A6UV4+HYU6RGkSD?=
 =?us-ascii?Q?6/TQ4v3KnhxPXqNtZpmKzf7j7OLf/dYsXWqY3NeXH8t30MgE0uaLbkMUkGvt?=
 =?us-ascii?Q?F1+o/gyCzfgTLM3uURO9Y9bRDby/rV6DQGVxaSeQ5t7Q/l2yRsbomAZrMV3L?=
 =?us-ascii?Q?ptXfR2gtyaCUIsED5RfAOJ7E2j4PxO05+fOP5ebxwrvZAN6MqBPRdL81rUpf?=
 =?us-ascii?Q?J7uCrBw5qll+CYQ/hfj6UFI0ZLtKuOi6BHy2Q2/q6bTO7kzVosdTyvz7FBNN?=
 =?us-ascii?Q?tdTTgFFsUmI5BPROhkWYiTXIwMp4SC4DyHwnimHwburFoaBgvNLis9QaVBhQ?=
 =?us-ascii?Q?kRnHRIyvm81DNbfR6UczQFAQoQZkKcuC2xwOaA/Z7g1RZ0BbwXh47pQ2sAff?=
 =?us-ascii?Q?2NlwHeVqMcVWvNfNNhjjUmyZ1Dsj4HzgXpXZjf5Gcx7D2psGORJqDRLt2D41?=
 =?us-ascii?Q?kJUxKMM84XSvZYLkQWPt0kcpK6hSnuUPGTTrUAXsNa6MF/dktiD/ouQyjl4N?=
 =?us-ascii?Q?yXM5udbDg6ZSX5aHv8ArXgClYdx3AUsXKAfR21x/xx3+XexUryvDfpYcqN3J?=
 =?us-ascii?Q?Gv0ejByoI3TUd8tbDJkpuX+eYS8ZNXgWa46m1NNeb3VyfcwzxPVN64gLsPOr?=
 =?us-ascii?Q?/AP+C5Yxjd9Xt0VGirte53P61jx3VeqCRW6z4uxl7jShNFGbP89kblTGKeKh?=
 =?us-ascii?Q?u036NujMtRjSCmL+HHI9BCjCHK8ojfmAbQODaYYYrUgnbwQHFtVvVcV3Plb2?=
 =?us-ascii?Q?TkJQm/K0gj63lAdTrmMM4GYyWE8MCvpTdDf5ODEKCPdMKEWBFyYxIjB46JGC?=
 =?us-ascii?Q?bWJCpPp4yI6hYcXczVGSkr1N/5gHxxAHqbIoEy0sOH0nRnG+poaJmKs2n2xh?=
 =?us-ascii?Q?TPedblkNEe1bCpZEec+cIjGViRcOwUxFyTeoQSUd5ifzICeZ2q6oZ6EwRZOf?=
 =?us-ascii?Q?B68x4HBdTTe0fpmWVQfnRvWIuFkba7flxlZc0JffdjsY0GA3uwJcCd1oN8pJ?=
 =?us-ascii?Q?glQsfw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5106c20-81d2-4355-7691-08db52ffca7e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 15:44:37.2302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yu3ElNnWJfxhw9o+cU5SB2G39RQV6oHZaDmWvYCuDCCuW5dfDvItTiiA6qBe8tMitUJzP7/tQrhhjQYlXp1d83df3Icfe1YlBEKquj/ABsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4491
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:20:39AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Store the offset in struct pkt instead of the address. This is
> important since address is only meaningful in the context of a packet
> that is stored in a single umem buffer and thus a single Tx
> descriptor. If the packet, in contrast need to be represented by
> multiple buffers in the umem, storing the address makes no sense since
> the packet will consist of multiple buffers in the umem at various
> addresses. This change is in preparation for the upcoming
> multi-buffer support in AF_XDP and the corresponding tests.
> 
> So instead of indicating the address, we instead indicate the offset
> of the packet in the first buffer. The actual address of the buffer is
> allocated from the umem with a new function called
> umem_alloc_buffer(). This also means we can get rid of the
> use_fill_for_addr flag as the addresses fed into the fill ring will
> always be the offset from the pkt specification in the packet stream
> plus the address of the allocated buffer from the umem. No special
> casing needed.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

...

> @@ -1543,9 +1569,8 @@ static bool testapp_unaligned(struct test_spec *test)
>  	test_spec_set_name(test, "UNALIGNED_MODE");
>  	test->ifobj_tx->umem->unaligned_mode = true;
>  	test->ifobj_rx->umem->unaligned_mode = true;
> -	/* Let half of the packets straddle a buffer boundrary */
> +	/* Let half of the packets straddle a 4K buffer boundrary */

nit: if you need to respin for some other reason, then while you are
     changing this line, perhaps s/boundrary/boundary/

>  	pkt_stream_replace_half(test, MIN_PKT_SIZE, -MIN_PKT_SIZE / 2);
> -	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
>  	testapp_validate_traffic(test);
>  
>  	return true;

