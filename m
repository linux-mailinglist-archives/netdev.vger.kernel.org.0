Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493B06C5F40
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 07:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjCWGAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 02:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCWGAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 02:00:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF7324BD0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 23:00:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pfE04-0001NC-1K; Thu, 23 Mar 2023 07:00:36 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pfE02-0004PC-Hv; Thu, 23 Mar 2023 07:00:34 +0100
Date:   Thu, 23 Mar 2023 07:00:34 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH net v1 6/6] net: dsa: microchip: ksz8: fix MDF
 configuration with non-zero VID
Message-ID: <20230323060034.GF23237@pengutronix.de>
References: <20230322143130.1432106-1-o.rempel@pengutronix.de>
 <20230322143130.1432106-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230322143130.1432106-7-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A typo in subject s/MDF/MDB

On Wed, Mar 22, 2023 at 03:31:30PM +0100, Oleksij Rempel wrote:
> FID is directly mapped to VID. However, configuring a MAC address with a
> VID != 0 resulted in incorrect configuration due to an incorrect bit
> mask. This kernel commit fixed the issue by correcting the bit mask and
> ensuring proper configuration of MAC addresses with non-zero VID.
> 
> Fixes: d23a5e18606c ("net: dsa: microchip: move ksz8->masks to ksz_common")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 4929fb29ed06..74c56d05ab0b 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -404,7 +404,7 @@ static const u32 ksz8863_masks[] = {
>  	[VLAN_TABLE_VALID]		= BIT(19),
>  	[STATIC_MAC_TABLE_VALID]	= BIT(19),
>  	[STATIC_MAC_TABLE_USE_FID]	= BIT(21),
> -	[STATIC_MAC_TABLE_FID]		= GENMASK(29, 26),
> +	[STATIC_MAC_TABLE_FID]		= GENMASK(25, 22),
>  	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
>  	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
>  	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(1, 0),
> -- 
> 2.30.2
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
