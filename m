Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204D9519145
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243604AbiECWYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243603AbiECWYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:24:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DCE13CF9;
        Tue,  3 May 2022 15:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/Wq47WQVrTu+VwzcIEw3FbiifrIiSabFW29ragK91A0=; b=x335xTeP+IoUUMpQSUwl7eAKFP
        dAg2iy2wGpAEObezDXtzjaYPlilXquVrqAaM+YqjhZdSrYT7M8d9HSIjUlmTTJx7He+NbwBJV5vBL
        nLcoakD3upyZModE99Fc5UjMWqsz8dnMRmmBWMC8zSphV8V9kj/YlhahtxaOjO49z/9w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nm0sm-0016yN-Mi; Wed, 04 May 2022 00:20:36 +0200
Date:   Wed, 4 May 2022 00:20:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH net-next v2 2/7] usbnet: smsc95xx: Don't clear read-only
 PHY interrupt
Message-ID: <YnGqtCDVHHpo/S+L@lunn.ch>
References: <cover.1651574194.git.lukas@wunner.de>
 <78fd68df1b27f187910a3bca538ae293baa14ab2.1651574194.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78fd68df1b27f187910a3bca538ae293baa14ab2.1651574194.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 03:15:02PM +0200, Lukas Wunner wrote:
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

    Andrew
