Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAB83B43AA
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 14:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhFYNBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:01:31 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:58231 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231434AbhFYNBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 09:01:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 668F03200302;
        Fri, 25 Jun 2021 08:59:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 25 Jun 2021 08:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Lc/7YbhG8BVCS8/O5KJel79B99C
        9eFu6MQnhr484GwQ=; b=0VDyogtCFQYgIHdUveTMn2U7PCazuIus/JjWZxKsXb3
        ED8VD88PhdotaB6hjw5sQ7dgAfYv+dD5PkuiBf08fHrW7DdhYrSm22kvXDdxtrGp
        Csd5rrfM2hVWi75vfpISKaumPS2iSKt7/8WCxXR9U8XbLPUIhsAJIPkQTJFBSzuK
        9mCRuxRKjS0hsyaTxfcpm5Q/glX0qDdhLhWw0h7rH9ehAqM32kOkGdK/BvEb2V50
        Wce1/FiIkp1LeV4RWhhDotTnDDeRsp/mvoIqC2/Jlc8rLOQBn0FUtEgfV6drDmaX
        VYmvqAFbegv3rJaa7fA0gfJEYVHCh5NbB7FTxClW3nA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Lc/7Yb
        hG8BVCS8/O5KJel79B99C9eFu6MQnhr484GwQ=; b=dsgz1boo9uJbTiUYh899kP
        mWzQvso1hL8Qq/O+GCsfQ1h/FbwOVTpe9ob+RyA6gqsZS9oKDOu58ZkmeIZJyN5A
        DDx5qSErTiMV69108rRroRa7C4Bsh1Hu3iUbb7P1Gux8a6gkjqpJwBYgAtiujwo+
        +DobfE2TmHzmsjiUclw5VksNBij/XMQw75nGBd6TVH95hD8/vUU16cXVl1XWFcLf
        YWix5A17YPNj9mFgRrWE6As8jZaSKe0rvYHCPj6U04J3YmIRK1/49Fqi8ggxQTb/
        5zNoj5xz+b3JaJ2SHUjaRstg4tjBw8hJ/5YmeX1HJQ34I2eKy8/bTXMyBdEUQuDg
        ==
X-ME-Sender: <xms:HNPVYD5l5v3Pm8fJLoXZQkIZEpuqcgX354eAx2CSSRfjTnHHeMP1Sg>
    <xme:HNPVYI7rLHuOQPNvh8h-7CC4yy4v57lNIJ2izk14PcektAToHL7vN4yoPSwz6RTo2
    VsjYiPfFrx-QHiffgM>
X-ME-Received: <xmr:HNPVYKc3ChA9dcqixvqQNQpvb6k6hNheuJ-RsdI-EDeK0UN6nJH8udEgxP3cFob9u-041QXsS62f1ygPGuWGRvf6EIDzNkutMmna>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegjedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmh
    grgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:HNPVYEIoMWfSj4V2t_kMdyyqOLULUYH_qVavkpTjC3Vd8xTnYYtWKQ>
    <xmx:HNPVYHI0Na94q32Orhxo33z82HgGOTQRoZmVTN08fY1owIv9ew5kGQ>
    <xmx:HNPVYNxcxBy4-TsOeB53oBHLdJvAoGTZJe-lXzeE5s0IBAEMzD_7rw>
    <xmx:HdPVYEHGtuuumcaCu8a_bH97CtBjul7Mi7n6JP2YtABP-sLUGk30Gg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Jun 2021 08:59:08 -0400 (EDT)
Date:   Fri, 25 Jun 2021 14:59:06 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     nicolas saenz julienne <nsaenz@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel Panic in skb_release_data using genet
Message-ID: <20210625125906.gj45zykbemh5zzhw@gilmour>
References: <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
 <20210524151329.5ummh4dfui6syme3@gilmour>
 <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
 <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
 <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
 <20210602132822.5hw4yynjgoomcfbg@gilmour>
 <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vj77sa6izslkbxij"
Content-Disposition: inline
In-Reply-To: <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vj77sa6izslkbxij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

Sorry for the late reply

On Thu, Jun 10, 2021 at 02:33:17PM -0700, Florian Fainelli wrote:
> On 6/2/2021 6:28 AM, Maxime Ripard wrote:
> > On Tue, Jun 01, 2021 at 11:33:18AM +0200, nicolas saenz julienne wrote:
> >> On Mon, 2021-05-31 at 19:36 -0700, Florian Fainelli wrote:
> >>>> That is also how I boot my Pi4 at home, and I suspect you are right,=
 if
> >>>> the VPU does not shut down GENET's DMA, and leaves buffer addresses =
in
> >>>> the on-chip descriptors that point to an address space that is manag=
ed
> >>>> totally differently by Linux, then we can have a serious problem and
> >>>> create some memory corruption when the ring is being reclaimed. I wi=
ll
> >>>> run a few experiments to test that theory and there may be a solution
> >>>> using the SW_INIT reset controller to have a big reset of the contro=
ller
> >>>> before handing it over to the Linux driver.
> >>>
> >>> Adding a WARN_ON(reg & DMA_EN) in bcmgenet_dma_disable() has not shown
> >>> that the TX or RX DMA have been left running during the hand over from
> >>> the VPU to the kernel. I checked out drm-misc-next-2021-05-17 to redu=
ce
> >>> as much as possible the differences between your set-up and my set-up
> >>> but so far have not been able to reproduce the crash in booting from =
NFS
> >>> repeatedly, I will try again.
> >>
> >> FWIW I can reproduce the error too. That said it's rather hard to repr=
oduce,
> >> something in the order of 1 failure every 20 tries.
> >=20
> > Yeah, it looks like it's only from a cold boot and comes in "bursts",
> > where you would get like 5 in a row and be done with it for a while.
>=20
> Here are two patches that you could try exclusive from one another
>=20
> 1) Limit GENET to a single queue
>=20
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index fcca023f22e5..e400c12e6868 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3652,6 +3652,12 @@ static int bcmgenet_change_carrier(struct
> net_device *dev, bool new_carrier)
>         return 0;
>  }
>=20
> +static u16 bcmgenet_select_queue(struct net_device *dev, struct sk_buff
> *skb,
> +                                struct net_device *sb_dev)
> +{
> +       return 0;
> +}
> +
>  static const struct net_device_ops bcmgenet_netdev_ops =3D {
>         .ndo_open               =3D bcmgenet_open,
>         .ndo_stop               =3D bcmgenet_close,
> @@ -3666,6 +3672,7 @@ static const struct net_device_ops
> bcmgenet_netdev_ops =3D {
>  #endif
>         .ndo_get_stats          =3D bcmgenet_get_stats,
>         .ndo_change_carrier     =3D bcmgenet_change_carrier,
> +       .ndo_select_queue       =3D bcmgenet_select_queue,
>  };
>=20
>  /* Array of GENET hardware parameters/characteristics */
>=20
> 2) Ensure that all TX/RX queues are disabled upon DMA initialization
>=20
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index fcca023f22e5..7f8a5996fbbb 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3237,15 +3237,21 @@ static void bcmgenet_get_hw_addr(struct
> bcmgenet_priv *priv,
>  /* Returns a reusable dma control register value */
>  static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
>  {
> +       unsigned int i;
>         u32 reg;
>         u32 dma_ctrl;
>=20
>         /* disable DMA */
>         dma_ctrl =3D 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
> +       for (i =3D 0; i < priv->hw_params->tx_queues; i++)
> +               dma_ctrl |=3D (1 << (i + DMA_RING_BUF_EN_SHIFT));
>         reg =3D bcmgenet_tdma_readl(priv, DMA_CTRL);
>         reg &=3D ~dma_ctrl;
>         bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
>=20
> +       dma_ctrl =3D 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
> +       for (i =3D 0; i < priv->hw_params->rx_queues; i++)
> +               dma_ctrl |=3D (1 << (i + DMA_RING_BUF_EN_SHIFT));
>         reg =3D bcmgenet_rdma_readl(priv, DMA_CTRL);
>         reg &=3D ~dma_ctrl;
>         bcmgenet_rdma_writel(priv, reg, DMA_CTRL);

I had a bunch of issues popping up today so I took the occasion to test
those patches. The first one doesn't change anything, I still had the
crash occurring with it. With the second applied (in addition), it seems
like it's fixed. I'll keep testing and will let you know.

Maxime

--vj77sa6izslkbxij
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYNXTGgAKCRDj7w1vZxhR
xTyXAP47Y4K6eW3N6vvjFUW+yM9k81QO9KzQ7N76EXCc2A5WpwD8Dmpk3WLgstOC
2BdhlHll5iLXQFuHRMBy+cjU/xRwrwY=
=h9od
-----END PGP SIGNATURE-----

--vj77sa6izslkbxij--
