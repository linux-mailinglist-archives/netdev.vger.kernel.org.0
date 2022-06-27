Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6102355C36F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiF0HjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiF0HjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:39:10 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B6160D0;
        Mon, 27 Jun 2022 00:39:08 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A957BC000A;
        Mon, 27 Jun 2022 07:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656315546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94jgi0v3jE6kcn4QQ7XA0jsCaD9LuswNs/AWgam6hBA=;
        b=pBItYIhbsdoCD6jIUc/s7NThU9NCYx2XtFvX6jt2kJxoRV0ICzOD79n31UT/jX0t+Yl4XM
        7MSw5Qfrn2vgnroEcaTHr/SaM42NJ+7HjxGhfG+IfkYWz4ApJZO88HUXs5kFOvtlrYIzel
        M3PEdEhtrz1dk+qHMaAFO9wTEIvKbHPlh/WeSNAcBM9l1dghmEpfJ/razHP/95ffILZDhv
        Kp8a26wg2VUY9iH8k2pIUB6smmuE1ohfxT24H/0bupl9RsslH4OudFHUBjsyjSJrM2uTTa
        fJEqYNz3VN14mO4uVNV5cLxHBGgbgEkusdf82a4ZPIXUKGdbgte+qR/2haxuIQ==
Date:   Mon, 27 Jun 2022 09:38:15 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v9 00/16] add support for Renesas RZ/N1
 ethernet subsystem devices
Message-ID: <20220627093815.25ba1bb6@fixe.home>
In-Reply-To: <20220624214330.aezwdsirjvvoha45@skbuf>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
        <20220624214330.aezwdsirjvvoha45@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Sat, 25 Jun 2022 00:43:30 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Fri, Jun 24, 2022 at 04:39:45PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
> > (most notably) a switch, two GMACs, and a MII converter [1]. This
> > series adds support for the switch and the MII converter.
> >=20
> > The MII converter present on this SoC has been represented as a PCS
> > which sit between the MACs and the PHY. This PCS driver is probed from
> > the device-tree since it requires to be configured. Indeed the MII
> > converter also contains the registers that are handling the muxing of
> > ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.
> >=20
> > The switch driver is based on DSA and exposes 4 ports + 1 CPU
> > management port. It include basic bridging support as well as FDB and
> > statistics support.
> >=20
> > Link: [1] https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-=
group-rzn1l-group-users-manual-r-engine-and-ethernet-peripherals
> >=20
> > -----
> > Changes in V9:
> > - Cover letter:
> >   - Remove comment about RZN1 patches that are now in the master branch.
> > - Commits:
> >   - Add Vladimir Oltean Reviewed-by
> > - PCS:
> >   - Add "Depends on OF" for PCS_RZN1_MIIC due to error found by intel
> >     kernel test robot <lkp@intel.com>.
> >   - Check return value of of_property_read_u32() for
> >     "renesas,miic-switch-portin" property before setting conf.
> >   - Return miic_parse_dt() return value in miic_probe() on error
> > - Switch:
> >   - Add "Depends on OF" for NET_DSA_RZN1_A5PSW due to errors found by
> >     intel kernel test robot <lkp@intel.com>.
> > - DT:
> >   - Add spaces between switch port and '{' =20
>=20
> I took one more look through the series and this looks good, thanks.

Hi Vladimir,

Thanks for the review.

Cl=C3=A9ment

>=20
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
