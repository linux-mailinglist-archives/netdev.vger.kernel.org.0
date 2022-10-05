Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E725F4FD3
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 08:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJEGhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 02:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJEGhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 02:37:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1219A606AD
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 23:36:56 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ofy1N-0005gv-M4; Wed, 05 Oct 2022 08:36:45 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ofy1M-0005Dz-09; Wed, 05 Oct 2022 08:36:44 +0200
Date:   Wed, 5 Oct 2022 08:36:43 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: pse-pd: PSE_REGULATOR should depend on REGULATOR
Message-ID: <20221005063643.GB14757@pengutronix.de>
References: <709caac8873ff2a8b72b92091429be7c1a939959.1664900558.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <709caac8873ff2a8b72b92091429be7c1a939959.1664900558.git.geert+renesas@glider.be>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 06:23:53PM +0200, Geert Uytterhoeven wrote:
> The Regulator based PSE controller driver relies on regulator support to
> be enabled.  If regulator support is disabled, it will still compile
> fine, but won't operate correctly.
> 
> Hence add a dependency on REGULATOR, to prevent asking the user about
> this driver when configuring a kernel without regulator support.
> 
> Fixes: 66741b4e94ca7bb1 ("net: pse-pd: add regulator based PSE driver")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  drivers/net/pse-pd/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/pse-pd/Kconfig b/drivers/net/pse-pd/Kconfig
> index 73d163704068ac27..687dec49c1e13fa0 100644
> --- a/drivers/net/pse-pd/Kconfig
> +++ b/drivers/net/pse-pd/Kconfig
> @@ -14,6 +14,7 @@ if PSE_CONTROLLER
>  
>  config PSE_REGULATOR
>  	tristate "Regulator based PSE controller"
> +	depends on REGULATOR || COMPILE_TEST
>  	help
>  	  This module provides support for simple regulator based Ethernet Power
>  	  Sourcing Equipment without automatic classification support. For
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
