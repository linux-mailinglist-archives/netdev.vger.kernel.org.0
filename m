Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA69C28FF6A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 09:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404822AbgJPHpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 03:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404814AbgJPHpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 03:45:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315D8C061755;
        Fri, 16 Oct 2020 00:45:53 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602834351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PkrVMaVUVdXfkf7Q2+Pi5ubk1vsDo82s232HcqyDaV0=;
        b=Khu9qyZ4a/tzso6SPmN0IT1WUKTjNpHgBDaMCXETtI/3/rs+DEZ4OTM9t8Fqj/paGJFqns
        j80b5OziwyHLOxutwmpxQCCrpMADP2noojeT9pHUa26c3SzJPGxBjkpLTwlQwiHd+EWKf4
        0fKEzad8NiohBfxxExWIPPq3fnNk3xVTbumeI65FqEiAqPr5VJTK38NBEOcUNDgot0Ys9i
        Z2mQYrnN2Ro17c0WPcT2HdXSiXPf0F+dJqiSVkHJs0CL+Gvy49ek8ZmCz5JITisz7MhFpN
        ngBduy2LjcHCjLooU6DtjvL3b5QMMZFhCVHMZ2UB3vrP/jWIBQ/7oBMzD6OaPg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602834351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PkrVMaVUVdXfkf7Q2+Pi5ubk1vsDo82s232HcqyDaV0=;
        b=kUc0ONV4/AxLIH2CUQl6APcRkPMRS6lFnD17IoShOpnCh8KtpbJ/RCf0+R0YOwgJNtkgec
        UWYgVCmOItrZIkBw==
To:     Christian Eggers <ceggers@arri.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
In-Reply-To: <1647199.FWNDY5eN7L@n95hx1g2>
References: <20201014161719.30289-1-ceggers@arri.de> <3253541.RgjG7ZtOS4@n95hx1g2> <20201014173103.26nvgqtrpewqskg4@skbuf> <1647199.FWNDY5eN7L@n95hx1g2>
Date:   Fri, 16 Oct 2020 09:45:42 +0200
Message-ID: <875z7asjfd.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Oct 15 2020, Christian Eggers wrote:
> On Wednesday, 14 October 2020, 19:31:03 CEST, Vladimir Oltean wrote:
>> What problem are you actually trying to solve?
> After (hopefully) understanding the important bits, I would like to solve=
 the=20
> problem that after calling __skb_put_padto() there may be no tailroom for=
 the=20
> tail tag.
>
> The conditions where this can happen are quite special. You need a skb->l=
en <=20
> ETH_ZLEN and the skb must be marked as cloned. One condition where this=20
> happens in practice is when the skb has been selected for TX time stampin=
g in=20
> dsa_skb_tx_timestamp() [cloned] and L2 is used as transport for PTP [size=
 <=20
> ETH_ZLEN]. But maybe cloned sk_buffs can also happen for other reasons.

Hmm. I've never observed any problems using DSA with L2 PTP time
stamping with this tail tag code. What's the impact exactly? Memory
corruption?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+JT6YACgkQeSpbgcuY
8KYZrg//WAcWmvGXqeDhGylR8UQzVqxRn9I127qIcoeq4lf1n9qtJspB7qauKZg8
gx0tlHWfMl4RJ0EFKhFZ8VReFlqLtwABK7Bd261sdWMCjV2r/eDYjk229Xw2fj6u
YhAWaah0ZFNxWO3A2bVMsKhyisMoM6juXCqssZG7T38E+E6nFxjfmXQxFcgxDY2k
ZiYh8iyEC0qCU3PmUviOBJoMEvmkVNnxHZp4vQysTyiDqErJl7I2DEzLA7L2CZyV
XTfLDuyZ79rSRrDS7dgPoV2eWy9sGzpzK+KYlFLbRvgH03/KPsvEcLJgnPKhvG2s
scbq46+jBfoZy5l5bp5GxjHmdvOYgf9TLmdJqE84QHvj7gtqDHpRpeaMEPTcOjpC
DOvvSFuUOnRVckAyUyxZjPSYrbOIGNQgqSAUN+03eUEjJ/+b/M/l+Q5i0qeUvRnU
asnSm0RN6YoonmNujMeW+OZ/EO7xbthnWh6+NLMcN85TTDrhvdu3eh3hn54iZvII
J2Bpjo04vLyWkphoOqDn5UAitGG31h0aq8k9JBVkDNcaNBslhVTEgknuELCJUSot
hXhGIVJ4ZXuWUhLOnlrXl4aIqitcT0giUtnG/QWT79pksfMJEN7G79KiREykvdKV
CdD6kK5ShjjgmaDVNOuRSCuBe2/lxUsjbNx5Pc9KrN+AcQkzj9k=
=+oJP
-----END PGP SIGNATURE-----
--=-=-=--
