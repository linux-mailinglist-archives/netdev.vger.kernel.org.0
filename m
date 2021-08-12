Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D133EA697
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhHLO3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 10:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbhHLO3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 10:29:36 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C673C061756;
        Thu, 12 Aug 2021 07:29:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id u1so4699959wmm.0;
        Thu, 12 Aug 2021 07:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qpoQw7ROBD2SDYhp7w8oAKoITp7+F7cgw9T8lXSU+WI=;
        b=Or+KdJQXbxyaUXRVMyGr0pf4Syjb6koFTiIARM6UQIPnEPrPLVGKWW64JnWNAINmFe
         6/DF0W1gRaOBiPJHF+5V97Y7a+ThwmSMF1Nn43fTTNaNQuKNWmZaWJ8tZprQVkn5etDS
         DYrC8yaG+81PwN2zVg0FdzcIJ8icsN6GkXgOR6hEGzfKLka4tH4vibB4cxIpA30A/2E9
         ZTSXlO2Lk13uwuBOFi4SYQPWpLsZEr4pmTwUTVVPEo48dCi3DtAHU9C3XQn+c1j1Ujfb
         hpv4Reqq0UEjpxVkMCT5pzu+dUgPGCkuN43Sg7I9gB6UTrM+/kGwWEE0xVqjXgV1oRCe
         4xXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qpoQw7ROBD2SDYhp7w8oAKoITp7+F7cgw9T8lXSU+WI=;
        b=kVVEmf7UEYS23s0KBUwtglBn4/okJtSRCOXqj9ulGu9f+uH/swzIni/EYC3NZfJOXb
         DcQ3NfQs9Baza4eNrDMuSSghuEBPCDbryWT1N2lIZ+d4zS/rwR27CoB0KNWvIjMza+Ps
         Mw/ms2FBIANptEKC1mcYr4qH6eX5WoVBwszu/R5QvuB7YXtUNYB4xQfj8D3o2i0ZMb2p
         Yv+kPv4NJk0D+reaQ/5uMHiD9/oVT/IQ+bcEs+b3cPmFtMz+0pPQLAS3tuq95Eba19FR
         MbNoBqAp4TIuod9iCWnepAqxcAACV25G1R8ckqCLnKfB0seHLh6uelMnqQrSjO8EmoFX
         aLmg==
X-Gm-Message-State: AOAM5317Ar151FlkiCAJM5Znz71BuvEDJOOEsY54Xa0+S9pWm/f+O+W3
        lyOSs4Hq6Mcs08X3e1zZ63s=
X-Google-Smtp-Source: ABdhPJxCP+aCbPg0vRcVfr4udlDmGa5DWaXpmvqbmX/twmCLHWSHhjPME1TRPXHRN/PQY8yl18MU/w==
X-Received: by 2002:a1c:1b83:: with SMTP id b125mr734908wmb.54.1628778549751;
        Thu, 12 Aug 2021 07:29:09 -0700 (PDT)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id o34sm9095431wms.10.2021.08.12.07.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 07:29:07 -0700 (PDT)
Date:   Thu, 12 Aug 2021 16:29:06 +0200
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
Message-ID: <YRUwMjeQnXH5RfoB@orome.fritz.box>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org>
 <YROpd450N+n6hYt2@orome.fritz.box>
 <87pmuk9ku9.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sZiS2GUEevjWNuYE"
Content-Disposition: inline
In-Reply-To: <87pmuk9ku9.wl-maz@kernel.org>
User-Agent: Mutt/2.1.1 (e2a89abc) (2021-07-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sZiS2GUEevjWNuYE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 11, 2021 at 02:23:10PM +0100, Marc Zyngier wrote:
> On Wed, 11 Aug 2021 11:41:59 +0100,
> Thierry Reding <thierry.reding@gmail.com> wrote:
> >=20
> > On Tue, Aug 10, 2021 at 08:07:47PM +0100, Marc Zyngier wrote:
> > > Hi all,
> > >=20
> > > [adding Thierry, Jon and Will to the fun]
> > >=20
> > > On Mon, 14 Jun 2021 03:25:04 +0100,
> > > Matteo Croce <mcroce@linux.microsoft.com> wrote:
> > > >=20
> > > > From: Matteo Croce <mcroce@microsoft.com>
> > > >=20
> > > > On RX an SKB is allocated and the received buffer is copied into it.
> > > > But on some architectures, the memcpy() needs the source and destin=
ation
> > > > buffers to have the same alignment to be efficient.
> > > >=20
> > > > This is not our case, because SKB data pointer is misaligned by two=
 bytes
> > > > to compensate the ethernet header.
> > > >=20
> > > > Align the RX buffer the same way as the SKB one, so the copy is fas=
ter.
> > > > An iperf3 RX test gives a decent improvement on a RISC-V machine:
> > > >=20
> > > > before:
> > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > [  5]   0.00-10.00  sec   733 MBytes   615 Mbits/sec   88          =
   sender
> > > > [  5]   0.00-10.01  sec   730 MBytes   612 Mbits/sec               =
   receiver
> > > >=20
> > > > after:
> > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > [  5]   0.00-10.00  sec  1.10 GBytes   942 Mbits/sec    0          =
   sender
> > > > [  5]   0.00-10.00  sec  1.09 GBytes   940 Mbits/sec               =
   receiver
> > > >=20
> > > > And the memcpy() overhead during the RX drops dramatically.
> > > >=20
> > > > before:
> > > > Overhead  Shared O  Symbol
> > > >   43.35%  [kernel]  [k] memcpy
> > > >   33.77%  [kernel]  [k] __asm_copy_to_user
> > > >    3.64%  [kernel]  [k] sifive_l2_flush64_range
> > > >=20
> > > > after:
> > > > Overhead  Shared O  Symbol
> > > >   45.40%  [kernel]  [k] __asm_copy_to_user
> > > >   28.09%  [kernel]  [k] memcpy
> > > >    4.27%  [kernel]  [k] sifive_l2_flush64_range
> > > >=20
> > > > Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> > >=20
> > > This patch completely breaks my Jetson TX2 system, composed of 2
> > > Nvidia Denver and 4 Cortex-A57, in a very "funny" way.
> > >=20
> > > Any significant amount of traffic result in all sort of corruption
> > > (ssh connections get dropped, Debian packages downloaded have the
> > > wrong checksums) if any Denver core is involved in any significant way
> > > (packet processing, interrupt handling). And it is all triggered by
> > > this very change.
> > >=20
> > > The only way I have to make it work on a Denver core is to route the
> > > interrupt to that particular core and taskset the workload to it. Any
> > > other configuration involving a Denver CPU results in some sort of
> > > corruption. On their own, the A57s are fine.
> > >=20
> > > This smells of memory ordering going really wrong, which this change
> > > would expose. I haven't had a chance to dig into the driver yet (it
> > > took me long enough to bisect it), but if someone points me at what is
> > > supposed to synchronise the DMA when receiving an interrupt, I'll have
> > > a look.
> >=20
> > One other thing that kind of rings a bell when reading DMA and
> > interrupts is a recent report (and attempt to fix this) where upon
> > resume from system suspend, the DMA descriptors would get corrupted.
> >=20
> > I don't think we ever figured out what exactly the problem was, but
> > interestingly the fix for the issue immediately caused things to go
> > haywire on... Jetson TX2.
>=20
> I love this machine... Did this issue occur with the Denver CPUs
> disabled?

Interestingly I've been doing some work on a newer device called Jetson
TX2 NX (which is kind of a trimmed-down version of Jetson TX2, in the
spirit of the Jetson Nano) and I can't seem to reproduce these failures
there (tested on next-20210812).

I'll go dig out my Jetson TX2 to run the same tests there, because I've
also been using a development version of the bootloader stack and
flashing tools and all that, so it's possible that something was fixed
at that level. I don't think I've ever tried disabling the Denver CPUs,
but then I've also never seen these issues myself.

Just out of curiosity, what version of the BSP have you been using to
flash?

One other thing that I ran into: there's a known issue with the PHY
configuration. We mark the PHY on most devices as "rgmii-id" on most
devices and then the Marvell PHY driver needs to be enabled. Jetson TX2
has phy-mode =3D "rgmii", so it /should/ work okay.

Typically what we're seeing with that misconfiguration is that the
device fails to get an IP address, but it might still be worth trying to
switch Jetson TX2 to rgmii-id and using the Marvell PHY, to see if that
improves anything.

> > I recall looking at this a bit and couldn't find where exactly the DMA
> > was being synchronized on suspend/resume, or what the mechanism was to
> > ensure that (in transit) packets were not received after the suspension
> > of the Ethernet device. Some information about this can be found here:
> >=20
> > 	https://lore.kernel.org/netdev/708edb92-a5df-ecc4-3126-5ab36707e275@nv=
idia.com/
> >=20
> > It's interesting that this happens only on Jetson TX2. Apparently on the
> > newer Jetson AGX Xavier this problem does not occur. I think Jon also
> > narrowed this down to being related to the IOMMU being enabled on Jetson
> > TX2, whereas Jetson AGX Xavier didn't have it enabled. I wasn't able to
> > find any notes on whether disabling the IOMMU on Jetson TX2 did anything
> > to improve on this, so perhaps that's something worth trying.
>=20
> Actually, I was running with the SMMU disabled, as I use the upstream
> u-boot provided DT. Switching to the kernel one didn't change a thing
> (with passthough or not).
>=20
> > We have since enabled the IOMMU on Jetson AGX Xavier, and I haven't seen
> > any test reports indicating that this is causing issues. So I don't
> > think this has anything directly to do with the IOMMU support.
>=20
> No, it looks more like either ordering or cache management. The fact
> that this patch messes with the buffer alignment makes me favour the
> latter...
>=20
> > That said, if these problems are all exclusive to Jetson TX2, or rather
> > Tegra186, that could indicate that we're missing something at a more
> > fundamental level (maybe some cache maintenance quirk?).
>=20
> That'd be pretty annoying. Do you know if the Ethernet is a coherent
> device on this machine? or does it need active cache maintenance?

I don't think Ethernet is a coherent device on Tegra186. I think
Tegra194 had various improvements with regard to coherency, but most
devices on Tegra186 do need active cache maintenance.

Let me dig through some old patches and mailing list threads. I vaguely
recall prototyping a patch that did something special for outer cache
flushing, but that may have been Tegra132, not Tegra186. I also don't
think we ended up merging that because it turned out to not be needed.

Thierry

--sZiS2GUEevjWNuYE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmEVMC8ACgkQ3SOs138+
s6F9Yw/9E9gZHvI7VhZn9baPhe4hNuP43xeTAXU8P1lT9PKH/foYi9Wvq244k/C/
5GTFzB0EARGYN7ByWoiw1slb58kjlDKPYyTwAvRcvxG8Rv6ujAoXI2cDtMjRla8o
ues+vQL2QEdsIXsdccE65cg/zOO47HHVL311oQJSZClILL62+uPaht2m75NY4HbW
PFjvfx86W3+5UinKF/cSZT2HmHtZRE1RUMBZZWHMdv17u5B5GMRmv49YVsY2RyQ9
r+7Gank/kBcRbT34e5mwe0qg0PwkZmKyIV/7DSpuhKQ5u1DsA3mY33sXDczFvO2Q
zuqPoRWQmoq89EZscGmuiUt6CNOL/8hRWlUQb83QYa2gOKLZYKctwrXRLCyo6Auq
0au9vQO6kkEEsi6k+RF+6ou3K69QDjhcM8nMb3fWEWz24CXqRJ1on/ZyGfMejxjS
ZpPSKWBqfC3Tf0GyZSTv8T8tgWhRJ1xrKnxz/BcQigglNZEmvvU6dZ2bOgc3vHfZ
P4DBK+lEbp9qpxiPoTyX/1rZbwIkeKIatHeKH5sPST/bcT7rFgo5LTv6ImwOWOmC
3BfwJdjQ9O5pDBi8FGDUSBwqAtRj0OQrcvFVHQhLsW7gD910COC73EFxiPOCRlfU
ihVfqq+ZP+LJmRXLcMKrz4E17qFfNGmxLSrcMgNgAWDq6GxI87w=
=szNp
-----END PGP SIGNATURE-----

--sZiS2GUEevjWNuYE--
