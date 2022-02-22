Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9B4BF3CD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiBVIiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiBVIit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:38:49 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F163F931A4;
        Tue, 22 Feb 2022 00:38:21 -0800 (PST)
Received: from relay1-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::221])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 53506D5FE5;
        Tue, 22 Feb 2022 08:16:15 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9F63524000E;
        Tue, 22 Feb 2022 08:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645517768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Natz2NWgWvho24fzbCnusdUGHKptahSa6WvIBwYrqSQ=;
        b=VFqnw5A4k32g9vv1hZ1WxHt+0LScib2vaHxuNFrVQIzAbiNQvi9w9aozpXKFol2lRZqOVF
        95IeseqOVi5x429kyWRL3YziWtD4op8InbwsyCh22H1/S+qxJAAQzfSnAqnO7yh9RiQMCh
        dfcoOFtLIT6xK/3ZZdXAboxypJh81/YGzAKPdQ7WfrdEmAWrErp931dGktpL9wkV6aBF7Y
        NAkjIKRKrcpclQvSdkMlhORlS5hdyAFJNQx2ktDQWdvHcnFI6GReL7Fp4fUVBeHjGpZAFj
        7YV4vP2R0KG2+wv2089hfUC+xiBahzcZR5T0UpD7rEKQUg18k7/YjQ0c6ae6Ig==
Date:   Tue, 22 Feb 2022 09:14:47 +0100
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
Subject: Re: [RFC 01/10] property: add fwnode_match_node()
Message-ID: <20220222091447.4afa940a@fixe.home>
In-Reply-To: <YhPPlFZGFvbNs+ZJ@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
        <20220221162652.103834-2-clement.leger@bootlin.com>
        <YhPPlFZGFvbNs+ZJ@smile.fi.intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 21 Feb 2022 19:44:52 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> On Mon, Feb 21, 2022 at 05:26:43PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add a function equivalent to of_match_node() which is usable for
> > fwnode support. Matching is based on the compatible property and it
> > returns the best matches for the node according to the compatible
> > list ordering. =20
>=20
> Not sure I understand the purpose of this API.
> We have device_get_match_data(), maybe you want similar for fwnode?
>=20

Hi Andy,

Actually device_get_match_data() is calling the .device_get_match_data
callback of the dev fwnode. This function is meant to be used by the
next patch (fwnode_get_match_data()) to be used as a generic fwnode
operation and thus be usable with software_node.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
