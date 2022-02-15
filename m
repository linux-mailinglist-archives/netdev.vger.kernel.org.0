Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64724B7AD0
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244701AbiBOW47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:56:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244694AbiBOW44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:56:56 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BB7BA75E
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:56:44 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id t14so648518ljh.8
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KgVZkUUbGUZQ31ZvNwCOIzIiGTf7WnYCysAE6/qgMwU=;
        b=jkpiSQy0pO5BRcFNR90Bqpn7JoS+4arc8FJd0S6Dam6/avw3TDN8o6vprTobszQt1Q
         /cGe7c9LVfx9qXrs1NGvIeo6YHcJHszV1ykPWhO6QR2hvIUg026GjgDOL7ip/FihwDvi
         rVOTR5gGVwJ58kA0IOlegJNi08TJr/CrqvWL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KgVZkUUbGUZQ31ZvNwCOIzIiGTf7WnYCysAE6/qgMwU=;
        b=5V80MxZmJDft7bZQh3vbNLqT2uo1wYweTHNEizRuQ5T98/df2Pb/13zl5JYpxt/wfm
         DmJqkRAaonp6DGQbY3X9ftt+i3TDSGFaYRm2fKEcFHdVfQ+xBY4Dtis+RSWKxs2Xeuig
         Mn82W3Y/tYnrwK0ffnqIPr+KKweun3Ibcn3xqoNLH4+xR7l54Oone4jg7qh4OMmRWhdq
         eN8S8WKbEfRjjAM+lbSqLylQbPRVMxWAOqqgpcbuZThesG36Jb6QExgvqfr13f0ENbJE
         Buo8A8W3A+VMzSUURTOBohS5oX9BDdJ62Wif/jTQ79Yv7+xmJbYleCjKUkB7/fSokoKa
         3D+g==
X-Gm-Message-State: AOAM533JQYXTQjqa2mNkAUYbDLqtP/iJfS5b7R0GTAmSGkSFiuutsxSH
        XSpNn8pLd2wV6MMo/ZKzdOumf0AQBsmGqITRGI2+/w==
X-Google-Smtp-Source: ABdhPJzE4wAiM8xsgQMVU9mjRRGUb9KfcCe+Pj7DgIWMdz/n7DiwZkVB1IoZTu7jvNUymg/+ylaTOdvY519yYIh5M/E=
X-Received: by 2002:a05:651c:990:b0:240:752f:a224 with SMTP id
 b16-20020a05651c099000b00240752fa224mr48937ljq.266.1644965802672; Tue, 15 Feb
 2022 14:56:42 -0800 (PST)
MIME-Version: 1.0
References: <20220209222646.348365-1-mauricio@kinvolk.io> <20220209222646.348365-6-mauricio@kinvolk.io>
 <CAEf4BzZDU5wvjsYa8QoCCbvjHtnn--VN2c=uOxq0y0Qx0i1DUw@mail.gmail.com>
In-Reply-To: <CAEf4BzZDU5wvjsYa8QoCCbvjHtnn--VN2c=uOxq0y0Qx0i1DUw@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Tue, 15 Feb 2022 17:56:31 -0500
Message-ID: <CAHap4zt52W5ifY_6wPa0-4pC+E_xizixTeZ+sMnVpRK=_N=Nbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 5/7] bpftool: Implement btfgen_get_btf()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 7:42 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Feb 9, 2022 at 2:27 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io=
> wrote:
> >
> > The last part of the BTFGen algorithm is to create a new BTF object wit=
h
> > all the types that were recorded in the previous steps.
> >
> > This function performs two different steps:
> > 1. Add the types to the new BTF object by using btf__add_type(). Some
> > special logic around struct and unions is implemented to only add the
> > members that are really used in the field-based relocations. The type
> > ID on the new and old BTF objects is stored on a map.
> > 2. Fix all the type IDs on the new BTF object by using the IDs saved in
> > the previous step.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/bpf/bpftool/gen.c | 136 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 135 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index c3e34db2ec8a..1efc7f3c64b2 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -1481,10 +1481,144 @@ static int btfgen_record_obj(struct btfgen_inf=
o *info, const char *obj_path)
> >         return err;
> >  }
> >
> > +static unsigned int btfgen_get_id(struct hashmap *ids, unsigned int ol=
d)
> > +{
> > +       uintptr_t new;
> > +
> > +       if (!hashmap__find(ids, uint_as_hash_key(old), (void **)&new))
> > +               /* return id for BTF_KIND_VOID as it's possible that th=
e
> > +                * ID we're looking for is the type of a pointer that
> > +                * we're not adding.
> > +                */
> > +               return 0;
> > +
> > +       return (unsigned int)(uintptr_t)new;
> > +}
> > +
> > +static int btfgen_add_id(struct hashmap *ids, unsigned int old, unsign=
ed int new)
> > +{
> > +       return hashmap__add(ids, uint_as_hash_key(old), uint_as_hash_ke=
y(new));
> > +}
> > +
> > +static int btfgen_remap_id(__u32 *type_id, void *ctx)
> > +{
> > +       struct hashmap *ids =3D ctx;
> > +
> > +       *type_id =3D btfgen_get_id(ids, *type_id);
> > +
> > +       return 0;
> > +}
> > +
> >  /* Generate BTF from relocation information previously recorded */
> >  static struct btf *btfgen_get_btf(struct btfgen_info *info)
> >  {
> > -       return ERR_PTR(-EOPNOTSUPP);
> > +       struct btf *btf_new =3D NULL;
> > +       struct hashmap *ids =3D NULL;
> > +       unsigned int i;
> > +       int err =3D 0;
> > +
> > +       btf_new =3D btf__new_empty();
> > +       if (!btf_new) {
> > +               err =3D -errno;
> > +               goto err_out;
> > +       }
> > +
> > +       ids =3D hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
> > +       if (IS_ERR(ids)) {
> > +               err =3D PTR_ERR(ids);
> > +               goto err_out;
> > +       }
> > +
> > +       /* first pass: add all marked types to btf_new and add their ne=
w ids to the ids map */
> > +       for (i =3D 1; i < btf__type_cnt(info->marked_btf); i++) {
>
> small nit: why keep calling btf__type_cnt() on each iteration? store
> it as n =3D btf__type_cnt(...) and do i < n ?

Fixed

>
> > +               const struct btf_type *cloned_type, *btf_type;
> > +               int new_id;
> > +
> > +               cloned_type =3D btf__type_by_id(info->marked_btf, i);
> > +
> > +               if (cloned_type->name_off !=3D MARKED)
> > +                       continue;
>
> see, if you did
>
> #define MARKED (1<<31)
>
> and did
>
> t->name_off |=3D MARKED
>
> everywhere, then you wouldn't need src_btf anymore, as you'd just
> restore original name_off right here with t->name_off &=3D ~MARKED.
>
> But it's fine, just wanted to point out why I wanted to use one bit,
> so that original values are still available.

I see, thanks for the explanation. In both cases a BTF copy to pass to
libbpf is needed, hence I'd say there's not that much difference.

>
> > +
> > +               btf_type =3D btf__type_by_id(info->src_btf, i);
> > +
> > +               /* add members for struct and union */
> > +               if (btf_is_struct(btf_type) || btf_is_union(btf_type)) =
{
>
> btf_is_composite(btf_type)
>
> > +                       struct btf_type *btf_type_cpy;
> > +                       int nmembers =3D 0, idx_dst, idx_src;
> > +                       size_t new_size;
> > +
> > +                       /* calculate nmembers */
> > +                       for (idx_src =3D 0; idx_src < btf_vlen(cloned_t=
ype); idx_src++) {
> > +                               struct btf_member *cloned_m =3D btf_mem=
bers(cloned_type) + idx_src;
>
> a bit nicer pattern is:
>
>
> struct btf_member *m =3D btf_members(cloned_type);
> int vlen =3D btf_vlen(cloned_type)
>
> for (i =3D 0; i < vlen; i++, m++) {
> }
>
> That way you don't have to re-calculate member
>

Reworked the code with the other suggestions below.

> > +
> > +                               if (cloned_m->name_off =3D=3D MARKED)
> > +                                       nmembers++;
> > +                       }
> > +
> > +                       new_size =3D sizeof(struct btf_type) + nmembers=
 * sizeof(struct btf_member);
> > +
> > +                       btf_type_cpy =3D malloc(new_size);
> > +                       if (!btf_type_cpy)
> > +                               goto err_out;
> > +
> > +                       /* copy btf type */
> > +                       *btf_type_cpy =3D *btf_type;
> > +
> > +                       idx_dst =3D 0;
> > +                       for (idx_src =3D 0; idx_src < btf_vlen(cloned_t=
ype); idx_src++) {
> > +                               struct btf_member *btf_member_src, *btf=
_member_dst;
> > +                               struct btf_member *cloned_m =3D btf_mem=
bers(cloned_type) + idx_src;
> > +
> > +                               /* copy only members that are marked as=
 used */
> > +                               if (cloned_m->name_off !=3D MARKED)
> > +                                       continue;
> > +
> > +                               btf_member_src =3D btf_members(btf_type=
) + idx_src;
> > +                               btf_member_dst =3D btf_members(btf_type=
_cpy) + idx_dst;
> > +
> > +                               *btf_member_dst =3D *btf_member_src;
> > +
> > +                               idx_dst++;
> > +                       }
> > +
> > +                       /* set new vlen */
> > +                       btf_type_cpy->info =3D btf_type_info(btf_kind(b=
tf_type_cpy), nmembers,
> > +                                                          btf_kflag(bt=
f_type_cpy));
> > +
> > +                       err =3D btf__add_type(btf_new, info->src_btf, b=
tf_type_cpy);
> > +                       free(btf_type_cpy);
>
> hmm.. this malloc and the rest still feels clunky... why not do it
> explicitly with btf__add_struct()/btf__add_union() and then
> btf__add_field() for each marked field? You also won't need to
> pre-calculate the number of members (libbpf will adjust number of
> members automatically, it's pretty nice API, try it).
>

You're right. Code looks better with this API.

> You can also use err =3D err ?: btf__add_xxx() pattern to minimize error
> handling conditionals
>

mmm, I didn't find a place where it could improve the code in this case.

>
>
> > +               } else {
> > +                       err =3D btf__add_type(btf_new, info->src_btf, b=
tf_type);
> > +               }
> > +
> > +               if (err < 0)
> > +                       goto err_out;
> > +
> > +               new_id =3D err;
> > +
> > +               /* add ID mapping */
> > +               err =3D btfgen_add_id(ids, i, new_id);
>
> Why using clunky hashmap API if we are talking about mapping
> sequential integers? Just allocate an array of btf__type_cnt()
> integers and use that as a straightforward map?
>

Makes sense. Probably a hashmap will use a bit less memory but I think
the readability improvement is worth it.


>
> > +               if (err)
> > +                       goto err_out;
> > +       }
> > +
> > +       /* second pass: fix up type ids */
> > +       for (i =3D 1; i < btf__type_cnt(btf_new); i++) {
> > +               struct btf_type *btf_type =3D (struct btf_type *) btf__=
type_by_id(btf_new, i);
> > +
> > +               err =3D btf_type_visit_type_ids(btf_type, btfgen_remap_=
id, ids);
> > +               if (err)
> > +                       goto err_out;
> > +       }
> > +
> > +       hashmap__free(ids);
> > +       return btf_new;
> > +
> > +err_out:
> > +       btf__free(btf_new);
> > +       hashmap__free(ids);
> > +       errno =3D -err;
> > +       return NULL;
> >  }
> >
> >  /* Create minimized BTF file for a set of BPF objects.
> > --
> > 2.25.1
> >
