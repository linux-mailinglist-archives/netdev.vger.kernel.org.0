Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D1420013D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 06:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgFSEaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 00:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgFSEaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 00:30:10 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F100C06174E;
        Thu, 18 Jun 2020 21:30:10 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id r16so3882809qvm.6;
        Thu, 18 Jun 2020 21:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tfVK3SbKrt+6Uzzz8EjfTw/A94qiX/szBfHPEHTipj0=;
        b=gaizaGEkIRGdzuV39rodmuylwlOMbdz1Jm8cDwAzLO0cRJX6mw2NSU/cPRr+L1fY2f
         Fifs5T9t+gOdHwbp9S6YtJnkOUHa+OSuqvbDjeriuVW+uqoglmkldab54MSeJb1hNjQ+
         Kd6tTgWKvlIgyTwPO5eccOOD9vWFuUYOT9S64MVoUcIolGMtQON8Fb6Rrb28cdCTwhbq
         r++B1zWBvIDY3BytikcQOLBOEiemNG1cUoEsTc+glvKdMjjN/DFMhOTRORXAjiQcBJ1U
         21U/H8uK46o2GeFl4xDe5vlvhS3qBdo+yb4l9oIO/dMEni7/rbG2GfqVj75JncRZKWkG
         fAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tfVK3SbKrt+6Uzzz8EjfTw/A94qiX/szBfHPEHTipj0=;
        b=KnWTzlYNGMD5pN5vEyKYj9GohNBIxaozUGFP58tZFkPW24GVLkCO8druHk1ju/MSdV
         TPRULarWPkuCn3O4JvquDEFR6nN+iwbCL17mmvbDkYUsbk8krB3vSMbuqMT0eeY2KEnn
         TjdwDc+3d9TBymQbvymnLGO44jKYWUahJMWbJwdOtGsIrXjJuivt00GGPK6JDUuQntmT
         DFVzk6pHItnVY6Hpw5mpBm/L9uuAVCGj034g2XNAZcKILa8nTKwfeLTHmRgaw6T+AQhX
         kt4dMiVK0cX0Y+simjUoJBaedQQD3OS6WHmLnnXvBodt3hbsQ2+4m3vBytLHeCvaoS8k
         WQ+g==
X-Gm-Message-State: AOAM532bj13X8GLJU5yWDrYMQ4CSU2ZMLSQdAVoQRT/gQUv0m/PWy1G3
        C6zogh2lbtFFW9pp7+xi49NJC3+YHT8aj5/O/GI=
X-Google-Smtp-Source: ABdhPJwpcj9WdUAyNe+XRFmMaXWIW3qvmSU0T//IYBb4W+bJSl2f/hjYI2OBH7jyS2DrrO2A5JQFnuvg/OFmk/9PvVQ=
X-Received: by 2002:ad4:4572:: with SMTP id o18mr6561740qvu.228.1592541009699;
 Thu, 18 Jun 2020 21:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-9-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 21:29:58 -0700
Message-ID: <CAEf4Bzaj-t0UYLiJh9czenqVtsi5UuviX_AqgpEq=gJx6WCHrw@mail.gmail.com>
Subject: Re: [PATCH 08/11] bpf: Add BTF whitelist support
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
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

On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to define 'whitelist' of BTF IDs, which is
> also sorted.
>
> Following defines sorted list of BTF IDs that is accessible
> within kernel code as btf_whitelist_d_path and its count is
> in btf_whitelist_d_path_cnt variable.
>
>   extern int btf_whitelist_d_path[];
>   extern int btf_whitelist_d_path_cnt;
>
>   BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
>   BTF_ID(func, vfs_truncate)
>   BTF_ID(func, vfs_fallocate)
>   BTF_ID(func, dentry_open)
>   BTF_ID(func, vfs_getattr)
>   BTF_ID(func, filp_close)
>   BTF_WHITELIST_END(btf_whitelist_d_path)
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h   |  3 +++
>  kernel/bpf/btf.c      | 13 +++++++++++++
>  kernel/bpf/btf_ids.h  | 38 ++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c |  5 +++++
>  4 files changed, 59 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index e98c113a5d27..a94e85c2ec50 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -283,6 +283,7 @@ struct bpf_func_proto {
>                 enum bpf_arg_type arg_type[5];
>         };
>         int *btf_id; /* BTF ids of arguments */
> +       bool (*allowed)(const struct bpf_prog *prog);
>  };
>
>  /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
> @@ -1745,6 +1746,8 @@ enum bpf_text_poke_type {
>  int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
>                        void *addr1, void *addr2);
>
> +bool btf_whitelist_search(int id, int list[], int cnt);
> +
>  extern int bpf_skb_output_btf_ids[];
>  extern int bpf_seq_printf_btf_ids[];
>  extern int bpf_seq_write_btf_ids[];
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 6924180a19c4..feda74d232c5 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -20,6 +20,7 @@
>  #include <linux/btf.h>
>  #include <linux/skmsg.h>
>  #include <linux/perf_event.h>
> +#include <linux/bsearch.h>
>  #include <net/sock.h>
>
>  /* BTF (BPF Type Format) is the meta data format which describes
> @@ -4669,3 +4670,15 @@ u32 btf_id(const struct btf *btf)
>  {
>         return btf->id;
>  }
> +
> +static int btf_id_cmp_func(const void *a, const void *b)
> +{
> +       const int *pa = a, *pb = b;
> +
> +       return *pa - *pb;
> +}
> +
> +bool btf_whitelist_search(int id, int list[], int cnt)

whitelist is a bit too specific, this functionality can be used for
blacklisting as well, no?

How about instead of "open coding" separately int list[] + int cnt, we
define a struct:

struct btf_id_set {
    u32 cnt;
    u32 ids[];
};

and pass that around?

This function then can be generic

bool btf_id_set_contains(struct btf_id_set *set, u32 id);

Then it's usable for both whitelist and blacklist? _contains also
clearly implies what's the return result, while _search isn't so clear
in that regard.


> +{
> +       return bsearch(&id, list, cnt, sizeof(int), btf_id_cmp_func) != NULL;
> +}
> diff --git a/kernel/bpf/btf_ids.h b/kernel/bpf/btf_ids.h
> index 68aa5c38a37f..a90c09faa515 100644
> --- a/kernel/bpf/btf_ids.h
> +++ b/kernel/bpf/btf_ids.h
> @@ -67,4 +67,42 @@ asm(                                                 \
>  #name ":;                                      \n"     \
>  ".popsection;                                  \n");
>
> +
> +/*
> + * The BTF_WHITELIST_ENTRY/END macros pair defines sorted
> + * list of BTF IDs plus its members count, with following
> + * layout:
> + *
> + * BTF_WHITELIST_ENTRY(list2)
> + * BTF_ID(type1, name1)
> + * BTF_ID(type2, name2)
> + * BTF_WHITELIST_END(list)

It kind of sucks you need two separate ENTRY/END macro (btw, START/END
or BEGIN/END would be a bit more "paired"), and your example clearly
shows why: it is not self-consistent (list2 on start, list on end ;).
But doing variadic macro like this would be a nightmare as well,
unfortunately. :(

> + *
> + * __BTF_ID__sort__list:
> + * list2_cnt:
> + * .zero 4
> + * list2:
> + * __BTF_ID__type1__name1__3:
> + * .zero 4
> + * __BTF_ID__type2__name2__4:
> + * .zero 4
> + *
> + */
> +#define BTF_WHITELIST_ENTRY(name)                      \
> +asm(                                                   \
> +".pushsection " SECTION ",\"a\";               \n"     \
> +".global __BTF_ID__sort__" #name ";            \n"     \
> +"__BTF_ID__sort__" #name ":;                   \n"     \

I mentioned in the previous patch already, I think "sort" is a bad
name, consider "set" (or "list", but you used list name already for a
slightly different macro).

> +".global " #name "_cnt;                        \n"     \
> +#name "_cnt:;                                  \n"     \

This label/symbol isn't necessary, why polluting the symbol table?

> +".zero 4                                       \n"     \
> +".popsection;                                  \n");   \
> +BTF_ID_LIST(name)
> +
> +#define BTF_WHITELIST_END(name)                                \
> +asm(                                                   \
> +".pushsection " SECTION ",\"a\";              \n"      \
> +".size __BTF_ID__sort__" #name ", .-" #name " \n"      \
> +".popsection;                                 \n");
> +
>  #endif
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index bee3da2cd945..5a9a6fd72907 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4633,6 +4633,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>                 return -EINVAL;
>         }
>
> +       if (fn->allowed && !fn->allowed(env->prog)) {
> +               verbose(env, "helper call is not allowed in probe\n");

nit: probe -> program, or just drop "in probe" part altogether

> +               return -EINVAL;
> +       }
> +
>         /* With LD_ABS/IND some JITs save/restore skb from r1. */
>         changes_data = bpf_helper_changes_pkt_data(fn->func);
>         if (changes_data && fn->arg1_type != ARG_PTR_TO_CTX) {
> --
> 2.25.4
>
