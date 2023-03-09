Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935856B2BD7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjCIRSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjCIRRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:17:51 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EC359CC
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 09:15:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GzIOu9DX1rRhP+sPNlRQh/GaGHKw7fWsh+q8KEbjdz7N7xY4NHWazAuAYKatIjR0GljaNSwdZ6VWa+kblmLxbW51KmqKsTty/6oN+brNidbEtDOEtul1u5ZgK5bNBniY7GWuKCvyGQEgychTTHAHpaIK+HHBLMCzOgI9GKjA59iBjEKE2byfbT5/QPcOmBh3fyOeOVFmvp30J8Kwnt6XercRVlStKgIrDCPt9UW+Iq2zz1GxKAnLjfbpPyCIY0Vz6ZvDOaf+phgpU+5iJHokeOTZuuXVRQhFc2aeMw+kc3ZkLMQG20o9rae2QUp3GDtiBgmhPMJCyCKLwRXtopo5WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odmvfeSNg3GSysaLzPNGNgFOepS2WLYrkthzHnAs3NU=;
 b=YHS3jev9A45ChdnVORwLa8pnvG/QPpU27f0gEV6gI28odjWK/XipTTGk/ByWrNd5WErig4vQeOhKFW/wML1IP8uEWE26Pou26FUTgjzH9oMg+6iIG+fddHvjdNX4tIcDkHqRPuNOcTB6Ed0XVSirT0bB5b2FPaU9gdy4LYsMDA/yYLMX4Igfkdmhhrdzk9Z0TzS7m1ipi8ClFot5AmYn8lR13qX9o2ylrsv3jnmZKrEQWi/ZpusexmpxW+LcOPG78kBVSGqpgrQFMdkFZxPCVt+btUE4ROHtETdKADJ6ZEt56vw8CXVORT0nFwVS1/2WVCmCceS0QgtDRXEuqFbNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odmvfeSNg3GSysaLzPNGNgFOepS2WLYrkthzHnAs3NU=;
 b=tp27BiMd+JUHWCROacSDljueEfACerBlujdDmj1DAZ+aEPT0UdDSPpG3/4qs2nz5sbCPHUD8ixzRNCzDJrtjuFoRCXrNrU0AquCcpSutwdxkLS3cd3Hf1ZdbYcy7ovUwtvqRvWMcgd/Ve/DVSG6EXl7mp8qAkGZPVyEnLM4eEWEGtl3W+dWpSsPcP8biB01FeX8G0lxckZ+R5p37M3UWDszkfBsJGgm2nitb2eZaw23aUscnvxiasCr8aOsLJicSy+9dxSiP1VR1UHRoQuo3eP/1RLRcA0Vghtv97psC1iOrqMpLpHOryqzPMBEXbkWy4GR80Tnu6Ww1QsdBVZMWDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SN7PR12MB8060.namprd12.prod.outlook.com (2603:10b6:806:343::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 17:15:54 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c707:d96c:a864:28a2]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c707:d96c:a864:28a2%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 17:15:54 +0000
Message-ID: <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
Date:   Thu, 9 Mar 2023 19:15:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
To:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-2-shayagr@amazon.com>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230309131319.2531008-2-shayagr@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0247.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::6) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|SN7PR12MB8060:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fdda0c0-1c5f-484f-6a85-08db20c1f046
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEe6u3Fc5rWhUJqbz1aGE1eexZZoT6S+C7FGMXEXOmCS3gwKO/YVVpXw1NmsW+6mO4p/HDsy+D8WfbXkicqU0YP98Bv5SiHHTwMZJ6haBAZE0j1sg41W91W8tecfls+NyyDuU+IRu2e0GQC7+Jmj6oaf72nnPOkxFjfzrnCwAxdpHtMjSYfP2cFcc2GEbhkjGeIsG9ZTkuXYZOvu+oMydFOKNnJee7eswP2HNNrQ4mWBtU2MQTYopMf05n8MML4KTI2HWwi53MvWDlGsNbwCftjV0EPr7bWuVZs5UXfAygwqw6jehKrVON16PEFtA/dVNq3W7+xnXdJ7zYnE01gWX/igB82mShM2LLqwobe14NqZpD7CulMFN/87xQbxLg1biey4aHi2x21JCgiMEHO74NG3MyiFt64PpHqrhbTInltJRAbYxri5RrO7lYS4aREyjNgP9bPv3o1m7ZBTxOV+f0eEMV3qDL8X3co9BdvyFP3GTGz92YCrXoNhz8hm4suxIUor0lqPq++FksWYOIAKkG0+tua9jNzRZKtFMmVVNB8/j7p/t7raR6SRpPHv/NCt2Ti2pbFfFYizuhj7I2yMI18zpXnt4pAFGhXR4BL+ygMacSbC2eSKgbtErO8oP6cJ7R0PO5qyXbiNW2q1NWJUiurTUxUfSj3XJFMJ+jxsTwbWaSoJ+9wn0QINAfVd2+oZDBQzCanxqyeKidAx7tFPuuySnqWsARcvKaw38YI+Y6w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199018)(31686004)(2906002)(5660300002)(7416002)(26005)(8936002)(36756003)(41300700001)(66476007)(66946007)(8676002)(4326008)(66556008)(31696002)(110136005)(316002)(86362001)(54906003)(478600001)(6486002)(6666004)(38100700002)(6512007)(53546011)(6506007)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFpFZi9QYXJ5VnA2UHBpYkNEaWlhdk80Um0yeGFId05sWWo0aDJJMjdpUmg0?=
 =?utf-8?B?Z0pwWmJZOGJub2U2Q0NweWcrZUFCcDdMQkNDTnN5eDIxWCt3ZDZVTGdxUFhn?=
 =?utf-8?B?aVJudkdlNmU4aFhOMXJZLzBaZkI2WkVnalBjelZSSGVKM0c0bHU0azhaQnYw?=
 =?utf-8?B?aTBma0F3amM1dDRlSStEQ016dmZhaXkvUGdTWGJGRWlxUm5aMkJDYUtsVk4w?=
 =?utf-8?B?S0h1Z1VRNU5DSDNuZVlRNnBCZUFBaS9aZ0FsMFFjc0pzSzhYN3VNRFNKQ3RE?=
 =?utf-8?B?K05SQlNBY1B5a3pKZGhJMVp5OWFOcDZkVHdydXZvYTlkNksrQXlGWTdhN3k1?=
 =?utf-8?B?R0dzc3ZiN256NlVVUmJWTVNsSFZpOElZaTBGN0pUUVpiK0s0UVg5Y1QraUZ1?=
 =?utf-8?B?U3QyR1ltMzhtUWg4UUttaTUvbzJIZC9wMnlSc1l4Y0dQdzJtWFNudmJZWmpV?=
 =?utf-8?B?SzhpNlV4Ry9lc2l5ck1HMVpnK2M4ZzRJeUlCLzB6VFZ0TUt0VzJkWU5oUlB1?=
 =?utf-8?B?UGN2WHFvSFdBYlQ1YldjT2FXMWpydDlJVHNjeGRBVDVxV0lVc3NCWTRZVXp4?=
 =?utf-8?B?NzJCbXFQK0Z2LzhqcjkyTFJTbWhMTThNL3dheHl6bkJ5YTNMcDVZbzJNODgy?=
 =?utf-8?B?VjlRZFpTTHIvd3gvRkxEbk1LZFdOTmJ6bDJ2aE1ZNjc3WW9JUXNmRlptSDVS?=
 =?utf-8?B?d0tFRm44U3hUSmFmdmYrbkUzQWd5bTJQc0cwQ3VWV28vZ2Y2eG9HY25CZWVi?=
 =?utf-8?B?c2V4dThURFg3RW0zbmxsaFRqZjZ1cXFqcFBtOWMyczk1dDBlNjBCV3NJUjBW?=
 =?utf-8?B?dFk2UVJTcnZWZWFLQnplUDVOZjU2RXNJdll0TnNpcnJZa2VVWEZudWZ1OG93?=
 =?utf-8?B?Qmpxb3ltVlhmRXR2Z2JJdGhsR3JhaG1QVkVMajhZS01KU0Z1Rit3UEdRQUhl?=
 =?utf-8?B?MmF1OWtCSEF2bEZNSFRka1pETlZYYXl0b1NiTUwranhlT2dnem9CYmhQS3Jm?=
 =?utf-8?B?c3Z5aCsrL295WEt4SDdoY29jWkpqeHRXb2RFZndFeHFtaUNka0YyeFJzMzQw?=
 =?utf-8?B?cWVLQ1pybnY0N2d1b1pGbFNPSmdHcXdpTWxCYjVLc0xPYnpGSlBHa3pKRUZT?=
 =?utf-8?B?bmd1WEdvTUFpa1dvVG1ML1hyZWhrd2xyUW1lQjF5Nmt2eThFNDQ4YmllcHJS?=
 =?utf-8?B?WWZLeVFNL0dDcDdVMXYxdkZWQlhwLzBkT09rY0liM0F0QjNIZUxNcnhMWmRN?=
 =?utf-8?B?elpxekxHQTZmZWhFbkZrVmNCT2JRajZSRlFhS3lweHk3UjJTL1F6TzVnNmkw?=
 =?utf-8?B?akZzTDJxZkNBY2hRSk5tdHgzblR2bjJTZTd0UFd5VnpLMmxOU2VlNHNITkRQ?=
 =?utf-8?B?UGE4dk8zRHFnMDBJekRtdUZ6WDM3ZllqVTJ5TWJUenROcnEwd2ZNRXZHWTdz?=
 =?utf-8?B?YnIxcWVDMnRpeEt5OGhrbERxQ3BnTFZhbnd6S0s2UU4xdkZiekhGUDFuYSt2?=
 =?utf-8?B?SlhRZlNjUTR1Uy8rQlhnREoxV0ZGK0pjRWJzY0ZiU0M1QUthdks2dTZ2VHFx?=
 =?utf-8?B?amxFOU9GTEt4dE5YS21MNTRvRmx0MGlZbzRvQWpCNEdzdWhGNlVzWlZleWZC?=
 =?utf-8?B?VHNITzNPUDN3U0gwQ1kzY05nMjFDcHRMNG5rSHVkcXM2M0ZURTBCOURFa3lM?=
 =?utf-8?B?bjhuaGZpQkU5amUxK3QrbzdFWWVnbmR6ZmZRSVQzYlpxWVU3aE13d0xZYmth?=
 =?utf-8?B?b201NHJ1d3hpa01ZNTBCTk5oRnFkeHB3b1djMC9aS2tkdG5OSUhScGtpRDZt?=
 =?utf-8?B?d0wrT2tTRTJQaE1PTEZZV1FEZkJwV1pJZ1RFRnc2cVNGMFloUDVXK2h4N3Rx?=
 =?utf-8?B?SXJIcHBpNU9rZnhHZGRqNFVxamZrSmlMc1F1NWJpRDQ4d0VlTm9wT0tWRWkx?=
 =?utf-8?B?NjNYczF0dTNlKzhjd0IvY3RJa0xmS2F5YlBwL3V1VWlOcDVTQWtsajVFRU9F?=
 =?utf-8?B?ZDltWDVwQmFmRUQrYUIrWi8wSlQ1czByeGs5ZjRYMStTK1hmZlJIbEZHOGRs?=
 =?utf-8?B?dkZHVzM3bVZZdnVUdWdUTHNvdzdnNlZ5UXBMdmtqZzVXT0hVM2t5eUpjbUVH?=
 =?utf-8?Q?cxXgtBL8GphVX3S4K/wbBJut3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fdda0c0-1c5f-484f-6a85-08db20c1f046
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 17:15:53.9511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CqDQV17QlnVY2xRvR+i3w05ZYDkgx46A0/EMCYOZ5EtcDQtVy4BHyXuArOo2Top
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8060
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2023 15:13, Shay Agroskin wrote:
> +``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN`` specifies the maximum number of bytes of a
> +transmitted packet a driver can push directly to the underlying device
> +('push' mode). Pushing some of the payload bytes to the device has the
> +advantages of reducing latency for small packets by avoiding DMA mapping (same
> +as ``ETHTOOL_A_RINGS_TX_PUSH`` parameter) as well as allowing the underlying
> +device to process packet headers ahead of fetching its payload.
> +This can help the device to make fast actions based on the packet's headers.

I know Jakub prefers the new parameter, but the description of this
still sounds extremely similar to TX copybreak to me..
TX copybreak was traditionally used to copy packets to preallocated DMA
buffers, but this could be implemented as copying the packet to the
(preallocated) WQE's inline part. That usually means DMA memory, but
could also be device memory in this ENA LLQ case.

Are we drawing a line that TX copybreak is the threshold for DMA memory
and tx_push_buf_len is the threshold for device memory?
Are they mutually exclusive?

BTW, as I mentioned in v1, ENA doesn't advertise tx_push, which is a bit
strange given the fact that it now adds tx_push_buf_len support.
