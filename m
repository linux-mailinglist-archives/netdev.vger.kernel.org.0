Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC64F65CE87
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjADIod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbjADIob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:44:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C812B1A058;
        Wed,  4 Jan 2023 00:44:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AFF1B815C2;
        Wed,  4 Jan 2023 08:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842B9C433D2;
        Wed,  4 Jan 2023 08:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672821868;
        bh=dhU/nCpwMIeJj3XRgwHtRg9MAK6LNzONvI7prwCy/ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U8QF2kd66RpNSVoDCopZ1nryaoJTBepMn9LFLZtBnvNQWxoyo0Zzd8IKfGwn/ygcd
         bHeMTDUXcxeuGd9yQMUOmDDvWNon8Xyxrns4j0hL9lhoQ8VNYCVUHAa4tXFfTJR5UI
         KRGpurmyhzJvx2LoSltExr2diTEha6oY++G+fO/Zb//ugWWWV0dzIUhfG6n+uRrjqD
         d+fhCy3qLg3FA3UQGqY0EH5bkh9dXI/yn+h6c1wzv1NjN6X4YggU15jn/JOaxJzO3W
         k7qHyxXxRAB3H+yXBGkJ0Y96hmFB/Zo6bd202Zfe/g10K0Yfz6JWd48jnSmuTjXm2Z
         dbF/4YSBsYW7g==
Date:   Wed, 4 Jan 2023 09:44:24 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <Y7U8aAhdE3TuhtxH@lore-desk>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
 <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e1TbLDOmNoNp9c+g"
Content-Disposition: inline
In-Reply-To: <20230103172153.58f231ba@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--e1TbLDOmNoNp9c+g
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 03 Jan 2023 16:19:49 +0100 Toke H=F8iland-J=F8rgensen wrote:
> > Hmm, good question! I don't think we've ever explicitly documented any
> > assumptions one way or the other. My own mental model has certainly
> > always assumed the first frag would continue to be the same size as in
> > non-multi-buf packets.
>=20
> Interesting! :) My mental model was closer to GRO by frags=20
> so the linear part would have no data, just headers.

That is assumption as well.

Regards,
Lorenzo

>=20
> A random datapoint is that bpf_xdp_adjust_head() seems=20
> to enforce that there is at least ETH_HLEN.

--e1TbLDOmNoNp9c+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY7U8aAAKCRA6cBh0uS2t
rC0sAP9Wj8TbwcYxrX2MfzTIpike7c8ukxeJjGrDXdn85FrJiwD+Oz3kURLL7uMq
7r4VDGFRDSVANSTQNKfV73cWZrP49AU=
=AJ4V
-----END PGP SIGNATURE-----

--e1TbLDOmNoNp9c+g--
