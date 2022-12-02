Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57087640199
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiLBIKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiLBIKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:10:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855E4AE4E0
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:10:03 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1p117L-0004RO-0U; Fri, 02 Dec 2022 09:09:55 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1p117I-0004pi-Ez; Fri, 02 Dec 2022 09:09:52 +0100
Date:   Fri, 2 Dec 2022 09:09:52 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: Re: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
Message-ID: <20221202080952.GG9130@pengutronix.de>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
 <20221129100754.2753237-9-s.hauer@pengutronix.de>
 <20221129081753.087b7a35@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129081753.087b7a35@kernel.org>
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

On Tue, Nov 29, 2022 at 08:17:53AM -0800, Jakub Kicinski wrote:
> On Tue, 29 Nov 2022 11:07:51 +0100 Sascha Hauer wrote:
> > +config RTW88_8821CU
> > +	tristate "Realtek 8821CU USB wireless network adapter"
> > +	depends on USB
> > +	select RTW88_CORE
> > +	select RTW88_USB
> > +	select RTW88_8821C
> > +	help
> > +	  Select this option will enable support for 8821CU chipset
> > +
> > +	  802.11ac USB wireless network adapter
> 
> Those kconfig knobs add so little code, why not combine them all into
> one? No point bothering the user with 4 different questions with amount
> to almost nothing.

I tend to agree here. I followed the pattern used with PCI support here,
but I also think that we don't need to be able to select all chips
individually. The following should be enough:

config RTW88_PCI
	tristate
	depends on PCI
	default y

config RTW88_USB
	tristate
	depends on USB
	default y

Still I'd like to continue with the current pattern to not block merging
of the USB support with this topic.

I could create a follow up patch though if that's desired.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
