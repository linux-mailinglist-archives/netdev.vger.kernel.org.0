Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDC4561E7B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiF3Oy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiF3Oy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:54:57 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195951B7BF;
        Thu, 30 Jun 2022 07:54:56 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id by38so23419116ljb.10;
        Thu, 30 Jun 2022 07:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Kd9uWMTHxo+g3H8QAnx28ov2poiguX8tTXaRvd3ppok=;
        b=LJYw47IIAuwaAt6zQHwBqMKOnd/Z93qIAVmbxpUGaIluSRQ1594lHJwBIP36tPdTL6
         R6U961vlXC855INTKr8Q0LiYi7YTJUUHyOdLeuzfrvXYjUEQZVKYWb03rNGcM6raeGZ9
         DbE2peiu9R2oSPkH4b7twj8kD12tNBj2/83l5W25kHjv7EmeYyeE1cuGOdRmHHJevQaD
         gSLk77lq22PIAynWYuIwc0IX7QY6lZPDEEsEc93UI4W1/ik5joOEyzuOSUTa4X9a6CXl
         j1YQf8pVsQ7j8nL+l0jCavQIT5cuFlLHAv1UeEhQyS/MQ/P4OhdJaDSZLsVrnBkh2jjC
         RKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Kd9uWMTHxo+g3H8QAnx28ov2poiguX8tTXaRvd3ppok=;
        b=OVbnHobehnLW90V1SjIXY/fzI6lw4xrA1uiwik04mZmLw5RDOuL3Jne9jcT4t9GDFu
         ttDyKZlaQX2VEVo9uK7g9w8oTKiBtieSEnLtn/zNEfFx9vJo1elPaBRMmRkHrkhrHd2/
         n73TXneNB/5sOzOFHb4uu5fbk6rrQqF053TH112AHRuBFFJXkfXCMMZqKCjosRT3DsQ4
         NJtpDP/+H2A9moQ35pNUF2GB1jANChQ3OvK1PQh5xemI8o2ntiKSlxR+Hn4j9kXfuFhw
         SIiDZt32ZthIqC0QqN9vtspeB/eyz0TNugG78+GZdKYn4A6gKpkHL6X7lq1nJl/prP/s
         r4Bg==
X-Gm-Message-State: AJIora9zN1FGumZyifS4k95KycpX5nVWk+aQ+f/MhFEZx+cZWFAYy+Ga
        cpsbFOLra8GwxE+IX35zXrM=
X-Google-Smtp-Source: AGRyM1v/kw3apsD7C7/cDG+XdAba5viGqX5Wwre58NiOVP+YmZbhJt59vdNhek1DorsWWpDtBrws+w==
X-Received: by 2002:a05:651c:1542:b0:249:a87f:8a34 with SMTP id y2-20020a05651c154200b00249a87f8a34mr5339077ljp.442.1656600894122;
        Thu, 30 Jun 2022 07:54:54 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id s21-20020a056512315500b0047f6e91d4fesm737109lfi.141.2022.06.30.07.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:54:53 -0700 (PDT)
Date:   Thu, 30 Jun 2022 16:54:51 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh@kernel.org>, Bhadram Varka <vbhadram@nvidia.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        jonathanh@nvidia.com, kuba@kernel.org, catalin.marinas@arm.com,
        will@kernel.org
Subject: Re: [PATCH net-next v1 5/9] dt-bindings: net: Add Tegra234 MGBE
Message-ID: <Yr25O9Spphgw+5lS@orome>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-5-vbhadram@nvidia.com>
 <20220628195534.GA868640-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7xSZjsUX66GvG/Lf"
Content-Disposition: inline
In-Reply-To: <20220628195534.GA868640-robh@kernel.org>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7xSZjsUX66GvG/Lf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2022 at 01:55:34PM -0600, Rob Herring wrote:
> On Thu, Jun 23, 2022 at 01:16:11PM +0530, Bhadram Varka wrote:
> > Add device-tree binding documentation for the Tegra234 MGBE ethernet
> > controller.
> >=20
> > Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> > Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> > ---
> >  .../bindings/net/nvidia,tegra234-mgbe.yaml    | 163 ++++++++++++++++++
> >  1 file changed, 163 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra2=
34-mgbe.yaml
> >=20
> > diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe=
=2Eyaml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> > new file mode 100644
> > index 000000000000..d6db43e60ab8
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> > @@ -0,0 +1,163 @@
> > +# SPDX-License-Identifier: GPL-2.0
>=20
> Dual license. checkpatch.pl will tell you this.
>=20
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Tegra234 MGBE Device Tree Bindings
>=20
> s/Device Tree Bindings/???bit Ethernet Controller/
>=20
> > +
> > +maintainers:
> > +  - Thierry Reding <treding@nvidia.com>
> > +  - Jon Hunter <jonathanh@nvidia.com>
> > +
> > +properties:
> > +
> > +  compatible:
> > +    const: nvidia,tegra234-mgbe
> > +
> > +  reg:
> > +    minItems: 3
> > +    maxItems: 3
> > +
> > +  reg-names:
> > +    items:
> > +      - const: hypervisor
> > +      - const: mac
> > +      - const: xpcs
>=20
> Is this really part of the same block? You don't have a PHY (the one in=
=20
> front of the ethernet PHY) and PCS is sometimes part of the PHY.

Yes, these are all part of the same block. As an example, the MGBE0
instantiation of this block on Tegra234 is assigned an address space
=66rom 0x06800000 to 0x068fffff. Within that there are three main sections
of registers:

	MAC 0x06800000-0x0689ffff
	PCS 0x068a0000-0x068bffff
	SEC 0x068c0000-0x068effff

Each of these are further subdivided (hypervisor and mac are within that
MAC section, while XPCS is in the PCS section) and we don't have reg
entries for all of them because things like SEC and virtualization
aren't supported upstream yet.

> > +
> > +  interrupts:
> > +    minItems: 1
> > +
> > +  interrupt-names:
> > +    items:
> > +      - const: common
>=20
> Just drop interrupt-names. Not a useful name really.

There will eventually be other interrupts that could be used here. For
example there are five additional interrupts that are used for
virtualization and another two for the MACSEC module. Neither of which
are supported in upstream at the moment, so we didn't want to define
these yet. However, specifying the interrupt-names property from the
start, it will allow these other interrupts to be added in a backwards-
compatible and easy way later on.

>=20
> > +
> > +  clocks:
> > +    minItems: 12
> > +    maxItems: 12
> > +
> > +  clock-names:
> > +    minItems: 12
> > +    maxItems: 12
> > +    contains:
> > +      enum:
> > +        - mgbe
> > +        - mac
> > +        - mac-divider
> > +        - ptp-ref
> > +        - rx-input-m
> > +        - rx-input
> > +        - tx
> > +        - eee-pcs
> > +        - rx-pcs-input
> > +        - rx-pcs-m
> > +        - rx-pcs
> > +        - tx-pcs
> > +
> > +  resets:
> > +    minItems: 2
> > +    maxItems: 2
> > +
> > +  reset-names:
> > +    contains:
> > +      enum:
> > +        - mac
> > +        - pcs
> > +
> > +  interconnects:
> > +    items:
> > +      - description: memory read client
> > +      - description: memory write client
> > +
> > +  interconnect-names:
> > +    items:
> > +      - const: dma-mem # read
> > +      - const: write
> > +
> > +  iommus:
> > +    maxItems: 1
> > +
> > +  power-domains:
> > +    items:
> > +      - description: MGBE power-domain
>=20
> What else would it be? Just 'maxItems: 1'.

It's possible that we have some generic descriptions like this in other
bindings, but I agree that this doesn't add anything useful. I can look
into other bindings and remove these generic descriptions so that they
don't set a bad example.

> > +
> > +  phy-handle: true
> > +
> > +  phy-mode: true
>=20
> All possible modes are supported by this h/w? Not likely.
>=20
> > +
> > +  mdio:
> > +    $ref: mdio.yaml#
> > +    unevaluatedProperties: false
> > +    description:
> > +      Creates and registers an MDIO bus.
>=20
> That's OS behavior...

I suppose we can just leave out the description here because this is
fairly standard.

Bhadram, can you address the comments in this and send out a v2 of the
whole series? As suggested by Jakub, let's either leave out the driver
bits at this point so as not to confuse maintainers any further, or at
least make sure that the driver patch is the last one in the series to
make it a bit more obvious what needs to be applied to net/next.

Also, keep in mind that if we want to get this into v5.20, we need to
get the bindings finalized in the next couple of days.

Thierry

--7xSZjsUX66GvG/Lf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmK9uTgACgkQ3SOs138+
s6FTOBAAuuUbdnpia9ccz76X+S3YT2I7yvXEOSqClOIGKCPXV556bOuSyQbGcHpE
CMSfqEHLexBNqS2uiHItqKWaaJOmbK3FKP7ylnV/gtb/Rma8PBiJ8lwkgIqXL6Ye
jCUOZulRgnZLLNhZyobm4fwGa1xV5qSOvIffJe6iSVJ9zDIVx5TCCUe+92v8NggT
BiK6/mzzHbHUcziMqlTdftex4cbQWuTT3sCk4kpQJzX+BH06pypIp+SauEOI6HYS
GxEYmeNbh6jUKAmgp/rRSRH8hOOt8pbMXm0WUzFGKn7gQqp8hhMiATuV83k9ECo3
BVa3a3HX/TzjNRp3Y139YYbcFt7T3lJsUmJSsolh2DBn5fEs4QmQxd6dfQdayRdF
t0M+ss+mZw9pk4XXQUyeAfqtBotw/r1dRA06k4+fE1Tec/jpvU5fgCRy60nBsMgx
aLasuR10m+asKO1DDxdOYjeOJDWUiaR3mLK6FD6lYG2h+lgOpqf5/PpboWbhv9pi
AHQmKDr8Ua36dYmgoHeAn9Yo3o+iuFsuvrrZvAubIRxdoeFAlBgKjCRTeOHL4pI2
oYDbPNDzyryt+STSSVFHlwQPcpghSw4IkIJqArAb+qFQNOINBqgDBtI+0nT+nLgk
iUHwS61Az4iBxlNG5pUdL8VO3eY/8GV3GNy8hsejmW8LXhj5uho=
=qGiN
-----END PGP SIGNATURE-----

--7xSZjsUX66GvG/Lf--
