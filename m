Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECECB303F72
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405490AbhAZN6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:58:03 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15944 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405613AbhAZN5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:57:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60101fa60000>; Tue, 26 Jan 2021 05:56:54 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 13:56:53 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 13:56:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVK+wKepkJF7QB1E1txfwjzuUoW4CCEUfn8hB1hXe8Y4y4k/ydO7uIVi9TJ8j5010q0xVkFRRXfL72G4D7ZxFDEjCm7MdawhLFAw0rPl0PvvmZXSrWC0HlEHvyATzOFn9ZVSpGctxl4XlIJc0EpMkltKwGx3PhvCKsKq8176h5/JUYB2apWm+m6h42YYC7cs97PmEaMM4uuCNYxuYbuIVXJ3mFFlIYndlvK4yvJimSn4Wtgg4VHJ2wdQVmoEW3p03VP9fXFChvHO1v6UqYG5PZfZD77ZR4k1eLtfa1yfz/meII1Q2q4HwSAPBH3Fc7gxo8qHtGoUQ920CTYinLZaTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmRkg/WIddBCdFnNCf1NVTZcwbWeq/78kglAUSRUJPo=;
 b=l3cyOjHqjuXv+Vl43oAPJ9q/S9NMKGnmEdZdOhNMG8Yk3ocz5L8gQyNc2y/dzIl9RNsgRCVQPVAxRgFxYgxidZHGJZW2p1PHJDuqHxMAkX4rL1/9iK/QAglvpAundgjlpz5ic0eROPgEuhTt9QAJlsXa8+Gnv4JV4yDo3AFAcDqGhKyYg/rYuOSU57grB5x5BlyBgHx8hIFMtRvUTXw9N/dDucaF1J+NyGGJlc28dLnYmqUoQq6PHJJDLHOfx52ARPYT/lW+JvtuF7vUNvpP1s7rXCF6DxRLAlq6c7u7nbn/Y/vEujexBOQrU64RjYQ37LTAAr17PMwMRaHQqqzbQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4878.namprd12.prod.outlook.com (2603:10b6:5:1b8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Tue, 26 Jan
 2021 13:56:52 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704%4]) with mapi id 15.20.3805.016; Tue, 26 Jan 2021
 13:56:52 +0000
Subject: Re: [PATCH net-next] bridge: Propagate NETDEV_NOTIFY_PEERS notifier
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>,
        Jarod Wilson <jarod@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210126040949.3130937-1-liuhangbin@gmail.com>
 <8a34f089-204f-aeb1-afc7-26ccc06419eb@nvidia.com>
 <20210126132448.GN1421720@Leo-laptop-t470s>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <90df4fe6-fcc5-f59a-c89c-6f596443af4d@nvidia.com>
Date:   Tue, 26 Jan 2021 15:56:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210126132448.GN1421720@Leo-laptop-t470s>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0120.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::17) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.129] (213.179.129.39) by ZR0P278CA0120.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Tue, 26 Jan 2021 13:56:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30e904fc-eb44-49dd-0feb-08d8c2023b97
X-MS-TrafficTypeDiagnostic: DM6PR12MB4878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB48789DD260C11385A248A26ADFBC9@DM6PR12MB4878.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AyX3L7Lo4cqt//Uqz6T2NlN3alTTtVZlTcqVZqTVrge8ir7Kyj958lVM1YGHzMY/2oQLwRv8YRTGno07IrtV+6h65coVg8hhySrG9LbjVO6QRXFphHFtYLlLh40F5pjvpTZy+f5y78l1MVhOt4QfodoU+tSV9aRzseRJerjZpQbbkBx8DZ49Fg232RFv8MbWS9s5lMQ2R371bPjKjwPiKUIdW6+YvOQ/fJHP1zKKkiL1HHy2Dweg5ArNXBApIjDfaQEb2d9yQCbVq82HA+xa7Lz6xSLbAfvauwrKb0oJZTKo1tqJTQJvz/SZyrBTjWh/kONqlrV6je6mFOpPUQsozmfxflhYg+7yLXdPnUg77N4YyVbJdprLz2NgHCgwAk1/0uMvYC3jXfkG/gbXG3cCwgG9W/Q0clA2APQxT/UCAa4cNb5R89BoArlqnteDccmmRbwZdM/r/1JMpwnI16goUeqF25DCA6pAUB5sgDew95kLCpm+yN7/52rbFdO38ADCZ7BC2LKAy/GLVOtMmSmkWyRxjo/7kJ7j0ubp/3vcn4KJEPa2dgcEsGgEPQhOemon
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(966005)(83380400001)(53546011)(31686004)(66946007)(2906002)(6666004)(186003)(86362001)(54906003)(26005)(36756003)(31696002)(16526019)(6486002)(8936002)(956004)(66476007)(66556008)(8676002)(6916009)(316002)(16576012)(478600001)(4326008)(5660300002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bGVHTGd3Rkx3K0JoM2VyK2V3aXFJeXY4Mzg4Ym5WVi84L3dZbEF5NHhiT2ZQ?=
 =?utf-8?B?RENtYitFQ1NWbVNWT0tOV2ZzSThkRGp4Q1ZqM2gvbkYrYWNNTmhQK2hwdDg0?=
 =?utf-8?B?YnF6SEd2aTUyd0grQ3lkMGtlaW9Rc0xiMUVTVVYzT2VvbEhmR0IrUlY1ZmNk?=
 =?utf-8?B?MnVWUFVzWUxqcGowSGc2N3lucG0rNk9sOFFFMERCbG1aSHlwUlRGZ1UxLzZY?=
 =?utf-8?B?c0JmVHdPOW1sUTlUM0xtNjVMdFNnVkNvZHhFS0RrTEdxOEtBQ2krc3MvUEpG?=
 =?utf-8?B?a2tNdzRuMCtSdnpCSXprOGFZQUwwaHlXUmJ2eE94YU5qalhZbHJBM2VaRzU3?=
 =?utf-8?B?WDlSWmFxTy9nb2RtcnhUdFkzMmN3ckVmbzl6RVRLYnllL2RvZHVrK2M3Q1FN?=
 =?utf-8?B?TEMxRzdRRFVGbUI2MXM3WmZIdWdqN0tyWFEwYWdFRFVxeWw1dG1uVUVRdUVl?=
 =?utf-8?B?aGhPc1hpOGtNZ0N5OXN0MXNVRXRyZWZtMHZ6QjlROE8wTTRnRGZsdmRQM0R4?=
 =?utf-8?B?MjhHSUkrcEprdlI0K1FJUFRabmFvcFUwUHRmclcwS0FiektreThqZzFGenhO?=
 =?utf-8?B?VFlkcjJQcnpxZm9QakpwS09iSzVkajF5djdWRlRxODVJREtsSW1BemJjWTIz?=
 =?utf-8?B?YUlUZUluS3pKYXRUUXYvdVRRWlVsYW9qYjZkNEZudTMzOTAyL2tEaDZubFdu?=
 =?utf-8?B?UVJRaHFiVGp3WEhpdDRrSUZXalBwR05LRXZYTnVlQ0RRVnFnMFpBVyt6akVR?=
 =?utf-8?B?amxLVVQ3TjRSNUdxelJSdEF6K25BNTRaWlF0QW5xaEZuVVJMUWRIWXZxMmZi?=
 =?utf-8?B?NTU3cEdRNWpHeVhaSnFLNlQ5WGRiUWl1dnZQdVZVeW13UzRaZ2t6OFM4UDFN?=
 =?utf-8?B?QUtJVERhYmxrREl3am16NWxtcnVqNmRXMHFSRURtaHZsYzdXVkpKVTRVUUd1?=
 =?utf-8?B?UFA5cytocEEvN1hCWkc0c2lGMmJMbzBiM1J0M3NIRWdnRW5GVTYzNTA3Y25M?=
 =?utf-8?B?RXQ3SE9xVGl4SS9QdkFkajFpZFN5NHFSbnl2UkYvWkJNTnBnNWZRbG14Vzll?=
 =?utf-8?B?K2pvOWlhenpnK1FldTlCd0pKR1ZSVEYvRWo5MFdFZmtFUkZHd0lieDE3WnV5?=
 =?utf-8?B?UElweXVOM1M2U1NkZ0F0V2JBVXlNWHdLOG93aTkzOTF3bDRtVStiUmkrTkRU?=
 =?utf-8?B?M3VjYnZrczU4UEhPY25JV2lpQjM0cWZrVU1tWWpYTmEzcVFJMU1TTTZQNFgv?=
 =?utf-8?B?UVQyT09JbXRJb05FMk5BRXhSNklGOGhGRkV3RUZzQW1GNURlS0tWeFFGbit3?=
 =?utf-8?B?UW1qRWJQTWlQOWxWT294QWFqZmxLRUlEUXdYdDFqQWZZMmpWaW40WXdyM21j?=
 =?utf-8?B?YkY2NG9rME02dUhJTnB5czNlZEFITU9maElEczE4Q3NKSmR0NlhyaW11RmNp?=
 =?utf-8?Q?GI8/lINc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e904fc-eb44-49dd-0feb-08d8c2023b97
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 13:56:52.0086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMng0QsszNqDHpHqVWeJUNw1AHAvrYiRrQ58VI0A2dTLTWVaH8DFT7N2/HJIJfYO2dIvndHR8Exb9WbhWI3F+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4878
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611669414; bh=LmRkg/WIddBCdFnNCf1NVTZcwbWeq/78kglAUSRUJPo=;
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
        b=RU8g/HZZ0AKVQwUyd1qki/dM9IQdzh8pSgO9gkKWXbLliQ6jyv7BhXPru+dW9hp0x
         BKD+LQ7Cgvmys2P7wM4wVsn3AJYkPgn02sBeXY5lMcidjSLWVS2Kr8ewuUSdTKZjJv
         ajmM7mlNZmkqZMGE/nYVA8sVy1w0Rec8VEFliaUafs34LfRsn8oNsX5Uce3b5aJLFu
         W7YQIQvXpfGutEC0W7d01rn3AVp1kVtRQcJcKdj5/25SR0jVHFkZsqsbxKOWUFONJW
         JO+fqh7DBv91HV6HvZjUi/zaGuU55XHEXbnGDtUSHwL6aVRFX4ZuoUyabCpUaSEV0c
         1imuL5DFLadpw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2021 15:25, Hangbin Liu wrote:
> On Tue, Jan 26, 2021 at 09:40:13AM +0200, Nikolay Aleksandrov wrote:
>> On 26/01/2021 06:09, Hangbin Liu wrote:
>>> After adding bridge as upper layer of bond/team, we usually clean up the
>>> IP address on bond/team and set it on bridge. When there is a failover,
>>> bond/team will not send gratuitous ARP since it has no IP address.
>>> Then the down layer(e.g. VM tap dev) of bridge will not able to receive
>>> this notification.
>>>
>>> Make bridge to be able to handle NETDEV_NOTIFY_PEERS notifier.
>>>
>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>>> ---
>>>  net/bridge/br.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/net/bridge/br.c b/net/bridge/br.c
>>> index ef743f94254d..b6a0921bb498 100644
>>> --- a/net/bridge/br.c
>>> +++ b/net/bridge/br.c
>>> @@ -125,6 +125,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
>>>  		/* Forbid underlying device to change its type. */
>>>  		return NOTIFY_BAD;
>>>  
>>> +	case NETDEV_NOTIFY_PEERS:
>>>  	case NETDEV_RESEND_IGMP:
>>>  		/* Propagate to master device */
>>>  		call_netdevice_notifiers(event, br->dev);
>>>
>>
>> I'm not convinced this should be done by the bridge, setups usually have multiple ports
>> which may have link change events and these events are unrelated, i.e. we shouldn't generate
>> a gratuitous arp for all every time, there might be many different devices present. We have
>> setups with hundreds of ports which are mixed types of devices.
>> That seems inefficient, redundant and can potentially cause problems.
> 
> Hi Nikolay,
> 
> Thanks for the reply. There are a few reasons I think the bridge should
> handle NETDEV_NOTIFY_PEERS:
> 
> 1. Only a few devices will call NETDEV_NOTIFY_PEERS notifier: bond, team,
>    virtio, xen, 6lowpan. There should have no much notification message.

You can't send a broadcast to all ports because 1 bond's link status has changed.
That makes no sense, the GARP needs to be sent only on that bond. The bond devices
are heavily used with bridge setups, and in general the bridge is considered a switch
device, it shouldn't be broadcasting GARPs to all ports when one changes link state.

> 2. When set bond/team's upper layer to bridge. The bridge's mac will be the
>    same with bond/team. So when the bond/team's mac changed, the bridge's mac
>    will also change. So bridge should send a GARP to notify other's that it's
>    mac has changed.

That is not true, the mac doesn't need to be the same at all. And in many
situations isn't.

> 3. There already has NETDEV_RESEND_IGMP handling in bridge, which is also
>    generated by bond/team and netdev_notify_peers(). So why there is IGMP
>    but no ARP?

Apples and oranges..

> 4. If bridge doesn't have IP address, it will omit GARP sending. So having
>    or not having IP address on bridge doesn't matters.
> 4. I don't see why how many ports affect the bridge sending GARP.

Bridge broadcasts are notoriously slow, they consider every port. We've seen glean
traffic take up 100% CPU with only 10k pps. I have patches that fix the situation for
*some* cases (i.e. where not all ports need to be considered), but in general you can't
optimize it much, so it's best to avoid sending them altogether.
Just imagine having a hundred SVIs on top of the bridge, that would lead to number if SVIs
multipled by the number of ports broadcast packets for each link flap of some bond/team port.
Same thing happens if there are macvlans on top, we have setups with thousands of virtual devices
and this will just kill them, if it was at all correct behaviour then we might look for a solution
but it is not in general. GARPs must be confined only to the bond ports which changed state, and
not broadcast to all every time.

> 
> Please correct me if I missed something.
> 
>> Also it seems this was proposed few years back: https://lkml.org/lkml/2018/1/6/135
> 
> Thanks for this link, cc Stephen for this discuss.
> 
> Hangbin
> 


