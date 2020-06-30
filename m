Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37D720EB21
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgF3Byn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgF3Bym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:54:42 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFD7C061755;
        Mon, 29 Jun 2020 18:54:42 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id u17so14500826qtq.1;
        Mon, 29 Jun 2020 18:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CvphssloF01xi3Q7XYZt+Pl7trcIGdQwWIvxrzOy9NE=;
        b=m68gKPZ0Y83T98hVDxcgTcmLJxbymiFZjTYPxwWka1Uku0hWazgl8EB/lr257WJp6A
         JGdwn0elmHRMrumySX2n1+02xOf0ljJYuCCrD3jNiiMDDBzS3bFQvJS26yp2/r2fAd6Q
         iTcF+Q8wrS0hPaLjuqICgL9mOT1MVwW9HnT9CfCxIT999twhgPcs23q2LIoF71jG+jdA
         2ypdMwE0oNjU6PpH4Z7a7dPkHYlhy4Agscb8tH2HM7o3ZMpxWUWP7YVkhyXmbesRYRd9
         Jli43gZEg+2NvHyRzeogxA3MGmvwPgr1CNk8j0nxDRdnQORCkdjetUXE6cniMj8p1oXQ
         5p2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CvphssloF01xi3Q7XYZt+Pl7trcIGdQwWIvxrzOy9NE=;
        b=gwoy7zL6Ogq8WHKSU0S8c4O//jfOQTCpoZ8Yxvun2m0Ma4QH8BVJRvSC/1AAiW6t7B
         6rpqiAwiANIXPU+Q51F+ADDNNlLbWo8LOc8DcyzwtxvclbV70X4wKqcG6pY+DZXTAaGf
         oNj5iFJUA2UVOLGfVKVvCSvhxEoeWYDtvFmQsIvcwRLAV6JcJyCfGZAf59fgg7VrZn8Z
         cL4eN5j9DXPIuR/hH/dIAhsZuoMPnz7CWQYwBiE6Y5c1rSFho9fIAujZui9Gg1cmtBA2
         TMW2dSpD2QP6Lt0qFOlKUrxX3ucuI9ob9QC1o2WUZKlZuMVfHVn05vRbc87hoMWD+yAf
         JMBQ==
X-Gm-Message-State: AOAM530ElgW2Gc9hw9/H+pq2G+TnZhJTwpPh5qTLovC1mwSguJ3TrEL5
        hMc0Ze2a23h2qlSQ9C7mkeuT/LpdcSY5aksDTzU=
X-Google-Smtp-Source: ABdhPJxhYdE3N3DLu7s2mN5efVqNKNiIP9Q7BxaHj4EtPmsH0+LZCmEL3hWKqVvLp55fIEHn0ImP1pHipzAGCCqVdRM=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr18558349qtd.59.1593482081916;
 Mon, 29 Jun 2020 18:54:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 18:54:30 -0700
Message-ID: <CAEf4BzbMND3VGxzqYU38agbTd+EVquD7J1Spx9LeR=569qMyEg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 00/14] bpf: Add d_path helper
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

On Thu, Jun 25, 2020 at 4:47 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> adding d_path helper to return full path for 'path' object.
>
> In a preparation for that, this patchset also adds support for BTF ID
> whitelists, because d_path can't be called from any probe due to its
> locks usage. The whitelists allow verifier to check if the caller is
> one of the functions from the whitelist.
>
> The whitelist is implemented in a generic way. This patchset introduces
> macros that allow to define lists of BTF IDs, which are compiled in
> the kernel image in a new .BTF.ids ELF section.
>
> The generic way of BTF ID lists allows us to use them in other places
> in kernel (than just for whitelists), that could use static BTF ID
> values compiled in and it's also implemented in this patchset.
>
> I originally added and used 'file_path' helper, which did the same,
> but used 'struct file' object. Then realized that file_path is just
> a wrapper for d_path, so we'd cover more calling sites if we add
> d_path helper and allowed resolving BTF object within another object,
> so we could call d_path also with file pointer, like:
>
>   bpf_d_path(&file->f_path, buf, size);
>
> This feature is mainly to be able to add dpath (filepath originally)
> function to bpftrace:
>
>   # bpftrace -e 'kfunc:vfs_open { printf("%s\n", dpath(args->path)); }'
>
> v4 changes:
>   - added ID sanity checks in btf_resolve_helper_id [Andrii]
>   - resolve bpf_ctx_convert via BTF_ID [Andrii]
>   - keep bpf_access_type in btf_struct_access [Andrii]
>   - rename whitelist to se and use struct btf_id_set [Andrii]
>   - several fixes for d_path prog/verifier tests [Andrii]
>   - added union and typedefs types support [Andrii]
>   - rename btfid to resolve_btfids [Andrii]
>   - fix segfault in resolve_btfids [John]
>   - rename section from .BTF_ids .BTF.ids (following .BTF.ext example)
>   - add .BTF.ids section info into btf.rst [John]
>   - updated over letter with more details [John]
>
> Also available at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   bpf/d_path
>
> thanks,
> jirka
>
>
> ---

Have you considered splitting this series into two? One with BTF ID
resolution and corresponding patches. I'm pretty confident in that one
and it seems ready (with some minor selftest changes). Then,
separately, d_path and that sub-struct address logic. That one depends
on the first one, but shouldn't really block BTF ID resolution from
going in sooner.

> Jiri Olsa (14):
>       bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object
>       bpf: Compile resolve_btfids tool at kernel compilation start
>       bpf: Add BTF_ID_LIST/BTF_ID macros
>       bpf: Resolve BTF IDs in vmlinux image
>       bpf: Remove btf_id helpers resolving
>       bpf: Use BTF_ID to resolve bpf_ctx_convert struct
>       bpf: Allow nested BTF object to be refferenced by BTF object + offset
>       bpf: Add BTF_SET_START/END macros
>       bpf: Add info about .BTF.ids section to btf.rst
>       bpf: Add d_path helper
>       tools headers: Adopt verbatim copy of btf_ids.h from kernel sources
>       selftests/bpf: Add verifier test for d_path helper
>       selftests/bpf: Add test for d_path helper
>       selftests/bpf: Add test for resolve_btfids
>

[...]
