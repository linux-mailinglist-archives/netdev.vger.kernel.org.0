Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30913231324
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgG1TxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgG1TxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:53:12 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75594C061794;
        Tue, 28 Jul 2020 12:53:12 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id t6so4804923qvw.1;
        Tue, 28 Jul 2020 12:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFnebe0rsf16Ital1PxCLlm4jXaeU/dlrpfp7jc2lKI=;
        b=Esld6XUPtN2Lbg5Z/4TOV6+LZ5mFlNKL48bJ0nTchCWPbWO5MtoPHoP4yISyYoN5ry
         SkqUiGALRhZhKzMgop1e3mWmuOY/fMGRV2ugED5MCmpL4Hts8xxqFkpw59J/w5jDQY/X
         OzgPPNAWpcIedxUSUgGVjQTkBqDHJVfG8mdvIQ75Hg7ejIhC4NxMEmaVCvnNxzFrNYS+
         qmdLs19xRiuVqg36OG0dMHaSSoAfzcao5fKA8EYzjrhqqQcHliw0D1V7Zhdg7EGNHwal
         6Z/FZFvNP5EEQnTb/ZNE2jc4vB2kjt9NJqxMH1FP0ePP3Jq3tP/42cHtZD8rWJk4M4yv
         wwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFnebe0rsf16Ital1PxCLlm4jXaeU/dlrpfp7jc2lKI=;
        b=XCNH63kR1AgTvjKWAzAmfuTit4yOQ+yc4nDTmUGXJmvpgL8vSr86s98arbLDJC/yQ9
         568OtnN+RA4wbnDAPJ1oMQlGDGR8rPiYnCeFq3cFqXY4MEd/YamQxCWkVFR/+Y2B6rMx
         L/gGolFTQokSuFe23ZJeQEhJS6yFToNjdomXcgg7If+6BiiCFFL0SMQEQ18K8HAy1+A0
         uHcSgL9CZmOXYOvTkWOg/FID7WXWSI0fH3xS+QhjgBluh3yGl8SXd1I6sj6Ef5e1cnxu
         HUnrfgdKWSJWq8Pv1vR85QDmUf6Zx/S/cZ42BZz2va2/Lv3c5IcrDY5EaJU8vz1KX+sy
         FFEw==
X-Gm-Message-State: AOAM530onYpPspXA+oOTr8B7VF5e96UEsHPyuRkHGrnf1Lzx+HgAPflJ
        8UexggD23dbrOfF4y6mQVBXOqrjKXyxg1KM3PJMEAM1o
X-Google-Smtp-Source: ABdhPJyDq5uaj6D6ZCVS3p+XxGn9ynGsBLI8WMlr6BftVWZyxlS7orAbrYAbwS4EJU6Bg1L2HM5MwJMaQNrvfpxScqI=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr28168888qvf.247.1595965991704;
 Tue, 28 Jul 2020 12:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-13-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-13-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 12:53:00 -0700
Message-ID: <CAEf4BzYTT23knreKpxPDLeWcLzTVQhtBrRPjrZ+MBpL4ajeavw@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 12/13] selftests/bpf: Add test for d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 2:14 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test for d_path helper which is pretty much
> copied from Wenbo Zhang's test for bpf_get_fd_path,
> which never made it in.
>
> The test is doing fstat/close on several fd types,
> and verifies we got the d_path helper working on
> kernel probes for vfs_getattr/filp_close functions.
>
> Original-patch-by: Wenbo Zhang <ethercflow@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../testing/selftests/bpf/prog_tests/d_path.c | 162 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_d_path.c |  64 +++++++
>  2 files changed, 226 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
> new file mode 100644
> index 000000000000..3b8f87fb17d7
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
> @@ -0,0 +1,162 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include <sys/stat.h>
> +#include <linux/sched.h>
> +#include <sys/syscall.h>
> +
> +#define MAX_PATH_LEN           128
> +#define MAX_FILES              7
> +#define MAX_EVENT_NUM          16
> +
> +#include "test_d_path.skel.h"
> +
> +static struct {
> +       __u32 cnt;
> +       char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> +} src;
> +
> +static int set_pathname(int fd, pid_t pid)
> +{
> +       char buf[MAX_PATH_LEN];
> +
> +       snprintf(buf, MAX_PATH_LEN, "/proc/%d/fd/%d", pid, fd);
> +       return readlink(buf, src.paths[src.cnt++], MAX_PATH_LEN);
> +}
> +
> +static int trigger_fstat_events(pid_t pid)
> +{
> +       int sockfd = -1, procfd = -1, devfd = -1;
> +       int localfd = -1, indicatorfd = -1;
> +       int pipefd[2] = { -1, -1 };
> +       struct stat fileStat;
> +       int ret = -1;
> +
> +       /* unmountable pseudo-filesystems */
> +       if (CHECK_FAIL(pipe(pipefd) < 0))
> +               return ret;
> +       /* unmountable pseudo-filesystems */
> +       sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +       if (CHECK_FAIL(sockfd < 0))
> +               goto out_close;
> +       /* mountable pseudo-filesystems */
> +       procfd = open("/proc/self/comm", O_RDONLY);
> +       if (CHECK_FAIL(procfd < 0))
> +               goto out_close;
> +       devfd = open("/dev/urandom", O_RDONLY);
> +       if (CHECK_FAIL(devfd < 0))
> +               goto out_close;
> +       localfd = open("/tmp/d_path_loadgen.txt", O_CREAT | O_RDONLY);
> +       if (CHECK_FAIL(localfd < 0))
> +               goto out_close;
> +       /* bpf_d_path will return path with (deleted) */
> +       remove("/tmp/d_path_loadgen.txt");
> +       indicatorfd = open("/tmp/", O_PATH);
> +       if (CHECK_FAIL(indicatorfd < 0))
> +               goto out_close;
> +
> +       ret = set_pathname(pipefd[0], pid);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(pipefd[1], pid);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(sockfd, pid);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(procfd, pid);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(devfd, pid);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(localfd, pid);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;
> +       ret = set_pathname(indicatorfd, pid);
> +       if (CHECK_FAIL(ret < 0))
> +               goto out_close;

Please use CHECK instead of CHECK_FAIL. Thanks.

> +
> +       /* triggers vfs_getattr */
> +       fstat(pipefd[0], &fileStat);
> +       fstat(pipefd[1], &fileStat);
> +       fstat(sockfd, &fileStat);
> +       fstat(procfd, &fileStat);
> +       fstat(devfd, &fileStat);
> +       fstat(localfd, &fileStat);
> +       fstat(indicatorfd, &fileStat);
> +
> +out_close:
> +       /* triggers filp_close */
> +       close(pipefd[0]);
> +       close(pipefd[1]);
> +       close(sockfd);
> +       close(procfd);
> +       close(devfd);
> +       close(localfd);
> +       close(indicatorfd);
> +       return ret;
> +}
> +

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
> new file mode 100644
> index 000000000000..e02dce614256
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_d_path.c
> @@ -0,0 +1,64 @@
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
> +int rets_stat[MAX_EVENT_NUM];
> +int rets_close[MAX_EVENT_NUM];
> +

please zero-initialize all of these, it causes issues on some Clang versions

[...]
