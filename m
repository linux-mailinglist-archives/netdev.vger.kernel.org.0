Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201A449F84E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbiA1L1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbiA1L1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:27:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D02C06173B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 03:27:18 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nDPPL-0003CI-EI; Fri, 28 Jan 2022 12:27:11 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nDPPG-00CeA2-HH; Fri, 28 Jan 2022 12:27:06 +0100
Date:   Fri, 28 Jan 2022 12:27:06 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfPTCmMDlXD1UHx9@pengutronix.de>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
 <YfJ+ceEzvzMM1JsW@kroah.com>
 <YfLPvF6pmcL1UG2f@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfLPvF6pmcL1UG2f@rowland.harvard.edu>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:12:48 up 92 days, 17:40, 116 users,  load average: 0.32, 1.33,
 6.79
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:00:44PM -0500, Alan Stern wrote:
> On Thu, Jan 27, 2022 at 12:13:53PM +0100, Greg KH wrote:
> > On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> > > The weakest link of usbnet devices is the USB cable.
> > 
> > The weakest link of any USB device is the cable, why is this somehow
> > special to usbnet devices?
> > 
> > > Currently there is
> > > no way to automatically detect cable related issues except of analyzing
> > > kernel log, which would differ depending on the USB host controller.
> > > 
> > > The Ethernet packet counter could potentially show evidence of some USB
> > > related issues, but can be Ethernet related problem as well.
> > > 
> > > To provide generic way to detect USB issues or HW issues on different
> > > levels we need to make use of devlink.
> > 
> > Please make this generic to all USB devices, usbnet is not special here
> > at all.
> 
> Even more basic question: How is the kernel supposed to tell the 
> difference between a USB issue and a HW issue?  That is, by what 
> criterion do you decide which category a particular issue falls under?

In case of networking device, from user space perspective, we have a
communication issue with some external device over the Ethernet.
So, depending on the health state of following chain:
cpu->hcd->USB cable->ethernet_controller->ethernet_cable-<...

We need to decide what to do, and what can be done automatically by
device itself, for example Mars rover :) The user space should get as
much information as possible what's going on in the system, to decide
the proper measures to fix or mitigate the problem. System designers
usually (hopefully) find out during testing what URB status and IP
uplink status for that hardware means and how to fix that.

Regards,
Oleksij & Marc
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
