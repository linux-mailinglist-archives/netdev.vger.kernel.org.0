Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB47E3073A6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 11:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhA1KXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 05:23:12 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:50889 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232342AbhA1KWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 05:22:34 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A1D3B580649;
        Thu, 28 Jan 2021 05:21:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 28 Jan 2021 05:21:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=WKrBbHzc805XUW+IWILdpePB9+M
        x4qNr5ByeHkDKEMM=; b=sOFjsjcZbdtXKklJVChBAIKxlnLsMcLo1fYPU3ICSGP
        FhRHU06NIezmMnZhpMaYg+fDidJZ6znPrcba7Mpf7HyYVtTHhbkBSFEifM0pJjaP
        sTNKb1Iiy0RXWiVuENDR9eI09pb3Z4oNozZQnIDBFYXfYs1wrM77iI5oQXhZdvZ8
        r7O7uFrDDwqPXnk+fRIZIw4oXJmWXetBvHO4apPtVDzPP5Fi5d9g6TpnAFXxqInO
        hXF9VREI1fuxv+VxKzhNdHqhjTWg+rLUm2U3Gn2hBA6mEr2EfN9Vg49T44DPddcc
        M+UpR9e62ifqvhIzEp6M5gI6Bh2JQaGQwu6UeQ2NQKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WKrBbH
        zc805XUW+IWILdpePB9+Mx4qNr5ByeHkDKEMM=; b=kqXv8zx0rEbo6gcDS+36eR
        H69TSoc6zIc59J9mehMBhZbXQtqEJHAiq9BpC8jm73MAsJQW2/ijGR7jzx+g9lcH
        kTGy+MuZEAOkeLhYuxYMTYs8HVKunU5q1vUnVvipAHGYMrw8lPsVxbGBOHFPUWEZ
        V9GVMjQXeB7TgGPRLeoGpDezDK9QkRmcYjuOzLYB/gg0wRD4IbLrrFIQUK0cpRuJ
        gW27i/43JCf6n7iyjY8j+dPTDNgyC0ZTu8lXYMrPcAElwjXJrZ5vVP7BCCGn4cbC
        1l4R1rPsvLrhQVb4tjIPl7eubrG4Ge/GLxXlt8v5mGGGvsnSWdU7uGmc+n/2pJOQ
        ==
X-ME-Sender: <xms:JZASYMn7Hu4HhiRXqKC4prc-QTrilhT3dBZ4rkB9ejbJ1HPUqhvFHg>
    <xme:JZASYL3mqeyyfDAY176hjN_bnH0MwCrNtlsUZmNODRGkKd_UgcFl_BbpY81nv0N8f
    DabHxGLQy1cNipN8I4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtth
    gvrhhnpeelkeeghefhuddtleejgfeljeffheffgfeijefhgfeufefhtdevteegheeiheeg
    udenucfkphepledtrdekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:JZASYKpkQf2s4o3230LBIMEuERLNQBTmdSiBVIVJVskHuiWgmYuH4w>
    <xmx:JZASYIkE5BL3oCXVoNZvYWRzy6p0ag1lncJQfHRlWDkuaZcmjZzpXQ>
    <xmx:JZASYK3IuB_t-7SrTrEU9mxkhqGtjpKF-YGALNq41tKeJff2nB1nPg>
    <xmx:J5ASYF1UtgU9keS1tgaUVsSodzhCpWJ_lxzvQx5dsCLe2HYEAWaIFA>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F16524005D;
        Thu, 28 Jan 2021 05:21:25 -0500 (EST)
Date:   Thu, 28 Jan 2021 11:21:24 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Samuel Holland <samuel@sholland.org>,
        Icenowy Zheng <icenowy@aosc.io>, Rob Herring <robh@kernel.org>,
        =?utf-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>,
        Shuosheng Huang <huangshuosheng@allwinnertech.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v5 16/20] net: stmmac: dwmac-sun8i: Prepare for second
 EMAC clock register
Message-ID: <20210128102124.5r7ztgehw2iqbbl6@gilmour>
References: <20210127172500.13356-1-andre.przywara@arm.com>
 <20210127172500.13356-17-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xhjmi5l7rzawjt23"
Content-Disposition: inline
In-Reply-To: <20210127172500.13356-17-andre.przywara@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xhjmi5l7rzawjt23
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 27, 2021 at 05:24:56PM +0000, Andre Przywara wrote:
> The Allwinner H616 SoC has two EMAC controllers, with the second one
> being tied to the internal PHY, but also using a separate EMAC clock
> register.
>=20
> To tell the driver about which clock register to use, we add a parameter
> to our syscon phandle. The driver will use this value as an index into
> the regmap, so that we can address more than the first register, if
> needed.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Maxime Ripard <mripard@kernel.org>

Maxime

--xhjmi5l7rzawjt23
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYBKQJAAKCRDj7w1vZxhR
xagXAP9sBF7h64P0H+8rQpl6V5lGj5Y3y/W70a+vh9IM8bXJNAD/eCKBDZ89fJ9m
IZRiUsDCg90R+6SY81zqg3DWFA9F7gM=
=nLfI
-----END PGP SIGNATURE-----

--xhjmi5l7rzawjt23--
