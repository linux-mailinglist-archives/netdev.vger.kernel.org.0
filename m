Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EACB485432
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388411AbfHGUAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:00:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39832 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387969AbfHGUAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:00:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9so89611271qtu.6;
        Wed, 07 Aug 2019 13:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ilf2CXFpRkBxK2pVf2kR8nhHAUPLR31x7WWxYjDGYI4=;
        b=WXsj0fvXVODTllzBGJgPC7k+Vb7nmb6ipu728oMWap3dA789C0sQb6AxIN6QdGPfv8
         JyD2bSPZ+E2LRYwmpZEyo1H+nga2zLPcS4itxHGr8JVfnMLd9QLp2v/Aa7ZvC+QBJehL
         A6AnXpLyQahxxMdxPCiUMUn6Z3dRhgxvqL7aHYF2Q5+CrTo/XANE31YhS9Em2ZrP4VOF
         anfjuhFZRFvPpIThfsh+HFfk9/vIU9cDum5cl/BSPWnDzFUfaBBwqK3dE0tlBzdGGHLC
         24q7UHm03cRsrWBhlmC+CZ0tgOpSzUx+DaHORCOKr32exM8bF8zbjR6+jrQHdgpc2eoN
         H3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ilf2CXFpRkBxK2pVf2kR8nhHAUPLR31x7WWxYjDGYI4=;
        b=Nd1EDZEubFO47zhGKzfw8olBP+0h9McbuOpfGcqlI06OxmmZpzq6tY3G6P4qmgXkBu
         z+EW2qUpll52+VzSdl3Zvh9HIhrpAso8FD2X4nU06um8o+QozajmQ4sLnl3USQgtgxX2
         /L37sofPpZfvhVRF10BOEWEP60Ui4RAbqQyKN4uU0vpgIS/VMGbaJj6FG1dJt6Py/59A
         QQcCJ1cF1eR7eqGJkXgHPvO8/JRFcEAYi5ESKBMKX6i6+Dg44FrnsF40vkB0IyAsxHe2
         cR4lze8/Jg4M1DaLYbXoNAVQml0P9RtHFK4nmuUtcifoROD0FD7Ie2o9fSLEgO7rNWPK
         KDWg==
X-Gm-Message-State: APjAAAU3VjqH0bzdkOOA2kSyvAjnoAvQoLaodzUy1M+uGgoAgs8CHqJy
        n7WWdbIywbPbeh7i5ClDRkYBMYLXw408aikeOI4=
X-Google-Smtp-Source: APXvYqwbpTRj9TAlnrPasASVw3rz31G3SMRx1ICA5kicufxYwwp5iZFiNxXze2pV9ocFu0nEP40ehc47ui35qto1aKI=
X-Received: by 2002:a0c:c107:: with SMTP id f7mr9797254qvh.150.1565208004620;
 Wed, 07 Aug 2019 13:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190807053806.1534571-1-andriin@fb.com> <20190807053806.1534571-3-andriin@fb.com>
 <20190807193011.g2zuaapc2uvvr4h6@ast-mbp>
In-Reply-To: <20190807193011.g2zuaapc2uvvr4h6@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Aug 2019 12:59:53 -0700
Message-ID: <CAEf4BzahxLWRVNcNWpba7_7CbbQgN8k0RU8Ya1XCK8j4rPQ0NQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 02/14] libbpf: convert libbpf code to use new
 btf helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 12:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 06, 2019 at 10:37:54PM -0700, Andrii Nakryiko wrote:
> > Simplify code by relying on newly added BTF helper functions.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ..
> >
> > -     for (i = 0, vsi = (struct btf_var_secinfo *)(t + 1);
> > -          i < vars; i++, vsi++) {
> > +     for (i = 0, vsi = (void *)btf_var_secinfos(t); i < vars; i++, vsi++) {
>
> > +                     struct btf_member *m = (void *)btf_members(t);
> ...
> >               case BTF_KIND_ENUM: {
> > -                     struct btf_enum *m = (struct btf_enum *)(t + 1);
> > -                     __u16 vlen = BTF_INFO_VLEN(t->info);
> > +                     struct btf_enum *m = (void *)btf_enum(t);
> > +                     __u16 vlen = btf_vlen(t);
> ...
> >               case BTF_KIND_FUNC_PROTO: {
> > -                     struct btf_param *m = (struct btf_param *)(t + 1);
> > -                     __u16 vlen = BTF_INFO_VLEN(t->info);
> > +                     struct btf_param *m = (void *)btf_params(t);
> > +                     __u16 vlen = btf_vlen(t);
>
> So all of these 'void *' type hacks are only to drop const-ness ?

Yes.

> May be the helpers shouldn't be taking const then?
>

Probably not, because then we'll have much wider-spread problem of
casting const pointers into non-const when passing btf_type into
helpers.
I think const as a default is the right choice, because normally BTF
is immutable and btf__type_by_id is returning const pointer, etc.
That's typical and expected use-case. btf_dedup and BTF sanitization +
datasec size setting pieces are an exception that have to modify BTF
types in place before passing it to user.

So realistically I think we can just leave it as (void *), or I can do
explicit non-const type casts, or we can just not use helpers for
mutable cases. Do you have a preference?
