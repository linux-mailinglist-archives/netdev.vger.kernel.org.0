Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DD6FFAD9
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 18:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfKQRRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 12:17:24 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33850 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfKQRRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 12:17:23 -0500
Received: by mail-qk1-f194.google.com with SMTP id 205so12430013qkk.1;
        Sun, 17 Nov 2019 09:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fx2VciQBT28HKq8nonJlVkforLB2KkAFigbIrUjR1KA=;
        b=t3BAY68WAJeRiYC3pBuxRoVQbqAAR6l55EdGe2VcOJwVpMbJ1YnxkmVjG9SVSYJcNI
         X/HUgFtI1vAxAjUwqpnWqScIoo6B7AlKsGYXRv6xFawMMoX6W7jSO2BdsvVe/3XhHWdk
         cisj9ZhSbNJ+wrQoGUPLe4+aiK843lEgs0xLDGlwhReemNER+s1uBKkEyMDVZkBW38qU
         lzVaQLsQTFv3GbRnaJQdxsoDRcfdX23u5ayr3up/dw3nWSTEepldI4h+tebrsyeKHLy8
         SqQ9lcIPZhYQyu0HwaHxRU/0x0N3u3hgBZ11i/Bn0P0ujvvNjGboBtdVcxLtMwk6WITG
         2RUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fx2VciQBT28HKq8nonJlVkforLB2KkAFigbIrUjR1KA=;
        b=Vxy2SkhL3nI7yX9s/aE0P1mWn5ACOfimsmV1v9QdK0eLfImwwF5Xjx7eZQBIzyNuJ8
         ilIDJd9v4B/3uokMlWJPkXumA2o9+vYYbowr0SVNOOyMO8FVZhj944ez+TsaKgglgIBK
         pbmhLzO2vDI9f2J5uB4iuGgLnANVUpTLCWWloKTRYVZDirpAo42gwHBMLOaYL7nSt346
         /3B/TejCvDUsXvL+VWCBva6uGf8ffDaixNztjb6fGVj/oYkKdkz67OHnuzCPClJLyX2i
         d3gwg09xC1QacTQVEwbl+Tg9c/Q6Tn/KOW8vWNc1F8i4tHBDKieHk2eW/Qj9MD7uotpD
         AJfQ==
X-Gm-Message-State: APjAAAXl5hgAgDOshKQ1PKhbBltJcbe8K73PCn2vlCXjJ9RbwbvPR4VT
        fbCwURZNADpbWeURMzzhZQ0gbahbTD+y7Z3dEI4=
X-Google-Smtp-Source: APXvYqzFIhKSrcizELW9CRuMzL5BonrNPxpHZZnfEQXo3c64TVkFMIbyEltDE7kJ1adg7lBp2707N6G77v1zTfMRvDs=
X-Received: by 2002:a37:b3c4:: with SMTP id c187mr8848861qkf.36.1574011041899;
 Sun, 17 Nov 2019 09:17:21 -0800 (PST)
MIME-Version: 1.0
References: <20191115040225.2147245-1-andriin@fb.com> <20191115040225.2147245-3-andriin@fb.com>
 <888858f7-97fb-4434-4440-a5c0ec5cbac8@iogearbox.net> <293bb2fe-7599-3825-1bfe-d52224e5c357@fb.com>
 <3287b984-6335-cacb-da28-3d374afb7f77@iogearbox.net> <fe46c471-e345-b7e4-ab91-8ef044fd58ae@fb.com>
 <c79ca69f-84fd-bfc2-71fd-439bc3b94c81@iogearbox.net> <3eca5e22-f3ec-f05f-0776-4635b14c2a4e@fb.com>
 <CAEf4BzZHT=Gwor_VA38Yoy6Lo7zeeiVeQK+KQpZUHRpnV6=fuA@mail.gmail.com> <3a99d3af-97e7-3d6d-0a9c-46fb8104a211@iogearbox.net>
In-Reply-To: <3a99d3af-97e7-3d6d-0a9c-46fb8104a211@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 17 Nov 2019 09:17:10 -0800
Message-ID: <CAEf4BzbyHn5JOf6=S6g=Qr15evEbwmMO3F4QCC9hkU0hpJcA4g@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 17, 2019 at 4:07 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/17/19 6:57 AM, Andrii Nakryiko wrote:
> > On Fri, Nov 15, 2019 at 5:18 PM Alexei Starovoitov <ast@fb.com> wrote:
> >> On 11/15/19 4:13 PM, Daniel Borkmann wrote:
> >>>>> Yeah, only for fd array currently. Question is, if we ever reuse that
> >>>>> map_release_uref
> >>>>> callback in future for something else, will we remember that we earlier
> >>>>> missed to add
> >>>>> it here? :/
> >>>>
> >>>> What do you mean 'missed to add' ?
> >>>
> >>> Was saying missed to add the inc/put for the uref counter.
> >>>
> >>>> This is mmap path. Anything that needs releasing (like FDs for
> >>>> prog_array or progs for sockmap) cannot be mmap-able.
> >>>
> >>> Right, I meant if in future we ever have another use case outside of it
> >>> for some reason (unrelated to those maps you mention above). Can we
> >>> guarantee this is never going to happen? Seemed less fragile at least to
> >>> maintain proper count here.
> >
> > I don't think we'll ever going to allow mmaping anything that contains
> > not just pure data. E.g., we disallow mmaping array that contains spin
> > lock for that reason. So I think it's safe to assume that this is not
> > going to happen even for future maps. At least not without some
> > serious considerations before that. So I'm going to keep it as just
> > plain bpf_map_inc for now.
>
> Fair enough, then keep it as it is. The purpose of the uref counter is to
> track whatever map holds a reference either in form of fd or inode in bpf
> fs which are the only two things till now where user space can refer to the
> map, and once it hits 0, we perform the map's map_release_uref() callback.

To be honest, I don't exactly understand why we need both refcnt and
usercnt. Does it have anything to do with some circular dependencies
for those maps containing other FDs? And once userspace doesn't have
any more referenced, we release FDs, which might decrement refcnt,
thus breaking circular refcnt between map FD and special FDs inside a
map? Or that's not the case and there is a different reason?

Either way, I looked at map creation and bpf_map_release()
implementation again. map_create() does set usercnt to 1, and
bpf_map_release(), which I assume is called when map FD is closed,
does decrement usercnt, so yeah, we do with_uref() manipulations for
cases when userspace maintains some sort of handle to map. In that
regard, mmap() does fall into the same category, so I'm going to
convert everything mmap-related back to
bpf_map_inc_with_uref()/bpf_map_put_with_uref(), to stay consistent.

>
> The fact that some maps make use of it and some others not is an implementation
> detail in my opinion, but the concept itself is generic and can be used by
> whatever map implementation would need it in future. From my perspective not
> breaking with this semantic would allow to worry about one less issue once
> this callback gets reused for whatever reason.
>
> As I understand, from your PoV, you think that this uref counter is and will
> be exactly only tied to the fd based maps that currently use it and given
> they understandably won't ever need a mmap interface we don't need to inc/dec
> it there.
>
> Fair enough, but could we add some assertion then which adds a check if a map
> ever uses both that we bail out so we don't forget about this detail in a few
> weeks from now? Given complexity we have in our BPF codebase these days, I'm
> mainly worried about the latter if we can catch such details with a trivial
> check easily, for example, it would be trivial enough to add a test for the
> existence of map_release_uref callback inside bpf_map_mmap() and bail out in
> order to guarantee this, similar as you do with the spinlock.
>
> > I'm going to convert bpf_prog_add/bpf_prog_inc, though, and will do it
> > as a separate patch, on top of bpf_map_inc refactor. It touches quite
> > a lot drivers, so would benefit from having being separate.
>
> Yeah, sounds good to me. Thanks for converting!
>
> >> I'm struggling to understand the concern.
> >> map-in-map, xskmap, socket local storage are doing bpf_map_inc(, false)
> >> when they need to hold the map. Why this case is any different?
>
> (See above.)
