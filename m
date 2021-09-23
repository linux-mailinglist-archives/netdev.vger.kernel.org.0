Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6E6416433
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 19:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242443AbhIWRQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 13:16:48 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:45921 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242279AbhIWRQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 13:16:48 -0400
Received: by mail-oi1-f181.google.com with SMTP id v10so10564179oic.12;
        Thu, 23 Sep 2021 10:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W/zoLBVYWYLAtQZXuGopwcFe9NOYRSnJw/clVnUsFws=;
        b=U6PDtOcYhQe7d6cF7i58v19YsNuJpu6Cb53q5sDXDsNfEOB72AFwLyihmTTPQmOx6J
         gHWvBjJjkWyeHiqBSeM/I+t8vON20sdirzZuQ9OqmYY2dv9NvRKkAi1oPFCugksX4EZ9
         E+tKDNpnOkqsfe3ZEypV2oNjYoKucLQK0MGvBzNB/7arKdOADj295uAZI8fSg+DlRgh4
         dWG+tLNbZVh6gDUM/DTRppUf6P2FTmUtwhqiNahUxE3dUNLZRI+PRQAvNI9bZmFPkHH8
         2yMvodZcpeRwPYKcszwB0SmgaqaaWnObglgR56V7BIs8ztqptrCqzWCT380wBjcMc4JN
         1nCg==
X-Gm-Message-State: AOAM5332dsC0rSzc2kc84FZkChTkK3N3MZ2WOoDGcHBJ5paG/Djl9GYk
        N430XrHC1uKq5pkBCpXO+Q==
X-Google-Smtp-Source: ABdhPJxsPme0f+zK3Xd121B7VN662M2+ciakkuDqc+YkX/kl4uyVjyJITFOqneN0tIkPDIVoD/MX/Q==
X-Received: by 2002:a05:6808:494:: with SMTP id z20mr13439028oid.103.1632417315848;
        Thu, 23 Sep 2021 10:15:15 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 14sm1428384oiy.53.2021.09.23.10.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 10:15:15 -0700 (PDT)
Received: (nullmailer pid 3191243 invoked by uid 1000);
        Thu, 23 Sep 2021 17:15:14 -0000
Date:   Thu, 23 Sep 2021 12:15:14 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC PATCH 2/2] Documentation: devicetree: net: dsa:
 qca8k: document configurable led support
Message-ID: <YUy2Ikol0dzO6Epp@robh.at.kernel.org>
References: <20210920180851.30762-1-ansuelsmth@gmail.com>
 <20210920180851.30762-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920180851.30762-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 08:08:51PM +0200, Ansuel Smith wrote:
> Document binding for configurable led. Ports led can now be set on/off
> and the blink/on rules can be configured using the "qca,led_rules"
> binding. Refer to the Documentation on how to configure them.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.txt     | 249 ++++++++++++++++++
>  1 file changed, 249 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 8c73f67c43ca..233f02cd9e98 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -29,6 +29,45 @@ the mdio MASTER is used as communication.
>  Don't use mixed external and internal mdio-bus configurations, as this is
>  not supported by the hardware.
>  
> +A leds subnode can be declared to configure leds port behaviour.
> +The leds subnode must declare the port with the mdio reg that will have the
> +attached led. Each port can have a max of 3 different leds. (Refer to example)
> +A led can have 4 different settings:
> +- Always off
> +- Always on
> +- Blink at 4hz
> +- Hw_mode: This special mode follow control_rule rules and blink based on switch
> +event.
> +A sysfs entry for control_rule and hw_mode is provided for each led.
> +Control rule for phy0-3 are shared and refer to the same reg. That means that
> +phy0-3 will blink based on the same rules. Phy4 have its dedicated control_rules.
> +
> +Each led can have the following binding:
> +The binding "default-state" can be declared to set them off by default or to
> +follow leds control_rule using the keep value. By default hw_mode is set as it's
> +the default switch setting.
> +The binding "qca,led_rules" can be used to declare the control_rule set on
> +switch setup. The following rules can be applied decalred in an array of string
> +in the dts:
> +- tx-blink: Led blink on tx traffic for the port
> +- rx-blink: Led blink on rx traffic for the port
> +- collision-blink: Led blink when a collision is detected for the port
> +- link-10M: Led is turned on when a link of 10M is detected for the port
> +- link-100M: Led is turned on when a link of 100M is detected for the port
> +- link-1000M: Led is turned on when a link of 1000M is detected for the port
> +- half-duplex: Led is turned on when a half-duplex link is detected for the port
> +- full-duplex: Led is turned on when a full-duplex link is detected for the port
> +- linkup-over: Led blinks only when the linkup led is on, ignore blink otherwise
> +- power-on-reset: Reset led on switch reset
> +- One of
> +	- blink-2hz: Led blinks at 2hz frequency
> +	- blink-4hz: Led blinks at 4hz frequency
> +	- blink-8hz: Led blinks at 8hz frequency
> +	- blink-auto: Led blinks at 2hz frequency with 10M, 4hz with 100M, 8hz
> +	  with 1000M
> +Due to the phy0-3 limitation, multiple use of 'qca8k_led_rules' will result in
> +the last defined one to be applied.
> +

Too big a change for plain text. This needs to be a schema (and also 
common most likely).

>  The CPU port of this switch is always port 0.
>  
>  A CPU port node has the following optional node:
> @@ -213,3 +252,213 @@ for the internal master mdio-bus configuration:
>  			};
>  		};
>  	};
> +
> +for the leds declaration example:
> +
> +#include <dt-bindings/leds/common.h>
> +
> +	&mdio0 {
> +		switch@10 {
> +			compatible = "qca,qca8337";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
> +			reg = <0x10>;
> +
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				port@0 {
> +					reg = <0>;
> +					label = "cpu";
> +					ethernet = <&gmac1>;
> +					phy-mode = "rgmii";
> +					fixed-link {
> +						speed = 1000;
> +						full-duplex;
> +					};
> +				};
> +
> +				port@1 {
> +					reg = <1>;
> +					label = "lan1";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port1>;
> +				};
> +
> +				port@2 {
> +					reg = <2>;
> +					label = "lan2";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port2>;
> +				};
> +
> +				port@3 {
> +					reg = <3>;
> +					label = "lan3";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port3>;
> +				};
> +
> +				port@4 {
> +					reg = <4>;
> +					label = "lan4";
> +					phy-mode = "internal";
> +					phy-handle = <&phy_port4>;
> +				};
> +
> +				port@5 {
> +					reg = <5>;
> +					label = "wan";
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
> +				};
> +			};
> +
> +			leds {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				phy@0 {

Duplicating the phy's here? LEDs are a function of the phy, so they 
should be under the actual phy node. So this should be a 'leds' node 
under the mdio/phy@0 node.

> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					reg = <0>;
> +
> +					led@0 {
> +						reg = <0>;
> +						color = <LED_COLOR_ID_GREEN>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_LAN;
> +						function-enumerator = <1>;
> +					};
> +
> +					led@1 {
> +						reg = <1>;
> +						color = <LED_COLOR_ID_AMBER>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_LAN;
> +						function-enumerator = <1>;
> +					};
> +				};
> +
> +				phy@1 {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					reg = <1>;
> +
> +					led@0 {
> +						reg = <0>;
> +						color = <LED_COLOR_ID_GREEN>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_LAN;
> +						function-enumerator = <2>;
> +					};
> +
> +					led@1 {
> +						reg = <1>;
> +						color = <LED_COLOR_ID_AMBER>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_LAN;
> +						function-enumerator = <2>;
> +					};
> +				};
> +
> +				phy@2 {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					reg = <2>;
> +
> +					led@0 {
> +						reg = <0>;
> +						color = <LED_COLOR_ID_GREEN>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_LAN;
> +						function-enumerator = <3>;
> +					};
> +
> +					led@1 {
> +						reg = <1>;
> +						color = <LED_COLOR_ID_AMBER>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_LAN;
> +						function-enumerator = <3>;
> +					};
> +				};
> +
> +				phy@3 {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					reg = <3>;
> +
> +					led@0 {
> +						reg = <0>;
> +						color = <LED_COLOR_ID_GREEN>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_LAN;
> +						function-enumerator = <4>;
> +					};
> +
> +					led@1 {
> +						reg = <1>;
> +						color = <LED_COLOR_ID_AMBER>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_LAN;
> +						function-enumerator = <4>;
> +					};
> +				};
> +
> +				phy@4 {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					reg = <4>;
> +
> +					led@0 {
> +						reg = <0>;
> +						color = <LED_COLOR_ID_GREEN>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_WAN;
> +						qca,led_rules = "tx-blink", "rx-blink", "link-1000M", "full-duplex", "linkup-over", "blink-8hz";
> +					};
> +
> +					led@1 {
> +						reg = <1>;
> +						color = <LED_COLOR_ID_AMBER>;
> +						default-state = "keep";
> +						function = LED_FUNCTION_WAN;
> +					};
> +				};
> +			};
> +		};
> +	};
> \ No newline at end of file

Fix this.

> -- 
> 2.32.0
> 
> 
