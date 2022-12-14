Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD68364D1F1
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 22:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLNVoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 16:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLNVnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 16:43:51 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05877442F4;
        Wed, 14 Dec 2022 13:43:48 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NXTQ51VMVz4xFy;
        Thu, 15 Dec 2022 08:43:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1671054222;
        bh=NlqnpfOSV2+NmSulfrNqSFmeU6Gp9w9H4diODez4Q1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rYUCNxSbbUFL8Bdsz/qcwQ8Gz8/ALmmMSOfGpOvQynvojsC07BONkJQUCY6FRdSEg
         YgW2Bz48pNPMzzs27xt6c5c3ub08KGERYe62kmiTWdqR+b+Cgxolulk5rfbY/M8BYq
         sPV+t2XINciwenZI41V4NjdubdyyhRLyGpvfB5e8egB+4/zqvpbNMDFUuFnqK5TeSR
         DTGE8jzNvtz6TuOR5m1NgvRmNyaDQc3Yt/Bp5mQZbXOgaSqnePZtYDZlo1KA7si3Lj
         pdibMnrAzN1SKE1fN8lpC5i1Run6Qq9fNsWihiLOUlnElIeq02FW8iUdbvIk5SxElR
         kpWrfwzLxKl2A==
Date:   Thu, 15 Dec 2022 08:43:40 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eduard Zingerman <eddyz87@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: linux-next: manual merge of the bpf-next tree with the perf
 tree
Message-ID: <20221215084340.01522de0@canb.auug.org.au>
In-Reply-To: <20221114121606.14436235@canb.auug.org.au>
References: <20221111104009.0edfa8a6@canb.auug.org.au>
        <20221114121606.14436235@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jRdeCr5DUIEbCVNZafec/RM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jRdeCr5DUIEbCVNZafec/RM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 14 Nov 2022 12:16:06 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Fri, 11 Nov 2022 10:40:09 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >=20
> > Today's linux-next merge of the bpf-next tree got a conflict in:
> >=20
> >   tools/perf/util/stat.c
> >=20
> > between commit:
> >=20
> >   8b76a3188b85 ("perf stat: Remove unused perf_counts.aggr field")
> >=20
> > from the perf tree and commit:
> >=20
> >   c302378bc157 ("libbpf: Hashmap interface update to allow both long an=
d void* keys/values")
> >=20
> > from the bpf-next tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >=20
> > --=20
> > Cheers,
> > Stephen Rothwell
> >=20
> > diff --cc tools/perf/util/stat.c
> > index 3a432a949d46,c0656f85bfa5..000000000000
> > --- a/tools/perf/util/stat.c
> > +++ b/tools/perf/util/stat.c
> > @@@ -318,7 -258,27 +318,7 @@@ void evlist__copy_prev_raw_counts(struc
> >   		evsel__copy_prev_raw_counts(evsel);
> >   }
> >  =20
> > - static size_t pkg_id_hash(const void *__key, void *ctx __maybe_unused)
> >  -void evlist__save_aggr_prev_raw_counts(struct evlist *evlist)
> >  -{
> >  -	struct evsel *evsel;
> >  -
> >  -	/*
> >  -	 * To collect the overall statistics for interval mode,
> >  -	 * we copy the counts from evsel->prev_raw_counts to
> >  -	 * evsel->counts. The perf_stat_process_counter creates
> >  -	 * aggr values from per cpu values, but the per cpu values
> >  -	 * are 0 for AGGR_GLOBAL. So we use a trick that saves the
> >  -	 * previous aggr value to the first member of perf_counts,
> >  -	 * then aggr calculation in process_counter_values can work
> >  -	 * correctly.
> >  -	 */
> >  -	evlist__for_each_entry(evlist, evsel) {
> >  -		*perf_counts(evsel->prev_raw_counts, 0, 0) =3D
> >  -			evsel->prev_raw_counts->aggr;
> >  -	}
> >  -}
> >  -
> > + static size_t pkg_id_hash(long __key, void *ctx __maybe_unused)
> >   {
> >   	uint64_t *key =3D (uint64_t *) __key;
> >    =20
>=20
> This is now a conflict between perf tree and the net-next tree.

This is now a conflict between the perf tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/jRdeCr5DUIEbCVNZafec/RM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOaQ4wACgkQAVBC80lX
0GyGGwgAnlmxEGYWYYPiAc3YCvFti4PWjBtd5sr1POcvdb/nlvtZFjZ2wv4MJxK7
SFnrK26w61Vtd8uuvwATz+0iUlYQ/kk3LSKy+RRQRVdZ+crkuTeKIyrYtjczFocF
5JvPqIQXCJXN7DfUPFqBCV3tB4IaV2Xe/vC39UOU9ajhzarc0dlnTDpQMDynf/dK
S4yF9eQCA9A/9dgbRALYTEGfhJXhWeTjzgLf5BEQQPr4zRd1JBaUKg/a4S+PZL4t
+VAJaNwhiyKgsEmjFEu/EQHYNVT7JiMB69NN6u8x3BY3vZWW8pFISqi2pdedpeMa
x2kuX9Bai/QIj+r0NRWR8KJKF7aTvQ==
=WNQ7
-----END PGP SIGNATURE-----

--Sig_/jRdeCr5DUIEbCVNZafec/RM--
