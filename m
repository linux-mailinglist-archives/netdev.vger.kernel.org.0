Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A248517525F
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgCBDn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:43:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3354 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgCBDn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:43:27 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0223fDrV014317;
        Sun, 1 Mar 2020 19:43:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6benZCZL+BM5g8ycZwqof67mKu2rhZKZMl1IR59E+BM=;
 b=XXLb/7AV0Rhho+fJvZvOFiMZBHtR9Q7jtBtgPFXnOBSwEzzZ3RrRK3Hur2LJjTYu8Jo1
 3fIia4bieihA/YT/GZs70XMCkNtYAyCJcM/9kvPi6f++C2tKOJnJXdFUrh/hU5q0Np0i
 iJklGU6i4RElqrqzoIQnvfPjI3Vx8w4qaJU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfpjvdm64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 01 Mar 2020 19:43:14 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 1 Mar 2020 19:43:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrUzxVL+KZydUOuQkp3mwEJKxhj0H31Jdymo6y311eJSqU8JzhDzoEfybquwCCfp82/tYytJgMYPuD+GLe1HaBcmbU2BoAYburlQ95k60yeRCcjYHONV5LoPSXJRHpyG2J8OiA/SRJm3eAiP1nkEJztSbjrWTNEEbNNdL1A+2rmblc6SZX90dwoAQIrom8jbltwEQ/V+Js4Rp5mQNtgt07UGhQG63PbU0rhwZrVqGZfD3CgEIxZ6nrk8N6tL6y4FikqyOkIJCvEJCekWOzbVdZ0gjo/RLNMeekuDd08zfkOIfDX9BtbxspJ5t+NIEF4aKmiF8kyBe+XyFkpQn5r57Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6benZCZL+BM5g8ycZwqof67mKu2rhZKZMl1IR59E+BM=;
 b=ncc2lfbMJJIwMEYtl87sPVg/9PrdS50PuktDBhlvZyDFX4lokmi5X82c3fEs14nYpBf1yJp2BN+fX2YqDrhmSgjQ9tlO9y7ec49IF+cMHHQNaPBlHOL2Dq+66zET2kpf36Y92t/Wep2czNZ1eK4QP/mMReGjiCYB7fPcZPY0AHhSrgObbq8+I97J9Oh1BhlMFF7/2vWtEBjgh2l5bBN3KnCEdNiOBwQs5Z7dOuoBROSn9DORFk4PnBPh1CrCOQGPGrBircYlADsVPzMY+Stry5lfcJc8ZVmW+YPfagUp8IA9CfY9AH+rpskJNg8LlVYq5NopFpt9LXYxZ0AiFxT9pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6benZCZL+BM5g8ycZwqof67mKu2rhZKZMl1IR59E+BM=;
 b=V7KdUu2J+jlJLQVrrV3JhXerd3mBzm3uiBQiwO6gWxWvgnqgl2xngrdCnJ9i0oyA9OiqbwC5ETuVTloGApQm6LOQQeG1fM8i9J4Dxk+9M51F9tTxwnyLpvgp71TpnljE/YyIrPDRaD9O1lqNcqN+2KOnlppyVS2wkJ/3zHPJMj4=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB3372.namprd15.prod.outlook.com (2603:10b6:5:16b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Mon, 2 Mar
 2020 03:43:10 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 03:43:10 +0000
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
To:     Song Liu <songliubraving@fb.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
 <07478dd7-99e2-3399-3c75-db83a283e754@fb.com>
 <2FFDA2FF-55D3-41EC-8D6C-34A7D1C93025@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <10ccbad0-0198-eeba-a24e-8090818d8f0a@fb.com>
Date:   Sun, 1 Mar 2020 19:42:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <2FFDA2FF-55D3-41EC-8D6C-34A7D1C93025@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR11CA0015.namprd11.prod.outlook.com (10.172.48.153) To
 DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:bc5a) by MWHPR11CA0015.namprd11.prod.outlook.com (10.172.48.153) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Mon, 2 Mar 2020 03:43:08 +0000
X-Originating-IP: [2620:10d:c090:400::5:bc5a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82825af8-f9d4-4f42-7378-08d7be5bd391
X-MS-TrafficTypeDiagnostic: DM6PR15MB3372:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB337242932B04046F57C36682D3E70@DM6PR15MB3372.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(136003)(39860400002)(366004)(199004)(189003)(16526019)(186003)(36756003)(2616005)(6636002)(316002)(2906002)(81156014)(37006003)(8676002)(54906003)(31686004)(81166006)(8936002)(53546011)(6506007)(31696002)(6666004)(6512007)(86362001)(6862004)(4326008)(5660300002)(478600001)(66556008)(52116002)(66476007)(6486002)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3372;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WlLnQ6ryhVRpGbVuL0tJPhXUWE7NtUX73HwiuLuu66tphB6maa5QuYOBEMWD+vSC9aRDsLtIWDjXupZEUXwlqVuDnTLbxSkSVPzt3W+xNRO6kr2oDQZADag5tgJgMoXq8agjgxvj7DVIbpNOqniinsTGgZhuNfNiJi3Kh0pBXBezYxb/Rb7abI7UcgUZNIydgHuy0GFakvJmHWEiDuWHxOb0Trdr/+UanzTLIMtGGdgOLXdPRHhFnFHcz2S5c0lmghcM/4+Hhx99BVmZihuCB0vKPc3vYu5Yqg/ts7j0mBaCiSn3kzVW/itVNccM7ILKwdDJYiX7yNZEP5LV7ANOPBe1IUeOH0bDH8LIK3YXfgfjJCCnqmA7FocLjKdDCmkNYBi3amOvC2+W5xp4YewawX9ccUUC7RNKPHBC87u2vRGX33gx1+hsdQ4uMYuIib4f
X-MS-Exchange-AntiSpam-MessageData: aU+VTWmjYKAgIraaIcj2Xpehs6dpcWO6ns92sjMdBT5P6IOlEOrDdLLvkRqJmC+gW2FtUD4OaiLyZNq2ALvV1VYWbA+iTZUTLmxwbIahim81v87bM0KYx0zF+02gHIjZqYvA0pcBohRg2c3aE2prHOQiwhqn5ipNA8DLJjn0JPduzXFUTqDAElxjhkEtcHcK
X-MS-Exchange-CrossTenant-Network-Message-Id: 82825af8-f9d4-4f42-7378-08d7be5bd391
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 03:43:10.0288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GcIRKQo71+npOSVcymGquMDD33m3q73uYfgX11ZI/DIY6tZ3XbUqYglomQDxFRhh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3372
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_09:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 spamscore=0 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 2:37 PM, Song Liu wrote:
> 
> 
>> On Feb 29, 2020, at 7:52 PM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 2/28/20 3:40 PM, Song Liu wrote:
>>> With fentry/fexit programs, it is possible to profile BPF program with
>>> hardware counters. Introduce bpftool "prog profile", which measures key
>>> metrics of a BPF program.
>>> bpftool prog profile command creates per-cpu perf events. Then it attaches
>>> fentry/fexit programs to the target BPF program. The fentry program saves
>>> perf event value to a map. The fexit program reads the perf event again,
>>> and calculates the difference, which is the instructions/cycles used by
>>> the target program.
>>> Example input and output:
>>>    ./bpftool prog profile 3 id 337 cycles instructions llc_misses
>>>          4228 run_cnt
>>>       3403698 cycles                                              (84.08%)
>>>       3525294 instructions   #  1.04 insn per cycle               (84.05%)
>>>            13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)
>>> This command measures cycles and instructions for BPF program with id
>>> 337 for 3 seconds. The program has triggered 4228 times. The rest of the
>>> output is similar to perf-stat. In this example, the counters were only
>>> counting ~84% of the time because of time multiplexing of perf counters.
>>> Note that, this approach measures cycles and instructions in very small
>>> increments. So the fentry/fexit programs introduce noticeable errors to
>>> the measurement results.
>>> The fentry/fexit programs are generated with BPF skeletons. Therefore, we
>>> build bpftool twice. The first time _bpftool is built without skeletons.
>>> Then, _bpftool is used to generate the skeletons. The second time, bpftool
>>> is built with skeletons.
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>>   tools/bpf/bpftool/Makefile                |  18 +
>>>   tools/bpf/bpftool/prog.c                  | 428 +++++++++++++++++++++-
>>>   tools/bpf/bpftool/skeleton/profiler.bpf.c | 171 +++++++++
>>>   tools/bpf/bpftool/skeleton/profiler.h     |  47 +++
>>>   tools/scripts/Makefile.include            |   1 +
>>>   5 files changed, 664 insertions(+), 1 deletion(-)
>>>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>>>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
>>> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
>>> index c4e810335810..c035fc107027 100644
>>> --- a/tools/bpf/bpftool/Makefile
>>> +++ b/tools/bpf/bpftool/Makefile
>>> @@ -59,6 +59,7 @@ LIBS = $(LIBBPF) -lelf -lz
>>>     INSTALL ?= install
>>>   RM ?= rm -f
>>> +CLANG ?= clang
>>>     FEATURE_USER = .bpftool
>>>   FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
>>> @@ -110,6 +111,22 @@ SRCS += $(BFD_SRCS)
>>>   endif
>>>     OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
>>> +_OBJS = $(filter-out $(OUTPUT)prog.o,$(OBJS)) $(OUTPUT)_prog.o
>>> +
>>> +$(OUTPUT)_prog.o: prog.c
>>> +	$(QUIET_CC)$(COMPILE.c) -MMD -DBPFTOOL_WITHOUT_SKELETONS -o $@ $<
>>> +
>>> +$(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
>>> +	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
>>> +
>>> +skeleton/profiler.bpf.o: skeleton/profiler.bpf.c
>>> +	$(QUIET_CLANG)$(CLANG) -g -O2 -target bpf -c $< -o $@
>>
>> With a fresh checkout, applying this patch and just selftests like
>>   make -C tools/testing/selftests/bpf
>>
>> I got the following build error:
>>
>> make[2]: Leaving directory `/data/users/yhs/work/net-next/tools/lib/bpf'
>> clang -g -O2 -target bpf -c skeleton/profiler.bpf.c -o skeleton/profiler.bpf.o
>> skeleton/profiler.bpf.c:5:10: fatal error: 'bpf/bpf_helpers.h' file not found
>> #include <bpf/bpf_helpers.h>
>>          ^~~~~~~~~~~~~~~~~~~
>> 1 error generated.
>> make[1]: *** [skeleton/profiler.bpf.o] Error 1
>>
>> I think Makefile should be tweaked to avoid selftest failure.
> 
> Hmm... I am not seeing this error. The build succeeded in the test.

Just tried again with a *fresh* checkout of tools/ directory with the patch.
   -bash-4.4$ make -C tools/testing/selftests/bpf
   ...
   LINK 
/data/users/yhs/work/net-next/tools/testing/selftests/bpf/tools/build/bpftool//libbpf/libbpf.a
   LINK 
/data/users/yhs/work/net-next/tools/testing/selftests/bpf/tools/build/bpftool/_bpftool
make[1]: *** No rule to make target `skeleton/profiler.bpf.c', needed by 
`skeleton/profiler.bpf.o'.  Stop.
make: *** 
[/data/users/yhs/work/net-next/tools/testing/selftests/bpf/tools/sbin/bpftool] 
Error 2
make: Leaving directory 
`/data/users/yhs/work/net-next/tools/testing/selftests/bpf

The error is different from my previous try, but the build still fails.

> 
> Thanks,
> Song
> 
