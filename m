Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AB842A82C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237435AbhJLPYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:24:11 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:40160
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237448AbhJLPYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 11:24:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMptx4GjIXyaintfCmHQmHiEyJcTQY3yUci8TVhsyHbXY73MHSCjP040/NTx5dd6daDWDVrgez3CeOrdaE/TPV2wAse8NlAGjAw6w7c7wHph1Aq+2vfLSWp756JmdrjpBovT2SeRdyLdS0gNgNijN2Tj14zYeHxouvIb9hYjkxwBrkltGUNDD90GOf3oFOLSi0NjjXW/R99PMMMan6Bp2c4bJjOw9OfOM71Q11cRXcWpOAd6Ya0xYF3hfG79pMdoOQqjQpVL25gD4+1FkfcIsRkdQluhrKP6tpx8pRqRP2n1Hur/jc8OnCutel96p7uWpbaKtY5swdWrd4P1HTDQdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gb8dEKq60p+PZzFZrVhTAINYAch6mLhTWofWF/N+i1k=;
 b=DiZcg/t5FXYh7H7WY6WiHwbi9S8T/53c7gyUelSWa4hX0n51g7eezyABpMDWtXfT7m2RFQKMQxAKCNYaC82M2g7H0OVnbwFa5g2msDts6T+L6kk8T10b6Miv6ZBFvuV6IiRf+G40PIfK5xCnEG9GEqlmxbp+yGr9PxhmPN/BDLMvJjqZMzxhTKzODqYykPvAJtCJm8X6RcefGWYROy32lkSD562YLw31kNVhLYHEwaPmLi3f4aGVxtL9jjPwJkj3Ydo1SDN4+h8442wwcPFMEOCOJfkUgBcUCdIkuyAKbx+aLPof3sRGjiejnH+Ac3tnk/rJwHmJMNsLfTT+BOTFwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gb8dEKq60p+PZzFZrVhTAINYAch6mLhTWofWF/N+i1k=;
 b=XM0HnsirQn0ua+13ZBrMtMliH2B3FqrYQcLvjGOlkYfcf/KuOuwFysBlD32PyBFDQuBwLMdBPvKiBpWZcNTHn5vDFgA1FLjW0LjNe5gEcb7KJIWd7+PxrkEXDr4NFs7+GQoxL3w+YS8fSLAXF+tIscpIcP0Qcnw6BKNlYMJFYDTJOQb6ka4/I/FtWltnOkDKwUCpHv+A80Qkd6vo2JPSHTwK07tCEJo3k2h2RuKR/RFKfQno0//PUlDfs7OIJtc5zvYxt9xv7hmvZQXYuKzPueHiYGxxQj3wDmal6O0Ez7mwMOn5KjMhdI80hiCLPJo9Tfe4JZTapmKZdd0OvBaHRg==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 15:22:06 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 15:22:06 +0000
Message-ID: <0641aafd-650d-2f9e-1645-946c347677cc@nvidia.com>
Date:   Tue, 12 Oct 2021 18:21:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next] net: bridge: make use of helper
 netif_is_bridge_master()
Content-Language: en-US
To:     Kyungrok Chung <acadx0@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
References: <20211012141810.30661-1-acadx0@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211012141810.30661-1-acadx0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::8) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.5] (213.179.129.39) by ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 15:22:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82bcac80-aa51-40de-601e-08d98d940ca6
X-MS-TrafficTypeDiagnostic: DM4PR12MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5072E26A4AFB1300BC5429C1DFB69@DM4PR12MB5072.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8y37kavJLALIDzaVKSpqTn1Lz936KOho0CI1PIJyQzOI93gKan3ChLMHj4fiygtKmGSLdA1DJnN5DKK4eYzUN5khne5U4rwbGBd7caGeHNNaZH4x4WyKM4HPH/g1cj4fWdLJN5c4Dawm6QFMhv9J6JetaJ1Dan0WyCeRsM6F9GvirBVpuJryICxQnzXRYzc5BQHh4ho5rPc7lkRaHKba7e59e+ZOBebq7DM6lmej/HZIMkVdAssaXVNXkOfx8Cn/YJIfdCQDiTruGV5I7ZC61pydN9xZyQ65OBP1rJpMZb62UqQlOwEFm0W6qMnq5inCYp5N9JBC6RYT+atQuk+6NVqyHDfSahwH8vwXxll7lfZjaFmVF7DoKA0x7EfWcA3bM/Om5MzU7Nh3u53Nm5C8zyX6mW/fnXUV7xaVcrbrnD2ZNntbYuJ8M5QgbepXUCbU5PyZ2dHSzaEHtTzltraTJmwo+5UcxUfL2Q6tAAzMOq86UYM7xflxFMuzTlF9/pYW19RinPT5FEw4aBFIKPHEq8bqb4PXEXTJ86IW/AC5fdvXQebsq/XFtxp785CjncNJg3S8AnwZ9VKb4hkxNptgBN11L7IAMGskU0xA1tB0Ci+GZQi7z9U8r/q4vfKMZiyf1KJtZpJv/RzlIhHcAGy9lEmmkDZatP5IINIke+6ggZdKeRtra6kFXZWykf5I9Yb47iaPXjZGvyCwNbk6D+OjHODHfFdEpNmpt/B4Z1I8c8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(53546011)(36756003)(508600001)(66556008)(4326008)(6486002)(66476007)(186003)(7416002)(6666004)(31686004)(8936002)(8676002)(5660300002)(26005)(316002)(110136005)(83380400001)(2906002)(31696002)(4744005)(2616005)(956004)(86362001)(16576012)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlhTcGlTOENIeGNmSnNwMHFoellKbXYwVlpFQmhrL2hmdE1lNCszWlZOeE9o?=
 =?utf-8?B?ellhRFU0L0R5dk5TRWhCdWpBeXp5enZpV3Y0alJPMVFrTW1NMHo1dklSMDRQ?=
 =?utf-8?B?NGQrREtNYTc0K0VCb2FqdXVxMHVDK1NxYkNxS1E2eEErZ2hZV0N5RCs1YjZJ?=
 =?utf-8?B?RnlDQTJSVGhpV3FFOUltdEd6L01ZR3pxaWE2Wm5BSUhBUEJhQkRpbTdDOFdz?=
 =?utf-8?B?QnZMUHdndHM2VnZYdGFYc1k4YzlxL1ZNNm9WcTdsUGxrSVovYlc3enduOTB2?=
 =?utf-8?B?OE1FYVhTblpzcmYvRVcrYXhwNTVvYmp6ZnU3RmFWS0pxbU1VT0ZFbUYzMGY3?=
 =?utf-8?B?VXRUZlUyUERlM2RzSVoxQTQyRnBncHNFYzVIbnJxcCtmcUszQWs1MVRxTW1Q?=
 =?utf-8?B?ZEc4eWpmaEZwR3lNUW1VWlh1TU1rQzVrOEpRM2o3dkx1MEhYd3hDdG9jazRE?=
 =?utf-8?B?Q1RBVGgrdzZCNWh5bmsrVXh6VGhJQWVzcTRJV3g5NWFKcWNlV1lpNFpPREI3?=
 =?utf-8?B?eC96Y0Q2WVlUTVk0OS9UOHpQckZ4dmU5UVRhTHFIUmRxU2tMK0F5bnhBZXhQ?=
 =?utf-8?B?dVhFZ05yaGZkRzBIUTkwdGMvWWlvTFYrVDdXd0RxbklyTTRwQVdLdGNLYnRG?=
 =?utf-8?B?L2hFelhXc0FHQXZwZy9wZWZiL2dsNWZzSWxVaVpvZHFPbDQzUE8xWUVpNmxq?=
 =?utf-8?B?Rld4N0dJM3o5c1RKanhpY3V3RTZEN3BqMW1HdUhid1pEMFliZ3NnWmJvenFK?=
 =?utf-8?B?c3hDTVdDeW9leWxnVk9EQ29ER0Y0S1JZOU5MNG9YOFhCRVU0TWNlVUJ1V2pJ?=
 =?utf-8?B?Ky9vS2UrREpsSGNnQStjSmg3TVRWdVVxZFFxZHNReEZla1hRV3lmUXZyYVNI?=
 =?utf-8?B?Rlg4dEF0SXdtd1FXZSt5Tnpta04rUDZrMWxpVHR5TDJpK2dmYk9qYkVFRW5a?=
 =?utf-8?B?b0ZNVWJNZmN2NitaM05abngxcmxxREtRSlMrWnZBdnh0M2RqeldBVTVqUFNm?=
 =?utf-8?B?aHBwamtHL2dZQVRkcnZud2VyK1oycFRjUUwwS2VVQTlUWmgxbjYydGpZY01D?=
 =?utf-8?B?aW9wVmI2ZUJrTHBVbE1POHBwdjk5VHl6bVRvTE5lV01nVG1EWCtRbmNvbTdO?=
 =?utf-8?B?LzlsbzBxYUczbWZoNHcvcVV2eDd6R3hRNkVYQmdRZmpIMUJWKzV4SytjRjM1?=
 =?utf-8?B?YUtEZGJlczIrVHpjZnVuQndOYXRuVlFmQ1VqcWs3MktXTkJFUTFCZ0pmZFJV?=
 =?utf-8?B?SkY1UllpT2NrWVIwSGpOR2FwTGNhb3IwZ0h3NktzOHBMSU1zNGc5M3MxNXRs?=
 =?utf-8?B?dWVEbWE3VjByeExRMVZoUi82WUQ4OEZsUnhuY1hub1ZReXAxUDVvSUxyYzEx?=
 =?utf-8?B?a1FiWWpSbEd3Sk9RS0x1eWNVclNOVlRHelVxOEtXRzBoWmwwb0gweXE4OGFZ?=
 =?utf-8?B?WCtOQUpXbERENUxJKzV4LzErTHY5QW5UcHRDS2h2ZzFFSHpPdG1SMFVDTGtl?=
 =?utf-8?B?K2FaSjUrczBsTVkxU01ET3lJVFdKS0E3MTRJUGtySE9GMHI0aE1adjJVRlFt?=
 =?utf-8?B?aUtiQ24rY3pieGpocmo2eDNZWXJiSDBRT0t4LzUwVkdaazVPMkIyVktXNG1N?=
 =?utf-8?B?Z01tb292S0JHaW5IaEgzaEhCY21wYnM5SFBwRDJ5aFRyRmYzQUs5ZnRidkFM?=
 =?utf-8?B?UmdHQ3dmcVRraGhrWXMxWWE5cU9NL0Q2S2kwNnZEK1M2c1Q1Sm85bEdXRmtZ?=
 =?utf-8?Q?kw0uXKODHAl9Q1LLITzcSpJfrBUWpswIvKjR5tZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bcac80-aa51-40de-601e-08d98d940ca6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 15:22:05.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SyxcKqEQwMtXDoTg9IiWdvAQUM3LfxsNyoQUgWyp0MRc/LU2Kx79ITWJIl1+GSJFIooBR7Z3q8mSC8kHf+qqgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/2021 17:18, Kyungrok Chung wrote:
> Make use of netdev helper functions to improve code readability.
> Replace 'dev->priv_flags & IFF_EBRIDGE' with netif_is_bridge_master(dev).
> 
> Signed-off-by: Kyungrok Chung <acadx0@gmail.com>
> ---
>  net/bridge/br.c                 | 4 ++--
>  net/bridge/br_fdb.c             | 6 +++---
>  net/bridge/br_if.c              | 2 +-
>  net/bridge/br_ioctl.c           | 2 +-
>  net/bridge/br_mdb.c             | 4 ++--
>  net/bridge/br_netfilter_hooks.c | 2 +-
>  net/bridge/br_netlink.c         | 4 ++--
>  7 files changed, 12 insertions(+), 12 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
