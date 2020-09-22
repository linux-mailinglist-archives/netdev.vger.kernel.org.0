Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2FB273DD0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 10:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgIVIzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 04:55:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39043 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbgIVIzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 04:55:55 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 04:55:54 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9CCB05C0291;
        Tue, 22 Sep 2020 04:46:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 22 Sep 2020 04:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=mDP4BtHBA2nqXD2xHYCwm78d1kg
        TCIbZdvscE7m131A=; b=nXByXqkk52KjttwejfvBuSU9s+yd9AWwNalJYdoh85U
        HhFaGoItn7Xgivwz9x6uYIN2pr+oPv/DSELsUp7YpxvzpAGnFtvrN6Lwn+BiBRhw
        +ansjtUWd29ZCY1tvYwGLYwrzQftNaY/3PKYkkHvS1EK8OWcysAlo3t/sy5BvBzi
        ybyJcrS00Xw5g15V+g73kxxWBGa72uwT3yDW4oB+mw2sxUbgMIxyogZjH/jPfkJA
        WQHq4OLt4F9lcJm9zTAZMf4HJQilPoitBwnXPh6IHVbEpxJgi/Aknb3ZVjMHJTtH
        a6J3VrHjX325lGMF6cJarea+GrdckBiqxFThi5bJvEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mDP4Bt
        HBA2nqXD2xHYCwm78d1kgTCIbZdvscE7m131A=; b=YAUWyRBTugCYZBKHIbidsy
        Vy2M5X63wFR/UABNBFKyoMAVo0dsiE0Z2qs4nAQNrgkVhy/fU9RxH0RkQd0upYbc
        JDGAmmD11VwUKC4/LhGHNvuZSj3IJkon4WIgTiR6p1Qo8aKGu/hBe/QYkk8yPwwu
        FNg1d6Adeigs5BGehLcp751NgaYFt1W8xQBLOsH6YJcCSxb6sCUIH0RujhDBMqO2
        rmKoWvp5YPpbS0cpGjkHj2XcqXADUuRWY4JlLlAHOWBXYRsmWsvLcwoMWRyKpQm9
        LrY3fETnH7AETZ9CggFQI9H5mQO2AuWNv3b+bpXriY9yVI+6Uqm3tOsooQFI4f9A
        ==
X-ME-Sender: <xms:7LlpXxfiAk6Xgye23teNSyX2oBNPtM4PKHTFbV2RB1zs3DYEHE-rgA>
    <xme:7LlpX_MJhXXdmP57gz5mrPUpz7PMCgrSZ7fZX30YpyC228U8700xkImbyfknDPgrb
    p8xkzhsBge4UbhGz14>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeggddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtth
    gvrhhnpeelkeeghefhuddtleejgfeljeffheffgfeijefhgfeufefhtdevteegheeiheeg
    udenucfkphepledtrdekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:7LlpX6jm-W1_Uy_gX6ry1NVoZFBDXUroRcHm5wHmP-MHT5OH8bAGmA>
    <xmx:7LlpX6-RZfCeH0TuGqy9QBK2O3KEnoajh2CW_Y22lYaQPyeHS82E8A>
    <xmx:7LlpX9sFuudC4JTOnDie8KRLEecp8OUefS9HRRQCBPHVc2OmQhNSgg>
    <xmx:7blpX27TDwMr7QZi74gltqd2BkGE6zR76XI7IpjIL948JJ9pt7-iTQ>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id A48B33280059;
        Tue, 22 Sep 2020 04:46:36 -0400 (EDT)
Date:   Tue, 22 Sep 2020 10:46:34 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH] net: allwinner: remove redundant irqsave and irqrestore
 in hardIRQ
Message-ID: <20200922084634.ibc2wfatu6aubhet@gilmour.lan>
References: <20200922015615.19212-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q5jjghgm3pyo5dc2"
Content-Disposition: inline
In-Reply-To: <20200922015615.19212-1-song.bao.hua@hisilicon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q5jjghgm3pyo5dc2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2020 at 01:56:15PM +1200, Barry Song wrote:
> The comment "holders of db->lock must always block IRQs" and related
> code to do irqsave and irqrestore don't make sense since we are in a
> IRQ-disabled hardIRQ context.
>=20
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>

Acked-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime

--q5jjghgm3pyo5dc2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX2m56gAKCRDj7w1vZxhR
xfrBAP9NND3Z8Wsmrs/PYXA96hgSzeqJx53rD3baApCGhbp0PAD7BYDuDCr0LG7w
WiN5BtjhCwICaeM6byu7Zlts49ys3AI=
=4Pdu
-----END PGP SIGNATURE-----

--q5jjghgm3pyo5dc2--
