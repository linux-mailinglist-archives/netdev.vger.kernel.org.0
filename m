Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2181F37FFD
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfFFVxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:53:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44000 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbfFFVxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:53:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so2082806pgv.10
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ml55HhBeLksSMf/6UTCo0TYrgIkNM83Z4DM7WZrZfr0=;
        b=aRVp2mN0tRPluJRCFCqumc1iNyISLORjm3DT9RezdT8oOo8478YkIAamttWpyI6IW3
         ngBwZwoDYtlFAiCb8GXGy9y5oNcDlW0AoVv1CWb2dY2x8YHvwNPSKv7BZo8h976OyVyZ
         82OQ9JaWtq5fCt/bV3PGA6fzs80vrpZ4ttaoQVXseCHw50q2Rexh4MbZU8HWIPM6jclI
         5lrwc07HYKZJ26TwkQLlwUeZk065FfTP/vYoOSPmhPxhdbAuiztiZGs+qb9e79buoY6S
         rB3dphzecrOE9KpcWSjypFmpHRQ/vna6m/K8izJTI6jWbOBxkncDlLMwgJ0lQCmpEtNc
         R/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ml55HhBeLksSMf/6UTCo0TYrgIkNM83Z4DM7WZrZfr0=;
        b=RJYj5NzJ1rP8OJyN2MOEgD6PCz07vZ31U0zpKAQGQe5WHadpVkOxvmg9mtigZaNo5f
         DnCD4WydaRBGuVFLGun4mQh2idaw5JncRWMYUqCuwtekZCBUCYg3zo2I+96C2iWo5nBP
         lOxWy66GhzGzTm218ORxolAZksT925YFC2+XwWEGbhwa5DXLitEfmJVJY7bKC4yRHDx3
         mAh/65P6LDK5w18o+ms3bT32c2y7wKapXCPDeZ0OhiqZl3ml5r6Qgcn90icqbSOkmmZe
         sq96cq7HsP3q0YkVHeQ0nPMctZDVlIrEPIYcWoEaxjpqxqbmSaBYqCsmKLJdvSOXMq9z
         8kFw==
X-Gm-Message-State: APjAAAXdhJSmmHzG3j8S0+Nt1Ao6FeTJsdVh3qZK2zdxpEroZWdSSFWT
        Vj7qShm8Dwsu+4NepnXD3As=
X-Google-Smtp-Source: APXvYqx3SXMgW8iU02GOSI8P7Gi7pSPM6Ac0nlRLQeby6ZaYdyeAg1T01F3CkVXBYNJF821VoamshA==
X-Received: by 2002:a63:c104:: with SMTP id w4mr605152pgf.125.1559858002801;
        Thu, 06 Jun 2019 14:53:22 -0700 (PDT)
Received: from [172.26.126.80] ([2620:10d:c090:180::1:627e])
        by smtp.gmail.com with ESMTPSA id 25sm114756pfp.76.2019.06.06.14.53.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 14:53:21 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        "Network Development" <netdev@vger.kernel.org>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>
Subject: Re: [PATCH net-next v2 1/2] bpf_xdp_redirect_map: Add flag to return
 XDP_PASS on map lookup failure
Date:   Thu, 06 Jun 2019 14:53:20 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <01288968-4BF8-48D6-81FB-3843AD1B41D6@gmail.com>
In-Reply-To: <87sgsmbelv.fsf@toke.dk>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
 <155982745460.30088.2745998912845128889.stgit@alrua-x1>
 <400a6093-6e9c-a1b4-0594-5b74b20a3d6b@iogearbox.net>
 <CAADnVQKZG6nOZUvqzvxz5xjZZLieQB4DvbkP=AjDF25FQB8Jfg@mail.gmail.com>
 <877e9yd70i.fsf@toke.dk> <9EC7B894-B076-46FA-BD2B-FFE12E55722B@gmail.com>
 <709e80ae-a08a-f00e-8f42-50289495d0de@iogearbox.net>
 <2319D5A1-22D6-409F-9570-6A135DB026E0@gmail.com> <87sgsmbelv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6 Jun 2019, at 14:14, Toke Høiland-Jørgensen wrote:

> Jonathan Lemon <jonathan.lemon@gmail.com> writes:
>
>> On 6 Jun 2019, at 12:24, Daniel Borkmann wrote:
>>
>>> On 06/06/2019 08:15 PM, Jonathan Lemon wrote:
>>>> On 6 Jun 2019, at 9:15, Toke Høiland-Jørgensen wrote:
>>>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>>>>> On Thu, Jun 6, 2019 at 8:51 AM Daniel Borkmann
>>>>>> <daniel@iogearbox.net> wrote:
>>>>>>> On 06/06/2019 03:24 PM, Toke Høiland-Jørgensen wrote:
>>>>>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>>>
>>>>>>>> The bpf_redirect_map() helper used by XDP programs doesn't return
>>>>>>>> any
>>>>>>>> indication of whether it can successfully redirect to the map
>>>>>>>> index it was
>>>>>>>> given. Instead, BPF programs have to track this themselves,
>>>>>>>> leading to
>>>>>>>> programs using duplicate maps to track which entries are
>>>>>>>> populated in the
>>>>>>>> devmap.
>>>>>>>>
>>>>>>>> This patch adds a flag to the XDP version of the
>>>>>>>> bpf_redirect_map() helper,
>>>>>>>> which makes the helper do a lookup in the map when called, and
>>>>>>>> return
>>>>>>>> XDP_PASS if there is no value at the provided index.
>>>>>>>>
>>>>>>>> With this, a BPF program can check the return code from the
>>>>>>>> helper call and
>>>>>>>> react if it is XDP_PASS (by, for instance, substituting a
>>>>>>>> different
>>>>>>>> redirect). This works for any type of map used for redirect.
>>>>>>>>
>>>>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>>> ---
>>>>>>>>  include/uapi/linux/bpf.h |    8 ++++++++
>>>>>>>>  net/core/filter.c        |   10 +++++++++-
>>>>>>>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>>>>> index 7c6aef253173..d57df4f0b837 100644
>>>>>>>> --- a/include/uapi/linux/bpf.h
>>>>>>>> +++ b/include/uapi/linux/bpf.h
>>>>>>>> @@ -3098,6 +3098,14 @@ enum xdp_action {
>>>>>>>>       XDP_REDIRECT,
>>>>>>>>  };
>>>>>>>>
>>>>>>>> +/* Flags for bpf_xdp_redirect_map helper */
>>>>>>>> +
>>>>>>>> +/* If set, the help will check if the entry exists in the map
>>>>>>>> and return
>>>>>>>> + * XDP_PASS if it doesn't.
>>>>>>>> + */
>>>>>>>> +#define XDP_REDIRECT_F_PASS_ON_INVALID BIT(0)
>>>>>>>> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_F_PASS_ON_INVALID
>>>>>>>> +
>>>>>>>>  /* user accessible metadata for XDP packet hook
>>>>>>>>   * new fields must be added to the end of this structure
>>>>>>>>   */
>>>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>>>>>> index 55bfc941d17a..2e532a9b2605 100644
>>>>>>>> --- a/net/core/filter.c
>>>>>>>> +++ b/net/core/filter.c
>>>>>>>> @@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct
>>>>>>>> bpf_map *, map, u32, ifindex,
>>>>>>>>  {
>>>>>>>>       struct bpf_redirect_info *ri =
>>>>>>>> this_cpu_ptr(&bpf_redirect_info);
>>>>>>>>
>>>>>>>> -     if (unlikely(flags))
>>>>>>>> +     if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>>>>>>>>               return XDP_ABORTED;
>>>>>>>>
>>>>>>>> +     if (flags & XDP_REDIRECT_F_PASS_ON_INVALID) {
>>>>>>>> +             void *val;
>>>>>>>> +
>>>>>>>> +             val = __xdp_map_lookup_elem(map,
>>>>>>>> ifindex);
>>>>>>>> +             if (unlikely(!val))
>>>>>>>> +                     return XDP_PASS;
>>>>>>>
>>>>>>> Generally looks good to me, also the second part with the flag.
>>>>>>> Given we store into
>>>>>>> the per-CPU scratch space and function like xdp_do_redirect() pick
>>>>>>> this up again, we
>>>>>>> could even propagate val onwards and save a second lookup on the
>>>>>>> /same/ element (which
>>>>>>> also avoids a race if the val was dropped from the map in the
>>>>>>> meantime). Given this
>>>>>>> should all still be within RCU it should work. Perhaps it even
>>>>>>> makes sense to do the
>>>>>>> lookup unconditionally inside bpf_xdp_redirect_map() helper iff we
>>>>>>> manage to do it
>>>>>>> only once anyway?
>>>>>>
>>>>>> +1
>>>>>>
>>>>>> also I don't think we really need a new flag here.
>>>>>> Yes, it could be considered an uapi change, but it
>>>>>> looks more like bugfix in uapi to me.
>>>>>> Since original behavior was so clunky to use.
>>>>>
>>>>> Hmm, the problem with this is that eBPF programs generally do
>>>>> something
>>>>> like:
>>>>>
>>>>> return bpf_redirect_map(map, idx, 0);
>>>>>
>>>>> after having already modified the packet headers. This will get them
>>>>> a
>>>>> return code of XDP_REDIRECT, and the lookup will then subsequently
>>>>> fail,
>>>>> which returns in XDP_ABORTED in the driver, which you can catch with
>>>>> tracing.
>>>>>
>>>>> However, if we just change it to XDP_PASS, the packet will go up the
>>>>> stack, but because it has already been modified the stack will drop
>>>>> it,
>>>>> more or less invisibly.
>>>>>
>>>>> So the question becomes, is that behaviour change really OK?
>>>>
>>>> Another option would be treating the flags (or the lower bits of
>>>> flags)
>>>> as the default xdp action taken if the lookup fails.  0 just happens
>>>> to
>>>> map to XDP_ABORTED, which gives the initial behavior.  Then the new
>>>> behavior
>>>> would be:
>>>>
>>>>     return bpf_redirect_map(map, index, XDP_PASS);
>>>
>>> Makes sense, that should work, but as default (flags == 0), you'd have
>>> to return XDP_REDIRECT to stay consistent with existing behavior.
>>
>> Right - I was thinking something along the lines of:
>>
>>     val = __xdp_map_lookup_elem(map, ifindex);
>>     if (unlikely(!val))
>>         return (flags & 3);
>>     ...
>>     return XDP_REDIRECT;
>>
>>
>> Stated another way, if the map lookup succeeds, return REDIRECT,
>> otherwise
>> return one (ABORT, DROP, PASS, TX).
>
> But then we're still changing UAPI on flags==0?

I believe your point (and Daniel's) is that for flags==0, it should always
return REDIRECT, which is the current behavior? I'm not seeing why it
matters.

Returning REDIRECT indicates something was stored in redirect_info, and
xdp_do_redirect() is called.  This will fail the lookup (which was just done)
and return -EINVAL.  Callers treat this as XDP_DROP.

On the other hand, returning XDP_ABORTED bypasses the xdp_do_redirect() call
and all callsites treat this as DROP.  The main difference seems to be the
tracing call - whether _trace_xdp_redirect_map_err or trace_xdp_exception gets
called.

Is this really an UAPI breakage?


> Also, what would be the
> use case for this, wouldn't the program have to react explicitly in any
> case (to, e.g., not modify the packet if it decides to XDP_PASS)?

How is that any different from using XDP_REDIRECT_F_PASS_ON_INVALID?
-- 
Jonathan


>
> -Toke
