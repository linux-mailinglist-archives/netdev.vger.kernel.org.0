Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E313EDAC6
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhHPQTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhHPQTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 12:19:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46FBC061796
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 09:18:28 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mFfJg-0002zI-Cx; Mon, 16 Aug 2021 18:18:24 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1mFfJe-0000OF-Ih; Mon, 16 Aug 2021 18:18:22 +0200
Date:   Mon, 16 Aug 2021 18:18:22 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression with commit e532a096be0e ("net: usb: asix: ax88772:
 add phylib support")
Message-ID: <20210816161822.td7jl4tv7zfbprty@pengutronix.de>
References: <3904c728-1ea2-9c2b-ec11-296396fd2f7e@linux.intel.com>
 <20210816081314.3b251d2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210816081314.3b251d2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:09:23 up 257 days,  6:15, 25 users,  load average: 0.01, 0.04,
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Aug 16, 2021 at 08:13:14AM -0700, Jakub Kicinski wrote:
> On Wed, 11 Aug 2021 17:55:34 +0300 Jarkko Nikula wrote:
> > Hi
> > 
> > Our ASIX USB ethernet adapter stopped working after v5.14-rc1. It 
> > doesn't get an IP from DHCP.
> > 
> > v5.13 works ok. v5.14-rc1 and today's head 761c6d7ec820 ("Merge tag 
> > 'arc-5.14-rc6' of 
> > git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc") show the 
> > regression.
> > 
> > I bisected regression into e532a096be0e ("net: usb: asix: ax88772: add 
> > phylib support").
> 
> Oleksij, any comments?

sorry, I lost it from radar.

> > Here's the dmesg snippet from working and non-working cases:
> > 
> > OK:
> > [    6.115773] asix 1-8:1.0 eth0: register 'asix' at usb-0000:00:14.0-8, 
> > ASIX AX88772 USB 2.0 Ethernet, 00:10:60:31:d5:f8
> > [    8.595202] asix 1-8:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0xC1E1
> > 
> > NOK:
> > [    6.511543] asix 1-8:1.0 eth0: register 'asix' at usb-0000:00:14.0-8, 
> > ASIX AX88772 USB 2.0 Ethernet, 00:10:60:31:d5:f8
> > [    8.518219] asix 1-8:1.0 eth0: Link is Down
> > 
> > lsusb -d 0b95:7720
> > Bus 001 Device 002: ID 0b95:7720 ASIX Electronics Corp. AX88772
> 

It sounds like issue which was fixed with the patch:
"net: usb: asix: ax88772: suspend PHY on driver probe"

This patch was taken in to v5.14-rc2. Can you please test it?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
