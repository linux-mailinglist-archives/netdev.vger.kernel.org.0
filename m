Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AAE2FC661
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbhATBXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbhATBXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 20:23:00 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D703C061573;
        Tue, 19 Jan 2021 17:22:20 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id p185so6731296ybg.8;
        Tue, 19 Jan 2021 17:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j3ElYe+i7O8pw4jej0PM4b0x0kTazcaI++/FaEblhCY=;
        b=ix8yKQeBPvIN+TxWg+ZefuVqMdNihSpIESlQ4WvT70h/gkPWHc07Q2NWWONrbFezzl
         XseENX3h8+r1AIIBU6k31cp2EayDiuOvMxqnPXVZ7jK5TQlmecdEBLKqOUTGqNuc19ZW
         Iq0sBh3WKvZdURTdauJkNZKrAiniffWfYcB+nJ+0jf5PSpzBOIuJkf2ejSQsmN9qvszS
         q/qbbpOK5vEFOq9UOFxeyhQn1W6QKltUXLiibUOQ0equ6AdokmyQYEvruBVWmiUurCvD
         cjhk5S1si8SmiOI5RrOMSQNasudjJbk0xWlLMVfsilkJy9SJD8vAi41iP6flt38p/o8S
         PJbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j3ElYe+i7O8pw4jej0PM4b0x0kTazcaI++/FaEblhCY=;
        b=eADRGRmQTPVNOn17vOz7WTmLD4Ew4oN0M3V6h6FMv1hMHzJdOS6Y7VY+jRA/OlnFuo
         hWMz8hqYYBA0Rai/ganud8lH6fG+dh8rqc/KZkK34ITIjMqSI+P3bFhywLcfbBK8u+uh
         xypuML4STBuHEDuNwnQIXITqX4pUxwk2j1Iko3JfCUMsXGdMsvf8drIkkI6CPiPpN6t7
         waKNqHlQfxWaBvwH/M9eLMUvRtPjDqPQAJ7GGfIHMDwaOyg7gUsl2sG7GbGkcqZt1CzK
         gky5kKH2poD9x1teMSbTJfAzsGDJ6aP8QBOIw7Zi4fEqPu0P4RWa++a/Ea2Lq81rQHBy
         +Drw==
X-Gm-Message-State: AOAM533ZnqzEe43kSuybJ0j3Y/GDEMdBL7P852G4rF9xZOa/LuyaMLC9
        9BKRsXCisRlsaiPeGyANBVxBsAeudt5h8/EhiEs=
X-Google-Smtp-Source: ABdhPJys6J4AT217bLaNLulXMwM8V25cE2+EiRiJPD8J2Dke0qXNwDAw31yqJrfaQXv0TfFPk+eSNzEwkKXR1hpJRLk=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr9827301ybg.27.1611105739391;
 Tue, 19 Jan 2021 17:22:19 -0800 (PST)
MIME-Version: 1.0
References: <20210119221220.1745061-1-jolsa@kernel.org> <20210119221220.1745061-4-jolsa@kernel.org>
In-Reply-To: <20210119221220.1745061-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Jan 2021 17:22:08 -0800
Message-ID: <CAEf4BzZNPJZBfz7Ga9MGvGGYge4MCP1O16JVuFjdzu-bCEQFLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: Use string table index from index
 table if needed
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
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

On Tue, Jan 19, 2021 at 2:15 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> For very large ELF objects (with many sections), we could
> get special value SHN_XINDEX (65535) for elf object's string
> table index - e_shstrndx.
>
> In such case we need to call elf_getshdrstrndx to get the
> proper string table index.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/btf.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 3c3f2bc6c652..4fe987846bc0 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -863,6 +863,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
>         Elf_Scn *scn = NULL;
>         Elf *elf = NULL;
>         GElf_Ehdr ehdr;
> +       size_t shstrndx;
>
>         if (elf_version(EV_CURRENT) == EV_NONE) {
>                 pr_warn("failed to init libelf for %s\n", path);
> @@ -887,7 +888,16 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
>                 pr_warn("failed to get EHDR from %s\n", path);
>                 goto done;
>         }
> -       if (!elf_rawdata(elf_getscn(elf, ehdr.e_shstrndx), NULL)) {
> +
> +       /*
> +        * Get string table index from extended section index
> +        * table if needed.
> +        */
> +       shstrndx = ehdr.e_shstrndx;
> +       if (shstrndx == SHN_XINDEX && elf_getshdrstrndx(elf, &shstrndx))
> +               goto done;

just use elf_getshdrstrndx() unconditionally, it works for extended
and non-extended numbering (see libbpf.c).

> +
> +       if (!elf_rawdata(elf_getscn(elf, shstrndx), NULL)) {
>                 pr_warn("failed to get e_shstrndx from %s\n", path);
>                 goto done;
>         }
> @@ -902,7 +912,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
>                                 idx, path);
>                         goto done;
>                 }
> -               name = elf_strptr(elf, ehdr.e_shstrndx, sh.sh_name);
> +               name = elf_strptr(elf, shstrndx, sh.sh_name);
>                 if (!name) {
>                         pr_warn("failed to get section(%d) name from %s\n",
>                                 idx, path);
> --
> 2.27.0
>
