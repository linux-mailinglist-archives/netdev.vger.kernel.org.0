Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76660403943
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 13:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351582AbhIHL7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 07:59:41 -0400
Received: from mail.loongson.cn ([114.242.206.163]:34908 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348327AbhIHL7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 07:59:39 -0400
Received: from [192.168.68.106] (unknown [111.19.45.122])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxb2tApThhHbEBAA--.1214S3;
        Wed, 08 Sep 2021 19:57:57 +0800 (CST)
Subject: Re: [RFC PATCH bpf-next] bpf: Make actual max tail call count as
 MAX_TAIL_CALL_CNT
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, bjorn@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Paul Chaignon <paul@cilium.io>
References: <1631089206-5931-1-git-send-email-yangtiezhu@loongson.cn>
 <e05e7407-74bb-3ba3-aab7-f62ca16a59ba@iogearbox.net>
 <9d0ca1ba-b8e1-dc99-17f4-189571f33c97@loongson.cn>
 <CAM1=_QR7jEKWCta6krttm9dTdXAa8HpDcp+eV5ufiUMbJ9SivA@mail.gmail.com>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <8e8d4bb7-0032-4b71-4411-4c95ed32b393@loongson.cn>
Date:   Wed, 8 Sep 2021 19:57:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAM1=_QR7jEKWCta6krttm9dTdXAa8HpDcp+eV5ufiUMbJ9SivA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: AQAAf9Dxb2tApThhHbEBAA--.1214S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1fZr47JFW3Zr17Kw4kZwb_yoWruryDpr
        WxWay5Kr4kXFySyFnFgw1xZa4Fyas5Jr98WF1rJrWIya90vF15KF1Ikr48uFnI9r1kWFyj
        va1vgr9rCa1DAFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvGb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY
        jI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjxUqRBTDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/21 7:36 PM, Johan Almbladh wrote:
> On Wed, Sep 8, 2021 at 12:56 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>> On 09/08/2021 04:47 PM, Daniel Borkmann wrote:
>>> [ You have a huge Cc list, but forgot to add Paul and Johan who recently
>>>    looked into this. Added here. ]
>>>
>>> On 9/8/21 10:20 AM, Tiezhu Yang wrote:
>>>> In the current code, the actual max tail call count is 33 which is
>>>> greater
>>>> than MAX_TAIL_CALL_CNT, this is not consistent with the intended meaning
>>>> in the commit 04fd61ab36ec ("bpf: allow bpf programs to tail-call other
>>>> bpf programs"):
>>>>
>>>> "The chain of tail calls can form unpredictable dynamic loops therefore
>>>> tail_call_cnt is used to limit the number of calls and currently is set
>>>> to 32."
>>>>
>>>> Additionally, after commit 874be05f525e ("bpf, tests: Add tail call test
>>>> suite"), we can see there exists failed testcase.
>>>>
>>>> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
>>>>    # echo 0 > /proc/sys/net/core/bpf_jit_enable
>>>>    # modprobe test_bpf
>>>>    # dmesg | grep -w FAIL
>>>>    Tail call error path, max count reached jited:0 ret 34 != 33 FAIL
>>>>
>>>> On some archs:
>>>>    # echo 1 > /proc/sys/net/core/bpf_jit_enable
>>>>    # modprobe test_bpf
>>>>    # dmesg | grep -w FAIL
>>>>    Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
>>>>
>>>> with this patch, make the actual max tail call count as
>>>> MAX_TAIL_CALL_CNT,
>>>> at the same time, the above failed testcase can be fixed.
>>>>
>>>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>>>> ---
>>>>
>>>> Hi all,
>>>>
>>>> This is a RFC patch, if I am wrong or I missed something,
>>>> please let me know, thank you!
>>> Yes, the original commit from 04fd61ab36ec ("bpf: allow bpf programs
>>> to tail-call
>>> other bpf programs") got the counting wrong, but please also check
>>> f9dabe016b63
>>> ("bpf: Undo off-by-one in interpreter tail call count limit") where we
>>> agreed to
>>> align everything to 33 in order to avoid changing existing behavior,
>>> and if we
>>> intend to ever change the count, then only in terms of increasing but
>>> not decreasing
>>> since that ship has sailed.
>> Thank you, understood.
>>
>> But I still think there is some confusion about the macro MAX_TAIL_CALL_CNT
>> which is 32 and the actual value 33, I spent some time to understand it
>> at the first glance.
>>
>> Is it impossible to keep the actual max tail call count consistent with
>> the value 32 of MAX_TAIL_CALL_CNT now?
> Yes. If the limit is 32 or 33 does not really matter, but there has to
> be a limit. Since the actual limit has been 33, we don't want to break
> any user space program relying on this value.


OK, I see, it is very clear now, thank you.

Since the actual limit is 33 now, can we change the value of
MAX_TAIL_CALL_CNT from 32 to 33 and then do some small changes
of the related code?

It will not change the current status but make the actual max
tail call count consistent with the value of MAX_TAIL_CALL_CNT.

If it is OK, I will send a patch later.

Thanks,
Tiezhu


>
>> At least, maybe we need to modify the testcase?
> Before making any changes in the test or the BPF code, we need to
> understand what the current behaviour actually is. Then we can make
> the necessary changes to make everything consistent with 33.
>
>>> Tiezhu, do you still see any arch that is not on 33
>>> from your testing?
>> If the testcase "Tail call error path, max count reached" in test_bpf is
>> right,
>> it seems that the tail call count limit is 32 on x86, because the testcase
>> passed on x86 jited.
> When I run the test_bpf.ko suite I get the following limits.
>
> Interpreter: 33
> JIT for arm{32,64}, mips, s390x, powerpc{32,64}, sparc: 33
> JIT for x86-{32,64}: 32
>
> However, there are also tail call tests in the selftests suite.
> According to Paul those tests show that everything is consistent with
> 33 now. So, there seem to be a discrepancy between the test_bpf.ko
> tests and the selftests.
>
> I am trying to investigate this matter further, but so far I have only
> been able to run the test_bpf.ko module for various archs in QEMU.
> Link: https://github.com/almbladh/test-linux
>
> I am currently working on getting the selftests to run in QEMU too,
> using Buildroot. If you have a working setup for this, it would be
> great if you could share that.
>
> Thanks,
> Johan
>
>>> Last time Paul fixed the remaining ones in 96bc4432f5ad ("bpf,
>>> riscv: Limit to 33 tail calls") and e49e6f6db04e ("bpf, mips: Limit to
>>> 33 tail calls").
>>>
>>> Thanks,
>>> Daniel

