Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5814F57806E
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiGRLKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiGRLKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:10:12 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7541F62C;
        Mon, 18 Jul 2022 04:10:05 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1D271320091B;
        Mon, 18 Jul 2022 07:10:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 18 Jul 2022 07:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1658142600; x=
        1658229000; bh=sHwq/Li6q7x+PDGIFv+evLt4wSOyZViEQf7oifqa30k=; b=x
        OyHFr2Wi6d6DuA/bwQYlXLNiSBUtND0UAReYSPkz6o3yrV1rnFnW3z4NdrweA+8S
        YfoZe9VDZfuR6iFwGOyyQA42i+PbeNh5pvR6+ZhJ+TJ9+d9X0jFEbaHQMkYKRbU2
        CEOwQHIIQ8zS8/U9Cu3kEFN+NsAXk2d+pzU0fNYWjOLETBW7p7vD/XEO7fVjbP35
        RHMtwb64Rz1HkMl3c4oW0kAwZPzfS1ZGE94N9dqqpT6fIEA2ra242NgEBMR1ZwAS
        24Tv5LKVCELybZjN9o3W0zhAWqSqMWTExXkrQR5qA3Zh6O0NWY+OEel6KD6+9HUP
        SGcSOotIMw/xpWrTzJZLQ==
X-ME-Sender: <xms:hz_VYrVdxlVu7KuYkzm5BLuwy7mLuk0owlGqMuFmlfe7_t0CtpFAuA>
    <xme:hz_VYjmgeF4BdsAKA1AtpePKUfbiDxyVIRLmweDVOk1UXKOGomGJHNe1kcwonFCLb
    YNhqSDZYMwvqocrKg8>
X-ME-Received: <xmr:hz_VYnbGO7OGn29Q_llT1jjafW0QGmdtnr1UWTn1FDzAHUOLK6AzGR8wgy0IIRjIqPVzgqVUG0dFNUXstL9i5Ou6lADV-fo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeforghr
    thihnhgrshcurfhumhhpuhhtihhsuceomheslhgrmhgsuggrrdhltheqnecuggftrfgrth
    htvghrnhepfeekgeeufeeuiedtteffjeetvdfhleelteekheehueethfevudehhedvveek
    udevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmh
    eslhgrmhgsuggrrdhlth
X-ME-Proxy: <xmx:iD_VYmXwbJKMXSg0soayuS1cTsPuZh1a7wGdOIZ3c7RkbnoSSpvzOw>
    <xmx:iD_VYlndvKf7IM1y2PQHqirE6ij9Ztj8IRGACGWP9cao0VBnBIQJjw>
    <xmx:iD_VYjfROtd6o_vUFcARqPyxZtvYutK7bR-X0R51OWR-7N-8uk2Uww>
    <xmx:iD_VYrefE8eEcX7eGZEvWoga2AvCsILNlr8WF-9Xm1fn89qOoL58sA>
Feedback-ID: i215944fb:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 07:09:57 -0400 (EDT)
Message-ID: <f6b5dc36-3dbb-433d-01d2-aad8959d0546@lambda.lt>
Date:   Mon, 18 Jul 2022 14:09:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC bpf-next 4/4] selftests/bpf: Fix kprobe get_func_ip
 tests for CONFIG_X86_KERNEL_IBT
Content-Language: en-US
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Yutaro Hayakawa <yutaro.hayakawa@isovalent.com>
References: <20220705190308.1063813-1-jolsa@kernel.org>
 <20220705190308.1063813-5-jolsa@kernel.org>
 <CAEf4BzapX_C16O9woDSXOpbzVsxjYudXW36woRCqU3u75uYiFA@mail.gmail.com>
 <YsdbQ4vJheLWOa0a@krava> <YtSCbIA+6JtRF/Ch@krava>
From:   Martynas Pumputis <m@lambda.lt>
In-Reply-To: <YtSCbIA+6JtRF/Ch@krava>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/22 00:43, Jiri Olsa wrote:
> On Fri, Jul 08, 2022 at 12:16:35AM +0200, Jiri Olsa wrote:
>> On Tue, Jul 05, 2022 at 10:29:17PM -0700, Andrii Nakryiko wrote:
>>> On Tue, Jul 5, 2022 at 12:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
>>>>
>>>> The kprobe can be placed anywhere and user must be aware
>>>> of the underlying instructions. Therefore fixing just
>>>> the bpf program to 'fix' the address to match the actual
>>>> function address when CONFIG_X86_KERNEL_IBT is enabled.
>>>>
>>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>>> ---
>>>>   tools/testing/selftests/bpf/progs/get_func_ip_test.c | 7 +++++--
>>>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
>>>> index a587aeca5ae0..220d56b7c1dc 100644
>>>> --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
>>>> +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
>>>> @@ -2,6 +2,7 @@
>>>>   #include <linux/bpf.h>
>>>>   #include <bpf/bpf_helpers.h>
>>>>   #include <bpf/bpf_tracing.h>
>>>> +#include <stdbool.h>
>>>>
>>>>   char _license[] SEC("license") = "GPL";
>>>>
>>>> @@ -13,6 +14,8 @@ extern const void bpf_modify_return_test __ksym;
>>>>   extern const void bpf_fentry_test6 __ksym;
>>>>   extern const void bpf_fentry_test7 __ksym;
>>>>
>>>> +extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak;
>>>> +
>>>>   __u64 test1_result = 0;
>>>>   SEC("fentry/bpf_fentry_test1")
>>>>   int BPF_PROG(test1, int a)
>>>> @@ -37,7 +40,7 @@ __u64 test3_result = 0;
>>>>   SEC("kprobe/bpf_fentry_test3")
>>>>   int test3(struct pt_regs *ctx)
>>>>   {
>>>> -       __u64 addr = bpf_get_func_ip(ctx);
>>>> +       __u64 addr = bpf_get_func_ip(ctx) - (CONFIG_X86_KERNEL_IBT ? 4 : 0);
>>>
>>> so for kprobe bpf_get_func_ip() gets an address with 5 byte
>>> compensation for `call __fentry__`, but not for endr? Why can't we
>>> compensate for endbr inside the kernel code as well? I'd imagine we
>>> either do no compensation (and thus we get &bpf_fentry_test3+5 or
>>> &bpf_fentry_test3+9, depending on CONFIG_X86_KERNEL_IBT) or full
>>> compensation (and thus always get &bpf_fentry_test3), but this
>>> in-between solution seems to be the worst of both worlds?...
>>
>> hm rigth, I guess we should be able to do that in bpf_get_func_ip,
>> I'll check
> 
> sorry for late follow up..
> 
> so the problem is that you can place kprobe anywhere in the function
> (on instruction boundary) but the IBT adjustment of kprobe address is
> made only if it's at the function entry and there's endbr instruction

To add more fun to the issue, not all non-inlined functions get endbr64. 
For example "skb_release_head_state()" does, while "skb_free_head()" 
doesn't.

> 
> and that kprobe address is what we return in helper:
> 
>    BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
>    {
>          struct kprobe *kp = kprobe_running();
> 
>          return kp ? (uintptr_t)kp->addr : 0;
>    }
> 
> so the adjustment would work only for address at function entry, but
> would be wrong for address within the function
> 
> perhaps we could add flag to kprobe to indicate the addr adjustment
> was done and use it in helper
> 
> but that's why I thought I'd keep bpf_get_func_ip_kprobe as it and
> leave it up to user
> 
> kprobe_multi and trampolines are different, because they can be
> only at the function entry, so we can adjust the ip properly
> 
> jirka
