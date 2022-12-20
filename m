Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6F652503
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 17:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbiLTQzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 11:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiLTQzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 11:55:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F164F1C126
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 08:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=h+NqXHYdjvrgR0+JEW7aHHRoBrP/9JwE2aHDvlcxq5A=; b=D1u4podtOUsemZgOorNyLPjO76
        2akNOdCbBz7sxu8xILMH5GZ8G65jnH7NE8oL7a3iGxq7hKVQyT4Pk9I4loP5y4rUnpPZvnnYAc6VX
        Y/iTOKEcrWEytqBzBDgKPse2YdAC7MWXG7OAm5j22aHpKkAZo2Op9qxcBZGkCFe5EyPo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7ftO-0006WF-OT; Tue, 20 Dec 2022 17:55:02 +0100
Date:   Tue, 20 Dec 2022 17:55:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Message-ID: <Y6Ho5rIlRHYPePEo@lunn.ch>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
 <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
 <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
 <cc720a28-9e73-7c88-86af-8814b02ee580@gmail.com>
 <1567686748.473254.1671551305632.JavaMail.zimbra@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567686748.473254.1671551305632.JavaMail.zimbra@savoirfairelinux.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 10:48:25AM -0500, Enguerrand de Ribaucourt wrote:
> > From: "Heiner Kallweit" <hkallweit1@gmail.com>
> > To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > Cc: "netdev" <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "woojung huh" <woojung.huh@microchip.com>,
> > "davem" <davem@davemloft.net>, "UNGLinuxDriver" <UNGLinuxDriver@microchip.com>, "Andrew Lunn" <andrew@lunn.ch>,
> > "Russell King - ARM Linux" <linux@armlinux.org.uk>
> > Sent: Tuesday, December 20, 2022 4:19:40 PM
> > Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to phy_disable_interrupts()
> My proposed approach would be to copy the original workaround actions
> within link_change_notify():
>  1. disable interrupts
>  2. reset speed
>  3. enable interrupts
> 
> However, I don't have access to the LAN8835 to test if this would work. I also
> don't have knowledge about which other Microchip PHYs could be impacted. Maybe
> there is an active Microchip developer we could communicate with to find out?

Woojung Huh added this code, and he sometimes contributes here.

Woojung, do you still have access to the hardware?

	 Andrew
