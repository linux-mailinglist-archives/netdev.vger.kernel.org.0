Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9C54AE5AE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 00:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiBHXxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 18:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238701AbiBHXx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 18:53:29 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A91C061577;
        Tue,  8 Feb 2022 15:53:27 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id q204so1106082iod.8;
        Tue, 08 Feb 2022 15:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FzvMSUuTeCOI1wQ0TwaK6PpWZEUxZXgUP5fohFrxN1A=;
        b=FSe8qZU7XtzwqjAkv+8vxDzbW575sVK7W5NB0yuhFCPS/CpqyBHRqLvCkKi91dbYSG
         ZlXozPQB3iRAnfDoMLjltzkB9xnZcdYqarD89EBVJX9JX6zjSzkMUm55PqfOGqtQK+32
         rMylW6yTeIW9CLQMOREXb/PK2AvQbbcyNq6WE2W6CFxFhxrpqv5iXB7wN6TwKLizKHac
         06m7of/j4yBRQzoWuWxzBhqi5Kf9OTOXtq9uKTT1dY80cYmpBaCrjlHpHEG7MitJNpKV
         tQoypw3E7mLX5flXebxDEVeC3skekqj0eJ71e52fI9+51yRRwY2YvASzMbokeSJy2tVc
         1i9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FzvMSUuTeCOI1wQ0TwaK6PpWZEUxZXgUP5fohFrxN1A=;
        b=AtpgR+N0IIBxQN+K54WvU5FARYX0Pggy2KlfEBRTfPAL+yTbFsvm993uLXmZ9stXGb
         eTFPDhf4Keg31mAM2YVKsrGsoJOxxt0+t29FnKB5tR4jMFLxq3POEzUxF7Z2rCQMXOu4
         hW0yHWOwE2wUllOctWtUVL5SB7dpFROhHEuMn7jAS7GD+vZFfY4wRQu9FtJ187g7ra0A
         jqObUsqbNUJk2mNrT0IaRS3Sfs2DxfTJTxmkNxcTzl3hCH6F+X64pdkA4ZaS2I2PevZt
         wttebl0cLB+FNMMSdc5lZgDxOZOpJykRkYsmDS+wQJlcjtXqgcxktMs3ycoZA8qylmDU
         Ws/w==
X-Gm-Message-State: AOAM533e2LeqP9Vafynuv6MrSXIBJ48M4YVcrXbhuBC7UDsHV0s2bgo2
        8TNpPFVI73J7na+oVC0vqKVibXKL7NLTY8Fe+OA=
X-Google-Smtp-Source: ABdhPJxJ9I4rMKOwlmIxqMPvBDoRJoE7uSHjRdx7QuHpvfmlWCuDnFU/De1iu8/o0ItWcWbGmHB44u46T6wxYUc/uaQ=
X-Received: by 2002:a02:7417:: with SMTP id o23mr3435736jac.145.1644364407167;
 Tue, 08 Feb 2022 15:53:27 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-4-jolsa@kernel.org>
 <CAEf4BzbPeQbURZOD93TgPudOk3JD4odsZ9uwriNkrphes9V4dg@mail.gmail.com>
 <YgIy2yCzbNmKPoxv@krava> <CAEf4BzYcR_zafS9fM16Hu15cpX=cU6da0T4dU2v+8K5Zd+puaA@mail.gmail.com>
 <YgMA6dY90DYk7jPu@krava>
In-Reply-To: <YgMA6dY90DYk7jPu@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Feb 2022 15:53:16 -0800
Message-ID: <CAEf4BzYUBZ-9h8=JaW=0S+6Q2Zo+OwWF4La=_unEDurKgnz+rw@mail.gmail.com>
Subject: Re: [PATCH 3/8] bpf: Add bpf_cookie support to fprobe
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Tue, Feb 8, 2022 at 3:46 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Tue, Feb 08, 2022 at 03:35:24PM -0800, Andrii Nakryiko wrote:
> > On Tue, Feb 8, 2022 at 1:07 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Mon, Feb 07, 2022 at 10:59:21AM -0800, Andrii Nakryiko wrote:
> > > > On Wed, Feb 2, 2022 at 5:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > >
> > > > > Adding support to call bpf_get_attach_cookie helper from
> > > > > kprobe program attached by fprobe link.
> > > > >
> > > > > The bpf_cookie is provided by array of u64 values, where
> > > > > each value is paired with provided function address with
> > > > > the same array index.
> > > > >
> > > > > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > > ---
> > > > >  include/linux/bpf.h            |  2 +
> > > > >  include/uapi/linux/bpf.h       |  1 +
> > > > >  kernel/bpf/syscall.c           | 83 +++++++++++++++++++++++++++++++++-
> > > > >  kernel/trace/bpf_trace.c       | 16 ++++++-
> > > > >  tools/include/uapi/linux/bpf.h |  1 +
> > > > >  5 files changed, 100 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > > index 6eb0b180d33b..7b65f05c0487 100644
> > > > > --- a/include/linux/bpf.h
> > > > > +++ b/include/linux/bpf.h
> > > > > @@ -1301,6 +1301,8 @@ static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
> > > > >  #endif
> > > > >  }
> > > > >
> > > > > +u64 bpf_fprobe_cookie(struct bpf_run_ctx *ctx, u64 ip);
> > > > > +
> > > > >  /* BPF program asks to bypass CAP_NET_BIND_SERVICE in bind. */
> > > > >  #define BPF_RET_BIND_NO_CAP_NET_BIND_SERVICE                   (1 << 0)
> > > > >  /* BPF program asks to set CN on the packet. */
> > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > index c0912f0a3dfe..0dc6aa4f9683 100644
> > > > > --- a/include/uapi/linux/bpf.h
> > > > > +++ b/include/uapi/linux/bpf.h
> > > > > @@ -1484,6 +1484,7 @@ union bpf_attr {
> > > > >                                 __aligned_u64   addrs;
> > > > >                                 __u32           cnt;
> > > > >                                 __u32           flags;
> > > > > +                               __aligned_u64   bpf_cookies;
> > > >
> > > > maybe put it right after addrs, they are closely related and cnt
> > > > describes all of syms/addrs/cookies.
> > >
> > > ok
> > >
> > > >
> > > > >                         } fprobe;
> > > > >                 };
> > > > >         } link_create;
> > > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > > index 0cfbb112c8e1..6c5e74bc43b6 100644
> > > > > --- a/kernel/bpf/syscall.c
> > > > > +++ b/kernel/bpf/syscall.c
> > > > > @@ -33,6 +33,8 @@
> > > > >  #include <linux/rcupdate_trace.h>
> > > > >  #include <linux/memcontrol.h>
> > > > >  #include <linux/fprobe.h>
> > > > > +#include <linux/bsearch.h>
> > > > > +#include <linux/sort.h>
> > > > >
> > > > >  #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> > > > >                           (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> > > > > @@ -3025,10 +3027,18 @@ static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *pro
> > > > >
> > > > >  #ifdef CONFIG_FPROBE
> > > > >
> > > > > +struct bpf_fprobe_cookie {
> > > > > +       unsigned long addr;
> > > > > +       u64 bpf_cookie;
> > > > > +};
> > > > > +
> > > > >  struct bpf_fprobe_link {
> > > > >         struct bpf_link link;
> > > > >         struct fprobe fp;
> > > > >         unsigned long *addrs;
> > > > > +       struct bpf_run_ctx run_ctx;
> > > > > +       struct bpf_fprobe_cookie *bpf_cookies;
> > > >
> > > > you already have all the addrs above, why keeping a second copy of
> > > > each addrs in bpf_fprobe_cookie. Let's have two arrays: addrs
> > > > (unsigned long) and cookies (u64) and make sure that they are sorted
> > > > together. Then lookup addrs, calculate index, use that index to fetch
> > > > cookie.
> > > >
> > > > Seems like sort_r() provides exactly the interface you'd need to do
> > > > this very easily. Having addrs separate from cookies also a bit
> > > > advantageous in terms of TLB misses (if you need any more persuasion
> > > > ;)
> > >
> > > no persuation needed, I actually tried that but it turned out sort_r
> > > is not ready yet ;-)
> > >
> > > because you can't pass priv pointer to the swap callback, so we can't
> > > swap the other array.. I did a change to allow that, but it's not trivial
> > > and will need some bigger testing/review because the original sort
> > > calls sort_r, and of course there are many 'sort' users ;-)
> >
> > Big sigh... :( Did you do something similar to _CMP_WRAPPER? You don't
> > need to change the interface of sort(), so it shouldn't require
> > extensive code refactoring. You'll just need to adjust priv to be not
> > just cmp_func, but cmp_func + swap_fun (need a small struct on the
> > stack in sort, probably). Or you did something else?
>
> I ended up with change below
>

exactly what I had in mind

> jirka
>
>
> ---
>  include/linux/sort.h  |  2 +-
>  include/linux/types.h |  1 +
>  lib/sort.c            | 44 +++++++++++++++++++++++++++++++++----------
>  3 files changed, 36 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/sort.h b/include/linux/sort.h
> index b5898725fe9d..e163287ac6c1 100644
> --- a/include/linux/sort.h
> +++ b/include/linux/sort.h
> @@ -6,7 +6,7 @@
>
>  void sort_r(void *base, size_t num, size_t size,
>             cmp_r_func_t cmp_func,
> -           swap_func_t swap_func,
> +           swap_r_func_t swap_func,
>             const void *priv);
>
>  void sort(void *base, size_t num, size_t size,
> diff --git a/include/linux/types.h b/include/linux/types.h
> index ac825ad90e44..ea8cf60a8a79 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -226,6 +226,7 @@ struct callback_head {
>  typedef void (*rcu_callback_t)(struct rcu_head *head);
>  typedef void (*call_rcu_func_t)(struct rcu_head *head, rcu_callback_t func);
>
> +typedef void (*swap_r_func_t)(void *a, void *b, int size, const void *priv);
>  typedef void (*swap_func_t)(void *a, void *b, int size);
>
>  typedef int (*cmp_r_func_t)(const void *a, const void *b, const void *priv);
> diff --git a/lib/sort.c b/lib/sort.c
> index aa18153864d2..f65078608c16 100644
> --- a/lib/sort.c
> +++ b/lib/sort.c
> @@ -122,16 +122,29 @@ static void swap_bytes(void *a, void *b, size_t n)
>   * a pointer, but small integers make for the smallest compare
>   * instructions.
>   */
> -#define SWAP_WORDS_64 (swap_func_t)0
> -#define SWAP_WORDS_32 (swap_func_t)1
> -#define SWAP_BYTES    (swap_func_t)2
> +#define SWAP_WORDS_64 (swap_r_func_t)0
> +#define SWAP_WORDS_32 (swap_r_func_t)1
> +#define SWAP_BYTES    (swap_r_func_t)2
> +#define SWAP_WRAPPER  (swap_r_func_t)3
> +
> +struct wrapper {
> +       cmp_func_t cmp;
> +       swap_func_t swap;
> +};
>
>  /*
>   * The function pointer is last to make tail calls most efficient if the
>   * compiler decides not to inline this function.
>   */
> -static void do_swap(void *a, void *b, size_t size, swap_func_t swap_func)
> +static void do_swap(void *a, void *b, size_t size, swap_r_func_t swap_func, const void *priv)
>  {
> +       const struct wrapper *w = priv;

I'd just move this under if

> +
> +       if (swap_func == SWAP_WRAPPER) {

const struct wrapper *w = priv; here

> +               w->swap(a, b, (int)size);
> +               return;
> +       }
> +
>         if (swap_func == SWAP_WORDS_64)
>                 swap_words_64(a, b, size);
>         else if (swap_func == SWAP_WORDS_32)
> @@ -139,15 +152,17 @@ static void do_swap(void *a, void *b, size_t size, swap_func_t swap_func)
>         else if (swap_func == SWAP_BYTES)
>                 swap_bytes(a, b, size);
>         else
> -               swap_func(a, b, (int)size);
> +               swap_func(a, b, (int)size, priv);
>  }
>
>  #define _CMP_WRAPPER ((cmp_r_func_t)0L)
>
>  static int do_cmp(const void *a, const void *b, cmp_r_func_t cmp, const void *priv)
>  {
> +       const struct wrapper *w = priv;
> +
>         if (cmp == _CMP_WRAPPER)
> -               return ((cmp_func_t)(priv))(a, b);
> +               return w->cmp(a, b);

same here, or just stick to the previous style with

return ((const struct wrapper *)priv)->cmd(a, b);

>         return cmp(a, b, priv);
>  }
>
> @@ -198,16 +213,20 @@ static size_t parent(size_t i, unsigned int lsbit, size_t size)
>   */
>  void sort_r(void *base, size_t num, size_t size,
>             cmp_r_func_t cmp_func,
> -           swap_func_t swap_func,
> +           swap_r_func_t swap_func,
>             const void *priv)
>  {
>         /* pre-scale counters for performance */
>         size_t n = num * size, a = (num/2) * size;
>         const unsigned int lsbit = size & -size;  /* Used to find parent */
> +       const struct wrapper *w = priv;
>
>         if (!a)         /* num < 2 || size == 0 */
>                 return;
>
> +       if (swap_func == SWAP_WRAPPER && !w->swap)

same here, I'd probably do the cast right here to keep this wrapper
stuff as local as possible

> +               swap_func = NULL;
> +
>         if (!swap_func) {
>                 if (is_aligned(base, size, 8))
>                         swap_func = SWAP_WORDS_64;
> @@ -230,7 +249,7 @@ void sort_r(void *base, size_t num, size_t size,
>                 if (a)                  /* Building heap: sift down --a */
>                         a -= size;
>                 else if (n -= size)     /* Sorting: Extract root to --n */
> -                       do_swap(base, base + n, size, swap_func);
> +                       do_swap(base, base + n, size, swap_func, priv);
>                 else                    /* Sort complete */
>                         break;
>
> @@ -257,7 +276,7 @@ void sort_r(void *base, size_t num, size_t size,
>                 c = b;                  /* Where "a" belongs */
>                 while (b != a) {        /* Shift it into place */
>                         b = parent(b, lsbit, size);
> -                       do_swap(base + b, base + c, size, swap_func);
> +                       do_swap(base + b, base + c, size, swap_func, priv);
>                 }
>         }
>  }
> @@ -267,6 +286,11 @@ void sort(void *base, size_t num, size_t size,
>           cmp_func_t cmp_func,
>           swap_func_t swap_func)
>  {
> -       return sort_r(base, num, size, _CMP_WRAPPER, swap_func, cmp_func);
> +       struct wrapper w = {
> +               .cmp  = cmp_func,
> +               .swap = swap_func,
> +       };
> +
> +       return sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
>  }
>  EXPORT_SYMBOL(sort);
> --
> 2.34.1
>
