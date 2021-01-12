Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278D22F2BF1
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392896AbhALJzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403989AbhALJzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:55:13 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE45C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 01:54:33 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id z11so1332287qkj.7
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 01:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=10CJIM2rM2mJ9aVWIA2I7jcHcXtQB84Bk80ptrJq0V8=;
        b=Vo9Ojrd4yLCL5/SVDA2N51lnS5iTpF9rC3dXZePrI6iGCG66iPpnKaJD0R8sqm4ohY
         7WqKebFPP6p3R9bglrPDdWVmX4fI6ppNlN0L/taGQLHV8mWDu516SfmT+t8MRTFc2hJH
         2wAQelImSLmFX1QuTy/gjBcUbLLBaLTTmKmiC3kzh9okRlVXrOSVjIRqU1lDKI3tkWfR
         3aslyQO/0P/GjbH5kzNjc+f2idvvVgeUfWSqKo4UqD+UW1Yl9a32K3i7Q6hnc5/qpKXs
         apEKehHxuwi8VUOe4TJ5NDQtjViAD7s2vYYAbVjUBRRgZk8vj0gu+drnv3DxRRLKVPB5
         C2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=10CJIM2rM2mJ9aVWIA2I7jcHcXtQB84Bk80ptrJq0V8=;
        b=KqOJWT2F/ub/19nRKWDaCFnmD32WfroprpfM+Qzn9pMdNKDnJeUmdO1w1JXPjYfmyS
         jYmcUoFI3hwyfR/N4HNklL8fiWg1ANP9SpdBhRKApRnOWF67XqZnw3yGTG/IL1Fbxthv
         xbWp7hxeJzKw68KEBDQN20JnDkYpifp15VBViW8i5dXXhhMVOBVoK5TyTv4h6aOhx2e5
         9xTyrz0OKs/XCdE1vfiCFg6u1bT5Mt/21qRBED67xTt5ccVdMw3IkZdlWqBMr+G3R/hl
         lo4o8Mgj5yGo/H2Sep/B0uLi6XpostcVNUpWUmqCih5o3uj8ytO2HpFWLS/39AwibrLh
         ArBA==
X-Gm-Message-State: AOAM5337Kx6+H1wI6vE748HfSQdiUkll0D6U1q+cz4c8wY0Kg9stlKbX
        CCPwP0GNq2TuGKxbDUh3nw8gXJo9LUL5qbtPFnoceqxWJJs=
X-Google-Smtp-Source: ABdhPJyLNvDiCNdvrUNpG2lfSIuOc6C2ndaajcQ0FwKuGJE7bHbVY1ILCpFE04xAGwUsIxxQRSrdl293Nyb6JrYlzfE=
X-Received: by 2002:a37:9a97:: with SMTP id c145mr3648529qke.350.1610445272320;
 Tue, 12 Jan 2021 01:54:32 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com>
 <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
 <CACT4Y+Y9H4xB_4sS9Hu6e+u=tmYXcw6PFB0LY4FRuGQ6HCywrA@mail.gmail.com>
 <CAGXu5j+jzmkiU_AWoTVF6e263iYSSJYUHB=Kdqh-MCfEO-aNSg@mail.gmail.com>
 <CACT4Y+b1nmsQBx=dD=Q9_y_GZx1PpqTbzR6j=u5UecQ0JLyMFg@mail.gmail.com>
 <CACT4Y+YYU6P1joGcNe9+E97-VACqs=5rcmOQerh2ju90R5Nfkg@mail.gmail.com>
 <CAH8yC8ncN7YZT804Ram3aCzoRGjCGKXEEUKFaNsq1MxtW0Uw3g@mail.gmail.com>
 <CACT4Y+abV4iDXf9y-_HyH5jQhmn5+=md+C4n+-77q=+cbN-OZA@mail.gmail.com> <CAH8yC8m_H_VLWaomSku62k4BhwjFCZTB0Td4s17Wtb7tAH5Lqw@mail.gmail.com>
In-Reply-To: <CAH8yC8m_H_VLWaomSku62k4BhwjFCZTB0Td4s17Wtb7tAH5Lqw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 12 Jan 2021 10:54:20 +0100
Message-ID: <CACT4Y+bt8p=e9czrEDVu2+HiFOxQe4pxr8AOdz_fP8tvvWh1FA@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     noloader@gmail.com
Cc:     Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 7:15 PM Jeffrey Walton <noloader@gmail.com> wrote:
> > > > ...
> > > > FTR, I've disabled the following UBSAN configs:
> > > > UBSAN_MISC
> > > > UBSAN_DIV_ZERO
> > > > UBSAN_BOOL
> > > > UBSAN_OBJECT_SIZE
> > > > UBSAN_SIGNED_OVERFLOW
> > > > UBSAN_UNSIGNED_OVERFLOW
> > > > UBSAN_ENUM
> > > > UBSAN_ALIGNMENT
> > > > UBSAN_UNREACHABLE
> > > >
> > > > Only these are enabled now:
> > > > UBSAN_BOUNDS
> > > > UBSAN_SHIFT
> > > >
> > > > This is commit:
> > > > https://github.com/google/syzkaller/commit/2c1f2513486f21d26b1942ce77ffc782677fbf4e
> > >
> > > I think the commit cut too deep.
> > >
> > > The overflows are important if folks are building with compilers other than GCC.
> > >
> > > The aligned data accesses are important on platforms like MIPS64 and Sparc64.
> > >
> > > Object size is important because it catches destination buffer overflows.
> > >
> > > I don't know what's in miscellaneous. There may be something useful in there.
> >
> > Hi Jeff,
> >
> > See the commit for reasons why each of these is disabled.
> > E.g. object size, somebody first needs to fix bugs like this one.
> > While things like skbuff have these UBs on trivial workloads, there is
> > no point in involving fuzzing and making it crash on this trivial bug
> > all the time and stopping doing any other kernel testing as the
> > result.
>
> Going off-topic a bit, what would you suggest for UBSAN_OBJECT_SIZE?
>
> It seems to me object size checking is being conflated with object
> type. It seems to me they need to be split: UBSAN_OBJECT_SIZE for
> actual object sizes, and UBSAN_OBJECT_TYPE for the casts.
>
> I still have a bitter taste in my mouth from
> https://www.cvedetails.com/bugtraq-bid/57602/libupnp-Multiple-Buffer-Overflow-Vulnerabilities.html.
> I hate to see buffer checks go away. (And I realize the kernel folks
> are more skilled than the guy who wrote libupnp).
>
> Jeff

I've filed https://bugs.llvm.org/show_bug.cgi?id=48726 for this. Does
it capture what you are asking? Let's move the discussion re ubsan
there.

However, in the first place I am suggesting fixing the code. E.g. for
sk_buff I would assume it's relatively easily fixable. A
formally legal fix I think should put sk_buff_head into sk_buff and
use it, no downsides and will eliminate the confusing "should go
first" comments.
Or as an workaround maybe we could make __skb_queue_before accept
sk_buff_head and cast the other way around.
