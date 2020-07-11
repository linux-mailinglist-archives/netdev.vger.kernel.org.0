Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2459721C55F
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 18:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgGKQwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 12:52:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58646 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgGKQwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 12:52:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juIjL-004djd-Mj; Sat, 11 Jul 2020 18:52:03 +0200
Date:   Sat, 11 Jul 2020 18:52:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
Message-ID: <20200711165203.GO1014141@lunn.ch>
References: <20200710090618.28945-1-kurt@linutronix.de>
 <20200710090618.28945-2-kurt@linutronix.de>
 <20200710163940.GA2775145@bogus>
 <874kqewahb.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kqewahb.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 01:35:12PM +0200, Kurt Kanzenbach wrote:
> On Fri Jul 10 2020, Rob Herring wrote:
> > On Fri, 10 Jul 2020 11:06:18 +0200, Kurt Kanzenbach wrote:
> >> For future DSA drivers it makes sense to add a generic DSA yaml binding which
> >> can be used then. This was created using the properties from dsa.txt. It
> >> includes the ports and the dsa,member property.
> >> 
> >> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> >> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> >> ---
> >>  .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
> >>  1 file changed, 80 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml
> >> 
> >
> >
> > My bot found errors running 'make dt_binding_check' on your patch:
> >
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: 'ports' is a required property
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dt.yaml: switch@10: 'ports' is a required property
> 
> Okay, the requirement for 'ports' has be to removed.

Hummm....

ti.cpsw is not a DSA switch. So this binding should not apply to
it. It is a plain switchdev switch.

The qcom,ipq806 is just an MDIO bus master. The DSA binding might
apply, for a specific .dts file, if that dts file has a DSA switch on
the bus. But in general, it should not apply.

So i actually think you need to work out why this binding is being
applied when it should not be.

I suspect it is the keyword 'switch'. switch does not imply it is a
DSA switch. There are other sorts of switches as well.

	Andrew
