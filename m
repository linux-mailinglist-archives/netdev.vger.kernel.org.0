Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63AE1BBA9C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 12:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgD1KD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 06:03:58 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:52533 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726932AbgD1KD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 06:03:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id E5B58580339;
        Tue, 28 Apr 2020 06:03:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 28 Apr 2020 06:03:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=bfyRrpRNqGk3bD/MI+xjZ+HE0Cw
        EJYIH+SprH0vjLlU=; b=Z+8pq0oLT7a7qD4AKlOw9YLXd1wCk+G5aFOuHQFD01Q
        VnJYOdscNtcwEibPnzQneHtKoUU7enhp8cxYc1EA3G1pGsxGAeGS1aNwePclf9mH
        VQQMTMh+wXvTfzhWyee5I4vNMeo+xoSMG8gxhgQ7FDquy9GbcthWjoiXYP7FoA1O
        rJkpe5z3kH2X8K2nW4Et6B64dKFvB1TMcJ//Vvwf5n8YAlXIaHKhD/gbZy87i5GA
        cbikWRD5p3os1pJ3bcMkWCvgzUVelxrYXNi98FiXbOoXQCubQMDE2i/Yu5/idrEL
        34TfwHISWbYuSQepV+1XgM177rWCVMGD8DVZm4gK/6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bfyRrp
        RNqGk3bD/MI+xjZ+HE0CwEJYIH+SprH0vjLlU=; b=aKShKvUn+J6r4/GBqVSb6o
        elewB6YnWE7rJO+jVEJHKRX4qnBUT1NiNi61EIf0Uj7MRQQ0TDWkuZZatiEUgA4A
        6+XeQYmrshabRuNRRLG6MCkEv7Xn2mF7FwJ0yz8j5DdLo5ayy9OqY78AkdhzHeIh
        LZCI4EqlGDQPy+TsahyxA4bii2cD1Sm0b0XlWQmzRRCdEm0WFT3PeBuaTYWwJwNc
        ZAeeNUF90qjoRJ6xIcpC4gj8LMubqPoWb1iSJ6hieSuXL+7Entcf2wLJbvhn/xrP
        DuAhJd467p8NcYG9hH/zDVMG/v0DRJksBSlAmvG40Nsu2mi1yttJG3DAGQbTwi6w
        ==
X-ME-Sender: <xms:i_-nXnb__Ic3afkNaHTDJn_hnUgQ8f6wDG4silLUF2ixSudkZyDfTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedriedugddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucfkphepledtrd
    ekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:i_-nXu8dzWVuc8z1fAXfP7ybogPcfXXlgD3KZKJfk32Kc9wV2AgxHg>
    <xmx:i_-nXhAdiBirlYu-f1yUYyaGg5OEHxra4pz9fgh-oyX_R6XcdYGWwA>
    <xmx:i_-nXisdpIP3hBSqk-PMGUylNUNDEQpJG3LXCm4WKEqpm9PK-QUm1w>
    <xmx:jP-nXpDH7HYCZWyhumEYlOf9r1wEUbGPrrUzjtNvcc6Z03kLmP-kIA>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id D877D3280068;
        Tue, 28 Apr 2020 06:03:54 -0400 (EDT)
Date:   Tue, 28 Apr 2020 12:03:52 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Alistair Francis <alistair@alistair23.me>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>, wens@csie.org,
        anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [DO-NOT-MERGE][PATCH v4 3/3] arm64: allwinner: Enable Bluetooth
 and WiFi on sopine baseboard
Message-ID: <20200428100352.g7g7kh5e4vpde3es@gilmour.lan>
References: <20200425155531.2816584-1-alistair@alistair23.me>
 <20200425155531.2816584-3-alistair@alistair23.me>
 <417EB5CB-F57F-4B7E-A81E-9ECE166BE217@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tpogyn2zhltbavuh"
Content-Disposition: inline
In-Reply-To: <417EB5CB-F57F-4B7E-A81E-9ECE166BE217@holtmann.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tpogyn2zhltbavuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

On Tue, Apr 28, 2020 at 11:51:24AM +0200, Marcel Holtmann wrote:
> Hi Alistair,
>=20
> > The sopine board has an optional RTL8723BS WiFi + BT module that can be
> > connected to UART1. Add this to the device tree so that it will work
> > for users if connected.
> >=20
> > Signed-off-by: Alistair Francis <alistair@alistair23.me>
> > ---
> > .../allwinner/sun50i-a64-sopine-baseboard.dts | 29 +++++++++++++++++++
> > 1 file changed, 29 insertions(+)
>=20
> so I am bit confused on what to do with this series? Do you want me to ap=
ply a
> subset of patches or do you require specific reviews or acks?

Applying 1 and 2 and leaving 3 aside would be great :)

Thanks!
Maxime

--tpogyn2zhltbavuh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXqf/gwAKCRDj7w1vZxhR
xYVMAP4nKDRimgu3t5jMwZnN+FtExoWjy6v+yWcUECMXuEsnGQEAzpQYH50JCwwP
eZsHDHII6Y9Hkgf0t2cj0zr5cBRAGwM=
=avZ8
-----END PGP SIGNATURE-----

--tpogyn2zhltbavuh--
