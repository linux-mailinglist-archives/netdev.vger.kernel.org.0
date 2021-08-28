Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9B33FA4E0
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 11:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhH1Jwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 05:52:36 -0400
Received: from mail-co1nam11on2045.outbound.protection.outlook.com ([40.107.220.45]:59489
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233735AbhH1Jw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 05:52:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdLPHlQJuKliaAmMXCl4ti5iYhgffxHxP6V0FN7IieP74e8tR6UNild0/jGTCORdj+sTOqi4dlO+TuBcZfVBkXLJHkhzVHdI3dS2u8cWAg6LOuyJkmHZ035d7Xw5oh3iyvYbxTj6Q/cPEZ0702TgtUiL9OlqpTDRspffa8E1Zenz/qjLWpUIOunrI5cPG7GThDTf6aM8mwTOO1+rUjoIESgZqBJJi29Jd5+CLDpNGZoLurj+dn/kwpel5fjBFeih0LMj2atCDWsbYLfq2YLfXtmqHm82fNQQwXQUekC9qCOhbQu66bORxj8vtfk+QF6L7Lb/m4qWdDNARA6o+ptIgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EK5Vk7oobnqwUypT96YBcvuTwV+0IlqXQT1pY8QDnDc=;
 b=OhkYxFUbJjUihxU4Z92QI7OBa9KCLmV6XCMe9TZZY7cbJMAdgRTBQ7PmxogR3V2fD6/ALkwod1Wtt3h4/oIRT4eJ+48x867q2K3FAn11a0cZ3mNiwacr+CnPFS9dzxBULVw6Wkco4Gd1jL8vqana3j+gBoOdGIcbcV+OwoS8hH21OmQ1Y77RXv9oZCfyaOwI4PxYELvGrXCt2PxgPIRvVzjGZI3CkyJIioweIcALnS2KT3+Un97ryzxLxqqGTtLz8jDzK/FFKtIUEejGSbXe/YKpjc3ZmDf+pIMZsG97U5fymf36bCED3ZdDp18nHXJ/KQzYMfZctVWzCuKotBUKrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EK5Vk7oobnqwUypT96YBcvuTwV+0IlqXQT1pY8QDnDc=;
 b=fcCr9VtEt6FHPMMB3uwJMxKauOlVnxzv3OWVip0X3brpDcLgJnFH7dzqvKjcZ7X9OPSfhCudsS2qqUV41WYzZAW+t+7g/QuDQ3zHVwqY5egfk5TFLk4h/bLqIyXJiFk//Wlj9Mp9OjxsaKU7gK/7xl49PTZ/aIojJ6LyFczpeOJKYq9WDag1oeYUL4VT/qxsIG1R40TOI2KCESzSz/hEDou2hBAHb9YrQN3IcC40RolzIaHDggdbq2VOHiUeh155eGKqa4zV/C9dO0tdyh1VGHEkp9TGmd09uqFsedXzIWx1toROI3VXlfkYIXbHzrC6R4D+IvomN0EPfjYboxjaxg==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 09:51:37 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%5]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 09:51:37 +0000
Subject: Re: [PATCH net-next] net: bridge: use mld2r_ngrec instead of
 icmpv6_dataun
To:     shjy180909@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     roopa@nvidia.com
References: <20210828084307.70316-1-shjy180909@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <44c13ff2-e693-605c-1851-c161492166cb@nvidia.com>
Date:   Sat, 28 Aug 2021 12:51:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210828084307.70316-1-shjy180909@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0145.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::15) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.175] (213.179.129.39) by ZR0P278CA0145.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.22 via Frontend Transport; Sat, 28 Aug 2021 09:51:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01fed311-effc-4561-db53-08d96a096d48
X-MS-TrafficTypeDiagnostic: DM4PR12MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5072DBBEF70679F22361163FDFC99@DM4PR12MB5072.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m383J/3fQIpkHRw0ez078ncts2l/w6dGDWMtzfHuN5MUg+NTG1XMKJbgmpZ8y6Bc9yh6UOlmuMq76NKpA22VMi4sZ1m7lF/Z1G4zvttEFlTA72nxQnrYHKkq3I5Y3MHksUOYRfY9kOEQ5gWn6wqyVzIeX3y8c+B8vqVK1YLKpuBhUETsOvoIYG70fyrFnIoIklluUVMkT6De6c+RSpSL0n6b6SPqjVaNtFCltj7v6MorvGuTmxTnWy4C2RxNV360HZjNOR9qivbbf+XbzkEaE1o13NT5Lne8eY8Lg2UpQEXpNIuV17bOtlsnqp1FCSH2PR2SZxjO9GAK5Z0RKPATG97Fh5wtQA4niCEvHntgFgWcF3celO7QLf9xU8LQ3AJ4xYmecq8DD4KItjYoVAQm2A7ZpIXaDbnZJehKtrVjfTYuV1Q/ebyj4BldxTtFX9K6okqBB83zFXfqCBJp+jY4zUyuF+nZ/6VijE3VAw5Y5/g9Veixydha0Hfq7pfRFjf/TakkOWObYL8zLhTWWCuTSP9Gv/6a7G5cVaTz+JkOAIz2+tRjbDKcfrfC9TCjEIlIY2elhtsXi2wRXBpuycypPBjcZ43OIrtBqJ5IEUwLO7VOO4HTNv8L4z4Mb+02FPF8tQo0gstmPTiQFTWOrnjFwUjY61ENtTI9SVrReOYzGjAs/O77OfiKTDSxljxOw6LDACo3NcpkqJfK3WNTc2v1seyvjhnIbwsXCTx+A/B74+w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(2616005)(107886003)(8936002)(66946007)(36756003)(53546011)(4326008)(186003)(8676002)(66556008)(6486002)(316002)(478600001)(956004)(16576012)(6666004)(2906002)(86362001)(83380400001)(66476007)(31696002)(26005)(38100700002)(31686004)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFZ2S0ZXeUhBLzIwSmNzdFlGTlhiR1QxV3BhMEp0SGN1M29KRHVkdE5EOXZ4?=
 =?utf-8?B?a2hLaTB0VjBXblZjUEUxWXErMDNnODhCbEhhbEphSDMydmhla1J3blRqSzdk?=
 =?utf-8?B?TGhGbzFUQ0IvYzUreUZld3orU3U5cWRsRnJOTFNVTkx2L2pZWlA3VEk4OEJG?=
 =?utf-8?B?RjFSVktpTU9KRDY1YUpoaEZoNXh5Qkg5bm1JV05QeEc2NFBCNlgyczhFUy9G?=
 =?utf-8?B?VXczbFRTQ2ZxRzFzNklxeXQ0RmpuYkFNSU1kOEZBQlFJcWwyMDlVL09VREFM?=
 =?utf-8?B?cHJnTUV5WStxazhwYnJvQjkyaHFSakIzaEpEb2FteHQzTUE5Y05TZGl1QjBy?=
 =?utf-8?B?MFhSZzNtV0xJV3hmQU9Cek9OMEp4U012dXRIMjBNOVg2K09lR3cwNEQ3VkE1?=
 =?utf-8?B?cFJmQlZNT0RmYm9hRWFlaEdyRitpOExDb1hFak8vbFdXU2VvV0d2ZFBiUml6?=
 =?utf-8?B?c0YwQWtDVlh2RE03a3BIT2JiV0JwNCtNeUVyd1dSeXQvWU5HVjFiT0dNVTZH?=
 =?utf-8?B?eU8xN3ZuYzhQTE5IdHgySWlYeng0ZlVYbUtUaG9oMjJYei9FMndKbmRPY2Q3?=
 =?utf-8?B?SDY2SWVuczBoMHFIU1hmdWdhdVl4SDFmS29SZ3ZoNTkzdE9MckREZ2V2YW5a?=
 =?utf-8?B?UmdlZlZjS0Q0U2FNbktjVG1NbmUzSTRxRU9WMFpDZ3pQMkJab2VTWEJQZHYv?=
 =?utf-8?B?TjdNY0xRTXBWWWdYRzFGbGVLQnVIWTQ0ZTN1c3JvclpNQ0gyNjRucnE0S21i?=
 =?utf-8?B?Sm52eFgzSXk5dkJsb0hmaHZVVGxXd0ptblpwOHA5NDF6NDFDSTcvazUrVFQw?=
 =?utf-8?B?c3hCSEsyYkN2d2NiRHlUbUNpM3JqTDRNNE9MOVlCNEMwZlkxRzZtTGw1bHVx?=
 =?utf-8?B?eXJPTUhqdmpYZzZCS0VCOGI1VzBXTHJLNW9IL1R1bzlDcU4venNaS2pmVTlL?=
 =?utf-8?B?QTF3SmlmOEhEeFUrc3BqWnQyRTJMZGhOaVlnRndyNEluTThXZTc2Um5zTzdo?=
 =?utf-8?B?YkxhdEhOSFhhc3h4cFA2UXZ4aHp5dmVmVGttdFo0RVF6dkUzenJPRng1aE1j?=
 =?utf-8?B?ZUpGdG9QcmNUL0JDZGhHK2JlRFcyT2lEaEhTcWZ1eWRqOEl2NXZiaHQxTk1N?=
 =?utf-8?B?b3lCUEhXYlJMb0FBQlJMc0dkbnpDbWFzNVlWZ2FwOWhrRzlNdENDcm5kWkdq?=
 =?utf-8?B?Mk9PbDdWdVNTK3VLRW9zWHg5V1FaVDMycmlGeHZqQytjWW5OQ3hBU3hsdXpv?=
 =?utf-8?B?RTZEb3BiTnlUV1NZbkNzdjU5NVhDcE1jejdEZEZ2Rlk0a2YrWGJDRndUamZM?=
 =?utf-8?B?MzlGZThqVTJGazEzUk94ZEkzaWxPVlU1NUxnWHhEcUZwdFB6NmNPNVVrYXc1?=
 =?utf-8?B?cFA3QXA2V2RlS2s3eTUwbVV1YSswSGtyNko3d2RVTlNvNTFHM0ZRYzkrcnU5?=
 =?utf-8?B?YjFuTHZlSHBoclNpZG9sckk0bUw0S3dhRHZEUWhwcVVDOVJuQmVmZXc5Sk9C?=
 =?utf-8?B?V1ZsTUgxMCtpY0ZtbCtLdGFTcWJtdHkxcFp0d1F1LytrZ3FGRFRiWWJYcUtZ?=
 =?utf-8?B?b3hhUDhINk5GS2xoUXExSGlhN3lxSkI4clRzR2tpQXljSnNraWFMOUdSRVpl?=
 =?utf-8?B?U3E1U2ovL0JySHRudUVNdk0vUGJwWmtkZXFqanEyWVkyeVJQRWJheXNjZzBQ?=
 =?utf-8?B?Z1U0L3J1UExQSGI5ci9sWnRnNE81R1dHaGtSRi93Zi94b0hmSDFXZGhGVzNH?=
 =?utf-8?Q?JWIwOUvgVtbmeRXgRwW1TihdYVepewJgPkEESyM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fed311-effc-4561-db53-08d96a096d48
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 09:51:37.3115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w39fcjjp7kuALmipQNo1mv0nhMZC4cXitP80RiSyvQXQayEGSVQbXA36EM3hHAuVBGjk4LyiQv4h1Mi7kjwdSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/08/2021 11:43, shjy180909@gmail.com wrote:
> From: MichelleJin <shjy180909@gmail.com>
> 
> using icmp6h->mld2r_ngrec instead of icmp6h->icmp6_dataun.un_data16[1].
> 
> Signed-off-by: MichelleJin <shjy180909@gmail.com>
> ---
>  net/bridge/br_multicast.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 2c437d4bf632..8e38e02208bd 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -2731,8 +2731,8 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
>  	struct net_bridge_mdb_entry *mdst;
>  	struct net_bridge_port_group *pg;
>  	unsigned int nsrcs_offset;
> +	struct mld2_report *mld2r;
>  	const unsigned char *src;
> -	struct icmp6hdr *icmp6h;
>  	struct in6_addr *h_addr;
>  	struct mld2_grec *grec;
>  	unsigned int grec_len;
> @@ -2740,12 +2740,12 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
>  	int i, len, num;
>  	int err = 0;
>  
> -	if (!ipv6_mc_may_pull(skb, sizeof(*icmp6h)))
> +	if (!ipv6_mc_may_pull(skb, sizeof(*mld2r)))
>  		return -EINVAL;
>  
> -	icmp6h = icmp6_hdr(skb);
> -	num = ntohs(icmp6h->icmp6_dataun.un_data16[1]);
> -	len = skb_transport_offset(skb) + sizeof(*icmp6h);
> +	mld2r = (struct mld2_report *) icmp6_hdr(skb);
> +	num = ntohs(mld2r->mld2r_ngrec);
> +	len = skb_transport_offset(skb) + sizeof(*mld2r);
>  
>  	for (i = 0; i < num; i++) {
>  		__be16 *_nsrcs, __nsrcs;
> 

Indeed it should be equivalent, have you run the bridge selftests with this change?


