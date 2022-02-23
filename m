Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E0E4C1A86
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbiBWSBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241790AbiBWSBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:01:34 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057DB3E0DB;
        Wed, 23 Feb 2022 10:00:55 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6D5F5C0004;
        Wed, 23 Feb 2022 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645639254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kY1Ql5jNd8+akOYr5MJM/nVmbSk1hVMt1XjyszBBYhg=;
        b=cxfiBDzVbh20mJFblTgbgSuxY4x1UQqa55dIjZA3KwnE3ugwHGCGW5i7Z7Ta3Cq93by9HE
        fxlU0Ng8WdMipwMjR5WjIXDUv17//5FECXpN8jH5TfPhCSrSoBEgpKfwRj2t9LVyLmuDvu
        kDAB8XZzuEZ25ksvEgj9oeomavBtwq4crhCfDGAkQ0wfR52RV7TF+PFpYJr2+h2uOEDa3i
        Kl8+OEgNIOQLmniGi/oUkjUYQ+cjf1ZZGURQEMvdhLux0Ny/NDS5RBJbwrcgDHBCIcTR1a
        k1PsYUP9FYxVeXkn+TuG7OpYUlCioSUWQxFQdp8tcgo9Y7PfrhKCgWqyOEc3xA==
Date:   Wed, 23 Feb 2022 18:59:27 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Enrico Weigelt <info@metux.net>,
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
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <20220223185927.2d272e3a@fixe.home>
In-Reply-To: <YhZxyluc7gYhmAuh@sirena.org.uk>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <YhPOxL++yhNHh+xH@smile.fi.intel.com>
        <20220222173019.2380dcaf@fixe.home>
        <YhZI1XImMNJgzORb@smile.fi.intel.com>
        <20220223161150.664aa5e6@fixe.home>
        <YhZRtads7MGzPEEL@smile.fi.intel.com>
        <YhZxyluc7gYhmAuh@sirena.org.uk>
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

Le Wed, 23 Feb 2022 17:41:30 +0000,
Mark Brown <broonie@kernel.org> a =C3=A9crit :

> On Wed, Feb 23, 2022 at 05:24:37PM +0200, Andy Shevchenko wrote:
> > On Wed, Feb 23, 2022 at 04:11:50PM +0100, Cl=C3=A9ment L=C3=A9ger wrote=
: =20
> > > Le Wed, 23 Feb 2022 16:46:45 +0200,
> > > Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit : =20
>=20
> > > > And here is the problem. We have a few different resource providers
> > > > (a.k.a. firmware interfaces) which we need to cope with. =20
>=20
> > > Understood that but does adding fwnode support means it should work
> > > as-is with both DT and ACPI ? ACPI code is still in place and only the
> > > of part was converted. But maybe you expect the fwnode prot to be
> > > conformant with ACPI. =20
>=20
> > Not only me, I believe Mark also was against using pure DT approach on
> > ACPI enabled platforms. =20
>=20
> I'm not 100% clear on the context here (I did dig about a bit in the
> thread on lore but it looks like there's some extra context here) but in
> general I don't think there's any enthusiasm for trying to mix different
> firmware interfaces on a single system.  Certainly in the case of ACPI
> and DT they have substantial differences in system model and trying to
> paper over those cracks and integrate the two is a route to trouble.
> This doesn't look like it's trying to use a DT on an ACPI system though?

Ideally no, but it is a possibility mentionned by Andrew, use DT
overlays on an ACPI system. This series did not took this way (yet).
Andrew mentionned that it could potentially be done but judging by your
comment, i'm not sure you agree with that.

>=20
> There's been some discussion on how to handle loadable descriptions for
> things like FPGA but I don't recall it ever having got anywhere concrete
> - I could have missed something.  Those are dynamic cases which are more
> trouble though.  For something that's a PCI card it's not clear that we
> can't just statically instanitate the devices from kernel code, that was
> how the MFD subsystem started off although it's now primarily applied to
> other applications.  That looks to be what's going on here?

Yes, in this series, I used the MFD susbsytems with mfd_cells. These
cells are attached with a swnode. Then, needed subsystems are
modified to use the fwnode API to be able to use them with
devices that have a swnode as a primary node.

>=20
> There were separately some issues with people trying to create
> completely swnode based enumeration mechanisms for things that required
> totally independent code for handling swnodes which seemed very
> concerning but it's not clear to me if that's what's going on here.

The card is described entirely using swnode that in a MFD PCI
driver, everything is described statically. The "enumeration" is static
since all the devices are described in the driver and registered using
mfd_add_device() at probe time. Thus, I don't think it adds an
enumeration mechanism like you mention but I may be wrong.

>=20
> > > As I said in the cover-letter, this approach is the only one that I d=
id
> > > found acceptable without being tied to some firmware description. If =
you
> > > have another more portable approach, I'm ok with that. But this
> > > solution should ideally work with pinctrl, gpio, clk, reset, phy, i2c,
> > > i2c-mux without rewriting half of the code. And also allows to easily
> > > swap the PCIe card to other slots/computer without having to modify t=
he
> > > description. =20
>=20
> > My proposal is to use overlays that card provides with itself.
> > These are supported mechanisms by Linux kernel. =20
>=20
> We have code for DT overlays in the kernel but it's not generically
> available.  There's issues with binding onto the platform device tree,
> though they're less of a problem with something like this where it seems
> to be a separate card with no cross links.

Indeed, the card does not have crosslinks with other devices and thus
it might be a solution to use a device-tree overlay (loaded from the
filesystem). But  I'm not sure if it's a good idea to do that on
a ACPI enabled platform.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
