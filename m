Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3013164BE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhBJLMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:12:54 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5451 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhBJLK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:10:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023befd0000>; Wed, 10 Feb 2021 03:09:49 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 11:09:45 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 11:06:11 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 11:06:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRnPrQAO7tltUTJfCUhxgnIyLB8HXroNw6rE+mko1l9cizzrl4IsV8J2JiusFuqZyV4QKh1KOHeh3Qeq//ATW2OkzaMQjduP24aJsbMDF6WXmje/9c6qHP8lbjr4p3Yqc2rQM2CdfLRwgSzC3EMIOSINeAUsOXo0mIOp2tqvllvfM6TuWaAOoBQVzNI4+r4DumqWajJcoLAwvIFRcHn/Xiqa3vkUEAnJhwoLAWgK96Od40eu3mMCq4LHJyaIUAgMaazCwU2dVbjzLu1pCjp6PL86BZIsa4TYHeesTgMR7aZeyLAUMUpNS1XwEny69GDB/XXSmVr/XYVXncwTYr2NJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQXcCNzGldQwHEpCtK/k/A0o3moxDA80QAxpatQPKoQ=;
 b=BwFYgnDKO/dugRe25b+cOw0d0pUKsl+TUlbfQpTo8RMCXZiq+EZ3UQq94pQ1lvjHcJnrMEvOWrKk4d9FAxInwGXwxh1rJppfTy8KjWdJuC9AoiZ9cMIon4EdHTcqltzPFajMxjoeod8OXPTJcPaErF8MXqCmMraXSfFYK//bPFrVMKhZJz3piDeVpVf5jfw0whx9stxO/vEGBGFB/pnOnnCZzUQdcu4o6qH9ww8xSHiFKlBenHOq6gGYAqBqlmiv+pjI2oy8l2BgKukKi2cOzxQja3ErHb9Qyj82rIF3sDMBCYjhWM4hvpZGc5xS5/xL7UHV2uEbP4griPwiefvKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3548.namprd12.prod.outlook.com (2603:10b6:5:180::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Wed, 10 Feb
 2021 11:06:08 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 11:06:07 +0000
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
 <a58e9615-036c-0431-4ea6-004af4988b27@nvidia.com>
 <20210210110125.rw6fvjtsqmmuglcg@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <90b255e6-efd2-b234-7bfc-4285331e56b1@nvidia.com>
Date:   Wed, 10 Feb 2021 13:05:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210210110125.rw6fvjtsqmmuglcg@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::22) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.121] (213.179.129.39) by ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 11:06:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f711ca5f-9e39-49eb-2b72-08d8cdb3ddbf
X-MS-TrafficTypeDiagnostic: DM6PR12MB3548:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB354882C937DFEA3AE6C50ECFDF8D9@DM6PR12MB3548.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: js0ws5XKCCx8SziI08ocUNyuuJXrLS/eiKpPrdhJ4il9DrQw7WlLNLyYBRwlBq+U4gWN52qpCAZwDY1OC//lPNxcQ04yvn2ut1QWBtZqXB0P4rDobeNz4r95zJKnIewlFdMBl8zjP10yOVob8OH6OSJrClpvX9E4xXilpRip7xg3mae43RvGuk+HX8bWdgvg1NwahAJG1DAqBOiOT808UP4WcV2o03DVSA7BEgFCPwhZsL8Mokyvm0lTJTQyd9/Tp4dVWUpxYpc4a/wGzcAG4B3o2u2rzTKCj4koTIz9YjLl3xhEU8n71DOMoVEHurF3Zdh+Sam91wRuG7CQxazaHiwkZUKatxqqa2Sequ6ojcwuk0gKo65sUJYpZQP2cn4wZF7X09EYUMeDVdQh6HQuYknMc58wYm8ruepFifFD9UgXR5v2HAQx3wDIdxGhZKkqxmCw2tWZxWd/J03hrqK/EydASNNSvn4jbMLamrv7xI/DVhIQPXEaaIP4e0BsYOY6CtJ/TvHXpmdroUqq1ewvjwKk5BVAW0dOOsyVouwvkTry647vNyei1DgVyeiG+c26OoaujEliEffQkumJ4LftEfy77Pk6cPDNKW/QAHHX6dk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(66556008)(7416002)(6916009)(31686004)(66946007)(8676002)(6666004)(6486002)(5660300002)(36756003)(2906002)(66476007)(478600001)(54906003)(16576012)(8936002)(53546011)(4326008)(31696002)(83380400001)(86362001)(2616005)(956004)(186003)(316002)(26005)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WE9kUEwwa201QXlXampKUGh0QVQ1R1RNdWQ0NkUxWnpyUStiRDhnaWJjNUh3?=
 =?utf-8?B?aHhXbHZIMWN1NUY1VFNwTm0vK1VuMHBQZ21HTG8wemhrTGM2aXdlN3V4cnVS?=
 =?utf-8?B?Ykx3d2dGSld1YUNkd1RKa1AvWkJ6bjJnTlhkVkpVSU1xSGVDcEdzRE5lZitj?=
 =?utf-8?B?OVE3NFpVUlFxcVVlTEQ0YjRodUJlLytMNEF5S01OQW5mZk9QZWxVd0V6UzBV?=
 =?utf-8?B?U21QV0ltalBjWkFSZTFTam52RkZwc1JTT3A5U0Y5UFErVHh4TFNDQXJUcGV1?=
 =?utf-8?B?TFMrYStjeXVpdG5FMDFkdm5peTdObjNuMXhRV2JoOXgvT2NVNFlEVldGVzk5?=
 =?utf-8?B?cWpwZzZFdXA1S0dSS1dLWURnMkZnVytoTHA0ZmtNTHJld01ZWFlBcnB3Mkdm?=
 =?utf-8?B?WmhCbXBBYmtHdU5RcWNLUVdqSkxkNEhXS3oya1owdkRWNnUvdWhQNjlvbHdJ?=
 =?utf-8?B?NFBpa1l1SEFmN3haOVFBSWZiNWxzWXNsNXNzeVhoL1UvbjNiZDlCRUs4V0R1?=
 =?utf-8?B?dTNWRzczNmthM2t0QnhML1NiZTVsTkgzdFNtWFpQbDZkWnFaNWhhU1hGMkJV?=
 =?utf-8?B?Znhac0hHRnllWHJ6QlBmSVRyaFlHN1IzQm02L1NQdzk0S2lETGplN0p1OXRQ?=
 =?utf-8?B?aUhGRlFvQ2xPZDhYa1dKazRFaDNucXhmc1c0MHlpbFljK01rVHpZY1hDMTE1?=
 =?utf-8?B?TU5zZVFoQ2NvVGl1WllvV3pKRHQvYzNtNC9ZY2xmeHRZLzhFQ3Voa1pFcjJ4?=
 =?utf-8?B?UEV2VnpQKytRVDZNSEIxb3FFWG9Oa0NyYmE3TjhJUWhQS3piUjI1U2YzYS9Q?=
 =?utf-8?B?SmptTlNFKzJURG8yWml1YXl3OTEzQUpHUHhrRmxiYWlYcGVPbzlTNnlpUUdW?=
 =?utf-8?B?SXlxZmVBSUNidkJiZTdjQ0FhSHZUZEw2K2F5b1dxSTVTVmxKS01SMlROallW?=
 =?utf-8?B?eHoxNEszeWYxelBuYXN4ckhmVzEwNWdHR2pVamdoai9ZZ3VKb0s4SHhMWVRs?=
 =?utf-8?B?WDF1SmsxUE03M1h0TDJycGVXSDVWZkM3bko2UW5DQm96RGdxQkZHeWhTdUQz?=
 =?utf-8?B?MkpoQmFDaCtBOVh0ZHdLUitsQTMwSmlRUWJhaTVxNnBSMnJtUFcrYVZrRFAz?=
 =?utf-8?B?QUlVVGR4SjhHeCtvVmJlQ0hoZlg2ZnQwNTkxVUNFd0RPQlpJdTZqVFc2Skk0?=
 =?utf-8?B?aEFNM09FYUt4eExXVlgwODFPOWhGOUFaNEhGSE1pTWJzYnhlTWt5Rm8xMEdE?=
 =?utf-8?B?di8wZldhZCthVFlqeEI1c0VnSFJFdTNGbkZ3MWJKTkljbEt0Q29jb1Q4KzJR?=
 =?utf-8?B?STRMTERrMFRnN2FuR2x2cGpGcUdiV0R3WXlBc0NzRVVNRmFoWm13Vk0xZmV2?=
 =?utf-8?B?SC8waUw0RTZEa29TMi9PVVFzNzBkTWxZdms5NFZjOERnZTdacEVFOHZ2MDVO?=
 =?utf-8?B?R2NMSCttUnFZeEZPWHZJYjR2N1FwODVrWWZSY1hjQVJMNytRV0Jvb3ZTL1ZB?=
 =?utf-8?B?c1JVVnVNalU4VHF0Yk1nOXBxUXd4clNjZ0lVSG1ZT0NxQnFYbmVNY2EyV0g1?=
 =?utf-8?B?bkVSdVlCeEY5ZTJaeEUzN2o0SHBqMFM5WEdjd1k3aEVtczF5YW0rS1BScmMz?=
 =?utf-8?B?djlHOCtoOWZKSjNuS2IwTkFBUUhYWnd3d0R6ZTVxMUQrSVlIMFd2UDQrY3RO?=
 =?utf-8?B?Wmd3WWFOZ0k1VFo4bm1oNFIvcTNYU2VjVDJWU2xyUjc4WGtIZm5MeERaZWty?=
 =?utf-8?Q?y3LHj4Gdvhc7bIdztEuR4uejiB36XMfYW2y7wAo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f711ca5f-9e39-49eb-2b72-08d8cdb3ddbf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 11:06:07.7283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kmdIZauY3QvQn2gLVMPyZvyMzYJlFRXXxw5upbnvBcXeRvG91n3HQ6b3n0yrj4zzT+MVrX5e2IuHMlqbqBt8qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3548
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612955389; bh=BQXcCNzGldQwHEpCtK/k/A0o3moxDA80QAxpatQPKoQ=;
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
        b=qOqMTgckoOI1RB3HL3mcU/JRejbL0fXkuQp70+xyop3KuiesQ4DKGBYpUDdaY/hpL
         jO3aLkSyRlXo1g5u1njuBb/D/6ff/BHMH5Fziu9BlOwjk2rl9dKkNKW9lygXc4tw/w
         15SREkyR0W1lrtaXC3Wbv7uSgPENjDmrPGVOF9flZZ/7rTlc9D3i2AIXVM+cJi1uR4
         3SIcsNU7lCaufV5agEO1Fm4jDj0ciG44RHaVu/n8BG02loIKh2cEhoctQT7XViK3DT
         8m+DfBBytf4sk8uKdih7kEa2iYLAu4cKu7hzIuTwZ5h3H1iebH2WLTX51A1UmlUMTd
         +fRw6Unn21B8A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02/2021 13:01, Vladimir Oltean wrote:
> On Wed, Feb 10, 2021 at 12:52:33PM +0200, Nikolay Aleksandrov wrote:
>> On 10/02/2021 12:45, Vladimir Oltean wrote:
>>> Hi Nikolay,
>>>
>>> On Wed, Feb 10, 2021 at 12:31:43PM +0200, Nikolay Aleksandrov wrote:
>>>> Hi Vladimir,
>>>> Let's take a step back for a moment and discuss the bridge unlock/lock sequences
>>>> that come with this set. I'd really like to avoid those as they're a recipe
>>>> for future problems. The only good way to achieve that currently is to keep
>>>> the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
>>>> after the flags have been changed (if they have changed obviously). That would
>>>> make the code read much easier since we'll have all our lock/unlock sequences
>>>> in the same code blocks and won't play games to get sleepable context.
>>>> Please let's think and work in that direction, rather than having:
>>>> +	spin_lock_bh(&p->br->lock);
>>>> +	if (err) {
>>>> +		netdev_err(p->dev, "%s\n", extack._msg);
>>>> +		return err;
>>>>  	}
>>>> +
>>>>
>>>> which immediately looks like a bug even though after some code checking we can
>>>> verify it's ok. WDYT?
>>>>
>>>> I plan to get rid of most of the br->lock since it's been abused for a very long
>>>> time because it's essentially STP lock, but people have started using it for other
>>>> things and I plan to fix that when I get more time.
>>>
>>> This won't make the sysfs codepath any nicer, will it?
>>>
>>
>> Currently we'll have to live with a hack that checks if the flags have changed. I agree
>> it won't be pretty, but we won't have to unlock and lock again in the middle of the 
>> called function and we'll have all our locking in the same place, easier to verify and
>> later easier to remove. Once I get rid of most of the br->lock usage we can revisit
>> the drop of PRE_FLAGS if it's a problem. The alternative is to change the flags, then
>> send the switchdev notification outside of the lock and revert the flags if it doesn't
>> go through which doesn't sound much better.
>> I'm open to any other suggestions, but definitely would like to avoid playing locking games.
>> Even if it means casing out flag setting from all other store_ functions for sysfs.
> 
> By casing out flag settings you mean something like this?
> 
> 
> #define BRPORT_ATTR(_name, _mode, _show, _store)		\
> const struct brport_attribute brport_attr_##_name = { 	        \
> 	.attr = {.name = __stringify(_name), 			\
> 		 .mode = _mode },				\
> 	.show	= _show,					\
> 	.store_unlocked	= _store,				\
> };
> 
> #define BRPORT_ATTR_FLAG(_name, _mask)				\
> static ssize_t show_##_name(struct net_bridge_port *p, char *buf) \
> {								\
> 	return sprintf(buf, "%d\n", !!(p->flags & _mask));	\
> }								\
> static int store_##_name(struct net_bridge_port *p, unsigned long v) \
> {								\
> 	return store_flag(p, v, _mask);				\
> }								\
> static BRPORT_ATTR(_name, 0644,					\
> 		   show_##_name, store_##_name)
> 
> static ssize_t brport_store(struct kobject *kobj,
> 			    struct attribute *attr,
> 			    const char *buf, size_t count)
> {
> 	...
> 
> 	} else if (brport_attr->store_unlocked) {
> 		val = simple_strtoul(buf, &endp, 0);
> 		if (endp == buf)
> 			goto out_unlock;
> 		ret = brport_attr->store_unlocked(p, val);
> 	}
> 

Yes, this can work but will need a bit more changes because of br_port_flags_change().
Then the netlink side can be modeled in a similar way.



