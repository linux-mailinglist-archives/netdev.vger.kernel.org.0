Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20B24C8E8B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbiCAPHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235482AbiCAPHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:07:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E61CA647F;
        Tue,  1 Mar 2022 07:06:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA056B81986;
        Tue,  1 Mar 2022 15:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE474C340EE;
        Tue,  1 Mar 2022 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646147176;
        bh=3rErMr8HPx66Jp00WJd9yEBIjWGz3wiDvsGrMjqCVAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hdimVuBrc+VRHT8NLNPkQIB6GizNq9maujOWeKdrDVMnAQYQRm2LmLfzNyF3wvOIJ
         LBPsO/PCcc0nroUoIJq2MjkInjaELLtHkyQoLGJe71NL8il9/nIPKnGZXr1aqh+Ewl
         x0SXQafhrW9XgowgZPXdWiYFTSdagsEyygI5xMqlQZmR0/HpQFgjRac148KyG9Ga3k
         LCSsMK9o31q24sTrg7XobBbuSAz6jK5XDrjkIPg2tO6ICqV2e+kEF1RZm9Oib5f+Mb
         jXdbH8GJA204lhfUZtooGpel8rzHa7B6xg3a76EPzfr+sB/H2rDARzNB+6M0se5UrN
         HNubxkMRCB/cw==
Date:   Tue, 1 Mar 2022 16:06:13 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH v4 2/7] i2c: core: Use generic_handle_irq_safe() in
 i2c_handle_smbus_host_notify().
Message-ID: <Yh42ZZFFcXnXqS5K@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
References: <20220211181500.1856198-1-bigeasy@linutronix.de>
 <20220211181500.1856198-3-bigeasy@linutronix.de>
 <YhY03EojmT3eaIcR@ninjato>
 <YhlXplZCkflfkg1W@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vly9pc/cg0xZd513"
Content-Disposition: inline
In-Reply-To: <YhlXplZCkflfkg1W@linutronix.de>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vly9pc/cg0xZd513
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 25, 2022 at 11:26:46PM +0100, Sebastian Andrzej Siewior wrote:
> On 2022-02-23 14:21:32 [+0100], Wolfram Sang wrote:
> > Is this 5.17 material? Or is 5.18 fine, too?
>=20
> 5.18 is fine. I intend to push into the RT-stable trees and this can't
> be backported without 1/7 and it does not affect !RT so I wouldn't
> bother.

Ok, applied to for-next then. Thanks for the heads up!


--vly9pc/cg0xZd513
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmIeNmQACgkQFA3kzBSg
KbbfYxAAgtOpVKmeFifH+JWyqT1mW6M6PKCY098U/utaJDTEnIPOnkUsMe4spnDs
TctqYaihXKSZf9UxlJhVPZ/ZIRHYSA+KF14IDEeLzkL49d4ojSGarl893u0l7bx2
6aQQeO3oJT4dGN7ohZsg2AYD6ym1baCtAH+zimu6hPacRHgucRh+0IvjYxgioXg3
rhYauOkmcDPxqPvS33shdRagDKbjZ3V+HqswU2FGmLEMCTOxNhvDw4q7mUsAsIqO
Ct370v13+nH6HQlXaOMzzIGROyz3GO3Xo/ZOYJdRsp/UCRHIMHabGMvyFBX5p4Hj
gAyWkNCqvLJdzYNmqtosc6r0iQFuZSUItW/wM+kHpwwwdOsup5n7QY7uBp78G6Ea
eRZJmC80xn3HEZ75FJTkT6aHucCZApCT3uBViUVwOA34fQYuujCcHvhuCEkGeJz5
kNdx6JdigSxX40Re7h6/ac1sz2EXm4CxmcFzQm10AFjJjjdzU2+zIqi/tk/6J+yS
oR2DR95lglxohOmzidOAL/qTmBNdeh+eQL0Ta9JJqSnVnRWCzu5iTzt/PXo8Vs5N
4cg8cpOAOFtYwxQrF1JaHgCStljwQbBp+IHBaJbOtzBYaLA3HoETlXLv/7opaFk4
+rw1pWvsOmQkGbFW/n+eVO0aYMnOMFGx8AOuKco5SQ73Otp5GSM=
=3Lg4
-----END PGP SIGNATURE-----

--vly9pc/cg0xZd513--
