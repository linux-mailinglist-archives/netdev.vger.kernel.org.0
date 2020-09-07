Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD7E260507
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgIGTHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729225AbgIGTHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 15:07:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E3DC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 12:07:30 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFMU9-00070T-7E; Mon, 07 Sep 2020 21:07:25 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFMU7-0007TG-14; Mon, 07 Sep 2020 21:07:23 +0200
Date:   Mon, 7 Sep 2020 21:07:22 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, adam.rudzinski@arf.net.pl,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH net-next 3/3] net: phy: bcm7xxx: request and manage GPHY
 clock
Message-ID: <20200907190722.GA10378@pengutronix.de>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-4-f.fainelli@gmail.com>
 <20200904061558.s2s33nfof6itt24y@pengutronix.de>
 <ccfa67f5-d3dd-26a6-1bb8-9772e2434d82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccfa67f5-d3dd-26a6-1bb8-9772e2434d82@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:24:13 up 199 days,  5:41, 225 users,  load average: 0.21, 0.24,
 0.33
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-04 08:37, Florian Fainelli wrote:

...

> > Is this really necessary? The devm_clk_get_optional() function already
> > registers the devm_clk_release() hook.
> 
> Yes, because you can unbind the PHY driver from sysfs, and if you want to
> bind that driver again, which will call .probe() again, you must undo
> strictly everything that .probe() did. The embedded mdio_device does not go
> away, so there will be no automatic freeing of resources. Using devm_* may
> be confusing, so using just the plain clk_get() and clk_put() may be clearer
> here.

Hi Florian,

sorry for asking again... I'm getting a bit confused during applying
your comments to my smsc-phy patchset.
A few drivers are using the devm_kzalloc() (including your bcm7xxx.c and
my smsc.c). Does this mean that those drivers have a memory leak since
the mdio_device does not disappear and so the memory allocated during
probe() isn't freed?

Regards,
  Marco
