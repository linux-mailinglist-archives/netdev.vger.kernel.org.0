Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAB7301A22
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 07:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhAXGJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 01:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAXGJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 01:09:02 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A51DC061573;
        Sat, 23 Jan 2021 22:08:22 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id i141so9997934yba.0;
        Sat, 23 Jan 2021 22:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Z/2Ilxxmqb2VTfLDcIvMPIJEIfnk9D8Dw6wAk1T0KA=;
        b=tZoCItM+obRTF+olLdMs9aRJsVvaNcwJnhK1NJx5sITGBjJnTCs4wgrJErpeIoLdFN
         1oGsCgTJiI6fIHabTRbdozYCWai99r6ERTBJTArx9tDAaTyiX/zdtl2sI1gkTaQZeKXQ
         ThtxQ1FFM4z/Fuv69oQmPoVX9QvF1aRHc+KxQYgYEHfvoaDMxshumIIO2o0abu14v46+
         UlxdyP3Cs1xZERru4CKYa4an+TWQNBdpAarXVDFEw8gV9BYiJpEV3dx/FAtUge3G3NvT
         m+5xxQ/qR0smxedbeUmbxQ1vJEcbIRWI22ukliufRdPInQtBi8tDP9cq3d8MpfDQQAEG
         KYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Z/2Ilxxmqb2VTfLDcIvMPIJEIfnk9D8Dw6wAk1T0KA=;
        b=EcyFmStlYNQrlLdnG6wCIuB4tj1KZ9ncNhOPZWreCX3nvAPHb53Z3SJQOllW/mh4WO
         jFe4NnZpqnxMhe/ZIMJPxieVmuqvVWJGvT66IhRRy1jwK/dPD1oiGgvupXBSkewRD4Q3
         7tHTyGyhk7L3mbiaaxz+tctOLt/uZBa6G6BEra3XRcqd6qix467GXiCnbB6mIwWDI2gt
         E6BcSPE6LpITSv0D9VHgLdYqpMsfO+y8aKAJprKW+3T35rxB0Fo6EzCa7YWu4b/73d3Z
         fKT49AnWmEqCojG76cCTm6rvb2eH9Qrjty4pF0EFhPDkriYnlna6a7HPsxw2epvsQdup
         3n8w==
X-Gm-Message-State: AOAM531Ca6YXXnXqUwtxmOQmvfrWg7Hu4369PrAZrtwtJNTpJxYZvx+C
        D4RqYCLcGaZOmBkSnTrzmA/MguubR/WLnYg3ZnU=
X-Google-Smtp-Source: ABdhPJzkG8ibM33ns8CNui5frd1GsQEvbqOl9xdb0zXpOkDJrjh5qXop6Bkn+pvCEtnDeBE6IjihajEQ+whdPHcpU8M=
X-Received: by 2002:a25:9882:: with SMTP id l2mr16341174ybo.425.1611468501020;
 Sat, 23 Jan 2021 22:08:21 -0800 (PST)
MIME-Version: 1.0
References: <20210121202203.9346-1-jolsa@kernel.org> <20210121202203.9346-3-jolsa@kernel.org>
 <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com> <20210123212341.GC117714@krava>
In-Reply-To: <20210123212341.GC117714@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 23 Jan 2021 22:08:10 -0800
Message-ID: <CAEf4BzaaP8YwCsQpiSkCCgYFTqFJ-yV234u0dtuxOgEQgwPeiA@mail.gmail.com>
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 1:23 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Jan 21, 2021 at 03:32:40PM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> > But the current variant looks broken. Oh, and
> > elf_symtab__for_each_symbol() is similarly broken, can you please fix
> > that as well?
>
> we'll have to change its callers a bit, because of hanging 'else'
> I'll send this separately if that's ok, when I figure out how to
> test ctf code
>

oh, else sucks. Sure, no problem doing it separately.

> jirka
>
>
> ---
> diff --git a/elf_symtab.h b/elf_symtab.h
> index 489e2b1a3505..6823a8c37ecf 100644
> --- a/elf_symtab.h
> +++ b/elf_symtab.h
> @@ -99,10 +99,9 @@ elf_sym__get(Elf_Data *syms, Elf_Data *syms_sec_idx_table,
>   * @index: uint32_t index
>   * @sym: GElf_Sym iterator
>   */
> -#define elf_symtab__for_each_symbol(symtab, index, sym) \
> -       for (index = 0, gelf_getsym(symtab->syms, index, &sym);\
> -            index < symtab->nr_syms; \
> -            index++, gelf_getsym(symtab->syms, index, &sym))
> +#define elf_symtab__for_each_symbol(symtab, index, sym)                \
> +       for (index = 0; index < symtab->nr_syms; index++)       \
> +               if (gelf_getsym(symtab->syms, index, &sym))
>
>  /**
>   * elf_symtab__for_each_symbol_index - iterate through all the symbols,
> diff --git a/libctf.h b/libctf.h
> index 749be8955c52..ee5412bec77e 100644
> --- a/libctf.h
> +++ b/libctf.h
> @@ -90,11 +90,9 @@ char *ctf__string(struct ctf *ctf, uint32_t ref);
>   */
>  #define ctf__for_each_symtab_function(ctf, index, sym)                       \
>         elf_symtab__for_each_symbol(ctf->symtab, index, sym)                  \
> -               if (ctf__ignore_symtab_function(&sym,                         \
> +               if (!ctf__ignore_symtab_function(&sym,                        \
>                                                 elf_sym__name(&sym,           \
>                                                               ctf->symtab)))  \
> -                       continue;                                             \
> -               else
>
>  /**
>   * ctf__for_each_symtab_object - iterate thru all the symtab objects
> @@ -105,11 +103,9 @@ char *ctf__string(struct ctf *ctf, uint32_t ref);
>   */
>  #define ctf__for_each_symtab_object(ctf, index, sym)                         \
>         elf_symtab__for_each_symbol(ctf->symtab, index, sym)                  \
> -               if (ctf__ignore_symtab_object(&sym,                           \
> +               if (!ctf__ignore_symtab_object(&sym,                          \
>                                               elf_sym__name(&sym,             \
>                                                             ctf->symtab)))    \
> -                       continue;                                             \
> -               else
>
>
>  #endif /* _LIBCTF_H */
>
