Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E9F37ED19
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241358AbhELULZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:11:25 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:40525 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385225AbhELUHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 16:07:30 -0400
Received: by mail-ot1-f47.google.com with SMTP id t4-20020a05683014c4b02902ed26dd7a60so11526553otq.7;
        Wed, 12 May 2021 13:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yb2F6IpQtcrjLpnZ8OUqSNETCWUG2Y/cxmrONnX/qQ0=;
        b=mJwSG8HRzyUm6D0CaR70aVwF0UK/fWVWzawWiuVacm4DQz4xPZoBErRL4snCUcXZW+
         U9hAk4sbaOo+c+xMWaZT4CWuYh6ot5E90HUQiY/J6rTqs1RyxRRuDZITA30gAevobNTh
         bIkq7J7lLqJwYZO7wz9IOdAYZLavsrl7A2Cq7EemUDmH6vJc5n291aw5Ccc1BFfkTbh7
         ZTgFcagmE/avgVjfG8THkXFqzpYKSDbW0tIGCczacyIIC4izNl08nKsDkksdp9jPSM15
         cQUjSb8RBjLAT4Q9upjCdV/AiEqySWrokklddZQppJXPXPw/k3e3V3yeM8Vu2xL4zu+H
         5bDA==
X-Gm-Message-State: AOAM532LvOymdZZq8QxpHCPEeFi3xNjo78t+RedaQP1wfE/jQeY8TS+y
        8WEUsozcJqOLBSp2IMYtrQ==
X-Google-Smtp-Source: ABdhPJwSUe0ziOmWy8JIXkBvGhsOb0+2ofLxLoozk1rPU8UTv2OYA5P1SoJOTqSefVxMYBy7MquboA==
X-Received: by 2002:a05:6830:1556:: with SMTP id l22mr32038786otp.34.1620849981456;
        Wed, 12 May 2021 13:06:21 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q26sm185669otn.0.2021.05.12.13.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:06:20 -0700 (PDT)
Received: (nullmailer pid 2225064 invoked by uid 1000);
        Tue, 11 May 2021 16:23:00 -0000
Date:   Tue, 11 May 2021 11:23:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next v5 21/25] devicetree: bindings: dsa: qca8k:
 Document internal mdio definition
Message-ID: <20210511162300.GA2221810@robh.at.kernel.org>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
 <20210511020500.17269-22-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511020500.17269-22-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 04:04:56AM +0200, Ansuel Smith wrote:
> Document new way of declare mapping of internal PHY to port.
> The new implementation directly declare the PHY connected to the port
> by adding a node in the switch node. The driver detect this and register
> an internal mdiobus using the mapping defined in the mdio node.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.txt     | 39 +++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 1daf68e7ae19..3973a9d3e426 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -21,6 +21,10 @@ described in dsa/dsa.txt. If the QCA8K switch is connect to a SoC's external
>  mdio-bus each subnode describing a port needs to have a valid phandle
>  referencing the internal PHY it is connected to. This is because there's no
>  N:N mapping of port and PHY id.
> +To declare the internal mdio-bus configuration, declare a mdio node in the
> +switch node and declare the phandle for the port referencing the internal
> +PHY is connected to. In this config a internal mdio-bus is registred and

registered

Otherwise,

Reviewed-by: Rob Herring <robh@kernel.org>

> +the mdio MASTER is used as communication.
>  
>  Don't use mixed external and internal mdio-bus configurations, as this is
>  not supported by the hardware.
> @@ -150,26 +154,61 @@ for the internal master mdio-bus configuration:
>  				port@1 {
>  					reg = <1>;
>  					label = "lan1";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port1>;
>  				};
>  
>  				port@2 {
>  					reg = <2>;
>  					label = "lan2";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port2>;
>  				};
>  
>  				port@3 {
>  					reg = <3>;
>  					label = "lan3";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port3>;
>  				};
>  
>  				port@4 {
>  					reg = <4>;
>  					label = "lan4";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port4>;
>  				};
>  
>  				port@5 {
>  					reg = <5>;
>  					label = "wan";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port5>;
> +				};
> +			};
> +
> +			mdio {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				phy_port1: phy@0 {
> +					reg = <0>;
> +				};
> +
> +				phy_port2: phy@1 {
> +					reg = <1>;
> +				};
> +
> +				phy_port3: phy@2 {
> +					reg = <2>;
> +				};
> +
> +				phy_port4: phy@3 {
> +					reg = <3>;
> +				};
> +
> +				phy_port5: phy@4 {
> +					reg = <4>;
>  				};
>  			};
>  		};
> -- 
> 2.30.2
> 
