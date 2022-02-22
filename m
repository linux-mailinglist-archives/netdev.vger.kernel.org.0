Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66E74C0354
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 21:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiBVUtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 15:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbiBVUtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 15:49:42 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A95A6440;
        Tue, 22 Feb 2022 12:49:13 -0800 (PST)
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 555FBDA0A5;
        Tue, 22 Feb 2022 20:31:15 +0000 (UTC)
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 25F99C0006;
        Tue, 22 Feb 2022 20:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645561868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FtuFfP7bf62RQnyfTs94b0RuonH4es1pIRqKW4UPqno=;
        b=KCS9BQw4EXM0r3F6Qy8PQwVvNQ7vVbSfScLUDd5qlj9L6xFHzNeMytBYDdtUjLp+NLf/7D
        eB8BUUvhuSGyVXvKMYFZ4QS3U3H8wlPwnad/Rdab87Tm7xHx7TpJsbvZsqPsDHwT/txt2Q
        8ke/vmD66aEzhetPa3uJ3NfiVR0rzVGNBjb9Vnv2x7dwHTQjMZbe0G7uQevL2YGrwzMl8J
        K/467CqeyGs/wzEZ0k3pq+5VH7LiKpGrLu9YgDIVwkExgTBBWGbxi6emu/tEfmHRLVobpM
        ovVFE8ZsZ+mQfrW3VnYXDnwA189qF6QshKy8Ou/MaMCoTs2dxbbwSSPSmWmxcQ==
Date:   Tue, 22 Feb 2022 21:31:03 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC 09/10] i2c: mux: add support for fwnode
Message-ID: <YhVIB2VTFHyQ4yqx@piout.net>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-10-clement.leger@bootlin.com>
 <YhPSDTAPiTvEESnO@smile.fi.intel.com>
 <20220222095325.52419021@fixe.home>
 <YhTBo03f5pY+J/R6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YhTBo03f5pY+J/R6@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/02/2022 11:57:39+0100, Andrew Lunn wrote:
> On Tue, Feb 22, 2022 at 09:53:25AM +0100, Clément Léger wrote:
> > Le Mon, 21 Feb 2022 19:55:25 +0200,
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
> > 
> > > On Mon, Feb 21, 2022 at 05:26:51PM +0100, Clément Léger wrote:
> > > > Modify i2c_mux_add_adapter() to use with fwnode API to allow creating
> > > > mux adapters with fwnode based devices. This allows to have a node
> > > > independent support for i2c muxes.  
> > > 
> > > I^2C muxes have their own description for DT and ACPI platforms, I'm not sure
> > > swnode should be used here at all. Just upload a corresponding SSDT overlay or
> > > DT overlay depending on the platform. Can it be achieved?
> > > 
> > 
> > Problem is that this PCIe card can be plugged either in a X86 platform
> > using ACPI or on a ARM one with device-tree. So it means I should have
> > two "identical" descriptions for each platforms.
> 
> ACPI != DT.
> 
> I know people like stuffing DT properties into ACPI tables, when ACPI
> does not have a binding. But in this case, there is a well defined
> ACPI mechanism for I2C muxes. You cannot ignore it because it is
> different to DT. So you need to handle the muxes in both the ACPI way
> and the DT way.
> 
> For other parts of what you are doing, you might be able to get away
> by just stuffing DT properties into ACPI tables. But that is not for
> me to decide, that is up to the ACPI maintainers.
> 

What I'm wondering is why you would have to stuff anything in ACPI when
plugging any PCIe card in a PC. Wouldn't that be a first?

I don't have to do so when plugging an Intel network card, I don't
expect to have to do it when plugging any other network card...

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
