Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3A54AC918
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiBGTDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiBGS7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:59:34 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34699C0401DA;
        Mon,  7 Feb 2022 10:59:33 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id d188so18103282iof.7;
        Mon, 07 Feb 2022 10:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlrx6oXPWSCnqM3cUMtMWElzYbWeRlSOVTIPXdMAcp0=;
        b=Kobk08ev20I14u062NpF1aA4nm+9R2w5y5z03ItBJidXCDyhlupcisTv8DC6F/fcF0
         A2MZge/ylEqd4cZF6TujkVWp+blLYVFi2PbGlx0bnrDp5iM6PdrxhxFOIQW+TYqfofhB
         B0OeQTaMOGms+ciUf4c9YnS64/TuUC+S+d9koxfUzO3vnpIqrIXvMZd4owQV9+08xdJV
         DUqEeEOrM+jirUzUbIVv3retKv1GEvshQp8PhoAdUxfMRsyRoPDODOTNjxhj6O1EWZZZ
         q04ZWyPi74s/Yx/pU1bbwfri8S+F1t59Pu/HqxB2e/blRelZXRZAANauzetzCbg9ZESm
         5SaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vlrx6oXPWSCnqM3cUMtMWElzYbWeRlSOVTIPXdMAcp0=;
        b=LC8+wWgQo50LBabM0TItp4b+Wo15AWK+G0GbnJs8yYBS9sflM+CJmyht1KFU0mJ5TJ
         T+KEAmv5h77VemE+MxBxIcNZ8ODpZadng6Y2fTyCI+b/xaC8rqd8xzIiLj8hFtzB2eEP
         LMgdgFCyXfzQCMgr4mV/kjLQNBUxzhVJCR2b+vhcPSPBWRf/NLMFG0pBeHYI0ymsW7NT
         7zh4/yzBr9WN5kN7BUzalsfzSk5GtaKkmWjQqw9lulIhpgtooU/y71pxw+xYgF7hDOGl
         HEjl6hx47c1NKu5zRAbMHp1VokmZRjkeVVMm5/ZAh2HzmGATbloncolaJCNNQo3NZy9E
         /ksw==
X-Gm-Message-State: AOAM533UtE9WCEnrqIFr+A7TQhJ8ffjg9iJTcvbvHANuXrZhamTn9oKd
        JwzgNfDIwWblLloRndaroozf9cVPvK0IBtkaNCd2ZvEA
X-Google-Smtp-Source: ABdhPJxlFUfYEdMi+0QmyxVvtBh2f9mww9fZ/WLSrkOV0ImB8kOwyePRXLbSxQ5zS/MvQkDTA6DtT7xm+4Wd72Hovu4=
X-Received: by 2002:a5e:8406:: with SMTP id h6mr456908ioj.144.1644260372560;
 Mon, 07 Feb 2022 10:59:32 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-4-jolsa@kernel.org>
In-Reply-To: <20220202135333.190761-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Feb 2022 10:59:21 -0800
Message-ID: <CAEf4BzbPeQbURZOD93TgPudOk3JD4odsZ9uwriNkrphes9V4dg@mail.gmail.com>
Subject: Re: [PATCH 3/8] bpf: Add bpf_cookie support to fprobe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 5:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding support to call bpf_get_attach_cookie helper from
> kprobe program attached by fprobe link.
>
> The bpf_cookie is provided by array of u64 values, where
> each value is paired with provided function address with
> the same array index.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h            |  2 +
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/syscall.c           | 83 +++++++++++++++++++++++++++++++++-
>  kernel/trace/bpf_trace.c       | 16 ++++++-
>  tools/include/uapi/linux/bpf.h |  1 +
>  5 files changed, 100 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6eb0b180d33b..7b65f05c0487 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1301,6 +1301,8 @@ static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
>  #endif
>  }
>
> +u64 bpf_fprobe_cookie(struct bpf_run_ctx *ctx, u64 ip);
> +
>  /* BPF program asks to bypass CAP_NET_BIND_SERVICE in bind. */
>  #define BPF_RET_BIND_NO_CAP_NET_BIND_SERVICE                   (1 << 0)
>  /* BPF program asks to set CN on the packet. */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c0912f0a3dfe..0dc6aa4f9683 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1484,6 +1484,7 @@ union bpf_attr {
>                                 __aligned_u64   addrs;
>                                 __u32           cnt;
>                                 __u32           flags;
> +                               __aligned_u64   bpf_cookies;

maybe put it right after addrs, they are closely related and cnt
describes all of syms/addrs/cookies.

>                         } fprobe;
>                 };
>         } link_create;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 0cfbb112c8e1..6c5e74bc43b6 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -33,6 +33,8 @@
>  #include <linux/rcupdate_trace.h>
>  #include <linux/memcontrol.h>
>  #include <linux/fprobe.h>
> +#include <linux/bsearch.h>
> +#include <linux/sort.h>
>
>  #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
>                           (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> @@ -3025,10 +3027,18 @@ static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *pro
>
>  #ifdef CONFIG_FPROBE
>
> +struct bpf_fprobe_cookie {
> +       unsigned long addr;
> +       u64 bpf_cookie;
> +};
> +
>  struct bpf_fprobe_link {
>         struct bpf_link link;
>         struct fprobe fp;
>         unsigned long *addrs;
> +       struct bpf_run_ctx run_ctx;
> +       struct bpf_fprobe_cookie *bpf_cookies;

you already have all the addrs above, why keeping a second copy of
each addrs in bpf_fprobe_cookie. Let's have two arrays: addrs
(unsigned long) and cookies (u64) and make sure that they are sorted
together. Then lookup addrs, calculate index, use that index to fetch
cookie.

Seems like sort_r() provides exactly the interface you'd need to do
this very easily. Having addrs separate from cookies also a bit
advantageous in terms of TLB misses (if you need any more persuasion
;)

> +       u32 cnt;
>  };
>
>  static void bpf_fprobe_link_release(struct bpf_link *link)
> @@ -3045,6 +3055,7 @@ static void bpf_fprobe_link_dealloc(struct bpf_link *link)
>
>         fprobe_link = container_of(link, struct bpf_fprobe_link, link);
>         kfree(fprobe_link->addrs);
> +       kfree(fprobe_link->bpf_cookies);
>         kfree(fprobe_link);
>  }
>
> @@ -3053,9 +3064,37 @@ static const struct bpf_link_ops bpf_fprobe_link_lops = {
>         .dealloc = bpf_fprobe_link_dealloc,
>  };
>
> +static int bpf_fprobe_cookie_cmp(const void *_a, const void *_b)
> +{
> +       const struct bpf_fprobe_cookie *a = _a;
> +       const struct bpf_fprobe_cookie *b = _b;
> +
> +       if (a->addr == b->addr)
> +               return 0;
> +       return a->addr < b->addr ? -1 : 1;
> +}
> +
> +u64 bpf_fprobe_cookie(struct bpf_run_ctx *ctx, u64 ip)
> +{
> +       struct bpf_fprobe_link *fprobe_link;
> +       struct bpf_fprobe_cookie *val, key = {
> +               .addr = (unsigned long) ip,
> +       };
> +
> +       if (!ctx)
> +               return 0;

is it allowed to have ctx == NULL?

> +       fprobe_link = container_of(ctx, struct bpf_fprobe_link, run_ctx);
> +       if (!fprobe_link->bpf_cookies)
> +               return 0;
> +       val = bsearch(&key, fprobe_link->bpf_cookies, fprobe_link->cnt,
> +                     sizeof(key), bpf_fprobe_cookie_cmp);
> +       return val ? val->bpf_cookie : 0;
> +}
> +
>  static int fprobe_link_prog_run(struct bpf_fprobe_link *fprobe_link,
>                                 struct pt_regs *regs)
>  {
> +       struct bpf_run_ctx *old_run_ctx;
>         int err;
>
>         if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> @@ -3063,12 +3102,16 @@ static int fprobe_link_prog_run(struct bpf_fprobe_link *fprobe_link,
>                 goto out;
>         }
>
> +       old_run_ctx = bpf_set_run_ctx(&fprobe_link->run_ctx);
> +
>         rcu_read_lock();
>         migrate_disable();
>         err = bpf_prog_run(fprobe_link->link.prog, regs);
>         migrate_enable();
>         rcu_read_unlock();
>
> +       bpf_reset_run_ctx(old_run_ctx);
> +
>   out:
>         __this_cpu_dec(bpf_prog_active);
>         return err;
> @@ -3161,10 +3204,12 @@ static int fprobe_resolve_syms(const void *usyms, u32 cnt,
>
>  static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>  {
> +       struct bpf_fprobe_cookie *bpf_cookies = NULL;
>         struct bpf_fprobe_link *link = NULL;
>         struct bpf_link_primer link_primer;
> +       void __user *ubpf_cookies;
> +       u32 flags, cnt, i, size;
>         unsigned long *addrs;
> -       u32 flags, cnt, size;
>         void __user *uaddrs;
>         void __user *usyms;
>         int err;
> @@ -3205,6 +3250,37 @@ static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *p
>                         goto error;
>         }
>
> +       ubpf_cookies = u64_to_user_ptr(attr->link_create.fprobe.bpf_cookies);

nit: let's call all this "cookies", this bpf_ prefix feels a bit
redundant (I know about perf_event.bpf_cookie, but still).

> +       if (ubpf_cookies) {
> +               u64 *tmp;
> +
> +               err = -ENOMEM;
> +               tmp = kzalloc(size, GFP_KERNEL);

kvmalloc?

> +               if (!tmp)
> +                       goto error;
> +
> +               if (copy_from_user(tmp, ubpf_cookies, size)) {
> +                       kfree(tmp);
> +                       err = -EFAULT;
> +                       goto error;
> +               }
> +

[...]
