Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270F04E24BF
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346517AbiCUK7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344310AbiCUK72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:59:28 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E28388D;
        Mon, 21 Mar 2022 03:57:59 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 83816240002;
        Mon, 21 Mar 2022 10:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647860278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LZNgnjWkKhLzqGXIS2PyfPRDrrDMyUhiYwcO73AF+24=;
        b=Wxx6YJ/79/95pD6rR/0C2Kaz+JctTL3b6Dorqi7ZVrwbV0L1WAYb+4oAJ6fvMMFtOJ0ne8
        tZbhuhmzJTPNkZGoa7anaZ3Bn0DTwUuDXaSt+Nq74g4GLRhY6K2T0OYpifi50VPVtlgNn9
        aC1BtO58qBEZpgFnUBTuNajIQPH5TaLei9n7bQqS65jrLhfVpvugcG+iAwlnCjwMqtSbQ3
        e+fuprJ2kmr/X4psUPw5XI4VDWIqKdrol6VXdybDLbFk1/3z1K8LtoKIKzzyuRKUxgzhEg
        I9nafmua3WdquDaRYBDyS3ZzWQQ0JBTTfgli61GuKiTxZd7ytVxfP/UpWWYsjw==
Date:   Mon, 21 Mar 2022 11:56:34 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] introduce fwnode in the I2C subsystem
Message-ID: <20220321115634.5f4b8bd4@fixe.home>
In-Reply-To: <20220318100201.630c70bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
        <20220318100201.630c70bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

Le Fri, 18 Mar 2022 10:02:01 -0700,
Jakub Kicinski <kuba@kernel.org> a =C3=A9crit :

> On Fri, 18 Mar 2022 17:00:46 +0100 Cl=C3=A9ment L=C3=A9ger wrote:
> > In order to allow the I2C subsystem to be usable with fwnode, add
> > some functions to retrieve an i2c_adapter from a fwnode and use
> > these functions in both i2c mux and sfp. ACPI and device-tree are
> > handled to allow these modifications to work with both descriptions.
> >=20
> > This series is a subset of the one that was first submitted as a larger
> > series to add swnode support [1]. In this one, it will be focused on
> > fwnode support only since it seems to have reach a consensus that
> > adding fwnode to subsystems makes sense.
> >=20
> > [1] https://lore.kernel.org/netdev/YhPSkz8+BIcdb72R@smile.fi.intel.com/=
T/ =20
>=20
> Sorry to jump ahead but would be great to split it up so that every
> subsystem could apply its patches without risking conflicts, once
> consensus has been reached.

Hi Jakub,

Ok, to be clear, you would like a series which contains all the
"base" fwnode functions that I'm going to add to be sent separately
right ? And then also split i2c/net stuff that was sent in this series ?

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
