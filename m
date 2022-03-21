Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAC74E246F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346384AbiCUKgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343869AbiCUKgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:36:32 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12E34F451;
        Mon, 21 Mar 2022 03:35:06 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DEC994000B;
        Mon, 21 Mar 2022 10:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647858905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gDN+CXjHQ/ODiqIi4dB5EG+EwVHDnIZuq5gJO2YW93I=;
        b=YAPDkLEccRFtepXqQK9cQ59TUdZ2aUHY90eETxmDDtopBwp0I/SYDIv8K/lLWe5Ucp0YZi
        QTRIP1c1lr0GUX/7UsUpG1EXs+OXZNhYjpm9RY0NDlSRp2D33MAasXX7A06ukSrZv79dP1
        +hmEVc8BB9NFQPqR/hKmKnpSTDvEEnV/KbpmOXusej+uZ2JnRHVEshCie1q7uTDjQJPs0Y
        6m7yGdCUz+5yKQal3KjxlHF6I+9xN3CNuRb9HNkWS/rVoiUEVSLPZTtvAZ66nGHTJpnLhx
        IQMzJ//4XyxHETcymPjwko6z7rlIbLx4W/+AHUymTjv5UOs9nGMM9ATbaa5IPQ==
Date:   Mon, 21 Mar 2022 11:33:41 +0100
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
Message-ID: <20220321113341.3c243e96@fixe.home>
In-Reply-To: <YjhUHjeqL2UpB0Gm@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
        <20220318160059.328208-2-clement.leger@bootlin.com>
        <YjSymEpNH8vnkQ+L@smile.fi.intel.com>
        <20220318174912.5759095f@fixe.home>
        <YjTK4UW7DwZ0S3QY@smile.fi.intel.com>
        <20220321084921.069c688e@fixe.home>
        <YjhUHjeqL2UpB0Gm@smile.fi.intel.com>
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

Le Mon, 21 Mar 2022 12:31:58 +0200,
Andy Shevchenko <andriy.shevchenko@linux.intel.com> a =C3=A9crit :

> >=20
> > IMHO, it would indeed be better. However,
> > fwnode_property_match_string() also allocates memory to do the same
> > kind of operation. Would you also like a callback for this one ? =20
>=20
> But matching string will need all of them to cover all possible cases.
> So, it doesn't rely on the certain index and needs allocation anyway.

Acked, it makes sense to keep it that way.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
