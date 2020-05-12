Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF66E1CF774
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgELOjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:39:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19040 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726168AbgELOjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:39:53 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CEdZZc017558;
        Tue, 12 May 2020 07:39:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TM9sqj1etn1Wfdy9PyTHHGycCBuSP2f5MZb4jgUylBY=;
 b=gybxbETTQBGulVhk8gLetoGcFZZv+lICT+KmYYqprRuc2vvUITMjA5lEe810H3HGy2zS
 VPW+eMz6+NA5By7dmSo7SODfyJcMsnfCUiiVN63pgoBJ9VjRgM+PxeBnPaEEY/ayID9a
 qt7UtdQc7Of9BH6HPM8AwL6hMlS4w4XPeXA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcgbmt09-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 07:39:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 07:39:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0KNWZOg6fPpB0tLPzGqkF8p3psOMw4zl8nv2m2+3XrbpSA243vu3hcsl1/IxlwzTb76qQDx+DbLy7g39TvrrLRNyB7eUIx/FltRLAyEc0cFE50yrRPXbftguaFPbHnq+Sp7y8UBeLNQ70So0vPbUzfUsv+I7C8Xa5ZLaxPK6U9YxECI1kfwTI3haloWH6STi1CCxl3FZ1AdSjNmgwbLFI5kYc3GEXNj3XdwHMgzuLajGgQFw3zEdcbD6MDDyxZaJ47nsJcmFFvbrX25Kx6w0pH8HScOYHAH6sW75XvlsEiZ/0dxCTS20i453cbrY7iFK4Wne+n63Xi4OXGOZlV0pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM9sqj1etn1Wfdy9PyTHHGycCBuSP2f5MZb4jgUylBY=;
 b=ejtrAvdyrXWKp0RnFafgiefQbolxJGmBeokhymFYYgKa6bM5uSc1EkzFh5FbFCqDT1HgpdADo+d/lEUsFnKUvShLBPcBc9alKOoHy2e+RxHS7q+4a5NkASD2nLqmCq8nDq9ROSqXY2ZvLXpw6jWKfEr1C0JER1NvS8TuRhAesOoM/H7DISWqtW/jiqjghE/c0z5BuXdMTvWx4ieTa4Hy/ewn7+sDA6gifFSNVinDfSEfnnuC1LBHXfmz4I5lpzK6A5YIvj5Jm0BGr0xg7m5ey1zGXRAWuH7jWExGU4lVaxpqHvu5deVS5maBkVnF97ZFXhxsGQXkQ6MHUR5LdIQKog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM9sqj1etn1Wfdy9PyTHHGycCBuSP2f5MZb4jgUylBY=;
 b=ixINvWL6E8Yp8OszVQ2zBDTKz2IqVM7ADevwA089V7CQC0TMYfoHkfIeLJyZ8mfrlY9eB3iaHAaJtE4bozH1iI3N/nsADJqsA9wwENYc2b+vGEjU3fvmOottE8NDD9ZMLwwG2U7SVumlqI12RgBfgtwUuboLbDKXi+PxnD4I/yU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2454.namprd15.prod.outlook.com (2603:10b6:a02:89::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Tue, 12 May
 2020 14:39:32 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 14:39:32 +0000
Subject: Re: [PATCH v2 bpf-next 1/3] selftests/bpf: add benchmark runner
 infrastructure
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200508232032.1974027-1-andriin@fb.com>
 <20200508232032.1974027-2-andriin@fb.com>
 <3fc4af5c-739a-35c3-c649-03eef18a3144@fb.com>
 <CAEf4BzYkbsd3EUXoH8M80+udtz-owN6gAb-Hpp==bNU2Pk6x+A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <80ca0fba-8a30-4f1f-6bf3-7ccaa1fa8d69@fb.com>
Date:   Tue, 12 May 2020 07:39:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzYkbsd3EUXoH8M80+udtz-owN6gAb-Hpp==bNU2Pk6x+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0106.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::47) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:d0f0) by BYAPR07CA0106.namprd07.prod.outlook.com (2603:10b6:a03:12b::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 12 May 2020 14:39:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:d0f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 914c8a16-53bc-40e8-efbc-08d7f682489f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2454164FEF4D19C00E65006BD3BE0@BYAPR15MB2454.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aquwXo9ghBumVbiRX9BS3xPul+VZa99ycWd8uk00LkZxaVSWhzPL18PPL93MzSt0WAROv3ejc+WpY4H1jo9ID/41QzFiwlp6F3U03dxgWko2HN20QpsYf2UAoKAfmMwp9nNebwbMNS8gJf5+cBUMl43UwKTQA+h+ntEzxAdL11jAF2cFowYWfmz23F7rsvN5D2Zr2KDQeXeZHJf3FFlMIstVaNKavHTG4t5ViRhYxSpega5dEcb7uTg417z6+CvtX9qQbOw1v49+rIEG3cwaNBuntQ4EJbf5Zgz8DLkTPRlXaNAUheJ6+PXK+bbta4ypP+DYrQiQOwIcHLCwSkB54Dxdxrykd2Y4iiVFxEZi/Lfh0yN4W4+zRm9u8dlJsJdGlo9DmyTapJ6k/6NURAYwUq1yede03rpfkG8QfRh+zY6d8OtpafXshI84j9Z8/NIIUxrJ22XiRgZdixwccBlnlJCX5VSadEuB21hSYvNZ5aFGZI5ZXyFcuIXCN6KIv+alQqH3GZRKQz5MnF5WvwVvRp2AMc25IKzItUE//WLCkbq3gRze5BYZPiOFUb4A3FC9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(33430700001)(316002)(31696002)(86362001)(186003)(16526019)(4326008)(2906002)(66556008)(33440700001)(54906003)(8676002)(66476007)(8936002)(52116002)(36756003)(66946007)(6486002)(6506007)(53546011)(6512007)(31686004)(478600001)(6916009)(5660300002)(30864003)(6666004)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gVILPom4+e/fwu5hl6IN/F9kOdZLn7iOXs1hu0mU7uWL32H7JaV8xQEfki3fxNIJIPVQXx8PQe5//PwZ1LqLL3FMLsYINLSGurRyXToKMxOJLptQCXO0ywDTiT8B2clo+e4YZgiFYPmY+uxKWjWT9De7HgaGQaWdt+Srs2rMFUiurYpPFOoQraadTf9TE48xbt1YQNIdjs69xHmW6cNjoTWmVdssngA6VgliarXfkxJ6sLcr4FMySBrrv+NGDkr7BUQH5G+AcMxGrojA5SV4DV6TmHPAwvodRfQ3bt8SCMwLY4I3AgfyFX63e3WQ3MZTUpoR2NVkozLNSBHWuYiZEEwutZ/YqsUxfHdDjk0MMUs1EUjisWaOnWqNYimXU5JmmnejtHiiYhv23fHnJI/m0no4kZ12Pt/tOw5d9B9NwnxhXVdDHUIDEvLMutjFizHVoEnpchHwl79AtQAcLfjVmWZnzQsGZfA8CE/2ZZixWAJkZUUTvMucjA/AwJBKOox/nEoEvnS1cJhtsApkI0vtvQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 914c8a16-53bc-40e8-efbc-08d7f682489f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 14:39:32.3205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZ/9E2YML+Gr004QH20QvMfDxL7XoOUNwWcS++Z7o990wZNmGwe68kPgEAJDYjI7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_04:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120111
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 8:29 PM, Andrii Nakryiko wrote:
> On Sat, May 9, 2020 at 10:10 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
>>> While working on BPF ringbuf implementation, testing, and benchmarking, I've
>>> developed a pretty generic and modular benchmark runner, which seems to be
>>> generically useful, as I've already used it for one more purpose (testing
>>> fastest way to trigger BPF program, to minimize overhead of in-kernel code).
>>>
>>> This patch adds generic part of benchmark runner and sets up Makefile for
>>> extending it with more sets of benchmarks.
>>>
>>> Benchmarker itself operates by spinning up specified number of producer and
>>> consumer threads, setting up interval timer sending SIGALARM signal to
>>> application once a second. Every second, current snapshot with hits/drops
>>> counters are collected and stored in an array. Drops are useful for
>>> producer/consumer benchmarks in which producer might overwhelm consumers.
>>>
>>> Once test finishes after given amount of warm-up and testing seconds, mean and
>>> stddev are calculated (ignoring warm-up results) and is printed out to stdout.
>>> This setup seems to give consistent and accurate results.
>>>
>>> To validate behavior, I added two atomic counting tests: global and local.
>>> For global one, all the producer threads are atomically incrementing same
>>> counter as fast as possible. This, of course, leads to huge drop of
>>> performance once there is more than one producer thread due to CPUs fighting
>>> for the same memory location.
>>>
>>> Local counting, on the other hand, maintains one counter per each producer
>>> thread, incremented independently. Once per second, all counters are read and
>>> added together to form final "counting throughput" measurement. As expected,
>>> such setup demonstrates linear scalability with number of producers (as long
>>> as there are enough physical CPU cores, of course). See example output below.
>>> Also, this setup can nicely demonstrate disastrous effects of false sharing,
>>> if care is not taken to take those per-producer counters apart into
>>> independent cache lines.
>>>
>>> Demo output shows global counter first with 1 producer, then with 4. Both
>>> total and per-producer performance significantly drop. The last run is local
>>> counter with 4 producers, demonstrating near-perfect scalability.
>>>
>>> $ ./bench -a -w1 -d2 -p1 count-global
>>> Setting up benchmark 'count-global'...
>>> Benchmark 'count-global' started.
>>> Iter   0 ( 24.822us): hits  148.179M/s (148.179M/prod), drops    0.000M/s
>>> Iter   1 ( 37.939us): hits  149.308M/s (149.308M/prod), drops    0.000M/s
>>> Iter   2 (-10.774us): hits  150.717M/s (150.717M/prod), drops    0.000M/s
>>> Iter   3 (  3.807us): hits  151.435M/s (151.435M/prod), drops    0.000M/s
>>> Summary: hits  150.488 ± 1.079M/s (150.488M/prod), drops    0.000 ± 0.000M/s
>>>
>>> $ ./bench -a -w1 -d2 -p4 count-global
>>> Setting up benchmark 'count-global'...
>>> Benchmark 'count-global' started.
>>> Iter   0 ( 60.659us): hits   53.910M/s ( 13.477M/prod), drops    0.000M/s
>>> Iter   1 (-17.658us): hits   53.722M/s ( 13.431M/prod), drops    0.000M/s
>>> Iter   2 (  5.865us): hits   53.495M/s ( 13.374M/prod), drops    0.000M/s
>>> Iter   3 (  0.104us): hits   53.606M/s ( 13.402M/prod), drops    0.000M/s
>>> Summary: hits   53.608 ± 0.113M/s ( 13.402M/prod), drops    0.000 ± 0.000M/s
>>>
>>> $ ./bench -a -w1 -d2 -p4 count-local
>>> Setting up benchmark 'count-local'...
>>> Benchmark 'count-local' started.
>>> Iter   0 ( 23.388us): hits  640.450M/s (160.113M/prod), drops    0.000M/s
>>> Iter   1 (  2.291us): hits  605.661M/s (151.415M/prod), drops    0.000M/s
>>> Iter   2 ( -6.415us): hits  607.092M/s (151.773M/prod), drops    0.000M/s
>>> Iter   3 ( -1.361us): hits  601.796M/s (150.449M/prod), drops    0.000M/s
>>> Summary: hits  604.849 ± 2.739M/s (151.212M/prod), drops    0.000 ± 0.000M/s
>>>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>>    tools/testing/selftests/bpf/.gitignore        |   1 +
>>>    tools/testing/selftests/bpf/Makefile          |  13 +-
>>>    tools/testing/selftests/bpf/bench.c           | 372 ++++++++++++++++++
>>>    tools/testing/selftests/bpf/bench.h           |  74 ++++
>>>    .../selftests/bpf/benchs/bench_count.c        |  91 +++++
>>>    5 files changed, 550 insertions(+), 1 deletion(-)
>>>    create mode 100644 tools/testing/selftests/bpf/bench.c
>>>    create mode 100644 tools/testing/selftests/bpf/bench.h
>>>    create mode 100644 tools/testing/selftests/bpf/benchs/bench_count.c
>>>
> 
> [...]
> 
> trimming is good :)
> 
>>> +
>>> +void hits_drops_report_final(struct bench_res res[], int res_cnt)
>>> +{
>>> +     int i;
>>> +     double hits_mean = 0.0, drops_mean = 0.0;
>>> +     double hits_stddev = 0.0, drops_stddev = 0.0;
>>> +
>>> +     for (i = 0; i < res_cnt; i++) {
>>> +             hits_mean += res[i].hits / 1000000.0 / (0.0 + res_cnt);
>>> +             drops_mean += res[i].drops / 1000000.0 / (0.0 + res_cnt);
>>> +     }
>>> +
>>> +     if (res_cnt > 1)  {
>>> +             for (i = 0; i < res_cnt; i++) {
>>> +                     hits_stddev += (hits_mean - res[i].hits / 1000000.0) *
>>> +                                    (hits_mean - res[i].hits / 1000000.0) /
>>> +                                    (res_cnt - 1.0);
>>> +                     drops_stddev += (drops_mean - res[i].drops / 1000000.0) *
>>> +                                     (drops_mean - res[i].drops / 1000000.0) /
>>> +                                     (res_cnt - 1.0);
>>> +             }
>>> +             hits_stddev = sqrt(hits_stddev);
>>> +             drops_stddev = sqrt(drops_stddev);
>>> +     }
>>> +     printf("Summary: hits %8.3lf \u00B1 %5.3lfM/s (%7.3lfM/prod), ",
>>> +            hits_mean, hits_stddev, hits_mean / env.producer_cnt);
>>> +     printf("drops %8.3lf \u00B1 %5.3lfM/s\n",
>>> +            drops_mean, drops_stddev);
>>
>> The unicode char \u00B1 (for +|-) may cause some old compiler (e.g.,
>> 4.8.5) warnings as it needs C99 mode.
>>
>> /data/users/yhs/work/net-next/tools/testing/selftests/bpf/bench.c:91:9:
>> warning: universal character names are only valid in C++ and C99
>> [enabled by default]
>>     printf("Summary: hits %8.3lf \u00B1 %5.3lfM/s (%7.3lfM/prod), ",
>>
>> "+|-" is alternative, but not as good as \u00B1 indeed. Newer
>> compiler may already have the default C99. Maybe we can just add
>> C99 for build `bench`?
> 
> I think I'm fine with ancient compiler emitting harmless warning for
> code under selftests/bpf, honestly...
> 
>>
>>> +}
>>> +
>>> +const char *argp_program_version = "benchmark";
>>> +const char *argp_program_bug_address = "<bpf@vger.kernel.org>";
>>> +const char argp_program_doc[] =
>>> +"benchmark    Generic benchmarking framework.\n"
>>> +"\n"
>>> +"This tool runs benchmarks.\n"
>>> +"\n"
>>> +"USAGE: benchmark <bench-name>\n"
>>> +"\n"
>>> +"EXAMPLES:\n"
>>> +"    # run 'count-local' benchmark with 1 producer and 1 consumer\n"
>>> +"    benchmark count-local\n"
>>> +"    # run 'count-local' with 16 producer and 8 consumer thread, pinned to CPUs\n"
>>> +"    benchmark -p16 -c8 -a count-local\n";
>>
>> Some of the above global variables probably are statics.
>> But I do not have a strong preference on this.
> 
> Oh, it's actually global variables argp library expects, they have to be global.
> 
>>
>>> +
>>> +static const struct argp_option opts[] = {
>>> +     { "list", 'l', NULL, 0, "List available benchmarks"},
>>> +     { "duration", 'd', "SEC", 0, "Duration of benchmark, seconds"},
>>> +     { "warmup", 'w', "SEC", 0, "Warm-up period, seconds"},
>>> +     { "producers", 'p', "NUM", 0, "Number of producer threads"},
>>> +     { "consumers", 'c', "NUM", 0, "Number of consumer threads"},
>>> +     { "verbose", 'v', NULL, 0, "Verbose debug output"},
>>> +     { "affinity", 'a', NULL, 0, "Set consumer/producer thread affinity"},
>>> +     { "b2b", 'b', NULL, 0, "Back-to-back mode"},
>>> +     { "rb-output", 10001, NULL, 0, "Set consumer/producer thread affinity"},
>>
>> I did not see b2b and rb-output options are processed in this file.
> 
> Slipped through the rebasing cracks from the future ringbuf
> benchmarks, will remove it. I also figured out a way to do this more
> modular anyways (child parsers in argp).
> 
>>
>>> +     {},
>>> +};
>>> +
> 
> [...]
> 
>>> +     for (i = 0; i < env.consumer_cnt; i++) {
>>> +             err = pthread_create(&state.consumers[i], NULL,
>>> +                                  bench->consumer_thread, (void *)(long)i);
>>> +             if (err) {
>>> +                     fprintf(stderr, "failed to create consumer thread #%d: %d\n",
>>> +                             i, -errno);
>>> +                     exit(1);
>>> +             }
>>> +             if (env.affinity)
>>> +                     set_thread_affinity(state.consumers[i], i);
>>> +     }
>>> +     for (i = 0; i < env.producer_cnt; i++) {
>>> +             err = pthread_create(&state.producers[i], NULL,
>>> +                                  bench->producer_thread, (void *)(long)i);
>>> +             if (err) {
>>> +                     fprintf(stderr, "failed to create producer thread #%d: %d\n",
>>> +                             i, -errno);
>>> +                     exit(1);
>>> +             }
>>> +             if (env.affinity)
>>> +                     set_thread_affinity(state.producers[i],
>>> +                                         env.consumer_cnt + i);
>>
>> Here, we bind consumer threads first and then producer threads, I think
>> this is probably just arbitrary choice?
> 
> yep, almost arbitrary. Most of my cases have 1 consumer and >=1
> producers, so it was convenient to have consumer pinned to same CPU,
> regardless of how many producers I have.
> 
>>
>> In certain cases, I think people may want to have more advanced binding
>> scenarios, e.g., for hyperthreading, binding consumer and producer on
>> the same core or different cores etc. One possibility is to introduce
>> -c option similar to taskset. If -c not supplied, you can have
>> the current default. Otherwise, using -c list.
>>
> 
> well, taskset's job is simpler, it takes a list of CPUs for single
> PID, if I understand correctly. Here we have many threads, each might
> have different CPU or even CPUs. But I agree that for some benchmarks
> it's going to be critical to control this precisely. Here's how I'm
> going to allows most flexibility without too much complexity.
> 
> --prod-affinity 1,2,10-16,100 -- will specify a set of CPUs for
> producers. First producer will use CPU with least index form that
> list. Second will take second, and so on. If there are less CPUs
> provided than necessary - it's an error. If more - it's fine.
> 
> Then for consumers will add independent --cons-affinity parameters,
> which will do the same for consumer threads.
> 
> Having two independent lists will allow to test scenarios where we
> want producers and consumers to fight for the same CPU.
> 
> Does this sound ok?

This sounds good, more than what I asked.

> 
>>> +     }
>>> +
>>> +     printf("Benchmark '%s' started.\n", bench->name);
>>> +}
>>> +
> 
> [...]
