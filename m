Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912AC304206
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 16:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391465AbhAZPAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 10:00:15 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17460 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390915AbhAZO4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 09:56:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60102d650001>; Tue, 26 Jan 2021 06:55:33 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 14:55:32 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 14:55:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWbhZ392FC90FNl1U1pf2tAalCjeTShI0M+TXVWoLaUXoPq4d89e3vSL1LUywirRXk4Zn7h2bpHyseY/KRqosti8t6boJdK0OuvHatKVDQnY45B1IGhtMY6OqqwUJUP16fFg/JzkLYPHfmmoKAJ0mjRJJDRT/Ju+qJRiyfoWbaGHCupXyLQSvV4zVjc/AvTvWoNGAh5/IuVzBfx5HPEnIR8QDIuCBn7tQScPIhDAaeGyxIuvYrQoVXPpQVVysYtDsgI32qz3f/oAaN9STcOHluycXu98UQQZZp0ZGYSi5UAFbG+B14x3qXqXFREmNeyzpn3/AIk8TqO+ywkTwgD+sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KflSjyZ+yvItKXatpnNsU1KAA8P6q58PX6s9V8DkcfA=;
 b=OJMeeLnpiYfrLvUxeTiDneWJJKyDnt5RdRUXT/i4kl7Hqd8eT46S6HGaaWAHz2UnDSr7liDAYJIx0U2oWXJ1jgTut9JUuLRKJcXAJffSWOWJZ8aAcPYRr0BlmiXqfRU69K/tQbQB2eq+dwOtctjqprpt8XLoZVd655+9x4tjDJ3nYt3yyJCNPyLWrbq+xCQhh8NaM/uKiKdv/xikt2S8YrRzFcDxKByn/pZcuVVxHB+ju51MJd3x0Hxl3RR6REvQJASdUCrfkHwhwfNwSwG6dDNcbhnWgwmOvKr6cny7EsMPDUI4z1FM/T1pnPjPPc/0L46m5c/HmC9y9pTnpZIHbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB2953.namprd12.prod.outlook.com (2603:10b6:5:189::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 14:55:31 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704%4]) with mapi id 15.20.3805.016; Tue, 26 Jan 2021
 14:55:31 +0000
Subject: Re: [PATCH net-next] bridge: Propagate NETDEV_NOTIFY_PEERS notifier
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>,
        Jarod Wilson <jarod@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@idosch.org>
References: <20210126040949.3130937-1-liuhangbin@gmail.com>
 <8a34f089-204f-aeb1-afc7-26ccc06419eb@nvidia.com>
 <20210126132448.GN1421720@Leo-laptop-t470s>
 <90df4fe6-fcc5-f59a-c89c-6f596443af4d@nvidia.com>
Message-ID: <0b5741b6-48c0-0c34-aed8-257f3e203ac5@nvidia.com>
Date:   Tue, 26 Jan 2021 16:55:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <90df4fe6-fcc5-f59a-c89c-6f596443af4d@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0010.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::20) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.129] (213.179.129.39) by ZRAP278CA0010.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 14:55:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61d4c603-6464-48b9-cb94-08d8c20a6d17
X-MS-TrafficTypeDiagnostic: DM6PR12MB2953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29537BAF217999F80ED313FBDFBC9@DM6PR12MB2953.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3f/0wfUrTZPDPU4uSPcq9yAcJEY9K/zzCY2txQMMMHo8Li3vco51I3ZBno464zsOIm6l/RUHkdPg90yKk26Lzjq1AdcgHMOcRHJeLjNMoo+YcD2USfGcb0+48XBts8SpRuDc2glEXypZmPYta++j1nj3epcisUMInegcvqn3gUax1UVkWp/36ByTvD7vYAVCa/mxlE+sKhHmrMbp+RkSF4vAJpeafRdlIqveWzwxL4P+UF4YULMVwN7PdaCImYs+MieChmXFqTEvLLcDbsJc9qNO+AXbCICjqoNx6bNS95UFDVCRPiElk2fnaalR/SB9esCEczOUM80f/HV6jeMrLidm98klsRsf9RRkMbvP8y2mlib2Z0AMMPqbp+X8cQBfoE4IyNuWypDEhMwCT52iIobFmaSTVikPA5BQXhj69rhLjHyjFVB5iAco0fRACyfxhEtWzDJQ4UrH4UgIgEEKQgqB9LCkyrBlrO+h0hBxwcWFKgliK6ojbtI4UA+flUU4G2RMiL88xjs8nlrpbrZ50v+bA6FOBWApJSxRrs7dV5iqKuFxRpISKGyIjZhFGmYQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(6486002)(316002)(53546011)(31686004)(186003)(8936002)(5660300002)(6916009)(966005)(83380400001)(6666004)(31696002)(4326008)(8676002)(2906002)(26005)(478600001)(2616005)(956004)(54906003)(16576012)(16526019)(66946007)(36756003)(66556008)(86362001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UE9QNHJtQXBHUHhvWGxncVdEbWZXbWN1ZE1pTE9ETkI0NnZ5NlZmYlpJekRw?=
 =?utf-8?B?czhJRHp1citnNTZoQW1jRjg5d3pLZHdLL0hYZU9qbExEQlN4cVlmcHdZcFdH?=
 =?utf-8?B?djRJdDZHMjFHNXo1eFVpMWplbzFkSVB5d21Bb0dTaWFhSk56RDVROGJ1Y0xY?=
 =?utf-8?B?cVBYSnFsREliUlcvYm9hL3VJNlZWR1lwZUVSVXd2R3lyeXJxYXFqR2d3UFBt?=
 =?utf-8?B?L0hvcDlkNXcxOTN3R2pXQWx3bzFSRjFqRUJCckVmc0hZNkg3alBXcE1xT2tj?=
 =?utf-8?B?MHVESUhQMllIQVVuVU0rYWMzbTRFK0NQM2hMVWxSMlpudCt2M2pSd0hGT2Ir?=
 =?utf-8?B?aWpmbHkvaFZETlBkSjlDM3I2R1lQOEU2dVBuZ3pqbU1XSHdoTy96NGl3MDRQ?=
 =?utf-8?B?a0FzOTFuUWw3enhwNVFoVUVDYmRGVXdHSDNCK3RkT0ROdk5FdXNIcXlIeDQ4?=
 =?utf-8?B?eEk0bHZyeUxzc2NFNWNJckF0VTNRcXNVQXJRL0RDVDlxYWwrMWE1bkNkeE04?=
 =?utf-8?B?MDFpR055MElNUXZFNVdwdVBqclVuWTQ4YUpLVWdGV2ZFZEQrNFE2bURNb2Qv?=
 =?utf-8?B?RHFqR2l2Z2NqWWpQczJRL3V2a1QvU3RseFlXUFBmNHMzV3NEenlIeGF1WnZS?=
 =?utf-8?B?QUg0MVNid0dLclJJWDdydlFRZXUrTDZsNlhQYTJzWXUvcTJpWTl4QlRkd05v?=
 =?utf-8?B?S2ZFVzRzSGdEdUtHWkVTY1Y1TFVUWnlXWHhqL1JBVmlXaGplTFpCKzlFRVha?=
 =?utf-8?B?aVp6NXFPTi9SRXF0RWNtNEI0eCtPMjUrQ3kwbjdKcE10WHJzc2IzUFhhRUFw?=
 =?utf-8?B?QVprbjh2dWY3eWpveCtQUnNrK25Jd0FxQkZuMkFheVJxbDhwWk9NY3JFeXVV?=
 =?utf-8?B?TytpSXp4OVdVRk9RSXgvY1BWMjA5RWRpRGEyQWFERGk4YWtpeDFIQms2S2xP?=
 =?utf-8?B?MVpBL1JmU3UxT1pmTEptVXNHL0FOeW1SajFUYmVhR1FlNStlcEJEUVcvbHlu?=
 =?utf-8?B?THhyVEpIQ0R1VzVuUFN2VG93MksyOHVyeFlPd0dwcytKWEZMR3dlQlB2V1lq?=
 =?utf-8?B?RlVPaFJJQnpQT01PT1BycGhFVUhHcDJxVjVCcUJxTTVLUGdYNnd1RHFVYmZX?=
 =?utf-8?B?ZXhiMGF4TjYvSFIvelJxdlFqYUFuZmhhSHQwYjY4WnQ4d1pnbUU3Uk13SG9n?=
 =?utf-8?B?RmFxY2hxc3luSnlkMVdOdStFczIydWJZeGtDVjVQRXBhZmRvTGJSOGZXbGxC?=
 =?utf-8?B?WEttTmJVWE8wSFpwNjUzM20zRTJJbVk1NVFjWUJnMWxseDJIbzRzbUhDYkMr?=
 =?utf-8?B?WW5NbHZiMjRaZnNBOHMxSkxSdEZCSU1GYUZaU2J2V0VtRTFXbGM4OTYwTHZP?=
 =?utf-8?B?clFudEFXWkgwTmR2SEVCVUdodjFPa1QrY2JPVjdaSDdaN1NrWERON0lPam9T?=
 =?utf-8?Q?hdSTGnnY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61d4c603-6464-48b9-cb94-08d8c20a6d17
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 14:55:31.0146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OibClAgcnB2q3zk79e4jQuEhH/2klplQcDw0K5CoGmp+1UPsdrzlk18V9rEvgLs3zxKhG+qFPlJcJJ6K573ggw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2953
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611672933; bh=KflSjyZ+yvItKXatpnNsU1KAA8P6q58PX6s9V8DkcfA=;
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
        b=AtjZ/cjg7+e3oH0oaYudtGxY2VCkJf7aQtSc6Q6O0lOBXyNTv0HhO4velZVUuaV/M
         WNeqc8GozBrboGYdA8WFMGxKfCiLMMAo9uFkPf6d8knTbk28G4bwpdMTrj5HyWf1XB
         V3e9ouxhldA8hwF+auk177SbHF4ifzFjW2BRuMB/iToEQ+3k4ZuwC2PeNPxCysZKzV
         4pBHXPNjtqyamW8C1doVZWN7SiaI8GoeKEaMjePNccefdKMfV0cPQNiSWhJriOCuy0
         BJzGXm3cabNUQGptrhZZD4mkXGwdaQkx/eHrEhwLr8/PfbfE1Hg+3fAdWa9CuU55Y8
         p6r/rvZWCw3Fw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2021 15:56, Nikolay Aleksandrov wrote:
> On 26/01/2021 15:25, Hangbin Liu wrote:
>> On Tue, Jan 26, 2021 at 09:40:13AM +0200, Nikolay Aleksandrov wrote:
>>> On 26/01/2021 06:09, Hangbin Liu wrote:
>>>> After adding bridge as upper layer of bond/team, we usually clean up the
>>>> IP address on bond/team and set it on bridge. When there is a failover,
>>>> bond/team will not send gratuitous ARP since it has no IP address.
>>>> Then the down layer(e.g. VM tap dev) of bridge will not able to receive
>>>> this notification.
>>>>
>>>> Make bridge to be able to handle NETDEV_NOTIFY_PEERS notifier.
>>>>
>>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>>>> ---
>>>>  net/bridge/br.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/net/bridge/br.c b/net/bridge/br.c
>>>> index ef743f94254d..b6a0921bb498 100644
>>>> --- a/net/bridge/br.c
>>>> +++ b/net/bridge/br.c
>>>> @@ -125,6 +125,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
>>>>  		/* Forbid underlying device to change its type. */
>>>>  		return NOTIFY_BAD;
>>>>  
>>>> +	case NETDEV_NOTIFY_PEERS:
>>>>  	case NETDEV_RESEND_IGMP:
>>>>  		/* Propagate to master device */
>>>>  		call_netdevice_notifiers(event, br->dev);
>>>>
>>>
>>> I'm not convinced this should be done by the bridge, setups usually have multiple ports
>>> which may have link change events and these events are unrelated, i.e. we shouldn't generate
>>> a gratuitous arp for all every time, there might be many different devices present. We have
>>> setups with hundreds of ports which are mixed types of devices.
>>> That seems inefficient, redundant and can potentially cause problems.
>>
>> Hi Nikolay,
>>
>> Thanks for the reply. There are a few reasons I think the bridge should
>> handle NETDEV_NOTIFY_PEERS:
>>
>> 1. Only a few devices will call NETDEV_NOTIFY_PEERS notifier: bond, team,
>>    virtio, xen, 6lowpan. There should have no much notification message.
> 
> You can't send a broadcast to all ports because 1 bond's link status has changed.
> That makes no sense, the GARP needs to be sent only on that bond. The bond devices
> are heavily used with bridge setups, and in general the bridge is considered a switch
> device, it shouldn't be broadcasting GARPs to all ports when one changes link state.
> 

Scratch the last sentence, I guess you're talking about when the bond's mac causes
the bridge to change mac address by br_stp_recalculate_bridge_id(). I was wondering
at first why would you need to send garp, but in fact, as Ido mentioned privately,
it is already handled correctly, but you need to have set arp_notify sysctl.
Then if the bridge's mac changes because of the bond flapping a NETDEV_NOTIFY_PEERS will be
generated. Check:
devinet.c inetdev_event() -> case NETDEV_CHANGEADDR

Alternatively you can always set the bridge mac address manually and then it won't be
changed by such events.

>> 2. When set bond/team's upper layer to bridge. The bridge's mac will be the
>>    same with bond/team. So when the bond/team's mac changed, the bridge's mac
>>    will also change. So bridge should send a GARP to notify other's that it's
>>    mac has changed.
> 
> That is not true, the mac doesn't need to be the same at all. And in many
> situations isn't.
> 
>> 3. There already has NETDEV_RESEND_IGMP handling in bridge, which is also
>>    generated by bond/team and netdev_notify_peers(). So why there is IGMP
>>    but no ARP?
> 
> Apples and oranges..
> 
>> 4. If bridge doesn't have IP address, it will omit GARP sending. So having
>>    or not having IP address on bridge doesn't matters.
>> 4. I don't see why how many ports affect the bridge sending GARP.
> 
> Bridge broadcasts are notoriously slow, they consider every port. We've seen glean
> traffic take up 100% CPU with only 10k pps. I have patches that fix the situation for
> *some* cases (i.e. where not all ports need to be considered), but in general you can't
> optimize it much, so it's best to avoid sending them altogether.
> Just imagine having a hundred SVIs on top of the bridge, that would lead to number if SVIs
> multipled by the number of ports broadcast packets for each link flap of some bond/team port.
> Same thing happens if there are macvlans on top, we have setups with thousands of virtual devices
> and this will just kill them, if it was at all correct behaviour then we might look for a solution
> but it is not in general. GARPs must be confined only to the bond ports which changed state, and
> not broadcast to all every time.

Again scratch the last part, I misunderstood why you need garps at first.

> 
>>
>> Please correct me if I missed something.
>>
>>> Also it seems this was proposed few years back: https://lkml.org/lkml/2018/1/6/135
>>
>> Thanks for this link, cc Stephen for this discuss.
>>
>> Hangbin
>>
> 
> 

