Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A10E2EEFB5
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbhAHJbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbhAHJbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:31:52 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD3AC0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:31:12 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id n142so7970096qkn.2
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p7CNbpBSPccH1hb+rOXFyKre6l57s8q4kN69whC0CUA=;
        b=PON5AO4eW+/ghJflh3LQZgs+WZ1EHC8Nd8E5KV6f7ayftxXjHqEHs6PKdb1TI0TOK5
         kfunV287GgnbbyLZvvIS01QjckF31wMDtwwuzCp75UWrks3NetMTeQ/wKM8BLfRlvGOE
         dFbgjgMMVYvTwRi3pMmTwJtptWfgygzKs5L1ucjdzBUaQJd1n2xMx8cDXMAtTQBqDupb
         e09zd1igFfl0RvpZd8AMA/PN3tB4s5QtfRiZh32JbdmM0/zhJLDQo7csEpAjFIotKHn1
         hgk74uKVpjtM69HDGSPgt21JiuKPrd1jF0GBKCftPSm66QCmNDIr7ahta/yWtPrYoKPW
         KgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p7CNbpBSPccH1hb+rOXFyKre6l57s8q4kN69whC0CUA=;
        b=maFJZluTaY3W0rZtxYC1nF0ZxR71lx1ElHIpdvuTAzI7VQUF/KeU+fogndtaJ01DeK
         OAltPCTZbYbl/8cAcawrTO2aCtoegqhU8Pe94h9WVjUiaGSPxsyD9Yh+GMjjFdPSFtU1
         DaT/HFFXE2Mhq8fCjm1Z0pS2htF5jZOQsE+EagM2A/+mVsrFxJVHYMX/k20KGNRtHAoR
         bhagvINGAYjFrEwGg8UC8JALiBjhOdbb2nk5n60r8DEvjGLK/Ds4+RvvGBcO1lYcB+bt
         9IWFGE99m/aDMgiU+1TtKhzgeI93EKyj5BCkVgyrPOMID3wADmZ/bBIuOQEWZGAEXnqS
         9Oaw==
X-Gm-Message-State: AOAM531LA98kXPmv7YYCSmh+JH8VaNwadpAwcy3LEALQ3659emYBzkrA
        pyQ6ILGShR0tjTMJyNa7yKO+cYcr4TAXkeKH4iX6VA==
X-Google-Smtp-Source: ABdhPJzJO/zSnwxBxdr6K/8eZS9L3nj3Q2d85+ingXlR4tERBrTXG+6G2mop1D0cvjTAZ0IPyaaqZ+6JpZeI5+Dd2rI=
X-Received: by 2002:a05:620a:983:: with SMTP id x3mr3065038qkx.231.1610098271104;
 Fri, 08 Jan 2021 01:31:11 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com> <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
In-Reply-To: <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 8 Jan 2021 10:30:59 +0100
Message-ID: <CACT4Y+Y9H4xB_4sS9Hu6e+u=tmYXcw6PFB0LY4FRuGQ6HCywrA@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Kees Cook <keescook@google.com>, Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 8:00 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > Hi Dmitry,
> > >
> > > On Mon, Dec 21, 2020 at 10:14 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > Hi Jason,
> > > >
> > > > Thanks for looking into this.
> > > >
> > > > Reading clang docs for ubsan:
> > > >
> > > > https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
> > > > -fsanitize=object-size: An attempt to potentially use bytes which the
> > > > optimizer can determine are not part of the object being accessed.
> > > > This will also detect some types of undefined behavior that may not
> > > > directly access memory, but are provably incorrect given the size of
> > > > the objects involved, such as invalid downcasts and calling methods on
> > > > invalid pointers. These checks are made in terms of
> > > > __builtin_object_size, and consequently may be able to detect more
> > > > problems at higher optimization levels.
> > > >
> > > > From skimming though your description this seems to fall into
> > > > "provably incorrect given the size of the objects involved".
> > > > I guess it's one of these cases which trigger undefined behavior and
> > > > compiler can e.g. remove all of this code assuming it will be never
> > > > called at runtime and any branches leading to it will always branch in
> > > > other directions, or something.
> > >
> > > Right that sort of makes sense, and I can imagine that in more general
> > > cases the struct casting could lead to UB. But what has me scratching
> > > my head is that syzbot couldn't reproduce. The cast happens every
> > > time. What about that one time was special? Did the address happen to
> > > fall on the border of a mapping? Is UBSAN non-deterministic as an
> > > optimization? Or is there actually some mysterious UaF happening with
> > > my usage of skbs that I shouldn't overlook?
> >
> > These UBSAN checks were just enabled recently.
> > It's indeed super easy to trigger: 133083 VMs were crashed on this already:
> > https://syzkaller.appspot.com/bug?extid=8f90d005ab2d22342b6d
> > So it's one of the top crashers by now.
>
> Ahh, makes sense. So it is easily reproducible after all.
>
> You're still of the opinion that it's a false positive, right? I
> shouldn't spend more cycles on this?

No, I am not saying this is a false positive. I think it's an
undefined behavior.
Either way, we need to resolve this one way or another to unblock
testing the rest of the kernel, if not with a fix to wg, then with a
fix to ubsan, or disable this check for kernel if kernel community
decides we want to use and keep this type of C undefined behavior in
the code base intentionally.
So far I see only 2 "UBSAN: object-size-mismatch" reports on the dashboard:
https://syzkaller.appspot.com/upstream
So cleaning them up looks doable. Is there a way to restructure the
code to not invoke undefined behavior?
Kees, do you have any suggestions on how to proceed? This seems to
stop testing of the whole kernel at the moment.
