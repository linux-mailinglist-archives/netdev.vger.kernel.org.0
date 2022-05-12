Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142BA524C34
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353402AbiELL5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344488AbiELL5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:57:35 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E006C55C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:57:32 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id AA80E10045BE8;
        Thu, 12 May 2022 13:57:30 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8BD842E6CC9; Thu, 12 May 2022 13:57:30 +0200 (CEST)
Date:   Thu, 12 May 2022 13:57:30 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 2/7] usbnet: smsc95xx: Don't clear read-only
 PHY interrupt
Message-ID: <20220512115730.GA4703@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <97d9528bb7fbee7313c5c6fb3a80346faaa32c13.1652343655.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97d9528bb7fbee7313c5c6fb3a80346faaa32c13.1652343655.git.lukas@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 10:42:02AM +0200, Lukas Wunner wrote:
> Upon receiving data from the Interrupt Endpoint, the SMSC LAN95xx driver
> attempts to clear the signaled interrupts by writing "all ones" to the
> Interrupt Status Register.
> 
> However the driver only ever enables a single type of interrupt, namely
> the PHY Interrupt.  And according to page 119 of the LAN950x datasheet,
> its bit in the Interrupt Status Register is read-only.  There's no other
> way to clear it than in a separate PHY register:
> 
> https://www.microchip.com/content/dam/mchp/documents/UNG/ProductDocuments/DataSheets/LAN950x-Data-Sheet-DS00001875D.pdf
> 
> Consequently, writing "all ones" to the Interrupt Status Register is
> pointless and can be dropped.
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Forgot to add Andrew's R-b which he kindly provided here:
https://lore.kernel.org/netdev/YnGqtCDVHHpo%2FS+L@lunn.ch/

Let's see if patchwork picks the tag up if I add it like this.
My apologies for the inconvenience.
