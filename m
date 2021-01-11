Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA5C2F1DC6
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390165AbhAKSPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbhAKSPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:15:47 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F3DC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:15:06 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p187so562879iod.4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=34kB1Ns88SnXmJ4h4la9faIDJSSZWsUcWdihCyi4k/s=;
        b=L1BUyCb4m3lYieeyY2nJMNID0K0qbw20xDeriQPIqNZ7gqTmANyAN6Yey48jCZEmj6
         TwZDBZLyHmw5T6rDgQuYrx2gBquxJ9I3RJhU5rzqVi+APt2Yh+XaT1xgjgJMut4gc9L5
         nJElL0lrV5FVC0Ivj9tFsONDeCtV+NChtfFAu6uLs25IkfjLStp/aWPKuy/CFCXyEuM0
         ksyNFbx++FWX1Iaz+nN1ycjuGLxIznNFZAk8Dn/ym0CIhG4iLc8mXQ8EAEQsxbVT6FTE
         GgT5woeG0x1VkDd0E6r5w9jWkmr1FIvA9N811tsq0PtC6zcj5hJLv90Suat/xyofk9ES
         T4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=34kB1Ns88SnXmJ4h4la9faIDJSSZWsUcWdihCyi4k/s=;
        b=JIK5bu8m0z+E8ffBfuj0RW0wXmKlxDUIBPTXORti8uO1ZM6A2kog50f5ceFttU8zEw
         JrnOLTGVW2qK56DO3IPTe1ZT951CGth25Mb4GX50JrZK9MFcX9suvs2nLh9yehMJxMzT
         g+5hIvP65tYM/hDftWXxqUJ9X97AF8lvhwtpCt1sMfLVwQOlbQsxeRQoX11KSZCU0e19
         /KaxV2NIZnNYbb5pMVBum0jl+CjciOi6PKvA+Lb2s+4Yo5u/eNKWDtZPF7pxD7R0DVp7
         ebbXJqWS2hDoO9trHtFE7xYDIqGwcQQjmTN9TkeUxk6E4OJppWhDMWT5pgRX0mL/FWTX
         +HhA==
X-Gm-Message-State: AOAM53251bg2l2j8jeyZVNZINeOOLhP9XVpE4q3A4OE4lSgWHtQSfTjX
        0zc+xxSnCrH/AHV2K9uahFD6k1h74T9oixsAeMI=
X-Google-Smtp-Source: ABdhPJz/pEBZgfUvTT6coxrYArCRq0ONH6BGEPyXeMeLDjJBAq5N38Nih5dic+xCcpm+8dlfn4D7xdi6t1RzD2yE6P8=
X-Received: by 2002:a5e:dd0d:: with SMTP id t13mr423871iop.132.1610388906271;
 Mon, 11 Jan 2021 10:15:06 -0800 (PST)
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
 <CAH8yC8ncN7YZT804Ram3aCzoRGjCGKXEEUKFaNsq1MxtW0Uw3g@mail.gmail.com> <CACT4Y+abV4iDXf9y-_HyH5jQhmn5+=md+C4n+-77q=+cbN-OZA@mail.gmail.com>
In-Reply-To: <CACT4Y+abV4iDXf9y-_HyH5jQhmn5+=md+C4n+-77q=+cbN-OZA@mail.gmail.com>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Mon, 11 Jan 2021 13:14:55 -0500
Message-ID: <CAH8yC8m_H_VLWaomSku62k4BhwjFCZTB0Td4s17Wtb7tAH5Lqw@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 12:58 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Mon, Jan 11, 2021 at 6:35 PM Jeffrey Walton <noloader@gmail.com> wrote:
> >
> > On Mon, Jan 11, 2021 at 12:20 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > ...
> > > FTR, I've disabled the following UBSAN configs:
> > > UBSAN_MISC
> > > UBSAN_DIV_ZERO
> > > UBSAN_BOOL
> > > UBSAN_OBJECT_SIZE
> > > UBSAN_SIGNED_OVERFLOW
> > > UBSAN_UNSIGNED_OVERFLOW
> > > UBSAN_ENUM
> > > UBSAN_ALIGNMENT
> > > UBSAN_UNREACHABLE
> > >
> > > Only these are enabled now:
> > > UBSAN_BOUNDS
> > > UBSAN_SHIFT
> > >
> > > This is commit:
> > > https://github.com/google/syzkaller/commit/2c1f2513486f21d26b1942ce77ffc782677fbf4e
> >
> > I think the commit cut too deep.
> >
> > The overflows are important if folks are building with compilers other than GCC.
> >
> > The aligned data accesses are important on platforms like MIPS64 and Sparc64.
> >
> > Object size is important because it catches destination buffer overflows.
> >
> > I don't know what's in miscellaneous. There may be something useful in there.
>
> Hi Jeff,
>
> See the commit for reasons why each of these is disabled.
> E.g. object size, somebody first needs to fix bugs like this one.
> While things like skbuff have these UBs on trivial workloads, there is
> no point in involving fuzzing and making it crash on this trivial bug
> all the time and stopping doing any other kernel testing as the
> result.

Going off-topic a bit, what would you suggest for UBSAN_OBJECT_SIZE?

It seems to me object size checking is being conflated with object
type. It seems to me they need to be split: UBSAN_OBJECT_SIZE for
actual object sizes, and UBSAN_OBJECT_TYPE for the casts.

I still have a bitter taste in my mouth from
https://www.cvedetails.com/bugtraq-bid/57602/libupnp-Multiple-Buffer-Overflow-Vulnerabilities.html.
I hate to see buffer checks go away. (And I realize the kernel folks
are more skilled than the guy who wrote libupnp).

Jeff
