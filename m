Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60BC41F72B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355769AbhJAV6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhJAV63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 17:58:29 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE2FC061775;
        Fri,  1 Oct 2021 14:56:44 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id q189so5364875ybq.1;
        Fri, 01 Oct 2021 14:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I3z6l9WwUm29vkId3Y300lHRHn0pAw4iKACOhq4iICo=;
        b=blepvXvNhCqW0Edy++jfZQugcfPD6wkrXQh7sPL1mHHoE6kjUEL1W+wYGx6zoBXikr
         w6WUd/gpBw6f/lrdPhMEHILl1qgB24v8aiiT/aGvMVixbfTWBhRhuLNdL+Sx3WGON3oh
         cC+bNKat1j3GAsThvmUXpTz9uSJLHhBMkv5kAxK3uUiWhSicNd1e3wywlE0soe+6O1td
         G/Trx5tL3szVXXNCXW9bLDmqlp40jnr8Q+SrC3hq/PqIWMP1poeL2E2gVFf37jCnN+5W
         DWqM/8o3UGW4uvG1i4ZRnvSjZ5OOBCTpikv4EK1yyaCT33+SsKYcAFyQcHxuxicbgxF6
         r5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I3z6l9WwUm29vkId3Y300lHRHn0pAw4iKACOhq4iICo=;
        b=npDTtLZb86ZYpgCV0gjYxLy1PvABclCmqKyQi6Z+/oNWuqbYjunfWfiDDIG/mXbUzJ
         +GMuhYkyRvg9JRf1e7k90sicSLBr5dNRM3r+Y5WotJ9FxnFkzEIZA1viLluEO68caXz9
         t0O6ci2PPxXotHL//SbXDc8tsaWtRU7LDPsYAI9jq6Ll1upOja6RZr1Z4c9sz2iEXWuz
         2kjbfY3HqJ5olbfyQtzS5b9QPczh+fubT/sgABcoSS8uNZyuEUbaSC9G5IOubmmkk3jp
         ffATnvpmJqRWxqW/KkaU0d8Kk+Auki4nAyd2QKVz3GnkGvNABOoHFeRDuLJs0c6TBaK1
         Aqhw==
X-Gm-Message-State: AOAM53128B9nvv25QEtzq/93XxgLko0lUYBSETg5302a+BW0luZgKdYT
        EoZ9asN9bGdW29Lpju54576cO8s8kRVj5ATsLCY=
X-Google-Smtp-Source: ABdhPJy2xM7JAZ9RVfUh/Q9DNcApFALkwihwNQ7dCcXGro5TirINwDv95vK/yMylhJi+utZ5/QT5LsyFflI9PnVIcEk=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr229323ybc.225.1633125403758;
 Fri, 01 Oct 2021 14:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210930062948.1843919-1-memxor@gmail.com> <20210930062948.1843919-7-memxor@gmail.com>
In-Reply-To: <20210930062948.1843919-7-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 14:56:32 -0700
Message-ID: <CAEf4BzZ166cVzb45avJobKqAh4udS9T5+q6qC=+0+KVerSc7rg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 6/9] libbpf: Support kernel module function calls
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
> This patch adds libbpf support for kernel module function call support.
> The fd_array parameter is used during BPF program load is used to pass

typo: duplicated "is used"

> module BTFs referenced by the program. insn->off is set to index into
> this array, but starts from 1, because insn->off as 0 is reserved for
> btf_vmlinux.
>
> We try to use existing insn->off for a module, since the kernel limits
> the maximum distinct module BTFs for kfuncs to 256, and also because
> index must never exceed the maximum allowed value that can fit in
> insn->off (INT16_MAX). In the future, if kernel interprets signed offset
> as unsigned for kfunc calls, this limit can be increased to UINT16_MAX.
>
> Also introduce a btf__find_by_name_kind_own helper to start searching
> from module BTF's start id when we know that the BTF ID is not present
> in vmlinux BTF (in find_ksym_btf_id).
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/bpf.c             |  1 +
>  tools/lib/bpf/btf.c             | 19 ++++++--
>  tools/lib/bpf/libbpf.c          | 80 +++++++++++++++++++++++----------
>  tools/lib/bpf/libbpf_internal.h |  3 ++
>  4 files changed, 76 insertions(+), 27 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 2401fad090c5..7d1741ceaa32 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -264,6 +264,7 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
>         attr.line_info_rec_size = load_attr->line_info_rec_size;
>         attr.line_info_cnt = load_attr->line_info_cnt;
>         attr.line_info = ptr_to_u64(load_attr->line_info);
> +       attr.fd_array = ptr_to_u64(load_attr->fd_array);
>
>         if (load_attr->name)
>                 memcpy(attr.prog_name, load_attr->name,
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 6ad63e4d418a..f1d872b3fbf4 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -695,15 +695,16 @@ __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
>         return libbpf_err(-ENOENT);
>  }
>
> -__s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
> -                            __u32 kind)
> +static __s32 __btf__find_by_name_kind(const struct btf *btf,
> +                                     const char *type_name, __u32 kind,
> +                                     bool own)

I generally try to avoid double underscore functions and in this case
given this is an internal helper, then calling it just
"btf_find_by_name_kind" would be perfectly fine. Also, instead of
passing a pretty obscure true/false "own" flag, let's pass "int
start_id", which makes it a bit more obvious and potentially usable
for some other cases where we won't to start from some type ID X which
is not necessarily is a boundary. I'd also put that start_id argument
right next to btf arg, so that we have "btf, start_id specifies source
of types" and "type_name and kind specifies the match condition". See
example below.

>  {
>         __u32 i, nr_types = btf__get_nr_types(btf);
>
>         if (kind == BTF_KIND_UNKN || !strcmp(type_name, "void"))
>                 return 0;
>
> -       for (i = 1; i <= nr_types; i++) {
> +       for (i = own ? btf->start_id : 1; i <= nr_types; i++) {
>                 const struct btf_type *t = btf__type_by_id(btf, i);
>                 const char *name;
>
> @@ -717,6 +718,18 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
>         return libbpf_err(-ENOENT);
>  }
>
> +__s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
> +                                __u32 kind)
> +{
> +       return __btf__find_by_name_kind(btf, type_name, kind, true);

so here you'll have a pretty clean (IMO)

return btf_find_by_name_kind(btf, btf->start_id, type_name, kind);

> +}
> +
> +__s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
> +                            __u32 kind)
> +{
> +       return __btf__find_by_name_kind(btf, type_name, kind, false);

and here:

return btf_find_by_name_kind(btf, 1, type_name, kind);

> +}
> +
>  static bool btf_is_modifiable(const struct btf *btf)
>  {
>         return (void *)btf->hdr != btf->raw_data;
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7544d7d09160..8943a56f4fcb 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -443,6 +443,11 @@ struct extern_desc {
>
>                         /* local btf_id of the ksym extern's type. */
>                         __u32 type_id;
> +                       /* offset to be patched in for insn->off, this is 0 for
> +                        * vmlinux BTF, and BTF fd index in obj->fd_array for
> +                        * module BTF
> +                        */
> +                       __s16 offset;

s/offset/btf_fd_idx/, give it a semantical name, it's use as insn->off
is just a particular detail

>                 } ksym;
>         };
>  };
> @@ -454,6 +459,7 @@ struct module_btf {
>         char *name;
>         __u32 id;
>         int fd;
> +       int fd_array_idx;
>  };
>
>  struct bpf_object {
> @@ -539,6 +545,10 @@ struct bpf_object {
>         void *priv;
>         bpf_object_clear_priv_t clear_priv;
>
> +       int *fd_array;
> +       size_t fd_array_cap;
> +       size_t fd_array_cnt;
> +
>         char path[];
>  };
>  #define obj_elf_valid(o)       ((o)->efile.elf)
> @@ -1168,6 +1178,9 @@ static struct bpf_object *bpf_object__new(const char *path,
>         obj->kern_version = get_kernel_version();
>         obj->loaded = false;
>
> +       /* We cannot use index 0 for module BTF fds */
> +       obj->fd_array_cnt = 1;
> +

This is a lie and we'll probably pay for this at some point. I'd
rather special handle 0 later when you allocate new memory and fd idx
(see below). Let's keep it initialized to proper 0 at the beginning,
so that it matches the NULL pointer properly.

>         INIT_LIST_HEAD(&obj->list);
>         list_add(&obj->list, &bpf_objects_list);
>         return obj;
> @@ -5383,6 +5396,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>                         ext = &obj->externs[relo->sym_off];
>                         insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
>                         insn[0].imm = ext->ksym.kernel_btf_id;
> +                       insn[0].off = ext->ksym.offset;
>                         break;
>                 case RELO_SUBPROG_ADDR:
>                         if (insn[0].src_reg != BPF_PSEUDO_FUNC) {

[...]

> -       if (kern_btf != obj->btf_vmlinux) {
> -               pr_warn("extern (func ksym) '%s': function in kernel module is not supported\n",
> -                       ext->name);
> -               return -ENOTSUP;
> -       }
> -
> -       kern_func = btf__type_by_id(kern_btf, kfunc_id);
> +       kern_func = btf__type_by_id(btf, kfunc_id);
>         kfunc_proto_id = kern_func->type;
>
>         ret = bpf_core_types_are_compat(obj->btf, local_func_proto_id,
> -                                       kern_btf, kfunc_proto_id);

kern_btf was used to distinguish it from obj->btf properly and point
out that it's kernel BTF. kernel doesn't mean only vmlinux, it fits
both vmlinux and module, so can you please keep the kern_btf name?

> +                                       btf, kfunc_proto_id);
>         if (ret <= 0) {
>                 pr_warn("extern (func ksym) '%s': func_proto [%d] incompatible with kernel [%d]\n",
>                         ext->name, local_func_proto_id, kfunc_proto_id);
>                 return -EINVAL;
>         }
>
> +       /* set index for module BTF fd in fd_array, if unset */
> +       if (mod_btf && !mod_btf->fd_array_idx) {
> +               /* insn->off is s16 */
> +               if (obj->fd_array_cnt == INT16_MAX) {
> +                       pr_warn("extern (func ksym) '%s': module BTF fd index %d too big to fit in bpf_insn offset\n",
> +                               ext->name, mod_btf->fd_array_idx);
> +                       return -E2BIG;
> +               }
> +

here I'd do

new_fd_idx = obj->fd_array_cnt ? obj->fd_array_cnt : 1;

> +               ret = libbpf_ensure_mem((void **)&obj->fd_array, &obj->fd_array_cap, sizeof(int),
> +                                       obj->fd_array_cnt + 1);

and here just new_fd_idx + 1, you get the idea. Special casing is
still in one place above, everything else is based on a calculated
index.

> +               if (ret)
> +                       return ret;
> +               mod_btf->fd_array_idx = obj->fd_array_cnt;
> +               /* we assume module BTF FD is always >0 */
> +               obj->fd_array[obj->fd_array_cnt++] = mod_btf->fd;
> +       }
> +
>         ext->is_set = true;
> -       ext->ksym.kernel_btf_obj_fd = kern_btf_fd;
>         ext->ksym.kernel_btf_id = kfunc_id;
> +       ext->ksym.offset = mod_btf ? mod_btf->fd_array_idx : 0;
>         pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
>                  ext->name, kfunc_id);
>

[...]
