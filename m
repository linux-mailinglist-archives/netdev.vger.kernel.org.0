Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5404A89E6
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351604AbiBCRYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352758AbiBCRYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:24:32 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543D0C06173D;
        Thu,  3 Feb 2022 09:24:32 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id c188so4114558iof.6;
        Thu, 03 Feb 2022 09:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mRCE2FCFqBrwh5iOM2we+rq9mjZfSNfsEzVYwQaowhQ=;
        b=WA6lquOKQuZZDZMT7mq2wYBHvUa01HE1M+kjJj1bATGN69dNFtLTLZM27qmdjwYkJI
         6YrrBAWPaWFuLlYspY3GASE8svz1i2mREaLMqpMSbtDMpaG5gKrjmUiaxzeSb5c3aL9/
         RqcHaH5mOYs8YrvGsgC2iXa00yBX5nuYdIts5piYDLiu1vHHqCUqxq1DZ15hqhn6vhkZ
         CUms8hREtc8mItrkH/qv1xy7WONCXM/zxN6/zEIbOhYBa0NEdoy6FOX/4GLut3T9X8TZ
         l0EJwe5X52qrMa6FfWrc0Q22bMOa71Mh74ex4PiwHqatVzYFHF53OSpqoJkf5LcEHO2f
         Ck2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mRCE2FCFqBrwh5iOM2we+rq9mjZfSNfsEzVYwQaowhQ=;
        b=rwdp8Q+kl/B3LiJ9QtWxPg2IrIpXyTqztlg/gnNy83tbMSzs4eedXZU0RABly/8JsY
         mYsh9KHdDGDWU8mMMQorGMY0wi7wSJSvn04Q0rOoPj/neveUmUEFV6QdYkT7DvJIvZ0+
         KAV4HLBInWAOAwYFVkXrnDQg+qsV7fjRbojsmkZmJHG5J5PdG44Hh77sCKESlNr81vFS
         hvxzYuLuPIAuh9GHRgXY2d/66Yz3MMG9sL+IH4OfjFndKCsb5I7Ev3YNzQG3MXBdbYEq
         kKfdJhowbTciu4JKdiS0cHj2LX3jrez1M+wS3laulm34gvB/Q6O9YPWPzp4bDY5GhJ1w
         F+gQ==
X-Gm-Message-State: AOAM532dGn6p1kUTYBlue5AKF9YIMNUK/68q3UDQE+E3AL6zBNd8maBy
        +dZDCC3ZSLGT0CBuD6ka0usOLxu7sEQlqmOmNJQ=
X-Google-Smtp-Source: ABdhPJwCXp9qtlbSr0c61DUHGwro9lPJKYe6CV/fLi/bIPnYpsWnhcHC25DmMgn40Kv5J+ut0oCCIfWhWNc/wE1XguQ=
X-Received: by 2002:a5e:8406:: with SMTP id h6mr19067121ioj.144.1643909071728;
 Thu, 03 Feb 2022 09:24:31 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-5-mauricio@kinvolk.io>
 <CAEf4BzaCJMUZ5ZVNgbVnCE0nmEETBo1iAp75nKp+mh2uKfJ9HQ@mail.gmail.com> <CAHap4zuC4EbSfX_N64Uc4m=3hi-hrQWMVuZm9jefPsjPVLNGpw@mail.gmail.com>
In-Reply-To: <CAHap4zuC4EbSfX_N64Uc4m=3hi-hrQWMVuZm9jefPsjPVLNGpw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Feb 2022 09:24:20 -0800
Message-ID: <CAEf4BzZ3mxNW_EFhRsqErhjhZNgVxfuyhw1TqZGBF2K0JWmOOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/9] bpftool: Add struct definitions and
 helpers for BTFGen
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

On Thu, Feb 3, 2022 at 8:08 AM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Wed, Feb 2, 2022 at 1:55 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jan 28, 2022 at 2:33 PM Mauricio V=C3=A1squez <mauricio@kinvolk=
.io> wrote:
> > >
> > > Add some structs and helpers that will be used by BTFGen in the next
> > > commits.
> > >
> > > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > > ---
> >
> > Similar considerations with unused static functions. It's also harder
> > to review when I don't see how these types are actually used, so
> > probably better to put it in relevant patches that are using this?
> >
>
> The next iteration splits the patches in a way that types are
> introduced in the same commit they're used.
>
> > >  tools/bpf/bpftool/gen.c | 75 +++++++++++++++++++++++++++++++++++++++=
++
> > >  1 file changed, 75 insertions(+)
> > >
> > > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > > index 64371f466fa6..68bb88e86b27 100644
> > > --- a/tools/bpf/bpftool/gen.c
> > > +++ b/tools/bpf/bpftool/gen.c
> > > @@ -1118,6 +1118,81 @@ static int btf_save_raw(const struct btf *btf,=
 const char *path)
> > >         return err;
> > >  }
> > >
> > > +struct btfgen_type {
> > > +       struct btf_type *type;
> > > +       unsigned int id;
> > > +};
> > > +
> > > +struct btfgen_info {
> > > +       struct hashmap *types;
> > > +       struct btf *src_btf;
> > > +};
> > > +
> > > +static size_t btfgen_hash_fn(const void *key, void *ctx)
> > > +{
> > > +       return (size_t)key;
> > > +}
> > > +
> > > +static bool btfgen_equal_fn(const void *k1, const void *k2, void *ct=
x)
> > > +{
> > > +       return k1 =3D=3D k2;
> > > +}
> > > +
> > > +static void *uint_as_hash_key(int x)
> > > +{
> > > +       return (void *)(uintptr_t)x;
> > > +}
> > > +
> > > +static void btfgen_free_type(struct btfgen_type *type)
> > > +{
> > > +       free(type);
> > > +}
> > > +
> > > +static void btfgen_free_info(struct btfgen_info *info)
> > > +{
> > > +       struct hashmap_entry *entry;
> > > +       size_t bkt;
> > > +
> > > +       if (!info)
> > > +               return;
> > > +
> > > +       if (!IS_ERR_OR_NULL(info->types)) {
> > > +               hashmap__for_each_entry(info->types, entry, bkt) {
> > > +                       btfgen_free_type(entry->value);
> > > +               }
> > > +               hashmap__free(info->types);
> > > +       }
> > > +
> > > +       btf__free(info->src_btf);
> > > +
> > > +       free(info);
> > > +}
> > > +
> > > +static struct btfgen_info *
> > > +btfgen_new_info(const char *targ_btf_path)
> > > +{
> > > +       struct btfgen_info *info;
> > > +
> > > +       info =3D calloc(1, sizeof(*info));
> > > +       if (!info)
> > > +               return NULL;
> > > +
> > > +       info->src_btf =3D btf__parse(targ_btf_path, NULL);
> > > +       if (libbpf_get_error(info->src_btf)) {
> >
> > bpftool is using libbpf 1.0 mode, so don't use libbpf_get_error()
> > anymore, just check for NULL
> >
>
> hmm, I got confused because libbpf_get_error() is still used in many
> places in bpftool. I suppose those need to be updated.

It's ok to use, but it's not necessary. Eventually I'd like to
deprecate libbpf_get_error() is it won't be necessary. So for new code
let's not add new uses of libbpf_get_error(). We can phase out
existing uses gradually (just like we do with CHECK() in selftests).


>
> > also, if you are using errno for propagating error, you need to store
> > it locally before btfgen_free_info() call, otherwise it can be
> > clobbered
> >
>
> Fixed.
>
>
>
> > > +               btfgen_free_info(info);
> > > +               return NULL;
> > > +       }
> > > +
> > > +       info->types =3D hashmap__new(btfgen_hash_fn, btfgen_equal_fn,=
 NULL);
> > > +       if (IS_ERR(info->types)) {
> > > +               errno =3D -PTR_ERR(info->types);
> > > +               btfgen_free_info(info);
> > > +               return NULL;
> > > +       }
> > > +
> > > +       return info;
> > > +}
> > > +
> > >  /* Create BTF file for a set of BPF objects */
> > >  static int btfgen(const char *src_btf, const char *dst_btf, const ch=
ar *objspaths[])
> > >  {
> > > --
> > > 2.25.1
> > >
