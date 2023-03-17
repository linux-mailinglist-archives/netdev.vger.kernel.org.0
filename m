Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0F16BEB36
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjCQO3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCQO3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D747D9C;
        Fri, 17 Mar 2023 07:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B8F66226B;
        Fri, 17 Mar 2023 14:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56996C433EF;
        Fri, 17 Mar 2023 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679063351;
        bh=D3V8W1v72x8mIyG6Ens123mTd1y9kzSOKpYqPHAW7PI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q+s8F3AifNO8AjIPQqst3WN0ZV1pQbk/u2d2LqRK7UFa6YE2z1vkD54OjQTS+4ZOI
         DyuO0zIZp/owksQ8P7mMM3T6NxuA2gXorXMTxGOqcGJxLXc9ngARElCL+kjL8Mikxh
         I4Fhz96bxyYMzTDzDJSZUym5APnit9NfuQ8NXW8AZWpkMcBHvQ2vkCEP7VHweXa4qx
         S4zpmyUnKgxiLtwMmwLerzXULgndMvbe3YxP9o613kl1UkTluLEFrGxk9lZN/GdmjU
         Zeo0Kkasggy+uKf3s1v1/G04wpocS/xU0YoFr8UaSCVpfgzn8hpdcAcEoNo9P0N6bO
         wxJmhbdiEyRdw==
Date:   Fri, 17 Mar 2023 15:29:03 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v4 04/14] net: phy: Add a binding for PHY LEDs
Message-ID: <20230317152903.5103f2c4@dellmb>
In-Reply-To: <6cf03603-2a8e-4c08-a61b-aef164a0f5d9@lunn.ch>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
        <20230317023125.486-5-ansuelsmth@gmail.com>
        <20230317084519.12d3587a@dellmb>
        <6cf03603-2a8e-4c08-a61b-aef164a0f5d9@lunn.ch>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.35; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 14:55:11 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, Mar 17, 2023 at 08:45:19AM +0100, Marek Beh=C3=BAn wrote:
> > On Fri, 17 Mar 2023 03:31:15 +0100
> > Christian Marangi <ansuelsmth@gmail.com> wrote:
> >  =20
> > > +	cdev->brightness_set_blocking =3D phy_led_set_brightness;
> > > +	cdev->max_brightness =3D 1;
> > > +	init_data.devicename =3D dev_name(&phydev->mdio.dev);
> > > +	init_data.fwnode =3D of_fwnode_handle(led);
> > > +
> > > +	err =3D devm_led_classdev_register_ext(dev, cdev, &init_data); =20
> >=20
> > Since init_data.devname_mandatory is false, devicename is ignored.
> > Which is probably good, becuse the device name of a mdio device is
> > often ugly, taken from devicetree or switch drivers, for example:
> >   f1072004.mdio-mii
> >   fixed-0
> >   mv88e6xxx-1
> > So either don't fill devicename or use devname_mandatory (and maybe
> > fill devicename with something less ugly, but I guess if we don't have
> > much choice if we want to keep persistent names).
> >=20
> > Without devname_mandatory, the name of the LED classdev will be of the
> > form
> >   color:function[-function-enumerator],
> > i.e.
> >   green:lan
> >   amber:lan-1
> >=20
> > With multiple switch ethenret ports all having LAN function, it is
> > worth noting that the function enumerator must be explicitly used in the
> > devicetree, otherwise multiple LEDs will be registered under the same
> > name, and the LED subsystem will add a number at the and of the name
> > (function led_classdev_next_name), resulting in names
> >   green:lan
> >   green:lan_1
> >   green:lan_2
> >   ... =20
>=20
> I'm testing on a Marvell RDK, with limited LEDs. It has one LED on the
> front port to represent the WAN port. The DT patch is at the end of
> the series. With that, i end up with:
>=20
> root@370rd:/sys/class/leds# ls -l
> total 0
> lrwxrwxrwx 1 root root 0 Mar 17 01:10 f1072004.mdio-mii:00:WAN -> ../../d=
evices/platform/soc/soc:interna
> l-regs/f1072004.mdio/mdio_bus/f1072004.mdio-mii/f1072004.mdio-mii:00/leds=
/f1072004.mdio-mii:00:WAN
>=20
> I also have:
>=20
> root@370rd:/sys/class/net/eth0/phydev/leds# ls
> f1072004.mdio-mii:00:WAN

Hmm, yes I see.  If label is specified, devicename is used even if
devname_mandatory is false.

> f1072004.mdio-mii:00: is not nice, but it is unique to a netdev. The
> last part then comes from the label property. Since there is only one
> LED, i went with what the port is intended to be used as. If there had
> been more LEDs, i would of probably used labels like "LINK" and
> "ACTIVITY", since that is often what they reset default
> to. Alternatively, you could names the "Left" and "Right", which does
> suggest they can be given any function.
>=20
> I don't actually think the name is too important, so long as it is
> unique. You are going to find it via /sys/class/net. MAC LEDs should
> be /sys/class/net/eth42/leds, and PHY LEDs will be
> /sys/class/net/phydev/leds.

Maybe the name may not be that important from the perspective of a user
who just wants to find the LED for a given phy, yes, but the
proposal of how LED classdev should be named was done in good faith
and accepted years ago. The documentation still defines the name format
and until that part of documenation is changed, I think we should at
least try to follow it.

Also, the label DT property has been deprecated for LEDs. IMO it should
be removed from that last patch of this series.

> It has been discussed in the past to either extend ethtool to
> understand this, or write a new little tool to make it easier to
> manipulate these LEDs.

Yes, and this would solve the problem for a user who wants to change
the behaviour of a LED for a given PHY. But a user who wants to list
all available LEDs by listing /sys/class/leds can also retrieve a nice
list of names that make sense, if the documented format is followed.

Marek
