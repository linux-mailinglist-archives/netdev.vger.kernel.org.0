Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD5B4B3223
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354468AbiBLAmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:42:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354465AbiBLAmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:42:51 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E848FD7F;
        Fri, 11 Feb 2022 16:42:49 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id h11so8108621ilq.9;
        Fri, 11 Feb 2022 16:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s2VxEqUnvkGiw2JNtu+nCEP/KEtYq+YZvqjFW/cM1WI=;
        b=g5FwwdPuT6kjLO9DtxjTzYJldBHa5dDWGnNMSqYGau9EB7e6Le0Gas9bfqJfeFTa1v
         xNaziQYp5oUNyBqGl2VR3m94hIGsny51T6yN2Vtdv6Eu1CJQOWDcQTVzJkTG/R4n5979
         MKcA9cZpxm7TtHzzbYuDpS++35XBBf7AaNNZLKEAqXELuFepSununIcAjWo5w4MlYPYC
         9idTOmdmAX8xuaTf93IqvUQrYtzlGQq4QvbMVLpco3q5hyXNMOMU5T3ZwNZppkFXAc0s
         Quc/n88fTDprb6FOtbad4oae93GaU6yvsN07bOffZ1zx8jEtG8wLQHMKhLmkZHCcXjA4
         8HbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s2VxEqUnvkGiw2JNtu+nCEP/KEtYq+YZvqjFW/cM1WI=;
        b=n668meGCwrAbvmVjJqgvM8SaRwLJLp5C69j4TpwyIhVG20Xrzf3xf+LXgd0Jdt2T4p
         7Eez+YRXseWvtaVam3O4T/wasq5mYSIBI6hZLxUxfphRlMwcUn0zWdIo16m8iOSvrudS
         jXfnwob0nBopxeYZLg07wwphPE6XZj5z9NzIf7tF7oswd1v/E6xqoPxv9O6+WkWM68xu
         xZ44WtquVM27bUgWpSJ9m4WfVXHytCoVNKwUBLDADFRiCQhjY33nEMApB5vX/3GRllnA
         x8iNzWkk8QTZZbqAZ5kWxs2/jq2Frgt5xQ0thDEcnM7IaCv7ddhvAk7/T0m/KTG8/r2H
         Q3Zg==
X-Gm-Message-State: AOAM531wDzZPC+ZMlms7GiX2KPBw122vWbb61D9qpHC3ia8rsR1SdveZ
        4u8TRVFSbu/9WZbFXhJGeAGPE4lT+GwwTD5Rxuk=
X-Google-Smtp-Source: ABdhPJxW1LQhtWkMjVPjqncn9Wy8e+a+gleU8I/O2T2uVQbEd8ZeqTeQtxwTQJHMUrkbZ4JPeamRLZ71AGyXVKpE8wA=
X-Received: by 2002:a05:6e02:1a6c:: with SMTP id w12mr2185116ilv.305.1644626569382;
 Fri, 11 Feb 2022 16:42:49 -0800 (PST)
MIME-Version: 1.0
References: <20220209222646.348365-1-mauricio@kinvolk.io> <20220209222646.348365-6-mauricio@kinvolk.io>
In-Reply-To: <20220209222646.348365-6-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Feb 2022 16:42:38 -0800
Message-ID: <CAEf4BzZDU5wvjsYa8QoCCbvjHtnn--VN2c=uOxq0y0Qx0i1DUw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 5/7] bpftool: Implement btfgen_get_btf()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 2:27 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io> =
wrote:
>
> The last part of the BTFGen algorithm is to create a new BTF object with
> all the types that were recorded in the previous steps.
>
> This function performs two different steps:
> 1. Add the types to the new BTF object by using btf__add_type(). Some
> special logic around struct and unions is implemented to only add the
> members that are really used in the field-based relocations. The type
> ID on the new and old BTF objects is stored on a map.
> 2. Fix all the type IDs on the new BTF object by using the IDs saved in
> the previous step.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 136 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 135 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index c3e34db2ec8a..1efc7f3c64b2 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1481,10 +1481,144 @@ static int btfgen_record_obj(struct btfgen_info =
*info, const char *obj_path)
>         return err;
>  }
>
> +static unsigned int btfgen_get_id(struct hashmap *ids, unsigned int old)
> +{
> +       uintptr_t new;
> +
> +       if (!hashmap__find(ids, uint_as_hash_key(old), (void **)&new))
> +               /* return id for BTF_KIND_VOID as it's possible that the
> +                * ID we're looking for is the type of a pointer that
> +                * we're not adding.
> +                */
> +               return 0;
> +
> +       return (unsigned int)(uintptr_t)new;
> +}
> +
> +static int btfgen_add_id(struct hashmap *ids, unsigned int old, unsigned=
 int new)
> +{
> +       return hashmap__add(ids, uint_as_hash_key(old), uint_as_hash_key(=
new));
> +}
> +
> +static int btfgen_remap_id(__u32 *type_id, void *ctx)
> +{
> +       struct hashmap *ids =3D ctx;
> +
> +       *type_id =3D btfgen_get_id(ids, *type_id);
> +
> +       return 0;
> +}
> +
>  /* Generate BTF from relocation information previously recorded */
>  static struct btf *btfgen_get_btf(struct btfgen_info *info)
>  {
> -       return ERR_PTR(-EOPNOTSUPP);
> +       struct btf *btf_new =3D NULL;
> +       struct hashmap *ids =3D NULL;
> +       unsigned int i;
> +       int err =3D 0;
> +
> +       btf_new =3D btf__new_empty();
> +       if (!btf_new) {
> +               err =3D -errno;
> +               goto err_out;
> +       }
> +
> +       ids =3D hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
> +       if (IS_ERR(ids)) {
> +               err =3D PTR_ERR(ids);
> +               goto err_out;
> +       }
> +
> +       /* first pass: add all marked types to btf_new and add their new =
ids to the ids map */
> +       for (i =3D 1; i < btf__type_cnt(info->marked_btf); i++) {

small nit: why keep calling btf__type_cnt() on each iteration? store
it as n =3D btf__type_cnt(...) and do i < n ?

> +               const struct btf_type *cloned_type, *btf_type;
> +               int new_id;
> +
> +               cloned_type =3D btf__type_by_id(info->marked_btf, i);
> +
> +               if (cloned_type->name_off !=3D MARKED)
> +                       continue;

see, if you did

#define MARKED (1<<31)

and did

t->name_off |=3D MARKED

everywhere, then you wouldn't need src_btf anymore, as you'd just
restore original name_off right here with t->name_off &=3D ~MARKED.

But it's fine, just wanted to point out why I wanted to use one bit,
so that original values are still available.

> +
> +               btf_type =3D btf__type_by_id(info->src_btf, i);
> +
> +               /* add members for struct and union */
> +               if (btf_is_struct(btf_type) || btf_is_union(btf_type)) {

btf_is_composite(btf_type)

> +                       struct btf_type *btf_type_cpy;
> +                       int nmembers =3D 0, idx_dst, idx_src;
> +                       size_t new_size;
> +
> +                       /* calculate nmembers */
> +                       for (idx_src =3D 0; idx_src < btf_vlen(cloned_typ=
e); idx_src++) {
> +                               struct btf_member *cloned_m =3D btf_membe=
rs(cloned_type) + idx_src;

a bit nicer pattern is:


struct btf_member *m =3D btf_members(cloned_type);
int vlen =3D btf_vlen(cloned_type)

for (i =3D 0; i < vlen; i++, m++) {
}

That way you don't have to re-calculate member

> +
> +                               if (cloned_m->name_off =3D=3D MARKED)
> +                                       nmembers++;
> +                       }
> +
> +                       new_size =3D sizeof(struct btf_type) + nmembers *=
 sizeof(struct btf_member);
> +
> +                       btf_type_cpy =3D malloc(new_size);
> +                       if (!btf_type_cpy)
> +                               goto err_out;
> +
> +                       /* copy btf type */
> +                       *btf_type_cpy =3D *btf_type;
> +
> +                       idx_dst =3D 0;
> +                       for (idx_src =3D 0; idx_src < btf_vlen(cloned_typ=
e); idx_src++) {
> +                               struct btf_member *btf_member_src, *btf_m=
ember_dst;
> +                               struct btf_member *cloned_m =3D btf_membe=
rs(cloned_type) + idx_src;
> +
> +                               /* copy only members that are marked as u=
sed */
> +                               if (cloned_m->name_off !=3D MARKED)
> +                                       continue;
> +
> +                               btf_member_src =3D btf_members(btf_type) =
+ idx_src;
> +                               btf_member_dst =3D btf_members(btf_type_c=
py) + idx_dst;
> +
> +                               *btf_member_dst =3D *btf_member_src;
> +
> +                               idx_dst++;
> +                       }
> +
> +                       /* set new vlen */
> +                       btf_type_cpy->info =3D btf_type_info(btf_kind(btf=
_type_cpy), nmembers,
> +                                                          btf_kflag(btf_=
type_cpy));
> +
> +                       err =3D btf__add_type(btf_new, info->src_btf, btf=
_type_cpy);
> +                       free(btf_type_cpy);

hmm.. this malloc and the rest still feels clunky... why not do it
explicitly with btf__add_struct()/btf__add_union() and then
btf__add_field() for each marked field? You also won't need to
pre-calculate the number of members (libbpf will adjust number of
members automatically, it's pretty nice API, try it).

You can also use err =3D err ?: btf__add_xxx() pattern to minimize error
handling conditionals



> +               } else {
> +                       err =3D btf__add_type(btf_new, info->src_btf, btf=
_type);
> +               }
> +
> +               if (err < 0)
> +                       goto err_out;
> +
> +               new_id =3D err;
> +
> +               /* add ID mapping */
> +               err =3D btfgen_add_id(ids, i, new_id);

Why using clunky hashmap API if we are talking about mapping
sequential integers? Just allocate an array of btf__type_cnt()
integers and use that as a straightforward map?


> +               if (err)
> +                       goto err_out;
> +       }
> +
> +       /* second pass: fix up type ids */
> +       for (i =3D 1; i < btf__type_cnt(btf_new); i++) {
> +               struct btf_type *btf_type =3D (struct btf_type *) btf__ty=
pe_by_id(btf_new, i);
> +
> +               err =3D btf_type_visit_type_ids(btf_type, btfgen_remap_id=
, ids);
> +               if (err)
> +                       goto err_out;
> +       }
> +
> +       hashmap__free(ids);
> +       return btf_new;
> +
> +err_out:
> +       btf__free(btf_new);
> +       hashmap__free(ids);
> +       errno =3D -err;
> +       return NULL;
>  }
>
>  /* Create minimized BTF file for a set of BPF objects.
> --
> 2.25.1
>
