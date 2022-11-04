Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CE4619716
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiKDNJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiKDNJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:09:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3BB764B
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 06:09:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oqwRQ-0000Io-48; Fri, 04 Nov 2022 14:09:00 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5E89F112F56;
        Fri,  4 Nov 2022 13:08:58 +0000 (UTC)
Date:   Fri, 4 Nov 2022 14:08:57 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH net-next 0/14] pull-request: can-next 2022-10-31
Message-ID: <20221104130857.amzwa2mzmwhbljmk@pengutronix.de>
References: <20221031154406.259857-1-mkl@pengutronix.de>
 <20221031202714.1eada551@kernel.org>
 <Y2CpRfuto8wFrXX+@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fk2qhj5vkx72nsjx"
Content-Disposition: inline
In-Reply-To: <Y2CpRfuto8wFrXX+@kroah.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fk2qhj5vkx72nsjx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.11.2022 06:06:13, Greg Kroah-Hartman wrote:
> On Mon, Oct 31, 2022 at 08:27:14PM -0700, Jakub Kicinski wrote:
> > On Mon, 31 Oct 2022 16:43:52 +0100 Marc Kleine-Budde wrote:
> > > The first 7 patches are by Stephane Grosjean and Lukas Magel and
> > > target the peak_usb driver. Support for flashing a user defined device
> > > ID via the ethtool flash interface is added. A read only sysfs
> >=20
> > nit: ethtool eeprom set !=3D ethtool flash
> >=20
> > > attribute for that value is added to distinguish between devices via
> > > udev.
> >=20
> > So the user can write an arbitrary u32 value into flash which then
> > persistently pops up in sysfs across reboots (as a custom attribute
> > called "user_devid")?
> >=20
> > I don't know.. the whole thing strikes me as odd. Greg do you have any
> > feelings about such.. solutions?
> >=20
> > patches 5 and 6 here:
> > https://lore.kernel.org/all/20221031154406.259857-1-mkl@pengutronix.de/
>=20
> Device-specific attributes should be in the device-specific directory,
> not burried in a class directory somewhere that is generic like this one
> is.
>
> Why isn't this an attribute of the usb device instead?

What about:

| /sys/devices/pci0000:00/0000:00:13.0/usb1/1-1/1-1:1.0/device_id

> And there's no need to reorder the .h file includes in patch 06 while
> you are adding a sysfs entry, that should be a separate commit, right?

ACK

> Also, the line:
>=20
> +	.attrs	=3D (struct attribute **)peak_usb_sysfs_attrs,
>=20
> Is odd, there should never be a need to cast anything like this if you
> are doing things properly.

After marking the struct attribute not as const, we can remove the cast:

| --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
| +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
| @@ -64,14 +64,14 @@ static ssize_t user_devid_show(struct device *dev, st=
ruct device_attribute *attr
|  }
|  static DEVICE_ATTR_RO(user_devid);
| =20
| -static const struct attribute *peak_usb_sysfs_attrs[] =3D {
| +static struct attribute *peak_usb_sysfs_attrs[] =3D {
|         &dev_attr_user_devid.attr,
|         NULL,
|  };
| =20
|  static const struct attribute_group peak_usb_sysfs_group =3D {
|         .name   =3D "peak_usb",
| -       .attrs  =3D (struct attribute **)peak_usb_sysfs_attrs,
| +       .attrs  =3D peak_usb_sysfs_attrs,
|  };
| =20
|  /*

But this code is obsolete, if we move the sysfs entry into the USB
device.

> So this still needs work, sorry.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fk2qhj5vkx72nsjx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNlDucACgkQrX5LkNig
011PgQgAp0mgwOKFanZDebpnwjPwKyWmpaqX4Ulkp3TpScC8eXoyx95ZG5kOZUr2
4fEBvWK+ueMfo5Xl8a2G8LpZ47CnEMcumX1pf5Gvl5IWz5JF7LocH9PZdmgppcMb
gav4U5r3jrgTRgSGChTZyQ5KIbZhK98h3N1TDGJeAEjs0W1gNOBzTVF2gBguEbuw
zK5d0OojEcXhejwO0bArj3QUXALHNcmDEj4tF2lgkPudhgSns/9kRwuV9SgRGveA
GggKqvGklV9TUx2j1pBckl0jsogN30shZkZ1Evisev5RetAay51NxCIrUV03YZX4
wgjaZA/0yfE34oS3cQJwfMPmFX2GQA==
=fRxp
-----END PGP SIGNATURE-----

--fk2qhj5vkx72nsjx--
