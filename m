Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDCA6ACCAA
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjCFScm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjCFScl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:32:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121FD7585B;
        Mon,  6 Mar 2023 10:32:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69514B81082;
        Mon,  6 Mar 2023 18:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D420AC433EF;
        Mon,  6 Mar 2023 18:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678127526;
        bh=lDuDv/QPxcLcLx8BERHPlUpPdhhn9RkbDWtfLmKKtuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OCN7pUxHvgb9FTwPg5lvpIkrEg5BT72xF2iOEN4Ofjh37Kf62fWUsdtZX1pIMfJcy
         yvSTPbRBJAkKf8Uo7Y5WqlEwsuqGAU475dROX86+vfUptw27oxkIH8I8V1R27p3T02
         wOjiTrlb6lMYrVz+ywvdAaL/bOy2LsqkuKzr5Phg2O38sViaYiCDYnfeEig9NKDyhz
         r5jrbG+v415Q5nLVoAvNpKNlLHsB1eqTTdmh80+rpjEKxLrucSQof0ZEJpO2JK71+r
         SfkBfQ4u7myWkSH6Bw85dEGKyFsEBI5frtuEesRvNSreVG6p23qfmAaDWhER3lQlP4
         d0PbYHS0T0P0A==
Date:   Mon, 6 Mar 2023 19:32:02 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC net-next] ethtool: provide XDP information with
 XDP_FEATURES_GET
Message-ID: <ZAYxolxpBtGZbO6m@lore-desk>
References: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
 <20230306102150.5fee8042@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="66VsHNCDmetl6Ayf"
Content-Disposition: inline
In-Reply-To: <20230306102150.5fee8042@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--66VsHNCDmetl6Ayf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon,  6 Mar 2023 11:26:10 +0100 Lorenzo Bianconi wrote:
> > Implement XDP_FEATURES_GET request to get network device information
> > about supported xdp functionalities through ethtool.
>=20
> You need to explain why. This is duplicating uAPI.

Hi Jakub,

So far the only way to dump the XDP features supported by the NIC is through
libbpf running bpf_xdp_query(). I would say it is handy for a sysadmin to
examine the XDP NIC capabilities in a similar way he/she is currently doing
for the hw offload capabilities. Something like (I have an ethtool user-spa=
ce
patch not posted yet):

$ethtool --get-xdp-features eth0
XDP features for eth0:
xdp-basic: supported
xdp-redirect: supported
xdp-ndo-xmit: supported
xdp-xsk-zerocopy: not-supported
xdp-hw-offload: not-supported
xdp-rx-sg: not-supported
xdp-ndo-xmit-sg: not-supported

Regards,
Lorenzo

--66VsHNCDmetl6Ayf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZAYxogAKCRA6cBh0uS2t
rORkAQCgq/reHidWqmXbDrjGJorF1NaG+B4SA6TlH3eqNhUVigEAq3TvxSyCzmoR
9UYlYhH4PZvWhMDiLgg4SDIKlIfdXwY=
=oJ5V
-----END PGP SIGNATURE-----

--66VsHNCDmetl6Ayf--
