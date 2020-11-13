Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119472B2417
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgKMSyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgKMSyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:54:50 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABB5C0613D1;
        Fri, 13 Nov 2020 10:54:50 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id l14so5503919ybq.3;
        Fri, 13 Nov 2020 10:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0c6KewSMw1khS70B/F9EOmC9/b4SWhw2T/F9MBx+LQU=;
        b=Rc7Rq9G1zqU7csuNLWbqiaJCewnqzuWehjz9DlYhN+nQEgI/osQVejAGtHmDDrJ5Dr
         sF44zi01OVqiLSXRXBpr8aAf7kGsq/BGJpwtqWgkhkxel6XSbD9BiyHJ2XMnQLt5rBhn
         ggJs5ekqm7lqodZf3qdzaTp8TJGEc1JTUkiMxAbmipEZtwcu226z+5Mv/b72iTJYCV8K
         sT5KANSqsjk6fCRVuRgR1PqKNng+HDUFJ9b3WsDTta45uSBcl2bWYH3MsLeHIWtCukuu
         YfLbPszOtx+Z54brQIXzEGBUzuUOHrJY/kAAhmdgEMMOqbijNhfpGGu1x+5NizRKksxn
         lWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0c6KewSMw1khS70B/F9EOmC9/b4SWhw2T/F9MBx+LQU=;
        b=fw8CsvubydUZNTmQU9LRSAgacJ7FSv89aCsPGcNWWne7Kn4ZhV2HoIo9wgkkVL8uE+
         +BweEDSXu6iyRBpw/mBdu7eLZEP0M8W/TrA1BT33hYRFceNlM/VY0mg5V/CogmmUTsqv
         NK745JPTYtkfxFAyDg/ui2W1YSaNSfI2QWjM6WGXvhDvRyF9kNSFUntQ4Mz0ccuaTMLp
         lW2BXztqJNCR+2Yg2qDeWYmLkF/4kWVgQnHTiIWPMLYGzlcCPJU8QnUl+/SY/gyTtJw5
         ATlq3NX5r4dEUCrKUFBN3KvYiTRaiXfurA5xn3agB1VrDvAwfWTKpY0nrDGBHINDOqCE
         EtVg==
X-Gm-Message-State: AOAM533yqKRn0rQj/0pAU+yd2c/1jkt+BEanXm72ncMAqCO49kzDTchq
        rpJ9kJ6ZzwBUBuske4152Pp2wKUYU9zoiHBKDy0zOmE8los=
X-Google-Smtp-Source: ABdhPJzEtwZ6KzD7iVEl7RAywbr89kHy8/LbK4hBcZbe33qWPxUT9g93cE58K+7OOwlPBbfN5rD+n+rk+Gq+O5s4qTE=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr5449957ybk.260.1605293689619;
 Fri, 13 Nov 2020 10:54:49 -0800 (PST)
MIME-Version: 1.0
References: <20201110011932.3201430-1-andrii@kernel.org> <20201110011932.3201430-5-andrii@kernel.org>
 <20201111101316.GA5304@linux-8ccs> <CAEf4BzZbKRgWhLD6KFOwJU8DDns9oufroBShczM9KqODCqbEPA@mail.gmail.com>
 <20201113103158.GA30836@linux-8ccs>
In-Reply-To: <20201113103158.GA30836@linux-8ccs>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Nov 2020 10:54:38 -0800
Message-ID: <CAEf4BzZtsdyMpaQCH1qKvvK+REsG_-JXcXq6sDnfYm-+oqpJEA@mail.gmail.com>
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

On Fri, Nov 13, 2020 at 2:32 AM Jessica Yu <jeyu@kernel.org> wrote:
>
> +++ Andrii Nakryiko [11/11/20 12:11 -0800]:
> >On Wed, Nov 11, 2020 at 2:13 AM Jessica Yu <jeyu@kernel.org> wrote:
> >>
> >> +++ Andrii Nakryiko [09/11/20 17:19 -0800]:
> >> [snipped]
> >> >diff --git a/kernel/module.c b/kernel/module.c
> >> >index a4fa44a652a7..f2996b02ab2e 100644
> >> >--- a/kernel/module.c
> >> >+++ b/kernel/module.c
> >> >@@ -380,6 +380,35 @@ static void *section_objs(const struct load_info *info,
> >> >       return (void *)info->sechdrs[sec].sh_addr;
> >> > }
> >> >
> >> >+/* Find a module section: 0 means not found. Ignores SHF_ALLOC flag. */
> >> >+static unsigned int find_any_sec(const struct load_info *info, const char *name)
> >> >+{
> >> >+      unsigned int i;
> >> >+
> >> >+      for (i = 1; i < info->hdr->e_shnum; i++) {
> >> >+              Elf_Shdr *shdr = &info->sechdrs[i];
> >> >+              if (strcmp(info->secstrings + shdr->sh_name, name) == 0)
> >> >+                      return i;
> >> >+      }
> >> >+      return 0;
> >> >+}
> >> >+
> >> >+/*
> >> >+ * Find a module section, or NULL. Fill in number of "objects" in section.
> >> >+ * Ignores SHF_ALLOC flag.
> >> >+ */
> >> >+static __maybe_unused void *any_section_objs(const struct load_info *info,
> >> >+                                           const char *name,
> >> >+                                           size_t object_size,
> >> >+                                           unsigned int *num)
> >> >+{
> >> >+      unsigned int sec = find_any_sec(info, name);
> >> >+
> >> >+      /* Section 0 has sh_addr 0 and sh_size 0. */
> >> >+      *num = info->sechdrs[sec].sh_size / object_size;
> >> >+      return (void *)info->sechdrs[sec].sh_addr;
> >> >+}
> >> >+
> >>
> >> Hm, I see this patchset has already been applied to bpf-next, but I
> >> guess that doesn't preclude any follow-up patches :-)
> >
> >Of course!
> >
> >>
> >> I am not a huge fan of the code duplication here, and also the fact
> >> that they're only called in one place. any_section_objs() and
> >> find_any_sec() are pretty much identical to section_objs() and
> >> find_sec(), other than the fact the former drops the SHF_ALLOC check.
> >
> >Right, but the alternative was to add a new flag to existing
> >section_objs() and find_sec() functions, which would cause much more
> >code churn for no good reason (besides saving some trivial code
> >duplication). And those true/false flags are harder to read in code
> >anyways.
>
> That's true, all fair points. I thought there was the possibility to
> avoid the code duplication if .BTF were also set to SHF_ALLOC, but I
> see for reasons you explained below it is more trouble than it's worth.
>
> >>
> >> Moreover, since it appears that the ".BTF" section is not marked
> >> SHF_ALLOC, I think this will leave mod->btf_data as a dangling pointer
> >> after the module is done loading and the module's load_info has been
> >> deallocated, since SHF_ALLOC sections are not allocated nor copied to
> >> the module's final location in memory.
> >
> >I can make sure that we also reset the btf_data pointer back to NULL,
> >if that's a big concern.
>
> It's not a terribly huge concern, since mod->btf_data is only accessed
> in the btf coming notifier at the moment, but it's probably best to at
> least not advertise it as a valid pointer anymore after the module is
> done loading. We do some pointer and section size cleanup at the end
> of do_init_module() for sections that are deallocated at the end of
> module load (starting where init_layout.base is reset to NULL),
> we could just tack on mod->btf_data = NULL there as well.

Sounds good, I'll send a follow up patch. Thanks!

>
> >>
> >> Why not simply mark the ".BTF" section in the module SHF_ALLOC? We
> >> already do some sh_flags rewriting in rewrite_section_headers(). Then
> >> the module loader knows to keep the section in memory and you can use
> >> section_objs(). And since the .BTF section stays in module memory,
> >> that might save you the memcpy() to btf->data in btf_parse_module()
> >> (unless that is still needed for some reason).
> >
> >Wasn't aware about rewrite_section_headers() manipulations. Are you
> >suggesting to just add SHF_ALLOC there for the .BTF section from the
> >kernel side? I guess that would work, but won't avoid memory copy (so
> >actually would waste kernel memory, if I understand correctly). The
> >reason being that the module's BTF is registered as an independently
> >ref-counted BTF object, which could be held past the kernel module
> >being unloaded. So I can't directly reference module's .BTF data
> >anyways.
>
> Ah OK, I was not aware that the section could be held past the module
> being unloaded. Then yeah, it would be a memory waste to keep them in
> memory if they are being memcpy'd anyway. Thanks for clarifying!
>
> Jessica
