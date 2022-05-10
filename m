Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D955224A2
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbiEJTV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiEJTVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:21:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0330167D6;
        Tue, 10 May 2022 12:21:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+R3tV+2LD5V29izQvJHOVeYCjFAg05xra0z1spVuGPOlPV/JxZlDH2te1b5NP4gUu81oKSSPnWyhTAzA6S2MrtRwxjXANZIqL+rO37SANfHMF8JANcsi0HWtCDN6rg/Q5qPnBwh3g7eC4pDDWJLayV5Bgb7BKc83/kJFjoxx24I8q6nT9/W1zBrX/JDWNwqBjdDzSiqZ8ppvErC5dlnmmJe2wqXP3eYz2AiKsa/EfCxCTDvSegDxmuXkWkwK6Fpe8vPhSROExcW10rQcpwycgjhy12OFEUZ5sIpgGxiOkDgfZfEXQT55rAZZ7NJM5GX6Sv2g8AAJMOJxkNGVAcAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QHzu9uOVHyQgXvlTyrvAvBEcksmmoAWAyb1CQ2ftUu8=;
 b=n6EcJudBVBKbmwr02ZGBVfVgl8PSgtQsClZA2g8hS7g87keeOZgxFzUZXAk/knuFt3UtR28TP9ewofDy1YVlqJ/fJ1Gc/YiHMJ+1g3Zty64vFmYD+USZrLTj8nnYr1/q/Mk2SPPTq1luORM6RziqZ8SnccWNPLR47GsCfD1OL75Sbpo4zYYM0fEH9/KyXQQVSLdOWVTRwWnE/jSPM+Z2YVWE9Px3yKchdMC5nqz4AVKDwR3VcnS3jPriM3pe12NXFsuAgfuG9SBTcoSZR+1JxLQZvy8JaRgLzev3E8mhG6ddMrXYN9J/xr7K2rjK0fWUHwQFFkkIwTIRaCJwhA/gdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHzu9uOVHyQgXvlTyrvAvBEcksmmoAWAyb1CQ2ftUu8=;
 b=e3l0dTnM9KEfKdeAlB8Dq9iQSeo+WK0rz3Rut8GXppR6DkyxLARAz7vT8IJjxeDHqP8QgHPxQaH/smKSkCYiP5/i7RrfukGKrXETujkJmb+zqYKW2F7Yyo1qZ5nv71dMrFUhiJB5oFptoNW/4MFoJ/RJ9QZvnH+dqu5hSoID0UfPIt70x7wW0G/gMtM5rth/BNaQtXHNatReAXBK3WBe6bBP5Gu5UDfQ+I88TS9Pv2G9d3umq1M3yRvkggdCojER/fGnAPFgzfua4Aa7ur8LrNJGsNzZjUsGm4z0s5aCwoj5W7/bx5uFtJY2ux6mYaWXtff0raSFa1Cboh9PPDjvzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BYAPR12MB2855.namprd12.prod.outlook.com (2603:10b6:a03:12c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 19:21:18 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:21:18 +0000
Message-ID: <59947338-cb4a-f437-0148-8ed0b83db442@nvidia.com>
Date:   Tue, 10 May 2022 22:21:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH bpf-next v9 4/5] bpf: Add selftests for raw syncookie
 helpers
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
References: <20220503171437.666326-1-maximmi@nvidia.com>
 <20220503171437.666326-5-maximmi@nvidia.com>
 <CAEf4BzZoBjcUqf_X2zNfu5ZUL8uoV3=hqD5OQWptohbXVTT4gg@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAEf4BzZoBjcUqf_X2zNfu5ZUL8uoV3=hqD5OQWptohbXVTT4gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0087.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::20) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42a98cf4-51d0-4ef4-406c-08da32ba421e
X-MS-TrafficTypeDiagnostic: BYAPR12MB2855:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB285599BCF94A1F0C463D1C20DCC99@BYAPR12MB2855.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8SzHpzVnDXDIFu6rJ1iXFIDMi63ozlzOUciy9ekLTAmf27sC7vhVdZ8636YH+RPAzLK/xSEByXWuMv4jmRxCP71HYwbJjdYvRJAyNh1j7biRu8fLab6qOsTJfgypfuWwYvgPvXx2yuWlHBmSaEp0BwnL82BViaWX4ICcoZ28STThArd1eqE+OzCGQoKkIg4esN9R9bqywSIAbTAg4D1bAOw97s3OCbWNFtidFhglbberES9etoMnugTaM2V2rpYrroe3nUWYd6wEqfJmRhwukco+JXgfY75wRiM2NMFhT2xhN2Dw+8dI92Z986CZfsIT87sqommrefZarv5O6IZX0Op57wA1vvjzsQLVRXtIJmyHARjT6bjwQiA/B0pEg7ZY5CrWSt3W/6PmHTpivfkgb+2ud9DSGx8zMjjeNeDwSHVQjFnP6wrHyyywmQYqMo5mFW3o13RWF+Eoc8isgQlKYm8pgSBthzUS78hX6hlvW+2Sjj0bqOezCSAIvCyZMKsfs+IWj+GSG4u+a/WQD0zbh9Prwm0B+GvkNFRUy0yEA47oRaGHpldXgHQtz4AFW6sopj/dDy/KT3ReY+TbYQEQc49UxTdkcSTepsLN9AIhKtiHZETfO1kZVWjn2yz5EdcBb+Qa+YA/JDp4+OAEx+PWkedLULU6IpiAo6kvPd/2L7puhyhjM824JQhwvnPJRQtHjgMIUSPY33V+7BPa1RyYLuFAtvrK7ZG5xnL72pKwl6Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(86362001)(38100700002)(83380400001)(6512007)(26005)(31696002)(2616005)(186003)(66476007)(31686004)(66556008)(8676002)(316002)(8936002)(4326008)(66946007)(36756003)(30864003)(5660300002)(7416002)(2906002)(508600001)(6486002)(6506007)(6916009)(54906003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckVhL3F6MTdTN2pUTy9TWFJGaVJlK254b1R4TjU4L3JITG1yU0I1QlZja2tP?=
 =?utf-8?B?dGl5emxRUlRLeGN0MS9UTjBpYnRjV0RSd00veVZGWGZ0Sys0cXo4TVdJdHcr?=
 =?utf-8?B?R28yRXp4S1oxRzBjcEcydldObFgxdmFUMUloS0FCSzdrT1VDU0VmaVAvQW9L?=
 =?utf-8?B?R01NdUJadGY1MmNKeGJkdDk5UGtBT0lwbE40cHRBTEllQkQ2YXNFTDY1WENq?=
 =?utf-8?B?TXFmV0NzbWVhWDY0Q0FrRi9hN3ZmdDNNTDgxTjZTNlhPWGxRcHg5aHJZdENB?=
 =?utf-8?B?d0hSTWRtUENZKzJ2ZGpWMGZHVkNVRFVvTjV0TXJIUkRndGVZMWVNc3creVd3?=
 =?utf-8?B?Tk50Y284RzdJcWVZZ3ZXMm9oVlNHVlpqNStnRmRUdjZBZk1UOXo3VDNGNDZ3?=
 =?utf-8?B?dStyL1UvR1lDc3FVeW5DV01uOTQ0N0hwOWlha0lIK2pwRFYzTmNYVVd4ako4?=
 =?utf-8?B?NGwyTUdGMFFDK3hiYVZQSDBPYTFPYTIxeFRyaVhCZHVNcHJLMWMvZnFUQzJW?=
 =?utf-8?B?bGRRb3RvMkVOTXRiV3N1Ni81YVZhSmxvb1ZtaHJUZFFobDBFb25hY2hWUlkz?=
 =?utf-8?B?eENldmpuQTZ4b1Ficzl5cC9hNFFINzF4QXU5NVhJcjRvQkRsNTg4ODByamxZ?=
 =?utf-8?B?SnRqYTVWNVpJZFhSWXJmNHowY2xDaCtaUi9Cc0VTV05xYTdhYWIzVWo2MGww?=
 =?utf-8?B?My9SRE5qZ29ZQ3ZnQUVDU2w4QnpiWXBLbGpmZUt1U21RelhuNXlmZDBWNXpn?=
 =?utf-8?B?Z1NpK0poalR5aHBjeTkxaWhaR0k3T1ZsSGExUmVPR2RSK3RCTW1BTWgvRC90?=
 =?utf-8?B?Y1gyVjd2SEE1MkRDWG5SeVd6V25aQ3JrQUcrclo4TGdEU28wLzBFMnZOeVdh?=
 =?utf-8?B?V2xNSEUwdnJ0NlFhYmN5dDNBMWYycmxvM3JaKzM5SEJ1cDRBa0NxUy9oRE4w?=
 =?utf-8?B?VFRib0I2S05wNTVTeW9qT0FjZ2psRkFSOXVYQlVVaExPbklFdEY0VlJRQ3Nk?=
 =?utf-8?B?YldFSlR1UWNzR1ZPN0VENVlCbktueTY4RE12d2twUzhzQ01rK3pLdXBBWXp5?=
 =?utf-8?B?SmVGOGcrWWJlNGlOelNOSUhrTHQ0R3hxWm5ROFZUTHg1VENFQm4vTDBWUjN5?=
 =?utf-8?B?MVhESGJVY1AzYUxJcXVGUnBFQWpMKzRXQVp1bVY3bDRwMUlDalBXNkV3RWtJ?=
 =?utf-8?B?OEMxeXExQ051N3ZlUzQrTUdXd2Jwanh5eUsrQzFSUlA1UEp0SHlXNGtJNEV2?=
 =?utf-8?B?TENVdDdoTWgwNmt2a3VHcGd6aGxzNng1MTB4UjUrYVNQbWhuU0RWanRUQ0l6?=
 =?utf-8?B?a3ZMZFFqZGVMcmtVcVFaOUN1RjBsc1Y4cnlJK0NWcGFNYTg0U3BBcTBzRmp1?=
 =?utf-8?B?U0JkWURaUExEZGMxYm5INSsrZ0R4bHVZOWZpcjZMaFN2WXRCVGdINUhvMUwz?=
 =?utf-8?B?OFcxSWRVVk9uK2FjeHA5YnF2RURpRWR2TCt3VzZvajVLaWNJYTBINnRmNXF2?=
 =?utf-8?B?dGxIYk9iSlRFZFh4OE9GbGNhR1pnOUJab0tFZUFXOHhjdDR0RklXaElhK0NR?=
 =?utf-8?B?QjVid3o0SHJmajlGUGtTa0VCZUZNenU4Zjg2bmhwWm1ZSmVUU0JpcHZvbkJK?=
 =?utf-8?B?YTY0MFZscDRZM1I2cWx2Zyt1T0JQOVhvNVV6QjhqY0g3WCtFdVpsc3dSM1dv?=
 =?utf-8?B?aHBjV08xQTg2c05vMUVtaG1oNXFpQ3FNMHczZzJQNEw5ZzUwdTVDREhMdjAv?=
 =?utf-8?B?WDZwMmloc1FXd2pTTVJBc1hxeXRaZkZ2eEtZcEk4NnZDbEJieThDQjY2MG9w?=
 =?utf-8?B?MjJUOGIzYUl6RHU2QWVvUTdJdjIvczdrbjd5ZGtsbmlkbld3MTNrcGxFdDVK?=
 =?utf-8?B?NDBlWEYrbjBadmNTdkhPdlZyWG45anlnMnV4SlFSSUtaN1hPNTdKWFMyR2Zm?=
 =?utf-8?B?T05ncEhLb1dsSnRycjJnMkxndnNsZnZZZjR6NDZGNFJFRmxtT0ZybEJCd21p?=
 =?utf-8?B?bnRpMHByYmk2eHhOY1BKV0ttalBoWjIraGhDSXlzdkdTYlI2YVJ5ZDExYmdn?=
 =?utf-8?B?L3RiS0U2dUN1RVIvT1BmSVVMZ2xlU1Mzekc1L3VVbUpkQnNvcmREOGNYTjRj?=
 =?utf-8?B?U2hwdXhuT0ErZVdhL2s1dnEzcXd6RlM3LzRNVHJFVHlHUHFoZ05qMC9OaGNj?=
 =?utf-8?B?bDJSbkdmbHU1TC96SnpINkpHQnJnVWhWbDFyVWZLSWlZdGVwMnRsaGNVdVpo?=
 =?utf-8?B?VTFRYk5yNjNLdVhMV1RxSVZucGhHVzJlWElwTVFkZVdXT0duMytqclNpV2JC?=
 =?utf-8?B?L0xrYzJKVlhOSnNjMjRXemQrZUwxcUN1SWZPYVRnMmRWb3Y5SG4xQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a98cf4-51d0-4ef4-406c-08da32ba421e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 19:21:18.2962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nnhuDFOvQqqsWB4b8+ZEhiV+tB03GNPvqukOpXvmwDvG/gbSjEG6AZaDhMdpbQ1pLOsztgaOOYpeGW5NoQni6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2855
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-07 00:34, Andrii Nakryiko wrote:
> On Tue, May 3, 2022 at 10:15 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> This commit adds selftests for the new BPF helpers:
>> bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6}.
>>
>> xdp_synproxy_kern.c is a BPF program that generates SYN cookies on
>> allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
>> iptables module.
>>
>> xdp_synproxy.c is a userspace control application that allows to
>> configure the following options in runtime: list of allowed ports, MSS,
>> window scale, TTL.
>>
>> A selftest is added to prog_tests that leverages the above programs to
>> test the functionality of the new helpers.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
> 
> selftests should use "selftests/bpf: " subject prefix, not "bpf: ",
> please update so it's more obvious that this patch touches selftests
> and not kernel-side BPF functionality.
> 
>>   tools/testing/selftests/bpf/.gitignore        |   1 +
>>   tools/testing/selftests/bpf/Makefile          |   5 +-
>>   .../selftests/bpf/prog_tests/xdp_synproxy.c   | 109 +++
>>   .../selftests/bpf/progs/xdp_synproxy_kern.c   | 750 ++++++++++++++++++
>>   tools/testing/selftests/bpf/xdp_synproxy.c    | 418 ++++++++++
>>   5 files changed, 1281 insertions(+), 2 deletions(-)
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>>   create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
>>
>> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
>> index 595565eb68c0..ca2f47f45670 100644
>> --- a/tools/testing/selftests/bpf/.gitignore
>> +++ b/tools/testing/selftests/bpf/.gitignore
>> @@ -43,3 +43,4 @@ test_cpp
>>   *.tmp
>>   xdpxceiver
>>   xdp_redirect_multi
>> +xdp_synproxy
>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>> index bafdc5373a13..8ae602843b16 100644
>> --- a/tools/testing/selftests/bpf/Makefile
>> +++ b/tools/testing/selftests/bpf/Makefile
>> @@ -82,9 +82,9 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>>   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>>          flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
>>          test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
>> -       xdpxceiver xdp_redirect_multi
>> +       xdpxceiver xdp_redirect_multi xdp_synproxy
>>
>> -TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
>> +TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/xdp_synproxy
>>
>>   # Emit succinct information message describing current building step
>>   # $1 - generic step name (e.g., CC, LINK, etc);
>> @@ -500,6 +500,7 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c      \
>>                           cap_helpers.c
>>   TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
>>                         $(OUTPUT)/liburandom_read.so                     \
>> +                      $(OUTPUT)/xdp_synproxy                           \
> 
> this is the right way to make external binary available to test_progs
> flavors, but is there anything inherently requiring external binary
> instead of having a helper function doing the same? urandom_read has
> to be a separate binary.

If you remember v1, it used to be a sample, but I was asked to convert 
it to a selftest, because samples are deprecated. The intention of 
having this separate binary is to have a sample reference implementation 
that can be used in real-world scenarios with minor or no changes.

>>                         ima_setup.sh                                     \
>>                         $(wildcard progs/btf_dump_test_case_*.c)
>>   TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>> new file mode 100644
>> index 000000000000..e08b28e25047
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>> @@ -0,0 +1,109 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <test_progs.h>
>> +#include <network_helpers.h>
>> +
>> +#define SYS(cmd) ({ \
>> +       if (!ASSERT_OK(system(cmd), (cmd))) \
>> +               goto out; \
>> +})
>> +
>> +#define SYS_OUT(cmd) ({ \
>> +       FILE *f = popen((cmd), "r"); \
>> +       if (!ASSERT_OK_PTR(f, (cmd))) \
>> +               goto out; \
>> +       f; \
>> +})
>> +
>> +static bool expect_str(char *buf, size_t size, const char *str)
>> +{
>> +       if (size != strlen(str))
>> +               return false;
>> +       return !memcmp(buf, str, size);
>> +}
>> +
>> +void test_xdp_synproxy(void)
>> +{
>> +       int server_fd = -1, client_fd = -1, accept_fd = -1;
>> +       struct nstoken *ns = NULL;
>> +       FILE *ctrl_file = NULL;
>> +       char buf[1024];
>> +       size_t size;
>> +
>> +       SYS("ip netns add synproxy");
>> +
>> +       SYS("ip link add tmp0 type veth peer name tmp1");
>> +       SYS("ip link set tmp1 netns synproxy");
>> +       SYS("ip link set tmp0 up");
>> +       SYS("ip addr replace 198.18.0.1/24 dev tmp0");
> 
>> +
>> +       // When checksum offload is enabled, the XDP program sees wrong
>> +       // checksums and drops packets.
>> +       SYS("ethtool -K tmp0 tx off");
>> +       // Workaround required for veth.
> 
> don't use C++ comments, please stick to /* */
> 
>> +       SYS("ip link set tmp0 xdp object xdp_dummy.o section xdp 2> /dev/null");
>> +
>> +       ns = open_netns("synproxy");
>> +       if (!ASSERT_OK_PTR(ns, "setns"))
>> +               goto out;
>> +
>> +       SYS("ip link set lo up");
>> +       SYS("ip link set tmp1 up");
>> +       SYS("ip addr replace 198.18.0.2/24 dev tmp1");
>> +       SYS("sysctl -w net.ipv4.tcp_syncookies=2");
>> +       SYS("sysctl -w net.ipv4.tcp_timestamps=1");
>> +       SYS("sysctl -w net.netfilter.nf_conntrack_tcp_loose=0");
>> +       SYS("iptables -t raw -I PREROUTING \
>> +           -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack");
>> +       SYS("iptables -t filter -A INPUT \
>> +           -i tmp1 -p tcp -m tcp --dport 8080 -m state --state INVALID,UNTRACKED \
>> +           -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460");
>> +       SYS("iptables -t filter -A INPUT \
>> +           -i tmp1 -m state --state INVALID -j DROP");
>> +
>> +       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 --single \
>> +                           --mss4 1460 --mss6 1440 --wscale 7 --ttl 64");
>> +       size = fread(buf, 1, sizeof(buf), ctrl_file);
> 
> buf is uninitialized so if fread fail strlen() can cause SIGSEGV or
> some other failure mode

No, it will exit on the assert below (size won't be equal to strlen(str)).

> 
>> +       pclose(ctrl_file);
>> +       if (!ASSERT_TRUE(expect_str(buf, size, "Total SYNACKs generated: 0\n"),
>> +                        "initial SYNACKs"))
>> +               goto out;
>> +
>> +       server_fd = start_server(AF_INET, SOCK_STREAM, "198.18.0.2", 8080, 0);
>> +       if (!ASSERT_GE(server_fd, 0, "start_server"))
>> +               goto out;
>> +
>> +       close_netns(ns);
>> +       ns = NULL;
>> +
>> +       client_fd = connect_to_fd(server_fd, 10000);
>> +       if (!ASSERT_GE(client_fd, 0, "connect_to_fd"))
>> +               goto out;
>> +
>> +       accept_fd = accept(server_fd, NULL, NULL);
>> +       if (!ASSERT_GE(accept_fd, 0, "accept"))
>> +               goto out;
>> +
>> +       ns = open_netns("synproxy");
>> +       if (!ASSERT_OK_PTR(ns, "setns"))
>> +               goto out;
>> +
>> +       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --single");
>> +       size = fread(buf, 1, sizeof(buf), ctrl_file);
>> +       pclose(ctrl_file);
>> +       if (!ASSERT_TRUE(expect_str(buf, size, "Total SYNACKs generated: 1\n"),
>> +                        "SYNACKs after connection"))
> 
> please use ASSERT_STREQ instead, same above

It doesn't fit here for two reasons:

* It doesn't consider size (and ignoring size will cause a UB on errors 
because of the uninitialized buf).

* buf is not '\0'-terminated, and ASSERT_STREQ uses strcmp.

> 
>> +               goto out;
>> +
>> +out:
>> +       if (accept_fd >= 0)
>> +               close(accept_fd);
>> +       if (client_fd >= 0)
>> +               close(client_fd);
>> +       if (server_fd >= 0)
>> +               close(server_fd);
>> +       if (ns)
>> +               close_netns(ns);
>> +
>> +       system("ip link del tmp0");
>> +       system("ip netns del synproxy");
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>> new file mode 100644
>> index 000000000000..9ae85b189072
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>> @@ -0,0 +1,750 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> 
> Can you please elaborate on what Linux-OpenIB license is and why
> GPL-2.0 isn't enough? We usually have GPL-2.0 or LGPL-2.1 OR
> BSD-2-Clause

That's the license boilerplate we use in the mlx5e driver. I'll check 
with the relevant people whether we can submit it as GPL-2.0 solely.

>> +/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
>> +
>> +#include "vmlinux.h"
>> +
>> +#include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_endian.h>
>> +#include <asm/errno.h>
>> +
> 
> [...]
> 
>> +
>> +static __always_inline __u16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
>> +                                              __u32 len, __u8 proto,
>> +                                              __u32 csum)
>> +{
>> +       __u64 s = csum;
>> +
>> +       s += (__u32)saddr;
>> +       s += (__u32)daddr;
>> +#if defined(__BIG_ENDIAN__)
>> +       s += proto + len;
>> +#elif defined(__LITTLE_ENDIAN__)
> 
> I've got few nudges in libbpf code base previously to use
> 
> #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> 
> instead (I don't remember the exact reason now, but there was a
> reason). Let's do the same here for consistency?

OK.

samples/bpf/xdpsock_user.c also still uses __BIG_ENDIAN__.

>> +       s += (proto + len) << 8;
>> +#else
>> +#error Unknown endian
>> +#endif
>> +       s = (s & 0xffffffff) + (s >> 32);
>> +       s = (s & 0xffffffff) + (s >> 32);
>> +
>> +       return csum_fold((__u32)s);
>> +}
>> +
>> +static __always_inline __u16 csum_ipv6_magic(const struct in6_addr *saddr,
>> +                                            const struct in6_addr *daddr,
>> +                                            __u32 len, __u8 proto, __u32 csum)
>> +{
>> +       __u64 sum = csum;
>> +       int i;
>> +
>> +#pragma unroll
>> +       for (i = 0; i < 4; i++)
>> +               sum += (__u32)saddr->in6_u.u6_addr32[i];
>> +
>> +#pragma unroll
> 
> why unroll? BPF verifier handles such loops just fine, even if
> compiler decides to not unroll them

Optimization, see csum_ipv6_magic in net/ipv6/ip6_checksum.c that has 
this loop unrolled manually.

>> +       for (i = 0; i < 4; i++)
>> +               sum += (__u32)daddr->in6_u.u6_addr32[i];
>> +
>> +       // Don't combine additions to avoid 32-bit overflow.
>> +       sum += bpf_htonl(len);
>> +       sum += bpf_htonl(proto);
>> +
>> +       sum = (sum & 0xffffffff) + (sum >> 32);
>> +       sum = (sum & 0xffffffff) + (sum >> 32);
>> +
>> +       return csum_fold((__u32)sum);
>> +}
>> +
>> +static __always_inline __u64 tcp_clock_ns(void)
> 
> __always_inline isn't mandatory, you can just have static __u64
> tcp_clock_ns() here and let compiler decide on inlining? same for
> below

Do you mean just these three functions, or all functions below, or 
actually all functions in this file?

It's not mandatory, but these are simple one-liners, it would be 
unpleasant to waste an extra call in performance-critical code if the 
compiler decides not to inline them.

>> +{
>> +       return bpf_ktime_get_ns();
>> +}
>> +
>> +static __always_inline __u32 tcp_ns_to_ts(__u64 ns)
>> +{
>> +       return ns / (NSEC_PER_SEC / TCP_TS_HZ);
>> +}
>> +
>> +static __always_inline __u32 tcp_time_stamp_raw(void)
>> +{
>> +       return tcp_ns_to_ts(tcp_clock_ns());
>> +}
>> +
> 
> [...]
> 
>> +static __always_inline void values_inc_synacks(void)
>> +{
>> +       __u32 key = 1;
>> +       __u32 *value;
>> +
>> +       value = bpf_map_lookup_elem(&values, &key);
>> +       if (value)
>> +               __sync_fetch_and_add(value, 1);
>> +}
>> +
>> +static __always_inline bool check_port_allowed(__u16 port)
>> +{
>> +       __u32 i;
>> +
>> +       for (i = 0; i < MAX_ALLOWED_PORTS; i++) {
>> +               __u32 key = i;
>> +               __u16 *value;
>> +
>> +               value = bpf_map_lookup_elem(&allowed_ports, &key);
>> +
>> +               if (!value)
>> +                       break;
>> +               // 0 is a terminator value. Check it first to avoid matching on
>> +               // a forbidden port == 0 and returning true.
> 
> please no C++ comments (everywhere)
> 
>> +               if (*value == 0)
>> +                       break;
>> +
>> +               if (*value == port)
>> +                       return true;
>> +       }
>> +
>> +       return false;
>> +}
>> +
> 
> [...]

