Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963244504C7
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 13:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhKONBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:01:05 -0500
Received: from mail-bn1nam07on2047.outbound.protection.outlook.com ([40.107.212.47]:30784
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhKONBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:01:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mcpc2+Dom5QxuYmH8+hH8q3EjPs6Ucbs0Xxz5q9KaRrGyQMOnpI9ypPc4OSf8DKEyWBS57B/INRaymxQOkJNDot7eLjmWN4BsoTw1MhqR0c88qu5vVMfzG6wRurBt1lxKUTsJE1e6YoFV7vB7VhBbn0LxqirOxnDSXq5DdYlbQagkeKldDAcKeGRicHAuDHZxKxvJPB8PgVbSCmsjSgzGvwkDlGIofgQRwGl1FMDBqhyrNdU96kdShW3svBFSTqb3r4mKSJDUBN+z95tP5DTciJzRpm/Wx0sf0e/1g7K3dHKm1cLC1HhnBQpRwVh0r2nAgyJe+nlei6X3HLGrsJxRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n67kbimtp8MtHB3A7c08WI1fauMy5KMJ0MyxZBnmcSk=;
 b=ZVSDIqn1JEOSh2EPnFbRrmXiZSTXoPe2zeIcYY7cL2F0Yyu221WPn730K6g1fva6Vav6q1LHLDhTNipkgXSup3IdKgLknnM6kbaijkxH+yZth01oWmCObOuwS1k3SdexWKVDEQNIiYRuSO/tHfiSKxT6vcXna8mueUL8qQnePEThDLih4jheeXli4DTcJ8W3NM+dBWpj9L/dPsMrNfAIzddujBb3GI7YXYadPseMeYPUyJp5QuhCCsQLeuXXS/m3rNtZkLJADMeRTAjP8o2ZZd3sjvkIhUdSwrOfd7Xjmn2bT8hQweU2aDKrRJe817taod7FMwOpq4wm6O+lsyZWOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n67kbimtp8MtHB3A7c08WI1fauMy5KMJ0MyxZBnmcSk=;
 b=g6fylaDzBWMy5+PsYsX4Qxj5ZyqsdlTErr/qegMEjeYrEuBpbrUZ5WOQKGyu7eSC5vV7hfV94mqWvRTXJG/7XyAXHId5d0MNCW0Mtq0oshQyoBxlVF8FBFJj0ITc6uOGoJRnQXg+0+hosGNMPakLGqSTuzd7C/dm8tOLgiMm0hehGU4vhucU5Pyk29K4CInAHQJ8JTYk5qugisg2fLbCkH98JREEyqqTwee9Qt8GGToBKKbc+9O5LpwogLfeze/T/ugoUMk85k4LFFamIGNvLTB6CosnxS+6TJ7a1YAtIaB0smg6JLRWW3hT4IbiuRURTbLJyuYO3Ttjh5XqA/pzqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5568.namprd12.prod.outlook.com (2603:10b6:5:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.20; Mon, 15 Nov
 2021 12:58:05 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 12:58:05 +0000
Message-ID: <ee7c8d05-93bf-3cc8-781f-2d6302778b3f@nvidia.com>
Date:   Mon, 15 Nov 2021 14:57:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] net: bridge: Slightly optimize 'find_portno()'
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        roopa@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0198.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.88] (213.179.129.39) by ZR0P278CA0198.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Mon, 15 Nov 2021 12:58:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fa9c7eb-76c6-4142-9b79-08d9a837908f
X-MS-TrafficTypeDiagnostic: DM6PR12MB5568:
X-Microsoft-Antispam-PRVS: <DM6PR12MB55681507EA51D5091C7839DEDF989@DM6PR12MB5568.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7s900jRkDiVo25PV/9uITPnydG9Uivxytpjoj/AQCSRNiebk7xD1ejB1l9DALDaxqVGP1Mhbzw3XyiIM8vtV2BzV8JUf6TU4au6gS/3hvIEBDD8z1RCCySjvw5xtDPULu7eqwL7aNA35X/73BNOriZRnIm0kXYv1kjAB1Osiur0PFPasWtgJWSlTBsedk5grD56ZjuMuUUACZZNgO1EDMXce66+9TPwSDkPo7ekIJjzO9qn9BlCx80CXpoJ1AUZ5+1oSaZHbMhopknjVBcQzibs7zRo5DcGr/UKBB+YNqegkxErcBiOcu+ud+H+R84Us4GHYQfNyhPU7jtFKySClvDRf6gnmEHxA6YeJLdw+BTnTrUnHMhJGi28xhJIuUIIzd+6e+FNE1IJxoVMvmPvvrLAHBQJz2BxeEqu0RsVflE0qAwhkf/qt9j7Fj9SfB4VtIqHFwK+gGZzRqe6GuWF/OGrprxmfSyfYtIEJCssvAHlTTA8dagIN4GaRXQOLnSuqFw0qIx8jmF4apWG4xLBsERzixK7ePyVSelgp0VV5J/u2Inri9JHhvhOtBbKJDBEh8RMaIA9K2p29L84tE24bCNigiDnUO7pQXAvEjWQyYvdA5zxlRWiV+6YUAfmBCfvL52ZaVyadIg3dhPoy8NCyxjsRRoEZmPdDg4Lr5291I11CdIdhC2y+i5VXBhh1f8Wd0w7JsKjoAo3TMtI0Q2cA+TsB9ULpmP1Pj7OS+IgxA0k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(8676002)(53546011)(186003)(66946007)(316002)(6486002)(2906002)(16576012)(38100700002)(4326008)(66476007)(66556008)(2616005)(5660300002)(31686004)(508600001)(31696002)(8936002)(26005)(83380400001)(86362001)(36756003)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clFqRkthMjdrOC9xY21iNTYzbWJ6d3pRbVprZFpZYzJGK0dTOXRZNVpBR2Vn?=
 =?utf-8?B?Y0ZSWW5OVzVxOUdJZVk3d3pjSmU4S1psOHozMDhyZ1FVUHFSVWxPOE4vS0I1?=
 =?utf-8?B?dlF4V3FjVFBoYVhOaE1ycXV5RlBmZGdvZjNiTm1uMUlOeDFQMzA0NmlsSXNn?=
 =?utf-8?B?RVFuRjR0enpGZXEvQXZFQjZqeDhIcHMrWjlHdmZjQ1d0WkRXakpPSUZwdTdD?=
 =?utf-8?B?L1hTNXEvZDl0d0tTakl5RCtmK0ZVcENTZmdIalBTUFBXMm40NHozM2JGSFQ3?=
 =?utf-8?B?SE1IeGNyR0d2KzBVNG5MRzhjTTJPMVJHOWZKdXQ4WVdJQ0hmOWg2OHRWR2J5?=
 =?utf-8?B?eWpJdDZrM2JNdnA1aWlTYVRBd21OVEJ1eTlRbmpEVEIxaWVFc1FyVUx4NnJ6?=
 =?utf-8?B?cWI4MUdsM2F3cUNWd0xaZnJzd21pbTlnMzNNTllRU3IxaFJaWEdGMlBrcld6?=
 =?utf-8?B?MkJUT0p1aWc3MlBlMWlTZCs5SVRUREVBS29qK0NMK1NOdjhiZnAxS0dzVEsv?=
 =?utf-8?B?amFmNTZKUHM2SFhweDVCeEM2ek8vdGZVclk2L3NnOUlBZVB1b3pBelVoUGEy?=
 =?utf-8?B?UDZBVkExOEduUStRazdXK21WUGVjZ0xZK24rdjNiWDY4WjVuaSswVVZFSGdX?=
 =?utf-8?B?OUJXUlFhbzZLeTUzR2o0N2RsMVZ6anBvZTJJVkNBZTV2ZzFUQ01ReWRaRUVv?=
 =?utf-8?B?ZlhHcVFJNGtJR256RDIvbWxMTG9vN1MyQmdBeEFPQWlEazlhUXp2VHRFOHdW?=
 =?utf-8?B?bnVCdWRJTVJVMDFjTEhFd0gvV01IV1ZGbVZxaUYyV0dBaTNmanRPaEMxUEkw?=
 =?utf-8?B?cmlHR1RIVzRXR05hL2ZGbCs3TVBlVDY2ODVNdHdjMUM0R2p6VDFwdmtWTkQ4?=
 =?utf-8?B?ZWhlS0lTQlVaeWRHRytMUnU0NEdFNEcrMHVyanNBUng4ZGtUekJBTGs2Zm1t?=
 =?utf-8?B?Sk5lWmdwZEVQdjZQTjBMSWRMV1FIdUI3L3k2VWgzMHVwaWtzSFlvK3U5VlJD?=
 =?utf-8?B?VGYvVWlxditJNHJaQUtKdWY2T0NOL1NvY1pzU0NBSlN6cm1jME1DUlZpV1hl?=
 =?utf-8?B?SVRmNGFuRkRJYXN2bERZNnJkalNBbUFFSmRYei9hOXhaK0JtdWdQNUVlOXhX?=
 =?utf-8?B?U091NEVIbWg4SFJ4N1Q0TTZDd0pKUDFwbWxRa0ZNaUEwSi9KOEcvaVNVejNU?=
 =?utf-8?B?T082c3FCNGNSN0VMMnNqOXJjR01IOEsxdkY4ODFnQW8rSHBtbWVteFdhVTR2?=
 =?utf-8?B?bllEUGhaY2lFWHlzTjJuajc0eUVtTDh3dE9adGtWVU5NUzNIdmNIaXZacUw0?=
 =?utf-8?B?eEFtQldRM3pGUHRIQ1cwdWtwbzhYa1RiOE9ka1BLdTdJZk9DMndiNHY3aWpD?=
 =?utf-8?B?NzRkUHdLdkdRQ3pUdDE5MkYwMzRMVXMxV0NpVHRTNHlMMkY0elFGenNCdmsy?=
 =?utf-8?B?QVMxTkxWeTRCcnIxN2dOSlJWTnJKZFlHNVJ1YXlsTExFMWxGOUVGcDk2cTZX?=
 =?utf-8?B?NlBQVnhwa2xVMTdMRkM3N3l4bm1hUlB2TzdoTUI1YmJxb1lWT2h4RnNEUkxQ?=
 =?utf-8?B?TW1GL3JDOGo0Uy8xVHhKcVYxbXYyRDJQMkNJbEFMakF1QnRlQ2ZFVW1iVUtx?=
 =?utf-8?B?dk9sZFBWSDlKcE16cUFnWEhJVWp2QUI0UzhTSHlxR0ErZ00wY3lqTlk2TFh5?=
 =?utf-8?B?T3ljNXlsWVh2RWpaanpLTXNVT244bkxxUjZiaFVaVytzV29lbWdBdlFqam5z?=
 =?utf-8?B?di9IbURUTGZwNEgvV2tFYjJZWjdzd3pjei9vM1pFc2NLb3E2UFhpaWs3eGFj?=
 =?utf-8?B?eElrODdnYzdWVm5BQjRLNDZmR00vUURQNGRXWFZpWURUL3doZ05XWkp5NFEy?=
 =?utf-8?B?WFpMaWFSWHZOUE8zckgvaEtndGZ6N25ZaHd1czhpWjROaGUzRkNGUlo3M0hx?=
 =?utf-8?B?Q2psajkwamZodVkySW5wQ2l2MmMrMnJYeVljR2xGT2duVEYzeVNGbHh3dlhO?=
 =?utf-8?B?ZWNrMVlvRk11Zm5vMjE2WnpSeWhOa0J4MjlvWS9uaFZlaGg2bE5WdExoMWNK?=
 =?utf-8?B?aHZXendoMHFMTVFvb2hQTENhVGlCTDJ2YU4rNHJKQ1hoTUhJT1ZDUWRKeGJ0?=
 =?utf-8?B?SkxKMmFVbm1QU1I0Um1aRmFoeVBJSHZiYjhvd0dpYURPK1dqUEVFWncvNDkr?=
 =?utf-8?Q?Lg4nwNWFoY6yoCGGc0MH5yQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa9c7eb-76c6-4142-9b79-08d9a837908f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 12:58:05.6104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8t1rmFU0K14aAmXpX4f06CDB1N6ER4YpF3IUHVCDPWaWubxSE8KTngqPhqpc+/2XlkL88swMb06kH4T9dqufrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5568
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/11/2021 21:02, Christophe JAILLET wrote:
> The 'inuse' bitmap is local to this function. So we can use the
> non-atomic '__set_bit()' to save a few cycles.
> 
> While at it, also remove some useless {}.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/bridge/br_if.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index c1183fef1f21..64b2d4fb50f5 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -397,10 +397,10 @@ static int find_portno(struct net_bridge *br)
>  	if (!inuse)
>  		return -ENOMEM;
>  
> -	set_bit(0, inuse);	/* zero is reserved */
> -	list_for_each_entry(p, &br->port_list, list) {
> -		set_bit(p->port_no, inuse);
> -	}
> +	__set_bit(0, inuse);	/* zero is reserved */
> +	list_for_each_entry(p, &br->port_list, list)
> +		__set_bit(p->port_no, inuse);
> +
>  	index = find_first_zero_bit(inuse, BR_MAX_PORTS);
>  	bitmap_free(inuse);
>  
> 

This should be targeted at net-next.
The patch itself looks ok, TBH it's a slow path so speed
doesn't really matter but it's a straight-forward change.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
