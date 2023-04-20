Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89E36E984D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjDTP3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjDTP3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:29:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7EB3AB7;
        Thu, 20 Apr 2023 08:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mUbYjNflH+AijfNqLX0x7O2v9BBYIHBK3Y4JvKS7bb4=; b=Nu3LIq/z3UMcDLXzqPvr9Sm0Yp
        NNTe3H/n2snKWMv72PtH6YrBkmg8+yhOXG9yDB00lo9ZnW6yZfE1W8WKEH/ul9Zo2rrW/+F10sBzT
        KnuXSC8Kho4g0TqKbQbnybsl5lJfTSaeOlwoiUS6oEhndvJ1lN8nUHjTJxPTObOC8AN8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppWDy-00Annn-D5; Thu, 20 Apr 2023 17:29:30 +0200
Date:   Thu, 20 Apr 2023 17:29:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Frank Sae <Frank.Sae@motor-comm.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fix circular LEDS_CLASS dependencies
Message-ID: <b0a2ddd4-6a91-43cd-9546-a9c3dff4fac2@lunn.ch>
References: <20230420084624.3005701-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420084624.3005701-1-arnd@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 10:45:51AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The CONFIG_PHYLIB symbol is selected by a number of device drivers that
> need PHY support, but it now has a dependency on CONFIG_LEDS_CLASS,
> which may not be enabled, causing build failures.
> 
> Avoid the risk of missing and circular dependencies by guarding the
> phylib LED support itself in another Kconfig symbol that can only be
> enabled if the dependency is met.
> 
> This could be made a hidden symbol and always enabled when both CONFIG_OF
> and CONFIG_LEDS_CLASS are reachable from the phylib, but there may be an
> advantage in having users see this option when they have a misconfigured
> kernel without built-in LED support.
> 
> Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This is for net-next.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
