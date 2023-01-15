Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65BB66B296
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 17:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjAOQbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 11:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjAOQbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 11:31:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6BB4ED9
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 08:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fKoQ6dLHyJrJAKZsNPDqV/dOgy5iAJcNL74j+nDYi8w=; b=TzISPbbuDofx/LpvMOTlk2SlZw
        NxoK831+WBToAxb/YsPgg3C8WJbfxZsiQTpgWk5+C1qaVt//fPd4PYW71z3M/wSv55BaFyOMDBmDL
        mJibF+0n8wUXs3y0p/KZ6U4yiJzd90tfsIJvy3k/ezHvLDMM5ORtZM3y9rQ5K5yK2X0o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pH5uE-0028mN-V2; Sun, 15 Jan 2023 17:30:50 +0100
Date:   Sun, 15 Jan 2023 17:30:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: mdio: validate parameter addr in
 mdiobus_get_phy()
Message-ID: <Y8QqOpVStynq3C1/@lunn.ch>
References: <cdf664ea-3312-e915-73f8-021678d08887@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdf664ea-3312-e915-73f8-021678d08887@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 11:54:06AM +0100, Heiner Kallweit wrote:
> The caller may pass any value as addr, what may result in an out-of-bounds
> access to array mdio_map. One existing case is stmmac_init_phy() that
> may pass -1 as addr. Therefore validate addr before using it.
> 
> Fixes: 7f854420fbfe ("phy: Add API for {un}registering an mdio device to a bus.")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Hi Heiner

This makes sense, but we should also fix stmmac to not actually do
this, since it is clearly wrong, and probably indicates a
configuration problem for that driver.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
