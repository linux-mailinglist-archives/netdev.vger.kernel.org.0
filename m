Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48033524C77
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353050AbiELMMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352872AbiELMMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:12:54 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E88040A00
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 05:12:51 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 5F8C6300034C7;
        Thu, 12 May 2022 14:12:49 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 5567B2E4EB2; Thu, 12 May 2022 14:12:49 +0200 (CEST)
Date:   Thu, 12 May 2022 14:12:49 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 3/7] usbnet: smsc95xx: Don't reset PHY behind
 PHY driver's back
Message-ID: <20220512121249.GB4703@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <53ea51cabb288a0eba475ffaf1b2afd15b505b62.1652343655.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ea51cabb288a0eba475ffaf1b2afd15b505b62.1652343655.git.lukas@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:42:03AM +0200, Lukas Wunner wrote:
> smsc95xx_reset() resets the PHY behind the PHY driver's back, which
> seems like a bad idea generally.  Remove that portion of the function.
> 
> We're about to use PHY interrupts instead of polling to detect link
> changes on SMSC LAN95xx chips.  Because smsc95xx_reset() is called from
> usbnet_open(), PHY interrupt settings are lost whenever the net_device
> is brought up.
> 
> There are two other callers of smsc95xx_reset(), namely smsc95xx_bind()
> and smsc95xx_reset_resume(), and both may indeed benefit from a PHY
> reset.  However they already perform one through their calls to
> phy_connect_direct() and phy_init_hw().
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Martyn Welch <martyn.welch@collabora.com>
> Cc: Gabriel Hojda <ghojda@yo2urs.ro>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Andrew kindly provided this tag here:
https://lore.kernel.org/netdev/YnGq401sOeC0zwt6@lunn.ch/

Forgot to add it to the commit.
Sending it in separately so patchwork picks it up.
My apologies for the inconvenience.
