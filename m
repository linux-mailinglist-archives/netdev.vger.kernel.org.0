Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE6C65D416
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjADNXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239645AbjADNWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:22:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BFC2AEB
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 05:22:21 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pD3ie-0004DB-CH; Wed, 04 Jan 2023 14:22:12 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pD3id-00011P-5S; Wed, 04 Jan 2023 14:22:11 +0100
Date:   Wed, 4 Jan 2023 14:22:11 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, pkshih@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
Message-ID: <20230104132211.GW11668@pengutronix.de>
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 01:48:41PM +0100, Martin Blumenstingl wrote:
> This series consists of three patches which are fixing existing
> behavior (meaning: it either affects PCIe or USB or both) in the rtw88
> driver.
> 
> The first change adds the packed attribute to the eFuse structs. This
> was spotted by Ping-Ke while reviewing the SDIO support patches from
> [0].
> 
> The remaining three changes relate to locking (barrier hold) problems.
> We previously had discussed patches for this for SDIO support, but the
> problem never ocurred while testing USB cards. It turns out that these
> are still needed and I think that they also fix the same problems for
> USB users (it's not clear how often it happens there though).

Indeed I haven't stumbled over any of the issues you fix in this series.
I briefly looked into it and it might be that at least some of the code
paths are only used with beam forming support. Could it be that my
cheapo USB sticks do not support that?

For what it's worth, I gave this series a quick test and didn't see any
regressions, so:

Tested-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
