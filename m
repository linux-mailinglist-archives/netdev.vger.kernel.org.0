Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3824E8EF2
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 09:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiC1H3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 03:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236389AbiC1H3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 03:29:45 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8473C49C;
        Mon, 28 Mar 2022 00:28:03 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2EEE0E0007;
        Mon, 28 Mar 2022 07:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648452482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OXmlB+ObSFBVeGDcXlfASLfeYiB6a6ZcPSqmHqh93og=;
        b=MPweZDXu0TcPPoQSFxcBwNPGNR4hVLAVJmIjlMN0wMf0kRrvqf/0TkXBqElt4mPDGDUash
        Q3Ho7RkFN48ihUbHmelfMMjflbkcqlp9a4M/zLtiNxMHRiFdooljlrjRYsdy9AICkaP/SG
        QebvIiVa+V3H3MUm2fnX4/WLYEeK4yrihUsK17Y+71Co0l9AwIRXj5/Czm7npfrms5jD19
        T6buST7yvqb+tGyw48uqvL33Ns2kGBodRahXcffHFHf2X4+mbslIOhMZvx7iQ5N/ThGZ2h
        sw+bbeBcmRlZtZlpyMOqBXGPc8yToXeB3DWruIrPVx030B3SWtPr9hEXVSdPEw==
Date:   Mon, 28 Mar 2022 08:26:42 +0200
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
Message-ID: <20220328082642.471281e7@fixe.home>
In-Reply-To: <Yj4MIIu7Qtvv25Fs@lunn.ch>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
        <20220325172234.1259667-2-clement.leger@bootlin.com>
        <Yj4MIIu7Qtvv25Fs@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 25 Mar 2022 19:38:24 +0100,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> On Fri, Mar 25, 2022 at 06:22:30PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > In order to support software node description transparently, add fwnode
> > support with fwnode_mdiobus_register(). This function behaves exactly
> > like of_mdiobus_register() function but using the fwnode node agnostic
> > API. This support might also be used to merge ACPI mdiobus support
> > which is quite similar to the fwnode one.
> >=20
> > Some part such as the whitelist matching are kept exclusively for OF
> > nodes since it uses an of_device_id struct and seems tightly coupled
> > with OF. Other parts are generic and will allow to move the existing
> > OF support on top of this fwnode version. =20
>=20
> Does fwnode have any documentation? How does a developer know what
> properties can be passed? Should you be adding a
>=20
> Documentation/fwnode/bindings/net/mdio.yaml ?
>=20
> 	Andrew

Hi Andrew,

Actually, fwnode is an abstraction for various firmware nodes such as
ACPI, device-tree and software nodes. It allows to access properties,
child and other attributes transparently from these various nodes but
does not actually defines how they should describe the hardware. If
there is specific hanling to be done, node type can be checked using
is_acpi_node(), is_of_node() and so on.

I think it is still needed to document the bindings for each node type.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
