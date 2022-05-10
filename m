Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C882352249E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbiEJTUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiEJTUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:20:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03F13DA46;
        Tue, 10 May 2022 12:20:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRANBCmSgIdYkH+Iz9x0PpYArwzCPwBB+Qkc6ygKmu/SrtoI5FeNxvWGtO0rUga/m4qf46YvfSoKXqkJOo3K9uxYrznCfL8HmdBBCCiffw9PSSAFN2aVWpO2mHi4RjWueNVOYPbaSFnSW62dXXsV69WT33exzmeQ4Od1nzTeqM8ZB0JGTK24LmebZP8wovnJ4TJoqOSGMxTP3k81ldFRDgK7pRIdWYfAZRITpsHx1mvTPZ6MS7CtgvHNKHPsD9OuMf8F/c+I2+qkVuHpeRU04SsSvp6JZYWnY9VXeGr6OOQUz89pxg1BA44zy8DP6cYq85T7S2icANlSrq/toxFjuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AqgVW8PwoJ6vNjMRP78blR/9nL5EdkKjBdM3Ppy2wKY=;
 b=V+Js0D8QI4oQL4MElKiGTSDOKGbDWf/hS+8aJuq/GVFhUGUUugYrwxgOysevrggO/ZafCsghO48dXUf4HMzoBmetYMiccvjHIGrLkVVBSlJlZGVVaRCW3x3Rww1xJbOrwC/+MXLKEaFSZJC8+jt1E+h6V18CGnYknHryxK/LSfsgdPd7A5uT06WEuM0Kbhv7dq3QkrQi44bKUrhJlqhu6T6q3JyzBR45bUyogO1V760G/pwTpm1X+rPZh+cf7kL04WxRkRD80jJmYc9tNuKT47+nVA6Lcy5fST97eZ2cVyztRvk5eut5uUEL972NEk4+BuGnUymAtWKMms1B9nBj8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqgVW8PwoJ6vNjMRP78blR/9nL5EdkKjBdM3Ppy2wKY=;
 b=LiAWuQF8nmYmcyb/A2FmdAA/AvQ71rs5TZwjD+Fl6uEr/YPSwe2FslcZBeICcNJPCgrhpQ5niDNRJoSgCATREy242q5FYZPHOWwfY679OJ10PgbiJMKMIrktmTs/N9LFfoE8KQVco/XcRfy0ta7ESx1t7y6Z7kO/aH5hd/guj0RVOr999jwYXew32NLIZTcGI5CyDT3xrjiQD57evNs+YwC2h+B07Lj48FlT6DX9ZrjAJjcI4ucG1IGzTXenBdh9L4GzLf2wGrv1H4CwWEBRKQ9GgkWILIeIkQd9l/SiiM/2RPmsYBqGQsUHZwv9imUVvIhuebximIihRjzkZ1ainw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BYAPR12MB2855.namprd12.prod.outlook.com (2603:10b6:a03:12c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 19:20:48 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:20:48 +0000
Message-ID: <1eaebd1b-6933-20c9-1371-0429703bab2f@nvidia.com>
Date:   Tue, 10 May 2022 22:20:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH bpf-next v9 3/5] bpf: Add helpers to issue and check SYN
 cookies in XDP
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
 <20220503171437.666326-4-maximmi@nvidia.com>
 <CAEf4BzYDfNuF4QL37ZLjR5--zimpycZsjzXhq6ao79_05+OOiA@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAEf4BzYDfNuF4QL37ZLjR5--zimpycZsjzXhq6ao79_05+OOiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0081.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::14) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eea7d1d-efc2-4da6-b0f3-08da32ba3061
X-MS-TrafficTypeDiagnostic: BYAPR12MB2855:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2855D11BD263D87111BB1245DCC99@BYAPR12MB2855.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFK7m96ieDfyxIO7iDyfKgcLfewgXyoPyHtF/Q5hQfQHRRNZLpqPz2yUf84d1NHQymDgMolrFxgdHQyMNKvVDRKZMRQOrvbEppXtt2uvD+4JsmDV++4T1/orE4RIhCUgrUL/VxPI6F8mqKrd9+21SBCq1NUNPXytWxS2E4RTyadlBJ51p2a+oiAUtinrjfMpqZM999/3ok8ZErVr/dqYy7am/aldfmTjGFCS4bUAtWCdCCMpyeinOr3+/5A8shUrW6h2mymB80ZzvFICAE+BxDD2dq/HuXkP3EDxnTK3m3aQ4hGAcYPKMzxTgY+WkE/CnpZoDzw3ZOWbeEYjWawmRzvkjaNfcX634lAQ5wiDUA3ZFHMqTRGCaMDd/hvmwkrZqwjShrOBPy/R7rb2poYMWf881BRf+uS6UvcYv3DNR067lwyPeHAVdDJm28bX8nGoLEIIISbVALfK7fOrCrEXczmwswW9OiOwQq9ZXHQfEGTTYcrrjM/xb9xdxhws+WNIecIZIYDNHsUOKkOKfl85j3LtbgiDIPUf1ppHqTaMRYIia7/ujPmPK3pJKRY8pF02rDPmjR3U6BTbtH0VWzSRXY01EBbTOagdFwMuxuydQ1UfO86GoisxI+0RqnfEPdC6PaV5hvA081Fk6RLywjs+niJ2BXULI/Oy5PHtENixwXM2A7IRHcNX5bCytcS0ph0uF5skOwZbzU/xu7O5JM7SsUAQkSDUj9XtX93zKe5jnUQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(86362001)(38100700002)(83380400001)(6512007)(26005)(31696002)(2616005)(186003)(66476007)(31686004)(66556008)(8676002)(316002)(8936002)(4326008)(66946007)(36756003)(5660300002)(7416002)(2906002)(508600001)(6486002)(6506007)(6916009)(54906003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlRWb1FsOTVlTG5mSXB6NlNXNkE1VTlLcWFxMThIQUJDWVE5TWJIbEFRaHRj?=
 =?utf-8?B?UjkzcjZTTDhQR1BCWkdMaWJnemZhRDg2RGpjYzNpUG9pSDM2YzE3R0llY3pK?=
 =?utf-8?B?d3NkYnV1UWhCQ1ZLcHZRNFZTdUNqVkNtQnArWCtvTWJHUzFyeUdLb1pvWmR2?=
 =?utf-8?B?ZGpvdW5mWERmNzdCaE14SWF2blU0QXp6V0VxcVlwS2dCZzM1czVzQ09nN0p2?=
 =?utf-8?B?cC9aRFFOVnQzZGpCUENqZ3dzM2xoeHJhQ1FLMkJITml3ME1hZFNVUXRiQmth?=
 =?utf-8?B?VTkzM1RrdEY1ZFAwUFZ4TFhQMmFsazNVaG5FQStiS2l4RjM1Y2JnaTN4aDFW?=
 =?utf-8?B?d1JPb2hoOStSZjRJTkNLZFNwR25ncm0xRWo2YkFjUGNGVzAwcTNTZWs4UmhI?=
 =?utf-8?B?RzlhR3lwZFZJaUZpb3dZRWlhNWJzbUh4QWQ1TDQ0REMzMjFiOEk3Y2IybTda?=
 =?utf-8?B?MjV2VHA2QlkxMkZHUU5xZWpXa3ZuK1B0eGhBK2dJZWoxdzAwbGszd0FwYmVT?=
 =?utf-8?B?Z2xWTzYrUUV6VkVLRzdTS2tQL3BZRWszMEJIVzRzTGpsRGJZMlo4dFhMamZO?=
 =?utf-8?B?QzhvSUNtL1VITmVQcUljSlBIK3luZEp1TkZuWVlmWEhsS0RZVVdYSXNGMEtJ?=
 =?utf-8?B?WWpqVzE4L08zL2NZY1pEc3ovcGVraEJCOWhNcm1UOS9UOStoaTVlQmFPZXd5?=
 =?utf-8?B?TjZObGxMM3lDQ2duakZkeFllRlhVWWdMUWpZem5UMGFRS0lodU8wdGMxNVJV?=
 =?utf-8?B?QmEzVWtlOUFoanF3QmxqTzF4R3BUVjRZMER6SEZ1dkFWSnJsR0U3ejJZVUQv?=
 =?utf-8?B?dHlsRTVTMldsNHZkWFluTy8vbUgyWG1NVmFCVnM5LzRFbEJ5dUF3c1lkUWky?=
 =?utf-8?B?ZU5uM2RmTFc5S1BjNDh3T2FrNHJ1V0ZXK0hhNFkzNXdycU00cStqZWxEUW92?=
 =?utf-8?B?bXQyQXBucmZyeWZxL0kvREFnbERXUHo5TjZTSjZ6aGZKeHBHemRuWDhndEhX?=
 =?utf-8?B?U1Fac2dnMndOZ0Njc1piRXEvakZqOGpOK1JJN29hSDFWL3lSMUZmQnFGT1p1?=
 =?utf-8?B?cHBOMGJHKzRDSmM2bFdzLy8xRkd6WmFoSmdYOC9Wb3Z0UVBYTFkxVXFjdHR2?=
 =?utf-8?B?MS9oenl3TVdBWlp4YnV3YmJzNTlOOVVSblVlMFlRSUhtWTFDQzFUWVprcHo1?=
 =?utf-8?B?eVlyZ09CY0N1QVBEaGlsMktKTngycE0xZ1E3RU9TWHM4dU1NTDVQckRHaGJH?=
 =?utf-8?B?b2d0bDdMV05WMnFQZ0lraG94QTVKUEJBR3lDZURtWkVEbDdwOEQwNW5VZk9k?=
 =?utf-8?B?VTN1Q0FsWHFiTlgzdU5WQ3NyRnZsb0Z0NEM4YXNNOFZCMkdBbmIzS1A1V0E4?=
 =?utf-8?B?aDRkSjlETUpkL3k0Ym9YZUY2bVZHUUtQaFBuY3YxeXVVTitiQkIyS1JON3NQ?=
 =?utf-8?B?L0ZrT3RSdjU0MEZsQ1FsdjF3Ykdxb08zeUU3cDl1TDloNVVzNk0vKzd6bmVj?=
 =?utf-8?B?WURrTFE3N3NXYnBHV0lSRndUOHdUb3ZIWDIyUjdLWDVYUFdJZks2V29LbkZn?=
 =?utf-8?B?RW9QcjA3SWJZZGd1eFp6d3FBYWoxQk44TWVObEF5UEFUbWVGcFJ6MVdVQUNH?=
 =?utf-8?B?alpDZEpXQWx4dWM4aTlkK2pYNVErU1V3QlVybVpiSUwxRkVZZ2laRVN5TjNw?=
 =?utf-8?B?ZEtOeWR6VE1mMnJ2OUUwQVg5aFJtSXRDblhMa2VUby9USGJKZVZvWEUwdHk3?=
 =?utf-8?B?U1kwU3Y0ZktLdHJvNWFGNHpvREhlb1pBS3FTbDJRSVcxalg2TUpTUmdkNkU5?=
 =?utf-8?B?ZFh5RlBDM0s2KzYyY2pFek1IRWVJMzZ0RU5ITnhBdHQvM2tGVHF2eUYreEYv?=
 =?utf-8?B?eWMxZEJDdWhsSVJyWlp5UUNxQUQwQzAyU3RTcWtmNXo1SXdMK09tbEJxcGNv?=
 =?utf-8?B?d2RCZGthbVBQcWd4T1AwWERvcDA1ank1eitrVlRCNU9nWjd0OFJoZHZKaFVX?=
 =?utf-8?B?NE1US3FGM2s4VVgxZ205OEVQZndweVNCOUhtMDN4aGpEazFJRXVFeWJSSFp0?=
 =?utf-8?B?MzlCN01YV2xRem1xQ3hhMTBvYjgyd3BidHBSVmxYbzI5V3JQZEdxZm1rangr?=
 =?utf-8?B?MjNaTEZTODY2UXhsQ3U5ZVVZNm9LeSt4VjRzeTRQVC9hVUR2L2JZc0pSN0JQ?=
 =?utf-8?B?TnFNaklWYy9HZStTcWFQa2UxUUthQ2FDcitPSmZKV3RsbzlIRUduQjRaTGFu?=
 =?utf-8?B?bU1EdHIwakIrOEZzVnRsSjYrdlpmaldmMjFPd1RBRUhXbUNtWktMd2JIYWhh?=
 =?utf-8?B?NnVSbVk5ZW5VeXIrSUhxNnFSY0pJdXhIc1JvN0lBSFNFRFoyRjh2Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eea7d1d-efc2-4da6-b0f3-08da32ba3061
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 19:20:48.6954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsEojl5A1lD/7r/QV1EgwhntSrd1gGqhNAi91s0NfHCsJUvMr6A9nkngHnxTRqUq1HbHONxdKL7t2oFBUIVHnw==
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

On 2022-05-07 00:19, Andrii Nakryiko wrote:
> On Tue, May 3, 2022 at 10:15 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> The new helpers bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6} allow an XDP
>> program to generate SYN cookies in response to TCP SYN packets and to
>> check those cookies upon receiving the first ACK packet (the final
>> packet of the TCP handshake).
>>
>> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
>> listening socket on the local machine, which allows to use them together
>> with synproxy to accelerate SYN cookie generation.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   include/net/tcp.h              |   1 +
>>   include/uapi/linux/bpf.h       |  78 ++++++++++++++++++++++
>>   net/core/filter.c              | 118 +++++++++++++++++++++++++++++++++
>>   net/ipv4/tcp_input.c           |   3 +-
>>   scripts/bpf_doc.py             |   4 ++
>>   tools/include/uapi/linux/bpf.h |  78 ++++++++++++++++++++++
>>   6 files changed, 281 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 94a52ad1101c..45aafc28ce00 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -432,6 +432,7 @@ u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
>>                           struct tcphdr *th, u32 *cookie);
>>   u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
>>                           struct tcphdr *th, u32 *cookie);
>> +u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss);
>>   u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
>>                            const struct tcp_request_sock_ops *af_ops,
>>                            struct sock *sk, struct tcphdr *th);
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 4dd9e34f2a60..5e611d898302 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -5156,6 +5156,80 @@ union bpf_attr {
>>    *             if not NULL, is a reference which must be released using its
>>    *             corresponding release function, or moved into a BPF map before
>>    *             program exit.
>> + *
>> + * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
>> + *     Description
>> + *             Try to issue a SYN cookie for the packet with corresponding
>> + *             IPv4/TCP headers, *iph* and *th*, without depending on a
>> + *             listening socket.
>> + *
>> + *             *iph* points to the IPv4 header.
>> + *
>> + *             *th* points to the start of the TCP header, while *th_len*
>> + *             contains the length of the TCP header (at least
>> + *             **sizeof**\ (**struct tcphdr**)).
>> + *     Return
>> + *             On success, lower 32 bits hold the generated SYN cookie in
>> + *             followed by 16 bits which hold the MSS value for that cookie,
>> + *             and the top 16 bits are unused.
>> + *
>> + *             On failure, the returned value is one of the following:
>> + *
>> + *             **-EINVAL** if *th_len* is invalid.
>> + *
>> + * s64 bpf_tcp_raw_gen_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th, u32 th_len)
>> + *     Description
>> + *             Try to issue a SYN cookie for the packet with corresponding
>> + *             IPv6/TCP headers, *iph* and *th*, without depending on a
>> + *             listening socket.
>> + *
>> + *             *iph* points to the IPv6 header.
>> + *
>> + *             *th* points to the start of the TCP header, while *th_len*
>> + *             contains the length of the TCP header (at least
>> + *             **sizeof**\ (**struct tcphdr**)).
>> + *     Return
>> + *             On success, lower 32 bits hold the generated SYN cookie in
>> + *             followed by 16 bits which hold the MSS value for that cookie,
>> + *             and the top 16 bits are unused.
>> + *
>> + *             On failure, the returned value is one of the following:
>> + *
>> + *             **-EINVAL** if *th_len* is invalid.
>> + *
>> + *             **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
>> + *
>> + * int bpf_tcp_raw_check_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th)
> 
> Note that all existing helpers that just return error or 0 on success
> return long. Please use long for consistency.

OK. There are some existing helpers that return int, though: 
bpf_inode_storage_delete, bpf_get_retval, bpf_set_retval. They should 
probably be fixed by someone as well.

>> + *     Description
>> + *             Check whether *iph* and *th* contain a valid SYN cookie ACK
>> + *             without depending on a listening socket.
>> + *
>> + *             *iph* points to the IPv4 header.
>> + *
>> + *             *th* points to the TCP header.
>> + *     Return
>> + *             0 if *iph* and *th* are a valid SYN cookie ACK.
>> + *
>> + *             On failure, the returned value is one of the following:
>> + *
>> + *             **-EACCES** if the SYN cookie is not valid.
>> + *
>> + * int bpf_tcp_raw_check_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th)
> 
> same
> 
>> + *     Description
>> + *             Check whether *iph* and *th* contain a valid SYN cookie ACK
>> + *             without depending on a listening socket.
>> + *
>> + *             *iph* points to the IPv6 header.
>> + *
>> + *             *th* points to the TCP header.
>> + *     Return
>> + *             0 if *iph* and *th* are a valid SYN cookie ACK.
>> + *
>> + *             On failure, the returned value is one of the following:
>> + *
>> + *             **-EACCES** if the SYN cookie is not valid.
>> + *
>> + *             **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> 
> [...]

