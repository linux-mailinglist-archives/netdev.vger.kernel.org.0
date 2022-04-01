Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26B34EED96
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 14:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346051AbiDAM7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 08:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346042AbiDAM7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 08:59:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E4E276817;
        Fri,  1 Apr 2022 05:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+kraZp/jdtMCz68q8csAdvc9YGn7/uI9fFuf0zEctLY=; b=dxgpvbBCfZOlIuW3Y5vBbijXBl
        O9HYqFB96RYjitg3FIi22exIzJki93Wkwww+c3BgzMomCEckxpqrbfP0upLCoH+KLaHBIqBHpVtwK
        H/wPGapH9u6ggoFeGiYkdGzD85vwJ4oipc4ehwA7YxxhURbbUd8MTES2FPy71jrx0ztc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naGqY-00Dfl8-JT; Fri, 01 Apr 2022 14:57:46 +0200
Date:   Fri, 1 Apr 2022 14:57:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Divya.Koppera@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v2 0/3] net: phy: micrel: Remove latencies support
 lan8814
Message-ID: <Ykb2yoXHib6l9gkT@lunn.ch>
References: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 01:05:19PM +0200, Horatiu Vultur wrote:
> Remove the latencies support both from the PHY driver and from the DT.
> The IP already has some default latencies values which can be used to get
> decent results. It has the following values(defined in ns):
> rx-1000mbit: 429
> tx-1000mbit: 201
> rx-100mbit:  2346
> tx-100mbit:  705

So one alternative option here is that ptp4l looks at

/sys/class/net/<ifname>/phydev/phy_id

to identify the PHY, listens to netlink messages to determine the link
speed and then applies the correction itself in user space. That gives
you a pretty generic solution, works for any existing PHY and pretty
much any existing kernel version.  And if you want board specific
values you can override them in the ptp4l configuration file.

       Andrew
