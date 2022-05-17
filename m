Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157B3529785
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiEQCzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiEQCy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:54:59 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBD74551C;
        Mon, 16 May 2022 19:54:58 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIXGYA020556;
        Mon, 16 May 2022 19:54:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KYcC2lUkH3rppfHC29pjSfDcJKb/BggBI655Oqa971s=;
 b=ee44cAr9s7PV7EbgLDOksbU1o1vCepEBvDUEyL61gW6V7XlxF7KxlXH53oMnJP6s8Q1m
 DKBcrSPjNt7wo+Y5baMjzJc3Cjxrqen5MYGvNn5DFWVDiB6lKWN49tw55RFo4exIo0cr
 nmpx3I1lxjXIyJLi3f6+YaHZzVT7ZNjnfEk= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g29xxp5he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 19:54:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwPECKFn/kAJkfhDYdcKU2niPREtM0JfAHoaEYhfSOnqT68Ec7HgrQKZvlrfVfwr24hfyiNaFwdrv3A87yiFUZeeBUm6WQavj1l1q6UuKftPbAoImc7Hx/pX0LObJU+Ij3peqeos9POorfo7qXqoAhaS3avT8qX0+rGot1VkLOhCo/aSrWrlVKRFiErkPsbUXEwzHBBOyWxgBgJCZq7ugZrAgs7PQ+OgIAf1xNRX+8bJKLClPIaMTVAZMQFbFDLQD4oaGHlnBKIU5aCmYoicGG1aV1ADQCYjzBau5YnbY4h0JW9YLjl1EuL1mDUkxMqBWfjtKYGrBsI6KZ+yv+tj0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYcC2lUkH3rppfHC29pjSfDcJKb/BggBI655Oqa971s=;
 b=ZfPpOq98+DOnO5Hz7MH6JJwwtbDvvQlxlcwVTtWEEmsOOhUKYdK13202MSGjPS0qIW1bc0sdsmBo+/cFjRYbdaQyr5HJCK4QahDIak5dF5pNLOiufnpQ3/DXuwtOqy+PGSK2lFGrCQlKwh/+u9Vy5h/N3CuqbZkxbpKKazmDCZr6uNGwJn/RxsmwS9VusS3Oh7RyNGoHERkYwN7CDEjQP3LcvxEAdNZn4AY2gLFLoFKWZj4gSedSILUrr/lxChDP2g2K79easQk4hRp2RsjO/HrS4tvyoKoQbz48SGBtPwFMwmxbJPg+8UobTTHrRDdRYArB7374D0EmNm9gRmPlOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MWHPR15MB1455.namprd15.prod.outlook.com (2603:10b6:300:bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 02:54:40 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 02:54:40 +0000
Message-ID: <5b4bd044-ba88-649b-9b85-e08e175691f9@fb.com>
Date:   Mon, 16 May 2022 19:54:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next 1/2] cpuidle/rcu: Making arch_cpu_idle and
 rcu_idle_exit noinstr
Content-Language: en-US
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20220515203653.4039075-1-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220515203653.4039075-1-jolsa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0103.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::44) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f242eff3-a7ed-41d3-807a-08da37b0963b
X-MS-TrafficTypeDiagnostic: MWHPR15MB1455:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB14550F4A51FA776C5AA6B67AD3CE9@MWHPR15MB1455.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8A9Pfs+vXsfPsIAEcXrq9Jb0tr4RfVgGc8PCbMlJrmbJv7IYDuAYLW33/Q/pAEEiwbt4pZIcmZZVijKer0KKxXAOMVttq8BFmnwJLnK+6eFn475LSiBwWPli30tBzYJX4HrCsr/Y8DWIH4JFjA5d1J51WCoC+cxujHQNObYCVPLBPKWVwGCRNrq9dtB2jvzmBaNUvxecEp7PtwNha/WXnwaqq4fY87Rt2gddAfM+OeWE+Qjm74YRMgtXLe0cuxoVl0MZKrvfFclbPdRzvfrIcs8erLfPOoFsskyt0pERzVtO/ULKYK4aX/34ysJ1lzNV9jeGJEUPsaFZKxacPz7wcd+62quKLzOUsZtl8/qqxdpmtmUCieW4n4/CqoCyW/jK172WV6AD39XUINT1KAEVW/8GglCI7jsnhBAnKkHp+7++t9pQGgV4DaIrzBvGVPMjIddxhftVWIASPdwQx2wCld1AG/xdZ8DlCD7RoahYpAjmRo2jtKMf8KZpbuNNHJlcAryTVRH7s/RaGUivCpo9rLmb/tOgrAYeNA57z92O6B/WFGrkbgzMDmnTvfqKUUpQcZNe51gm7xqEr5b4uaMaFUSRJKS7C5MWGGIxgn45dq7xPfyhieNMzOj90g5GYNOLIvDlZjjm6UrXZ19XObDLw2e7WMdpfcAIZTvgqesTifM27sultlGiInSB/5lYLpLICTWH+exc8f0599bCNDsG0ERwnpHJ2iv4TN3/kT1A1d6A43ZhkPxsH+ajPsclqqT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(4326008)(66556008)(8676002)(66476007)(66946007)(86362001)(110136005)(6486002)(53546011)(508600001)(8936002)(186003)(38100700002)(5660300002)(52116002)(7416002)(2906002)(54906003)(6666004)(316002)(2616005)(6512007)(36756003)(31686004)(83380400001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Znl6aVVHdDRac0RSbmE4QTkwWWhQVlROZzNuMG9CODJvV3dlZWJ4OEVWaHgx?=
 =?utf-8?B?OUJVMjlFK1EzbkFEZkYyNTRBT1E1dEREYU9YTHBuQWk2QTVtK1Z6d0xEdlpZ?=
 =?utf-8?B?dmJ6R3Y2eXNSeDIyYXZvRSsvOUI5NzVScHFyR2VCWUIwaVgxR0prS1dvcUw4?=
 =?utf-8?B?NnVRdi9BQ0pWRnhpc1NXeEVqV1hTdVZJR1dUaGdsS0tySStIUHAvUlc3Q210?=
 =?utf-8?B?bmFkY1NYcC85bG9HZE9LM004ZlRyUlQ2MkQrb2N0NlMxWHhxWTVCSEsrUXNv?=
 =?utf-8?B?Z29ORFlxRlRxUmo5dE9Oa0F3VEFOM0VQMmR3SjlmNE1iQlpjVWllZi9YeFdB?=
 =?utf-8?B?YjcwZElrY0ZteHAybEpUM2o3SDl6S1NXZUdWNUNrV2gvTStEc0FsME5mcnI0?=
 =?utf-8?B?VE11bnlTSWJid2FDbkUvVVJGREVMSHUwai9uRXVTUTZaRHg0SzZLb3VxdGxs?=
 =?utf-8?B?L2lwOGhTN1dFUkxvTTU0c0tjZjd3WVZqakQwamhwaGpPaDdqTzdCNUxJUU0z?=
 =?utf-8?B?SWtQbHF0M2lHRnVwNG5Za3puL1BTRUs1N3BubFhGMjc1aENlN1RjYjIzeWor?=
 =?utf-8?B?dndWL0t1RENZSDRXbEw2REFRN0dVbU9RWGtiM0dWWHJ2eWU3aGd3ZlVLL3Fn?=
 =?utf-8?B?eGRWaXZMZDFSQ0JRSm9LWUZya3FQbk1jVzdWdFlaTEo2WWlGZzVSbFZtMXBU?=
 =?utf-8?B?NjhUeEswUHl5d1hHRkNGMDVZTk1XVkliNTR5c3NvdmRvVEE1TFlWaDlCRU4y?=
 =?utf-8?B?WWxuR01PckI3bkxzeGkwMmVwV1c3SlBkTHBuSVEvU0lHNlpSUTNvQ0RCVWV1?=
 =?utf-8?B?OWV3b3E1TU9IbXBWYmpvZnFuS3djUWYrQjlLekFwdCtKeG1RZ01uZTJGUlJq?=
 =?utf-8?B?RHhXbXBML0FqMERRU0l4T0RQbHYrU3R6S09MWGszazZYd2RCQXhJYU5GczdU?=
 =?utf-8?B?ZmVCMnFONXByNVNnYzNCcmVkMVNya1BrRTdLQ3hLQ0pBOFl1SERvOTl6bEl6?=
 =?utf-8?B?dHNoaHdQdDllUTlmWXk4Y2JHODE2ZDJDWFdINytGamlsN0dHMWVrVUF1WDRj?=
 =?utf-8?B?VUY3ZWxCZ2hIcnQ5aERodlNOcERxcVV1bHQ3cDcyT1RyVTdDNWtsaitHRkl5?=
 =?utf-8?B?bG5aNGoybVpTVjhkaXZ1TWFpd2ZzNE01OER3V2laUjE3NkFrVHhYOFRWUThh?=
 =?utf-8?B?UUpmYUNCQmYvU3NXYUtCZitUcjA1K2NnQlZySnQ2N2s2Qk1Vay9mc3loRVhp?=
 =?utf-8?B?SlBHWWw5RTFWQnIvcU80Tm9pU05xVFlOZmhGdVdnVnNwU2ppRmROMkkxWEln?=
 =?utf-8?B?NVhBZTVsZlJTNnIvQjFaaG1WVWhyblJjb2RXVDFSKzNxUTQ0T1BST3crUjdD?=
 =?utf-8?B?YW1ITHUzcFVvWjRKZyt0L2NVRFRhd21QbmFVbTVXeitWRHNHVHlYa01vT2Vz?=
 =?utf-8?B?ekhCQWFwQklQWEFZL200VVVkUjlpLzdUYjZhQjJzc2tFODJnc1VjRW5sYnZq?=
 =?utf-8?B?dGdBdXBVUE9OWE1UNGhxcGhCN3djQVRnQzBGOVVmYVdrbDZqd0YwU1hjMGJs?=
 =?utf-8?B?Z1haMHFCN1lhd0k0TkREWjE0VXVtMU5ROWwvcjJuWkE3S2ZwSURXTnZ1cGVQ?=
 =?utf-8?B?MmJpcjZJbGtGVHdNWmNKK2t5MDdNaDhucjREYXVGUmVaOFlpUFFjOU9VSnJW?=
 =?utf-8?B?M2pGeDJrUkdhbnlOejZ5RmNjaWhTdzZ2L3BjWWl2S0hDNHlhWTd0SlVRU3R2?=
 =?utf-8?B?UkN3SjhhY3YyVkJmdWhUNXhCZmRSYTY5OHRTY2pNeEdaRHp1ek51QmtKMXBN?=
 =?utf-8?B?VUhSUkRyenZWb0FnRUwzT2x1T1FKak9QQXBpa0VpWUhTLzhRdzBuWjZZZDls?=
 =?utf-8?B?MnY2cEZBZDNHSXhkZko5SDFFNDVEYlMzcStBbzhBcjFvRVFVYzNtS3RvMUZP?=
 =?utf-8?B?NkwwLzUvaHVHN2YxWnh4R0RSOHFEb3lXNVY0UlQ3TThud21zeGV2SmVZcHFi?=
 =?utf-8?B?SCs2RkxvUjhFM25GMkxvSjQ5ZWVQbkdkQklsSTB0R3crLzh0Y2lXS050R0tq?=
 =?utf-8?B?em1rUkFZMXRwSXpxcmphMmRValV3SzZkTjl2RFc3M1ljWGdadGlTYmhtT2sx?=
 =?utf-8?B?MSs5aFk5MnprRC9wS29ES2RMemJEWk1vb1VQQkljMTdHUlBEKzdkWVZoYkRE?=
 =?utf-8?B?UXVuOE9aL1dkVUJLeUZINE5rM3NaRFFCR0JvT3cvZWRudkNRQzBMVUhoM0M4?=
 =?utf-8?B?eFlzWURJb1pSZUpJaTFvbHZnVFlNblZ5Y2pJT293NjB4M0JVSVRNSnlGV28y?=
 =?utf-8?B?UG5xZjAwaVZNZHd0dUdtd0NJWS9pVXlSWXlnclNJMGRZdVk2M3dsOHpkN0lQ?=
 =?utf-8?Q?36YQpWY0vu4W6VXo=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f242eff3-a7ed-41d3-807a-08da37b0963b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 02:54:40.2006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ui224GnYQxuxRoj1LEqFmU2M+LGQRx4cFhT1gjicr6lI6dcMJtZ3l845IOm6maSl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1455
X-Proofpoint-GUID: klHr2PTN3KW_r_-iLNODk9yBZwcQ02EA
X-Proofpoint-ORIG-GUID: klHr2PTN3KW_r_-iLNODk9yBZwcQ02EA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_16,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/22 1:36 PM, Jiri Olsa wrote:
> Making arch_cpu_idle and rcu_idle_exit noinstr. Both functions run
> in rcu 'not watching' context and if there's tracer attached to
> them, which uses rcu (e.g. kprobe multi interface) it will hit RCU
> warning like:
> 
>    [    3.017540] WARNING: suspicious RCU usage
>    ...
>    [    3.018363]  kprobe_multi_link_handler+0x68/0x1c0
>    [    3.018364]  ? kprobe_multi_link_handler+0x3e/0x1c0
>    [    3.018366]  ? arch_cpu_idle_dead+0x10/0x10
>    [    3.018367]  ? arch_cpu_idle_dead+0x10/0x10
>    [    3.018371]  fprobe_handler.part.0+0xab/0x150
>    [    3.018374]  0xffffffffa00080c8
>    [    3.018393]  ? arch_cpu_idle+0x5/0x10
>    [    3.018398]  arch_cpu_idle+0x5/0x10
>    [    3.018399]  default_idle_call+0x59/0x90
>    [    3.018401]  do_idle+0x1c3/0x1d0
> 
> The call path is following:
> 
> default_idle_call
>    rcu_idle_enter
>    arch_cpu_idle
>    rcu_idle_exit
> 
> The arch_cpu_idle and rcu_idle_exit are the only ones from above
> path that are traceble and cause this problem on my setup.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   arch/x86/kernel/process.c | 2 +-
>   kernel/rcu/tree.c         | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index b370767f5b19..1345cb0124a6 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -720,7 +720,7 @@ void arch_cpu_idle_dead(void)
>   /*
>    * Called from the generic idle code.
>    */
> -void arch_cpu_idle(void)
> +void noinstr arch_cpu_idle(void)

noinstr includes a lot of attributes:

#define noinstr                                                         \
         noinline notrace __attribute((__section__(".noinstr.text")))    \
         __no_kcsan __no_sanitize_address __no_profile 
__no_sanitize_coverage

should we use notrace here?

>   {
>   	x86_idle();
>   }
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index a4b8189455d5..20d529722f51 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -896,7 +896,7 @@ static void noinstr rcu_eqs_exit(bool user)
>    * If you add or remove a call to rcu_idle_exit(), be sure to test with
>    * CONFIG_RCU_EQS_DEBUG=y.
>    */
> -void rcu_idle_exit(void)
> +void noinstr rcu_idle_exit(void)
>   {
>   	unsigned long flags;
>   
