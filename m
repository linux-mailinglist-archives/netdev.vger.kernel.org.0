Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917B52FD5D7
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391538AbhATQib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:38:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391499AbhATQbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 11:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611160213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HWEm9l+Fw77ui1b4c+Aizii9SYhFgNLuUIBsDhLc5/I=;
        b=KjSlil6iuqwp1nMWozbhGfkUpvXx5mFZlH9RhjuyCoD0bu6oL67+IR8vBo2jGV6NP2vL5Q
        Zp1d0k/9aTwSV1knzBpQx2l3tc8/D2ELc2eG9jcy9iuXsLidT1239bo766n8QCMzQv0omd
        BGUNRiTYIf/9O6M3jqV7D4/nCNzyvf0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-tBQhU9AHOA65wlN6ZcRMPQ-1; Wed, 20 Jan 2021 11:30:11 -0500
X-MC-Unique: tBQhU9AHOA65wlN6ZcRMPQ-1
Received: by mail-ed1-f70.google.com with SMTP id u17so11366964edi.18
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 08:30:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=HWEm9l+Fw77ui1b4c+Aizii9SYhFgNLuUIBsDhLc5/I=;
        b=aayduRUYuRz5J75mcJtbqMg5iIw32sTgk+ZDKIFVrUSdEHtuTJcO7KFherbE95WXyF
         1VH5BzFXWFERhdIOTx4TRwTZlLPMG6HNFozMyx6K6PX8wp0oUt38HWC73TA4Ggq7ujzT
         UCuI4j1hR4XJC0+vAmiC5O4PDZFjzz5cw3y37WqFR5tTmFDKQzdRIrbBH6XewVWJJ8WB
         jXFVbx9Uo+jFxP/ubpORDvIEwiqcPD32aI6hDZIUYs2yuGxNLmqUYEuS/WpS9X7l/6EJ
         3XHAUUs9eA7lBTWyBC/YA7I1fy674l4mWeMb4ArZpylbkGQojWTEG2EHfBdWmccnQvEN
         VfhA==
X-Gm-Message-State: AOAM533w65pxdTKEWlKkFNb8YUExsUznDFObmEN307JQYpiPSCZZG6zY
        u8LusRkh3g5Xk1kqLbfRkTCDvRCjCvKZAwJVyR9/DXf91Qk+YrIXiqN8Lq6K5R34Fs6aztQ6ylV
        nuIndWJD3q19J8GVr
X-Received: by 2002:aa7:c7d8:: with SMTP id o24mr8206048eds.328.1611160210625;
        Wed, 20 Jan 2021 08:30:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXwH7VEwgQS8Dcshv8QzzgTXA6+377docK5Eq2A/xU5tlEOH81mMXGrnSjXxlNGjwIqhgWsg==
X-Received: by 2002:aa7:c7d8:: with SMTP id o24mr8206028eds.328.1611160210419;
        Wed, 20 Jan 2021 08:30:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x25sm1349302edv.65.2021.01.20.08.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 08:30:09 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 171DF180331; Wed, 20 Jan 2021 17:30:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: Re: [PATCH bpf-next v2 1/8] xdp: restructure redirect actions
In-Reply-To: <0a7d1a0b-de2e-b973-a807-b9377bb89737@intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-2-bjorn.topel@gmail.com> <87bldjeq1j.fsf@toke.dk>
 <996f1ff7-5891-fd4a-ee3e-fefd7e93879d@intel.com> <87mtx34q48.fsf@toke.dk>
 <0a7d1a0b-de2e-b973-a807-b9377bb89737@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jan 2021 17:30:09 +0100
Message-ID: <87bldj4lm6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-01-20 15:52, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:
>>=20
>>> On 2021-01-20 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>>>
>>>>> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>>>>>
>>>>> The XDP_REDIRECT implementations for maps and non-maps are fairly
>>>>> similar, but obviously need to take different code paths depending on
>>>>> if the target is using a map or not. Today, the redirect targets for
>>>>> XDP either uses a map, or is based on ifindex.
>>>>>
>>>>> Future commits will introduce yet another redirect target via the a
>>>>> new helper, bpf_redirect_xsk(). To pave the way for that, we introduce
>>>>> an explicit redirect type to bpf_redirect_info. This makes the code
>>>>> easier to follow, and makes it easier to add new redirect targets.
>>>>>
>>>>> Further, using an explicit type in bpf_redirect_info has a slight
>>>>> positive performance impact by avoiding a pointer indirection for the
>>>>> map type lookup, and instead use the hot cacheline for
>>>>> bpf_redirect_info.
>>>>>
>>>>> The bpf_redirect_info flags member is not used by XDP, and not
>>>>> read/written any more. The map member is only written to when
>>>>> required/used, and not unconditionally.
>>>>
>>>> I like the simplification. However, the handling of map clearing becom=
es
>>>> a bit murky with this change:
>>>>
>>>> You're not changing anything in bpf_clear_redirect_map(), and you're
>>>> removing most of the reads and writes of ri->map. Instead,
>>>> bpf_xdp_redirect_map() will store the bpf_dtab_netdev pointer in
>>>> ri->tgt_value, which xdp_do_redirect() will just read and use without
>>>> checking. But if the map element (or the entire map) has been freed in
>>>> the meantime that will be a dangling pointer. I *think* the RCU callba=
ck
>>>> in dev_map_delete_elem() and the rcu_barrier() in dev_map_free()
>>>> protects against this, but that is by no means obvious. So confirming
>>>> this, and explaining it in a comment would be good.
>>>>
>>>
>>> Yes, *most* of the READ_ONCE(ri->map) are removed, it's pretty much only
>>> the bpf_redirect_map(), and as you write, the tracepoints.
>>>
>>> The content/element of the map is RCU protected, and actually even the
>>> map will be around until the XDP processing is complete. Note the
>>> synchronize_rcu() followed after all bpf_clear_redirect_map() calls.
>>>
>>> I'll try to make it clearer in the commit message! Thanks for pointing
>>> that out!
>>>
>>>> Also, as far as I can tell after this, ri->map is only used for the
>>>> tracepoint. So how about just storing the map ID and getting rid of the
>>>> READ/WRITE_ONCE() entirely?
>>>>
>>>
>>> ...and the bpf_redirect_map() helper. Don't you think the current
>>> READ_ONCE(ri->map) scheme is more obvious/clear?
>>=20
>> Yeah, after your patch we WRITE_ONCE() the pointer in
>> bpf_redirect_map(), but the only place it is actually *read* is in the
>> tracepoint. So the only purpose of bpf_clear_redirect_map() is to ensure
>> that an invalid pointer is not read in the tracepoint function. Which
>> seems a bit excessive when we could just store the map ID for direct use
>> in the tracepoint and get rid of bpf_clear_redirect_map() entirely, no?
>>=20
>> Besides, from a UX point of view, having the tracepoint display the map
>> ID even if that map ID is no longer valid seems to me like it makes more
>> sense than just displaying a map ID of 0 and leaving it up to the user
>> to figure out that this is because the map was cleared. I mean, at the
>> time the redirect was made, that *was* the map ID that was used...
>>
>
> Convinced! Getting rid of bpf_clear_redirect_map() would be good! I'll
> take a stab at this for v3!

Cool!

>> Oh, and as you say due to the synchronize_rcu() call in dev_map_free() I
>> think this whole discussion is superfluous anyway, since it can't
>> actually happen that the map gets freed between the setting and reading
>> of ri->map, no?
>>
>
> It can't be free'd but, ri->map can be cleared via
> bpf_clear_redirect_map(). So, between the helper (setting) and the
> tracepoint in xdp_do_redirect() it can be cleared (say if the XDP
> program is swapped out, prior running xdp_do_redirect()).

But xdp_do_redirect() should be called on driver flush before exiting
the NAPI cycle, so how can the XDP program be swapped out?

> Moving to the scheme you suggested, does make the discussion
> superfluous. :-)

Yup, awesome :)

-Toke

