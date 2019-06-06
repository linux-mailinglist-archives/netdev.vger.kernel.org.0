Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6859537F4F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfFFVO5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 17:14:57 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45214 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfFFVO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:14:56 -0400
Received: by mail-ed1-f68.google.com with SMTP id f20so5275359edt.12
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=uy658wQ8dtPti7I5yBTW++T94AdIdQl/H8Hlo7l9i/k=;
        b=GeZmtgUXCKuPE8hF/b52WHOddLY4cb0OiD9vtOVHx9KXjNrEQW+Q3+4qCa6LwImA0e
         HNAsAso6abcx6Yr3p8KroE8xtjl3bD/557hH8uB4GwjW+D2QiKSWSXvJ3r+MFyT3r/Y7
         vgGlK/0H5SFwImfUh/7uwi/7QsgT/qADdQ0lTXzFaAtyy4SkPc7PeWBHOtXR2ngUyQm1
         tZLWLw+Mb9+pxtdtufoTBTE9Z44Z0ZP1OZXV5ee5HWAhyZXWduOaMGjoGV1kaw5o0kr7
         le5ku7UJEQ68HY7lzDq5nxGECiMDhYGa43pAFNPAMAtQhOhm8+b8cJq4kiHc82soV4uE
         R1cA==
X-Gm-Message-State: APjAAAWf54YDX/WYQWFsLMha/b+b1JTRGSXjn116rAxRWqlw8/iSBpp1
        XNeq93nwYgi+6mqp33Zdps7ynQ==
X-Google-Smtp-Source: APXvYqwz0ARYXhNTtguH3twfZu0oAhWfqX07iz79wsR1wL0o73qe6GWcZ0sqgdj8/ULgvmxAj73dXg==
X-Received: by 2002:a17:906:fac5:: with SMTP id lu5mr19441466ejb.295.1559855693856;
        Thu, 06 Jun 2019 14:14:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b10sm29842ejb.30.2019.06.06.14.14.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 14:14:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 90184181CC1; Thu,  6 Jun 2019 23:14:52 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net-next v2 1/2] bpf_xdp_redirect_map: Add flag to return XDP_PASS on map lookup failure
In-Reply-To: <2319D5A1-22D6-409F-9570-6A135DB026E0@gmail.com>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1> <155982745460.30088.2745998912845128889.stgit@alrua-x1> <400a6093-6e9c-a1b4-0594-5b74b20a3d6b@iogearbox.net> <CAADnVQKZG6nOZUvqzvxz5xjZZLieQB4DvbkP=AjDF25FQB8Jfg@mail.gmail.com> <877e9yd70i.fsf@toke.dk> <9EC7B894-B076-46FA-BD2B-FFE12E55722B@gmail.com> <709e80ae-a08a-f00e-8f42-50289495d0de@iogearbox.net> <2319D5A1-22D6-409F-9570-6A135DB026E0@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 06 Jun 2019 23:14:52 +0200
Message-ID: <87sgsmbelv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Lemon <jonathan.lemon@gmail.com> writes:

> On 6 Jun 2019, at 12:24, Daniel Borkmann wrote:
>
>> On 06/06/2019 08:15 PM, Jonathan Lemon wrote:
>>> On 6 Jun 2019, at 9:15, Toke Høiland-Jørgensen wrote:
>>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>>>> On Thu, Jun 6, 2019 at 8:51 AM Daniel Borkmann 
>>>>> <daniel@iogearbox.net> wrote:
>>>>>> On 06/06/2019 03:24 PM, Toke Høiland-Jørgensen wrote:
>>>>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>>
>>>>>>> The bpf_redirect_map() helper used by XDP programs doesn't return 
>>>>>>> any
>>>>>>> indication of whether it can successfully redirect to the map 
>>>>>>> index it was
>>>>>>> given. Instead, BPF programs have to track this themselves, 
>>>>>>> leading to
>>>>>>> programs using duplicate maps to track which entries are 
>>>>>>> populated in the
>>>>>>> devmap.
>>>>>>>
>>>>>>> This patch adds a flag to the XDP version of the 
>>>>>>> bpf_redirect_map() helper,
>>>>>>> which makes the helper do a lookup in the map when called, and 
>>>>>>> return
>>>>>>> XDP_PASS if there is no value at the provided index.
>>>>>>>
>>>>>>> With this, a BPF program can check the return code from the 
>>>>>>> helper call and
>>>>>>> react if it is XDP_PASS (by, for instance, substituting a 
>>>>>>> different
>>>>>>> redirect). This works for any type of map used for redirect.
>>>>>>>
>>>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>> ---
>>>>>>>  include/uapi/linux/bpf.h |    8 ++++++++
>>>>>>>  net/core/filter.c        |   10 +++++++++-
>>>>>>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>>>> index 7c6aef253173..d57df4f0b837 100644
>>>>>>> --- a/include/uapi/linux/bpf.h
>>>>>>> +++ b/include/uapi/linux/bpf.h
>>>>>>> @@ -3098,6 +3098,14 @@ enum xdp_action {
>>>>>>>       XDP_REDIRECT,
>>>>>>>  };
>>>>>>>
>>>>>>> +/* Flags for bpf_xdp_redirect_map helper */
>>>>>>> +
>>>>>>> +/* If set, the help will check if the entry exists in the map 
>>>>>>> and return
>>>>>>> + * XDP_PASS if it doesn't.
>>>>>>> + */
>>>>>>> +#define XDP_REDIRECT_F_PASS_ON_INVALID BIT(0)
>>>>>>> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_F_PASS_ON_INVALID
>>>>>>> +
>>>>>>>  /* user accessible metadata for XDP packet hook
>>>>>>>   * new fields must be added to the end of this structure
>>>>>>>   */
>>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>>>>> index 55bfc941d17a..2e532a9b2605 100644
>>>>>>> --- a/net/core/filter.c
>>>>>>> +++ b/net/core/filter.c
>>>>>>> @@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct 
>>>>>>> bpf_map *, map, u32, ifindex,
>>>>>>>  {
>>>>>>>       struct bpf_redirect_info *ri = 
>>>>>>> this_cpu_ptr(&bpf_redirect_info);
>>>>>>>
>>>>>>> -     if (unlikely(flags))
>>>>>>> +     if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>>>>>>>               return XDP_ABORTED;
>>>>>>>
>>>>>>> +     if (flags & XDP_REDIRECT_F_PASS_ON_INVALID) {
>>>>>>> +             void *val;
>>>>>>> +
>>>>>>> +             val = __xdp_map_lookup_elem(map, 
>>>>>>> ifindex);
>>>>>>> +             if (unlikely(!val))
>>>>>>> +                     return XDP_PASS;
>>>>>>
>>>>>> Generally looks good to me, also the second part with the flag. 
>>>>>> Given we store into
>>>>>> the per-CPU scratch space and function like xdp_do_redirect() pick 
>>>>>> this up again, we
>>>>>> could even propagate val onwards and save a second lookup on the 
>>>>>> /same/ element (which
>>>>>> also avoids a race if the val was dropped from the map in the 
>>>>>> meantime). Given this
>>>>>> should all still be within RCU it should work. Perhaps it even 
>>>>>> makes sense to do the
>>>>>> lookup unconditionally inside bpf_xdp_redirect_map() helper iff we 
>>>>>> manage to do it
>>>>>> only once anyway?
>>>>>
>>>>> +1
>>>>>
>>>>> also I don't think we really need a new flag here.
>>>>> Yes, it could be considered an uapi change, but it
>>>>> looks more like bugfix in uapi to me.
>>>>> Since original behavior was so clunky to use.
>>>>
>>>> Hmm, the problem with this is that eBPF programs generally do 
>>>> something
>>>> like:
>>>>
>>>> return bpf_redirect_map(map, idx, 0);
>>>>
>>>> after having already modified the packet headers. This will get them 
>>>> a
>>>> return code of XDP_REDIRECT, and the lookup will then subsequently 
>>>> fail,
>>>> which returns in XDP_ABORTED in the driver, which you can catch with
>>>> tracing.
>>>>
>>>> However, if we just change it to XDP_PASS, the packet will go up the
>>>> stack, but because it has already been modified the stack will drop 
>>>> it,
>>>> more or less invisibly.
>>>>
>>>> So the question becomes, is that behaviour change really OK?
>>>
>>> Another option would be treating the flags (or the lower bits of 
>>> flags)
>>> as the default xdp action taken if the lookup fails.  0 just happens 
>>> to
>>> map to XDP_ABORTED, which gives the initial behavior.  Then the new 
>>> behavior
>>> would be:
>>>
>>>     return bpf_redirect_map(map, index, XDP_PASS);
>>
>> Makes sense, that should work, but as default (flags == 0), you'd have
>> to return XDP_REDIRECT to stay consistent with existing behavior.
>
> Right - I was thinking something along the lines of:
>
>     val = __xdp_map_lookup_elem(map, ifindex);
>     if (unlikely(!val))
>         return (flags & 3);
>     ...
>     return XDP_REDIRECT;
>
>
> Stated another way, if the map lookup succeeds, return REDIRECT, 
> otherwise
> return one (ABORT, DROP, PASS, TX).

But then we're still changing UAPI on flags==0? Also, what would be the
use case for this, wouldn't the program have to react explicitly in any
case (to, e.g., not modify the packet if it decides to XDP_PASS)?

-Toke
