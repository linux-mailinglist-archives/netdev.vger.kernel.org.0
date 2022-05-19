Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7213B52DD5E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 21:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbiESTCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 15:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244319AbiESTBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 15:01:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CEDCE2F;
        Thu, 19 May 2022 12:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=30Q8obn7fVx0WpjeIrxqO72NAYu9ZR5ZQbK3CveRK4k=; b=X4
        6jRghNiloLNde3Ixf8nY/PsgQKrP85prblbwpt2r8ltCQs6FBwo0H5PvuWb8/fp3KJfGPbv4cWXoG
        b0EosV+i7WComxN0hci1jQlpKb5zCJMNlVfhcn/+hMTJqU3t6ZddVbs9rJS3EprMPzMDsOqcSGct1
        OkYumOZvk0CGC1k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nrlO4-003X2h-Bo; Thu, 19 May 2022 21:00:40 +0200
Date:   Thu, 19 May 2022 21:00:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Cc:     Tommaso Merciai <tommaso.merciai@amarulasolutions.com>,
        Alberto Bianchi <alberto.bianchi@amarulasolutions.com>,
        linuxfancy@googlegroups.com,
        linux-amarula <linux-amarula@amarulasolutions.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: phy: DP83822: enable rgmii mode if
 phy_interface_is_rgmii
Message-ID: <YoaT2IrpO3mR/Nqh@lunn.ch>
References: <20220519182423.1554379-1-tommaso.merciai@amarulasolutions.com>
 <CAOf5uwni8tdr2srmp=X_uqs44_0Gtk_JuUoKSRoRFP2WhOfZVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOf5uwni8tdr2srmp=X_uqs44_0Gtk_JuUoKSRoRFP2WhOfZVw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 08:29:26PM +0200, Michael Nazzareno Trimarchi wrote:
> Hi
> 
> Il gio 19 mag 2022, 20:24 Tommaso Merciai <tommaso.merciai@amarulasolutions.com
> > ha scritto:
> 
>     RGMII mode can be enable from dp83822 straps, and also writing bit 9
>     of register 0x17 - RMII and Status Register (RCSR).
>     When phy_interface_is_rgmii this mode must be enabled
> 
>     References:
>      - https://www.ti.com/lit/gpn/dp83822i p66
> 
>     Signed-off-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
>     Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
>     Suggested-by: Alberto Bianchi <alberto.bianchi@amarulasolutions.com>
>     Tested-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
>     ---
>      drivers/net/phy/dp83822.c | 4 ++++
>      1 file changed, 4 insertions(+)
> 
>     diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
>     index ce17b2af3218..66fa61fb86db 100644
>     --- a/drivers/net/phy/dp83822.c
>     +++ b/drivers/net/phy/dp83822.c
>     @@ -408,6 +408,10 @@ static int dp83822_config_init(struct phy_device
>     *phydev)
>                             if (err)
>                                     return err;
>                     }
>     +
>     +               /* Enable RGMII Mode */
>     +               phy_set_bits_mmd(phydev, DP83822_DEVADDR,
>     +                                       MII_DP83822_RCSR, BIT(9));
>             }
> 
> 
> 
> Please define bit 9 and this break other connection. Introduce again the switch
> for phy interface connection

Hi guys

Please try to perform your own reviews before posting to the list.

I agree with an #define for BIT(9).

However, i don't understand what you mean by the rest of your
comments. Please make sure your colleges understand you.

	  Andrew
