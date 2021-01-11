Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A742F1C19
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389487AbhAKRSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728553AbhAKRSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:18:10 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75F2C061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:17:29 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id j18so7746661qvu.3
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uszYj5lEvhFLLbJXZOIO6BRSOL2kmx/dGu1iJ8EpN3c=;
        b=NWRVNMJZjsaeJGlQ0AYMg3t8T+PRJlnaUjFpJnhLfHj2pUqJxRHyV+GoSbNjmyTKLj
         /D5FTOl84mP9nQeEAX39Ed2choLmw9U0m74AkpcjiOMsX8/BqqV6D8vGgo7MvjhDQvcH
         NlPr1AYrFnj5B3bhFk4m5Sjk+tuY8JnfwO5wODUkqQNqXrZiloqE5lMYduhrVygDQJ2R
         HbamMDzHGPasVKqIbLHhdQX4ycvjnLvr3NydTAvssRyvQsbkMV13PQ+a25b+NL6wu8bX
         mbqL9gF/biJvGpnBCaGlf+UeJCs0Ycn8mfDQdbuDENkqG6zno9AktnMdbtoa+5b3HnwV
         8Clw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uszYj5lEvhFLLbJXZOIO6BRSOL2kmx/dGu1iJ8EpN3c=;
        b=aTy9U/9T4kT/XsTqTuQB7uvkUuz084f30eKKTLX22MfKlLQhpMNRyX7fR+wlfsm+4a
         Co32/u42sK1jmExYhA763u+qfGyE7Z+64gC7yQokPM7egz7xnLW9PbrWb7KaGlLRol6t
         SXawmyVik7BdV0nEnEuvr2UIjynk/zgVeedCZYPhWR5kSK7OEQO9oC9z+eGQS+nomxrz
         rblDiT1XK2XnVuQmFGf0Dg0LuXkoZiBiqT4zXRK/FBvG0UYmFFqpFSBu6JQuDhVhiA/9
         vYAB5JQP+xkbhX6oFTdBmBpnVwQx6/bBm6V0yuF+hG0/baYLXe2UVaL1/6fV03kr51yo
         yuWg==
X-Gm-Message-State: AOAM531zhFz/m7Xo5J+sTLqEYTKr7vv2g7IDWuej4IK9ivQkdT7MZjo7
        GEy8nCQVXmEZL+rEYA0ohVlXGkJBJ18ztmWLOCNpzA==
X-Google-Smtp-Source: ABdhPJw6I2yYlwm+deLHUrwu9LaUvxdgAFOGdkQIRgIjEiyrpCC0Pl+H4llJ16MYFAWGBuMhuVrPQ+hxuQav6karIeU=
X-Received: by 2002:a0c:8304:: with SMTP id j4mr665451qva.18.1610385448636;
 Mon, 11 Jan 2021 09:17:28 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com>
 <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
 <CACT4Y+Y9H4xB_4sS9Hu6e+u=tmYXcw6PFB0LY4FRuGQ6HCywrA@mail.gmail.com>
 <CAGXu5j+jzmkiU_AWoTVF6e263iYSSJYUHB=Kdqh-MCfEO-aNSg@mail.gmail.com> <CACT4Y+b1nmsQBx=dD=Q9_y_GZx1PpqTbzR6j=u5UecQ0JLyMFg@mail.gmail.com>
In-Reply-To: <CACT4Y+b1nmsQBx=dD=Q9_y_GZx1PpqTbzR6j=u5UecQ0JLyMFg@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 11 Jan 2021 18:17:17 +0100
Message-ID: <CACT4Y+YYU6P1joGcNe9+E97-VACqs=5rcmOQerh2ju90R5Nfkg@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     Kees Cook <keescook@chromium.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 9, 2021 at 10:46 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Fri, Jan 8, 2021 at 9:26 PM Kees Cook <keescook@chromium.org> wrote:
> >> On Thu, Jan 7, 2021 at 8:00 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >> > > >
> >> > > > Hi Dmitry,
> >> > > >
> >> > > > On Mon, Dec 21, 2020 at 10:14 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> >> > > > > Hi Jason,
> >> > > > >
> >> > > > > Thanks for looking into this.
> >> > > > >
> >> > > > > Reading clang docs for ubsan:
> >> > > > >
> >> > > > > https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
> >> > > > > -fsanitize=object-size: An attempt to potentially use bytes which the
> >> > > > > optimizer can determine are not part of the object being accessed.
> >> > > > > This will also detect some types of undefined behavior that may not
> >> > > > > directly access memory, but are provably incorrect given the size of
> >> > > > > the objects involved, such as invalid downcasts and calling methods on
> >> > > > > invalid pointers. These checks are made in terms of
> >> > > > > __builtin_object_size, and consequently may be able to detect more
> >> > > > > problems at higher optimization levels.
> >> > > > >
> >> > > > > From skimming though your description this seems to fall into
> >> > > > > "provably incorrect given the size of the objects involved".
> >> > > > > I guess it's one of these cases which trigger undefined behavior and
> >> > > > > compiler can e.g. remove all of this code assuming it will be never
> >> > > > > called at runtime and any branches leading to it will always branch in
> >> > > > > other directions, or something.
> >> > > >
> >> > > > Right that sort of makes sense, and I can imagine that in more general
> >> > > > cases the struct casting could lead to UB. But what has me scratching
> >> > > > my head is that syzbot couldn't reproduce. The cast happens every
> >> > > > time. What about that one time was special? Did the address happen to
> >> > > > fall on the border of a mapping? Is UBSAN non-deterministic as an
> >> > > > optimization? Or is there actually some mysterious UaF happening with
> >> > > > my usage of skbs that I shouldn't overlook?
> >> > >
> >> > > These UBSAN checks were just enabled recently.
> >> > > It's indeed super easy to trigger: 133083 VMs were crashed on this already:
> >> > > https://syzkaller.appspot.com/bug?extid=8f90d005ab2d22342b6d
> >> > > So it's one of the top crashers by now.
> >> >
> >> > Ahh, makes sense. So it is easily reproducible after all.
> >> >
> >> > You're still of the opinion that it's a false positive, right? I
> >> > shouldn't spend more cycles on this?
> >>
> >> No, I am not saying this is a false positive. I think it's an
> >> undefined behavior.
> >>
> >> Either way, we need to resolve this one way or another to unblock
> >> testing the rest of the kernel, if not with a fix to wg, then with a
> >> fix to ubsan, or disable this check for kernel if kernel community
> >> decides we want to use and keep this type of C undefined behavior in
> >> the code base intentionally.
> >> So far I see only 2 "UBSAN: object-size-mismatch" reports on the dashboard:
> >> https://syzkaller.appspot.com/upstream
> >> So cleaning them up looks doable. Is there a way to restructure the
> >> code to not invoke undefined behavior?
> >
> >
> > Right; that's my question as well.
> >
> >>
> >> Kees, do you have any suggestions on how to proceed? This seems to
> >> stop testing of the whole kernel at the moment.
> >
> >
> > If it's blocking other stuff and there isn't a path to fixing it soon, then I think we'll need to disable this check (and open an issue to track it).
>
> Oh, I see, the code is actually in skbuff.h:
>
> static inline void __skb_queue_tail(struct sk_buff_head *list, struct
> sk_buff *newsk)
> {
>     __skb_queue_before(list, (struct sk_buff *)list, newsk);
> }
>
> It casts sk_buff_head to sk_buff relying on equal layout of some
> prefix of these structs.
> Is it really UB in C? UBSAN docs say:
> "An attempt to potentially use bytes which the optimizer can determine
> are not part of the object being accessed".
> But C has POD layout for structs, right? These next/prev fields are
> within sk_buff_head (otherwise things would explode).
> I can imagine this may be not valid in C++, can this UBSAN check be
> C++-specific? Or at least some subset of this check, I can imagine it
> can detect bad bugs in C as well where things go really wrong.
>
> If there is no quick solution proposed, I tend to disable this check
> in syzbot for now. We need to clean at least common things like
> sk_buff first.


FTR, I've disabled the following UBSAN configs:
UBSAN_MISC
UBSAN_DIV_ZERO
UBSAN_BOOL
UBSAN_OBJECT_SIZE
UBSAN_SIGNED_OVERFLOW
UBSAN_UNSIGNED_OVERFLOW
UBSAN_ENUM
UBSAN_ALIGNMENT
UBSAN_UNREACHABLE

Only these are enabled now:
UBSAN_BOUNDS
UBSAN_SHIFT

This is commit:
https://github.com/google/syzkaller/commit/2c1f2513486f21d26b1942ce77ffc782677fbf4e
