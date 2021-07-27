Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27563D6C15
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 04:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhG0CKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 22:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhG0CKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 22:10:53 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BE5C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 19:51:17 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id y18so13503986oiv.3
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 19:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8hlT8YULz/udHP9aA6WQeMdyXPVu3rVmOKlnBogFVBk=;
        b=oarikdotjqNFyTu58c4dtZl+jDBY+/HoDxi2lUNVnHePWwPZ7gqwKy5MYxiK1ENmN5
         8XO1KsLLtl+xrFPVUUdGNi5jr8ArEIbUuKgTBYyYW6UmwxBPF7impxaLGXKEkC9cUPu6
         QBqOQXQ9If7rIENsMMWIuvjitAszn4mqYEim5m87NvNOHb2PKypCKw5WUQcYr8bIua3V
         8z9PVyRw0DsD5Hj/cNx9E0gj/EdqRlWi0k90Di8yj8e5l1NdbgQpwIl+g/Ufyr4A4EXW
         lFVzYkMiNlcW2xqQMFy1EdsUA4u2BCczuekgN8yOcd6Xco2Cd4cP8X66xDOV1AjyQHBS
         o2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8hlT8YULz/udHP9aA6WQeMdyXPVu3rVmOKlnBogFVBk=;
        b=gmDfGExn6GE/gM+ozjOnBGTHdf2p4j8yBxCpdp6pHWE2fCbPgj/ZnAiPnCFukLfGJC
         ZYrbi92TJHaNO30wbca+p796NgKDSh4OXxuErsNViZS/qV3Tg6FUvI9zQBnxj2FNbUT2
         pbREsPhaqZp6PmmJEyhuFfxJ1/vMU1MXkuP1Izso9pqyWXpyqS7CbqqprUy/1+23WbET
         Fc2ndDIRH+eUeuAIFK3rYKX0PwQVU5njOzYVR/gWSno4nm1rzbOirtVNuY9GjmyvBf7s
         wSB6NdGy5m+ldwIImr3sJ5o3oR5NKjF6hdOVWnlf/LVstxUuLRmEDVC4bTt/kjkSyqFF
         2mGA==
X-Gm-Message-State: AOAM5315hHIxE5QBPuufp5GTYmQ6DBlx32GOKJsmy+f6Po1Q1uJI2si3
        fUAdu0qgqqTfpjWKSRHn0kptUqti/ro=
X-Google-Smtp-Source: ABdhPJwvQDhJTpyj5Sl79zlNW1Ss9Fll+V3OqN+1RzXioOuhfb7jkEQjCYy4af2HB7pZP7Uze06mug==
X-Received: by 2002:aca:6109:: with SMTP id v9mr12969678oib.147.1627354276334;
        Mon, 26 Jul 2021 19:51:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id w207sm370728oie.42.2021.07.26.19.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 19:51:15 -0700 (PDT)
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>, Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20210705124307.201303-1-m@lambda.lt>
 <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <YPpIeppWpqFCSaqZ@Laptop-X1>
 <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com>
 <0cc404df-078a-686e-c5ce-8473c0e220f5@gmail.com>
 <CAEf4Bza3gMzfSQcv_QDzVP=vsCzxy=8DHwU-EVqOt8XagK7OHw@mail.gmail.com>
 <cce56767-efbe-e572-6290-111c6c845578@gmail.com>
 <CAEf4BzZHTuq8FhxyoQ-gksXspUqmocsEGyU2D5r6pFibOSSVMw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <69ee30ef-5bdb-9179-c6a4-f87502b14e31@gmail.com>
Date:   Mon, 26 Jul 2021 20:51:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZHTuq8FhxyoQ-gksXspUqmocsEGyU2D5r6pFibOSSVMw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/21 9:13 AM, Andrii Nakryiko wrote:
> On Mon, Jul 26, 2021 at 6:58 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 7/23/21 6:25 PM, Andrii Nakryiko wrote:
>>>>>>>> This is still problematic, because one section can have multiple BPF
>>>>>>>> programs. I.e., it's possible two define two or more XDP BPF programs
>>>>>>>> all with SEC("xdp") and libbpf works just fine with that. I suggest
>>>>>>>> moving users to specify the program name (i.e., C function name
>>>>>>>> representing the BPF program). All the xdp_mycustom_suffix namings are
>>>>>>>> a hack and will be rejected by libbpf 1.0, so it would be great to get
>>>>>>>> a head start on fixing this early on.
>>>>>>>
>>>>>>> Thanks for bringing this up. Currently, there is no way to specify a
>>>>>>> function name with "tc exec bpf" (only a section name via the "sec" arg). So
>>>>>>> probably, we should just add another arg to specify the function name.
>>>>>>
>>>>>> How about add a "prog" arg to load specified program name and mark
>>>>>> "sec" as not recommended? To keep backwards compatibility we just load the
>>>>>> first program in the section.
>>>>>
>>>>> Why not error out if there is more than one program with the same
>>>>> section name? if there is just one (and thus section name is still
>>>>> unique) -- then proceed. It seems much less confusing, IMO.
>>>>>
>>>>
>>>> Let' see if I understand this correctly: libbpf 1.0 is not going to
>>>> allow SEC("xdp_foo") or SEC("xdp_bar") kind of section names - which is
>>>> the hint for libbpf to know program type. Instead only SEC("xdp") is
>>>> allowed.
>>>
>>> Right.
>>>
>>>>
>>>> Further, a single object file is not going to be allowed to have
>>>> multiple SEC("xdp") instances for each program name.
>>>
>>> On the contrary. Libbpf already allows (and will keep allowing)
>>> multiple BPF programs with SEC("xdp") in a single object file. Which
>>> is why section_name is not a unique program identifier.
>>>
>>
>> Does that require BTF? My attempts at loading an object file with 2
>> SEC("xdp") programs failed. This is using bpftool from top of tree and
>> loadall.
> 
> You mean kernel BTF? Not if XDP programs themselves were built
> requiring CO-RE. So if those programs use #include "vmlinux.h", or
> there is BPF_CORE_READ() use somewhere in the code, or explicit
> __attribute__((preserve_access_index)) is used on some of the used
> structs, then yes, vmlinux BTF will be needed. But otherwise no. Do
> you have verbose error logs? I think with bpftool you can get them
> with -d argument.
> 

xdp_l3fwd is built using an old school compile line - no CO-RE or BTF,
just a basic compile line extracted from samples/bpf 2-3 years ago.
Works fine for what I need and take this nothing more than an example to
verify your comment

"Libbpf already allows (and will keep allowing) multiple BPF programs
with SEC("xdp") in a single object file."


The bpftool command line to load the programs is:

$ bpftool -ddd prog loadall xdp_l3fwd.o /sys/fs/bpf

It fails because libbpf is trying to put 2 programs at the same path:

libbpf: pinned program '/sys/fs/bpf/xdp'
libbpf: failed to pin program: File exists
libbpf: unpinned program '/sys/fs/bpf/xdp'
Error: failed to pin all programs

The code that works is this:

SEC("xdp_l3fwd")
int xdp_l3fwd_prog(struct xdp_md *ctx)
{
        return xdp_l3fwd_flags(ctx, 0);
}

SEC("xdp_l3fwd_direct")
int xdp_l3fwd_direct_prog(struct xdp_md *ctx)
{
        return xdp_l3fwd_flags(ctx, BPF_FIB_LOOKUP_DIRECT);
}

The code that fails is this:

SEC("xdp")
int xdp_l3fwd_prog(struct xdp_md *ctx)
{
        return xdp_l3fwd_flags(ctx, 0);
}

SEC("xdp")
int xdp_l3fwd_direct_prog(struct xdp_md *ctx)
{
        return xdp_l3fwd_flags(ctx, BPF_FIB_LOOKUP_DIRECT);
}

which is what you said should work -- 2 programs with the same section name.

From a very quick check of bpftool vs libbpf, the former is calling
bpf_object__pin_programs from the latter and passing the base path
(/sys/fs/bpf in this example) and then bpf_object__pin_programs adds the
pin_name for the prog - which must be the same for both programs since
the second one fails.

