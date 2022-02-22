Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA264BF40D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiBVIsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiBVIsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:48:12 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82026A4181;
        Tue, 22 Feb 2022 00:47:46 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AF65A20005;
        Tue, 22 Feb 2022 08:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645519665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uZKr2oZAcs/SeZv9XA5j9RK7i/j5mPJQetOpo6cdtRI=;
        b=bRLY27l72+Xs9deJxJWKItUXiH8r5qe+BoFp8gQyIDqhSZGWPRQRHsbigz08o2eeRny79v
        FbrGwC17V23bWA8boZZKp37/LJfeW1eC37u8WogyemhAPvsA+1anwi1jaX14kmkK86HQfz
        SKEOyjpfzS+d+s+RGzH6JVL/vhCMUGV78MFgZxXUXdT4wcivjOO5ZicVPlLPalRLVHRXEP
        N1IXZfnmRYsZGcGxTZ7T6KKhIG7vTzetdnrTbiknK+EqFR/XH8d3EIgm3CNVUWbdWrPtnW
        +x857g/WSBUqm6Vbzh6r9fNE1GwRpjRtpqOAE4F3vs2V5V8eqv68x4UmdwnBuQ==
Date:   Tue, 22 Feb 2022 09:46:23 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 02/10] property: add fwnode_get_match_data()
Message-ID: <20220222094623.1f7166c3@fixe.home>
In-Reply-To: <CAHp75VdwfhGKOiGhJ1JsiG+R2ZdHa3N4hz6tyy5BmyFLripV5A@mail.gmail.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-3-clement.leger@bootlin.com>
        <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
        <20220222091902.198ce809@fixe.home>
        <CAHp75VdwfhGKOiGhJ1JsiG+R2ZdHa3N4hz6tyy5BmyFLripV5A@mail.gmail.com>
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

Le Tue, 22 Feb 2022 09:33:32 +0100,
Andy Shevchenko <andy.shevchenko@gmail.com> a =C3=A9crit :

> On Tue, Feb 22, 2022 at 9:24 AM Cl=C3=A9ment L=C3=A9ger <clement.leger@bo=
otlin.com> wrote:
> > Le Mon, 21 Feb 2022 19:46:12 +0200,
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit : =20
> > > On Mon, Feb 21, 2022 at 05:26:44PM +0100, Cl=C3=A9ment L=C3=A9ger wro=
te: =20
>=20
> ...
>=20
> > > It's OF-centric API, why it has fwnode prefix? Can it leave in driver=
s/of instead? =20
> >
> > The idea is to allow device with a software_node description to match
> > with the content of the of_match_table. Without this, we would need a
> > new type of match table that would probably duplicates part of the
> > of_match_table to be able to match software_node against a driver.
> > I did not found an other way to do it without modifying drivers
> > individually to support software_nodes. =20
>=20
> software nodes should not be used as a replacement of the real
> firmware nodes. The idea behind is to fill the gaps in the cases when
> firmware doesn't provide enough information to the OS. I think Heikki
> can confirm or correct me.

Yes, the documentation states that:

NOTE! The primary hardware description should always come from either
ACPI tables or DT. Describing an entire system with software nodes,
though possible, is not acceptable! The software nodes should only
complement the primary hardware description.

>=20
> If you want to use the device on an ACPI based platform, you need to
> describe it in ACPI as much as possible. The rest we may discuss.
>=20

Agreed but the PCIe card might also be plugged in a system using a
device-tree description (ARM for instance). I should I do that without
duplicating the description both in DT and ACPI ?

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
