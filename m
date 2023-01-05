Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6302665E661
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjAEIB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjAEIB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:01:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E38F544FC
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 00:01:55 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pDLC4-0006Mj-IX; Thu, 05 Jan 2023 09:01:44 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pDLC2-0004l2-MY; Thu, 05 Jan 2023 09:01:42 +0100
Date:   Thu, 5 Jan 2023 09:01:42 +0100
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc:     Chris Morgan <macroalpha82@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
Message-ID: <20230105080142.GA15042@pengutronix.de>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com>
 <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
From:   Sascha Hauer <sha@pengutronix.de>
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

On Wed, Jan 04, 2023 at 09:59:35PM +0200, Bitterblue Smith wrote:
> On 04/01/2023 01:01, Chris Morgan wrote:
> > On Wed, Dec 28, 2022 at 12:30:20AM +0100, Martin Blumenstingl wrote:
> >> Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
> >> well as the existing RTL8821C chipset code.
> >>
> > 
> > Unfortunately, this doesn't work for me. I applied it on top of 6.2-rc2
> > master and I get errors during probe (it appears the firmware never
> > loads).
> > 
> > Relevant dmesg logs are as follows:
> > 
> > [    0.989545] mmc2: new high speed SDIO card at address 0001
> > [    0.989993] rtw_8821cs mmc2:0001:1: Firmware version 24.8.0, H2C version 12
> > [    1.005684] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x14): -110
> > [    1.005737] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1080): -110
> > [    1.005789] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x11080): -110
> > [    1.005840] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x3): -110
> > [    1.005920] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x1103): -110
> > [    1.005998] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x80): -110
> > [    1.006078] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1700): -110
> > 
> > The error of "sdio read32 failed (0x1700): -110" then repeats several
> > hundred times, then I get this:
> > 
> > [    1.066294] rtw_8821cs mmc2:0001:1: failed to download firmware
> > [    1.066367] rtw_8821cs mmc2:0001:1: sdio read16 failed (0x80): -110
> > [    1.066417] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x100): -110
> > [    1.066697] rtw_8821cs mmc2:0001:1: failed to setup chip efuse info
> > [    1.066703] rtw_8821cs mmc2:0001:1: failed to setup chip information
> > [    1.066839] rtw_8821cs: probe of mmc2:0001:1 failed with error -16
> > 
> > The hardware I am using is an rtl8821cs that I can confirm was working
> > with a previous driver.
> > 
> > Thank you.
> > 
> The USB-based RTL8811CU also doesn't work, with suspiciously similar
> errors:
> 
> Dec 25 21:43:37 home kernel: rtw_8821cu 1-2:1.0: Firmware version 24.11.0, H2C version 12
> Dec 25 21:43:37 home kernel: rtw_8821cu 1-2:1.0 wlp0s20f0u2: renamed from wlan0
> Dec 25 21:43:40 home kernel: rtw_8821cu 1-2:1.0: read register 0x5 failed with -110

Is this the very first register access or are there other register
accesses before that actually do work?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
