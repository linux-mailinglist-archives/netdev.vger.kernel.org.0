Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22DB511D3D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiD0RWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiD0RWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:22:53 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CD0443E2;
        Wed, 27 Apr 2022 10:19:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6ca8y2bCdIWLk5EYgfHxSLR7GPH+65pJkBdUZyc8pdrRWAdBJttYUvN634Pw1hHOyCTEbK3Rge+8akkq5TM/FD0LA3V8cmT0oCV/OSFgwC+D5GRjmdkoGBnKbHSsn1ZvGuxyUdsQQhrS1j8vuMqSw+cDvzAOvxKm/PgXoHztchKgKxZKuR6hG+YHpmABCWFwKvd6g9G0U+s2PGnuhEW7eX5u0npzbHWZyseK3I9JWaekU9VASASDvoW8aKFaKZOYFcpG85iW+P4OzehMkoHZFX2IDg75B6CIVUJtId+eLWftMVJJB9eoJdtNR7dDZwRoZzxBN/74e2zUN4+jgHYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zQGEHaKu580NxhjKX1XD2MqC0NeRRZ8ZCpg82jvwIQ=;
 b=Lc5HhwYxW5RbSvvXGStiraxkVbw0niHy9fBzygniRQpHYBCw9hnFc7mKs1M1BydGgXJ4kuX1+hywOgHtzY7hcCxKkz/faWzBupQtsCe93uVE38LQ4B6napMHppiuRepHTS5BPr+B2lbE4o2QM8RpwdSXVJtC1Me/Nt7b9YYl2qBAdcKD/Etz5mfocrHcKcYFYGuvrqxKLfBsDQuXfBMXTsI7UqOL6xqsBYVplT1vngHazcR0KghMOxKYMFUWvVrpjHaN9ojv4/jjazTV4NeTcCt3kS2Y1oYnbuMdZfOd51G/8ro/uVkFej6lAWzgMnR2p1rRyvjYYEvka4KxGGerpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zQGEHaKu580NxhjKX1XD2MqC0NeRRZ8ZCpg82jvwIQ=;
 b=sIXbuOCpWLyCZn7TOrBlMEjUianKiS0fN9X+uJDYAYf938WiL8pspiv1T3Hp1VHer4eVzMmnWMFnJoWw8ZttOrQZSbWUoudlTEHN6swkONiRsBjQkz7gfwy0nWNhgRBmseKnTz/1kQzfUrtSv5fAMoqkiMxIf8naEQmCbE4/7FMRGUJUDTIt34k82iWckcSo2L87AkDIaGLrCspoHZOfmkrA+nSGQcPSmrzPNsTOIsYre/R356ecwCWWTrVM0bW/6sjT56ymGdxhZmfQ2l7kyJAXcfG5lumbZDzqXKHbnKlNOlzD8QQ1uC7gTmwth+CorfWNyit5h3i7fFVZaG8aiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MWHPR1201MB0239.namprd12.prod.outlook.com (2603:10b6:301:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.19; Wed, 27 Apr
 2022 17:19:38 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 17:19:38 +0000
Message-ID: <946b8928-56b6-b6ca-ec33-6ffe7af6a90c@nvidia.com>
Date:   Wed, 27 Apr 2022 20:19:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH bpf-next v6 5/6] bpf: Add selftests for raw syncookie
 helpers
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
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
References: <20220422172422.4037988-1-maximmi@nvidia.com>
 <20220422172422.4037988-6-maximmi@nvidia.com>
 <20220426001223.wlnfd2kmmogip5d5@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CAEf4BzaGjxsf46YPs1FRSp4kj+nkKhw7vLKAGwgrdnAuTW5+9Q@mail.gmail.com>
 <92e9eaf6-4d72-3173-3271-88e3b8637c7a@nvidia.com>
 <CAEf4BzZhjY+F9JYmT7k+m87UZ1qKuO8_Mjjq4CGgkr=z9BGDCg@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAEf4BzZhjY+F9JYmT7k+m87UZ1qKuO8_Mjjq4CGgkr=z9BGDCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0498.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::23) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7166cf30-40a6-4cf8-0b43-08da28721bc5
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0239:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0239DD6CCF9B87F906D1C04FDCFA9@MWHPR1201MB0239.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9c9O3Dt/JAvk4nCYpWOlDuz6O0aTJO7WM0gmmzsXK545BSYw2yXUGnFxfwLkPOlbnDeICPyrZP9xMmhrlJi/MlC/qZMgAXD1hNxqwkvH/Tr67sbxIHP50CAGNOWv5XHkaH03bogn2alwuj29iwdVBrFOiWFTk+CN/lL/5SGck7s6t1X+OAgav4YCOfHfj9yQThPrzBp+/9lO8wNPn9kxdYHRaIItamcLlKBPeDolU0ci/N/AW/6d/cCaatqtKSsGgbCYhCZFNTOs6yr1GmDGsHBcuEHDpFUwxEeC5L2TB6IGR8QsdOEld4jjwiKN25X6zuM3JJ0v67SP2vqgwQ1OM1zitsWymdBfd/axm3oZ6rXaL4wIBGDj1EB/BgX8Mu8yihDTD0S6l76GHZfftuI2bgnNVpaiNBrZH1yZn9Xer32PqcPRbJt/HNnxyw+aI0yuKG2NBNDRgIGZqEPSFqXyrRHXNBuVzEqAziqYihH0dKH1g+6fAiiL1BSOw8gVzAIJ4YKKVAZFph2NMqdWuXrul23vVXh3T2swovNMt9RjUPUBqF5XTuz43qYEO+jAvIxCS6DaYLzyU9skmoUgUemMEsjwrmdD27As7gAwYxPwigIob96SaAip9vgeJWqJ8inxpxVqsaVGfJjEAoSCthKbhLLT8MhsuSmRc8qRNKUScnrbDSvDjLqZC219OhlAUPmrmdr25CSdKefGv4DtFHpyNvyKBKq19a9yevuexF5q5bwrmpaF3IFcJhF/JbxOM6GAMWVGCZU/Kh+7dKhrbTPHuyGwOosh5TcX6aqk2SmKEbl3sT3XYB7Clr0mA1zvWzPf4quh1Ac8jfrm768WahaQ01gDSWL4K754LX88L1sbKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(6486002)(2616005)(8936002)(6506007)(5660300002)(53546011)(31686004)(83380400001)(186003)(86362001)(26005)(7416002)(7406005)(966005)(38100700002)(31696002)(6512007)(6666004)(8676002)(508600001)(66556008)(2906002)(4326008)(66946007)(66476007)(6916009)(316002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzRORktOUFJReFJTaCtyWHBpUXhwOWNYc0VEYTRzVmE3bHBoWnZzQUptUGRO?=
 =?utf-8?B?T2hjL2g1Yk1IVzIzWGdGUDBvRFFpWHc0TlVrOTFYRGZJSHJLbU9sbkZjYTJs?=
 =?utf-8?B?RktZeFN3NzJlVXk1ZUhqa0lvSUE2a2hLUEUvcTE5RGZCb3lvYjFnUWVEQUl3?=
 =?utf-8?B?NXhSbUFXNjVMQVFNOFJtL1NqaVdBTEQ0NThNLzNwd0pNelBBN3FXdjljVXR3?=
 =?utf-8?B?b3E0QUJUNzQ1R2tUaHJkbHZlc05FUjB3QWl5clkrSHoxUkFka2RNMGdPb0JF?=
 =?utf-8?B?NXl4V2VEZVJlc2NQSlpsUHE4OHZNYWpVcHgvY2JLL3FHdzNXbFZaR0dORmdz?=
 =?utf-8?B?a0QzQm1xY2kxNUdpdGhHU1dtUVoyMlJvZlh4WE8zcjZrRzdTbVY5T1gwelpH?=
 =?utf-8?B?QmZyRXpIbUhxSkNVcWJCVXN1cEhKWFV6VS9uMjZSUklGY2NGMDdwV2ZPSlA3?=
 =?utf-8?B?YlVEM2JidGZ2VE96aUdjb0Z4azJ0aUp3TVZtdlBhZDJNdDJrd08zQ0RpNkIx?=
 =?utf-8?B?L0Q1aDYyWGtuR041Qzdkcmlsc0p6dGxjT0RWRjNFWS8veTZjcGlVTVp2Tk9O?=
 =?utf-8?B?ZUhKU0h5eU10TjQ3WitpQ0JwMFZtdHZTUWY0MWtXb2xSTDFMVmplcjdVTHZ6?=
 =?utf-8?B?eFlrUUsySXBwYkRvWkhZdEpaNGIzbkRaR002SERGcGwwV3FHQzBTdXB4M0cz?=
 =?utf-8?B?RUpHNTRIRlo2TzBxVlBrVU8zeWZkblNJcmNMMWFxendDWk9ONnZJc0hDcDhi?=
 =?utf-8?B?STlacWlVVEZxSlh4TDlNUml6akI5dDlFKys5YXdKZXZLVU9hTXAxdEdqOXJG?=
 =?utf-8?B?c0Z2ZEdYK2pKeDFmTzR0MjJ3SXVmYW1RRjlmTXNBT3ZGZ2prVE9CeVBpZVVE?=
 =?utf-8?B?b1hKZmtlZ2t2ZmJKVDJ5M0tLSklXVzRwNVdVK25KclVuTERZUDdqMDJEcXRj?=
 =?utf-8?B?dDhBckR6c0NTUEd2cHU5bEJVUkRtYUVjNEVUSjlhNWxkbkdUTUFHVTN1VDZh?=
 =?utf-8?B?YjBtRjRSME1yVFFUcHRwQWxrcHI2VzJzYittcUxpL2ZCcXpkeGpUaENPNEFW?=
 =?utf-8?B?dUMvd2U1SzM4bUpyalY1bTY4bHlGZmVCUVpjM0ZKZmNBRW40c01rZmdVUzMy?=
 =?utf-8?B?UXA1QjEvTFZaVzZ0R2RCNVprVy9MVy9nM2tMaTNSRTQ4S1ltRGZIb0JWK1c3?=
 =?utf-8?B?VGgvUVRtVEVNSzZhSWZucFpPWnhkN2t1Y0I4azFuc2NmcUdzaFJ6SGhLd1hL?=
 =?utf-8?B?TXhTU1pDR0VYQ2dGdkRZVlczWEhaYmNPZFoyUW85YjFla2RrYzlzbTBOY2hV?=
 =?utf-8?B?VG45NEhUYzYxWFJMeENtVWxNN1VlUFlUck4yd21mRnk4M0Z4Z2RKTmx0ZmlR?=
 =?utf-8?B?N2s3djhVRktVcDNIZ0F5MHM4bnlYQmVqNldPTEZsa1hWNEdCNkYxZWJCcG00?=
 =?utf-8?B?MklYZmxlQlZyRmFVNk5UZUJyU005MmVIUGQ1Q3pIZGRtcGdwbWlQVTlNaWUx?=
 =?utf-8?B?ME1TT1M3Ym4zOUlCWWw2bHBUc3dwbFdraUVnT3pmM20yb0ZwYWtoTzkvSWZT?=
 =?utf-8?B?Yld0OW0wakN2VFZRWmNKOURyS3NqRzkxQjBwWTB4RmRqd1lDb2FCMGNjTWRm?=
 =?utf-8?B?aVRWOFpkSi9oQmFDU21EaHZzc2VNejlHVHBPdGZVTnpqM3lRTEhWRmxSYlFa?=
 =?utf-8?B?aklvRlF1ZGN5eitHUG82ZXhHVFNOV0hhUzlzUE11Sm1IWllBcE1NY1FIQnMx?=
 =?utf-8?B?VUF0OXlwMUxrM0hET290S25ab2VrZGROelpyN20xd2I0dUZWUWZzblBRMnkz?=
 =?utf-8?B?aUJqaDZKOHFibUs3QkFjL1ZNc21UZ0JrdEJFRUY0ZkJvUXV0Qkc2OHgxdUFD?=
 =?utf-8?B?L0ZVSkZaUFNnaTNPUWVmdjJiOHMvRGg4T2c1dVF5eDZ1OUx2WkY4ak1WY2tV?=
 =?utf-8?B?anBocG0wVXZQbmxwbmZJbjNYdFNWSUV4ZEVtMjhVUWpoVVFWN29mU294ZWxk?=
 =?utf-8?B?czBFOURLbCtCZ2VxZUtTY1k5ajlJWC9zTStFT2F2TFVVd1lhWUxKTno1S3VF?=
 =?utf-8?B?bHdYS3g5TDNObXd5Z25wSnVxaVRvTjUyUG9CZ3lpbG12VkxvSm1vOHdiRkxy?=
 =?utf-8?B?M1kwamR5Y251UnZrY3JEYmlhWk9OeFVRL0w1UFlsL0tXb0pEWkg1NVBYNkZI?=
 =?utf-8?B?UjdSajVMZk9talJUV05GNEdEN0FLbHdzUTBrZjBhVmtqMjcxakZNOXlaWm16?=
 =?utf-8?B?WDM0WEVvS281dmFtMTNDbzYxZnN0UHJZSk9saVJSaENPcXFVRG9XVU4ra0dh?=
 =?utf-8?B?VUN6dEp6MGF1M1lScDhSU1FHRjhEaU85aThYRHl3bDJ4U3JOMjBodz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7166cf30-40a6-4cf8-0b43-08da28721bc5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 17:19:38.7220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akBNqznCGxd34+jCupquhJ86O1mDxWFOAzLmRz3vYChc+6EvVXTvyAxHA9qypIOH0kAK2jL6bUKAW5C8H/hq8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0239
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-27 01:11, Andrii Nakryiko wrote:
> On Tue, Apr 26, 2022 at 11:29 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> On 2022-04-26 09:26, Andrii Nakryiko wrote:
>>> On Mon, Apr 25, 2022 at 5:12 PM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>>
>>>> On Fri, Apr 22, 2022 at 08:24:21PM +0300, Maxim Mikityanskiy wrote:
>>>>> +void test_xdp_synproxy(void)
>>>>> +{
>>>>> +     int server_fd = -1, client_fd = -1, accept_fd = -1;
>>>>> +     struct nstoken *ns = NULL;
>>>>> +     FILE *ctrl_file = NULL;
>>>>> +     char buf[1024];
>>>>> +     size_t size;
>>>>> +
>>>>> +     SYS("ip netns add synproxy");
>>>>> +
>>>>> +     SYS("ip link add tmp0 type veth peer name tmp1");
>>>>> +     SYS("ip link set tmp1 netns synproxy");
>>>>> +     SYS("ip link set tmp0 up");
>>>>> +     SYS("ip addr replace 198.18.0.1/24 dev tmp0");
>>>>> +
>>>>> +     // When checksum offload is enabled, the XDP program sees wrong
>>>>> +     // checksums and drops packets.
>>>>> +     SYS("ethtool -K tmp0 tx off");
>>>>
>>>> BPF CI image doesn't have ethtool installed.
>>>> It will take some time to get it updated. Until then we cannot land the patch set.
>>>> Can you think of a way to run this test without shelling to ethtool?
>>>
>>> Good news: we got updated CI image with ethtool, so that shouldn't be
>>> a problem anymore.
>>>
>>> Bad news: this selftest still fails, but in different place:
>>>
>>> test_synproxy:FAIL:iptables -t raw -I PREROUTING -i tmp1 -p tcp -m tcp
>>> --syn --dport 8080 -j CT --notrack unexpected error: 512 (errno 2)
>>
>> That's simply a matter of missing kernel config options:
>>
>> CONFIG_NETFILTER_SYNPROXY=y
>> CONFIG_NETFILTER_XT_TARGET_CT=y
>> CONFIG_NETFILTER_XT_MATCH_STATE=y
>> CONFIG_IP_NF_FILTER=y
>> CONFIG_IP_NF_TARGET_SYNPROXY=y
>> CONFIG_IP_NF_RAW=y
>>
>> Shall I create a pull request on github to add these options to
>> https://github.com/libbpf/libbpf/tree/master/travis-ci/vmtest/configs?
>>
> 
> Yes, please. But also for [0], that's the one that tests all the
> not-yet-applied patches
> 
>    [0] https://github.com/kernel-patches/vmtest/

Created pull requests:

https://github.com/kernel-patches/vmtest/pull/79
https://github.com/libbpf/libbpf/pull/490

>>> See [0].
>>>
>>>     [0] https://github.com/kernel-patches/bpf/runs/6169439612?check_suite_focus=true
>>

