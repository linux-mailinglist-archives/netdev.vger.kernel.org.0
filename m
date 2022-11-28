Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1E563B226
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiK1TWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbiK1TWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:22:10 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29562DCD
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:22:09 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id t62so12671028oib.12
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lObuvBuVImK8GOxZ/KwRsTUs+Zp60dapoKCv+L/Yh10=;
        b=RNrYRDB7evRL3IduYhMVUhAVP7ZIfOZ+A//ZZ2mUc0DXCyrb+Nl3tL+LhQwK9Jm2+C
         ugg/FLjrRswaU3Cp0Zn3aq/bkqiRaV/5e7g7WkbJ1RKDst8pl/YMDOuwk53EGKqCfrUN
         3HdCqj3z+/uPaH79PjmavpLyf8FBtH3ebtqwx+oC8R8Iq7JG0TqrDejwwhHxp1yHZxqv
         Q4mOqeDHmnN8DaFEKNeFvNhPkXc/AM592wZ1cSjEzaeu3cwVlp6yD5devnkofvQLWcan
         l4/Z8PfAtkr0KlTFyUokqs9RWColRtQjxtfQyIdnHs1Osn64SibITsUXGd81BKypjzyf
         a4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lObuvBuVImK8GOxZ/KwRsTUs+Zp60dapoKCv+L/Yh10=;
        b=yVpNbSTKlbWYXM7lHLSz9u7CLDPJbpT2C/POyRLLitWyz3XobPP1UlCsl1gchgTn3L
         vxr88kme41ZSN6kOyw2Hwg5wIn10gm+hTSfwDgKEDVH+ZtdIsfOpNQ7ckKc+kVbkLLlu
         KOE04g9Q5OshSc7hkq2yJMXasXy/8Sy+UHtWUDw8cyOHPOn4uVu7Xeu6xdAEajuq7aJ4
         coRw0ui938OsVPjih+1e5Rqav+joUy5MIndmII8+9SdW0o1NXON/D6RjKnmoxH2jXvAu
         zdxQdt/9W5EAx2iO6C8pMERgTdV18IrECs7HvLSc3csUKJp3IptPAH2o513ThzAGyVcv
         gyHg==
X-Gm-Message-State: ANoB5pkGbNHkK9pQP0ViyptMBt07VJqYkbqjvKiAtOerHTFnGvjsu0jl
        Y8a47Re6bHopYn/V5YN/RroNYJ3HKiRw0txJ3r4VRA==
X-Google-Smtp-Source: AA0mqf7RAs1w/gvL+XiD5brsD7hgDmY33HsWo2XVDDY2JWNC3KqH6hhEMXHsqiICGjH3SSSQn1ZUrGE9+R1bGFokiUY=
X-Received: by 2002:a05:6808:a90:b0:35b:aa33:425a with SMTP id
 q16-20020a0568080a9000b0035baa33425amr4530689oij.181.1669663329076; Mon, 28
 Nov 2022 11:22:09 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-3-sdf@google.com>
 <87mt8e2a69.fsf@toke.dk> <CAKH8qBvmgx0Lr7efP0ucdZMEzZM-jzDKcAW9YPBqADWVsHb9cA@mail.gmail.com>
In-Reply-To: <CAKH8qBvmgx0Lr7efP0ucdZMEzZM-jzDKcAW9YPBqADWVsHb9cA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 28 Nov 2022 11:21:58 -0800
Message-ID: <CAKH8qBvp+4MjRpwMeG3G_duC6RCoJurswMFuC9ynf-F9-is0+g@mail.gmail.com>
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

On Mon, Nov 28, 2022 at 10:53 AM Stanislav Fomichev <sdf@google.com> wrote:
>
>  s
>
> On Fri, Nov 25, 2022 at 9:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Stanislav Fomichev <sdf@google.com> writes:
> >
> > > There is an ndo handler per kfunc, the verifier replaces a call to th=
e
> > > generic kfunc with a call to the per-device one.
> > >
> > > For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> > > implements all possible metatada kfuncs. Not all devices have to
> > > implement them. If kfunc is not supported by the target device,
> > > the default implementation is called instead.
> >
> > BTW, this "the default implementation is called instead" bit is not
> > included in this version... :)
>
> fixup_xdp_kfunc_call should return 0 when the device doesn't have a
> kfunc defined and should fallback to the default kfunc implementation,
> right?
> Or am I missing something?
>
> > [...]
> >
> > > +#ifdef CONFIG_DEBUG_INFO_BTF
> > > +BTF_SET8_START(xdp_metadata_kfunc_ids)
> > > +#define XDP_METADATA_KFUNC(name, str) BTF_ID_FLAGS(func, str, 0)
> > > +XDP_METADATA_KFUNC_xxx
> > > +#undef XDP_METADATA_KFUNC
> > > +BTF_SET8_END(xdp_metadata_kfunc_ids)
> > > +
> > > +static const struct btf_kfunc_id_set xdp_metadata_kfunc_set =3D {
> > > +     .owner =3D THIS_MODULE,
> > > +     .set   =3D &xdp_metadata_kfunc_ids,
> > > +};
> > > +
> > > +u32 xdp_metadata_kfunc_id(int id)
> > > +{
> > > +     return xdp_metadata_kfunc_ids.pairs[id].id;
> > > +}
> > > +EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);
> >
> > So I was getting some really weird values when testing (always getting =
a
> > timestamp value of '1'), and it turns out to be because this way of
> > looking up the ID doesn't work: The set is always sorted by the BTF ID,
> > not the order it was defined. Which meant that the mapping code got the
> > functions mixed up, and would call a different one instead (so the
> > timestamp value I was getting was really the return value of
> > rx_hash_enabled()).
> >
> > I fixed it by building a secondary lookup table as below; feel free to
> > incorporate that (or if you can come up with a better way, go ahead!).
>
> Interesting, will take a closer look. I took this pattern from
> BTF_SOCK_TYPE_xxx, which means that 'sorting by btf-id' is something
> BTF_SET8_START specific...
> But if it's sorted, probably easier to do a bsearch over this table
> than to build another one?

Ah, I see, there is no place to store an index :-( Maybe the following
is easier still?

diff --git a/net/core/xdp.c b/net/core/xdp.c
index e43f7d4ef4cf..8240805bfdb7 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -743,9 +743,15 @@ static const struct btf_kfunc_id_set
xdp_metadata_kfunc_set =3D {
        .set   =3D &xdp_metadata_kfunc_ids,
 };

+BTF_ID_LIST(xdp_metadata_kfunc_ids_unsorted)
+#define XDP_METADATA_KFUNC(name, str) BTF_ID(func, str)
+XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+
 u32 xdp_metadata_kfunc_id(int id)
 {
-       return xdp_metadata_kfunc_ids.pairs[id].id;
+       /* xdp_metadata_kfunc_ids is sorted and can't be used */
+       return xdp_metadata_kfunc_ids_unsorted[id];
 }
 EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);



> > -Toke
> >
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index e43f7d4ef4cf..dc0a9644dacc 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -738,6 +738,15 @@ XDP_METADATA_KFUNC_xxx
> >  #undef XDP_METADATA_KFUNC
> >  BTF_SET8_END(xdp_metadata_kfunc_ids)
> >
> > +static struct xdp_metadata_kfunc_map {
> > +       const char *fname;
> > +       u32 btf_id;
> > +} xdp_metadata_kfunc_lookup_map[MAX_XDP_METADATA_KFUNC] =3D {
> > +#define XDP_METADATA_KFUNC(name, str) { .fname =3D __stringify(str) },
> > +XDP_METADATA_KFUNC_xxx
> > +#undef XDP_METADATA_KFUNC
> > +};
> > +
> >  static const struct btf_kfunc_id_set xdp_metadata_kfunc_set =3D {
> >         .owner =3D THIS_MODULE,
> >         .set   =3D &xdp_metadata_kfunc_ids,
> > @@ -745,13 +754,41 @@ static const struct btf_kfunc_id_set xdp_metadata=
_kfunc_set =3D {
> >
> >  u32 xdp_metadata_kfunc_id(int id)
> >  {
> > -       return xdp_metadata_kfunc_ids.pairs[id].id;
> > +       return xdp_metadata_kfunc_lookup_map[id].btf_id;
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_metadata_kfunc_id);
> >
> >  static int __init xdp_metadata_init(void)
> >  {
> > -       return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metada=
ta_kfunc_set);
> > +       const struct btf *btf;
> > +       int i, j, ret;
> > +
> > +       ret =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metad=
ata_kfunc_set);
> > +       if (ret)
> > +               return ret;
> > +
> > +       btf =3D bpf_get_btf_vmlinux();
> > +
> > +       for (i =3D 0; i < MAX_XDP_METADATA_KFUNC; i++) {
> > +               u32 btf_id =3D xdp_metadata_kfunc_ids.pairs[i].id;
> > +               const struct btf_type *t;
> > +               const char *name;
> > +
> > +               t =3D btf_type_by_id(btf, btf_id);
> > +               if (WARN_ON_ONCE(!t || !t->name_off))
> > +                       continue;
> > +
> > +               name =3D btf_name_by_offset(btf, t->name_off);
> > +
> > +               for (j =3D 0; j < MAX_XDP_METADATA_KFUNC; j++) {
> > +                       if (!strcmp(name, xdp_metadata_kfunc_lookup_map=
[j].fname)) {
> > +                               xdp_metadata_kfunc_lookup_map[j].btf_id=
 =3D btf_id;
> > +                               break;
> > +                       }
> > +               }
> > +       }
> > +
> > +       return 0;
> >  }
> >  late_initcall(xdp_metadata_init);
> >  #else /* CONFIG_DEBUG_INFO_BTF */
> >
