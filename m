Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5549B123E4
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 23:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfEBVKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 17:10:00 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39226 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBVJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 17:09:59 -0400
Received: by mail-ot1-f67.google.com with SMTP id o39so3453249ota.6;
        Thu, 02 May 2019 14:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QtkqH6IpA43h0KuYAycj7yzP1AGC1MU/BxNPtjJYr3s=;
        b=QwDzL7z3wxUmkH1SZ97Eex5jesLQtxjwgwV8tVXzae5Hk+MH1lw9PL6lAKbgwf8f7W
         QhZuFpFotJl00HGKnkNKtXWu2MnbVoGQuGq9/bY7palwPJ114d862w6Glj7eDtpVsU4m
         cJoSeOD/jHqfhX0G1KhuZddf0g4ToYzOYJRuv+MuW6mBD7RXAwVIEH9wGEHsfUzbEXb/
         IP75AaNRbXMGO6DMbRjIHkDy/oYPsaVBL0pKGA3K754d9R1F/IuOuLkvEL+vbfStLbW1
         Yhd5DzJNNC8wAqcGjSFo/rePzVfsbKDpP8IrPiMi2xJ7djI8i6eaXd9qPgIAUS7vxbS2
         L0nQ==
X-Gm-Message-State: APjAAAXeg58ad0fDFgK4W30CWjZqpOS5+Hp30zsN+74QAQp6gTmiWPWc
        dwX6YSAhafMW0YFiY1BXsgHown8=
X-Google-Smtp-Source: APXvYqxnZxXvfqjHdophlaBthbXEy4/BcPCcWZUXO7xwC3VYB/+OhqEMFQzMzayuAotgP38xuu7vgw==
X-Received: by 2002:a9d:7f0b:: with SMTP id j11mr4397270otq.132.1556831398985;
        Thu, 02 May 2019 14:09:58 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id j14sm43899otk.14.2019.05.02.14.09.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 14:09:58 -0700 (PDT)
Date:   Thu, 2 May 2019 16:09:57 -0500
From:   Rob Herring <robh@kernel.org>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: wiznet: add w5x00 support
Message-ID: <20190502210957.GA12202@bogus>
References: <20190430185215.21685-1-nsaenzjulienne@suse.de>
 <20190430185215.21685-2-nsaenzjulienne@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430185215.21685-2-nsaenzjulienne@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 08:52:14PM +0200, Nicolas Saenz Julienne wrote:
> Add bindings for Wiznet's w5x00 series of SPI interfaced Ethernet chips.
> 
> Based on the bindings for microchip,enc28j60.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> ---
>  .../devicetree/bindings/net/wiznet,w5x00.txt  | 48 +++++++++++++++++++
>  1 file changed, 48 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wiznet,w5x00.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wiznet,w5x00.txt b/Documentation/devicetree/bindings/net/wiznet,w5x00.txt
> new file mode 100644
> index 000000000000..2cbedefb1607
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wiznet,w5x00.txt
> @@ -0,0 +1,48 @@
> +* Wiznet w5x00
> +
> +This is a standalone 10/100 MBit Ethernet controller with SPI interface.
> +
> +For each device connected to a SPI bus, define a child node within
> +the SPI master node.
> +
> +Required properties:
> +- compatible: Should be "wiznet,w5100", "wiznet,w5200" or "wiznet,w5500"

One per line please.

> +- reg: Specify the SPI chip select the chip is wired to.
> +- interrupts: Specify the interrupt index within the interrupt controller (referred
> +              to above in interrupt-parent) and interrupt type. w5x00 natively
> +              generates falling edge interrupts, however, additional board logic
> +              might invert the signal.
> +- pinctrl-names: List of assigned state names, see pinctrl binding documentation.
> +- pinctrl-0: List of phandles to configure the GPIO pin used as interrupt line,
> +             see also generic and your platform specific pinctrl binding
> +             documentation.
> +
> +Optional properties:
> +- spi-max-frequency: Maximum frequency of the SPI bus when accessing the w5500.
> +  According to the w5500 datasheet, the chip allows a maximum of 80 MHz, however,
> +  board designs may need to limit this value.
> +- local-mac-address: See ethernet.txt in the same directory.
> +
> +
> +Example (for Raspberry Pi with pin control stuff for GPIO irq):
> +
> +&spi {
> +	eth1: w5500@0 {

ethernet@0

> +		compatible = "wiznet,w5500";
> +		reg = <0>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&eth1_pins>;
> +		interrupt-parent = <&gpio>;
> +		interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
> +		spi-max-frequency = <30000000>;
> +	};
> +};
> +
> +&gpio {
> +	eth1_pins: eth1_pins {
> +		brcm,pins = <25>;
> +		brcm,function = <0>; /* in */
> +		brcm,pull = <0>; /* none */
> +	};
> +};
> +
> -- 
> 2.21.0
> 
