Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4FE1C79E5
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgEFTHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgEFTHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 15:07:49 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5422E2082E;
        Wed,  6 May 2020 19:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588792068;
        bh=vEk1l0b0aFjTQ+QBNrJc+lWz02KZWQQiVF4ewewFykU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0QsngKDy/UO8gxrQY1fAvH4QzO5WeKaDcfHIrnt7woYWDCCvSKkxaileozhDC5MLB
         oqElanvadLKbqmBxOniFXtHkRMO0N4OOfFFIWvjqESHoITgf3Q5q8AL8WDQjWccAA0
         EKJ2mhJVOx15ruRXrdP/nTwYnOKmlvMyjBPxCFvw=
Received: by mail-oi1-f182.google.com with SMTP id x7so1852127oic.3;
        Wed, 06 May 2020 12:07:48 -0700 (PDT)
X-Gm-Message-State: AGi0PuYzYydBbUhhFhjcDSPtrZ+aFI1Njo74rG7KVPggs3yNSvqtydhe
        Td90S1TZ13miPVo7+rfseoLf5nSQ70Cwq/xByw==
X-Google-Smtp-Source: APiQypIxk+82zWtS2WRfVpiOgxoVhgubSQ/9B246d0TSOVrM2QLI+fFAW4fIxOBrlbcY7o4Hsx5IbKqmonMdFvVQz7c=
X-Received: by 2002:a05:6808:24f:: with SMTP id m15mr4069585oie.152.1588792067520;
 Wed, 06 May 2020 12:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
 <20200501205011.14899-2-grygorii.strashko@ti.com> <20200505040419.GA8509@bogus>
 <b8bb1076-e345-5146-62d3-e1da1d35da4f@ti.com>
In-Reply-To: <b8bb1076-e345-5146-62d3-e1da1d35da4f@ti.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 6 May 2020 14:07:35 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+P_OEFDBbAsvyCCOKZnQuAUYYnyDDwm7aNudN3pRK78g@mail.gmail.com>
Message-ID: <CAL_Jsq+P_OEFDBbAsvyCCOKZnQuAUYYnyDDwm7aNudN3pRK78g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] dt-binding: ti: am65x: document common
 platform time sync cpts module
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tero Kristo <t-kristo@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        netdev <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 10:01 AM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
>
>
>
> On 05/05/2020 07:04, Rob Herring wrote:
> > On Fri, May 01, 2020 at 11:50:05PM +0300, Grygorii Strashko wrote:
> >> Document device tree bindings for TI AM654/J721E SoC The Common Platform
> >> Time Sync (CPTS) module. The CPTS module is used to facilitate host control
> >> of time sync operations. Main features of CPTS module are:
> >>    - selection of multiple external clock sources
> >>    - 64-bit timestamp mode in ns with ppm and nudge adjustment.
> >>    - control of time sync events via interrupt or polling
> >>    - hardware timestamp of ext. events (HWx_TS_PUSH)
> >>    - periodic generator function outputs (TS_GENFx)
> >>    - PPS in combination with timesync router
> >>    - Depending on integration it enables compliance with the IEEE 1588-2008
> >> standard for a precision clock synchronization protocol, Ethernet Enhanced
> >> Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
> >> Measurement (PTM).
> >>
> >> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >> ---
> >>   .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |   7 +
> >>   .../bindings/net/ti,k3-am654-cpts.yaml        | 152 ++++++++++++++++++
> >>   2 files changed, 159 insertions(+)
> >>   create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> >> index 78bf511e2892..0f3fde45e200 100644
> >> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> >> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> >> @@ -144,6 +144,13 @@ patternProperties:
> >>       description:
> >>         CPSW MDIO bus.
> >>
> >> +  "^cpts$":
>
> ok
>
> >
> > Fixed strings go under 'properties'.
> >
> >> +    type: object
> >> +    allOf:
> >> +      - $ref: "ti,am654-cpts.yaml#"
> >> +    description:
> >> +      CPSW Common Platform Time Sync (CPTS) module.
> >> +
> >>   required:
> >>     - compatible
> >>     - reg
> >> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> >> new file mode 100644
> >> index 000000000000..1b535d41e5c6
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
> >> @@ -0,0 +1,152 @@
> >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >> +%YAML 1.2
> >> +---
> >> +$id: http://devicetree.org/schemas/net/ti,am654-cpts.yaml#
> >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >> +
> >> +title: The TI AM654x/J721E Common Platform Time Sync (CPTS) module Device Tree Bindings
> >> +
> >> +maintainers:
> >> +  - Grygorii Strashko <grygorii.strashko@ti.com>
> >> +  - Sekhar Nori <nsekhar@ti.com>
> >> +
> >> +description: |+
> >> +  The TI AM654x/J721E CPTS module is used to facilitate host control of time
> >> +  sync operations.
> >> +  Main features of CPTS module are
> >> +  - selection of multiple external clock sources
> >> +  - Software control of time sync events via interrupt or polling
> >> +  - 64-bit timestamp mode in ns with PPM and nudge adjustment.
> >> +  - hardware timestamp push inputs (HWx_TS_PUSH)
> >> +  - timestamp counter compare output (TS_COMP)
> >> +  - timestamp counter bit output (TS_SYNC)
> >> +  - periodic Generator function outputs (TS_GENFx)
> >> +  - Ethernet Enhanced Scheduled Traffic Operations (CPTS_ESTFn) (TSN)
> >> +  - external hardware timestamp push inputs (HWx_TS_PUSH) timestamping
> >> +
> >> +   Depending on integration it enables compliance with the IEEE 1588-2008
> >> +   standard for a precision clock synchronization protocol, Ethernet Enhanced
> >> +   Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
> >> +   Measurement (PTM).
> >> +
> >> +  TI AM654x/J721E SoCs has several similar CPTS modules integrated into the
> >> +  different parts of the system which could be synchronized with each other
> >> +  - Main CPTS
> >> +  - MCU CPSW CPTS with IEEE 1588-2008 support
> >> +  - PCIe subsystem CPTS for PTM support
> >> +
> >> +  Depending on CPTS module integration and when CPTS is integral part of
> >> +  another module (MCU CPSW for example) "compatible" and "reg" can
> >> +  be omitted - parent module is fully responsible for CPTS enabling and
> >> +  configuration.
> >
> > That's fine, but you should still have compatible and reg.
>
> I'll add reg as below. But compatible is an issue, because
> k3-am654-cpsw-nuss call of_platform_populate() to create mdio device.
> But for CPTS I do not want to create device as k3-am654-cpsw-nuss uses direct
> function calls to CPTS.
>
> Will it be correct to switch to of_platform_device_create() instead of
> of_platform_populate()?

That should be fine I think.

Rob
