Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B87C4E8F64
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 09:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbiC1H4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 03:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235479AbiC1H4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 03:56:30 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1049FE0;
        Mon, 28 Mar 2022 00:54:48 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 99F78240007;
        Mon, 28 Mar 2022 07:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648454086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D0dTfjkSSMzAeXU+oyu+XbInITXKvZF7+hzpqqr1zII=;
        b=JF7edwBRyOYiIZdU7mIFuu9pw6auMXlpx4flsdGCg/EuLa/0bLnJ0/vuGyrQwIzO/+5g41
        Sfs3XCdkYwtutHkfA/RuRkZjvpA0w8oICxaXUtPDx2Z9VrW1y80kW/JBi7Z5lkXTErZyY1
        qRFr8fnuHiqEtDAtne9RjjLEz9O84yD8V2JG0flq5NPevbPGs7BooxH1oogB8p3qEOv3Ra
        yYfu0u6YDhHC+BIEWxjITJkxQnobFntXKFD43vFGbLOC3AoNLbbqhHqfSrXcgkZZa4maRS
        FO4rnR5iyZHhwAq+Of+Xg8sNqVHaSCvsUTQAVplr/H6LCUZQb/nLb4+oE/tNqw==
Date:   Mon, 28 Mar 2022 09:53:21 +0200
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
Subject: Re: [net-next 2/5] net: mdio: of: use fwnode_mdiobus_* functions
Message-ID: <20220328095321.3820bd4c@fixe.home>
In-Reply-To: <Yj4KzQPeVUxZEn0k@lunn.ch>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
        <20220325172234.1259667-3-clement.leger@bootlin.com>
        <Yj4KzQPeVUxZEn0k@lunn.ch>
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

Le Fri, 25 Mar 2022 19:32:45 +0100,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> On Fri, Mar 25, 2022 at 06:22:31PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Now that fwnode support has been added and implements the same behavior
> > expected by device-tree parsing =20
>=20
> The problem is, we cannot actually see that. There is no side by side
> comparison which makes it clear it has the same behaviour.
>=20
> Please see if something like this will work:
>=20
> 1/4: copy drivers/net/mdio/of_mdio.c to drivers/net/mdio/fwnode_mdio.c
> 2/4: Delete from fwnode_mdio.c the bits you don't need, like the whitelist
> 3/4: modify what is left of fwnode_mdio.c to actually use fwnode.
> 4/4: Rework of_mdio.c to use the code in fwnode_mdio.c
>=20
> The 3/4 should make it clear it has the same behaviour, because we can
> see what you have actually changed.

Indeed, that would be more clear to provide this as separate patches
that shows clearly the conversion. Will do that.

>=20
> FYI: net-next is closed at the moment, so you need to post RFC
> patches.

Ok, I refered to http://vger.kernel.org/~davem/net-next.html which
seems wrong actually

>=20
>     Andrew

Thanks

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
