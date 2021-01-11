Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F112F212A
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbhAKUwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKUwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:52:09 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC45C061786;
        Mon, 11 Jan 2021 12:51:28 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id r63so93947ybf.5;
        Mon, 11 Jan 2021 12:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XBkaYt5WREhWLVNUYKKmCiMEYrqWo6+GrHTKOekyuZs=;
        b=qlKh1L8FbjHHW9xvlr7/fmEufY/3bamOppWooa6Pz+CSud25F6C4L0eIKuI94pbKNd
         BIthwYVGW3VxFj1QUNRBD4WCGSG4GwOvZ9L2R5qfLObLSzhV+O0K82xgV7eiN2wxZw1s
         Wq6rbuFefBopZWGJi39yga1DXX/k2o4BGKQd9u2MK6O0G1rOedMawqNnWLE40H1CDbEx
         mNkgHXR6P8SdhVWCx+gbgPAxXBqq1AfWsh3FsqxBTCNb5w53Z6aKqlc6W2lBnl2NNQib
         eoFSbBRfyqgzMgjefrLUlVanCLIfdAjo28TVTK+YmER8rGIocrN8byHQZZu98JafxbPE
         gjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XBkaYt5WREhWLVNUYKKmCiMEYrqWo6+GrHTKOekyuZs=;
        b=MbCpKQC5r42wW0VtEMca7Q81cET/73bnJSktbDm1gJqyEbWFQousFU71yABjFcfpNq
         j/470CAIXWyAVhI0lMCs1FxLArNGXZcljd5oA664YSCmlTRqRpP7aih5O8nLJvuAJ2az
         VNCfITcbvQw+TvYS980pAH+m8zTF/2T+gTct/i8BYBl5o54wWC7mTLycF/d7Z0ru7Ar9
         3Q3bq1wP3DdLoLH40R4y22+bxwT+x7X5k6/O/moXGeSckot2ZRUyeH96Wbn2Qrgs/GvZ
         C7Us2DVWJpYjWJDrC+EtpjHHLjGjnRm0C7AzSzjOTfqBuL/6o8fbFySNbvNKBTCKwk9T
         /vTg==
X-Gm-Message-State: AOAM53146Dbw/Vk72JsHUoUz6rUehI8lzFRI6NO+PT2WrUGdwJDShbCL
        HhOwilNXvnmc5N0FZkVq955c6Q5iOjcXhOKokMnfN2aEFj8=
X-Google-Smtp-Source: ABdhPJyQUTAT1d2wXFSbqCke8Uz35fl6+5A2UHF9JDlmOZvptkUnIStHzZYuLZQng2CTIMBapWuwQIuZCsiJMXVnuXs=
X-Received: by 2002:a25:aea8:: with SMTP id b40mr2291043ybj.347.1610398287941;
 Mon, 11 Jan 2021 12:51:27 -0800 (PST)
MIME-Version: 1.0
References: <20210110070341.1380086-1-andrii@kernel.org> <20210110070341.1380086-2-andrii@kernel.org>
 <e621981d-5c3d-6d92-871b-a98520778363@fb.com>
In-Reply-To: <e621981d-5c3d-6d92-871b-a98520778363@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 12:51:17 -0800
Message-ID: <CAEf4BzZhFrHho-F+JyY6wQyWUZ+0cJJLkGv+=DHP4equkkm4iw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: allow loading empty BTFs
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Christopher William Snowhill <chris@kode54.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 10:13 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/9/21 11:03 PM, Andrii Nakryiko wrote:
> > Empty BTFs do come up (e.g., simple kernel modules with no new types and
> > strings, compared to the vmlinux BTF) and there is nothing technically wrong
> > with them. So remove unnecessary check preventing loading empty BTFs.
> >
> > Reported-by: Christopher William Snowhill <chris@kode54.net>
> > Fixes: ("d8123624506c libbpf: Fix BTF data layout checks and allow empty BTF")
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >   tools/lib/bpf/btf.c | 5 -----
> >   1 file changed, 5 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 3c3f2bc6c652..9970a288dda5 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -240,11 +240,6 @@ static int btf_parse_hdr(struct btf *btf)
> >       }
> >
> >       meta_left = btf->raw_size - sizeof(*hdr);
> > -     if (!meta_left) {
> > -             pr_debug("BTF has no data\n");
> > -             return -EINVAL;
> > -     }
>
> Previous kernel patch allows empty btf only if that btf is module (not
> base/vmlinux) btf. Here it seems we allow any empty non-module btf to be
> loaded into the kernel. In such cases, loading may fail? Maybe we should
> detect such cases in libbpf and error out instead of going to kernel and
> get error back?

I did this consciously. Kernel is more strict, because there is no
reasonable case when vmlinux BTF or BPF program's BTF can be empty (at
least not that now we have FUNCs in BTF). But allowing libbpf to load
empty BTF generically is helpful for bpftool, as one example, for
inspection. If you do `bpftool btf dump` on empty BTF, it will just
print nothing and you'll know that it's a valid (from BTF header
perspective) BTF, just doesn't have any types (besides VOID). If we
don't allow it, then we'll just get an error and then you'll have to
do painful hex dumping and decoding to see what's wrong.

In practice, no BPF program's BTF should be empty, but if it is, the
kernel will rightfully stop you. I don't think it's a common enough
case for libbpf to handle.

>
> > -
> >       if (meta_left < hdr->str_off + hdr->str_len) {
> >               pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> >               return -EINVAL;
> >
