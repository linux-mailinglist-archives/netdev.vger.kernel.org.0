Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3222AA217
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgKGBwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgKGBwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 20:52:08 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AABC0613CF;
        Fri,  6 Nov 2020 17:52:07 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id m188so2808368ybf.2;
        Fri, 06 Nov 2020 17:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=htDTYjHxkl8pJF7YHCGD1ZPutKHgCLrJs1VPdouellw=;
        b=QZLDbSviyGyu7BFxBlQygO3Ug4vsO3xn8BJYpTidIg3bS/hLq8RkUwW/IQlmHTzul0
         QLzc3K+A5/RmTJksI3yCs6/i51OAcUMb1Nwydu5kGwOAIcfuQHooCvbIp7msi92lOIbP
         WqBoGCqpdMnpHPLPXr2YOexIyctT0YLlBZ4a8m2NWcBAKfvAR42D74TJTps0n30ht9tN
         JPmSLCTMVo8AvrYCOkTsQ6kBR5y+8GU1S/vpJgNKvqKSg6tG9WlO6SsM5IUBgF2/PeDE
         NKbIWMrL9sUSzC+MXS8v4Wo6RsCVyU7/QIKruiKeM/4amnoN5dYa2+zpLf1vsa7kZeD7
         9CdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=htDTYjHxkl8pJF7YHCGD1ZPutKHgCLrJs1VPdouellw=;
        b=RzJweUw3k0I/8qTEQZWEdqvdMD88tcTX/bGQmZurmN6Gyn2xiGonykOluPzuUlZDgI
         az/tqy/M0of7JGrc/MkEkDaiUYnmPdLHfFFbof/DqC85Di3ZCbBajWclSyIStFbkaBcT
         Xcsu/GNOAzYwkFeTLfnCs/pcTMZ5/XlWzuHJxKcvLTGLSzbo6mertoJ/6aj12/oFVkvd
         P6wLcAL7QslMbGiIxJLjJEDmaW5IQPL32hACCJmJGbcLbhqMQK9/rd2R/jgG8Ajjex1B
         qpXbNSeLWQ4lgP0D2yfUDYCuEkWvA6cL6XRvm58y65kxZGZJkUxVxTDzjvHirW/Vdf2X
         5z1w==
X-Gm-Message-State: AOAM531B4Chc3pGq2h/utDSM7STdG85B4OoZAyGEXSZpHVPHJS0USzVj
        32P7JV7cYGyoZiHiVorG0+D2JxB9XpdA8rOpDow=
X-Google-Smtp-Source: ABdhPJyEQvPNkLG9odnR7nyp6PHikU1NluOE2NO2Of7H7AKzquSk2uGkqXiOf4nhqHJ0SV6JciUb0FeLG/BUpZNecuo=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr6951356ybe.403.1604713926926;
 Fri, 06 Nov 2020 17:52:06 -0800 (PST)
MIME-Version: 1.0
References: <20201106230228.2202-1-andrii@kernel.org> <20201106230228.2202-2-andrii@kernel.org>
 <712CED9D-91E3-4CF1-AAFC-3E970582D06D@fb.com>
In-Reply-To: <712CED9D-91E3-4CF1-AAFC-3E970582D06D@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 17:51:56 -0800
Message-ID: <CAEf4BzZV2Uks_iE5v+7fvQXBvnLgmDQGwn3Bh2+4T-XODxeRJQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/5] bpf: add in-kernel split BTF support
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 5:28 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 6, 2020, at 3:02 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
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
>
> [...]
>
> >
> > @@ -600,8 +618,15 @@ static const struct btf_kind_operations *btf_type_ops(const struct btf_type *t)
> >
> > static bool btf_name_offset_valid(const struct btf *btf, u32 offset)
> > {
> > -     return BTF_STR_OFFSET_VALID(offset) &&
> > -             offset < btf->hdr.str_len;
> > +     if (!BTF_STR_OFFSET_VALID(offset))
> > +             return false;
> > +again:
> > +     if (offset < btf->start_str_off) {
> > +             btf = btf->base_btf;
> > +             goto again;
>
> Can we do a while loop instead of "goto again;"?

yep, not sure why I went with goto...

while (offset < btf->start_str_off)
    btf = btf->base_btf;

Shorter.

>
> > +     }
> > +     offset -= btf->start_str_off;
> > +     return offset < btf->hdr.str_len;
> > }
> >
> > static bool __btf_name_char_ok(char c, bool first, bool dot_ok)
> > @@ -615,10 +640,25 @@ static bool __btf_name_char_ok(char c, bool first, bool dot_ok)
> >       return true;
> > }
> >
> > +static const char *btf_str_by_offset(const struct btf *btf, u32 offset)
> > +{
> > +again:
> > +     if (offset < btf->start_str_off) {
> > +             btf = btf->base_btf;
> > +             goto again;
> > +     }
>
> Maybe add a btf_find_base_btf(btf, offset) helper for this logic?

No strong feelings about this, but given it's a two-line loop might
not be worth it. I'd also need a pretty verbose
btf_find_base_btf_for_str_offset() and
btf_find_base_btf_for_type_id(). I feel like loop might be less
distracting actually.

>
> > +
> > +     offset -= btf->start_str_off;
> > +     if (offset < btf->hdr.str_len)
> > +             return &btf->strings[offset];
> > +
> > +     return NULL;
> > +}
> > +
>
> [...]
>
> > }
> >
> > const char *btf_name_by_offset(const struct btf *btf, u32 offset)
> > {
> > -     if (offset < btf->hdr.str_len)
> > -             return &btf->strings[offset];
> > -
> > -     return NULL;
> > +     return btf_str_by_offset(btf, offset);
> > }
>
> IIUC, btf_str_by_offset() and btf_name_by_offset() are identical. Can we
> just keep btf_name_by_offset()?

btf_str_by_offset() is static, so should be inlinable, while
btf_name_by_offset() is a global function, I was worrying about
regressing performance for __btf_name_valid() and
__btf_name_by_offset(). Premature optimization you think?

>
> >
> > const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id)
> > {
> > -     if (type_id > btf->nr_types)
> > -             return NULL;
> > +again:
> > +     if (type_id < btf->start_id) {
> > +             btf = btf->base_btf;
> > +             goto again;
> > +     }
>
> ditto, goto again..
>
> [...]
>
>
