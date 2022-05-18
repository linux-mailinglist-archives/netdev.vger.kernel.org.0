Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642B252C47F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242616AbiERUjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242611AbiERUi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:38:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4694624AC72
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652906336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c2UEH33t7qis5XHqHrLUTP+pJbHyhdaTPLohO6Lqklg=;
        b=FXTSR2pUZl3EZ5ff1uWPfuVNXVo400XaMDEsZCTZvCvHwelWPc7+d2NskQJamPJ5bcnAKw
        Bhqetv1GaGBTpNHCa16gYrFevIw8+J8UXTrd5GDyydUCAt8w4OiXVydhZFmqRKAIvHRflv
        nQSo0KaJnPHzhZkFC6E7szQgV8TXPc0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-I7ugPBrnPeSzkjGazQ2XBw-1; Wed, 18 May 2022 16:38:54 -0400
X-MC-Unique: I7ugPBrnPeSzkjGazQ2XBw-1
Received: by mail-wm1-f69.google.com with SMTP id 205-20020a1c02d6000000b003928cd3853aso3407523wmc.9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c2UEH33t7qis5XHqHrLUTP+pJbHyhdaTPLohO6Lqklg=;
        b=k1xi1pJot5Jte/cgH8sy4GMqZfuhNVbSh3bQlhw0WKevTbMj/X56getUJ+zjv3bl3j
         CYVKEJrurIDyzlED0v5HvjNsHTUuJYSYzEPmnjX9s/+HBPh6AYqL3NZCE+qTE8wFizrD
         us+O4Gpp4vj9QmDg9ULfi57PcWTf2tYaroFFZHaC8lvbm9FlWceUiKbIkh+yxitvlgT0
         TN5M1muIFL6pEY1cDci4QJS+t6z8+g+A4vIuOre/2TSyTIOIwfvKh26CUuTWniZW8dXt
         I1yDKsuvI0M7ZmJLeDg4i+3E/mJfW7oqPyxNJxc82uxQJTB1df66YFVYbXPypcINdAAY
         YnaA==
X-Gm-Message-State: AOAM532jLGCslBOw62A09rnWos60iDoq9cw9eLGGo0c42wnoNuJRvAWF
        eb0xmHSt83w1IqET630TjVC4/Wp0vCFJc32Hnz402mX8yk0zrmLwaaRc0G5eChSNXcRwoEYH/E1
        XtKnSy7qVA5zZqhmL
X-Received: by 2002:a5d:64a2:0:b0:20e:6404:b32d with SMTP id m2-20020a5d64a2000000b0020e6404b32dmr1231635wrp.202.1652906333469;
        Wed, 18 May 2022 13:38:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHUsIVsXgeke7g/X6ny5YZAZzlvBKCutw59SPkFd0GIbsjUnpcNO9dWIWvjU9lpta4pvb5Bg==
X-Received: by 2002:a5d:64a2:0:b0:20e:6404:b32d with SMTP id m2-20020a5d64a2000000b0020e6404b32dmr1231609wrp.202.1652906333214;
        Wed, 18 May 2022 13:38:53 -0700 (PDT)
Received: from localhost (net-93-71-56-156.cust.vodafonedsl.it. [93.71.56.156])
        by smtp.gmail.com with ESMTPSA id w10-20020a7bc10a000000b003971176b011sm2569931wmi.0.2022.05.18.13.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:38:52 -0700 (PDT)
Date:   Wed, 18 May 2022 22:38:50 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org, brouer@redhat.com,
        toke@redhat.com, memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: add selftest for
 bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc
Message-ID: <YoVZWsiwcX3yoLAD@lore-desk>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <e95abdd9c6fa1fa97f3ca60e8eb06799784e671a.1652870182.git.lorenzo@kernel.org>
 <1e426140-d374-5bfc-89f8-37df9ead26ba@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c1u5qttNp6zG7j4p"
Content-Disposition: inline
In-Reply-To: <1e426140-d374-5bfc-89f8-37df9ead26ba@fb.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c1u5qttNp6zG7j4p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 5/18/22 3:43 AM, Lorenzo Bianconi wrote:
> > Introduce selftests for the following kfunc helpers:
> > - bpf_xdp_ct_add
> > - bpf_skb_ct_add
> > - bpf_ct_refresh_timeout
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   .../testing/selftests/bpf/prog_tests/bpf_nf.c |  4 ++
> >   .../testing/selftests/bpf/progs/test_bpf_nf.c | 72 +++++++++++++++----
> >   2 files changed, 64 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_nf.c
> > index dd30b1e3a67c..be6c5650892f 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > @@ -39,6 +39,10 @@ void test_bpf_nf_ct(int mode)
> >   	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for=
 bad but valid netns_id");
> >   	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for f=
ailed lookup");
> >   	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSU=
PPORT for invalid len__tuple");
> > +	ASSERT_EQ(skel->bss->test_add_entry, 0, "Test for adding new entry");
> > +	ASSERT_EQ(skel->bss->test_succ_lookup, 0, "Test for successful lookup=
");
>=20
> The default value for test_add_entry/test_succ_lookup are 0. So even if t=
he
> program didn't execute, the above still succeeds. So testing with
> a non-default value (0) might be a better choice.

ack, I will fix it in v4.

>=20
> > +	ASSERT_TRUE(skel->bss->test_delta_timeout > 9 && skel->bss->test_delt=
a_timeout <=3D 10,
> > +		    "Test for ct timeout update");
>=20
> ASSERT_TRUE(skel->bss->test_delta_timeout =3D=3D 10, ...)? Could you add =
some
> comments on why the value should be 10. It is not obvious by
> inspecting the code.

I added some tolerance to avoid races with jiffies update in test_bpf_nf.c

>=20
> >   end:
> >   	test_bpf_nf__destroy(skel);
> >   }
> > diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/te=
sting/selftests/bpf/progs/test_bpf_nf.c
> > index f00a9731930e..361430dde3f7 100644
> > --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> > +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> > @@ -1,6 +1,7 @@
> >   // SPDX-License-Identifier: GPL-2.0
> >   #include <vmlinux.h>
> >   #include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_endian.h>
> >   #define EAFNOSUPPORT 97
> >   #define EPROTO 71
> > @@ -8,6 +9,8 @@
> >   #define EINVAL 22
> >   #define ENOENT 2
> > +extern unsigned long CONFIG_HZ __kconfig;
> > +
> >   int test_einval_bpf_tuple =3D 0;
> >   int test_einval_reserved =3D 0;
> >   int test_einval_netns_id =3D 0;
> > @@ -16,6 +19,9 @@ int test_eproto_l4proto =3D 0;
> >   int test_enonet_netns_id =3D 0;
> >   int test_enoent_lookup =3D 0;
> >   int test_eafnosupport =3D 0;
> > +int test_add_entry =3D 0;
> > +int test_succ_lookup =3D 0;
> > +u32 test_delta_timeout =3D 0;
> >   struct nf_conn;
> > @@ -26,31 +32,40 @@ struct bpf_ct_opts___local {
> >   	u8 reserved[3];
> >   } __attribute__((preserve_access_index));
> > +struct nf_conn *bpf_xdp_ct_add(struct xdp_md *, struct bpf_sock_tuple =
*, u32,
> > +			       struct bpf_ct_opts___local *, u32) __ksym;
> >   struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tu=
ple *, u32,
> >   				  struct bpf_ct_opts___local *, u32) __ksym;
> > +struct nf_conn *bpf_skb_ct_add(struct __sk_buff *, struct bpf_sock_tup=
le *, u32,
> > +			       struct bpf_ct_opts___local *, u32) __ksym;
> >   struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock=
_tuple *, u32,
> >   				  struct bpf_ct_opts___local *, u32) __ksym;
> >   void bpf_ct_release(struct nf_conn *) __ksym;
> > +void bpf_ct_refresh_timeout(struct nf_conn *, u32) __ksym;
> >   static __always_inline void
> > -nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u3=
2,
> > -				   struct bpf_ct_opts___local *, u32),
> > +nf_ct_test(struct nf_conn *(*look_fn)(void *, struct bpf_sock_tuple *,=
 u32,
> > +				      struct bpf_ct_opts___local *, u32),
> > +	   struct nf_conn *(*add_fn)(void *, struct bpf_sock_tuple *, u32,
> > +				     struct bpf_ct_opts___local *, u32),
> >   	   void *ctx)
> >   {
> >   	struct bpf_ct_opts___local opts_def =3D { .l4proto =3D IPPROTO_TCP, =
=2Enetns_id =3D -1 };
> >   	struct bpf_sock_tuple bpf_tuple;
> >   	struct nf_conn *ct;
> > +	int err;
> >   	__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));
> > -	ct =3D func(ctx, NULL, 0, &opts_def, sizeof(opts_def));
> > +	ct =3D look_fn(ctx, NULL, 0, &opts_def, sizeof(opts_def));
> >   	if (ct)
> >   		bpf_ct_release(ct);
> >   	else
> >   		test_einval_bpf_tuple =3D opts_def.error;
> >   	opts_def.reserved[0] =3D 1;
> > -	ct =3D func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeo=
f(opts_def));
> > +	ct =3D look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> > +		     sizeof(opts_def));
> >   	opts_def.reserved[0] =3D 0;
> >   	opts_def.l4proto =3D IPPROTO_TCP;
> >   	if (ct)
> > @@ -59,21 +74,24 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct b=
pf_sock_tuple *, u32,
> >   		test_einval_reserved =3D opts_def.error;
> >   	opts_def.netns_id =3D -2;
> > -	ct =3D func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeo=
f(opts_def));
> > +	ct =3D look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> > +		     sizeof(opts_def));
> >   	opts_def.netns_id =3D -1;
> >   	if (ct)
> >   		bpf_ct_release(ct);
> >   	else
> >   		test_einval_netns_id =3D opts_def.error;
> > -	ct =3D func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeo=
f(opts_def) - 1);
> > +	ct =3D look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> > +		     sizeof(opts_def) - 1);
> >   	if (ct)
> >   		bpf_ct_release(ct);
> >   	else
> >   		test_einval_len_opts =3D opts_def.error;
> >   	opts_def.l4proto =3D IPPROTO_ICMP;
> > -	ct =3D func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeo=
f(opts_def));
> > +	ct =3D look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> > +		     sizeof(opts_def));
> >   	opts_def.l4proto =3D IPPROTO_TCP;
> >   	if (ct)
> >   		bpf_ct_release(ct);
> > @@ -81,37 +99,67 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct b=
pf_sock_tuple *, u32,
> >   		test_eproto_l4proto =3D opts_def.error;
> >   	opts_def.netns_id =3D 0xf00f;
> > -	ct =3D func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeo=
f(opts_def));
> > +	ct =3D look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> > +		     sizeof(opts_def));
> >   	opts_def.netns_id =3D -1;
> >   	if (ct)
> >   		bpf_ct_release(ct);
> >   	else
> >   		test_enonet_netns_id =3D opts_def.error;
> > -	ct =3D func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeo=
f(opts_def));
> > +	ct =3D look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> > +		     sizeof(opts_def));
> >   	if (ct)
> >   		bpf_ct_release(ct);
> >   	else
> >   		test_enoent_lookup =3D opts_def.error;
> > -	ct =3D func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def, s=
izeof(opts_def));
> > +	ct =3D look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def,
> > +		     sizeof(opts_def));
> >   	if (ct)
> >   		bpf_ct_release(ct);
> >   	else
> >   		test_eafnosupport =3D opts_def.error;
> > +
> > +	bpf_tuple.ipv4.saddr =3D bpf_get_prandom_u32(); /* src IP */
> > +	bpf_tuple.ipv4.daddr =3D bpf_get_prandom_u32(); /* dst IP */
> > +	bpf_tuple.ipv4.sport =3D bpf_htons(bpf_get_prandom_u32()); /* src por=
t */
> > +	bpf_tuple.ipv4.dport =3D bpf_htons(bpf_get_prandom_u32()); /* dst por=
t */
>=20
> Since it is already random number, bpf_htons is not needed here.
> bpf_endian.h can also be removed.

ack, I will fix it in v4.

Regards,
Lorenzo

>=20
> > +
> > +	ct =3D add_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> > +		    sizeof(opts_def));
> > +	if (ct) {
> > +		struct nf_conn *ct_lk;
> > +
> > +		ct_lk =3D look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4),
> > +				&opts_def, sizeof(opts_def));
> > +		if (ct_lk) {
> > +			/* update ct entry timeout */
> > +			bpf_ct_refresh_timeout(ct_lk, 10000);
> > +			test_delta_timeout =3D ct_lk->timeout - bpf_jiffies64();
> > +			test_delta_timeout /=3D CONFIG_HZ;
> > +			bpf_ct_release(ct_lk);
> > +		} else {
> > +			test_succ_lookup =3D opts_def.error;
> > +		}
> > +		bpf_ct_release(ct);
> > +	} else {
> > +		test_add_entry =3D opts_def.error;
> > +		test_succ_lookup =3D opts_def.error;
> > +	}
> >   }
> [...]
>=20

--c1u5qttNp6zG7j4p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoVZWgAKCRA6cBh0uS2t
rDhFAP0V9L+fb6LgkOX/R+Sa7+0SMZHAduxtMlSA/HMSxR6pNQD/Xa9ygwNi0aS/
CQtFYYhxP0Km1YWISooyRo+LyNHPygY=
=RwIO
-----END PGP SIGNATURE-----

--c1u5qttNp6zG7j4p--

