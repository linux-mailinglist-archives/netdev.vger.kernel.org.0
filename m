Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F4C1752AC
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 05:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCBE0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 23:26:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30464 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726845AbgCBE0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 23:26:46 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0224QVEt003957;
        Sun, 1 Mar 2020 20:26:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=amtqqQ2qQ4IDAi8DGLbn/i9LNBpdxeAE6RheHDF2xZE=;
 b=aEvTLCZvdESzxCqDG22WB5Dls/wNjjwXHu+Z7dam2rVu8Wp6d1wf5adYWKJIQ091NU+C
 JbGEqVtvD3dNaW8VN7J3FG3dEbC34NIhvJGhZbw6S9kqYSFPZj4AextEwiFhylCSKxaP
 TldxYhXLtU+SkoRNnpyjGvZAKYYg7d0rce8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8kwataa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 01 Mar 2020 20:26:33 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 1 Mar 2020 20:26:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHqzuVk2w+fi0jnuCPYrOCKljCbeZbV57MuHJe/w5PtVHwWykAxbnFnEvOGG0SxNFQyr1+1cqBcE+kuA404YxnkLrY6nR1vhnQXmR3Wzc2t+ieAFaSIOv350ci1TttLdbMmf7XwvY/Oun8AIokgai/tkGnzyk+WIqupsnZ4JWcs1b0m3Nmjy47/sfdV5ha3QlKpmp7F3oDVXieDBdLk3VHG4nTSwxaz83qoR3W+rZZGVIsVCIpTm4UqHGaAMyC+p1d4/nKBH/6eH4+NBNcoFuFM/nYRdktg82b0Vgy1qJXvLJvLxd5oeps/ggqt+0URvJatkFww75gDBPWnVlzTNzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amtqqQ2qQ4IDAi8DGLbn/i9LNBpdxeAE6RheHDF2xZE=;
 b=gJ5nJMZ/i6/7YLMgVwOjxXQsynbtwjKeOaT9pnXK47T4FFQCjzOnxeFQY+jsC4kU/AP/OQezDSs18aa1u6JQ39oZ07mDgVfD0umqCdFWPZVun7s5oVeXvtHhlTA2eJO1E70TSqQELFx9I3Mzpa7Ww8KHqGUCKDR8iIQP2v+FXQfJlxTU86JjRBg5PGdStpmpgIMbmKkSVaZw2yuEyMBJh8/OWfKVLjkqzzCAkqHEPaNbqRt7aDry+Y9+0AJQyZ/jpscy/ivc9CrUMbAB7nzj2q7sNU7wv+t7OkV5pFBAmomaAOd2jOUlzFKHeebUsToQbZQnkdpPpaT8UTYO1beqxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amtqqQ2qQ4IDAi8DGLbn/i9LNBpdxeAE6RheHDF2xZE=;
 b=SI7j8lrnxbIUXaq1cwx5zAUq69O76yN4D72tWH4s7bBq2rxOSzjKiVPx3EiYSIBp/9noSufJY3oXB5/siHbmG5e9061ENIhDApog9cc/nS1bg/yBGvtX0dYnDuDypoW77Wek/Woz6+7219f4uBuA4aijtj8pcy6Grx+KZYWgtbs=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB3402.namprd15.prod.outlook.com (2603:10b6:5:16f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 04:26:08 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 04:26:08 +0000
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
From:   Yonghong Song <yhs@fb.com>
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
 <10ccbad0-0198-eeba-a24e-8090818d8f0a@fb.com>
Message-ID: <c6d0d39f-0d22-0f2f-4016-0f4602a305b0@fb.com>
Date:   Sun, 1 Mar 2020 20:26:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <10ccbad0-0198-eeba-a24e-8090818d8f0a@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:300:16::33) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:bc5a) by MWHPR13CA0023.namprd13.prod.outlook.com (2603:10b6:300:16::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.5 via Frontend Transport; Mon, 2 Mar 2020 04:26:07 +0000
X-Originating-IP: [2620:10d:c090:400::5:bc5a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f97a2acc-3c6a-4ac5-6731-08d7be61d4b3
X-MS-TrafficTypeDiagnostic: DM6PR15MB3402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB340242E75E90EA637B796584D3E70@DM6PR15MB3402.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(39860400002)(376002)(396003)(189003)(199004)(37006003)(54906003)(52116002)(316002)(6636002)(6506007)(53546011)(31686004)(6512007)(6486002)(86362001)(31696002)(6666004)(36756003)(8936002)(81166006)(81156014)(8676002)(5660300002)(16526019)(4326008)(2616005)(6862004)(2906002)(186003)(478600001)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3402;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mYdfwYWUqbKzbpBNVtIlVTMGBpboatGnwRz8pPyYUMPGpgM1Xfr3WVEfr90Ct/vIKTLGQmJPZk3tMOA6GuDhwoDz1uF+oAx55++v+dCMkseWt0vhW28t5h06dv1ErIIaA4ZyaYk3d0NKVKnN0X2+n2IcgKo0NKmnMUifEkbS/mOMkOWUua7B5AodCPbO/n9eSJGTQ8bv5RigowLTJJ4aKaS/ydGj0ymEgJvgcK1bC7Jg3J+4IF53qiOmlLM2nJR7Brw7uuclCbVa/TqgDPnl251gYQVWRbnziGqlpAlauZ/mghPxSZN1w6JNCeTg7twZuSjAcIfZ+9sQM/SnWPfIHUZ8QDeq7iWDnMwEtqvqIHU9dnxud763PQGFIT7nrgrb/Iuuoj7jKDHnLsYV6OvBwavoU3a7stKg4VlNRyr3xVdwkaz37t4yesLqNfIU4Vbo
X-MS-Exchange-AntiSpam-MessageData: yrChx1y7RR9h3euZj4vkNVLz/BFRuRY04FPC0//Jnh9CbX6oJXOq1/6tnAg//kvWLSvnWLUstN9//3HaOkyTRs0UNOK/a6ihCkYW9kDgRPCjWvPytQPB7BhsvALRe7nLdhvsx2S0m07THQ+VKO6hkLABeQPws2WWVQA1O34kcVlH2pj5Ckh1MuK+IioL9ZX0
X-MS-Exchange-CrossTenant-Network-Message-Id: f97a2acc-3c6a-4ac5-6731-08d7be61d4b3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 04:26:08.7625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8jN6WH9WNlqPUU55h3u8oEw/61rufaJ60qY53DjgA1ghfZBQVc/HkcRsS1Ieutl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3402
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_09:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 phishscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020031
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 7:42 PM, Yonghong Song wrote:
> 
> 
> On 3/1/20 2:37 PM, Song Liu wrote:
>>
>>
>>> On Feb 29, 2020, at 7:52 PM, Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 2/28/20 3:40 PM, Song Liu wrote:
>>>> With fentry/fexit programs, it is possible to profile BPF program with
>>>> hardware counters. Introduce bpftool "prog profile", which measures key
>>>> metrics of a BPF program.
>>>> bpftool prog profile command creates per-cpu perf events. Then it 
>>>> attaches
>>>> fentry/fexit programs to the target BPF program. The fentry program 
>>>> saves
>>>> perf event value to a map. The fexit program reads the perf event 
>>>> again,
>>>> and calculates the difference, which is the instructions/cycles used by
>>>> the target program.
>>>> Example input and output:
>>>>    ./bpftool prog profile 3 id 337 cycles instructions llc_misses
>>>>          4228 run_cnt
>>>>       3403698 cycles                                              
>>>> (84.08%)
>>>>       3525294 instructions   #  1.04 insn per cycle               
>>>> (84.05%)
>>>>            13 llc_misses     #  3.69 LLC misses per million isns  
>>>> (83.50%)
>>>> This command measures cycles and instructions for BPF program with id
>>>> 337 for 3 seconds. The program has triggered 4228 times. The rest of 
>>>> the
>>>> output is similar to perf-stat. In this example, the counters were only
>>>> counting ~84% of the time because of time multiplexing of perf 
>>>> counters.
>>>> Note that, this approach measures cycles and instructions in very small
>>>> increments. So the fentry/fexit programs introduce noticeable errors to
>>>> the measurement results.
>>>> The fentry/fexit programs are generated with BPF skeletons. 
>>>> Therefore, we
>>>> build bpftool twice. The first time _bpftool is built without 
>>>> skeletons.
>>>> Then, _bpftool is used to generate the skeletons. The second time, 
>>>> bpftool
>>>> is built with skeletons.
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>>   tools/bpf/bpftool/Makefile                |  18 +
>>>>   tools/bpf/bpftool/prog.c                  | 428 
>>>> +++++++++++++++++++++-
>>>>   tools/bpf/bpftool/skeleton/profiler.bpf.c | 171 +++++++++
>>>>   tools/bpf/bpftool/skeleton/profiler.h     |  47 +++
>>>>   tools/scripts/Makefile.include            |   1 +
>>>>   5 files changed, 664 insertions(+), 1 deletion(-)
>>>>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>>>>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
>>>> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
>>>> index c4e810335810..c035fc107027 100644
>>>> --- a/tools/bpf/bpftool/Makefile
>>>> +++ b/tools/bpf/bpftool/Makefile
>>>> @@ -59,6 +59,7 @@ LIBS = $(LIBBPF) -lelf -lz
>>>>     INSTALL ?= install
>>>>   RM ?= rm -f
>>>> +CLANG ?= clang
>>>>     FEATURE_USER = .bpftool
>>>>   FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
>>>> @@ -110,6 +111,22 @@ SRCS += $(BFD_SRCS)
>>>>   endif
>>>>     OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
>>>> +_OBJS = $(filter-out $(OUTPUT)prog.o,$(OBJS)) $(OUTPUT)_prog.o
>>>> +
>>>> +$(OUTPUT)_prog.o: prog.c
>>>> +    $(QUIET_CC)$(COMPILE.c) -MMD -DBPFTOOL_WITHOUT_SKELETONS -o $@ $<
>>>> +
>>>> +$(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
>>>> +    $(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
>>>> +
>>>> +skeleton/profiler.bpf.o: skeleton/profiler.bpf.c
>>>> +    $(QUIET_CLANG)$(CLANG) -g -O2 -target bpf -c $< -o $@
>>>
>>> With a fresh checkout, applying this patch and just selftests like
>>>   make -C tools/testing/selftests/bpf
>>>
>>> I got the following build error:
>>>
>>> make[2]: Leaving directory `/data/users/yhs/work/net-next/tools/lib/bpf'
>>> clang -g -O2 -target bpf -c skeleton/profiler.bpf.c -o 
>>> skeleton/profiler.bpf.o
>>> skeleton/profiler.bpf.c:5:10: fatal error: 'bpf/bpf_helpers.h' file 
>>> not found
>>> #include <bpf/bpf_helpers.h>
>>>          ^~~~~~~~~~~~~~~~~~~
>>> 1 error generated.
>>> make[1]: *** [skeleton/profiler.bpf.o] Error 1
>>>
>>> I think Makefile should be tweaked to avoid selftest failure.
>>
>> Hmm... I am not seeing this error. The build succeeded in the test.
> 
> Just tried again with a *fresh* checkout of tools/ directory with the 
> patch.
>    -bash-4.4$ make -C tools/testing/selftests/bpf
>    ...
>    LINK 
> /data/users/yhs/work/net-next/tools/testing/selftests/bpf/tools/build/bpftool//libbpf/libbpf.a 
> 
>    LINK 
> /data/users/yhs/work/net-next/tools/testing/selftests/bpf/tools/build/bpftool/_bpftool 
> 
> make[1]: *** No rule to make target `skeleton/profiler.bpf.c', needed by 
> `skeleton/profiler.bpf.o'.  Stop.
> make: *** 
> [/data/users/yhs/work/net-next/tools/testing/selftests/bpf/tools/sbin/bpftool] 
> Error 2
> make: Leaving directory 
> `/data/users/yhs/work/net-next/tools/testing/selftests/bpf
> 
> The error is different from my previous try, but the build still fails.

FYI. The following change fixed build in my env.

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index c035fc107027..20a90d8450f8 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -120,7 +120,7 @@ $(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
         $(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)

  skeleton/profiler.bpf.o: skeleton/profiler.bpf.c
-       $(QUIET_CLANG)$(CLANG) -g -O2 -target bpf -c $< -o $@
+       $(QUIET_CLANG)$(CLANG) -I$(srctree)/tools/lib -g -O2 -target bpf 
-c $< -o $@

  profiler.skel.h: $(OUTPUT)_bpftool skeleton/profiler.bpf.o
         $(QUIET_GEN)$(OUTPUT)./_bpftool gen skeleton 
skeleton/profiler.bpf.o > $@

> 
>>
>> Thanks,
>> Song
>>
