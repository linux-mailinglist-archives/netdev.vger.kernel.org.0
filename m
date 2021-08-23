Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D0E3F470D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 11:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbhHWJBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 05:01:17 -0400
Received: from mail-bn8nam11on2046.outbound.protection.outlook.com ([40.107.236.46]:5856
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229944AbhHWJBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 05:01:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYslofUL7ypRZr0WEMPyqRZJ5b+c+c/8FUuiw6D6NMsCq5gK/TT5X+hHohGplT52u40t8TjAZ/FARWXAvKK5+VrxRrQss6CAD/PVOWyNjB28tjP8XVqiyZo/K9xsOeaQxIDrAHCfgiwe2JcTOEagzH83/ZEgqee30zeq5/wHrkcqnPMsLAAUUfL0e7hjG0FbBaRs3VWiC6V229lM9BWmnv960d/8cmmSW4bA9vK5Qtu4+yd89IXiW8E+ArdsfWYWbsIwa8AfMCCFGFcFIqnPmGuYTRsY2oRBvtwYhNlkl5TlEdbaNJC3nGCJWMPimS7Aq38pUZQpeZ6AxiP/tAU5fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhkY4sxH7BnSdsblCHD6C4HSfFyBBXfDAZzZU5UipAI=;
 b=GYuYmI/z9CAZyxgvsvCRDzBd2s+Rxle+8j8px0D5UnWOM9s1J3tjSyp4lLiV1Y7+8eOSfPmNN+8sghQ06T8X5xcAOgjnxpxkrfO8geWiSahnhh+CwmLUIwCeaBXNF0b3EYGKrwqwe2bveJfsJ9Wl5HjoU1Ozq+sR5seTfgGn9FfVB6wpkFXcwb/eyD2wrhK42vQ7bKubmZXNz+ViwxWe8pAyxJrBlKCxYNKBjPaCnlchrHybF2qfL2qd6T/1HQfabdYOL1DhjTtXgJeGDEXG/ZHOJ6aa6qcry9cxtk7joqO6CSFNM9ruZKY6e8V4qmdjz/B3Hp582Y7oG97nCkTCTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhkY4sxH7BnSdsblCHD6C4HSfFyBBXfDAZzZU5UipAI=;
 b=bGVS3uxCcZIY5z8IlVscb7wYaQz/qmJWHY3gLk1jRspr5XFj+HNsZhprMBeQbFlzUpp+Qqevq8O0HLfMT6wVRTU6NSnivYFLaFZnFeVlVPxlghfdFNsNQQVxh2UXjh8FuH5lgyhzSJg3vhShQP3mTZJ9kAbK4IJrMw6bMHSZp0d/Nq4hWCLwoUt7qraODDTGw/gLYtM+qnyuwQnvWCuMQ87BBmU5pFUyca8BRq+9uFWfcPNyv6TUw6MUIRdktt3weebbbCylj0AXuuPx0A0NMHk0AzUau6eYS7Wy+1mhp7tnsOMF1+gNzjPZ54IZbEm1PosXXDNfWQnm0osEz9J22w==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5479.namprd12.prod.outlook.com (2603:10b6:8:38::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 09:00:32 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 09:00:32 +0000
Subject: Re: [PATCH net-next] net: bridge: replace __vlan_hwaccel_put_tag with
 skb_vlan_push
To:     Kangmin Park <l4stpr0gr4m@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210823061938.28240-1-l4stpr0gr4m@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <13c1df91-be22-f4e0-cd61-7c99eb4e45f4@nvidia.com>
Date:   Mon, 23 Aug 2021 12:00:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210823061938.28240-1-l4stpr0gr4m@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::19) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.23] (213.179.129.39) by ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 09:00:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 640526ac-40fc-4b0c-f6c1-08d966147687
X-MS-TrafficTypeDiagnostic: DM8PR12MB5479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB54798EEB4BAABB15C3607CC0DFC49@DM8PR12MB5479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0mTy4eI5/DFzmzgxaFIm4/6Cs6rgwLd/wvkRwWDN/vPa6p3fmqmfDadNaoLKGP9xwsomYN8tNAl/3jHsPYJSE+RqMv3MCDMMcnpVGSrTuJQJbBBDJ7kAovAogNulSATy6+/Dk0+b0hTbYc9e4UehsjuwN1YNhM3htgrVCh8Op3WQXrGSuknrEPUjIQ3dyj3kIJVZaTHH1OyvRVCJpC0BDBll5XI33gPegNPOdOK46KJ4N/E1f7tOIHdgXCLbCKbDnpDw8lgxYth3CbdU8FVTdCJXHkeGc9mLK5YDbwT+6FRK013kmW37I5O0j9a9WEfa7nJnG5Tni/Ewan97wE/aLMGlt+EbQ/KafKa1+aEteIVILHpSY40AJ3KeqmwlvhQMglbCEYWveFQ3u9YsRe+MAzcvWL7nkZG1kyFvKxtoZfVqeO7LAeGRlaGZVkHcRo77P+Hcg6oFGKhsNXzZHYdHz98B+t2WnAXirUWadM8Vv4wrAatapoCcYAGUja7X4gASUWXGwWpAPevK4FUeDYxqh/K+rWR+lbylrx31UDplb5UsOEJiVJcP4n/i9GREMCJa2/62qFALY2n2jra9b1MZqcqAazdDAccFjmlIm1BM1Y4gHut9TFVm/4lWzn8T9LadH+XTZLrIYbSqLQk/rLurGZgKw8Ae4FDABY9J5o9rjyfF4i7LaMCFCVm7QcAQJtEJc+dneGpZWj6MRBgV1anPt2kqT7eE5GyjhbUcp88/UCY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(2616005)(83380400001)(110136005)(478600001)(36756003)(6666004)(31696002)(2906002)(956004)(186003)(4326008)(38100700002)(8676002)(31686004)(6636002)(66556008)(86362001)(26005)(53546011)(6486002)(66476007)(66946007)(5660300002)(16576012)(8936002)(54906003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVJpMW92akdlMkJEZ016bUpMSFpJOUt2NVdMTGUvbEh1TSs2YTJobkFpT3J3?=
 =?utf-8?B?VThzMDVYdXVVaG96NFBRSGxEV3JrNWZXZEJndlJHYWM0djIyUEwyTTNud2c3?=
 =?utf-8?B?SlpFMlpsVkc2NitiSWpOaHMxUU1Kamg0UUF0dmQ5T3Z5NDQzNmJhcTZwcVor?=
 =?utf-8?B?dnNBSVlnZmYva1pUenp0OGJlWmU4N3Q5aXZEaGUrTGJwb0RwMTVtYTdCdnB2?=
 =?utf-8?B?T28ybmN4cmt2LzdaMGJJNHZtbjVESmVaZk80TmlGaG9VMUpNTUpQakl1NFJZ?=
 =?utf-8?B?aHJRZTVzZEJZcHUxblVCS3JhK3VLKytiVlBxRXNpZ1FONmFRZUJraDlLRVNk?=
 =?utf-8?B?eDhUVjZGRkhPWFR6KzlNeVJPdlQrRlYvdDBSeVR6TkNVUk15R0hEMlNwbnRa?=
 =?utf-8?B?RE5maTBUV1lGRmxaQ1pSN1gwVHFJUm9iL0t0MHdpY1crTTVOUTFnWHZDeWk0?=
 =?utf-8?B?NFVRTXV6ZStLZE1ZdGZoUUZhMmVxTGpCMmtGa2lGQmRpS0hsS1FRTkxwNU5B?=
 =?utf-8?B?clZKczhOZUtPQzhwNEkramN2SVhpS2dSelJGb1N4SDl6dkNuM09UcHpTaFNI?=
 =?utf-8?B?UVJhdC84YUUzOWhwbUEzalZCT0JUR0g2Z2l0TmZnRGQvV0txRDlSamRidkdk?=
 =?utf-8?B?RUFBRGlSZ0UybFdVR05vRnFWeFBleFRvNnhXMW9FY05Zd1dkOUtpRnN2K0J1?=
 =?utf-8?B?N01sdXQ2RWprU1BSTjlJSmIzalExSFZ3Rmo1MDhOV2pyOWZuVW81aWIwdU8r?=
 =?utf-8?B?US9sZm1jVjg3RFdROXhhcVZJUERrY0R1VDVXTGVsNk5FeDJXVmc3d2N5RDJn?=
 =?utf-8?B?aDVkM1NwSjQ2RjRKaTVrYVhtZjNoc3d0bHFLaHprenlqQmQvUUpTQ3ZvR3FP?=
 =?utf-8?B?MGhPLzlTVWpaRHFnSXJ2ZG9XK0I1dGJqWHpQc3JYTW53dXBSUEFONXpoZFpV?=
 =?utf-8?B?YUJCV0NVclZJcVgxcTNVdURiK2F5MWtWSTh6TWIycmR0a2w0anJpbEhqRmlX?=
 =?utf-8?B?THNLVDVHMTYva0dvT3FVcHZ1VlExUmNpT04yaHV1RUJhdjRGM29FdUZiRWU0?=
 =?utf-8?B?dTY3Q2RtR0ExQmRyeDZCSEpuOXI5R1U4RGF4dFJYUXpvOWRBVC9QaWFLRUxW?=
 =?utf-8?B?WkFWTGdOTkF1U0djVjArR2Fhc0Y1MW5UUnBBbEpVZ29mMDBiNWErVkRDOWYz?=
 =?utf-8?B?Zk5oeS9uRkE3Unp1ZlNYWXZ5UVZacU9aMjhLTGY3MWQxOENTam5oRWV5WEFi?=
 =?utf-8?B?M1lHcmhmd0wyN01jcE9sSFdvSHc2YXNsYm5LT3BrWTVQVytzVXlwYkxwOGRu?=
 =?utf-8?B?azVmOU56Q0gvYkNjTG8wWUJFUmMyWE41OExvbzM2cERERno0ejdPL29SeVRN?=
 =?utf-8?B?Y3c4T2lJZGFEYWtsV0lOWmkyNlJJWGowa3h5MVh0aXY3ZG1PSlkvYlVqRVEw?=
 =?utf-8?B?UENRdnBRU256QUNUeHVnaXZPUVJya2dUNmhqWnMzYXpJTC9UN3ZRTGRwRW1y?=
 =?utf-8?B?Y1M4WlRFVXVPTXpqSTN1c21wU3VCUHhlRHA3VWxSTExITEh1RlFKQnlYSlBT?=
 =?utf-8?B?MDQzVFhTaGR2YlF4YVl3dWNUeitUSUlFbTZrMXZ0TUtZOXA2dXA0MW03UTRB?=
 =?utf-8?B?TWx6SXUvcnFuNlU5bWkyb0ljSXRhREJzYThaVG9yU25zYzJpaUxqbWFvNFd1?=
 =?utf-8?B?Q2tzclhidDZiVnBRVVphQ2hqNUVhWTV3cVdXSXl1ZHMyazcxam80Vm4wUlBL?=
 =?utf-8?Q?0YfOlhjBlhUNfJdntJ3wtLsUuBzMvEYtStZr66n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640526ac-40fc-4b0c-f6c1-08d966147687
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 09:00:32.4911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f+vnx8Kz8vI+vsJamp5uF+alpeFVUqncAvzxXnhEQz+relmVV77ef/xs+q259ogVk5+uJzYW+cT4ZsKCGpUN/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5479
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/08/2021 09:19, Kangmin Park wrote:
> br_handle_ingress_vlan_tunnel() is called in br_handle_frame() and
> goto drop when br_handle_ingress_vlan_tunnel() return non-zero.
> 
> But, br_handle_ingress_vlan_tunnel() always return 0. So, the goto
> routine is currently meaningless.
> 
> However, paired function br_handle_egress_vlan_tunnel() call
> skb_vlan_pop(). So, change br_handle_ingress_vlan_tunnel() to call
> skb_vlan_push() instead of __vlan_hwaccel_put_tag(). And return
> the return value of skb_vlan_push().
> 
> Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> ---
>  net/bridge/br_vlan_tunnel.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
> index 01017448ebde..7b5a33dc9d4d 100644
> --- a/net/bridge/br_vlan_tunnel.c
> +++ b/net/bridge/br_vlan_tunnel.c
> @@ -179,9 +179,7 @@ int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
>  
>  	skb_dst_drop(skb);
>  
> -	__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, vlan->vid);
> -
> -	return 0;
> +	return skb_vlan_push(skb, p->br->vlan_proto, vlan->vid);
>  }
>  
>  int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
> 

This changes behaviour though, I don't like changing code just for the sake of it.
Perhaps the author had a reason to use hwaccel_put_tag instead. Before we would
just put hwaccel tag, now if there already is hwaccel tag we'll push it inside
the skb and then push the new tag in hwaccel. In fact I think you can even trigger
the warning inside skb_vlan_push, so:

Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


