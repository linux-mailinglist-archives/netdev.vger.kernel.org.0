Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069D8AEC61
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbfIJNyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 09:54:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39489 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIJNyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:54:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so20455051wra.6;
        Tue, 10 Sep 2019 06:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8y5zl/FvVcCr/c4MWWRIXbl+ZBX3AwIpnBzmyoFPjrs=;
        b=Mur0Z29yZ/pc6eZ3STsSP1j/AZgf6Op9pA0u8aMqXMvuNAdich/xs/ADaPqGc6/VSc
         yp1OwSlxS3SFgTSOIVYQWOt1Woe+s/5V4joqIYXQm+RAhE006XcvH7vgMd/gq7vE4DYs
         fQ/0I/ZIVgTYVYSvqiNycR+oWSU46YDT0yLfUMpWr78DD4qQMZmcPkJCaL9KVa3YrZ4O
         gdq5+TF6fgkwxQPFGIOp/wvd1BYboZHw1uo6hHl7PO4JgNWqe2d+0f0wOpjGSW8Lwbdb
         5ot9YnhQpvwHbkyvDc91jlNyXsc9Wxqt05Hzh5PJztxlMA2dAcoc/gSU+5CXAl12HG4K
         cfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8y5zl/FvVcCr/c4MWWRIXbl+ZBX3AwIpnBzmyoFPjrs=;
        b=qTvFaG634Sc1dhW5ShH+mVPAYOJa066cW5ruu0+x48yBMman5HcfYJwEl9U6IFnQ0y
         Ib9euzGkeS2dDHusGbZgYMxBCAnDVKLD8URFB80vT6Slv8HwT93VmTJF4JtqBK+DTR5K
         9pwnT9dH/gDZCaLZDHnhvigcTjjMc8rGrR8Lve1a0BDAQFrfdODJuXv88WnvJDY5YYjL
         COgISXNGEKy5CIYnkc95lyXXrXoxs9b3EEsopP+3HrC4cvcQo6ZIr8uAMYCyObfqzXD0
         9WLU7t42eKJQxP3f7GhDd71gHxLOHXZdmwXw5C+dsgJKiXj3hvOlHu7cHW+7CXD4AbYY
         AHbw==
X-Gm-Message-State: APjAAAVyq6MkjmZ9vOII56TEH8fFjIlmoJ1Qxe7fi1s5e611l/1LbtjN
        9rHadJxGfaGMi5/9LlJGkeE=
X-Google-Smtp-Source: APXvYqzBZrUbstKl7F1E3GYnRZATymo9Q+Zfs02JXaH+RkkNQXTXQaSAiK7xI4bVlJgV2ZxFNu3kHw==
X-Received: by 2002:adf:f601:: with SMTP id t1mr26555774wrp.36.1568123669918;
        Tue, 10 Sep 2019 06:54:29 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id c74sm2811187wme.46.2019.09.10.06.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 06:54:28 -0700 (PDT)
Date:   Tue, 10 Sep 2019 15:54:27 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced
 addressing mode when needed
Message-ID: <20190910135427.GB9897@ulmo>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <BN8PR12MB3266B232D3B895A4A4368191D3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190909191127.GA23804@mithrandir>
 <BN8PR12MB3266850280A788D41C277B08D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266850280A788D41C277B08D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2019 at 08:32:38AM +0000, Jose Abreu wrote:
> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Sep/09/2019, 20:11:27 (UTC+00:00)
>=20
> > On Mon, Sep 09, 2019 at 04:07:04PM +0000, Jose Abreu wrote:
> > > From: Thierry Reding <thierry.reding@gmail.com>
> > > Date: Sep/09/2019, 16:25:45 (UTC+00:00)
> > >=20
> > > > @@ -92,6 +92,7 @@ struct stmmac_dma_cfg {
> > > >  	int fixed_burst;
> > > >  	int mixed_burst;
> > > >  	bool aal;
> > > > +	bool eame;
> > >=20
> > > bools should not be used in struct's, please change to int.
> >=20
> > Huh? Since when? "aal" right above it is also bool. Can you provide a
> > specific rationale for why we shouldn't use bool in structs?
>=20
> Please see https://lkml.org/lkml/2017/11/21/384.

The context is slightly different here. stmmac_dma_cfg exists once for
each of these ethernet devices in the system, and I would assume that in
the vast majority of cases there's exactly one such device in the system
so the potential size increase is very small. On the other hand, there
are potentially very many struct sched_dl_entity, so the size impact is
multiplied.

Anyway, if you insist I'll rewrite this to use an unsigned int bitfield.

Thierry

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl13qxAACgkQ3SOs138+
s6Gtlw/+PebnFYt7gpCYJwV+uclDuC52tBtJfP3xyipRbTfKpM01hAZ66jlbMHXo
biTf5b5Xy6PBS7aIQcDWakm4J853T9n/4maQK5whR//YTCh0Gf2h+68WoB1IdnYW
lRAYLk/knUUE6hHVG0HFKEc8WuCR+4vEOvT4K8odKqBzv0xdj2lhpvtOOisWenAz
sf5qVUDXTGgCrB3ofBA1ZOzWaLDAA+961v1mQyLv35/Qayix1xRkI2mFHSGwlqzG
UiQtQiPd5c56TKKk1GLjzaE/dtst0DGCpeMnAeZAw6DZPGjrfId3OmsZP2VZMUAC
5+t9UDKDVWyS9HL2iRYAwa6YRXRBBJ1gAzaDwTf2RHSal37qU2PbgGQRtjtDJft4
yUW+uk32XQ6qD70jFmSoO/2pA5izBeuquKtJG8HVdM+FiayuYAg8SKX541Z55+Xs
yehBhr0A+Z9jyq07wPuKqp7rez3KH+IyDZ4eyyEbUmOqqG1ZNOG4s5c4FfwMA8Cp
+CQSQ13D2QWj54TeXVf6lyRU5Vhm2gPZHv3ahwB2s6yGc8V5E4DbNH47DoKAbzGY
mh2gA6MhDIlNS7v4ZeVthhwmbq6dWYXz46Dlc7Y0GgvHF9MkHXmip3Aq0ndXSF36
SMfu5YkcPIAbLpFqj2H/jA53sAPi33iyeXqkNacZUm7npf13NcU=
=mn/8
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
