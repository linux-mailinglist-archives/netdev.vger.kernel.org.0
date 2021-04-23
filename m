Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F32F368C30
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhDWE33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDWE33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:29:29 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC61C061574;
        Thu, 22 Apr 2021 21:28:52 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 82so54182614yby.7;
        Thu, 22 Apr 2021 21:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VOgB3hrQZNKW3F/Hx3vlNxReUfujeuFLapDOjpUWBCc=;
        b=ulbUrrtrr+kBjoaJGo8mT/pnfzRA1f2P1J+G4/wOwMvCDZ4FmGqMg+zVM1eSCw2d42
         s8YjORaRS++SDGm5n4Gb/71SUAfVtIaE5tkwmyXGXseS+6leYvP/wLbZXXfViC0qAcca
         pQzmIo+p3BYECVXoAucl4WqIFqcxS8S1IcK8BRkIr8TtBhnKIpu+MA0BXHGw1jrVmvJi
         lGJ0wv/yOgEmuDagFgIJs6uVnqzf+9iqW8w1ueakxRUeZQj+zAnbwp3i4ufD+vaQzjci
         16E3mCpyULAObWB2nSOqM1QXqUgpeT9TMBLXbgki1U+RmgLzZx7mXEcNZ+fL8eY4UzbK
         wf9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VOgB3hrQZNKW3F/Hx3vlNxReUfujeuFLapDOjpUWBCc=;
        b=huj2uEMbp8svu6e9QZsYYO19f2cTeM3zeid9LVh/jOi90I3aB2pM0WZn34mIKHyEFz
         IoAsO5DtMwk+hg9hywBj9XkG8AJf8eT8g4z0dkd9+JWNpHZAsBFEJcEkEpLfIWdbXyqH
         2UuiSxNSMgr5HacENYp24talz2GLCYWLLvtxov048gN3w4klABRFY67XX6JTNdBjmMtl
         ZWQVIPk/kvHu4+qCtOwzypYpWVT4OM1BPPt3lxf6HGdqMuhzZW7VIkc2LvALifbxTSih
         QTqanPr5l8MsgIlPOxGajx9EWzOGwCSQlA7pB3rRjMbD3cSD27O+godNJMmx5mKmOgfT
         vxgA==
X-Gm-Message-State: AOAM533cYzz0SohBGdn+SijzJQIy24cjnymzTZYzpArbjrifnOxv7BxH
        ESJOU17G/n7FXUrap9ZT/iAx4MaMrTBIL1Geu/c=
X-Google-Smtp-Source: ABdhPJxOE2Xzgi5ReZxL27zHkZjgZK6VYHtn+8wFF4cLkRmfSIHjmU0xTtDze2bvaT90atNPq4OwuVvR7qgc5FFMDpg=
X-Received: by 2002:a25:9942:: with SMTP id n2mr2964273ybo.230.1619152131478;
 Thu, 22 Apr 2021 21:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-12-andrii@kernel.org>
 <d6297a28-855f-4c46-7754-b0c0b1f11d6b@fb.com> <CAEf4BzYzML_5O-+6=bW6U=jCc9aG86GBJH6fwrsU5gSacbjL7w@mail.gmail.com>
 <cffdf4e2-220d-cc2e-67e9-b83e848bdddf@fb.com> <8c6d3655-f9c7-d0b0-b10f-00f679c44c1e@fb.com>
In-Reply-To: <8c6d3655-f9c7-d0b0-b10f-00f679c44c1e@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 21:28:40 -0700
Message-ID: <CAEf4BzZjW8OJQjMJ0qCTftnuStUXxKpf4eVrigCLDf4+VcxJSQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 11/17] libbpf: add linker extern resolution
 support for functions and global variables
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 7:36 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/22/21 4:57 PM, Yonghong Song wrote:
> >
> >
> > On 4/22/21 3:12 PM, Andrii Nakryiko wrote:
> >> On Thu, Apr 22, 2021 at 2:27 PM Yonghong Song <yhs@fb.com> wrote:
> >>>
> >>>
> >>>
> >>> On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> >>>> Add BPF static linker logic to resolve extern variables and
> >>>> functions across
> >>>> multiple linked together BPF object files.
> >>>>
> >>>> For that, linker maintains a separate list of struct glob_sym
> >>>> structures,
> >>>> which keeps track of few pieces of metadata (is it extern or
> >>>> resolved global,
> >>>> is it a weak symbol, which ELF section it belongs to, etc) and ties
> >>>> together
> >>>> BTF type info and ELF symbol information and keeps them in sync.
> >>>>
> >>>> With adding support for extern variables/funcs, it's now possible
> >>>> for some
> >>>> sections to contain both extern and non-extern definitions. This
> >>>> means that
> >>>> some sections may start out as ephemeral (if only externs are
> >>>> present and thus
> >>>> there is not corresponding ELF section), but will be "upgraded" to
> >>>> actual ELF
> >>>> section as symbols are resolved or new non-extern definitions are
> >>>> appended.
> >>>>
> >>>> Additional care is taken to not duplicate extern entries in sections
> >>>> like
> >>>> .kconfig and .ksyms.
> >>>>
> >>>> Given libbpf requires BTF type to always be present for .kconfig/.ksym
> >>>> externs, linker extends this requirement to all the externs, even
> >>>> those that
> >>>> are supposed to be resolved during static linking and which won't be
> >>>> visible
> >>>> to libbpf. With BTF information always present, static linker will
> >>>> check not
> >>>> just ELF symbol matches, but entire BTF type signature match as
> >>>> well. That
> >>>> logic is stricter that BPF CO-RE checks. It probably should be
> >>>> re-used by
> >>>> .ksym resolution logic in libbpf as well, but that's left for follow up
> >>>> patches.
> >>>>
> >>>> To make it unnecessary to rewrite ELF symbols and minimize BTF type
> >>>> rewriting/removal, ELF symbols that correspond to externs initially
> >>>> will be
> >>>> updated in place once they are resolved. Similarly for BTF type
> >>>> info, VAR/FUNC
> >>>> and var_secinfo's (sec_vars in struct bpf_linker) are staying
> >>>> stable, but
> >>>> types they point to might get replaced when extern is resolved. This
> >>>> might
> >>>> leave some left-over types (even though we try to minimize this for
> >>>> common
> >>>> cases of having extern funcs with not argument names vs concrete
> >>>> function with
> >>>> names properly specified). That can be addresses later with a
> >>>> generic BTF
> >>>> garbage collection. That's left for a follow up as well.
> >>>>
> >>>> Given BTF type appending phase is separate from ELF symbol
> >>>> appending/resolution, special struct glob_sym->underlying_btf_id
> >>>> variable is
> >>>> used to communicate resolution and rewrite decisions. 0 means
> >>>> underlying_btf_id needs to be appended (it's not yet in final
> >>>> linker->btf), <0
> >>>> values are used for temporary storage of source BTF type ID (not yet
> >>>> rewritten), so -glob_sym->underlying_btf_id is BTF type id in
> >>>> obj-btf. But by
> >>>> the end of linker_append_btf() phase, that underlying_btf_id will be
> >>>> remapped
> >>>> and will always be > 0. This is the uglies part of the whole
> >>>> process, but
> >>>> keeps the other parts much simpler due to stability of sec_var and
> >>>> VAR/FUNC
> >>>> types, as well as ELF symbol, so please keep that in mind while
> >>>> reviewing.
> >>>
> >>> This is indeed complicated. I has some comments below. Please check
> >>> whether my understanding is correct or not.
> >>>
> >>>>
> >>>> BTF-defined maps require some extra custom logic and is addressed
> >>>> separate in
> >>>> the next patch, so that to keep this one smaller and easier to review.
> >>>>
> >>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>>> ---
> >>>>    tools/lib/bpf/linker.c | 844
> >>>> ++++++++++++++++++++++++++++++++++++++---
> >>>>    1 file changed, 785 insertions(+), 59 deletions(-)
> >>>>
> [...]
> >>>
> >>>> +             src_sec = &obj->secs[sym->st_shndx];
> >>>> +             if (src_sec->skipped)
> >>>> +                     return 0;
> >>>> +             dst_sec = &linker->secs[src_sec->dst_id];
> >>>> +
> >>>> +             /* allow only one STT_SECTION symbol per section */
> >>>> +             if (sym_type == STT_SECTION && dst_sec->sec_sym_idx) {
> >>>> +                     obj->sym_map[src_sym_idx] = dst_sec->sec_sym_idx;
> >>>> +                     return 0;
> >>>> +             }
> >>>> +     }
> >>>> +
> >>>> +     if (sym_bind == STB_LOCAL)
> >>>> +             goto add_sym;
> >>>> +
> >>>> +     /* find matching BTF info */
> >>>> +     err = find_glob_sym_btf(obj, sym, sym_name, &btf_sec_id,
> >>>> &btf_id);
> >>>> +     if (err)
> >>>> +             return err;
> >>>> +
> >>>> +     if (sym_is_extern && btf_sec_id) {
> >>>> +             const char *sec_name = NULL;
> >>>> +             const struct btf_type *t;
> >>>> +
> >>>> +             t = btf__type_by_id(obj->btf, btf_sec_id);
> >>>> +             sec_name = btf__str_by_offset(obj->btf, t->name_off);
> >>>> +
> >>>> +             /* Clang puts unannotated extern vars into
> >>>> +              * '.extern' BTF DATASEC. Treat them the same
> >>>> +              * as unannotated extern funcs (which are
> >>>> +              * currently not put into any DATASECs).
> >>>> +              * Those don't have associated src_sec/dst_sec.
> >>>> +              */
> >>>> +             if (strcmp(sec_name, BTF_EXTERN_SEC) != 0) {
> >>>> +                     src_sec = find_src_sec_by_name(obj, sec_name);
> >>>> +                     if (!src_sec) {
> >>>> +                             pr_warn("failed to find matching ELF
> >>>> sec '%s'\n", sec_name);
> >>>> +                             return -ENOENT;
> >>>> +                     }
> >>>> +                     dst_sec = &linker->secs[src_sec->dst_id];
> >>>> +             }
> >>>> +     }
> >>>> +
> >>>> +     glob_sym = find_glob_sym(linker, sym_name);
> >>>> +     if (glob_sym) {
> >>>> +             /* Preventively resolve to existing symbol. This is
> >>>> +              * needed for further relocation symbol remapping in
> >>>> +              * the next step of linking.
> >>>> +              */
> >>>> +             obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
> >>>> +
> >>>> +             /* If both symbols are non-externs, at least one of
> >>>> +              * them has to be STB_WEAK, otherwise they are in
> >>>> +              * a conflict with each other.
> >>>> +              */
> >>>> +             if (!sym_is_extern && !glob_sym->is_extern
> >>>> +                 && !glob_sym->is_weak && sym_bind != STB_WEAK) {
> >>>> +                     pr_warn("conflicting non-weak symbol #%d (%s)
> >>>> definition in '%s'\n",
> >>>> +                             src_sym_idx, sym_name, obj->filename);
> >>>> +                     return -EINVAL;
> >>>>                }
> >>>>
> >>>> +             if (!glob_syms_match(sym_name, linker, glob_sym, obj,
> >>>> sym, src_sym_idx, btf_id))
> >>>> +                     return -EINVAL;
> >>>> +
> >>>> +             dst_sym = get_sym_by_idx(linker, glob_sym->sym_idx);
> >>>> +
> >>>> +             /* If new symbol is strong, then force dst_sym to be
> >>>> strong as
> >>>> +              * well; this way a mix of weak and non-weak extern
> >>>> +              * definitions will end up being strong.
> >>>> +              */
> >>>> +             if (sym_bind == STB_GLOBAL) {
> >>>> +                     /* We still need to preserve type (NOTYPE or
> >>>> +                      * OBJECT/FUNC, depending on whether the
> >>>> symbol is
> >>>> +                      * extern or not)
> >>>> +                      */
> >>>> +                     sym_update_bind(dst_sym, STB_GLOBAL);
> >>>> +                     glob_sym->is_weak = false;
> >>>> +             }
> >>>> +
> >>>> +             /* Non-default visibility is "contaminating", with
> >>>> stricter
> >>>> +              * visibility overwriting more permissive ones, even
> >>>> if more
> >>>> +              * permissive visibility comes from just an extern
> >>>> definition
> >>>> +              */
> >>>> +             if (sym_vis > ELF64_ST_VISIBILITY(dst_sym->st_other))
> >>>> +                     sym_update_visibility(dst_sym, sym_vis);
> >>>
> >>> For visibility, maybe we can just handle DEFAULT and HIDDEN, and others
> >>> are not supported? DEFAULT + DEFAULT/HIDDEN => DEFAULT, HIDDEN + HIDDEN
> >>> => HIDDEN?
>
> Looking at your selftest. Your current approach, DEFAULT + DEFAULT ->
> DEFAULT, HIDDEN + HIDDEN/DEFAULT -> HIDDEN should work fine. This is
> also align with ELF principal to accommodate the least permissive
> visibility.

Yes, and also PROTECTED + HIDDEN/DEFAULT -> PROTECTED. But we don't
special handle PROTECTED right now. So I think it makes sense to error
out if anyone tries to use PROTECTED, which is why I'll restrict to
HIDDEN and DEFAULT for now.

>
> >>>
> >>
> >> Sure, we can restrict this to STV_DEFAULT and STV_HIDDEN for now. >>
> [...]
