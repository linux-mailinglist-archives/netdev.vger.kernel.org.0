Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E9E380CE
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfFFWby convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 18:31:54 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39345 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFFWbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:31:53 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so5553977edv.6
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 15:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=io7y5EpxB+P68pNMlcAYTHu8k648Q7IgeIdFwtsLxzc=;
        b=Uy5D7RgZF7H+6i6FSHR6xefbUm9qdNU0lBK73f72noijLRDKw0IL32AJgIQQcMpYIZ
         t7KgRO9pl6flhBoyHi391kCZ2KWnuWkg8JSfmwiC7HTuEF/WgJW8gClDL/CbXY3kbTnL
         5j8dzCDLJWiVT3yygwDy+N2FXOoaElPkeuRukiWfU8JMr6nxNhIjHleLKcHb5W7AMc7p
         nvWOw9Y5RAfy1k8XTz92X3HMDqyvPVqx6gCP+rdU/ocLc/yM1JCP+4H9aGcnjNZYI0BH
         y0RrAfrhfmiHKXIly0pCmXAbB1zJuULXSjNwH+1cg/lIoxbene/7d7TQltox70x5Ikps
         WP3g==
X-Gm-Message-State: APjAAAWFZtgVVNDbCH1cxarMJjrtkdgGMupkWN2rvYGeoxEph5yD91Uo
        cEIlrWDPzg4FA5153+I8puPYLA==
X-Google-Smtp-Source: APXvYqxiPlHi9ERmz8LX4tFr6Z11ErWEbmQxmiHUNGDVk+89JuehpX/fLE0x27VdFqJFHXtmH4Xa/Q==
X-Received: by 2002:a50:ca89:: with SMTP id x9mr52224075edh.164.1559860311786;
        Thu, 06 Jun 2019 15:31:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id m21sm53600edq.57.2019.06.06.15.31.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 15:31:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 88097181CC1; Fri,  7 Jun 2019 00:31:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net-next v2 1/2] bpf_xdp_redirect_map: Add flag to return XDP_PASS on map lookup failure
In-Reply-To: <01288968-4BF8-48D6-81FB-3843AD1B41D6@gmail.com>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1> <155982745460.30088.2745998912845128889.stgit@alrua-x1> <400a6093-6e9c-a1b4-0594-5b74b20a3d6b@iogearbox.net> <CAADnVQKZG6nOZUvqzvxz5xjZZLieQB4DvbkP=AjDF25FQB8Jfg@mail.gmail.com> <877e9yd70i.fsf@toke.dk> <9EC7B894-B076-46FA-BD2B-FFE12E55722B@gmail.com> <709e80ae-a08a-f00e-8f42-50289495d0de@iogearbox.net> <2319D5A1-22D6-409F-9570-6A135DB026E0@gmail.com> <87sgsmbelv.fsf@toke.dk> <01288968-4BF8-48D6-81FB-3843AD1B41D6@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 07 Jun 2019 00:31:50 +0200
Message-ID: <87o93abb1l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Lemon <jonathan.lemon@gmail.com> writes:

> On 6 Jun 2019, at 14:14, Toke Høiland-Jørgensen wrote:
>
>> Jonathan Lemon <jonathan.lemon@gmail.com> writes:
>>
>>> On 6 Jun 2019, at 12:24, Daniel Borkmann wrote:
>>>
>>>> On 06/06/2019 08:15 PM, Jonathan Lemon wrote:
>>>>> On 6 Jun 2019, at 9:15, Toke Høiland-Jørgensen wrote:
>>>>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>>>>>> On Thu, Jun 6, 2019 at 8:51 AM Daniel Borkmann
>>>>>>> <daniel@iogearbox.net> wrote:
>>>>>>>> On 06/06/2019 03:24 PM, Toke Høiland-Jørgensen wrote:
>>>>>>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>>>>
>>>>>>>>> The bpf_redirect_map() helper used by XDP programs doesn't return
>>>>>>>>> any
>>>>>>>>> indication of whether it can successfully redirect to the map
>>>>>>>>> index it was
>>>>>>>>> given. Instead, BPF programs have to track this themselves,
>>>>>>>>> leading to
>>>>>>>>> programs using duplicate maps to track which entries are
>>>>>>>>> populated in the
>>>>>>>>> devmap.
>>>>>>>>>
>>>>>>>>> This patch adds a flag to the XDP version of the
>>>>>>>>> bpf_redirect_map() helper,
>>>>>>>>> which makes the helper do a lookup in the map when called, and
>>>>>>>>> return
>>>>>>>>> XDP_PASS if there is no value at the provided index.
>>>>>>>>>
>>>>>>>>> With this, a BPF program can check the return code from the
>>>>>>>>> helper call and
>>>>>>>>> react if it is XDP_PASS (by, for instance, substituting a
>>>>>>>>> different
>>>>>>>>> redirect). This works for any type of map used for redirect.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>>>> ---
>>>>>>>>>  include/uapi/linux/bpf.h |    8 ++++++++
>>>>>>>>>  net/core/filter.c        |   10 +++++++++-
>>>>>>>>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>>>>>>>>
>>>>>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>>>>>> index 7c6aef253173..d57df4f0b837 100644
>>>>>>>>> --- a/include/uapi/linux/bpf.h
>>>>>>>>> +++ b/include/uapi/linux/bpf.h
>>>>>>>>> @@ -3098,6 +3098,14 @@ enum xdp_action {
>>>>>>>>>       XDP_REDIRECT,
>>>>>>>>>  };
>>>>>>>>>
>>>>>>>>> +/* Flags for bpf_xdp_redirect_map helper */
>>>>>>>>> +
>>>>>>>>> +/* If set, the help will check if the entry exists in the map
>>>>>>>>> and return
>>>>>>>>> + * XDP_PASS if it doesn't.
>>>>>>>>> + */
>>>>>>>>> +#define XDP_REDIRECT_F_PASS_ON_INVALID BIT(0)
>>>>>>>>> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_F_PASS_ON_INVALID
>>>>>>>>> +
>>>>>>>>>  /* user accessible metadata for XDP packet hook
>>>>>>>>>   * new fields must be added to the end of this structure
>>>>>>>>>   */
>>>>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>>>>>>> index 55bfc941d17a..2e532a9b2605 100644
>>>>>>>>> --- a/net/core/filter.c
>>>>>>>>> +++ b/net/core/filter.c
>>>>>>>>> @@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct
>>>>>>>>> bpf_map *, map, u32, ifindex,
>>>>>>>>>  {
>>>>>>>>>       struct bpf_redirect_info *ri =
>>>>>>>>> this_cpu_ptr(&bpf_redirect_info);
>>>>>>>>>
>>>>>>>>> -     if (unlikely(flags))
>>>>>>>>> +     if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>>>>>>>>>               return XDP_ABORTED;
>>>>>>>>>
>>>>>>>>> +     if (flags & XDP_REDIRECT_F_PASS_ON_INVALID) {
>>>>>>>>> +             void *val;
>>>>>>>>> +
>>>>>>>>> +             val = __xdp_map_lookup_elem(map,
>>>>>>>>> ifindex);
>>>>>>>>> +             if (unlikely(!val))
>>>>>>>>> +                     return XDP_PASS;
>>>>>>>>
>>>>>>>> Generally looks good to me, also the second part with the flag.
>>>>>>>> Given we store into
>>>>>>>> the per-CPU scratch space and function like xdp_do_redirect() pick
>>>>>>>> this up again, we
>>>>>>>> could even propagate val onwards and save a second lookup on the
>>>>>>>> /same/ element (which
>>>>>>>> also avoids a race if the val was dropped from the map in the
>>>>>>>> meantime). Given this
>>>>>>>> should all still be within RCU it should work. Perhaps it even
>>>>>>>> makes sense to do the
>>>>>>>> lookup unconditionally inside bpf_xdp_redirect_map() helper iff we
>>>>>>>> manage to do it
>>>>>>>> only once anyway?
>>>>>>>
>>>>>>> +1
>>>>>>>
>>>>>>> also I don't think we really need a new flag here.
>>>>>>> Yes, it could be considered an uapi change, but it
>>>>>>> looks more like bugfix in uapi to me.
>>>>>>> Since original behavior was so clunky to use.
>>>>>>
>>>>>> Hmm, the problem with this is that eBPF programs generally do
>>>>>> something
>>>>>> like:
>>>>>>
>>>>>> return bpf_redirect_map(map, idx, 0);
>>>>>>
>>>>>> after having already modified the packet headers. This will get them
>>>>>> a
>>>>>> return code of XDP_REDIRECT, and the lookup will then subsequently
>>>>>> fail,
>>>>>> which returns in XDP_ABORTED in the driver, which you can catch with
>>>>>> tracing.
>>>>>>
>>>>>> However, if we just change it to XDP_PASS, the packet will go up the
>>>>>> stack, but because it has already been modified the stack will drop
>>>>>> it,
>>>>>> more or less invisibly.
>>>>>>
>>>>>> So the question becomes, is that behaviour change really OK?
>>>>>
>>>>> Another option would be treating the flags (or the lower bits of
>>>>> flags)
>>>>> as the default xdp action taken if the lookup fails.  0 just happens
>>>>> to
>>>>> map to XDP_ABORTED, which gives the initial behavior.  Then the new
>>>>> behavior
>>>>> would be:
>>>>>
>>>>>     return bpf_redirect_map(map, index, XDP_PASS);
>>>>
>>>> Makes sense, that should work, but as default (flags == 0), you'd have
>>>> to return XDP_REDIRECT to stay consistent with existing behavior.
>>>
>>> Right - I was thinking something along the lines of:
>>>
>>>     val = __xdp_map_lookup_elem(map, ifindex);
>>>     if (unlikely(!val))
>>>         return (flags & 3);
>>>     ...
>>>     return XDP_REDIRECT;
>>>
>>>
>>> Stated another way, if the map lookup succeeds, return REDIRECT,
>>> otherwise
>>> return one (ABORT, DROP, PASS, TX).
>>
>> But then we're still changing UAPI on flags==0?
>
> I believe your point (and Daniel's) is that for flags==0, it should always
> return REDIRECT, which is the current behavior? I'm not seeing why it
> matters.
>
> Returning REDIRECT indicates something was stored in redirect_info, and
> xdp_do_redirect() is called.  This will fail the lookup (which was just done)
> and return -EINVAL.  Callers treat this as XDP_DROP.
>
> On the other hand, returning XDP_ABORTED bypasses the xdp_do_redirect() call
> and all callsites treat this as DROP.  The main difference seems to be the
> tracing call - whether _trace_xdp_redirect_map_err or trace_xdp_exception gets
> called.
>
> Is this really an UAPI breakage?

Well, that's what I'm trying to figure out :)

It will mean that the xdp_redirect_map_err() tracepoint is no longer
triggered, and anyone who counts the number of different return codes
seen by the program (as we do in the XDP tutorial, for instance[0]) is
going to see different values all of a sudden.

So it kinda feels dodgy to change it, I'd say? As in, I'm not vehemently
opposed, just trying to be extra cautious?

>> Also, what would be the use case for this, wouldn't the program have
>> to react explicitly in any case (to, e.g., not modify the packet if
>> it decides to XDP_PASS)?
>
> How is that any different from using XDP_REDIRECT_F_PASS_ON_INVALID?

My point is that it's not: If you have to check the return value anyway,
we're not really gaining everything from making it possible to select
what that return value is?

-Toke

[0] https://github.com/xdp-project/xdp-tutorial/blob/master/packet01-parsing/xdp_prog_kern.c#L94
