Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E48869C9E6
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjBTLcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBTLcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:32:08 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BE314E9B;
        Mon, 20 Feb 2023 03:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bff/5XIICrrisOnMSKE6dF95dqiOkytOqY31MUpzJytsZkFhI8mV8A8njBGrthhdzl5rPQf0yOzMdGzLgX7yfAgWWwPktDgtSg7hYYdUuWB46WBDLE7VPMN5AuzrcinRTThEr2XhjonwWtl+OeBGTmwK9U20iXfO63p8y1he19mACFfP4m9aaMG+tVC84Pb3PZtNbCecJUF3j8HyKbnLew24szLYPMqOyQ8AZGPHrzZ1xWpvD+pWAw9KasOzniGfaW0c52ymcIa0V4gtX7VXR0D7SBhwTDZqmxCeKlBFjhm9Y1znDEIEHQnvrIeHbyTsFdzXKCtPu94yWj6h53/Qfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=br5yXT0/UNcCqQ1Y+fQEcJfujmAQQTimlhNPlHuupbw=;
 b=EiY3aT+bbTDNhLmu7uOqFCPF0BS8Zk5goJcidWSmWoYV5VgaIkTvKTkrFZEKBtpMuQ8c4P2TwiHSu31vUpuGMkR5ulDiP+bQPpgoLgv0aQGp7IspKxneOSHcwTkLhT8Hnqfit2mN2lEDFlM0M5xOrOzkkS4YXZKtwrYqtspJ+uzidahMP1EVhygy1UXu+qt+DgMXx4jJeQ71lR+Xa5j5LSJjm3NwfO2n3Wrjg66u9DrXbIIfhFTJIi++1qXWlb5Hb5bgLas9ees3X3ryKoxCCjhw6LpbzaIsRBWiyXZrolIsiUSsRgxydAP3QUpLk3M5PTkLhGudHKhGuupgItmhIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=br5yXT0/UNcCqQ1Y+fQEcJfujmAQQTimlhNPlHuupbw=;
 b=gb9xv6XWzqYQmc8kmwi6tO5TlbaJ4hSb6u9R7/UN4ZeMxWMKWfWgPsUFMwEIS9IMz8aIiVWNO7UCut1zxR7OSTxJU5Zrkneoumneu+Fbb2cBui8wlt2NQe5D1P9YXxOmeedIMWMY0Got7SDpO+0sHxDgZsu5Sjw4n+JqHPdeARGqWB72txhVwxDoofJYgDnMRypTeqNqVbXPWumpoTyJDS/LHvN/9UUwe6KR4IMtv6E+FYW6FgnrjjQRizdU8lGxnD8Oh2sjJWKqLESOKFmouzHh8cFxjKKBnY08PLyy/4JJvHBVW0E7aJTRUcMc4rkrLPpeAy14gOamvRHj7EHr8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by IA1PR12MB6258.namprd12.prod.outlook.com (2603:10b6:208:3e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 11:32:05 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 11:32:04 +0000
Message-ID: <43d3415d-9d55-244e-5e32-4ae98ee7a5ba@nvidia.com>
Date:   Mon, 20 Feb 2023 19:31:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v1 2/3] net/mlx5e: Add helper for
 encap_info_equal for tunnels with options
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-3-gavinl@nvidia.com>
 <611a9a70-0f6e-cba5-dcb3-3412e6e9956f@intel.com>
 <40a616a5-f350-2ac1-eda1-7e4c777ed487@nvidia.com>
 <85172e19-5344-bc30-e6a4-aa39dba3b50b@intel.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <85172e19-5344-bc30-e6a4-aa39dba3b50b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0043.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::31) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|IA1PR12MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 387884a8-102e-43e0-2ead-08db13361770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DeKb44eIRVdqn1iLMLs4IDdmCump9t8FDrZyL/kGM24zxn/wEMJC1fdtmahBmJeMZtgxjCmq6DG0IeCotf94dlWtfnir5YyWQ3uEzVdPq6yu+PqGhokDd04q4FvgPipER/w28XP8N9Smywe04XbGqIotOMJililLjQe1M9MHvhvbj80hhY/Chr+1B2o7VljFF4jvBIs/LYoBjM+nV4xWltGBYoJ6bLwEW1i9kKn0ef28f0kv0s3PUlgwHa/1uaAnrjATnrpJQepaW1KYegcjl3mQxWZGkoiNiRU+xJQPfiRbk4bd2mM0j8ZVoWfb7z28Y/w5T2NSGU2VzZO5ejLcxSyxsKmp5kms+m6X9O1UtJmhhsQlrw2E24NbNQsCy+TfsdCFJFM4pX1CJdQAufYrif0n6Srb5YfXLElGhj2zZPKRD13+uR4+hDhRN+QsJblioX6m9V6UesSDWQ2Xl0Jm93gYA3lnj0r7/VCEyTce6PLEu5sr2vyqej/KL8CxaVE9qzogZ2TvsF6/j4Emd5iaPPg173NacQlU6lf7I4NXg1vbxAfX9NXH5XOxd0Ce8qphT7ve521EIJKEYR5AeTlWIwkpPD1KcqraVHBlWlbNJfg/Rfn2ERPESkgm/STdTMS3E4/247vbo0diNUw3MINxeKFDg6cRR5Huwl5XiJWJFHvJSlXng/RAvPosaqNiUfAVMsLNnfIXldz+0yl3I2VU+aGKzlgE6Ln0DinOlsDnVtw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199018)(54906003)(66556008)(316002)(66476007)(8936002)(8676002)(66946007)(6506007)(6916009)(4326008)(6666004)(107886003)(41300700001)(2616005)(53546011)(26005)(186003)(6512007)(478600001)(6486002)(36756003)(31696002)(86362001)(2906002)(5660300002)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDNUL1ZSc3J5TUg1eStJVklFVHdrLzBSL2hmWlB0Si85NE9RbFcwWEUwT2Nk?=
 =?utf-8?B?T0IvcDZUcXR2dUlnRFdiMFNOSEx4allZU0w0V3FqSVRGeFpQc0thQmVJcUJO?=
 =?utf-8?B?NkI1RFZTR3NPQXZzWWFETlYzTCszbkNrZ3g5bGdkYjVDNEpVRk9CS3lLSkJJ?=
 =?utf-8?B?MTRxZldlUWFpOG12U0E1emFYNTEyQXVXWWVIcjVNOFBTSFM0WjNPUWR6RVNS?=
 =?utf-8?B?YUtCQ3RVaGJISU12WFRuenRmUHN3UFV4MFBZMUlFaWVWd1pSa2h3RHhxVW1i?=
 =?utf-8?B?dEtpOHVYdGZNM2x1b3R4RzlFREN3dFdtR21GUGdOUmJFSEZnd1hTM1p4dlFW?=
 =?utf-8?B?N0xCUVBONXlocVBtZyt5SkdUSEtpbVRiU3M5aC92YkxPdFl0c3dwU1Y1bGdz?=
 =?utf-8?B?NDJtNGREbEJ4QTBqVVRHYndhR2EyeXppcnZadCtBOEQ2SEVOMDUrekhxU3hN?=
 =?utf-8?B?ZklpQWtZZTlMRlhBK3c3V24vWGdWNUV2MXh2SWxNcTF6Rm5ENjhvWHhqU3RJ?=
 =?utf-8?B?RGVHUW96bEE1S0dxVUtLQVBBUU1SVDlqaFRKbGZpMlpYY0tqM1ZpUThiZnk2?=
 =?utf-8?B?a3hkUnNoYko1aXZ4OHg2cTdNKy9SNlNOVjMwWlZ0YWVoQ1UveUFDQ3YrczF2?=
 =?utf-8?B?T2pSSHhYa04wcVJWMk5pMlBpdWxwazRub01sYkl2QmhnbVpsd056Tk5jdTFQ?=
 =?utf-8?B?YXEwbGhqMzdPaFFCWXpCK1MwL0laL1pQaHJ4bUl0eEFaSkoxbGJaQWFPZlZZ?=
 =?utf-8?B?NEtWZFU1ODBsRkI4anNsRHNJL0JWSXFQMWFJdVBuVkszME9GK2RFdUJhdm1y?=
 =?utf-8?B?a1dRNVZjY1NmenV5ZExWd3piVWNaY09LTHB5T3RpQVpHVE56N3MxVlpITnVR?=
 =?utf-8?B?WnRVR0YvNDJSdldXY0RlWlFiVzVTb3ZNTDVVRDUycCtHcHBDemphbzkvaS9C?=
 =?utf-8?B?YzN1THhmVkhnQUo5S2R1Mmd3dXUvTEt4MDlpckR5ZnF4eXljOHZjYlRvckln?=
 =?utf-8?B?aE15RExCNkluZU4xTlk4RUUyWDBNWFpWcTFJOTFpSHV4LytmVFFlTEpzczJi?=
 =?utf-8?B?SHZnQmhORWNyUmxDSzVoVGdFNUgxVXo1dXVJeVZjOE9YV1hOdlA1ZmdyMW5v?=
 =?utf-8?B?NjB4dGVMQnIvSy9lQnRxWEFLY2JrMVFCeC91OVZKWHkvYnM3NlJQK3Awdmh3?=
 =?utf-8?B?OVNiME81K2dTUTl4UVYzcEJscUczRHo2L3NDN0t2WGVYVzFoa1lkTzdmc2V5?=
 =?utf-8?B?cVp1WVA0N3VacnlpWUpSTFRtbGhlQTE3SDlmL3JvTG5mRFA2U0tBYUtWSkpW?=
 =?utf-8?B?YStLMFZLY0pQT0JhNnhZZ2RBcUNjbFMvczhjeHdzZ0hHcXhuaFRLZk1FVkVr?=
 =?utf-8?B?U09RdnZSNXlIUkxiNXJLYU1TdUJ2bUpYcER4NlRhZnd0d0JJN0o5Mnd0L0k0?=
 =?utf-8?B?U0ZqV0tGNUxObFBoR3RFQmxGNm8zMGkyUUJUMklFUGdZcU51UTQwOUlrSFht?=
 =?utf-8?B?b0gwdUtKc1J2QURTNldudnhOdFY4TkRnTFdxdXAraFhFUU1VQThrYStNQlI5?=
 =?utf-8?B?QVhUUjJ0dWRubXplR29yeHU0ZWFVdnJmR0VlNWR4MWViZC91YmJRYjl4SDZk?=
 =?utf-8?B?cFl5NC9sajJZZXo4d01WNnJLVEVkMmp4dk5od0RMZXN2NmJ3Vng0bFJMUG5O?=
 =?utf-8?B?THZOU25EQzVuUUplUkdrOFRpSUE1U1N4NVU1VmxlUUNJYzQyYmwzOE5SdTh5?=
 =?utf-8?B?bnpEbXZtcm5MbmNBdjBoQzJHT2JXeXFxaXkxVWdjZ2xKbkZlNmxaVUF5UndH?=
 =?utf-8?B?QVdDTzNOSWJ2RTcweXpGSDJKMEpnWUwzcFpzZERQUFFyV0ZkMjVaaTNhazl3?=
 =?utf-8?B?VjEzTmY5N2E3NFY5R2NBUjl2NzVFRzB2blg2cnA4eDVCNGQ0WUlsUTlWL0k4?=
 =?utf-8?B?ZXRrV000bElLUVN2ZWo3cFdMSSt6M3BBdExBS0RUR0FJdVo3SStDZ0s5bDRs?=
 =?utf-8?B?cXdmbGRmelM5T3FEZ0RyajRRSnVucHlWYldMeFozZE5HWHNSbTVDdzRQdkVo?=
 =?utf-8?B?ZG42ckhWbC9BalNkNWRsZnlnNVlYMXpIWllPcXBrZU1YQ2pUN2pkaFdrcVE3?=
 =?utf-8?Q?zAfmepms5MnLJecU5ejBv2qAF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387884a8-102e-43e0-2ead-08db13361770
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 11:32:04.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3TFDIjPO/f86nOZvRcM/u+AXBgaTNYLTHSU8eLaZbRg0SGWwFm3rjFGHz2LeJrOdTHwxWKfSHBpykNIX1cUYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6258
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/16/2023 12:56 AM, Alexander Lobakin wrote:
> External email: Use caution opening links or attachments
>
>
> From: Gavin Li <gavinl@nvidia.com>
> Date: Wed, 15 Feb 2023 10:54:12 +0800
>
>> On 2/14/2023 11:01 PM, Alexander Lobakin wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> From: Gavin Li <gavinl@nvidia.com>
>>> Date: Tue, 14 Feb 2023 15:41:36 +0200
> [...]
>
>>>> +     if (a_has_opts != b_has_opts)
>>>> +             return false;
>>>> +
>>>> +     /* options stored in memory next to ip_tunnel_info struct */
>>>> +     a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
>>>> +     b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
>>>> +
>>>> +     return a_info->options_len == b_info->options_len &&
>>>> +             memcmp(a_info + 1, b_info + 1, a_info->options_len) == 0;
>>> 1. memcmp() is not aligned to the first expr (off-by-one to the right).
>> Options start from "info + 1", see ip_tunnel_info_opts and will use it
>> here to replace the "info+1".
> Nah, I mean the following. Your code:
>
>          return a_info->options_len == b_info->options_len &&
>                  memcmp(a_info + 1, b_info + 1, ...
>
> should be:
>
>          return a_info->options_len == b_info->options_len &&
>                 memcmp(a_info + 1, b_info + 1, ...
>
> 7 spaces instead of a tab to have it aligned to the prev line.
ACK
>
>>> 2. `!expr` is preferred over `expr == 0`.
>> ACK
>>>> +}
>>>> +
>>>>    static int cmp_decap_info(struct mlx5e_decap_key *a,
>>>>                           struct mlx5e_decap_key *b)
>>>>    {
>>> [...]
>>>
>>> Thanks,
>>> Olek
> Thanks,
> Olek
