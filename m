Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EF021BDD3
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgGJTi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 15:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgGJTi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 15:38:56 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CC0207D0;
        Fri, 10 Jul 2020 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594409935;
        bh=LoSJMfK92YumYrvaNsXj0AvUWvu64EYY6m7/BSaeTZE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hfo2UZfOYx7MpoASvQLR99H+ibRB7SEkkhnbNkgJliAjznTi2b/kwTwCzWjoCb9Qs
         eAqPBuekTIt3JjJ0YbXm3xoJwfW89Io9IOJp7y6LmOWBc17HisInGsENy91VP2A3zK
         6An4u/q+LOm/Fdhiq0n2Ylago4ABnI1N0QmtEbX8=
Received: by mail-oi1-f177.google.com with SMTP id k22so5755189oib.0;
        Fri, 10 Jul 2020 12:38:55 -0700 (PDT)
X-Gm-Message-State: AOAM530VawN/oLmTYunAQMtve420c8Ow0G5OArjyXaZ4TETSm+kpr6iL
        +aMFLI2gX48Y3zujxddLuIgVll+/Mr1rV9s9ag==
X-Google-Smtp-Source: ABdhPJzAB5d07pCJasiAsdsh07SEaezq9dexRFAqKHbwbvGpDpVDW2NzrP+hP7WWnZwkzjXsmVZfthZDAm74TW+L56A=
X-Received: by 2002:aca:bb82:: with SMTP id l124mr5555099oif.106.1594409934332;
 Fri, 10 Jul 2020 12:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200710090618.28945-1-kurt@linutronix.de> <20200710090618.28945-2-kurt@linutronix.de>
 <20200710164500.GA2775934@bogus> <8c105489-42c5-b4ba-73b6-c3a858f646a6@gmail.com>
In-Reply-To: <8c105489-42c5-b4ba-73b6-c3a858f646a6@gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 10 Jul 2020 13:38:42 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+zP9++MftM+Dh2Fe-OdKq6EiGA_tASEbBwA_jEdwoFCA@mail.gmail.com>
Message-ID: <CAL_Jsq+zP9++MftM+Dh2Fe-OdKq6EiGA_tASEbBwA_jEdwoFCA@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 11:20 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 7/10/2020 9:45 AM, Rob Herring wrote:
> > On Fri, Jul 10, 2020 at 11:06:18AM +0200, Kurt Kanzenbach wrote:
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
> >> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> >> new file mode 100644
> >> index 000000000000..bec257231bf8
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> >> @@ -0,0 +1,80 @@
> >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >> +%YAML 1.2
> >> +---
> >> +$id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
> >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >> +
> >> +title: Distributed Switch Architecture Device Tree Bindings
> >
> > DSA is a Linuxism, right?
>
> Not really, it is a Marvell term that describes their proprietary
> switching protocol. Since then DSA within Linux expands well beyond just
> Marvell switches, so the terms have been blurred a little bit.

Either way, sounds like the terminology here should be more general.

Though I missed that this is really just a conversion of dsa.txt which
should be removed in this patch. Otherwise, you'll get me re-reviewing
the binding.

> >> +
> >> +maintainers:
> >> +  - Andrew Lunn <andrew@lunn.ch>
> >> +  - Florian Fainelli <f.fainelli@gmail.com>
> >> +  - Vivien Didelot <vivien.didelot@gmail.com>
> >> +
> >> +description:
> >> +  Switches are true Linux devices and can be probed by any means. Once probed,
> >
> > Bindings are OS independent.
> >
> >> +  they register to the DSA framework, passing a node pointer. This node is
> >> +  expected to fulfil the following binding, and may contain additional
> >> +  properties as required by the device it is embedded within.
> >
> > Describe what type of h/w should use this binding.
> >
> >> +
> >> +properties:
> >> +  $nodename:
> >> +    pattern: "^switch(@.*)?$"
> >> +
> >> +  dsa,member:
> >> +    minItems: 2
> >> +    maxItems: 2
> >> +    description:
> >> +      A two element list indicates which DSA cluster, and position within the
> >> +      cluster a switch takes. <0 0> is cluster 0, switch 0. <0 1> is cluster 0,
> >> +      switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
> >> +      (single device hanging off a CPU port) must not specify this property
> >> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> >> +
> >> +  ports:
> >> +    type: object
> >> +    properties:
> >> +      '#address-cells':
> >> +        const: 1
> >> +      '#size-cells':
> >> +        const: 0
> >> +
> >> +    patternProperties:
> >> +      "^port@[0-9]+$":
> >
> > As ports and port are OF graph nodes, it would be better if we
> > standardized on a different name for these. I think we've used
> > 'ethernet-port' some.
>
> Yes we did talk about that before, however when the original DSA binding
> was introduced about 7 years ago (or maybe more recently, my memory
> fails me now), "ports" was chosen as the encapsulating node. We should
> be accepting both ethernet-ports and ports.

Yes, I'm aware of the history. Back then it was a free-for-all on node
names. Now we're trying to be more disciplined. Ideally, we pick
something unique to standardize on and fix the dts files to match as
long as the node name is generally a don't care for the OS.

The schema says only port/ports is allowed, so at a minimum
ethernet-port/ethernet-ports needs to be added here.

>
> >
> >> +          type: object
> >> +          description: DSA switch ports
> >> +
> >> +          allOf:
> >> +            - $ref: ../ethernet-controller.yaml#
> >
> > How does this and 'ethernet' both apply?
>
> I think the intent here was to mean that some of the properties from the
> Ethernet controller such as phy-mode, phy-handle, fixed-link also apply
> here since the switch port is a simplified Ethernet MAC on a number of
> counts.

Okay, it's good to explicitly define which of those apply as I imagine
some don't. Just need "<prop>: true" to do that.

Rob
