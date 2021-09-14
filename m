Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F6140AE4E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhINM4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:56:33 -0400
Received: from mail.loongson.cn ([114.242.206.163]:46926 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232664AbhINM4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:56:32 -0400
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9CxNOakm0BhApwGAA--.20312S3;
        Tue, 14 Sep 2021 20:55:02 +0800 (CST)
Subject: Re: [PATCH bpf v4 13/14] bpf/tests: Fix error in tail call limit
 tests
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
References: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
 <20210914091842.4186267-14-johan.almbladh@anyfinetworks.com>
 <4b9db215-edcd-6089-6ecd-6fe9b20dcbbb@loongson.cn>
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, netdev@vger.kernel.org, bpf@vger.kernel.org
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <8e2404d6-f226-3749-2e35-5519b2c90754@loongson.cn>
Date:   Tue, 14 Sep 2021 20:55:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <4b9db215-edcd-6089-6ecd-6fe9b20dcbbb@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9CxNOakm0BhApwGAA--.20312S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW5ury3CFykuryktrWDJwb_yoW8KF4xpa
        4xJ3ZxKFW8JFySqanIgFW0gw1furZYyryUCr4ayryayFs5Aw1kGFy8Kr18uryav3yF9F4I
        vrsYywn8C3WkJrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9lb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
        c7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Xr1l42xK82IYc2Ij64vIr41l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
        GVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
        0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
        rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r
        4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUgX_TUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/14/2021 08:41 PM, Tiezhu Yang wrote:
> On 09/14/2021 05:18 PM, Johan Almbladh wrote:
>> This patch fixes an error in the tail call limit test that caused the
>> test to fail on for x86-64 JIT. Previously, the register R0 was used to
>> report the total number of tail calls made. However, after a tail call
>> fall-through, the value of the R0 register is undefined. Now, all tail
>> call error path tests instead use context state to store the count.
>>
>> Fixes: 874be05f525e ("bpf, tests: Add tail call test suite")
>> Reported-by: Paul Chaignon <paul@cilium.io>
>> Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
>> ---
>>   lib/test_bpf.c | 37 +++++++++++++++++++++++++++----------
>>   1 file changed, 27 insertions(+), 10 deletions(-)
>>
>> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
>> index 7475abfd2186..ddb9a8089d2e 100644
>> --- a/lib/test_bpf.c
>> +++ b/lib/test_bpf.c
>> @@ -12179,10 +12179,15 @@ static __init int test_bpf(void)
>>   struct tail_call_test {
>>       const char *descr;
>>       struct bpf_insn insns[MAX_INSNS];
>> +    int flags;
>>       int result;
>>       int stack_depth;
>>   };
>>   +/* Flags that can be passed to tail call test cases */
>> +#define FLAG_NEED_STATE        BIT(0)
>> +#define FLAG_RESULT_IN_STATE    BIT(1)
>> +
>>   /*
>>    * Magic marker used in test snippets for tail calls below.
>>    * BPF_LD/MOV to R2 and R2 with this immediate value is replaced
>> @@ -12252,32 +12257,38 @@ static struct tail_call_test 
>> tail_call_tests[] = {
>>       {
>>           "Tail call error path, max count reached",
>>           .insns = {
>> -            BPF_ALU64_IMM(BPF_ADD, R1, 1),
>> -            BPF_ALU64_REG(BPF_MOV, R0, R1),
>> +            BPF_LDX_MEM(BPF_W, R2, R1, 0),
>> +            BPF_ALU64_IMM(BPF_ADD, R2, 1),
>> +            BPF_STX_MEM(BPF_W, R1, R2, 0),
>>               TAIL_CALL(0),
>>               BPF_EXIT_INSN(),
>>           },
>> -        .result = MAX_TAIL_CALL_CNT + 1,
>> +        .flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
>> +        .result = (MAX_TAIL_CALL_CNT + 1 + 1) * MAX_TESTRUNS,
>
> Hi Johan,
>
> I have tested this patch,
> It should be "MAX_TAIL_CALL_CNT + 1" instead of "MAX_TAIL_CALL_CNT + 1 
> + 1"?

Oh, sorry, it is right when MAX_TAIL_CALL_CNT is 32,
I have tested it based on MAX_TAIL_CALL_CNT is 33,
so I need to modify here if MAX_TAIL_CALL_CNT is 33 in my v3 patch.

Tested-by: Tiezhu Yang <yangtiezhu@loongson.cn>

>
> [...]
>
> Thanks,
> Tiezhu

