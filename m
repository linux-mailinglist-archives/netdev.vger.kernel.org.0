Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2893EF579
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhHQWIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:08:37 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:33502 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbhHQWIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 18:08:36 -0400
Received: by mail-ot1-f43.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so346222oti.0;
        Tue, 17 Aug 2021 15:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Dkzyna3iRum7FXSG1p1Ls9wZHTi3AwS/R5FqTQ3RqI=;
        b=XadaA+FmfZxDlsehnXnPfIk8R2i3jJgWWL35I91mwKhCiQP9MzuYNL7MkA2AfTyhKo
         L7+qlFie20ztD2TLjRxjytdWPWvYptFwRvPmvqUvfPsUjr0NN1OGZpNnCdBmxE2/dPJP
         0HUtIUboK3MnQx2PaMueueI3uwoY80BzHPuDqArJbLx8d3WvauDTmArTdsXEvKBpJfeI
         0Zw+Dm0j7XWzRTiPLG1orq5ABWjl3ZO4Y3SWRjWnd4eOC6uUZO0fPKjKGm8h4devq5Ni
         wlmJbt8lHNi99kDlkRZwBB9g5X+EB00CPwoUwWpHHGIECvORKLrzLWNr8srDm/GggZW5
         E4dw==
X-Gm-Message-State: AOAM530LotaDDM9SxFzmTYv0xHOXhEmfT0BNgLmDg1I5jRjtJnIp/DUT
        jOKqzx+Svd74WT//X/WgUw==
X-Google-Smtp-Source: ABdhPJxSEgPsC27dcBqGYTR2rv3j7Aq+8UWnVhOlX0fcl8d0ePbZWHyCkvjl04Nx56WiHX7lmn2/8A==
X-Received: by 2002:a9d:638e:: with SMTP id w14mr4276129otk.248.1629238082258;
        Tue, 17 Aug 2021 15:08:02 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l67sm651583otl.3.2021.08.17.15.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 15:08:01 -0700 (PDT)
Received: (nullmailer pid 924856 invoked by uid 1000);
        Tue, 17 Aug 2021 22:08:00 -0000
Date:   Tue, 17 Aug 2021 17:08:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 10/10] docs: devicetree: add
 documentation for the VSC7512 SPI device
Message-ID: <YRwzQJ9LuKrZ4aQM@robh.at.kernel.org>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-11-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814025003.2449143-11-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 07:50:03PM -0700, Colin Foster wrote:
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  .../devicetree/bindings/net/dsa/ocelot.txt    | 92 +++++++++++++++++++
>  1 file changed, 92 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> index 7a271d070b72..edf560a50803 100644
> --- a/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> @@ -8,6 +8,7 @@ Currently the switches supported by the felix driver are:
>  
>  - VSC9959 (Felix)
>  - VSC9953 (Seville)
> +- VSC7511, VSC7512, VSC7513, VSC7514 via SPI
>  
>  The VSC9959 switch is found in the NXP LS1028A. It is a PCI device, part of the
>  larger ENETC root complex. As a result, the ethernet-switch node is a sub-node
> @@ -211,3 +212,94 @@ Example:
>  		};
>  	};
>  };
> +
> +The VSC7513 and VSC7514 switches can be controlled internally via the MIPS
> +processor. The VSC7511 and VSC7512 don't have this internal processor, but all
> +four chips can be controlled externally through SPI with the following required
> +properties:
> +
> +- compatible:
> +	Can be "mscc,vsc7511", "mscc,vsc7512", "mscc,vsc7513", or
> +	"mscc,vsc7514".
> +
> +Supported phy modes for all chips are:
> +
> +* phy_mode = "sgmii": on ports 0, 1, 2, 3
> +
> +The VSC7512 and 7514 also support:
> +
> +* phy_mode = "sgmii": on ports 4, 5, 6, 7
> +* phy_mode = "qsgmii": on ports 7, 8, 10
> +
> +Example for control from a BeagleBone Black
> +
> +&spi0 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	ethernet-switch@0 {
> +		compatible = "mscc,vsc7512";
> +		spi-max-frequency = <250000>;
> +		reg = <0>;
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			port@0 {
> +				reg = <0>;
> +				ethernet = <&mac>;
> +				phy-mode = "sgmii";
> +
> +				fixed-link {
> +					speed = <100>;
> +					full-duplex;
> +				};
> +			};
> +
> +			port@1 {
> +				reg = <1>;
> +				label = "swp1";
> +				phy-handle = <&sw_phy1>;
> +				phy-mode = "sgmii";
> +			};
> +
> +			port@2 {
> +				reg = <2>;
> +				label = "swp2";
> +				phy-handle = <&sw_phy2>;
> +				phy-mode = "sgmii";
> +			};
> +
> +			port@3 {
> +				reg = <3>;
> +				label = "swp3";
> +				phy-handle = <&sw_phy3>;
> +				phy-mode = "sgmii";
> +			};
> +		};
> +
> +		mdio {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			sw_phy1: ethernet-phy@1 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				reg = <0x1>;
> +			};
> +
> +			sw_phy2: ethernet-phy@2 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				reg = <0x2>;
> +			};
> +
> +			sw_phy3: ethernet-phy@3 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				reg = <0x3>;
> +			};
> +		};
> +	};
> +};

If you want a whole new example, then convert this to DT schema. But is 
there anything really new or different here to warrant another example?

Rob
