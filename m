Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235C02B1FA9
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgKMQKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:10:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31286 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbgKMQKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:10:02 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADG5Zd2022700;
        Fri, 13 Nov 2020 08:09:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=I7I+IRWlsfAk/Khrk2N3iQjoUWBzsqhIar0aaTPBJGs=;
 b=dtzdjwyBc9v+Fy3X0WBOuBwLx8c0CL/R68DA9faylxiFZbKQqBWC6ln8DVy7Jo2ORgKk
 0ZF6JRQeFjozt/Dx2dusV97W/ob19Nf2p8cUf2IP8jae6+HHg9UtDrLM7ZzwqWPPR0xb
 aMszce5SM0jS+zcVcTrA1iotNKk06/FOErQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34sw7kr2cg-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 08:09:03 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 08:09:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQD+Waa+JC9PA+se6SUbhqs3m//k5JnxFHjOpgr0nJRCQtc/jFRlRWU63MlhT1OjOOYD4RkkbpHcCLxE9M/VX68xmCTKqhpY11AaZxl25hZAHhq02qxr+v0/pmX9Txk2skq72wBn0JDi3CSrL9u4CsSoL4UWDHebQMICtdAAMs42W8AXvI0kDoZ1e5+dk3ezf5a78v1bDLOgQrZDD2pe3pw5TAlq8G6rjxAdkCBT48h+ugVvfoiU9FfVNh0g6h6k9nwzzBP9JdszTo2DynkWHTowb0CMYlqf/2T2oTEyCcLrV9KficVb41Qm6TvzeyJT3S1CUjI6n0YpvNSO022gzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieZpfzaZLISiE4A1D24q7zeZNiuOQmKf6v+Bw3ZgAUQ=;
 b=ICf4RtBs42Hb2kCRVgI30lnGHgJtCXKnYpGlVdQXUojmuosQOz31fo05quDhPPFdBNzPBNJ9GyH8enzHkD4wlicjvr8uTTCPWOsY07u0MEyE2HJvpQ1nSXbID3pPALJuERXn895uKLMtijn5y5S5hPPhu/ytAuLFEpIVUFUli4yQ/hTk1q60Na69UKRkORoanUzT12fzapgIzTXPnmNS6ETsnu9wN6H0jDh8Wse2QXcRanYdlZsArvTVo0Akl5NdR2kr/AQol+j/u+VIooLycT6w/BVXnWfGNIE5M/u/ihjPgltK3PCZkcKEjlws9YHGeYws4HfK1gPXj1xCWcsvQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieZpfzaZLISiE4A1D24q7zeZNiuOQmKf6v+Bw3ZgAUQ=;
 b=Q7E6azFywMIsWju32FC8vAuuCi+S61KFW+ZgUMF8BVZa+hxN4w8NDk7AbS1s7kBsG0BTTcNfmvsnbz0cXTkCMDlqpbC1ff+6hX68oo+WE4KHLcw6Gg3mH5vSUggQ5eX5vOBgu/a9gqcylRl0otTLQmCibnCrcUEs5zcNnSo7QZM=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by SJ0PR15MB4203.namprd15.prod.outlook.com (2603:10b6:a03:2e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Fri, 13 Nov
 2020 16:09:01 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 16:09:01 +0000
Subject: Re: KASAN: vmalloc-out-of-bounds Read in bpf_trace_run3
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>, <mmullins@fb.com>,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <00000000000004500b05b31e68ce@google.com>
 <CACT4Y+aBVQ6LKYf9wCV=AUx23xpWmb_6-mBqwkQgeyfXA3SS2A@mail.gmail.com>
 <20201113053722.7i4xkiyrlymcwebg@hydra.tuxags.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c63f89b2-0627-91d8-a609-3f2a3b5b5a2d@fb.com>
Date:   Fri, 13 Nov 2020 08:08:57 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
In-Reply-To: <20201113053722.7i4xkiyrlymcwebg@hydra.tuxags.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:a1da]
X-ClientProxiedBy: MWHPR10CA0023.namprd10.prod.outlook.com (2603:10b6:301::33)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::11f6] (2620:10d:c090:400::5:a1da) by MWHPR10CA0023.namprd10.prod.outlook.com (2603:10b6:301::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Fri, 13 Nov 2020 16:08:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51487e94-4483-4c2e-6ab2-08d887ee6f5f
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4203:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4203B0303AACF3456C164043D3E60@SJ0PR15MB4203.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFraG1bl0CbPpMQNoYQcPQp02bvOdMcBUe6UZ3IAzn77XZDmTHLvJWy6QBXvC+QhuWSkhEnuPeOP8M2vWDXq7xRbJWckmhGm1DjF5LHp+XAqUbn9Zg+U5EaUHYksYf9OsDhy0dlR0wYD1dHNbKf007SPmHOggh4hzmOmc2vwGQ5eJf22Y5CgH5kPoRG5bFyEm15ZPyIZaTC6SpAcdg6ZJuPsxDuo+flKVsb3m9f2YZ08mvYECzU+zURqSnWJIIrq2QNFn5IGVIGzElGpCcbSsP/ri+DtQS4Wdheha5NwDT/7kFXRC7qWRU+Z9QWy5mO60R5ZBa+EYHDCX9GyUN9BNHdsNamOBhALiB32Jn5q8UfxPPE0vmeneCPBIQvR8GDHE2DR2SjtPGVMrEtntQ9Wm9LFB9jGOpCC8KH6ZXW7+umMBSjXtjEBntkKxmeyfshcm7TW4Jgl/ZzQ6Uj0PVqRJK6QQuDhaSXOI+MFEza4VerELCwADdhKNusofkL4hW5b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(396003)(346002)(6486002)(2906002)(83380400001)(66946007)(316002)(110136005)(921005)(8936002)(86362001)(7416002)(36756003)(5660300002)(2616005)(66556008)(66476007)(8676002)(52116002)(478600001)(31696002)(186003)(31686004)(16526019)(53546011)(966005)(99710200001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yEsScjcYnIzw5dMzf2VkyPrznIC7Wq/OyCS4qZy4m0IJVnv2lgzIUlwOyz7m5PT9saD4mhc2BAdvlqYRja1P2Po2oyJ6XS/AJCbNRUqWXSOTRErKcuyxS0x7P9rb4OnX2ArE1CuDnSJaXdzmrS3VPZw0Oqzjfok2Vr46xXXaWaAP/thbc4oWkAU/x76thYfK9nCqRzopwrCYTyNWAvJVVj2ERZeZ+JddPSUT0xerYCUVaHd5AzGtwP/k5/XuHxd8FYMquXJByb/K1khqfpuizyqjmYwDLqNtc2DGsdYH2V8uz/2KEekBcxZSC3tD//M5FTo6vW09vWqk2JqnIdY4mT3ce/E5UW6wtmK2i17W9QBQpAw+W38PrNJI7F8oMm+rpAaqKpi3JbxHzRrjN4e//z/NW0qucebrSKXBHQ90xJzne7gpIPrSQsM9LGawgjnuuEFwyO34nrClDBfXUSqZGlnwDbtcE9r25Nr56jv2Bnmzs4shTxIzG+WL4jAi+w1QOXpYFWplVX+RuiAzb118iU9eZBahOb5Z2F+MoEdi7LZmlCw/DpRL5hncRU+aZZQzPhiyS9JJbO9EUckUoYb49GOeWZSc8RgCrHX2+d3iXeH0irBvfcDKffyRrDwATy1dRO1Hh1MgPNF2V19psv2CFrokES56inr8r3jpAXZcDJc7232jJcbHZA3m4QgP4lXDDf1tdm/sNvfymnQhIu4fJ0Iy2O8rz5X8LKGXI6ivUUfXA+NWEdFFO0kR3hTige5qjmmjAxu4FZAgJQrgIhn5Ru4bLOLax0AVBlmUTPS/zqgjoFmmiLo1vyxBnXMLZo87mqNCak7ngQKbY7ru4km5kP3kqce/Adm/A6Z+/E0gyI6+amjBcq0P+GbuGwbNP1FwOr702O6jRFOW4hzvBiMs6U9J5j9PWpQycVhcF6gHoAE=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51487e94-4483-4c2e-6ab2-08d887ee6f5f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 16:09:01.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B62KOtR5ftOWJmM12KbJJM6JN+p0bSrZ80JM6Csn5VJlB1Gv0rEF/lE2OtmndHrM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4203
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 9 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 adultscore=0 bulkscore=0 clxscore=1011
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130104
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/20 9:37 PM, Matt Mullins wrote:
> On Wed, Nov 11, 2020 at 03:57:50PM +0100, Dmitry Vyukov wrote:
>> On Mon, Nov 2, 2020 at 12:54 PM syzbot
>> <syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com> wrote:
>>>
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    080b6f40 bpf: Don't rely on GCC __attribute__((optimize)) ..
>>> git tree:       bpf
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1089d37c500000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=58a4ca757d776bfe
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=d29e58bb557324e55e5e
>>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f4b032500000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1371a47c500000
>>>
>>> The issue was bisected to:
>>>
>>> commit 9df1c28bb75217b244257152ab7d788bb2a386d0
>>> Author: Matt Mullins <mmullins@fb.com>
>>> Date:   Fri Apr 26 18:49:47 2019 +0000
>>>
>>>      bpf: add writable context for raw tracepoints
>>
>>
>> We have a number of kernel memory corruptions related to bpf_trace_run now:
>> https://groups.google.com/g/syzkaller-bugs/search?q=kernel/trace/bpf_trace.c
>>
>> Can raw tracepoints "legally" corrupt kernel memory (a-la /dev/kmem)?
>> Or they shouldn't?
>>
>> Looking at the description of Matt's commit, it seems that corruptions
>> should not be possible (bounded buffer, checked size, etc). Then it
>> means it's a real kernel bug?
> 
> This bug doesn't seem to be related to the writability of the
> tracepoint; it bisected to that commit simply because it used
> BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE for the reproducer and it EINVAL's
> before that program type was introduced.  The BPF program it loads is
> pretty much a no-op.
> 
> The problem here is a kmalloc failure injection into
> tracepoint_probe_unregister, but the error is ignored -- so the bpf
> program is freed even though the tracepoint is never unregistered.
> 
> I have a first pass at a patch to pipe through the error code, but it's
> pretty ugly.  It's also called from the file_operations ->release(), for

Maybe you can still post the patch, so people can review and make 
suggestions which may lead to a *better* solution.

> which errors are solidly ignored in __fput(), so I'm not sure what the
> best way to handle ENOMEM is...
> 
>>
>>
>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12b6c4da500000
>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=11b6c4da500000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=16b6c4da500000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
>>> Fixes: 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
>>>
>>> ==================================================================
>>> BUG: KASAN: vmalloc-out-of-bounds in __bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
>>> BUG: KASAN: vmalloc-out-of-bounds in bpf_trace_run3+0x3e0/0x3f0 kernel/trace/bpf_trace.c:2083
>>> Read of size 8 at addr ffffc90000e6c030 by task kworker/0:3/3754
>>>
>>> CPU: 0 PID: 3754 Comm: kworker/0:3 Not tainted 5.9.0-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> Workqueue:  0x0 (events)
>>> Call Trace:
>>>   __dump_stack lib/dump_stack.c:77 [inline]
>>>   dump_stack+0x107/0x163 lib/dump_stack.c:118
>>>   print_address_description.constprop.0.cold+0x5/0x4c8 mm/kasan/report.c:385
>>>   __kasan_report mm/kasan/report.c:545 [inline]
>>>   kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>>>   __bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
>>>   bpf_trace_run3+0x3e0/0x3f0 kernel/trace/bpf_trace.c:2083
>>>   __bpf_trace_sched_switch+0xdc/0x120 include/trace/events/sched.h:138
>>>   __traceiter_sched_switch+0x64/0xb0 include/trace/events/sched.h:138
>>>   trace_sched_switch include/trace/events/sched.h:138 [inline]
>>>   __schedule+0xeb8/0x2130 kernel/sched/core.c:4520
>>>   schedule+0xcf/0x270 kernel/sched/core.c:4601
>>>   worker_thread+0x14c/0x1120 kernel/workqueue.c:2439
>>>   kthread+0x3af/0x4a0 kernel/kthread.c:292
>>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
>>>
>>>
>>> Memory state around the buggy address:
>>>   ffffc90000e6bf00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>   ffffc90000e6bf80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>> ffffc90000e6c000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>                                       ^
>>>   ffffc90000e6c080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>   ffffc90000e6c100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>> ==================================================================
[...]
