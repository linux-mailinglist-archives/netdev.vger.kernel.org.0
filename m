Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4869F63B1AB
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiK1Sxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiK1Sxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:53:50 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE02B1D676
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:53:49 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id cn2-20020a056830658200b0066c74617e3dso7585741otb.2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOXrMjEVKIxZNa+pLydBF32oQSzpQAdTCEg3fN16wT8=;
        b=PckAFB5PFpXQUDESVABVKy3zs2Id9PAFlVBXsAjtcpsq1psBaKG1tC9MHJ5pxkAsGD
         YiqJAs0NLPYvOIkzhuo0xmkgE7lUCXDgsnjZzOU/cqz50IFuMaIH0jRsfVnD1nwhReXQ
         cQRGzlowpK/GjcWoIVlwR6sYynuLVA4ODxsOBV+6ZcNZLhpkTicuO9pQYE1sOL3tpUh4
         +KgtnfLQ9UqK3zvrhR5MO+s6/hZt0AZ8GyUIm+KpV7jTale3AKLpRh+vJXJKKY4bj0A7
         qAY3Jc529kiTPZ045l/DjLkA+M5IbBTe3ZT786UxMewTBLef0tcCO00geRZVcTaU+b08
         dEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOXrMjEVKIxZNa+pLydBF32oQSzpQAdTCEg3fN16wT8=;
        b=nslGtEDBphmIzxXrSgx/Obd4d9O21ddUdtG0O1bWTcmp9FL4/PB8m7vwtCoYgFnN7z
         NGJ3gLsfCFV8kyjT3Hi5XPweoSG/dq7BDz9NSxqqf7t8T4iFkOQzo22FUGMjaJCBcoN9
         IANdkGSsdkgXXf7y8dMsKyIMLkJMYJgX97YFpNceqrwg21TJ2O5UkCEybukLFZlZo2MO
         ErKt0aK+jNm8ZcF2qyIeRAKek/+/SEfPGkjyU9i/jMTPHXprtJDQ9rBBiSxqJOYrwcfY
         Fx3QIM1JXL8nTO6eDgZapbp2wRiH89WNLDPqLtt43zfht7tfLXgeUyq6xFUu8KuPo/Y7
         /+3g==
X-Gm-Message-State: ANoB5pmF+3T2xi/9aZajp9GGxH3sCNMTJx1S2DBvnycbdkEQ+6lrlZqG
        cLjLkD/PiAuFtPz1znu9WyjS0Sy+YTLuR4LlUj82tw==
X-Google-Smtp-Source: AA0mqf6gVf52njEkd3Vl5baB3313MSFTcJkMjZ869zEwckaWM2otoMMph/0bgnJ3qK+z/YsxbGKh9kmf4qa1jCtBsAc=
X-Received: by 2002:a05:6830:18d3:b0:66c:dd29:813d with SMTP id
 v19-20020a05683018d300b0066cdd29813dmr17968578ote.312.1669661628835; Mon, 28
 Nov 2022 10:53:48 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-3-sdf@google.com>
 <87mt8e2a69.fsf@toke.dk>
In-Reply-To: <87mt8e2a69.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 28 Nov 2022 10:53:38 -0800
Message-ID: <CAKH8qBvmgx0Lr7efP0ucdZMEzZM-jzDKcAW9YPBqADWVsHb9cA@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next v2 2/8] bpf: XDP metadata RX kfuncs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 s

On Fri, Nov 25, 2022 at 9:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > There is an ndo handler per kfunc, the verifier replaces a call to the
> > generic kfunc with a call to the per-device one.
> >
> > For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> > implements all possible metatada kfuncs. Not all devices have to
> > implement them. If kfunc is not supported by the target device,
> > the default implementation is called instead.
>
> BTW, this "the default implementation is called instead" bit is not
> included in this version... :)

fixup_xdp_kfunc_call should return 0 when the device doesn't have a
kfunc defined and should fallback to the default kfunc implementation,
right?
Or am I missing something?

> [...]
>
> > +#ifdef CONFIG_DEBUG_INFO_BTF
> > +BTF_SET8_START(xdp_metadata_kfunc_ids)
> > +#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, 0)
> > +XDP_METADATA_KFUNC_xxx
> > +#undef XDP_METADATA_KFUNC
> > +BTF_SET8_END(xdp_metadata_kfunc_ids)
> > +
> > +static const struct btf_kfunc_id_set xdp_metadata_kfunc_set =3D {
> > +     .owner =3D THIS_MODULE,
> > +     .set   =3D &xdp_metadata_kfunc_ids,
> > +};
> > +
> > +u32 xdp_metadata_kfunc_id(int id)
> > +{
> > +     return xdp_metadata_kfunc_ids.pairs[id].id;
> > +}
> > +EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);
>
> So I was getting some really weird values when testing (always getting a
> timestamp value of '1'), and it turns out to be because this way of
> looking up the ID doesn't work: The set is always sorted by the BTF ID,
> not the order it was defined. Which meant that the mapping code got the
> functions mixed up, and would call a different one instead (so the
> timestamp value I was getting was really the return value of
> rx_hash_enabled()).
>
> I fixed it by building a secondary lookup table as below; feel free to
> incorporate that (or if you can come up with a better way, go ahead!).

Interesting, will take a closer look. I took this pattern from
BTF_SOCK_TYPE_xxx, which means that 'sorting by btf-id' is something
BTF_SET8_START specific...
But if it's sorted, probably easier to do a bsearch over this table
than to build another one?

> -Toke
>
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index e43f7d4ef4cf..dc0a9644dacc 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -738,6 +738,15 @@ XDP_METADATA_KFUNC_xxx
>  #undef XDP_METADATA_KFUNC
>  BTF_SET8_END(xdp_metadata_kfunc_ids)
>
> +static struct xdp_metadata_kfunc_map {
> +       const char *fname;
> +       u32 btf_id;
> +} xdp_metadata_kfunc_lookup_map[MAX_XDP_METADATA_KFUNC] =3D {
> +#define XDP_METADATA_KFUNC(name, str) { .fname =3D __stringify(str) },
> +XDP_METADATA_KFUNC_xxx
> +#undef XDP_METADATA_KFUNC
> +};
> +
>  static const struct btf_kfunc_id_set xdp_metadata_kfunc_set =3D {
>         .owner =3D THIS_MODULE,
>         .set   =3D &xdp_metadata_kfunc_ids,
> @@ -745,13 +754,41 @@ static const struct btf_kfunc_id_set xdp_metadata_k=
func_set =3D {
>
>  u32 xdp_metadata_kfunc_id(int id)
>  {
> -       return xdp_metadata_kfunc_ids.pairs[id].id;
> +       return xdp_metadata_kfunc_lookup_map[id].btf_id;
>  }
>  EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);
>
>  static int __init xdp_metadata_init(void)
>  {
> -       return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata=
_kfunc_set);
> +       const struct btf *btf;
> +       int i, j, ret;
> +
> +       ret =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadat=
a_kfunc_set);
> +       if (ret)
> +               return ret;
> +
> +       btf =3D bpf_get_btf_vmlinux();
> +
> +       for (i =3D 0; i < MAX_XDP_METADATA_KFUNC; i++) {
> +               u32 btf_id =3D xdp_metadata_kfunc_ids.pairs[i].id;
> +               const struct btf_type *t;
> +               const char *name;
> +
> +               t =3D btf_type_by_id(btf, btf_id);
> +               if (WARN_ON_ONCE(!t || !t->name_off))
> +                       continue;
> +
> +               name =3D btf_name_by_offset(btf, t->name_off);
> +
> +               for (j =3D 0; j < MAX_XDP_METADATA_KFUNC; j++) {
> +                       if (!strcmp(name, xdp_metadata_kfunc_lookup_map[j=
].fname)) {
> +                               xdp_metadata_kfunc_lookup_map[j].btf_id =
=3D btf_id;
> +                               break;
> +                       }
> +               }
> +       }
> +
> +       return 0;
>  }
>  late_initcall(xdp_metadata_init);
>  #else /* CONFIG_DEBUG_INFO_BTF */
>
