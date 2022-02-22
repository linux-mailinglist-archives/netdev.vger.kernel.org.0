Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1145D4BF36D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiBVIU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBVIU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:20:58 -0500
X-Greylist: delayed 260 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Feb 2022 00:20:31 PST
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAF3155C35;
        Tue, 22 Feb 2022 00:20:30 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E5C26100004;
        Tue, 22 Feb 2022 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645518026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W5Nefp6GfuNeDoo+g/v+e3/VXcVfBUoFmyuv8FL7z+4=;
        b=OKkc8UOr8QCrah0F5Elkwb5Jme6SaZXNa0HvOfBn0RTpCv1hzn4ZH6F6HhjKiBtS2/E8YI
        Afljgq/1rUjbZ/F6HDktUWOcYUeUieeQvSpeKWGDwQnocGrhcksTP3uKc/51o2vv9sdPuN
        RkqSUQhC2qIafJJbZp+8pXYcV6h3lmFGKQ2VGKMyyjNDKTwRlx6mPpL8iIhgx+VQDO/WjQ
        /KoUkGk9XLC6Gb/zdUigH/G/+dkrDK0z0BKpUbZUult4daeW/GkuG/7PQf+tZPwRh4B+uz
        2hg3SBQlFoxtx04HUvdWhVcSVQIHFdo0NjsXKIvPEcCVmt2dnmhwQ4bQzMYLWw==
Date:   Tue, 22 Feb 2022 09:19:02 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 02/10] property: add fwnode_get_match_data()
Message-ID: <20220222091902.198ce809@fixe.home>
In-Reply-To: <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-3-clement.leger@bootlin.com>
        <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
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

Le Mon, 21 Feb 2022 19:46:12 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Mon, Feb 21, 2022 at 05:26:44PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add fwnode_get_match_data() which is meant to be used as
> > device_get_match_data for fwnode_operations. =20
>=20
> ...
>=20
> > +const void *fwnode_get_match_data(const struct fwnode_handle *fwnode,
> > +				  const struct device *dev)
> > +{
> > +	const struct of_device_id *match;
> > +
> > +	match =3D fwnode_match_node(fwnode, dev->driver->of_match_table);
> > +	if (!match)
> > +		return NULL;
> > +
> > +	return match->data;
> > +} =20
>=20
> It's OF-centric API, why it has fwnode prefix? Can it leave in drivers/of=
 instead?
>=20
>=20

The idea is to allow device with a software_node description to match
with the content of the of_match_table. Without this, we would need a
new type of match table that would probably duplicates part of the
of_match_table to be able to match software_node against a driver.
I did not found an other way to do it without modifying drivers
individually to support software_nodes.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
