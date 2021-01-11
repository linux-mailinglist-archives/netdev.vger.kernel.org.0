Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F622F1C8F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389710AbhAKRg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389703AbhAKRg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:36:27 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423AAC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:35:47 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id t3so319673ilh.9
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=LzViG+6M8a4vzSOV8ooN/619eTwTPtJS9YsOMkrafo4=;
        b=FDrrknj7kNV/QrfpRwB6R6xqsKJWmj2qzNa0V0VygomjPj54UKDbL4w2Grt8p9qe6Z
         pP09mi/1TLnSR+5lNgi5Rf0YV8GO2H4kuH3FHfjPYtxo79ux7IISu12v/9OHJmuBaoOP
         sRwMl1DZ7bVgSGiGovXOk636jif2iP3DDcmZ4T2whGuwIKeMJFJNHRvAsM4GCLC8xjVm
         vnmiwC5hWLkuv3PnvjBsLxXmzACxZ2JrDPHFVxWv+aIbjWKliKPOjX0ymR6FoxLTkpIO
         Evy3/5OT39hvUzxaVIKafjABrYT70qzQXeRcIcOQ2NVdr1WHlONW2gNr9bEaS8mDoeGv
         UP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=LzViG+6M8a4vzSOV8ooN/619eTwTPtJS9YsOMkrafo4=;
        b=Yu8HWpFo8WeKLVJt55O0X8NjFdSj1nyG2KhpgqhP86Gi2J+D8yH+tTRljJz1AVsJEn
         2U6JqyfQHZKQr0fDv3AVAVoxJF4M5oq5MwZNzLMpErtWRe73q5TzLD7Tb+e4vzFC+3oW
         7oz/bnmq63VLw9Q+J+moc5TN54I6Y0Qs+fGjLc0LB+ZytI1mOEiOok3BHefsSVPUO8Xh
         BOOsszRxmf3MUkYe569bjKCtBEkrJvtWx4hVnAnH+v66DzzJ7Im4ss7LwBwl44t6EIIx
         /U4wASLreWBN3sqU6wOiCxXm6sKKAHIv4KRXA+wIDrvRdl41DaDXXPP1ss4JbSxieIbm
         JYMg==
X-Gm-Message-State: AOAM530T9iqbyJ9LB3dVuSkEpbhWYwFnJ7PpeGZWX+fKB/qwCKVp2Fy7
        2RdEI5mfE8cFqpg0WUlZPizkqoPRjm4aYqPNPwg=
X-Google-Smtp-Source: ABdhPJxOc/ADjRCF61vsnDHmpkcvuPUerMZtDscg25vqMGpQWUCmaq77u6H/4q8EUlUEGg2Jk6p5gfPjDiAUUMgc3Ic=
X-Received: by 2002:a92:cb52:: with SMTP id f18mr215994ilq.41.1610386546763;
 Mon, 11 Jan 2021 09:35:46 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
 <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
 <CACT4Y+bKvf5paRS4X1QrcKZWfvtUi6ShP4i3y5NukRpQj0p1+Q@mail.gmail.com>
 <CAHmME9oOeMLARNsxzW0dvNT7Qz-EieeBSJP6Me5BWvjheEVysw@mail.gmail.com>
 <CACT4Y+Y9H4xB_4sS9Hu6e+u=tmYXcw6PFB0LY4FRuGQ6HCywrA@mail.gmail.com>
 <CAGXu5j+jzmkiU_AWoTVF6e263iYSSJYUHB=Kdqh-MCfEO-aNSg@mail.gmail.com>
 <CACT4Y+b1nmsQBx=dD=Q9_y_GZx1PpqTbzR6j=u5UecQ0JLyMFg@mail.gmail.com> <CACT4Y+YYU6P1joGcNe9+E97-VACqs=5rcmOQerh2ju90R5Nfkg@mail.gmail.com>
In-Reply-To: <CACT4Y+YYU6P1joGcNe9+E97-VACqs=5rcmOQerh2ju90R5Nfkg@mail.gmail.com>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Mon, 11 Jan 2021 12:35:19 -0500
Message-ID: <CAH8yC8ncN7YZT804Ram3aCzoRGjCGKXEEUKFaNsq1MxtW0Uw3g@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 12:20 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> ...
> FTR, I've disabled the following UBSAN configs:
> UBSAN_MISC
> UBSAN_DIV_ZERO
> UBSAN_BOOL
> UBSAN_OBJECT_SIZE
> UBSAN_SIGNED_OVERFLOW
> UBSAN_UNSIGNED_OVERFLOW
> UBSAN_ENUM
> UBSAN_ALIGNMENT
> UBSAN_UNREACHABLE
>
> Only these are enabled now:
> UBSAN_BOUNDS
> UBSAN_SHIFT
>
> This is commit:
> https://github.com/google/syzkaller/commit/2c1f2513486f21d26b1942ce77ffc782677fbf4e

I think the commit cut too deep.

The overflows are important if folks are building with compilers other than GCC.

The aligned data accesses are important on platforms like MIPS64 and Sparc64.

Object size is important because it catches destination buffer overflows.

I don't know what's in miscellaneous. There may be something useful in there.

Jeff
