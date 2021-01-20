Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745472FD452
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732449AbhATPjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:39:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388385AbhATOy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:54:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611154379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X3ef/yWKjHQXxstlBAjxJ4gnAy5LKmoZd+GY3iLVlxo=;
        b=SY5fdVI4FM7LNGfFqGwuly++QcotL6jrj8o0MCYrKYXZ/QfV/ORAodVs7CTa4pDXIduS65
        SF62NwtwWoILehpeJlySZGWbC3/+wEz9fa1lcAIisLWk1pskxbQMrMCH48xsw96+SHdSAU
        WyC5vc8U3CVjLIp4o4fcWYHATXFn6SY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-19OsLERrP0q0hH83uR52YQ-1; Wed, 20 Jan 2021 09:52:57 -0500
X-MC-Unique: 19OsLERrP0q0hH83uR52YQ-1
Received: by mail-ej1-f70.google.com with SMTP id f26so7582276ejy.9
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:52:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=X3ef/yWKjHQXxstlBAjxJ4gnAy5LKmoZd+GY3iLVlxo=;
        b=XcasghkNjcNrHc5+6lZA3+6rT8D4a8Y5vgCRBIKq+PzGmP7L84Pi807QCtNVoBjlJd
         +/SITxIARNRf9fEe+PsOh21qwBfcodXcGLVCwICOEQ/0gq9rIp62ePEhK7Nlu6YnRCDJ
         JKHCH8pmhk7cU5HXRjGCM73dRU/ypuZtTpJ/ra+7fKPE8hU7qaY7TRbbegft2WcBZpRl
         kkZVbVFvgnQRnRJH32tQpTHoR+LxhYe6vsoeL5fjpYdu6V0Hfx4lyaXPJz4zRCdb3LDW
         i/GIie5AMjHTN0o7VzwlX0BS9rUkzmcIWhasKtcxMs96C4iLDVGr1NDDgVXWud2iCOa3
         Hutw==
X-Gm-Message-State: AOAM533HPdBzwDGF2euO3lcOBz8HqyL0XjEen2ZYCYGmbhLCz5WbyYNX
        VI6ZTjMnvPrz36DZMk18WjH/I8IGbUxJhjonEQVOgG2mqcZgUl6RGvEguSt+UtPpFbNdW3v6e9g
        TO3WJCPCKYDOEy+bn
X-Received: by 2002:a50:d80c:: with SMTP id o12mr7284900edj.338.1611154376376;
        Wed, 20 Jan 2021 06:52:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxG2iPdBowp0p+m+2+XBgbeuH1LGwsO5EHdrCogkKJ6IYhKcRmN6vnlYe9fs7MdUSBC/ngZ6w==
X-Received: by 2002:a50:d80c:: with SMTP id o12mr7284883edj.338.1611154375961;
        Wed, 20 Jan 2021 06:52:55 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z22sm1210969edb.88.2021.01.20.06.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:52:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 10D77180331; Wed, 20 Jan 2021 15:52:55 +0100 (CET)
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
In-Reply-To: <996f1ff7-5891-fd4a-ee3e-fefd7e93879d@intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-2-bjorn.topel@gmail.com> <87bldjeq1j.fsf@toke.dk>
 <996f1ff7-5891-fd4a-ee3e-fefd7e93879d@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jan 2021 15:52:55 +0100
Message-ID: <87mtx34q48.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-01-20 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>=20
>>> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>>>
>>> The XDP_REDIRECT implementations for maps and non-maps are fairly
>>> similar, but obviously need to take different code paths depending on
>>> if the target is using a map or not. Today, the redirect targets for
>>> XDP either uses a map, or is based on ifindex.
>>>
>>> Future commits will introduce yet another redirect target via the a
>>> new helper, bpf_redirect_xsk(). To pave the way for that, we introduce
>>> an explicit redirect type to bpf_redirect_info. This makes the code
>>> easier to follow, and makes it easier to add new redirect targets.
>>>
>>> Further, using an explicit type in bpf_redirect_info has a slight
>>> positive performance impact by avoiding a pointer indirection for the
>>> map type lookup, and instead use the hot cacheline for
>>> bpf_redirect_info.
>>>
>>> The bpf_redirect_info flags member is not used by XDP, and not
>>> read/written any more. The map member is only written to when
>>> required/used, and not unconditionally.
>>=20
>> I like the simplification. However, the handling of map clearing becomes
>> a bit murky with this change:
>>=20
>> You're not changing anything in bpf_clear_redirect_map(), and you're
>> removing most of the reads and writes of ri->map. Instead,
>> bpf_xdp_redirect_map() will store the bpf_dtab_netdev pointer in
>> ri->tgt_value, which xdp_do_redirect() will just read and use without
>> checking. But if the map element (or the entire map) has been freed in
>> the meantime that will be a dangling pointer. I *think* the RCU callback
>> in dev_map_delete_elem() and the rcu_barrier() in dev_map_free()
>> protects against this, but that is by no means obvious. So confirming
>> this, and explaining it in a comment would be good.
>>
>
> Yes, *most* of the READ_ONCE(ri->map) are removed, it's pretty much only=
=20
> the bpf_redirect_map(), and as you write, the tracepoints.
>
> The content/element of the map is RCU protected, and actually even the
> map will be around until the XDP processing is complete. Note the
> synchronize_rcu() followed after all bpf_clear_redirect_map() calls.
>
> I'll try to make it clearer in the commit message! Thanks for pointing=20
> that out!
>
>> Also, as far as I can tell after this, ri->map is only used for the
>> tracepoint. So how about just storing the map ID and getting rid of the
>> READ/WRITE_ONCE() entirely?
>>
>
> ...and the bpf_redirect_map() helper. Don't you think the current
> READ_ONCE(ri->map) scheme is more obvious/clear?

Yeah, after your patch we WRITE_ONCE() the pointer in
bpf_redirect_map(), but the only place it is actually *read* is in the
tracepoint. So the only purpose of bpf_clear_redirect_map() is to ensure
that an invalid pointer is not read in the tracepoint function. Which
seems a bit excessive when we could just store the map ID for direct use
in the tracepoint and get rid of bpf_clear_redirect_map() entirely, no?

Besides, from a UX point of view, having the tracepoint display the map
ID even if that map ID is no longer valid seems to me like it makes more
sense than just displaying a map ID of 0 and leaving it up to the user
to figure out that this is because the map was cleared. I mean, at the
time the redirect was made, that *was* the map ID that was used...

Oh, and as you say due to the synchronize_rcu() call in dev_map_free() I
think this whole discussion is superfluous anyway, since it can't
actually happen that the map gets freed between the setting and reading
of ri->map, no?

>> (Oh, and related to this I think this patch set will conflict with
>> Hangbin's multi-redirect series, so maybe you two ought to coordinate? :=
))
>>
>
> Yeah, good idea! I would guess Hangbin's would go in before this, so I
> would need to adapt.
>
>
> Thanks for taking of look at the series, Toke! Much appreciated!

You're welcome :)

-Toke

