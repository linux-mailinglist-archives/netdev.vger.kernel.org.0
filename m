Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7891D394EE4
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 03:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhE3BTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 21:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhE3BTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 21:19:16 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47879C061574;
        Sat, 29 May 2021 18:17:38 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id e10so11176922ybb.7;
        Sat, 29 May 2021 18:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EShTowP+tcGQc64UEUm7RFR1I6QAAde0tBd7WGQUDHU=;
        b=bERr68h3M1lPtCuT5MqAaBxQYaj08o9pQFt4J8fsdTic10ZQzbEILATI1iDVmWaeMF
         XlvkfDNQmyVgKZEJd9JWTmswBHhJaM20+uziII9fA7B0RQIK8zhI0nieFZeHuLPHPfiP
         Fbs5l8E898go62Ldlb+nkOqzXrR/vU0oInsEnpPTsje/NJ6HQIxNHBt56n2UCHh1zqqZ
         m/512POl1kzr2xXPX1xNCPI4lWNaGecXFhEJPWT9ebYW3tAFmnFmk6T/USK7hs+CEXvc
         cxwWSI6nDjjHjfqMDXRwm6SoLlria2Yxps7vTNAcmVQ5u1JXee5h99LVl9Ai4WDNaWzS
         UHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EShTowP+tcGQc64UEUm7RFR1I6QAAde0tBd7WGQUDHU=;
        b=TyYCMJZn1UTfyiLyaVRzI2ilE1Om0Ohm+I+5BVnEmp1vYa5kdgoWXrTsHJpMq0ueH0
         ulIY2+5Qqz7R/eyh7rUIJnGYch2a1TLi/9rTJJ25YdR9hd21/v6oWO9I3Q2s1WtZ1anK
         iO797nywPGYnkk/4Yy5h1t0K8nFMTZ9IVrMW9CNj5VCyD3Ki3zTnhpamHdWKZakvBU6+
         KT2ZOVRiGrEoTj2/j4trigD9H9VAb3tNQwKa+HL3K/TbArhkKsRKJvWploYgaI875Ewu
         7HjqWQR4G0basLNJQC84BiglQAjChPY4ffnQ+LS6N+1WZFfShmUx+ZNizWeNWZXRSO8O
         0uig==
X-Gm-Message-State: AOAM532ttnm8EgsyUGRB+aPrKojLVin+VovXz8C84InKgqsMcUeJVvzc
        iJhxzX2yIrYGkr6/Q80/8zQKuplJdXvqvv64cm8=
X-Google-Smtp-Source: ABdhPJz7LUkHy4FEZNdVEOCtnk0LyPJGfsAED/HCNLROdksSFhXNdOZDcZx6N01UvvA24Wiy0I18ddTmThYtT8c0N70=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr20910655ybg.459.1622337457232;
 Sat, 29 May 2021 18:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210528090758.1108464-1-yukuai3@huawei.com> <c5a37d91-dd20-55e3-a78b-272a00b940d5@iogearbox.net>
 <b22eac4a-aad5-917d-5f26-7955b798779b@huawei.com>
In-Reply-To: <b22eac4a-aad5-917d-5f26-7955b798779b@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 29 May 2021 18:17:26 -0700
Message-ID: <CAEf4BzZN_r_7AVrBwEW5qxiCr4ej1AkyY=4gWX3LufdhyL7Sgw@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: Fix return value check in attach_bpf()
To:     "yukuai (C)" <yukuai3@huawei.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 6:25 PM yukuai (C) <yukuai3@huawei.com> wrote:
>
> On 2021/05/29 4:46, Daniel Borkmann wrote:
> > On 5/28/21 11:07 AM, Yu Kuai wrote:
> >> use libbpf_get_error() to check the return value of
> >> bpf_program__attach().
> >>
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   tools/testing/selftests/bpf/benchs/bench_rename.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c
> >> b/tools/testing/selftests/bpf/benchs/bench_rename.c
> >> index c7ec114eca56..b7d4a1d74fca 100644
> >> --- a/tools/testing/selftests/bpf/benchs/bench_rename.c
> >> +++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
> >> @@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
> >>       struct bpf_link *link;
> >>       link = bpf_program__attach(prog);
> >> -    if (!link) {
> >> +    if (libbpf_get_error(link)) {
> >>           fprintf(stderr, "failed to attach program!\n");
> >>           exit(1);
> >>       }
> >
> > Could you explain the rationale of this patch? bad2e478af3b
> > ("selftests/bpf: Turn
> > on libbpf 1.0 mode and fix all IS_ERR checks") explains: 'Fix all the
> > explicit
> > IS_ERR checks that now will be broken because libbpf returns NULL on
> > error (and
> > sets errno).' So the !link check looks totally reasonable to me.
> > Converting to
> > libbpf_get_error() is not wrong in itself, but given you don't make any
> > use of
> > the err code, there is also no point in this diff here.
> Hi,
>
> I was thinking that bpf_program__attach() can return error code
> theoretically(for example -ESRCH), and such case need to be handled.
>

I explicitly changed to NULL check + libbpf 1.0 error reporting mode
because I don't care about specific error in benchmarks. So as Daniel
and John pointed out, existing code is correct and doesn't need
adjustment.

You are right, though, that error code is indeed returned, but you can
check errno directly (but need to enable libbpf 1.0 mode) or use
libbpf_get_error() (which will get deprecated some time before libbpf
1.0) if you don't know which mode your code will be run in.


> Thanks,
> Yu Kuai
> >
> > Thanks,
> > Daniel
> > .
> >
