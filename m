Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE322681D7D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjA3Vz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjA3Vz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:55:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1974748619;
        Mon, 30 Jan 2023 13:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iZ9I+o9Sq8mKMq/+Ee0s7Cj650HKNOS9yF3s0PIH8Fk=; b=vnEM9KfFGkRtF32e6XA/OE9qtc
        Qx3ampxHzoa/QiImnewG/hsIGetpRPn2Vz6fI8RS+WCMrae0KQPWzzrvzhvhZ6EzCGN7iwqlvlsPO
        s/j+oWIXSbGJWcl3RWySIm3jXelZJUR+WWYIyxBWYtu45CYLKfMXiWsP25fBO7np4piY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMc7M-003cfw-FS; Mon, 30 Jan 2023 22:55:12 +0100
Date:   Mon, 30 Jan 2023 22:55:12 +0100
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
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v3 02/15] net: phy: add
 genphy_c45_read_eee_abilities() function
Message-ID: <Y9g8wOED58xKwu4m@lunn.ch>
References: <20230130080714.139492-1-o.rempel@pengutronix.de>
 <20230130080714.139492-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130080714.139492-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline void mii_eee_100_10000_adv_mod_linkmode_t(unsigned long *adv,
> +							u32 val)
> +{
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> +			 adv, val & MDIO_EEE_100TX);
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> +			 adv, val & MDIO_EEE_1000T);
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
> +			 adv, val & MDIO_EEE_10GT);
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
> +			 adv, val & MDIO_EEE_1000KX);
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
> +			 adv, val & MDIO_EEE_10GKX4);
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> +			 adv, val & MDIO_EEE_10GKR);
> +}

This and mmd_eee_cap_to_ethtool_sup_t() are very similar. Could you
try to remove the duplication. Maybe
ethtool_convert_link_mode_to_legacy_u32() could be used?

	Andrew					  
