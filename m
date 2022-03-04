Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C754CD481
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiCDMvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiCDMvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:51:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25A51B1DE4;
        Fri,  4 Mar 2022 04:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3zSYmUfILo42NmKSIeBACpJ1qTOzQlDChMK4Lpf3/Lo=; b=BAXE8OUEXSqnQ+UMkLbA9OD6K+
        lWA7nqaB6ANdF0z0U3qkln/ZC3Ya9OgavSDUoDhW5khEhAeLm/ULSHaCTXPKOXK03kL7SfJVWcn38
        L+flw+wgdz5xnEps2SkfuUJjiObsU9LSSwFiz9FALOh9XxiLiEmt5Fxu7mC24iPM8O2Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQ7OR-009EGH-DJ; Fri, 04 Mar 2022 13:50:47 +0100
Date:   Fri, 4 Mar 2022 13:50:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, madhuri.sripada@microchip.com,
        manohar.puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <YiILJ3tXs9Sba42B@lunn.ch>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304093418.31645-3-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 03:04:17PM +0530, Divya Koppera wrote:
> Supports configuring latency values and also adds
> check for phy timestamping feature.
> 
> Signed-off-by: Divya Koppera<Divya.Koppera@microchip.com>
> ---
>  .../devicetree/bindings/net/micrel.txt          | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
> index 8d157f0295a5..c5ab62c39133 100644
> --- a/Documentation/devicetree/bindings/net/micrel.txt
> +++ b/Documentation/devicetree/bindings/net/micrel.txt
> @@ -45,3 +45,20 @@ Optional properties:
>  
>  	In fiber mode, auto-negotiation is disabled and the PHY can only work in
>  	100base-fx (full and half duplex) modes.
> +
> + - lan8814,ignore-ts: If present the PHY will not support timestamping.
> +
> +	This option acts as check whether Timestamping is supported by
> +	hardware or not. LAN8814 phy support hardware tmestamping.

Does this mean the hardware itself cannot tell you it is missing the
needed hardware? What happens when you forget to add this flag? Does
the driver timeout waiting for hardware which does not exists?

> + - lan8814,latency_rx_10: Configures Latency value of phy in ingress at 10 Mbps.
> +
> + - lan8814,latency_tx_10: Configures Latency value of phy in egress at 10 Mbps.
> +
> + - lan8814,latency_rx_100: Configures Latency value of phy in ingress at 100 Mbps.
> +
> + - lan8814,latency_tx_100: Configures Latency value of phy in egress at 100 Mbps.
> +
> + - lan8814,latency_rx_1000: Configures Latency value of phy in ingress at 1000 Mbps.
> +
> + - lan8814,latency_tx_1000: Configures Latency value of phy in egress at 1000 Mbps.

Why does this need to be configured, rather than hard coded? Why would
the latency for a given speed change? I would of thought though you
would take the average length of a PTP packet and divide is by the
link speed.

     Andrew
