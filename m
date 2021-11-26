Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A52545F363
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbhKZSGV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Nov 2021 13:06:21 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52453 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbhKZSEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 13:04:20 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 719D460016;
        Fri, 26 Nov 2021 18:01:03 +0000 (UTC)
Date:   Fri, 26 Nov 2021 19:00:55 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>
Subject: Re: [PATCH net-next v3 1/4] dt-bindings: net: mscc,vsc7514-switch:
 convert txt bindings to yaml
Message-ID: <20211126190055.1911a142@fixe.home>
In-Reply-To: <20211126175004.6dsumhtepek4m36h@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
        <20211126172739.329098-2-clement.leger@bootlin.com>
        <20211126175004.6dsumhtepek4m36h@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 26 Nov 2021 17:50:05 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Fri, Nov 26, 2021 at 06:27:36PM +0100, Clément Léger wrote:
> > +  ethernet-ports:
> > +    type: object
> > +
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
> > +
> > +    additionalProperties: false
> > +
> > +    patternProperties:
> > +      "^port@[0-9a-f]+$":
> > +        type: object
> > +        description: Ethernet ports handled by the switch
> > +
> > +        $ref: ethernet-controller.yaml#
> > +
> > +        unevaluatedProperties: false
> > +
> > +        properties:
> > +          reg:
> > +            description: Switch port number
> > +
> > +          phy-handle: true
> > +
> > +          phy-mode: true
> > +
> > +          fixed-link: true
> > +
> > +          mac-address: true
> > +
> > +        required:
> > +          - reg
> > +
> > +        oneOf:
> > +          - required:
> > +              - phy-handle
> > +              - phy-mode
> > +          - required:
> > +              - fixed-link  
> 
> Are you practically saying that a phy-mode would not be required with
> fixed-link? Because it still is...

I tried to get it right by looking at a binding you probably know
(dsa.yaml), but none of them are using a oneOf property for these
properties so I tried to guess what was really required or not. I will
add the phy-mode property in the required field since it seems always
needed:

+        required:
+          - reg
+          - phy-mode
+
+        oneOf:
+          - required:
+              - phy-handle
+          - required:
+              - fixed-link  

Does it looks good to you ?

Thanks,

> 
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - interrupts
> > +  - interrupt-names
> > +  - ethernet-port  



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
