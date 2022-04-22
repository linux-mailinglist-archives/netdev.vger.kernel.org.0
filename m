Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA77750BEAA
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbiDVRbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiDVRba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:31:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1F2E6C55;
        Fri, 22 Apr 2022 10:28:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAvG+rN5kihD3Ak27DEKOLl/IQi9YWMXvhLeUPKTkXDZvbORSkwMf5LyILxcKdFHn/5RDWdTaQOGb1556CWT136EYbO5d7rFUqiQeksNuyO7edX6j781b8gGuPnWGEo0NrmjXbq2K5sAJ4PD2AsMGul8H9cgavmOiaZ9dX9DctWsyKiLvfgDhBpJQCMd/SFPucRKU6yCuZDrDIfUAYYVa6kkLeJBvh4YjFKenjQ8YL3E7GrfghSY5633FwquXmxr0dK2JBBWEi6wO40b2q8GcpKn7zWnw16+8RurLFopakH2l3KLnQpLiobfW/DNlEonwgpFasBP/Wfna6Q5vg390g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMmvFWQHLwxXaxiO9VCTN+FPh+pgW3SQUkBjd694rVo=;
 b=Rc3636vvfB2GWBdyd7j8jUpgF9zlU610ymtH6ki3aH9C26j6paYmgDpWKfZxbwj4nUEr7BvDyqP2p3Au9wijqRAm5hjeNBugt09riG6TEeFz5V9LEzPIk3oak93So/gSyKd61yLHZd85gzt1cOcHJTR8wm2NFSgbuJbSTOgso7gwquFUzbYEvjpf/Xv3fn+Eu8SUY2IC7UwIEEJFRhRWcLkgQhUz7di4S38vGNQPOuAZFX4j2fuw/yFoPVaI7s4eUo9iWjt+gDwPHxh4DolX305sZxjZmuJePkbxgXSLsggYj7RnW2Asvk5IncgWVSB645Wfz1l4aFrQiiCju3kANg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMmvFWQHLwxXaxiO9VCTN+FPh+pgW3SQUkBjd694rVo=;
 b=c9Qe4lq4FAz7PV+cZoVPIPFHTtbqQOIikHuYDDLj5mWDzFNzBXPbzPNziS1AkKLMjAgrm0ti3WKLJznIFotdkPUBO97NOJ6Si91gm0pdOTjSKzs/HVJUr7zbIdaCvYIs0oKRZLaNwV9BjlackQ6f1B2caGEklBxQcjZJkmggteQU75r+ohQ34PajsUkHlQdXI51Hl0qrXN7rVajtQKDvvh0FEPZWmgr/33sPcw8JhkhpG5zh+eSb7pYX/uQ2DtG1qblBeFsSjTXKYDoo9saYTSpYuDF07/sveNy+MJxn87Rr16w5DNpO6jrtD4flsBWsmRGhlJLkL1K3457tlp+O9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MN2PR12MB3151.namprd12.prod.outlook.com (2603:10b6:208:d1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 17:23:42 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 17:23:42 +0000
Message-ID: <87ad8351-6c2d-39ec-7b72-1cf273bbaa72@nvidia.com>
Date:   Fri, 22 Apr 2022 20:23:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next v5 4/6] bpf: Add helpers to issue and check SYN
 cookies in XDP
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
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
        linux-kselftest@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
References: <20220413134120.3253433-1-maximmi@nvidia.com>
 <20220413134120.3253433-5-maximmi@nvidia.com>
 <e75057fd-42d4-071e-b8b9-0b93e643adfd@iogearbox.net>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <e75057fd-42d4-071e-b8b9-0b93e643adfd@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0430.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::21) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc831c36-8303-444a-4b03-08da2484d8a4
X-MS-TrafficTypeDiagnostic: MN2PR12MB3151:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB315145C19FBE28F3769CADCCDCF79@MN2PR12MB3151.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7YX5X10ean3aBvHciToJr7MyN+Y5IcMsHG6h+ZjJoutzThgX89SAUAOJlqlPJ4j7LkL197dGfbWw0dYJSst+xI9B1IBPn5voCEC6VcbZsk57QXqRAMCHblY1ivnUrsZmR97zG7If8xYmIu9BkeSMhrEYLDTz1x1bBJy94d+ioXvUjz/bEXD05iBJnRWD9hmBl0mrjw25XLbCJDsYuQ9f/fPq0pDZ5sn5Ftw/5npj5W2YFSYBAe6G31wYvigpwc0NogqYG7LkR4jn18S77Ont3lNnz+4r3oaEEVgrEUSxCdKZ0pOt6S01QpGKlt/5VLnmSg0mY3W+tyMzwljvl+ojrBFFbzOnno2c90AsrZABkLV0ghKJsAsspNnxbNQmN4/1Pf42fzT9xscXCKKeJPjxRzeTCHBUhW84J4pn02CV8F1GQTfXXFyr+yFDPTlRMkHLso8/0q8hAOOI30LWfhOSooZaF1UhI01vtIyEsDnEW8dqTYziARsNKagXATvJNFUbCDvFS/UZbJQKtgMVF4ji0tODUjf4yUbkvypQDIHxu4fl7AZbN4pMfSIsAQi6YQhubeb48M/0VnUNSL69Go8YStD0h3wGUSo/3uE9NMQ7Lw3F3WLaTMVK1zC7UH9xxuommC4abqJkX1MQVrOyTIqr4+JYxO0XXygSPyro3SdnisnwgyJVy6GxDNNTxQejkk4vw3JDlZuKDFLehpBS/eHi4KjxmvELUp7IP/Gd5ppBjUY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(54906003)(8936002)(508600001)(53546011)(7416002)(6916009)(31686004)(2906002)(316002)(6486002)(31696002)(86362001)(6506007)(186003)(83380400001)(5660300002)(66556008)(66946007)(2616005)(66476007)(4326008)(8676002)(6666004)(26005)(6512007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG5lQW43aDRrbldJRStRdm1uelpwMnBKQ2V1YzN2dDBLTzNBZzhWdlFzaUN3?=
 =?utf-8?B?ZnNtaDFqK0dKYStPMVBSK2lTZDFtejVWV1V3TEN2YWFKYjF0Q2EwS3gzWE5D?=
 =?utf-8?B?UEdLNHRQVmV5K0JyTlA3NHlFanJIVjdzRWNXYno5MEF3cUNQTkxhWHJ5SjBz?=
 =?utf-8?B?N0RZK2VjNW0xMnBkM2ZTVHppRnR2UVVJQVlJa2xQd3dCYUJNVEkwWlVRL2tk?=
 =?utf-8?B?cEgxQnlQL1B5aGcwc0YxN2FYQWNodW82bEJhOFhScThQS2VFaGo4V0I0QXdG?=
 =?utf-8?B?VmU2L25DeTZFK3ZKbDY0Z1RlYlhoN1BvUE0xa25BRkk0RjRxbXhPa3RZTFJG?=
 =?utf-8?B?TDYrWkh3U2daMnc5clBHbHpTRks1Ym1EdFdiYkROQ005SHpxVkUxbFlnR2dC?=
 =?utf-8?B?NlJYVVRKa1pmaHlNY2pLS2srQlhnank1ckE4clV1TCtTcHgycmwrMlgrNUM3?=
 =?utf-8?B?Zlc4WlNUem9ac0lFZWZ6bWxwdkRhMGRjeENXV2t2dmhqczRqY3Jya3A1SmhU?=
 =?utf-8?B?eHRKK0hOeTEyWFNmZytjeEppdGlCUDREaWJnaklBbVVKUUp2RG9CbjVYZFlL?=
 =?utf-8?B?dzRrZG9WTDR4ZjREVmRWTnRRUUx1SGJwUlZQcTFRZU1TdTh1UVhIYTN0Vmo1?=
 =?utf-8?B?a3ZqT1lOM01wUGV2OFNpQnVybit4ZUU0VDhDUkMyVzZyMTZoKzFCNkM4R1FF?=
 =?utf-8?B?ZnIycmlwOWMxZ3JGZEZ2b0NhdnpxdWdUaXpmSWRpTkpXQTA0cEc0K1RCVmlq?=
 =?utf-8?B?OVN5eXRlTDZiM1lPWmxwVXFTM2J3KzgvSC9UYlUrWVVmZlZ6SXpvN3FBWHpo?=
 =?utf-8?B?Rzh2ZGJGSjJZMDN6N0RiclN1SVNyNTlWTGN0L2dTbUhTcHppcUVxQ01mVnpz?=
 =?utf-8?B?R2Ftc0ltWlNsY0pxL3lDL1dVWm4xMURPL1Z0RHZZMlN0SEtVNnBNNHdFZEd2?=
 =?utf-8?B?c0JxKzhPV081YmRybyszbDIxNHNLdHlvY0hWVGVhWUhqS3Yra2JkZTFVdHRo?=
 =?utf-8?B?ajA1eTVHalZCOVVWR3piWEdjODRBWFN5UWtIdUVCUjVCQUZzTi8xSFdVOUd1?=
 =?utf-8?B?REJPanZwSTNudC92Z2xxbnAvaE51L3VVOHhuSXJaYjlrQUlqa1JTTmtRWXFz?=
 =?utf-8?B?end0ZnhaeGo3OTVJbzcrUXE2d1hNS3BPRTM4QWNZZHplQTVQUS9qQU44c0tL?=
 =?utf-8?B?OGEyakRjc2paRnF5ZU9iUjliVkFyRUhoNk5zd1Z1TW9UbXpucEtlMnhzZGMr?=
 =?utf-8?B?d2UrTWt4bm15emxra0dFRVBlL2VuSVQ4K0RUaGIxYVo0UUZmTGo4SlI5blhj?=
 =?utf-8?B?U0VZRW55OXNud3BvTlM3TTY4U3IzY292TzVZQkRUeWJKY1Bac2RYK1RmY1ZE?=
 =?utf-8?B?NUJTQXpyLzVhaU1XS1N4OWNMaGVsT3lUOEc5V1hlWU5zaFpGYU9aZUFJb0Zo?=
 =?utf-8?B?MW9DdXhNdzdHLzBha2grcWExNHJSbi9VVXZRd05odDBTTVQrNGRHVkRGWFNC?=
 =?utf-8?B?TmRHdVlwZjhUVFFIZVNCTWkxcCtGMkZ1YmNpS1hNOFkwWk95Y1hXV1dWalJl?=
 =?utf-8?B?TVVDWXV3SUFodE1Jd1o3MEZnOEJLanRlNVRsNTFjcmU3S1grYk10Q0NUTmlx?=
 =?utf-8?B?NXJDNW5jZjlMdnF3aTc1SmRpSi9panIxbUlEMmM4clo0cXFxYVFZeGRHdHVz?=
 =?utf-8?B?Z1YrTDY2MjZEbmdhTWtkZUlXMGVWd253LzljRFI1UEMxbnJMWm1JV2pnek5m?=
 =?utf-8?B?OHN6RWJCTUwxYU5vb0NqcG8yUktDNGlCVXl3SzFQYVhneEduV0Y4c1cxVXVm?=
 =?utf-8?B?WkxvazNsVVdmOXAyWCt4TFllN1A1anJ5Zmxhb3Y0aEpYS1BBVTU1clJ5UUk2?=
 =?utf-8?B?cXhoSHIvcTN1M1NkQWx5d09WMC9aVGJtUlNuSXQ1T0ppOUZNTlZycEc5alNY?=
 =?utf-8?B?RmtlZFljdGZ5VWlldWszRnhFNndmMGJaaHBELzhGaFg5emNGeWtZd0dyRzgr?=
 =?utf-8?B?bTl3aytPMUNGMUtxTndYSVJ0bmQ0cUdMbHR1dHdPcmlPSEtpMGVzeG9tU0FM?=
 =?utf-8?B?ODhETnk5YUtVOEpZK1VqT0YyNENpWjRnYXU0c2hBMG9YU1gzT3MrcXZhandm?=
 =?utf-8?B?Rll6MDNXRTlHNjhvekptNGtyeERlQ1p0NFlTcERYT25WWHJ5VnpSSFh1WE1o?=
 =?utf-8?B?dFlrVXl0V0NTU0ZpanhQM1NKU0ljbktpTnlZVC9DOVVjSDh3WmxZeDNZNVIw?=
 =?utf-8?B?cEN2c2U3OGtvdWhFUDAzM2RWU1JLdGxnRVZjMTFyelJvdUswaGExYVVLSmJS?=
 =?utf-8?B?aE5TNWRUOFZwWm9rWkxBcWlQVzJLMGxwdEtkMHI2Y0I2ODlEeFZzdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc831c36-8303-444a-4b03-08da2484d8a4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:23:42.3411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49sRAhBTj+1HjVQoiaF0v0lIIk5trb0Po/fSl4J3b43Dg4ebyd/D99m/KIXXdMfcEk4n/d92Ekt4q75IiubV2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3151
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-14 01:48, Daniel Borkmann wrote:
> On 4/13/22 3:41 PM, Maxim Mikityanskiy wrote:
> [...]
>>   /* integer value in 'imm' field of BPF_CALL instruction selects 
>> which helper
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 7446b0ba4e38..428cc63ecdf7 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -7425,6 +7425,124 @@ static const struct bpf_func_proto 
>> bpf_skb_set_tstamp_proto = {
>>       .arg3_type      = ARG_ANYTHING,
>>   };
>> +BPF_CALL_3(bpf_tcp_raw_gen_syncookie_ipv4, struct iphdr *, iph,
>> +       struct tcphdr *, th, u32, th_len)
>> +{
>> +#ifdef CONFIG_SYN_COOKIES
>> +    u32 cookie;
>> +    u16 mss;
>> +
>> +    if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
>> +        return -EINVAL;
>> +
>> +    mss = tcp_parse_mss_option(th, 0) ?: TCP_MSS_DEFAULT;
>> +    cookie = __cookie_v4_init_sequence(iph, th, &mss);
>> +
>> +    return cookie | ((u64)mss << 32);
>> +#else
>> +    return -EOPNOTSUPP;
>> +#endif /* CONFIG_SYN_COOKIES */
> 
> This (and for other added helpers below) will be rather tricky to probe 
> for availability
> e.g. via `bpftool feature probe [...]`. Much better if you wrap the 
> ifdef CONFIG_SYN_COOKIES
> around the {xdp,tc_cls_act}_func_proto() instead as we do elsewhere.

Just for the record, I copied this pattern from the existing SYN cookie 
helpers, but what you suggest makes sense, so I'll fix it for my helpers 
and resubmit.

>> +}
>> +
>> +static const struct bpf_func_proto 
>> bpf_tcp_raw_gen_syncookie_ipv4_proto = {
>> +    .func        = bpf_tcp_raw_gen_syncookie_ipv4,
>> +    .gpl_only    = true, /* __cookie_v4_init_sequence() is GPL */
>> +    .pkt_access    = true,
>> +    .ret_type    = RET_INTEGER,
>> +    .arg1_type    = ARG_PTR_TO_MEM,
>> +    .arg1_size    = sizeof(struct iphdr),
>> +    .arg2_type    = ARG_PTR_TO_MEM,
>> +    .arg3_type    = ARG_CONST_SIZE,
>> +};
>> +
>> +BPF_CALL_3(bpf_tcp_raw_gen_syncookie_ipv6, struct ipv6hdr *, iph,
>> +       struct tcphdr *, th, u32, th_len)
>> +{
>> +#ifndef CONFIG_SYN_COOKIES
>> +    return -EOPNOTSUPP;
>> +#elif !IS_BUILTIN(CONFIG_IPV6)
>> +    return -EPROTONOSUPPORT;
>> +#else
>> +    const u16 mss_clamp = IPV6_MIN_MTU - sizeof(struct tcphdr) -
>> +        sizeof(struct ipv6hdr);
>> +    u32 cookie;
>> +    u16 mss;
>> +
>> +    if (unlikely(th_len < sizeof(*th) || th_len != th->doff * 4))
>> +        return -EINVAL;
>> +
>> +    mss = tcp_parse_mss_option(th, 0) ?: mss_clamp;
>> +    cookie = __cookie_v6_init_sequence(iph, th, &mss);
>> +
>> +    return cookie | ((u64)mss << 32);
>> +#endif
>> +}
>> +
>> +static const struct bpf_func_proto 
>> bpf_tcp_raw_gen_syncookie_ipv6_proto = {
>> +    .func        = bpf_tcp_raw_gen_syncookie_ipv6,
>> +    .gpl_only    = true, /* __cookie_v6_init_sequence() is GPL */
>> +    .pkt_access    = true,
>> +    .ret_type    = RET_INTEGER,
>> +    .arg1_type    = ARG_PTR_TO_MEM,
>> +    .arg1_size    = sizeof(struct ipv6hdr),
>> +    .arg2_type    = ARG_PTR_TO_MEM,
>> +    .arg3_type    = ARG_CONST_SIZE,
>> +};
> [...]
>>   bool bpf_helper_changes_pkt_data(void *func)
>> @@ -7837,6 +7955,14 @@ xdp_func_proto(enum bpf_func_id func_id, const 
>> struct bpf_prog *prog)
>>           return &bpf_tcp_check_syncookie_proto;
>>       case BPF_FUNC_tcp_gen_syncookie:
>>           return &bpf_tcp_gen_syncookie_proto;
>> +    case BPF_FUNC_tcp_raw_gen_syncookie_ipv4:
>> +        return &bpf_tcp_raw_gen_syncookie_ipv4_proto;
>> +    case BPF_FUNC_tcp_raw_gen_syncookie_ipv6:
>> +        return &bpf_tcp_raw_gen_syncookie_ipv6_proto;
>> +    case BPF_FUNC_tcp_raw_check_syncookie_ipv4:
>> +        return &bpf_tcp_raw_check_syncookie_ipv4_proto;
>> +    case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
>> +        return &bpf_tcp_raw_check_syncookie_ipv6_proto;
>>   #endif
>>       default:
>>           return bpf_sk_base_func_proto(func_id);

