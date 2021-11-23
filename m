Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6513845A18A
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhKWLhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:37:01 -0500
Received: from mail-bn1nam07on2060.outbound.protection.outlook.com ([40.107.212.60]:38468
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229899AbhKWLhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:37:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c99yR2KLLp7x0vwpO4qucMaSafRF5mWXQjmsPBvC/iRfvrQ23NV3XVUcmigqLWL3tK2ijRyG1U+jz0yOUK95PDJuVBDG91z3vbtU51p4vznouK2Qqe/PmLTXEsmreRzf37jWAPr8sinSLhpLvtW40S1qZ0sTZfu5Y2bv56ozZ9qgR6WhT+KdJoYTmL9bupC2KR61PcCtcDsyEcGDG7IXY8XAcUAjn4A3ERif5rVJbKNmyIWA0iTdYPww/NV92wJ3iSh+FAkO61/m9Kt/aGBuLtjsVb65jOAutWTxfanxd4JqGZ3REKqlmLMtDJH0Qz9BIh+NxlGHwUn7yqL+frdjJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKnqCN5WkWwH1PNS1D+ccEEaVDDUHrozyHj41cTnGPM=;
 b=i6gfinaYenGEXd5gEgIvvb2FWM18Z+yhC3Vwb3fRn2Pi8IHiqWFAcVK9wLha1BFcgMW0icdHQ/Jt87uHQjo76+H6Os/rcniZgnPs4TRFwrZugKu55/deige4tp93sMz5RWXEIfVM+dDSaFHf4rrMFREzTBTa6f5VsPXtSAjgELpdu2Sj6fkMHX8EUzv1j8efAAHcaFaG4LQ+gosFg+DAOVdFm0gtsnINj0SPNREi2NmqmXwJefKYnGUSD2JdDWur8n1aoosUEee6tsYGSeIr8FVOJ3N4aRZCiJcFJn/HVfcsNShcc1ax3VXXOYs6wFw0OYZfoJY7zoHFxU+TVKAWMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKnqCN5WkWwH1PNS1D+ccEEaVDDUHrozyHj41cTnGPM=;
 b=nRD5mjEFVAAZR2OVtTOj3o/vgfisI9XlpQbd0ZLbTDwVcGmdLqucf5NHHJz7f0GPpkoPCyHq8ee7A6QaE+ijHpII5lpOyPRL8mvZQS1yzO6wAKH4XNRladO7/M8OFARTx5Xg8ILIjwM2YAyrhEix2MtFbN0O0iNJEl7dRYjRx9B/ZuOw6W0yqs/XFUOSmPYt4VQ+YCFmpafZwfVw3kCsq2nWRxbIsvgu0C5X6Jasw1bWZwp6KFIUaqbi90hD5Dow5xT8GC6eMyRolyvjTA5CkOC895Qm8ijfQqa+vh3j74XKZA4VX170QlD+9k+EnzN53+Vg7Qk9VrdHWKvSpYBpFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5518.namprd12.prod.outlook.com (2603:10b6:5:1b9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 11:33:51 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 11:33:51 +0000
Message-ID: <f9ea69c2-495b-72c5-5327-22d6228d50d1@nvidia.com>
Date:   Tue, 23 Nov 2021 13:33:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net] net: nexthop: fix null pointer dereference when IPv6
 is not enabled
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, stable@vger.kernel.org
References: <20211123102719.3085670-1-razor@blackwall.org>
 <YZzMAgIKFsCRjgc/@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YZzMAgIKFsCRjgc/@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0193.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.23] (213.179.129.39) by ZR0P278CA0193.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Tue, 23 Nov 2021 11:33:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cd5b7fb-e0d8-4245-a3cf-08d9ae751fba
X-MS-TrafficTypeDiagnostic: DM6PR12MB5518:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5518E0BA5F69D9AA2E552DD9DF609@DM6PR12MB5518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9QqQoXxLZd90GUYlQl1bHBP9sxZlUIuOZUa0AAdIjpXKXKDuLQZNH107iGlDFM7pg/4xO3hWwpxRQJeO/AS4VCpmzgscjEgZQYN5juJo1IrSaJCg1bl6Vp25xgk/iWMvlc5B0oZ2CeR8L8ptKUpN3V1QpnUbDVblJHAxliIBNrB5U2x9t1gq95XogfibJ4//t2UnSuV9ly5wsD+0BKjT2SPMwYTTAlSNpyBhISrTqmupGM8v9mRvJtLGePwBF3/ewjgzqW0ExGIDEfXawPdJMCfMg0jSisYoaKSdbW6qQS3f0FFLD6qhSj/ttboqC83gWX2dDmdEzJBs8JKzWOfp7/jnVbujD/oO2R4fRM7Li8ulOTHOteWTon+2p1yuOFXJFL2QYuw9ZdrskY5bXqTifnW8Q12PkNhmsjrpJkAw3WyFvTBD6m5vSFwQc6kg/bFAj8Zx+T4/YDM33mDB74EkhmEb7FmmU4uTAJR7VwfT1iof2UGaWB8RCCNh9vUBqNBb9n7P+W+qh4Hswc6sjowAXJbANYtl3YuocEGSBAfpxDYupgVuL8ysE7vPk2b8aRvkUELDxew8pQg3Lit5zJF7ZsbWRI2SQdlmZ8LGi65yBAnGKj6XJfrJJvwFjWa58+NY6jGzHt97O9EUfwPLOtYrKKfuosvzHR2myHol3Uf3v9cqC/KZqzgs9zaxwMdIuTVpHNV1jF0iHVc3LENbL6VvM4ICZmL1GeJWlTq+5xPtYXAHy218BQgY1MNWZe9xqO9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(110136005)(31686004)(86362001)(316002)(53546011)(16576012)(83380400001)(4326008)(186003)(5660300002)(8936002)(956004)(8676002)(36756003)(2906002)(6486002)(2616005)(6666004)(26005)(31696002)(66556008)(66946007)(66476007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWpaS1Qrd0VEajJlVGZVa0J5VTlnMW03T2F3QTQ0SWJXWXR2elRqcVc3Q0U3?=
 =?utf-8?B?dDEyalFoZ3I3ZEpaNEZtMzF3MUpkN0dHcGp5WDNLOE1HWTRYeEdsOHVGYWcv?=
 =?utf-8?B?cTgrSTYrN2tHYW5UOEw3VzB1NXl3aVF3bWpwTlBkQzJUcGxaQUdaa2EzMU5M?=
 =?utf-8?B?T2Q0dGVWYSt4RUxIWisxSkJpVHZ0Y3VERUlFeHF0WEVGQmI4ZFlkRGxJQ1p4?=
 =?utf-8?B?YndrdGpnV1hYbmJXV3VUTFMvcjcwRUs2Z2hLMHg1RnNsWktDTWk0dnpxSXlY?=
 =?utf-8?B?WEc0VzdlQndGb1Z0VWl3cWoxREQ2cTlWbWU5Um1kR0VQeGNRT3ZRZjdoMEpm?=
 =?utf-8?B?cTltQ3lRVzJIMWVPUktvWGVLcnVZZGdMSlpaclVSSUV4SDdVelBGT1hPb0g3?=
 =?utf-8?B?eEZlV1Y2WjVqYUw3TlpwT1UrMHY3c1ZtVHozUGU4REYwaHl5VTFxVmc4YTlt?=
 =?utf-8?B?cFJXamVPR1EvMDcyODNtb25wTzV2Y0J2ZEozeHAxazc3TjdPMFpFaTNtZC9h?=
 =?utf-8?B?STEwTzhZUWM0a2FJL3N1OEZNVWJqeEN3aE1UQ2hzRjMvTW5LTnppemZMTitQ?=
 =?utf-8?B?NnQ5K2VhaGZtVVQvY1VkdDZ5TTJDdk9sL1NWYlNKdWt4MzNCbkF3NExDRmJp?=
 =?utf-8?B?NExsa0VTeW5UZldobjBIdmpQL2NiNFM2VUFnRXovZW5ZaW1zYU9icG5JeFNs?=
 =?utf-8?B?eG1wT0E1VEQyeDd0QVdVRGRUbU1uYllYQ2MrOHBib2lLS0xscno4S3hvbHdu?=
 =?utf-8?B?cnB5WEVzYWVLck8yL0JxeWJuMU9Qd3lmOHRsQVpzNkxOeDZsbWFGUFJvbGZx?=
 =?utf-8?B?NGU5d1ptcU1tc3cvdWdtWHhLY1hUVlc4WnZxS2hXUHJMeVVtMlJ5NmJMdWpN?=
 =?utf-8?B?M2FSTWIxb0RWblNYMjV0NEtKcnd5K3lGM0JIRVFhOC90RlpFbzVkeG90VzVH?=
 =?utf-8?B?MEVMdWExYWJQNldLSnJkSnhNYVpCZEJFclpQTXJ4U1RkSks4UmE4NjZyMGFx?=
 =?utf-8?B?Y0thWjRWbGtRN0NBbjRnMkgyQUY4d0Y2VEJyTjJadUNIZjY1azJJODBZUGVS?=
 =?utf-8?B?RzA2L25Ia0VvRXQ4NzMwSjlTcHpNcWRjM2VjVThCdDR5YXF1SkxsaHMrSytz?=
 =?utf-8?B?U3d5ZDg3d0tUYm9zYU9GeStwUTJsSEFwQWxiQXdjNXMvem5SWXU0NkpjWE1v?=
 =?utf-8?B?Y0lCMmdTM2t5bVc2cnhBcDBpTGlCbkRvbFd4a0pkVDZ4d3VTaXpSL3dQYnpW?=
 =?utf-8?B?blgwdzM2Y0s1L1dlZU1WOS9EV2JJK29LeEhOZDRvYzdldVZuK3luUm5aOXk4?=
 =?utf-8?B?VXBId2NYdVRxbFFCaFlGbm93M05RUUlEVElEcjh1TDhBR1Z1RWtoVGxpbTJH?=
 =?utf-8?B?b2dneXJtUUgwZVV4eVNYZGcrOHcwUGxIYlhMQllYaHBjT0hPdzRCZkhwY1BU?=
 =?utf-8?B?YTNnY2dpMlhTRVJNcWlhZmtyWDJVb0ZXWTh1c3NTTzdsUUsrSEFPZU95Q1R0?=
 =?utf-8?B?NlhRbmlyMnNsS2NyMk90d1pUMjZBbXVNdWpNd0ZrWmpISWVnSDk0cXFFUlky?=
 =?utf-8?B?cjB6KzhqaytIdVY5b2ZMSk9DTmVUODhnbk43Q2V5Z0NUWk9YdEt3djIrazdy?=
 =?utf-8?B?MjBrQXpiWUhJL3FwTXRvazBYUVdDNlFxakNJam5raUpFb1R5N2JDRW5mcE9z?=
 =?utf-8?B?a1dSeUlybFR6eFg5dXRxd2RIeXdFQ1NvdEJpWVJDM0twRU5IRFFlSFNGc0Rx?=
 =?utf-8?B?T2NObm1NcmlGM1ZvL2ZDWkdyM0EzUGsreVhPN2RqQkF0T2tvSEdNSDREeUlv?=
 =?utf-8?B?MzlZR0dGNzN2b1NUSTFZOHZESVp4blZyeVo1NkxiVkcyR0FRQ1JjQmJGMXFx?=
 =?utf-8?B?YWROSU5wTElNWGwza2NudTYzMVNtektYYXBJWDdYYVBRUVEycFlxOURsUFcv?=
 =?utf-8?B?ZTQya3BLQnlSeU9EVzdBaUUwWGx6NXJVZ05ra1VTbnk3TUhNTlFMdmR4d2xN?=
 =?utf-8?B?Y0hKbTVGR2pBajhSN3RhUHZ6RTVOREVaL1E4aHFJSllUS25hZlNpOUNKTUVN?=
 =?utf-8?B?RlZLMkZuRE9EU3ZXaGdqY2dqSUhIVG9yMWtzS0xPcllYR0FtSGM1K2p0eTFw?=
 =?utf-8?B?Tk1EVy83cTBkR0lsNVVra1djQ1p0NlprUWZxR05STVgxVjh5cVVoeXZjOStY?=
 =?utf-8?Q?qXz/qchdhbmogQJ78vld1Yo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd5b7fb-e0d8-4245-a3cf-08d9ae751fba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 11:33:51.8657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/NeycJ87yycybG1vSl3wF7chaRQ2VCJ+p88MyQ9WbcoP5/Eff16BdXt+07Qbktaf8HXV0aarCG1zHBc9t8iXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5518
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2021 13:09, Ido Schimmel wrote:
> On Tue, Nov 23, 2021 at 12:27:19PM +0200, Nikolay Aleksandrov wrote:
>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>
>> When we try to add an IPv6 nexthop and IPv6 is not enabled
>> (!CONFIG_IPV6) we'll hit a NULL pointer dereference[1] in the error path
>> of nh_create_ipv6() due to calling ipv6_stub->fib6_nh_release. The bug
>> has been present since the beginning of IPv6 nexthop gateway support.
>> Commit 1aefd3de7bc6 ("ipv6: Add fib6_nh_init and release to stubs") tells
>> us that only fib6_nh_init has a dummy stub because fib6_nh_release should
>> not be called if fib6_nh_init returns an error, but the commit below added
>> a call to ipv6_stub->fib6_nh_release in its error path. To fix it return
>> the dummy stub's -EAFNOSUPPORT error directly without calling
>> ipv6_stub->fib6_nh_release in nh_create_ipv6()'s error path.
> 
> [...]
> 
>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>> index a69a9e76f99f..5dbd4b5505eb 100644
>> --- a/net/ipv4/nexthop.c
>> +++ b/net/ipv4/nexthop.c
>> @@ -2565,11 +2565,15 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
>>  	/* sets nh_dev if successful */
>>  	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
>>  				      extack);
>> -	if (err)
>> +	if (err) {
>> +		/* IPv6 is not enabled, don't call fib6_nh_release */
>> +		if (err == -EAFNOSUPPORT)
>> +			goto out;
>>  		ipv6_stub->fib6_nh_release(fib6_nh);
> 
> Is the call actually necessary? If fib6_nh_init() failed, then I believe
> it should clean up after itself and not rely on fib6_nh_release().
> 

I think it doesn't do that, or at least not entirely. For example take the following
sequence of events:
 fib6_nh_init:
 ...
  err = fib_nh_common_init(net, &fib6_nh->nh_common, cfg->fc_encap,
                                 cfg->fc_encap_type, cfg, gfp_flags, extack);
  (passes)

  then after:

  fib6_nh->rt6i_pcpu = alloc_percpu_gfp(struct rt6_info *, gfp_flags);
  if (!fib6_nh->rt6i_pcpu) {
          err = -ENOMEM;
          goto out;
  }
  (fails)

I don't see anything in the error path that would free the fib_nh_common_init() resources,
i.e. nothing calls fib_nh_common_release(), which is called by fib6_nh_release().

By the way, I haven't checked but it looks like fib_check_nh_v6_gw() might leak memory if
fib6_nh_init() fails like that unless I'm missing something.

That change might be doable, but much riskier because there is at least 1 call site which relies
on fib6_info_release -> fib6_info_destroy_rcu() to call fib6_nh_release in its error path.

I'd prefer to fix these bugs in a straight-forward way and would go with the bigger
change for fib6_nh_init() cleanup for net-next. WDYT ?

Cheers,
 Nik


