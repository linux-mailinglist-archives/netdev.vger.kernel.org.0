Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC6A43E5AB
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhJ1QD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:03:28 -0400
Received: from mail-dm6nam12on2068.outbound.protection.outlook.com ([40.107.243.68]:1665
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229846AbhJ1QD1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 12:03:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMax31y+lbYSzsOExrrR/joglPc78B4MQaMDopO4zUnHq27KO5G0IjB5zsf760fCOuaCP+tMVfL1iWll9ej+0xmSF+AKrw0rHEmCFlqf2dtmExUB1CtkpUZZGmafu6suWuMSx/zBWtwFqJZlXkd6cw+6/4WAbClC/BLEHIBohpUQVvqEuoaJUBtuBFkNQEZfd39psjyt3cDgbATb8XzrV0+kvo9tncs/VlQL6beKHGVzETI/ZTg5uwlqYgIdqBan40AH3Oe4eDAhipSfq5p519qGOFaXVTqYvB2QXlh4FYjHVJkEE5RnfseZgSIqct0qsOls9sxI8od8rAK8MFaEJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1E6JeiiGsGkVww35EcZKNpNrX3ktiIWhgjgkQIwKbA=;
 b=UXVzwsqaXgJiXjISFtEzK4Ej//wDoVkQdOLIAsvt7PJMJY2LZmFyp0SA1BxT+WQZ5ZTS7uMy7+rvk3B6cGy5FPpcSCulHfz9DoAvNWgOLWswJfqRWU9R6lcQcSRNWzqZ7r0PtRTFa1YNyn34nbMviVCIHMPseXqMrIj9oHdtLG2yqtdT/H2VCN+aLUNEqlX48iwLb0i6DEm/tcdD8Ip2wWbAd9cHTisYg7aK1i1CVMRlyZEcA+polaL2GF1Bm0WIkkx/uezqJMql4ZaqHD2l0SjfhhrBcbRMUNYqjdONB+RCwb9V9IUWFmEVwJ2pA1+WpszmtMfIsQ6wpnN4KGz1JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1E6JeiiGsGkVww35EcZKNpNrX3ktiIWhgjgkQIwKbA=;
 b=ejGtEjnMADfGM+KcAe0/UcipmyJ4px55yNC5dQKaoGsuFgdFRDX4LOA8MqhXNeeSWx3kMTkduNmkrxfH98kkexHqZQbBZKECkXZNCP39ij4PrU7LtOMgyehwqmNkpOOlQlAtTtMqB2bbHIZIsTJo0d+xpcSQSl6trSiPc8k/zjxRkCu/lDMRSzwQcWEQ5S9CsiBv/hq5xYyLtXcy4CJFQUPkev3nfWwiAFhrI400d2I5RJBGyDz3fZIpsA/nzknzXyiBcPlMKnYqrGcyAR5rtkq11aUyqRQx+pKN3AkxsR/Pg9T1ZwvFEgjyWEl+fljEpedbEyw7XWZ+vEtEpC+yoQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5271.namprd12.prod.outlook.com (2603:10b6:208:315::9)
 by BL1PR12MB5237.namprd12.prod.outlook.com (2603:10b6:208:30b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 16:00:58 +0000
Received: from BL1PR12MB5271.namprd12.prod.outlook.com
 ([fe80::f1ef:e438:4a36:cf41]) by BL1PR12MB5271.namprd12.prod.outlook.com
 ([fe80::f1ef:e438:4a36:cf41%3]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 16:00:58 +0000
Message-ID: <128db0c4-1d7e-27fa-0dae-3567a0913f1d@nvidia.com>
Date:   Thu, 28 Oct 2021 19:00:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net v2] net: bridge: fix uninitialized variables when
 BRIDGE_CFM is disabled
Content-Language: en-US
To:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org
Cc:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20211028155835.2134753-1-ivecera@redhat.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211028155835.2134753-1-ivecera@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0045.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::14) To BL1PR12MB5271.namprd12.prod.outlook.com
 (2603:10b6:208:315::9)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0045.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Thu, 28 Oct 2021 16:00:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd35e4ce-ed29-4b59-b8f1-08d99a2c2124
X-MS-TrafficTypeDiagnostic: BL1PR12MB5237:
X-Microsoft-Antispam-PRVS: <BL1PR12MB523794A10B101A31BB687D10DF869@BL1PR12MB5237.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7wA5WETcBSo2XirREGtSNIgtrPAPPxeEsP3gCxiYGK8OQmtE6h1oqhmD3r0eSq7AE+IzTuqeCgkZjoJ6NPaZuz0b9GNudc6Ykfmd1HFpcDk3H53XxoY++dlEPY+rMpmlMQL3bjX8rp7n9NyTLnliL/FNNtIWCvRT/kB14/4K3R2BBu09iGIUEhxkxF9Nba4urtxMUTWijONrmVbpXB3JRZ8HG3JTwtDSH/Wxaq6V5xLPSKSrE8nlqnebNiDum3QViDt0CqsPj4f1XjZe4LtCffmJIg/3cZ5Ao8RP9tOQ790JbGblZfqID1rjqpkeZbzDb5vCop4Y4zdxHMvl8CRxbTiowbPbF4cIQC/PpgCufuruhmeOBpyEVwZ+6OtsK26r/v56vcVlpgZ4O0zAmEwHIh1yfS0mUWbViqL2GiClbqNXQA6lSnY95/5xjLaqv1bATluL1Kuf29tJ7MhCahh9W/YKcCE1G1kaSBvqgLWFMObTE9rwiFyKJrHUf3P8ZfGb+TBsoOO2Pg6oAFn3JbumBKf507SuA/9AO79Y94b6DtZgx/7mlnTtS29djY7ANoispEocC8A9w5VlVx0YvV0sHGt2YlWyBvS935+P/xrdO71Ps5rasmhJxmUseDGz2HWFhHNauLeiqgCRJtfDZJRpEtvosa4UxhnruHUfAKx9MC8LLQ4bsheENM7OnP9OJrPZt83HGSjcLCSrIfUfmIy9Dx4phEySdnM9xSvhtMbkBO4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5271.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(66556008)(66476007)(26005)(53546011)(38100700002)(83380400001)(66946007)(6486002)(4326008)(508600001)(31696002)(6666004)(31686004)(86362001)(2616005)(316002)(54906003)(186003)(8936002)(956004)(5660300002)(8676002)(36756003)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXRnV28xbWMvbmV3MGJsb3VhbU9WWndNWGNFRFpjaGVmUXJLeXpIZEQ2MTZu?=
 =?utf-8?B?NVh3V0I2N00wWGd5RzFQcjFDa3c4NUFRZ1Vka1JGdy9FT0VLOGJ1SG5jVU5Z?=
 =?utf-8?B?NGh1UVY5eWkvVHRhUWZWYVVLbVVTTHMxS2pqMDhGUTdxc0pWQmgrUzVFYmcy?=
 =?utf-8?B?N3ZzcVYxYXlzYnBBRkhnZlRkR3I3U0ZEK3pXMXJQRlY3QUdIK2VHb2hTODFm?=
 =?utf-8?B?N0R1ZThOMXJKd0xWRXgvamRlSXdBaERpZU9jdDlmWUtKcXcySjd3cnppdTB1?=
 =?utf-8?B?d2ZoOTdNMy9MTUwzNVNPdndyWDFCcktnNEFBSlpxWUpEY0F0NWpIaGpDdkRH?=
 =?utf-8?B?RXd2UU5qNXRNMGhpdkdGNDJ4a3Z5b2wyV3gzVXBKeVRGU0djekRYdFJrM1VM?=
 =?utf-8?B?WXpZSWIvSHdBMlFqckxDWGQrQjhpT2dacGt1QzM5cnR6NWZUdFRZRDNrKzdK?=
 =?utf-8?B?WTBOUi9CNzdhdGF5elBzdldwVTJ4eXpseHpySm5xbDJVdUV4L090ZFEvckQv?=
 =?utf-8?B?OG02eFFndnRRUVZKMDJsMU1OU2ZGUGgyL1crdllPZzM2WGdnYlJUTzB4Q2hN?=
 =?utf-8?B?aFQzaW8zTjBVemRueW5CYWdBVS9WMk9rWUEvYnNaQVlaa2xtVENPNjc5Wjhx?=
 =?utf-8?B?anNIZHgwallTY2dIZkozMVFCL0xob2d1WmtxbEd4WlF0bVVXa3d2eVc2Zi9E?=
 =?utf-8?B?L2haRFZrUEdDZ2d4T3NacHBwcitaeVFFU09JUUlXM1psQlduMDNQK1F6cUtP?=
 =?utf-8?B?cGZac0llb0paT2k4UUVVN0dRUG5mK3BOWEpIamhLcXgwbFJMOVA5WlA1Tk5B?=
 =?utf-8?B?ODd3cGd0cXBScWdOMXZXOGs3TGhmdkJwQUZPdWMxUDZlcVlFbVM4ZnFTWmEv?=
 =?utf-8?B?N3Fpd2tuTDVrZUJFSXU2MzlRR1g0WVFIK25FeHJ3UE5IdnZ1UDgvVHRrZ1Y4?=
 =?utf-8?B?TXJaa3JCcVF4VnJYOE10dDRtbHl6SXJXblV5UGs1TmRnSVZiMUZUMFJpRDRm?=
 =?utf-8?B?emxUb0E0bTN2WEJKSnc0MWhlSzU3UzdDZTNMREpJK21GTTlWOVpYamlWNllV?=
 =?utf-8?B?bUtxZlFkSUs0VGU0Nm5acUlzREkxR1VtSy9LSk1iTXF0YmcxNjh2ZjFsL3NE?=
 =?utf-8?B?YjROU1RHbHljVnMyTHlPYTdXYm5GS0xHUlNjdWlWQlM0WWxMNmxMWHE5clhu?=
 =?utf-8?B?V3Rzd2phemgxOTJkYVdEeWVqbXpQMlZGdDJXbVpIeHZrUlRSdjZmaVZYbE5W?=
 =?utf-8?B?d3hDcW9zdm12b3o1UU4rRWVOSW1WYnRCbzBNcXVSZlNMcXZNd0hzUUZ0bTNJ?=
 =?utf-8?B?a1RwTEVNaGZzWGErV3FvNzFHT3U0WEJ4UjZTZzRGaDdTaW1GbVVxMWMvemNo?=
 =?utf-8?B?ZGpuV1pLei9DakJEVjRaOEhmUzFjYWtBTHp6NVdjdmVRbHVvWENQa2tPUjdL?=
 =?utf-8?B?QTFLOStwL1BDUDdmZUxVSTM3dS9aYU5DNFFTZndLNVNqSWhMTlV4d3hXSnRT?=
 =?utf-8?B?Mis4Y0RlbE55WE40RUd2NXJsYnQvZmFNbTBXOGc5UVR1SUlKZy9IRjNpcnNn?=
 =?utf-8?B?Uko4dDlUK2M1YkhPd0FaQ3owNThiSjZLdEdPL3hDVWd1Qk5UWXp5cXBYellE?=
 =?utf-8?B?TEVXREFKR0lhZmZXMmxLU1BJU21WakFaa3BEUzFZMTd2RXlvYktwbXVHT01a?=
 =?utf-8?B?Y2VPVFZJS29zbDFOMCswWEcyUDZGOUFaSjk5RzVoR1d3VS9GblJCRUFsdHA3?=
 =?utf-8?B?NXFMd1ZOWjQxWGZhbnVvSlhSNDF3Qk91bk5QZ1BDdVcwSlFuM3Z1YXV3L0h6?=
 =?utf-8?B?L0NvOFJnRkJjdWZodCtwZUM4Sm9CTkxlaml2SjRhOHZ3dHpkbGJUMlVLWUtI?=
 =?utf-8?B?QXdvUUZvSVBHVkdYMzQ0dXRQN2JCOWJxUkRFWUZDYU4rR21janlMQk12ZWxa?=
 =?utf-8?B?dUtnTStyYmVwV1dYS2duNjlpa3lEMmtqVHV0NzhWbDQ4M0hvb2ltS3JDeTM3?=
 =?utf-8?B?dzdCdzRYWDRvdkZkblJsTHBkTnNDUGRyZE05dnJwWEJLMGxmQmd0eDVjNTFx?=
 =?utf-8?B?TUhlQzJSY1NIcG5pd3N6OFhmaHFTUWczelZkWEFWczlaZVdpUVpCdkNIUGhX?=
 =?utf-8?B?YnJhVlRKNDhWWFVOTnlZcWJvaEJKUkRsTDhSNVI4VzBOMkRQL0c2aElacWoy?=
 =?utf-8?Q?w+1yJiXDR8q9zh9N1Lts19U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd35e4ce-ed29-4b59-b8f1-08d99a2c2124
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5271.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 16:00:58.0564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7Xy6zQSPthQrgOIiMn+hzLeFqHZF0GgHlMw7kUwfx8tvoXTLN2V8/aiULFtLcFTuQiTmQZCn0NYaZFPUBwOcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5237
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/10/2021 18:58, Ivan Vecera wrote:
> Function br_get_link_af_size_filtered() calls br_cfm_{,peer}_mep_count()
> that return a count. When BRIDGE_CFM is not enabled these functions
> simply return -EOPNOTSUPP but do not modify count parameter and
> calling function then works with uninitialized variables.
> Modify these inline functions to return zero in count parameter.
> 
> Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
> Cc: Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  net/bridge/br_private.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 37ca76406f1e..fd5e7e74573c 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1911,11 +1911,13 @@ static inline int br_cfm_status_fill_info(struct sk_buff *skb,
>  
>  static inline int br_cfm_mep_count(struct net_bridge *br, u32 *count)
>  {
> +	*count = 0;
>  	return -EOPNOTSUPP;
>  }
>  
>  static inline int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count)
>  {
> +	*count = 0;
>  	return -EOPNOTSUPP;
>  }
>  #endif
> 

Thank you,
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

