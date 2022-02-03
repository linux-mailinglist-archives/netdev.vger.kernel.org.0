Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0EF4A8A10
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352850AbiBCRaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352863AbiBCRah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:30:37 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC1AC061714;
        Thu,  3 Feb 2022 09:30:36 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id d3so2681477ilr.10;
        Thu, 03 Feb 2022 09:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=28LvQSK5xqFFME2HQZ/Q66dEIyl5PBTGM0aHlZaybB0=;
        b=XH/lmh6xoTieh6z6C088oZVLgQBFgG8bWQoChMK6ZmQ493P2pwQT0K5fJm7E0N0d6t
         NaZyFHCpVqRW/A4kjaL5+cgVaBJKZSBWiZgDOe6Uegiy8yDS4b9Xg9/twHlE+p+7Rn9C
         uu62aVYqnVTHrOYsCyfPpP6tBvS0RlsL+WjfcpaaAz5v61dWTbEAq3RanBQvCiTHswFO
         J/GvmEHTbZXcS2Q/X0ft+XRk5eeyOPvl/UFYrSh+23QUR+8VIdCdv5WLfsxFLrZOHTcG
         veCshK4Inkmc2HxIise9L2ncf3M5vuNWiu/isVRD0QovtfTHq80T/PGWURQ7O9Nb9xnD
         OiWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=28LvQSK5xqFFME2HQZ/Q66dEIyl5PBTGM0aHlZaybB0=;
        b=451635wPHVK9G6RKQaz1yzzCelmouNXHO4Ri85wGaaoRAYn8vOMrHTerIBmAsStGAg
         LRmfVgY6CC3hK1hfEa8e352OBb0M9LKMULKbRCwAn7RvN0Vccy3eH6nO/j0L5Y3kh7Sq
         qLQasKrHxT2GFxOWNWGKfMmfjdywOZ2gU6VZDf9Dph5c2pqmsTv4+vkW/4tp7DBvYThs
         MH0HMeDaUsbiRRqFJsO89OiiVDxFtbCeCx/v/AsAkvrcQ4up36yFOb8qTJJuARNIJQVa
         eQAoPbmNosUMOJhnXqv0lWpBJz9ohIEWKZxEf0L6QzEyupYJY3eJxjyAWkxO/wc7KKUz
         h5VQ==
X-Gm-Message-State: AOAM531VydsODByI895FSzxfmh/wKhJLC0Pv85Gh5WZzeNcyNfANxHOK
        Rg4USW6GYXsSj7EvDCG5pu0bhp0r1/1afBElglA=
X-Google-Smtp-Source: ABdhPJwTQIJAMZzde62cbSi43TFT6EcBvlu1lObtkc+AMcBo8F1RTb+BuOizGAael3BjahyWD/z23mcDs70NLOUlkpM=
X-Received: by 2002:a05:6e02:2163:: with SMTP id s3mr19255551ilv.252.1643909436187;
 Thu, 03 Feb 2022 09:30:36 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-7-mauricio@kinvolk.io>
 <CAEf4BzZu-u1WXGScPZKVQZc+RGjmnYm45mcOGkzXyFLMKS-5gA@mail.gmail.com> <CAHap4zv+bLA4BB9ZJ7RXDCChe6dU0AB3zuCieWskp2OJ5Y-4xw@mail.gmail.com>
In-Reply-To: <CAHap4zv+bLA4BB9ZJ7RXDCChe6dU0AB3zuCieWskp2OJ5Y-4xw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Feb 2022 09:30:25 -0800
Message-ID: <CAEf4BzagOBmVbrPOnSwthOxt7CYoqNTuojbtmgskNa_Ad=8EVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/9] bpftool: Implement relocations recording
 for BTFGen
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 8:40 AM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Wed, Feb 2, 2022 at 2:31 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk=
.io> wrote:
> > >
> > > This commit implements the logic to record the relocation information
> > > for the different kind of relocations.
> > >
> > > btfgen_record_field_relo() uses the target specification to save all =
the
> > > types that are involved in a field-based CO-RE relocation. In this ca=
se
> > > types resolved and added recursively (using btfgen_put_type()).
> > > Only the struct and union members and their types) involved in the
> > > relocation are added to optimize the size of the generated BTF file.
> > >
> > > On the other hand, btfgen_record_type_relo() saves the types involved=
 in
> > > a type-based CO-RE relocation. In this case all the members for the
> >
> > Do I understand correctly that if someone does
> > bpf_core_type_size(struct task_struct), you'll save not just
> > task_struct, but also any type that directly and indirectly referenced
> > from any task_struct's field, even if that is through a pointer.
>
> That's correct.
>
> > As
> > in, do you substitute forward declarations for types that are never
> > directly used? If not, that's going to be very suboptimal for
> > something like task_struct and any other type that's part of a big
> > cluster of types.
> >
>
> We decided to include the whole types and all direct and indirect
> types referenced from a structure field for type-based relocations.
> Our reasoning is that we don't know if the matching algorithm of
> libbpf could be changed to require more information in the future and
> type-based relocations are few compared to field based relocations.
>

It will depend on application and which type is used in relocation.
task_struct reaches tons of types and will add a very noticeable size
to minimized BTF, for no good reason, IMO. If we discover that we do
need those types, we'll update bpftool to generate more.


> If you are confident enough that adding empty structures/unions is ok
> then I'll update the algorithm. Actually it'll make our lives easier.
>

Well, test it of course, but I think it should work.

> > > struct and union types are added. This is not strictly required since
> > > libbpf doesn't use them while performing this kind of relocation,
> > > however that logic could change on the future. Additionally, we expec=
t
> > > that the number of this kind of relocations in an BPF object to be ve=
ry
> > > low, hence the impact on the size of the generated BTF should be
> > > negligible.
> > >
> > > Finally, btfgen_record_enumval_relo() saves the whole enum type for
> > > enum-based relocations.
> > >
> > > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > > ---
> > >  tools/bpf/bpftool/gen.c | 260 ++++++++++++++++++++++++++++++++++++++=
+-
> > >  1 file changed, 257 insertions(+), 3 deletions(-)
> > >

[...]

> > > +
> > > +       btfgen_member =3D calloc(1, sizeof(*btfgen_member));
> > > +       if (!btfgen_member)
> > > +               return -ENOMEM;
> > > +       btfgen_member->member =3D btf_member;
> > > +       btfgen_member->idx =3D idx;
> > > +       /* add btf_member as member to given btfgen_type */
> > > +       err =3D hashmap__add(btfgen_type->members, uint_as_hash_key(b=
tfgen_member->idx),
> > > +                          btfgen_member);
> > > +       if (err) {
> > > +               free(btfgen_member);
> > > +               if (err !=3D -EEXIST)
> >
> > why not check that such a member exists before doing btfgen_member allo=
cation?
> >
>
> I thought that it could be more efficient calling hashmap__add()
> directly without checking and then handling the case when it was
> already there. Having a second thought it seems to me that it's not
> always true and depends on how many times the code follows each path,
> what we don't know. I'll change it to check if it's there before.
>

See my other reply on this patch. Maybe you won't need a hashmap at
all if you modify btf_type in place (As in, set extra bit to mark that
type or its member is needed)? It feels a bit hacky, but this is an
internal and one specific case inside bpftool, so I think it's
justified (and it will be much cleaner and shorter code, IMO).

> > > +                       return err;
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +

[...]
