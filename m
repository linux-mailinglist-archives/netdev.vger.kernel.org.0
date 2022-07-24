Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07AC57F734
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 23:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiGXV1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 17:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiGXV1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 17:27:46 -0400
Received: from yangtze.blisses.org (yangtze.blisses.org [144.202.50.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B816C10FDA
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 14:27:45 -0700 (PDT)
Received: from contoocook.blisses.org (contoocook.blisses.org [68.238.57.52])
        by yangtze.blisses.org (Postfix) with ESMTP id B1C4617D711;
        Sun, 24 Jul 2022 17:27:43 -0400 (EDT)
Authentication-Results: yangtze.blisses.org;
        dkim=pass (2048-bit key; unprotected) header.d=blisses.org header.i=@blisses.org header.a=rsa-sha256 header.s=default header.b=Nleyriy1;
        dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=blisses.org;
        s=default; t=1658698063;
        bh=4gJW88yObdM4qY0NgVKXMqb0Zt1FUTMPxU+PDW73EB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nleyriy1LXXbD/l/N6xat7TUgrasjWGP5/RqB7M65LxEaIir/IOfZfsYWxT61SNBX
         P/Oklq3QBR1n0WrY35HEc7BsXFCdKd+j8+g6b6f1w83jXKjSfAdTuYufkeUJIvUEGU
         JHueH1zJfPBiv2lzFzmMIZzupeP7bdjyItQYf8r1DbUQJPPLVIBxbcLiAzfs1aZN0t
         KxFGIWr4zzTPx0Cv7REzS7oKyhb3CMppfK2VxqPB2P2nH3+mrYpeEeyJeAWskU1Alz
         25hOMmXhua03PMDvDQB9sQC/alTqdtUA2970pPNrfNAN8TrTsenmtU04Ez/MW2p2Zk
         VJpIvmWAtSS7w==
Date:   Sun, 24 Jul 2022 17:27:42 -0400
From:   Mason Loring Bliss <mason@blisses.org>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, hkallweit1@gmail.com
Subject: Re: Issue with r8169 (using r8168 for now) driving 8111E
Message-ID: <Yt25TiVImcnpnuAE@blisses.org>
References: <YtxI7HedPjWCvuVm@blisses.org>
 <Ytx7nc3FosXV6ptC@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KscbYT9j58UvY3Ip"
Content-Disposition: inline
In-Reply-To: <Ytx7nc3FosXV6ptC@electric-eye.fr.zoreil.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KscbYT9j58UvY3Ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 24, 2022 at 12:52:13AM +0200, Francois Romieu wrote:

> The driver should receive and process this kind of CRC errored packet sin=
ce
> 79d0c1d26e1eac0dc5b201e66b65cc5e4e706743 ("r8169: Support RX-FCS flag.")
> provided ethtool was not used to disable it (see -k/-K and rx-fcs/rx-all).
> tcpdump may thus help to identify some pattern in the packet.

Thank you for the additional detail!

It appears to be the case that having an APC surge supressor inline,
despite it being labelled as gigabit-capable, was the cause of the CRC
errors. I changed cables, and that not helping, I swapped in different APC
units, and the errors persisted until I went straight from NIC to ONT. Now
I've gone a couple hours without seeing an error, and haven't in fact seen
one since the link came back up after the most recent change.

I'm glad the driver stopped suppressing these errors, or I'd not have known
the inline surge supression was a bit flaky. Thank you.

--=20
Mason Loring Bliss    mason@blisses.org
They also surf, who only stand on waves.

--KscbYT9j58UvY3Ip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEEXtBZz1axB5rEDCEnrJXcHbvJVUFAmLduUcACgkQnrJXcHbv
JVXKxQ/+JQ85ZD2m9ANWpXWmE8a7iAK81amwFZA/2DkDpsKRQJPPYpyAIDzCEv2m
lKaWyfzGY5A0f5LerwMdEXEe5bMrLiXqc+gSZhPuNBfwFyOv3dN/NcTgGJxcshmX
wLcaak0kD6EgZ/VBZuYxWwqOXZiGw3Adydg6FB5fQvT31H2bxxfajO3M/oPa7TTN
I73QuIxIgWuS2Y8+0thgiLPVp5nvk5geRx72WZeaHwR2xt3dykMfKDR8q08YHROi
q/fJpswouLHAISVjFZ3wNrJ27gpwXcfiFP5qCMccWw+vWNx1RolYmtopvroCAESh
t7l7QxVXPbhjXFX0RGPzGmUgeYrmAmFY33dnu8MXuyqTCKlM6kTjxy4Db5jzUdio
+WrWygxiM09x4oo5fIbnH/Ra4kq99LCtydnAyT3hWCwzlOQKsEXfI8DkVbv9U0HK
8x0DMU9Od41ktR/jt021JRJRZLHyKGtsvDzg077ps9qOQnPLsc7el4cdXfJYNS+d
u6ZXCOQmU97rqWNQI2t9J3l6cK3lu9A0vEHpI1jrVMjewg+FEh+1Mv2Y+50zu7Wi
eTYyVnjqP4vhddrMFDUcA4c6BAfDopetS3pjfyWlWb/aERQBlSkT5Bcy9m8a6/NA
Vx4cWYNVX9gbSbnUjJt6k7vy8jRHTleNXRM/nKCUHAJswIsDinQ=
=ywiO
-----END PGP SIGNATURE-----

--KscbYT9j58UvY3Ip--
