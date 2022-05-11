Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C592523222
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239553AbiEKLsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbiEKLs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:48:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F2E2421A2;
        Wed, 11 May 2022 04:48:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrvfdbJy01uOP0EyUgEVSAWBDGKd02PNTluj7LLlMGSjafEkFyJIqUNSVQFO5PAUYKVxTjPZagArlKfoUk3JZNqmWhEUXxFrjxUrUho4XhGfHn2/vb7f8GV28/trYOh2dGyj/qi3jmxO2GgZxnJwHrJ0nz+PzxjUAaDpCrACjel5l0CLDuYPufOK4tVtc4A4+e8CdrTxo56QRipVrx5lzc/qiLTxtPLyjEmCj/o7d8TRhGuyRXK9mhrjTFMWXbypzdpjpvDmTrnhLVg93TDp42gbzI2KTxhET5p7D/Q9cVBqtAGUgjjK3xok4PpY2TcJpCRqparrNLk5jWSLr50IwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QZfdAzzLoIDIo0VJVB/lVhAkA0GfuX0OhFBZ/B5WGY=;
 b=E71jdHK9BYTufZzXKSqsZhLsNMMSl2pGqlDx81auj4WQFWFWNmUf+G758V12X+XKluuzpzeqxbQ5Z0lQz4tDqWghEAKKINLU7n1DiXz+9zP/7u33G1+mu8XqGfLuKxO52XEliN41vAhS0aw3PwrbLt6bTsKrS+d70a7ys/oxaJbuJWftInvHccqyPrQW+WzbyH5voFs8m9zLvLAJSeIvbLazWd1v38HS0qUxyRt/pIaLowtv6Wk4op3bgWNsv8SfCRz1YkRsmmu8nbwTmVzO2/StF1GBzjpYY6FJHgi5n3NHJpQP1Wt7UyzYkgvcxSWHmAuJLWQ/TmtKRxdJTlbDTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QZfdAzzLoIDIo0VJVB/lVhAkA0GfuX0OhFBZ/B5WGY=;
 b=CgE0GJm2K7TC0GOyGNOGMHuDsEJ8hGd5zNHkNBRaUpJFX47eI7+Rzb2UL4bTbDH8kesTPE07j9q831V7ppxTJfl+pswveY/ckCgHa9tqgPixxm5e30KLccmQutF7zk4tZmiqnt/f2VQRvAMhrYi8N9lKWANtcfA37GuJSLK0Kd8vnQGQUObRJe5GfNqJ+TlwmxdbTaLeNT4tB0Ph6/oNTAkCopJugOtQ1I0RPe8b9ow5OA6LHtP3B1YNCEukqnVxfW6iOv1wMnuF9ahdkmCZVGrwplJxcPzyJ6MNA7Lb9ZWgqaQj8e7LV71TuHg3EVBnNiUjHlqNXJtw4hdLcNe49w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN8PR12MB2915.namprd12.prod.outlook.com (2603:10b6:408:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 11:48:23 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 11:48:23 +0000
Message-ID: <8afeb75c-efa6-da86-637a-916769158a0f@nvidia.com>
Date:   Wed, 11 May 2022 14:48:07 +0300
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
 <59947338-cb4a-f437-0148-8ed0b83db442@nvidia.com>
 <CAEf4Bzat1U+=sPPGXP0X-B-Ay8ruN81ppFK00dopgCGxAwmkzw@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAEf4Bzat1U+=sPPGXP0X-B-Ay8ruN81ppFK00dopgCGxAwmkzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0271.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::6) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df0630b6-29b0-468a-c952-08da33442708
X-MS-TrafficTypeDiagnostic: BN8PR12MB2915:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB2915F85FA3CB6A42184656EEDCC89@BN8PR12MB2915.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tR/vpkqQpX2Bd4mQXlCD42J11eE/bmfgTcgMEbaIletm7IZUgL7qCkHmH4PYuqOGmOCDx72Uw26hNufBJbyDtVcv6jwZBGkeflscRGP7zObzaCFCi9SCNbee8omRWjcHQGYKyKlXZPuaR8aIzAfO1oBYJTP3/k/jBY7qjevMSNAiLIf3rct5DxGlqGxk3L/rCJDpudlyx3ZVctEnvbpdOtD9YioBVrgxhZkalkHxN+S51oQA4TYn1zQDSK6fpddCkynVnQDx28ZLzd7S5ZQ9EjuqwE86G6eIcCCxLMdsggYYzeZlkR7pdmcsrfGP8m9X4VbYsVrV6DcMXrW12tQc8ZWWFYg8ExkKYpT3hn2wS+2MVVaQRXlbd2avt557UApn8FUmrF5ySIXv4c+5NYTOqq3OTGz3D7UD+8JwI3yYsiGUnUNvsv4UFb0wYlmnrF/8TfsCJNHUEdGY3ogMZ1YepiTfGNkfbehNTh7WINIead80YJC4o9nwobNODUQgv9jUbOAwhZaGQ5BBPsUfFpDASBRQa3MVSM2lBNMQT887qSLlexSq5eYkkSSHRmv5g3VK2ss8nBrZmwL/uFYVVkELpZu72jNDf2aGfg2DToe/FQYjUQ4iz1VLCGOgAtymy0UnAlrFt0JNdMKRBXBurH5bcHolXeSQ2dxN0CULKg12FYJE5/lM3ush6brxajOhDNxv7hLMic+jbeJ4SaG0ErD4kEE9Vg6CuEtlpzfbtYEXBQY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38100700002)(6666004)(6506007)(53546011)(508600001)(86362001)(31696002)(54906003)(6486002)(2616005)(4326008)(66556008)(8936002)(8676002)(66946007)(66476007)(316002)(26005)(6916009)(6512007)(31686004)(36756003)(83380400001)(30864003)(7416002)(5660300002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzRVNjhHcGNmQzdzU3ozLzh3YVJjZ1o2eFk0SFVLb0tWbnowV2pidUErN1Ro?=
 =?utf-8?B?N0lKM1hLYTN0YXBFNG5LQUVodG9lU3BWNSt5dnV3RVJCcDV1NWZQNGVwMFJo?=
 =?utf-8?B?b2JzTTVZem1Rbk9xaXRoMWlzNUs4OUZqV2RqQW1PK1MzN2dyQmhrNis0VWFQ?=
 =?utf-8?B?cGZUbGlqaUFnUm9vS2J4NUZ3TzQ1VVlUbEZSV2pubTFjYldNaUJWYjdscytp?=
 =?utf-8?B?SDJheGRvUGtRMFpyWUFYcGFhaTJHTmJCL1h2OThFK00vblRMbzF5R2ZWRnBu?=
 =?utf-8?B?LzdBczkrV0xmUGIzTUZSd0NSVGdjL3hwK1lDUmF4WkowNnQ2MGNxbW40MmVI?=
 =?utf-8?B?MTl2YkpFUHpKN3R0UE8rVlBVM1B2V1dpZ1VMdEM5cmVqWVhka0ZVcm5QLzlt?=
 =?utf-8?B?YzVyMjBIVUZmQnRIdzVVcUFoaW5FNCtYQWdVbVd6VXhlSTlJbXNkVE1qZzd6?=
 =?utf-8?B?MDk3dlBSK0R3cWJRQmZMeW5FT3pBbkptZTltankrWUQ1NzNiUnY1N1JmRkI3?=
 =?utf-8?B?ZWw5Q0c3YWNwOXFrQmIwamVOOXJEQlVCa2VLWFJHeVk1aG9ScDVldW9HMjg5?=
 =?utf-8?B?VjAvNHFlSWRxSGR5aFQzcFA1eWhLVGIrdWNoTGhaRkswOGprYk90VFc4TnZn?=
 =?utf-8?B?Y0l6L25XTFlsRlljNzN3ZDlFT3Zma3dkRHVWVU9LUEtGV3F4RHgyeTBTaExk?=
 =?utf-8?B?a2YzWkR5UktGV09pM01PV29Wcks2cGI1S0R3aFIybTlvWTg0T29NTzI1Mk0y?=
 =?utf-8?B?VWIzRkpqQmFyRy9VMHk3ZVkwUHBQTmNXZTduQTdMYmY3YUFwaXZSRjhNMmRu?=
 =?utf-8?B?NGdIZ0tLdG94RjNXMUc3cHBzZjJ0R0VXWFpIMTRMdUNuL1JkT0ExTitQRkpH?=
 =?utf-8?B?UFFpQmNobGdYYnJndHIxcmR6WmhnYmJpVWZ5d2dkY3Y0b3lRcmZDdFpQOFM0?=
 =?utf-8?B?YVpWUlo4ekdKbUJUMVdGK0FEQVRmeFNRWXltcEl1UUZhR1BvNnkydUtJMVE2?=
 =?utf-8?B?MTFPQy82djlLYWhKK2ZScXRXYmRXYnhqNGZLbXU0RHJpcDgxcFNIZ3JaOWJN?=
 =?utf-8?B?Z1lkb2xPWENjUHp6NnRLZU5CZ01UaTNmZ0RuWmlrNzdZZ2k4NlBoYk5RYjFW?=
 =?utf-8?B?VlkvZ1FadnY0UEE1TzJuWEsyYU9sRC9YaHdYM2pTWjNiZXBuVjZMOHdqcnVl?=
 =?utf-8?B?cldIMUVoblYwQThvQlVvQ0N2bEZ6WFJkeVNpOU5kS0h5QllvTzZKN25HRG12?=
 =?utf-8?B?VXNVSU5USjZwZEVhL0oveWZvQXN6V0s1RDNPV1Y2bVZ6WnJIUjE1bU80S04x?=
 =?utf-8?B?b2xWVGtUL0Z3OGd1blNKdVBOaEVBQURRaFZia2ZtQ3lnMS8vRFFVcDFadTQv?=
 =?utf-8?B?YTJQeHd1V2tleU15L0xnQVlOMUlsdThZYWpQTGdTMU1PaEhNeUxPbUl6SEQ0?=
 =?utf-8?B?WWZBVHlNU2J6cjhxcnhCd1lDVzVXdXpvZkZ4anJldGNKdm1MZStRNFJLYmhw?=
 =?utf-8?B?bXdWVkxsTXBjQk5iaFlZUUVoMlk1aXdnNnBFQm03OHBDRnV6UVo4Rk1JcmZO?=
 =?utf-8?B?Nm1ZaEpUdE4wTzV1SmVaR1I1bVU2MEM5NUh6aHlvcVFqaGUrc0VIU2lBdzZB?=
 =?utf-8?B?RzdhcnRHTm1GRlhSUkNENTdqMElnSmFSVU9ISnQyNkpNeVF3SkRzOXRVaXZ1?=
 =?utf-8?B?eFg3SU1CNVZoS0ZXQW1lcE10SmViY0FyTWRZT0lVZkdUM0tLVXVBZ2RBSXFt?=
 =?utf-8?B?NkNFcFZ5TmszN1pxcUtUOTkra3UzRDBJT0lGdnlhL1h5NjNZeEw4b0Q3SlpB?=
 =?utf-8?B?aUgwU3NBcXBrS0dqcVdrUGowUDBXR2pQQ1dxY2J1ekxoMlRwZk9Jb3JUMjJk?=
 =?utf-8?B?YmZOZHE5UXh4bVh4dEkwQ0RhcGNPTENJYzF2NklGRFNNbS91S0VPYkx1QUNl?=
 =?utf-8?B?Rk9GRVUzdTNvcDhzekNwcUZGRG8wVXdhUlU5V3F5ZnB1UkYwSFEwWWVPeUJ5?=
 =?utf-8?B?bmljS2RYRFJhQThqUlY5TW9MVHhHd3VtaG9jTDRVeHpaRjRibzdnLzhQdkJO?=
 =?utf-8?B?VDY5L3lLdXY4Y3lFTUFkNlljUGx2SGlJcUw5aUtRRzZMdHlrWWhKVEc3VDFx?=
 =?utf-8?B?RzlTcm1ERS90V3Z5cGk5bTUrMFI2cHYwbVIzTGRnMmRaOS9odll2V2JkSFIy?=
 =?utf-8?B?ZnJFN3M0L3E0RW0yZ1k0S1ZGVjRSWEZ3TkowU3lwaUd3VEpmUDFLWmdwQnNB?=
 =?utf-8?B?RTJzT2xIM3YrWkhHTXhqSmtudE1zL2FReno0TGQrNzhYV0JieGFLb0k2THVM?=
 =?utf-8?B?YTZCUnNWeENuYUxrS3g1TGtkVmh0WHRLZENuRWJhZHd4V0hyYllrUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0630b6-29b0-468a-c952-08da33442708
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 11:48:23.5788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VX9Gr26oePrn58EuJwZX27jsqXAxz5yEaL4XSubaSkm8/LnwFeiJdkypkKQjla5EF8CNgqI7bUVQy1rCFEpSSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2915
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-11 03:10, Andrii Nakryiko wrote:
> On Tue, May 10, 2022 at 12:21 PM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> On 2022-05-07 00:34, Andrii Nakryiko wrote:
>>> On Tue, May 3, 2022 at 10:15 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>>>
>>>> This commit adds selftests for the new BPF helpers:
>>>> bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6}.
>>>>
>>>> xdp_synproxy_kern.c is a BPF program that generates SYN cookies on
>>>> allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
>>>> iptables module.
>>>>
>>>> xdp_synproxy.c is a userspace control application that allows to
>>>> configure the following options in runtime: list of allowed ports, MSS,
>>>> window scale, TTL.
>>>>
>>>> A selftest is added to prog_tests that leverages the above programs to
>>>> test the functionality of the new helpers.
>>>>
>>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>>> ---
>>>
>>> selftests should use "selftests/bpf: " subject prefix, not "bpf: ",
>>> please update so it's more obvious that this patch touches selftests
>>> and not kernel-side BPF functionality.
>>>
>>>>    tools/testing/selftests/bpf/.gitignore        |   1 +
>>>>    tools/testing/selftests/bpf/Makefile          |   5 +-
>>>>    .../selftests/bpf/prog_tests/xdp_synproxy.c   | 109 +++
>>>>    .../selftests/bpf/progs/xdp_synproxy_kern.c   | 750 ++++++++++++++++++
>>>>    tools/testing/selftests/bpf/xdp_synproxy.c    | 418 ++++++++++
>>>>    5 files changed, 1281 insertions(+), 2 deletions(-)
>>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>>>>    create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>>>>    create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
>>>>
>>>> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
>>>> index 595565eb68c0..ca2f47f45670 100644
>>>> --- a/tools/testing/selftests/bpf/.gitignore
>>>> +++ b/tools/testing/selftests/bpf/.gitignore
>>>> @@ -43,3 +43,4 @@ test_cpp
>>>>    *.tmp
>>>>    xdpxceiver
>>>>    xdp_redirect_multi
>>>> +xdp_synproxy
>>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>>>> index bafdc5373a13..8ae602843b16 100644
>>>> --- a/tools/testing/selftests/bpf/Makefile
>>>> +++ b/tools/testing/selftests/bpf/Makefile
>>>> @@ -82,9 +82,9 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>>>>    TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>>>>           flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
>>>>           test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
>>>> -       xdpxceiver xdp_redirect_multi
>>>> +       xdpxceiver xdp_redirect_multi xdp_synproxy
>>>>
>>>> -TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
>>>> +TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/xdp_synproxy
>>>>
>>>>    # Emit succinct information message describing current building step
>>>>    # $1 - generic step name (e.g., CC, LINK, etc);
>>>> @@ -500,6 +500,7 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c      \
>>>>                            cap_helpers.c
>>>>    TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
>>>>                          $(OUTPUT)/liburandom_read.so                     \
>>>> +                      $(OUTPUT)/xdp_synproxy                           \
>>>
>>> this is the right way to make external binary available to test_progs
>>> flavors, but is there anything inherently requiring external binary
>>> instead of having a helper function doing the same? urandom_read has
>>> to be a separate binary.
>>
>> If you remember v1, it used to be a sample, but I was asked to convert
>> it to a selftest, because samples are deprecated. The intention of
>> having this separate binary is to have a sample reference implementation
>> that can be used in real-world scenarios with minor or no changes.
>>
> 
> Ok, I'll let others chime in if they care enough about this. Selftests
> are first and foremost a test and not an almost production-ready
> collection of tools, but fine by me.
> 
>>>>                          ima_setup.sh                                     \
>>>>                          $(wildcard progs/btf_dump_test_case_*.c)
>>>>    TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>>>> new file mode 100644
>>>> index 000000000000..e08b28e25047
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>>>> @@ -0,0 +1,109 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +#include <test_progs.h>
>>>> +#include <network_helpers.h>
>>>> +
>>>> +#define SYS(cmd) ({ \
>>>> +       if (!ASSERT_OK(system(cmd), (cmd))) \
>>>> +               goto out; \
>>>> +})
>>>> +
>>>> +#define SYS_OUT(cmd) ({ \
>>>> +       FILE *f = popen((cmd), "r"); \
>>>> +       if (!ASSERT_OK_PTR(f, (cmd))) \
>>>> +               goto out; \
>>>> +       f; \
>>>> +})
>>>> +
>>>> +static bool expect_str(char *buf, size_t size, const char *str)
>>>> +{
>>>> +       if (size != strlen(str))
>>>> +               return false;
>>>> +       return !memcmp(buf, str, size);
>>>> +}
>>>> +
>>>> +void test_xdp_synproxy(void)
>>>> +{
>>>> +       int server_fd = -1, client_fd = -1, accept_fd = -1;
>>>> +       struct nstoken *ns = NULL;
>>>> +       FILE *ctrl_file = NULL;
>>>> +       char buf[1024];
>>>> +       size_t size;
>>>> +
>>>> +       SYS("ip netns add synproxy");
>>>> +
>>>> +       SYS("ip link add tmp0 type veth peer name tmp1");
>>>> +       SYS("ip link set tmp1 netns synproxy");
>>>> +       SYS("ip link set tmp0 up");
>>>> +       SYS("ip addr replace 198.18.0.1/24 dev tmp0");
>>>
>>>> +
>>>> +       // When checksum offload is enabled, the XDP program sees wrong
>>>> +       // checksums and drops packets.
>>>> +       SYS("ethtool -K tmp0 tx off");
>>>> +       // Workaround required for veth.
>>>
>>> don't use C++ comments, please stick to /* */
>>>
>>>> +       SYS("ip link set tmp0 xdp object xdp_dummy.o section xdp 2> /dev/null");
>>>> +
>>>> +       ns = open_netns("synproxy");
>>>> +       if (!ASSERT_OK_PTR(ns, "setns"))
>>>> +               goto out;
>>>> +
>>>> +       SYS("ip link set lo up");
>>>> +       SYS("ip link set tmp1 up");
>>>> +       SYS("ip addr replace 198.18.0.2/24 dev tmp1");
>>>> +       SYS("sysctl -w net.ipv4.tcp_syncookies=2");
>>>> +       SYS("sysctl -w net.ipv4.tcp_timestamps=1");
>>>> +       SYS("sysctl -w net.netfilter.nf_conntrack_tcp_loose=0");
>>>> +       SYS("iptables -t raw -I PREROUTING \
>>>> +           -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack");
>>>> +       SYS("iptables -t filter -A INPUT \
>>>> +           -i tmp1 -p tcp -m tcp --dport 8080 -m state --state INVALID,UNTRACKED \
>>>> +           -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460");
>>>> +       SYS("iptables -t filter -A INPUT \
>>>> +           -i tmp1 -m state --state INVALID -j DROP");
>>>> +
>>>> +       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 --single \
>>>> +                           --mss4 1460 --mss6 1440 --wscale 7 --ttl 64");
>>>> +       size = fread(buf, 1, sizeof(buf), ctrl_file);
>>>
>>> buf is uninitialized so if fread fail strlen() can cause SIGSEGV or
>>> some other failure mode
>>
>> No, it will exit on the assert below (size won't be equal to strlen(str)).
> 
> it's better to use ASSERT_STREQ() which will also emit expected and
> actual strings if they don't match. So maybe check size first, and
> then ASSERT_STREQ() instead of custom expect_str() "helper"?

See below, the command's output is not a string.

If I extend my expect_str function to print the expected and actual 
outputs, would that work for you?

>>
>>>
>>>> +       pclose(ctrl_file);
>>>> +       if (!ASSERT_TRUE(expect_str(buf, size, "Total SYNACKs generated: 0\n"),
>>>> +                        "initial SYNACKs"))
>>>> +               goto out;
>>>> +
>>>> +       server_fd = start_server(AF_INET, SOCK_STREAM, "198.18.0.2", 8080, 0);
>>>> +       if (!ASSERT_GE(server_fd, 0, "start_server"))
>>>> +               goto out;
>>>> +
>>>> +       close_netns(ns);
>>>> +       ns = NULL;
>>>> +
>>>> +       client_fd = connect_to_fd(server_fd, 10000);
>>>> +       if (!ASSERT_GE(client_fd, 0, "connect_to_fd"))
>>>> +               goto out;
>>>> +
>>>> +       accept_fd = accept(server_fd, NULL, NULL);
>>>> +       if (!ASSERT_GE(accept_fd, 0, "accept"))
>>>> +               goto out;
>>>> +
>>>> +       ns = open_netns("synproxy");
>>>> +       if (!ASSERT_OK_PTR(ns, "setns"))
>>>> +               goto out;
>>>> +
>>>> +       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --single");
>>>> +       size = fread(buf, 1, sizeof(buf), ctrl_file);
>>>> +       pclose(ctrl_file);
>>>> +       if (!ASSERT_TRUE(expect_str(buf, size, "Total SYNACKs generated: 1\n"),
>>>> +                        "SYNACKs after connection"))
>>>
>>> please use ASSERT_STREQ instead, same above
>>
>> It doesn't fit here for two reasons:
>>
>> * It doesn't consider size (and ignoring size will cause a UB on errors
>> because of the uninitialized buf).
>>
>> * buf is not '\0'-terminated, and ASSERT_STREQ uses strcmp.
> 
> can it be non-zero-terminated in normal case? see above about checking
> for errors separately

fread(buf, x, y, file) just reads up to x*y bytes into buf. It doesn't 
treat it as a zero-terminated string, it can be any binary sequence of 
bytes. So, yes, in normal case it's going to be some printable 
characters WITHOUT any terminating '\0' (no one prints a '\0' to the 
terminal in normal cases). In bad cases it could be anything, including 
'\0' in the middle of the buffer, which would terminate strcmp early and 
can cause false positives.

>>
>>>
>>>> +               goto out;
>>>> +
>>>> +out:
>>>> +       if (accept_fd >= 0)
>>>> +               close(accept_fd);
>>>> +       if (client_fd >= 0)
>>>> +               close(client_fd);
>>>> +       if (server_fd >= 0)
>>>> +               close(server_fd);
>>>> +       if (ns)
>>>> +               close_netns(ns);
>>>> +
>>>> +       system("ip link del tmp0");
>>>> +       system("ip netns del synproxy");
>>>> +}
>>>> diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>>>> new file mode 100644
>>>> index 000000000000..9ae85b189072
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>>>> @@ -0,0 +1,750 @@
>>>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>>>
>>> Can you please elaborate on what Linux-OpenIB license is and why
>>> GPL-2.0 isn't enough? We usually have GPL-2.0 or LGPL-2.1 OR
>>> BSD-2-Clause
>>
>> That's the license boilerplate we use in the mlx5e driver. I'll check
>> with the relevant people whether we can submit it as GPL-2.0 solely.
>>
> 
> ok
> 
>>>> +/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
>>>> +
>>>> +#include "vmlinux.h"
>>>> +
>>>> +#include <bpf/bpf_helpers.h>
>>>> +#include <bpf/bpf_endian.h>
>>>> +#include <asm/errno.h>
>>>> +
>>>
>>> [...]
>>>
>>>> +
>>>> +static __always_inline __u16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
>>>> +                                              __u32 len, __u8 proto,
>>>> +                                              __u32 csum)
>>>> +{
>>>> +       __u64 s = csum;
>>>> +
>>>> +       s += (__u32)saddr;
>>>> +       s += (__u32)daddr;
>>>> +#if defined(__BIG_ENDIAN__)
>>>> +       s += proto + len;
>>>> +#elif defined(__LITTLE_ENDIAN__)
>>>
>>> I've got few nudges in libbpf code base previously to use
>>>
>>> #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
>>> #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
>>>
>>> instead (I don't remember the exact reason now, but there was a
>>> reason). Let's do the same here for consistency?
>>
>> OK.
>>
>> samples/bpf/xdpsock_user.c also still uses __BIG_ENDIAN__.
>>
>>>> +       s += (proto + len) << 8;
>>>> +#else
>>>> +#error Unknown endian
>>>> +#endif
>>>> +       s = (s & 0xffffffff) + (s >> 32);
>>>> +       s = (s & 0xffffffff) + (s >> 32);
>>>> +
>>>> +       return csum_fold((__u32)s);
>>>> +}
>>>> +
>>>> +static __always_inline __u16 csum_ipv6_magic(const struct in6_addr *saddr,
>>>> +                                            const struct in6_addr *daddr,
>>>> +                                            __u32 len, __u8 proto, __u32 csum)
>>>> +{
>>>> +       __u64 sum = csum;
>>>> +       int i;
>>>> +
>>>> +#pragma unroll
>>>> +       for (i = 0; i < 4; i++)
>>>> +               sum += (__u32)saddr->in6_u.u6_addr32[i];
>>>> +
>>>> +#pragma unroll
>>>
>>> why unroll? BPF verifier handles such loops just fine, even if
>>> compiler decides to not unroll them
>>
>> Optimization, see csum_ipv6_magic in net/ipv6/ip6_checksum.c that has
>> this loop unrolled manually.
>>
>>>> +       for (i = 0; i < 4; i++)
>>>> +               sum += (__u32)daddr->in6_u.u6_addr32[i];
>>>> +
>>>> +       // Don't combine additions to avoid 32-bit overflow.
>>>> +       sum += bpf_htonl(len);
>>>> +       sum += bpf_htonl(proto);
>>>> +
>>>> +       sum = (sum & 0xffffffff) + (sum >> 32);
>>>> +       sum = (sum & 0xffffffff) + (sum >> 32);
>>>> +
>>>> +       return csum_fold((__u32)sum);
>>>> +}
>>>> +
>>>> +static __always_inline __u64 tcp_clock_ns(void)
>>>
>>> __always_inline isn't mandatory, you can just have static __u64
>>> tcp_clock_ns() here and let compiler decide on inlining? same for
>>> below
>>
>> Do you mean just these three functions, or all functions below, or
>> actually all functions in this file?
>>
>> It's not mandatory, but these are simple one-liners, it would be
>> unpleasant to waste an extra call in performance-critical code if the
>> compiler decides not to inline them.
>>
> 
> my point was that it's not mandatory anymore. Given this is a hybrid
> high-performance sample and selftest, I don't care. If it was just a
> test, there is no point in micro-optimizing this (similar for loop
> unrolling).
> 
>>>> +{
>>>> +       return bpf_ktime_get_ns();
>>>> +}
>>>> +
>>>> +static __always_inline __u32 tcp_ns_to_ts(__u64 ns)
>>>> +{
>>>> +       return ns / (NSEC_PER_SEC / TCP_TS_HZ);
>>>> +}
>>>> +
>>>> +static __always_inline __u32 tcp_time_stamp_raw(void)
>>>> +{
>>>> +       return tcp_ns_to_ts(tcp_clock_ns());
>>>> +}
>>>> +
>>>
>>> [...]
>>>
> 
> [...]

