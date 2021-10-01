Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2DB41F6B0
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355080AbhJAVLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355640AbhJAVLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 17:11:13 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05EBC0613E6;
        Fri,  1 Oct 2021 14:09:26 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id z5so23301041ybj.2;
        Fri, 01 Oct 2021 14:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RNz2xN/mK/HSLvlX8J0MiZKBTon0nEQ4e8Ht/DeCmI8=;
        b=a8rMmxwZ6tdoyVru2Mz3yspmGwE6Hl9LrYRR1WkH0JxDC45E8OmPmyg7hCAQrVFXT+
         l6WxnDq4YRPCverno0H0WIubOP16ER2AZPOx5Fn72JH3EVOBJwJH7pl5gMjC9Mav+e64
         9TLjDWCXZJzXx/mss85qdTHgqPsH5fFQU55yI3vVBNAbR6zMQ4GSOImsjOOKEx5i33CK
         KF9GarbzfBb+I4Xw6rv2TMnu0TCyOcIxNGVMqJrlrHEKUJW+63dDQiQV9/yccpoQwie8
         0WT+jFCh7bDJetZEA4w+tIYH9tj3wZmE4oxFSbAGWaYRKze7l05XRNtbusIC11IIK4Rc
         enEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNz2xN/mK/HSLvlX8J0MiZKBTon0nEQ4e8Ht/DeCmI8=;
        b=qe/3QOed1Ue/JSSdpX0dUSdZlb7CwQhZd1lQ79bKx476noU67p/A46dLglYeahF8+b
         sMD9CA+108WqMHFaEimq3QogPK0eMA0wrpEtYpicZwC8E7H6+hjE/yVdtedzxAjfli+e
         UUwFGj3fq906VgQXRpbweecQxKuXwV+m5g78jpsIFPX6K/EmWZmwzmfjulPdPUB8b9ma
         dW3UduUWHEzcG5nuWCMmR8Rhxr+X6wepahJsCDl2/hXce/032eHY+kwDLy+km41tKLTP
         gyAK4+Z51ju+BloZ/hhANWNU6uutWD74hhLy9ZZd5rUVh6/G+lull4xQnVYFMwGpjBlB
         hJwA==
X-Gm-Message-State: AOAM530eiSEFxNGBLr4UWda3sH/qkJIkjE+sFEPoxA5LpoKTlK+6aegG
        eRbO29f8gvpyxWGAESAeQEcELzHHHrFj++t+syE=
X-Google-Smtp-Source: ABdhPJyBzUtFp5FJQtqpZCS2SZcLLnkhtLq8wVu5kyvlcsgg8N2jPxuA6gomCYoZrQ9/J47LdYoLE0sFLpYo/hoPO+U=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr3087ybh.267.1633122565824;
 Fri, 01 Oct 2021 14:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210930062948.1843919-1-memxor@gmail.com> <20210930062948.1843919-4-memxor@gmail.com>
In-Reply-To: <20210930062948.1843919-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 14:09:14 -0700
Message-ID: <CAEf4BzahEZPvAuXfNAd3weqwRKewuHoFX4VZ4YpQqP0BLCiQQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 3/9] bpf: btf: Introduce helpers for dynamic
 BTF set registration
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:30 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds helpers for registering btf_id_set from modules and the
> check_kfunc_call callback that can be used to look them up.
>
> With in kernel sets, the way this is supposed to work is, in kernel
> callback looks up within the in-kernel kfunc whitelist, and then defers
> to the dynamic BTF set lookup if it doesn't find the BTF id. If there is
> no in-kernel BTF id set, this callback can be used directly.
>
> Also fix includes for btf.h and bpfptr.h so that they can included in
> isolation. This is in preparation for their usage in tcp_bbr, tcp_cubic
> and tcp_dctcp modules in the next patch.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpfptr.h |  1 +
>  include/linux/btf.h    | 31 +++++++++++++++++++++++++
>  kernel/bpf/btf.c       | 51 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 83 insertions(+)
>
> diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
> index 546e27fc6d46..46e1757d06a3 100644
> --- a/include/linux/bpfptr.h
> +++ b/include/linux/bpfptr.h
> @@ -3,6 +3,7 @@
>  #ifndef _LINUX_BPFPTR_H
>  #define _LINUX_BPFPTR_H
>
> +#include <linux/mm.h>
>  #include <linux/sockptr.h>
>
>  typedef sockptr_t bpfptr_t;
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 214fde93214b..382c00d5cede 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -5,6 +5,7 @@
>  #define _LINUX_BTF_H 1
>
>  #include <linux/types.h>
> +#include <linux/bpfptr.h>
>  #include <uapi/linux/btf.h>
>  #include <uapi/linux/bpf.h>
>
> @@ -238,4 +239,34 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
>  }
>  #endif
>
> +struct kfunc_btf_id_set {
> +       struct list_head list;
> +       struct btf_id_set *set;
> +       struct module *owner;
> +};
> +
> +struct kfunc_btf_id_list;
> +
> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> +void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
> +                              struct kfunc_btf_id_set *s);
> +void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
> +                                struct kfunc_btf_id_set *s);
> +#else
> +static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
> +                                            struct kfunc_btf_id_set *s)
> +{
> +}
> +static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
> +                                              struct kfunc_btf_id_set *s)
> +{
> +}
> +#endif
> +
> +#define DECLARE_CHECK_KFUNC_CALLBACK(type)                                     \
> +       bool __bpf_##type##_check_kfunc_call(u32 kfunc_id, struct module *owner)
> +#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
> +       struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
> +                                        THIS_MODULE }
> +
>  #endif
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index c3d605b22473..5a8806cfecd0 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6343,3 +6343,54 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>  };
>
>  BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
> +
> +struct kfunc_btf_id_list {
> +       struct list_head list;
> +       struct mutex mutex;
> +};
> +
> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> +
> +void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
> +                              struct kfunc_btf_id_set *s)
> +{
> +       mutex_lock(&l->mutex);
> +       list_add(&s->list, &l->list);
> +       mutex_unlock(&l->mutex);
> +}
> +EXPORT_SYMBOL_GPL(register_kfunc_btf_id_set);
> +
> +void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
> +                                struct kfunc_btf_id_set *s)
> +{
> +       mutex_lock(&l->mutex);
> +       list_del_init(&s->list);
> +       mutex_unlock(&l->mutex);
> +}
> +EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
> +
> +#endif
> +
> +#define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
> +       struct kfunc_btf_id_list name = { LIST_HEAD_INIT(name.list),           \
> +                                         __MUTEX_INITIALIZER(name.mutex) }; \
> +       EXPORT_SYMBOL_GPL(name)
> +

nit: \ alignment seems off

> +#define DEFINE_CHECK_KFUNC_CALLBACK(type, list_name)                           \
> +       bool __bpf_##type##_check_kfunc_call(u32 kfunc_id,                     \
> +                                            struct module *owner)             \

does this have to be a type-specific macro-defined function? It seems
like type is used only for creating a dedicated function with type
embedded in it, but otherwise this helper only needs mutex and the
list, why not code it as a generic function and pass mutex and list
explicitly (or if it is always struct struct kfunc_btf_id_list then
just declare it so)? I think that will be easier to follow.


> +       {                                                                      \
> +               struct kfunc_btf_id_set *s;                                    \
> +               if (!owner || !IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))      \
> +                       return false;                                          \
> +               mutex_lock(&list_name.mutex);                                  \
> +               list_for_each_entry(s, &list_name.list, list) {                \
> +                       if (s->owner == owner &&                               \
> +                           btf_id_set_contains(s->set, kfunc_id)) {           \
> +                               mutex_unlock(&list_name.mutex);                \
> +                               return true;                                   \
> +                       }                                                      \
> +               }                                                              \
> +               mutex_unlock(&list_name.mutex);                                \
> +               return false;                                                  \
> +       }
> --
> 2.33.0
>
