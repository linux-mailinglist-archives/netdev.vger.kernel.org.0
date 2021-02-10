Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A4331646A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhBJK4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:56:19 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8259 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhBJKxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:53:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023bb0a0001>; Wed, 10 Feb 2021 02:52:58 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 10:52:44 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 10:52:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsoOblxAylTBHWjPT1dtKjykKaEE52+eaRYV2XwCSso8AKqdVcqiNPbpXd7ffb3UvyKt38/h0u88vn/lzNQev4Kynr7dS2q+KMzcgXDrpobgFrmDjTTQgaWFtspstIpQM7kUUM+UQbOg5hJ0XeH2GGiy4ljcutoVbl6w+cHoasrv+3vgPn6K1B0vPJvdzHff1xBzFLazUodPEWf37Bh/Zx3EKgJLtgJiMliHuBSxR6kjDNN0/OFesiwI+2BBvSm8IJrD8RGaAqDiX7Vo3pP7R+qRrmMefjs1aw5Whdspm9bSU+6fWO3cWP76iwKdy21mJ5cS8cKeSjF9ROL6UTf87w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoyCDkVxFMW5IEGPNDnX4tj6Kvb9pVf6rwR0O8yY8SA=;
 b=T39CgAmJL9kQiV5UfxZbYEi6trzoApo1G/tOcXqZ4er54amivOys6ekQC/bdM4U7FLmF8+K9FzoEbB7iY4fSz8Cbcne+0d63Dj2QPOghp1FgVsH4qj8QfFbT/LF9pAcMIc7yCyk0RC4eMowQaHX7+HeU+svPyMn6Z5kYV8WAIn79NbADr5IO7yqnWxYPO6hFD29ecARWbBvn+pjjQtXPSXEkjAPc9pVR+gTPNeaj7J/tyXhukZ7ftLDkiEbHcoFQfa54ln3pYgddl8Xie34h/j7zwN8Gq7ItyCikUdqkc2c/dwmyIHIQOz7Z4Jh5oaaOzLAHgKy8WLAqrk8JzCBaWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1610.namprd12.prod.outlook.com (2603:10b6:4:3::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.30; Wed, 10 Feb 2021 10:52:43 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 10:52:43 +0000
Subject: Re: [PATCH v3 net-next 00/11] Cleanup in brport flags switchdev
 offload for DSA
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Roopa Prabhu" <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <a8e9284b-f0a6-0343-175d-8c323371ef8d@nvidia.com>
 <20210210104549.ga3lgjafn5x3htwj@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <a58e9615-036c-0431-4ea6-004af4988b27@nvidia.com>
Date:   Wed, 10 Feb 2021 12:52:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210210104549.ga3lgjafn5x3htwj@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::14) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.121] (213.179.129.39) by ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26 via Frontend Transport; Wed, 10 Feb 2021 10:52:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e730c586-a4b5-4642-3297-08d8cdb1fe02
X-MS-TrafficTypeDiagnostic: DM5PR12MB1610:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB161003140F651B6EF49766E4DF8D9@DM5PR12MB1610.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EytQKX+k4yqHN8962ceH6axMTwDE16Ly+vrBgEPmYnpDuDKAWECMj2A6JEp7lMcIiK9TaLwtDCgQGEgCw7HT5Lqm4A+yOQppAwlQqklEcRE2viJzSP7ODnPO3HM9XrLMYiNMlY3t/BeBbpQjfUORL4gVIP23MmjnzrJ+Txcne/geha+fO/BX7JvrGD2cXYZdMBA/E9reD5cBRWTK6H4yMuyoWJzkXA557huB4cWbThu4F0M4mWie4d4Z1JjKVGI8krI/ccQsSN0w04YL+XO1FbcnH//18lS+MTKaUEPUMsSmNr5PdQYDUw7rf/u5Aguke6EOljnV/UD4/lOvqVtJV9FCMAN8v86yIreBPh6HJrbr0KveoICWrMCLaPg9FvogItVRvUllqZl0o4vKVfgnAwqHTB2xBGLBJjLz7YCdJb8mTBG0tK3WJPeO8y5AhbIaCZut/Y+74nyCve05CmiUgMKACJPAT0t4mclNuMl24gYevpci9IJ6tLENGBaJmbRVQJeZiFWf5SWDJMFnXmj2Pekp7hT6QOJSuIxC0QDrxQLZeun4bwFgo8S5YtNyznEH0ezQ069AH8hbgILxT7PJ0qg0I25Wkm3BPcBLGn2Z4Es=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(376002)(366004)(346002)(396003)(6666004)(53546011)(2906002)(26005)(31696002)(478600001)(36756003)(86362001)(31686004)(5660300002)(16526019)(7416002)(186003)(4326008)(2616005)(6916009)(54906003)(16576012)(83380400001)(316002)(8676002)(956004)(66476007)(6486002)(8936002)(66556008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YzhZR0VNOVlBaFh4SUpPcmRKbmExTkRZcVFiMWIwQWVleXVrV1orL2JWWUFS?=
 =?utf-8?B?RTF6MDhHN2RWWEVNL0VZR1VTVU9qWWM1Uy9RWWYwTThDWHgzQTFCcklhZ1pa?=
 =?utf-8?B?TFBidVZROE5jbVIwUzFaZHVURXBzbEtZV0srbUdFUGc0UVN6RmxDYlAyNXVp?=
 =?utf-8?B?WTdqeXB1UkpISW5FQUhvMUxjZ1p0SFpJM1UxMVJnZEhMRGJralJTNnZlZXpO?=
 =?utf-8?B?c2ZCVThPRTN1UUZDem10bU85MG1uNitLL25rRDh0M2IyU0FvNkx3RGpLRzZI?=
 =?utf-8?B?MGRmcmtJOTlZUGZDMWFPZjhZa1d1K1FtZ3NPY25xUE81U2poWjk3Slc3bkJr?=
 =?utf-8?B?SktvSlVaUGp5eXVZTWVsN2dRSXUzR1BZcWgxS0EzcXV1K0pDZndhUVg5Vjhw?=
 =?utf-8?B?S3lNWHlKcVJkRWl5OHVRU2lHSGM5Z01zSHJFVis0c0VFcFFqdUF0bmttdFFj?=
 =?utf-8?B?THY5SkZVTkluem9LTUxOR0lFQnRvOUpHcjQ2S0RpMkRGYjVlZDFiMTRJeDFa?=
 =?utf-8?B?VnByTVBUZlU1Z2lVYlVNZlVFRzF4TFNkRE9VckM0Tkc4U1ZsYS9vRyt6ZkEy?=
 =?utf-8?B?cSsxYm56b2RHaFBlWmR5SU5Vb3k3K0J6cU5KdkQ4ZElWMXU4d2d1OTg3ZFhV?=
 =?utf-8?B?TTZXaFJYZFo1VXBLNS9IMFlUVWNEc2JGa0VXNS9pUmRodzVuL2E0RWRhQmRZ?=
 =?utf-8?B?dVIyT3k3d2F1Q3FseHN4VWhrdHhONFRaVC9oemNmZXRqUTNvR1BmbjI2Ykly?=
 =?utf-8?B?MXZsZzhRNkJnb3FQT3NuYjhnRW9IbTQ3M2pZY0hiUWZIMy9lQ2U0ZC9LUzdz?=
 =?utf-8?B?UzlYVUo2SEk1Snkyd3c3cVJhVDR3QitzNDdneENkRUJpRTNTOWVXV2xpN1pp?=
 =?utf-8?B?TmNwV01PcG8yb3RjQkE5VEdJSWpvbk1UR1VuMFIxdEkxZmFSbTg3OUNnNHVX?=
 =?utf-8?B?a3ovTFdUWkZnQWNOQUIyNlB4N2lROTVBMm9xYWpqcXJCNkRoL2FZNFFOTmlN?=
 =?utf-8?B?N1ZhSi9ZTDdBVUJMTkdneFB5NWZyMTcvaEZ4dTRUQmNEMFp4M2l4RmNSa0pS?=
 =?utf-8?B?L2MvSjRKQXZRVmFHK0JMNWpDb2VvT09IZzBxdDRSQmd5d2dUZHhzS2wyTlFZ?=
 =?utf-8?B?Vm44S3VGTTJrM1ZHZHlFSHAyMDFsRWFsWFk5VzVJd0MwNXVrUlhjTFM3VWY2?=
 =?utf-8?B?cVNqQWFYeUJSU2ovMGtsSnlyeDFyS25yb0VrR0dnUDNtYzJqUkcvZjdKbnJ5?=
 =?utf-8?B?V1gvWVlYbjZjMDE5VU83b1Q1ZGZZNVBSR0ZYNFJUU1kvd1R5VG5aV0M4ZTFz?=
 =?utf-8?B?M2RrOUtnYzI1SlRrNTRkNkpVakJsemU2YURGUWpycm51UmRVaUtHK3FBdDhQ?=
 =?utf-8?B?M2dXZHRIaHNLbmo5aE5obUorYTVsT2dCeGJmanNISllGTXE5RnhxNFZ5NEJR?=
 =?utf-8?B?VzlUWU5kZE5lSmIvV0RudlMweEE0S0RUUGdhaHlTU2lvNElsVm1ScmFHNmRu?=
 =?utf-8?B?TkEza2VFZnNkbTduRlZpc1lMMDNxWUpZbmxtc2hheE0zRlJySEFzSmpJdlJJ?=
 =?utf-8?B?ejI2cU9KOHRicnR1YjRTdW41VS9UcUl6aTZzSWNXcHU5RHJuak5zRnBYL3lV?=
 =?utf-8?B?THBkNkFrYjVMTkN2QVFTeWh0bnRzRGdEZ0JJbENnaVNlNU9Lc3l4N3hQcito?=
 =?utf-8?B?WXlXSlpaVXF0RzAydVAzRGdDRytVOEFuNmlzTUxDYjJSeGt1aW9yY2VuYi9W?=
 =?utf-8?Q?5QYH0MfynfCEvI6cs83KnwnaG7NNIa+EdE7ZLJj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e730c586-a4b5-4642-3297-08d8cdb1fe02
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 10:52:42.8622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /h70JJs9A6Evzsnxl3fOT+4RsNHdxqh2LBtMxWi23w8IrZBj2s9I9EYH7TwtzYbxlIBU0nHIFPk4jy1qrTwucA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1610
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612954378; bh=XoyCDkVxFMW5IEGPNDnX4tj6Kvb9pVf6rwR0O8yY8SA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
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
        b=or6BSl0RUAeMODas7gnX3uPEn6KwQ1bzjN4SNPM9PihGN3qIeb/jaeYT5bFQxON4c
         S1Kmq2XlMNmfZEAfRzNfpFMHpgJrieeO1kF0AsgDuyJExiEWyEAS/g1QmplMS2Pb+m
         oGXfJfN9nsnBowuEvSLT4EEc+rWXYJTRHS0tgfpy/IYJ1gxA/kE9BRV8nbMjFlpq3w
         YmOhuOavDICaoDvkmyZ2bld5wewbZO56Hu5oGWVL3w+l+a26gGXt1yJM6t9mh+8X/v
         BWYpwuaZcRQVGThOrXfJesuvE2RXQF2Rjulsrw4RA/Uw0bULesNE8jjCjmHwfHIxqD
         zi9Q9AYhLvFCQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02/2021 12:45, Vladimir Oltean wrote:
> Hi Nikolay,
> 
> On Wed, Feb 10, 2021 at 12:31:43PM +0200, Nikolay Aleksandrov wrote:
>> Hi Vladimir,
>> Let's take a step back for a moment and discuss the bridge unlock/lock sequences
>> that come with this set. I'd really like to avoid those as they're a recipe
>> for future problems. The only good way to achieve that currently is to keep
>> the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
>> after the flags have been changed (if they have changed obviously). That would
>> make the code read much easier since we'll have all our lock/unlock sequences
>> in the same code blocks and won't play games to get sleepable context.
>> Please let's think and work in that direction, rather than having:
>> +	spin_lock_bh(&p->br->lock);
>> +	if (err) {
>> +		netdev_err(p->dev, "%s\n", extack._msg);
>> +		return err;
>>  	}
>> +
>>
>> which immediately looks like a bug even though after some code checking we can
>> verify it's ok. WDYT?
>>
>> I plan to get rid of most of the br->lock since it's been abused for a very long
>> time because it's essentially STP lock, but people have started using it for other
>> things and I plan to fix that when I get more time.
> 
> This won't make the sysfs codepath any nicer, will it?
> 

Currently we'll have to live with a hack that checks if the flags have changed. I agree
it won't be pretty, but we won't have to unlock and lock again in the middle of the 
called function and we'll have all our locking in the same place, easier to verify and
later easier to remove. Once I get rid of most of the br->lock usage we can revisit
the drop of PRE_FLAGS if it's a problem. The alternative is to change the flags, then
send the switchdev notification outside of the lock and revert the flags if it doesn't
go through which doesn't sound much better.
I'm open to any other suggestions, but definitely would like to avoid playing locking games.
Even if it means casing out flag setting from all other store_ functions for sysfs.

