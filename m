Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC81144DE93
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 00:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhKKXmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 18:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhKKXmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 18:42:22 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C47C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 15:39:32 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id i6so15271911uae.6
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 15:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j4v9BoUqE5THR/POP2rwQKiOwF7muwwRuvyZdm8EX68=;
        b=r7xCDzugzkcIEDTjq0dBmc1CNg6/gxATCWmGlqsCZ8j6kpYB50T6v4XoRm1ncufWTv
         MruD5HlYdhfznkMtjBFzbMZ65vpXiG0Vdk/Gu5MKvBoEjHYFR6ufgWJR7+XIpvKzx4CU
         3L+n6CmN68YcN22fm3psS6W8j/KYuA6cki9+6UqKVwI4Ko2ntIiodmFRu981ugGPrLUM
         mF5d4Q4s5jrzTXCRCEzvoc3WQ7Bg0x62ud9mpaQpeq2x2OGydOIuwpEltvWdJ3QoWC7/
         gJcXUmZ1Rq6pWpumyBtlp/SNdmdK+LNvnv2XyOYdpuVDi/V+3ifpOsiatDRl+VnJ7pWl
         AJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j4v9BoUqE5THR/POP2rwQKiOwF7muwwRuvyZdm8EX68=;
        b=LsWSTr1OVqoPHO9OqwMTwDuwBisZD3FcXvJNJRX9NqMmYONdBb54htOBQHgYFl19wY
         hLp6d4GwggIUOv+pHDFIZEWBvBg1w5JxIJ9yYIGpbIObA/dY4u8nhd8CZckM/BO3qnuQ
         3UBMDZDCGVbE8sh3ddUgnxg8sBk2s3M8PCqGTKESID5Ir7tE1B2TDL4m0HP8EGQEyFJP
         WGkDRLRzJZvApZBBdBAe8k7zRxeXBb9AM4py5CtQKMaxQPkgUnCTxzkHvrQfU2nLP1J3
         AAZDdBidU7FK2praU1Eyt0JAef1/GJGTsmoVOs4qT9VcPgXpxP++XgvUf2dFcT1z4KKf
         9+mA==
X-Gm-Message-State: AOAM5328bdg8ZxHjhjBS/kShpkEuzna4ed6OM6JKsEesQVot183UrVVt
        Ln35XGx1JUWC0jIS6mx5gjqUj5mAbPk6ORwUdfkrJBnxAC4=
X-Google-Smtp-Source: ABdhPJw7YArV8KIKD31+kY7xNsztsjLS5qUO2+5uT6jhMhu7oJkT6TGo1uOzEdLdfz9COB9iQqI8gSJK0e8R1o42CEo=
X-Received: by 2002:a67:e896:: with SMTP id x22mr3790169vsn.0.1636673971818;
 Thu, 11 Nov 2021 15:39:31 -0800 (PST)
MIME-Version: 1.0
References: <20211110114632.24537-1-quentin@isovalent.com> <20211110114632.24537-4-quentin@isovalent.com>
 <CAEf4BzbtC8S_j7oZP9vqK+FwoSvBmt8Hp4_ZyzbwUifg8JfUUA@mail.gmail.com>
In-Reply-To: <CAEf4BzbtC8S_j7oZP9vqK+FwoSvBmt8Hp4_ZyzbwUifg8JfUUA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Thu, 11 Nov 2021 23:39:20 +0000
Message-ID: <CACdoK4JnbpU6ijcNr5n6HMj+yOb=OhEwO3DUQOgNYRvoe+EgfQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/6] bpftool: Use $(OUTPUT) and not $(O) for
 VMLINUX_BTF_PATHS in Makefile
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 at 18:59, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Nov 10, 2021 at 3:46 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > The Makefile for bpftool relies on $(OUTPUT), and not on $(O), for
> > passing the output directory. So $(VMLINUX_BTF_PATHS), used for
> > searching for kernel BTF info, should use the same variable.
> >
> > Fixes: 05aca6da3b5a ("tools/bpftool: Generalize BPF skeleton support and generate vmlinux.h")
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > ---
> >  tools/bpf/bpftool/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > index 2a846cb92120..40abf50b59d4 100644
> > --- a/tools/bpf/bpftool/Makefile
> > +++ b/tools/bpf/bpftool/Makefile
> > @@ -150,7 +150,7 @@ $(BOOTSTRAP_OBJS): $(LIBBPF_BOOTSTRAP)
> >  OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
> >  $(OBJS): $(LIBBPF) $(LIBBPF_INTERNAL_HDRS)
> >
> > -VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                           \
> > +VMLINUX_BTF_PATHS ?= $(if $(OUTPUT),$(OUTPUT)/vmlinux)                 \
> >                      $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)    \
>
> But you still check KBUILD_OUTPUT? O overrides KBUILD_OUTPUT as far as
> kernel build goes. So if you still support KBUILD_OUTPUT, you should
> support O. And the $(OUTPUT) seems to be completely unrelated, as that
> defines the output of bpftool build files, not the vmlinux image. Or
> am I missing something?

OK, I think I'm the one who missed the point. I simply figured we
meant to search the output directory, and that it should be $(OUTPUT)
like everywhere else in the Makefile. But from what I understand now,
it's not the case. Let's drop this patch.

If the rest of the set looks good to you, can you just skip this
patch, or do you prefer me to send a v2?

Quentin
