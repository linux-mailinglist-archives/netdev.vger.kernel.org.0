Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41610253EA0
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgH0HIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgH0HIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:08:15 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFB7C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:08:15 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id a6so1000844oog.9
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=jvL6xxc6ISeyso9gfNOQ7DHDHE65WAJ7XCIqjwcRs9g=;
        b=UKFRMdPzEvMRkomT3ZPZ4fyBqPALH0wFAxdT3N8+f2w5QFFmjswCVgkz/UvqySQ0lz
         9e8/GOJbeMKzGXCbJyu4IbMaj3C8l5r1f9jBJ38D1lxXxQ4x8sTPqApeM/kz6Up6YITY
         2SGv9yoLSJ4mSXl8w93uocgz0nl4Q7d3Uf7RcYhW0Q+cPQevycMM2AAQ/s2mJbTw6Cl5
         bhocRzTIopYVmwrLtkHNxOh+bnIuK1vKeSGqvFLnIz1j8aCdFpbj4E4YivjpLUaC1U3V
         bdfFZny8dDYnLxgP1aLKr6A18QShBs1HGEsyViDnW6B840mMCBM//ePoM08DX0Dj+vdw
         AXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=jvL6xxc6ISeyso9gfNOQ7DHDHE65WAJ7XCIqjwcRs9g=;
        b=jCJ6j8TcLD8euPuzqLeCYJLDqUTHsSKphXHVxD+xQzx22HYsfZMvT2cUvcXeF4XlHq
         aw6W3ecQkYe86x7j5LdwQd09EGt34bQBcxjQ0WlqgNuB596Hk4yMovVRJVI4bFEo0VsQ
         vviXhF+Okflm9nR8Do9+iw6+ISaZM+gIz11Ry+Gs29d+kVuCpSEAXDNGStdz3r7dWdMh
         QEQSqsT6GpfGtlDeDurZ+NWse738Ghb86Ot3IauMrGK7oS0ssbnbfxRSS6aqlqrNXxKk
         /OfWvBFbUpWOH+5ne8MRuRTXzCIEOhB8Ww7+iuq8Cgp+E9H5WZvVa4ETogUWw3RMjDjR
         vxDg==
X-Gm-Message-State: AOAM531AYE4KzW+INOawA6hZKsTjtp6Zhs95MlEIDsYVV++Idurx+nRe
        O/jypQyJ2OGkcsQRN91kOoCuem/n/6OWT4oroaI=
X-Google-Smtp-Source: ABdhPJy3K4+rZSdRJ0gY7O1BhWLQS6wawZygNhFcu4/3P/24uzg7emS8MFGJDb4JyT/z+co4a1wyr3AawY9Jzvod5Uc=
X-Received: by 2002:a4a:dfd4:: with SMTP id p20mr13278932ood.86.1598512094667;
 Thu, 27 Aug 2020 00:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
 <20200816150133.GA17475@1wt.eu> <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
 <CA+icZUUSQGTbfMCUo9JyAZ_FZzvF98v06pRgH+6iMqgVUYijdQ@mail.gmail.com>
 <20200820043323.GA21461@1wt.eu> <CA+icZUXV21ZYzcM_rcKfd3pQ56KYueMQ=YKaVc-QEL7Duf2v-A@mail.gmail.com>
 <20200820060843.GA21526@1wt.eu> <20200820065838.GB21526@1wt.eu>
 <20200820080503.GC21526@1wt.eu> <CANEQ_+L+22Hkdqf38Zr0bfq16fcL1Ax2X9fToXV_niHKXCB8aA@mail.gmail.com>
 <20200827010915.GA28379@1wt.eu>
In-Reply-To: <20200827010915.GA28379@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 27 Aug 2020 09:08:03 +0200
Message-ID: <CA+icZUXAqWrHhipb8xO=Yf+MGCMUgjkcYAXursyTRbGgqFomPw@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        George Spelvin <lkml@sdf.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 3:09 AM Willy Tarreau <w@1wt.eu> wrote:
>
> Hi Amit,
>
> On Thu, Aug 27, 2020 at 02:06:39AM +0300, Amit Klein wrote:
> > Hi
> >
> > Is there an ETA for this patch then?
>
> No particular ETA on my side, I was waiting for potential criticisms
> before going further. I suspect that if nobody complains anymore, it's
> an implicit voucher and I'll have to clean up and post the series then.
>

Hi Willy,

again a feedback from me as a tester of the last patchset.

I have tested it in several build-environments:

#1: GCC v10.2 + GNU/ld (BFD)
#2: GCC v10.2 + LLVM/ld.lld (LLD)
#3: GCC v10.2 + LLD plus all available LLVM "bin"utils v11.0.0-rc2
(replacements for GNU's nm, objdump, objcopy, ar, strin, ranlib, etc.)
#4: LLVM toolchain v11.0.0-rc2 and Clang-IAS (Integrated ASsembler)
#5: LLVM toolchain v11.0.0-rc2 and Clang-LTO (LinkTime Optimization)
#6: LLVM toolchain v11.0.0-rc2 and Clang-CFI (Control Flow Integrity)

For what are you waiting for :-)?

Feel free to add my...

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

If you are interested in Clang-IAS/Clang-LTO/Clang-CFI... I want to
promote the LLVM MC (micro-conference) at Linux Plumbers Conference
2020 today (27-Aug-2020) - starting 16:00 UTC.
AFAICS it is freely available via YouTube (untested by me).

- Sedat -
