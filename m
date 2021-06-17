Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BC83AAF59
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhFQJMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:12:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231435AbhFQJMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 05:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623921008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QyqFtiU3z2ei2H0zxrEJzHtN9ZSY0dHGKYbBjpd8sPw=;
        b=ZTke1XZStikbz3G+dtvYhXaHX46pw0y/pUs41sy6ejBNN4RsQcSYu1u6a5oVFiAniCnC+0
        SaDS2APOV7z7W7qdm9hGauSSEBm3t4nB+y3Lu81E0YGcwdxjHIzNlydnbAmhVmGXJhoH7X
        usWc0kjDACFj6S0KPL2wDgAbZPDyvFc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-Q0aj4tprPqqEwRVMNeOghQ-1; Thu, 17 Jun 2021 05:10:07 -0400
X-MC-Unique: Q0aj4tprPqqEwRVMNeOghQ-1
Received: by mail-ed1-f70.google.com with SMTP id f12-20020a056402150cb029038fdcfb6ea2so1134091edw.14
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 02:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QyqFtiU3z2ei2H0zxrEJzHtN9ZSY0dHGKYbBjpd8sPw=;
        b=KLvxReaM9XOck8ZXgQPYY9Kw2uzae3aLKTNVv6RqKyyWiW7t9mfuR1G5ubJHx2EJ1d
         CZmj6f5V1sq1MB+TH+DYaYHYfoIlA8gLMQtHBDr57Ecl3yf9HKdh3aXthnhnbw5ezLSo
         yJRrOOqEfT1iLCFbVVCVQCoVKy5Wffev8FU1p5FNI4dZXxI3hM4ki74So/aRqFt+WLYk
         /gALreeqdhfh22QlFg9a+MJYeeO3jUnghLJpVQtgZXEQkUkKo0qdwp1VjCbmgje8jHFe
         +Q63PlxBmG+nQ7wuej/5Pl6f325gjeil8r8Z8bB9HQLCfij87+6wT0q7hEt7cSS1ZAl3
         KPWQ==
X-Gm-Message-State: AOAM530cLvxZk3BYdioanxr/dVtab4R0wCfoIA8B/fAQozmZDTA8iGM+
        r8YY1t4LJ829nGE2A3xWBWMxKbzvtWGj0Nb183JPxzxV4fxpdGb5iRfk3lqYqNBJLw6bddsOIik
        117DnNObEj02WQwUm
X-Received: by 2002:a05:6402:2742:: with SMTP id z2mr5186646edd.66.1623921005894;
        Thu, 17 Jun 2021 02:10:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsqPA+pMQABzOz379wdXow+Vgr6xo9CA+XItKKC/X7LlnCWm3Ubzs7V/lG6WOU0iNgZ0dxng==
X-Received: by 2002:a05:6402:2742:: with SMTP id z2mr5186618edd.66.1623921005750;
        Thu, 17 Jun 2021 02:10:05 -0700 (PDT)
Received: from krava ([83.240.60.126])
        by smtp.gmail.com with ESMTPSA id m18sm3289941ejx.56.2021.06.17.02.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 02:10:05 -0700 (PDT)
Date:   Thu, 17 Jun 2021 11:10:03 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Frank Eigler <fche@redhat.com>, Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
Message-ID: <YMsRa3nT4tlzO6DJ@krava>
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
 <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com>
 <YMopCb5CqOYsl6HR@krava>
 <CAPGftE-CqfycuyTRpFvHwe5kR5gG8WGyLSgdLTat5XnxmqQ3GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPGftE-CqfycuyTRpFvHwe5kR5gG8WGyLSgdLTat5XnxmqQ3GQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 03:09:13PM -0700, Tony Ambardar wrote:
> On Wed, 16 Jun 2021 at 09:38, Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, Jun 16, 2021 at 08:56:42AM -0700, Yonghong Song wrote:
> > >
> > > On 6/16/21 2:25 AM, Tony Ambardar wrote:
> > > > While patching the .BTF_ids section in vmlinux, resolve_btfids writes type
> > > > ids using host-native endianness, and relies on libelf for any required
> > > > translation when finally updating vmlinux. However, the default type of the
> > > > .BTF_ids section content is ELF_T_BYTE (i.e. unsigned char), and undergoes
> > > > no translation. This results in incorrect patched values if cross-compiling
> > > > to non-native endianness, and can manifest as kernel Oops and test failures
> > > > which are difficult to debug.
> >
> > nice catch, great libelf can do that ;-)
> 
> Funny, I'd actually assumed that was your intention, but I just
> couldn't find where the
> data type was being set, so resorted to this "kludge". While there's a .BTF_ids
> section definition in include/linux/btf_ids.h, there's no means I can
> see to specify
> the data type either (i.e. in the gcc asm .pushsection() options). That approach
> would be cleaner.
> 
> >
> > > >
> > > > Explicitly set the type of patched data to ELF_T_WORD, allowing libelf to
> > > > transparently handle the endian conversions.
> > > >
> > > > Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
> > > > Cc: stable@vger.kernel.org # v5.10+
> > > > Cc: Jiri Olsa <jolsa@kernel.org>
> > > > Cc: Yonghong Song <yhs@fb.com>
> > > > Link: https://lore.kernel.org/bpf/CAPGftE_eY-Zdi3wBcgDfkz_iOr1KF10n=9mJHm1_a_PykcsoeA@mail.gmail.com/
> > > > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> > > > ---
> > > >   tools/bpf/resolve_btfids/main.c | 3 +++
> > > >   1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> > > > index d636643ddd35..f32c059fbfb4 100644
> > > > --- a/tools/bpf/resolve_btfids/main.c
> > > > +++ b/tools/bpf/resolve_btfids/main.c
> > > > @@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
> > > >     if (sets_patch(obj))
> > > >             return -1;
> > > > +   /* Set type to ensure endian translation occurs. */
> > > > +   obj->efile.idlist->d_type = ELF_T_WORD;
> > >
> > > The change makes sense to me as .BTF_ids contains just a list of
> > > u32's.
> > >
> > > Jiri, could you double check on this?
> >
> > the comment in ELF_T_WORD declaration suggests the size depends on
> > elf's class?
> >
> >   ELF_T_WORD,                   /* Elf32_Word, Elf64_Word, ... */
> >
> > data in .BTF_ids section are allways u32
> >
> 
> I believe the Elf32/Elf64 refer to the arch since some data structures vary
> between the two, but ELF_T_WORD is common to both, and valid as the
> data type of Elf_Data struct holding the .BTF_ids contents. See elf(5):
> 
>     Basic types
>     The following types are used for  N-bit  architectures  (N=32,64,  ElfN
>     stands for Elf32 or Elf64, uintN_t stands for uint32_t or uint64_t):
> ...
>         ElfN_Word       uint32_t
> 
> Also see the code and comments in "elf.h":
>     /* Types for signed and unsigned 32-bit quantities.  */
>     typedef uint32_t Elf32_Word;
>     typedef uint32_t Elf64_Word;

ok

> 
> > I have no idea how is this handled in libelf (perhaps it's ok),
> > but just that comment above suggests it could be also 64 bits,
> > cc-ing Frank and Mark for more insight
> >
> 
> One other area I'd like to confirm is with section compression. Is it safe
> to ignore this for .BTF_ids? I've done so because include/linux/btf_ids.h
> appears to define the section with SHF_ALLOC flag set, which is
> incompatible with compression based on "libelf.h" comments.

not sure what you mean.. where it wouldn't be safe?
what workflow/processing

thanks,
jirka

