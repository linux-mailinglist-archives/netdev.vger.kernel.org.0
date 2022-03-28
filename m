Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6B04E9825
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 15:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243172AbiC1NaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 09:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243186AbiC1NaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 09:30:11 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA92E2F;
        Mon, 28 Mar 2022 06:28:29 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A530CE000D;
        Mon, 28 Mar 2022 13:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648474107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pvhfpTjbPTNOPq0i6h9iJSx3PSkVifP/1sAQ45cy05Q=;
        b=EIHQVVnhQu901PrnzfOqv9osManSB1x0YotcJIv9sEE0MNhVsRkSw8/7w+VfUL8qwcr7BQ
        I19Q7flGRM103VbzIMviYuuRh9rOaFMIiJTxKjJhEkPTyKHbEMIbeQllSqwAlNL2LhatUM
        MGD2IulP2uKF6Jm9ISskl5/By71R4FTgYADNqSX5SSYcrbHNKwoAFVA4c3kZfy7QGLK4XG
        4L/aLYB8uZ81g5ahIe+/5XFsvif1EpnZqqHzB/V5k1CSBqUlqLF1ON9apgvv2i6WuREf3+
        eAorcBkeme5Q8uFptPd9PizzdOPiG6RzhCCfdOXMHhQP1xYgoysIEEQV3osvFA==
Date:   Mon, 28 Mar 2022 15:27:00 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/5] net: mdio: fwnode: add fwnode_mdiobus_register()
Message-ID: <20220328152700.74be6037@fixe.home>
In-Reply-To: <YkGyFJuUDS6x4wrC@lunn.ch>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
        <20220325172234.1259667-2-clement.leger@bootlin.com>
        <Yj4MIIu7Qtvv25Fs@lunn.ch>
        <20220328082642.471281e7@fixe.home>
        <YkGyFJuUDS6x4wrC@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 28 Mar 2022 15:03:16 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> > >=20
> > > Does fwnode have any documentation? How does a developer know what
> > > properties can be passed? Should you be adding a
> > >=20
> > > Documentation/fwnode/bindings/net/mdio.yaml ?
> > >=20
> > > 	Andrew =20
> >=20
> > Hi Andrew,
> >=20
> > Actually, fwnode is an abstraction for various firmware nodes such as
> > ACPI, device-tree and software nodes. It allows to access properties,
> > child and other attributes transparently from these various nodes but
> > does not actually defines how they should describe the hardware. If
> > there is specific hanling to be done, node type can be checked using
> > is_acpi_node(), is_of_node() and so on.
> >=20
> > I think it is still needed to document the bindings for each node type.=
 =20
>=20
> But you seem to be implementing a subset of what each node type
> supports. So maybe it would be good to document which parts of the OF
> binding can be used, which parts of the ACPI binding can be used, etc.

With this series, fwnode_mdiobus_register() supports exactly the same
subset that is supported by of_mdiobus_register(). This is not true for
ACPI though, but I could easily add this support providing that someone
could test it. Or I can left it as is and document that ACPI is not
supported and add some checks to avoid fwnode_mdiobus_register being
called with an ACPI node. What would you prefer ?

The goal in the end is to be able to use only fwnode_mdiobus_register()
to register mdiobus device whatever the node type.

>=20
> 	Andrew


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
