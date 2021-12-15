Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F93475079
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 02:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbhLOBUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 20:20:41 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29131 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbhLOBUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 20:20:41 -0500
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JDHRR1NWMz1DK4k;
        Wed, 15 Dec 2021 09:17:39 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 09:20:34 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 09:20:34 +0800
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix building error when using
 userspace pt_regs
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <shuah@kernel.org>
CC:     <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211214135555.125348-1-pulehui@huawei.com>
 <9063be69-fbd9-c0a5-9271-c6d4281c71ef@iogearbox.net>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <30aa8ea2-3752-d711-50f8-4b3d49cad56f@huawei.com>
Date:   Wed, 15 Dec 2021 09:20:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <9063be69-fbd9-c0a5-9271-c6d4281c71ef@iogearbox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/12/15 4:01, Daniel Borkmann wrote:
> On 12/14/21 2:55 PM, Pu Lehui wrote:
>> When building bpf selftests on arm64, the following error will occur:
>>
>> progs/loop2.c:20:7: error: incomplete definition of type 'struct
>> user_pt_regs'
>>
>> Some archs, like arm64 and riscv, use userspace pt_regs in
>> bpf_tracing.h, which causes build failure when bpf prog use
>> macro in bpf_tracing.h. So let's use vmlinux.h directly.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> 
> Looks like this lets CI fail, did you run the selftests also with 
> vmtest.sh to
> double check?
> 
> https://github.com/kernel-patches/bpf/runs/4521708490?check_suite_focus=true 
> :
> 
> [...]
> #189 verif_scale_loop6:FAIL
> libbpf: prog 'trace_virtqueue_add_sgs': BPF program load failed: 
> Argument list too long
> libbpf: prog 'trace_virtqueue_add_sgs': -- BEGIN PROG LOAD LOG --
> R1 type=ctx expected=fp
> BPF program is too large. Processed 1000001 insn
> verification time 12250995 usec
> stack depth 88
> processed 1000001 insns (limit 1000000) max_states_per_insn 107 
> total_states 21739 peak_states 2271 mark_read 6
> -- END PROG LOAD LOG --
> libbpf: failed to load program 'trace_virtqueue_add_sgs'
> libbpf: failed to load object 'loop6.o'
> scale_test:FAIL:expect_success unexpected error: -7 (errno 7)
> Summary: 221/986 PASSED, 8 SKIPPED, 1 FAILED
> [...]
> 
> Please take a look and fix in your patch, thanks!
> .
Sorry for my negligence, I'll take a look and fix it.
