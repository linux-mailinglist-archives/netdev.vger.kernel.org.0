Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B340BE86A
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 00:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbfIYWq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 18:46:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46774 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfIYWq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 18:46:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so154247wrv.13;
        Wed, 25 Sep 2019 15:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CEZdOX21rmjotp8jx0GVHCSCIrQmoVSTc0h3cKmO9YI=;
        b=mAoIXKqv8lB4MLmARHSy55VTPRFCAfx3/MA+JH4eHdRrP76KU+gHoVHQRaA4KgzPl1
         r0yy2exr0YGZhFepeiJSlV+ypdpghONw2kbuLDwjkwQlvvIfNqoJY+rAZeofGoX2HRTC
         szPfPDrmKIBUuEWJEvQcPUFZjmqaZEFlQ1Haf5wau32PDnZxS7qb6nsH0i9yPrOt7dzy
         4G0ddYPFkfRrqcyQOu7ZrzEnk5fn220KuDZUuiPj/00HSbOsB4mBZSzlgQQQf+V5sgfd
         B6BZlioYmAFPMjRInAmpXm9QKN4mjTIauSYfG36EoRNMfOcffcHmIfEJHl37WEXP133c
         3nIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CEZdOX21rmjotp8jx0GVHCSCIrQmoVSTc0h3cKmO9YI=;
        b=HeweWuQjnpvmtPAI/vctbCnEefzwJz8RTigD327DEC6LhNOa7APMuwVDiGfTqVY6RT
         mKi8y1hieIkDgBVrs0RWLDCvwzmd/q59zEofbrx6rhjNRbXs95ZQh0tNec0kqc9mttXs
         p65Zo6Dmgqt2N9w31pmzqHwSGLbMNeYLA3tBhoCMdYIjCKawpwBt3LOVfi1l3XElzIlw
         v+93P1o6F260yUPOE3Mwmt9XclohILxeYXuqD9iYz2SJltKEtYHubziZkoiu08mz8eS9
         MORv9J9SQsFhmirEpQd4aXtWPIC5w1MnNPhgZYy30ZCPJri5x4AiXXnp7zoedQTIfryP
         YrFQ==
X-Gm-Message-State: APjAAAVne72BE646cCFProtHYetz+btNhuPXC1cf5Xcdgk16Rw9pfrOf
        4ELq98zjg8ictAuwAxuKAgw=
X-Google-Smtp-Source: APXvYqyZMYYmQIAhprS8+pJka6zOV+MlQMWnqkvuRIE65XzmSLqUvmqJ1+id3dbCtzsgDMYrwuTqig==
X-Received: by 2002:a5d:6a09:: with SMTP id m9mr443268wru.12.1569451583600;
        Wed, 25 Sep 2019 15:46:23 -0700 (PDT)
Received: from localhost (p200300E41F0FEE00021F3CFFFE37B91B.dip0.t-ipconnect.de. [2003:e4:1f0f:ee00:21f:3cff:fe37:b91b])
        by smtp.gmail.com with ESMTPSA id b22sm325037wmj.36.2019.09.25.15.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 15:46:21 -0700 (PDT)
Date:   Thu, 26 Sep 2019 00:46:20 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "bbiswas@nvidia.com" <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
Message-ID: <20190925224620.GA8115@mithrandir>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
 <20190924.214508.1949579574079200671.davem@davemloft.net>
 <BN8PR12MB3266F851B071629898BB775AD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190925.133353.1445361137776125638.davem@davemloft.net>
 <BN8PR12MB3266A2F1F5F3F18F3A80BFC1D3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB32667F9FDDB2161E9B63C1AFD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <9f0e2386-c4b1-52b0-6881-e72093eb1b05@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <9f0e2386-c4b1-52b0-6881-e72093eb1b05@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2019 at 10:31:13AM -0700, Florian Fainelli wrote:
> On 9/25/19 4:46 AM, Jose Abreu wrote:
> > From: Jose Abreu <joabreu@synopsys.com>
> > Date: Sep/25/2019, 12:41:04 (UTC+00:00)
> >=20
> >> From: David Miller <davem@davemloft.net>
> >> Date: Sep/25/2019, 12:33:53 (UTC+00:00)
> >>
> >>> From: Jose Abreu <Jose.Abreu@synopsys.com>
> >>> Date: Wed, 25 Sep 2019 10:44:53 +0000
> >>>
> >>>> From: David Miller <davem@davemloft.net>
> >>>> Date: Sep/24/2019, 20:45:08 (UTC+00:00)
> >>>>
> >>>>> From: Thierry Reding <thierry.reding@gmail.com>
> >>>>> Date: Fri, 20 Sep 2019 19:00:34 +0200
> >>>>>
> >>>>> Also, you're now writing to the high 32-bits unconditionally, even =
when
> >>>>> it will always be zero because of 32-bit addressing.  That looks li=
ke
> >>>>> a step backwards to me.
> >>>>
> >>>> Don't agree. As per previous discussions and as per my IP knowledge,=
 if=20
> >>>> EAME is not enabled / not supported the register can still be writte=
n.=20
> >>>> This is not fast path and will not impact any remaining operation. C=
an=20
> >>>> you please explain what exactly is the concern about this ?
> >>>>
> >>>> Anyway, this is an important feature for performance so I hope Thier=
ry=20
> >>>> re-submits this once -next opens and addressing the review comments.
> >>>
> >>> Perhaps I misunderstand the context, isn't this code writing the
> >>> descriptors for every packet?
> >>
> >> No, its just setting up the base address for the descriptors which is=
=20
> >> done in open(). The one that's in the fast path is the tail address,=
=20
> >> which is always the lower 32 bits.
> >=20
> > Oops, sorry. Indeed it's done in refill operation in function=20
> > dwmac4_set_addr() for rx/tx which is fast path so you do have a point=
=20
> > that I was not seeing. Thanks for bringing this up!
> >=20
> > Now, the point would be:
> > 	a) Is it faster to have an condition check in dwmac4_set_addr(), or
> > 	b) Always write to descs the upper 32 bits. Which always exists in the=
=20
> > IP and is a standard write to memory.
>=20
> The way I would approach it (as done in bcmgenet.c) is that if the
> platform both has CONFIG_PHYS_ADDR_T_64BIT=3Dy and supports > 32-bits
> addresses, then you write the upper 32-bits otherwise, you do not. Given
> you indicate that the registers are safe to write regardless, then maybe
> just the check on CONFIG_PHYS_ADDR_T_64BIT is enough for your case. The
> rationale in my case is that register writes to on-chip descriptors are
> fairly expensive (~200ns per operation) and get in the hot-path.
>=20
> The CONFIG_PHYS_ADDR_T_64BIT check addresses both native 64-bit
> platforms (e.g.: ARM64) and those that do support LPAE (ARM LPAE for
> instance).

I think we actually want CONFIG_DMA_ADDR_T_64BIT here because we're
dealing with addresses returned from the DMA API here.

I can add an additional condition for the upper 32-bit register writes,
something like:

	if (IS_ENABLED(CONFIG_DMA_ADDR_T_64BIT) && priv->dma_cfg->eame)
		...

The compiler should be able to eliminate that as dead code on platforms
that don't support 64-bit DMA addresses, but the code should still be
compiler regardless of the setting, thus increasing the compile
coverage.

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl2L7jgACgkQ3SOs138+
s6E85A//TUkBCR3yGIWSlP9JU9/6nlGvQO3HX7K6NEPTfgXEotbcKqS6AbfEBIfO
/tZZYX4n5CzdNi7MRt80D/H5BiTbQsEGskXBWrTHxWbtRuMyjWVdjBp3wB/BFouJ
HVcCDecT5RNz6yIWUD980FXMjviYYXjTjzTUjFCPRg0Kn+Cm1mu8RgEULQb9EzFl
YJ1WgzK8w+Q0taHrSPh8nJRszpXaqIOSw2YJprS5RW6lnzJfUp02ejjqwzGfVgUO
CqGu9J7auKI+aXQioPCmqRXGj2rIf9pWT4ihiq0gGyhiE5jqQTKTUsugmc4UxuDM
xD4yz01/+zfXvAG9dn+eEWiO3l676r5J4ph38gUh9O9vwEHh3G4bA/Kbfd1Zg70e
A6G0vGn8WbMRbOpliBkU5pHpTKng6eczGycHUBc0YuJBTHMfSYA8+uG03pIm6kbe
rZR0N6aw54m1W7uYoU0JKm+taInOpOpFguEIfxSorKJikZw29qBWysE+8Dzw1yW2
ufCmL4FOFuw59w3JpCKQ7Sk1laPKwacdCi8ieGOlqEds4/FM/Yl7CV3AxbV0VyLg
fmJSRTPQ++oDh6wohqQL6UQWj6+4b1rnhwb6jJyTFR81o3t3yLYplNm5NLk9Kbi7
1eMLurX/fO1JCJNsmix2jBqV0yO152teT0xHUb1buBwJSCasSyI=
=+uVD
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
