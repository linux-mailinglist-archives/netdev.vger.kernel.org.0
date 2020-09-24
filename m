Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676E1277A2C
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgIXU1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXU1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:27:33 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C739C0613CE;
        Thu, 24 Sep 2020 13:27:33 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 133so357350ybg.11;
        Thu, 24 Sep 2020 13:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sVpaIrHnlGnETUATILxTCCZgsMdSdAWqsYduFS9Muoo=;
        b=cVkXGmp4no6HwJYCYhY/Zyu8ov4nTeEGl5H+gHBREhIL6QDll3gGB/yO1Hg6e7ksLu
         XiAEIdKIhS6NVBV2tshXR2wv+3mavCOD+oNbWTdNKtrBHjcEp7J700mBpXwpi/6nrfRa
         rJaq5J2zdWrm2O60x2j9tC0jGVxFhp7sDNIJsxzPyFuN+KLQHCdJcY4M6CmlkjX2hu3f
         rJlMtjbEktkMN37OUWH7Oin++QEOoaWynlvgYILuZStqGltj/TrmrD4XsEz/PdOpCG4e
         hWTQSTB9toRj9x/fTL5a+03Iqoo/pCXpq1Mxa1eAYnRQ2n02yGXwHKM//iKUaz30Levt
         68jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sVpaIrHnlGnETUATILxTCCZgsMdSdAWqsYduFS9Muoo=;
        b=hWabpFzbiGtbChoICutsHzeJVLP1rCcn+5aOkQBl/lsvNmrtHDC6ke3zghUZ864XmH
         FOHz5pvXV0cTGnRbaah3nUo879Ss2NrE+PBg4e4n73OwA2jJMhUwkP+7YjLg/5rdD1nx
         W9xM8Z+ofYyjo5oxXhfuvBLO6K9VbTRQOuP+S0fiRgMlCMYn8eNolqr112yMXP0y6LsZ
         aW8pNaNtUcTZMxWLDOPyHIdMoknYUfhv0AUamcXCe2V4QD1lXnegFN79yDfD5a9ojPPC
         dryc2dyZuzLZsgsQa92JbfoNAmILiObTgPARQ8+9eKlS/0L6EKkJKCk+IzZm6AQ4/dc2
         tKPQ==
X-Gm-Message-State: AOAM532/yJb1IQBS2mLVwbzGG48/A5/N3nQl0fbJaYwYAKQl8YA2q1ZM
        Le2Mj+/ARCf7JkSGgj2PVhgrvM5FwrOTRIeo/Kk=
X-Google-Smtp-Source: ABdhPJxcQjaGZ917mia033FxGjaWM6WigbkGpl9gVx8LQFkPVt3gtaRye04VnaDz6yea2//no0qpI60hW/ycX+977ec=
X-Received: by 2002:a25:2596:: with SMTP id l144mr754767ybl.510.1600979252721;
 Thu, 24 Sep 2020 13:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200923155436.2117661-1-andriin@fb.com> <20200923155436.2117661-6-andriin@fb.com>
 <5f6cc1a188bdf_4939c208e1@john-XPS-13-9370.notmuch>
In-Reply-To: <5f6cc1a188bdf_4939c208e1@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 13:27:22 -0700
Message-ID: <CAEf4Bzaiz9SCH1JFBK8zou=GHwZwEiDfUxKhtWzUv2t=4jYfkQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/9] libbpf: allow modification of BTF and add
 btf__add_str API
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 8:56 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Allow internal BTF representation to switch from default read-only mode, in
> > which raw BTF data is a single non-modifiable block of memory with BTF header,
> > types, and strings layed out sequentially and contiguously in memory, into
> > a writable representation with types and strings data split out into separate
> > memory regions, that can be dynamically expanded.
> >
> > Such writable internal representation is transparent to users of libbpf APIs,
> > but allows to append new types and strings at the end of BTF, which is
> > a typical use case when generating BTF programmatically. All the basic
> > guarantees of BTF types and strings layout is preserved, i.e., user can get
> > `struct btf_type *` pointer and read it directly. Such btf_type pointers might
> > be invalidated if BTF is modified, so some care is required in such mixed
> > read/write scenarios.
> >
> > Switch from read-only to writable configuration happens automatically the
> > first time when user attempts to modify BTF by either adding a new type or new
> > string. It is still possible to get raw BTF data, which is a single piece of
> > memory that can be persisted in ELF section or into a file as raw BTF. Such
> > raw data memory is also still owned by BTF and will be freed either when BTF
> > object is freed or if another modification to BTF happens, as any modification
> > invalidates BTF raw representation.
> >
> > This patch adds the first BTF writing API: btf__add_str(), which allows to
> > add arbitrary strings to BTF string section. All the added strings are
> > automatically deduplicated. This is achieved by maintaining an additional
> > string lookup index for all unique strings. Such index is built when BTF is
> > switched to modifiable mode. If at that time BTF strings section contained
> > duplicate strings, they are not de-duplicated. This is done specifically to
> > not modify the existing content of BTF (types, their string offsets, etc),
> > which can cause confusion and is especially important property if there is
> > struct btf_ext associated with struct btf. By following this "imperfect
> > deduplication" process, btf_ext is kept consitent and correct. If
> > deduplication of strings is necessary, it can be forced by doing BTF
> > deduplication, at which point all the strings will be eagerly deduplicated and
> > all string offsets both in struct btf and struct btf_ext will be updated.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> [...]
>
> > +/* Ensure BTF is ready to be modified (by splitting into a three memory
> > + * regions for header, types, and strings). Also invalidate cached
> > + * raw_data, if any.
> > + */
> > +static int btf_ensure_modifiable(struct btf *btf)
> > +{
> > +     void *hdr, *types, *strs, *strs_end, *s;
> > +     struct hashmap *hash = NULL;
> > +     long off;
> > +     int err;
> > +
> > +     if (btf_is_modifiable(btf)) {
> > +             /* any BTF modification invalidates raw_data */
> > +             if (btf->raw_data) {
>
> I missed why this case is needed? Just being cautious? It looks like
> we get btf->hdr != btf->raw_data (aka btf_is_modifiable) below, but
> by the tiime we do this set it looks like we will always null btf->raw_data
> as well. Again doesn't appear harmful just seeing if I missed a path.

It's because of btf__get_raw_data() (it's currently used by pahole for
BTF dedup). raw_data is cached in struct btf and is owned by it, so
when we attempt modification, we have to invalidate a single-blob
representation, as it is immediately invalid. This is mostly to
preserve existing semantics, but also not to keep allocating new
memory if caller created BTF and then accesses raw_data few times.

>
> > +                     free(btf->raw_data);
> > +                     btf->raw_data = NULL;
> > +             }
> > +             return 0;
> > +     }
> > +
> > +     /* split raw data into three memory regions */
> > +     hdr = malloc(btf->hdr->hdr_len);
> > +     types = malloc(btf->hdr->type_len);
> > +     strs = malloc(btf->hdr->str_len);
> > +     if (!hdr || !types || !strs)
> > +             goto err_out;
> > +
> > +     memcpy(hdr, btf->hdr, btf->hdr->hdr_len);
> > +     memcpy(types, btf->types_data, btf->hdr->type_len);
> > +     memcpy(strs, btf->strs_data, btf->hdr->str_len);
> > +
> > +     /* build lookup index for all strings */
> > +     hash = hashmap__new(strs_hash_fn, strs_hash_equal_fn, btf);
> > +     if (IS_ERR(hash)) {
> > +             err = PTR_ERR(hash);
> > +             hash = NULL;
> > +             goto err_out;
> > +     }
> > +
>
> [...]
>
> Thanks,
> John
