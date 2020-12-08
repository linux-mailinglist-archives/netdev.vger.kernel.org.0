Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA262D2132
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgLHC4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgLHC4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 21:56:46 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558C7C061749;
        Mon,  7 Dec 2020 18:56:06 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id a16so9795190ybh.5;
        Mon, 07 Dec 2020 18:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSje9n3VPr3wDX6ba9oiUHJZjrVWnD42SoJEnpxPaT0=;
        b=Bt9prF0BlYUsDheIq5OsA2QMPJSXzB3MZUk0qf2EmHEpJa56RJL32qsBJUvyiUgHab
         fLaRyvMhH9AZ4UKWcKWH9cXa5jcicEHG84C5H2tzfxFvD+sqn79s6jr6qT7SGjHf7IFB
         SyOAfxlJxQ49f8Z6/NS0l+DBi1ow2+lWF22YL9RC1Pmfe3I/l1U7WznLaBhWcDRlPMme
         Luc8BoUhFa2KqFUNUOapVyAkxgWlgZUM2TO+iRDtSRq9CEn+s6FM0X+AtK4kGYlXpTHO
         yN/qc79kWYrvLdOssHMxnAV7eVhtrYaey7zLKotsNgx4gChegOK3w2ZXkFIiiWwnkWy2
         eSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSje9n3VPr3wDX6ba9oiUHJZjrVWnD42SoJEnpxPaT0=;
        b=SJyD2NRiR/NbHB7grUByh8yXka49GRNkAedPrVWDeFdloOLskJKQcJZvbCOD4WpeP7
         RVVqn0YwFp5UJz2t5PIKVRuED+vP6VY+imkOE6siDkUh1fAHfe9pRmthumjsskSuCDiP
         cTeSBCDJQ6/9UmVEpEy02lIpKARJ9DTIhTcqdsPbOYVJbgQJRFldVYORod0i+ln3cCK3
         0b5iFbcxlPz1uPPpVCuuiwGcRczscZsjsWBjCNjt/zRF1VAoU0AK/G4HCCtbdk2Clbwy
         PpKYjWVzRDYLKEhYJIVJSUTedhHnqiVa//E4vwGPhhkkJ3xHbbAllzPM9jo0gTj89DTK
         UBGw==
X-Gm-Message-State: AOAM533hoDwIjnBmiuPjGHpGPXGZufdikugTy27od7TSaEmkLN0LF2g8
        qsu9i+Fa9stFoCHaINq3OWCJ9q9cII8+fMsvs7s=
X-Google-Smtp-Source: ABdhPJz5q85EwD3/aj1kdc+nqtInzbkI4flXkxwH0I396nyNgBpWZVnLpeswcdLEMaD6Tg/P1YMxz8/wnNLaWEBIHCA=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr27390825ybe.403.1607396165705;
 Mon, 07 Dec 2020 18:56:05 -0800 (PST)
MIME-Version: 1.0
References: <20201204232002.3589803-1-andrii@kernel.org> <ea2478fc-45c4-6480-bba5-a956abf54f13@fb.com>
In-Reply-To: <ea2478fc-45c4-6480-bba5-a956abf54f13@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Dec 2020 18:55:54 -0800
Message-ID: <CAEf4BzbE8ddJqj-uwJSJ19vWhgOpd-hbK34+JhdRo1PX-omY_w@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpftool: fix PID fetching with a lot of results
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 5, 2020 at 11:11 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/4/20 3:20 PM, Andrii Nakryiko wrote:
> > In case of having so many PID results that they don't fit into a singe page
> > (4096) bytes, bpftool will erroneously conclude that it got corrupted data due
> > to 4096 not being a multiple of struct pid_iter_entry, so the last entry will
> > be partially truncated. Fix this by sizing the buffer to fit exactly N entries
> > with no truncation in the middle of record.
> >
> > Fixes: d53dee3fe013 ("tools/bpftool: Show info for processes holding BPF map/prog/link/btf FDs")
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Ack with one nit below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   tools/bpf/bpftool/pids.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> > index df7d8ec76036..477e55d59c34 100644
> > --- a/tools/bpf/bpftool/pids.c
> > +++ b/tools/bpf/bpftool/pids.c
> > @@ -89,9 +89,9 @@ libbpf_print_none(__maybe_unused enum libbpf_print_level level,
> >
> >   int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
> >   {
> > -     char buf[4096];
> > -     struct pid_iter_bpf *skel;
> >       struct pid_iter_entry *e;
> > +     char buf[4096 / sizeof(*e) * sizeof(*e)];
> > +     struct pid_iter_bpf *skel;
>
> No need to move "struct pid_iter_bpf *skel", right?

It's actually a move of `struct pid_iter_entry *e;` in from of char
buf[], to be able to use sizeof(*e) instead of sizeof(struct
pid_iter_bpf). It's just that diff tool didn't catch this properly :)

>
> >       int err, ret, fd = -1, i;
> >       libbpf_print_fn_t default_print;
> >
> >
