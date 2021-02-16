Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EEE31C8EE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhBPKie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:38:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229761AbhBPKi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:38:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613471821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8rs5zW1or0x3SgRQjoDUd0UE+g7JCYAEd7GiRX8HiGs=;
        b=ULSZG/PzL7HqlRgeSeYeVLwgZQXFgryKJoCgYoAPE7Cf1PuINHIhMFZqyj7G3FPTGdJ8M5
        Dvhf7fJWet7ACNHP0Tm+IkIwklbHpnzbTWwK3rQFwgHZBhEOXdGyXaplBlZXtrfbYd4HhC
        FBHtweyiZHIfoGNt/lzPNyp/RtBm/ic=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-a42AmJQhMHmhBQnZIOOBYw-1; Tue, 16 Feb 2021 05:36:59 -0500
X-MC-Unique: a42AmJQhMHmhBQnZIOOBYw-1
Received: by mail-ed1-f70.google.com with SMTP id bo11so7122922edb.0
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:36:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8rs5zW1or0x3SgRQjoDUd0UE+g7JCYAEd7GiRX8HiGs=;
        b=nhBHTOmBo3/4kfRR8iUE6EtkMOOc1oKQnyjS0zsVLnB7mmI/CV2D4G1aVQDgi4kxPw
         iza0vYgDy/LPprdLJiOQPqoRygbzH8ewPFhep6R0CstJDi2Rh0XfbD1RWiSKjT532Czr
         llhwWKAGt0qDgkBJYozvhllHNusoBctDynNx0H7Po0zoLPae4XBdDBNl7imaAHNbwq6c
         XPJO3ai/O4XHPHkSjd0COfH+aVkxmW/u+68u180PYSIlsHvjQzt7JB81ujTRyE5Hz3SB
         4F8d8htjZMAnPUwRD/FaPLjOgCH4x9lClcPnXcm5mxqe8Jfr8+1SujJazK1Fh5C1a+ns
         vckQ==
X-Gm-Message-State: AOAM532RBFy9+d4NFI6PEtcSNDjtFtPdx6oIVzzk1PrtxWErQTNDqAXc
        n7ibNHqqXaCtT5K8100Muf1clVJx3jdTbyPY90tPwSBZiRuF8D/gstO/nHKiNj3c5Ugf/fPwogk
        EK8vfSdkkEd5/ADhE
X-Received: by 2002:a17:906:54b:: with SMTP id k11mr18804549eja.495.1613471818112;
        Tue, 16 Feb 2021 02:36:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6vHFODLJBF9abhWybbR0ngnRu1I7OKFSuPKOlnBmdqRflzF2uUISKl8pP/YmnNJfq0pWcbw==
X-Received: by 2002:a17:906:54b:: with SMTP id k11mr18804534eja.495.1613471817826;
        Tue, 16 Feb 2021 02:36:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id hr3sm12383053ejc.41.2021.02.16.02.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:36:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 199C71805FA; Tue, 16 Feb 2021 11:36:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
In-Reply-To: <602b0f54c05a6_3ed41208dc@john-XPS-13-9370.notmuch>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk> <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
 <8735xxc8pf.fsf@toke.dk>
 <602b0f54c05a6_3ed41208dc@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Feb 2021 11:36:57 +0100
Message-ID: <87pn10b8om.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> John Fastabend <john.fastabend@gmail.com> writes:
>>=20
>> >> > However, in libxdp we can solve the original problem in a different=
 way,
>> >> > and in fact I already suggested to Magnus that we should do this (s=
ee
>> >> > [1]); so one way forward could be to address it during the merge in
>> >> > libxdp? It should be possible to address the original issue (two
>> >> > instances of xdpsock breaking each other when they exit), but
>> >> > applications will still need to do an explicit unload operation bef=
ore
>> >> > exiting (i.e., the automatic detach on bpf_link fd closure will take
>> >> > more work, and likely require extending the bpf_link kernel support=
)...
>> >> >
>> >>=20
>> >> I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
>> >> we're months ahead, then I'd really like to see this in libbpf until =
the
>> >> merge. However, I'll leave that for Magnus/you to decide!
>> >
>> > Did I miss some thread? What does this mean libbpf 1.0/libxdp merge?
>>=20
>> The idea is to keep libbpf focused on bpf, and move the AF_XDP stuff to
>> libxdp (so the socket stuff in xsk.h). We're adding the existing code
>> wholesale, and keeping API compatibility during the move, so all that's
>> needed is adding -lxdp when compiling. And obviously the existing libbpf
>> code isn't going anywhere until such a time as there's a general
>> backwards compatibility-breaking deprecation in libbpf (which I believe
>> Andrii is planning to do in an upcoming and as-of-yet unannounced v1.0
>> release).
>
> OK, I would like to keep the basic XDP pieces in libbpf though. For examp=
le
> bpf_program__attach_xdp(). This way we don't have one lib to attach
> everything, but XDP.

The details are still TDB; for now, we're just merging in the XSK code
to the libxdp repo. I expect Andrii to announce his plans for the rest
soonish. I wouldn't expect basic things like that to go away, though :)

>>=20
>> While integrating the XSK code into libxdp we're trying to make it
>> compatible with the rest of the library (i.e., multi-prog). Hence my
>> preference to avoid introducing something that makes this harder :)
>>=20
>> -Toke
>>=20
>
> OK that makes sense to me thanks. But, I'm missing something (maybe its
> obvious to everyone else?).
>
> When you load an XDP program you should get a reference to it. And then
> XDP program should never be unloaded until that id is removed right? It
> may or may not have an xsk map. Why does adding/removing programs from
> an associated map have any impact on the XDP program? That seems like
> the buggy part to me. No other map behaves this way as far as I can
> tell. Now if the program with the XDP reference closes without pinning
> the map or otherwise doing something with it, sure the map gets destroyed
> and any xsk sockets are lost.

The original bug comes from the XSK code abstracting away the fact that
an AF_XDP socket needs an XDP program on the interface to work; so if
none exists, the library will just load a program that redirects into
the socket. Which breaks since the xdpsock example application is trying
to be nice and clean up after itself, by removing the XDP program when
it's done with the socket, thus breaking any other programs using that
XDP program. So this patch introduces proper synchronisation on both add
and remove of the XDP program...

-Toke

