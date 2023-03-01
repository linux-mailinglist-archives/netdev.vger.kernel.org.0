Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CEC6A702B
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjCAPsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjCAPsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:48:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30F9AD2F;
        Wed,  1 Mar 2023 07:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Azuz1nJ1RPQ5tw9j2NP8VjvzoOm0XSRr/0GTTjrCmVw=; b=cTRPaFwIJqyLpIpj9YVd0O/JLi
        iI17gu/qUl6uZnYuYDbzT5zz0Jm+kdmwY26uquzPUuLevPdxEAsnj3VR/E0iJawExL5JsSbS27+eO
        11UNZkWTOJGcjFF0wL/PyJZcHZiBTTKbTgn121DEZWiE3o9PnTnMf9k7yxSnkAxK4rD4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pXOg7-006FUC-4j; Wed, 01 Mar 2023 16:47:39 +0100
Date:   Wed, 1 Mar 2023 16:47:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     enguerrand.de-ribaucourt@savoirfairelinux.com,
        woojung.huh@microchip.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        edumazet@google.com, linux-usb@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH v3 net] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Message-ID: <Y/9zm981bYNxq1Az@lunn.ch>
References: <20230301154307.30438-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301154307.30438-1-yuiko.oshino@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 08:43:07AM -0700, Yuiko Oshino wrote:
> Move the LAN7800 internal phy (phy ID  0x0007c132) specific register
> accesses to the phy driver (microchip.c).
> 
> Fix the error reported by Enguerrand de Ribaucourt in December 2022,
> "Some operations during the cable switch workaround modify the register
> LAN88XX_INT_MASK of the PHY. However, this register is specific to the
> LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
> that register (0x19), corresponds to the LED and MAC address
> configuration, resulting in unapropriate behavior."
> 
> I did not test with the DP8322I PHY, but I tested with an EVB-LAN7800
> with the internal PHY.
> 
> Fixes: 14437e3fa284 ("lan78xx: workaround of forced 100 Full/Half duplex mode error")
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
