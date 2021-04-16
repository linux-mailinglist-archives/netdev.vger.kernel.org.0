Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8E636213A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242792AbhDPNkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 09:40:46 -0400
Received: from elvis.franken.de ([193.175.24.41]:53884 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhDPNkn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 09:40:43 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lXOhk-0002lT-00; Fri, 16 Apr 2021 15:40:16 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id A52AAC04CD; Fri, 16 Apr 2021 15:35:36 +0200 (CEST)
Date:   Fri, 16 Apr 2021 15:35:36 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 net-next 10/10] dt-bindings: net: korina: Add DT
 bindings for IDT 79RC3243x SoCs
Message-ID: <20210416133536.GA10451@alpha.franken.de>
References: <20210416085207.63181-1-tsbogend@alpha.franken.de>
 <20210416085207.63181-11-tsbogend@alpha.franken.de>
 <ca4d9975-c153-94c9-dec8-bf9416c76b45@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca4d9975-c153-94c9-dec8-bf9416c76b45@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 12:29:46PM +0300, Sergei Shtylyov wrote:
> On 16.04.2021 11:52, Thomas Bogendoerfer wrote:
> 
> > Add device tree bindings for ethernet controller integrated into
> > IDT 79RC3243x SoCs.
> > 
> > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > ---
> >   .../bindings/net/idt,3243x-emac.yaml          | 74 +++++++++++++++++++
> >   1 file changed, 74 insertions(+)
> >   create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> > new file mode 100644
> > index 000000000000..3697af5cb66f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> > @@ -0,0 +1,74 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/idt,3243x-emac.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: IDT 79rc3243x Ethernet controller
> > +
> > +description: Ethernet controller integrated into IDT 79RC3243x family SoCs
> > +
> > +maintainers:
> > +  - Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > +
> > +allOf:
> > +  - $ref: ethernet-controller.yaml#
> > +
> > +properties:
> > +  compatible:
> > +    const: idt,3243x-emac
> > +
> > +  reg:
> > +    maxItems: 3
> > +
> > +  reg-names:
> > +    items:
> > +      - const: korina_regs
> > +      - const: korina_dma_rx
> > +      - const: korina_dma_tx
> > +
> > +  interrupts:
> > +    items:
> > +      - description: RX interrupt
> > +      - description: TX interrupt
> > +
> > +  interrupt-names:
> > +    items:
> > +      - const: korina_rx
> > +      - const: korina_tx
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  clock-names:
> > +    items:
> > +      - const: mdioclk
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - interrupts
> > +  - interrupt-names
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +
> > +    ethernet@60000 {
> > +        compatible = "idt,3243x-emac";
> > +
> > +        reg = <0x60000 0x10000>,
> > +              <0x40000 0x14>,
> > +              <0x40014 0x14>;
> > +        reg-names = "korina_regs",
> > +                    "korina_dma_rx",
> > +                    "korina_dma_tx";
> > +
> > +        interrupts-extended = <&rcpic3 0>, <&rcpic3 1>;
> 
>    You use this prop, yet don't describe it?

that's just interrupt-parent and interrupts in one statement. And since
make dt_binding_check didn't complained I thought that's good this way.
Rob, do I need to describe interrupts-extended as well ?

I could change that to interrupt-parent/interrupts as the driver no
longer uses dma under/overrun interrupts, which have a different
interrupt-parent.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
