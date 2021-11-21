Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE564585B9
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhKUSCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:02:31 -0500
Received: from mail-bn1nam07on2045.outbound.protection.outlook.com ([40.107.212.45]:23630
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238020AbhKUSCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 13:02:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuIqfy1GYY+Tt3AsLE5xUSuejmHDc0oue8eZyyKRSWTvJCDD6jqXeH18MFjtCtPMz8oUxIk5lQhABGkLRr/Z5spRXHmWcPOCcdDdgAdWF2LMTLXk3FoE4BtCpHOFRneXz/FO7xqMIafkHEdQkGeYAlwVxGPUkZ6SAFS28BXTT8DUZ9TMjoiMzUdG9e6UImKtdW2Y6dGxKInaucxDi8JMphC08F+FVsR5w32pLhWEw0h46lVhvzRRBP0AjzpWdWe1zAeprVbugZyg6tYKjOLPsYHIEQTxfPZ6lhpsEYXKoYUak6h7M5/Bykl98GkrRKgMuw8uC1+niGV8iXggTXvYyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=keUePLoDxs0fQyJYJWBKljY6pQWqCNcHrQwG5b121qs=;
 b=Nb8jMcVsc8hHKRbTfr4lGc7yBgnx5b4d6WxnyKiA8uu5MMpddL0SSBfzl7TqluFFsntz7Fr0VkDG0iJdjvf31vFalI/NeZBU6X3fi0A0Y7HMEpredUUNKISyQjS9ljap/3lNJ1GR0zehLMnT5JtccRTtLMvV0H71+eB/tuuoXEY6YBpGBjciGDkTz2liDWHPWRp2Y7rcImjxOI6WB5LPHdSab5dqvRCv2k0/4vyKByujwFoqJYLIl2dPIS7Qhq9PBxjMk3XUuJL8dA9Cs9PIWA8LYYhAvWz7Ny6NeyqH40jpGOqpWcer6lmzOnRoeDVA7ufbm8Pu3EW95ieoxiP7Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keUePLoDxs0fQyJYJWBKljY6pQWqCNcHrQwG5b121qs=;
 b=KPe40UlD5k68FWiPCcXx85OQIFz5pqxB5m4PTAjTZDZj6KO8LrccRKn2wWrqbj3DkaPO/jEUEs+I7P9Foha/DjPMcOofLkf2y2CevisPWl+1jMDCSJ5uiu6anJ1vl8cJPWm0kaswxzartnMNYjxhRPdVAY80JFGioajwNxgaR8JoeNDenL1jziN0Jp55fVPCezDf8Kz/UHj/t8gM6zgpw3g6nAAMJZip3hf1OSEy8R2pnVKWpjD4Q5uUR4i7mXIp3umR8WOtVdhDAa3edDv/UCGbHHAjwpZT5ezXbaw60/ob5AhIqyIn6cEedT/lS2Znny77nYPZ18HOUV1FBcbjcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5104.namprd12.prod.outlook.com (2603:10b6:5:393::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Sun, 21 Nov
 2021 17:59:23 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4690.027; Sun, 21 Nov 2021
 17:59:23 +0000
Message-ID: <5694713b-0d18-27a9-417c-9c500ce19c14@nvidia.com>
Date:   Sun, 21 Nov 2021 19:59:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 3/3] selftests: net: fib_nexthops: add test for group
 refcount imbalance bug
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com
References: <20211121152453.2580051-1-razor@blackwall.org>
 <20211121152453.2580051-4-razor@blackwall.org> <YZqHj5GFUdp7MEZU@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YZqHj5GFUdp7MEZU@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR04CA0043.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.23] (213.179.129.39) by AS9PR04CA0043.eurprd04.prod.outlook.com (2603:10a6:20b:46a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Sun, 21 Nov 2021 17:59:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b061ebfa-7eef-4694-668e-08d9ad18a67b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5104:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5104696826A2FA1C1EB7EC96DF9E9@DM4PR12MB5104.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I01mIianoFOoj9z2uiAzC0BNOgRcCJ6qR7ZNXeymz/tb6511+nfr/wsVtVwuf+N9ywvl1d5hYGxSn2f9UL7uBrkliG9OyC237NUijjAETU2YyRqxVUQp1tl7SRXQ6w9c7IVVIliS1xOPh2FjMbBNfzRq02z/Vg5ZbXEcZ27G5Z2Q4gTCJX5qxwqTi4b0nXwvt6jJnfAVkkmSanJmgL9jp9RfoxkF3u7uBbjmSAwTFluQMczV/GqOtSaMb72VRVJs2kxNGrYecPFha7ezTEOPbgcBSH0qwWznBbP78s+6cKH8cwkNZ+ZFyoGvm9YlvKpB7TgVitf9FN8v+jducOIE3aqRLtQxRXT3mgLQP5qRYCwqI9CSMjVHMLYG7dkWy3IqJ4GVDGaoyFsCW1+MI9uozNnUR2NOJxOYf87pP02Vn1F4J/SFwovyWhisLNR3+13bTPuzWoCiEJBCviuIQHp4q7Od2Jf/WpcX6ApjiufnQ30Jxu+M0lkriNl5wghGcg1ff6E29zSSf5x0qPKnKiAvk8zc4hKljjq1ipQh5s203927WMwHOwEJzeWMFY7aY4tdjbt/jAC/Xj4KqtBchAsuQaPiPMynsj787eIZlMeggqq0yimv3OIDrxwliA20zXPBjf+TemfnR692vypy2CSXFkcF2jOQOTbeGh7dg4cU70q3BI91wJMbmt7UCoGahtJoIj/pNv5Q5cA4PYranmR8EwOaQgYtCS8xTuOoB38/Zj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(38100700002)(6666004)(8676002)(8936002)(316002)(53546011)(31696002)(66946007)(5660300002)(31686004)(186003)(66556008)(66476007)(6486002)(956004)(86362001)(110136005)(26005)(4326008)(508600001)(83380400001)(2616005)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXVDTHN1MmowRkgzWEVnUk5hZldLNlVnSlErRm9BT256eTJpTkhydURiZGRa?=
 =?utf-8?B?V2Q5QTYwai9JZ2F0UlZsUFFBOUlLMmEyc0VyODhmUitMMW9aejZYcUFEdmVh?=
 =?utf-8?B?b3dCVmdHaW1HQnBSRUxpQThVa1RCakk3QmhzZ2Q2c0QxSW8zdFM5cEM1NW1Q?=
 =?utf-8?B?eEVmZk45UkEwVWRZU1VVOHFtd2Z0d3g5MGpHUFF3TDY3MzR0TUREVS8xeFkz?=
 =?utf-8?B?UHpPYjBQaDlRTmFmQmF1YzFVRndvTUc2eWUwU1ZDNjkwQ2JuZDE2enN6UFlB?=
 =?utf-8?B?cW5pTGt0WXZqSWU5dFhCOGFQQWxLQ2IyVG1nbWxiK2JlKzJURGFlRVlpaDlT?=
 =?utf-8?B?TWFoU1NEV3RmMldTOTg5ejhEcFplUkkycks5aHQ4WlFMVCt1M0QyZUc5L2N6?=
 =?utf-8?B?VHJhSkhZcWlvYjVPQWZRK0NjVzBPMW1JTmt4Q0dxNFRSSG1kTkhnNU52Y2ZE?=
 =?utf-8?B?dkhJREpSc3lCaHVBdzBrbmduNjF3WDQxSEJ1SUpFUjJmMGFVSU5OaE0vM09C?=
 =?utf-8?B?cmhGNkdteWUwbWY5RW1qVG4vVkJpOE9hVXp4a0NUZ1NhajZOWFFiU2hvRTQr?=
 =?utf-8?B?RFpaNnZvQ09GUkNyZU82emxSemdsSkprTHBYSXhrU2xoZGpzb1E0eFIwTjl0?=
 =?utf-8?B?bjgxSHBxOSsybm12TU1HMlo2eHdObUw2c2FVeW13eTU0SkdQalZCWHZ4R0pB?=
 =?utf-8?B?TmZuM0tEZWtoWm1pZThtV1RqdXNUNlYvZFpQSERubzZTK3QwWFBydG9VTkE1?=
 =?utf-8?B?ZmxaK3dSQ3lvaXMrVkE5TSs5b3JPaWthWHhEUE1qS1cxSk9BYjZqYUJ6N0pD?=
 =?utf-8?B?UkJpcFp1alBaMFQrcFo1MkJrTnF1cnRSbGRENkJqSUNNdU1Ub3JHbnRQYTNN?=
 =?utf-8?B?RkZLazBiQW5KL0NKTUFoUDN6czgxcjYzWThXcUVhMFYvZDhJRWgzb2xuaHJh?=
 =?utf-8?B?NzN4YitRNkcxSzJCWmFOWHY1RFAvVnkyWWRkRlpITkppampIZFNtYWNJZmxq?=
 =?utf-8?B?ajdPZDlvTGZYdmp5cUZiN1lkVEJOcVgweDZkL2gxNHd3elZKKy94aEtVT2c4?=
 =?utf-8?B?RUFJakEzdUhXSlhEcGZtbHF4QmhwT2J1QlJadUR6Vk9TdEdmS1p5Yk1oTy9z?=
 =?utf-8?B?TjBXRVNWY0tDVTVwY21VM2tQalJDNlBDZmxRMmU5L3I0dkNESjJlRW1CcTdC?=
 =?utf-8?B?bjhmUlJZblpXZTJydWRoTThGN1UxaXYvem5VSFFsdVhtTUwxdGJnOEtuUmMv?=
 =?utf-8?B?cmJNMGNhNjFCdkpOV05zSWhnaFpzWFBuUGU1Vmx6cnVBcWtDaTE3TGVub0p4?=
 =?utf-8?B?Nm9LZ1ovV3puZk13MnZnMkJyWmt1N0JrTEYxT1kxOUF3Z3BVUnU5TEZFQzN1?=
 =?utf-8?B?NTN1Q0lxWjR1MGkrVk0vN050T2pXVUFBbE10V3dMeWQwMkxUWldJOXVtcXow?=
 =?utf-8?B?YUZVNGltRmVqVTBjd01rYnYzOFdrdlRCR2N6QzZJcXBMamVNdUhYRm44NmRU?=
 =?utf-8?B?NlVPL1JmNW02ZGdzVEpMVnNJOVd2Z3o1bUNpc2VjWXRTLzliZnZuaWs1Qk1U?=
 =?utf-8?B?ek5Uc0hEWWROZEFXcUpyb3ZHMG9EWXNzczQ0MjF1OVBkOXRVWm9JV2tJdUth?=
 =?utf-8?B?cWhOVEpEc1BDOERJeGRzM2JEVGFiaThZZFYyTFBvaUp1eWl4S01UNmN3endF?=
 =?utf-8?B?VFFHUjA4dlZvd3d3RStuVWd6R3M0Rk9QaUI1bG8zSEtySC9jaXU4WTJibHQ2?=
 =?utf-8?B?eERaNy9GdEgyS2dCSC9oN3JmdFdKZEJveCsrNERzN3JkQTdITVBoVXdSSFNO?=
 =?utf-8?B?M0hKeEkzN2dZOHNPQWtjdUZvQVB3cEo3bGM2ODdJbDZBeFpicysvTDQzQkVr?=
 =?utf-8?B?TE5ub3loSnU5V0hEaEtlam9mam1mTU5HUGF5U2tQYjVPNlA3enZzQkc4MzZB?=
 =?utf-8?B?cStDTzU1a1lIZ1FOSWE1NXlTb25LbzlnNldOalV3aXU5cGJMcS93Skt1dytl?=
 =?utf-8?B?SVlnS3phU2pMYlcwMzBpWWVrMjVPTThmTHhZUlFmdThrWEh4Y2ZaOHJzaHNk?=
 =?utf-8?B?TUpHdUFpMHhXRUt2SWQ0TUkwSldZc2ZZNWpUYXlCS3hXNWpVRE03dUw0WXJS?=
 =?utf-8?B?NXkyRDN2MVJBNDlJMXNWK2g1UjBCL25QNjA1aGtCVUFmY09DRUlkaWhxWUhy?=
 =?utf-8?Q?oGXga/CHNJvHOT+Zz35pJ2M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b061ebfa-7eef-4694-668e-08d9ad18a67b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2021 17:59:23.5821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qEvRMecEjJr5zlDhb2Fcu3pd8+3XkMpk9DLj+RlKz8C1hNcjY7+zSwX3aSbk/ygoVztxsIljBAssLG2N+nyjUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/11/2021 19:53, Ido Schimmel wrote:
> On Sun, Nov 21, 2021 at 05:24:53PM +0200, Nikolay Aleksandrov wrote:
>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>
>> The new selftest runs a sequence which causes circular refcount
>> dependency between deleted objects which cannot be released and results
>> in a netdevice refcount imbalance.
>>
>> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
>> ---
>>  tools/testing/selftests/net/fib_nexthops.sh | 56 +++++++++++++++++++++
>>  1 file changed, 56 insertions(+)
>>
>> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
>> index b5a69ad191b0..48d88a36ae27 100755
>> --- a/tools/testing/selftests/net/fib_nexthops.sh
>> +++ b/tools/testing/selftests/net/fib_nexthops.sh
>> @@ -629,6 +629,59 @@ ipv6_fcnal()
>>  	log_test $? 0 "Nexthops removed on admin down"
>>  }
>>  
>> +ipv6_grp_refs()
>> +{
>> +	run_cmd "$IP link set dev veth1 up"
>> +	run_cmd "$IP link add veth1.10 link veth1 up type vlan id 10"
>> +	run_cmd "$IP link add veth1.20 link veth1 up type vlan id 20"
>> +	run_cmd "$IP -6 addr add 2001:db8:91::1/64 dev veth1.10"
>> +	run_cmd "$IP -6 addr add 2001:db8:92::1/64 dev veth1.20"
>> +	run_cmd "$IP -6 neigh add 2001:db8:91::2 lladdr 00:11:22:33:44:55 dev veth1.10"
>> +	run_cmd "$IP -6 neigh add 2001:db8:92::2 lladdr 00:11:22:33:44:55 dev veth1.20"
>> +	run_cmd "$IP nexthop add id 100 via 2001:db8:91::2 dev veth1.10"
>> +	run_cmd "$IP nexthop add id 101 via 2001:db8:92::2 dev veth1.20"
>> +	run_cmd "$IP nexthop add id 102 group 100"
>> +	run_cmd "$IP route add 2001:db8:101::1/128 nhid 102"
>> +
>> +	# create per-cpu dsts through nh 100
>> +	run_cmd "ip netns exec me mausezahn -6 veth1.10 -B 2001:db8:101::1 -A 2001:db8:91::1 -c 5 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1"
> 
> I see that other test cases in this file that are using mausezahn check
> that it exists. See ipv4_torture() for example
> 

Indeed, I'll adjust the test

>> +
>> +	# remove nh 100 from the group to delete the route potentially leaving
>> +	# a stale per-cpu dst
> 
> Not sure I understand the comment. Maybe:
> 
> "Remove nh 100 from the group. If the bug described in the previous
> commit is not fixed, the nexthop continues to cache a per-CPU dst entry
> that holds a reference on the IPv6 route."
> 
> ?
> 

Yes, that is the stale per-cpu dst.

>> +	run_cmd "$IP nexthop replace id 102 group 101"
>> +	run_cmd "$IP route del 2001:db8:101::1/128"
>> +
>> +	# add both nexthops to the group so a reference is taken on them
>> +	run_cmd "$IP nexthop replace id 102 group 100/101"
>> +
>> +	# if the bug exists at this point we have an unlinked IPv6 route
> 
> I would mention that by "the bug" you are referring to the bug described
> in previous commit
> 

since there is no commit id yet, I can give a brief description only
I'll may refer to it by subject though

>> +	# (but not freed due to stale dst) with a reference over the group
>> +	# so we delete the group which will again only unlink it due to the
>> +	# route reference
>> +	run_cmd "$IP nexthop del id 102"
>> +
>> +	# delete the nexthop with stale dst, since we have an unlinked
>> +	# group with a ref to it and an unlinked IPv6 route with ref to the
>> +	# group, the nh will only be unlinked and not freed so the stale dst
>> +	# remains forever and we get a net device refcount imbalance
>> +	run_cmd "$IP nexthop del id 100"
>> +
>> +	# if the bug exists this command will hang because the net device
>> +	# cannot be removed
>> +	timeout -s KILL 5 ip netns exec me ip link del veth1.10 >/dev/null 2>&1
>> +
>> +	# we can't cleanup if the command is hung trying to delete the netdev
>> +	if [ $? -eq 137 ]; then
>> +		return 1
>> +	fi
>> +
>> +	# cleanup
>> +	run_cmd "$IP link del veth1.20"
>> +	run_cmd "$IP nexthop flush"
>> +
>> +	return 0
>> +}
>> +
>>  ipv6_grp_fcnal()
>>  {
>>  	local rc
>> @@ -734,6 +787,9 @@ ipv6_grp_fcnal()
>>  
>>  	run_cmd "$IP nexthop add id 108 group 31/24"
>>  	log_test $? 2 "Nexthop group can not have a blackhole and another nexthop"
>> +
>> +	ipv6_grp_refs
>> +	log_test $? 0 "Nexthop group replace refcounts"
>>  }
>>  
>>  ipv6_res_grp_fcnal()
>> -- 
>> 2.31.1
>>

