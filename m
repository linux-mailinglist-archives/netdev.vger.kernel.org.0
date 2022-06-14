Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1F54AA0A
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351797AbiFNHHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 03:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiFNHHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 03:07:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316063A180
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 00:06:59 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o10dV-0008My-OX; Tue, 14 Jun 2022 09:06:49 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o10dT-0007Uk-Kn; Tue, 14 Jun 2022 09:06:47 +0200
Date:   Tue, 14 Jun 2022 09:06:47 +0200
From:   "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Message-ID: <20220614070647.GP1615@pengutronix.de>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
 <20220530135457.1104091-11-s.hauer@pengutronix.de>
 <1493412d473614dfafd4c03832e71f86831fa43b.camel@realtek.com>
 <20220531074244.GN1615@pengutronix.de>
 <8443f8e51774a4f80fed494321fcc410e7174bf1.camel@realtek.com>
 <20220610132627.GO1615@pengutronix.de>
 <5ee547c352caee7c2ba8c0f541a305abeef0af9c.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ee547c352caee7c2ba8c0f541a305abeef0af9c.camel@realtek.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 12:02:23AM +0000, Ping-Ke Shih wrote:
> On Fri, 2022-06-10 at 15:26 +0200, s.hauer@pengutronix.de wrote:
> > On Thu, Jun 09, 2022 at 12:51:49PM +0000, Ping-Ke Shih wrote:
> > > 
> > > Today, I borrow a 8822cu, and use your patchset but revert
> > > patch 10/10 to reproduce this issue. With firmware 7.3.0,
> > > it looks bad. After checking something about firmware, I
> > > found the firmware is old, so upgrade to 9.9.11, and then
> > > it works well for 10 minutes, no abnormal messages.
> > 
> > I originally used firmware 5.0.0. Then I have tried 9.9.6 I have lying
> > around here from my distro. That version behaves like the old 5.0.0
> > version. Finally I switched to 9.9.11 from current linux-firmware
> > repository. That doesn't work at all for me unfortunately:
> > 
> > [  221.076279] rtw_8822cu 2-1:1.2: Firmware version 9.9.11, H2C version 15
> > [  221.078405] rtw_8822cu 2-1:1.2: Firmware version 9.9.4, H2C version 15
> > [  239.783261] wlan0: authenticate with 76:83:c2:ce:83:0b
> > [  242.398435] wlan0: send auth to 76:83:c2:ce:83:0b (try 1/3)
> > [  242.402992] wlan0: authenticated
> > [  242.420735] wlan0: associate with 76:83:c2:ce:83:0b (try 1/3)
> > [  242.437094] wlan0: RX AssocResp from 76:83:c2:ce:83:0b (capab=0x1411 status=0 aid=4)
> > [  242.485521] wlan0: associated
> > [  242.564847] wlan0: Connection to AP 76:83:c2:ce:83:0b lost
> > [  244.577617] wlan0: authenticate with 76:83:c2:cd:83:0b
> > [  244.578257] wlan0: bad VHT capabilities, disabling VHT
> > 
> > This goes on forever. I finally tried 9.9.10 and 9.9.9, they also behave
> > like 9.9.11.
> > 
> 
> Please help do more experiements on your 8822cu with the
> latest firmware 9.9.11.
> 
> 1. which module RFE type you are using?
>    My 8822cu is RFE type 4.
>    Get this information from 
> 
>    cat /sys/kernel/debug/ieee80211/phyXXX/rtw88/coex_info
> 
>    The 4th line:
>    Mech/ RFE                                = Non-Shared/ 4  

I have:

Mech/ RFE                                = Shared/ 3

As you mention this I remember that I added this hunk to rtw8822c.c:

@@ -4895,6 +4916,8 @@ static const struct rtw_rfe_def rtw8822c_rfe_defs[] = {
        [0] = RTW_DEF_RFE(8822c, 0, 0),
        [1] = RTW_DEF_RFE(8822c, 0, 0),
        [2] = RTW_DEF_RFE(8822c, 0, 0),
+       [3] = RTW_DEF_RFE(8822c, 0, 0),
+       [4] = RTW_DEF_RFE(8822c, 0, 0),
        [5] = RTW_DEF_RFE(8822c, 0, 5),
        [6] = RTW_DEF_RFE(8822c, 0, 0),
 };

I copied [4] from Hans Ulli Krolls repository, but the [3] entry needed
for my hardware I made up myself. I don't know if that's correct and
what difference it makes, but I stopped thinking about it when I
realized that it works.

> 
> 4. Disable power save to see if it still disconnect from AP
> 
>    iw wlan0 set power_save off
> 
>    If this can work well, still power save mode works abnormal.

With powersave disabled it still doesn't work.

> 
> 3. Disable keep-alive. (with power_save on)
> 
> --- a/main.c
> +++ b/main.c
> @@ -2199,6 +2199,7 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
>         ieee80211_hw_set(hw, HAS_RATE_CONTROL);
>         ieee80211_hw_set(hw, TX_AMSDU);
>         ieee80211_hw_set(hw, SINGLE_SCAN_ON_ALL_BANDS);
> +       ieee80211_hw_set(hw, CONNECTION_MONITOR);
> 
>    This can make it still connected even it doesn't receive anything.
>    Check if it can leave power save without abnormal messages.
> 
> 4. USB interference
> 
>    Very low possibility, but simply try USB 2.0 and 3.0 ports.

Surprisingly this really makes a difference. I have a EHCI port which I
used up to now. One other port is behind a XHCI controller and on that
port the device behaves much better, but still far from perfect.

> 
> 5. Try another AP working on different band (2.4GHz or 5Ghz)

I have tried two access points in both 2.4GHt and 5GHz bands. That
doesn't make any significant difference.

Some other things I saw yesterday during testing:

I've seen this more than once:

[  249.914750] rtw_8822cu 4-1:1.2: error beacon valid
[  249.914890] rtw_8822cu 4-1:1.2: Download probe request to firmware failed
[  249.914903] rtw_8822cu 4-1:1.2: Update probe request failed
[  249.925005] rtw_8822cu 4-1:1.2: HW scan failed with status: -16
[  251.246244] rtw_8822cu 4-1:1.2: error beacon valid
[  251.246387] rtw_8822cu 4-1:1.2: Download probe request to firmware failed
[  251.246400] rtw_8822cu 4-1:1.2: Update probe request failed
[  251.255539] rtw_8822cu 4-1:1.2: HW scan failed with status: -16
[  262.611263] rtw_8822cu 4-1:1.2: error beacon valid

With powersave enabled I saw this while pinging the device from a remote
host:

64 bytes from 192.168.0.196: icmp_seq=304 ttl=64 time=169 ms
64 bytes from 192.168.0.196: icmp_seq=305 ttl=64 time=15405 ms
64 bytes from 192.168.0.196: icmp_seq=306 ttl=64 time=14395 ms
64 bytes from 192.168.0.196: icmp_seq=307 ttl=64 time=13371 ms
64 bytes from 192.168.0.196: icmp_seq=310 ttl=64 time=10300 ms
64 bytes from 192.168.0.196: icmp_seq=311 ttl=64 time=9276 ms
64 bytes from 192.168.0.196: icmp_seq=312 ttl=64 time=8252 ms
64 bytes from 192.168.0.196: icmp_seq=313 ttl=64 time=7229 ms
64 bytes from 192.168.0.196: icmp_seq=314 ttl=64 time=6205 ms
64 bytes from 192.168.0.196: icmp_seq=315 ttl=64 time=5181 ms
64 bytes from 192.168.0.196: icmp_seq=316 ttl=64 time=4154 ms
64 bytes from 192.168.0.196: icmp_seq=317 ttl=64 time=3130 ms
64 bytes from 192.168.0.196: icmp_seq=318 ttl=64 time=2110 ms
64 bytes from 192.168.0.196: icmp_seq=319 ttl=64 time=1087 ms
64 bytes from 192.168.0.196: icmp_seq=320 ttl=64 time=63.8 ms

You see that we have a 16s lag and then all of a sudden the answer to 16
ping packets come in at once.

This all looks very erratic now. I would be grateful for hints where I
could look at. In the meantime I see if I get get another rtl8822cu wifi
dongle to see if my hardware is bad.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
