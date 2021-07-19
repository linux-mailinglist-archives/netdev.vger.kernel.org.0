Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1915D3CF002
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442681AbhGSW4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 18:56:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358297AbhGSUQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 16:16:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LZePE50xSuSqrDuocYC1iK5RvzuFoCiQqu0MVQ7AeoE=; b=fTCodS85M87FDJ97Yu/UfsHUpi
        Y2aNKXXrmQGzU86VUAkK1haEHl+V2dvpr48clLpsmZlffqEoVoynAR0p2r95d1fqOAg9gzXzRLbPg
        UeI4i7N17Qn8cwdtB2yHVm0mPj21Bi+hfdMI5l4b6EMS34W0ftScQLW0HL5tW1fPq3LM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5aJJ-00DxjV-Nm; Mon, 19 Jul 2021 22:56:21 +0200
Date:   Mon, 19 Jul 2021 22:56:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Message-ID: <YPXm9avkMoD/oat8@lunn.ch>
References: <20210719082756.15733-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719082756.15733-1-ms@dev.tdt.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +		int_delay = phy_get_internal_delay(phydev, dev,
> +						   xway_internal_delay,
> +						   delay_size, true);
> +
> +		if (int_delay < 0) {
> +			phydev_warn(phydev, "rx-internal-delay-ps is missing, use default of 2.0 ns\n");
> +			int_delay = 4; /* 2000 ps */

The binding say:

 rx-internal-delay-ps:
    description: |
      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
      PHY's that have configurable RX internal delays.  If this property is
      present then the PHY applies the RX delay.

So the property is optional. It being missing should not generate a
warning. Please just use the default of 2ns. This makes the usage the
same as the other drivers using phy_get_internal_delay().

     Andrew
