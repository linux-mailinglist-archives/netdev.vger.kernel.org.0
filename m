Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DD927FA2F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbgJAHXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgJAHXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:23:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BCBC0613D0;
        Thu,  1 Oct 2020 00:23:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k8so3682234pfk.2;
        Thu, 01 Oct 2020 00:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LrYLWDQM8stmz0yFz3Wg0u7Rhgkk0IZGCSoh4qC8NGo=;
        b=WEi+4jZWtcRSC7DoRUySz4lbViIHSOBrrCEPUcWUqRej/P4QjjjyRot4hI1BEllrkY
         uP/JYMH6mDG9HccOuI1SWE5eQDBOw5SJkGLzfQoq94tFB2JBcbA5TedKCFTDrr97+++b
         MAXob9d8uIvxaCwXgdu5LMXmQqxMDkcLksBLKJ9TxnF/62YPOfGNFQGiZhw0MIjJhlS3
         Ll+IYCKndZwdLXZkDLdvPMknncD+URg7GGOj+XZCGZSsK684H0MP7bRovCGsxHDHFWYE
         37Kdw8pGDepYQ1jsTjAoio2QxjM9/Banr+hIUpvWXWtVkO/S5ahWOtUPmESjgX5x5BXU
         +p7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LrYLWDQM8stmz0yFz3Wg0u7Rhgkk0IZGCSoh4qC8NGo=;
        b=qPa4pGrZQwkzQAgsEL5iu9gbi6zh3EVpdUcBQiSPKYZk9H6oR8bXoKevP6q+btX9qF
         Bae+mNu0+KaWnRR4mXQfvfXmGaThYCVgTMmB018z+nrmYO269toyaOFcTmGQruyK5+jr
         kxWzyhVndCY83EkNn1l0cieN2hVxzcgyuZBpJOHcaz2ny1mgZ6lDbCdq0FN/Hji0grE8
         TZ2lPfir4fkSzuwCkaDWta9MYDrgVX+8sg53+Kn3eLsqywGlXKL0oY34gx+/ZUI+5w62
         wz8WX+yRhHWMdJG69/TcRtgYMLBPaVTkyl5XdGSmG9oOJ4SPkY4ClZS8tLNbmD+RMrJm
         h7YA==
X-Gm-Message-State: AOAM531ywrCWokadB/hFyvxWWSrHSk6KvrHp1Np1r9TQ3pnHuDlndyPT
        xssRxZhmhcz5f6I6IzbaFaA=
X-Google-Smtp-Source: ABdhPJwMyLOXMi2i32b5+lOK7RIN4L5ZLWJ8vMk6L5e/S71dxOIZstKJCsskm0686d08wPnHTn9YBg==
X-Received: by 2002:a65:5802:: with SMTP id g2mr4917679pgr.261.1601537031863;
        Thu, 01 Oct 2020 00:23:51 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:76d9])
        by smtp.gmail.com with ESMTPSA id c20sm5141227pfc.209.2020.10.01.00.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 00:23:50 -0700 (PDT)
Date:   Thu, 1 Oct 2020 00:23:48 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/4] selftests: bpf: Add helper to compare
 socket cookies
Message-ID: <20201001072348.hxhpuoqmeln6twxw@ast-mbp.dhcp.thefacebook.com>
References: <20200928090805.23343-1-lmb@cloudflare.com>
 <20200928090805.23343-3-lmb@cloudflare.com>
 <20200929055851.n7fa3os7iu7grni3@kafai-mbp>
 <CAADnVQLwpWMea1rbFAwvR_k+GzOphaOW-kUGORf90PJ-Ezxm4w@mail.gmail.com>
 <CACAyw98WzZGcFnnr7ELvbCziz2axJA_7x2mcoQTf2DYWDYJ=KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACAyw98WzZGcFnnr7ELvbCziz2axJA_7x2mcoQTf2DYWDYJ=KA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:28:33AM +0100, Lorenz Bauer wrote:
> On Tue, 29 Sep 2020 at 16:48, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> 
> ...
> 
> > There was a warning. I noticed it while applying and fixed it up.
> > Lorenz, please upgrade your compiler. This is not the first time such
> > warning has been missed.
> 
> I tried reproducing this on latest bpf-next (b0efc216f577997) with gcc
> 9.3.0 by removing the initialization of duration:
> 
> make: Entering directory '/home/lorenz/dev/bpf-next/tools/testing/selftests/bpf'
>   TEST-OBJ [test_progs] sockmap_basic.test.o
>   TEST-HDR [test_progs] tests.h
>   EXT-OBJ  [test_progs] test_progs.o
>   EXT-OBJ  [test_progs] cgroup_helpers.o
>   EXT-OBJ  [test_progs] trace_helpers.o
>   EXT-OBJ  [test_progs] network_helpers.o
>   EXT-OBJ  [test_progs] testing_helpers.o
>   BINARY   test_progs
> make: Leaving directory '/home/lorenz/dev/bpf-next/tools/testing/selftests/bpf'
> 
> So, gcc doesn't issue a warning. Jakub did the following little experiment:
> 
> jkbs@toad ~/tmp $ cat warning.c
> #include <stdio.h>
> 
> int main(void)
> {
>         int duration;
> 
>         fprintf(stdout, "%d", duration);
> 
>         return 0;
> }
> jkbs@toad ~/tmp $ gcc -Wall -o /dev/null warning.c
> warning.c: In function ‘main’:
> warning.c:7:2: warning: ‘duration’ is used uninitialized in this
> function [-Wuninitialized]
>     7 |  fprintf(stdout, "%d", duration);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> The simple case seems to work. However, adding the macro breaks things:
> 
> jkbs@toad ~/tmp $ cat warning.c
> #include <stdio.h>
> 
> #define _CHECK(duration) \
>         ({                                                      \
>                 fprintf(stdout, "%d", duration);                \
>         })
> #define CHECK() _CHECK(duration)
> 
> int main(void)
> {
>         int duration;
> 
>         CHECK();
> 
>         return 0;
> }
> jkbs@toad ~/tmp $ gcc -Wall -o /dev/null warning.c
> jkbs@toad ~/tmp $

That's very interesting. Thanks for the pointers.
I'm using gcc version 9.1.1 20190605 (Red Hat 9.1.1-2)
and I saw this warning while compiling selftests,
but I don't see it with above warning.c example.
clang warns correctly in both cases.

> Maybe this is https://gcc.gnu.org/bugzilla/show_bug.cgi?id=18501 ? The
> problem is still there on gcc 10. Compiling test_progs with clang does
> issue a warning FWIW, but it seems like other things break when doing
> that.

That gcc bug has been opened since transition to ssa. That was a huge
transition for gcc. But I think the bug number is not correct. It points to a
different issue. I've checked -fdump-tree-uninit-all dump with and without
macro. They're identical. The tree-ssa-uninit pass suppose to warn, but it
doesn't. I wish I had more time to dig into it. A bit of debugging in
gcc/tree-ssa-uninit.c can probably uncover the root cause.
