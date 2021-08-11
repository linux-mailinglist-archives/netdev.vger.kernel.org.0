Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F119B3E8ED6
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 12:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhHKKkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 06:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbhHKKkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 06:40:01 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F13DC061765;
        Wed, 11 Aug 2021 03:39:38 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so153712wma.0;
        Wed, 11 Aug 2021 03:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ymQA2hHz+rJD9SJ7VV0dm8wNzfeebhRbADCOnx38kfE=;
        b=ha0y0LkvLGzSCID92+weZcfSCpO2QSCBqSBF8ngmenW6aNq8uEOFeN/SWmOJXM9q6L
         HzNEM0XRm+T/6a8cDfdSIm9l96X9V5JMJAKj48n2Et0m81QeGMOKWzfaYf6VZqE0U1vE
         uPoyL9B4zhZ0LKC6D8w43W7i+klOHrTDfYoxPi+z6eyeq3Ii/2hkRxLqdrTvtYx2bJb5
         e0O65+n+Z0T2u8PORVYA1Ra9RzmUB32ESDJZwbIBVU2R6/VD48VsUYcO0b+/xiFCeDkX
         TdJxmCl5WXpgXGWYarhTVUzDsxlb2HhwTBh0tTxo/Qy2inYN23egtf3evgkFuNE6+pRD
         nwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ymQA2hHz+rJD9SJ7VV0dm8wNzfeebhRbADCOnx38kfE=;
        b=t/epGDvSwuMs9wDJgIRlzmN8VYugERganvH+fR9yD0bk+UwrOKX0G2/57bSrSAlLwH
         7bGaBkI2JNjA/9/1R5GlSNtCTV/NwQ/0vFH/Y2dkvwWm7cnXjyszApdLkE/z3DEzU2gJ
         VJzqloibQrP9Q0z0vHpcHt0cPkFzeOaW9SvQg3SEp/mD7uh461lFL1kcemBY5is/Y+Cn
         jSh6JMc0+RF8+3KNhklWWBnxx9NEnp7VOMhWlRTIQaR59RZRqaC3Qt+t9Od3iSDxjRPu
         BR3gwgmzHjsID4Hw3CVW6BVn8Byw3HlTnVvKKIXV1K2dmBXwumdVnc2HW/oS16BWzkNy
         hoqg==
X-Gm-Message-State: AOAM532vbMkxTlE6O2NeHThhpmdzZL8mGStJ0TsmvP0lYzJVqaT3k2++
        oFUyu9VqLe5PFEP7wsoMFlc=
X-Google-Smtp-Source: ABdhPJwnHXcd2JgwGMgS0CK0TG6AlpvrBdA68ua69ts8fe3ees0AYc9r8yx7FLdaRYbdsNmGF5pJDw==
X-Received: by 2002:a05:600c:4ed2:: with SMTP id g18mr4664530wmq.140.1628678376110;
        Wed, 11 Aug 2021 03:39:36 -0700 (PDT)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id k186sm6726628wme.45.2021.08.11.03.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 03:39:34 -0700 (PDT)
Date:   Wed, 11 Aug 2021 12:41:59 +0200
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
Message-ID: <YROpd450N+n6hYt2@orome.fritz.box>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w9GKWoBivj0rdXcy"
Content-Disposition: inline
In-Reply-To: <871r71azjw.wl-maz@kernel.org>
User-Agent: Mutt/2.1.1 (e2a89abc) (2021-07-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w9GKWoBivj0rdXcy
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

One other thing that kind of rings a bell when reading DMA and
interrupts is a recent report (and attempt to fix this) where upon
resume from system suspend, the DMA descriptors would get corrupted.

I don't think we ever figured out what exactly the problem was, but
interestingly the fix for the issue immediately caused things to go
haywire on... Jetson TX2.

I recall looking at this a bit and couldn't find where exactly the DMA
was being synchronized on suspend/resume, or what the mechanism was to
ensure that (in transit) packets were not received after the suspension
of the Ethernet device. Some information about this can be found here:

	https://lore.kernel.org/netdev/708edb92-a5df-ecc4-3126-5ab36707e275@nvidia=
=2Ecom/

It's interesting that this happens only on Jetson TX2. Apparently on the
newer Jetson AGX Xavier this problem does not occur. I think Jon also
narrowed this down to being related to the IOMMU being enabled on Jetson
TX2, whereas Jetson AGX Xavier didn't have it enabled. I wasn't able to
find any notes on whether disabling the IOMMU on Jetson TX2 did anything
to improve on this, so perhaps that's something worth trying.

We have since enabled the IOMMU on Jetson AGX Xavier, and I haven't seen
any test reports indicating that this is causing issues. So I don't
think this has anything directly to do with the IOMMU support.

That said, if these problems are all exclusive to Jetson TX2, or rather
Tegra186, that could indicate that we're missing something at a more
fundamental level (maybe some cache maintenance quirk?).

Thierry

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

--w9GKWoBivj0rdXcy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmETqXQACgkQ3SOs138+
s6FahhAAwUgDWNskZhlCOE5XS+z1+QlxbTaxOr/oMQPnrcgSs9v7Fq3qOnY+bPy7
Xp15CY5aHjKFStZTuS/3jOkt8tdqzHdgfDoOM9OJ45csUXjj6opR3Loc/aq4W5Xe
/TAiJfjp3HZtn0GGJfrxaYKFDyyR25lGvouWDlT6W2+DKODu0KA5Yx99FytBXVi0
rtjzSUtJftG0sQM3t53tB8Z8hjjcimwNFmvv3DDmHbLfQFFtvb6HUKOT3XiXxhqE
O7bQzxtUuzWs5U4OG9pTUTyTKbXIrdL8zNad2SGFbi/nA1OVSD0t2FKEbvAzewqv
r69ZOmqg+GnpXgtOCx+tqYkWc4PX65pFnb1ES6tTENb+bOCxyrzTbcAtHZf03gFf
cjanvPZXo3jZqdmscRblcRM9iwO48KYtZqoi/ZEP1iLOV/z99TILd9RST0E1Lmsa
gHmdjpe7kQ/6uGu0OXN2CUqqpBycT7MVX7S9If+IgmNx04biVJlR+azfD7W3yoU5
y7HqFqR4OShCDh4bVzkBzPqCv8TQUH/qD78LbGkmtARQNj679D7QkHNPzjv/QMrU
sDCt7idaOWZXz0GaKn9/Uv55lNdfagrLkNG/WIhiwCUEPsbXuHgKcZVlxABq9t/V
ua5XmcI5wHo5nr4jlUxZG9YPgR0H6GWXMRa4q3hpeUaeq34KhSw=
=BYku
-----END PGP SIGNATURE-----

--w9GKWoBivj0rdXcy--
