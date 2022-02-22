Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD6D4BF3E0
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiBVIna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiBVIna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:43:30 -0500
X-Greylist: delayed 58434 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Feb 2022 00:43:04 PST
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30858D21DF;
        Tue, 22 Feb 2022 00:43:04 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BE0B8240034;
        Tue, 22 Feb 2022 08:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645519382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PddXUx732JNHTzqQ0bj6q31D8bPvLWiNmf2xat3g8s0=;
        b=BR/FXbmmnDB44ixuH+theQDBMOsPiSFiDqb3xAjzI3bbNcCUQYk83Mihl4hlrlY/K5miV6
        ukVkxcib0JIicnkgyTappdwrzHCRO18X0IYGj7ZPUHuLeI3a7jGlpX3aR/jUyiGyGswFii
        9i82k13mo96iKCBJENXrt5hsCNL5lxmiejylk7zwLTwoqw+Sn7x34KxIrt5w0nOzYkEPO/
        54KARCzyfiMrT0cZH/3Dr3cmPPCKsQEnig85nqKj8WgDLdlRCdf5+tffL8/5gKHGmOywZG
        AFr0tQuDC4YySRgDzZcCr1yHvsIPgg9Zy+dJsQcOWGm3yysb2tct5u6c7NaqLA==
Date:   Tue, 22 Feb 2022 09:39:21 +0100
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
Subject: Re: [RFC 03/10] base: swnode: use fwnode_get_match_data()
Message-ID: <20220222093921.24878bae@fixe.home>
In-Reply-To: <YhPQUPzz5vPvHUAy@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-4-clement.leger@bootlin.com>
        <YhPQUPzz5vPvHUAy@smile.fi.intel.com>
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

Le Mon, 21 Feb 2022 19:48:00 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Mon, Feb 21, 2022 at 05:26:45PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > In order to allow matching devices with software node with
> > device_get_match_data(), use fwnode_get_match_data() for
> > .device_get_match_data operation. =20
>=20
> ...
>=20
> > +	.device_get_match_data =3D fwnode_get_match_data, =20
>=20
> Huh? It should be other way around, no?
> I mean that each of the resource providers may (or may not) provide a
> method for the specific fwnode abstraction.
>=20

Indeed, it should be the other way. But since this function is generic
and uses only fwnode API I guessed it would be more convenient to
define it in the fwnode generic part and use it for specific
implementation. I could have modified device_get_match_data to call it
if there was no .device_get_match_data operation like this:

const void *device_get_match_data(struct device *dev)
{
	if (!fwnode_has_op(fwnode, device_get_match_data)
		return fwnode_get_match_data(dev);
	return fwnode_call_ptr_op(dev_fwnode(dev),device_get_match_data, dev);
}

But I thought it was more convenient to do it by setting the
.device_get_match_data field of software_node operations.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
