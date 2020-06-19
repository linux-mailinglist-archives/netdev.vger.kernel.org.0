Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E53200158
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 06:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgFSEoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 00:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFSEoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 00:44:38 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDDAC06174E;
        Thu, 18 Jun 2020 21:44:36 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z2so4251767qts.5;
        Thu, 18 Jun 2020 21:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SI3ZLIRsj68LNAmSivNJI1K6mDIGZCfGLgWYLBDxIJE=;
        b=NSnEdblFPxqZLdG8kXUDSQbnLfZxXQkKuLZr7YQRgjAmpffk1UvixoZTrKbPw6t5Pp
         IA8osdiedHsjjLh5OzSAmhApCg4DcDH5lc328HDhIXvhsXMceZ2TJQIUFcrSQyCw4IGd
         fMGapCxVvihHeuftfatAgFk6tgQkivJDmm8cgbfjHS2wOKixcLihfwzsrfy7plqcHm3i
         NCufYTYFpnOH3tglMaMs4ypOLxzUjVhjQunCcyiMWmbyU37wjjuX94IRYiZehlwfUrBc
         eKltBJBSPQaLG9VijdWQsXsoN3J+qzlrETPDqHK12cdEXFvZf6AFW3fO7aydzqHqgjUh
         T/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SI3ZLIRsj68LNAmSivNJI1K6mDIGZCfGLgWYLBDxIJE=;
        b=W4oto576ETSQYKdYPro9wVW1f/IedfLjF1drJ/KbcJXVGYOGNPBpgVso5MQmQ/CbVY
         hSfvPgDw8cByetXQviz/D35adrgbtOag6XRtLB1Rqntgfxit2yPffWGS+OvubVVYRWkw
         ZVP0Re30+41WoABTWYEKbKvTTHlcNbAAJlbZiI8cXkbyl8cnWl0hK7Q0tVPvw2ktvjif
         0l1ORcl/PsrpmHTgSZspP4YMlPvJRIny1LQLpXBPYSnM/ZfaMwC2fBZoeaSPGy/BQ0gc
         aGGxe9RsQ2cqa66wGeZDtTJW3ZdIp4QMM+syoR52Vebm5ZIlscDZe0oBpl7hNy7KXcSA
         sePA==
X-Gm-Message-State: AOAM5323y9pepvDbZbxLAtjOymjPfZkryOFgCk2HkxW826io8ZlafCUS
        7exY2iTg0TBf4tc2Gv0iELfzrBoOElmgbOke1/erxSJK
X-Google-Smtp-Source: ABdhPJxnZX0uZast0PWDypYVqW02DaXm7VCj3yp5tCzAnBwFtWoRYdazDhng+N0e+TqXxbNzcaN1rDreX4nFVzqf8wk=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr1601745qtm.171.1592541874737;
 Thu, 18 Jun 2020 21:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-12-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-12-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 21:44:23 -0700
Message-ID: <CAEf4BzZmNFUBdSzCLiiQ-anQRmnzd-E1qa0wVdXHu0pYV_-=Nw@mail.gmail.com>
Subject: Re: [PATCH 11/11] selftests/bpf: Add test for d_path helper
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

On Tue, Jun 16, 2020 at 3:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
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
>  .../testing/selftests/bpf/prog_tests/d_path.c | 153 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_d_path.c |  55 +++++++
>  2 files changed, 208 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
> new file mode 100644
> index 000000000000..e2b7dfeb506f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
> @@ -0,0 +1,153 @@
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
> +struct d_path_test_data {
> +       pid_t pid;
> +       __u32 cnt_stat;
> +       __u32 cnt_close;
> +       char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
> +       char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
> +};

with skeleton there is no point in defining this container struct, and
especially duplicating it between BPF code and user-space code. Just
declare all those fields as global variables and access them from
skeleton directly.

[...]

> diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
> new file mode 100644
> index 000000000000..1b478c00ee7a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_d_path.c
> @@ -0,0 +1,55 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +#define MAX_PATH_LEN           128
> +#define MAX_EVENT_NUM          16
> +
> +static struct d_path_test_data {
> +       pid_t pid;
> +       __u32 cnt_stat;
> +       __u32 cnt_close;
> +       char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
> +       char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
> +} data;
> +
> +struct path;
> +struct kstat;

both structs are in vmlinux.h, you shouldn't need this.

[...]

>
