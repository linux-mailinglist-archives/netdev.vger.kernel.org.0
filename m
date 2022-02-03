Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0434A885E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352130AbiBCQKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiBCQKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:10:10 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5400C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:10:09 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id l27so2227643lfe.1
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+ZiB7aeMsHSB73dCnGjTp/BLK5NyDFO1hk6bvnniQOQ=;
        b=JVBuV29zGoJozWfnTHh8eLmEaPB2OK/uUZrGTd75Bfw5Nm21AXGNkHppuOgzpfKiyD
         n3nNBuF6gbiEYXQ23HHypVKkr+1USF/ds4H5VSzMDhov5QOtUFdl8z8MahhF/Pnau/6L
         +VXtJcV6t7G8JIdDiae9RnT5eD9fEBSQFE0uY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+ZiB7aeMsHSB73dCnGjTp/BLK5NyDFO1hk6bvnniQOQ=;
        b=UE6Rfqd2bv7du5ddLzWKrFMPoGWZhURYdjLMAEGBiP8S42t3IP/duDBzQSrwi+JGoj
         tRC/Lgor+xDM3Ce9NDPzGMYTkwVzjnqOv77+POupvuH9ki3eFxPB5EtC8p9enyURIfZt
         316j2HydmIzUYzcrartU5PMH1MxrVqIsNWVheNb+1T4iLrwC9s+kcV8wgiGH89PuL/Q/
         tZwn5Vwp/Bxww4CLUvzGf/9TqF3yZxSQRkLNM5b94GXo6bERb7CvSFBReMgfRFQwarek
         EwVVNmoBajzvdhhx3qPejpeI7k+hgigodzwc7qSAWcr880Ks0dH8L6vJFHfBozIdK+f2
         4BXg==
X-Gm-Message-State: AOAM532JE74aqrX/ybhCTnpmk5oqLlKJleBTjfo2X7GlLFdYGbe7i2KB
        OdWxjHky6WY1f3DTWKdnA/Yp/iQP0dC0Qb5YYk07OQ==
X-Google-Smtp-Source: ABdhPJyv/2SqAC0dLiLOG3QpC91AOXH+Dpwf8nQ8QJ0GnAZj1YtJP+yTFi+g/ptgqafFmQB8xdagqrwYi3weL+qRqKI=
X-Received: by 2002:a05:6512:2342:: with SMTP id p2mr27225672lfu.382.1643904608045;
 Thu, 03 Feb 2022 08:10:08 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-6-mauricio@kinvolk.io>
 <CAEf4BzbbMykZRpTms8OxvQxEwuLHoR9hVGLpZWfXx+D_s=87jA@mail.gmail.com>
In-Reply-To: <CAEf4BzbbMykZRpTms8OxvQxEwuLHoR9hVGLpZWfXx+D_s=87jA@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Thu, 3 Feb 2022 11:09:57 -0500
Message-ID: <CAHap4zuWAmBBhTpUef44z42RjQtqmhOMFjB-yBr8AuqGyYnKCw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 5/9] bpftool: Implement btfgen()
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 2:15 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > btfgen() receives the path of a source and destination BTF files and a
> > list of BPF objects. This function records the relocations for all
> > objects and then generates the BTF file by calling btfgen_get_btf()
> > (implemented in the following commits).
> >
> > btfgen_record_obj() loads the BTF and BTF.ext sections of the BPF
> > objects and loops through all CO-RE relocations. It uses
> > bpf_core_calc_relo_insn() from libbpf and passes the target spec to
> > btfgen_record_reloc() that saves the types involved in such relocation.
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/bpf/bpftool/Makefile |   8 +-
> >  tools/bpf/bpftool/gen.c    | 221 ++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 223 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > index 83369f55df61..97d447135536 100644
> > --- a/tools/bpf/bpftool/Makefile
> > +++ b/tools/bpf/bpftool/Makefile
> > @@ -34,10 +34,10 @@ LIBBPF_BOOTSTRAP_INCLUDE :=3D $(LIBBPF_BOOTSTRAP_DE=
STDIR)/include
> >  LIBBPF_BOOTSTRAP_HDRS_DIR :=3D $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
> >  LIBBPF_BOOTSTRAP :=3D $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
> >
> > -# We need to copy hashmap.h and nlattr.h which is not otherwise export=
ed by
> > -# libbpf, but still required by bpftool.
> > -LIBBPF_INTERNAL_HDRS :=3D $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nl=
attr.h)
> > -LIBBPF_BOOTSTRAP_INTERNAL_HDRS :=3D $(addprefix $(LIBBPF_BOOTSTRAP_HDR=
S_DIR)/,hashmap.h)
> > +# We need to copy hashmap.h, nlattr.h, relo_core.h and libbpf_internal=
.h
> > +# which are not otherwise exported by libbpf, but still required by bp=
ftool.
> > +LIBBPF_INTERNAL_HDRS :=3D $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nl=
attr.h relo_core.h libbpf_internal.h)
> > +LIBBPF_BOOTSTRAP_INTERNAL_HDRS :=3D $(addprefix $(LIBBPF_BOOTSTRAP_HDR=
S_DIR)/,hashmap.h relo_core.h libbpf_internal.h)
> >
> >  ifeq ($(BPFTOOL_VERSION),)
> >  BPFTOOL_VERSION :=3D $(shell make -rR --no-print-directory -sC ../../.=
. kernelversion)
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 68bb88e86b27..bb9c56401ee5 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -15,6 +15,7 @@
> >  #include <unistd.h>
> >  #include <bpf/bpf.h>
> >  #include <bpf/libbpf.h>
> > +#include <bpf/libbpf_internal.h>
> >  #include <sys/types.h>
> >  #include <sys/stat.h>
> >  #include <sys/mman.h>
> > @@ -1143,6 +1144,11 @@ static void *uint_as_hash_key(int x)
> >         return (void *)(uintptr_t)x;
> >  }
> >
> > +static void *u32_as_hash_key(__u32 x)
> > +{
> > +       return (void *)(uintptr_t)x;
> > +}
> > +
> >  static void btfgen_free_type(struct btfgen_type *type)
> >  {
> >         free(type);
> > @@ -1193,12 +1199,223 @@ btfgen_new_info(const char *targ_btf_path)
> >         return info;
> >  }
> >
> > -/* Create BTF file for a set of BPF objects */
> > -static int btfgen(const char *src_btf, const char *dst_btf, const char=
 *objspaths[])
> > +static int btfgen_record_field_relo(struct btfgen_info *info, struct b=
pf_core_spec *targ_spec)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> > +
> > +static int btfgen_record_type_relo(struct btfgen_info *info, struct bp=
f_core_spec *targ_spec)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> > +
> > +static int btfgen_record_enumval_relo(struct btfgen_info *info, struct=
 bpf_core_spec *targ_spec)
> >  {
> >         return -EOPNOTSUPP;
> >  }
> >
> > +static int btfgen_record_reloc(struct btfgen_info *info, struct bpf_co=
re_spec *res)
> > +{
> > +       switch (res->relo_kind) {
> > +       case BPF_CORE_FIELD_BYTE_OFFSET:
> > +       case BPF_CORE_FIELD_BYTE_SIZE:
> > +       case BPF_CORE_FIELD_EXISTS:
> > +       case BPF_CORE_FIELD_SIGNED:
> > +       case BPF_CORE_FIELD_LSHIFT_U64:
> > +       case BPF_CORE_FIELD_RSHIFT_U64:
> > +               return btfgen_record_field_relo(info, res);
> > +       case BPF_CORE_TYPE_ID_LOCAL:
> > +       case BPF_CORE_TYPE_ID_TARGET:
> > +       case BPF_CORE_TYPE_EXISTS:
> > +       case BPF_CORE_TYPE_SIZE:
> > +               return btfgen_record_type_relo(info, res);
> > +       case BPF_CORE_ENUMVAL_EXISTS:
> > +       case BPF_CORE_ENUMVAL_VALUE:
> > +               return btfgen_record_enumval_relo(info, res);
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +}
> > +
> > +static struct bpf_core_cand_list *
> > +btfgen_find_cands(const struct btf *local_btf, const struct btf *targ_=
btf, __u32 local_id)
> > +{
> > +       const struct btf_type *local_type;
> > +       struct bpf_core_cand_list *cands =3D NULL;
> > +       struct bpf_core_cand local_cand =3D {};
> > +       size_t local_essent_len;
> > +       const char *local_name;
> > +       int err;
> > +
> > +       local_cand.btf =3D local_btf;
> > +       local_cand.id =3D local_id;
> > +
> > +       local_type =3D btf__type_by_id(local_btf, local_id);
> > +       if (!local_type) {
> > +               err =3D -EINVAL;
> > +               goto err_out;
> > +       }
> > +
> > +       local_name =3D btf__name_by_offset(local_btf, local_type->name_=
off);
> > +       if (!local_name) {
> > +               err =3D -EINVAL;
> > +               goto err_out;
> > +       }
> > +       local_essent_len =3D bpf_core_essential_name_len(local_name);
> > +
> > +       cands =3D calloc(1, sizeof(*cands));
> > +       if (!cands)
> > +               return NULL;
> > +
> > +       err =3D bpf_core_add_cands(&local_cand, local_essent_len, targ_=
btf, "vmlinux", 1, cands);
> > +       if (err)
> > +               goto err_out;
> > +
> > +       return cands;
> > +
> > +err_out:
> > +       if (cands)
> > +               bpf_core_free_cands(cands);
>
> we can also add if (!cands) return into bpf_core_free_cands(), like
> all other public destructor APIs in libbpf do
>

Makes sense.

> > +       errno =3D -err;
> > +       return NULL;
> > +}
> > +
> > +/* Record relocation information for a single BPF object*/
> > +static int btfgen_record_obj(struct btfgen_info *info, const char *obj=
_path)
> > +{
> > +       const struct btf_ext_info_sec *sec;
> > +       const struct bpf_core_relo *relo;
> > +       const struct btf_ext_info *seg;
> > +       struct hashmap *cand_cache;
> > +       struct btf_ext *btf_ext;
> > +       unsigned int relo_idx;
> > +       struct btf *btf;
> > +       int err;
> > +
> > +       btf =3D btf__parse(obj_path, &btf_ext);
> > +       err =3D libbpf_get_error(btf);
>
> same, libbpf 1.0 mode, no need for libbpf_get_error()
>
> > +       if (err) {
> > +               p_err("failed to parse bpf object '%s': %s", obj_path, =
strerror(errno));
>
> nit: "BPF object"? I'm not sure we do this consistently, but BPF
> should be spelled with capitals in logs
>
>
>
> > +               return err;
> > +       }
> > +
> > +       if (btf_ext->core_relo_info.len =3D=3D 0)
> > +               return 0;
> > +
> > +       cand_cache =3D bpf_core_create_cand_cache();
> > +       if (IS_ERR(cand_cache))
> > +               return PTR_ERR(cand_cache);
> > +
> > +       seg =3D &btf_ext->core_relo_info;
> > +       for_each_btf_ext_sec(seg, sec) {
> > +               for_each_btf_ext_rec(seg, sec, relo_idx, relo) {
> > +                       struct bpf_core_spec specs_scratch[3] =3D {};
> > +                       struct bpf_core_relo_res targ_res =3D {};
> > +                       struct bpf_core_cand_list *cands =3D NULL;
> > +                       const void *type_key =3D u32_as_hash_key(relo->=
type_id);
> > +                       const char *sec_name =3D btf__name_by_offset(bt=
f, sec->sec_name_off);
> > +
> > +                       if (relo->kind !=3D BPF_CORE_TYPE_ID_LOCAL &&
> > +                           !hashmap__find(cand_cache, type_key, (void =
**)&cands)) {
> > +                               cands =3D btfgen_find_cands(btf, info->=
src_btf, relo->type_id);
> > +                               if (!cands) {
> > +                                       err =3D -errno;
> > +                                       goto out;
> > +                               }
> > +
> > +                               err =3D hashmap__set(cand_cache, type_k=
ey, cands, NULL, NULL);
> > +                               if (err)
> > +                                       goto out;
> > +                       }
> > +
> > +                       err =3D bpf_core_calc_relo_insn(sec_name, relo,=
 relo_idx, btf, cands,
> > +                                                     specs_scratch, &t=
arg_res);
>
> it feels like you forgot to submit some important patch, as I said, I
> can't find bpf_core_calc_relo_insn() anywhere
>

Yes, sorry about that. Will be in the next iteration.

>
> > +                       if (err)
> > +                               goto out;
> > +
> > +                       err =3D btfgen_record_reloc(info, &specs_scratc=
h[2]);
>
> at least let's leave a comment that specs_scratch[2] is target spec
> (but that's an implementation detail, ugh...)
>

Right.

>
>
> > +                       if (err)
> > +                               goto out;
> > +               }
> > +       }
> > +
> > +out:
> > +       bpf_core_free_cand_cache(cand_cache);
> > +
> > +       return err;
> > +}
> > +
> > +/* Generate BTF from relocation information previously recorded */
> > +static struct btf *btfgen_get_btf(struct btfgen_info *info)
> > +{
> > +       return ERR_PTR(-EOPNOTSUPP);
> > +}
> > +
> > +/* Create BTF file for a set of BPF objects.
> > + *
> > + * The BTFGen algorithm is divided in two main parts: (1) collect the
> > + * BTF types that are involved in relocations and (2) generate the BTF
> > + * object using the collected types.
> > + *
> > + * In order to collect the types involved in the relocations, we parse
> > + * the BTF and BTF.ext sections of the BPF objects and use
> > + * bpf_core_calc_relo_insn() to get the target specification, this
> > + * indicates how the types and fields are used in a relocation.
> > + *
> > + * Types are recorded in different ways according to the kind of the
> > + * relocation. For field-based relocations only the members that are
> > + * actually used are saved in order to reduce the size of the generate=
d
> > + * BTF file. For type-based and enum-based relocations the whole type =
is
> > + * saved.
> > + *
> > + * The second part of the algorithm generates the BTF object. It creat=
es
> > + * an empty BTF object and fills it with the types recorded in the
> > + * previous step. This function takes care of only adding the structur=
e
> > + * and union members that were marked as used and it also fixes up the
> > + * type IDs on the generated BTF object.
> > + */
> > +static int btfgen(const char *src_btf, const char *dst_btf, const char=
 *objspaths[])
>
> naming nit: btfgen is actually misleading. pahole is "btfgen", but
> this is actually some sort of "BTF minimizer". So something like
> "minimize_btf" would be a bit more descriptive
>

I agree that minimize_btf() is better. I think we can continue to use
btfgen_* for the different types.


> > +{
> > +       struct btfgen_info *info;
> > +       struct btf *btf_new =3D NULL;
> > +       int err;
> > +
> > +       info =3D btfgen_new_info(src_btf);
> > +       if (!info) {
> > +               p_err("failed to allocate info structure: %s", strerror=
(errno));
> > +               err =3D -errno;
> > +               goto out;
> > +       }
> > +
> > +       for (int i =3D 0; objspaths[i] !=3D NULL; i++) {
> > +               p_info("Processing BPF object: %s", objspaths[i]);
> > +
> > +               err =3D btfgen_record_obj(info, objspaths[i]);
> > +               if (err)
> > +                       goto out;
> > +       }
> > +
> > +       btf_new =3D btfgen_get_btf(info);
> > +       if (!btf_new) {
> > +               err =3D -errno;
> > +               p_err("error generating btf: %s", strerror(errno));
> > +               goto out;
> > +       }
> > +
> > +       p_info("Creating BTF file: %s", dst_btf);
>
> normally tools don't advertise each action through logs, unless it's
> some verbose mode. Let's dop one BTF generated per one bpftool
> invocation and drop all this descriptive logging. User will know input
> and output BTFs exactly, because they will specify it as input
> arguments (so no need to parse any output just to know what went
> where, etc).
>

> > +       err =3D btf_save_raw(btf_new, dst_btf);
> > +       if (err) {
> > +               p_err("error saving btf file: %s", strerror(errno));
> > +               goto out;
> > +       }
> > +
> > +out:
> > +       btf__free(btf_new);
> > +       btfgen_free_info(info);
> > +
> > +       return err;
> > +}
> > +
> >  static int do_min_core_btf(int argc, char **argv)
> >  {
> >         char src_btf_path[PATH_MAX], dst_btf_path[PATH_MAX];
> > --
> > 2.25.1
> >
