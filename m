Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8D368EF60
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjBHM4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 07:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBHM4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:56:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA5630EB6;
        Wed,  8 Feb 2023 04:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5oTXr0EPcDd/e3wIuQRZ5u10MSlrlS9A+107BrjVmHs=; b=lZXrR+cpLuZWFm1TV1kwOBAI8X
        3orKSsD9snMKmhpFBtZ2MknaMyc6+SXMyBUch2d47V7zsB7267Y3jphpG0NH5u1HSgxXsgUtg7JXd
        sKM1ffrc3/sDrSfUlDxW/5wVK3gKYtCgGo/8QX7RMPNu2WwRBAbx058NOymLLOcQIlF8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPjzn-004Oze-F9; Wed, 08 Feb 2023 13:56:19 +0100
Date:   Wed, 8 Feb 2023 13:56:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     Roger Quadros <rogerq@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v4 2/2] net: ti:
 icssg-prueth: Add ICSSG ethernet driver
Message-ID: <Y+Ob8++GWciL127K@lunn.ch>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-3-danishanwar@ti.com>
 <Y+ELeSQX+GWS5N2p@lunn.ch>
 <42503a0d-b434-bbcc-553d-a326af5b4918@ti.com>
 <e8158969-08d0-1edc-24be-8c300a71adbd@kernel.org>
 <4438fb71-7e20-6532-a858-b688bc64e826@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4438fb71-7e20-6532-a858-b688bc64e826@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>>> +static int prueth_config_rgmiidelay(struct prueth *prueth,
> >>>> +				    struct device_node *eth_np,
> >>>> +				    phy_interface_t phy_if)
> >>>> +{
> >>>
> >>> ...
> >>>
> >>>> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
> >>>> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
> >>>> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
> >>>> +
> >>>> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);
> > 
> > This is only applicable to some devices so you need to restrict this only
> > to those devices.
> > 
> 
> Currently ICSSG driver is getting upstreamed for AM65 SR2.0 device, so I don't
> think there is any need for any device related restriction. Once support for
> other devices are enabled for upstream, we can modify this accordingly.

The problem is, this is a board property, not a SoC property. What if
somebody designs a board with extra long clock lines in order to add
the delay?

> I checked the latest Technical Reference Manual [1] (Section 5.1.3.4.49, Table
> 5-624) for AM65 Silicon Revision 2.0.
> 
> Below is the description in Table 5-624
> 
> BIT	    : 24
> Field	    : RGMII0_ID_MODE
> Type	    : R/W
> Reset	    : 0h
> Description : Controls the PRU_ICSSG0 RGMII0 port internal transmit delay
> 	      0h - Internal transmit delay is enabled
> 	      1h - Reserved
> 
> The TX internal delay is always enabled and couldn't be disabled as 1h is
> reserved. So hardware support for disabling TX internal delay is not there.

So if somebody passes a phy-mode which requires it disabled, you need
to return -EINVAL, to indicate the hardware cannot actually do it.

> As, TX internal delay is always there, there is no need to enable it in MAC or
> PHY. So no need of API prueth_config_rgmiidelay().
> 
> My approach to handle delay would be as below.
> 
> *) Keep phy-mode = "rgmii-id" in DT as asked by Andrew.

As i said this depends on the board, not the SoC. In theory, you could
design a board with an extra long RX clock line, and then use phy-mode
rgmii-txid, meaning the MAC/PHY combination needs to add the TX delay.

> *) Let TX internal delay enabled in Hardware.
> *) Let PHY configure RX internal delay.
> *) Remove prueth_config_rgmiidelay() API is there is no use of this. TX
> Internal delay is always enabled.
> *) Instead of calling prueth_config_rgmiidelay() API in prueth_netdev_init()
> API, add below if condition.
> 
> 	if(emac->phy_if == PHY_INTERFACE_MODE_RGMII_ID)
> 		emac->phy_if == PHY_INTERFACE_MODE_RGMII_RXID

You should handle all cases where a TX delay is requested, not just
ID.

	Andrew
