Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B093E2F1D49
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390071AbhAKR7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbhAKR7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:59:34 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B75EC06179F
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:58:47 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id d11so26623qvo.11
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ATuJmOFy0KcqE13PnrVbyttP4a9Jz5qFuwsOuBQL/Vw=;
        b=MUBr7e2G3c7SlRYU3UN1lvqA22wCQ7x/PE67AqxvzqThT9VDZGyj4drBnWjQcFbxZR
         4q0+ZL3hedviQI365712Z8+iKsMA4PhKlEEOFM4xNR1vu7HQXQSai1DhgEb58dIN7Xnz
         zH6as85malg1f0W2X7I0ysmae2F8IyQqZKrJ2Mnps9JohV2X4st/Hcpkh0lCRTXkJFyl
         7JdBwvkM94r2QYFxx/FU70f3HdD6/KplNFfNXqGu+YbZUT7hCO3NesqD/KM0bIjbl7CH
         iPfSq42BjQ5h+xZ/00siYLkIYJEIrpS+HUZ2tsSwvw11ZA4xtTpKf8eBwnfJwebInH12
         aZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ATuJmOFy0KcqE13PnrVbyttP4a9Jz5qFuwsOuBQL/Vw=;
        b=Wk+j04XmpvCYPAOucN0M1U6KSgQv+P9CWtuF9GaG+gmYMt3wnz9iNOZfnXb5vMNcmd
         qqAIUFiHd+UyEey+iN4UfoaB9djeyo9+EKNlyepk+awKKckux2kScAVBOzPtUi7vrvyK
         bfeZT4o4l1QZNdIiVlMGpPoEU7U57MutjPxXd10rsKCIH9lrvq+BPW5RAU6XEnK5i1kn
         3kKqUF5jU5hsRautCd+6zInc7n5MHVUdRjjPbgCMu+KNkAe2mPb73uU2Q8ZVzeHxyD64
         OSjPOLQGKYQoC3upK2846x6EtEZyJmDlGyuVM9mpyd2x9I3ANAajT164CTDvntSBHieL
         abRw==
X-Gm-Message-State: AOAM533CXR1PrFltOKRzOHTFUGJQh2R9umL2+VOYTBNFDBUSAilqNUCd
        hBqmWNVzaJN18ZGRMyxtdLAn2aRs0Uc+Gu8B8weWEg==
X-Google-Smtp-Source: ABdhPJxEVFwSKbAyhvqeMm56EZyjm/kLEVGSg+G6Kyh2y5K5/c/Iw1c+MJR5a8pqvLSWTlakYZbwTxpf2bdnCa+zSFE=
X-Received: by 2002:a0c:8304:: with SMTP id j4mr833661qva.18.1610387926447;
 Mon, 11 Jan 2021 09:58:46 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com>
 <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
 <CACT4Y+Y9H4xB_4sS9Hu6e+u=tmYXcw6PFB0LY4FRuGQ6HCywrA@mail.gmail.com>
 <CAGXu5j+jzmkiU_AWoTVF6e263iYSSJYUHB=Kdqh-MCfEO-aNSg@mail.gmail.com>
 <CACT4Y+b1nmsQBx=dD=Q9_y_GZx1PpqTbzR6j=u5UecQ0JLyMFg@mail.gmail.com>
 <CACT4Y+YYU6P1joGcNe9+E97-VACqs=5rcmOQerh2ju90R5Nfkg@mail.gmail.com> <CAH8yC8ncN7YZT804Ram3aCzoRGjCGKXEEUKFaNsq1MxtW0Uw3g@mail.gmail.com>
In-Reply-To: <CAH8yC8ncN7YZT804Ram3aCzoRGjCGKXEEUKFaNsq1MxtW0Uw3g@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 11 Jan 2021 18:58:34 +0100
Message-ID: <CACT4Y+abV4iDXf9y-_HyH5jQhmn5+=md+C4n+-77q=+cbN-OZA@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     noloader@gmail.com
Cc:     Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 6:35 PM Jeffrey Walton <noloader@gmail.com> wrote:
>
> On Mon, Jan 11, 2021 at 12:20 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > ...
> > FTR, I've disabled the following UBSAN configs:
> > UBSAN_MISC
> > UBSAN_DIV_ZERO
> > UBSAN_BOOL
> > UBSAN_OBJECT_SIZE
> > UBSAN_SIGNED_OVERFLOW
> > UBSAN_UNSIGNED_OVERFLOW
> > UBSAN_ENUM
> > UBSAN_ALIGNMENT
> > UBSAN_UNREACHABLE
> >
> > Only these are enabled now:
> > UBSAN_BOUNDS
> > UBSAN_SHIFT
> >
> > This is commit:
> > https://github.com/google/syzkaller/commit/2c1f2513486f21d26b1942ce77ffc782677fbf4e
>
> I think the commit cut too deep.
>
> The overflows are important if folks are building with compilers other than GCC.
>
> The aligned data accesses are important on platforms like MIPS64 and Sparc64.
>
> Object size is important because it catches destination buffer overflows.
>
> I don't know what's in miscellaneous. There may be something useful in there.

Hi Jeff,

See the commit for reasons why each of these is disabled.
E.g. object size, somebody first needs to fix bugs like this one.
While things like skbuff have these UBs on trivial workloads, there is
no point in involving fuzzing and making it crash on this trivial bug
all the time and stopping doing any other kernel testing as the
result.
