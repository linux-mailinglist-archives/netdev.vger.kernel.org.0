Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE525E1FE
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgIDTex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIDTev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 15:34:51 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE40C061244;
        Fri,  4 Sep 2020 12:34:50 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s92so5190867ybi.2;
        Fri, 04 Sep 2020 12:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l7AbF6ObHul/HpyDP1CM3i794LArutPSVoTj+5ZND9c=;
        b=E3CRJycglGFtdTRqsIeYV4f037iqOXMeZ7ZmrCDWl/ZiD89Ml1+6DshFCBA9E7KefO
         8oXQLV3ZPRW3rzjWxyq/wnEThsg4T8B7O5I62mVo756ejOey2aI6SmssfmiWtUlPRENr
         MOcNFz9cvbTqHXpIYAkMCXFglgB0RPk+vPdhcGwO+xmLKR/BqgL2w6YAuDAoh31FJ+yV
         PvMTE2b+sjn28LEOwSSW5KPDlBZWDvF9rpG8PgX67XF6aOUPw6mivy6J8eBSHM4CbnhC
         NCZR4nXQaReVhCCpWHG8FBcoozYTE+AFsb6GEuD6gphZH9kLQccO/LnNQ9CdqRI4ODHT
         iiag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l7AbF6ObHul/HpyDP1CM3i794LArutPSVoTj+5ZND9c=;
        b=ZWcCWe5Scf4KdL+/X7jZbVsbz6w7Wc/1y5+uG46Yy3JU4br5lS9Q+kd7UbD/A/Z1ZX
         cTYdOIRtWVwVGclQ289sXaHKdRLnrMrC3yfdHIpw7QyLgi43juYHXHYYbnXypcyQJMdh
         1dCwYWrVCz70nrq/3GAvXpRERjPfmgu1I58dXtXWnjRzDWKIXG8gVVVR2p2B7CkSecL9
         6rvqv+rL+IspUSm+Z+T/HvFVPDeuw4Q6Wd6JfTa60RMCemNltcYw6kWZLUpxQwJ1iu5N
         JhtfVlBlSU5NkNBVL6Dvs5ro2+MsjjS2C9PQ6rtyQcRFsV7IO0SXnqzoG/4MnB4zUS6z
         yWXA==
X-Gm-Message-State: AOAM530Y3dCt9cdZHdQSP4EoiFE2FSEOMFutprTcDPdQ8AToJo1cfmlE
        zpz7I+udUwvsxteBQEbYpDQ4Sm413m9q8kr8xXw=
X-Google-Smtp-Source: ABdhPJxb2XupjUC1M++Pp29hJVxUIXjCX59D857gC4+43yhdgI8g8gmqmSjrDVOEgBQuC/neJe5Bf8iU+2USIjL8NjY=
X-Received: by 2002:a5b:44d:: with SMTP id s13mr12361472ybp.403.1599248089911;
 Fri, 04 Sep 2020 12:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-3-haoluo@google.com>
In-Reply-To: <20200903223332.881541-3-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 12:34:39 -0700
Message-ID: <CAEf4Bzbu=Rdztx2xC6vkyeT=KGhQdy=+Dto8r1maWMLa5cGHbA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/6] bpf/libbpf: BTF support for typed ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 3:34 PM Hao Luo <haoluo@google.com> wrote:
>
> If a ksym is defined with a type, libbpf will try to find the ksym's btf
> information from kernel btf. If a valid btf entry for the ksym is found,
> libbpf can pass in the found btf id to the verifier, which validates the
> ksym's type and value.
>
> Typeless ksyms (i.e. those defined as 'void') will not have such btf_id,
> but it has the symbol's address (read from kallsyms) and its value is
> treated as a raw pointer.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

Logic looks correct, but I have complaints about libbpf logging
consistency, please see suggestions below.

>  tools/lib/bpf/libbpf.c | 116 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 102 insertions(+), 14 deletions(-)
>

[...]

> @@ -3119,6 +3130,8 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
>                         vt->type = int_btf_id;
>                         vs->offset = off;
>                         vs->size = sizeof(int);
> +                       pr_debug("ksym var_secinfo: var '%s', type #%d, size %d, offset %d\n",
> +                                ext->name, vt->type, vs->size, vs->offset);

debug leftover?

>                 }
>                 sec->size = off;
>         }
> @@ -5724,8 +5737,13 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
>                                 insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
>                                 insn[1].imm = ext->kcfg.data_off;
>                         } else /* EXT_KSYM */ {
> -                               insn[0].imm = (__u32)ext->ksym.addr;
> -                               insn[1].imm = ext->ksym.addr >> 32;
> +                               if (ext->ksym.type_id) { /* typed ksyms */
> +                                       insn[0].src_reg = BPF_PSEUDO_BTF_ID;
> +                                       insn[0].imm = ext->ksym.vmlinux_btf_id;
> +                               } else { /* typeless ksyms */
> +                                       insn[0].imm = (__u32)ext->ksym.addr;
> +                                       insn[1].imm = ext->ksym.addr >> 32;
> +                               }
>                         }
>                         break;
>                 case RELO_CALL:
> @@ -6462,10 +6480,72 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>         return err;
>  }
>
> +static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
> +{
> +       struct extern_desc *ext;
> +       int i, id;
> +
> +       if (!obj->btf_vmlinux) {
> +               pr_warn("support of typed ksyms needs kernel btf.\n");
> +               return -ENOENT;
> +       }

This check shouldn't be needed, you'd either successfully load
btf_vmlinux by now or will fail earlier, because BTF is required but
not found.

> +
> +       for (i = 0; i < obj->nr_extern; i++) {
> +               const struct btf_type *targ_var, *targ_type;
> +               __u32 targ_type_id, local_type_id;
> +               int ret;
> +
> +               ext = &obj->externs[i];
> +               if (ext->type != EXT_KSYM || !ext->ksym.type_id)
> +                       continue;
> +
> +               id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
> +                                           BTF_KIND_VAR);
> +               if (id <= 0) {
> +                       pr_warn("no btf entry for ksym '%s' in vmlinux.\n",
> +                               ext->name);

please try to stick to consistent style of comments:

"extern (ksym) '%s': failed to find BTF ID in vmlinux BTF" or
something like that


> +                       return -ESRCH;
> +               }
> +
> +               /* find target type_id */
> +               targ_var = btf__type_by_id(obj->btf_vmlinux, id);
> +               targ_type = skip_mods_and_typedefs(obj->btf_vmlinux,
> +                                                  targ_var->type,
> +                                                  &targ_type_id);
> +
> +               /* find local type_id */
> +               local_type_id = ext->ksym.type_id;
> +
> +               ret = bpf_core_types_are_compat(obj->btf_vmlinux, targ_type_id,
> +                                               obj->btf, local_type_id);

you reversed the order, it's always local btf/id, then target btf/id.

> +               if (ret <= 0) {
> +                       const struct btf_type *local_type;
> +                       const char *targ_name, *local_name;
> +
> +                       local_type = btf__type_by_id(obj->btf, local_type_id);
> +                       targ_name = btf__name_by_offset(obj->btf_vmlinux,
> +                                                       targ_type->name_off);
> +                       local_name = btf__name_by_offset(obj->btf,
> +                                                        local_type->name_off);

it's a bit unfortunate that we get the name of an already resolved
type, because if you have a typedef to anon struct, this will give you
an empty string. I don't know how much of a problem that would be, so
I think it's fine to leave it as is, and fix it if it's a problem in
practice.

> +
> +                       pr_warn("ksym '%s' expects type '%s' (vmlinux_btf_id: #%d), "
> +                               "but got '%s' (btf_id: #%d)\n", ext->name,
> +                               targ_name, targ_type_id, local_name, local_type_id);

same thing, please stay consistent in logging format. Check
bpf_core_dump_spec() for how BTF type info is usually emitted
throughout libbpf:

"extern (ksym): incompatible types, expected [%d] %s %s, but kernel
has [%d] %s %s\n"

there is a btf_kind_str() helper to resolve kind to a string representation.


> +                       return -EINVAL;
> +               }
> +
> +               ext->is_set = true;
> +               ext->ksym.vmlinux_btf_id = id;
> +               pr_debug("extern (ksym) %s=vmlinux_btf_id(#%d)\n", ext->name, id);

"extern (ksym) '%s': resolved to [%d] %s %s\n", similar to above
suggestion. This "[%d]" format is very consistently used for BTF IDs
throughout, so it will be familiar and recognizable for people that
had to deal with this in libbpf logs.

> +       }
> +       return 0;
> +}
> +
>  static int bpf_object__resolve_externs(struct bpf_object *obj,
>                                        const char *extra_kconfig)
>  {
> -       bool need_config = false, need_kallsyms = false;
> +       bool need_kallsyms = false, need_vmlinux_btf = false;
> +       bool need_config = false;

nit: doesn't make sense to change the existing source code line at
all. Just add `bool need_vmlinux_btf = false;` on a new line? Or we
can split all these bools into 3 separate lines, if you prefer.

>         struct extern_desc *ext;
>         void *kcfg_data = NULL;
>         int err, i;

[...]
