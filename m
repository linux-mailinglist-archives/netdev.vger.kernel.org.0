Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EE93E36EA
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 21:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhHGTFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 15:05:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38408 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGTFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 15:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kn6cL09Y4NMxxmqQnsrVBNiHMYyVkK31PINrCIN33Ng=; b=uQiZf+RdEytsY/zD0ZsCeJSOBS
        5DpjrN8NCiQ0zTiJosZEaRGs2PbJo5j5Dv4PpxQA/S2/0TxRn5VeCbsxDh/9PEe/DiqLacgSFQ76h
        12Xj4W9GulTn4OIlxpmdS47M+fwriBIiG3LIgvSCl6DnE0V2h+TIfdp03XnAgoyKOTGE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCRd0-00GVy6-CR; Sat, 07 Aug 2021 21:05:02 +0200
Date:   Sat, 7 Aug 2021 21:05:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: Add bindings for LiteETH
Message-ID: <YQ7ZXu7hHTCNBwNz@lunn.ch>
References: <20210806054904.534315-1-joel@jms.id.au>
 <20210806054904.534315-2-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806054904.534315-2-joel@jms.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 03:19:03PM +0930, Joel Stanley wrote:
> LiteETH is a small footprint and configurable Ethernet core for FPGA
> based system on chips.
> 
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
>  .../bindings/net/litex,liteeth.yaml           | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
> new file mode 100644
> index 000000000000..e2a837dbfdaa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
> @@ -0,0 +1,62 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/litex,liteeth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LiteX LiteETH ethernet device
> +
> +maintainers:
> +  - Joel Stanley <joel@jms.id.au>
> +
> +description: |
> +  LiteETH is a small footprint and configurable Ethernet core for FPGA based
> +  system on chips.
> +
> +  The hardware source is Open Source and can be found on at
> +  https://github.com/enjoy-digital/liteeth/.
> +
> +properties:
> +  compatible:
> +    const: litex,liteeth
> +
> +  reg:
> +    minItems: 3
> +    items:
> +      - description: MAC registers
> +      - description: MDIO registers
> +      - description: Packet buffer

Hi Joel

How configurable is the synthesis? Can the MDIO bus be left out? You
can have only the MDIO bus and no MAC?

I've not looked at the driver yet, but if the MDIO bus has its own
address space, you could consider making it a standalone
device. Somebody including two or more LiteETH blocks could then have
one shared MDIO bus. That is a supported Linux architecture.

> +
> +  interrupts:
> +    maxItems: 1
> +
> +  rx-fifo-depth:
> +    description: Receive FIFO size, in units of 2048 bytes
> +
> +  tx-fifo-depth:
> +    description: Transmit FIFO size, in units of 2048 bytes
> +
> +  mac-address:
> +    description: MAC address to use
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    mac: ethernet@8020000 {
> +        compatible = "litex,liteeth";
> +        reg = <0x8021000 0x100
> +               0x8020800 0x100
> +               0x8030000 0x2000>;
> +        rx-fifo-depth = <2>;
> +        tx-fifo-depth = <2>;
> +        interrupts = <0x11 0x1>;
> +    };

You would normally expect to see some MDIO properties here, a link to
the standard MDIO yaml, etc.

    Andrew
