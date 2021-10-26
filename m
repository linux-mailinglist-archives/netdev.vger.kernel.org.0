Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E5543BD39
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 00:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240010AbhJZWa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 18:30:28 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:50913
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240004AbhJZWaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 18:30:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbYXoOwStlM7KlSKkNo/s4vN3J8htn87208LXP9cEb02UIMlvRuaUmsxePGGlTb07m/e1rk0kUcFD5+chhO3aTQjDX90yZHL3u9Bo44fOyMJ1FNmQ5g+2X/P5wbfB3LvbbhbAk/LyKGPIoNe8xBw0/orLickq+oc56AYZJQ4CnOM1aYs1BKOrt0LrjLYtG5ShekwnGH8W+ZSe2MzvLWITE5gbNHfWBCNgl8aBOS/SrNj5MW+jHA53K5ghbS9HURB5VGBIImBGufcztr9WFZcD6hehnOQm62Le7JAJCKH6lMJHlXqyKwZefM6BSOcr3hSg/jvbuCYqNNCMUawDSDjdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4F13YeJncWc0fUDKQ/xRO06nmgAryDTRMTLNRusc4Is=;
 b=c61PKLgdK2n8Si63u2w7SatZAr1NVZ9ADCzkeWHMyIIYxLjjshp4cecWpT/cg13DCVz2bpJXzqliyF+MtK8wwW9BEEYvde/LVH1yC9WU+xVdeOb81nWA86cFMX1xAyRwKYptyD5Q4BJ1nKAeeFrJIRpjmjS0pN+5b+rrtRkRW4wgQcWZorbrlE3ZqagZVd1rXgubm9VlnPFF01Fc8Jc/PzTvqbypIlKeBnhxy4V5+QM+T/ZumatAwsBnI60bu+GXN9cO9YhFBCBQHP6khnE4/CXyDlTdauPCsPuKuW2WJ+pt4GTEzSqrKUY7FqEbq7p2zlBRJ/Haweqa5q23tvYYVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4F13YeJncWc0fUDKQ/xRO06nmgAryDTRMTLNRusc4Is=;
 b=pcJl5nPU3/WlHrlJccw8+qI4lc0lB3N3WRRs8V/PfegWBvN1oC+oG3DI8+ASOUKgO3nOPI8gTPBh3fffy8hCQwEU5uRDcqhzd2+/MGnZryBm9IGQxaqTjnUM2AfswUuHUEYyQa9zy+uPZBUv0Q3Nf3TfIBqxaXEswgdz82qF52vRcVJRZqA3EKKKmb4pMGLS/3WIRSfIHoR34guCXOTJNL0NiehZMOkDIT/npRYmMOho0To64FQ4M+Br1ZYqYl7/HdjIX00axEWrQaO2ruJdLJmMx1zZWMPO9aoQ3W4HmUOkTP8suNbecWoliS5tR0GOZr2mQgqwmR3YLPhU1T7gyw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5309.namprd12.prod.outlook.com (2603:10b6:5:39d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 22:27:56 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 22:27:56 +0000
Message-ID: <e0517da5-359b-7d2b-39a5-10e1f681749a@nvidia.com>
Date:   Wed, 27 Oct 2021 01:27:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
 <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
 <20211026112525.glv7n2fk27sjqubj@skbuf>
 <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
 <20211026165424.djjy5xludtcqyqj2@skbuf>
 <a703cf3c-50f5-1183-66a8-8af183737e26@nvidia.com>
 <20211026190136.jkxyqi6b7f4i2bfe@skbuf>
 <dcff6140-9554-5a08-6c23-eeef47dd38d0@nvidia.com>
 <20211026215153.lpdk66rjvsodmxto@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026215153.lpdk66rjvsodmxto@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0057.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::8) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0057.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Tue, 26 Oct 2021 22:27:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 500b078d-bab1-4a00-b773-08d998cfdbb7
X-MS-TrafficTypeDiagnostic: DM4PR12MB5309:
X-Microsoft-Antispam-PRVS: <DM4PR12MB530971C322348FCCB1A44C2FDF849@DM4PR12MB5309.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GSDH3lWnfnDBUIKh80VZAEmpvsL++Z01lnP4rAKrAXOy/focuaHkqtibANqqxOSTD9cMBc7TbGNQsWZx511Yq7HajT6LXy79hAf0LT5cB2qlr8MjK0o+o/g48QGrfAzrSHnGAIdWbaWTLeeTT03CUnIGXo1al7KiQBWFcDtJ+a+/kcvchRUaYkbmfMnRdIyaDk0UPyOl1cuclRqmWeUBpD+gmWgB13SO/jppzU4Ct/bDyYd4N2AE1gWO97Di7EItLo6BhScIf1rx71SxE5kjFUfn5Squ9DHDS8SFXM4wgWDWUH8ADLeDpqwGP5aGbYYt8hylIk4oXacn9hoQyK+ucW02igw4kENPvtG81+6lZim7qSuHBQJJm71bYlFFAV7iz+mkkeg0B3LSuL16Ec+DMguaUOZmERl83pZzmr1lTvqnClR7+ykYBcxPHJt0BO5IKhqp65/prKzjDtIT6Ug5QxLZOGZhaCPGNHFTgi/grKQxgLiuCwtBFvTPaNk0X6Tg11KsZ2MX2FfXRZh+l5+3jDndKKjAAGYT9P520R2nj+2LH/hDElHNWLYcHo0ILHWxWtV5F2safKT45Ja18iwsP4kmKWIeXxHxq6M8iIVLH5mAuUxV6M75U2RHk4ppauC2NkazT+xXtR7Af+iwvbdNgmqzYmhdNdz370Vq86hvBKNLOzdsXz/ry7ntKVAEHTR3d7w//+FLRd+yRltGrie8ywMGmXrBNjrk48GNO5KT3Fk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(107886003)(508600001)(6916009)(53546011)(316002)(31686004)(36756003)(6666004)(26005)(4326008)(38100700002)(66946007)(8936002)(8676002)(83380400001)(5660300002)(186003)(30864003)(16576012)(2616005)(956004)(2906002)(31696002)(66556008)(66476007)(86362001)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2dKTVBJbUVvMURsUnZWT2VQUDlVUU9oZFJURUowRGY4d2E1N3Y3SU51U2lT?=
 =?utf-8?B?U3g3OUJRRVdCZENWS25HMnhlSGlrZE5TRmt3ZkhkbHArYmdQU2dFdWtpZ0V2?=
 =?utf-8?B?V2xUVzFaYys4dXVtcTBaQ3RxaytTMFE1VWZNc3Q4RTY1VlJ3L1dZNHRiN0tm?=
 =?utf-8?B?ZHJWd0pGdE1sQ2tRSnNyb2ZVVmlHbG85Um5xQlZMVjVlTkhuYytkdnJxME9k?=
 =?utf-8?B?K3VINEhZYTNtWjlNNzBzbUJrekprL0JhZFlDQ2Z3dzFyYU9hUFBOZkNoaWRi?=
 =?utf-8?B?NUVmbE5IWEl1RzBmZ3BWMWVKUzU3NGxROEZWMzJTaGM0RkQxd3lheWNIRk5X?=
 =?utf-8?B?b2J1akVXOC9BeVV3V3d1QTdGaFRNeG50aVNGcUtwMXlHRFpaTmpCazJqM3c3?=
 =?utf-8?B?R3lqTnErUzNzVXYyQ3dWdVNPeVhLT0c4ekJ2L1J1TitHaHdwUXhJVkFGMVcw?=
 =?utf-8?B?MVcrZVlPRlBzYThNUm83dUFyR2grNFY3SE5jeDJjSklzQnJXSkhSUU5BTG0w?=
 =?utf-8?B?bXEzM1RIOFRZbC9RYzFoemgrMlBDS0UxZ2lxR00vcU9lV2hZbnRWclV4Y09l?=
 =?utf-8?B?MHdWRDdaREtNd05ZeUNaYlpjNmloV3A0YXRpSWxPTFlSL1Z6YXdRTGR6cllj?=
 =?utf-8?B?WVR6ejdGZmd5RTNwWkRoS1FmOVZvK1B2Yk1TMmU5TjFZcE5xeTg2bmZVWkVU?=
 =?utf-8?B?QW95MitiTzlsVDViMnZzQTlHdFhEZUlCbnIrcXdvWDVjVGZtR1ZnZEQxMU83?=
 =?utf-8?B?RWp0MkQzZ3oyNkJKTStscFd1UWYwdDhza2x1dno3SHl1ZlJOLzNQRGxwUDJV?=
 =?utf-8?B?Z1h2cFV4UXFyYWF2TWN2eUF4Z1A3SnFncU9vOUhOMnZtRDhjay9lK255SGYw?=
 =?utf-8?B?WHVRcGhXU2dFQUkreHFsanNTdFN3L0lIbGx3K0k2aUxsdTU2dDBkVjlLOXEw?=
 =?utf-8?B?SVJoUUVBZnJCMzlkMHo4S3FqZzBrUFczcWlqL25HQ2hIVVZQbFBzd0NsVHNR?=
 =?utf-8?B?engzZjlrUm9rM3JYUmlIamd6bW5NN1pydnlWQXFtM0NQMWRuMFFyMy9jTW1P?=
 =?utf-8?B?L1Z3T1Q2bUUvY0Ywa3NITGMxb2ZxeU9Mb1VYYlZOcHFYT2dBY2YyWUc1Y2Rm?=
 =?utf-8?B?SUloUjVHME16VE5QUkcwaFJPUmVLbmtPTmFBKzY3SWNYVUd6WU5xUGUrYzEv?=
 =?utf-8?B?NU8vYXNYdjVYdXYrRWs5c0NvUEZidEFLeFZ0UFYyb0RQb0NyWi9sMVFoNTNj?=
 =?utf-8?B?Y3c3NUVqOVpQV2V1endMdnpRcDhjQ3dzQ1l6WUQ5bTNTbEpqMjd2UVhvUEFV?=
 =?utf-8?B?QUhNcWxjMG1Jd1RrN2RoSnpGaGFuQTZqanFvWWtIazJmNWhkRDM0c0kwM1Fl?=
 =?utf-8?B?YkwwbmZTMGFFakhrQXVnb0RCdE05OHpBNjZuZ2Z2UHBsTzQzRUQ2VDY4VUxZ?=
 =?utf-8?B?Uk9kNStyRnpNZnc1aHFaYmJJandONTZDeTZicmVJSkxqVFVqRWg2dE8wUE1O?=
 =?utf-8?B?REo2NlVUYVpkZnNsL0VFU0Y2dk1SU0dvOFhYYi9Kdk1CNW5UYWxxc3dhY1I5?=
 =?utf-8?B?UGQ2S3NYMCs3b25lY1Y2MFdVRmlwWWRjVG9veDRBRFBpSHdJSktNQytVUFpn?=
 =?utf-8?B?bFRwYVJ6ZzFJeVB4MFpGUzNBL3lTRWNSS0NCSjJXcE9ZbHEyeVFmTW9yMUpT?=
 =?utf-8?B?bXExeXRtV1JCWGozay83ME5Fb05sU3F6VFljdHlRZXF4Yk5pRzNLY2NlaFFh?=
 =?utf-8?B?MnJwMWZVaTlISWwvRnBVU1dLeXZER0hVRDJ5S0crUTdHYWVqZEFWcnc3YXVJ?=
 =?utf-8?B?K1dSazI4OFkrcktoZjlNMURCbkI5STFGanhxei9sZlR0QWF0N2tWSkxJdHQx?=
 =?utf-8?B?Vkp4MDlBN0t5UTk5SnVVR1R2Q080bm1QbDVkdFJqZ1lzcWNvV0tvTFVBemNL?=
 =?utf-8?B?NE82NERQc0hlMWhMSXc5bGxSMThqSjVtTC83QUx0OXAxQ21kZFBaWnJyUXU2?=
 =?utf-8?B?V1pPVHVrV2FCSzgwZWJselFhUU1sS3dMd3hTallqUHlqMnk2YUZrbEVxaStY?=
 =?utf-8?B?YUc5N2xDQkZxUSt5YmJVS1QwL082VjRHVTdLR0dVY1owUWZ4QmlmU1dRbXBC?=
 =?utf-8?B?U0JscjZpeTdoTElvRU15UVV5dFdQZmREb0JWeDArSk5sMk9HMFArMFpxeTdM?=
 =?utf-8?Q?8hYd3KLyXPlkJQDKRiEeiwo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500b078d-bab1-4a00-b773-08d998cfdbb7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 22:27:56.3539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VuHEN5ODBJ2gRgl729e37cmQjnu/snRbLClXV6ht7VhsrR+y2EnQr2zYJfQMivQf+1fWv1GnK37kDUoghjF9Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5309
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 00:51, Vladimir Oltean wrote:
> On Tue, Oct 26, 2021 at 10:56:59PM +0300, Nikolay Aleksandrov wrote:
>> On 26/10/2021 22:01, Vladimir Oltean wrote:
>>> On Tue, Oct 26, 2021 at 08:10:45PM +0300, Nikolay Aleksandrov wrote:
>>>> On 26/10/2021 19:54, Vladimir Oltean wrote:
>>>>> On Tue, Oct 26, 2021 at 03:20:03PM +0300, Nikolay Aleksandrov wrote:
>>>>>> On 26/10/2021 14:25, Vladimir Oltean wrote:
>>>>>>> On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
>>>>>>>> Hi,
>>>>>>>> Interesting way to work around the asynchronous notifiers. :) I went over
>>>>>>>> the patch-set and given that we'll have to support and maintain this fragile
>>>>>>>> solution (e.g. playing with locking, possible races with fdb changes etc) I'm
>>>>>>>> inclined to go with Ido's previous proposition to convert the hash_lock into a mutex
>>>>>>>> with delayed learning from the fast-path to get a sleepable context where we can
>>>>>>>> use synchronous switchdev calls and get feedback immediately.
>>>>>>>
>>>>>>> Delayed learning means that we'll receive a sequence of packets like this:
>>>>>>>
>>>>>>>             br0--------\
>>>>>>>           /    \        \
>>>>>>>          /      \        \
>>>>>>>         /        \        \
>>>>>>>      swp0         swp1    swp2
>>>>>>>       |            |        |
>>>>>>>    station A   station B  station C
>>>>>>>
>>>>>>> station A sends request to B, station B sends reply to A.
>>>>>>> Since the learning of station A's MAC SA races with the reply sent by
>>>>>>> station B, it now becomes theoretically possible for the reply packet to
>>>>>>> be flooded to station C as well, right? And that was not possible before
>>>>>>> (at least assuming an ageing time longer than the round-trip time of these packets).
>>>>>>>
>>>>>>> And that will happen regardless of whether switchdev is used or not.
>>>>>>> I don't want to outright dismiss this (maybe I don't fully understand
>>>>>>> this either), but it seems like a pretty heavy-handed change.
>>>>>>>
>>>>>>
>>>>>> It will depending on lock contention, I plan to add a fast/uncontended case with
>>>>>> trylock from fast-path and if that fails then queue the fdb, but yes - in general
>>>>>
>>>>> I wonder why mutex_trylock has this comment?
>>>>>
>>>>>  * This function must not be used in interrupt context. The
>>>>>  * mutex must be released by the same task that acquired it.
>>>>>
>>>>>> you are correct that the traffic could get flooded in the queue case before the delayed
>>>>>> learning processes the entry, it's a trade off if we want sleepable learning context.
>>>>>> Ido noted privately that's usually how hw acts anyway, also if people want guarantees
>>>>>> that the reply won't get flooded there are other methods to achieve that (ucast flood
>>>>>> disable, firewall rules etc).
>>>>>
>>>>> Not all hardware is like that, the switches I'm working with, which
>>>>> perform autonomous learning, all complete the learning process for a
>>>>> frame strictly before they start the forwarding process. The software
>>>>> bridge also behaves like that. My only concern is that we might start
>>>>> building on top of some fundamental bridge changes like these, which
>>>>> might risk a revert a few months down the line, when somebody notices
>>>>> and comes with a use case where that is not acceptable.
>>>>>
>>>>
>>>> I should've clarified I was talking about Spectrum as Ido did in a reply.
>>>
>>> Ido also said "I assume Spectrum is not special in this regard" and I
>>> just wanted to say this such that we don't end with the wrong impression.
>>> Special or not, to the software bridge it would be new behavior, which
>>> I can only hope will be well received.
>>>
>>>>>> Today the reply could get flooded if the entry can't be programmed
>>>>>> as well, e.g. the atomic allocation might fail and we'll flood it again, granted it's much less likely
>>>>>> but still there haven't been any such guarantees. I think it's generally a good improvement and
>>>>>> will simplify a lot of processing complexity. We can bite the bullet and get the underlying delayed
>>>>>> infrastructure correct once now, then the locking rules and other use cases would be easier to enforce
>>>>>> and reason about in the future.
>>>>>
>>>>> You're the maintainer, I certainly won't complain if we go down this path.
>>>>> It would be nice if br->lock can also be transformed into a mutex, it
>>>>> would make all of switchdev much simpler.
>>>>>
>>>>
>>>> That is why we are discussing possible solutions, I don't want to force anything
>>>> but rather reach a consensus about the way forward. There are complexities involved with
>>>> moving to delayed learning too, one would be that the queue won't be a simple linked list
>>>> but probably a structure that allows fast lookups (e.g. rbtree) to avoid duplicating entries,
>>>> we also may end up doing two stage lookup if the main hash table doesn't find an entry
>>>> to close the above scenario's window as much as possible. But as I said I think that we can get
>>>> these correct and well defined, after that we'll be able to reason about future changes and
>>>> use cases easier. I'm still thinking about the various corner cases with delayed learning, so
>>>> any feedback is welcome. I'll start working on it in a few days and will get a clearer
>>>> view of the issues once I start converting the bridge, but having straight-forward locking
>>>> rules and known deterministic behaviour sounds like a better long term plan.
>>>
>>> Sorry, I might have to read the code, I don't want to misinterpret your
>>> idea. With what you're describing here, I think that what you are trying
>>> to achieve is to both have it our way, and preserve the current behavior
>>> for the common case, where learning still happens from the fast path.
>>> But I'm not sure that this is the correct goal, especially if you also
>>> add "straightforward locking rules" to the mix.
>>>
>>
>> The trylock was only an optimization idea, but yes you'd need both synchronous
>> and asynchronous notifiers. I don't think you need sleepable context when
>> learning from softirq, who would you propagate the error to? It is important
>> when entries are being added from user-space, but if you'd like to have veto
>> option from softirq then we can scratch the trylock idea altogether.
> 
> I'll let Ido answer here. As I said, the model I'm working with is that
> of autonomous learning, so for me, no. Whereas the Spectrum model is
> that of secure learning. I expect that it'd be pretty useless to set up
> software assisted secure learning if you're just going to say yes and
> learn all addresses anyway. I've never seen Spectrum documentation, but
> I would be shocked if it wouldn't be able to be configured to operate in
> the bare-bones autonomous learning mode too.
> 

Ack, got it.

>> Let's not focus on the trylock, it's a minor detail.
>>
>>> I think you'd have to explain what is the purpose of the fast path trylock
>>> logic you've mentioned above. So in the uncontended br->hash_lock case,
>>> br_fdb_update() could take that mutex and then what? It would create and
>>> add the FDB entry, and call fdb_notify(), but that still can't sleep.
>>> So if switchdev drivers still need to privately defer the offloading
>>> work, we still need some crazy completion-based mechanism to report
>>> errors like the one I posted here, because in the general sense,
>>> SWITCHDEV_FDB_ADD_TO_DEVICE will still be atomic.
>>
>> We do not if we have ADD_TO_DEVICE and ADD_TO_DEVICE_SYNC,
> 
> Just when I was about to say that I'm happy to get rid of some of those
> workqueues, and now you're telling me not only we might not get rid of
> them, but we might also end up with a second, separate implementation :)
> 
> Anyway, let's not put the cart before the horses, let's see what the
> realities of the bridge data path learning and STP flushing will teach
> us about what can and can't be done.
> 

We will get rid of some workqueues (I hope), I was saying that if do the trylock we
might have to add both sync and async, otherwise we just need a single sync one.

>> but that optimization is probably not worth the complexity of
>> maintaining both so we can just drop the trylock.
>>
>>>
>>> And how do you queue a deletion, do you delete the FDB from the pending
>>> and the main hash table, or do you just create a deletion command to be
>>> processed in deferred context?
>>>
>>
>> All commands which cannot take the mutex directly will be executed from a delayed
>> queue. We also need a delayed flush operation because we need to flush from STP code
>> and we can't sleep there due to the STP spinlock. The pending table can be considered
>> only if we decide to do a 2-stage lookup, it won't be used or consulted in any other
>> case, so user-space adds and deletes go only the main table.
>>
>>> And since you'd be operating on the hash table concurrently from the
>>> deferred work and from the fast path, doesn't this mean you'll need to
>>> use some sort of spin_lock_bh from the deferred work, which again would
>>> incur atomic context when you want to notify switchdev? Because with the
>>> mutex_trylock described above, you'd gain exclusivity to the main hash
>>> table, but if you lose, what you need is exclusivity to the pending hash
>>> table. So the deferred context also needs to be atomic when it dequeues
>>> the pending FDB entries and notifies them. I just don't see what we're
>>> winning, how the rtnetlink functions will be any different for the better.
>>>
>>
>> The rbtree can be fully taken by the delayed action and swapped with a new one,
>> so no exclusivity needed for the notifications. It will take the spinlock, get
>> the whole tree and release the lock, same if it was a simple queue.
> 
> I'm quite unfamiliar with this technique, atomically swapping a queue
> pointer with a new empty one, and emptying that queue while unlocked.
> Do you have any reference implementation for this kind of technique?
> 

the delayed work would be doing something similar to:

spin_lock(delay_lock);
record tree root
rcu change tree root with empty
spin_unlock(delay_lock);

mutex_lock(br->hash_lock);
process recorded (old) tree and free items via rcu
mutex_unlock(br->hash_lock);

We have the same pattern with queues all around the kernel.

>> The spinlock for the rbtree for the delayed learning is necessary in all cases,
> 
> "in all cases" means "regardless of whether we try from the fast path to
> make fdb_create() insert directly into &br->fdb_hash_tbl, or if we
> insert into a temporary rbtree for pending entries"? I don't understand
> this: why would you take the rbtree spinlock if you've inserted into the
> main hash table already?
> 

No, it means that we need the spinlock to protect the delayed queue.

> I'm only concerned about spin locks we'd have to hold while calling
> fdb_notify().
> 

There won't be any spinlocks for fdb_notify(), we'll be doing all notifications from
sleepable context with the mutex held, that's the goal at least.

>> if we used the trylock fast learn then we could directly insert the entry if we win, but
>> again lets just always use delayed ops from atomic contexts as a start.
>>
>> All entries from atomic contexts will be added to an rbtree which will be processed
>> from a delayed work, it will be freed by RCU so lookups can be done if we decide to
>> do a 2-stage lookup for the fast Rx path to reduce the flooding case window that you
>> described above.
>>
>> We win having sleepable context for user-space calls and being able to do synchronous
>> calls to the drivers to wait for the errors.
> 
> I think I'd really have to see the code at this point, sorry.
> 

Sure, I'll prepare an RFC version this week.

Thanks for the comments.
