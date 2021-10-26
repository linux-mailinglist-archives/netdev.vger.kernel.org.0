Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2D043B7EC
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhJZRNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:13:18 -0400
Received: from mail-sn1anam02on2040.outbound.protection.outlook.com ([40.107.96.40]:24131
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237755AbhJZRNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:13:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aV3WHDAZ5VVfaW17GP+LumUU1d8Ciio/0CEPaCU64EizDHZT/bovNODxFy1rRhlQKHRlLz9Oz5eAmCzjNEEiTVd9UD3ouDBGh3jjdB+lztnINOZcwNJMaNQhIA0j+4GNIwGDCQTHK/MyYCV8kc1By/a8GJx8L4b995fVxhJW4HUwfe8+oS0Qv2TSYheNjgiQq9T1lAHOCr3oo9I3gGDH2aTkKF2Fs07pO3IwTkChk5dFf8m593K7J4HNRmfnUcaB3v2pvbQuSBRCnOPSSeTY2OuVoNTIYZqY4wgY2/+yIZLLIKB/TOsjhtzXYWJYu9bnC8eQrGI2D/qgTwdF86w3IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRtcE1FZW0XAZYzWlz80yqzi2UvOzpsyX4iFVVKc4/U=;
 b=Krt0woxSq6KuZ0lR5DGRR6Gaykefgka/fiRC9FPhaCXUEcE9rXqmtaqBxw7twaRtVYiZS/rLME1s6EPHSKZ5DJBOs3B9eTO5jNz7ljmU9c5s4Qhmd4SvqmZEnP6C0KJ3x4m1ltNqkXmyalAFk1zONYCW8xlmNx3njQPUTtZTboEdPklpxwDyzpSYlgra8tJrkkbYfav4Ku01qDxLGdDcUBjdHb5JkUTtV0ehRsZa06Df2RtNdMiOUNNuAKi5rPG2LUrEJWSOdkHVVQNpRDZ8sTx7j9sixH7S97m/g1uFttFr379X+dNfqAUCw8/GVvcx7aR8GXUXz5z83uUAqaOiHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRtcE1FZW0XAZYzWlz80yqzi2UvOzpsyX4iFVVKc4/U=;
 b=k+zdzzh8zjmLWbseF+N6QL6BtYm8sJ5FpQtUlSz+KnDAALnVXEQ4CV3f6cZkSAfubN9b/JrRuxERH2omopF6jaVVdyO3dmXY2qIXb/g6wnaz+l12I3kdeLKbufh0cJTi8iQsGqL/2YsNEepV+gJDGGsxvjXYPtAkX5CPqt76Tz5edNZa4a9DtwpNBPy9DpHtUNltPUl0bujYtI5X9fpFu95u+Jo9E5cAogE2oUoGGOEfsnp3gH7Og7i1lSunCx5TGRfP4nxHv2L13bDVcD4/w3Pju3mtGFaA0W6FH0+y3JHjQPsZ+597BKhWgJn8qK7hoUKZC8QvtobrickVQI6wYw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 17:10:52 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 17:10:52 +0000
Message-ID: <a703cf3c-50f5-1183-66a8-8af183737e26@nvidia.com>
Date:   Tue, 26 Oct 2021 20:10:45 +0300
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
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026165424.djjy5xludtcqyqj2@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0018.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::31) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by AM6P192CA0018.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Tue, 26 Oct 2021 17:10:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 727b9911-6580-4388-aeb8-08d998a3905a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5056:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5056294C40D5C52834749C71DF849@DM4PR12MB5056.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4CwG4fSH+yBvCpJixPrhkptK5Pa6BiEOkk/sCpxwlpg4OQq9YL5Q3lM3BQtCJVf+aH7dj+0JTv2VSZuSc5UZYqx8bjp1TpfziYiUWSOTzkZrhxLZ8cWy46VQIRbyvzl8GOJt2M9nxKKfJuSsElNpZJqF3gNeEbxzMHR6yjjCfengFeHkgzjgwBLqe9/q7MTIODGRdM56LDdRbKrDF+UbrXqiGMYtt8Jt2G5tYHQ8L2gzlbcalzqYDukSAXnVPCyPQPUOKgzi86PMVUFn8XNxYx15fQKJq2tevbMA7mqlCHAoOLEsKMQ6/+3qM4IDnaP/EdLiTYonapzayVo5gbXxPB2Wd7x8atNKihPCF+rWJLLhSP0zWaMXCb6OS/7csg5bBma9gXGh13nYAPvv75gWMVS0Gdnd5ewZl0QpApjk1Ig4f6pEyPxAnh9v5cyWCiDmMmdL3R8kFiGOSycvBnKf2T4D/aoeqoAkk6Ij7VpkTdi8in4fGlCOsv3P1O3vuYnUh1Gx5mjiF8NlsqVCkvxx+v7zM0g0dqfGnRwf/hCuZhXP6M6HoxOZQDKIZI+9AEj5vaWfP4OAYLEi2WikbSQs7MVkliVUXXvQqju1fjc9EBCSJDbVQzWHOXf2Op62ii8OofQdGdRQGAdClO7dzv6kQ7U7x44dYu+IF3PFG/A8NdSJDIcx93p2vHVYdSuIISPxDzb0b2YL8udXE3rCiDYT21QldCXjhobEdb1Ze8Gv4Tk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(31686004)(107886003)(83380400001)(6486002)(6916009)(6666004)(8676002)(5660300002)(31696002)(26005)(2616005)(4326008)(86362001)(66946007)(54906003)(2906002)(16576012)(66556008)(66476007)(8936002)(316002)(36756003)(186003)(508600001)(956004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjEwOC9qZnJ5UUxEVUwvM1A3eTEwUXdteTVnMzRHSmw4QW5xN3dTYUE1L3p4?=
 =?utf-8?B?QXdCYlZmd0hlclBDaTB2S2RKZUpramxmV0ZrblhuYm9vZ0pwY3l2cTdWQ1FI?=
 =?utf-8?B?ZFRoUTN3UUphYXpidW1JY2xONzBHVWZSVHRCL29sV0hONmtta3lQYTg3ZXpG?=
 =?utf-8?B?SkdpNFMvMXRybEVEWjlIejVuSjZ6eU1ITFdMNGtTZGtpQVNFZysxR2Z2QVRR?=
 =?utf-8?B?RUw2Y2NOYUkvYXpYUjN0YzFIQnFTVnVFS3NJL2x6MXpCYWhGb2hMY00zYUFI?=
 =?utf-8?B?cCt2RTNIcHB4NnlrcTgrYUFwVC9SbDg2S3Z2U0htbTZ0enN4NWwzdzRoOTdQ?=
 =?utf-8?B?YmYxamRXNjZUSkN0TE5BVGY0YzdOVmJnL3Z0amg1TmljVWo2L1VjZGNGSlVB?=
 =?utf-8?B?VWh1OFQ4YVJva0lFV2lPRURmcjl4a2JlVWhJbGN2dWZEb0lBdHJJbnFJaWJt?=
 =?utf-8?B?UWh6MnpDQXczekRNSHdOdHg4NkxGbTNURTE1elVPL09CdDlLc1ZnNUFzU21V?=
 =?utf-8?B?WHFOQkhMMmRXT2J6SVRTcmxLNGtYTDJ6TWZ2NFNtUDB4NVJnU2QxNG5aSDd6?=
 =?utf-8?B?WDVGZUcwcDNFZVJJWEIvd2Y4V3ZQNE1TRVRNWkUvL1AwUHYrY2syOUQxYndv?=
 =?utf-8?B?cDRxa2w1S2JKTG1TSFphVWd3RHVqaytSdkJaMUw3bFJScklXVkNJWXdiVkhO?=
 =?utf-8?B?NEVCY1FLQ29qY0RmZlZ6YkFpVHRnYWdteUtPM0w3TjJMUkh0cGtIblZCUFVE?=
 =?utf-8?B?UmQ1WnhoNXp2ZmFGbVRvOENqTXM0TG43ZUl0a3N0aE02Ui9nZjhsem5UM3RI?=
 =?utf-8?B?dEhSME5JeVhpd25xb0lqQ2V4b3VOdnZZWFZLbWw1TnBScFY2TWs3eW12M0xm?=
 =?utf-8?B?cXZRQ0UyaFl5ZHJONXZaS1FTOEo5QlVMSXA0S25ReWkvb3ZidGdSRlNmeXhi?=
 =?utf-8?B?OW5FUTBCMHA3a1BBVjlaN24wQ2FCSzh4MjBxWjcrU0QxT1NOSytYNFhMZmtI?=
 =?utf-8?B?VTJQV0JXbHFzMXg0ZHp0aU9sMzArK3NoelVtNEo5ZFJSZGIvaWY0dEdYTG9F?=
 =?utf-8?B?SDAxbjRXUmtsdDN3a1BoZHJvMnRaRDdhVFg0UVVDYmxIRkZkenJXUXdxY1hP?=
 =?utf-8?B?RUdGbTBUOUJ3Y1owRUozWDA1Ymd4NmtSMkppbFR1VndrRWZRVHVCd2lMdlN0?=
 =?utf-8?B?RkxmWEp0aVpGZU95Sk5aZ0daby94Zmx3WVd1QzkyQ3JZTHlTQURib01PUVFQ?=
 =?utf-8?B?QlZjZ1RuNU1HRWRmWVFUelVlK0hScTJMR3FlVkhJd0cxVGVJakNvTjl3dWh2?=
 =?utf-8?B?MmRYVCtCOUZaNVNrRWVnZHY3cERDLzg3SUFEMnA1cUpDK0YrSmlScHJkNnRw?=
 =?utf-8?B?Um5nZzMzcUdzdU1KZ1dtM2g0ZkZZaGVURzNBc05iejFpNkxySGJIT3U2TUtO?=
 =?utf-8?B?TWpBQ0pNUmhNYU5KaWk5WWxabmF1Ujlhd2UrYjVRZ1pxaXZHTVpSL3JZakF4?=
 =?utf-8?B?amsyS2JsM0xjdW9FMmFtanRST2tydUVGZld4Y3pVWUFjaGZXZHZ6SXFYVXNj?=
 =?utf-8?B?K3ZQcmUyU1JQbE9FS2J0a2lQNlhUaWJaSSs0eWJ5Rm0xSVo4V1Z0TW5Db25y?=
 =?utf-8?B?U3FFVVJHR0JiWjBXeWNEWVhxVWlzYWJGNThlTHlvNFpwM01oYW0zOEp2RXN2?=
 =?utf-8?B?U1EvaEowQnhmK1BYNmU4Qm9FN3BiRTIxUm5tbDM0b09yRlJnU1ljWEIySURh?=
 =?utf-8?B?Tms3eVN4bkc4dWZMZWMzL0Y0eUFrV2k2aVRPQ1A5V0dZUTZybmh4Zmx3TzNC?=
 =?utf-8?B?dlFQdFdpYUg0UnZQVDZLOTJHcG90WEk2VU9EUnpWbXFkZ1ZQc2c4ZEEybExR?=
 =?utf-8?B?dm5tbjBReW01dWZ2WEN1U1lXWi9ycXI3czRRZ0gzaEg4Mi8zTkovTGpCRjZ4?=
 =?utf-8?B?ZlBqMzRXeGRkdER4V2FQbTA0cDRLSis2ZmVjUVRRLzJzSUQ5SlovMmpNb21C?=
 =?utf-8?B?aHM3VnlVRVNQZlBYdEJFN1VVR3pDcW0rWklkcW9XaHdyN2taWmVGdFBuV3dJ?=
 =?utf-8?B?THYzNHpMVGlNeDVkZ1Q0eHFGQnN2dVhER3IvbnJpRkxiMkJYdzQxMndGNVB6?=
 =?utf-8?B?WE5kZXhVWDR5TVdzcFE2L1J1eW8zZ2RiRHl0QXcvS2xwVnRERTRucFdvUHZF?=
 =?utf-8?Q?qU9WQVoCeby2l5vrPDGkbpY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727b9911-6580-4388-aeb8-08d998a3905a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:10:52.0948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoBSSXSMCaDYOMbL6xzGqGbdyMYs9gjFA87c6ac/QnCrQ/K1i9Iy+Mk4Q0S4ODWhNRcqXqnhp/ADpK3OsH96Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 19:54, Vladimir Oltean wrote:
> On Tue, Oct 26, 2021 at 03:20:03PM +0300, Nikolay Aleksandrov wrote:
>> On 26/10/2021 14:25, Vladimir Oltean wrote:
>>> On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
>>>> Hi,
>>>> Interesting way to work around the asynchronous notifiers. :) I went over
>>>> the patch-set and given that we'll have to support and maintain this fragile
>>>> solution (e.g. playing with locking, possible races with fdb changes etc) I'm
>>>> inclined to go with Ido's previous proposition to convert the hash_lock into a mutex
>>>> with delayed learning from the fast-path to get a sleepable context where we can
>>>> use synchronous switchdev calls and get feedback immediately.
>>>
>>> Delayed learning means that we'll receive a sequence of packets like this:
>>>
>>>             br0--------\
>>>           /    \        \
>>>          /      \        \
>>>         /        \        \
>>>      swp0         swp1    swp2
>>>       |            |        |
>>>    station A   station B  station C
>>>
>>> station A sends request to B, station B sends reply to A.
>>> Since the learning of station A's MAC SA races with the reply sent by
>>> station B, it now becomes theoretically possible for the reply packet to
>>> be flooded to station C as well, right? And that was not possible before
>>> (at least assuming an ageing time longer than the round-trip time of these packets).
>>>
>>> And that will happen regardless of whether switchdev is used or not.
>>> I don't want to outright dismiss this (maybe I don't fully understand
>>> this either), but it seems like a pretty heavy-handed change.
>>>
>>
>> It will depending on lock contention, I plan to add a fast/uncontended case with
>> trylock from fast-path and if that fails then queue the fdb, but yes - in general
> 
> I wonder why mutex_trylock has this comment?
> 
>  * This function must not be used in interrupt context. The
>  * mutex must be released by the same task that acquired it.
> 
>> you are correct that the traffic could get flooded in the queue case before the delayed
>> learning processes the entry, it's a trade off if we want sleepable learning context.
>> Ido noted privately that's usually how hw acts anyway, also if people want guarantees
>> that the reply won't get flooded there are other methods to achieve that (ucast flood
>> disable, firewall rules etc).
> 
> Not all hardware is like that, the switches I'm working with, which
> perform autonomous learning, all complete the learning process for a
> frame strictly before they start the forwarding process. The software
> bridge also behaves like that. My only concern is that we might start
> building on top of some fundamental bridge changes like these, which
> might risk a revert a few months down the line, when somebody notices
> and comes with a use case where that is not acceptable.
> 

I should've clarified I was talking about Spectrum as Ido did in a reply.

>> Today the reply could get flooded if the entry can't be programmed
>> as well, e.g. the atomic allocation might fail and we'll flood it again, granted it's much less likely
>> but still there haven't been any such guarantees. I think it's generally a good improvement and
>> will simplify a lot of processing complexity. We can bite the bullet and get the underlying delayed
>> infrastructure correct once now, then the locking rules and other use cases would be easier to enforce
>> and reason about in the future.
> 
> You're the maintainer, I certainly won't complain if we go down this path.
> It would be nice if br->lock can also be transformed into a mutex, it
> would make all of switchdev much simpler.
> 

That is why we are discussing possible solutions, I don't want to force anything
but rather reach a consensus about the way forward. There are complexities involved with
moving to delayed learning too, one would be that the queue won't be a simple linked list
but probably a structure that allows fast lookups (e.g. rbtree) to avoid duplicating entries,
we also may end up doing two stage lookup if the main hash table doesn't find an entry
to close the above scenario's window as much as possible. But as I said I think that we can get
these correct and well defined, after that we'll be able to reason about future changes and
use cases easier. I'm still thinking about the various corner cases with delayed learning, so
any feedback is welcome. I'll start working on it in a few days and will get a clearer
view of the issues once I start converting the bridge, but having straight-forward locking
rules and known deterministic behaviour sounds like a better long term plan.

