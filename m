Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A875E3044D9
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389736AbhAZRPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:15:54 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9160 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390836AbhAZJYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 04:24:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600fdfb10000>; Tue, 26 Jan 2021 01:24:01 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 09:24:01 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 09:23:48 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 09:23:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXRkYqSHUAJuzqpVc8R8BcUJDxNTVX8XZE05eFM8lzZUZAKM+70D97e7ClHb+6QQRVgAtN00RlWyMYtATVicGNcJwyMwWYtsTxtSW/sHtHJy2X6qyw63nazb8t5F9Tv9zyVFgPikgs2nU+4vAdZy6XlVoJAZRWasSurwspIquceP4nQkJ8Oi8z/sHFOD2Sn5kNOi0pUZwlDQqpgFBXC7SOXJN5JRN3PU66WHkfp8QJH+w9WcT0sho88pBDSGi0AWQN4R+Ig1gW0aLFalEi8sNGZOoaN/Osass0iCq0mm6GcMd+ZRGqdSRJzQakqvoUYQ/RP4gZKkEJbpkE5O/Lyitg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jUBdUOkbwd/WN8tHGLMNUyg6S3FbagX4rD7ZwwdgPE=;
 b=hIWyS6RFuZPkN9x2t1Csxd74cgE4VdFuVj9qU2k9CDYnXQED5GTJvh9+3QrOVecOOleEPn+9btq1ds9RqAoyh/scOtGEdyoX16Hj87igCzTord5wL9SRsanWy85fRwq9T4iOkVKMh5dINzjqUN3gKxGH31TE1inzpuwBJhk6m4ItzupCiPE+Qqvsz8ezQaRp625+hzATyqfHTPmm5WIr6SeD1PLRN1Rqlm4CT/YhvHUvhlMaB1ol20ShcDnt1qxRq4V3ymCD1EwWaRVLjESSlEmOReMAJHJLrYsN9dNhcjn7PCcCj6vGKxNc4GyZ7HZFM8K7zBVJqgN7kSGwrsUuiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4107.namprd12.prod.outlook.com (2603:10b6:5:218::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Tue, 26 Jan
 2021 09:23:46 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704%4]) with mapi id 15.20.3805.016; Tue, 26 Jan 2021
 09:23:46 +0000
Subject: Re: [PATCH net-next 0/2] net: bridge: multicast: per-port EHT hosts
 limit
To:     Nikolay Aleksandrov <razor@blackwall.org>, <netdev@vger.kernel.org>
CC:     <roopa@nvidia.com>, <bridge@lists.linux-foundation.org>,
        <kuba@kernel.org>, <davem@davemloft.net>
References: <20210126092132.407355-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f0f19c6c-f5bf-0d07-fb49-60167e281bd1@nvidia.com>
Date:   Tue, 26 Jan 2021 11:23:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210126092132.407355-1-razor@blackwall.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0081.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::14) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.166] (213.179.129.39) by ZR0P278CA0081.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Tue, 26 Jan 2021 09:23:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 338cdf6b-68b7-47d7-ad95-08d8c1dc14eb
X-MS-TrafficTypeDiagnostic: DM6PR12MB4107:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB41078FFE77B194FACB951813DFBC9@DM6PR12MB4107.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0bIJxILVWAf6SUD7dWeKNzfd3zsQ/12jjkIdl8sjRBgYuYyqmkqzo7k2s2CFnqZjtYgqgk+HvuWqfaEKG0imDG/y/iVrnM53VfRznisYX7Ym990NviaqAcphflm5TcWa70rOyYo4jG9DTikjoePBJ3SJDlCf5/3cFEol8OMa+eRUOetnMxR4JpKh702Dt+TgWITbP1I6hh6HET+TQpdHCST7LqxfPRk8OdPQrvNAYpTx0KdUlifwcBPJ7mVu4GmO13kxT9q+6Xyf4RnsSH9P+BjqRDdP6RWq2UBv9tNwUU+KZcQXPlMVim7VV5tdKaF9uMIVW1XJBjIEhoVKOraHO5uX9azc4Kdq/Owjs2e4lZH6i4Amq4qHyh5yS5HczWkIHeOIUxIzF3BYdE3+d1t/qDx5YBNp2lJXqIpX87ZlxkPZ3b08sY2cPl5/cUGTon0PL5TjoAzIYzN8H6knohkYBriQ/1P2My5f1CVXxYjA13Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(31686004)(6666004)(2906002)(8936002)(6486002)(83380400001)(36756003)(26005)(86362001)(66556008)(66476007)(66946007)(8676002)(31696002)(2616005)(478600001)(16576012)(5660300002)(316002)(53546011)(186003)(4326008)(956004)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SGZPWEl6cEk5RmZJckJLUXphTGdpdE51VnQ3OVFicE5hNEF0a2JYdXA0anZC?=
 =?utf-8?B?cytuNXJ2dHAzZHJWQ1ZZSjVOQUxpaGRYMmx0NGRmUE1ldjF5RHh6K1czUE1Y?=
 =?utf-8?B?WTlvNGdVNEpld0NQNG1KdDlSUmdpbnJ1dmdVd3JHWjh3OEEzZ0xyY1NqSy9S?=
 =?utf-8?B?NUJTZlIxVy83a3ltWUtwYng5ZSt3TU41eSs2R1NyTTJ3MFdJdmdYeEZHWkxJ?=
 =?utf-8?B?dmhoY2NJUXQxRWpNRzhnZWo2aDFWRHNpcWl6NEcyeWZkbFN0MEdTQzZ0L0py?=
 =?utf-8?B?NEkyenhXdm9qRkNmTXE3Q1VuUG0yQ2hUZEVQN3FpMHpvbGJ1bXF6cTByNjhY?=
 =?utf-8?B?SHl4R1hncmRBQ0tkRTg2aWgybGdrS2pLMTZEcXhkK1lEVG1jajVhRTVWWWdh?=
 =?utf-8?B?eGFTVUJEWmZYUjYweHlIWmsraVZaeC83SlRaM1IrTm9FVDROeVZVSUtnTzYw?=
 =?utf-8?B?UFJabG5mSFc3N3RabXE3a3ZrcnNlNnUvaVZFSC9EQXVJQk1aK2FEYzNIZTJ6?=
 =?utf-8?B?cEswVlRBTks1MGJONG5HejJ6TnNkdkt5MVUvU2xDZ0tXTTAxczV6SGxNSTYr?=
 =?utf-8?B?b3lBbnNTM3ZVR0FENWVmRkxmYVRVaFMxTzBiMDNqZ3RKOW5MdjAzaWFScnYy?=
 =?utf-8?B?WjZPb2V6OHVzcW1KU2RMaGQ1cGxFMWJpR0xNdm15Q1RvOUpsUGU2SVVNU1lP?=
 =?utf-8?B?YndJWUxFcTE4Y3J2dUdHN0JXa2FRVlZzU1ZLT01nb3lWcStkcVNKcGVML2dy?=
 =?utf-8?B?VmNydDBWY3dYcHZmVDh5T2ZQSnFaSXhPT2pUVzV4eFEwVkRBZ240b1QrMDJi?=
 =?utf-8?B?THg1SmY4amQrN3hmdmFKK1BzaEgyK1BzZzFibVRDcElnTjZuZ25rbmoyK2hR?=
 =?utf-8?B?RzZKQXVXUlpOTVFIbDhDTkJHeVY0VGYvQWZjUXBtUzd4V2x0djgzaFE2N2V6?=
 =?utf-8?B?OHF1TkNEaE9Na2lzVmplQnd0K1NkdjBFUW9lRUVBdWJoalA3bHpVYkl4MFUy?=
 =?utf-8?B?cWNEdVhqMFZ1cFRjU25MOXN3elhHcHJyUWZ2UWUxU1dvZVJDdEw0bnYzNWh4?=
 =?utf-8?B?SVQrZ05IdUFHVkQ0NkFIZlpOa2dGaHFnbGtSZkFaVWlOUnpJQTV3WDBNVjAz?=
 =?utf-8?B?bFUrQnQ2MldWNkNmczJqVUhPaXowSmFHdStuYXZxQkNES3c0Q2E4UUE5Q2pF?=
 =?utf-8?B?ZXFpTXlOMFRxTElmakJtS3g2MTlNNmhDdWt1c3hlajlsZGdPWXVSWnVvRk4v?=
 =?utf-8?B?U3l2MWZaVklnNy9DejJHM1IwYmJFSGxnQWN6bVRMREZaNnAvSFFmQVhNOEhn?=
 =?utf-8?B?Sk1HTkFPVldZZjJzNlB0cEdUUzh3djJ4bW1EOER1UVpRMmhaQnhPRHozRUJS?=
 =?utf-8?B?UTdiTnBjVFVQcU03SnBvK3BFQlRqanlsK0ZuYkFjQ2d0b09DUzVPcVloUVJ3?=
 =?utf-8?Q?lp6W41br?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 338cdf6b-68b7-47d7-ad95-08d8c1dc14eb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 09:23:46.1647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SasAK3cyvrFBIqki8FIKtQC87EOV+iN81catX4n69XPRTC0lkTYiC/21vJGD3heuI1J3fxYIiL8DXCzsQC8fcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4107
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611653041; bh=/jUBdUOkbwd/WN8tHGLMNUyg6S3FbagX4rD7ZwwdgPE=;
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
        b=sPijnaqxpDxn3megZiIySBj7LO/ZD3a6EfaBcbhwBe6hJbtjVYzNNd72v8HqeRbcX
         IP6XozumK5dHXLUuu5pFvr0pTyLzCXL8PIwvtJYjKti/Ujm5asLH42sudQkRxCTKc5
         w1x/G+6TmEOvlBVZP3oY1YHCTpXqvjhQxbLXqyS5rFFR5Rt0Ef2iLsXeHmkeIa7Z65
         AqiYUBGbTRsHBfoyTYYwX6FbUttpi9WqqZGAQc/YlAPQA51X6f4rvTEOGMxOBJe68M
         Vjnvr9jntjFM2UTVtBKZWMXwJyZhmpGAQp2NcvqsWzpDYbI7sIFJnpdPs/4Elb6HCW
         dynQVguU1U9fA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2021 11:21, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set adds a simple configurable per-port EHT tracked hosts limit.
> Patch 01 adds a default limit of 512 tracked hosts per-port, since the EHT
> changes are still only in net-next that shouldn't be a problem. Then
> patch 02 adds the ability to configure and retrieve the hosts limit
> and to retrieve the current number of tracked hosts per port.
> 
> Thanks,
>  Nik
> 
> Nikolay Aleksandrov (2):
>   net: bridge: multicast: add per-port EHT hosts limit
>   net: bridge: multicast: make tracked EHT hosts limit configurable
> 
>  include/uapi/linux/if_link.h      |  2 ++
>  net/bridge/br_multicast.c         | 16 ++++++++++++++++
>  net/bridge/br_multicast_eht.c     |  7 +++++++
>  net/bridge/br_netlink.c           | 19 ++++++++++++++++++-
>  net/bridge/br_private.h           |  2 ++
>  net/bridge/br_private_mcast_eht.h | 28 ++++++++++++++++++++++++++++
>  net/bridge/br_sysfs_if.c          | 26 ++++++++++++++++++++++++++
>  net/core/rtnetlink.c              |  2 +-
>  8 files changed, 100 insertions(+), 2 deletions(-)
> 

Self-NAK
Aaargh.. sent older version, sorry about the noise. I'll send the proper one as
v2 in a bit.


