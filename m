Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3FE4A784D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346782AbiBBSzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346773AbiBBSzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:55:03 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502D1C061714;
        Wed,  2 Feb 2022 10:55:03 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id e8so125004ilm.13;
        Wed, 02 Feb 2022 10:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W01OgxZnPfZz+4Y5af6MYzZeKKIi8p82/VCebOeHRjQ=;
        b=KwR0h6OgSXxUxQqiXVze1WP84kXYZhh5IbXB2tQgQFswZ6ex/L7odmTdqk37Jyxm3k
         8NREIYWoHEzGNmm2VrrlVl0y8E7exYyTkg/KxI34w1VLXLyMvGHdd43aQfCuKBgL8bDh
         24oX8QrpD01DIMyrgb3Lbcma2ab8t5zLsyFp0SWjszhN1P3dI96OrMYnwhSXsod2MRWz
         kLwnh6cRYLEv1Q8f9LSW+gCXzJ2oqqLcM7dadNmb7CLc2Ml9/jRh/uk72TWG4uuZuZ7T
         tVb2vNB9VrDTO4TWhntDsGFhAr9Vcxw+XltNbQ3avi7vObvfcomIGQPB2LE4F6MWzRXz
         nv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W01OgxZnPfZz+4Y5af6MYzZeKKIi8p82/VCebOeHRjQ=;
        b=tzmFqS8rJl0Hh9C+3J106+Phu/9uAZWAM3knscJXcoCZvHzmqU+KCAN6uGHFTWuzH2
         vYOfBNDG/tnULrOuBtirzINE5fwG+jEPaU2boRuk9cwQbRM/yE6tvP2U+Vev9M+uIkwK
         v4BJmC49em4eKu9WgbQIIN1m8ankqAY4tKESGdrvxE+04zLRq9Jkx2KFfj4pImhjyINc
         Tvopes6YThO+mr0EOZM57wR6Duzn/J1y6l3+ninBskZYTM/odXBZVgUopMV8qg7zQK4N
         +HV87ucURjKk8XIAKaxglh5578D2CP60uveK2OD1lwz2PUUYYl+7PEh5b/cSR6lWgmhB
         T1wQ==
X-Gm-Message-State: AOAM530SXBrNwIoZFbh1yD4tjEL/GPGa6cXKGxT1XfbA7xjPHGIuKKUG
        OMbj3OTNL75Ko2NbRbBIkFns04MviRmWizpUx/4=
X-Google-Smtp-Source: ABdhPJzhSIrPv6TTilWIqqDzFPmi+K664ZZ1dFKSFyiIHbdUnqJb8CciSxIvSCsmKQy+F2IhnOQKBtK+wzsoM3wvSrM=
X-Received: by 2002:a05:6e02:2163:: with SMTP id s3mr17363744ilv.252.1643828102720;
 Wed, 02 Feb 2022 10:55:02 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-5-mauricio@kinvolk.io>
In-Reply-To: <20220128223312.1253169-5-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 10:54:51 -0800
Message-ID: <CAEf4BzaCJMUZ5ZVNgbVnCE0nmEETBo1iAp75nKp+mh2uKfJ9HQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/9] bpftool: Add struct definitions and
 helpers for BTFGen
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> Add some structs and helpers that will be used by BTFGen in the next
> commits.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---

Similar considerations with unused static functions. It's also harder
to review when I don't see how these types are actually used, so
probably better to put it in relevant patches that are using this?

>  tools/bpf/bpftool/gen.c | 75 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
>
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 64371f466fa6..68bb88e86b27 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1118,6 +1118,81 @@ static int btf_save_raw(const struct btf *btf, con=
st char *path)
>         return err;
>  }
>
> +struct btfgen_type {
> +       struct btf_type *type;
> +       unsigned int id;
> +};
> +
> +struct btfgen_info {
> +       struct hashmap *types;
> +       struct btf *src_btf;
> +};
> +
> +static size_t btfgen_hash_fn(const void *key, void *ctx)
> +{
> +       return (size_t)key;
> +}
> +
> +static bool btfgen_equal_fn(const void *k1, const void *k2, void *ctx)
> +{
> +       return k1 =3D=3D k2;
> +}
> +
> +static void *uint_as_hash_key(int x)
> +{
> +       return (void *)(uintptr_t)x;
> +}
> +
> +static void btfgen_free_type(struct btfgen_type *type)
> +{
> +       free(type);
> +}
> +
> +static void btfgen_free_info(struct btfgen_info *info)
> +{
> +       struct hashmap_entry *entry;
> +       size_t bkt;
> +
> +       if (!info)
> +               return;
> +
> +       if (!IS_ERR_OR_NULL(info->types)) {
> +               hashmap__for_each_entry(info->types, entry, bkt) {
> +                       btfgen_free_type(entry->value);
> +               }
> +               hashmap__free(info->types);
> +       }
> +
> +       btf__free(info->src_btf);
> +
> +       free(info);
> +}
> +
> +static struct btfgen_info *
> +btfgen_new_info(const char *targ_btf_path)
> +{
> +       struct btfgen_info *info;
> +
> +       info =3D calloc(1, sizeof(*info));
> +       if (!info)
> +               return NULL;
> +
> +       info->src_btf =3D btf__parse(targ_btf_path, NULL);
> +       if (libbpf_get_error(info->src_btf)) {

bpftool is using libbpf 1.0 mode, so don't use libbpf_get_error()
anymore, just check for NULL

also, if you are using errno for propagating error, you need to store
it locally before btfgen_free_info() call, otherwise it can be
clobbered

> +               btfgen_free_info(info);
> +               return NULL;
> +       }
> +
> +       info->types =3D hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NUL=
L);
> +       if (IS_ERR(info->types)) {
> +               errno =3D -PTR_ERR(info->types);
> +               btfgen_free_info(info);
> +               return NULL;
> +       }
> +
> +       return info;
> +}
> +
>  /* Create BTF file for a set of BPF objects */
>  static int btfgen(const char *src_btf, const char *dst_btf, const char *=
objspaths[])
>  {
> --
> 2.25.1
>
