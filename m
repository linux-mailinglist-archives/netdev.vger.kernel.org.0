Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE42E4E2195
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345037AbiCUHwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiCUHwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:52:14 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78235286E2;
        Mon, 21 Mar 2022 00:50:47 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B2A3A1BF20E;
        Mon, 21 Mar 2022 07:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647849044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyewfmDrMNw+w6+feNe7eI+y5/zMvOy/2DQM7Bmk60I=;
        b=ncVvFFrRh9wP2PFth4q+uYSwK+8q26M1t++LZ7geib9/toPxbqT3NzW+FNLv4W+YRPiq/C
        i2xyQFIeyW7jDZPFPfGbLGyrdi4WXgveVFAD7tYOLdn/fNMhSUMnGEjMCvaQI88PZbxqlr
        GMpSMwIBfwWopJsAW1l452eWa+JNmx9GBIXsksq5fZWxpBxUqQlPgZOTRpTAP4HXiPrbIH
        VHGX9CyV+Mfg+qfHxduN0BAX5jR8S5byV6rM1uCUEJbracEhv3F852UUNYUzOc+NQwSCDV
        PeNcafchnRU5Oe6znE6OIgTRi1ojJqu8HX3CVg1R7/ed0GUIFLSevp0tUKUnoA==
Date:   Mon, 21 Mar 2022 08:49:21 +0100
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
Message-ID: <20220321084921.069c688e@fixe.home>
In-Reply-To: <YjTK4UW7DwZ0S3QY@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
        <20220318160059.328208-2-clement.leger@bootlin.com>
        <YjSymEpNH8vnkQ+L@smile.fi.intel.com>
        <20220318174912.5759095f@fixe.home>
        <YjTK4UW7DwZ0S3QY@smile.fi.intel.com>
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

Le Fri, 18 Mar 2022 20:09:37 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Fri, Mar 18, 2022 at 05:49:12PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Le Fri, 18 Mar 2022 18:26:00 +0200,
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit : =20
> > > On Fri, Mar 18, 2022 at 05:00:47PM +0100, Cl=C3=A9ment L=C3=A9ger wro=
te: =20
> > > > Add fwnode_property_read_string_index() function which allows to
> > > > retrieve a string from an array by its index. This function is the
> > > > equivalent of of_property_read_string_index() but for fwnode suppor=
t.   =20
>=20
> ...
>=20
> > > > +	values =3D kcalloc(nval, sizeof(*values), GFP_KERNEL);
> > > > +	if (!values)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	ret =3D fwnode_property_read_string_array(fwnode, propname, value=
s, nval);
> > > > +	if (ret < 0)
> > > > +		goto out;
> > > > +
> > > > +	*string =3D values[index];
> > > > +out:
> > > > +	kfree(values);   =20
> > >=20
> > > Here is UAF (use after free). How is it supposed to work? =20
> >=20
> > values is an array of pointers. I'm only retrieving a pointer out of
> > it. =20
>=20
> I see, thanks for pointing out.
>=20
> Nevertheless, I don't like the idea of allocating memory in this case.
> Can we rather add a new callback that will provide us the necessary
> property directly?
>=20

IMHO, it would indeed be better. However,
fwnode_property_match_string() also allocates memory to do the same
kind of operation. Would you also like a callback for this one ?

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
