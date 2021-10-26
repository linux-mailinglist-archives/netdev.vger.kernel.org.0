Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD1243BB48
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhJZT7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:59:34 -0400
Received: from mail-dm6nam11on2050.outbound.protection.outlook.com ([40.107.223.50]:44871
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230526AbhJZT7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:59:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBOKvuCJ7v8Q3PEoVOCs4gdzK1sogqqSRYQGFKwPVPGQ+2M3ho5I5dVVSdz7D7cSG3RGsEHQCqTyseyFMWZq4z1NoUiEutTKekVj8pra/6TCWPMHNjHd738v6Vi+Fsuy89/Jfg5/o9s1CgegAwvu5Dt89YRsZI9zwOMgZhCuauitY2FCfpHPqVx2Cg0fWgOifMDFCHL4AgxcOKUsnXyAre8lmZmtPHiuvUDWAoHgNUV2awTb5I4nW0CL5NPfLIlLM1nCosaRndKXSJNVtgz50n/ujBTRH8dGUyj/ewHoRb2vVk2MMdqczASGDoSam8k5sZ9rA6fPMutt6bq7iJ9dXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6DFHD/PBhEeFJwsbtlYpMFTU4zhplUVLGe04EKZ8/E=;
 b=cQ+2Z0jFB1An+gDUfBHhm5Ma2WR5ua//CT67IGi9YiK718ES+xjDg/O25fClwsi7GSG18DH9yiilYD4XRf7iB66+CVKDscLO47oV+UpbjYfeBST5HssOwEnnxwteQYeMM2X+vhEwVQDzTQ3nXP96/bdbEl6sStSAu8V4Q8QIY4wzGW4GbeaKCs04UyTiEciV5AWHdSAE+AC7A6BlYoQE+P5lVuUznJU99Bi7cBrkm/lkwP9w6ib62iWWTW0L7uq0MGxKaGBKDGNCnklFPheD1zSnPVsX+r+JASZwhqdMxG/JlC8fllbfyjG4p2QSgHWLq5P/P7lIkivLYkNCMSk+Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6DFHD/PBhEeFJwsbtlYpMFTU4zhplUVLGe04EKZ8/E=;
 b=WTpjlCVwizbLE3tiR9M9Pla8mwURYEa1IEvbAZnplnSHlT3Z2lsAlsJq3RdgIyoPz7b1KK3CiH9lKER6HkP1b8Uqu2jIl2t3s7RSmrC2Yfrj8V7GnFRxb7v0TDniHfMvc5K1L4lScCwsdivnEbDMv6Ga4jwfTK8NQdvqQs8Ufa53HGPAapG00+BrSJQlDVwq7WNlG/MACYadOscc+qJlRm2uzki9zWohvzTVzF5i0a1qM3/WkQTaF1dvqQeXgM/dD+J3TqZ95qvGCKB+dI/0mUsO3TrGW6XFTTtUSN8xf9hHEW5Uabuq6/nqSfeo34MXED5LZciA0Wo6ynueZuEjEQ==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5567.namprd12.prod.outlook.com (2603:10b6:5:1ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 19:57:08 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 19:57:08 +0000
Message-ID: <dcff6140-9554-5a08-6c23-eeef47dd38d0@nvidia.com>
Date:   Tue, 26 Oct 2021 22:56:59 +0300
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
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026190136.jkxyqi6b7f4i2bfe@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::6) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by FR0P281CA0056.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend Transport; Tue, 26 Oct 2021 19:57:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d56a0bd6-5153-4f54-5227-08d998baca4f
X-MS-TrafficTypeDiagnostic: DM6PR12MB5567:
X-Microsoft-Antispam-PRVS: <DM6PR12MB556757FD8AA580ADEA624D16DF849@DM6PR12MB5567.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOBTmN1afVCYG+FwSBbNT/R+6E86QLYno2jBbVEOY25O30ybOb06X+ZMXirjO6CRNPVkczzrpQDxT+e5qdcc3JEvCdtX1df/QDdJfg4fQhEFDg1R1CIKPf6bdOh7KVaxU4bipM6tfF5d/nIlsTCOxUnqyCN8LkUv4ZUehCjNDRCcfQSO3OIqPTMjO6r0SX5eBk4hB85Ewz+c655iWFREKrhtbjtgM9iPqbzUpNEHwOLZR3bxFYpDRVzRKBbhRlHMHZEWERI+jLGN6sfyDFkscEaO/0PadkJPVyqBhaAqXtodXzBm/FjSkNZqyqmOvHGRIRhZH+d9t3bmZ7q1XReqNYp2SPoR0PGfLwDz6mzN4DmMorolcAegVuTwjcDKnVsDEv8P3AFUImIOvvXNJ1i3W5ylsR9Yjzh0dL1t1Fp9M3ylvc2+hrEhzJgNCCsx5hkEcTrD/e0x2D60qxRVNQQO0Qg2X09lrkNYzJ5RQ6QtZaAlmpaFKg+ghR2aGS0Yz5xMVzNrLPNXmMfjA6qi1PrGNp3OzfoIFT5VpvzNGaiGXhv+3ZSHx1yBAZ248XJjqK9pS9LfD2aLl4NPdgbUyV1MfxdKJdvPnKWaylhT53njKd2RTrIDqdv035PF1qbuZijiBH7Y9rcEmlGl6BepizpA2PWPCae5H4fThO1a59xpHrNYhsDKNK+olw8Br8A+kv3MjfJqPvi/LNcGguEiV06Om+pEndSbRoDRpVQTtLROwd8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(316002)(107886003)(31696002)(8676002)(508600001)(66556008)(5660300002)(16576012)(86362001)(54906003)(53546011)(186003)(38100700002)(83380400001)(66946007)(6916009)(6666004)(4326008)(2906002)(31686004)(6486002)(26005)(956004)(2616005)(66476007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFN1R2YzK0grMkhkWkhJSzRuUEYvV2dJOTJKWWVjVjVWcHRHZ0JQemk1WXAy?=
 =?utf-8?B?ZmxBOHVZb0FqTjlBbU85L2FIYklWVmdWV2pZZXl0SVpxQ200SHhWSHVCWFdG?=
 =?utf-8?B?NmJYQzRXNVlpeUhmcHhSMStFZjRFRFVVU21CWnNRVXBkZ2Y3V2orQ2NCSGZq?=
 =?utf-8?B?MFpjaElUcUtmY0RoUFluclFzcEJ5Tkc1cUoyOUpQc0Y2UmR1aml6eThnQndm?=
 =?utf-8?B?cHhaTGtVYUFZbW11cG91R0lzQTA0K0M0YkJLMkdVWkM0L2QwU1p4WERrSjRk?=
 =?utf-8?B?dERJeGJpZGhlWmtGNkxpZVA2cjBKL0RkalVDZWhKcmNwVDNUbi9NcllpNDRo?=
 =?utf-8?B?SGFsaUU3ZGFrVk9BM2g5N3pQWWw2NnFoU05wYTZiS0pnazM1Vy9NRzJqM1lT?=
 =?utf-8?B?Smk2cStwVXpJVjAwVkNuOFdNbFpSR3ZZeXM2ZTgyQzd3YnVHYjNDeW1US0xO?=
 =?utf-8?B?d2pHK2Z0d0x6cHdsUTF2djlnanJaVUlORmw1S0Q2c2Y2REtHSDhuVHc3QVF1?=
 =?utf-8?B?Qkxmc2VEQU05a2dnRXpOeUFuYXFBSmVqWHdYa0FZVk4yRnNlN2tHZ0ZtOTJo?=
 =?utf-8?B?cDNZRG9QWHNKVXUxSmNEbE5IQlo1YlVRR0oydTJzVmhUSWgzQzhPMWRuUVly?=
 =?utf-8?B?VUFaajBUVHBkYlJNek1vT2oyTTA2dUVTZ3dMc0xNMWlOR2JxZzVubXBmamRt?=
 =?utf-8?B?VUMvTmpub3lIbElnUi9RUTBaRFpTMVFST2ZDVzhjWkVZeVo3elZEYnNyQmxJ?=
 =?utf-8?B?QUlCeUJ5ZkZDNXNSaVRvSnJFakkvM3I5M1hqL2h6Vk4zL01ndUJMSW1CWVJJ?=
 =?utf-8?B?akZnODB4YmhhNEdnSUxHeDlWWDl1RDh0cW8yV0FZYy9ySU91NlN6b0pWUFVB?=
 =?utf-8?B?QTJYOUg2T01PSC9aUWFjOERXM3JZaitnVWRWQlQxTmNBdzFGYTRRbFYxeFgv?=
 =?utf-8?B?OTh3WkE4RmwvWUVPKzhpb1QvVFJkbXd2Rktva3JuMC92cFpRc0JGSGJ4TDla?=
 =?utf-8?B?L2tEckVEZUZ1YkYzalZrNlhVY0VrMmhmeXZlUW5LcEcyYzcyVG5vTXZqWC9i?=
 =?utf-8?B?ekFualpsUStFeG9pVk8zR1hicjNvcXdPZS9WdU5PMjVST2RLc2todGNmSGVm?=
 =?utf-8?B?VHRyMDFnbExWbnI4VEFscTZXaUVQemJ5YzFSR1NSOW1GOTJTSFlwQVF5K0pN?=
 =?utf-8?B?M2pFbjEwbUZod2l4VmoxaWhIcW9QVnRZUHIvazJGWlpFTk1nc1lFSkV4eVNR?=
 =?utf-8?B?Si9rY21xbk51bE5vNXNUR1kvOHE4QjRpT2hyUUlWL1ZtYk9NUTV0azFTTWk2?=
 =?utf-8?B?UTdKdG1oZ0ZGUTJyZnB3eGdidEZjM0hEVTA3a2V3V2N2TFY4VjNLZ2VwTmFk?=
 =?utf-8?B?VzZ6dVJRd0dxeDBiaFU5QTliNzJUejJoV0NMWUx0STZmK0UxS0doNHR2ME1M?=
 =?utf-8?B?ZGI0cTM0MUF3b3NxS0FjTnNPajRhb3krWHljejV6RW93MU45SFNwVkIyVlJy?=
 =?utf-8?B?bnFkSmNYRUpJUzJvbk5OdFQ0K0NxYzlySDlxMHY1Ym51NURTUC9vOFBHR0JB?=
 =?utf-8?B?K0RCTWlUVGd1MGRWMDZDZ3lIazFlMHBxUGlESTd6N1VkY0Q2OE5NeEUxYUU5?=
 =?utf-8?B?RzR2dDZGQzljbnNDL3YxYmhHeVUvZSsyTllMRDM4UDBTUU5WaklNSzFFbHRn?=
 =?utf-8?B?a1NnTDhuWWF3MlBhQnhwbkN5NTZzR3htMlVmYzNac3preXpvaXFwa0pMK0lG?=
 =?utf-8?B?dE5rMWR1cmNGYXlMU2FFOWZ4K0F6OUVCSFdjV1N2ajdwMG5GTWpYQXJZSWtV?=
 =?utf-8?B?VXNWY3lhcDluODRNYjdleTRObXJLUFpsSTNvQUpvQmkyUVpwZHpyNzFCMFZI?=
 =?utf-8?B?NERiK3liOWV1ZTZTWnJsaEpmTlVtV3Z5eGJSeThyOTBhNVN2NkxSYW93YUI0?=
 =?utf-8?B?R21WTG1nSmorNVB1VE42SVhUMERDWVlUNy9LOUx6djZCQ3EzYlg2QitjU0ph?=
 =?utf-8?B?WWh1K1hxWDZ0NGk5NTFZNDdvcU9yaHdsQ2twZnZoN0VneitJNnRiNjJmbXo4?=
 =?utf-8?B?VHlWNktzc3dNUXNtMkV4WUFxUTUvNEgwMnd2MHFuR1JEbXphRjVJTlJmM0gy?=
 =?utf-8?B?dDFEcHRBdEo5UTZwcFlDUVBCM3EvcXFNLzdsUVdEanlhZUFFRGhickdsUTFj?=
 =?utf-8?Q?6zEGDnw1oSCLOWn5BlM9+gc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56a0bd6-5153-4f54-5227-08d998baca4f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 19:57:08.0447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CJyLLIeyow5Nxg9KQ4wMYap76xOXbICQJGxXLJN8b7/ilcKW7g/f9ZhuwDqDb0dhcMZqkaLGfELjIo9Q5qf4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5567
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 22:01, Vladimir Oltean wrote:
> On Tue, Oct 26, 2021 at 08:10:45PM +0300, Nikolay Aleksandrov wrote:
>> On 26/10/2021 19:54, Vladimir Oltean wrote:
>>> On Tue, Oct 26, 2021 at 03:20:03PM +0300, Nikolay Aleksandrov wrote:
>>>> On 26/10/2021 14:25, Vladimir Oltean wrote:
>>>>> On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
>>>>>> Hi,
>>>>>> Interesting way to work around the asynchronous notifiers. :) I went over
>>>>>> the patch-set and given that we'll have to support and maintain this fragile
>>>>>> solution (e.g. playing with locking, possible races with fdb changes etc) I'm
>>>>>> inclined to go with Ido's previous proposition to convert the hash_lock into a mutex
>>>>>> with delayed learning from the fast-path to get a sleepable context where we can
>>>>>> use synchronous switchdev calls and get feedback immediately.
>>>>>
>>>>> Delayed learning means that we'll receive a sequence of packets like this:
>>>>>
>>>>>             br0--------\
>>>>>           /    \        \
>>>>>          /      \        \
>>>>>         /        \        \
>>>>>      swp0         swp1    swp2
>>>>>       |            |        |
>>>>>    station A   station B  station C
>>>>>
>>>>> station A sends request to B, station B sends reply to A.
>>>>> Since the learning of station A's MAC SA races with the reply sent by
>>>>> station B, it now becomes theoretically possible for the reply packet to
>>>>> be flooded to station C as well, right? And that was not possible before
>>>>> (at least assuming an ageing time longer than the round-trip time of these packets).
>>>>>
>>>>> And that will happen regardless of whether switchdev is used or not.
>>>>> I don't want to outright dismiss this (maybe I don't fully understand
>>>>> this either), but it seems like a pretty heavy-handed change.
>>>>>
>>>>
>>>> It will depending on lock contention, I plan to add a fast/uncontended case with
>>>> trylock from fast-path and if that fails then queue the fdb, but yes - in general
>>>
>>> I wonder why mutex_trylock has this comment?
>>>
>>>  * This function must not be used in interrupt context. The
>>>  * mutex must be released by the same task that acquired it.
>>>
>>>> you are correct that the traffic could get flooded in the queue case before the delayed
>>>> learning processes the entry, it's a trade off if we want sleepable learning context.
>>>> Ido noted privately that's usually how hw acts anyway, also if people want guarantees
>>>> that the reply won't get flooded there are other methods to achieve that (ucast flood
>>>> disable, firewall rules etc).
>>>
>>> Not all hardware is like that, the switches I'm working with, which
>>> perform autonomous learning, all complete the learning process for a
>>> frame strictly before they start the forwarding process. The software
>>> bridge also behaves like that. My only concern is that we might start
>>> building on top of some fundamental bridge changes like these, which
>>> might risk a revert a few months down the line, when somebody notices
>>> and comes with a use case where that is not acceptable.
>>>
>>
>> I should've clarified I was talking about Spectrum as Ido did in a reply.
> 
> Ido also said "I assume Spectrum is not special in this regard" and I
> just wanted to say this such that we don't end with the wrong impression.
> Special or not, to the software bridge it would be new behavior, which
> I can only hope will be well received.
> 
>>>> Today the reply could get flooded if the entry can't be programmed
>>>> as well, e.g. the atomic allocation might fail and we'll flood it again, granted it's much less likely
>>>> but still there haven't been any such guarantees. I think it's generally a good improvement and
>>>> will simplify a lot of processing complexity. We can bite the bullet and get the underlying delayed
>>>> infrastructure correct once now, then the locking rules and other use cases would be easier to enforce
>>>> and reason about in the future.
>>>
>>> You're the maintainer, I certainly won't complain if we go down this path.
>>> It would be nice if br->lock can also be transformed into a mutex, it
>>> would make all of switchdev much simpler.
>>>
>>
>> That is why we are discussing possible solutions, I don't want to force anything
>> but rather reach a consensus about the way forward. There are complexities involved with
>> moving to delayed learning too, one would be that the queue won't be a simple linked list
>> but probably a structure that allows fast lookups (e.g. rbtree) to avoid duplicating entries,
>> we also may end up doing two stage lookup if the main hash table doesn't find an entry
>> to close the above scenario's window as much as possible. But as I said I think that we can get
>> these correct and well defined, after that we'll be able to reason about future changes and
>> use cases easier. I'm still thinking about the various corner cases with delayed learning, so
>> any feedback is welcome. I'll start working on it in a few days and will get a clearer
>> view of the issues once I start converting the bridge, but having straight-forward locking
>> rules and known deterministic behaviour sounds like a better long term plan.
> 
> Sorry, I might have to read the code, I don't want to misinterpret your
> idea. With what you're describing here, I think that what you are trying
> to achieve is to both have it our way, and preserve the current behavior
> for the common case, where learning still happens from the fast path.
> But I'm not sure that this is the correct goal, especially if you also
> add "straightforward locking rules" to the mix.
> 

The trylock was only an optimization idea, but yes you'd need both synchronous
and asynchronous notifiers. I don't think you need sleepable context when
learning from softirq, who would you propagate the error to? It is important
when entries are being added from user-space, but if you'd like to have veto
option from softirq then we can scratch the trylock idea altogether.
Let's not focus on the trylock, it's a minor detail.

> I think you'd have to explain what is the purpose of the fast path trylock
> logic you've mentioned above. So in the uncontended br->hash_lock case,
> br_fdb_update() could take that mutex and then what? It would create and
> add the FDB entry, and call fdb_notify(), but that still can't sleep.
> So if switchdev drivers still need to privately defer the offloading
> work, we still need some crazy completion-based mechanism to report
> errors like the one I posted here, because in the general sense,
> SWITCHDEV_FDB_ADD_TO_DEVICE will still be atomic.

We do not if we have ADD_TO_DEVICE and ADD_TO_DEVICE_SYNC, but that optimization
is probably not worth the complexity of maintaining both so we can just drop the
trylock.

> 
> And how do you queue a deletion, do you delete the FDB from the pending
> and the main hash table, or do you just create a deletion command to be
> processed in deferred context?
> 

All commands which cannot take the mutex directly will be executed from a delayed
queue. We also need a delayed flush operation because we need to flush from STP code
and we can't sleep there due to the STP spinlock. The pending table can be considered
only if we decide to do a 2-stage lookup, it won't be used or consulted in any other
case, so user-space adds and deletes go only the main table.

> And since you'd be operating on the hash table concurrently from the
> deferred work and from the fast path, doesn't this mean you'll need to
> use some sort of spin_lock_bh from the deferred work, which again would
> incur atomic context when you want to notify switchdev? Because with the
> mutex_trylock described above, you'd gain exclusivity to the main hash
> table, but if you lose, what you need is exclusivity to the pending hash
> table. So the deferred context also needs to be atomic when it dequeues
> the pending FDB entries and notifies them. I just don't see what we're
> winning, how the rtnetlink functions will be any different for the better.
> 

The rbtree can be fully taken by the delayed action and swapped with a new one,
so no exclusivity needed for the notifications. It will take the spinlock, get
the whole tree and release the lock, same if it was a simple queue.
The spinlock for the rbtree for the delayed learning is necessary in all cases,
if we used the trylock fast learn then we could directly insert the entry if we win, but
again lets just always use delayed ops from atomic contexts as a start.

All entries from atomic contexts will be added to an rbtree which will be processed
from a delayed work, it will be freed by RCU so lookups can be done if we decide to
do a 2-stage lookup for the fast Rx path to reduce the flooding case window that you
described above.

We win having sleepable context for user-space calls and being able to do synchronous
calls to the drivers to wait for the errors.

