Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9198030574B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhA0JrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:47:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4096 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbhA0Jo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:44:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601135eb0001>; Wed, 27 Jan 2021 01:44:11 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 09:44:08 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 09:43:41 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.56) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Jan 2021 09:43:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQC65B2jV4Qj+wLcDu2FgvLGMlakuvwVHI6qn6Kd/bIXbCSGWO2MDgb952QxY9yEMeN2tjnHvQizcH7xi3Aji8wHpNEi/cM+GCunrUQZvxgoG7rQaifYtSRkep7JW4AGj4Jnb9u55a2RlRD4CBeOnSPS0hn8A7tZxcsKDJN8E2UQQbbRwpNaalxJTNwSKIhZmBXMSi7Ekgung1aGpZ0nbYPKRAwXd2BEjXTjqCd+st75Mfm1j0rq7PBsRKaOBOUNSTLYp/JqQpCgC7ro5CoXacrq9muywvRWPYE0k93TjGRGrmKLDmQwHIOZWrP66bHArC2rRsf+OVdPgPiq7JZGBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jY266hAVgTv4KS2eNpt/f7YT8Uh+6OySEqRuBszyVw=;
 b=QPpc79u1xmQ3mtkc/eFCulVUt/nSuJ+JQ5PWYoHTGc782GlL1aHNy0Y1nVrbYVvQgJqivWfoIPKc+XhBJcBEHYJNQD+RXMK7XcZ4V3uDDJeRaTBMuwrhy5r7cViVTPSAWOgSoNow/mOxThwETdaR23EkrY6oUx7EqG5Qg7Kzn74HkH9ILQ/oPFJUme+ZdpO2RpsHhi420j5Bm5NUdHJkYWARUGAL9BiW6uq/xDC+Wek2ymUnZQWpN8wJorXeVUIWJczhLngLHzN5EPVQRc0sLt+7exrv+nmWQybGZTh+LHPb40S54c40X0iaOGGEVcCszLDMxuueC++/izhFd1Fjlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR1201MB2536.namprd12.prod.outlook.com (2603:10b6:3:e9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 09:43:38 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704%4]) with mapi id 15.20.3805.016; Wed, 27 Jan 2021
 09:43:38 +0000
Subject: Re: [PATCH net-next] bridge: Propagate NETDEV_NOTIFY_PEERS notifier
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>,
        "Jarod Wilson" <jarod@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Ido Schimmel" <idosch@idosch.org>
References: <20210126040949.3130937-1-liuhangbin@gmail.com>
 <8a34f089-204f-aeb1-afc7-26ccc06419eb@nvidia.com>
 <20210126132448.GN1421720@Leo-laptop-t470s>
 <90df4fe6-fcc5-f59a-c89c-6f596443af4d@nvidia.com>
 <0b5741b6-48c0-0c34-aed8-257f3e203ac5@nvidia.com>
 <20210127041521.GO1421720@Leo-laptop-t470s>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <e22d0eea-4236-5916-cc42-532a3dfcc9dd@nvidia.com>
Date:   Wed, 27 Jan 2021 11:43:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210127041521.GO1421720@Leo-laptop-t470s>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0108.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::23) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.222] (213.179.129.39) by ZR0P278CA0108.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 09:43:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 833fca15-9294-46a4-dca1-08d8c2a805fa
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2536DA22ECB1EF79BA9AA502DFBB9@DM5PR1201MB2536.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0w2itShNjcIaWw2ZRtfcttpkwEe4Vn9oJvtdoCFrZH8so6jrsm6b9dThveSPU7KI37lmsOWG9BKsOpbVlXLAX3walQfzweg0m4McBLgYFZRs/EAttb6Mov5+pyULEhlmcJ0cgzQBdZmC0zNZnnvjewLG66h6uNIXtdHK65L4qZxRsUsWZbrGDncEk5k68pmk8FCrHgJcDvhmgKfSTWLldbXd16e5bnPnmObV9wizm7T92ModFrF9S6ZY9glomCBWaS3T4SNg4+0jl4VfEbCsbaytaDSQWWfvlQYhTUeYcmm+31K5lNPcuv7ZJ0FvVIfzd89dQpt4VCMIhI1cO0plT89uYEjwAYAwe8Zeg+dJgNObKrMroYt5tEBCB62r/akpClGcSnAAw5qbdNi3/1xs6gyEi6sh+Uq/p4+veHZBQOR3Zuq4bM/tUIUcavSn+0mSB2g2/X/l8D2I3W39Yc90yGvWGNDu0A+rskMtMPTSMr6YwIa4Q0lSwtLtmAvNGYlalEBascNaFVM7wjNZkqDdRqs2mShub088gxAtrHS0ZnUVAlpMrgO4gzd+cc9kSXHOVrUvnpAoZh+jN6UUzOpM5R5X21kWxW685a4b4PTPVpM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(6666004)(2616005)(316002)(6916009)(31696002)(86362001)(956004)(5660300002)(54906003)(53546011)(31686004)(36756003)(6486002)(16576012)(4326008)(478600001)(66946007)(8676002)(66556008)(8936002)(2906002)(83380400001)(16526019)(26005)(66476007)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c1Zid2NzQmZ6cGFIdnlJVWNQZjZvQVhvUnFzK1FxVWpXM0NnYzFrM0hrRHp6?=
 =?utf-8?B?RGJkRWNnVWYyalhXZ1JBS0lEWVFqRmRTdHVxVU9kRlVtTUVIcXlpUmRMTGVs?=
 =?utf-8?B?ajNaQ0h5MSt1ZU5uTGZ5MVZVaEhKanV3bTV5MnVTdEx1UjRseUU0K0s1dFEx?=
 =?utf-8?B?NnhZMnlTTkZqNE01MVRhQ0c3c0N3MEZYbU9uWkN1ejBYenp2L2x1ZjhUV3Zk?=
 =?utf-8?B?STJCSlJ1aVJqZ28rekpYREJXSlJBS1lCZDRsRVMxZ0RWTlhmc0NDUnMycURU?=
 =?utf-8?B?Y1JRRTlyT21NdEpOVE5ocFg4R2ZhTEpKcVphODJCQ0prMHdSUkJ2eXVCQ0ZO?=
 =?utf-8?B?LzVQL3EvMkFoRlp2eEVtWWptQndZak1JRjNoVEpROUdQMWE3WldyamhhTER5?=
 =?utf-8?B?VFgwc2Q1YUxTbEczRXM0VmRwSUFmcmJhTmNlOXFxdHlhUzlPOHd5cERROWZm?=
 =?utf-8?B?RDd6Vk9aQ3R2V2E2OGJSVTZyeDBPWkZKOThIYlhYZm4yUjdEOFBwSzNnVGFZ?=
 =?utf-8?B?Q1JjWkJDRVU1N3A4U1hXSlltb1hIbWFWcm5NbWtHNDhQU1BnMzFwSXIzUGN5?=
 =?utf-8?B?cVVldElzQy9qYkpmcTE4Q1Q5UTdYbm9VelN5WE5QclJXMVQ4Y1c0MUNOY3FB?=
 =?utf-8?B?SS96RVdvYTJuRW9rdVV2MjZ6K3p6ODR5VkJpMWFwdUZoNitLKzJ6VFZ3Zjdt?=
 =?utf-8?B?WndSTFpDK2tncmdwRTY5eHVzWG5meXZrMXM1aDRWcXI5VUdKbG1BV2xYNGJJ?=
 =?utf-8?B?Z0g5clZNUGdvdE1xQmZJUzdTakx0Z0tBU0xxYTZFOXo0R0NmYk5tNXR2UkNp?=
 =?utf-8?B?Rm01WllFeEtCOHY5NXR0SEV3RlU4dG8rc0htOW5CT3NQMXo5dW1CYzVLNkQz?=
 =?utf-8?B?UnB6MGx1SSt0ZHBhOThYV2RrR08wVDJoUUdiUE9UQ01DSC9uSFpCcGtoM2xv?=
 =?utf-8?B?WEZkc1BHRVpTOG9xZXZZelFEV2VZTHVqa2xwZEorWnM2b0dnYUVHYXZEQ2R3?=
 =?utf-8?B?dW5SSTlmenFGSzAydHBQeUJ3aG9HSHFkZWR4NWNzaDVodHBuWEhXQm9GRVU3?=
 =?utf-8?B?QTNJOTdtN2hSSmYyZ0tLZi9FYU1oZ2lHUHBJMVZUTHo1TUVuMjBlZlBIMnpI?=
 =?utf-8?B?Y3dZYTd4bWVKTnlpc1cyK2w1enNPY0lUK3RJZWd0eDVWR3VCTjdvdW1KOGVY?=
 =?utf-8?B?bktHQW1OaXhncHpBM0hxakU5dEMxNHdYUEdXOHQzVVIrVFRSTXdqUzdFQ21i?=
 =?utf-8?B?cnhXUUNBTVVFdXFCOGNEM3Uxb2tESm5lNGl1NEVKTVByUllrMFpOWW5FcWdR?=
 =?utf-8?B?VHRTeEZ0RFJDamRnVGRjMUszV1N1Z2N4NGlVNUF3RG0xQlhQZE83aVJ5b3pY?=
 =?utf-8?B?ODZYVFdkVVdpbFJhcnJvcHFiYkdadmZNdmlTbVo0MkpEejBKdzFrajdOa1lx?=
 =?utf-8?Q?xTw3tREt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 833fca15-9294-46a4-dca1-08d8c2a805fa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 09:43:38.4850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOAgsfBe0iMZwmLDcBuE6nXDdEIGmjzpv31meX/JrKBWNPTH8ac1ORO62ryBfojRLfnHdMoldehwwM0B6FuNfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2536
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611740651; bh=5jY266hAVgTv4KS2eNpt/f7YT8Uh+6OySEqRuBszyVw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
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
        b=P+UW28L6HLx8kOpTxL9yv78mf5YqIDJaSUb9D8vJgfjUEVTJL6J68EGYpQ5s4p29k
         YqeUgmGjWhNdbCtPBSpW/H40ZtgOQjyImYidUrCB7ZpsWgfWG+zenf28KsE0IrVE2e
         0p4Evh6jfQMlWf6iWZEXKaBkqFNO3jYsKX2EkJg3W1rKy+qhWDNDw2gWhOD9OYLd53
         TqgAzdYuv4bJ5z4Mz7IQLZ840svOrj9AIaLqcyZIwUoCGp+mc2x1ola2XUfZXSeRBm
         99ebv3DQF5lP7FUnLXYtk9C5qNuFyM3hxkH5DzIzo91C03kLJK3m+xzBMLWCyfaNQO
         ltqGF8hA5QKYg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/01/2021 06:15, Hangbin Liu wrote:
> On Tue, Jan 26, 2021 at 04:55:22PM +0200, Nikolay Aleksandrov wrote:
>>>> Thanks for the reply. There are a few reasons I think the bridge should
>>>> handle NETDEV_NOTIFY_PEERS:
>>>>
>>>> 1. Only a few devices will call NETDEV_NOTIFY_PEERS notifier: bond, team,
>>>>    virtio, xen, 6lowpan. There should have no much notification message.
>>>
>>> You can't send a broadcast to all ports because 1 bond's link status has changed.
>>> That makes no sense, the GARP needs to be sent only on that bond. The bond devices
>>> are heavily used with bridge setups, and in general the bridge is considered a switch
>>> device, it shouldn't be broadcasting GARPs to all ports when one changes link state.
>>>
>>
>> Scratch the last sentence, I guess you're talking about when the bond's mac causes
>> the bridge to change mac address by br_stp_recalculate_bridge_id(). I was wondering
> 
> Yes, that's what I mean. Sorry I didn't make it clear in commit description.
> 
>> at first why would you need to send garp, but in fact, as Ido mentioned privately,
>> it is already handled correctly, but you need to have set arp_notify sysctl.
>> Then if the bridge's mac changes because of the bond flapping a NETDEV_NOTIFY_PEERS will be
>> generated. Check:
>> devinet.c inetdev_event() -> case NETDEV_CHANGEADDR
> 
> Yes, this is a generic work around. It will handle all mac changing instead of
> failover.
> 
> For IGMP, although you said they are different. In my understanding, when
> bridge mac changed, we need to re-join multicast group, while a gratuitous
> ARP is also needed. I couldn't find a reason why IGMP message is OK but GARP
> is not.
> 

I think that's needed more because of port changing rather than mac changing.
Switches need to be updated if the port has changed, all of that is already handled
correctly by the bond. And I also meant that mcast is handled very differently in
the bridge, usually you'd have snooping enabled.

The patch below isn't correct and will actually break some cases when bonding
flaps ports and propagates NETDEV_RESEND_IGMP with a bridge on top.

>>
>> Alternatively you can always set the bridge mac address manually and then it won't be
>> changed by such events.
> 
> Thanks for this tips. I'm not sure if administers like this way.
> 
> This remind me another issue. Should we resend IGMP when got port
> NETDEV_RESEND_IGMP notify, Even the bridge mac address may not changed?
> Shouldn't we only resend IGMP, GARP when bridge mac address changed, e.g.
> 
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index 1b169f8e7491..74571f24bb18 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -80,8 +80,11 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
>  		changed_addr = br_stp_recalculate_bridge_id(br);
>  		spin_unlock_bh(&br->lock);
>  
> -		if (changed_addr)
> +		if (changed_addr) {
>  			call_netdevice_notifiers(NETDEV_CHANGEADDR, br->dev);
> +			call_netdevice_notifiers(NETDEV_RESEND_IGMP, br->dev);
> +			call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, br->dev);
> +		}
>  
>  		break;
>  
> @@ -124,11 +127,6 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
>  	case NETDEV_PRE_TYPE_CHANGE:
>  		/* Forbid underlaying device to change its type. */
>  		return NOTIFY_BAD;
> -
> -	case NETDEV_RESEND_IGMP:
> -		/* Propagate to master device */
> -		call_netdevice_notifiers(event, br->dev);
> -		break;
>  	}
>  
>  	if (event != NETDEV_UNREGISTER)
> 
> 
> Thanks
> Hangbin
> 

