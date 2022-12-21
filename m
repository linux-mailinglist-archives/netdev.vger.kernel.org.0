Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BB0653384
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiLUPiO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Dec 2022 10:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiLUPhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:37:51 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A390610AE
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:36:11 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1p818b-0007if-9S; Wed, 21 Dec 2022 16:36:09 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1p818Z-000p2n-GJ; Wed, 21 Dec 2022 16:36:07 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1p818X-000AdV-5z; Wed, 21 Dec 2022 16:36:05 +0100
Message-ID: <432ed015f4ba99d6bddd0a10af72324fea1388da.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] dt-bindings: net: Add rfkill-gpio binding
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, kernel@pengutronix.de
Date:   Wed, 21 Dec 2022 16:36:05 +0100
In-Reply-To: <20221221144505.GA2848091-robh@kernel.org>
References: <20221221104803.1693874-1-p.zabel@pengutronix.de>
         <20221221144505.GA2848091-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1+deb11u1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mi, 2022-12-21 at 08:45 -0600, Rob Herring wrote:
> On Wed, Dec 21, 2022 at 11:48:02AM +0100, Philipp Zabel wrote:
> > Add a device tree binding document for GPIO controlled rfkill switches.
> > The name, type, shutdown-gpios and reset-gpios properties are the same
> > as defined for ACPI.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  .../devicetree/bindings/net/rfkill-gpio.yaml  | 60 +++++++++++++++++++
> >  1 file changed, 60 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/rfkill-gpio.yaml b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> > new file mode 100644
> > index 000000000000..6e62e6c96456
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> > @@ -0,0 +1,60 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/net/rfkill-gpio.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +
> > +title: GPIO controlled rfkill switch
> > +
> > +maintainers:
> > +  - Johannes Berg <johannes@sipsolutions.net>
> > +  - Philipp Zabel <p.zabel@pengutronix.de>
> > +
> > +properties:
> > +  compatible:
> > +    const: rfkill-gpio
> > +
> > +  name:
> 
> Did you test this? Something should complain, but maybe not. The problem 
> is 'name' is already a property in the unflattened DT (and old FDT 
> formats).

Thank you. Maybe this was hidden by the fact that I set the name
property to the same string as the node's name.

> 'label' would be appropriate perhaps, but why do we care what the name 
> is?

This is meant to be the identifier of the rfkill API object. It is the
content of /sys/class/rfkill/rfkill0/name, and the 'ID' in the rfkill
command line tool, that can be used to select a switch, in case a
device has multiple radios of the same type.

> > +    $ref: /schemas/types.yaml#/definitions/string
> > +    description: rfkill switch name, defaults to node name
> > +
> > +  type:
> 
> Too generic. Property names should ideally have 1 type globally. I think 
> 'type' is already in use. 'radio-type' instead?

These values correspond to the 'enum rfkill_type' in Linux UAPI, but I
think in this context 'radio-type' would be better than 'rfkill-type'.

> > +    description: rfkill radio type
> > +    enum:
> > +      - wlan
> > +      - bluetooth
> > +      - ultrawideband
> > +      - wimax
> > +      - wwan
> > +      - gps
> > +      - fm
> > +      - nfc
> > +
> > +  shutdown-gpios:
> > +    maxItems: 1
> > +
> > +  reset-gpios:
> > +    maxItems: 1
> 
> I'm lost as to why there are 2 GPIOs.

I don't know either.  My assumption is that this is for devices that
are radio silenced by just asserting their reset pin (for example GPS
chips). The driver handles them the same.

I could remove reset-gpios and make shutdown-gpios required.

> > +
> > +required:
> > +  - compatible
> > +  - type
> > +
> > +oneOf:
> > +  - required:
> > +      - shutdown-gpios
> > +  - required:
> > +      - reset-gpios
> 
> But only 1 can be present? So just define 1 GPIO name.

The intent was that only one of them would be required.

> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    rfkill-pcie-wlan {
> 
> Node names should be generic.

What could be a generic name for this - is "rfkill" acceptable even
though it is a Linux subsystem name? Or would "rf-kill-switch" be
better?

How should they be called if there are multiple of them?

> > +        compatible = "rfkill-gpio";
> > +        name = "rfkill-pcie-wlan";
> > +        type = "wlan";
> > +        shutdown-gpios = <&gpio2 25 GPIO_ACTIVE_HIGH>;
> > +    };
> > -- 
> > 2.30.2

regards
Philipp
