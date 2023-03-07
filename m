Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A176AD335
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 01:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCGAPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 19:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGAPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 19:15:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D6C3B0C2;
        Mon,  6 Mar 2023 16:15:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9942B811E3;
        Tue,  7 Mar 2023 00:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099BBC433D2;
        Tue,  7 Mar 2023 00:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678148132;
        bh=FS9WIYrQoj667GDcd9ZicNBtv9aXKYwndML6rXyJ4I4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZPNWFizzs1vurdEcuVlciMzYtOTn9y0NXsWygFmdx64DPhyPP68Wmn3DZcb7IXoP
         y0k/b9IaPAK5YatHc1PcVmuaMUKZs1RBkNeYDD/FgnlnyHxM7LSm/ETvmdOeowWYW5
         jlYf3y9V65fbN9iBMl7XewizbCVg10MoR8RAdULuXtJbrJtESHzEWsB2DhuXpQKzy9
         KsJTSubxTtoq/TxAwLbMmQg72kAaSN/Aiku8IfhAvdRFcURsOSmLBgXrSJhXLNEE5X
         GpMKoAy3lwxDAK1JE3LLdYxaIFofgrD/luddryLyFpEhVLASelLPEyZU5obEDNVSs2
         JFNuI11SHPFRQ==
Date:   Tue, 7 Mar 2023 01:15:28 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC net-next] ethtool: provide XDP information with
 XDP_FEATURES_GET
Message-ID: <ZAaCINTWbMxH2wGD@lore-desk>
References: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
 <20230306102150.5fee8042@kernel.org>
 <ZAYxolxpBtGZbO6m@lore-desk>
 <20230306113225.6a087a4c@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ScMZVT0OGjuYurHk"
Content-Disposition: inline
In-Reply-To: <20230306113225.6a087a4c@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ScMZVT0OGjuYurHk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 6 Mar 2023 19:32:02 +0100 Lorenzo Bianconi wrote:
> > So far the only way to dump the XDP features supported by the NIC is th=
rough
> > libbpf running bpf_xdp_query(). I would say it is handy for a sysadmin =
to
> > examine the XDP NIC capabilities in a similar way he/she is currently d=
oing
> > for the hw offload capabilities. Something like (I have an ethtool user=
-space
> > patch not posted yet):
>=20
> The sysadmin running linux-next or 6.3-rc1, that is? :)

:)

>=20
> The plan in my head is to package a tool like tools/net/ynl/cli.py for
> sysadmins to use. Either package it with the specs or expose the specs
> in sysfs like we expose BTF and kheaders.
>=20
> I was hoping we can "give it a release or two" to get more experience
> with the specs with just developers using them, 'cause once sysadmins
> are using them we'll have to worry about backward compat.
>=20
> But I don't want to hold you back so if the plan above sounds sensible
> to you we can start executing on it, perhaps?
>=20
> Alternative would be to teach ethtool or some other tool (new tool?)
> to speak netdev genl, because duplicating the uAPI at the kernel level
> really seems odd :(

ok, I got your point here and I am fine with it. What I would like to impro=
ve
with the proposed ethtool support is to help the user to double-check why a
given XDP verdict or functionality is not working properly. A typical examp=
le
I think is mlx5 driver where we can enable/disable some XDP capabilities th=
rough
ethtool, so the sysadmin can double check that XDP "rx-sg" is actually not
enabled because rq_wq_type is not set to MLX5_WQ_TYPE_CYCLIC.
I think it is fine to use cli.py to solve this issue in order to avoid mixi=
ng
uAPI :)

Regards,
Lorenzo

--ScMZVT0OGjuYurHk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZAaCIAAKCRA6cBh0uS2t
rPYUAQCEwmSMpEZoutCTuOSnPtg/MSN3XafvDKiEpJAQmuqwWAD/Y5kBUFmFOc4m
fuWw1qaMJqhskWLsBpwrt5Jhf8fF7Qc=
=BQ+/
-----END PGP SIGNATURE-----

--ScMZVT0OGjuYurHk--
