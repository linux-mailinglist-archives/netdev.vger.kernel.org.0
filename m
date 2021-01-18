Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111CF2FAC8D
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438034AbhARVXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:23:48 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:26551 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389246AbhARVX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:23:29 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6005fc260000>; Tue, 19 Jan 2021 05:22:46 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 21:22:45 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 21:22:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSbUAGYD8nZ9c9E4V60GotRjiC5F6hn9qoFTjaIpPipApSk1CeJMbnDMF6L3CUCVFSjOpsOpTGL373nuaR4RnSHSfOQQVlO2Y9nGWjBR5n0eGu+ruRbnxjDADSKJTY4wwqDa0fHUlWcwrZwoXsrRow1d3sXKwVs3a6SeIPREtBlmZcKHaA6aWPB9sL1VqEPH/kgNGxJPBfWivmiSSs25VV52Re873drWPWmwA0rwQ7r+uy8T/ub5C8+UcjdFugCfUY6vx7qRGFwaTcdA5n2nMt7bgHGQk55lSgCmOhzGoF0kIKftajh5QDGsfg9b55X5gs77Dss8gKI1xDBVfTLtnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfJF7tMyjo/8pbVt+tQxffWxVz79qTviuBECDjy/LpA=;
 b=O2ol1lDLwODzFDcq94ZYbqlIYbJn0+FZL7T3NphbdsbS5NG69AaFM5xn+4w+vA3qfSmESBhz9YVlbosfAtXkBekK6LSypkoj4HCYBYLhkfG0vFoglbfZoSypY9eD25om6zaWMqL33xSJQVdEKybP/Si5kRm3urMooZ5f8bDmWgMcAYVEzasYA01SLPM/KZcvdbeWvZLiujlKKc91pJD2BLTvOcOcQY/hk1wgrTkjrmgDwnLz6GFow7ws+2ogUlfL6FKOVdIkCWEGjladrN3LZBG+q+hiue2YS/3CvCBpfcmT8sa1fpEzVeLZgTKN7rQFgd2o9M+ysmd1Flm7ncCTYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 21:22:44 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 21:22:43 +0000
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <roopa@nvidia.com>, <netdev@vger.kernel.org>, <jiri@resnulli.us>,
        <idosch@idosch.org>, <stephen@networkplumber.org>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf> <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf> <87o8hmj8w0.fsf@waldekranz.com>
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
Message-ID: <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
Date:   Mon, 18 Jan 2021 23:22:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::23) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 21:22:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c48ff00-e660-469a-c0a1-08d8bbf7317c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4106FAA879EA02F61229BAB6DFA40@DM6PR12MB4106.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gPAaNtHL1JkykQuwFg1UjKNok9Qi6YI4NhdqDXxNY7ZKTsaK7l9ffbQ3GqYFgSeFBGzTQd2h0p4yAsJJzqA29KHyP37m5+pfvc/OqP8KK+FiGFTxwMwxPIxZGHQfL0w/4TibyzjTuwEXdP5Rx8WVUYEpvKSarr/DqYUyn+7sS3mZDiRjE3ZIGUSVzqQ7JIm2v0lyIcVrE7hSiWM0irfGixx6Hz17rMyt36XSQmgp6a4rpNVth1P5XkTtjjUr9v9XzjmjBaPNwzxCriqpb+8tBMMB5OzMJJ6xE7r2giM1V0KB4rUEEkacExywgFyxfuFIwXOCez41FFZ6rGX1Iuu2zqTyPAJG2dGXPej/l1oaU8szUnRf87xX5ICONP4rC1YQYmBrke2CbfOToCGzwiCJx7JwBkBm0sfIJK0qBI12Bf2xN5Zr7DCWgxa/YvFveP5rsEpzieyjJWlhV3T1Zhg0/twKzFwB4WBz3zMichQqNSA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(86362001)(31696002)(8676002)(2616005)(956004)(15650500001)(16526019)(8936002)(83380400001)(4326008)(36756003)(2906002)(316002)(110136005)(6486002)(16576012)(478600001)(66556008)(53546011)(5660300002)(66476007)(66946007)(31686004)(186003)(7416002)(6666004)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TXNMcHpERFIvM25BYmloZHpmSHVNL0N3MUJrRituM3AzTDBVdXRlaTAvTmpm?=
 =?utf-8?B?YVFrMUlNeXhtWWJtMFNyUHBqWmZNMkxUTWY4aUtKekdhYjcxRXB1OTl4eVNk?=
 =?utf-8?B?K1ZPeFd1Vkt1Z3RCNldCRUxHQkF1VU1TMzVBMDQwTTZ0YnRLdHBITUlLaFZY?=
 =?utf-8?B?a3NtQlBoNGVVL0UxVVo2T1FtMkpJajVaSHllVVpJVGNJNEl3K0hqckxCbUg1?=
 =?utf-8?B?WVRobitKYk95MEM3VlRUbFdqd0Rad2dWVTFjN3d0aUU4aGVQSldiaFRxa1Zi?=
 =?utf-8?B?dmlYWWdraC9YOUNYWlVzS2FKYVV2UEJuN3QzdjM3Sk9STTdGakpKWUdaZVBp?=
 =?utf-8?B?Y3BMYk5vUDA0Y3grSVh4R1lzWG9sdytVRjYxZVhYZWJkRkVYcnNKWDhRSHlj?=
 =?utf-8?B?QXgrYWd2SFRKRmdLRVFpNTM0UForQTJ1bXErSVUrK3NxQWYrRWlDWVBqTzhy?=
 =?utf-8?B?SWNYbnpEUGo3bHhRa1FkQjFnZFJ0cGpxNVhieE5ENUprTCtPRmpoSVBMK1I5?=
 =?utf-8?B?aTVaUWNremd3dlFRWVg3NTd4aVp4VFN6STBSZzR6VzIwM1I4dzFiUTBwWjM5?=
 =?utf-8?B?cUsxRFVtNU04MXFkTS9lSHpyVU1ETmw4UEhIa1pua0hqbXYxZ2lWUkwyOE5h?=
 =?utf-8?B?cEdsNzV4dHBXeDJ2R0dRaW0rSkhYNFRVbWd6akFOQ1ZrSGUxRjRNZ0NFaEN0?=
 =?utf-8?B?WXhmb0VtdkFhaDFUREZNQ2VBdktNZnFVTjZYWEtnMEVCYnFjYjFRTEMySTBZ?=
 =?utf-8?B?dTE5RWZXNXZ1d2JrWmJlaXl1WnhibzkrMkh4dG83SEQ4K0ZkSmJmQTh6WWdi?=
 =?utf-8?B?ZHRvVnQ3SkFYTTdubStGWGkyTFdKbzVYb2JiZktoZjZQQVEvZTJnMzdSb0hT?=
 =?utf-8?B?ZHE3WFYyVWZKQThKRkxmaWlzNjNCck40eWtjTFVCKzIxWHpENkEvZ0gxSWNs?=
 =?utf-8?B?TGdvcTRHeEFDU1ZJaG5NTEJLNlNvQVRXVzJVY0VqS2lVM24wQWpXeldqY2ND?=
 =?utf-8?B?cEVCbG8zTk93WjhNTjlEWWxnc0wvMnBpV1NKZyswUG84eVBnenVtN0JtVnlQ?=
 =?utf-8?B?Z0hxTzFpMEwyWEFDVmRlT25Hc2JkeGEwdktERWcvWTNxR0pGVnFGYStvYUFI?=
 =?utf-8?B?NUIvZ0lQQldNRyt2MlpjaHUvdGdmeUZTUThVTGFKN2tLZFk3eDUrTVNEeEVX?=
 =?utf-8?B?K3dscGFnV2crQWl6cmxDSC9vMENKcVZhUU1UZTlHQzB1TGpMVWFMQVllSnh5?=
 =?utf-8?B?c3JsUnFHZ0luN1liSzJqMXNtalR5WDhsbWRBWEtVMGVOTVZrOU5PNEIvd2lP?=
 =?utf-8?B?NzJxRzRST1R2VWFINkVPZDlOSERMcmZjMjFtWCtHWVNmTXB2S3FZRkFBRk0y?=
 =?utf-8?B?bzFOekNYcUNTc3FRclh4a3k4WU9qdnlxbGxIc0hML0RjSklFRUU0ODVZVzhX?=
 =?utf-8?Q?1nShdufX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c48ff00-e660-469a-c0a1-08d8bbf7317c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 21:22:43.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2R4V9ODxVIVRhBriQMaFARU/vBBt3jQWKZOxTxgX9CyvTGhMV7igpCOu0WanaQh3o6CmXMewt9+1xkP3ik93vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611004966; bh=wfJF7tMyjo/8pbVt+tQxffWxVz79qTviuBECDjy/LpA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:From:To:CC:References:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=BSyfsAB6LGW5sCCDJRYyo/tfq3gtj+2gH++DP0+WhkKQ2pWbCsytE27cMrVYpNENd
         GTRhG+c7tXkmt66ic2RvujDKNs1KE7sHIzcEsZmFng1Og3/VuU1zK7+rM6e3rqNsdO
         WYjiPAgocfgM+/d6UaFk3mVeseXUS56OUFqGqXM4MKl1nOoabW2VJlxJS1xvtWHeZG
         HbLqXoHRfNR8rf3F8FPpTsKPVaVFTJ03B4UlvsRt8tPYNcAlbjv2IkgiaajyWR8Qgy
         Okc6ObJdkK3KWUYPHMdNj6RrK4n2A3mdnFAywIE2933EtopIItNDLKcJ1w+B72KoJW
         UxTFA84kn/tWA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2021 23:17, Nikolay Aleksandrov wrote:
> On 18/01/2021 22:19, Tobias Waldekranz wrote:
>> On Mon, Jan 18, 2021 at 21:27, Vladimir Oltean <olteanv@gmail.com> wrote:
>>> On Mon, Jan 18, 2021 at 07:58:59PM +0100, Tobias Waldekranz wrote:
>>>> Ah I see, no I was not aware of that. I just saw that the entry towards
>>>> the CPU was added to the ATU, which it would in both cases. I.e. from
>>>> the switch's POV, in this setup:
>>>>
>>>>    br0
>>>>    / \ (A)
>>>> swp0 dummy0
>>>>        (B)
>>>>
>>>> A "local" entry like (A), or a "static" entry like (B) means the same
>>>> thing to the switch: "it is somewhere behind my CPU-port".
>>>
>>> Yes, except that if dummy0 was a real and non-switchdev interface, then
>>> the "local" entry would probably break your traffic if what you meant
>>> was "static".
>>
>> Agreed.
>>
>>>>> So I think there is a very real issue in that the FDB entries with the
>>>>> is_local bit was never specified to switchdev thus far, and now suddenly
>>>>> is. I'm sorry, but what you're saying in the commit message, that
>>>>> "!added_by_user has so far been indistinguishable from is_local" is
>>>>> simply false.
>>>>
>>>> Alright, so how do you do it? Here is the struct:
>>>>
>>>>     struct switchdev_notifier_fdb_info {
>>>> 	struct switchdev_notifier_info info; /* must be first */
>>>> 	const unsigned char *addr;
>>>> 	u16 vid;
>>>> 	u8 added_by_user:1,
>>>> 	   offloaded:1;
>>>>     };
>>>>
>>>> Which field separates a local address on swp0 from a dynamically learned
>>>> address on swp0?
>>>
>>> None, that's the problem. Local addresses are already presented to
>>> switchdev without saying that they're local. Which is the entire reason
>>> that users are misled into thinking that the addresses are not local.
>>>
>>> I may have misread what you said, but to me, "!added_by_user has so far
>>> been indistinguishable from is_local" means that:
>>> - every struct switchdev_notifier_fdb_info with added_by_user == true
>>>   also had an implicit is_local == false
>>> - every struct switchdev_notifier_fdb_info with added_by_user == false
>>>   also had an implicit is_local == true
>>> It is _this_ that I deemed as clearly untrue.
>>>
>>> The is_local flag is not indistinguishable from !added_by_user, it is
>>> indistinguishable full stop. Which makes it hard to work with in a
>>> backwards-compatible way.
>>
>> This was probably a semantic mistake on my part, we meant the same
>> thing.
>>
>>>> Ok, so just to see if I understand this correctly:
>>>>
>>>> The situation today it that `bridge fdb add ADDR dev DEV master` results
>>>> in flows towards ADDR being sent to:
>>>>
>>>> 1. DEV if DEV belongs to a DSA switch.
>>>> 2. To the host if DEV was a non-offloaded interface.
>>>
>>> Not quite. In the bridge software FDB, the entry is marked as is_local
>>> in both cases, doesn't matter if the interface is offloaded or not.
>>> Just that switchdev does not propagate the is_local flag, which makes
>>> the switchdev listeners think it is not local. The interpretation of
>>> that will probably vary among switchdev drivers.
>>>
>>> The subtlety is that for a non-offloading interface, the
>>> misconfiguration (when you mean static but use local) is easy to catch.
>>> Since only the entry from the software FDB will be hit, this means that
>>> the frame will never be forwarded, so traffic will break.
>>> But in the case of a switchdev offloading interface, the frames will hit
>>> the hardware FDB entry more often than the software FDB entry. So
>>> everything will work just fine and dandy even though it shouldn't.
>>
>> Quite right.
>>
>>>> With this series applied both would result in (2) which, while
>>>> idiosyncratic, is as intended. But this of course runs the risk of
>>>> breaking existing scripts which rely on the current behavior.
>>>
>>> Yes.
>>>
>>> My only hope is that we could just offload the entries pointing towards
>>> br0, and ignore the local ones. But for that I would need the bridge
>>
>> That was my initial approach. Unfortunately that breaks down when the
>> bridge inherits its address from a port, i.e. the default case.
>>
>> When the address is added to the bridge (fdb->dst == NULL), fdb_insert
>> will find the previous local entry that is set on the port and bail out
>> before sending a notification:
>>
>> 	if (fdb) {
>> 		/* it is okay to have multiple ports with same
>> 		 * address, just use the first one.
>> 		 */
>> 		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
>> 			return 0;
>> 		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
>> 		       source ? source->dev->name : br->dev->name, addr, vid);
>> 		fdb_delete(br, fdb, true);
>> 	}
>>
>> You could change this so that a notification always is sent out. Or you
>> could give precedence to !fdb->dst and update the existing entry.
>>
>>> maintainers to clarify what is the difference between then, as I asked
>>> in your other patch.
>>
>> I am pretty sure they mean the same thing, I believe that !fdb->dst
>> implies is_local. It is just that "bridge fdb add ADDR dev br0 self" is
>> a new(er) thing, and before that there was "local" entries on ports.
>>
>> Maybe I should try to get rid of the local flag in the bridge first, and
>> then come back to this problem once that is done? Either way, I agree
>> that 5/7 is all we want to add to DSA to get this working.
>>
> 
> BR_FDB_LOCAL and !fdb->dst are not the same thing, check fdb_add_entry().
> You cannot get rid of it, !fdb->dst implies BR_FDB_LOCAL, but it's not
> symmetrical.
> 

Scratch that, I spoke too soon. You can get rid of it internally, just need
to be careful not to break user-visible behaviour as Vladimir mentioned.

> Cheers,
>  Nik
> 

 

