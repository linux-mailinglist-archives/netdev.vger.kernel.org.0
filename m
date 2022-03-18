Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AB34DDF57
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbiCRQwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbiCRQwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:52:02 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F33167C6;
        Fri, 18 Mar 2022 09:50:39 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 788891C0012;
        Fri, 18 Mar 2022 16:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647622238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aS1N89uzvpd8jnYBFJepA/ZxoklG7RH275pUOIYJ0bQ=;
        b=MOBC9vWcqqqeGLx0FQdShhqqb2keJX3tphFbdRpb+gQoME0eXl2nKpOm7Kl7k9e93WGny1
        5Pw8x9ZnakL+laJgvyKtVypoJnBOObCnEORbAfO4+QBOOGF4FVqLV7C1Zqr6hHlXlbWneD
        eU+Yj7qmJYW7fa7qG0N1C4OBP37XxiOGK7jz4FVfEtHyuPMx5DzmKjXycSeDHix/7vJVrs
        ay4CRgKQ7bJQ8/ro46txKovtyPGgmxSP6QhQ+SQfeXrL5qWwBwXHMY5IBG4IqoEyP3oSOT
        T44vb0ESLpVWNugprcg6u0RF2cRZaICvaryvN24h0nJ/bWfLpWiIfn0BhPzbWQ==
Date:   Fri, 18 Mar 2022 17:49:12 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] property: add fwnode_property_read_string_index()
Message-ID: <20220318174912.5759095f@fixe.home>
In-Reply-To: <YjSymEpNH8vnkQ+L@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
        <20220318160059.328208-2-clement.leger@bootlin.com>
        <YjSymEpNH8vnkQ+L@smile.fi.intel.com>
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

Le Fri, 18 Mar 2022 18:26:00 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Fri, Mar 18, 2022 at 05:00:47PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add fwnode_property_read_string_index() function which allows to
> > retrieve a string from an array by its index. This function is the
> > equivalent of of_property_read_string_index() but for fwnode support. =
=20
>=20
> ...
>=20
> > +	values =3D kcalloc(nval, sizeof(*values), GFP_KERNEL);
> > +	if (!values)
> > +		return -ENOMEM;
> > +
> > +	ret =3D fwnode_property_read_string_array(fwnode, propname, values, n=
val);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	*string =3D values[index];
> > +out:
> > +	kfree(values); =20
>=20
> Here is UAF (use after free). How is it supposed to work?
>=20

values is an array of pointers. I'm only retrieving a pointer out of
it.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
