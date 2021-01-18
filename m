Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6072F9F2A
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 13:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403874AbhARMLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 07:11:12 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:63888 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391269AbhARL4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 06:56:05 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6005772a0000>; Mon, 18 Jan 2021 19:55:22 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 11:55:22 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 11:55:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsP9av19nL7qfO6J6WSPT/yr2Exc6bkaL2YY1Tj5WzPt0ywAtrWiLlcQ9Ja1/G1pmWMuH0YYUrD8Icj0Aut9RObbpmzmooLiL4faKntXqVWX9sPT7xj08WzEggAPe3tccTa1zszXqckZSHdAR8FqaxUGmw5Rdgb21RLydaZwUoJz7OBtFZD6ma9te87xDAiqE4O4ifkPNzfj/+xwlX4W0UC6adYHuubIbLYGI5iz5ZOKemkrhWIbtF18aKGkbcLpSiIFje3NRN3Rr6wqLH5r2vZFUsEPD1YhHNc/+3NVtq+SmjUaxue52kuIL3apgQcZDZuJXnZZWCKPGxSYL3omfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEdfpYVHfIWXubdM9Fe9ow4PHbVKBEVGfcE3jCihZDM=;
 b=eoooiI1hOD5Bm1AYPa5+SSplUsMcgy/dhCRQtE6vgSk4DF82DAdPmgGP2Vv8UCgbBN183lEi3DGdIpxqvMiZK8e5TopEgdcwS8SFkMVgHeQovNxdMkLBRNQ/QzcKPhd2p/GQzqpDpO20pgncIZbNALCAW/CqlkwVJaKUg13c1g8G7LIPUNNOSzHJ1i+o+F3flE5mZ4ggA3mfMpkAXDetIhbdceh54jiQHvGz52xQXgM3qkDNo20LRN/lsY6FfxgoQgZwAMkuLe8HPWv8MtS5AwH1zIOrieMc0eAHtGoKi58gz78i7lsOADNc4BmgHZzzTqxT/gqAWFGuwCYrEIAc2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: zte.com.cn; dkim=none (message not signed)
 header.d=none;zte.com.cn; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3339.namprd12.prod.outlook.com (2603:10b6:5:119::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 11:55:19 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 11:55:19 +0000
Subject: Re: [PATCH v4 net-next] net: bridge: check vlan with eth_type_vlan()
 method
To:     <menglong8.dong@gmail.com>, <kuba@kernel.org>
CC:     <roopa@nvidia.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Menglong Dong <dong.menglong@zte.com.cn>
References: <20210117080950.122761-1-dong.menglong@zte.com.cn>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <ffce5e21-fdd2-cb2b-6957-7454aea9c665@nvidia.com>
Date:   Mon, 18 Jan 2021 13:55:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210117080950.122761-1-dong.menglong@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0019.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:28::6) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by GV0P278CA0019.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:28::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 11:55:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9da8ac27-9a98-457f-a57a-08d8bba7edc3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3339370F1A5C9C9BD722CCA9DFA40@DM6PR12MB3339.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1GenZcvWSZlmfUZDrirVR+Q29NnhmdCMtvZCw44nrP93GRHvMjwrkSdF9rNuFFM6HGUmVb1HP6H0FkU1fjlLYutW/F948BnP8LRnph8fwSM+fGrXrKtgPahklb19P7xsUicZFUTOhUDXSFQxo1WB45OG8MVyEbQTrG0Hvm1hxTbOBLKS5YEf+AtFj4gDjcsf2DDV5FVer8A8Pml0k+IJMg4S2CDUWbtpZWZjSAiCa+RnK8HG4vcNUSWlp1rt5yMikFvh59h6jvFzfQTuEYlmqA7F55L5QtfXYpxFWC+hCUyFLYAWe64Q9g+Qmag8CxJv4CPUaQQErVBWoJBcPkfWDBX0ILrG2vliXm91Gtn6yTa4Z5zYBwGBIzrWfiISVqsTURZx4t2ERK0DJIqZUaWOVZzi6wwGPa5b4tncc/1UQKhiLZnXlIQ+UkVhuIgbHqA8LMxHnLdoNPC5YMUxQdPVGiXRDVcd7OhFF+t2wotGfAM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(36756003)(2906002)(66476007)(186003)(66556008)(8676002)(66946007)(26005)(316002)(4326008)(16526019)(31696002)(86362001)(6486002)(5660300002)(31686004)(956004)(16576012)(83380400001)(2616005)(478600001)(4744005)(53546011)(8936002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dCtqaExoSVVNZUswRE9jNk53bmxDSVJXYkVCNWtjZ2I3d3g4MGtzNHYyYmF4?=
 =?utf-8?B?SXFXNG52N0hQVFdUcll1ajRNVkhhZVlldytCTHBQaXRrK01oOEV2akQvdG5n?=
 =?utf-8?B?RGFnaWtEMXhrRklhV080MU1BbmZEWkJzYTdCMk4ycENiS2RGV2lNYTE5bzNB?=
 =?utf-8?B?OW51cFdIM2NPUDdxMnhncGxUQlZaYTRJQTRSblRNazR6NVFaUTQxUVRWbTZt?=
 =?utf-8?B?S1RraGVtL09qSlZhOUxKS0svUmErWXpLWnA1azhFRUJKQ2pUVzd3cXVWSDhO?=
 =?utf-8?B?aERERElSYjhkMTJZMXlCMzN0cGVrU0xWRG1TbklKSXZWUlZmY1hGeklIS0Fm?=
 =?utf-8?B?aDNOMllST1dzMXpSNS9MK0V5QTdGbWRPYkFWc3FveXY4cnpuLzJ4NS9kNi9j?=
 =?utf-8?B?aHdTeUpRVCtKdUFFcHpSL0FpcEl5c3hFK2doL3pPQnJGSGtRb2Z0RmFwWlcv?=
 =?utf-8?B?dFBRN1RSRG9PTHF0SEc1MEhUVWVwTzUrWjJRTHNZS3dPcm15K1VWVjUwUmlR?=
 =?utf-8?B?ZUUreHdocXRwSytFT2xuUk1naStGQWV1NU9hTlRNaGhtS0toQmpSbDRzM04y?=
 =?utf-8?B?VVUzOFQxMUdPOEV3T3Q1cE81UDBiUklUREpmdHZXcGI0cU9pTjVRRHZwa1Rh?=
 =?utf-8?B?ang3VGxmTmdwRWxHU1g2WEl0dmdPMUpDSmFNWDkrVDYzL3NVM09hOFB0eUlh?=
 =?utf-8?B?eWlUaHV1VnVKaHdyVjlHWlltQkJPTTdoUGhVRW84V2p3ek0zTkpmN1RBVDZu?=
 =?utf-8?B?azVKaWFDWXZyZytObWx5SkxEbnJrRmpYR0YzdEVpN01IWnV6allYNGVqVDA0?=
 =?utf-8?B?SGFneWV4Zkp0UE5Qam1Kbm4zMVB1WkhnVEthR0s2U21wZGNsRWVQd1EvNmE2?=
 =?utf-8?B?MjJXa1BpeEl2VE1sU0NGWVRaZFgyekRDTndsVk4vTVV6N1EyaEZhU00yc0RH?=
 =?utf-8?B?Vkw0WGRkWjhvRTRuN0dkZmErZEpwc2NlNExTMk51SkpseTdiNW1EUGd0MElo?=
 =?utf-8?B?ckFTb2xTV0VVbjdIajgrRkMvRUM4MVEzeXlmcFh5ZmRheTJmMXRvZEZHdmRT?=
 =?utf-8?B?WE8vYWJoa0FlbFk3SGVTbjN0azhyalQ2ODF1Qk5pUXRVakg5eWh2MzF6K1lm?=
 =?utf-8?B?WUx3aWZFOFJ5NHhJUUxJV3I3azZHWjliYkk4Q3YvYkpoK25IdXp2enBWU09Q?=
 =?utf-8?B?RXJMMmpQNzJrWDNhL1FhelVYc1VCamttOTduZFhSd1dkeFNtOHBRUHk5RXNl?=
 =?utf-8?B?ZEJPUVVKQjJaeUdUKy96S2xHL0NRQjFtd2FnUCtuYkxNelVOcERUMys0bHJ2?=
 =?utf-8?B?cVdCNWZUNWZsTExMUkpvNVl5TXBRaW9iNVJUWWM5L2JqNWN5aVdCSUxvZjRn?=
 =?utf-8?B?cUVqWVE4clBpQm1KNkhKVVFGbUlsY1hQVnlxS1dsbGp0bEk2WjdBc29XK214?=
 =?utf-8?Q?i/0PIvzm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da8ac27-9a98-457f-a57a-08d8bba7edc3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 11:55:19.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCpOy9EeuPk0cdubkBZ+b6Y4qKtFUziSfOU1zZK62vrGtvvphiXfN9lbnidnZosDZZOueoLvTP1BY9S3PY4ZxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3339
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610970922; bh=yEdfpYVHfIWXubdM9Fe9ow4PHbVKBEVGfcE3jCihZDM=;
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
        b=MDNJiiza0lLSo6/NMP1UAQB5Zr4OwhRDpTasWnCYpTc5gUHRVbpOnxCZV5xQbAGk4
         ohFvm3ix8t3o+FLBe0Ia1yqW6UJfKsWZw06YBao1hx+ZfbVriI98lYTcYFK8JWgzZu
         FvuQtdyibWMqK7+xYGjmw9FbtRb9qJ41aFCnAOXklH8K87Uk0Dun7hrOYKLiGHyt8u
         1O2kczoYMR+nLXgi0hRDOvA2lULFJzfVB0bOu7R60EMm52fOHLrbfd2yNsVlrcCkiv
         4MpiIAsnQYeTa7XQUC7I5V8vVteqt2QB9S6jgR1ATaCTKE+BQ6zzKlj+9wZ9knV6R1
         ES72LilMQe9hw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2021 10:09, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Replace some checks for ETH_P_8021Q and ETH_P_8021AD with
> eth_type_vlan().
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> ---
> v4:
> - remove unnecessary brackets.
> 
> v3:
> - fix compile warning in br_vlan_set_proto() by casting 'val' to
>   be16.
> 
> v2:
> - use eth_type_vlan() in br_validate() and __br_vlan_set_proto()
>   too.
> ---
>  net/bridge/br_forward.c |  3 +--
>  net/bridge/br_netlink.c | 12 +++---------
>  net/bridge/br_vlan.c    |  2 +-
>  3 files changed, 5 insertions(+), 12 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

