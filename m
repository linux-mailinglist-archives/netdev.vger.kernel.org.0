Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841D0ADF3A
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 21:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbfIITNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 15:13:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45679 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732594AbfIITNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 15:13:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id l16so15316434wrv.12;
        Mon, 09 Sep 2019 12:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EtjT9krkvQVip1GWh+seq/qOERbt+UkK3wD01Yg2ZFg=;
        b=kxVr1/Hg35Cp44iNRnQUCAS08K9VFo4bedJz7CwrgJT1NaW3llESuddQl66c6Vr7WG
         MA/ov+QQTMsAFEscBF93a1M4GRhuELlmqZvfBW+Qa+dmrV37KdFTiFafgsxwnOnPCyRS
         u/45Y4AnffCr1c0/Wz0ch3awt8ULpekIRud6FJTurvQ7g6wHI4J9lEThBuLoMBhENKN3
         3WEFxf/eYgGcsRoI5zM/hY7LP32SaClg28lPzlYGgyJHdR8A6vIQ5CxYn6Y5DhxAP0H0
         hKEPvVaHq4OLGR9FkPH9TZ5vhfMpV4irMsvH7K1h4YNXuQr8apcWwUeHwVXpufOTjEx0
         mSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EtjT9krkvQVip1GWh+seq/qOERbt+UkK3wD01Yg2ZFg=;
        b=QBB9422MOc9SoiX2EbVJeukMtRT6647lpcN0wAeShdOmFsaHtiYckBoBirVTHbtSKO
         pHyin3FRiUJ28tqQ7kiXVJA4ufvyUMC+GC9H9ZV1zNarwvOPx9S39a7jEg7eeLMtqaFx
         aCaQavAdlo0UwoHjms3S8MDWS25encUlLeqts5sIRc3QUDWa4pacZfU9aO8Pejrjdlad
         v32qqMXMx/ysek+i3qoQuQccei7a93JgcGzGChEZlfCoQS8uiIacfeKSGhFdF1cxuKAt
         lVIy3rGf7YVhKsfx0xReQIXWgJxnyM9KsxCIz3WXkGCpUods0033jGO3Yz6qJHXRSrSH
         A4YQ==
X-Gm-Message-State: APjAAAU4Dgb/AtRXW1am/9oq5uBgv43HgQkqbzlbJRLL//dJaZioT3dM
        AMKVrpRKw79FwBhRfOLQJ9Y=
X-Google-Smtp-Source: APXvYqygJvOqFCAqeat55Yfx16OlTCafNbBdmOIw1pL8k21L1FX7un9aN9bQINaNsFdxxDRphGdFVw==
X-Received: by 2002:a5d:684a:: with SMTP id o10mr14630854wrw.23.1568056411652;
        Mon, 09 Sep 2019 12:13:31 -0700 (PDT)
Received: from localhost (p200300E41F12DF00021F3CFFFE37B91B.dip0.t-ipconnect.de. [2003:e4:1f12:df00:21f:3cff:fe37:b91b])
        by smtp.gmail.com with ESMTPSA id q15sm19151235wrg.65.2019.09.09.12.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 12:13:30 -0700 (PDT)
Date:   Mon, 9 Sep 2019 21:13:29 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
Message-ID: <20190909191329.GB23804@mithrandir>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <20190909152546.383-2-thierry.reding@gmail.com>
 <BN8PR12MB3266AAC6FF4819EC25CB087BD3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266AAC6FF4819EC25CB087BD3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2019 at 04:05:52PM +0000, Jose Abreu wrote:
> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Sep/09/2019, 16:25:46 (UTC+00:00)
>=20
> > @@ -79,6 +79,10 @@ static void dwmac4_dma_init_rx_chan(void __iomem *io=
addr,
> >  	value =3D value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
> >  	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
> > =20
> > +	if (dma_cfg->eame)
>=20
> There is no need for this check. If EAME is not enabled then upper 32=20
> bits will be zero.

The idea here was to potentially guard against this register not being
available on some revisions. Having the check here would avoid access to
the register if the device doesn't support enhanced addressing.

>=20
> > +		writel(upper_32_bits(dma_rx_phy),
> > +		       ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(chan));
> > +
> >  	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan=
));
> >  }
>=20
> > @@ -97,6 +101,10 @@ static void dwmac4_dma_init_tx_chan(void __iomem *i=
oaddr,
> > =20
> >  	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
> > =20
> > +	if (dma_cfg->eame)
>=20
> Same here.
>=20
> > +		writel(upper_32_bits(dma_tx_phy),
> > +		       ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(chan));
> > +
> >  	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan=
));
> >  }
>=20
> Also, please provide a cover letter in next submission.

Alright, will do.

Thierry

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl12pFkACgkQ3SOs138+
s6ETZA//e0WU5Hrb5t7pZZJ4aMic/ZLKBTWhpHFIWs2viAiezlw3okqBevLUWQ9s
UGS5OJgTsdpdSng+6PlL235LiIAAlvEMup3qwW3m4elEkxx4VrLcyH1S6AZabxZ4
F/ntmiJHDOLMNGQknuPqZhKcqTm7Ybci7MzRfYBZnQF+GNOBG7rld2CC0kYPV9mm
b58HEq+CdSnJE1u1531lt785PGkJVekNhr4FDP9nXTamvUcR9bHooK9C8qBf/I/U
TXG0lOKu2R3hvSJBnoAUffDboA2+Y0jZD/oZnjmsXzGU5YYvZgqxS95vObsDVZri
LwvDOkwG4X6tveTp74nc3gLoUScsKx4aNfYqlxmTCito8r8DGijEgVUOp7Fnhjcy
QxQ2D/VBb7AJSMa2xi22lYU1/FhCISFJQ6D0w7eCM95G/hlIdSRzzo2o1yXOFxKb
RvH7v7rsPDUzU8jDXtD86R5Dsea/TaFnPRM4kCQrCopXY8pQoR6YQ7xHmTp4remu
vP6BrZAk20ApsMD4G8KhPI5n0URKadOtN+bkWJrsBGaw8HLwR6ricq84j67Whibi
lmeDt+jCxPMCvRSHMrGnh3pha7Km7fto4QjtSq+ZJndfTuNeqxt1D68n9FNnxHGP
V2Ck0tGw31Ui629CrHaZQgqfpQb1swosPAUuK3AnuAnImkgMfws=
=kFia
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
