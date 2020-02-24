Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37316A2E9
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 10:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgBXJoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 04:44:05 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34465 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727252AbgBXJoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 04:44:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 403056F45;
        Mon, 24 Feb 2020 04:44:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 Feb 2020 04:44:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=8D6LuRxaoCzIVrsMtMaDax+b3gC
        RwpjTTxEPY3vi8sw=; b=QyiSrbuZDxmS0/3x848Zpki0l0UZmW5Yf8y/ybpvHvj
        abrv3S7nodrCGVcZ3sQDUk43E61bIuadELNRNr7dUd5PxzKA7gZj3Gm3FYNewMjI
        QIXGP958QZhd1d9S4+yYbBuCzjvQdcatRjxyC6PK6+tJlb96xbrFbyzWlfxb9oYx
        z7U64L8WPHFmS/Iq9JrZKGlCIIzFoUMpicsXbAHwLivvm94QhX2Bwbqjaof4+TjT
        D/7ZvO3hyLDFcnCyPGHQRkanznRYHRGd5h0n0YPd5gj2OtnYEirxnAmfWwfy89oY
        Qy8t+zwMPxBE7yqIwjvLO7068uWs7nMCkKFoDjNWuEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8D6LuR
        xaoCzIVrsMtMaDax+b3gCRwpjTTxEPY3vi8sw=; b=CP7WwY699l786hOUiAf6by
        x+rtB9SqF4VItFWahkIJvBCFerSGh96TPZBN/xlAlZHdGfNu7co/Sdtv7QbjH3Vn
        PjJGuwmCWIxTLxmVNQlt92ACsrOrji6++jG9UXrHIXH5hPC9Qt1AfZzUR71He+MD
        +BD/xi2ZZSAVmEAmet6mlzjZxYDBE1A372+B5qbNOp+/eYk6LBnAy4vP5Hk5PaBd
        OvlzhHu7Hu2XLO7TRUCY29tQ/3quEhJA+ZB5DDBNXl8BDnwpult6ZPsKMDuEVOoW
        b47LhPXTDhFttduUuL/GBfA0f9vICjcQL/z7eWCY9wqJOzYcy75KYKTQekD6peuA
        ==
X-ME-Sender: <xms:4JpTXrBS8PvxoPN3aNrnvWeIr6vKHF5DhVRlbmO1vLTtzSaDaSHHfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrledtgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucfkphepledtrd
    ekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:4JpTXuOghxf55SQ45Xzn2t26MYdJiU5nBulwT8t8eIChzKP6rdHjNA>
    <xmx:4JpTXqdVfYQUWKMrIzWesJaxoUkspZQTqu91Rps0AxTOaVTTOcoE_Q>
    <xmx:4JpTXn51C2oCOSGhVLu1wrcmiaPQsRMBbGzBhWUWMddKZobl_qHEJQ>
    <xmx:45pTXpHYENYFLJ05uceH-qzs201WXROOgFkCY2-ug9XZqkeAMOglMg>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7FF6A3280059;
        Mon, 24 Feb 2020 04:44:00 -0500 (EST)
Date:   Mon, 24 Feb 2020 10:43:59 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH net-next v1 09/18] net/allwinner: Remove driver version
Message-ID: <20200224094359.t2qevsxzilgq3faj@gilmour.lan>
References: <20200224085311.460338-1-leon@kernel.org>
 <20200224085311.460338-10-leon@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3l2hq75myvlmy434"
Content-Disposition: inline
In-Reply-To: <20200224085311.460338-10-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3l2hq75myvlmy434
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2020 at 10:53:02AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> There is no need in custom driver version for in-tree code.
>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Acked-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime

--3l2hq75myvlmy434
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXlOa3wAKCRDj7w1vZxhR
xcbKAQD34RQIuVr/Eh3rqW6wAmdRFzMj82wPjjPCwVxOnFdvRgEA5ad/HOXd1R53
M1v0PShtjx6kM890phDjQwlRq6EvWAE=
=V9ws
-----END PGP SIGNATURE-----

--3l2hq75myvlmy434--
