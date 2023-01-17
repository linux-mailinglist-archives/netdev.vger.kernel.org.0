Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBF366DF34
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjAQNrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjAQNq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:46:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2951F3B0D4;
        Tue, 17 Jan 2023 05:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=00YNGItwONCh6ufe2XXTM1rthx+FFUTn1IrFPrp8JEk=; b=bZtSQ8TB+sFe/t9YScPyxnzBK+
        7LfpGxfG7cPHQJvJ8Lw9PQiVGB2eDLikuSDkP5shEeX4SuX0ih0IoFVAQ6REjxY68agP8+Nq7IG3h
        9G6fKpcdYOOUitWJEr1TRduiZUoQ3/17VIO5h+TEmMpLVZvvfryJ4cnDPS9GeYbwFa0I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHmIU-002KJG-D6; Tue, 17 Jan 2023 14:46:42 +0100
Date:   Tue, 17 Jan 2023 14:46:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.passaro@gmail.com
Subject: Re: [PATCH net-next v3] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8amwmZLajZfum89@lunn.ch>
References: <20230116160114.36467-1-pierluigi.p@variscite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116160114.36467-1-pierluigi.p@variscite.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 05:01:14PM +0100, Pierluigi Passaro wrote:
> When the reset gpio is defined within the node of the device tree
> describing the PHY, the reset is initialized and managed only after
> calling the fwnode_mdiobus_phy_device_register function.
> However, before calling it, the MDIO communication is checked by the
> get_phy_device function.
> When this happens and the reset GPIO was somehow previously set down,
> the get_phy_device function fails, preventing the PHY detection.
> These changes force the deassert of the MDIO reset signal before
> checking the MDIO channel.
> The PHY may require a minimum deassert time before being responsive:
> use a reasonable sleep time after forcing the deassert of the MDIO
> reset signal.
> Once done, free the gpio descriptor to allow managing it later.
> 
> Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>
> Signed-off-by: FrancescoFerraro <francesco.f@variscite.com>

FYI: There is still a discussion going on in v1 of this patch. Please
do not merge yet.

   Andrew
