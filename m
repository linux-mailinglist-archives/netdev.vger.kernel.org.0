Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF552AF991
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgKKUML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgKKUML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:12:11 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598A1C0613D1;
        Wed, 11 Nov 2020 12:12:11 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id v92so3092546ybi.4;
        Wed, 11 Nov 2020 12:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pB38drbiYuyH57f1j/OGS58rHVCVIBiVZxazCjdLplA=;
        b=YTaod/s6xOSthLFOf5v9u0Agfru7+P51p/rp9bBE05FqDCVEEi1IKyAy/Ksck1hJgj
         M7FKDYj9jAXS8yANQRlv8ehfwdaEx0pfj5IYInLYYzgakIcJYPsbEQGNVOedib+0DQZK
         T/44IWZV4CD8Y2YlrVMjLeyReEPgBi76rdiY72xd3WBnHpOD0wRtZwyVWgEl9MNCD1MY
         TNCMVgBmshhtaxiIRo3P7V1gtbsawLC7Zdo7wRWsjpcqDFWJKftVWjtGDmKI4wEueaK0
         oE1jnTHUKV/kOnxxdTAo480tDlvuTCX7j/RwXNEFRkPmvx44to1XCma6Jlgb3Jmj+n20
         9fow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pB38drbiYuyH57f1j/OGS58rHVCVIBiVZxazCjdLplA=;
        b=A8/Eh2z2ZKZFf8ocBm/wnqh8T+UaL7bDa8+dWMw9lmic7b5JIN0pJRhCL7tnOc1B2G
         PeQyYaYW3MFjJZZ27pnrzGut/JnmDqbtZoGN2oAhN7qnhV9hm/qimTuXef8ofZ6u3ZPV
         BxhfKZ3+7O3Bjzxwx2uafIJ7W97NtInfSwrQfA9HxMePsoaNo+PSIAGvrimwX49Z80Yq
         fLEvzVKeBe+Ibkwuc9MadiLF/YO7SkRh3k9I18FrHjNeNN4UJRNH6I5lH7tcx03bdfSM
         +17SQbNqA8fMi6U3aTLIoC500AzgH1pu9jGnR260mOfM43fSS3Rz73KWz/CUahwYdnDN
         +E5g==
X-Gm-Message-State: AOAM533f7vdGe4/bLuAEbknzuXQbWHCsIjNtnWrC5gDrBSMwqTWy+e7L
        MYChxINfXovzPXNuj0057SDGMx/5fywo7+BR26c=
X-Google-Smtp-Source: ABdhPJzYDY7ZkALEs1trStLJuAnj+VHR91+D3T1A0rOUFfDHX+SUOJaXYI/asPu5fxHeZTrSFyR9P8zb/E7BjHmo044=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr9444434ybg.230.1605125530599;
 Wed, 11 Nov 2020 12:12:10 -0800 (PST)
MIME-Version: 1.0
References: <20201110011932.3201430-1-andrii@kernel.org> <20201110011932.3201430-5-andrii@kernel.org>
 <20201111101316.GA5304@linux-8ccs>
In-Reply-To: <20201111101316.GA5304@linux-8ccs>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Nov 2020 12:11:59 -0800
Message-ID: <CAEf4BzZbKRgWhLD6KFOwJU8DDns9oufroBShczM9KqODCqbEPA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 4/5] bpf: load and verify kernel module BTFs
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 2:13 AM Jessica Yu <jeyu@kernel.org> wrote:
>
> +++ Andrii Nakryiko [09/11/20 17:19 -0800]:
> [snipped]
> >diff --git a/kernel/module.c b/kernel/module.c
> >index a4fa44a652a7..f2996b02ab2e 100644
> >--- a/kernel/module.c
> >+++ b/kernel/module.c
> >@@ -380,6 +380,35 @@ static void *section_objs(const struct load_info *info,
> >       return (void *)info->sechdrs[sec].sh_addr;
> > }
> >
> >+/* Find a module section: 0 means not found. Ignores SHF_ALLOC flag. */
> >+static unsigned int find_any_sec(const struct load_info *info, const char *name)
> >+{
> >+      unsigned int i;
> >+
> >+      for (i = 1; i < info->hdr->e_shnum; i++) {
> >+              Elf_Shdr *shdr = &info->sechdrs[i];
> >+              if (strcmp(info->secstrings + shdr->sh_name, name) == 0)
> >+                      return i;
> >+      }
> >+      return 0;
> >+}
> >+
> >+/*
> >+ * Find a module section, or NULL. Fill in number of "objects" in section.
> >+ * Ignores SHF_ALLOC flag.
> >+ */
> >+static __maybe_unused void *any_section_objs(const struct load_info *info,
> >+                                           const char *name,
> >+                                           size_t object_size,
> >+                                           unsigned int *num)
> >+{
> >+      unsigned int sec = find_any_sec(info, name);
> >+
> >+      /* Section 0 has sh_addr 0 and sh_size 0. */
> >+      *num = info->sechdrs[sec].sh_size / object_size;
> >+      return (void *)info->sechdrs[sec].sh_addr;
> >+}
> >+
>
> Hm, I see this patchset has already been applied to bpf-next, but I
> guess that doesn't preclude any follow-up patches :-)

Of course!

>
> I am not a huge fan of the code duplication here, and also the fact
> that they're only called in one place. any_section_objs() and
> find_any_sec() are pretty much identical to section_objs() and
> find_sec(), other than the fact the former drops the SHF_ALLOC check.

Right, but the alternative was to add a new flag to existing
section_objs() and find_sec() functions, which would cause much more
code churn for no good reason (besides saving some trivial code
duplication). And those true/false flags are harder to read in code
anyways.

>
> Moreover, since it appears that the ".BTF" section is not marked
> SHF_ALLOC, I think this will leave mod->btf_data as a dangling pointer
> after the module is done loading and the module's load_info has been
> deallocated, since SHF_ALLOC sections are not allocated nor copied to
> the module's final location in memory.

I can make sure that we also reset the btf_data pointer back to NULL,
if that's a big concern.

>
> Why not simply mark the ".BTF" section in the module SHF_ALLOC? We
> already do some sh_flags rewriting in rewrite_section_headers(). Then
> the module loader knows to keep the section in memory and you can use
> section_objs(). And since the .BTF section stays in module memory,
> that might save you the memcpy() to btf->data in btf_parse_module()
> (unless that is still needed for some reason).

Wasn't aware about rewrite_section_headers() manipulations. Are you
suggesting to just add SHF_ALLOC there for the .BTF section from the
kernel side? I guess that would work, but won't avoid memory copy (so
actually would waste kernel memory, if I understand correctly). The
reason being that the module's BTF is registered as an independently
ref-counted BTF object, which could be held past the kernel module
being unloaded. So I can't directly reference module's .BTF data
anyways.

Also, marking .BTF with SHF_ALLOC with pahole or objcopy tool actually
might generate warnings because SHF_ALLOC sections need to be
allocated to data segments, which neither of those tools know how to
do, it requires a linker support. We do that for vmlinux with extra
linker script logic, but for kernel modules we don't have and probably
don't want to do that.

So in the end, the cleanest approach still seems like not doing
SHF_ALLOC but allowing "capturing" .BTF data with an extra helper.

>
> Thanks,
>
> Jessica
>
> > /* Provided by the linker */
> > extern const struct kernel_symbol __start___ksymtab[];
> > extern const struct kernel_symbol __stop___ksymtab[];
> >@@ -3250,6 +3279,9 @@ static int find_module_sections(struct module *mod, struct load_info *info)
> >                                          sizeof(*mod->bpf_raw_events),
> >                                          &mod->num_bpf_raw_events);
> > #endif
> >+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> >+      mod->btf_data = any_section_objs(info, ".BTF", 1, &mod->btf_data_size);
> >+#endif
> > #ifdef CONFIG_JUMP_LABEL
> >       mod->jump_entries = section_objs(info, "__jump_table",
> >                                       sizeof(*mod->jump_entries),
> >--
> >2.24.1
> >
