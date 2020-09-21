Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DED2736AF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgIUXc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUXc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:32:26 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CEBC061755;
        Mon, 21 Sep 2020 16:32:26 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u21so12544706ljl.6;
        Mon, 21 Sep 2020 16:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xtUNWeu8dteoz4XBiz8jWFo83W9FMdhO8jzRvy8mI2g=;
        b=tVmYKd1MoZhxR4nmxzA00OP0ROKz9PbbbqJZj9GjVP4nnnYY9nq6OVAFaO43UW1OPJ
         Gq6unKBl+grVakbNpYPIgbWkJJfyx4H43dV+dt6Trjapbewn0TVstDeaSvhB3w2qhxZo
         qPD+9Ft1jGwsj+a6un6XjLEDh6uy/0r9AnmLhomlpAiz0t+xH/pVe/Y5r1xWROFMBM9U
         g8qpVa4KmgrvV7k0FN0CnNVJLsRTaJTbBr6B7IF7JzSKFCxw3S5ADjhmU1RI79Qy4o9P
         4qvEsO/K1XkCCozBzquh+6yxFDpoc0OYbuo9t/Rp5d9MkmxEmguJnViNmjUWD+VpflND
         makA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xtUNWeu8dteoz4XBiz8jWFo83W9FMdhO8jzRvy8mI2g=;
        b=RMBy8tgk+vHYb86Rawhsj/Nde9qCGCArdZXhyZzcYaSIjKAEKVZTW7mApzHWOZOQMQ
         8vXPx3oQhF9iPnlyy53ko25i60+DUe5nCsuR4kkazcDflZFk59pKrhnXblYwBAyi6UJi
         3g/DknW4Tk4peePFbNm2bmNkx33LVQZKUbmb2sBVUw6uXH8hiyQKYlLfAD6GbMeZDtuI
         LSI+4i3Jb1sw13eRYb9x8RfDmuUidip81T140oEbs2Rx2SPaKTXq+JI4n4K7TKGODyNl
         Wf5qfiyGjdHxr7GqLwgZ4N/mXowgrbjKgGFDTnGkwbsUYpGlyasNmyNCMU2/+/uZgf97
         bRmQ==
X-Gm-Message-State: AOAM530vMSm3a42vlorPlMBgpjeAWFAeG5x82Myj6s/7j1xbBZNUx1pu
        bnnwVbiJp0RIQkLUgz52ynJ3idxsxm4/fyFjX2sVRPm/ozw=
X-Google-Smtp-Source: ABdhPJw0WDb6gaU2PczRTf9JfNCIy2P9m+eA/6kh/ZSqleHcps22l98Mt4NsOaO25Qmk/JPBUw1mOAUbXCNoOeyUMYc=
X-Received: by 2002:a2e:d01:: with SMTP id 1mr632015ljn.121.1600731144694;
 Mon, 21 Sep 2020 16:32:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200918112338.2618444-1-jolsa@kernel.org>
In-Reply-To: <20200918112338.2618444-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Sep 2020 16:32:13 -0700
Message-ID: <CAADnVQ+OmqycbKTewWPA9D5upP9Ri-yvS1=GKRN1nQs6AL_YVw@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next] selftests/bpf: Fix stat probe in d_path test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 4:23 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Some kernels builds might inline vfs_getattr call within fstat
> syscall code path, so fentry/vfs_getattr trampoline is not called.
>
> Alexei suggested [1] we should use security_inode_getattr instead,
> because it's less likely to get inlined. Using this idea also for
> vfs_truncate (replaced with security_path_truncate) and vfs_fallocate
> (replaced with security_file_permission).
>
> Keeping dentry_open and filp_close, because they are in their own
> files, so unlikely to be inlined, but in case they are, adding
> security_file_open.
>
> Switching the d_path test stat trampoline to security_inode_getattr.
>
> Adding flags that indicate trampolines were called and failing
> the test if any of them got missed, so it's easier to identify
> the issue next time.
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> [1] https://lore.kernel.org/bpf/CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com/
> Fixes: e4d1af4b16f8 ("selftests/bpf: Add test for d_path helper")
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
> v2 changes:
>   - replaced vfs_* function with security_* in d_path allow list
>     vfs_truncate  -> security_path_truncate
>     vfs_fallocate -> security_file_permission
>     vfs_getattr   -> security_inode_getattr
>   - added security_file_open to d_path allow list
>   - split verbose output for trampoline flags
>
>  kernel/trace/bpf_trace.c                        |  7 ++++---
>  tools/testing/selftests/bpf/prog_tests/d_path.c | 10 ++++++++++
>  tools/testing/selftests/bpf/progs/test_d_path.c |  9 ++++++++-
>  3 files changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b2a5380eb187..e24323d72cac 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1118,10 +1118,11 @@ BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
>  }
>
>  BTF_SET_START(btf_allowlist_d_path)
> -BTF_ID(func, vfs_truncate)
> -BTF_ID(func, vfs_fallocate)
> +BTF_ID(func, security_path_truncate)
> +BTF_ID(func, security_file_permission)
> +BTF_ID(func, security_inode_getattr)
> +BTF_ID(func, security_file_open)
>  BTF_ID(func, dentry_open)
> -BTF_ID(func, vfs_getattr)
>  BTF_ID(func, filp_close)
>  BTF_SET_END(btf_allowlist_d_path)

bpf CI system flagged the build error:
FAILED unresolved symbol security_path_truncate
because CONFIG_SECURITY_PATH wasn't set.
Which points to the issue with this patch that the above
security_* funcs have to be guarded with appropriate #ifdef.
I don't have a use case for tracing vfs_truncate, but
security_path_unlink I would want to do in the future.
Unfortunately it's under the same SECURITY_PATH ifdef.
So my earlier desire to make it fool proof is not feasible at this point.
Adding 'was_probed_func_inlined' check to libbpftrace.a would
solve it eventually.
For now I think we have to live with this function probing fragility.
So I've modified the patch to add these few security_* funcs
and kept vfs_* equivalents.
Also reworded commit log and applied to bpf-next. Thanks
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=a8a717963fe5ecfd274eb93dd1285ee9428ffca7
