Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A5C3F0E46
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhHRWiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:38:07 -0400
Received: from mail-bn8nam11on2065.outbound.protection.outlook.com ([40.107.236.65]:34400
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234574AbhHRWiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 18:38:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iz9o8enRLiYygHStgG0jVSDm10H3rz4rS1iasYoSwP9vWxocv5ieZwAbDKnsE/e+H5h1k4+2dcQeDC1vjgXrF5zVRmXv2YdAFWN4fWKDaL6hzccEZfR78WIwyuZe6evNpYHf0HsKrNaYbnmOMdxzS6BrRJuYdBhmAHQQ2DbnSGcIOcLjl+9CNcw+m1kKIVxLmago18HNA2hjoT3Vh9zDHr9yh2t4D9vYaoFeS213UDfjYhxN3KIo9GNn3bQ09brgVWvfv7Bh3f9xYHBh+N+ULikFzHHXD6ILPc/0RlmqJs1O5/Tf4iPqRqdIQyOWbPestXNJjhjtNtqmMjriJ03X4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfBL5ax+GV5PG+F6cilGLY52v/DzsnGglksTXxyKVIc=;
 b=KyT9rfiumDRwbBMlsd+Y/ELISzXVcJK2L6+bSrBdfLdngsAcKC0PuispMmYgO5+QttV+9671nPCyhRgxzZQiLsQnYL+PX8s56uSHpHDl37a3FSmFJF/ioMtgaCL4R2i8h01rZqBpgIVBgKG5cA+IHVLXvnFPRDdLGVwoI4m0a2CNVkuTl8o4fYxSNebLxNp8EILJQlXBs+cjqfdNjLgY0VcPoOqRSjZtt3DjxoPamgkuAf9uqxU3t3iqFoqnYeen4DeQHZBHi05XydBqC4W2EHNUbxLKkJDGUbqzPDPszwTOnvOxIeQdypENy/j1Tf3yRD4WNWmD6QrgSTgShUOYlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfBL5ax+GV5PG+F6cilGLY52v/DzsnGglksTXxyKVIc=;
 b=EfmzhgkM4VMdXxxhZglViwVwEzWYiavqzKi5nTwwUJj1hsAvWnHK9korICLkDRvOF/+KHqZ3WtD/4LGHF9JAb81aECeNTxsjv4OOf/+EbY0vgbPcnmKkvSF6QSA14gbF137TlqkU8QMO7/0f2+1SLHSy31wr/fo1owzck6dReMiEfFg82Us+2UVdwCELD/culcNP4j1xF+9H/LZkeIgbv/DQQdffF0I6JDy1E+hdxkUiv49ldroLoa5e4Vw2dVdaJETab39W9emijBjiu6C6JKZ1CNDj3IRWJjy7eyRMVC716cuCTE4f3W1h/tKX0nppv2pxnkOpkSM9m4+C0dNTwg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5184.namprd12.prod.outlook.com (2603:10b6:5:397::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 22:37:27 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 22:37:27 +0000
Subject: Re: [PATCH net-next] ipmr: ip6mr: Add ability to display non default
 caches and vifs
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20210818200951.7621-1-ssuryaextr@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <912ed426-68c3-6a44-daec-484b45fdebde@nvidia.com>
Date:   Thu, 19 Aug 2021 01:37:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210818200951.7621-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.22] (213.179.129.39) by ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 22:37:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a00de809-829d-4d65-5e6a-08d96298c1da
X-MS-TrafficTypeDiagnostic: DM4PR12MB5184:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5184C078532D4B892CD0397EDFFF9@DM4PR12MB5184.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GIvw+jVgJNaM8INUfvKAmQeJfQLmSwRxbAhDA6H1VqAGVtP77nrw353hIhiPSOtZe58GW6TwfVOaavLFnefQ3uEQG61Xu6SUw5u9uUFpHmrN0ZbVV0qYwrFatUue4f+DerkQgnWbKInTbz/KLydmZOBT2b5Wx9U4ycrEzHof5ugSAOWHVGwwc/X6jNKrF/e6Z7rDCGXGyY5zBcperBII+jFxdy1yXpbEBbxJ2hYfwNlb7vER4wJcS0Lrfu/S7T5F66O3lFFbb4JZn6WcVhNA2tXg2ir0Q3A1EAV6nhda70yJ0pFZ5F+USg6trzdZHDFHD24+2Xct0rOfsYAAY3SZeJSUlYKzYx/dbpVMkFPof3Uw9QjvG1K3TzmHbqNVYmPt2/YULP5j4zGjJHmCoQjGgAV10f4In4RX4QgUJd5FODkRZ3jEtHVPA3ly34uZYkuiFLhRHSsPAnLFutQiIa93M4pajlHFghQluIPS7Qhb2jfJsM6iPKGjj0XyzMKUxvVnNGnYQspA1m8U5LN6iiExjzHQ/Q13Yem35TdEbOCJLNmkL6Dli/cTLzeEUTdlHVej7V3nPzQBqdB3ZPFamfThZK/6ZDvEYZMtJ9KIiLYxCRHHX+0pdp1jkspFK2+VA8++05sT0MvIl+O5EPY+fPiNsIfbtBFlwBlE9FiDAezeo/bFC7todQJJj5IwyuiqWekI+USGk2zC6/HiYK8suLh8tJDYYyp+UOly91Hlny+3yBH/MtunjWIUeD/jZ0RbPRFD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(66476007)(5660300002)(66946007)(16576012)(36756003)(956004)(2906002)(6666004)(6486002)(66556008)(83380400001)(31696002)(316002)(8936002)(186003)(8676002)(86362001)(31686004)(38100700002)(26005)(478600001)(53546011)(2616005)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mk9hcUdOVG16WTVVMjQ4WjhZakdXMzRsa3ozbm05eEFYbU1rZHlVVytaVmhX?=
 =?utf-8?B?akNyMWNJV0ZKclZBcXVoQ0NzYnZ0cUZ2L3hrNFVSOXNtbjVCVjBxTlVnS3Y4?=
 =?utf-8?B?VFpYSTRUMmhuVFU0WGdqSHV3T1R5NDAwanNxQ3NtVDAvNFlmb0QxUTAwNWhK?=
 =?utf-8?B?a1ZrT2ZDUWNrWEdmVlc4VXVEVnNZZUkvc2Y4TW1qRm42c3krWjBRbTJRWUJH?=
 =?utf-8?B?a2JQS2xtQVRhQjhxYm1rVTZCcTBMRFZIWUI3a0dObUNseW5ad1dNaUMrYnlS?=
 =?utf-8?B?cmJyeWhya1B0MXVzK0ZmOHdicTlueSsvbExFMlh4NndhSTBaUjUzeVdFTHp2?=
 =?utf-8?B?TEFuUjJBT005WEZ1eEJiN0J6bEF0aDVxWXNEMHljSUo3cTdHcVE1ckJBSE0r?=
 =?utf-8?B?dDE0MW1tcUpCNXEwRldBQ1FBQ2JhQ0tiRkRXa2RwVFRvN0lDVzZCQzRZelY5?=
 =?utf-8?B?V3E4Y0JBVG5nbjhjaENoelBSci9GUStYY1NwSnJGY1duU3grUXRHSHJoYnN1?=
 =?utf-8?B?clZuZWlMQklTN0dLa2R3c3RncE05RXVOQjJWUWVmMWRNV0w0Y0xaRUg5Njlp?=
 =?utf-8?B?SDl6Y2J5V3lQSWJOWUVIZWRIZ3ZUNmwrMmlWd3kvNm9EV1JPV2R2ckZSWStJ?=
 =?utf-8?B?cE9sVDhpZDlKNkloNUR3VU1uazN1dVhJOUJsaXI5TXpBd000ZkhkYk8rVHhl?=
 =?utf-8?B?aURpTE83cktsK3VWWjZaMVA0MjBUZ3U0b3U2ODhaa3Jsa3l0cnhqZ0NWTWw4?=
 =?utf-8?B?NGMxM2hpVVM2VWFUUDc2d2NFRVBMUUJBekJBdnFXaVpNS2VneDFRVFRsQVFw?=
 =?utf-8?B?czl0OUVpMEQvYnAzeDVLOFBSK3pxaUROUUZER2xjNlcxUFMyYWtlb1FGbCt6?=
 =?utf-8?B?S0dEenlKUGRJYlliVWZqa01LZEgyM1U5N0tUYi90SDA0L3ZuaTBsbERWbHgz?=
 =?utf-8?B?N3ZHK2FPMkpIK1VpbzNyYml0aUlLcnNFK3M4aDY3UXZ0R1VhY2RDZkZPTTZY?=
 =?utf-8?B?dlh3bFBiOTVvQ3QvNUV0dE51TG9VVXVMUnpOYk81WVFuSzF3VVR0TFkxTTY2?=
 =?utf-8?B?QTJSTSt6ZGtJb3oyTmZTbC9SU2JVQ2YvZVpJZHJncFdxWWdCSlRISGJZRXlW?=
 =?utf-8?B?cHUyYVRTZUpKclgxYkUwOVZzK0l0SG9YeVRSUUduYjIvVXNMLzY2eUJWajda?=
 =?utf-8?B?ZUNhQW5jeldXcjhUK2VjaUZOZVdERVVUdTRHTUFIeWVBd0NCd0RjT1JZWUxC?=
 =?utf-8?B?bVRJSnpudWdtK0d2WCtRamZyQnZKdUM1d3hHZm1abnpna3IyQ2hlM1dKODRE?=
 =?utf-8?B?dW1tTHhDZm5DZTg3LzVuc3ROYWhSMTdJbThKL2JRN3BDV3VsNmFyVVRoNjF0?=
 =?utf-8?B?a0YzQnh0MWtjYzFneVV6Z25vN2pRRmZveUxnMGRjU202UnR1U3QraG9Qc1hl?=
 =?utf-8?B?aFJwdncxRHRHbGhrdGhtKzQwTDVZMWRnemM4Nm9CanJRanYrZERFYmpRMFR4?=
 =?utf-8?B?ZlJyQ011clAvYXc4OEk5c3ZlZk5QcitlbHhncEx5RkdyZGZlYzdsclVDSUlL?=
 =?utf-8?B?RjQwNXd1YnFERmNqZDR0YmRTdmhTVDFmMTFHT2IvSDVvRjRiV3huc2RKYUMy?=
 =?utf-8?B?aFdGR0dWNDRyeXhjQW1HcWJ2US8vMFJ2eVBEcVdsYmZ3Tytva0MreUxtSllB?=
 =?utf-8?B?M0t4SThKNkozRmRhcXJOZTNBUGlhUGt6VXJJTjRuT1c3d1FrZkNoYWJFc1FP?=
 =?utf-8?Q?bY4d89PH8cWKLRIz53Ao7mwx5rIOTjQ8uuLl4xH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00de809-829d-4d65-5e6a-08d96298c1da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 22:37:27.8133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0GC082c6qhqib2ptQXP8T7FOcqrBnf+e1WbWVFv74MRwKjNba5EnNL97a8IpEyKxcIkDSysXwVvj3xKkDcMe6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2021 23:09, Stephen Suryaputra wrote:
> With multiple mroute tables it seems that there should be a way to
> display caches and vifs for the non-default table. Add two sysctls to
> control what to display. The default values for the sysctls are
> RT_TABLE_DEFAULT (253) and RT6_TABLE_DFLT (254).
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 14 ++++++++++++++
>  include/net/netns/ipv4.h               |  3 +++
>  include/net/netns/ipv6.h               |  3 +++
>  net/ipv4/af_inet.c                     |  3 +++
>  net/ipv4/ipmr.c                        | 14 ++++++++++++--
>  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
>  net/ipv6/ip6mr.c                       | 14 ++++++++++++--
>  net/ipv6/route.c                       |  3 +++
>  net/ipv6/sysctl_net_ipv6.c             |  9 +++++++++
>  9 files changed, 68 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index d91ab28718d4..de47563514f0 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1382,6 +1382,13 @@ mc_forwarding - BOOLEAN
>  	conf/all/mc_forwarding must also be set to TRUE to enable multicast
>  	routing	for the interface

Sorry, but I don't see any point to this. We don't have it for any of the other
non-default cases, and I don't see a point of having it for ipmr either.
If you'd like to display the non-default tables then you query for them, you
don't change a sysctl to see them in /proc.
It sounds like a workaround for an issue that is not solved properly, and
generally it shouldn't be using /proc. If netlink interfaces are not sufficient
please improve them.

Why do we need a whole new sysctl or net proc entries ?

Cheers,
 Nik
