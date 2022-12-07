Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90736645DA0
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiLGP3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiLGP3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:29:05 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2058.outbound.protection.outlook.com [40.92.89.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A17101CB;
        Wed,  7 Dec 2022 07:29:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFJOTpYa8cMif8UoVobmNuRp1btEwACqSbqz5DMOhDxzwjMGQRY5omogfXmUlJAy9nznoew0dzMtTcA0gss9h9ZQ+3QjvjSHllr17bkz1em7U+gu6z3BeyPdsWOnBjLyn9Xdd1oKl4oLf8rvRv55oH8x81lI4PsoyxF1qgC87hkjC81hv0y4KdvwC5VHvo2kKuPkzBGxJmPf4YpLO2emIoZ7T0Up9vbMdVemNxOPP5r3ecL6moVyR//2bjtWIB7jqOic4rqZz5LPYNWe2bSqKHr3yYTascpvk0tY2XBsmrEi/5+8QdvO6EmlOBnq1jc10e2m2wk7uOAoAGpdm/adOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuZ21kH4NGW4q33dGSpTBj49Xh/eRujGvaiqZPQ/trM=;
 b=ab4capwCmFuKzo3jCbnKDJ9pmyHb4dIiC0EXnDiL5YTFk8dM+EPdSd/2odCy1QgxmRPZ1DCflnR5r2BxDaSi0zzcNaDHLy5z+1YMDUSFz41HcNjGePYEArEzJKc5X3h3RGLAH3RzTC5syaaLjlBf1a2upVoxeLKHXFhvuhdUQmvz+z9SYcNo26WqMaqYZWGeynY5VXIJ4t1LswgUMa979K0ZeBQ3k3mExsScElMKsH+4+1nWdijuMk/AwfNmwz8uCVsDBDMk/nj09G6Jn1hAl1GTq32GrQfEnk+bXeE903IjJaMwAWzkv94Qw9wRJjsyjtqLVfen4YZMagDJZvl6kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuZ21kH4NGW4q33dGSpTBj49Xh/eRujGvaiqZPQ/trM=;
 b=ZPjSjkTlq1eWtm0Q4O6mjKvssakCOi96xjie/j+fMiQgEuY4/g8RUBys+GRd5TES7pnFZonks1GpnG4X4FGqNaTWW0fwS9LaT4chIyVlqLMVX5qj4JU73OotPXI4uX/eIhaY7R4FD06gF/2eTNSpNx/jXs1pC4Pzown+uVc1L7hbZem2DeDquKyBAsk7lxgHF3aSp6BNwEjTMKjMiu3Vqn1z7EQQ2r6lIN6xDqEpJ6FTOfkFSSS/1Lmx4oso9GDAAGUGaktE/Nh2Mi0fmPwLthgJMRpRC1av/CFWSHSctVJpnMcMYg/R7AO0xjn/gOh2zrL0NJyv1kKezjOmFWDgIA==
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:34b::15)
 by PRAP192MB1458.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:29c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 15:29:01 +0000
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b]) by DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 15:29:01 +0000
Message-ID: <DU0P192MB15479DE3A186319F999748E3D61A9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
Date:   Wed, 7 Dec 2022 23:28:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH bpf-next v2] bpf: Upgrade bpf_{g,s}etsockopt return values
Content-Language: en-US
From:   Ji Rongfeng <SikoJobs@outlook.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        andrii@kernel.org, song@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
 <deb77161-3091-a134-4b82-78fef06efe85@linux.dev>
 <7901fd2a-e6d5-8176-73bd-b910f8abee33@outlook.com>
In-Reply-To: <7901fd2a-e6d5-8176-73bd-b910f8abee33@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [xmLTBxQN79R/Mzxphkbf3KP9t61C69Mz]
X-ClientProxiedBy: SJ0PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::28) To DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:34b::15)
X-Microsoft-Original-Message-ID: <291c6431-05b7-3709-68eb-3aa92ea80913@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0P192MB1547:EE_|PRAP192MB1458:EE_
X-MS-Office365-Filtering-Correlation-Id: bd84bd63-9dd3-42b8-34c4-08dad867c460
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kfavVOOpeqPlyMqUN7M3FTgZ8xfyDYHZZ70dDC8ZmKx45Jy75M8ue8CnX0CZ6ecsZ36R84S+UBJ/oUWtnOhNOhh8OnmImK+5cyLTll5XpmU0k1zX896LY0uvl9YfH2uAOWnP88wI/Ymu36heJWMtJxrcl75zvGjFSixE/oqYKPjuAjztJVhcAe79apaVwMUagv3nc6PL4rIGe48tIJLZft++X+IvfZHQsDvnEL8OvcvJaouln60/9JZbgMBrt8xoeniGj+YU4/sa7R60S8QlsobHkig2mXkt5BbAiab/9q57OkbiD1CB95ZRUBwTUI3qkhMwAeLp5t9k8KYeKgZakPwguzJmmWwHLJ50tvatH7nyjCSF4Yjl4AlCicR+SHwRs+Q0Rvx26AOLt/K7CRW9pqMdqz78jMoyCi4iIiO1BoCr+HY/lQTpy8Kid9luSw7mLRZNFZLuKQBqUN1BWHE5NsMDD/mAKLkejkXskJf3zJAmZ39/Ki4wlkA/a7vQePYJKF/CYtRantEB8+qtJmUwtG3EaKtI/E/RBuNoRYS+CLL0B68uJ34vwOjdoYJK4iNU1W074qRAmDsFbebnm0Ht3spYoqYYAGftaYQYMpae24OrBwbcOaa8IZ5NDRIfPAwPW9973xzbEb0FpPmSFEp5+w==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZExIOFEyeUpDTlE4SzZzL1IrOGJlOEhSYTFndVhnQytaTS8zMU5zcFNzTVRl?=
 =?utf-8?B?RHFNM1ZZZERNdTJ5UFRKSUVKV20rWSt3ZjI3MDk2a3dFRWx4NmpETmRZeWxB?=
 =?utf-8?B?dXBPU2YweFZxc2ZyN0tjY1FVVGFRMEJYdUFNazZ6bGJ6YkVTTWJhQVpENWp1?=
 =?utf-8?B?SmhNcytXdXU2ZzNoRElHM3BsOFBPbUFQVjlXL1RTb1p2a0gya2M3WmJ1akFv?=
 =?utf-8?B?WXFsUmFjYlVtMlFDUEh2NTg1cCtaVWl0ZmxrbFNMb0lSNUQ0c29WaTJFTldj?=
 =?utf-8?B?SEZ3ZDhZZDlzZ2hKOWphYjRzTFRyanRscDFLdENmUU1JVHhtR3ZUdTdjTXA3?=
 =?utf-8?B?YTFSVElLdkdGQWR4V1U1M1dudnZZdmJpejJCdFlYWURKQWtVR0IwS1E3bnYy?=
 =?utf-8?B?eXM3cWx1OWc1eDJKTkt2UkRCRUg2amt4b1VxY05LMGZkYk9vNXJGWFN5d210?=
 =?utf-8?B?cEhnb0NQVndkQ1BDbnZlalRzWGFpN0NsOVg0TVc0S2lNbHV6OUlCa3lwNG5r?=
 =?utf-8?B?OWdncTVLbmNXQ0g0U0VhQkREM3kwR1N1dmUrU2czaElUejRSREZ3Yk42SWFi?=
 =?utf-8?B?RkZzb1o3WThFMmJNWnVqRU45bXJ3WVp3NUxnTTJNM3ovQXMyMTg5Z0lITEJX?=
 =?utf-8?B?L0IzT1dLcUsxL1YzR0piY3R4NVBjSUFweEplWVRJOHU4S2hyU3k2WFRPY0hS?=
 =?utf-8?B?Vy9xeDRLTUJrajlOV0kxYmFkbDlick1oOXdzb0l1UWFaTnVIakc4REZVVXp0?=
 =?utf-8?B?cHVnV0pBQkVETW9UY3M4Y2lCeXVuWDQ5ZHpKMmpGWGx0ZzZvN2hxd0pWek5B?=
 =?utf-8?B?Zk1VdTRuSDJxdEJ3TmlnajhaV0twOHVidDJmSkROaHAraTFaV3JUT1dMbk9L?=
 =?utf-8?B?N2JYZmZpQU1JS1FNakJzV1E5RWdUeUtUOVJ5WGUvQnB3VHZFaFlxL1NMWHhL?=
 =?utf-8?B?QWlWRXc5S0toMGJ2MmNHS1RXNlZ1bU9kZ29Cc054RkFqK3RHZWVpMmdnOXpL?=
 =?utf-8?B?NE5uWjNmVUpiVUZPT283b3gzYkxSZ0hUelZCZHdtdWNTNVBpTW5pK1hXM2Fp?=
 =?utf-8?B?VlU1d0NiamdGWmdLVTZQeklIZkwrOFd4a0RWRU1XdVoyVG1MUFovQlFsVEpu?=
 =?utf-8?B?Y3dHWDZSdUR6UHNnWTdnM1d3MG1IY2trL1I0OEhXeW5KYkU2MTQ5ZFBhMVBM?=
 =?utf-8?B?OWdpY0szV1pYRzRkUjNmMjhzT2xxVTdjaWhoZG1aOVBMcnM2bXRwZE9YQzNS?=
 =?utf-8?B?UzVGcHd4WmVvTGNHVWRSTTQ0eERJUS8rUFdHOTRPRGtxbFhZRG45Y1VUdmtW?=
 =?utf-8?B?SEFyTnNPUURUU1FEN2JFVTA1cHBUU3N0UDVMdlg0TWtFZG8zV2FSNGc1WEpm?=
 =?utf-8?B?bjNWWE13RDBudVhRTmY5M3hTZ3BFTksxMWZXOGpMcDNGSG1uVTI5elcva2lS?=
 =?utf-8?B?SmY0UUd1RVJXd1FCakJxWnk5UnYwU2k4S3plczlYaWEwTUxjZ0dPUW9HaTFh?=
 =?utf-8?B?Qy80bkRYcTkzd3pzRDV2VTViZzRYc2ZJTWtaZ2pXSTk5dVE3TVBmUjZjTHNF?=
 =?utf-8?B?SUtYZUFGRzAyakRweCtwWmxIZW4rN2M0T2psWTFkdS9ReWxMN2ZFTjFVYzMr?=
 =?utf-8?B?VGZTdU84SDNiNWxvOGlhZW4rUkpId3pNWER3Qlc3YW0zYlVCSjFtTm83NjJB?=
 =?utf-8?B?ZHJheFZYMmJiVDljOXlmL2ozbTBTRjQvUVc1QjdWbmI4VWQreHlzbWt3PT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd84bd63-9dd3-42b8-34c4-08dad867c460
X-MS-Exchange-CrossTenant-AuthSource: DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 15:29:01.7809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PRAP192MB1458
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/7 19:19, Ji Rongfeng wrote:
> On 2022/12/7 2:36, Martin KaFai Lau wrote:
>> On 12/2/22 9:39 AM, Ji Rongfeng wrote:
>>> Returning -EINVAL almost all the time when error occurs is not very
>>> helpful for the bpf prog to figure out what is wrong. This patch
>>> upgrades some return values so that they will be much more helpful.
>>>
>>> * return -ENOPROTOOPT when optname is unsupported
>>>
>>>    The same as {g,s}etsockopt() syscall does. Before this patch,
>>>    bpf_setsockopt(TCP_SAVED_SYN) already returns -ENOPROTOOPT, which
>>>    may confuse the user, as -EINVAL is returned on other unsupported
>>>    optnames. This patch also rejects TCP_SAVED_SYN right in
>>>    sol_tcp_sockopt() when getopt is false, since do_tcp_setsockopt()
>>>    is just the executor and it's not its duty to discover such error
>>>    in bpf. We should maintain a precise allowlist to control whether
>>>    an optname is supported and allowed to enter the executor or not.
>>>    Functions like do_tcp_setsockopt(), their behaviour are not fully
>>>    controllable by bpf. Imagine we let an optname pass, expecting
>>>    -ENOPROTOOPT will be returned, but someday that optname is
>>>    actually processed and unfortunately causes deadlock when calling
>>>    from bpf. Thus, precise access control is essential.
>>
>> Please leave the current -EINVAL to distinguish between optnames 
>> rejected by bpf and optnames rejected by the do_*_{get,set}sockopt().
> 
> To reach that goal, it would be better for us to pick a value other than 
> -ENOPROTOOPT or -EINVAL. This patch actually makes sk-related errors, 
> level-reletad errors, optname-related errors and opt{val,len}-related 
> errors distinguishable, as they should be, by leaving -EINVAL to 
> opt{val,len}-related errors only. man setsockopt:
> 
>  > EINVAL optlen invalid in setsockopt().  In some cases this error
>  >        can also occur for an invalid value in optval (e.g., for
>  >        the IP_ADD_MEMBERSHIP option described in ip(7)).
> 
> With an unique return value, the bpf prog developer will be able to know 
> that the error is "unsupported or unknown optname" for sure, saving time 
> on figuring the actual cause of the error. In production environment, 
> the bpf prog will be able to test whether an optname is available in 
> current bpf env and decide what to do next also, which is very useful.
> 
>>
>>>
>>> * return -EOPNOTSUPP on level-related errors
>>>
>>>    In do_ip_getsockopt(), -EOPNOTSUPP will be returned if level !=
>>>    SOL_IP. In ipv6_getsockopt(), -ENOPROTOOPT will be returned if
>>>    level != SOL_IPV6. To be distinguishable, the former is chosen.
>>
>> I would leave this one as is also.  Are you sure the do_ip_*sockopt 
>> cannot handle sk_family == AF_INET6?  afaict, bpf is rejecting those 
>> optnames instead.
> 
> -EOPNOTSUPP is just picked here as an unique return value representing 
> "unknown level or unsupported sk_family or mismatched protocol in 
> bpf_{g,s}etsockopt()". I'm ok if you want to pick another unique value 
> for them or pick three unique values for each type of error : )

Sorry, I meant "three unique values for three types of error", which is 
growing more and more sensible in my mind as I'm thinking about it.

> 
>>
>>>
>>> * return -EBADFD when sk is not a full socket
>>>
>>>    -EPERM or -EBUSY was an option, but in many cases one of them
>>>    will be returned, especially under level SOL_TCP. -EBADFD is the
>>>    better choice, since it is hardly returned in all cases. The bpf
>>>    prog will be able to recognize it and decide what to do next.
>>
>> This one makes sense and is useful.
>>
> 

