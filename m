Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A604064B354
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 11:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbiLMKjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 05:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbiLMKjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 05:39:13 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46371B9F9;
        Tue, 13 Dec 2022 02:39:10 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E26091C09F4; Tue, 13 Dec 2022 11:39:08 +0100 (CET)
Date:   Tue, 13 Dec 2022 11:39:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Jakub Kicinski <kuba@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5hWTI0UF5f9I0a9@duo.ucw.cz>
References: <20221212130924.863767275@linuxfoundation.org>
 <CA+G9fYv7tm9zQwVWnPMQMjFXtNDoRpdGkxZ4ehMjY9qAFF0QLQ@mail.gmail.com>
 <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17sVYUeo7bE3z69j"
Content-Disposition: inline
In-Reply-To: <86c7e7a5-6457-49c5-a9e3-b28b8b8c1134@app.fastmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--17sVYUeo7bE3z69j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2022-12-13 10:20:30, Arnd Bergmann wrote:
> On Tue, Dec 13, 2022, at 08:48, Naresh Kamboju wrote:
> > On Mon, 12 Dec 2022 at 18:43, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >
> > Regression detected on arm64 Raspberry Pi 4 Model B the NFS mount faile=
d.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Following changes have been noticed in the Kconfig file between good an=
d bad.
> > The config files attached to this email.
> >
> > -CONFIG_BCMGENET=3Dy
> > -CONFIG_BROADCOM_PHY=3Dy
> > +# CONFIG_BROADCOM_PHY is not set
> > -CONFIG_BCM7XXX_PHY=3Dy
> > +# CONFIG_BCM7XXX_PHY is not set
> > -CONFIG_BCM_NET_PHYLIB=3Dy
>=20
> > Full test log details,
> >  - https://lkft.validation.linaro.org/scheduler/job/5946533#L392
> >  -=20
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v=
5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/tests/
> >  -=20
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v=
5.10.158-107-gd2432186ff47/testrun/13594402/suite/log-parser-test/test/chec=
k-kernel-panic/history/
>=20
> Where does the kernel configuration come from? Is this
> a plain defconfig that used to work, or do you have
> a board specific config file?
>=20
> This is most likely caused by the added dependency on
> CONFIG_PTP_1588_CLOCK that would lead to the BCMGENET
> driver not being built-in if PTP support is in a module.

There's no PTP_1588_CLOCK_OPTIONAL in 5.10. This needs to be dropped:

|2a4912705 421f86 o: 5.10| net: broadcom: Add PTP_1588_CLOCK_OPTIONAL depen=
dency for BCMGENET under ARCH_BCM2835

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--17sVYUeo7bE3z69j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY5hWTAAKCRAw5/Bqldv6
8rDhAJ9a7yt02CI4FJMdok20phpAyMLt9wCfZ7K+tGfohkp+A/QHR76DTu7Vf5s=
=tCRA
-----END PGP SIGNATURE-----

--17sVYUeo7bE3z69j--
