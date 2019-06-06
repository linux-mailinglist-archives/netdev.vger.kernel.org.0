Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0332837DE1
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfFFUNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:13:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41138 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfFFUNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:13:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id 83so1951992pgg.8
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 13:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=smwjhCnaTj2DSUZ0jaMvbmxv+RUMu0a7e/5ESpJEHjI=;
        b=kiRhjYInvQnEtkvL9XUXKnk/NcZEJ3fby+cMVBuB78yT694od+S0XluG4HI9q2kGWA
         SrIPNtz2K0MHQFuTJE7NqcU2B4zhdpNDvgOpRWk0pEsRLVB76JYdU8/c/vcT7qefxt38
         2Kj8KH7/kB1/3R6dWRn5Ov3sDWjDGw/c8PUoQJeA2dx70zlCs4MTNBc1zsss1HDl/c3C
         WqlC1nFU0f4o7SFQMw7V25P1tyggQcegD3+OspnVem/vWXOZ74LzakV2BbA6rfFesw+R
         SEXHlL40KtGVJ/PJFFu/uMLjU8nJAlyRbPl60exQrhEBk8sb8//yXkF0+BlZ94+olCrN
         F0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=smwjhCnaTj2DSUZ0jaMvbmxv+RUMu0a7e/5ESpJEHjI=;
        b=VuMZ4rk6T5ivUaNT/pNQn2PJP3Kban4N8ZffTgpDtIRvd4o6HgFzVN8+KG+6UKQ7E+
         1YeOP5RovBnC0pqxGfFdt3Dv9Iis1+GqBb6A7yInKYlSAz5WZr7mrTxcbYGuazIV9Ctz
         bMb8+FLy/2SZNjsYkwn3YWBWUQ8Z17CcWHSkh6xnBQ5sZX310lJSH/mtqE09D/Z/DP9I
         B4/VB4ElGt5gdLeIHHOUmAGCilgxTYg72gD8EhJCeKjp66xW9ZYX1kisykgoiVjcbffj
         ClM+YbeTagcYe+S6b+ewF/KZYTgSL10u1AMpADLzBqZRC0w4+m60rBz3JmWcHzKlxL8S
         U7ZQ==
X-Gm-Message-State: APjAAAV02lXlkGgPl5M2A9CC27CwF2Hd4DI/AHjSF+2lcX2zKC23+D6Y
        v50biQEyLAWNcqLQoykKt3o=
X-Google-Smtp-Source: APXvYqwhzs4LmyuGXf1DIlesIvGf+EDTWHiyuzJgD/Df5qfxCOAQAZjYWNHYYzy1aoCmguDxsYPxgg==
X-Received: by 2002:a63:e706:: with SMTP id b6mr319953pgi.90.1559851988814;
        Thu, 06 Jun 2019 13:13:08 -0700 (PDT)
Received: from [172.26.126.80] ([2620:10d:c090:180::1:627e])
        by smtp.gmail.com with ESMTPSA id d9sm26803pgl.20.2019.06.06.13.13.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 13:13:08 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Daniel Borkmann" <daniel@iogearbox.net>
Cc:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        "Network Development" <netdev@vger.kernel.org>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>
Subject: Re: [PATCH net-next v2 1/2] bpf_xdp_redirect_map: Add flag to return
 XDP_PASS on map lookup failure
Date:   Thu, 06 Jun 2019 13:13:06 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <2319D5A1-22D6-409F-9570-6A135DB026E0@gmail.com>
In-Reply-To: <709e80ae-a08a-f00e-8f42-50289495d0de@iogearbox.net>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
 <155982745460.30088.2745998912845128889.stgit@alrua-x1>
 <400a6093-6e9c-a1b4-0594-5b74b20a3d6b@iogearbox.net>
 <CAADnVQKZG6nOZUvqzvxz5xjZZLieQB4DvbkP=AjDF25FQB8Jfg@mail.gmail.com>
 <877e9yd70i.fsf@toke.dk> <9EC7B894-B076-46FA-BD2B-FFE12E55722B@gmail.com>
 <709e80ae-a08a-f00e-8f42-50289495d0de@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6 Jun 2019, at 12:24, Daniel Borkmann wrote:

> On 06/06/2019 08:15 PM, Jonathan Lemon wrote:
>> On 6 Jun 2019, at 9:15, Toke Høiland-Jørgensen wrote:
>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>>> On Thu, Jun 6, 2019 at 8:51 AM Daniel Borkmann 
>>>> <daniel@iogearbox.net> wrote:
>>>>> On 06/06/2019 03:24 PM, Toke Høiland-Jørgensen wrote:
>>>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>
>>>>>> The bpf_redirect_map() helper used by XDP programs doesn't return 
>>>>>> any
>>>>>> indication of whether it can successfully redirect to the map 
>>>>>> index it was
>>>>>> given. Instead, BPF programs have to track this themselves, 
>>>>>> leading to
>>>>>> programs using duplicate maps to track which entries are 
>>>>>> populated in the
>>>>>> devmap.
>>>>>>
>>>>>> This patch adds a flag to the XDP version of the 
>>>>>> bpf_redirect_map() helper,
>>>>>> which makes the helper do a lookup in the map when called, and 
>>>>>> return
>>>>>> XDP_PASS if there is no value at the provided index.
>>>>>>
>>>>>> With this, a BPF program can check the return code from the 
>>>>>> helper call and
>>>>>> react if it is XDP_PASS (by, for instance, substituting a 
>>>>>> different
>>>>>> redirect). This works for any type of map used for redirect.
>>>>>>
>>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>> ---
>>>>>>  include/uapi/linux/bpf.h |    8 ++++++++
>>>>>>  net/core/filter.c        |   10 +++++++++-
>>>>>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>>> index 7c6aef253173..d57df4f0b837 100644
>>>>>> --- a/include/uapi/linux/bpf.h
>>>>>> +++ b/include/uapi/linux/bpf.h
>>>>>> @@ -3098,6 +3098,14 @@ enum xdp_action {
>>>>>>       XDP_REDIRECT,
>>>>>>  };
>>>>>>
>>>>>> +/* Flags for bpf_xdp_redirect_map helper */
>>>>>> +
>>>>>> +/* If set, the help will check if the entry exists in the map 
>>>>>> and return
>>>>>> + * XDP_PASS if it doesn't.
>>>>>> + */
>>>>>> +#define XDP_REDIRECT_F_PASS_ON_INVALID BIT(0)
>>>>>> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_F_PASS_ON_INVALID
>>>>>> +
>>>>>>  /* user accessible metadata for XDP packet hook
>>>>>>   * new fields must be added to the end of this structure
>>>>>>   */
>>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>>>> index 55bfc941d17a..2e532a9b2605 100644
>>>>>> --- a/net/core/filter.c
>>>>>> +++ b/net/core/filter.c
>>>>>> @@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct 
>>>>>> bpf_map *, map, u32, ifindex,
>>>>>>  {
>>>>>>       struct bpf_redirect_info *ri = 
>>>>>> this_cpu_ptr(&bpf_redirect_info);
>>>>>>
>>>>>> -     if (unlikely(flags))
>>>>>> +     if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>>>>>>               return XDP_ABORTED;
>>>>>>
>>>>>> +     if (flags & XDP_REDIRECT_F_PASS_ON_INVALID) {
>>>>>> +             void *val;
>>>>>> +
>>>>>> +             val = __xdp_map_lookup_elem(map, 
>>>>>> ifindex);
>>>>>> +             if (unlikely(!val))
>>>>>> +                     return XDP_PASS;
>>>>>
>>>>> Generally looks good to me, also the second part with the flag. 
>>>>> Given we store into
>>>>> the per-CPU scratch space and function like xdp_do_redirect() pick 
>>>>> this up again, we
>>>>> could even propagate val onwards and save a second lookup on the 
>>>>> /same/ element (which
>>>>> also avoids a race if the val was dropped from the map in the 
>>>>> meantime). Given this
>>>>> should all still be within RCU it should work. Perhaps it even 
>>>>> makes sense to do the
>>>>> lookup unconditionally inside bpf_xdp_redirect_map() helper iff we 
>>>>> manage to do it
>>>>> only once anyway?
>>>>
>>>> +1
>>>>
>>>> also I don't think we really need a new flag here.
>>>> Yes, it could be considered an uapi change, but it
>>>> looks more like bugfix in uapi to me.
>>>> Since original behavior was so clunky to use.
>>>
>>> Hmm, the problem with this is that eBPF programs generally do 
>>> something
>>> like:
>>>
>>> return bpf_redirect_map(map, idx, 0);
>>>
>>> after having already modified the packet headers. This will get them 
>>> a
>>> return code of XDP_REDIRECT, and the lookup will then subsequently 
>>> fail,
>>> which returns in XDP_ABORTED in the driver, which you can catch with
>>> tracing.
>>>
>>> However, if we just change it to XDP_PASS, the packet will go up the
>>> stack, but because it has already been modified the stack will drop 
>>> it,
>>> more or less invisibly.
>>>
>>> So the question becomes, is that behaviour change really OK?
>>
>> Another option would be treating the flags (or the lower bits of 
>> flags)
>> as the default xdp action taken if the lookup fails.  0 just happens 
>> to
>> map to XDP_ABORTED, which gives the initial behavior.  Then the new 
>> behavior
>> would be:
>>
>>     return bpf_redirect_map(map, index, XDP_PASS);
>
> Makes sense, that should work, but as default (flags == 0), you'd have
> to return XDP_REDIRECT to stay consistent with existing behavior.

Right - I was thinking something along the lines of:

    val = __xdp_map_lookup_elem(map, ifindex);
    if (unlikely(!val))
        return (flags & 3);
    ...
    return XDP_REDIRECT;


Stated another way, if the map lookup succeeds, return REDIRECT, 
otherwise
return one (ABORT, DROP, PASS, TX).
-- 
Jonathan

	
>
> Thanks,
> Daniel
