Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0DA6CB728
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 08:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjC1G2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 02:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjC1G2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 02:28:13 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70E2B6
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 23:28:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UppTEHC4zd/7NXXBqxlD25ztF3wRY21MwHoXxmE7BtHDpYgwV5RftLFJv0SkhqNuDcD0/73fIWZOyM/OHTUWQ6XsOjh9+QkmIxZFVPyyOzeCxohq8JbmBUy7Jz2IVGTOCV23M0giOyt2/KgWzGxLmSVRgH3TDFbmSs9ARl2fLaPOAHTcwpp7FLpbicX4V8sJV7KA1ZUP3SEDj5+xM8XEx7AEmSq6eXsYZ8UAILcF1pOE6FjaGKFNMGl96SOELxoC9rDNRk1LvacY89B6VZLRKPnUg78vPWRrDz4o4+QPcVJMHq8ysaI6k1BR6r52/B3BC1O8bx3+4AwPui41RW+beQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pYxFJ+zg8Fmmc2iOIg63qfbauLcIK48wVtC4pPGoSQ=;
 b=N8VCqzHsOoTZpd6UEpKSbUJAvKIHrzXyDG3aWBnFCnsSXbt4aLDyIhqdnMQ5RyTMncrXJorQv8/xMLxHeUwBPuT4jctkQMPD6tx3NT58KeJTHwx6GnGBo0v9xuo/QXmjpTIs3L9ndhBD1xewikV1UApU9cGiZl468nCFQftMv0Ns1hidnQdbiOmrP8lMRV85spNW+obtoAQlJKhQGoVqWRw2HKj7n2xum1tBaNFNfNWX3Ju/eFYKXhOMkuzzT61ud9dqcUfxa3tyNR19lUcaFCXBsVTuQN8tXlWbJitdju3kyG6EP0Rv2zSmuJA/s4BqYJXwxi0zWd46hxEuDMaIPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pYxFJ+zg8Fmmc2iOIg63qfbauLcIK48wVtC4pPGoSQ=;
 b=RlmMc7tkfJkmJf4MVctD77WTLD1B8AeYw5u0JSc6BvlDmAv0VR2EAb5AlX2JK39PWRPBw3rlRL7CtEElC5105H9F/lIOgfkJHx6XYpTo2SzU6bGbUv5OFsKTn8yD3D4n7R5PZ4P4Vfxh0h/Tc70o8pWW03Sifq8AFcoeWw6gADFxQSnOcJCqsccwA9Qm1Pb4wtWxJxm92B5UsIpU61ad1U72xIfabnsGngnV+zUHtBdXtFwNpD9nirKgGPuJFeThbtCCmC8iYLQrYyD5Xku4+YCb5Hru9gNAbCK8QZ/q5juUGK8kNJ27xVeimtTAx7vZZQyc6y0rt6NTmd4CgWRkKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20)
 by PH8PR12MB6674.namprd12.prod.outlook.com (2603:10b6:510:1c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 06:28:03 +0000
Received: from BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::dd0c:ecea:440e:e1a]) by BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::dd0c:ecea:440e:e1a%5]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 06:28:03 +0000
Message-ID: <cfaa67a5-2ad1-6058-9ad0-89c8a24bcfa9@nvidia.com>
Date:   Tue, 28 Mar 2023 09:27:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 net-next 1/2] ipv6: Remove in6addr_any alternatives.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20230327235455.52990-1-kuniyu@amazon.com>
 <20230327235455.52990-2-kuniyu@amazon.com>
From:   Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20230327235455.52990-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0499.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::6) To BN9PR12MB5258.namprd12.prod.outlook.com
 (2603:10b6:408:11f::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5258:EE_|PH8PR12MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 00560abb-0ba6-4524-4ca2-08db2f55955e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBcROb7LaSEJ3P9ga+IUvHHs39vmWDYLS7jG/OeH2AYqo9ky5ctD4UuHHk9HXXZVRYCfpvXd4pSsp+bR8rgQVJfqgseH15v8RVmSI5YioujCJoAuz6ppT4rdgVFj3p9E6E+6P3u7rGVHgZfykWMD9hOzVebvLrlxk2tv8wW7v+fwO0/Uh68NmzstKb+ahLfqOgTW3mqCnTrKERrD87l+DG4V3Bt+96Ci/w9cJRi8qyCMp2dg2RJraC4M5gyEaZjuK0V1SDAwp8G4g347E0AHcyPYL1nULXFj7hcBqKjlNqwaJwfbEAVbeUlbkMhyxgTDSUiNT6vD4L0msq1MkYYtaNgI6bDNVackaKo2B8fz+kR/36OIqaaC3YlyMboL7AT7J0/zWhUSwZKAVLjJOcmXJx+VVQnLCIC/rJoiFVS6W4Mptr5cY5jFSFI32YajkDcf66LbDeMwrOgqluBw4DDUKX05kzIkkTt+kkwDlmNo1Fk1VDnZIDO/m40dv3Bu80bu/T4i29oBmhUkgvWXMgwRS7rRXQa4WQEXtRyta4OAopgViZwBRHjzS22Baj5bdRv6tV7SGkCjufynSDLDiwitXuZP7C3TJOsDbZTGjntn3fqn/E4Ak1lV15umwBhSUn6L/4/IJ7OOOxBmHgk8Nv7KYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199021)(26005)(186003)(6486002)(6512007)(316002)(53546011)(6506007)(8676002)(4326008)(66946007)(110136005)(66476007)(66556008)(41300700001)(31686004)(6666004)(478600001)(2616005)(8936002)(5660300002)(2906002)(83380400001)(86362001)(38100700002)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dk1JaTVRTHZaMVN6Y2ltV2kyT3NDVG51MEVheGNyc0xiSXNhSXEyUUJGQlZT?=
 =?utf-8?B?ZFpRbkl0TmRGM016bXRGOEZwVENUYXhaNHZ4dDRTTmMvcW9hZUlZUDB3NHVW?=
 =?utf-8?B?aU5GQm5sWUQ3bHpZZTFseS9Ld2dsY1k4TzFOSHZDcEhBUjFmUmZUbUxOMTd0?=
 =?utf-8?B?bGdrVnJlemd4OWVSRkRmVytBdWZTbzJZaUw0Y3ZPVWNaRmdGY0tnNldJRkp5?=
 =?utf-8?B?eTZvRGNtaGt4WmUxQ2FoQ3RTRm5Rd2FxK3NaMXltREZBdmwwVmg2Q3BxY0Jy?=
 =?utf-8?B?WUwyRS9jbC9IbTNrWUdFSjVFWllpRzBhUzBEd1BOWjcyWHRsajlwRlo1RnRH?=
 =?utf-8?B?OEVpRVRsblVpRDF5cGZxY0hKZXptUVZrZk04bXJtSTFHK3hzZWFzL2IrTk5m?=
 =?utf-8?B?T1pSV2htdmF1VnY5WXNaUnhIOUxXa0JuU2tTZVRJUEJKOWh1SWFrRG5Ua1pV?=
 =?utf-8?B?eXc1dVRmRzhPOEVIOFE1SnVyUVA3cG5KaFY5TU1IbGpiM2xpVHNQckhUNHhN?=
 =?utf-8?B?OEowWWx4UmloclFQdXNrVDVZazd0eEwvYXhXWmJIL3VtOHdPa1I5MlFFdkRa?=
 =?utf-8?B?VVFBM2JuVGVkcHE4WmNsS0lqMnhEME1VTkxRWjBSaUwrT24yOFpxSUZNdU1I?=
 =?utf-8?B?V2tLeUlTSzAvUzA0Yk1vREtmSTlKMkdsMmJrc3hWRXhZVys3c2lyN0RzUWlD?=
 =?utf-8?B?ekFLaXp2MEtDanBabXpkN2toZU1OWStJTnpHVGlOelVEc0U1VG1PSm85ZC8x?=
 =?utf-8?B?ejVPOEVWRzRGd29OUlVmYWlkYjRwQzFIMjBMSSsvSjYyT3o2MnA4WFdYMW1m?=
 =?utf-8?B?ZmhWNU9qNjNBVStqMzQwMDYxY0g5RzdpSGM5Ykl6V1NqNlRyMWlFbmx0OHZ3?=
 =?utf-8?B?ZWJrTG5zeC9HWDBuQnVRNkM4Z3RjYndTN0lLTHJTN3EyVlhTL0VxQVFwZXo4?=
 =?utf-8?B?bWdPWnZZUlVZYWF2eE9BbGkvUE0rQy9Md0VOcTdtVlVkOUdmeG9GRTRUVWtY?=
 =?utf-8?B?RWVIYU42VUQrM1lwekROaU54RHlRTHZVSXFLSWQ2UjBiejc4aittU0VNbW90?=
 =?utf-8?B?UmdMeDZWeHp1ekpNemErK2VHRG9nTTRqKzc5b0ZyOW4xSW5VazZrTDkzUmpO?=
 =?utf-8?B?b1ZPMFpVYzk5TWdkak95TFVyR3IzQVdXc3g0VDIxeTdYQUtMSzZlL05ETjlM?=
 =?utf-8?B?Q2hOUktaZWFEWkNxSkl3emhqMWxYVVdWWlBnV2ludGkxRmNXVTNaSG13dnR0?=
 =?utf-8?B?VkRRRU5iMGlaYlIzSnB2OUhUTmJuTG5CSDMyQ2RFd1l1VytKKy9GRXI1cnNj?=
 =?utf-8?B?TXkycVU1TmVKQncrQjY5S21GcExzT0dnVXh3VlZ6Qk1PR1VjQUFaNnFmMUxm?=
 =?utf-8?B?eXg5UUV6VjY1WXJsdnhoeWx0Z08rcXNvTWRINjhrcFRSZWNvSUxDTXV0VExF?=
 =?utf-8?B?UjUyb3hqSlUwSk9Cc1JYZFNRMDI2MkVWYUhYaTNpMjRQdTAwb2Jqbk1ZRlNN?=
 =?utf-8?B?R1hYakpka2s0REZidDBiZ3Jxc2laNU5mMjJ5SWRaYkFlZmE1WnloTlRFY0RE?=
 =?utf-8?B?S0tDVGU2MEtVeDM2aHVpcVNSVHE4SFhXUmZnNVljOTdpMXR2RnhObGpENE5C?=
 =?utf-8?B?OEd1Sk9pS0NmTXFiMUZWdjRmRGxZeW42c01SQTBkTTVVUG5TVWJhNlpTMlEz?=
 =?utf-8?B?Nmh0eFN2N1pOMVNXNGNBMUlNSzZnVEtaTU9LMmJBWTc3NVdZWW11U1BZMlJE?=
 =?utf-8?B?NmUyL0hVWENIY1YxMlYrOEF4dDJtMlpBU1gyUHgxZ1hiMTdCNFRYYXJ3dTIz?=
 =?utf-8?B?Rmh2bVhUaWlBQXBHZzYxZlltVmY4NG1LbVNuVFl0T2t6OG1aeGthWEFhT1R0?=
 =?utf-8?B?VVlmbjdrZkh4Zy9JczhyS0N5VUNsUFpia0NLNXdBcmh4M1BLSlhnc1IvZ1pq?=
 =?utf-8?B?N0pWai85V2gyckUyZGdZVlpIUjZzS09GUUFBb3grR1FVNENGK3FjQkVQQW9V?=
 =?utf-8?B?amlvbmp0L1RHZmhadFE3UWt2M2hPS0tpbXY3MlhONzQvcGZOM0FScnJVZFpv?=
 =?utf-8?B?NWJadG4vNVo2MURGNjQvaThFSEhZREF2ZGh2SFlGRDZkNVYzeDUyOU9JUlR4?=
 =?utf-8?Q?D+ZAy9F9GCvrIflgEUHSfv8DB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00560abb-0ba6-4524-4ca2-08db2f55955e
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 06:28:03.0021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2PZx7z4L7DcmezBjp6HzHGK+1ws1eUooojNAw/JqoMJWMWajW5AiAodfScCv+nv6H1ffU11jfV8V4lX8uMAmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6674
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28/03/2023 2:54, Kuniyuki Iwashima wrote:
> Some code defines the IPv6 wildcard address as a local variable and
> use it with memcmp() or ipv6_addr_equal().
> 
> Let's use in6addr_any and ipv6_addr_any() instead.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |  5 ++---
>  include/net/ip6_fib.h                                 |  9 +++------
>  include/trace/events/fib.h                            |  5 ++---
>  include/trace/events/fib6.h                           |  5 +----
>  net/ethtool/ioctl.c                                   | 10 +++++-----
>  net/ipv4/inet_hashtables.c                            | 11 ++++-------
>  6 files changed, 17 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index a108e73c9f66..20c2d2ecaf93 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> @@ -98,7 +98,6 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
>  #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
>  	else if (ip_version == 6) {
>  		int ipv6_size = MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6);
> -		struct in6_addr zerov6 = {};
>  
>  		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
>  				     outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6);
> @@ -106,8 +105,8 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
>  				     outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6);
>  		memcpy(&tun_attr->dst_ip.v6, daddr, ipv6_size);
>  		memcpy(&tun_attr->src_ip.v6, saddr, ipv6_size);
> -		if (!memcmp(&tun_attr->dst_ip.v6, &zerov6, sizeof(zerov6)) ||
> -		    !memcmp(&tun_attr->src_ip.v6, &zerov6, sizeof(zerov6)))
> +		if (ipv6_addr_any(&tun_attr->dst_ip.v6) ||
> +		    ipv6_addr_any(&tun_attr->src_ip.v6))
>  			return 0;
>  	}
>  #endif
> diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
> index 6268963d9599..6f21d37a07c3 100644
> --- a/include/net/ip6_fib.h
> +++ b/include/net/ip6_fib.h
> @@ -472,13 +472,10 @@ void rt6_get_prefsrc(const struct rt6_info *rt, struct in6_addr *addr)
>  	rcu_read_lock();
>  
>  	from = rcu_dereference(rt->from);
> -	if (from) {
> +	if (from)
>  		*addr = from->fib6_prefsrc.addr;
> -	} else {
> -		struct in6_addr in6_zero = {};
> -
> -		*addr = in6_zero;
> -	}
> +	else
> +		*addr = in6addr_any;
>  
>  	rcu_read_unlock();
>  }
> diff --git a/include/trace/events/fib.h b/include/trace/events/fib.h
> index c2300c407f58..76297ecd4935 100644
> --- a/include/trace/events/fib.h
> +++ b/include/trace/events/fib.h
> @@ -36,7 +36,6 @@ TRACE_EVENT(fib_table_lookup,
>  	),
>  
>  	TP_fast_assign(
> -		struct in6_addr in6_zero = {};
>  		struct net_device *dev;
>  		struct in6_addr *in6;
>  		__be32 *p32;
> @@ -74,7 +73,7 @@ TRACE_EVENT(fib_table_lookup,
>  				*p32 = nhc->nhc_gw.ipv4;
>  
>  				in6 = (struct in6_addr *)__entry->gw6;
> -				*in6 = in6_zero;
> +				*in6 = in6addr_any;
>  			} else if (nhc->nhc_gw_family == AF_INET6) {
>  				p32 = (__be32 *) __entry->gw4;
>  				*p32 = 0;
> @@ -87,7 +86,7 @@ TRACE_EVENT(fib_table_lookup,
>  			*p32 = 0;
>  
>  			in6 = (struct in6_addr *)__entry->gw6;
> -			*in6 = in6_zero;
> +			*in6 = in6addr_any;
>  		}
>  	),
>  
> diff --git a/include/trace/events/fib6.h b/include/trace/events/fib6.h
> index 6e821eb79450..4d3e607b3cde 100644
> --- a/include/trace/events/fib6.h
> +++ b/include/trace/events/fib6.h
> @@ -68,11 +68,8 @@ TRACE_EVENT(fib6_table_lookup,
>  			strcpy(__entry->name, "-");
>  		}
>  		if (res->f6i == net->ipv6.fib6_null_entry) {
> -			struct in6_addr in6_zero = {};
> -
>  			in6 = (struct in6_addr *)__entry->gw;
> -			*in6 = in6_zero;
> -
> +			*in6 = in6addr_any;
>  		} else if (res->nh) {
>  			in6 = (struct in6_addr *)__entry->gw;
>  			*in6 = res->nh->fib_nh_gw6;
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 646b3e490c71..59adc4e6e9ee 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -27,6 +27,7 @@
>  #include <linux/net.h>
>  #include <linux/pm_runtime.h>
>  #include <net/devlink.h>
> +#include <net/ipv6.h>
>  #include <net/xdp_sock_drv.h>
>  #include <net/flow_offload.h>
>  #include <linux/ethtool_netlink.h>
> @@ -3127,7 +3128,6 @@ struct ethtool_rx_flow_rule *
>  ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
>  {
>  	const struct ethtool_rx_flow_spec *fs = input->fs;
> -	static struct in6_addr zero_addr = {};
>  	struct ethtool_rx_flow_match *match;
>  	struct ethtool_rx_flow_rule *flow;
>  	struct flow_action_entry *act;
> @@ -3233,20 +3233,20 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
>  
>  		v6_spec = &fs->h_u.tcp_ip6_spec;
>  		v6_m_spec = &fs->m_u.tcp_ip6_spec;
> -		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr))) {
> +		if (!ipv6_addr_any((struct in6_addr *)v6_m_spec->ip6src)) {
>  			memcpy(&match->key.ipv6.src, v6_spec->ip6src,
>  			       sizeof(match->key.ipv6.src));
>  			memcpy(&match->mask.ipv6.src, v6_m_spec->ip6src,
>  			       sizeof(match->mask.ipv6.src));
>  		}
> -		if (memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
> +		if (!ipv6_addr_any((struct in6_addr *)v6_m_spec->ip6dst)) {
>  			memcpy(&match->key.ipv6.dst, v6_spec->ip6dst,
>  			       sizeof(match->key.ipv6.dst));
>  			memcpy(&match->mask.ipv6.dst, v6_m_spec->ip6dst,
>  			       sizeof(match->mask.ipv6.dst));
>  		}
> -		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr)) ||
> -		    memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
> +		if (!ipv6_addr_any((struct in6_addr *)v6_m_spec->ip6src) ||
> +		    !ipv6_addr_any((struct in6_addr *)v6_m_spec->ip6dst)) {
>  			match->dissector.used_keys |=
>  				BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
>  			match->dissector.offset[FLOW_DISSECTOR_KEY_IPV6_ADDRS] =
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 6edae3886885..e7391bf310a7 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -826,13 +826,11 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
>  				      unsigned short port, int l3mdev, const struct sock *sk)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> -	struct in6_addr addr_any = {};
> -
>  	if (sk->sk_family != tb->family) {
>  		if (sk->sk_family == AF_INET)
>  			return net_eq(ib2_net(tb), net) && tb->port == port &&
>  				tb->l3mdev == l3mdev &&
> -				ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> +				ipv6_addr_any(&tb->v6_rcv_saddr);
>  
>  		return false;
>  	}
> @@ -840,7 +838,7 @@ bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const
>  	if (sk->sk_family == AF_INET6)
>  		return net_eq(ib2_net(tb), net) && tb->port == port &&
>  			tb->l3mdev == l3mdev &&
> -			ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> +			ipv6_addr_any(&tb->v6_rcv_saddr);
>  	else
>  #endif
>  		return net_eq(ib2_net(tb), net) && tb->port == port &&
> @@ -866,11 +864,10 @@ inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, in
>  {
>  	struct inet_hashinfo *hinfo = tcp_or_dccp_get_hashinfo(sk);
>  	u32 hash;
> -#if IS_ENABLED(CONFIG_IPV6)
> -	struct in6_addr addr_any = {};
>  
> +#if IS_ENABLED(CONFIG_IPV6)
>  	if (sk->sk_family == AF_INET6)
> -		hash = ipv6_portaddr_hash(net, &addr_any, port);
> +		hash = ipv6_portaddr_hash(net, &in6addr_any, port);
>  	else
>  #endif
>  		hash = ipv4_portaddr_hash(net, 0, port);

Thanks,
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
