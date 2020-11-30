Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD92C862C
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgK3OGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:06:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgK3OGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 09:06:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjjno-009Vq6-RZ; Mon, 30 Nov 2020 15:05:16 +0100
Date:   Mon, 30 Nov 2020 15:05:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/3] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
Message-ID: <20201130140516.GC2073444@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-2-steen.hegelund@microchip.com>
 <20201127170052.GV2073444@lunn.ch>
 <20201130130934.o47mdjiqidtznm2t@mchp-dev-shegelun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130130934.o47mdjiqidtznm2t@mchp-dev-shegelun>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 02:09:34PM +0100, Steen Hegelund wrote:
> On 27.11.2020 18:00, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > > +  reg-names:
> > > +    minItems: 153
> > > +    items:
> > > +      - const: dev2g5_0
> > > +      - const: dev5g_0
> > > +      - const: pcs5g_br_0
> > > +      - const: dev2g5_1
> > > +      - const: dev5g_1
> > ...
> > > +      - const: ana_ac
> > > +      - const: vop
> > 
> > > +    switch: switch@600000000 {
> > > +      compatible = "microchip,sparx5-switch";
> > > +      reg = <0x10004000 0x4000>, /* dev2g5_0 */
> > > +        <0x10008000 0x4000>, /* dev5g_0 */
> > > +        <0x1000c000 0x4000>, /* pcs5g_br_0 */
> > > +        <0x10010000 0x4000>, /* dev2g5_1 */
> > > +        <0x10014000 0x4000>, /* dev5g_1 */
> > 
> > ...
> > 
> > > +        <0x11800000 0x100000>, /* ana_l2 */
> > > +        <0x11900000 0x100000>, /* ana_ac */
> > > +        <0x11a00000 0x100000>; /* vop */
> > 
> > This is a pretty unusual binding.
> > 
> > Why is it not
> > 
> > reg = <0x10004000 0x1af8000>
> > 
> > and the driver can then break up the memory into its sub ranges?
> > 
> >    Andrew
> Hi Andrew,
> 
> Since the targets used by the driver is not always in the natural
> address order (e.g. the dev2g5_x targets), I thought it best to let the DT
> take care of this since this cannot be probed.  I am aware that this causes
> extra mappings compared to the one-range strategy, but this layout seems more
> transparent to me, also when mapped over PCIe.

The question is, do you have a device tree usage for this? Are there
devices in the family which have the regions in a different order?

You can easily move this table into the driver, and let the driver
break the region up. That would be normal.

      Andrew
