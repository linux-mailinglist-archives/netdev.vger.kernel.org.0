Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63430316655
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhBJMO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:14:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6477 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhBJMMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:12:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023cd700004>; Wed, 10 Feb 2021 04:11:28 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 12:11:27 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 12:11:10 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.59) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 12:11:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONWFI7/P3VcG5I5AV+XjHeOmfnZ+v0HjxtGOye2XT30oNpj9vSY5DqbyUlCxhAHdjFz0ppW9nLLrOGYqpxsu6MSoN05Q9l/m7FfyocbvguqB6mGcQDKS3KiwPK49KfaR1HMuzcmDEZpm0A+AKxMRlTWY7q9inT+c2Ok1FisVp7zKHU6hKCw8y73wfUsd/31k4tk2wmjPLY3o//kmnxKig2N/qBxgaZOw5PgpA3SiFNUEVKoDx4MRlyO8uO0zIgMWLyUjXoMAbyzLlCJgX/AsCsb2c8zyx3UGabtp8ewFHsr1vt3+vGFgYJZ+7qNGCPILIMeablZ8jhnyCkSeUgx1FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZHwbm11YKU5XNuAjvISHzIucFT+gq4HAVZZMB/nkoM=;
 b=YOwbflfSyqarda0uzxTBKvWZCPyKRlx/eLTbZuiywLx1bC0Bl66fYFuuDyLL3FhKsMk/paXKU+JOAdG1YDqw0t3lZioiJIq/G4L0nWSZr0sUU6jXodZuRu7TTpn1TjA3MwCEMQiE34Sh/Ota8itEhlUpherRRX26StIsJwfXOY8fMZ+LKFp+6dPFHHbhDWJVvgHUZU1aCUitpnKfe0lX64V+WI9Y6jfrnCFconBUcWqe1dQV89BM1DxHTe6OIZnkzrhjNh9KMyPhP1Z6MzU2aTwp6KCw6MMbQBwkFyfV2up/W9RO2g8haps0pwxczckuhxVApt9NCbr5jkiLwI85hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3627.namprd12.prod.outlook.com (2603:10b6:5:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Wed, 10 Feb
 2021 12:11:07 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 12:11:07 +0000
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
 <90b255e6-efd2-b234-7bfc-4285331e56b1@nvidia.com>
 <20210210120106.g7blqje3wq4j5l6j@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f5087476-a979-eede-c7e7-1fc057a0c058@nvidia.com>
Date:   Wed, 10 Feb 2021 14:10:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210210120106.g7blqje3wq4j5l6j@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0100.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::15) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.121] (213.179.129.39) by ZR0P278CA0100.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 12:11:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a300ad0-0ef8-4a13-2ff3-08d8cdbcf20a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3627:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3627D1A45C36BC45035670C8DF8D9@DM6PR12MB3627.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NpZguJ9S85uh75TmFO5xAii3VlMi7nDgxOdnnf7wXato8qdmzUbW7HyJLrzfFCPX+elEte2y7LDprfdj0tIWS+TL0MHd4RpWws+eclpUhkWmj9BeszDP3b5sPLWZp8la+SS/SUGxZ5cGQvierOqUsKCRc4a4mqeMEpLaEJu5j/QxUQZEjVQW/tiwgENEDI4dp3EyCXLGVgkEcaFSyHIyU3lvD+mn6ll7A1EvzoLE7D7IIB45YOPQhB3utNHw8NfqSkWYtvIh5scfoEb4GsmhWO1EePdvt0cWpQz3pW5Ujwsk1iTSSTYNKXDXRgeo/kYQSU0EAq9k2yEvurWf0xVufaSW6J07Fu8D+3JXG2KfiglbXRoz8CBsTuN+juAM+NsggZRef4wSZiqh63NjklfTUGlDBcwgXOOnKb5SeCxk9vbpUM2fGw1mo2Uc9iMi6nMCwqX2566Q7tYCGPWNloZgGEvhncebmZ7dwc0PsKkTFEOK7IDYRSJrF7laaSam9xW6CmqUdcQzm913r3WW8Jfmq8t5sQ7rQiqtj4MzjrazyM5MVrLTqbIJVelxjcuuuiIk7yICT+1P1eoHWlOdhcMEWTeoUB9/9HhIxpHZdqvrFPs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(376002)(346002)(136003)(16526019)(186003)(66556008)(6916009)(4326008)(83380400001)(2906002)(7416002)(31686004)(66476007)(316002)(8936002)(478600001)(66946007)(53546011)(8676002)(31696002)(5660300002)(86362001)(16576012)(956004)(54906003)(2616005)(6666004)(26005)(36756003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RUN0SzA1KzdxV1RzcHZxeWxXaEF0QUxIenYwblo0dllGMjZCK1l1Rkl2RmFa?=
 =?utf-8?B?b29yNnJ0VW93Z09LaWE2Mlc1SXgva0NHYldURS9UN2FKT1pNRWdkeTQ5blBM?=
 =?utf-8?B?SjJrQmRJVDZJVnF6RFlNVkdobGg3UWVqRDRZMWw3ejQ2YlpvV3VJcWlFeXNQ?=
 =?utf-8?B?R3dqck9IRVphRHF5VFFnNjVrZkl4Y2ErTVp3eVhyNnZ0QUZ5cC9wam9PMjYz?=
 =?utf-8?B?WHZzQWtaTkNGQUtDVm5YMmFmSW1Yc3FMdjJ0a2wrOCt2cDRJK2Fwd0krYllL?=
 =?utf-8?B?N2Y3UjZKWlBsMkVIVE12RXYyTlRYL3h4L1dtL2c1dW8zdFlBWlBKeHZxZmNn?=
 =?utf-8?B?b1ZJVjVwdW8wUWRha0hjU05CV3YrL1FCRTZLUUJuL3dOMjN6TE1sOC9jNzFH?=
 =?utf-8?B?aWR6Z0Y0MndNSjlKKzF3L1ZhN3ZqYzl6a0JDNVcvU05HQ3VYMW5tWXFGZHVU?=
 =?utf-8?B?aGhxdEp4QTRVTEJjdG50T3pVbXJDSkhCcHNmQTJkeXE1QUM4NDB4ZTJaakJO?=
 =?utf-8?B?OUdNeUcwZFo0eC9WV2FtY0ZGb0hPMFpGRlYwRkdhM21WcHZVMXZHMnRVWTI2?=
 =?utf-8?B?OWRPUDNWUVJYZllpUGhORnpHc054ZkFOVkY3KzVqS21vNjczMmpIVjJGelZq?=
 =?utf-8?B?V2xlWTZqWlcyZVdORWVmVHBpUlk1Tk9LZGlDZU10U05ESk9VZ3pES1E4QmxW?=
 =?utf-8?B?V0ZQTzhMaCsyTU11SU1vNUpiMmphbDc2SDZFZER3TWtxbFl1Z1ZNNEdTMEdQ?=
 =?utf-8?B?eHF5OElnWnRVbU5NMnNCei9TZ3FIUG82QW5yMFJBR0tJQnZGZ0xSbUF1dWdC?=
 =?utf-8?B?OFhlN0dOeldOYkxHdVhkRzlrdXVQTi9LMzRMZTlpTUlLNk5vczduTm9qaEV5?=
 =?utf-8?B?YzVIS2EzYXVoUVVWWUNNR3N3dG5GYnlqVENyUktYTEREMmZnZGwzbGdnQzJn?=
 =?utf-8?B?VmFMN0duZW9ocEwzc2VaU1VuaUUwY2FwVkJPVmltYmlHOE1nZ2FDZGtvb0h0?=
 =?utf-8?B?ODU2cTJ0UTNFbFhPdjRRMllnWlN5Um9qank2UkkxWHpramEyL0J4NVVIQmpS?=
 =?utf-8?B?eXBXQk5CaUh0WWZFQzJzeFhXZnJPVUhFSGVPZjkrZGtPMnlMRVJWd0gvRHh5?=
 =?utf-8?B?dWUzRExkeEZSd3lBNjhWV0ZpdE9FOXZzcTdqODh2QWRqSU5XQ3gwa0o3NUNw?=
 =?utf-8?B?WWxSbjByMENodG9ocnord3NZTlZQTCtBeWUxcXJ6am1XVndaVm8zSGN3QWMy?=
 =?utf-8?B?RTludFdRYzIrWlJrNXI4dWZSbStRNGpqVHFLN0s4TXI4YnZsTTdWQ3NpK0Y5?=
 =?utf-8?B?S2NwOFB4Wk5pYTBhVmZjcU1UODhlSmJ5WDBDblJmQytmVDZzaHFaY2lCMlg0?=
 =?utf-8?B?a0FPMU9vdTM3WnVLQTlkcE5yTEh0R1ZZMWVKN2NOZ3pzM1ZjR0YxaDhlTllh?=
 =?utf-8?B?VE9nUG40VkhUejZlQlJQU1R3bDFKMFE3bUR1VGZ0Z1J4bTkxQmVNR1dvR2JB?=
 =?utf-8?B?SGZ2UFplem5yRHFDM3lXR2duOXRkVTdHRUYrY293bFdEUkxxNnFuMDRuYnUz?=
 =?utf-8?B?TzdTcUwyeDE3VG1OQm0zMWZCR1BhUHlLTnpwK0lGQlVTTE1Ud0JUcmhCV21X?=
 =?utf-8?B?dW9BSThkY0dlbDIvaHN0M1dGSHdkRExIaEpYZ0oxa1JkNFExTUdLYjduWHVh?=
 =?utf-8?B?VXhsaHlGcm9WY09hSEZPam04Q0pneXNyajd2RFRsNXRsemtYVUNxKzhNWGRN?=
 =?utf-8?Q?/1lr3JLHdVVmVyoMS8zU087QIfVO69osmHEY9Oy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a300ad0-0ef8-4a13-2ff3-08d8cdbcf20a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 12:11:07.4500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COQ/G6NSeIQEwJppdzKg3uIbeNjEK0/08QLJ1qfYMxyvEANLxJNeftDti4eKebgZjKZW+qDuANRqdyW0QRg/Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3627
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612959088; bh=/ZHwbm11YKU5XNuAjvISHzIucFT+gq4HAVZZMB/nkoM=;
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
        b=SK+qBTRiQMUYv8rOmYF6ADAYxEbWF9zH7nfWg/Nte3+W77NebRPKNHtgxzsP0cehc
         2ZKLPr04bZIso26RKwdGMF4s7K0SUE04ycAB3+0K2qoRvhUdVKVtoNmUcEYb04NDnL
         N0oPac4lFQ+ubTaH/wGicIeMa6zTazc6ExsZpcvc7Fmh1Qb0wLpRk+kxXgJEJ2Zcq1
         eE8LFbYlIIxjIBI0DDGTYaG2qNNMsLKG9p0bzWnEvIXfyVA0VNHt53QQs8z4Fqo9Z7
         +e7uVA/Vat4Jrcl+5dBehhQGRKZDwc7PYVWRPfqn20r9b+uW+J1ZQNktjRktc31iPI
         9P+2HqZbDkV7w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02/2021 14:01, Vladimir Oltean wrote:
> On Wed, Feb 10, 2021 at 01:05:57PM +0200, Nikolay Aleksandrov wrote:
>> On 10/02/2021 13:01, Vladimir Oltean wrote:
>>> On Wed, Feb 10, 2021 at 12:52:33PM +0200, Nikolay Aleksandrov wrote:
>>>> On 10/02/2021 12:45, Vladimir Oltean wrote:
>>>>> Hi Nikolay,
>>>>>
>>>>> On Wed, Feb 10, 2021 at 12:31:43PM +0200, Nikolay Aleksandrov wrote:
>>>>>> Hi Vladimir,
>>>>>> Let's take a step back for a moment and discuss the bridge unlock/lock sequences
>>>>>> that come with this set. I'd really like to avoid those as they're a recipe
>>>>>> for future problems. The only good way to achieve that currently is to keep
>>>>>> the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
>>>>>> after the flags have been changed (if they have changed obviously). That would
>>>>>> make the code read much easier since we'll have all our lock/unlock sequences
>>>>>> in the same code blocks and won't play games to get sleepable context.
>>>>>> Please let's think and work in that direction, rather than having:
>>>>>> +	spin_lock_bh(&p->br->lock);
>>>>>> +	if (err) {
>>>>>> +		netdev_err(p->dev, "%s\n", extack._msg);
>>>>>> +		return err;
>>>>>>  	}
>>>>>> +
>>>>>>
>>>>>> which immediately looks like a bug even though after some code checking we can
>>>>>> verify it's ok. WDYT?
>>>>>>
>>>>>> I plan to get rid of most of the br->lock since it's been abused for a very long
>>>>>> time because it's essentially STP lock, but people have started using it for other
>>>>>> things and I plan to fix that when I get more time.
>>>>>
>>>>> This won't make the sysfs codepath any nicer, will it?
>>>>>
>>>>
>>>> Currently we'll have to live with a hack that checks if the flags have changed. I agree
>>>> it won't be pretty, but we won't have to unlock and lock again in the middle of the
>>>> called function and we'll have all our locking in the same place, easier to verify and
>>>> later easier to remove. Once I get rid of most of the br->lock usage we can revisit
>>>> the drop of PRE_FLAGS if it's a problem. The alternative is to change the flags, then
>>>> send the switchdev notification outside of the lock and revert the flags if it doesn't
>>>> go through which doesn't sound much better.
>>>> I'm open to any other suggestions, but definitely would like to avoid playing locking games.
>>>> Even if it means casing out flag setting from all other store_ functions for sysfs.
>>>
>>> By casing out flag settings you mean something like this?
>>>
>>>
>>> #define BRPORT_ATTR(_name, _mode, _show, _store)		\
>>> const struct brport_attribute brport_attr_##_name = { 	        \
>>> 	.attr = {.name = __stringify(_name), 			\
>>> 		 .mode = _mode },				\
>>> 	.show	= _show,					\
>>> 	.store_unlocked	= _store,				\
>>> };
>>>
>>> #define BRPORT_ATTR_FLAG(_name, _mask)				\
>>> static ssize_t show_##_name(struct net_bridge_port *p, char *buf) \
>>> {								\
>>> 	return sprintf(buf, "%d\n", !!(p->flags & _mask));	\
>>> }								\
>>> static int store_##_name(struct net_bridge_port *p, unsigned long v) \
>>> {								\
>>> 	return store_flag(p, v, _mask);				\
>>> }								\
>>> static BRPORT_ATTR(_name, 0644,					\
>>> 		   show_##_name, store_##_name)
>>>
>>> static ssize_t brport_store(struct kobject *kobj,
>>> 			    struct attribute *attr,
>>> 			    const char *buf, size_t count)
>>> {
>>> 	...
>>>
>>> 	} else if (brport_attr->store_unlocked) {
>>> 		val = simple_strtoul(buf, &endp, 0);
>>> 		if (endp == buf)
>>> 			goto out_unlock;
>>> 		ret = brport_attr->store_unlocked(p, val);
>>> 	}
>>>
>>
>> Yes, this can work but will need a bit more changes because of br_port_flags_change().
>> Then the netlink side can be modeled in a similar way.
> 
> What I just don't understand is how others can get away with doing
> sleepable work in atomic context but I can't make the notifier blocking
> by dropping a spinlock which isn't needed there, because it looks ugly :D
> 

That's a bug that's gone unnoticed, surely not an argument to make error-prone changes.
It's not because of ugliness, rather for easier reasoning when people want to work with
that code, easier to maintain and later easier to verify when the lock gets removed.
We'll reduce the chance for new bugs by having code that can be understood easier,
especially for locking it's never a good idea to play games, we must try to avoid it
when we can.



