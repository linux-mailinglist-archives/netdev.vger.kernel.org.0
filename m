Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D1520BBF6
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgFZVzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZVzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:55:46 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9952AC03E979;
        Fri, 26 Jun 2020 14:55:46 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e11so10228210qkm.3;
        Fri, 26 Jun 2020 14:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o1EHNnZCUnXFxkUA/oLBF3fOGOdmCt42NiXP+2hmzMc=;
        b=qQHcC4ZBJ3zZSfu/9SLFDvUPeQpMk00iHBTURli5JnGOvhrzQod/U0aMQXL8l2WLG/
         UdAZVxNGnDBusFtWZubNNh86F5UBYmLkt6XupCSaVXg6HK7NXrTscQvRQ5Uo1P0J5yAc
         jDsMCE4n98h5RkPe52YuSXnbOLhi1vfJk1FD6HxIwHvIhpmabOVA34bvPLXHsYU32zMb
         rWYiHX8Rql0A/sJ4johS406y7QAh5Ex1CIQ/B5fvVQS2vPf8m/dbgDUDfrpb19nb7T1c
         GnSo9XY1/x7CLqJKddYFVZ9MX1wjRJEeL2WdJkk7kdyBhPteyT3ACn53hodPXgMynDD8
         FriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o1EHNnZCUnXFxkUA/oLBF3fOGOdmCt42NiXP+2hmzMc=;
        b=iCBZ+nqRdArFD1vivu+MuE2nW4WHoYNbpzIjHtUdbOCF8TYTbz4jmoTGrsX4yenFTj
         OyjE7y9T6q3BPhpRG2u9FqcnUTtNoOiqbVXQAjh513zACyNa937Pnqsf6AStskt04xUJ
         P6L0w8+oOwc027yv8/PuDqryK+m04q9RNfd4Kq0w8j1ZX2MGwgUOr58cWe6QPalbOltb
         edEOfJn2OGwjdfN7AtasDZ5Zi23XhNuPw7ZwGZb32x6+bxjWDlY9xIkQo4RtEKcT40ql
         KrrRTdVLmmUbJv8qBRI6CnAywuE3qutVm3uQEAoYWZ/zijSu3EbrCrf+0qP9Anv4cu3K
         E84Q==
X-Gm-Message-State: AOAM532FEAJjcCPTGqFBgnNR1Wi8k7vkZulox7uzJbLn5gm+JjEeGCdU
        BklvgN1Zmlst6DuXdlj6zaGQrVGndARckik3rpI=
X-Google-Smtp-Source: ABdhPJwkA9ekJJ9M8nqEHrMlYL2BD3BJZ1mDRCivll8aPnTAeCKrvH2tOpIbus7du/BAuyYE2COpbUReYKxns3Hn8Uw=
X-Received: by 2002:a37:7683:: with SMTP id r125mr2667132qkc.39.1593208545856;
 Fri, 26 Jun 2020 14:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-14-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-14-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 14:55:34 -0700
Message-ID: <CAEf4BzYpYXN6nZc1CT3ZHUoeYfALK_SY2cLUZ7G72ka5GL_33Q@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 13/14] selftests/bpf: Add test for d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test for d_path helper which is pretty much
> copied from Wenbo Zhang's test for bpf_get_fd_path,
> which never made it in.
>
> I've failed so far to compile the test with <linux/fs.h>
> kernel header, so for now adding 'struct file' with f_path
> member that has same offset as kernel's file object.
>
> Original-patch-by: Wenbo Zhang <ethercflow@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../testing/selftests/bpf/prog_tests/d_path.c | 145 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_d_path.c |  50 ++++++
>  2 files changed, 195 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
> new file mode 100644
> index 000000000000..6096aef2bafc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_d_path.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +#define MAX_PATH_LEN           128
> +#define MAX_EVENT_NUM          16
> +
> +pid_t my_pid;
> +__u32 cnt_stat;
> +__u32 cnt_close;
> +char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
> +char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
> +
> +SEC("fentry/vfs_getattr")
> +int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
> +            __u32 request_mask, unsigned int query_flags)
> +{
> +       pid_t pid = bpf_get_current_pid_tgid() >> 32;
> +
> +       if (pid != my_pid)
> +               return 0;
> +
> +       if (cnt_stat >= MAX_EVENT_NUM)
> +               return 0;
> +
> +       bpf_d_path(path, paths_stat[cnt_stat], MAX_PATH_LEN);
> +       cnt_stat++;
> +       return 0;
> +}
> +
> +SEC("fentry/filp_close")
> +int BPF_PROG(prog_close, struct file *file, void *id)
> +{
> +       pid_t pid = bpf_get_current_pid_tgid() >> 32;
> +
> +       if (pid != my_pid)
> +               return 0;
> +
> +       if (cnt_close >= MAX_EVENT_NUM)
> +               return 0;
> +
> +       bpf_d_path((struct path *) &file->f_path,
> +                  paths_close[cnt_close], MAX_PATH_LEN);

Can you please capture the return result of bpf_d_path() (here and
above) and validate that it's correct? That will help avoid future
breakages if anyone changes this.

> +       cnt_close++;
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.25.4
>
