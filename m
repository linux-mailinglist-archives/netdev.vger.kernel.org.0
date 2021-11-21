Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF99B4585E3
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhKUSVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:21:04 -0500
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:28385
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231214AbhKUSVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 13:21:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZydiFf8PE0OKgLNK40yMrAjgyRpmBIn1N/XEYDYcu1NFaZGm9xu1PErUiQYojUNOkPAKM8BdafRDKZcWALKZ+du73yGrA7EABcJNdW5gXnE5SqHCWWfO0WNNLziUPHJzITTJLYsk9yxzzupDNhUSGJAyF57CC3mzB+offb+bE2wstOwSTachb0y5JMCGvpAYhJKU0xkyFPAPOlaM5ep2+0cFMBCMpqAdr/YeyGrxPQ6xm2+Xug9spQytFuo5Gwuy/A9xPwVrH6Vh9MXvz5PiNkWqM/ErSip2QjzBtZhpIPmn4DblWxrqXZs0oEGUkosvXowy0iBw0PNi6DI0qywbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9r3F5nCVIvoSo3oaS+00izyCCCaLzDW8DWqzZb1q/5E=;
 b=JaANIicSAPLitLWxaiNU1aVjrcOTe9jSMv1gQprPkzkY/fDqfdQzEgNQzQ2ZUDaGWZE0R22YtmEUpwtK5HKLLtUcDasDFYkvZAvkgLKDJt/VNn0TdbJL7dtL23+2WulfH1wwC0Q5TsGiO/o/ime8/hLDfkQlSFooJO4TUVDY81cObYjz8mcbVHMcaJKTHBDkldL0voBgrMkolUCVPCJZCdx4jTZ+0r2VK6humyEG+xUK5CrdQtL9hbvRqwoDKEEVhnXskCQeoJ6QHUlHSSRuiAzVxsQ1iwlBP4GrVl4CkyZMaQPf0M4c2SCzbL6/xhNoYE//Tg47p3i58ZI+pC4h6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r3F5nCVIvoSo3oaS+00izyCCCaLzDW8DWqzZb1q/5E=;
 b=HqMKtHYjQlmzhQe7FwK1Tes0hSDU3RhJ9JsAnoJa6XXn4cB7cYuPAFDizyO1TJkoCkxJXvDi+XyiHC0C94rqdBc58uW82jw9AW47kOADYNLa2CHcWVA+TqrK0m1zyQ4mTY6a9qrcRU+56ShOjyJP1RnI9sIqZa/sd0vge/NXGNAlujxkPKrffQCMjran9lAoBk4NyTouSAaSMZ46qyn6DDXFctHNSz8NI52v3EfkwKnjKeFeRzyNbto3cJxgeAQzi1MLHrJxwtUPbI4l3HO+1qYJZ0O1I13nhg/cHqXaOOYC3GsZPhGbjVvw9AWnZVS451eWWzuuR+NCZjXXA5fMEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Sun, 21 Nov
 2021 18:17:55 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4690.027; Sun, 21 Nov 2021
 18:17:55 +0000
Message-ID: <d902fd06-00c2-fbff-1df2-4db3e890724a@nvidia.com>
Date:   Sun, 21 Nov 2021 20:17:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 0/3] net: nexthop: fix refcount issues when replacing
 groups
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com
References: <20211121152453.2580051-1-razor@blackwall.org>
 <YZqIBVcFwIzj6VZG@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YZqIBVcFwIzj6VZG@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0126.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.23] (213.179.129.39) by AS8PR04CA0126.eurprd04.prod.outlook.com (2603:10a6:20b:127::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Sun, 21 Nov 2021 18:17:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3241dc44-98ef-4289-52af-08d9ad1b3d1e
X-MS-TrafficTypeDiagnostic: DM6PR12MB5565:
X-Microsoft-Antispam-PRVS: <DM6PR12MB556539ADEFCDF5DC6FB7861BDF9E9@DM6PR12MB5565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0kgpY/mH9DI2pmKXT//gNYPweQEuRP6b2nE2SBZmNVvjc3E6yu53VLh/makikpbuHfm5V+vkoH5WlhbfMANjpF3VKoRuChvDL5obO2ZLtLhETo2VCXZWJ7FgV1hVix108YpR6jJGwR9QGwL4twlllm9u/sxFa0ILstiRzue+ko1md1wR0bHD/0K/GEFSCuHcKTxi4IPZo4wPhl1Ut9sSDX7gGJVQwabBEtuJGwxcQTrbXeG1piZ6a73Uq44zHWr6a0z3qwTfPvmRmmEPka0qGuGGajjTZxatdwfIHJ38VROB2gpu/HLLwbvU+Va9N1pVigBnqwdkHUDVLO9qL/qGGkmqnGTbnWHSgpKyPFcfHFw9S+m02GlwY9LbP42yM2KDYQ/TnxNBgWrEepuy7KKD3Bei5YiBsje9L6WBbAFn7XevuE9LP3m3ZZsJMdwgyhwR2Gu4brCIw7t9XOrQ8USP0gPC4XdzYGPZxxnTD4NPgOCqYFhrHj+o5lYTDZax1K8qywGlOG6bJrwyAxY0JCgiTccTOcBELU8Tc+cbvl0jCNRK0nusLH2BxZkYLCnUKwH43BlwH42X26tjaDxM//p4ogq2DNiwLmsX9x2VHLyzZakj03lf79xT/oCSqrd3fD3aXvxs2Rru48+FCyHkeIBhvtYV1pHrf0cEA4Mah5xMwMvjFXTUk8x5b0pCi54eXwrdzdkG/TipnZUPiULOg3iMvF5Rr/IZmJa9jdNXL+HxzxE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(53546011)(5660300002)(8676002)(2616005)(86362001)(38100700002)(316002)(6666004)(2906002)(26005)(16576012)(4326008)(36756003)(508600001)(31686004)(31696002)(110136005)(66946007)(956004)(66556008)(6486002)(66476007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWwrUVM0T1RxTW9icDQ2aTliTS9IcmJJejFWbTk3RktMcVlVTXFJbitPN1Ns?=
 =?utf-8?B?L2R6cDZtcXlRMERHcXJack5FRFp5S1VNdnBSUWhuRkpXa1Vtbmp6aUdFbDBs?=
 =?utf-8?B?SnBrNU1rZDBYK1JUQU94OHpNNExRMlMzS1lTRitRN1FRSWcvTEZBbmtxRnph?=
 =?utf-8?B?ZTFyUVR4TzBLaGlEUGlOdXBxbWFjVmtTNk1CelVzTEltNXpsUE1PSlN3clg3?=
 =?utf-8?B?d2d3bTNRTXZGTVVoc2MxTVUxU1pQeCtxc0RRd3dCMHc1OE1GRUlPbTdHY25U?=
 =?utf-8?B?ZWtuS2pBaGRIeUQ2S3VkbXl4OE8vVldFcmJEVElBdXlOemJlUFdxSHFxcUxu?=
 =?utf-8?B?V2RETGp6bksyUmZlRmp4V0lZYnlnQktMN0NnbDkyb2dqNFYzVk85cmhyd3Va?=
 =?utf-8?B?Y0hsbi9LUE9xM2N4aXlaK2Qwb3NzZ01SdzBIaUFCV28rRUdTNG1mVWhlYVpl?=
 =?utf-8?B?WVJ4SC9pQXFqNVFDQTdMWGxPTGtXWEUvaEhyVWQ0SkcvMWFMcFFMQmdOYTZD?=
 =?utf-8?B?WnZldHRDM1hsMVhQb0t0Z1NOUVVtc1pobk1uT0tyWHg1cGc5b3puVHFJcllh?=
 =?utf-8?B?VTA0dWROWG9LTGZGM09OT0xKNnBHTFhTL0tiZzhTcXEzVkp3RkdtVHNGc1Aw?=
 =?utf-8?B?ZWFaTHY5VmRLaE9pOUhrVHF0MDUzMzB5QS9zRWRvdDE3bTQ5Nk5yQ1RkMG14?=
 =?utf-8?B?SUlHME1XREltUVEzWDFHb0cwMWVlZE5ybnUyaU5ib3ZSVFhFaXBjSTBJaUl5?=
 =?utf-8?B?TGpJZXh1WDJQQmNzK05XRm5sZ1d4TFlLM2dUYWpzazAvU2hLR1ZKUVAyZjJX?=
 =?utf-8?B?SE83SThkdGJmcDRqSFROUXY0S1ozKzV1bEQ3R0Fzb0VyQm9FbHlOVzllM3dI?=
 =?utf-8?B?cklFamttVTZ3N1IyREI1MmN0aWZ5cE14R21MWVdwMCtmdjZWTnVtN0k5UTFa?=
 =?utf-8?B?bGU5V2E1SVFITmdIWTRVL3JDMGxZSzc1aWNtd1ErVXFUVW1wdVdHaEY3WlF0?=
 =?utf-8?B?dElIRmFraVJ4S0wwN2ZGc2tCREpHcUM3QTI5c05qdGRveW0wVUdZQ1hUT2hy?=
 =?utf-8?B?Qk5GM09YNU0rTVJ3T0VSeEFvS2E0RXRBLzRZMzdyTVZjOGtYMmZBTjBkeHNR?=
 =?utf-8?B?NDZDdTVKTVlabE9KTElVdGxQRmNnWXBoU3prNkQrNmJMaGJ6bXFkaE1PRjEr?=
 =?utf-8?B?c3d1MmQ1NWpDN0VPcWo0SVhkQ0Q5VGZKb3BGQjVvTEF1VUNIS2g2UVQ4dEM0?=
 =?utf-8?B?eWdBZFU4LzA4b0x5YUh6YU5iamVOMm5UQjRVSGMyZEVJTXp4dEZWVUpCbERF?=
 =?utf-8?B?cGtDOE1pVDlHK2d3SGsxai9kd0FHby9jQUVjTVRVK0YvaUZEemI5WC9FZllT?=
 =?utf-8?B?ZHVBOW9qT0lHSGx6SFZtczJnYndYV2w1WEZRV1JhdjFabXRMSk5BU2UyUlAv?=
 =?utf-8?B?Q2Z4dzlqRjAzRHZnOE9XaTlsY1hzMEo4RGl4UzcwVDN6V25GSGhZSzhsRHN0?=
 =?utf-8?B?S0UwOGJmZGpsV3FoSktWa3BEaFlyUjJFdDJBSXdDK1lOeUMxU3JwaUY5ZEhz?=
 =?utf-8?B?Y2lNd3RHOTBZbVNYSjd2M3hxUDNCb2xlZnFZaVVWZldZejFTK2FUUEx6Tm44?=
 =?utf-8?B?NXVkaTNZREYxVGlFNE0vTlFxMTRzM20ra0c3WFJVYWp6SFhVeVBOT1F4aDJ1?=
 =?utf-8?B?ays5RlM0QXJnZU80eGxuTkpFZTJrWXVic0FtZ1NSQXdNKzJVZEFLSFhuWnNP?=
 =?utf-8?B?cWpkbldXMUJ1RzFHdS9uNkFoQ1Z4VmRoZXFYQTcxNFhYMTB2bUNmUVlhbThm?=
 =?utf-8?B?dENIMmI4THU0RFBleU8zRC93ODRrQW1QL3ViQUx0ZXpJK0U3b2xrZEJ6L1lh?=
 =?utf-8?B?ZklYMGZBWm9yVDFnN1VVK1ROY1VQc2xiVHpidlVYTEZvMEI5SnBDbnZ2Nkt2?=
 =?utf-8?B?NG01Y3EyYThFaGVNZGNrQ1JSWGVLYXZHTTFLUVJHQjEwVThOR3Q2L3lRbUdZ?=
 =?utf-8?B?aFhpWHR5bU1WWHg1clVlZjE0ZDMyTFQ1Y2lQdHJ6Z3pvM25sYitsNjRwMEp2?=
 =?utf-8?B?MzNxeWVrd2RHdlBlZDh0bWM5YkU1NFVkOEc0RzUxU3VicUltVWhTQTVNeDB5?=
 =?utf-8?B?QkRmRlZiS2M4ZDA4L016bWZlZ0JMWndmZG83RUJuSjFyNDNraUFyYm9RT2tw?=
 =?utf-8?Q?2/QmuLnVO2KphI4JzauciVk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3241dc44-98ef-4289-52af-08d9ad1b3d1e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2021 18:17:55.4737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLWOrfdlk0ddE7xJ6NRmX3C1m3V0PGI0zEGI+4bwb3DWTnv57dfW7WpecrHM/wn1Ln5x1hUH4nUJ08QeVP7FHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5565
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/11/2021 19:55, Ido Schimmel wrote:
> On Sun, Nov 21, 2021 at 05:24:50PM +0200, Nikolay Aleksandrov wrote:
>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>
>> Hi,
>> This set fixes a refcount bug when replacing nexthop groups and
>> modifying routes. It is complex because the objects look valid when
>> debugging memory dumps, but we end up having refcount dependency between
>> unlinked objects which can never be released, so in turn they cannot
>> free their resources and refcounts. The problem happens because we can
>> have stale IPv6 per-cpu dsts in nexthops which were removed from a
>> group. Even though the IPv6 gen is bumped, the dsts won't be released
>> until traffic passes through them or the nexthop is freed, that can take
>> arbitrarily long time, and even worse we can create a scenario[1] where it
>> can never be released. The fix is to release the IPv6 per-cpu dsts of
>> replaced nexthops after an RCU grace period so no new ones can be
>> created. To do that we add a new IPv6 stub - fib6_nh_release_dsts, which
>> is used by the nexthop code only when necessary. We can further optimize
>> group replacement, but that is more suited for net-next as these patches
>> would have to be backported to stable releases.
> 
> Will run regression with these patches tonight and report tomorrow
> 

Thank you, I've prepared v2 with the selftest mausezahn check and will hold
it off to see how the tests would go. Also if any comments show up in the
meantime. :)

By the way I've been running a torture test all day for multiple IPv6 route
forwarding + local traffic through different CPUs while also replacing multiple
nh groups referencing multiple nexthops, so far it looks good.

