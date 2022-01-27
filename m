Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6F49E0AE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240081AbiA0LXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiA0LXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:23:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8659EC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:23:14 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2rq-000536-AJ; Thu, 27 Jan 2022 12:23:06 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nD2rp-0008BL-JU; Thu, 27 Jan 2022 12:23:05 +0100
Date:   Thu, 27 Jan 2022 12:23:05 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from
 device tree
Message-ID: <20220127112305.GC9150@pengutronix.de>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
 <YfJ6lhZMAEmetdad@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfJ6lhZMAEmetdad@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:08:34 up 47 days, 19:54, 83 users,  load average: 0.10, 0.22,
 0.25
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:57:26AM +0100, Greg KH wrote:
> On Thu, Jan 27, 2022 at 11:49:05AM +0100, Oleksij Rempel wrote:
> > Similar to the option to set a netdev name in device tree for switch
> > ports by using the property "label" in the DSA framework, this patch
> > adds this functionality to the usbnet infrastructure.
> > 
> > This will help to name the interfaces properly throughout supported
> > devices. This provides stable interface names which are useful
> > especially in embedded use cases.
> 
> Stable interface names are for userspace to set, not the kernel.
> 
> Why would USB care about this?  If you need something like this, get it
> from the USB device itself, not DT, which should have nothing to do with
> USB as USB is a dynamic, self-describing, bus.  Unlike DT.
> 
> So I do not think this is a good idea.

This is needed for embedded devices with integrated USB Ethernet
controller. Currently I have following use cases to solve:
- Board with one or multiple USB Ethernet controllers with external PHY.
  The PHY need devicetree to describe IRQ, clock sources, label on board, etc.
- Board with USB Ethernet controller with DSA switch. The USB ethernet
  controller is attached to the CPU port of DSA switch. In this case,
  DSA switch is the sub-node of the USB device. The CPU port should have
  stable name for all device related to this product.

Using user space tools to name interfaces would double the maintenance
of similar information: DT - describing the HW + udev scripts describing
same HW again.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
