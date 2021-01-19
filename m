Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA22F2FC576
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394911AbhASNs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:58 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10911 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390495AbhASK31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:29:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6006b44e0000>; Tue, 19 Jan 2021 02:28:30 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Jan
 2021 10:28:29 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Jan
 2021 10:28:27 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 19 Jan 2021 10:28:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRXGo8fOSd2blXOyO+m2A3vkVfwV41ywLpO2UQOe5oT7TGkIsFBstvyT+3+Qcgmo+iredk1mX8CIJnd3ry9nCbP/erRqKAWx8mMA0CKQpeO8C7TSJskxvdx23gmgk05f3lZB1gUP6q+HStc98Ej2RTJplHBxueQxrnN2anNYMgqms9MWgjz6x/KtPUEPfQf0I3rMuGTEJV78f+cZ0DGTXuVX5P/xrqtRwK+pc7NyOKXPxzj+MaYtoWIyPzZl6pXU3cZXXqbJwLG8wVQvvt6FdCmppktsZVP+6ObvneqxjBbx/0owDdy+zwYyb/NI9CbXxhSd9++Ecyo70EvkX6wBLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZklx65/u2TnVcxOj6Od/p2Z69mEsSA++kfZWT56GFA=;
 b=DdJ5NuylVtNJcgFdS93p2UIEmPJ3FdzJaRJHEKuSBebJ4BPh5i0uwhbluvoNW9wCkLnC7hRWjH388a5FAY4xK6N4qpT1ZvbVdNjrx+x7b1/B2hevCsUWpuaK8ZTtNy5h+RS0XBv1h3ctkO6Qtjt3RgEsHUhPDwXLcU2cAJh4nABsQnzmvqEf5vEmXlcgmnj9wY15fon1czPiWP1POw9y+XKB2qHLjF5FKoxzHmszGLGkpwSQ0N6PhpNI2eSSuWeRSWZ1/IvkXYn9J17FDpVUF9B7gaETD/8r19I4xJF37D7oQL4SQyIeh7EWKDOoh6uyXahRVRJvFhPJNWGeY3FMlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB4663.namprd12.prod.outlook.com (2603:10b6:4:a9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 19 Jan
 2021 10:28:25 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 10:28:25 +0000
Subject: Re: [PATCH v1] ipv4: add iPv4_is_multicast() check in
 ip_mc_leave_group().
To:     Jakub Kicinski <kuba@kernel.org>, <wangyingjie55@126.com>
CC:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1610890456-42846-1-git-send-email-wangyingjie55@126.com>
 <20210118203954.15553706@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <699ff28c-9d55-bca6-6dc5-8bda109cb4aa@nvidia.com>
Date:   Tue, 19 Jan 2021 12:28:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210118203954.15553706@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0042.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:29::11) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by GV0P278CA0042.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:29::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 19 Jan 2021 10:28:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e8fce88-cfcc-46f2-7c05-08d8bc64f42c
X-MS-TrafficTypeDiagnostic: DM5PR12MB4663:
X-Microsoft-Antispam-PRVS: <DM5PR12MB4663DFD952C7CDCB610762F4DFA30@DM5PR12MB4663.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5gLVOHcIguO1MYZcj/QLe9tE/ibfKm7enxNizvoBcjSe7d5ZApBef8fy/GsciuOFoxvbFu6YXMDv5QfmGWHEUJvyXPofp9yz3hM2g6pBvHBo9lECJfUkhv/p1MU8348LO9Rj4Nh7Ij0lSnChfXIH8vX/oFHxRcdrna5KT3iW5V3vyzfS8QI0BcxZH0f91qqMU/yhuL0GMA7clHDFoioRC/ogt3fbEIprKIY51g7hF228sE5QDTZVzJKZE/HIBXeyh7mPSubnMPHXEwE4miZdyoQKirERHU/mIXNPu0BwMNe0Hc1CKcn27hFAFn0b2Vsrbb+fMbSNypvBqEYslopvKbJWz0zkVXh1H3rhX3phoKMeRy6xEHsugr2jVHFvR7g6mCDL/3qbAm+OE1Tw9xAwSxEKLIyAAFdCrW43Lw2p/+TDH5LIy59zpRhJ2XOIUw7GIWAEzT3SZZ5rwI/c+fpp3Vw6DHmQPTWGVR9j46FEetHssAAt/2feXviksmhab/r9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(66946007)(66556008)(66476007)(36756003)(956004)(53546011)(2616005)(26005)(186003)(16526019)(31696002)(6666004)(8676002)(478600001)(6486002)(86362001)(31686004)(316002)(16576012)(8936002)(4326008)(5660300002)(2906002)(525324002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TkZEWnV4Qkw2QWRYMVF2c3FRcDZrK3F0bWVZTnk2VEh1aEZPanlwY09uSG9x?=
 =?utf-8?B?N1gvTFdHUlpGeCsvTTc5a1JHWkhQTUo0WFBrZ0tDbEk5ajl2bkd3Y1VFa282?=
 =?utf-8?B?cnZ6ZVZ0SnBlSDFBZ2oyTFhzTFlnVFdPanl0ajFGWHhMRFZGdU9iU1VJWE01?=
 =?utf-8?B?ZFVXOXQ5aG1qZHYvUER1R1c4Zk42ZUlJd1Bwelc2L1Q4c0svVmRKRHcrN2dW?=
 =?utf-8?B?NFdqSklxQ0JsWWVxalpzMFFNUFJhVURZWUF0VDNvZ0JNaWF4bDhLVjVRM1dH?=
 =?utf-8?B?K3BVSDBTQXlXRkV4eTBVN1ZpRmZ4cWhUaGRZMGQ3emxxcktUMFZQYllTTWEw?=
 =?utf-8?B?VTgxNFhLMmlJcVUvQ3A5d0k1WGlyaDIwRFBYYy9JMWVqaGJmNTVqK1JSRGlO?=
 =?utf-8?B?QnN4bHl6OWxuT01teG5aaFBrZElrSkd0eHpNYk9VdEFsRkJsczZRZGdNVDQ3?=
 =?utf-8?B?bmVkZG1zWDNxeklMY2Y5R2Z6dVRrSklwT3RWeDUxVkRvZ0l5Qy9WWWw3c29Y?=
 =?utf-8?B?VDM2amVvUlJtK0RHaERZRmZwbnl6b2NGQzNhSkE5RHVkaFloSVNxMmxQYUth?=
 =?utf-8?B?cU93Q0h5TEJXS1UrUGJ3MlBsQUVJb3VFNHR1QStsSys2c0c5ellERmZhQTMx?=
 =?utf-8?B?N2R4YlRvWFBINVRHcU5wK1QyNjJPeHhOcVZKUnNaRzBEMjFheURsbGx3K2FR?=
 =?utf-8?B?bjZ1eUhhTmJGYy9lR0Jta3BUd2h0czA2SHpKbTVwd0xvQjQyL2xPQkRWSzZr?=
 =?utf-8?B?V2dOemFPWm1nVmFNYW1rVEpkSVkxV3ZocUZkajhTdEFFT2djUFd1OHRDYWs5?=
 =?utf-8?B?VTZoaUhzNEJibUdLeVo1NmlVZnRWNGpZbWsrVmxnL3VrRFJVQUxVNHFxNEds?=
 =?utf-8?B?VjlFTXJpUHo1ai8rRzRab053N2JQMGF0MnBuQmtjZllJZGRnTmJzL3dyN3lX?=
 =?utf-8?B?b09odnBKUXp6QXMzZmg5R3J2dEpOY3RmVnV2aWRGVGI5NE9pd01CNDEvaTE0?=
 =?utf-8?B?SFlzdkVENjhURHltcUpHQmpzeVVTcGZNUWZ6NDhGOGFxWks4cVFmWFk0TytJ?=
 =?utf-8?B?eHI1dmdId2c5TDg3MUtTMC8zYTN3QURJUXV6WXpORU1USFVTMFpWajBSV3NY?=
 =?utf-8?B?bHpBN0pjdHU1QUVZRHpuUGlwRi9KQ0tSS1RtRGNMaExRdEw2VHpzOWE1Vk9r?=
 =?utf-8?B?UWYvN2ExQTUwdnZlZW5iam5iVTJIanpLWEgvUVdTcVVpR1FIVVpLcFM1NnlG?=
 =?utf-8?B?VU1aV0Y3YS9tZ2RRcjJSSWtxLzQvL21QNjRRWXdCaWZ0dWplNHdYS1dmTDNI?=
 =?utf-8?B?cUFid0ErSUhjRmw5aU1wL3lJZFdUK3RvYlh2TndMMXpzSUw2S05mV044SFZU?=
 =?utf-8?B?T3B4dUlLUm0waUxyWjh4MTRMaHpXajNuc2FkYm1waGRJeXVOMFJ0d0J3VUxR?=
 =?utf-8?Q?wGBp0J9B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8fce88-cfcc-46f2-7c05-08d8bc64f42c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 10:28:25.4522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scUqYnJeZf9o647IemneKId/elU3RB2DRsKRxD7ksE0fWpXIQI89ZT3CjrZ6lKmOPnDzMNusNqFkkC61zwMPDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4663
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611052110; bh=OZklx65/u2TnVcxOj6Od/p2Z69mEsSA++kfZWT56GFA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=byl1mj0pvktbFHjDgnXJ+xZ4XAh8ond0F0SfoTBUGJc12DibdSMUQOwEeV7JTEQYP
         7U/iwjVXPK7ofcXbrzTUJHDZEcAnzV5I0qXK0hcYTc4cyYf427s8ypMmHWZOmT3OP2
         9KQTxgniP4WvwBAzHybEQkGfNUz0ez83e6efGXyeZMalv+0Gm9FqfvPVgufU0tOXaZ
         Huy1BtX4FLMcy1lYtJ1rsRfDSCDoYScK923R7K/fFSMOleid1MWeA3PLc/DxmdJjst
         iaObT2v2oqD/Miw0cggjH2WKoieaKw6kqAdxD8adJ4SKgymfXAhV+odDetrcHsND4x
         LQCqzJntRpfzg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2021 06:39, Jakub Kicinski wrote:
> On Sun, 17 Jan 2021 05:34:16 -0800 wangyingjie55@126.com wrote:
>> From: Yingjie Wang <wangyingjie55@126.com>
>>
>> There is no iPv4_is_multicast() check added to ip_mc_leave_group()
>> to check if imr->imr_multiaddr.s_addr is a multicast address.
>> If not a multicast address, it may result in an error.
> 
> Could you please say more? From looking at the code it seems like
> no address should match if group is non-mcast, and -EADDRNOTAVAIL 
> will be returned.
> 
> Adding Nik to CC.
> 

Thanks, and absolutely right. I don't see any point in changing the code, also
you are definitely not fixing any bug. 

>> In some cases, the callers of ip_mc_leave_group() don't check
>> whether it is multicast address or not before calling
>> such as do_ip_setsockopt(). So I suggest adding the ipv4_is_multicast()
>> check to the ip_mc_leave_group() to prevent this from happening.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
>> ---
>>  net/ipv4/igmp.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
>> index 7b272bbed2b4..1b6f91271cfd 100644
>> --- a/net/ipv4/igmp.c
>> +++ b/net/ipv4/igmp.c
>> @@ -2248,6 +2248,9 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
>>  	u32 ifindex;
>>  	int ret = -EADDRNOTAVAIL;
>>  
>> +	if (!ipv4_is_multicast(group))
>> +		return -EINVAL;
>> +
>>  	ASSERT_RTNL();
>>  
>>  	in_dev = ip_mc_find_dev(net, imr);
> 

