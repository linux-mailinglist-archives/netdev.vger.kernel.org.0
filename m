Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8E246C7CE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbhLGW6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhLGW6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 17:58:16 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED88C061574;
        Tue,  7 Dec 2021 14:54:45 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id f9so1479226ybq.10;
        Tue, 07 Dec 2021 14:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KIUT20NJGyEzKpPlf+Kj5bOvgKjOQpWqtgUjoQeoVpY=;
        b=bCl5TPUDim/CaOSCDir1lhcVCnE+UMPLzZV+nHMXhJMMTZJiZme6nKV3cL1cRZ12vl
         hWxWcCe9VUP25J7DPFwcuZTeV8MGECaj8BKZYlOKy+wFFZAc6QklxbPNbBnycMfurCQJ
         MTqXW7BPtMIX+6C8erBWSfZ4oCnRq3cnpJceUujixR3llVpg4Ww81483gN2xLaz2M++s
         p1nO/Uly7SzfDm2NlfeH2aOPQlUcylCdQq1viaCedZ1DrjmbxVafQQoAvjcjTSCJROuV
         8y6VBtOPXUijFlKDdxnV1gkwl4JyBCBXjHQ8bEuDd+27UtsrfrYHUFEAy2izPmPidYk9
         6Ifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KIUT20NJGyEzKpPlf+Kj5bOvgKjOQpWqtgUjoQeoVpY=;
        b=Uj3HuvPx+z+E+lbyl+I6Zs3metlTzC8lQdnqrByWgzzTuJMVPS1EDR4JORpiK2BM0Q
         4/7fhG6BBk6A2pxH3Rg8Uq9lWzvXXe3b3Ru+x5FpwCInTi5hqKqKh6+QydCAeRf4pGcz
         2OPNH4F2XNXxm8WcnwdLLpSg329BMy+4QVjTUONARnadK0AbcwCpUistXjJcOEq3XQpq
         ysryg3AdsVdYJcoJuXekMgZfNqK3O5U9xnWEeeRzKPl9jbvdGicB9NVObeYweF+j5bir
         mo+tpMItF4zZslpcCnSwltJHD53VHnkap3DrKYFJnJoL075zbo5B67H74I9nyrtboixq
         pu/w==
X-Gm-Message-State: AOAM532SvG2rMDeS21h8pL0nYTAE6Y1emoC9BqdLXcfpKQ7qOIlRWI92
        8fwdaIeQE2xWlnEas2WZXVgbdbMqSggumkcKlM8=
X-Google-Smtp-Source: ABdhPJzg3gooPAKHVdMOpJLG8/YYxFysuOPPxmJz4m5qhFLTw4VSIN50Bc5gVLRQBVninGN35SeahmfG/tMjR7MRxpQ=
X-Received: by 2002:a25:e406:: with SMTP id b6mr55301906ybh.529.1638917684832;
 Tue, 07 Dec 2021 14:54:44 -0800 (PST)
MIME-Version: 1.0
References: <20211204140700.396138-1-jolsa@kernel.org> <20211204140700.396138-4-jolsa@kernel.org>
 <7df54ca3-1bae-4d54-e30f-c2474c48ede0@fb.com> <Ya+kg3SPcBU4loIz@krava>
In-Reply-To: <Ya+kg3SPcBU4loIz@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Dec 2021 14:54:33 -0800
Message-ID: <CAEf4BzbAVO-SGub8+haDayhnL_VLyYAof8eUB_d6Qp18yC2Adw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add tests for
 get_func_[arg|ret|arg_cnt] helpers
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 10:14 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Dec 06, 2021 at 02:03:54PM -0800, Andrii Nakryiko wrote:
> >
> > On 12/4/21 6:07 AM, Jiri Olsa wrote:
> > > Adding tests for get_func_[arg|ret|arg_cnt] helpers.
> > > Using these helpers in fentry/fexit/fmod_ret programs.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >   .../bpf/prog_tests/get_func_args_test.c       |  38 ++++++
> > >   .../selftests/bpf/progs/get_func_args_test.c  | 112 ++++++++++++++++++
> > >   2 files changed, 150 insertions(+)
> > >   create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
> > >   create mode 100644 tools/testing/selftests/bpf/progs/get_func_args_test.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
> > > new file mode 100644
> > > index 000000000000..c24807ae4361
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
> > > @@ -0,0 +1,38 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <test_progs.h>
> > > +#include "get_func_args_test.skel.h"
> > > +
> > > +void test_get_func_args_test(void)
> > > +{
> > > +   struct get_func_args_test *skel = NULL;
> > > +   __u32 duration = 0, retval;
> > > +   int err, prog_fd;
> > > +
> > > +   skel = get_func_args_test__open_and_load();
> > > +   if (!ASSERT_OK_PTR(skel, "get_func_args_test__open_and_load"))
> > > +           return;
> > > +
> > > +   err = get_func_args_test__attach(skel);
> > > +   if (!ASSERT_OK(err, "get_func_args_test__attach"))
> > > +           goto cleanup;
> > > +
> > > +   prog_fd = bpf_program__fd(skel->progs.test1);
> > > +   err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > > +                           NULL, NULL, &retval, &duration);
> > > +   ASSERT_OK(err, "test_run");
> > > +   ASSERT_EQ(retval, 0, "test_run");
> > > +
> > > +   prog_fd = bpf_program__fd(skel->progs.fmod_ret_test);
> > > +   err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > > +                           NULL, NULL, &retval, &duration);
> > > +   ASSERT_OK(err, "test_run");
> > > +   ASSERT_EQ(retval, 1234, "test_run");
> >
> >
> > are the other two programs executed implicitly during one of those test
> > runs? Can you please leave a small comment somewhere here if that's true?
>
> test1 triggers all the bpf_fentry_test* fentry/fexits
> fmod_ret_test triggers the rest, I'll put it in comment
>
> >
> >
> > > +
> > > +   ASSERT_EQ(skel->bss->test1_result, 1, "test1_result");
> > > +   ASSERT_EQ(skel->bss->test2_result, 1, "test2_result");
> > > +   ASSERT_EQ(skel->bss->test3_result, 1, "test3_result");
> > > +   ASSERT_EQ(skel->bss->test4_result, 1, "test4_result");
> > > +
> > > +cleanup:
> > > +   get_func_args_test__destroy(skel);
> > > +}
> > > diff --git a/tools/testing/selftests/bpf/progs/get_func_args_test.c b/tools/testing/selftests/bpf/progs/get_func_args_test.c
> > > new file mode 100644
> > > index 000000000000..0d0a67c849ae
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/progs/get_func_args_test.c
> > > @@ -0,0 +1,112 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <linux/bpf.h>
> > > +#include <bpf/bpf_helpers.h>
> > > +#include <bpf/bpf_tracing.h>
> > > +#include <errno.h>
> > > +
> > > +char _license[] SEC("license") = "GPL";
> > > +
> > > +__u64 test1_result = 0;
> > > +SEC("fentry/bpf_fentry_test1")
> > > +int BPF_PROG(test1)
> > > +{
> > > +   __u64 cnt = bpf_get_func_arg_cnt(ctx);
> > > +   __u64 a = 0, z = 0, ret = 0;
> > > +   __s64 err;
> > > +
> > > +   test1_result = cnt == 1;
> > > +
> > > +   /* valid arguments */
> > > +   err = bpf_get_func_arg(ctx, 0, &a);
> > > +   test1_result &= err == 0 && (int) a == 1;
> >
> >
> > int cast unnecessary? but some ()'s wouldn't hurt...
>
> it is, 'a' is int and trampoline saves it with 32-bit register like:
>
>   mov    %edi,-0x8(%rbp)
>
> so the upper 4 bytes are not zeroed

oh, this is definitely worth a comment, it's quite a big gotcha we'll
need to remember


>
> >
> >
> > > +
> > > +   /* not valid argument */
> > > +   err = bpf_get_func_arg(ctx, 1, &z);
> > > +   test1_result &= err == -EINVAL;
> > > +
> > > +   /* return value fails in fentry */
> > > +   err = bpf_get_func_ret(ctx, &ret);
> > > +   test1_result &= err == -EINVAL;
> > > +   return 0;
> > > +}
> > > +
> > > +__u64 test2_result = 0;
> > > +SEC("fexit/bpf_fentry_test2")
> > > +int BPF_PROG(test2)
> > > +{
> > > +   __u64 cnt = bpf_get_func_arg_cnt(ctx);
> > > +   __u64 a = 0, b = 0, z = 0, ret = 0;
> > > +   __s64 err;
> > > +
> > > +   test2_result = cnt == 2;
> > > +
> > > +   /* valid arguments */
> > > +   err = bpf_get_func_arg(ctx, 0, &a);
> > > +   test2_result &= err == 0 && (int) a == 2;
> > > +
> > > +   err = bpf_get_func_arg(ctx, 1, &b);
> > > +   test2_result &= err == 0 && b == 3;
> > > +
> > > +   /* not valid argument */
> > > +   err = bpf_get_func_arg(ctx, 2, &z);
> > > +   test2_result &= err == -EINVAL;
> > > +
> > > +   /* return value */
> > > +   err = bpf_get_func_ret(ctx, &ret);
> > > +   test2_result &= err == 0 && ret == 5;
> > > +   return 0;
> > > +}
> > > +
> > > +__u64 test3_result = 0;
> > > +SEC("fmod_ret/bpf_modify_return_test")
> > > +int BPF_PROG(fmod_ret_test, int _a, int *_b, int _ret)
> > > +{
> > > +   __u64 cnt = bpf_get_func_arg_cnt(ctx);
> > > +   __u64 a = 0, b = 0, z = 0, ret = 0;
> > > +   __s64 err;
> > > +
> > > +   test3_result = cnt == 2;
> > > +
> > > +   /* valid arguments */
> > > +   err = bpf_get_func_arg(ctx, 0, &a);
> > > +   test3_result &= err == 0 && (int) a == 1;
> > > +
> > > +   err = bpf_get_func_arg(ctx, 1, &b);
> > > +   test3_result &= err == 0;
> >
> >
> > why no checking of b value here?
>
> right, ok
>
> >
> > > +
> > > +   /* not valid argument */
> > > +   err = bpf_get_func_arg(ctx, 2, &z);
> > > +   test3_result &= err == -EINVAL;
> > > +
> > > +   /* return value */
> > > +   err = bpf_get_func_ret(ctx, &ret);
> > > +   test3_result &= err == 0 && ret == 0;
> > > +   return 1234;
> > > +}
> > > +
> > > +__u64 test4_result = 0;
> > > +SEC("fexit/bpf_modify_return_test")
> > > +int BPF_PROG(fexit_test, int _a, __u64 _b, int _ret)
> > > +{
> > > +   __u64 cnt = bpf_get_func_arg_cnt(ctx);
> > > +   __u64 a = 0, b = 0, z = 0, ret = 0;
> > > +   __s64 err;
> > > +
> > > +   test4_result = cnt == 2;
> > > +
> > > +   /* valid arguments */
> > > +   err = bpf_get_func_arg(ctx, 0, &a);
> > > +   test4_result &= err == 0 && (int) a == 1;
> > > +
> > > +   err = bpf_get_func_arg(ctx, 1, &b);
> > > +   test4_result &= err == 0;
> >
> >
> > same, for consistency, b should have been checked, no?
>
> ok
>
> thanks,
> jirka
>
