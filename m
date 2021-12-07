Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE63C46C280
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbhLGSSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:18:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38669 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230257AbhLGSSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:18:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638900872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RtlB+q2yXh5ebvFEGBR9G9xtBgb8a+zDj7VKXAAjuUU=;
        b=W5G9pViddUlOB1n4MJO+Y81C9STZRjWbGnwlUumYEGxYZQv0/lafdCVz1tZGvQxRn6b22n
        O6+9l1wKGjchyXxixAHNeixaj0sPKwjK9zI0w2z3PrEvEYwMo0qHWKcuUoJij81NWLrCzs
        94QfvoQ2qo4c2GRbrznKG5jv5nIYpF4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-FkHlfwPzOzSTsiJZBXX3TQ-1; Tue, 07 Dec 2021 13:14:30 -0500
X-MC-Unique: FkHlfwPzOzSTsiJZBXX3TQ-1
Received: by mail-ed1-f69.google.com with SMTP id c1-20020aa7c741000000b003e7bf1da4bcso12086863eds.21
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 10:14:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RtlB+q2yXh5ebvFEGBR9G9xtBgb8a+zDj7VKXAAjuUU=;
        b=MvDn/sD54XjLX5K1Jr0FPYOoxJ0SExqTTP6pc+eapv7nXkc0yA99Alw+AX0prGJV9l
         o2JLooxnY4GYdfy/Say5dYBCjzUGXTkrHhArhH0YbRpJuTpt6uQtglaCVruAUlY0kh+b
         WZ/AwcxPdBy/nDYydK3+NzH23f6taKoki8w5726qbCUqim2ZpaGHwzO/uqZ3Csw4HHHY
         qmtjpeyCo3qA0p/t82R2H6ixgD2oqyuSf6vyDQm5Mglevm5guDfHKBx7CzngGNvcKOs1
         M1k4YcP5PxeVZj4pQm9ds0KCHEeFK9eGvud768dPYcFXNaJaAK++48Gwqz6JU4oPql4V
         mqGg==
X-Gm-Message-State: AOAM533GS2+lyWZ+pW6nLHKrDngyeVKEu0SMLblfUd1GqVAUskwyes3B
        JvaLFzMTdK9Rv05CiedD7aXqO18PEUfLTlek5IGwhmP0MnF9dPGMLHWkIqj948jeuxaKZVyER3r
        +YY4rK+mpjL2nojds
X-Received: by 2002:a05:6402:50c6:: with SMTP id h6mr11090588edb.228.1638900869699;
        Tue, 07 Dec 2021 10:14:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJztv0/R/GP2WdIu+4Ybks24SMSx8TdzLXm/jkvJgv6Vbx5rweFpsJt5IDCgQjGCe9yB8U9hVg==
X-Received: by 2002:a05:6402:50c6:: with SMTP id h6mr11090558edb.228.1638900869444;
        Tue, 07 Dec 2021 10:14:29 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id r13sm315655edo.71.2021.12.07.10.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 10:14:29 -0800 (PST)
Date:   Tue, 7 Dec 2021 19:14:27 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, andrii@kernel.org
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add tests for
 get_func_[arg|ret|arg_cnt] helpers
Message-ID: <Ya+kg3SPcBU4loIz@krava>
References: <20211204140700.396138-1-jolsa@kernel.org>
 <20211204140700.396138-4-jolsa@kernel.org>
 <7df54ca3-1bae-4d54-e30f-c2474c48ede0@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7df54ca3-1bae-4d54-e30f-c2474c48ede0@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 02:03:54PM -0800, Andrii Nakryiko wrote:
> 
> On 12/4/21 6:07 AM, Jiri Olsa wrote:
> > Adding tests for get_func_[arg|ret|arg_cnt] helpers.
> > Using these helpers in fentry/fexit/fmod_ret programs.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   .../bpf/prog_tests/get_func_args_test.c       |  38 ++++++
> >   .../selftests/bpf/progs/get_func_args_test.c  | 112 ++++++++++++++++++
> >   2 files changed, 150 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/get_func_args_test.c
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
> > new file mode 100644
> > index 000000000000..c24807ae4361
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
> > @@ -0,0 +1,38 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +#include "get_func_args_test.skel.h"
> > +
> > +void test_get_func_args_test(void)
> > +{
> > +	struct get_func_args_test *skel = NULL;
> > +	__u32 duration = 0, retval;
> > +	int err, prog_fd;
> > +
> > +	skel = get_func_args_test__open_and_load();
> > +	if (!ASSERT_OK_PTR(skel, "get_func_args_test__open_and_load"))
> > +		return;
> > +
> > +	err = get_func_args_test__attach(skel);
> > +	if (!ASSERT_OK(err, "get_func_args_test__attach"))
> > +		goto cleanup;
> > +
> > +	prog_fd = bpf_program__fd(skel->progs.test1);
> > +	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > +				NULL, NULL, &retval, &duration);
> > +	ASSERT_OK(err, "test_run");
> > +	ASSERT_EQ(retval, 0, "test_run");
> > +
> > +	prog_fd = bpf_program__fd(skel->progs.fmod_ret_test);
> > +	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > +				NULL, NULL, &retval, &duration);
> > +	ASSERT_OK(err, "test_run");
> > +	ASSERT_EQ(retval, 1234, "test_run");
> 
> 
> are the other two programs executed implicitly during one of those test
> runs? Can you please leave a small comment somewhere here if that's true?

test1 triggers all the bpf_fentry_test* fentry/fexits
fmod_ret_test triggers the rest, I'll put it in comment

> 
> 
> > +
> > +	ASSERT_EQ(skel->bss->test1_result, 1, "test1_result");
> > +	ASSERT_EQ(skel->bss->test2_result, 1, "test2_result");
> > +	ASSERT_EQ(skel->bss->test3_result, 1, "test3_result");
> > +	ASSERT_EQ(skel->bss->test4_result, 1, "test4_result");
> > +
> > +cleanup:
> > +	get_func_args_test__destroy(skel);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/get_func_args_test.c b/tools/testing/selftests/bpf/progs/get_func_args_test.c
> > new file mode 100644
> > index 000000000000..0d0a67c849ae
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/get_func_args_test.c
> > @@ -0,0 +1,112 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +#include <errno.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +__u64 test1_result = 0;
> > +SEC("fentry/bpf_fentry_test1")
> > +int BPF_PROG(test1)
> > +{
> > +	__u64 cnt = bpf_get_func_arg_cnt(ctx);
> > +	__u64 a = 0, z = 0, ret = 0;
> > +	__s64 err;
> > +
> > +	test1_result = cnt == 1;
> > +
> > +	/* valid arguments */
> > +	err = bpf_get_func_arg(ctx, 0, &a);
> > +	test1_result &= err == 0 && (int) a == 1;
> 
> 
> int cast unnecessary? but some ()'s wouldn't hurt...

it is, 'a' is int and trampoline saves it with 32-bit register like:

  mov    %edi,-0x8(%rbp)

so the upper 4 bytes are not zeroed

> 
> 
> > +
> > +	/* not valid argument */
> > +	err = bpf_get_func_arg(ctx, 1, &z);
> > +	test1_result &= err == -EINVAL;
> > +
> > +	/* return value fails in fentry */
> > +	err = bpf_get_func_ret(ctx, &ret);
> > +	test1_result &= err == -EINVAL;
> > +	return 0;
> > +}
> > +
> > +__u64 test2_result = 0;
> > +SEC("fexit/bpf_fentry_test2")
> > +int BPF_PROG(test2)
> > +{
> > +	__u64 cnt = bpf_get_func_arg_cnt(ctx);
> > +	__u64 a = 0, b = 0, z = 0, ret = 0;
> > +	__s64 err;
> > +
> > +	test2_result = cnt == 2;
> > +
> > +	/* valid arguments */
> > +	err = bpf_get_func_arg(ctx, 0, &a);
> > +	test2_result &= err == 0 && (int) a == 2;
> > +
> > +	err = bpf_get_func_arg(ctx, 1, &b);
> > +	test2_result &= err == 0 && b == 3;
> > +
> > +	/* not valid argument */
> > +	err = bpf_get_func_arg(ctx, 2, &z);
> > +	test2_result &= err == -EINVAL;
> > +
> > +	/* return value */
> > +	err = bpf_get_func_ret(ctx, &ret);
> > +	test2_result &= err == 0 && ret == 5;
> > +	return 0;
> > +}
> > +
> > +__u64 test3_result = 0;
> > +SEC("fmod_ret/bpf_modify_return_test")
> > +int BPF_PROG(fmod_ret_test, int _a, int *_b, int _ret)
> > +{
> > +	__u64 cnt = bpf_get_func_arg_cnt(ctx);
> > +	__u64 a = 0, b = 0, z = 0, ret = 0;
> > +	__s64 err;
> > +
> > +	test3_result = cnt == 2;
> > +
> > +	/* valid arguments */
> > +	err = bpf_get_func_arg(ctx, 0, &a);
> > +	test3_result &= err == 0 && (int) a == 1;
> > +
> > +	err = bpf_get_func_arg(ctx, 1, &b);
> > +	test3_result &= err == 0;
> 
> 
> why no checking of b value here?

right, ok

> 
> > +
> > +	/* not valid argument */
> > +	err = bpf_get_func_arg(ctx, 2, &z);
> > +	test3_result &= err == -EINVAL;
> > +
> > +	/* return value */
> > +	err = bpf_get_func_ret(ctx, &ret);
> > +	test3_result &= err == 0 && ret == 0;
> > +	return 1234;
> > +}
> > +
> > +__u64 test4_result = 0;
> > +SEC("fexit/bpf_modify_return_test")
> > +int BPF_PROG(fexit_test, int _a, __u64 _b, int _ret)
> > +{
> > +	__u64 cnt = bpf_get_func_arg_cnt(ctx);
> > +	__u64 a = 0, b = 0, z = 0, ret = 0;
> > +	__s64 err;
> > +
> > +	test4_result = cnt == 2;
> > +
> > +	/* valid arguments */
> > +	err = bpf_get_func_arg(ctx, 0, &a);
> > +	test4_result &= err == 0 && (int) a == 1;
> > +
> > +	err = bpf_get_func_arg(ctx, 1, &b);
> > +	test4_result &= err == 0;
> 
> 
> same, for consistency, b should have been checked, no?

ok

thanks,
jirka

