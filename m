Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E2E3BC7B3
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhGFITd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:19:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53999 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230257AbhGFITc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 04:19:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 538735C00B1;
        Tue,  6 Jul 2021 04:16:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Jul 2021 04:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=VRYFD5m0Gwl8PPRuEHr4ly+D+f2
        XRiXhGgldVWt78s4=; b=qXTHciXaMGQWSp89/9JThcTq4V3vJDWHTKlqom/+H2b
        o2qvQx1O/bNhVfqsx064Ht1Vjv5cOOVyDDpAV/f/oeKry63gGHz5rxtV8aiwxySH
        PdM1lu6NafFITsAQ/+t8WensNHwdyBut/t9Dm8/DjdZYox5z6nlJ1x3he8NMAzr1
        IHLfZN94Myo0yuWu3qrTAvqXVLIjkhbBiqaICEyI7ZgBn5iu0shOvSzZ7NAs8nlx
        V8Csb9SgOUbfj9XHR3mPFC8oUvXaOwHrmsvUKrL2Fj5c2ZS3OO25/hB+ReFsKDMS
        JuWOUbhQSDbBaUFSdOy0s17hHTvzxExzXLdGriELfNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VRYFD5
        m0Gwl8PPRuEHr4ly+D+f2XRiXhGgldVWt78s4=; b=IvlUIBF+aRZWSHZQCG4kbq
        aBzHItwLplFWbWnxkSXII7wFCqClusLsFTeZ7Ay4J+jBTafu/P4UwMfbgYC0beTA
        sCFhCWSNmj8x2KNlonJuXvL3+4t2sNk+byp/gwiHdiT/VCJBC7+dWIyG5ZaqwVu3
        DOWL7gEM9o88ZTNpPH9PGprzEKfOYRAXFr8dSC4pSVZZJQeOrqOznBMxTrq/os6O
        hxurtcNmQ57IaAN0NG7lJwbGrnsVh7xZ0ZfuCYIH0RJ/2JNocEiMUn1rlUfrLzHO
        Qpef1ZCsCzDUx0OMPCg/6qRGoIb7+wsHztCPTrZss4QkSW58DTmqqeI8fQFCPJcA
        ==
X-ME-Sender: <xms:dRHkYCF09dI1GsfsSyJEGC98Z3zQJymYKKT6Frq-UsU5-h6ZoK0G4A>
    <xme:dRHkYDU0Ok3egk8ERprZBq8rMPgWwYmr_vh_Ge2V_PkKv_f7Cy6Qym4yMg-NPExTa
    fQjo9oKSujaZUq62tU>
X-ME-Received: <xmr:dRHkYMIw7DrN689gD7mBnbWTVPhy5YfOfHYB_94m0TKLOmoxC3FWIJ5amWutECpirXx50ctxisuny8QwEXT8uE28cW4L1vVRTODq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihimhgvucft
    ihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtthgvrh
    hnpeelkeeghefhuddtleejgfeljeffheffgfeijefhgfeufefhtdevteegheeiheeguden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigih
    hmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:dRHkYMF6Gr439KAQ45V0merH45Pc0QiMu1ZrpifqcqAcoXNFRig7wQ>
    <xmx:dRHkYIVuv38Y5jyWajcekV4-3KQOAlPC61IxsbDcNorbeuYad-q6UA>
    <xmx:dRHkYPMoUBtnvk1kUIwWDcl1v522K71oLFtxzeV_VkK9BYFZXBAPAw>
    <xmx:dRHkYGxkRSFYRQ5MNgFRVcLriSL1QFumpROHLm1CYaLS9UlD2fEMww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jul 2021 04:16:52 -0400 (EDT)
Date:   Tue, 6 Jul 2021 10:16:51 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     nicolas saenz julienne <nsaenz@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel Panic in skb_release_data using genet
Message-ID: <20210706081651.diwks5meyaighx3e@gilmour>
References: <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
 <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
 <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
 <20210602132822.5hw4yynjgoomcfbg@gilmour>
 <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
 <20210625125906.gj45zykbemh5zzhw@gilmour>
 <0f0f41de-76ca-a9a2-c362-9b15dd47f144@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7hquxtca7e6vcpxt"
Content-Disposition: inline
In-Reply-To: <0f0f41de-76ca-a9a2-c362-9b15dd47f144@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7hquxtca7e6vcpxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

On Fri, Jul 02, 2021 at 09:49:31AM -0700, Florian Fainelli wrote:
> On 6/25/2021 5:59 AM, Maxime Ripard wrote:
> > Hi Florian,
> >=20
> > Sorry for the late reply
> >=20
> > On Thu, Jun 10, 2021 at 02:33:17PM -0700, Florian Fainelli wrote:
> > > On 6/2/2021 6:28 AM, Maxime Ripard wrote:
> > > > On Tue, Jun 01, 2021 at 11:33:18AM +0200, nicolas saenz julienne wr=
ote:
> > > > > On Mon, 2021-05-31 at 19:36 -0700, Florian Fainelli wrote:
> > > > > > > That is also how I boot my Pi4 at home, and I suspect you are=
 right, if
> > > > > > > the VPU does not shut down GENET's DMA, and leaves buffer add=
resses in
> > > > > > > the on-chip descriptors that point to an address space that i=
s managed
> > > > > > > totally differently by Linux, then we can have a serious prob=
lem and
> > > > > > > create some memory corruption when the ring is being reclaime=
d. I will
> > > > > > > run a few experiments to test that theory and there may be a =
solution
> > > > > > > using the SW_INIT reset controller to have a big reset of the=
 controller
> > > > > > > before handing it over to the Linux driver.
> > > > > >=20
> > > > > > Adding a WARN_ON(reg & DMA_EN) in bcmgenet_dma_disable() has no=
t shown
> > > > > > that the TX or RX DMA have been left running during the hand ov=
er from
> > > > > > the VPU to the kernel. I checked out drm-misc-next-2021-05-17 t=
o reduce
> > > > > > as much as possible the differences between your set-up and my =
set-up
> > > > > > but so far have not been able to reproduce the crash in booting=
 from NFS
> > > > > > repeatedly, I will try again.
> > > > >=20
> > > > > FWIW I can reproduce the error too. That said it's rather hard to=
 reproduce,
> > > > > something in the order of 1 failure every 20 tries.
> > > >=20
> > > > Yeah, it looks like it's only from a cold boot and comes in "bursts=
",
> > > > where you would get like 5 in a row and be done with it for a while.
> > >=20
> > > Here are two patches that you could try exclusive from one another
> > >=20
> > > 1) Limit GENET to a single queue
> > >=20
> > > diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > index fcca023f22e5..e400c12e6868 100644
> > > --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > @@ -3652,6 +3652,12 @@ static int bcmgenet_change_carrier(struct
> > > net_device *dev, bool new_carrier)
> > >          return 0;
> > >   }
> > >=20
> > > +static u16 bcmgenet_select_queue(struct net_device *dev, struct sk_b=
uff
> > > *skb,
> > > +                                struct net_device *sb_dev)
> > > +{
> > > +       return 0;
> > > +}
> > > +
> > >   static const struct net_device_ops bcmgenet_netdev_ops =3D {
> > >          .ndo_open               =3D bcmgenet_open,
> > >          .ndo_stop               =3D bcmgenet_close,
> > > @@ -3666,6 +3672,7 @@ static const struct net_device_ops
> > > bcmgenet_netdev_ops =3D {
> > >   #endif
> > >          .ndo_get_stats          =3D bcmgenet_get_stats,
> > >          .ndo_change_carrier     =3D bcmgenet_change_carrier,
> > > +       .ndo_select_queue       =3D bcmgenet_select_queue,
> > >   };
> > >=20
> > >   /* Array of GENET hardware parameters/characteristics */
> > >=20
> > > 2) Ensure that all TX/RX queues are disabled upon DMA initialization
> > >=20
> > > diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > index fcca023f22e5..7f8a5996fbbb 100644
> > > --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > @@ -3237,15 +3237,21 @@ static void bcmgenet_get_hw_addr(struct
> > > bcmgenet_priv *priv,
> > >   /* Returns a reusable dma control register value */
> > >   static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
> > >   {
> > > +       unsigned int i;
> > >          u32 reg;
> > >          u32 dma_ctrl;
> > >=20
> > >          /* disable DMA */
> > >          dma_ctrl =3D 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA=
_EN;
> > > +       for (i =3D 0; i < priv->hw_params->tx_queues; i++)
> > > +               dma_ctrl |=3D (1 << (i + DMA_RING_BUF_EN_SHIFT));
> > >          reg =3D bcmgenet_tdma_readl(priv, DMA_CTRL);
> > >          reg &=3D ~dma_ctrl;
> > >          bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
> > >=20
> > > +       dma_ctrl =3D 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_=
EN;
> > > +       for (i =3D 0; i < priv->hw_params->rx_queues; i++)
> > > +               dma_ctrl |=3D (1 << (i + DMA_RING_BUF_EN_SHIFT));
> > >          reg =3D bcmgenet_rdma_readl(priv, DMA_CTRL);
> > >          reg &=3D ~dma_ctrl;
> > >          bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
> >=20
> > I had a bunch of issues popping up today so I took the occasion to test
> > those patches. The first one doesn't change anything, I still had the
> > crash occurring with it. With the second applied (in addition), it seems
> > like it's fixed. I'll keep testing and will let you know.
>=20
> Did this patch survive more days of testing? I am tempted to send it
> regardless of your testing because it is a correctness issue that is being
> fixed. There is a global DMA enable bit which should "cut" any TX/RX queu=
es,
> but still, for symmetry with other code paths all queues should be disabl=
ed.

Unfortunately, I haven't spent too much time working on mainline
recently, so I didn't really have the occasion to test further that
patch.

It seems to make sense anyway like you said, so you can definitely send
it, with my Tested-by :)

Maxime

--7hquxtca7e6vcpxt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYOQRcwAKCRDj7w1vZxhR
xTCWAP9+YY50v6lyWO89cHcdW90R6nOflZNYOW+V1mW/Lm60kgD+L9O59GeCVcac
kQoXvHBeHif7dIDEgxvLCmAVDFo/7Ao=
=GZNB
-----END PGP SIGNATURE-----

--7hquxtca7e6vcpxt--
