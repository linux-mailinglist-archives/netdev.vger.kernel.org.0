Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10166257E8D
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgHaQUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:20:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41500 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727939AbgHaQUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:20:16 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGJqMQ024191;
        Mon, 31 Aug 2020 09:19:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8fWNIfCEhRn0vBG8PPYVxeG/xhDB403A7pFvgNtXmkw=;
 b=NypFwoUlLPjcgP+KngjUywSv8aM6zrMfIuuKqnRCFbo57P2ZUJ/wtHBoKGXZB8woWwHd
 8p8Ns5ztIniDeESwqsf91emjw7B+uji2f4pfs1TbEaF5+27D2PlaWsK9ueTgOEDdRzo1
 t1le+/69CUQsrxH6bMSIFTPr4r0Ud0QrIjI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 338gqn40qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 31 Aug 2020 09:19:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 09:19:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcOFr48accOsppYk0usW7HFzZuD8trM2n7rFPenTRyGA3S6VxT1a5pgeNvyt7vjQB6j/b/C60QG78KiUwjYVUnQ6XcZh/pUO216cs53ehZrqUPnxjOnVzmgnLCZqXVl2Z+Bu4EqLLBHwzw8gbVR8x7aBm5RbBtSLecljxa4B22xU+13mpBmmYwf/DfUWOArWOEYFH4O2SMTOHBWU24J0yDHepQncd60IGbos6mfENqpjAQpX/f9ptCxlikH9SvOer6ZbKLlz6t8IXUaDQAF0gjVUwK+xnRgb1t4+x0hQM1pqeVQJBUPegTl8trLQ41HXX/M/sPcG9no/I3vO7lfU0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fWNIfCEhRn0vBG8PPYVxeG/xhDB403A7pFvgNtXmkw=;
 b=he6JhuMcnOyyJWa3we1A4BJ7qDJYCqAvfvhhgaGWis/b3PckKYvlfKdwLJaIHGW336VLbZipMVLgx4boiZ4S//2cpTdvUjFlvKcindcx9Df1M7Q62tsQse3YuoR9HrENNhdGn38RenbVieFd3dSJqw1gdCpiugn02Pc6hB1jD4FI502qNhLOIlr6zO71YkXnAW9NdP4DhcO6TXKcjLEP6hgWhD1VP2h+EwbG8KtCtur6iodN2a+IQ5ADTxCN/dKUA1onpLOPRT/DhaJweGavzfdWK5qFU6IA5lXjgH5hZYNPl5rFjCI7JkLUrpA+ZvO+HR+C8jaTpIv7tYnJaRBK/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fWNIfCEhRn0vBG8PPYVxeG/xhDB403A7pFvgNtXmkw=;
 b=cW3SQebA6tHCe3Sre+4tRZaZjBMzBpKBbHvHbpQr22BxYlYolmt+KSS/1Shka7E2hrCwLw3oGMwK1/nI/gyVJvjCkY8fztWaYabfxft/iLxH/H9/p2sy3O0zeaiSYwOzpPBVedS1mJqj93NykqgGIAAA0i9Av2hudBqdm2uJAeo=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW2PR1501MB2156.namprd15.prod.outlook.com (2603:10b6:302:d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Mon, 31 Aug
 2020 16:19:52 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 16:19:52 +0000
Subject: Re: [PATCH v2 bpf-next] bpf: Fix build without BPF_SYSCALL, but with
 BPF_JIT.
To:     <paulmck@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20200831155155.62754-1-alexei.starovoitov@gmail.com>
 <20200831161552.GA2855@paulmck-ThinkPad-P72>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <0f277bc8-9dca-aca8-c7c3-af2991282588@fb.com>
Date:   Mon, 31 Aug 2020 09:19:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200831161552.GA2855@paulmck-ThinkPad-P72>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0067.namprd07.prod.outlook.com
 (2603:10b6:a03:60::44) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR07CA0067.namprd07.prod.outlook.com (2603:10b6:a03:60::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 16:19:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:4d4f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10497a87-2fff-45cf-f72e-08d84dc9b08b
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2156:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR1501MB21560F7494778583E726E8D7D7510@MW2PR1501MB2156.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQp8XUTBfzY2UTnsPD6hb3SlmBgtLyoLU6JZSzrkBmI2sS6j34Rs2Lckc3W8/AWKd3nODD2Ho2iL1uqgzWI8p3CAULa+ugWCq3ySqZYR0JpuK6zrPbaNZlRrZXwFZs0+54nBp58sWNv8LFQixJ6ImqAEPywl64tRqnQcV2LADNzSUsAk9C8arozJwpeBa4wjwJ6lMiWj8u+Wlz5kF/CuIk3r/sDbDC3iV8RjUG5CaooUFAyHkUk+PULTYQG17ivrgtYdoe7IgX76VNgvQJ2nE9ui9kc3v0nv4O5Qjz8bZN8rllJwV9BqYBeicrOLYmKMCOntlWThUmfRM3hxMK6lyaY0AENfDFkQP/WeSyuPFdzjSshPntb5bqEppn1BrYBD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(39860400002)(376002)(396003)(53546011)(86362001)(8676002)(316002)(8936002)(5660300002)(2906002)(52116002)(4326008)(36756003)(6486002)(31686004)(66946007)(956004)(2616005)(66556008)(66476007)(16576012)(6916009)(31696002)(478600001)(83380400001)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cvbLEYLm5x1JPOXcv3e9MhBPB7gSEYM5TzaNZDRHSSiYkEoKy38Dqm7d6Mg6OkkH5JnZarCt63oyFWwTX+pqN9ULCHA6+Gp8z5BmAOeosZkm31SalLSpWz7zLvXTt/lYZyzuY6J3YJK83LvlGdArAWDJwtRRexqufXF23QLYww/Gr5ZiZho+5JbqfXCwyVxetyegyrt8DzSseHERnv52zkAbBwNfQ7rPnqHjACEZZ+KKTno7dJ9zDIcbotjWFRDyj1/LHwFIYF83k768ot686oIuR2vo2sQbN/VtHghou2Z6Sf+6d1S0j1/fMEyWNR5VcA00yMC4MjdICCiX12LGMH4yPUjCBOtWcEt6CKUNaOgCXI9tM8DewiYZcR9mYTA1aBt+a/4qBLRYY4FzmZ/GEiDS7c+dktFuH8NrUGvCponzFyUTm1Wu94NIVgcKIVmbBTqTtuiuq37gEFZ+VIHplzyKC410aEiZspv2YvMPcNnEt5a09FfNpOnFo4tV3PsM/BfrB3Idc0inUgtDSexEV8jB4TKRCf6QGd2mZervRgSEK52ZEfkKWWdoDCLEdVtP5AlaPER9W5D33hOoeIJcNJJvnMFNznyJaxFtXweUOWfno0OdbelwKBxx8BSTxFyzBZV4rgEiekBBgGxjht2HMXjrtWKSMJu3ykIOjfVv/eg=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10497a87-2fff-45cf-f72e-08d84dc9b08b
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3772.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 16:19:52.1799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1hXthabF0ubNkT0G4vX8ZdqYgC9x0L9UIqJeEaDKBP21kJbyTH45ugC5KsXxLZz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2156
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_08:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1011 suspectscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=874 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310097
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 9:15 AM, Paul E. McKenney wrote:
> On Mon, Aug 31, 2020 at 08:51:55AM -0700, Alexei Starovoitov wrote:
>> From: Alexei Starovoitov <ast@kernel.org>
>>
>> When CONFIG_BPF_SYSCALL is not set, but CONFIG_BPF_JIT=y
>> the kernel build fails:
>> In file included from ../kernel/bpf/trampoline.c:11:
>> ../kernel/bpf/trampoline.c: In function ‘bpf_trampoline_update’:
>> ../kernel/bpf/trampoline.c:220:39: error: ‘call_rcu_tasks_trace’ undeclared
>> ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_enter_sleepable’:
>> ../kernel/bpf/trampoline.c:411:2: error: implicit declaration of function ‘rcu_read_lock_trace’
>> ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_exit_sleepable’:
>> ../kernel/bpf/trampoline.c:416:2: error: implicit declaration of function ‘rcu_read_unlock_trace’
>>
>> This is due to:
>> obj-$(CONFIG_BPF_JIT) += trampoline.o
>> obj-$(CONFIG_BPF_JIT) += dispatcher.o
>> There is a number of functions that arch/x86/net/bpf_jit_comp.c is
>> using from these two files, but none of them will be used when
>> only cBPF is on (which is the case for BPF_SYSCALL=n BPF_JIT=y).
>>
>> Add rcu_trace functions to rcupdate_trace.h. The JITed code won't execute them
>> and BPF trampoline logic won't be used without BPF_SYSCALL.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
>> Acked-by: Paul E. McKenney <paulmck@kernel.org>
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> Looks good, and unless someone tells me otherwise, I am assuming that
> this one goes up the normal BPF patch route.

Yes. It fixes the issue in bpf-next tree.
