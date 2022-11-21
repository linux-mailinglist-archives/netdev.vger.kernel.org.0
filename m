Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517CA632563
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiKUORm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiKUORM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:17:12 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC43310B49;
        Mon, 21 Nov 2022 06:17:10 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 931F710000B;
        Mon, 21 Nov 2022 14:17:01 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     "Bonaccorso, Salvatore" <carnil@debian.org>,
        "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>
Subject: Re: drivers/net/wwan/iosm/iosm_ipc_protocol.c:244:36: error: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]
Date:   Mon, 21 Nov 2022 15:16:52 +0100
Message-ID: <3150689.e9J7NaK4W3@bagend>
Organization: Connecting Knowledge
In-Reply-To: <SJ0PR11MB500875E67568132D3D4EBCB1D70A9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <Y3aKqZ5E8VVIZ6jh@eldamar.lan> <2951107.mvXUDI8C0e@bagend> <SJ0PR11MB500875E67568132D3D4EBCB1D70A9@SJ0PR11MB5008.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3495024.aeNJFYEL58"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3495024.aeNJFYEL58
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Date: Mon, 21 Nov 2022 15:16:52 +0100
Message-ID: <3150689.e9J7NaK4W3@bagend>
Organization: Connecting Knowledge
MIME-Version: 1.0

Hi Chetan,

On Monday, 21 November 2022 14:47:20 CET Kumar, M Chetan wrote:
> I tried reproducing it at my side by compiling kernel for armhf
> configuration [1] but could not reproduce it. Could you please share the
> steps and config details for reproducing it locally so that I can take a
> look at it.

I have a clone of the upstream kernel in ~/dev/kernel.org/linux
You also need a clone of https://salsa.debian.org/kernel-team/linux

All the commands are done from the 'kernel-team/linux' dir.

The configuration file for compilation is generated from the `debian/config` dir.

# Create an 'orig' tarball from upstream 6.1-rc5
$ debian/bin/genorig.py ~/dev/kernel.org/linux/

# set some (cross compile) build options (with 14 cores)
$ export DEB_BUILD_OPTIONS="parallel=14"
$ export DEB_BUILD_PROFILES="cross nodoc pkg.linux.nosource pkg.linux.notools pkg.linux.nokerneldbg"
$ export ARCH=armhf
$ export CC=arm-linux-gnueabihf-gcc-12
$ dpkg-architecture --host-arch armhf

# Clean things up and do the actual build
$ dpkg-architecture -c fakeroot debian/rules maintainerclean
$ dpkg-architecture -c debian/rules orig
$ time dpkg-architecture -c fakeroot debian/rules binary-indep
$ time dpkg-architecture -c fakeroot debian/rules binary-arch

HTH,
  Diederik
--nextPart3495024.aeNJFYEL58
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY3uIVAAKCRDXblvOeH7b
buuqAQD8NyiZaKYdxlxsCaeQjVVpFkD9cHF+t/byYMblMsJZ4wEA2l7K9qavwSdM
K8Yz8DLFnIQUEHpbCPMjK/6i/P57Zw4=
=y5WD
-----END PGP SIGNATURE-----

--nextPart3495024.aeNJFYEL58--



