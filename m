Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA2C2ADE5F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731499AbgKJSbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgKJSbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:31:38 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11657C0613CF;
        Tue, 10 Nov 2020 10:31:37 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id c129so12594157yba.8;
        Tue, 10 Nov 2020 10:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=peGiCwgtCJ3sRYv27ePRKvzy1zD9nBWcslzddhBQHGo=;
        b=QoBv/dR75xRGMgLxop0xRqFlVbS+msKtifA8Uoq634CC1Np3Pt7m8UuN1fpTkll19P
         jWt7ZUvjrcgkFOfeoB2QaEbulhROzjQs+3sBrgfKxk7f3UPn5ST4moI8SIP4hXzc4RTE
         CiLNe21s6yJXxSFZ+bb1JJ3/84XTPfrb0sisIipfzxpomtwPbRFcN9XJe8y2Br+JRyut
         KQ1YR/n9foD0B/6740z8WkhKyXgRBtQbaibcI8SOO5WUcaikIjFnNPWQ2X2Y3hu3Vv6r
         yfjAb5/t7P3M/MT3/A8dQucA5lbOPdoJ2vPHoLcbwJszHKxsK4ChtEO7iRybrcCdiIAS
         yGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=peGiCwgtCJ3sRYv27ePRKvzy1zD9nBWcslzddhBQHGo=;
        b=HZbsNYsHnUfopmZlEv5z22eVxhltBdUsX6OQuL1/sviXOQbbHFvqw58rM6qUu+gmya
         oKGHeKMHyJv1LQOTCJ8Bz2pHUxaXXBkmWOjwXT1Qe2TkCf44euVDQoe21LgrBcDM81As
         wGlEAwDQLsYm+PQaKc/IFGRpV6uQ2LNKiNySHp6nIk7EvSRDliYFMKfG1nK2HICcOmRj
         VyQtCKJeNGHEjL5UQWxkRMm9obKmHWUqeTl2pao5TmMsoqKOLrf15ASjBaFNuB5i6Lss
         GeOtg/Z6aKW+NygQy3ge9swGv8F8Vn4vfM8wGi2gzrdk5xzgiaSifr4tTcdsYYPueerh
         pEUQ==
X-Gm-Message-State: AOAM533V20LEK6nnEyZbFpjHBJOgb/AVrTrZZyi5VFWtDoRQ9kSoIJGs
        VP4Y/Fpyg531TCyp4vVIQiDQ41C6kFWSO7lS1xq+iLwW5Ak=
X-Google-Smtp-Source: ABdhPJwnrrf9uBO5MotE8u6KmeZ28WHW2pwMTzwMt2WZ4vnEpO9yPKFNNbwhuJT6LO5qCwQqdpRDbqFZM9OPMkSY7dc=
X-Received: by 2002:a25:585:: with SMTP id 127mr17217817ybf.425.1605033096297;
 Tue, 10 Nov 2020 10:31:36 -0800 (PST)
MIME-Version: 1.0
References: <20201110011932.3201430-1-andrii@kernel.org> <20201110011932.3201430-2-andrii@kernel.org>
 <695E976D-DECA-4BE1-BFB0-771878B9CFCD@fb.com>
In-Reply-To: <695E976D-DECA-4BE1-BFB0-771878B9CFCD@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Nov 2020 10:31:25 -0800
Message-ID: <CAEf4BzYORuxNUvJDTe4cPvJ18HNhFDOuYGfLdUzuwHeddVLw6Q@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/5] bpf: add in-kernel split BTF support
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 9:50 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Adjust in-kernel BTF implementation to support a split BTF mode of operation.
> > Changes are mostly mirroring libbpf split BTF changes, with the exception of
> > start_id being 0 for in-kernel implementation due to simpler read-only mode.
> >
> > Otherwise, for split BTF logic, most of the logic of jumping to base BTF,
> > where necessary, is encapsulated in few helper functions. Type numbering and
> > string offset in a split BTF are logically continuing where base BTF ends, so
> > most of the high-level logic is kept without changes.
> >
> > Type verification and size resolution is only doing an added resolution of new
> > split BTF types and relies on already cached size and type resolution results
> > in the base BTF.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> > kernel/bpf/btf.c | 171 +++++++++++++++++++++++++++++++++--------------
> > 1 file changed, 119 insertions(+), 52 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 6324de8c59f7..727c1c27053f 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -203,12 +203,17 @@ struct btf {
> >       const char *strings;
> >       void *nohdr_data;
> >       struct btf_header hdr;
> > -     u32 nr_types;
> > +     u32 nr_types; /* includes VOID for base BTF */
> >       u32 types_size;
> >       u32 data_size;
> >       refcount_t refcnt;
> >       u32 id;
> >       struct rcu_head rcu;
> > +
> > +     /* split BTF support */
> > +     struct btf *base_btf;
> > +     u32 start_id; /* first type ID in this BTF (0 for base BTF) */
> > +     u32 start_str_off; /* first string offset (0 for base BTF) */
> > };
> >
> > enum verifier_phase {
> > @@ -449,14 +454,27 @@ static bool btf_type_is_datasec(const struct btf_type *t)
> >       return BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC;
> > }
> >
> > +static u32 btf_nr_types_total(const struct btf *btf)
> > +{
> > +     u32 total = 0;
> > +
> > +     while (btf) {
> > +             total += btf->nr_types;
> > +             btf = btf->base_btf;
> > +     }
> > +
> > +     return total;
> > +}
> > +
> > s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind)
> > {
> >       const struct btf_type *t;
> >       const char *tname;
> > -     u32 i;
> > +     u32 i, total;
> >
> > -     for (i = 1; i <= btf->nr_types; i++) {
> > -             t = btf->types[i];
> > +     total = btf_nr_types_total(btf);
> > +     for (i = 1; i < total; i++) {
> > +             t = btf_type_by_id(btf, i);
> >               if (BTF_INFO_KIND(t->info) != kind)
> >                       continue;
> >
> > @@ -599,8 +617,14 @@ static const struct btf_kind_operations *btf_type_ops(const struct btf_type *t)
> >
> > static bool btf_name_offset_valid(const struct btf *btf, u32 offset)
> > {
> > -     return BTF_STR_OFFSET_VALID(offset) &&
> > -             offset < btf->hdr.str_len;
> > +     if (!BTF_STR_OFFSET_VALID(offset))
> > +             return false;
> > +
> > +     while (offset < btf->start_str_off)
> > +             btf = btf->base_btf;
>
> Do we need "if (!btf) return false;" in the while loop? (and some other loops below)

No, because for base btf start_str_off and start_type_id are always
zero, so loop condition is always false.

>
> [...]
>
