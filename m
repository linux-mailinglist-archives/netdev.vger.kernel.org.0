Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F4C2635FD
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgIIS14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:27:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53088 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgIIS1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 14:27:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG4oc-00DxUV-6F; Wed, 09 Sep 2020 20:27:30 +0200
Date:   Wed, 9 Sep 2020 20:27:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909182730.GK3290129@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200909162552.11032-2-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 06:25:46PM +0200, Marek Behún wrote:
> Document binding for LEDs connected to and controlled by various chips
> (such as ethernet PHY chips).
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> ---
>  .../leds/linux,hw-controlled-leds.yaml        | 99 +++++++++++++++++++
>  1 file changed, 99 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> 
> diff --git a/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> new file mode 100644
> index 0000000000000..eaf6e5d80c5f5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> @@ -0,0 +1,99 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/leds/linux,hw-controlled-leds.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LEDs that can be controlled by hardware (eg. by an ethernet PHY chip)
> +
> +maintainers:
> +  - Marek Behún <marek.behun@nic.cz>
> +
> +description:
> +  Many an ethernet PHY (and other chips) supports various HW control modes
> +  for LEDs connected directly to them. With this binding such LEDs can be
> +  described.
> +
> +properties:
> +  compatible:
> +    const: linux,hw-controlled-leds
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +patternProperties:
> +  "^led@[0-9a-f]+$":
> +    type: object
> +    allOf:
> +      - $ref: common.yaml#
> +    description:
> +      This node represents a LED device connected to a chip that can control
> +      the LED in various HW controlled modes.
> +
> +    properties:
> +      reg:
> +        maxItems: 1
> +        description:
> +          This property identifies the LED to the chip the LED is connected to
> +          (eg. an ethernet PHY chip can have multiple LEDs connected to it).
> +
> +      enable-active-high:
> +        description:
> +          Polarity of LED is active high. If missing, assumed default is active
> +          low.
> +        type: boolean
> +
> +      led-tristate:
> +        description:
> +          LED pin is tristate type. If missing, assumed false.
> +        type: boolean
> +
> +      linux,default-hw-mode:
> +        description:
> +          This parameter, if present, specifies the default HW triggering mode
> +          of the LED when LED trigger is set to `dev-hw-mode`.
> +          Available values are specific per device the LED is connected to and
> +          per LED itself.
> +        $ref: /schemas/types.yaml#definitions/string
> +
> +    required:
> +      - reg

My Yaml foo is not very good. Do you need to list colour, function and
linux,default-trigger, or do they automagically get included from the
generic LED binding?

	Andrew
