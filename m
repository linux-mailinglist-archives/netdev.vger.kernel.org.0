Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CF968CB60
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 01:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjBGAon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 19:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjBGAom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 19:44:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8421C16AF6;
        Mon,  6 Feb 2023 16:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nwp0SvoHdLuHe4/f8GA05H2SnD3BeOwlfVbhJX3vLGU=; b=0x0WbCpO0tlVFKreP22iFHTqYW
        FYiaWaPq9zR+A9BL5auqtrFhfwRApEAf315i6XhqGakj65UDeHTSMVwO1DUOealEKsK+rDsXRGsz3
        lAbOrYII/nc5KvBDcaoZxX2JjFe/JQPCLT3mMKx4nnBwWRE9aqUm6ZbtjmXKOWb/nbDo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPC60-004FgR-7E; Tue, 07 Feb 2023 01:44:28 +0100
Date:   Tue, 7 Feb 2023 01:44:28 +0100
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
Subject: Re: [PATCH net-next v5 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Message-ID: <Y+Ge7DVId3aJMEok@lunn.ch>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
 <20230206135050.3237952-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135050.3237952-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* The 802.3 2018 standard says the top 2 bits are reserved and should
> +	 * read as 0. Also, it seems unlikely anybody will build a PHY which
> +	 * supports 100GBASE-R deep sleep all the way down to 100BASE-TX EEE.
> +	 * If MDIO_PCS_EEE_ABLE is 0xffff assume EEE is not supported.
> +	 */
> +	if (val == GENMASK(15, 0))
> +		return 0;

Given the comment says 0xffff i would just use 0xffff, not GENMASK.

Other than that:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
