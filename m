Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB828B18
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 21:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbfEWTye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 15:54:34 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:35943 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387715AbfEWTye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 15:54:34 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 915DD240004;
        Thu, 23 May 2019 19:54:26 +0000 (UTC)
Date:   Thu, 23 May 2019 21:54:26 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>
Subject: Re: [PATCH 1/8] dt-bindings: net: Add YAML schemas for the generic
 Ethernet options
Message-ID: <20190523195426.jmlpmofvm3mqw247@flea>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <CAL_JsqJnFUt55b+AGpcNNjvsKsHNz9PY+b7FJ4+6CMNppzb3vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJnFUt55b+AGpcNNjvsKsHNz9PY+b7FJ4+6CMNppzb3vg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thanks for the review,

On Thu, May 23, 2019 at 08:10:22AM -0500, Rob Herring wrote:
> > +  fixed-link:
> > +    allOf:
> > +      - if:
> > +          type: array
> > +        then:
> > +          minItems: 1
> > +          maxItems: 1
> > +          items:
> > +            type: array
> > +            minItems: 5
> > +            maxItems: 5
> > +          description:
> > +            An array of 5 cells, with the following accepted values
> > +              - At index 0, the emulated PHY ID, choose any but but
> > +                unique to the all specified fixed-links, from 0 to 31
> > +              - at index 1, duplex configuration with 0 for half duplex
> > +                or 1 for full duplex
> > +              - at index 2, link speed in Mbits/sec, accepted values are
> > +                10, 100 and 1000
> > +              - at index 3, pause configuration with 0 for no pause, 1
> > +                for pause
> > +              - at index 4, asymmetric pause configuration with 0 for no
> > +                asymmetric pause, 1 for asymmetric pause
>
> Looks like constraints to me:
>
> items:
>   - minimum: 0
>     maximum: 31
>   - enum: [ 0, 1 ]
>   - enum: [ 10, 100, 1000 ]
> ...

Yeah, we should definitely do something like that. I tried and failed,
but that looks like the right solution.

> > +
> > +
> > +      - if:
>
> Couldn't this be an 'else' and avoid the allOf?

I don't really know, we could go both ways. Which one would be the
more verbose in the case where someone would just have a boolean
instead of the node or the array?

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
