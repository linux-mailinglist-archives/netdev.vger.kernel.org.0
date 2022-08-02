Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE6D5875EB
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 05:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiHBDVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 23:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiHBDVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 23:21:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E122619D;
        Mon,  1 Aug 2022 20:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79237611D5;
        Tue,  2 Aug 2022 03:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34679C433C1;
        Tue,  2 Aug 2022 03:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659410491;
        bh=89Wih5pNoTA3uPXxltvo1FysMtwCoXLeQ7NxdVqjJVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W3S7Qm2pqL+wSX20xIk33U4732DLeUAMr/mqveOZMYjPBK5RZvC/o1ykG0IuEQGb5
         R66/8o4xq29PmJU8d1f4czMdJd6jybzF6eofY8pmNG0YFFAqGC9Ibjh6dnCh8UkSef
         9/tdTJUHhJLLD6iwIAfnPsvNIl0qz+fcNOMGsHnskAAtEpnXMpghmvzhuy5rHet7Hs
         HE800rtV6hZbdNi5pX6TtczPL/2UDeSVpqCFWGaUUWz7+sCxLcQ7+7FToouOJJkyhP
         ZjIqNmn0/AopjMdt2mxs+YWkWWdXMMfv9ECi2StG+FcIlAhxg126yKE9tbAh84XgxI
         9eHO+CsfJgz2Q==
Date:   Mon, 1 Aug 2022 20:21:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v4 0/4] net: Introduce QUSGMII phy mode
Message-ID: <20220801202129.17174b5f@kernel.org>
In-Reply-To: <20220801073713.32290-1-maxime.chevallier@bootlin.com>
References: <20220801073713.32290-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Aug 2022 09:37:09 +0200 Maxime Chevallier wrote:
> This is the V4 of a previous series [1] initially aimed at introducing
> inband extensions, with modes like QUSGMII. This mode allows passing
> info in the ethernet preamble between the MAC and the PHY, such s
> timestamps.
> 
> This series has now become a preliminary series, that simply introduces
> the new interface mode, without support for inband extensions, that will
> come later.
> 
> The reasonning is that work will need to be done in the networking
> subsystem, but also in the generic phy driver subsystem to allow serdes
> configuration for qusgmii.
> 
> This series add the mode, the relevant binding changes, adds support for
> it in the lan966x driver, and also introduces a small helper to get the
> number of links a given phy mode can carry (think 1 for SGMII and 4 for
> QSGMII). This allows for better readability and will prove useful
> when (if) we support PSGMII (5 links on 1 interface) and OUSGMII (8
> links on one interface).
> 
> V4 contains no change but the collected Reviewed-by from Andrew.

This series came in after the closing of net-next:

https://lore.kernel.org/all/20220731212214.1c733186@kernel.org/

let's defer it until after the merge window.
