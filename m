Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664D7425DC8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240943AbhJGUsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbhJGUsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:48:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BA7C061570;
        Thu,  7 Oct 2021 13:46:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so6118705pjb.5;
        Thu, 07 Oct 2021 13:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n778GDxPUk5bM/6oUWYf94rGxS7Ym+wi8wyNVSUVHJY=;
        b=lf7NCZlMcXElgNAC66pZrN0XcQRt25y96kBcovC843viIgi1uE0pje7PtVyQPY0NqB
         qkvbwFwWFvppdKTfbVxiMUpPZAGbsyLd1tdlAohH5YdwJoLw65SEXKFmzMukywSMSrAj
         6F9tbwacQ7pAAmtkghVCpMWDMXevVnPpwFLp2Pm+8pu33TwU1C5eEshwzETOX4t9ooIm
         GuMz4GTqlUCtLo1ArIjI2ztuDW9u5ZLWF2R3HeFVSx87cehkcyAtdBAjz4VIRB/58l4Y
         T2CxWpYAxVJnRSRpyofXjA74izX49gjzCMIwk+6sPOE81Rpep/UcuRP23ujdyhXlJX5u
         m0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n778GDxPUk5bM/6oUWYf94rGxS7Ym+wi8wyNVSUVHJY=;
        b=bcatoaun4nKhQtV+CwOM8hemhXrECl1UPXC9VthnOHoPU6RwgcUTsXBXmPznIhpcqJ
         sNx95oN+MXAkHP7uPIvISy2CcCC3zwvJJ9EGVmdBDae14BWcmEPlBDLAf8df2IPbjVIa
         V2B9QTkxVo7bmgC0TodBs/A7LTFGw+ndHhVOOMXSSOCBkYsyYJpKbJI5Eby6JWUcZIc8
         1onyzEHWBiqhFBqbjvtODEkFrJ6Dcn6YWr6y4fyKYalDsbqxXevU/7wchqlxqlS/NsUI
         tZm1mb2/yrJnjfAFiV0g8km7IQ9kgB70yHslOZtTq2dVz/RhX0wm3LW7XoSO1Uoi+giL
         3lyQ==
X-Gm-Message-State: AOAM530EK9/YEbEjWRXLfuVTO7LlgBkgxyo5w8kdH0Y4n1lBMHmuOMEd
        nFSNUH/TDgxGmjG11e8jO08=
X-Google-Smtp-Source: ABdhPJyWu61PR6GwdZ3nM0x+fSD3FB9bBBhz6apFdeOAQCR7M7gZwqJxWzY/FI8oCZTPI+lMjmY7mw==
X-Received: by 2002:a17:90a:9b84:: with SMTP id g4mr5459162pjp.123.1633639572322;
        Thu, 07 Oct 2021 13:46:12 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id 8sm280984pfi.194.2021.10.07.13.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:12 -0700 (PDT)
Date:   Fri, 8 Oct 2021 02:16:09 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 4/6] bpf: selftests: Move test_ksyms_weak
 test to lskel, add libbpf test
Message-ID: <20211007204609.ygrqpx4rahfzqzly@apollo.localdomain>
References: <20211006002853.308945-1-memxor@gmail.com>
 <20211006002853.308945-5-memxor@gmail.com>
 <CAPhsuW7y3ycWkXLwSmJ5TKbo7Syd65aLRABtWbZcohET0RF6rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW7y3ycWkXLwSmJ5TKbo7Syd65aLRABtWbZcohET0RF6rA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:03:49AM IST, Song Liu wrote:
> On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
> > Create a file for testing libbpf skeleton as well, so that both
> > gen_loader and libbpf get tested.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> [...]
> > diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c
> > new file mode 100644
> > index 000000000000..b75725e28647
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c
> > @@ -0,0 +1,31 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <test_progs.h>
> > +#include "test_ksyms_weak.skel.h"
> > +
> > +void test_ksyms_weak_libbpf(void)
>
> This is (almost?) the same as test_weak_syms(), right? Why do we need both?
>

One includes lskel.h (light skeleton), the other includes skel.h (libbpf
skeleton). Trying to include both in the same file, it ends up redefining the
same struct. I am not sure whether adding a prefix/suffix to light skeleton
struct names is possible now, maybe through another option to bpftool in
addition to name?

> > +{
> > +       struct test_ksyms_weak *skel;
> > +       struct test_ksyms_weak__data *data;
> > +       int err;
> > +
> > +       skel = test_ksyms_weak__open_and_load();
> > +       if (!ASSERT_OK_PTR(skel, "test_ksyms_weak__open_and_load"))
> > +               return;
>
> [...]
>
> > diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> > index 5f8379aadb29..521e7b99db08 100644
> > --- a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> > +++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
> > @@ -21,7 +21,6 @@ __u64 out__non_existent_typed = -1;
> >  extern const struct rq runqueues __ksym __weak; /* typed */
> >  extern const void bpf_prog_active __ksym __weak; /* typeless */
> >
> > -
> >  /* non-existent weak symbols. */
> >
> >  /* typeless symbols, default to zero. */
> > @@ -38,7 +37,7 @@ int pass_handler(const void *ctx)
> >         /* tests existing symbols. */
> >         rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
> >         if (rq)
> > -               out__existing_typed = rq->cpu;
> > +               out__existing_typed = 0;
>
> Why do we need this change?
>

Since they share the same BPF object for generating skeleton, it needs to remove
dependency on CO-RE which gen_loader does not support.

If it is kept, we get this:
...
libbpf: // TODO core_relo: prog 0 insn[5] rq kind 0
libbpf: prog 'pass_handler': relo #0: failed to relocate: -95
libbpf: failed to perform CO-RE relocations: -95
libbpf: failed to load object 'test_ksyms_weak'
...
> >         out__existing_typeless = (__u64)&bpf_prog_active;
> >
> >         /* tests non-existent symbols. */
> > --
> > 2.33.0
> >

--
Kartikeya
