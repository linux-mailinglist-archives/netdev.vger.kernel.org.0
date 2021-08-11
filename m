Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793183E8E95
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 12:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhHKK0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 06:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbhHKK0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 06:26:10 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F56C061765;
        Wed, 11 Aug 2021 03:25:46 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q11so2304055wrr.9;
        Wed, 11 Aug 2021 03:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=poD4yJ/4qKvPMZwA0eL/IpVknURnkw2HP2HyOGJX1/c=;
        b=VRwUa98g/jNOHgolhsmWJpnp+3HHGhuSlXN42pvWXGXqplB8zie7xRIWvAsfQMo0fm
         4PqjDRpmFZxGLxtEFzTdocajMqV9+Nw7ZLdDHVNU0EXEKpJHhDlSFPrC+l7yDPf2MKop
         pzp0v+15tQnayMq+CZn0HxepBxFhbz6CCF4utUiQDy96UOBtG52JGa15iOF6oJo/85fW
         KVcQZUf5j0S8LcAZqmFRqqKIa3lYdRNrjXKeXU25g2ZmXHs7DNFXv850FHrqMbUmVeSg
         ZXr2vDnx4BlODPy3PAk9kD0soFm3IESoZ2ZjcgLswFRCRMGJuxU3EdvMiWd1V4L4nPMK
         2HrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=poD4yJ/4qKvPMZwA0eL/IpVknURnkw2HP2HyOGJX1/c=;
        b=M6YtTFGxbemVgqsdUObb2SBqMfLeMcnVCyIq9mSba9BPEx7FrxTgbatwINr4WVDKnP
         jWURNDw+J4ScRuwKr6f5ZX5RuaauNb5j+CdLSLYd5o1pImuqPDNagDYiaTi686Laj0HO
         71xFPerbJ1HmDqdsWJTkkkTgW18wU4cfRb6VDfsfdJI6UYv9WV/7BTkCzpYRdu3bEaMa
         Q/YrJmzNxsz0pOsSujIcW0MKlywlsN8Nz2RCPmm4qbjchvu+EpLTuSk9PZHmnBVZF2LT
         9Eh95ScClwZcrEqba4hdzmxkWgwPRjhFsuEED0afFVW4gt+AERwE2aDlAoVOWm+z1JC2
         gjMg==
X-Gm-Message-State: AOAM5328odRn21i25GhY2LpaJKP68c9nVS9oPGMP2v571y4qbsXc3YwP
        iKZj9ydnTKnyh9g6wClK5DM=
X-Google-Smtp-Source: ABdhPJx/OVwCCR5GEZWwYZdFNS936Tx9PO+z20xUhoLro+EHeMqsO7igz7VXtNuz1NJ7/oOjKyIV0Q==
X-Received: by 2002:adf:e0d1:: with SMTP id m17mr35220361wri.233.1628677545106;
        Wed, 11 Aug 2021 03:25:45 -0700 (PDT)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id 9sm23757021wmf.34.2021.08.11.03.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 03:25:43 -0700 (PDT)
Date:   Wed, 11 Aug 2021 12:28:09 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH net-next] stmmac: align RX buffers
Message-ID: <YROmOQ+4Kqukgd6z@orome.fritz.box>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LpFoc4PPAZtVVu++"
Content-Disposition: inline
In-Reply-To: <871r71azjw.wl-maz@kernel.org>
User-Agent: Mutt/2.1.1 (e2a89abc) (2021-07-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LpFoc4PPAZtVVu++
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 10, 2021 at 08:07:47PM +0100, Marc Zyngier wrote:
> Hi all,
>=20
> [adding Thierry, Jon and Will to the fun]
>=20
> On Mon, 14 Jun 2021 03:25:04 +0100,
> Matteo Croce <mcroce@linux.microsoft.com> wrote:
> >=20
> > From: Matteo Croce <mcroce@microsoft.com>
> >=20
> > On RX an SKB is allocated and the received buffer is copied into it.
> > But on some architectures, the memcpy() needs the source and destination
> > buffers to have the same alignment to be efficient.
> >=20
> > This is not our case, because SKB data pointer is misaligned by two byt=
es
> > to compensate the ethernet header.
> >=20
> > Align the RX buffer the same way as the SKB one, so the copy is faster.
> > An iperf3 RX test gives a decent improvement on a RISC-V machine:
> >=20
> > before:
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec   733 MBytes   615 Mbits/sec   88             s=
ender
> > [  5]   0.00-10.01  sec   730 MBytes   612 Mbits/sec                  r=
eceiver
> >=20
> > after:
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  1.10 GBytes   942 Mbits/sec    0             s=
ender
> > [  5]   0.00-10.00  sec  1.09 GBytes   940 Mbits/sec                  r=
eceiver
> >=20
> > And the memcpy() overhead during the RX drops dramatically.
> >=20
> > before:
> > Overhead  Shared O  Symbol
> >   43.35%  [kernel]  [k] memcpy
> >   33.77%  [kernel]  [k] __asm_copy_to_user
> >    3.64%  [kernel]  [k] sifive_l2_flush64_range
> >=20
> > after:
> > Overhead  Shared O  Symbol
> >   45.40%  [kernel]  [k] __asm_copy_to_user
> >   28.09%  [kernel]  [k] memcpy
> >    4.27%  [kernel]  [k] sifive_l2_flush64_range
> >=20
> > Signed-off-by: Matteo Croce <mcroce@microsoft.com>
>=20
> This patch completely breaks my Jetson TX2 system, composed of 2
> Nvidia Denver and 4 Cortex-A57, in a very "funny" way.
>=20
> Any significant amount of traffic result in all sort of corruption
> (ssh connections get dropped, Debian packages downloaded have the
> wrong checksums) if any Denver core is involved in any significant way
> (packet processing, interrupt handling). And it is all triggered by
> this very change.
>=20
> The only way I have to make it work on a Denver core is to route the
> interrupt to that particular core and taskset the workload to it. Any
> other configuration involving a Denver CPU results in some sort of
> corruption. On their own, the A57s are fine.
>=20
> This smells of memory ordering going really wrong, which this change
> would expose. I haven't had a chance to dig into the driver yet (it
> took me long enough to bisect it), but if someone points me at what is
> supposed to synchronise the DMA when receiving an interrupt, I'll have
> a look.

I recall that Jon was looking into a similar issue recently, though I
think the failure mode was slightly different. I also vaguely recall
that CPU frequency was impacting this to some degree (lower CPU
frequencies would increase the chances of this happening).

Jon's currently out of office, but let me try and dig up the details
on this.

Thierry

>=20
> Thanks,
>=20
> 	M.
>=20
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net=
/ethernet/stmicro/stmmac/stmmac.h
> > index b6cd43eda7ac..04bdb3950d63 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > @@ -338,9 +338,9 @@ static inline bool stmmac_xdp_is_enabled(struct stm=
mac_priv *priv)
> >  static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
> >  {
> >  	if (stmmac_xdp_is_enabled(priv))
> > -		return XDP_PACKET_HEADROOM;
> > +		return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
> > =20
> > -	return 0;
> > +	return NET_SKB_PAD + NET_IP_ALIGN;
> >  }
> > =20
> >  void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue);
> > --=20
> > 2.31.1
> >=20
> >=20
>=20
> --=20
> Without deviation from the norm, progress is not possible.

--LpFoc4PPAZtVVu++
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmETpjYACgkQ3SOs138+
s6FzpRAAqwF1hrrbcKXot3GUKC45t/3TCFrELCjzW4CqTpHhhxWPhEA1F7P7TKiU
iTOLQO2Gj68Lek6KaistNi6hPdmRdh91mr1qLi8ORq94uquX9j+2Vgq7Iwb+qltE
eKtaNUoSc5bnh5xUvKj87UVMSn690+LelT6lRiyIzghdk8Pt0RcM9UWbtL5g1VVq
paYq7o96j3xkiY/QO+SXOObhMH4yH8ew2cQiIvUBYQnQGN7bi1jqvK11MVvZhpFq
YyxO6SNacXjqKYUL3UDQ2o4k7dMX3HeLBDG/VTOG5FSGcSWZ5eNdaJhRc4Muy70h
NewtkD6tAAqXjv/LugbgL2BiPt0PyZFiyACVTbClunCn+70yvpRdTSCHw2dzC1d3
HYK3Um2yVrL6NLBEZaaSb6rX6CM6qom8OzbRPZcNQo3Xho0Cav+Ng2fRaR6a0zc7
+tvKZ9dSxsQy2SvLaeMvF/ECc0M1Kwv98nhpXMhrPKuZCvC2UM/nrqqkm5EyQguT
xezuFk1x63wDH5oBBeyzEniD9sa+Uht1ehoTwiw0tI+CAFSlqv0ySljWhnn6MNqO
zwR/WPmZE1zjgqjcKUJ2NnQ97ua3DSs6H6yQK+24KEFJr9wbOmQWOanYYscWIZNf
4GiAvgpNP4z3f2QJ8wxlesr/oGLvhDVvmcXl9x2zmrAFHz7xLA0=
=PCp2
-----END PGP SIGNATURE-----

--LpFoc4PPAZtVVu++--
