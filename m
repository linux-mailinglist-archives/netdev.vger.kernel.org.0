Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B25520FC4
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbiEJIjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiEJIjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:39:02 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [217.70.178.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675481BD73A;
        Tue, 10 May 2022 01:35:03 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F0FD620000B;
        Tue, 10 May 2022 08:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652171702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kh7DYyBInXTh3sG9c4M0Sk5M7gxxMdC14JimjF3W+Nw=;
        b=dtIs2wdRF3USwu7B0gKSjyiiiOIhdk93PWxVGVtb0s0ZA2Oj+ue41m2ONpp6FHPijz8N1V
        99NyKykZg3IccFuBnOuLRb75PsaB+la/ibdKXLR8OEDvQOeDHutZBk9BpBpDzD0XKRIvjj
        1t9v3+qyhvfW9R8oKPwb8DphwAQhjqmY8nM1TNm2Z2cHYEZ9hW6KbvpxsJMCpmC277GMRf
        olQp/zD9+orxRJdMQtFO8s6qcLdPlS6GWzbqeqa7jsog9zq+1jTtNwDlM8BrvehF29/kxq
        DZmF3+aODL7Ji+Vd0qJ+OEKNrRGiJbQ9MgkxTA54PHKFn+61/KXqlAynCwnRLQ==
Date:   Tue, 10 May 2022 10:34:58 +0200
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next v4 06/12] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220510103458.381aaee2@xps-bootlin>
In-Reply-To: <20220509160813.stfqb4c2houmfn2g@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
        <20220509131900.7840-7-clement.leger@bootlin.com>
        <20220509160813.stfqb4c2houmfn2g@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 9 May 2022 19:08:13 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Mon, May 09, 2022 at 03:18:54PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add Renesas RZ/N1 advanced 5 port switch driver. This switch
> > handles 5 ports including 1 CPU management port. A MDIO bus is also
> > exposed by this switch and allows to communicate with PHYs
> > connected to the ports. Each switch port (except for the CPU
> > management ports) is connected to the MII converter.
> >=20
> > This driver includes basic bridging support, more support will be
> > added later (vlan, etc).
> >=20
> > Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> > Suggested-by: Phil Edworthy <phil.edworthy@renesas.com>
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > ---
> > +static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
> > +				  struct dsa_bridge bridge,
> > +				  bool *tx_fwd_offload,
> > +				  struct netlink_ext_ack *extack)
> > +{
> > +	struct a5psw *a5psw =3D ds->priv;
> > +
> > +	/* We only support 1 bridge device */
> > +	if (a5psw->br_dev && bridge.dev !=3D a5psw->br_dev) {
> > +		NL_SET_ERR_MSG_MOD(extack,
> > +				   "Forwarding offload supported
> > for a single bridge"); =20
>=20
> I don't think I saw the dsa_slave_changeupper() patch that avoids
> overwriting the extack when dsa_port_bridge_join() returns
> -EOPNOTSUPP.

Ok, I did not understood that dsa_slave_changeupper() *did* needed to
be modified. I'll do that.

>=20
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	a5psw->br_dev =3D bridge.dev;
> > +	a5psw_flooding_set_resolution(a5psw, port, true);
> > +	a5psw_port_mgmtfwd_set(a5psw, port, false);
> > +
> > +	return 0; =20
>=20
> By the way, does this switch pass
> tools/testing/selftests/drivers/net/dsa/no_forwarding.sh?

Unfortunately, the board I have only has 2 ports availables and thus, I
can only test one bridge or two separated ports at a time... I *should*
receive a 4 ports one in a near future but that not yet sure.


