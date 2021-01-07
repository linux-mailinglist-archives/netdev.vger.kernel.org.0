Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB87D2ECF8C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 13:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhAGMXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 07:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbhAGMXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 07:23:21 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882C1C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 04:22:40 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id h16so2632029qvu.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 04:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdNXcZN7MbGtSRJVA62Glhr7KIdj4Wp2fgKjinrNPrw=;
        b=jm4J5bf0DQ6WhBilsZPO2rABFj2B8U74PrfGHDS951rlkRBK3RmTmCs+R//8YhBFXK
         s+6SvYeOOjwXtTClgd0IHcuXTIPKCtyF0JUF2B0QhrAkmBh6MZ7h+4tVC7v53471RzBM
         fxx86lwFFNebk42NlIWoV5+y7i9QZIclOGI5GgY2SYh+ZXiR1yfHUppwKv3HUlxGRQXV
         FUFh+qzFGiiOFKxu/+PscZuhGWIaCYaYL+7qg52cpPlAZQ6jkywG7ud+DjmBCe1amSir
         8d9ErsMSrNCnOqyeI1T6fmqU+YfjymdENt02WKr36r/PsvmOe5xiB9NoVYzAFcs1ih/O
         OY8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdNXcZN7MbGtSRJVA62Glhr7KIdj4Wp2fgKjinrNPrw=;
        b=gPAReID1s0WYwcUdj6r1q/94mHeHw9oRt/7qmHl6U25FC8RRAdBX2zuxbTHSthpqdT
         2779k0/s1A5jZdssnlmvGgFN2tiwXIxgxgaSoCvZ/G9XIWQDYWl7Zjm4w+fI69cKPAEQ
         ioNlBaL1sni2WeBUstHZO+7wGcRJZPeec1vDHpsj9MqjQJJBN6b8Ufk3kCs5SYo86wzG
         wkU5XUziTy01i+HyxYL4J5IAKEQ72WhNlOlBNjmlkyZJSIacP2qIdUnJK4QcTaglHIAS
         Bqig0WaTXuQPhF31c3psgVmF8FROSowpRTn9qBetknm66YCTixk0D8DNKS3S6UqdZIPm
         mY2Q==
X-Gm-Message-State: AOAM530X/55BlvswVsY19mBAbTpk/kFYW/zt2ycgQTqxX3E8mIr1+ubc
        ofNKW/7Xuf7eSwPY6+9BWY0l6wN+e9lZut4DQ68VZA==
X-Google-Smtp-Source: ABdhPJzCJoJW5wPCb3Yz6y1rcW7AEKqEzyDZyoWAXfM1lzVFnxoav54OHxx4TwopnGNBe2Vi96hpx+gSyMtI75D8Qzw=
X-Received: by 2002:a05:6214:487:: with SMTP id ay7mr1615002qvb.37.1610022159411;
 Thu, 07 Jan 2021 04:22:39 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com> <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
In-Reply-To: <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 7 Jan 2021 13:22:27 +0100
Message-ID: <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com>
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

On Mon, Dec 21, 2020 at 12:23 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Dmitry,
>
> On Mon, Dec 21, 2020 at 10:14 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > Hi Jason,
> >
> > Thanks for looking into this.
> >
> > Reading clang docs for ubsan:
> >
> > https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
> > -fsanitize=object-size: An attempt to potentially use bytes which the
> > optimizer can determine are not part of the object being accessed.
> > This will also detect some types of undefined behavior that may not
> > directly access memory, but are provably incorrect given the size of
> > the objects involved, such as invalid downcasts and calling methods on
> > invalid pointers. These checks are made in terms of
> > __builtin_object_size, and consequently may be able to detect more
> > problems at higher optimization levels.
> >
> > From skimming though your description this seems to fall into
> > "provably incorrect given the size of the objects involved".
> > I guess it's one of these cases which trigger undefined behavior and
> > compiler can e.g. remove all of this code assuming it will be never
> > called at runtime and any branches leading to it will always branch in
> > other directions, or something.
>
> Right that sort of makes sense, and I can imagine that in more general
> cases the struct casting could lead to UB. But what has me scratching
> my head is that syzbot couldn't reproduce. The cast happens every
> time. What about that one time was special? Did the address happen to
> fall on the border of a mapping? Is UBSAN non-deterministic as an
> optimization? Or is there actually some mysterious UaF happening with
> my usage of skbs that I shouldn't overlook?

These UBSAN checks were just enabled recently.
It's indeed super easy to trigger: 133083 VMs were crashed on this already:
https://syzkaller.appspot.com/bug?extid=8f90d005ab2d22342b6d
So it's one of the top crashers by now.
