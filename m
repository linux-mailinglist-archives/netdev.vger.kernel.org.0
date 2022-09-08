Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0285B15E7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 09:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiIHHqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 03:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiIHHqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 03:46:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98040C6FE5;
        Thu,  8 Sep 2022 00:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34D7E61B97;
        Thu,  8 Sep 2022 07:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C2CC433D6;
        Thu,  8 Sep 2022 07:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662623161;
        bh=1qbcCEX+sQ8g0mZD9IjQGLMCvIx1Q+qXHBZvuLbiDvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X568Iaf00v9P6o7xOh7dG11HYFakaGf+cDqRvAJ0/esfarUgbFcE49iJeUCKvlpgD
         Nt8ClCmVkcnVxgSnW4ZAb56CVPEGBJ9QwLKjLhe/bjVHQCPRg7Bd3GvXhPinslHFL0
         QMmo+6Gni7zxjWkuv0wSNA0podZOBmZPRSnrneTNAub71uwE19xpx7H3Fkdk7mfo+y
         iHR82Ro4qJ7dUYE8Rtng1t97hagS/q5QBIHIYIebtf5vu6XUKNL0VRPLNonAuZU1ky
         y/03HScSP9lBjTSQy93Wborklg7UnDsJ/pb0g0VXMVChzLjISpyvdiXmZStjThcK8i
         8CEDvmV592CFw==
Date:   Thu, 8 Sep 2022 09:45:57 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix ct status check in bpf_nf
 selftests
Message-ID: <YxmdteGsAuSUT/Wc@lore-desk>
References: <f35b32f3303b7cb70a5e55f5fbe0bd3a1d38c9a6.1662548037.git.lorenzo@kernel.org>
 <CAPhsuW4Vcn4GELkKWNdb+X4L+KfdtOiHqN0VijhWy+vLjvD74g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FpTC8qmoeK9pm397"
Content-Disposition: inline
In-Reply-To: <CAPhsuW4Vcn4GELkKWNdb+X4L+KfdtOiHqN0VijhWy+vLjvD74g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FpTC8qmoeK9pm397
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Sep 7, 2022 at 3:56 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >
> > Check properly the connection tracking entry status configured running
> > bpf_ct_change_status kfunc.
> > Remove unnecessary IPS_CONFIRMED status configuration since it is
> > already done during entry allocation.
> >
> > Fixes: 6eb7fba007a7 ("selftests/bpf: Add tests for new nf_conntrack kfu=
ncs")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 4 ++--
> >  tools/testing/selftests/bpf/progs/test_bpf_nf.c | 8 +++++---
> >  2 files changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_nf.c
> > index 544bf90ac2a7..903d16e3abed 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> > @@ -111,8 +111,8 @@ static void test_bpf_nf_ct(int mode)
> >         /* allow some tolerance for test_delta_timeout value to avoid r=
aces. */
> >         ASSERT_GT(skel->bss->test_delta_timeout, 8, "Test for min ct ti=
meout update");
> >         ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct t=
imeout update");
> > -       /* expected status is IPS_SEEN_REPLY */
> > -       ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update=
 ");
> > +       /* expected status is IPS_CONFIRMED | IPS_SEEN_REPLY */
> > +       ASSERT_EQ(skel->bss->test_status, 0xa, "Test for ct status upda=
te ");
>=20
> Why do we use 0xa instead of IPS_CONFIRMED | IPS_SEEN_REPLY?
> To avoid dependency on the header file?

nope, thx for reporting it. I will fix it in v2.

Regards,
Lorenzo

>=20
> Thanks,
> Song

--FpTC8qmoeK9pm397
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYxmdtQAKCRA6cBh0uS2t
rPC9AP9mEeNA0FVy3StHmi5X6GQCdTh5rmO2hvLquhsD+aDT0wD/d+nClLO5HQPr
X6pTY/4E97C0IuY7XZ41E6VLMsb36gw=
=Oqzi
-----END PGP SIGNATURE-----

--FpTC8qmoeK9pm397--
