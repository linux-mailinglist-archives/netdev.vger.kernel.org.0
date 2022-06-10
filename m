Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C625D546750
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 15:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245504AbiFJN0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 09:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbiFJN0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 09:26:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12601D9B7C
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 06:26:42 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nzeei-00034e-KG; Fri, 10 Jun 2022 15:26:28 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nzeeh-0008VP-8f; Fri, 10 Jun 2022 15:26:27 +0200
Date:   Fri, 10 Jun 2022 15:26:27 +0200
From:   "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>
Subject: Re: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Message-ID: <20220610132627.GO1615@pengutronix.de>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
 <20220530135457.1104091-11-s.hauer@pengutronix.de>
 <1493412d473614dfafd4c03832e71f86831fa43b.camel@realtek.com>
 <20220531074244.GN1615@pengutronix.de>
 <8443f8e51774a4f80fed494321fcc410e7174bf1.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8443f8e51774a4f80fed494321fcc410e7174bf1.camel@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 12:51:49PM +0000, Ping-Ke Shih wrote:
> On Tue, 2022-05-31 at 09:42 +0200, s.hauer@pengutronix.de wrote:
> > On Tue, May 31, 2022 at 01:07:36AM +0000, Ping-Ke Shih wrote:
> > > On Mon, 2022-05-30 at 15:54 +0200, Sascha Hauer wrote:
> > > > The powersave modes do not work with USB devices (tested with a
> > > > RTW8822CU) properly. With powersave modes enabled the driver issues
> > > > messages like:
> > > > 
> > > > rtw_8822cu 1-1:1.2: firmware failed to leave lps state
> > > > rtw_8822cu 1-1:1.2: timed out to flush queue 3
> > > 
> > > Could you try module parameter rtw_disable_lps_deep_mode=1 to see
> > > if it can work?
> > 
> > No, this module parameter doesn't seem to make any difference.
> > 
> > # cat /sys/module/rtw88_core/parameters/disable_lps_deep
> > Y
> > 
> > Still "firmware failed to leave lps state" and poor performance.
> > 
> > Any other ideas what may go wrong here?
> > 
> 
> Today, I borrow a 8822cu, and use your patchset but revert
> patch 10/10 to reproduce this issue. With firmware 7.3.0,
> it looks bad. After checking something about firmware, I
> found the firmware is old, so upgrade to 9.9.11, and then
> it works well for 10 minutes, no abnormal messages.

I originally used firmware 5.0.0. Then I have tried 9.9.6 I have lying
around here from my distro. That version behaves like the old 5.0.0
version. Finally I switched to 9.9.11 from current linux-firmware
repository. That doesn't work at all for me unfortunately:

[  221.076279] rtw_8822cu 2-1:1.2: Firmware version 9.9.11, H2C version 15
[  221.078405] rtw_8822cu 2-1:1.2: Firmware version 9.9.4, H2C version 15
[  239.783261] wlan0: authenticate with 76:83:c2:ce:83:0b
[  242.398435] wlan0: send auth to 76:83:c2:ce:83:0b (try 1/3)
[  242.402992] wlan0: authenticated
[  242.420735] wlan0: associate with 76:83:c2:ce:83:0b (try 1/3)
[  242.437094] wlan0: RX AssocResp from 76:83:c2:ce:83:0b (capab=0x1411 status=0 aid=4)
[  242.485521] wlan0: associated
[  242.564847] wlan0: Connection to AP 76:83:c2:ce:83:0b lost
[  244.577617] wlan0: authenticate with 76:83:c2:cd:83:0b
[  244.578257] wlan0: bad VHT capabilities, disabling VHT
[  246.866182] wlan0: send auth to 76:83:c2:cd:83:0b (try 1/3)
[  246.871830] wlan0: authenticated
[  246.892754] wlan0: associate with 76:83:c2:cd:83:0b (try 1/3)
[  246.911045] wlan0: RX AssocResp from 76:83:c2:cd:83:0b (capab=0x1431 status=0 aid=3)
[  246.940608] wlan0: associated
[  247.152308] wlan0: Connection to AP 76:83:c2:cd:83:0b lost
[  248.912821] wlan0: Connection to AP 00:00:00:00:00:00 lost
[  249.105517] wlan0: authenticate with 76:83:c2:ce:83:0b
[  251.482183] wlan0: send auth to 76:83:c2:ce:83:0b (try 1/3)
[  251.486765] wlan0: authenticated
[  251.508731] wlan0: associate with 76:83:c2:ce:83:0b (try 1/3)
[  251.521904] wlan0: RX AssocResp from 76:83:c2:ce:83:0b (capab=0x1411 status=0 aid=4)
[  251.565233] wlan0: associated
[  251.720602] wlan0: Connection to AP 76:83:c2:ce:83:0b lost
[  253.527904] wlan0: Connection to AP 00:00:00:00:00:00 lost
[  253.728243] wlan0: authenticate with 76:83:c2:cd:83:0b
[  253.728921] wlan0: bad VHT capabilities, disabling VHT
[  256.014184] wlan0: send auth to 76:83:c2:cd:83:0b (try 1/3)
[  256.019608] wlan0: authenticated
[  256.044702] wlan0: associate with 76:83:c2:cd:83:0b (try 1/3)
[  256.062049] wlan0: RX AssocResp from 76:83:c2:cd:83:0b (capab=0x1431 status=0 aid=3)
[  256.093117] wlan0: associated
[  256.169071] wlan0: Connection to AP 76:83:c2:cd:83:0b lost
[  258.145286] wlan0: authenticate with 76:83:c2:ce:83:0b
[  260.626182] wlan0: send auth to 76:83:c2:ce:83:0b (try 1/3)
[  260.630495] wlan0: authenticated
[  260.652783] wlan0: associate with 76:83:c2:ce:83:0b (try 1/3)
[  260.666201] wlan0: RX AssocResp from 76:83:c2:ce:83:0b (capab=0x1411 status=0 aid=4)
[  260.708596] wlan0: associated
[  260.769613] wlan0: Connection to AP 76:83:c2:ce:83:0b lost
[  262.770668] wlan0: authenticate with 76:83:c2:cd:83:0b
[  262.771272] wlan0: bad VHT capabilities, disabling VHT
[  265.158184] wlan0: send auth to 76:83:c2:cd:83:0b (try 1/3)

This goes on forever. I finally tried 9.9.10 and 9.9.9, they also behave
like 9.9.11.

No luck today :(

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
