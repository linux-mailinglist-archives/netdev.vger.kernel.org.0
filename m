Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947F3530DF6
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbiEWKOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiEWKOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:14:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9A825C50
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:14:02 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nt54T-0006QP-Ud; Mon, 23 May 2022 12:13:53 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nt54S-0001yL-Nx; Mon, 23 May 2022 12:13:52 +0200
Date:   Mon, 23 May 2022 12:13:52 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Hans Ulli Kroll <linux@ulli-kroll.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 00/10] RTW88: Add support for USB variants
Message-ID: <20220523101352.GM25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <55f569899e4e894970b826548cd5439f5def2183.camel@ulli-kroll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55f569899e4e894970b826548cd5439f5def2183.camel@ulli-kroll.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:08:14 up 53 days, 22:37, 77 users,  load average: 0.16, 0.21,
 0.16
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 06:07:16AM +0200, Hans Ulli Kroll wrote:
> On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> > This series adds support for the USB chip variants to the RTW88 driver.
> > 
> 
> Hi Sascha
> 
> glad you found some *working* devices for rtw88 !
> 
> I spend some of the weekend testing your driver submission.
> 
> for rtl8821cu devices I get following output
> 
> some Logilink device
> 
> [ 1686.605567] usb 1-5.1.2: New USB device found, idVendor=0bda, idProduct=c811, bcdDevice=
> 2.00

Most devices in the driver are described as:

	USB_DEVICE_AND_INTERFACE_INFO(0x0bda, 0xc82c, 0xff, 0xff, 0xff),

This particular one has:

	USB_DEVICE(0x0bda, 0xc811),

When I use USB_DEVICE() instead of USB_DEVICE_AND_INTERFACE_INFO() on my
device then the Wifi driver tries to bind to the bluetooth interface on
the same device which then fails with similar error messages. Maybe you
have to use

	USB_DEVICE_AND_INTERFACE_INFO(0x0bda, 0xc811, 0xff, 0xff, 0xff)

instead. I could imagine that the plain USB_DEVICE() once worked for you
because the bluetooth driver was faster to probe and only left the Wifi
interface free for the Wifi driver to probe.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
