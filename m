Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB76B43DD1B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhJ1IsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:48:10 -0400
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:61089
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229791AbhJ1IsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 04:48:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSEoG31Gyz+W9/2n/1ratbG/EcqZuLF3mv+gSPxwQ4eK648vJidcRDwid810XbWqZZ3q7Pjbv/HKP33UpGf65U7/LR006SA5Ik7cEnJXYJC3A/Pev+ncUYTA1hKIUYLYsZxKfjSeVopJiqzH/S+9SQats3s2QCKOnt70tUiQAsIcnAgyw9AkX1QkUEoEtk47w5HfBm/FDkpYx05Vj1nmxiF5OyREWpxivXRV1zFvgKNTy96BS69qBE0Q/Nng6NO1+nt4EzrHXHFifCvuYlcLTp2PVfk5IADrrL51n7Pj6+Kvlavtxd64AIWjJdwsOfsUAmKMMQ6v8GIc6qmLXWM+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcjGjQ/v8qulOLaqnPb1aEiO6Ds7XxIrZjH+j+/Vsms=;
 b=PpTwjoCzddkVkW6OHufgIdLv1UmCXt3nM4FQzzVFmud3IWDu1kfup5Ku4P4YTZaT5utInrRs9hdGpS+ES6RGp3NL00AajDhAfXr72eclGws//gNAIFEkRr0oZ3q4x0nnRb7l8WNMlxyXdGGUP2fVZhonn8DxGXkRFycOUy/xheUoikQnYEsRakSmTvVcgfFARofzT9eAdDcjG1L7nN2y8CT6oL+MzLs31yB7CI7T8UbtVHk+ymLW8hptIN5xIIr7poQOvRj2dk+Q8KNHVIjnJRVNB/C7C2dmuJs5pmxAxoLQB1LmnZ5RG9CoAz01xKs7j8jhBA7YWerO0BF77F4SLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcjGjQ/v8qulOLaqnPb1aEiO6Ds7XxIrZjH+j+/Vsms=;
 b=Ty6CrGPne/g7U/d2EIq01Qjp0vP15HpESUtAxSZU4bEEdbjqM51bBvQEiqBCBOh1BEQTYgXmlUZ1f7U6Iykl/dWmzUbKXTpk/vvYUETwHVKc3BvAN/sSJd7TCer/z0AzqSA/C0qFAkn0uzq8ZV2FAZn/hNdiw6VWFYjynO3DhRLpeyR22kjd3u3YrsusqtdirBbMtMx3W1G99upX7e+WNN8/YWAZRSWT8kdCQYhe+weYLHcsTOZ6XPQ/xb4F3koJF0s0gbPyvElAuDfEDO4Dk/BjMc9QD0cTQTH8H1dzpIcJrcAT7cmAH6i/83Yg0icObosMQ8GUevR4mSQFBheleQ==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5464.namprd12.prod.outlook.com (2603:10b6:8:3d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 08:45:41 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 08:45:40 +0000
Message-ID: <96d38f44-61f0-d021-109c-f24f74251cd7@nvidia.com>
Date:   Thu, 28 Oct 2021 11:45:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 1/5] net: bridge: provide shim definition for
 br_vlan_flags
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-2-vladimir.oltean@nxp.com>
 <a8d9df33-408b-a2a0-2e77-754200ff7840@nvidia.com>
 <20211027194552.3t4l5hi2ivfvibru@skbuf>
 <97a4088c-ba81-229b-0f7c-088a0069db41@nvidia.com>
 <20211027195442.mwlyvrokj6ygpv7m@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211027195442.mwlyvrokj6ygpv7m@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0140.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::19) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0140.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Thu, 28 Oct 2021 08:45:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0117a7eb-e1f7-4208-8c57-08d999ef5248
X-MS-TrafficTypeDiagnostic: DM8PR12MB5464:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5464F403D8888FCC0BD69116DF869@DM8PR12MB5464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcG0kIgFNJxP1+SIhMkwG7aiw+WXGlHsEzHZAKQMFkaI77auILMAblkl6ikE+WSYdL1RDkVqU71P3W3zzdjF7hAEh4WCOs9nnOSusgRRZ1oN6dEhmBoz9bZgVeit7WgQurduLRa/eEK1yDCtN64dRi71qjub2dcTSvSdPsspgWlne9qxdUXKCnF2ByX/XJi7kOB17i1vQ3liR7VEbgzTjOaF92DCdAGit9VmmrSzrOou8P321LkZjDJJC1H1bIpPwiJ9Ftj8CN5zRlR0SME4J6tGR31BPjBilAT6VIscP9M2Xaq2pIqeezn/amXv03s3jIR88IJS/doslNA7WaHCLV9jVQ0Ckv2UN0MINzugYowrn4FUSR4FpQgw46xxKkQTknJ7D6GLDZ4IRZ+n0IeMOe305LRnScg2iQ2aC0l+hmM4aaYHBo/3YExb4XvJIm3gsb1zN7RH9D9QAl3f4Inw8JbfyVYWlQAican7/r5suiMH5C7pi1oZmsXxjRGvJ4xcC/K4Bkl34KIW43VeFXgk8D1g3WOF44UIqUEynbMPJcPy2JAJYlgaoo5V8yuptSJmlFsHRjJrTTYPNHKFhhqcmX2iJtsbl5oH7mgYlTm3vK2eBeDhdQnFvav8J4fMoeecu/YfR7IJb0pXfthoWlMAwse893YZxA70vggeMrYCMU8zeuwNlXTc3Y4be//k7nQZLbsB3HeGdc3Kc7m68EBMi7z54vIcLidWWc5oNunV+1s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(36756003)(53546011)(316002)(4326008)(107886003)(66556008)(86362001)(31696002)(298455003)(31686004)(66476007)(66946007)(508600001)(26005)(6916009)(956004)(2616005)(6486002)(8676002)(54906003)(186003)(8936002)(6666004)(38100700002)(5660300002)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MStFSFhRalFpd2x3RzQ4akgreEJOQXBLcTVlbENxcDBqZmtTMHl1bHNxaEVB?=
 =?utf-8?B?blFDMGc2eEhuYkhEeDdKSHBkNXRZRkRKOHZ3UExLaFZKVVVjL1IvRkxnTkNT?=
 =?utf-8?B?UnBvZFR3ejdqQWUxNkR2a1NhbFZ5blVRVVY1MlBxRUdjZmlmTXI1MlVBWWg1?=
 =?utf-8?B?SEVYd2RoSWxIVTFMZitrSFBCTXUzUjdEYzFkZFhKUFY5R0JiRHVmY0h1YmZl?=
 =?utf-8?B?S2RQVW5EQXZ2cHVlazZEbXYxRVR2ZWJ1RDRHKzMyckJCWGtZbWdQVjBZK0hR?=
 =?utf-8?B?SEZQUXF2aU12QnAzKzlHMjZxWGk1amVIN3VUcTZEZFliVVBGUDcrL2llOGN6?=
 =?utf-8?B?cHZLWmFGcFJMaXpNSThZWnA3VVpMa2sxR1JXOVM4eUFBOUswbWxUVjJDcVdh?=
 =?utf-8?B?blNsOFg2QzBSY0NFOHRockpxemdVT2tqVDV6K2creU9ZMjJEVC84ekczSDl1?=
 =?utf-8?B?NWM4RWVWZC9tcjFYSmNPMDhYV08vRlJQak5PSEw1QVVwZ21INjFwcmEyMWp6?=
 =?utf-8?B?UVZsYmh2RUFaMU1BOXg3RnZWU0l5RTdPb05Ta0Fsa0pSTHg3WjZldUljNC91?=
 =?utf-8?B?T0VOUVRQejJrQTV4TG1YMFY3cFJKZzh0VVBsZTdYUFh6aStwRzJmR0RGajJO?=
 =?utf-8?B?VHY1MzNUcXNWNVMwTTljaC9ubk1vSkdLanBMWVcwNjM1M0VJYnl2MUlHdjdr?=
 =?utf-8?B?K0lJbXJzQUV2MDhsMVpkcFQ0bkIybjZDV29RRG15QWkxMDgrd09JZWYySDVm?=
 =?utf-8?B?WkR6S1JlZFNScmVJdlQ3MjBSUndSdEhNYWwrNklqUG9nL0gwT3lob1pZTHhw?=
 =?utf-8?B?R0JXODJDaUJJYkVadlRJZ2c1M3dxR2Rvd0daMStkclNUQzFZd0VrOVl3SjZW?=
 =?utf-8?B?ZkFTaExQMVNqL0lQaW9GMDFWWG5XVE5yYkFSVHRvSTkzVjlxKy94OFpZdW4z?=
 =?utf-8?B?MFpvNmFOT0ZWOEtYdmluZU92RlQrL085SERPK0s3anJoTklXOGlTb0dsR2ZY?=
 =?utf-8?B?UTIzblltVnd3Z3c1dWY2MG5HbnVwZC84cmVxZEZid2FWZU9OZjRxYkVwQWxN?=
 =?utf-8?B?YWRIQVljT3NTVFlUYzVFVlNLN1hlR2k1d0lFdmlCb2pMdlMwMkFWRHpWdE1H?=
 =?utf-8?B?RUlmZWdBb3JqY3hUNWdDeUsvc0FyNFBONUVQUUNUUng4Umw3SVFsMHNZWFpn?=
 =?utf-8?B?S3FRWVVoTEY5dkZwT09RTUoycXRWbFhxUzRoVHIvNGEzTysxZ2hTSnhtcGhM?=
 =?utf-8?B?Wlp2MzF0NWF6R0JKcmlIeTRvaFE3R1FRVWlMVHhWU2pwMUpLRTdaUW5UNkdx?=
 =?utf-8?B?Nk9VK3BQZVViUitjQTUwY1ZHRDFDUVB4VjZQU29ndzhkSU9ndHQ2VWJIZ3A4?=
 =?utf-8?B?RmZjVnQxb3ZnSHY0SUxENmVYcC9NanVlUVNPWjZlMkJnTUJOMzV4UE1VOXpK?=
 =?utf-8?B?STNQcmwzbjN2b0ZHUklCbUU3N3RFNk5rSXVNMllSSzRQMXF5T3hjK0ozYzhl?=
 =?utf-8?B?T21LZnAzUTFrNXhzTENDTk96NTdhazQ4RWRUZjFWOW9Sa00vaW1aY3ZrUno0?=
 =?utf-8?B?U3pqMHJQbXdjQ1ZrK1lPWUhEck9EQkl3NnZUcGEyNU84eFlYT2RYSHdSd0xE?=
 =?utf-8?B?YzdETndXL2JITXorQWc3SkR4VUlJbVZJaVp1SzdsVkNhT1NCSU5uOTFCQjV1?=
 =?utf-8?B?RCs4RkZOUnMvQnh4Um9HeXpFdE05ME83cjFhMTBiRm9RODk5ek9Ydk9oNkR2?=
 =?utf-8?B?MFJEN2VHVmF5dGE4QlhVSGVsdFFJMW0rRThKVklRMmlrbE1oVTdqRGRJQjBJ?=
 =?utf-8?B?RlFiSWNHK1NiVnN2bzNxR1ova21xWGRoUWp6cGtMeWR2UEovM0ljSnFKWjJh?=
 =?utf-8?B?YklONFk3aVEzTTc1Y3dZRDNWczdBQ0JabjBuTEVpdUk1NzJiUFlPbUtJTzdt?=
 =?utf-8?B?R2hTTnA3VVBJUDdlUU44MnRFaDliSUVqcVdDU1VHL3kwUHZtN3d4L3kwV0tE?=
 =?utf-8?B?SVlxRERnMjFHQ1ZiK25YNEpnUWRrYlEzS01pWDhLYVZLdmRKS2lYZFVZc1By?=
 =?utf-8?B?VDR5akJKV3hOeE5PamMyRVVtSkFldndHcHVpNTRIUnBLak9ZcXZPemk3NExp?=
 =?utf-8?B?UHk2dFhOR3B3UTc5eFM5dmF4QUcwRGtFcTU1d0lZTDdlbkF2Unh1dm5MSTN1?=
 =?utf-8?Q?EQLKETrurJr5/6pUCvQvMvg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0117a7eb-e1f7-4208-8c57-08d999ef5248
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 08:45:40.8486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MAitH7udajONLazY0MDMTUR0G5REZfWAHC+qC+EmBrTwc0iS9UJJ+SAgMQ5s9kEzkHjdyC6683CzIpmIYUsnOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5464
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 22:54, Vladimir Oltean wrote:
> On Wed, Oct 27, 2021 at 10:50:47PM +0300, Nikolay Aleksandrov wrote:
>> On 27/10/2021 22:45, Vladimir Oltean wrote:
>>> On Wed, Oct 27, 2021 at 10:28:12PM +0300, Nikolay Aleksandrov wrote:
>>>> On 27/10/2021 19:21, Vladimir Oltean wrote:
>>>>> br_vlan_replay() needs this, and we're preparing to move it to
>>>>> br_switchdev.c, which will be compiled regardless of whether or not
>>>>> CONFIG_BRIDGE_VLAN_FILTERING is enabled.
>>>>>
>>>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>>> ---
>>>>>  net/bridge/br_private.h | 5 +++++
>>>>>  1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>>>> index 3c9327628060..cc31c3fe1e02 100644
>>>>> --- a/net/bridge/br_private.h
>>>>> +++ b/net/bridge/br_private.h
>>>>> @@ -1708,6 +1708,11 @@ static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
>>>>>  	return true;
>>>>>  }
>>>>>  
>>>>> +static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
>>>>> +{
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>>  static inline int br_vlan_replay(struct net_device *br_dev,
>>>>>  				 struct net_device *dev, const void *ctx,
>>>>>  				 bool adding, struct notifier_block *nb,
>>>>>
>>>>
>>>> hm, shouldn't the vlan replay be a shim if bridge vlans are not defined?
>>>> I.e. shouldn't this rather be turned into br_vlan_replay's shim?
>>>>
>>>> TBH, I haven't looked into the details just wonder why we would compile all that vlan
>>>> code if bridge vlan filtering is not enabled.
>>>
>>> The main reason is that I would like to avoid #ifdef if possible. If you
>>> have a strong opinion otherwise I can follow suit.
>>>
>>
>> Well, I see that we add ifdefs for IGMP, so I don't see a reason why not
>> to ifdef out the vlan replay in the same way too.
>>
>> I don't have a strong preference either way, end result is the same.
> 
> Since the caller and the callee are in the same C file, shimming out is
> not as clean as providing a static inline function definition with an
> empty body, and if I could avoid doing what I did for
> 
> br_mdb_replay()
> {
> #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
> 	<some other variables>;
> 	int err;
> 
> 	err = <body>;
> 
> 	if (err)
> 		return err;
> #endif
> 
> 	return 0;
> }
> 
> I'd do it. For br_vlan_replay() I could avoid it, so I left it at that.
> 

that's ok,
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

