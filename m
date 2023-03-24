Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57306C8559
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjCXSv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCXSvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABD82711;
        Fri, 24 Mar 2023 11:51:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDBD562C17;
        Fri, 24 Mar 2023 18:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA2DC433D2;
        Fri, 24 Mar 2023 18:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679683883;
        bh=QI5iYgTsM1ofAY1J/uBq41C90EbbFq4z92TpmdnFVc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tNCjlyW8f7VaTbSCdPD6yo9vJvr8VRMo9JXdO+aZZXqe6Am1BcQwreIJU3qHP3Ois
         B/Rv6t/v/mWitdZlIBc5xEYDH++hMpx9g+yjdR8eS/vopd7aGDcRh6529bmD5/oHLu
         FjCyCTZ0O5ykbfXbVJOiRe33MJpwoDkc00hp9H+sw3anVTUpJtNS8WlAiffYIzvO88
         fotJpp5xnnLEf+dvSVw8E+WPQYNwXW+xE194ASOkkfgB173lWHN7s3H+anebxssULH
         sVznSmacOj2lrd527KFOcplTJV344/iUG2f0DleiGk/gjG/8BNSg1FAQG5ErMivnKM
         1GtceNZJr//vQ==
Date:   Fri, 24 Mar 2023 18:51:19 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 2/7] regmap: check for alignment on translated register
 addresses
Message-ID: <ZB3xJ4/FTEwHyVyY@sirena.org.uk>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="R3QyACzrFnj0ObNQ"
Content-Disposition: inline
In-Reply-To: <20230324093644.464704-3-maxime.chevallier@bootlin.com>
X-Cookie: Single tasking: Just Say No.
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--R3QyACzrFnj0ObNQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 24, 2023 at 10:36:39AM +0100, Maxime Chevallier wrote:
> With regmap->reg_base and regmap->reg_downshift, the actual register
> address that is going to be used for the next operation might not be the
> same as the one we have as an input. Addresses can be offset with
> reg_base and shifted, which will affect alignment.
>=20
> Check for alignment on the real register address.

It is not at all clear to me that the combination of stride and
downshift particularly makes sense, and especially not that the
stride should be applied after downshifting rather than to what
the user is passing in.

--R3QyACzrFnj0ObNQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQd8ScACgkQJNaLcl1U
h9APUgf/VgS2RAgGVn3JfSBIqYVhOLgeS+YFm9Azjphm9lH6hDY6lyib+hAJFQ1H
3uOqbJBWJ/v6SSeYTAdA4jwZhiiaPQ+b1NRz/cNmbouD8aEmQp4mDm8Py8NYPTKO
JWs8tF0UBVsllIO/bh5wRgG3tFLP+wivFYHB3QBm2bP4NcLC60U2w3hxvfpFEUb3
cLZQS5SYznLhwaunrpI9XfQbKzDRT3eb2WN9vrb6MnhPzON/8/OOHUtOT8sOo2+s
4NiBtYCjzh4gz4EGG4ywH2VCEGMU5qjOEd0qyOXGjOgH9pTCSnVB1c06MS1EhqJm
yGxEi1ATCsgcXaPEEZ1urEwFhPqzjg==
=cfQS
-----END PGP SIGNATURE-----

--R3QyACzrFnj0ObNQ--
