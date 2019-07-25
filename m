Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A37429A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 02:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfGYAh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 20:37:28 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38604 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfGYAh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 20:37:28 -0400
Received: by mail-qt1-f193.google.com with SMTP id n11so47411167qtl.5;
        Wed, 24 Jul 2019 17:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rkYrcnzGklcjqyrCpXelRjKMi97QveEgZZ2vQcZX2ZE=;
        b=VYZLhzwaqlhUYckpCGpBP1LTZCh6+zml2gUGKSwnTqGVJw5iiXDIWeZdwEWACT9dTh
         0PGMRYuj12InP14cG8RkLVM1Ua3+FMFArGfr6vYkxgrqjvgdMeHQuo75m5d0pAACIEgH
         E5EvLv4PwdbwfUI4jsIjO1k1iJNQDipEQEf0Plmyz+ogbJ6mmuvQr769rPSWoIM2wUBF
         /5w95je6gH+iOH+bDOXRgm09DBTVi/jSH3d/rkMe/CLnvjS1nkR5apI1ZK1nOMnINid4
         jJkfOYthdlLJ0VTR6538LUIafRF6Xuy1+Ho12OjnDjz8bq3GZKmfxNlk6bBVdIGiHoz1
         P9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rkYrcnzGklcjqyrCpXelRjKMi97QveEgZZ2vQcZX2ZE=;
        b=tlyGCGZkS2i7qzlSjxhej5d/7t7ZEsqO+HXxOU2gEeUlUC2eunFG8c4frFVp+H7IFk
         PyBM0ApY/iIqgWmPe3RwoBh65w1/4hBDIUz382uLxydYO0BpNaRGRNRh9xNY+vz/lozW
         pkndhQKjZBSiESX5E5+KvMkFtB1ryx2vBfGjGdRmibGGHmJX3yUoy5FJYsbNRwiKMw2n
         lF2cHUijr6PtKXUHmaIYeFSl4DKa0i0DPZRuUdvGIRfLLqXZGvs6HDoxxAgeVw/QtPSO
         NXT+oMyJcJxQlcrkLnWMlKJotCf/hCBCFJixFhgkkw8tqDj5c9Q/UnClCKLIOv3jeExT
         bfOA==
X-Gm-Message-State: APjAAAVadcZnqBKlIIa4Bpe9AQ6yKPzei9YsQ0nLqaZ38nPUbe+XELp5
        r9GIWXNjzCPhGgsb/flZ8gJlYARxo0TK5PGURX8=
X-Google-Smtp-Source: APXvYqxXGC3tv3syaluC0CU6o88VgNxqa1oaqH9sLYDIqc3Op07TJi40G+uuR07Vt8LYt8PkGpdgUsRXiruBEEtkTro=
X-Received: by 2002:a0c:818f:: with SMTP id 15mr58085742qvd.162.1564015047359;
 Wed, 24 Jul 2019 17:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-2-andriin@fb.com>
 <B5E772A5-C0D9-4697-ADE2-2A94C4AD37B5@fb.com>
In-Reply-To: <B5E772A5-C0D9-4697-ADE2-2A94C4AD37B5@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Jul 2019 17:37:16 -0700
Message-ID: <CAEf4BzZsU8qXa08neQ=nrFFTXpSWsxrZuZz=kVjS2BXNUoofUw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] libbpf: add .BTF.ext offset relocation
 section loading
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 5:00 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add support for BPF CO-RE offset relocations. Add section/record
> > iteration macros for .BTF.ext. These macro are useful for iterating over
> > each .BTF.ext record, either for dumping out contents or later for BPF
> > CO-RE relocation handling.
> >
> > To enable other parts of libbpf to work with .BTF.ext contents, moved
> > a bunch of type definitions into libbpf_internal.h.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/btf.c             | 64 +++++++++--------------
> > tools/lib/bpf/btf.h             |  4 ++
> > tools/lib/bpf/libbpf_internal.h | 91 +++++++++++++++++++++++++++++++++
> > 3 files changed, 118 insertions(+), 41 deletions(-)
> >

[...]

> > +
> > static int btf_ext_parse_hdr(__u8 *data, __u32 data_size)
> > {
> >       const struct btf_ext_header *hdr = (struct btf_ext_header *)data;
> > @@ -1004,6 +979,13 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 size)
> >       if (err)
> >               goto done;
> >
> > +     /* check if there is offset_reloc_off/offset_reloc_len fields */
> > +     if (btf_ext->hdr->hdr_len < sizeof(struct btf_ext_header))
>
> This check will break when we add more optional sections to btf_ext_header.
> Maybe use offsetof() instead?

I didn't do it, because there are no fields after offset_reloc_len.
But now I though that maybe it would be ok to add zero-sized marker
field, kind of like marking off various versions of btf_ext header?

Alternatively, I can add offsetofend() macro somewhere in libbpf_internal.h.

Do you have any preference?

>
> > +             goto done;
> > +     err = btf_ext_setup_offset_reloc(btf_ext);
> > +     if (err)
> > +             goto done;
> > +
> > done:

[...]
