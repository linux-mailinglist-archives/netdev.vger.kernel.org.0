Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2455475DB
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 17:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiFKO77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 10:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236853AbiFKO76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 10:59:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BCB4AE06
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 07:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tpxzV6cXuedm0MRz7VsxAbDm0eUUUhO0uvZfLRfj0Nw=; b=ttDnexuBN46s4/Vl38MUXuszzz
        sdGuiVRF7lcwe2LFqf9UqTelOg1iuYxXkQMT3BCNwAQYUpC8YAHZye/t1IPitMhXvd7BcDpJ+P/ru
        HHMuuvzW2vF1ynPzprTfhahM4qtD4D3No05c9EZYtW+Zhpq7aGND/oyGIs83P3gdTKH8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o02ab-006WDI-KM; Sat, 11 Jun 2022 16:59:49 +0200
Date:   Sat, 11 Jun 2022 16:59:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ondrej Spacek <ondrej.spacek@nxp.com>
Subject: Re: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G
 are not advertised
Message-ID: <YqSt5Rysq110xpA3@lunn.ch>
References: <20220610084037.7625-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610084037.7625-1-claudiu.manoil@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 11:40:37AM +0300, Claudiu Manoil wrote:
> Even when the eth port is resticted to work with speeds not higher than 1G,
> and so the eth driver is requesting the phy (via phylink) to advertise up
> to 1000BASET support, the aquantia phy device is still advertising for 2.5G
> and 5G speeds.
> Clear these advertising defaults when requested.

Hi Claudiu

genphy_c45_an_config_aneg(phydev) is called in aqr_config_aneg, which
should set/clear MDIO_AN_10GBT_CTRL_ADV5G and
MDIO_AN_10GBT_CTRL_ADV2_5G. Does the aQuantia PHY not have these bits?

	Andrew
