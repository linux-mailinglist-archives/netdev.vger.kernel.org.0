Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5065B43C658
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJ0JXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:23:25 -0400
Received: from mail-mw2nam08on2046.outbound.protection.outlook.com ([40.107.101.46]:50529
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240025AbhJ0JWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 05:22:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ery3AJi792Qg+AbJR5YK69tKfBJUaZ0i3TU30Kgf1/Ixe6LZha85gWgaULqSLfTRv94erMVpjaoLo4M9wnZIZ3n9XejB59sC8ZfwSI5MCTXywu8OGpFvITyQhLT0rXQ/jPyVolMJn3FRHw5YtPSx3ugnDstzy4cwbG0fZEC9e4DDFCJuLA8USOrbRQK79SccfEux64vcEn/sS1sN2Zax69NChz3qZ+dsL3lwPEssImU4P7YyFyePyIopAq7JdS+D50UJexBw59C9t0qcE6mIXG6odo1w+d8BQrmqjTTreZfVCSqFdjNXKVVza8GsVmpREoCBp71FXFTeAGTbKgQTzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTPhFZyjXeYM5vncJHEIZ7q+Ell0LeFrc+mwFFb7OhI=;
 b=HJKScgRRQOqiURIiNZkdzhZtusVQxQT02TVsEhQw2w+VIEFnYaSnKJrIhaa+hXJnvihLNzGUry1KhsdneTPvHYy9hq5rEIq+TaX5k1buwtWh09qlMxt6kllLjafPsXK7gY/VSKxOgBaYTcg+dPJ5+BRqqRkQrYrcUVcUYVaAd1N1pyGz++abqjE2uXe0mJ6f7sQ4yVVEe9NxNMvImGfaXr2tFAdvC9zHkzYzJmmcVmGkqYh1mO/dPaBV+q7hFHdKXjoAK9/coi30XxFaWuKXDSM01oeuD3MyKMiWwEVKT0pVM//GVUBtHNyMlItXNemXd3eFbvpXGDtI4vuJyY0ZCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTPhFZyjXeYM5vncJHEIZ7q+Ell0LeFrc+mwFFb7OhI=;
 b=q/hUkCy541ZRm0yAnmxSW1HSAyNZAAqCpv467n0AgpCvXxQAUE0RxUa+sM2xmdgf/qNHgQY/ccqxKlo0jBbX+ocYZT27XJke3oNpaqpr067lch0fXviNMOl9qq8D4w+FBWr/RLhamN2cwIWc95d8eREmuVHlvbCcr4aYIV3u0BxEHpsmYSX3z3+TmO5ACrGGN6F/hYiN34aCDc5611A5W/wkfZPxI0hKjSi6BoQj1GYlv1r8mymqONgxd3fkbV2GZLfUbz1MOezDffL68wFDigVUjDx6hhBg4euaYK/RbkzMpISpa+vz5K/lrAggHyJxLjNJKVnmugU2JUBQ9Pckdg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5151.namprd12.prod.outlook.com (2603:10b6:5:392::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 27 Oct
 2021 09:20:24 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 09:20:24 +0000
Message-ID: <3653946a-75d9-95c3-d63e-6d5eeb6b1b8b@nvidia.com>
Date:   Wed, 27 Oct 2021 12:20:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Content-Language: en-US
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
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
 <e0517da5-359b-7d2b-39a5-10e1f681749a@nvidia.com>
In-Reply-To: <e0517da5-359b-7d2b-39a5-10e1f681749a@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Wed, 27 Oct 2021 09:20:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 123a6d18-c5cf-4fa4-7492-08d9992b01c3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5151:
X-Microsoft-Antispam-PRVS: <DM4PR12MB51514F0A772CD30AACAF30D6DF859@DM4PR12MB5151.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUWHqLyVV24UiyGI0XvrXuXs6WTTksW9RTqWVi6acxP+orpVtustqNoqSJ3pUiRzyaHI7QUsI1cp4bsdVoMwU0qtAFYVBxiq9mIbXrDNHkVchAczlLBu+uCJ03Xi4Nb7zVsqtrsFQHrkAqN/Kjdja0QqnAd0QWumgO7zjlFIxTsiOLxNxm3y6dphkudVPYfysGzOGr1WXwUjVrO7Q24BKOZzQCAHHYN+lWcmcJj5OIsUoZOwGUEak6RIESbDiTaDslp2sT2VSXhp3w68o446GhMQAlMjaWxti76RYpblQJfsPyE1vHGTy11RPUlQacThNlGUEIY2zGmgXvIWnNSsJV891eanTK+KVUJYhKlmAcw5fJF+wuY7ecfA0oZ5G4ru1p7W9887ys1nkdI8HgEZK350QM5kUHR0LdPSxuO+ca9S4AWOn3enXAcenZXLpSe2J4RTiW+C4QkiQ0sybmObO1JaLO1WDg7zPrNax8ByKPPGCWWiOUhCI53rscRedbRZuO0OGY63vu41ECUj5VV9tAoyfSTd/wm4Z+WoPtzzA+51bNJosmcYY3Wkjq5/3+CAn8VTI4CJuoPOSouHxnw5gN/Z9E6rx7GzbPI6Hb70MSHw8yeafSFfFuCadNV90yBkDvz3gq87BjgYi0aufXCcnalvJsTI8dd4fzM9cGoPKJA3LBxGYrlB5EbHBEc1Bl5ypwA0a/SY2UX2MXKK0f6jFWZhq7uvyXp9Bra49CaWUjFXLnWsiatZjklMYzju4tfx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(6666004)(54906003)(16576012)(107886003)(2906002)(6916009)(26005)(36756003)(66556008)(316002)(83380400001)(53546011)(86362001)(4326008)(38100700002)(31696002)(186003)(508600001)(66476007)(2616005)(6486002)(8936002)(30864003)(956004)(8676002)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qi9ZNndzRnNIVlpQR25qRDJEbWpXNUFUOE9WL1dLVmladXBXekQxTmZVRDBX?=
 =?utf-8?B?ZVp2bDNjSENaVzg1clRCbmRHa2JtM1hyZlFuQkV6cnZkVTdsOW1CdDkwdzJR?=
 =?utf-8?B?TVdjOEV4Vkp3TEY2QXhzZ2hST3Rzb2Rnc2VyM0FQaFVhVURUU2luM0htLy83?=
 =?utf-8?B?L0hac0haL1g5dXE1dklyQnkyTVBueGVwMTZRNHhBNG8zZmFoVzBURjFVNEZi?=
 =?utf-8?B?a0YrZWRLblhjbkNrUlFSSjFkZVZPc0pUSUtHSExMRXpiWU5LamVNUW43WEdr?=
 =?utf-8?B?WEN5SzFpblo1RDNWVTRkejU0SHRuVmE2cytkS3NuQXdER0pCZnA0ZXd3UTRZ?=
 =?utf-8?B?ZCtUQnFZRTYwOXg3TjNaY1FGRXdyVU9udjNDQTdaTkNGd0p2RXZhS084Rzlp?=
 =?utf-8?B?SkgxR1JJRHdUaE5XWHlzSW1Gd3cxT29HMFdzeFBFYnRBbTBSUy8wVWdNR2tS?=
 =?utf-8?B?dFdlSit1N2pVNFFnVlBYNyt3eFcxbWNsOFo5dThqbCsyWFJXazZIN0wxY1g2?=
 =?utf-8?B?TVpEUEsvMG5BSzQzbVNDeG9ENnlFOU5FQ3ZVbDdpbUVJMHhGTVVUUnJBMjhq?=
 =?utf-8?B?c2VaMUZGdSsrNm9VWnRXYUpSQW4zSS93K2Z6dFhKWmpoWisvUUJ5NmJNVVQx?=
 =?utf-8?B?NEM5SWs0RDlTV2phdUZnUE42d0ZQOG94VTgxTkxFVWdYbUo4aHJCdTMveTNo?=
 =?utf-8?B?MlVkeFMzS0p6eHNCa2JIdG9GeEpWL1RHSEN0SlNmOTZWdlBzQTVodTdmRnNk?=
 =?utf-8?B?azlVd2YxeW5xVENXMHNwTGR0cjNBTmRTb3c3aldWVGFuSkFCQnVBR3N4Syti?=
 =?utf-8?B?WWlVYmVoZnhXcENGb2pMa09pTkQrdTQ5NjRIK09DbzZOQ3MraUlxWGx5cE52?=
 =?utf-8?B?cE1RUzA2YVphMkdqVzJsczhVc25yaThJMGhFUldBeGRuNlBnc25hTnNXUFVQ?=
 =?utf-8?B?czAxT1JxeERKOHNCd0U0Q2w3Y1ZBRmhOdGJlWXZkZExnelk3clREeFJOUjNB?=
 =?utf-8?B?Z3VMbnRhblJraysrK1dmMXJNVWtVWWQ3U0xQOUt0a05UcW1OYkRPOEE4MVgx?=
 =?utf-8?B?Ty9HOXdPK05GaENHdGhFNGh4aXZzT1BCMGtkWnE2UlU1aHEwTStDY1c0UVpP?=
 =?utf-8?B?azg5N2d5S0V1bmhUbWtpMDVZT2RvbU5MZDdIMHZ3UlE0aGtmVm9zRG0vQ09U?=
 =?utf-8?B?d3o0Z084aEp1UWIrc215ckllWFdMSm96T3dMOE9lS0Y4N2lrdHh3Y2J6bE05?=
 =?utf-8?B?REtEK3NhM0IwYiszM1FTdEl3L3k4WmVFaVNaZndUbndMZVZkdk9WRFN1RzMw?=
 =?utf-8?B?bGs2WHc2Q29EbEYwTEh1bUswbmczbWpFNEFGbEFzVlBDd0FyS0R2K21xTGpJ?=
 =?utf-8?B?cWlWYVZKWWFjRkNyUkI1L2RVY1FvdkxhdlovYVhkTVArVlpuNXFWTHNqaUJC?=
 =?utf-8?B?cjBWaURVcjVPemh6QVl5cUhIQTJhWjd2T0VwTUVXTUlMUWFtUktSMnk3dGZW?=
 =?utf-8?B?VlBrREdJZnJnMHJzTHg0MWxsSTRTU3hPem1BYXI5SmU2YmhHVTZYQWliMllu?=
 =?utf-8?B?SFVEU1ZOWDV5QnJtZGZFckFydHdqU05KQ2syYmE5K2NKd3pCUE5YUHhYVmpD?=
 =?utf-8?B?SGtZYm1JTENtUDZYcUNzOXZSVUNLTmRxblFtL3IvbE9VWjhzWjNoOSs1MDAx?=
 =?utf-8?B?SWtwWFYxZkMyUzBKeWJ1YlJ5d0hRQzQrZy9CQjJjRmRRcFBSTTVDQjJMUnJu?=
 =?utf-8?B?aklCa2kyZEEzZkgxOVMyTGwvcnZFM1lpamJ1bGo1MkQwYkt3UVNIU0twUTRa?=
 =?utf-8?B?Rm5UMlRTU0JLZTQ4WEV5ZjRlckRzZWNxSEFGVnByTUt6SlFVR3ZOYVNzMERY?=
 =?utf-8?B?K3B6ZGExUmNTR1o4V0tXeG5KVG8yNmppTGo5QUl6VURtcEpDbCtqMVRRSFBj?=
 =?utf-8?B?L21pc0Ivekk4Si81OS9MWitjSUNXb1F3d0IwSEJOZ2FiWVNRTm5mMWZhS2Vl?=
 =?utf-8?B?Yno1UnVHS3l2dUI5Wkc3NVhFMURreXkvVDdnNjNqQWUxMDNjaW1MMTRVNW9O?=
 =?utf-8?B?bVh2akdIdDlUVFNKNnlYcDZieGxBbWhza2pMdE5haW9EcWFvT3ViQlppWTNs?=
 =?utf-8?B?eHR2MDJXTmMrZFduSGs3YWZSK1F5cDlFczBGVU1GclBMdTUwWjhmdy80T2Nk?=
 =?utf-8?Q?9/m7JF+22kt1lMeR0Mj6y4Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 123a6d18-c5cf-4fa4-7492-08d9992b01c3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:20:24.3160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/VSCdmFY4r79+/uWOfnUuTGiLfrz/xfnXnM8fQZCao7KEY8rQ0JRuDF0HrrSbj0X9Nm5qrcOY4XOr5duZJ54Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 01:27, Nikolay Aleksandrov wrote:
> On 27/10/2021 00:51, Vladimir Oltean wrote:
>> On Tue, Oct 26, 2021 at 10:56:59PM +0300, Nikolay Aleksandrov wrote:
>>> On 26/10/2021 22:01, Vladimir Oltean wrote:
>>>> On Tue, Oct 26, 2021 at 08:10:45PM +0300, Nikolay Aleksandrov wrote:
>>>>> On 26/10/2021 19:54, Vladimir Oltean wrote:
>>>>>> On Tue, Oct 26, 2021 at 03:20:03PM +0300, Nikolay Aleksandrov wrote:
>>>>>>> On 26/10/2021 14:25, Vladimir Oltean wrote:
>>>>>>>> On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
>>>>>>>>> Hi,
>>>>>>>>> Interesting way to work around the asynchronous notifiers. :) I went over
>>>>>>>>> the patch-set and given that we'll have to support and maintain this fragile
>>>>>>>>> solution (e.g. playing with locking, possible races with fdb changes etc) I'm
>>>>>>>>> inclined to go with Ido's previous proposition to convert the hash_lock into a mutex
>>>>>>>>> with delayed learning from the fast-path to get a sleepable context where we can
>>>>>>>>> use synchronous switchdev calls and get feedback immediately.
>>>>>>>>
>>>>>>>> Delayed learning means that we'll receive a sequence of packets like this:
>>>>>>>>
>>>>>>>>             br0--------\
>>>>>>>>           /    \        \
>>>>>>>>          /      \        \
>>>>>>>>         /        \        \
>>>>>>>>      swp0         swp1    swp2
>>>>>>>>       |            |        |
>>>>>>>>    station A   station B  station C
>>>>>>>>
>>>>>>>> station A sends request to B, station B sends reply to A.
>>>>>>>> Since the learning of station A's MAC SA races with the reply sent by
>>>>>>>> station B, it now becomes theoretically possible for the reply packet to
>>>>>>>> be flooded to station C as well, right? And that was not possible before
>>>>>>>> (at least assuming an ageing time longer than the round-trip time of these packets).
>>>>>>>>
>>>>>>>> And that will happen regardless of whether switchdev is used or not.
>>>>>>>> I don't want to outright dismiss this (maybe I don't fully understand
>>>>>>>> this either), but it seems like a pretty heavy-handed change.
>>>>>>>>
>>>>>>>
>>>>>>> It will depending on lock contention, I plan to add a fast/uncontended case with
>>>>>>> trylock from fast-path and if that fails then queue the fdb, but yes - in general
>>>>>>
>>>>>> I wonder why mutex_trylock has this comment?
>>>>>>
>>>>>>  * This function must not be used in interrupt context. The
>>>>>>  * mutex must be released by the same task that acquired it.
>>>>>>
>>>>>>> you are correct that the traffic could get flooded in the queue case before the delayed
>>>>>>> learning processes the entry, it's a trade off if we want sleepable learning context.
>>>>>>> Ido noted privately that's usually how hw acts anyway, also if people want guarantees
>>>>>>> that the reply won't get flooded there are other methods to achieve that (ucast flood
>>>>>>> disable, firewall rules etc).
>>>>>>
>>>>>> Not all hardware is like that, the switches I'm working with, which
>>>>>> perform autonomous learning, all complete the learning process for a
>>>>>> frame strictly before they start the forwarding process. The software
>>>>>> bridge also behaves like that. My only concern is that we might start
>>>>>> building on top of some fundamental bridge changes like these, which
>>>>>> might risk a revert a few months down the line, when somebody notices
>>>>>> and comes with a use case where that is not acceptable.
>>>>>>
>>>>>
>>>>> I should've clarified I was talking about Spectrum as Ido did in a reply.
>>>>
>>>> Ido also said "I assume Spectrum is not special in this regard" and I
>>>> just wanted to say this such that we don't end with the wrong impression.
>>>> Special or not, to the software bridge it would be new behavior, which
>>>> I can only hope will be well received.
>>>>
>>>>>>> Today the reply could get flooded if the entry can't be programmed
>>>>>>> as well, e.g. the atomic allocation might fail and we'll flood it again, granted it's much less likely
>>>>>>> but still there haven't been any such guarantees. I think it's generally a good improvement and
>>>>>>> will simplify a lot of processing complexity. We can bite the bullet and get the underlying delayed
>>>>>>> infrastructure correct once now, then the locking rules and other use cases would be easier to enforce
>>>>>>> and reason about in the future.
>>>>>>
>>>>>> You're the maintainer, I certainly won't complain if we go down this path.
>>>>>> It would be nice if br->lock can also be transformed into a mutex, it
>>>>>> would make all of switchdev much simpler.
>>>>>>
>>>>>
>>>>> That is why we are discussing possible solutions, I don't want to force anything
>>>>> but rather reach a consensus about the way forward. There are complexities involved with
>>>>> moving to delayed learning too, one would be that the queue won't be a simple linked list
>>>>> but probably a structure that allows fast lookups (e.g. rbtree) to avoid duplicating entries,
>>>>> we also may end up doing two stage lookup if the main hash table doesn't find an entry
>>>>> to close the above scenario's window as much as possible. But as I said I think that we can get
>>>>> these correct and well defined, after that we'll be able to reason about future changes and
>>>>> use cases easier. I'm still thinking about the various corner cases with delayed learning, so
>>>>> any feedback is welcome. I'll start working on it in a few days and will get a clearer
>>>>> view of the issues once I start converting the bridge, but having straight-forward locking
>>>>> rules and known deterministic behaviour sounds like a better long term plan.
>>>>
>>>> Sorry, I might have to read the code, I don't want to misinterpret your
>>>> idea. With what you're describing here, I think that what you are trying
>>>> to achieve is to both have it our way, and preserve the current behavior
>>>> for the common case, where learning still happens from the fast path.
>>>> But I'm not sure that this is the correct goal, especially if you also
>>>> add "straightforward locking rules" to the mix.
>>>>
>>>
>>> The trylock was only an optimization idea, but yes you'd need both synchronous
>>> and asynchronous notifiers. I don't think you need sleepable context when
>>> learning from softirq, who would you propagate the error to? It is important
>>> when entries are being added from user-space, but if you'd like to have veto
>>> option from softirq then we can scratch the trylock idea altogether.
>>
>> I'll let Ido answer here. As I said, the model I'm working with is that
>> of autonomous learning, so for me, no. Whereas the Spectrum model is
>> that of secure learning. I expect that it'd be pretty useless to set up
>> software assisted secure learning if you're just going to say yes and
>> learn all addresses anyway. I've never seen Spectrum documentation, but
>> I would be shocked if it wouldn't be able to be configured to operate in
>> the bare-bones autonomous learning mode too.
>>
> 
> Ack, got it.
> 
>>> Let's not focus on the trylock, it's a minor detail.
>>>
>>>> I think you'd have to explain what is the purpose of the fast path trylock
>>>> logic you've mentioned above. So in the uncontended br->hash_lock case,
>>>> br_fdb_update() could take that mutex and then what? It would create and
>>>> add the FDB entry, and call fdb_notify(), but that still can't sleep.
>>>> So if switchdev drivers still need to privately defer the offloading
>>>> work, we still need some crazy completion-based mechanism to report
>>>> errors like the one I posted here, because in the general sense,
>>>> SWITCHDEV_FDB_ADD_TO_DEVICE will still be atomic.
>>>
>>> We do not if we have ADD_TO_DEVICE and ADD_TO_DEVICE_SYNC,
>>
>> Just when I was about to say that I'm happy to get rid of some of those
>> workqueues, and now you're telling me not only we might not get rid of
>> them, but we might also end up with a second, separate implementation :)
>>
>> Anyway, let's not put the cart before the horses, let's see what the
>> realities of the bridge data path learning and STP flushing will teach
>> us about what can and can't be done.
>>
> 
> We will get rid of some workqueues (I hope), I was saying that if do the trylock we
> might have to add both sync and async, otherwise we just need a single sync one.
> 
>>> but that optimization is probably not worth the complexity of
>>> maintaining both so we can just drop the trylock.
>>>
>>>>
>>>> And how do you queue a deletion, do you delete the FDB from the pending
>>>> and the main hash table, or do you just create a deletion command to be
>>>> processed in deferred context?
>>>>
>>>
>>> All commands which cannot take the mutex directly will be executed from a delayed
>>> queue. We also need a delayed flush operation because we need to flush from STP code
>>> and we can't sleep there due to the STP spinlock. The pending table can be considered
>>> only if we decide to do a 2-stage lookup, it won't be used or consulted in any other
>>> case, so user-space adds and deletes go only the main table.
>>>
>>>> And since you'd be operating on the hash table concurrently from the
>>>> deferred work and from the fast path, doesn't this mean you'll need to
>>>> use some sort of spin_lock_bh from the deferred work, which again would
>>>> incur atomic context when you want to notify switchdev? Because with the
>>>> mutex_trylock described above, you'd gain exclusivity to the main hash
>>>> table, but if you lose, what you need is exclusivity to the pending hash
>>>> table. So the deferred context also needs to be atomic when it dequeues
>>>> the pending FDB entries and notifies them. I just don't see what we're
>>>> winning, how the rtnetlink functions will be any different for the better.
>>>>
>>>
>>> The rbtree can be fully taken by the delayed action and swapped with a new one,
>>> so no exclusivity needed for the notifications. It will take the spinlock, get
>>> the whole tree and release the lock, same if it was a simple queue.
>>
>> I'm quite unfamiliar with this technique, atomically swapping a queue
>> pointer with a new empty one, and emptying that queue while unlocked.
>> Do you have any reference implementation for this kind of technique?
>>
> 
> the delayed work would be doing something similar to:
> 
> spin_lock(delay_lock);
> record tree root
> rcu change tree root with empty
> spin_unlock(delay_lock);
> 
> mutex_lock(br->hash_lock);
> process recorded (old) tree and free items via rcu
> mutex_unlock(br->hash_lock);
> 
> We have the same pattern with queues all around the kernel.
> 
>>> The spinlock for the rbtree for the delayed learning is necessary in all cases,
>>
>> "in all cases" means "regardless of whether we try from the fast path to
>> make fdb_create() insert directly into &br->fdb_hash_tbl, or if we
>> insert into a temporary rbtree for pending entries"? I don't understand
>> this: why would you take the rbtree spinlock if you've inserted into the
>> main hash table already?
>>
> 
> No, it means that we need the spinlock to protect the delayed queue.
> 
>> I'm only concerned about spin locks we'd have to hold while calling
>> fdb_notify().
>>
> 
> There won't be any spinlocks for fdb_notify(), we'll be doing all notifications from
> sleepable context with the mutex held, that's the goal at least.
> 
>>> if we used the trylock fast learn then we could directly insert the entry if we win, but
>>> again lets just always use delayed ops from atomic contexts as a start.
>>>
>>> All entries from atomic contexts will be added to an rbtree which will be processed
>>> from a delayed work, it will be freed by RCU so lookups can be done if we decide to
>>> do a 2-stage lookup for the fast Rx path to reduce the flooding case window that you
>>> described above.
>>>
>>> We win having sleepable context for user-space calls and being able to do synchronous
>>> calls to the drivers to wait for the errors.
>>
>> I think I'd really have to see the code at this point, sorry.
>>
> 
> Sure, I'll prepare an RFC version this week.
> 
> Thanks for the comments.
> 

OK, I've started working on converting the bridge but there are a few more downsides to
delaying notifications that I really don't like and there is no good clean way around them.

a) after conversion we need to queue an event (read take spinlock) for each roaming of an fdb and flag change
   which are now lockless

b) we either lose transient fdb changes and send only the last notification for that fdb, or we have to snapshot
   the whole fdb on every change

c) we need to serialize and order actions, so in addition to the rbtree for fdb lookup, we'll need an ordered list of events

Now b) is most worrisome and really problematic, anything from user-space which is following that fdb's changes
would miss events in the first case (not an option), or we'll have to deal with the complexity of snapshotting
entries which in itself has a few problems and doesn't really extend well to other objects (snapshotting an mdb
could be a nightmare). I don't see a clean way forward to fix this as I don't want to do the completion async
waiting either, that would impose future race and locking issues and could make future changes harder to get right.

We have to explore alternative options, until we have something viable which doesn't play locking games
we'll have to live with the current situation.

I'll keep thinking about this and will try a few ideas.

Thanks,
 Nik
