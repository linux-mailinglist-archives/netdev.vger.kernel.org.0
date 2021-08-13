Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3E63EB6EE
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 16:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240785AbhHMOos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 10:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbhHMOos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 10:44:48 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6FEC061756;
        Fri, 13 Aug 2021 07:44:21 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id f10so3920088wml.2;
        Fri, 13 Aug 2021 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2GEjq99Ivf3hy+n7EUR2s2FJOrTklvp8lMkzGzLSlp0=;
        b=Y8zwNcjCx+h1UdumUaPu7pesQBDoZN92clH1u7JNjfchXUBltzO6Hq+tMpwDWkK8CI
         CCS/tCK+Ay9RsGm0H+A6e7/HA/lqoobcBHjX9E25NOklGJM3Lme/K5pkdpGMD2WcE8gF
         8oLdDR5YP72ZPME54YtfI+LyoCYfKE/0nXX2wS6Z/PNXrV9kaMjpok1aqt9tzKdU2FmU
         nNKke3J71Skwe3UdJSa0PoOp9bpti9tRoxQoc8eRa2BNemU0k2okytWpYtCtJP6Fx7HD
         oUeEfZkMifpB9rafuECHy5e/H4wZdv7BQn/94xcsnhotMtEXtLadrH0Hs+GP9zx8BZ4n
         gbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2GEjq99Ivf3hy+n7EUR2s2FJOrTklvp8lMkzGzLSlp0=;
        b=CA43NQyTchcpAp/rwqX+iKV0E7qe4NFQscL7ovdS1AD8wz2vtzWYPPFS5Vz/4om6Se
         gc9kYBt7l0UCUMBSsrq2S/JQS3tXovM/ZrjuBSOdQ6o7vb9gxGDJNUDrpxq/URWM5A6/
         MYedy2rSgFyVdn5OaEmY2VOnsJUeIa45MRPY1Sd5cXyP1sMHDT9CPzESkBEHDT11ARqf
         TFAzKlJ4irxjJq8kgzt9ZI050AgwnEpdFhAdPl4o6RQ4YesM1wAuXhzCd/lPY96/WSe9
         YW/IRuNS6dG60Q6Rg2YwgXCGEV9Ig8IkotetcAUr+gw3Gsb6lw3DGATNGdPmXsYQdA+/
         +9lw==
X-Gm-Message-State: AOAM532RFzSsJezd9eLBw+ExjmOPV5ooTMpZXxcYs7ulhrs0V1ZaAsp4
        DB3SuqAoZeSYu3EYPTypMUM=
X-Google-Smtp-Source: ABdhPJxnx3BM6wz5YYRTf89esWL4ZWKvIrQqeRM0oSTeawxwQy3JNDz03Ud0xkzXOJKOgU5EsnDaJQ==
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr3062131wmj.63.1628865859846;
        Fri, 13 Aug 2021 07:44:19 -0700 (PDT)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id e11sm1751375wrm.80.2021.08.13.07.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 07:44:18 -0700 (PDT)
Date:   Fri, 13 Aug 2021 16:44:17 +0200
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
Message-ID: <YRaFQRyD8fwc6PEz@orome.fritz.box>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org>
 <YROpd450N+n6hYt2@orome.fritz.box>
 <87pmuk9ku9.wl-maz@kernel.org>
 <YRUwMjeQnXH5RfoB@orome.fritz.box>
 <87v94a8z0u.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X64kRSgE2UZmdzLA"
Content-Disposition: inline
In-Reply-To: <87v94a8z0u.wl-maz@kernel.org>
User-Agent: Mutt/2.1.1 (e2a89abc) (2021-07-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--X64kRSgE2UZmdzLA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 12, 2021 at 04:26:41PM +0100, Marc Zyngier wrote:
> On Thu, 12 Aug 2021 15:29:06 +0100,
> Thierry Reding <thierry.reding@gmail.com> wrote:
> >=20
> > On Wed, Aug 11, 2021 at 02:23:10PM +0100, Marc Zyngier wrote:
>=20
> [...]
>=20
> > > I love this machine... Did this issue occur with the Denver CPUs
> > > disabled?
> >=20
> > Interestingly I've been doing some work on a newer device called Jetson
> > TX2 NX (which is kind of a trimmed-down version of Jetson TX2, in the
> > spirit of the Jetson Nano) and I can't seem to reproduce these failures
> > there (tested on next-20210812).
> >=20
> > I'll go dig out my Jetson TX2 to run the same tests there, because I've
> > also been using a development version of the bootloader stack and
> > flashing tools and all that, so it's possible that something was fixed
> > at that level. I don't think I've ever tried disabling the Denver CPUs,
> > but then I've also never seen these issues myself.
> >=20
> > Just out of curiosity, what version of the BSP have you been using to
> > flash?
>=20
> I've only used the BSP for a few weeks when I got the board last
> year. The only thing I use from it is u-boot to chainload an upstream
> u-boot, and boot Debian from there.

That's interesting... have you ever tried to inject a version of
upstream U-Boot into the BSP and have it flash that instead? That should
allow you to drop the chainloading step.

Not that that's likely to have anything to do with this.

> > One other thing that I ran into: there's a known issue with the PHY
> > configuration. We mark the PHY on most devices as "rgmii-id" on most
> > devices and then the Marvell PHY driver needs to be enabled. Jetson TX2
> > has phy-mode =3D "rgmii", so it /should/ work okay.
> >=20
> > Typically what we're seeing with that misconfiguration is that the
> > device fails to get an IP address, but it might still be worth trying to
> > switch Jetson TX2 to rgmii-id and using the Marvell PHY, to see if that
> > improves anything.
>=20
> I never failed to get an IP address. Overall, networking has been
> solid on this machine until this patch. I'll try and mess with this
> when I get time, but that's probably going to be next week now.

So I've hooked up my Jetson TX2 and tried various workloads. I wasn't
able to reproduce this on next-20210813. I've tried both the L4T 32.6.1
release and a local development build.

Perhaps one thing to try would be to upgrade your L4T BSP to something
newer. I know that there have occasionally been bugs in the MTS
firmware, which is what's running on the Denver cores, and newer BSPs
can fix those kinds of issues.

If that doesn't help, perhaps try to read out the SoC version numbers so
that we can compare. I know that some newer Tegra186 chips behave
slightly differently, so that's perhaps a difference that would explain
why it's not happening on all devices.

You can read the version and revision from sysfs using something like:

	# cat /sys/devices/soc0/{major,minor,revision}

> [...]
>=20
> > > That'd be pretty annoying. Do you know if the Ethernet is a coherent
> > > device on this machine? or does it need active cache maintenance?
> >=20
> > I don't think Ethernet is a coherent device on Tegra186. I think
> > Tegra194 had various improvements with regard to coherency, but most
> > devices on Tegra186 do need active cache maintenance.
> >=20
> > Let me dig through some old patches and mailing list threads. I vaguely
> > recall prototyping a patch that did something special for outer cache
> > flushing, but that may have been Tegra132, not Tegra186. I also don't
> > think we ended up merging that because it turned out to not be needed.
>=20
> ARMv8 forbid any sort of *visible* outer cache, so I really hope this
> is not required. We wouldn't be able to support it.

I couldn't find any trace of this anywhere. So I'm possibly
misremembering. It's also more likely that this was on an earlier SoC
generation, otherwise I'd probably remember more clearly.

Thierry

--X64kRSgE2UZmdzLA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmEWhT4ACgkQ3SOs138+
s6G1rxAArVvwByHZ3mTo/xyzjpXbONIIoIJ3sPDUfnv0XGyqVLpstQGZqzZM2qmr
OiykYQpbdjemNNvZLrW0axYvo/7ImPhMaA2aKhOUdekOqx8HhMFUpBB4t5zvzeKm
/EpbhncuTeIXMGVeCpYNSnBqqf9TvewojlecM/UuiqMRfEH093LmZz2hluVWWzHz
V9LbAz/MfMz+XH9HTsLz6rRsR49mh2n3eO0XfJPqZYwuPr6U/hQEBspb9b/8nK2Y
eUKzHcec0Lk0qesdnarMb14YFCs8zShQd4hKsxGsA65gC1vKpfDp5Bact4jtuo4L
4HfKNS4HD0mKU413Jd/AcFu0sht5b0MDV8iyxXZKwgHCScrEwLiUpVpqcEVgreCw
UfXmExHmZrSglwe8LOBX/8cGekHMUojyu3mdBkzKTT4MZf8UavvwDfmLEsgyYmEO
u67ZQvhIjOXw4HpUvVTY07v1Sj1aHZjKgl7baD4nVx9cR7bjxVK7AbFvykKYZjdI
3EiE33eHg/18CN3XaaPA7A6Kh8gLj/7Y8fziusfDV3G/wGm7we1oF5DTjBHbAQu8
GOuH7ZMzJ8NwMTJ758zhRdKCS4dt0fsAXYgC5iwGbFaSYwzv9JkCdYCLntyNWtYR
ulWUWKl7p76oH+P+WqjPcYdEpz8SVCfhQjoRzgu3FSPu+bNM/oc=
=uBz8
-----END PGP SIGNATURE-----

--X64kRSgE2UZmdzLA--
