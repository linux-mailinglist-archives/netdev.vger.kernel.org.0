Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0393AA67F
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhFPWLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhFPWLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 18:11:32 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF55C061574;
        Wed, 16 Jun 2021 15:09:25 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id w14so3701829ilv.1;
        Wed, 16 Jun 2021 15:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5/uulY+IC9y/uppUJeDJbwharAtVC5jH912gWs8zQxw=;
        b=bGK6H1tTvy+ZrX0Hzgz0yj2RIBFXGxE4yYQTSgGGvckiaHwk6quzgeh93F28aJAJaG
         FDqp/1CJhs5ailpQx2lOo098Mus1DXKP+7yNyNZymp7kaqZ++Y5mlhndFx2BsHT8psMM
         dtRyPOVEluSxUM8SXnoOl+ST6FoD/b/SzOnoeutnVpBMQKeYcehkfspr1v8DTy068xeY
         9UyTHJBWbwj3H5wra+/hw+N11s4ueKyZloobx8NCMc3K1+kic49NImDMSnT3HCLjwJT6
         0xdKw9BLmXf/b63qZCPAsNdDTyTLkMElM84w+cMfzz0i5Rbz70okC2NtHmJ3Vvlfj7NQ
         VDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5/uulY+IC9y/uppUJeDJbwharAtVC5jH912gWs8zQxw=;
        b=g2aljZoXPqVLpNa5SclllvTXC/w03yqcNyDgc7pAzWu2SblFFIPgQxBs28qBGL6inX
         b5Dm1askcoWShOZI784BLBWbbkxtAqLTBIHudwR51lpo2FO0k6WNe8X0PuvY5jbFkAhn
         9UwsIJELdSH0gXTqghxTd+E9kDlC6K3ewPb1hCEuUIs8IxDIvaZ5C9VFBlHmfsrZ5zN/
         JmMiZj0o1IpxcAXxrZVBqDIoHIbdYwhmgsiP+vgHDPQYD3zkrIsI3KpyySPv1PlInr8Q
         Fz6rKVbLz5o8txlio3zkXApSCegw8VVrQRab5MOVhrQuYBocwv8d2p/2yYpZHipbAsBr
         gqcg==
X-Gm-Message-State: AOAM530eqBSte9DD7GTP13lQsuwEP053zVbJ9UvWSh9kBmmvupNLrCDM
        li8LHJq4J3Ky1Rm8uVZPiv7ozc+qy/JJcRhKhhs=
X-Google-Smtp-Source: ABdhPJyXLP3ZcAZLp+FazkKFugzsOYEGHhBvGCIGfGmcAQClUFJBhc7NS7GTdEvU9fbq6ew9KsBEZSirq78fL94PMek=
X-Received: by 2002:a92:b0c:: with SMTP id b12mr1132896ilf.123.1623881364533;
 Wed, 16 Jun 2021 15:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
 <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com> <YMopCb5CqOYsl6HR@krava>
In-Reply-To: <YMopCb5CqOYsl6HR@krava>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Wed, 16 Jun 2021 15:09:13 -0700
Message-ID: <CAPGftE-CqfycuyTRpFvHwe5kR5gG8WGyLSgdLTat5XnxmqQ3GQ@mail.gmail.com>
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Frank Eigler <fche@redhat.com>, Mark Wielaard <mjw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Jun 2021 at 09:38, Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Jun 16, 2021 at 08:56:42AM -0700, Yonghong Song wrote:
> >
> > On 6/16/21 2:25 AM, Tony Ambardar wrote:
> > > While patching the .BTF_ids section in vmlinux, resolve_btfids writes type
> > > ids using host-native endianness, and relies on libelf for any required
> > > translation when finally updating vmlinux. However, the default type of the
> > > .BTF_ids section content is ELF_T_BYTE (i.e. unsigned char), and undergoes
> > > no translation. This results in incorrect patched values if cross-compiling
> > > to non-native endianness, and can manifest as kernel Oops and test failures
> > > which are difficult to debug.
>
> nice catch, great libelf can do that ;-)

Funny, I'd actually assumed that was your intention, but I just
couldn't find where the
data type was being set, so resorted to this "kludge". While there's a .BTF_ids
section definition in include/linux/btf_ids.h, there's no means I can
see to specify
the data type either (i.e. in the gcc asm .pushsection() options). That approach
would be cleaner.

>
> > >
> > > Explicitly set the type of patched data to ELF_T_WORD, allowing libelf to
> > > transparently handle the endian conversions.
> > >
> > > Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
> > > Cc: stable@vger.kernel.org # v5.10+
> > > Cc: Jiri Olsa <jolsa@kernel.org>
> > > Cc: Yonghong Song <yhs@fb.com>
> > > Link: https://lore.kernel.org/bpf/CAPGftE_eY-Zdi3wBcgDfkz_iOr1KF10n=9mJHm1_a_PykcsoeA@mail.gmail.com/
> > > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> > > ---
> > >   tools/bpf/resolve_btfids/main.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > >
> > > diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> > > index d636643ddd35..f32c059fbfb4 100644
> > > --- a/tools/bpf/resolve_btfids/main.c
> > > +++ b/tools/bpf/resolve_btfids/main.c
> > > @@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
> > >     if (sets_patch(obj))
> > >             return -1;
> > > +   /* Set type to ensure endian translation occurs. */
> > > +   obj->efile.idlist->d_type = ELF_T_WORD;
> >
> > The change makes sense to me as .BTF_ids contains just a list of
> > u32's.
> >
> > Jiri, could you double check on this?
>
> the comment in ELF_T_WORD declaration suggests the size depends on
> elf's class?
>
>   ELF_T_WORD,                   /* Elf32_Word, Elf64_Word, ... */
>
> data in .BTF_ids section are allways u32
>

I believe the Elf32/Elf64 refer to the arch since some data structures vary
between the two, but ELF_T_WORD is common to both, and valid as the
data type of Elf_Data struct holding the .BTF_ids contents. See elf(5):

    Basic types
    The following types are used for  N-bit  architectures  (N=32,64,  ElfN
    stands for Elf32 or Elf64, uintN_t stands for uint32_t or uint64_t):
...
        ElfN_Word       uint32_t

Also see the code and comments in "elf.h":
    /* Types for signed and unsigned 32-bit quantities.  */
    typedef uint32_t Elf32_Word;
    typedef uint32_t Elf64_Word;

> I have no idea how is this handled in libelf (perhaps it's ok),
> but just that comment above suggests it could be also 64 bits,
> cc-ing Frank and Mark for more insight
>

One other area I'd like to confirm is with section compression. Is it safe
to ignore this for .BTF_ids? I've done so because include/linux/btf_ids.h
appears to define the section with SHF_ALLOC flag set, which is
incompatible with compression based on "libelf.h" comments.

Thanks for reviewing,
Tony

> thanks,
> jirka
>
> >
> > > +
> > >     elf_flagdata(obj->efile.idlist, ELF_C_SET, ELF_F_DIRTY);
> > >     err = elf_update(obj->efile.elf, ELF_C_WRITE);
> > >
> >
>
