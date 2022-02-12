Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2EA04B37BA
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 20:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiBLTyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 14:54:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiBLTyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 14:54:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FF4606D5
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 11:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zSGyJIz3fOH7gcze6t4tBgM6vNS4rCMmwUbF+jvcHGY=; b=5/bVUWaSbh8zqAyt7bip/VogSV
        pKP+tILCz0Rfq2nQo0SCzhs3GUs4v574KXxxsYq+IbGlUJE2IULH291p0vo91AnldwIG/vzDG/qNV
        /HjZq6176GIzTJ5s6afWpjn67b50Hcu0Qh15SMzuE27kSoyWdGysTfeGJ2ZHFk39KJ4Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIySz-005eOi-6o; Sat, 12 Feb 2022 20:53:57 +0100
Date:   Sat, 12 Feb 2022 20:53:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next V1 5/5] net: lan743x: Add support for Clause-45
 MDIO PHY management
Message-ID: <YggQVTZJhmEh0YQk@lunn.ch>
References: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
 <20220212155315.340359-6-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220212155315.340359-6-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan743x_mdiobus_c45_read(struct mii_bus *bus, int phy_id, int index)
> +{
> +	if (index & MII_ADDR_C45) {

...

> +		return (int)(ret & 0xFFFF);
> +	}
> +
> +	ret = lan743x_mdiobus_read(bus, phy_id, index);
> +	return ret;

This function appear to either do a c45 or a c22 access. So the
function name is not very accurate.

	 Andrew
