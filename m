Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7602361EEB3
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiKGJWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiKGJWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:22:10 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCE217062;
        Mon,  7 Nov 2022 01:22:08 -0800 (PST)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N5Qf34bQkzJnWR;
        Mon,  7 Nov 2022 17:19:07 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:22:06 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:22:05 +0800
Subject: Re: [PATCH bpf RESEND 2/4] bpf: Remove size check for sk in
 bpf_skb_is_valid_access for 32-bit architecture
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>,
        Artem Savkov <asavkov@redhat.com>, bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20221103092118.248600-1-yangjihong1@huawei.com>
 <20221103092118.248600-3-yangjihong1@huawei.com>
 <Y2OknBtLgqTHSrvy@shell.armlinux.org.uk>
 <CAADnVQ+gX8Xc57K2hSG5ZNfU1RtKBFgEp2yOWq08X68bWjMqsg@mail.gmail.com>
 <CAEf4BzaJMfCXf_uUgyuWBddyd3qrV7SgpVy-hicuOn87FigMSg@mail.gmail.com>
 <CAADnVQJAp4=ouSTn2UM=N-EHvO=v2RMVN1dH8erkyMU9ZF1QCA@mail.gmail.com>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <dd998453-1baf-272a-8130-76529d338f2f@huawei.com>
Date:   Mon, 7 Nov 2022 17:22:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQJAp4=ouSTn2UM=N-EHvO=v2RMVN1dH8erkyMU9ZF1QCA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 2022/11/5 7:37, Alexei Starovoitov wrote:
> On Fri, Nov 4, 2022 at 3:43 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Thu, Nov 3, 2022 at 11:15 AM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>>
>>> On Thu, Nov 3, 2022 at 4:23 AM Russell King (Oracle)
>>> <linux@armlinux.org.uk> wrote:
>>>>
>>>> On Thu, Nov 03, 2022 at 05:21:16PM +0800, Yang Jihong wrote:
>>>>> The error code -EACCES is returned when bpf prog is tested in 32-bit environment,
>>>>> This is because bpf_object__relocate modifies the instruction to change memory
>>>>> size to 4 bytes, as shown in the following messages:
>>>>>
>>>>> libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
>>>>> libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
>>>>> libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4
>>>>>
>>>>> As a result, the bpf_skb_is_valid_access check fails. For 32-bit architecture,
>>>>> unnecessary checks need to be deleted.
>>>>
>>>> Isn't the purpose of this check to ensure that the entire pointer is
>>>> written, and BPF can't write half of it?
>>>>
>>>>
>>>>>        case offsetof(struct __sk_buff, sk):
>>>>> -             if (type == BPF_WRITE || size != sizeof(__u64))
>>>>> -                     return false;
>>>>
>>>> Wouldn't "(size != sizeof(struct bpf_sock *) && size != sizeof(__u64))"
>>>> be more appropriate here, so 32-bit can only write the 32-bit pointer
>>>> or the full 64-bit value, and 64-bit can only write the 64-bit pointer?
>>>> Or is there a reason not to? bpf folk?
>>>
>>> You're correct. The patch is completely wrong.
>>> The bug is elsewhere.
>>
>> So I looked at this a bit (and replied to the old version of this
>> patch). What happens in the kernel is that we expect 64-bit load but
>> rewrite it to 32-bit load on 32-bit architectures (because we just use
>> sizeof(struct sk_buff, sk) which is 4 bytes on 32-bit arch.
>>
>> The problem here is that libbpf adjusts such pointer accesses from
>> 8-byte read to 4-byte reads for preserve_access_index (because libbpf
>> sees that pointer is really 4 byte long), which is what we actually
>> want in the general case. Here the assumption was made before CO-RE
>> that __sk_buff is a stable (and fake) UAPI and the correct BPF program
>> will access sk as a 64-bit pointer because BPF-side pointers always
>> appear as 64-bit.
>>
>> But from a correctness standpoint I think it should be fine to enable
>> both 32- and 64-bit loads for such pointers in __sk_buff for 32-bit
>> host arch. This will work well with CO-RE and will be correctly
>> rewritten to 32-bit or 64-bit accesses, depending on host
>> architecture.
>>
>> We should still reject 32-bit load on 64-bit host arch, though.
> 
> Replied in the other thread as well :)
> The CO_RE screws up access here.
> Since it's a load of a pointer the verifier has to see it as a 8-byte load.
> When CO-RE converts it to 4 byte the verifier won't recognize it
> as a pointer load anymore.
> We cannot easily convert 64-bit BPF ISA into 32-bit.
> It's a massive amount of work.
> .

 From the above discussion, there are two different solutions:
1. Modify bpf_skb_is_valid_access to ensure that 32-bit can only load 
the 32-bit pointer or the full 64-bit value, and 64-bit can only load 
the 64-bit pointer
2. Modify libbpf, CO_RE skips adjust load's mem size and retains the 
8-byte load.
The two fixes will be added in the next version.
Please review the solution to be selected.

Thanks,
Yang
