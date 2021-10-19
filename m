Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF0432EE0
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbhJSHGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:06:10 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:15950 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbhJSHGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1634627032;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=LqqeB6DceXFWyX7sgoc88gYwP71+I7K3TbIfjPLLW2Y=;
    b=aDGNLEDBAsCzsBywjPlMbPSjUGQluq8ru6QGESYwJ+vh4AaJvzK6Jxj57m7iBAUALc
    wH9p9cA0rBjTgGo6tIy9GW4RokDSXJYGNce6DQbsGawA8vD4xbN64+T7WZL32rk/bQoP
    0OyUoWf/zy1DAwTyRoBHqznHjJPxvYW5MR0g8eB7+Eb4c7ED5kYW3035CiZWaV6WFf/e
    l+yQwxUtz4WXv3/9tNOoHp6Q1L36X9f1pHXVKIjLEhR0SL5NM4d3ca2kXEe3xGVKlEgm
    m5kpPxAZVDG4UdPej5/lfJ5b0L369+t5eATGkshiD+ta4ZnQv5tg/MgSAMQpVSUMTv3s
    QTjg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u267FZF9PwpcNKLVrKw5+aY="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.33.8 AUTH)
    with ESMTPSA id 301038x9J73obME
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 19 Oct 2021 09:03:50 +0200 (CEST)
Date:   Tue, 19 Oct 2021 09:03:47 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Rob Herring <robh@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add schema for
 Qualcomm BAM-DMUX
Message-ID: <YW5t01Su5ycLm67c@gerhold.net>
References: <20211011141733.3999-1-stephan@gerhold.net>
 <20211011141733.3999-4-stephan@gerhold.net>
 <YW3XgaiT2jBv4D+L@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW3XgaiT2jBv4D+L@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 03:22:25PM -0500, Rob Herring wrote:
> On Mon, Oct 11, 2021 at 04:17:35PM +0200, Stephan Gerhold wrote:
> > The BAM Data Multiplexer provides access to the network data channels of
> > modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916 or
> > MSM8974. It is built using a simple protocol layer on top of a DMA engine
> > (Qualcomm BAM) and bidirectional interrupts to coordinate power control.
> > 
> > The device tree node combines the incoming interrupt with the outgoing
> > interrupts (smem-states) as well as the two DMA channels, which allows
> > the BAM-DMUX driver to request all necessary resources.
> > 
> > Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> > ---
> > Changes since RFC: None.
> > ---
> >  .../bindings/net/qcom,bam-dmux.yaml           | 87 +++++++++++++++++++
> >  1 file changed, 87 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> > new file mode 100644
> > index 000000000000..33e125e70cb4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> > @@ -0,0 +1,87 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/qcom,bam-dmux.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Qualcomm BAM Data Multiplexer
> > +
> > +maintainers:
> > +  - Stephan Gerhold <stephan@gerhold.net>
> > +
> > +description: |
> > +  The BAM Data Multiplexer provides access to the network data channels
> > +  of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
> > +  or MSM8974. It is built using a simple protocol layer on top of a DMA engine
> > +  (Qualcomm BAM DMA) and bidirectional interrupts to coordinate power control.
> > +
> > +properties:
> > +  compatible:
> > +    const: qcom,bam-dmux
> 
> Is this block the same on every SoC? It needs to be SoC specific.
> 

Hm, I think describing it as *SoC*-specific wouldn't be accurate:
This node does not describe any hardware block, it's more a "firmware
convention". The only hardware involved is the BAM DMA engine, which
already has SoC/IP-specific compatibles in its own device tree node.

This means that if anything there should be "firmware version"-specific
compatibles, because one SoC might have different (typically signed)
firmware versions that provide slightly different functionality.
However, I have to admit that I'm not familiar enough with the different
firmware versions to come up with a reasonable naming schema for the
compatible. :/

In general, I cannot think of any difference between different versions
that would matter to a driver. The protocol is quite simple, and minor
firmware differences can be better handled through the control channel
that sets up the connection for the modem.

Does that make sense?

Thanks!
Stephan
