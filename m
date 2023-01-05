Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D4D65E46A
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjAEEJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjAEEId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:08:33 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10969107;
        Wed,  4 Jan 2023 20:06:36 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NnXV848MJz4f3lXl;
        Thu,  5 Jan 2023 11:47:28 +0800 (CST)
Received: from [10.67.109.184] (unknown [10.67.109.184])
        by APP2 (Coremail) with SMTP id Syh0CgDXy+lPSLZjWGduBA--.2842S2;
        Thu, 05 Jan 2023 11:47:31 +0800 (CST)
Message-ID: <426fdad5-17a5-41e7-57b9-aa4c1a4f4327@huaweicloud.com>
Date:   Thu, 5 Jan 2023 11:47:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH bpf-next] bpf, x86: Simplify the parsing logic of
 structure parameters
Content-Language: en-US
To:     Yonghong Song <yhs@meta.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Pu Lehui <pulehui@huawei.com>
References: <20230103013158.1945869-1-pulehui@huaweicloud.com>
 <ba11a68a-6099-0e0e-6531-e70e64429b7e@meta.com>
From:   Pu Lehui <pulehui@huaweicloud.com>
In-Reply-To: <ba11a68a-6099-0e0e-6531-e70e64429b7e@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgDXy+lPSLZjWGduBA--.2842S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuFW7Wr1fXr48CFykWr4xtFb_yoW7Ww1rpF
        s5Aw1UJryUJr1kGr18Jr1UJry7Jr4UJ3WDJr18XFyUJr4UAr1jqr1UXr10grWUJr48Jr1U
        Jr1jqrn3Zr15Jr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
        07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
        WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
        7IUbPEf5UUUUU==
X-CM-SenderInfo: psxovxtxl6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/5 2:24, Yonghong Song wrote:
> 
> 
> On 1/2/23 5:31 PM, Pu Lehui wrote:
>> From: Pu Lehui <pulehui@huawei.com>
>>
>> Extra_nregs of structure parameters and nr_args can be
>> added directly at the beginning, and using a flip flag
>> to identifiy structure parameters. Meantime, renaming
>> some variables to make them more sense.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> 
> Thanks for refactoring. Using nr_regs instead of nr_args indeed
> making things easier to understand. Ack with a few nits below.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> 
>> ---
>>   arch/x86/net/bpf_jit_comp.c | 99 +++++++++++++++++--------------------
>>   1 file changed, 46 insertions(+), 53 deletions(-)
>>
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index e3e2b57e4e13..e7b72299f5a4 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -1839,62 +1839,57 @@ st:            if (is_imm8(insn->off))
>>       return proglen;
>>   }
>> -static void save_regs(const struct btf_func_model *m, u8 **prog, int 
>> nr_args,
>> +static void save_regs(const struct btf_func_model *m, u8 **prog, int 
>> nr_regs,
>>                 int stack_size)
>>   {
>> -    int i, j, arg_size, nr_regs;
>> +    int i, j, arg_size;
>> +    bool is_struct = false;
>> +
>>       /* Store function arguments to stack.
>>        * For a function that accepts two pointers the sequence will be:
>>        * mov QWORD PTR [rbp-0x10],rdi
>>        * mov QWORD PTR [rbp-0x8],rsi
>>        */
>> -    for (i = 0, j = 0; i < min(nr_args, 6); i++) {
>> -        if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG) {
>> -            nr_regs = (m->arg_size[i] + 7) / 8;
>> +    for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
>> +        arg_size = m->arg_size[j];
>> +        if (arg_size > 8) {
>>               arg_size = 8;
>> -        } else {
>> -            nr_regs = 1;
>> -            arg_size = m->arg_size[i];
>> +            is_struct ^= 1;
>>           }
>> -        while (nr_regs) {
>> -            emit_stx(prog, bytes_to_bpf_size(arg_size),
>> -                 BPF_REG_FP,
>> -                 j == 5 ? X86_REG_R9 : BPF_REG_1 + j,
>> -                 -(stack_size - j * 8));
>> -            nr_regs--;
>> -            j++;
>> -        }
>> +        emit_stx(prog, bytes_to_bpf_size(arg_size),
>> +             BPF_REG_FP,
>> +             i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
>> +             -(stack_size - i * 8));
>> +
>> +        j = is_struct ? j : j + 1;
>>       }
>>   }
>> -static void restore_regs(const struct btf_func_model *m, u8 **prog, 
>> int nr_args,
>> +static void restore_regs(const struct btf_func_model *m, u8 **prog, 
>> int nr_regs,
>>                int stack_size)
>>   {
>> -    int i, j, arg_size, nr_regs;
>> +    int i, j, arg_size;
>> +    bool is_struct = false;
> 
> Maybe
>      bool next_same_struct = false
> to better characterize what it means?
> 

agree, will do as suggested bellow.

>>       /* Restore function arguments from stack.
>>        * For a function that accepts two pointers the sequence will be:
>>        * EMIT4(0x48, 0x8B, 0x7D, 0xF0); mov rdi,QWORD PTR [rbp-0x10]
>>        * EMIT4(0x48, 0x8B, 0x75, 0xF8); mov rsi,QWORD PTR [rbp-0x8]
>>        */
>> -    for (i = 0, j = 0; i < min(nr_args, 6); i++) {
>> -        if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG) {
>> -            nr_regs = (m->arg_size[i] + 7) / 8;
>> +    for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
> 
> Let us put a comment here so the later users can understand the logic
> behind 'is_struct ^= 1'.
> 
> /* The arg_size is at most 16 bytes, enforced by the verifier. */
> 
>> +        arg_size = m->arg_size[j];
>> +        if (arg_size > 8) {
>>               arg_size = 8;
>> -        } else {
>> -            nr_regs = 1;
>> -            arg_size = m->arg_size[i];
>> +            is_struct ^= 1;
> 
> next_same_struct = !next_same_struct;
> 
> The same for above save_regs().
> 
>>           }
>> -        while (nr_regs) {
>> -            emit_ldx(prog, bytes_to_bpf_size(arg_size),
>> -                 j == 5 ? X86_REG_R9 : BPF_REG_1 + j,
>> -                 BPF_REG_FP,
>> -                 -(stack_size - j * 8));
>> -            nr_regs--;
>> -            j++;
>> -        }
>> +        emit_ldx(prog, bytes_to_bpf_size(arg_size),
>> +             i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
>> +             BPF_REG_FP,
>> +             -(stack_size - i * 8));
>> +
>> +        j = is_struct ? j : j + 1;
>>       }
>>   }
> [...]

