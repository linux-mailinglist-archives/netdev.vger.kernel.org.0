Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9206B043A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCHK2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjCHK2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:28:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2E415895;
        Wed,  8 Mar 2023 02:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6F6161742;
        Wed,  8 Mar 2023 10:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC6FC433EF;
        Wed,  8 Mar 2023 10:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678271296;
        bh=3ATSMMmIqMCYSoje7sUGyuaLfmmC29rxXpx9pHsAz0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HruyILWz2z91atQn0pwC6BOg2QeSjDMlhQO3lWI/BWDIMbwJr2oaCIdZIBC2DcyP0
         u+Ae2g3yr4pBHVZQmMBholQIS3GswVTi2boG8yI9WPQsLlPjqV+9aP9g46stBqn1YY
         RnakilR57CKXs4HcwNeBSRte1vHqWTPLV9daig7NJarJjEBcWb/bDxcSc4YSkgTFqs
         bnXYhT1Hdpl88ruBJppbszXMsU3JRt2rhqmhJYL+zcJCW2KTx+XD5yNpi4D3Wr79Pt
         hMtzzE6I8Cnr9oS/bOuhJAEsLTXZ6PzvFyKwVwBNMaX3l5aRSthccauvN7P4i/bYDP
         OPIrVvEmqTH1Q==
Date:   Wed, 8 Mar 2023 11:28:12 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: Re: [PATCH net-next 1/8] tools: ynl: fix render-max for flags
 definition
Message-ID: <ZAhjPNfv8PVKSpw2@lore-desk>
References: <cover.1678200041.git.lorenzo@kernel.org>
 <b4359cc25819674de797029eb7e4a746853c1df4.1678200041.git.lorenzo@kernel.org>
 <20230308000649.03adbcce@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sg26xanjhsS6mPfY"
Content-Disposition: inline
In-Reply-To: <20230308000649.03adbcce@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sg26xanjhsS6mPfY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue,  7 Mar 2023 15:53:58 +0100 Lorenzo Bianconi wrote:
> > Properly manage render-max property for flags definition type
> > introducing mask value and setting it to (last_element << 1) - 1
> > instead of adding max value set to last_element + 1
> >=20
> > Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  tools/net/ynl/ynl-gen-c.py | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
> > index 274e9c566f61..f2e41dd962d4 100755
> > --- a/tools/net/ynl/ynl-gen-c.py
> > +++ b/tools/net/ynl/ynl-gen-c.py
> > @@ -1995,9 +1995,14 @@ def render_uapi(family, cw):
> > =20
> >              if const.get('render-max', False):
> >                  cw.nl()
> > -                max_name =3D c_upper(name_pfx + 'max')
> > -                cw.p('__' + max_name + ',')
> > -                cw.p(max_name + ' =3D (__' + max_name + ' - 1)')
> > +                if const['type'] =3D=3D 'flags':
> > +                    max_name =3D c_upper(name_pfx + 'mask')
> > +                    max_val =3D f' =3D {(entry.user_value() << 1) - 1}=
,'
>=20
> Hm, why not use const.get_mask() here? Rather than the last entry?

actually I did this change but it ended up in patch 3/8. I will fix it in v=
2.

Regards,
Lorenzo

>=20
> > +                    cw.p(max_name + max_val)
> > +                else:
> > +                    max_name =3D c_upper(name_pfx + 'max')
> > +                    cw.p('__' + max_name + ',')
> > +                    cw.p(max_name + ' =3D (__' + max_name + ' - 1)')
> >              cw.block_end(line=3D';')
> >              cw.nl()
> >          elif const['type'] =3D=3D 'const':
>=20

--sg26xanjhsS6mPfY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZAhjPAAKCRA6cBh0uS2t
rMJ/AQDTcazZlObzi/XK6FpEt1hd9r+AFAoStz24EZcVcE/45AD/cH7LH7TqGQpj
6a6P3BMfyVfOdK29ArCM8eaqVHYCXQE=
=oW96
-----END PGP SIGNATURE-----

--sg26xanjhsS6mPfY--
