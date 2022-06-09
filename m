Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50A75442A0
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbiFIE1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiFIE1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:27:39 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDAD766B;
        Wed,  8 Jun 2022 21:27:35 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LJWJ95Yg1zjXFj;
        Thu,  9 Jun 2022 12:26:33 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 12:27:31 +0800
Message-ID: <55c1b9d6-1d53-9752-fb03-00f60ed15db7@huawei.com>
Date:   Thu, 9 Jun 2022 12:27:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v5 1/6] arm64: ftrace: Add ftrace direct call
 support
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        <cj.chengjian@huawei.com>, <huawei.libin@huawei.com>,
        <xiexiuqi@huawei.com>, <liwei391@huawei.com>
References: <Yo4xb2w+FHhUtJNw@FVFF77S0Q05N>
 <0f8fe661-c450-ccd8-761f-dbfff449c533@huawei.com>
 <Yo9REdx3nsgbZunE@FVFF77S0Q05N>
 <40fda0b0-0efc-ea1b-96d5-e51a4d1593dd@huawei.com>
 <Yp4s7eNGvb2CNtPp@FVFF77S0Q05N.cambridge.arm.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <Yp4s7eNGvb2CNtPp@FVFF77S0Q05N.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/2022 12:35 AM, Mark Rutland wrote:
> On Thu, May 26, 2022 at 10:48:05PM +0800, Xu Kuohai wrote:
>> On 5/26/2022 6:06 PM, Mark Rutland wrote:
>>> On Thu, May 26, 2022 at 05:45:03PM +0800, Xu Kuohai wrote:
>>>> On 5/25/2022 9:38 PM, Mark Rutland wrote:
>>>>> On Wed, May 18, 2022 at 09:16:33AM -0400, Xu Kuohai wrote:
>>>>>> Add ftrace direct support for arm64.
>>>>>>
>>>>>> 1. When there is custom trampoline only, replace the fentry nop to a
>>>>>>    jump instruction that jumps directly to the custom trampoline.
>>>>>>
>>>>>> 2. When ftrace trampoline and custom trampoline coexist, jump from
>>>>>>    fentry to ftrace trampoline first, then jump to custom trampoline
>>>>>>    when ftrace trampoline exits. The current unused register
>>>>>>    pt_regs->orig_x0 is used as an intermediary for jumping from ftrace
>>>>>>    trampoline to custom trampoline.
>>>>>
>>>>> For those of us not all that familiar with BPF, can you explain *why* you want
>>>>> this? The above explains what the patch implements, but not why that's useful.
>>>>>
>>>>> e.g. is this just to avoid the overhead of the ops list processing in the
>>>>> regular ftrace code, or is the custom trampoline there to allow you to do
>>>>> something special?
>>>>
>>>> IIUC, ftrace direct call was designed to *remove* the unnecessary
>>>> overhead of saving regs completely [1][2].
>>>
>>> Ok. My plan is to get rid of most of the register saving generally, so I think
>>> that aspect can be solved without direct calls.
>> Looking forward to your new solution.
> 
> For the register saving rework, I have a WIP branch on my kernel.org repo:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/ftrace/minimal-regs
>   git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/ftrace/minimal-regs
> 
> I'm working on that at the moment along with a per-callsite ops implementaiton
> that would avoid most of the need for custom trampolines (and work with branch
> range limitations):
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/ftrace/per-callsite-ops
>   git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/ftrace/per-callsite-ops
> 
>>>> [1]
>>>> https://lore.kernel.org/all/20191022175052.frjzlnjjfwwfov64@ast-mbp.dhcp.thefacebook.com/
>>>> [2] https://lore.kernel.org/all/20191108212834.594904349@goodmis.org/
>>>>
>>>> This patch itself is just a variant of [3].
>>>>
>>>> [3] https://lore.kernel.org/all/20191108213450.891579507@goodmis.org/
>>>>
>>>>>
>>>>> There is another patch series on the list from some of your colleagues which
>>>>> uses dynamic trampolines to try to avoid that ops list overhead, and it's not
>>>>> clear to me whether these are trying to solve the largely same problem or
>>>>> something different. That other thread is at:
>>>>>
>>>>>   https://lore.kernel.org/linux-arm-kernel/20220316100132.244849-1-bobo.shaobowang@huawei.com/
>>>>>
>>>>> ... and I've added the relevant parties to CC here, since there doesn't seem to
>>>>> be any overlap in the CC lists of the two threads.
>>>>
>>>> We're not working to solve the same problem. The trampoline introduced
>>>> in this series helps us to monitor kernel function or another bpf prog
>>>> with bpf, and also helps us to use bpf prog like a normal kernel
>>>> function pointer.
>>>
>>> Ok, but why is it necessary to have a special trampoline?
>>>
>>> Is that *just* to avoid overhead, or do you need to do something special that
>>> the regular trampoline won't do?
>>>
>>
>> Sorry for not explaining the problem. The main bpf prog accepts only a
>> single argument 'ctx' in r1, so to allow kernel code to call bpf prog
>> transparently, we need a trampoline to convert native calling convention
>> into BPF calling convention [1].
>>
>> [1] https://lore.kernel.org/bpf/20191114185720.1641606-5-ast@kernel.org/
> 
> Thanks for the pointer; I'll go page that in.
> 
>> For example,
>>
>> SEC("struct_ops/dctcp_state")
>> void BPF_PROG(dctcp_state, struct sock *sk, __u8 new_state)
>> {
>>     // do something
>> }
>>
>> The above bpf prog will be compiled to something like this:
>>
>> dctcp_state:
>>     r2 = *(u64 *)(r1 + 8)  // new_state
>>     r1 = *(u64 *)(r1 + 0)  // sk
>>     ...
>>
>> It accepts only one argument 'ctx' in r1, and loads the actual arugment
>> 'sk' and 'new_state' from r1 + 0 and r1 + 8, resepectively. So before
>> calling this prog, we need to construct 'ctx' and store its address to r1.
>>
>>>>>
>>>>> In that other thread I've suggested a general approach we could follow at:
>>>>>   
>>>>>   https://lore.kernel.org/linux-arm-kernel/YmGF%2FOpIhAF8YeVq@lakrids/
>>>>
>>>> Is it possible for a kernel function to take a long jump to common
>>>> trampoline when we get a huge kernel image?
>>>
>>> It is possible, but only where the kernel Image itself is massive and the .text
>>> section exceeeds 128MiB, at which point other things break anyway. Practically
>>> speaking, this doesn't happen for production kernels, or reasonable test
>>> kernels.
>>
>> So even for normal kernel functions, we need some way to construct and
>> destruct long jumps atomically and safely.
> 
> My point was that case is unrealistic for production kernels, and utterly
> broken anyway (and as below I intend to make ftrace detect this and mark itself
> as broken).
> 
> FWIW, an allmodconfig kernel built with GCC 12.1.0 has a ~30MB .text segment,
> so for realistic kernels we have plenty of headroom for normal functions to
> reach the in-kernel trampoline.
> 
>>> I've been meaning to add some logic to detect this at boot time and idsable
>>> ftrace (or at build time), since live patching would also be broken in that
>>> case.
>>>>>> As noted in that thread, I have a few concerns which equally apply here:
>>>>>
>>>>> * Due to the limited range of BL instructions, it's not always possible to
>>>>>   patch an ftrace call-site to branch to an arbitrary trampoline. The way this
>>>>>   works for ftrace today relies upon knowingthe set of trampolines at
>>>>>   compile-time, and allocating module PLTs for those, and that approach cannot
>>>>>   work reliably for dynanically allocated trampolines.
>>>>
>>>> Currently patch 5 returns -ENOTSUPP when long jump is detected, so no
>>>> bpf trampoline is constructed for out of range patch-site:
>>>>
>>>> if (is_long_jump(orig_call, image))
>>>> 	return -ENOTSUPP;
>>>
>>> Sure, my point is that in practice that means that (from the user's PoV) this
>>> may randomly fail to work, and I'd like something that we can ensure works
>>> consistently.
>>>
>>
>> OK, should I suspend this work until you finish refactoring ftrace?
> 
> Yes; I'd appreciate if we could hold on this for a bit.
> 
> I think with some ground work we can avoid most of the painful edge cases and
> might be able to avoid the need for custom trampolines.
> 

I'v read your WIP code, but unfortunately I didn't find any mechanism to
replace bpf trampoline in your code, sorry.

It looks like bpf trampoline and ftrace works can be done at the same
time. I think for now we can just attach bpf trampoline to bpf prog.
Once your ftrace work is done, we can add support for attaching bpf
trampoline to regular kernel function. Is this OK?

> Thanks,
> Mark.
> .
