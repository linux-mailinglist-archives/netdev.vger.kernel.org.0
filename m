Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD265303771
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 08:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731597AbhAZHnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 02:43:15 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7725 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387472AbhAZHl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 02:41:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600fc76e0000>; Mon, 25 Jan 2021 23:40:30 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 07:40:29 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 07:40:22 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 07:40:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAVuhcAnrvO/ZWdyFn/V2ujwE2f+Wc3UujxMCoqn0hDtM57gzCzRR+CId5ldmXZ+v/mDA71lZMaZE0GrRM07ni/ZHEh3+0A9PjpgXMikCBmIpHGyLNmRCXzrzxyegYY9VTnJULVxp14WYYIQXp9lvb97dGpR6VYnrCAIk3YGS9CaVFL6svJYleq4lfh79Npo5Un5ySW4A/K+Z6cioYezaOeZ8YVxvM+pzE3rektLmVf9N+YwNDhxNQ9rhOk9A4LYvPfsVb/CmZ+tUIoLDlyFGro46VEDZpWjrBFi2dnpvA15jqXR6Glqy9AdswYFHhKPphqBH6ZLG+MPCVyrhm2+KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TokF8fBD1VT3oaASSR4IcURgeAFKFygEzdmLlIccYMs=;
 b=Evsq0FTfAlJj38cPcpK/OdRY0foWS9tBdKJksOQILR970K/KedM8O+hmaIMvdcWQGvFPR5svh7tHDGJt5Q2CC45GfF94edxKBbpxdjkRw40wnBzbTfO9DUpOt2o3Fx5TwLfbGs5c9IYG+60YLWxDVVSfeCHAnAy/+c4/n39YAY1Eutiv/ha1i9Y/50cv1zkpWKEoDJly2Y6WWXU01ehWi4od5V+OjCxzu11fIb8KmNXkSnO4G2plJWTRJCJLFVv/QvaGxWyJLXagRJwIbVVv/C9at3yfMtt55rirdRSa6f6fFD/++Y3G+8oK3GffJ1sRAnZxipdcEBLt5a+gDQ23qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1852.namprd12.prod.outlook.com (2603:10b6:3:10a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Tue, 26 Jan
 2021 07:40:20 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704%4]) with mapi id 15.20.3805.016; Tue, 26 Jan 2021
 07:40:19 +0000
Subject: Re: [PATCH net-next] bridge: Propagate NETDEV_NOTIFY_PEERS notifier
To:     Hangbin Liu <liuhangbin@gmail.com>, <netdev@vger.kernel.org>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>,
        Jarod Wilson <jarod@redhat.com>,
        "Jiri Pirko" <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>
References: <20210126040949.3130937-1-liuhangbin@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <8a34f089-204f-aeb1-afc7-26ccc06419eb@nvidia.com>
Date:   Tue, 26 Jan 2021 09:40:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210126040949.3130937-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0009.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::19) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.166] (213.179.129.39) by ZRAP278CA0009.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Tue, 26 Jan 2021 07:40:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad4f1767-20de-4678-6f3a-08d8c1cda1a2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1852D8D0568358BA14B1348BDFBC9@DM5PR12MB1852.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tSAaCgx/3lNCFL61iyn1lQoCtYbybivfmucDx4EzZEIZUywW6YutkGFbktHqAmyW1Wg5HE5v6h4UWVhYo1pcvwS7iRJAm4xQptlrEfcCGh4bsAEttuXO2KWVJ+rfJLC0fnMyQah9kp06Ik/XgH6A4IOjgkjtFKb71f4NxrXNIS8xcbP/L9J85gb7dr/lnLpIjDaQkVwTsua74y+iETERAW0QL196ak87GuRCBedzhf4IGl7QQmKf/RYb/2KVMkaV1g2m+RJipGdzSZ+Gelnkg5LBl197uttn8mJKNCgjs2PZGLfS5Cgz9fNad5nEhZa5rmf0y2vdBngbHfdERXCIImKxrltQQncOmT3j86JfbR74GqsYfbS+RvBwjV6A3WV7c3ZfWoRq/3rFqYzNHOhtExW62Um/LoFFCC5PodeTPjUVCKna33e/AYA8EyWgHd1Ftj3MR0nZ88AnzA0llywyNgjgtobsxLxHQY5B5iucmnkxCWu0LQdjcgJieF03hJIFlKbtDM9iAva0T+LYeDGxZer3IXcwn9BQPvJhNLK45lWH1Sxu7ZRQuGlpeWEBvbI6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(6666004)(16576012)(54906003)(478600001)(316002)(5660300002)(2906002)(31696002)(966005)(31686004)(8936002)(66946007)(36756003)(956004)(2616005)(53546011)(86362001)(8676002)(26005)(16526019)(186003)(66476007)(66556008)(6486002)(83380400001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Zzc0Qnlpc3lOY0tsMFFuU3pJaWpEUUpnUkhXa2JwblU5ZFZadDZRRmxJV1k1?=
 =?utf-8?B?UHFDWXk3Wnl3OFhzOEJVbHVxYnJaS2JIRXBhWjB1cXNJelBiVW9iZDRFQ09C?=
 =?utf-8?B?TVp4RVRNcmpZc2VjZ0FMVTIxMFFmM0ZZVHh1VlVibjREK2tvNWJPQVRjZ3Vm?=
 =?utf-8?B?SkdKSk90TjNSYXRFcFNIbEhPQ3Y5WHdidW5lWHZyQTJSQlczOExOWXZiZDA2?=
 =?utf-8?B?UDZHNFdwL3Y4QTBYNE93enNNN3JxTHFMKzdSQUlCb3JkNHVvVG9XeGJtSFNx?=
 =?utf-8?B?eHlmY2lRK2pKUzJraFBhVE1QMWJpc3pyZFdpd1JnYkRNLzhmZk1xRXFhRXAw?=
 =?utf-8?B?dWcydTB6TkRGQlZUcklMdHBHMndjMXNtbkI2M2Z6clNXakFjNmorVWpDbnN2?=
 =?utf-8?B?a2pxZzVSVC8zR3d0UitEajlxYnhkeDE3Yk1pR0t1dFpPeXJoMW0yZGlFQWV4?=
 =?utf-8?B?Nk1UbFVScVJQaCtuUlNkV1lqUUN4M3RnU3loWXgzTjk0Y2U3ZVZiSWc1a3oy?=
 =?utf-8?B?UXpmZWY1dVlvOExKRjVSV0gzWE9lRjBJenNNdzhpSGxaVlNPRWloRG9zeE00?=
 =?utf-8?B?RlgwQThnZnlPbkJsRFR0MUJxM3ZuQnBOUE5SQ3BpZ29ha2FjWDJ1cnNlVEpD?=
 =?utf-8?B?TWJWOG0zZWJnOFJjR3NPS0dRS3VBQkVlU3E2UW02L3Q0eTRwYTgxSzNhUTJ4?=
 =?utf-8?B?U25SclNiWkh4eFVXSHFEeU5xeG9sUlRLTDEzY1NoeEkzTGxhdE5idmJ5c3hv?=
 =?utf-8?B?Wm9sNktkTWJJQzJDNHh5UGtvaEtQd0Nya3dlbzZ2ZFdOTFlCNndGZVBoVFhU?=
 =?utf-8?B?N2ViOVJzVEJmNnZuVVF4SFQ4b3U5QkdsZXRIamV6d05lMXVNTnFBZ0FYdW05?=
 =?utf-8?B?eFNDUjZqaHE3cDNFVzNmRGZERTBydFc0c1NZZnl1dk1VQXFoWWh2SWxGdStO?=
 =?utf-8?B?QnR3bytrV285aHZodXU4TFJhYVdjQnNBR2hqdXVuK25WdHAyUlh6WDBaRkRO?=
 =?utf-8?B?ZEExdGxCODA2SldoS0NIN2wrWDk3L3lSY3ZKb1Q1d3VFR2lxekxNWVVqTGNX?=
 =?utf-8?B?Y0tsU3RhejJyOGo3bmozMU5ja0RzQUtSZEdiZG9pcEtkME12R1FCMHd2ampO?=
 =?utf-8?B?dnpkS09aYXJlYlVRZ1cxOGN2SENPaXN4L0I5VUtLTU41NzRZQ3o3WndudGJp?=
 =?utf-8?B?VjlCNjJLcFV1THBIeUczdWVBcEtQR3ZuV0huWlR2dWtCenBXN0JZV0lPZmtZ?=
 =?utf-8?B?cU9VQlA2UzhKNnV4VldHbm1OTytTUWlpdzZORUp6NHZnTVcwMGNVVWZ5U0VH?=
 =?utf-8?B?SnVCNjRCenpqd2Jmc3J3OVlPeHhEeVc1eXlWOTBiU0xOaVVwMUxhZk9Mc1B4?=
 =?utf-8?B?M2hKY2FNakd2OGdmTXdwUDZmdEtMVU5pRFZqSnJaTS9hUGdzd1Q4dVFTR2kz?=
 =?utf-8?Q?eggGQSS3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4f1767-20de-4678-6f3a-08d8c1cda1a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 07:40:19.8731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Vm0AYyPBjT1pUmUENUR3LlIOOiCuy1Z7z0bqOPpp1ilkgSw45K9nB2aZV8epkqhvVOusHlUV1QE2DdHJOn6bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1852
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611646830; bh=TokF8fBD1VT3oaASSR4IcURgeAFKFygEzdmLlIccYMs=;
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
        b=el5x9MzrbKb7d1FcYKR3AMmLAosI60rEL9+YZ1NEew/3z688BNaNfzMAM/EY6c/7u
         AJXfNvjTtCLDn/wUV7A3FBGzuIs6sOlQioBkzFmMMoM+OoiFo1ZcYN1f6h9Nqiq5M1
         8XLEfr2lzPei1dxVwtW6GFuRWK8DTFupBxAD3KOziGl9i8mSs3NU2tl+6coXatPcmx
         GB39umThOroCisbXWkzNRDYOtnYcvEduu6b/0qKUT609FeoOJCloEXr0JIbBXkjbVc
         6f2Is7V1dRJtdujeLRwXtJ+MNjUrVeb0eHmnJsvRMFeH3+5EudulV796Av1HEcpRWX
         3FkBbSfQQ5+sA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2021 06:09, Hangbin Liu wrote:
> After adding bridge as upper layer of bond/team, we usually clean up the
> IP address on bond/team and set it on bridge. When there is a failover,
> bond/team will not send gratuitous ARP since it has no IP address.
> Then the down layer(e.g. VM tap dev) of bridge will not able to receive
> this notification.
> 
> Make bridge to be able to handle NETDEV_NOTIFY_PEERS notifier.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/bridge/br.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index ef743f94254d..b6a0921bb498 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -125,6 +125,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
>  		/* Forbid underlying device to change its type. */
>  		return NOTIFY_BAD;
>  
> +	case NETDEV_NOTIFY_PEERS:
>  	case NETDEV_RESEND_IGMP:
>  		/* Propagate to master device */
>  		call_netdevice_notifiers(event, br->dev);
> 

I'm not convinced this should be done by the bridge, setups usually have multiple ports
which may have link change events and these events are unrelated, i.e. we shouldn't generate
a gratuitous arp for all every time, there might be many different devices present. We have
setups with hundreds of ports which are mixed types of devices.
That seems inefficient, redundant and can potentially cause problems.

Also it seems this was proposed few years back: https://lkml.org/lkml/2018/1/6/135

Thanks,
 Nik
