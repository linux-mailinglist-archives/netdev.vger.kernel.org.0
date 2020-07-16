Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91E2221AC
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgGPLsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGPLsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:48:13 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CA5C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 04:48:13 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id d17so6823932ljl.3
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 04:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=/GvE5mLubde7FdkABAeWnyMsWpw4xjTaM1e3k7MWqIA=;
        b=jg7ezTaJ0octejEhVxfpChAgTaEQI6MYYALNlnfRCxmAkRsEg6EMtaFNCKAX4GM8+J
         biXYT+/h29AZtBgXvf2R572PzXzkhsFxo/Fs3nKykp4dsekjR+Yc1LPDKNKw7OGjGbkX
         zwUROrUeShTrB27hdQsclp3ww/Slcm2l3wsCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=/GvE5mLubde7FdkABAeWnyMsWpw4xjTaM1e3k7MWqIA=;
        b=o7tNrRALJiU/uQWbwePMjIGB6AXWx96mKv2Du/qPJW3bBfUsCwuwjicjQ8X8zqOtsJ
         s944fH5VIJ3RKDxanx2rjhOK9rZVHm7e+BLD5Beexo90ePQq+qBH+iYPsVmQ0BwvOyJN
         9IVVBCZZtI9k/CU8VXywIxJlmvinUAPq4pEZcjomuTixjfvebtaEj4PW8saBB3mEgWPp
         DS2S5fif2OIU2HuQD1kz8XykFH8WFqT4j+Ldnnq4z2UPKRGPuwEWeu7mA3Y4W5g2BqA7
         C/yjOdQAjH0SNiAC6npFPVzdVk9ZGaptx3asOp01a7hrNc86C9akl5Npb1UMNQ9/9scK
         nenw==
X-Gm-Message-State: AOAM532MnVGMjIHAXQmWKP9Wy4fkGpzdW2Y+hXjyF6gCJyUluQNTI2Td
        rBOzqyxS/AdV7tIx9uFyiYOeicmnjU+zeg==
X-Google-Smtp-Source: ABdhPJxVQNiZterynrx2heHWJx0H3l7YAy9VRzzb1g5CjHd3YIGbnALJxgXOhIhiLFfYFwbDZlFTrw==
X-Received: by 2002:a2e:9ac4:: with SMTP id p4mr1929744ljj.143.1594900091536;
        Thu, 16 Jul 2020 04:48:11 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d22sm340396lfs.26.2020.07.16.04.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 04:48:10 -0700 (PDT)
References: <20200710173123.427983-1-jakub@cloudflare.com> <c98aaa5e-9347-c23f-cfa6-e267f2485c5b@fb.com> <87a700y3yb.fsf@cloudflare.com> <7c27726c-9bba-8d7c-55b4-69d7af287382@fb.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] bpf: Shift and mask loads narrower than context field size
In-reply-to: <7c27726c-9bba-8d7c-55b4-69d7af287382@fb.com>
Date:   Thu, 16 Jul 2020 13:48:09 +0200
Message-ID: <878sfjy93a.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 10:59 PM CEST, Yonghong Song wrote:
> On 7/15/20 12:26 PM, Jakub Sitnicki wrote:
>> On Wed, Jul 15, 2020 at 08:44 AM CEST, Yonghong Song wrote:
>>> On 7/10/20 10:31 AM, Jakub Sitnicki wrote:

[...]

>>>> The "size < target_size" check is left in place to cover the case when a
>>>> context field is narrower than its target field, even if we might not have
>>>> such case now. (It would have to be a u32 context field backed by a u64
>>>> target field, with context fields all being 4-bytes or wider.)
>>>>
>>>> Going back to the example, with the fix in place, the upper half load from
>>>> ctx->ip_protocol yields zero:
>>>>
>>>>     int reuseport_narrow_half(struct sk_reuseport_md * ctx):
>>>>     ; int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>>>>        0: (b4) w0 = 0
>>>>     ; if (half[0] == 0xaaaa)
>>>>        1: (79) r2 = *(u64 *)(r1 +8)
>>>>        2: (69) r2 = *(u16 *)(r2 +924)
>>>>        3: (54) w2 &= 65535
>>>>     ; if (half[0] == 0xaaaa)
>>>>        4: (16) if w2 == 0xaaaa goto pc+7
>>>>     ; if (half[1] == 0xbbbb)
>>>>        5: (79) r1 = *(u64 *)(r1 +8)
>>>>        6: (69) r1 = *(u16 *)(r1 +924)
>>>
>>> The load is still from offset 0, 2 bytes with upper 48 bits as 0.
>>
>> Yes, this is how narrow loads currently work, right? It is not specific
>> to the case I'm fixing.
>>
>> To give an example - if you do a 1-byte load at offset 1, it will load
>> the value from offset 0, and shift it right by 1 byte. So it is expected
>> that the load is always from offset 0 with current implementation.
>
> Yes, the load is always from offset 0. The confusion part is
> it load offset 0 with 2 bytes and then right shifting 2 bytes
> to get 0...

Right, I see how silly is the generated instruction sequence. I guess
I've accepted how <prog_type>_convert_ctx_access functions emit loads
and didn't stop and question this part before.

>> SEC("sk_reuseport/narrow_byte")
>> int reuseport_narrow_byte(struct sk_reuseport_md *ctx)
>> {
>> 	__u8 *byte;
>>
>> 	byte = (__u8 *)&ctx->ip_protocol;
>> 	if (byte[0] == 0xaa)
>> 		return SK_DROP;
>> 	if (byte[1] == 0xbb)
>> 		return SK_DROP;
>> 	if (byte[2] == 0xcc)
>> 		return SK_DROP;
>> 	if (byte[3] == 0xdd)
>> 		return SK_DROP;
>> 	return SK_PASS;
>> }
>>
>> int reuseport_narrow_byte(struct sk_reuseport_md * ctx):
>> ; int reuseport_narrow_byte(struct sk_reuseport_md *ctx)
>>     0: (b4) w0 = 0
>> ; if (byte[0] == 0xaa)
>>     1: (79) r2 = *(u64 *)(r1 +8)
>>     2: (69) r2 = *(u16 *)(r2 +924)
>>     3: (54) w2 &= 255
>> ; if (byte[0] == 0xaa)
>>     4: (16) if w2 == 0xaa goto pc+17
>> ; if (byte[1] == 0xbb)
>>     5: (79) r2 = *(u64 *)(r1 +8)
>>     6: (69) r2 = *(u16 *)(r2 +924)
>>     7: (74) w2 >>= 8
>>     8: (54) w2 &= 255
>> ; if (byte[1] == 0xbb)
>>     9: (16) if w2 == 0xbb goto pc+12
>> ; if (byte[2] == 0xcc)
>>    10: (79) r2 = *(u64 *)(r1 +8)
>>    11: (69) r2 = *(u16 *)(r2 +924)
>>    12: (74) w2 >>= 16
>>    13: (54) w2 &= 255
>> ; if (byte[2] == 0xcc)
>>    14: (16) if w2 == 0xcc goto pc+7
>> ; if (byte[3] == 0xdd)
>>    15: (79) r1 = *(u64 *)(r1 +8)
>>    16: (69) r1 = *(u16 *)(r1 +924)
>>    17: (74) w1 >>= 24
>>    18: (54) w1 &= 255
>>    19: (b4) w0 = 1
>> ; if (byte[3] == 0xdd)
>>    20: (56) if w1 != 0xdd goto pc+1
>>    21: (b4) w0 = 0
>> ; }
>>    22: (95) exit
>>
>>>
>>>>        7: (74) w1 >>= 16
>>>
>>> w1 will be 0 now. so this will work.
>>>
>>>>        8: (54) w1 &= 65535
>>>
>>> For the above insns 5-8, verifier, based on target information can
>>> directly generate w1 = 0 since:
>>>    . target kernel field size is 2, ctx field size is 4.
>>>    . user tries to access offset 2 size 2.
>>>
>>> Here, we need to decide whether we permits user to do partial read beyond of
>>> kernel narrow field or not (e.g., this example)? I would
>>> say yes, but Daniel or Alexei can provide additional comments.
>>>
>>> If we allow such accesses, I would like verifier to generate better
>>> code as I illustrated in the above. This can be implemented in
>>> verifier itself with target passing additional kernel field size
>>> to the verifier. The target already passed the ctx field size back
>>> to the verifier.
>>
>> Keep in mind that the BPF user is writing their code under the
>> assumption that the context field has 4 bytes. IMHO it's reasonable to
>> expect that I can load 2 bytes at offset of 2 from a 4 byte field.
>>
>> Restricting it now to loads below the target field size, which is
>> unknown to the user, would mean rejecting programs that are working
>> today. Even if they are getting funny values.
>>
>> I think implementing what you suggest is doable without major
>> changes. We have load size, target field size, and context field size at
>> hand in convert_ctx_accesses(), so it seems like a matter of adding an
>> 'if' branch to handle better the case when we know the end result must
>> be 0. I'll give it a try.
>
> Sounds good. The target_size is returned in convert_ctx_access(), which
> is too late as the verifier already generated load instructions. You need to get
> it earlier in is_valid_access().

I have a feeling that I'm not following what you have in mind.

True, target_size is only known after convert_ctx_access generated
instructions. At this point, if we want to optimize the narrow loads
that must return 0, we can pop however many instructions
convert_ctx_access appended to insn_buf and emit BPF_MOV32/64_IMM.

However, it sounds a bit more complex than what I hoped for initially,
so I'm starting to doubt the value. Considering that narrow loads at an
offset that matches or exceeds target field size must be a corner case,
if the current "broken" behavior went unnoticed so far.

I'll need to play with the code and see how it turns out. But for the
moment please consider acking/nacking this one, as a simple way to fix
the issue targeted at 'bpf' branch and stable kernels.

>
>>
>> But I do want to empahsize that I still think the fix in current form is
>> correct, or at least not worse than what we have already in place narrow
>> loads.
>
> I did agree that the fix in this patch is correct. It is just that we
> could do better to fix this problem.

I agree with your sentiment. Sorry if I got too defensive there.

>
>>
>>>
>>>>        9: (b4) w0 = 1
>>>>     ; if (half[1] == 0xbbbb)
>>>>       10: (56) if w1 != 0xbbbb goto pc+1
>>>>       11: (b4) w0 = 0
>>>>     ; }
>>>>       12: (95) exit
>>>>
>>>> Fixes: f96da09473b5 ("bpf: simplify narrower ctx access")
>>>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>>>> ---
>>>>    kernel/bpf/verifier.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>> index 94cead5a43e5..1c4d0e24a5a2 100644
>>>> --- a/kernel/bpf/verifier.c
>>>> +++ b/kernel/bpf/verifier.c
>>>> @@ -9760,7 +9760,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>>>    			return -EINVAL;
>>>>    		}
>>>>    -		if (is_narrower_load && size < target_size) {
>>>> +		if (is_narrower_load || size < target_size) {
>>>>    			u8 shift = bpf_ctx_narrow_access_offset(
>>>>    				off, size, size_default) * 8;
>>>>    			if (ctx_field_size <= 4) {
>>>>
