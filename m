Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728116A67FF
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 08:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCAHLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 02:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCAHLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 02:11:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCF337B56
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 23:11:49 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pXGcq-0004Lv-1Z; Wed, 01 Mar 2023 08:11:44 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pXGcn-0006iK-4Q; Wed, 01 Mar 2023 08:11:41 +0100
Date:   Wed, 1 Mar 2023 08:11:41 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     stable@vger.kernel.org
Cc:     "linux-wireless@vger.kernel.org Neo Jou" <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Andreas Henriksson <andreas@fatal.se>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: Re: [PATCH v2 0/3] wifi: rtw88: USB fixes
Message-ID: <20230301071141.GN23347@pengutronix.de>
References: <20230210111632.1985205-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210111632.1985205-1-s.hauer@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 12:16:29PM +0100, Sascha Hauer wrote:
> This series addresses issues for the recently added RTW88 USB support
> reported by Andreas Henriksson and also our customer.
> 
> The hardware can't handle urbs that have a size of multiple of the
> bulkout_size (usually 512 bytes). The symptom is that the hardware
> stalls completely. The issue can be reproduced by sending a suitably
> sized ping packet from the device:
> 
> ping -s 394 <somehost>
> 
> (It's 394 bytes here on a RTL8822CU and RTL8821CU, the actual size may
> differ on other chips, it was 402 bytes on a RTL8723DU)
> 
> Other than that qsel was not set correctly. The sympton here is that
> only one of multiple bulk endpoints was used to send data.
> 
> Changes since v1:
> - Use URB_ZERO_PACKET to let the USB host controller handle it automatically
>   rather than working around the issue.
> 
> Sascha Hauer (3):
>   wifi: rtw88: usb: Set qsel correctly
>   wifi: rtw88: usb: send Zero length packets if necessary
>   wifi: rtw88: usb: drop now unnecessary URB size check

These patches went in upstream as:

7869b834fb07c wifi: rtw88: usb: Set qsel correctly
07ce9fa6ab0e5 wifi: rtw88: usb: send Zero length packets if necessary
462c8db6a0116 wifi: rtw88: usb: drop now unnecessary URB size check

These patches make the RTW88 USB support much more reliable. Can they be
picked for the current 6.2 stable series please?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
