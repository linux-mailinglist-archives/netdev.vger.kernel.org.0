Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B193D4C34D3
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiBXSkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiBXSkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:40:31 -0500
X-Greylist: delayed 166129 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 10:39:59 PST
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0CC25D6FC;
        Thu, 24 Feb 2022 10:39:59 -0800 (PST)
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 91D231BF203;
        Thu, 24 Feb 2022 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645727998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ekM1W1uzOOxfBmlQ7EQovp83hvSwhF7Ii2bJO1V+DjA=;
        b=Sg9IJ5Z1f7t8z9TDjBOQ+4Q4gutrAaWI9EO8jWgu1v/s90TYOBuytik28VhCe2s5DSIMU2
        X3Tg8bDOWONL/MiRpodw2q83J69VOdIhpor0Fdol52NDbYplXMhjonfxZlYtEPgUT7JoEX
        srwv1EBOIMIXT5D7GDhbZFz1khD5DectJmTWjdRiyZlbMEIEos9Xbp/uMs/6Sg8zik1jAo
        7Ge/yJY9L4BQ1JPHUMX4jDNeXaoIkPt1Xzkl7xoGWDXaUEg8qmFviUho5eh7yMwdZUiodP
        G+0Ljc1J8oasASN0u+vkVVOroUM7DTQveVQvzDoB56f6HSxBMgoP/0P9qupS3g==
Date:   Thu, 24 Feb 2022 19:39:52 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <YhfQ+MCYxrdDqN9J@piout.net>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220224154040.2633a4e4@fixe.home>
 <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
 <YhelOFYKBsfQ8SRW@sirena.org.uk>
 <YhfLG6wlFvYY3YU8@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhfLG6wlFvYY3YU8@paasikivi.fi.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2022 20:14:51+0200, Sakari Ailus wrote:
> Hi Mark,
> 
> On Thu, Feb 24, 2022 at 03:33:12PM +0000, Mark Brown wrote:
> > On Thu, Feb 24, 2022 at 03:58:04PM +0100, Hans de Goede wrote:
> > 
> > > As Mark already mentioned the regulator subsystem has shown to
> > > be a bit problematic here, but you don't seem to need that?
> > 
> > I believe clocks are also potentially problematic for similar reasons
> > (ACPI wants to handle those as part of the device level power management
> > and/or should have native abstractions for them, and I think we also
> > have board file provisions that work well for them and are less error
> > prone than translating into an abstract data structure).
> 
> Per ACPI spec, what corresponds to clocks and regulators in DT is handled
> through power resources. This is generally how things work in ACPI based
> systems but there are cases out there where regulators and/or clocks are
> exposed to software directly. This concerns e.g. camera sensors and lens
> voice coils on some systems while rest of the devices in the system are
> powered on and off the usual ACPI way.
> 
> So controlling regulators or clocks directly on an ACPI based system
> wouldn't be exactly something new. All you need to do in that case is to
> ensure that there's exactly one way regulators and clocks are controlled
> for a given device. For software nodes this is a non-issue.
> 
> This does have the limitation that a clock or a regulator is either
> controlled through power resources or relevant drivers, but that tends to
> be the case in practice. But I presume it wouldn't be different with board
> files.
> 

In this use case, we don't need anything that is actually described in
ACPI as all the clocks we need to control are on the device itself so I
don't think this is relevant here.

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
