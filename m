Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6883B201DE8
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgFSWNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729264AbgFSWNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:13:08 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C88DC06174E;
        Fri, 19 Jun 2020 15:13:08 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id q14so8385866qtr.9;
        Fri, 19 Jun 2020 15:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=in4oZ9U5BKIE1Z3z3573GOie9b5wsL/oh/8kyMjLAjA=;
        b=SbgIjYy3Y5XjBIUzEqw2lhBdY0K2pXuVcSjIysAYyFQ6NdV4uNC6eOtuY4BlClZiRb
         we1DCAIIeMbW23VPJo+Hx4ALcySXMCF7Jiht6sfSQk7uJWED8NEn87cUKIRl0QXHj6VN
         4ilA5PnrMP57u0cXtYZvrOZWgUg8Sdbn1/G5jmNZIb3tAoo2joZfTgFoDrsfPaU/Yv+H
         Jy87mOSm8X2aZc3C42iSWwjVTIJ7lBlwY9CDWk8exG6/e/PKKkqVB8vIu79HrDLLicRQ
         vR+vkTnNHsSJLkKbWybK9Yr+svH97sTO3hyHoThij9Ze8tzBqFx1bt3pdigLCKMWzp26
         35bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=in4oZ9U5BKIE1Z3z3573GOie9b5wsL/oh/8kyMjLAjA=;
        b=FI2FF8G0qr9jdfcAQP61dq52pnZwfXTyZ4FjmDNiFol2Lb1NdPCxl3jJrHUtxFluvz
         k9jz5kl6C6gbnO3CRMoko2/2dSO14P25momElgorb+DCHVjBHSN4qrO1LLqnuAtCxpir
         B/NWlWOjtxuPU5N7Eh793R0hT8O1v0l1agE7zbLmRvO3QwQD1RbmTbhZSB6JEvyMYcZf
         joQ+fXiK7vmXGNc+uUOfR2JIN4Wmi+6LZRUzztZG3/zcRwJQY/BNpSEaEKsnarU8d/qA
         VRHep/L0LRLRaadx0E3r4kCPwpW+IJnfX2iXbBHHnMeF1HEIlqNWSLCKEeucp4vNi3HR
         zlhg==
X-Gm-Message-State: AOAM533+kqkcRSiVfKTPbb7revjGMHrIbguSQ+pSeKAE8Q0fjgytaJFt
        zNjhZMYgFY7/ejfiySe5mq1c7k4/OVU0fTBCsPY=
X-Google-Smtp-Source: ABdhPJxQsxM4Et1u2C3EHPBVYfYsvtdVgNxhMG5AeSd/88hPYkiKkMQqiwQkpw+KbBbHRpnfQ3vcmWeIFFazEHOHoXI=
X-Received: by 2002:aed:34a4:: with SMTP id x33mr5357608qtd.93.1592604787468;
 Fri, 19 Jun 2020 15:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200619203026.78267-1-andriin@fb.com> <20200619203026.78267-2-andriin@fb.com>
 <CA+khW7ji5gFXh1XN71CUy08+bofu=yKfopgXV7yOuhRkoSr1=w@mail.gmail.com>
In-Reply-To: <CA+khW7ji5gFXh1XN71CUy08+bofu=yKfopgXV7yOuhRkoSr1=w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jun 2020 15:12:56 -0700
Message-ID: <CAEf4Bzazwb6kZHP_vD0yd_kgoxh9mbhV_x11c80YBuy=b6ZHpA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/9] libbpf: generalize libbpf externs support
To:     Hao Luo <haoluo@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 2:57 PM Hao Luo <haoluo@google.com> wrote:
>
> Only two small places on this version, otherwise it looks good to me.
> I can offer my reviewed-by, if need. :)
>
> Thanks for the patch!
>
> Reviewed-by: Hao Luo <haoluo@google.com>
>
> On Fri, Jun 19, 2020 at 1:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Switch existing Kconfig externs to be just one of few possible kinds of more
> > generic externs. This refactoring is in preparation for ksymbol extern
> > support, added in the follow up patch. There are no functional changes
> > intended.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> [...]
>
> > @@ -2756,23 +2796,29 @@ static int cmp_externs(const void *_a, const void *_b)
>
> [...]
>
> > +
> > +       if (a->type == EXT_KCFG) {
> > +               /* descending order by alignment requirements */
> > +               if (a->kcfg.align != b->kcfg.align)
> > +                       return a->kcfg.align > b->kcfg.align ? -1 : 1;
> > +               /* ascending order by size, within same alignment class */
> > +               if (a->kcfg.sz != b->kcfg.sz)
> > +                       return a->kcfg.sz < b->kcfg.sz ? -1 : 1;
> > +               /* resolve ties by name */
> > +       }
> > +
> >         return strcmp(a->name, b->name);
> >  }
>
> I assume the comment /* resolve ties by name */ is intended to be
> close to strcmp?

yep

>
> > @@ -2818,22 +2864,39 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> >                 ext->name = btf__name_by_offset(obj->btf, t->name_off);
> >                 ext->sym_idx = i;
> >                 ext->is_weak = GELF_ST_BIND(sym.st_info) == STB_WEAK;
> > -               ext->sz = btf__resolve_size(obj->btf, t->type);
> > -               if (ext->sz <= 0) {
> > -                       pr_warn("failed to resolve size of extern '%s': %d\n",
> > -                               ext_name, ext->sz);
> > -                       return ext->sz;
> > -               }
> > -               ext->align = btf__align_of(obj->btf, t->type);
> > -               if (ext->align <= 0) {
> > -                       pr_warn("failed to determine alignment of extern '%s': %d\n",
> > -                               ext_name, ext->align);
> > -                       return -EINVAL;
> > -               }
> > -               ext->type = find_extern_type(obj->btf, t->type,
> > -                                            &ext->is_signed);
> > -               if (ext->type == EXT_UNKNOWN) {
> > -                       pr_warn("extern '%s' type is unsupported\n", ext_name);
> > +
> > +               ext->sec_btf_id = find_extern_sec_btf_id(obj->btf, ext->btf_id);
> > +               if (ext->btf_id <= 0) {
> > +                       pr_warn("failed to find BTF for extern '%s' [%d] section: %d\n",
> > +                               ext_name, ext->btf_id, ext->sec_btf_id);
> > +                       return ext->sec_btf_id;
> > +               }
>
> Did you mean "ext->sec_btf_id <= 0" rather than "ext->btf_id <= 0"?

yep, argh...
