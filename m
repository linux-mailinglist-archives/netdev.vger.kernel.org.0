Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455AA5029E3
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353463AbiDOMdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353746AbiDOMc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:32:59 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EC62A24A;
        Fri, 15 Apr 2022 05:30:27 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CB7B61BF20B;
        Fri, 15 Apr 2022 12:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650025826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A1/tszHDG8Vff4skAnjSZX538JXjqq1vMLo59ef74jo=;
        b=afzipWdjZ8lUcVOEUnYPkNYt+ZTIgSvshV8phJLgcQG13g0so4ZCFUzO2AGUhoFfizSuQB
        mp4fQ8tpm3s3tI6aEG0Ap4/C9dRVvN08xX71QRpyBfyeZ6ue/M5KNZ8rT4VJ6qc/Wnh9Yv
        Zb2u4EEN+tRj0h0QkaD0AAs+YlFx/X1sdOb4OWzsJemgN+h9/keFzsitnbd3JDyGIeWiDa
        3Dooquwa5CSrp+tIRhiIHMJY9FPjCH5Uw9QLijyHjlTiINJsGcm/O+jcQSfxUOG/GI4lXb
        OY6daObOgp64dow6NoJ6Wz5guq3NpjEL3Ethm5sCz0+hqg+L4z6UAQ3Jbg3H9Q==
Date:   Fri, 15 Apr 2022 14:28:57 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415142857.525ccd2d@fixe.home>
In-Reply-To: <20220415105503.ztl4zhoyua2qzelt@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-7-clement.leger@bootlin.com>
        <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
        <20220415113453.1a076746@fixe.home>
        <20220415105503.ztl4zhoyua2qzelt@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
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

Le Fri, 15 Apr 2022 13:55:03 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Fri, Apr 15, 2022 at 11:34:53AM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Le Thu, 14 Apr 2022 17:47:09 +0300,
> > Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit : =20
> > > > later (vlan, etc).
> > > >=20
> > > > Suggested-by: Laurent Gonzales <laurent.gonzales@non.se.com>
> > > > Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> > > > Suggested-by: Phil Edworthy <phil.edworthy@renesas.com>   =20
> > >=20
> > > Suggested? What did they suggest? "You should write a driver"?
> > > We have a Co-developed-by: tag, maybe it's more appropriate here? =20
> >=20
> > This driver was written from scratch but some ideas (port isolation
> > using pattern matcher) was inspired from a previous driver. I thought it
> > would be nice to give them credit for that.
> >=20
> > [...] =20
>=20
> Ok, in that case I don't really know how to mark sources of inspiration
> in the commit message, maybe your approach is fine.
>=20
> > > >  obj-y				+=3D hirschmann/
> > > >  obj-y				+=3D microchip/
> > > > diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5=
psw.c
> > > > new file mode 100644
> > > > index 000000000000..5bee999f7050
> > > > --- /dev/null
> > > > +++ b/drivers/net/dsa/rzn1_a5psw.c
> > > > @@ -0,0 +1,676 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/*
> > > > + * Copyright (C) 2022 Schneider-Electric
> > > > + *
> > > > + * Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > > > + */
> > > > +
> > > > +#include <linux/clk.h>
> > > > +#include <linux/etherdevice.h>
> > > > +#include <linux/kernel.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/of.h>
> > > > +#include <linux/of_mdio.h>
> > > > +#include <net/dsa.h>
> > > > +#include <uapi/linux/if_bridge.h>   =20
> > >=20
> > > Why do you need to include this header? =20
> >=20
> > It defines BR_STATE_* but I guess linux/if_bridge.h does include it. =20
>=20
> Yes.
>=20
> > > > +static void a5psw_port_pattern_set(struct a5psw *a5psw, int port, =
int pattern,
> > > > +				   bool enable)
> > > > +{
> > > > +	u32 rx_match =3D 0;
> > > > +
> > > > +	if (enable)
> > > > +		rx_match |=3D A5PSW_RXMATCH_CONFIG_PATTERN(pattern);
> > > > +
> > > > +	a5psw_reg_rmw(a5psw, A5PSW_RXMATCH_CONFIG(port),
> > > > +		      A5PSW_RXMATCH_CONFIG_PATTERN(pattern), rx_match);
> > > > +}
> > > > +
> > > > +static void a5psw_port_mgmtfwd_set(struct a5psw *a5psw, int port, =
bool enable)   =20
> > >=20
> > > Some explanation on what "management forward" means/does? =20
> >=20
> > I'll probably rename that cpu_port_forward to match the dsa naming.
> > It'll actually isolate the port from other ports by only forwarding the
> > packets to the CPU port. =20
>=20
> You could probably do without a rename by just adding a comment that
> says that it enables forwarding only towards the management port.
>=20
> > > Please implement .shutdown too, it's non-optional. =20
> >=20
> > Hum, platform_shutdown does seems to check for the .shutdown callback:
> >=20
> > static void platform_shutdown(struct device *_dev)
> > {
> > 	struct platform_device *dev =3D to_platform_device(_dev);
> > 	struct platform_driver *drv;
> >=20
> > 	if (!_dev->driver)
> > 		return;
> >=20
> > 	drv =3D to_platform_driver(_dev->driver);
> > 	if (drv->shutdown)
> > 		drv->shutdown(dev);
> > }
> >=20
> > Is there some documentation specifying that this is mandatory ?
> > If so, should I just set it to point to an empty shutdown function then
> > ? =20
>=20
> I meant that for a DSA switch driver is mandatory to call dsa_switch_shut=
down()
> from your ->shutdown method, otherwise subtle things break, sorry for bei=
ng unclear.
>=20
> Please blindly copy-paste the odd pattern that all other DSA drivers use
> in ->shutdown and ->remove (with the platform_set_drvdata(dev, NULL) call=
s),
> like a normal person :)
>=20
> > > > + * @reg_lock: Lock for register read-modify-write operation   =20
> > >=20
> > > Interesting concept. Generally we see higher-level locking schemes
> > > (i.e. a rmw lock won't really ensure much in terms of consistency of
> > > settings if that's the only thing that serializes concurrent thread
> > > accesses to some register). =20
> >=20
> > Agreed, this does not guarantee consistency of settings but guarantees
> > that rmw modifications are atomic between devices. I wasn't sure about
> > the locking guarantee that I could have. After looking at other
> > drivers, I guess I will switch to something more common such as using
> > a global mutex for register accesses. =20
>=20
> LOL, that isn't better...
>=20
> Ideally locking would be done per functionality that the hardware can
> perform independently (like lookup table access, VLAN table access,
> forwarding domain control, PTP block, link state control, etc).
> You don't want to artificially serialize unrelated stuff.
> A "read-modify-write" lock would similarly artificially serialize
> unrelated stuff for you, even if you intend it to only serialize
> something entirely different.
>=20
> Most things as seen by a DSA switch driver are implicitly serialized by
> the rtnl_mutex anyway.=20

Is there a list of the functions that are protected by the RTNL lock
without having to deep dive in the whole stacks ? That would be really
useful to remove useless locking from my driver. But I guess I'll have
to look at other drivers to see that.

> Some things aren't (->port_fdb_add, ->port_fdb_del).

Ok, looks like for them a mutex is often used which also seems more
appropriate in my case since the operation on the learn table can take
some times.

> There is a point to be made about adding locks for stuff that is
> implicitly serialized by the rtnl_mutex, since you can't really test
> their effectiveness. This makes it more difficult for the driver writer
> to make the right decision about locking, since in some cases, the
> serialization given by the rtnl_mutex isn't something fundamental and
> may be removed, to reduce contention on that lock. In that case, it is
> always a nice surprise to find a backup locking scheme in converted
> drivers. With the mention that said backup locking scheme was never
> really tested, so it may be that it needs further work anyway.

Ok understood.

>=20
> > > The selftests don't cover nearly enough, but just to make sure that t=
hey
> > > pass for your switch, when you use 2 switch ports as h1 and h2 (hosts=
),
> > > and 2 ports as swp1 and swp2? There's surprisingly little that you do=
 on
> > > .port_bridge_join, I need to study the code more. =20
> >=20
> > Port isolation is handled by using a pattern matcher which is enabled
> > for each port at setup. If set, the port packet will only be forwarded
> > to the CPU port. When bridging is needed, the pattern matching is
> > disabled and thus, the packets are forwarded between all the ports that
> > are enabled in the bridge. =20
>=20
> Is there some public documentation for this pattern matcher?

Yes, the manual is public [1]. See the Advanced 5 Ports Switch section.

[1]
https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-gr=
oup-users-manual-r-engine-and-ethernet-peripherals

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
