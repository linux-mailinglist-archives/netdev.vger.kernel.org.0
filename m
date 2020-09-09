Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60A3263216
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731055AbgIIQe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731096AbgIIQem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:34:42 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CD0C061573;
        Wed,  9 Sep 2020 09:34:42 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id q3so2166714ybp.7;
        Wed, 09 Sep 2020 09:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bz7rEhxYp3SlW/L1/DoGXJkXqWRJ/MVplIqXHQoZUfk=;
        b=pd+uoqlqxUrm3nzrqpIm3QY0eORPpJdndeSmE3zYpQOjab2SWJP5nT9bkG8XyMGek7
         5ZOn31GidWomgOQ95C89K4nHkekGR+OLHloxGd8JsrOJAcYwhdp4rQMCDmrnXrpXOA4T
         IwYYIWT2LUnrUPNUt0rpM0PvvFkbOTo9nh1adsjT+yV4MFTJwuCb1p/wsfBtF58ZX4W2
         NHTnJHQ+7dDxNWaC+iRO0ZLYugububaNnN5l9rEoz3faVAxVXTC+uzq94+BBSyoCjbgV
         En4tI5Ivw/xb8A1ltryznSdezcjEOyJU2PmTxZKWHdN70nscv8qFx87G9uz2So8ZotLb
         v7vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bz7rEhxYp3SlW/L1/DoGXJkXqWRJ/MVplIqXHQoZUfk=;
        b=Db91r8RS9V7esJZeALD/23Lcn8DqQDLp6/Z8uK8HAhvw7k33xW34TUgJg4AtwuZ8cJ
         aeLu0zCoKGGKUSCe3oKQ/1t/abuhgcV/5TRm/MItllNG7mhAeqU/6Hr2g5FFdoubZdi6
         xfWFG1+uiIWFt3HIx/0qo93tY+0Et42dGFDGu4lstQSH56cDKs2hyJCmkBqAcTEve2/g
         LW90VPjBBNvP3Y6OcAILP5eTCGxC9Nck/6QtPoiCJU9iDV6TiblKYXD5wyKps9y+319e
         oQI5516zM5Lx0aph6fCtS0aPIF4pa43jkXbi/a7DhzkeRI0kgRTdE31rLpy/tj9c0tZq
         72Mw==
X-Gm-Message-State: AOAM5320fL/Y7no9iceUQ1fhwUy/RIixrjcB3HQcNrVlBPM3fD6ufTeX
        ccEAGL1RzDFFNfeVTw5F+Q4EHj0pxiKEUK/EeX8=
X-Google-Smtp-Source: ABdhPJzekXdvMgtQk4KQkK6/fwW8QtqagN0dvuxWXPqC4jSpt6DayWXW1Yl0yqXIb/SnyhiEIG68rt3sjYsxBKvouiQ=
X-Received: by 2002:a25:6885:: with SMTP id d127mr6560959ybc.27.1599669281507;
 Wed, 09 Sep 2020 09:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
 <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com>
 <87mu22ottv.fsf@toke.dk> <CAEf4BzbywFBSW+KypeWkG7CF8rNSu5XxS8HZz7BFuUsC9kZ1ug@mail.gmail.com>
 <87eenbnrmy.fsf@toke.dk>
In-Reply-To: <87eenbnrmy.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 09:34:30 -0700
Message-ID: <CAEf4BzaiwjLkKpJHgU3i0r0REPVOc6zEgF2MUHNBfGQ9S=gz_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Sep 7, 2020 at 1:49 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> >> May be we should talk about problem statement and goals.
> >> >> Do we actually need metadata per program or metadata per single .o
> >> >> or metadata per final .o with multiple .o linked together?
> >> >> What is this metadata?
> >> >
> >> > Yep, that's a very valid question. I've also CC'ed Andrey.
> >>
> >> For the libxdp use case, I need metadata per program. But I'm already
> >> sticking that in a single section and disambiguating by struct name
> >> (just prefixing the function name with a _ ), so I think it's fine to
> >> have this kind of "concatenated metadata" per elf file and parse out t=
he
> >> per-program information from that. This is similar to the BTF-encoded
> >> "metadata" we can do today.
> >>
> >> >> If it's just unreferenced by program read only data then no special=
 names or
> >> >> prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any=
 map to any
> >> >> program and it would be up to tooling to decide the meaning of the =
data in the
> >> >> map. For example, bpftool can choose to print all variables from al=
l read only
> >> >> maps that match "bpf_metadata_" prefix, but it will be bpftool conv=
ention only
> >> >> and not hard coded in libbpf.
> >> >
> >> > Agree as well. It feels a bit odd for libbpf to handle ".metadata"
> >> > specially, given libbpf itself doesn't care about its contents at al=
l.
> >> >
> >> > So thanks for bringing this up, I think this is an important
> >> > discussion to have.
> >>
> >> I'm fine with having this be part of .rodata. One drawback, though, is
> >> that if any metadata is defined, it becomes a bit more complicated to
> >> use bpf_map__set_initial_value() because that now also has to include
> >> the metadata. Any way we can improve upon that?
> >
> > I know that skeleton is not an answer for you, so you'll have to find
> > DATASEC and corresponding variable offset and size (libbpf provides
> > APIs for all those operations, but you'll need to combine them
> > together). Then mmap() map and then you can do partial updates. There
> > is no other way to update only portions of an ARRAY map, except
> > through memory-mapping.
>
> Well, I wouldn't mind having to go digging through the section. But is
> it really possible to pick out and modify parts of it my mmap() before
> the object is loaded (and the map frozen)? How? I seem to recall we
> added bpf_map__set_initial_value() because this was *not* possible with
> the public API?
>

Ah, right, .rodata is frozen on load, forgot we are talking about .rodata h=
ere.


> Also, for this, a bpf_map__get_initial_value() could be a simple way to
> allow partial modifications. The caller could just get the whole map
> value, modify it, and set it again afterwards with
> __set_initial_value(). Any objections to adding that?

Yeah, I think having an API for getting initial map value makes sense.
But please follow the naming convention for getters and call it
bpf_map__initial_value().

>
> -Toke
>
