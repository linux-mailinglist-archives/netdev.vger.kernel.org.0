Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE42A3BAE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgKCFKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCFKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:10:20 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABD4C0617A6;
        Mon,  2 Nov 2020 21:10:18 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id h196so13780890ybg.4;
        Mon, 02 Nov 2020 21:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YY5S0KYNCfOLFnTIvP4ucZEpZyH9RAvDMVKfJXAVlGo=;
        b=S4bp0sd1zGyEmdQ1nXLxX1pBPoQqqPJogxE+uUW620154sdYD1I1RfN37bHpN7l/my
         78YiwfwHPHUsf8BiudYfTcc1Ty0BDMtjccOGIw1pnumQiyOhAV4BXelV3lp3tMPMtqk4
         ju/0j2/fsvx/2wrXjkcynv7vL5o3VfbsV5F68a6zL9UjPbl2KpdDqJmn0QwTWm1o+O2c
         Set19LhewGzQRNahG2R67FijtOq/IH4ZJ1eIbKcX08bS2KdYUd7LhgdwK+o9lbEnj/oo
         l3D/D6EgR4bub0xjGyeWQHfum4ZOxGDgpb72KgPaH4Ujd1KEu0/uL84oBuDMLEJUi7dE
         YyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YY5S0KYNCfOLFnTIvP4ucZEpZyH9RAvDMVKfJXAVlGo=;
        b=JdpKaVZu23jlYjwmyZEwLaiFAaatvWOwDB9L24PZGSDUILFYfM9EyR9I4fxdABHVan
         Ofr/+IswSe4dYiajz/W5Plmu2jECfGlyLZldcpj+KcDRPvMmI61SvFyaVMgbt9qUKDsq
         OS/tA80PADKKupdO3FyDddPyH5YFPXx0XnkT8qNQQNUpXgQuAICzGBdrQJ4l4C7E5r+4
         2TMzCL1CBA8z/C1AophVuxGma+7PU6/Ht0zriFCVbAh/ZWZqZ4FN9GnkRkAIB8MtiOjc
         zW1zOETiTghnPpomp3csdsVHuVMa97MRElCWn4oSVxyZ3oRQfVxzIL6vyabFj6r6TRhs
         PEcg==
X-Gm-Message-State: AOAM533+NMq/Q2MOVldcNQAVRdYVNp9O40JjvopvwddOthee+OlkjDeC
        s8KpcR5bcWRcLTYrXbzWKzpHiCcUDvU4UH7spvE7F/Fx06k=
X-Google-Smtp-Source: ABdhPJwTO2ZkpXJoswBO4g9T6AFCoGyA/bB2yyHrbDwx4Sc47dK+C+T/RVk1MNXRWnqPWE6eHYmdao8XAUpx5/kb/4M=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr26936152ybk.260.1604380218107;
 Mon, 02 Nov 2020 21:10:18 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-6-andrii@kernel.org>
 <62331693-EDCE-4173-86C0-D9E771DA5C22@fb.com>
In-Reply-To: <62331693-EDCE-4173-86C0-D9E771DA5C22@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 21:10:07 -0800
Message-ID: <CAEf4BzZVSQahEa6b5=7Xv3iwjavrzz3z1QHTNjruuTHS_LEb7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/11] selftests/bpf: add split BTF basic test
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 3:36 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Add selftest validating ability to programmatically generate and then dump
> > split BTF.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With a nit:
>
> [...]
> >
> > +
> > +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
> > +{
> > +     vfprintf(ctx, fmt, args);
> > +}
> > +
> > +void test_btf_split() {
> > +     struct btf_dump_opts opts;
> > +     struct btf_dump *d = NULL;
> > +     const struct btf_type *t;
> > +     struct btf *btf1, *btf2 = NULL;
>
> No need to initialize btf2 to NULL.

yep, must be a leftover from earlier version, I'll remove initialization.

>
> > +     int str_off, i, err;
> > +
> > +     btf1 = btf__new_empty();
> > +     if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
> > +             return;
> > +
> >
>
> [...]
>
