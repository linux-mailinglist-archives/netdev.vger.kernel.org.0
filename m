Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38551436D98
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhJUWkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhJUWki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 18:40:38 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14029C061764;
        Thu, 21 Oct 2021 15:38:22 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id v200so2665798ybe.11;
        Thu, 21 Oct 2021 15:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mX0gvzf/8QgI7lZxsXDzZG6vg6V+U9yQ0ZFCiOuBHEo=;
        b=KonIF20sHgoOuKrWtmsRSJMbRoVsWrVKS7hixfNEbWzYzmdNQOUHSeH2r3EEdg8dx1
         RrJekPfWfHsiNT+WMokibqdKZN4GBvnyCyDokh2s4wYfQR5Y3xqh/b1LKTpW9f1bnps9
         hMeTeAn4xtpUCBbol1qcC8fnhs2XLafB/BEmuaPNFcjGCcTiH2+sKDrrUkAPadKzJRMs
         TRcPZastxBaMNAoROM/WhbhChKVCmOLuScNq5KeWC01+x92K/cSsPZONKzuiAnLjUJCj
         hxgeEKqqhKqCVQI22wcEcNnQ0E/bxPixyGn/4IXj+kd+lZ69I+IvDw3aWOESF8khVoqd
         XZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mX0gvzf/8QgI7lZxsXDzZG6vg6V+U9yQ0ZFCiOuBHEo=;
        b=Q/u8i9iN1zdkOv5PA3EWP1ooJBZt7LmZSlR+Zu2bWU7JPrZHKqqeVckbvsC6eXJkEx
         IJZQa9P+GRBEv5mcELx0OAeLcKWd4kltiGHs6o8hWt7r5ifOku63scHA7KH0EisxDIca
         L3tYcb7DqW8Haa1xDwVjXX8VW/IxqmHdUn9jIFacBQ7fpN3XQpbvTvfNZO+F6RfgChmv
         MahtQHwMcHWAEurOm7lHPm2c+nT0woYatyZ74OYwZGIKRCISJAaOn5aQ7jrTgLCoereC
         dZetLAjNpEUKT0jjP4qow2sJM68PyyII73YQNMPgJrGpGBb65RpQSHpW/tz83waZmO2L
         ICBQ==
X-Gm-Message-State: AOAM532kfrKg2QX3mBKvy2NFKzEvHwGlHO84d5CoOAMC6X8em0V8d3hl
        suWiWNJ4ZQ/1mM/MHT9Rp+qkYgI1lnTJLtsgqfU=
X-Google-Smtp-Source: ABdhPJxwUn/Nw+hFDNm25s6Pp6fp7TE4u5/M+TC0Rh+aiycuH8FRg6i2NM/ST69jmyv4dEGj0gNMW/Xcj4JwPvITPTg=
X-Received: by 2002:a25:5606:: with SMTP id k6mr9160954ybb.51.1634855901340;
 Thu, 21 Oct 2021 15:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211021034603.4458-1-laoar.shao@gmail.com> <20211021034603.4458-2-laoar.shao@gmail.com>
In-Reply-To: <20211021034603.4458-2-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Oct 2021 15:38:10 -0700
Message-ID: <CAEf4BzbLzVEXd0FO6MRuVJA=CO7zbgSrx8c0JcuR_1K=bq1OcA@mail.gmail.com>
Subject: Re: [PATCH v5 11/15] tools/bpf/bpftool: use TASK_COMM_LEN_16 instead
 of hard-coded 16
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        Christian Brauner <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>, juri.lelli@redhat.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        oliver.sang@intel.com, kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 8:46 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Use TASK_COMM_LEN_16 instead of hard-coded 16 to make it more grepable.
> It uses bpf_probe_read_kernel() to get task comm, which may return a
> string without nul terminator. We should use bpf_probe_read_kernel_str()
> instead.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
>  tools/bpf/bpftool/Makefile                | 1 +
>  tools/bpf/bpftool/main.h                  | 3 ++-
>  tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 4 ++--
>  tools/bpf/bpftool/skeleton/pid_iter.h     | 4 +++-
>  4 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index d73232be1e99..33fbde84993c 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -164,6 +164,7 @@ $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
>         $(QUIET_CLANG)$(CLANG) \
>                 -I$(if $(OUTPUT),$(OUTPUT),.) \
>                 -I$(srctree)/tools/include/uapi/ \
> +               -I$(srctree)/tools/include/ \

bpftool shouldn't rely on internal kernel headers for compilation. If
you want to have TASK_COMM_LEN_16 constant for grep-ability, just
#define it where appropriate

>                 -I$(LIBBPF_PATH) \
>                 -I$(srctree)/tools/lib \
>                 -g -O2 -Wall -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index 90caa42aac4c..5efa27188f68 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -12,6 +12,7 @@
>  #include <linux/compiler.h>
>  #include <linux/kernel.h>
>  #include <linux/hashtable.h>
> +#include <linux/sched/task.h>
>  #include <tools/libc_compat.h>
>

[...]
