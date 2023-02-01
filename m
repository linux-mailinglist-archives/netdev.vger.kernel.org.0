Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B43686CD8
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjBAR20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjBAR2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:28:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859A53E632;
        Wed,  1 Feb 2023 09:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=50Bg29+w61BN/4LjQdJx9K3FafHtmhGyZO4xLMgCCDw=; b=4dZNNdOqbvAgVuwM0rvkYeUIuG
        QnIlNg47TTJW3wtfbkc2Enc2xhollGqPNXHeJBQk97U99cr/ZOqjXka3LfegjJM+BH8mcTckzLW/M
        l/kLjHe9AiwvPRNJEQaLP3K678uXLrEoIUlZzd0UP0+4o9wUfLZoReEi8fWPxdIZp1M8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNGu5-003ouM-8X; Wed, 01 Feb 2023 18:28:13 +0100
Date:   Wed, 1 Feb 2023 18:28:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 06/23] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
Message-ID: <Y9qhLbZ/kf2/buln@lunn.ch>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201145845.2312060-7-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* This is optional functionality. If not supported, we may get an error
> +	 * which should be ignored.
> +	 */
> +	genphy_c45_read_eee_abilities(phydev);

Humm, philosophic discussion. Would it be better for
genphy_c45_read_eee_abilities() to silently ignore the error? Errors
like -ETIMEDOUT should probably be returned, but -EOPNOTSUPP should be
ignored.

	Andrew
