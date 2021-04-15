Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0823361222
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhDOScp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:32:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63014 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233052AbhDOSco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:32:44 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FIVXUw012816;
        Thu, 15 Apr 2021 11:31:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=q675a/4k+Zj+/RpRXhHC/NuoSuJ/ACZdUJH/npkLj8U=;
 b=fMHvDKuiwpYV9kB0ljbU6y0poMzJclzfLBRhOdVQA1t0fjH/BSUMaOCOeTV/lYVYfyA/
 /J6jpZDF2AQ9xuzP6ETfQCYlZMjaqtjBq5UoUwbRQttWMMqRS1Xo2RHqkjKjftHSkKtc
 NirlN0LNOynUHjbCOuVj3Um/LAd2Quel+1g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37wvks1frn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 15 Apr 2021 11:31:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 11:31:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xv0w5oKzZHpy0OI8vBjMArYX/zA7KhE/jqZm7U7CePPxIqDml8jiqt08XGDw4KMdxfuoN53v5o5RjuqWJDfHdC3T189Mbgy6C8De0VapB1lgNgoRNSJT1TNIp/Z8TRb3+XypOMFFWNSjkAH7K/fNFXHv+LudmuFL/1eqrViEk5L/6eXWbMXRCqOQgl810EqRJMWh+f+Y4b2cAK08RKYqmaJu5ZFRT5TCcslBC+ew/jehz8YjYWZ3n+6YfpK1SxLIG1mvkgNdVM0ldycrhqOArGJebt4VTf0I6ElNTKXbrVY1l8PpyZ4Js0ySkot/NUe7SugTnNb3tuygrKzQEpkIyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q675a/4k+Zj+/RpRXhHC/NuoSuJ/ACZdUJH/npkLj8U=;
 b=DOt7NZjEFkjF/c+UMl2rkfPTwVgt7lt31ffLXWuDPPPR/0LBFfJEXHSqicfFzzGxg5EEXYoNNjC32QznfXeyUniSlhQ4ku5ExRDps8tU6po9oqLObi4GS83caQqiiw45R+V2eegtj4ClvGXKfS2AfmORwoxmUMCkl/4Mr6GQz+lkPnkEIOyEudDJSm6PutfgT2a/PDt+qF8a9ZJfZ6Xrl3ihNrSQmyC1Mtn6YNMS5JHYwzD8+ccUAnlQucz7rCQG7V1qLx+IBhFsQrm6z9BEKo7bcjZ3P4syuxWJvp9tywb0uftM0nr1E/QtnYSPArK2b7eoYETbnrWxQaM3cA116A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2158.namprd15.prod.outlook.com (2603:10b6:805:3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 18:31:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3999.033; Thu, 15 Apr 2021
 18:31:24 +0000
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
To:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
References: <20210413121516.1467989-1-jolsa@kernel.org>
 <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava>
 <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home> <YHh6YeOPh0HIlb3e@krava>
 <20210415141831.7b8fbe72@gandalf.local.home>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ea9da77e-3cd9-874d-c1fe-086b7889d669@fb.com>
Date:   Thu, 15 Apr 2021 11:31:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210415141831.7b8fbe72@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:5dca]
X-ClientProxiedBy: MWHPR20CA0041.namprd20.prod.outlook.com
 (2603:10b6:300:ed::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::112e] (2620:10d:c090:400::5:5dca) by MWHPR20CA0041.namprd20.prod.outlook.com (2603:10b6:300:ed::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 18:31:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bda28624-6f3d-4c38-05b1-08d9003caca8
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB21588C8B1101439711D225BCD34D9@SN6PR1501MB2158.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CQObdMyLIwzGPGLxro+3S5/qwo/GJFKxNq/noBVa47f6H5mhsSdKnYRKUx1cNnGZNC04VZZMJt4KrQ8Pf5+QgcqmdU4V5/3pDKlLdSUdv0vY38MJcW3N1M+4HIZys8rwG6Kizu8gtBy1Me46Zgj2CPhtRbREJGhQdrTBTbfGiFnkkvRz8pBcMIAllxTd+Kd2r2Xlz9yj/OcnoQMJAUjEgbh9vwtNWEzGiKNFcmTrcxT1c7V54Z16FP3izLdi5z5cnGQeGNDi0RRKHHD/LLdq+H82OwoHAOI0KQ6r99ageO6tMxHcQWf8Is5fjGRZ2Wg+GMCDgiDFwp3lML3KaYiaDRoxEojBvvhAvCPoDkJwunq42SRta2CHCLZynTE4wZUjOw4uXVwmxWFrfW7C+YGWyHx7O6zFwXS/HI1/lLL8vevH4oafFaJKdOye8G1bb5twspHBV0ROYzZrl+GD79XmE89UlebGuwfiw2IF+kAPVMsET6wWZqXPZHL8H33zdjlrRrf6kZXnEbYLVaY8Vtbc82vyxJto5Iz46IQa4N9pBhZrsrr2nOAeIVY4mY+b2cdu5Skoyw+QsaIbucP3LVemKmJujUFOJIhTC6nriUefM2SS4nf9butXMfJo5apZOLSyNpBv0Pk9E2tzrIUKTJZINZXUfxXACJln5SBjqA5yNavMvFEQugw6C6KhbAScsdr8mgAxcXhoKe2fdx0ZhjQkUWUU9ei8MYz1fLj72rqe2KSElQhOJt4XuAM4JB4lvFZk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(186003)(16526019)(66946007)(66476007)(478600001)(52116002)(66556008)(6486002)(86362001)(31696002)(2616005)(7416002)(8936002)(5660300002)(53546011)(38100700002)(110136005)(2906002)(54906003)(83380400001)(4326008)(8676002)(36756003)(316002)(966005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eDl6aG43R2x4dFk0SnFlMktDUHBiekNEUktlcW1OZDJwOHJKSVA2TnFDc3BJ?=
 =?utf-8?B?bVBESkhRaVZtY1A0bGUxK2pYQ2VXcUIvVmpZdjhWRVRyazQ0MTJLZ0h5Vndq?=
 =?utf-8?B?K2ZTRE9OUTdIRmc1cWNkN2VPV1VIczc2YVBiNjQwRXl1bTZxNXBjRjJEOGdx?=
 =?utf-8?B?N09QSVNsRUJwY3I4UWhlTkIvcWtzNGdhNDNML3FpMXdxV09KaHdZeGcvMExv?=
 =?utf-8?B?NjBlN0xZYW53cnlPZlNEdU1kNjN5QitYVDA1d2Zhem02OFpyL1pwSmxhLy92?=
 =?utf-8?B?T1Z6eGJQS0krOFJjUlRtTU1JLzBVbHYxeXJDZ1k4UTREYllOSXVjVkpaZ0E2?=
 =?utf-8?B?VmdvOUtaTDBFalBVVS9nNWgvMURMZGlQM0xLeVBvTmEyaXlrdWZ4Yk83YURz?=
 =?utf-8?B?R3M3MVdwQ3NZcEZURGljL0E1WEJ1ejZQaldoVUFaSFpqTnkydXFaQmY4TzdT?=
 =?utf-8?B?VFhWREZiaWtPRENJelN0MzB4MDc2Wk1WaFhoVjYxd0FJditOTm9oRkhhYzd4?=
 =?utf-8?B?NzZNWVhuNyt3cWVTSkRnbjcyYzlXVXdHVWdUK1FQRzZhSGdaMCtyMVFDMHY3?=
 =?utf-8?B?bDI0RWV1cCtJQm1zY2VoUWwyVHFyeXY4aDBWT0FhMlJJUU9SSXJJbktaRUZt?=
 =?utf-8?B?eTdXVWtIOW9xZWRhcDJSNXVyN1htTVF0eDBYWWNONHU1VGpuTEkxNjc1UmVB?=
 =?utf-8?B?Ny82ejVVY1J2U1JJeHhNVUpCbUtpbkRrNWpTTXhiV0k3V25NcE5GZ21EWWd3?=
 =?utf-8?B?WTRtS25neDcwL1dsY1VBaWFPRHA0R21tMFMzY2ZDeU1TaFdjMHo5WlloNEJz?=
 =?utf-8?B?Z3lmelhPS3BJQ1djUWQxOHdVSzd3Q1dZbWRsdHJJZFZKY0kyeUtHUThKV0Vx?=
 =?utf-8?B?dTA1TmtKRXFOZWtGUVJOL0MxaEpGNHRPK1BhV3J3clNOa0g3MjRtZ3JDOG9I?=
 =?utf-8?B?SitJSE1aMEh4YVV0aVRKTFp4YURpYjlJNzhTdUNMT2VRNHYxSXZVYXJYNjRT?=
 =?utf-8?B?TVlLUm90ejFtMDFKOTZINDF3aDYvL1J1cDRKVEUvdnltbkx0Q0NqSit3RElj?=
 =?utf-8?B?S3k5TFBxV3NDaGtJc051UVRtVy9oajF6R09SMjdXMjkvUlBidE9xQlp0VHZC?=
 =?utf-8?B?aVBYZXZKeEVNOHhrNXVPcGw1c29kK1UwS1UzaXFQNzArV2diL09xNnd5cW4r?=
 =?utf-8?B?VzdQdUhwK2xRQnljTzZEaHdoNGZUOFJkVmxLU0crREZIVjFRYWZFd1Blai80?=
 =?utf-8?B?bVRSdFNLNEt3cjVkNVppeSt5UnhGNEZScUJRZDhwMzNCRStQOWd3WWxzYS8w?=
 =?utf-8?B?Qkp4WnV4TVFXeDlVZ1JleU1xekYwblFDSmFjYVZmdGtTWVNiN1A5T2tjekFB?=
 =?utf-8?B?NGwvV0pJcU9aYVNvbVl3a0RldDhKT1pDcElrakZ5NkwvUkoyaDU1Y0pKbVNw?=
 =?utf-8?B?UWZTQWdtRFowV1FvWXA0bGtlRkpUR04xWXFUS0MvWHUxdEVqL3BNQWJRWHo5?=
 =?utf-8?B?dXVEUGU1dFBNMjl1SU5zSHdWVkZ1TDNQcDhHbStVVUNiMk9KQzNWZkxxRDBm?=
 =?utf-8?B?Q083bERMVlR4QmNjc2d4UDRHY2hSRVdOUmFZQ2RJRnZ2WmQwRzRSakhXZVRS?=
 =?utf-8?B?YVdtU3lXRmk5eWJDUUNvZEptVmJWRG9OYTRUbCt4eE9XSFozay9NeFhXVVI3?=
 =?utf-8?B?TVhuRTJYd0JvR3lMcjY2WjIwKzJvZElXeXQ5QXcwbldqaFhPLzJwSUJxUlpq?=
 =?utf-8?B?MVR3TS9qKzg3WjJRSElHUGxkcDR1UEUrMWlaVFY0UnplaXFpdlN3K0xrVXhI?=
 =?utf-8?B?TUtYYXA2a0NUa0E1VGlqQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bda28624-6f3d-4c38-05b1-08d9003caca8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 18:31:24.5625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0Dc2KvIndlY8beGJMByvCRvVFGur+vztKJ90e89/TOOyxsED2gZAxTdAJvReyWA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2158
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 7_rOVycn852HCtBhC8jKqnmpcOXJdPdU
X-Proofpoint-ORIG-GUID: 7_rOVycn852HCtBhC8jKqnmpcOXJdPdU
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_09:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 suspectscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 impostorscore=0 clxscore=1011 adultscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/21 11:18 AM, Steven Rostedt wrote:
> On Thu, 15 Apr 2021 19:39:45 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
>>> I don't know how the BPF code does it, but if you are tracing the exit
>>> of a function, I'm assuming that you hijack the return pointer and replace
>>> it with a call to a trampoline that has access to the arguments. To do
>>
>> hi,
>> it's bit different, the trampoline makes use of the fact that the
>> call to trampoline is at the very begining of the function and, so
>> it can call the origin function with 'call function + 5' instr.
>>
>> so in nutshell the trampoline does:
>>
>>    call entry_progs
>>    call original_func+5
> 
> How does the above handle functions that have parameters on the stack?

In arch/x86/net/bpf_jit_comp.c, the following code

int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, 
void *image_end,
                                 const struct btf_func_model *m, u32 flags,
                                 struct bpf_tramp_progs *tprogs,
                                 void *orig_call)
{
         int ret, i, cnt = 0, nr_args = m->nr_args;
         int stack_size = nr_args * 8;
         struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
         struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
         struct bpf_tramp_progs *fmod_ret = 
&tprogs[BPF_TRAMP_MODIFY_RETURN];
         u8 **branches = NULL;
         u8 *prog;

         /* x86-64 supports up to 6 arguments. 7+ can be added in the 
future */
         if (nr_args > 6)
                 return -ENOTSUPP;
...

Here, nr_args will be maximumly 5 original arguments + "ret" value 
argument for fexit bpf program.

yes, it is a known limitation. I guess more can be added and pushed to
the stack. Looks like there is no strong request so this has not been
implemented yet.

> 
>>    call exit_progs
>>
>> you can check this in arch/x86/net/bpf_jit_comp.c in moe detail:
>>
>>   * The assembly code when eth_type_trans is called from trampoline:
>>   *
>>   * push rbp
>>   * mov rbp, rsp
>>   * sub rsp, 24                     // space for skb, dev, return value
>>   * push rbx                        // temp regs to pass start time
>>   * mov qword ptr [rbp - 24], rdi   // save skb pointer to stack
>>   * mov qword ptr [rbp - 16], rsi   // save dev pointer to stack
>>   * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
>>   * mov rbx, rax                    // remember start time if bpf stats are enabled
>>   * lea rdi, [rbp - 24]             // R1==ctx of bpf prog
>>   * call addr_of_jited_FENTRY_prog  // bpf prog can access skb and dev
>>
>> entry program called ^^^
>>
>>   * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
>>   * mov rsi, rbx                    // prog start time
>>   * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
>>   * mov rdi, qword ptr [rbp - 24]   // restore skb pointer from stack
>>   * mov rsi, qword ptr [rbp - 16]   // restore dev pointer from stack
>>   * call eth_type_trans+5           // execute body of eth_type_trans
>>
>> original function called ^^^
> 
> This would need to be limited to only functions that do not have any
> parameters on the stack.
> 
>>
>>   * mov qword ptr [rbp - 8], rax    // save return value
>>   * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
>>   * mov rbx, rax                    // remember start time in bpf stats are enabled
>>   * lea rdi, [rbp - 24]             // R1==ctx of bpf prog
>>   * call addr_of_jited_FEXIT_prog   // bpf prog can access skb, dev, return value
>>
>> exit program called ^^^
>>
>>   * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
>>   * mov rsi, rbx                    // prog start time
>>   * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
>>   * mov rax, qword ptr [rbp - 8]    // restore eth_type_trans's return value
>>   * pop rbx
>>   * leave
>>   * add rsp, 8                      // skip eth_type_trans's frame
>>   * ret                             // return to its caller
>>
>>> this you need a shadow stack to save the real return as well as the
>>> parameters of the function. This is something that I have patches that do
>>> similar things with function graph.
>>>
>>> If you want this feature, lets work together and make this work for both
>>> BPF and ftrace.
>>
>> it's been some time I saw a graph tracer, is there a way to make it
>> access input arguments and make it available through ftrace_ops
>> interface?
> 
> I have patches that could easily make it do so. And should probably get
> them out again. The function graph tracer has a shadow stack, and my
> patches allow you to store data on it for use with the exiting of the
> program.
> 
> My last release of that code is here:
> 
>    https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/
> 
> It allows you to "reserve data" to pass from the caller to the return, and
> that could hold the arguments. See patch 15 of that series.
> 
> 
> -- Steve
> 
