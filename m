Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEEB5FBE07
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 01:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJKXB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 19:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJKXB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 19:01:26 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA8F9FEC
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 16:01:24 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-12c8312131fso17700566fac.4
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 16:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NmhxoB5FfeDLQSOCmHfU2Us6Bf0La5Ymj1Q8d1Ci+Y=;
        b=hikWRSPJtZ8VgEI+7O08taRL31Iuz4MeLJoGC3SNfDE8lzz9/5U7qHVs0JOqSwbb74
         0/9FAAHaNLYp5fTy5fJXOEHD9Y4+gV7fZJayd+8eWkvHpXfuesOZLzAGCl6qRvZSh4UX
         uA1Je/OFgiw1jMkUxkNeSEBzVsFkooPN4sh6UjJ9eIZgZjzFnzqvnYnquwhMF9jbxQPz
         I918R1C3D5WxRB4js8CSyu1tUmt2YIhawgGfzgViQdnxCvYO66g2GwZ+O3a7M3kx87eP
         8i28++Kyxuu7LjUOM8ibFEfJXcltBbgLpRWOpOKU42ZjZ/Odl8fQTmMGv+ZkjX8pwkWV
         DnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NmhxoB5FfeDLQSOCmHfU2Us6Bf0La5Ymj1Q8d1Ci+Y=;
        b=aA67aY1dmg9bV7S+Kp6vlrA/asHYv//WtH7i4siutIT4gQH4B6TD13F0BA2Ipq7U2v
         61ypE4Yz/UUY0NSJLs7hGZOyr5aMJkWkowryngakQQl00MEDzdphfrs58xfgHlY42V26
         G655xApG6VMlAtRWbmohgvNZInXMmSkkALiJ9lINDYXEvEvnEA3m27N/c72V9jpcfGfy
         RApI5B4HPirEwSlyFY4oufvcbLq9CDG2Wl5CBPRPz80dyg9FwtKRukOL60n5SgQaZMzV
         5bCfisS51uXmvbw9Ydg3T/Kf7wSPnTxSA9sPHJzf7dAAqabF37Z0/Rmk4s66sviqqy6x
         Tp2w==
X-Gm-Message-State: ACrzQf0S1qYIGi6YucO6LPDoIddecc2TaVce/adsU0gBrrFwFs0VIUco
        LYh19KUcwwQruDkanbqPQ6kKl0ojbJlkPu+ecgRncQ==
X-Google-Smtp-Source: AMsMyM5N0L4L3FOVl+mGmuvzLjnRyLQ9Hgcq2jpnXWweheGK6eoLgzIp/P4hGoetZKJhy7Ds098DMbaUVMNhz/RjXvM=
X-Received: by 2002:a05:6870:c082:b0:12b:542c:71cf with SMTP id
 c2-20020a056870c08200b0012b542c71cfmr848222oad.45.1665529283863; Tue, 11 Oct
 2022 16:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221011190613.13008-1-mig@semihalf.com> <20221011190613.13008-2-mig@semihalf.com>
 <ad015bc9-a6d2-491d-463a-42a6a0afbf75@linaro.org> <CAPv3WKcY=erFTBDLP1AhQa0+CP6C8KJinmKFEkR2xh4mHHv_aQ@mail.gmail.com>
In-Reply-To: <CAPv3WKcY=erFTBDLP1AhQa0+CP6C8KJinmKFEkR2xh4mHHv_aQ@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 12 Oct 2022 01:01:13 +0200
Message-ID: <CAPv3WKdon28ntGQ=xbmL+CEFQ7=xzOQOcV9qN_8MOt-uiLHoXg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dt-bindings: net: marvell,pp2: convert to json-schema
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     =?UTF-8?Q?Micha=C5=82_Grzelak?= <mig@semihalf.com>,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wt., 11 pa=C5=BA 2022 o 22:34 Marcin Wojtas <mw@semihalf.com> napisa=C5=82(=
a):
>
> Hi Krzysztof,
>
> Let me chime in.
>
> wt., 11 pa=C5=BA 2022 o 21:50 Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> napisa=C5=82(a):
> >
> > On 11/10/2022 15:06, Micha=C5=82 Grzelak wrote:
> > > Convert the marvell,pp2 bindings from text to proper schema.
> > >
> > > Move 'marvell,system-controller' and 'dma-coherent' properties from
> > > port up to the controller node, to match what is actually done in DT.
> >
> > You need to also mention other changes done during conversion -
> > requiring subnodes to be named "(ethernet-)?ports", deprecating port-id=
.
> >
> > >
> > > Signed-off-by: Micha=C5=82 Grzelak <mig@semihalf.com>
> > > ---
> > >  .../devicetree/bindings/net/marvell,pp2.yaml  | 286 ++++++++++++++++=
++
> > >  .../devicetree/bindings/net/marvell-pp2.txt   | 141 ---------
> > >  MAINTAINERS                                   |   2 +-
> > >  3 files changed, 287 insertions(+), 142 deletions(-)
> > >  create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2=
.yaml
> > >  delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2=
.txt
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b=
/Documentation/devicetree/bindings/net/marvell,pp2.yaml
> > > new file mode 100644
> > > index 000000000000..24c6aeb46814
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
> > > @@ -0,0 +1,286 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/marvell,pp2.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Marvell CN913X / Marvell Armada 375, 7K, 8K Ethernet Controll=
er
> > > +
> > > +maintainers:
> > > +  - Marcin Wojtas <mw@semihalf.com>
> > > +  - Russell King <linux@armlinux.org>
> > > +
> > > +description: |
> > > +  Marvell Armada 375 Ethernet Controller (PPv2.1)
> > > +  Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
> > > +  Marvell CN913X Ethernet Controller (PPv2.3)
> > > +
> > > +properties:
> > > +  compatible:
> > > +    enum:
> > > +      - marvell,armada-375-pp2
> > > +      - marvell,armada-7k-pp22
> > > +
> > > +  reg:
> > > +    minItems: 3
> > > +    maxItems: 4
> > > +
> > > +  "#address-cells":
> > > +    const: 1
> > > +
> > > +  "#size-cells":
> > > +    const: 0
> > > +
> > > +  clocks:
> > > +    minItems: 2
> > > +    items:
> > > +      - description: main controller clock
> > > +      - description: GOP clock
> > > +      - description: MG clock
> > > +      - description: MG Core clock
> > > +      - description: AXI clock
> > > +
> > > +  clock-names:
> > > +    minItems: 2
> > > +    items:
> > > +      - const: pp_clk
> > > +      - const: gop_clk
> > > +      - const: mg_clk
> > > +      - const: mg_core_clk
> > > +      - const: axi_clk
> > > +
> > > +  dma-coherent: true
> > > +
> > > +  marvell,system-controller:
> > > +    $ref: /schemas/types.yaml#/definitions/phandle
> > > +    description: a phandle to the system controller.
> > > +
> > > +patternProperties:
> > > +  '^(ethernet-)?port@[0-9]+$':
> > > +    type: object
> > > +    description: subnode for each ethernet port.
> > > +
> > > +    properties:
> > > +      interrupts:
> > > +        minItems: 1
> > > +        maxItems: 10
> > > +        description: interrupt(s) for the port
> > > +
> > > +      interrupt-names:
> > > +        minItems: 1
> > > +        items:
> > > +          - const: hif0
> > > +          - const: hif1
> > > +          - const: hif2
> > > +          - const: hif3
> > > +          - const: hif4
> > > +          - const: hif5
> > > +          - const: hif6
> > > +          - const: hif7
> > > +          - const: hif8
> > > +          - const: link
> > > +
> > > +        description: >
> > > +          if more than a single interrupt for is given, must be the
> > > +          name associated to the interrupts listed. Valid names are:
> > > +          "hifX", with X in [0..8], and "link". The names "tx-cpu0",
> > > +          "tx-cpu1", "tx-cpu2", "tx-cpu3" and "rx-shared" are suppor=
ted
> > > +          for backward compatibility but shouldn't be used for new
> > > +          additions.
> > > +
> > > +      reg:
> > > +        description: ID of the port from the MAC point of view.
> > > +
> > > +      port-id:
> > > +        $ref: /schemas/types.yaml#/definitions/uint32
> >
> >         deprecated: true
> >
> > > +        description: >
> > > +          ID of the port from the MAC point of view.
> > > +          Legacy binding for backward compatibility.
> > > +
> > > +      phy:
> > > +        $ref: /schemas/types.yaml#/definitions/phandle
> > > +        description: >
> > > +          a phandle to a phy node defining the PHY address
> > > +          (as the reg property, a single integer).
> > > +
> > > +      phy-mode:
> > > +        $ref: ethernet-controller.yaml#/properties/phy-mode
> > > +
> > > +      marvell,loopback:
> > > +        $ref: /schemas/types.yaml#/definitions/flag
> > > +        description: port is loopback mode.
> > > +
> > > +      gop-port-id:
> > > +        $ref: /schemas/types.yaml#/definitions/uint32
> > > +        description: >
> > > +          only for marvell,armada-7k-pp22, ID of the port from the
> > > +          GOP (Group Of Ports) point of view. This ID is used to ind=
ex the
> > > +          per-port registers in the second register area.
> > > +
> > > +    required:
> > > +      - interrupts
> > > +      - port-id
> > > +      - phy-mode
> > > +      - reg
> >
> > Keep the same order of items here as in list of properties
> >
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - clocks
> > > +  - clock-names
> > > +
> > > +allOf:
> > > +  - $ref: ethernet-controller.yaml#
> >
> > Hmm, are you sure this applies to top-level properties, not to
> > ethernet-port subnodes? Your ports have phy-mode and phy - just like
> > ethernet-controller. If I understand correctly, your Armada Ethernet
> > Controller actually consists of multiple ethernet controllers?
> >
>
> PP2 is a single controller with common HW blocks, such as queue/buffer
> management, parser/classifier, register space, and more. It controls
> up to 3 MAC's (ports) that can be connected to phys, sfp cages, etc.
> The latter cannot exist on their own and IMO the current hierarchy -
> the main controller with subnodes (ports) properly reflects the
> hardware.
>
> Anyway, the ethernet-controller.yaml properties fit to the subnodes.
> Apart from the name. The below is IMO a good description:.
>
> > If so, this should be moved to proper place inside patternProperties.
> > Maybe the subnodes should also be renamed from ports to just "ethernet"
> > (as ethernet-controller.yaml expects), but other schemas do not follow
> > this convention,
>
> ethernet@
> {
>     ethernet-port@0
>     {
>      }
>      ethernet-port@1
>      {
>      }
> }
>
> What do you recommend?
>

I moved the ethernet-controller.yaml reference to under the subnode
(this allowed me to remove phy and phy-mode description)) and it
doesn't complain about the node naming. Please let me know if below
would be acceptable.

--- a/Documentation/devicetree/bindings/net/marvell,pp2.yaml
+++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
@@ -61,7 +61,11 @@ patternProperties:
     type: object
     description: subnode for each ethernet port.

+    allOf:
+      - $ref: ethernet-controller.yaml#
+
     properties:
       interrupts:
         minItems: 1
         maxItems: 10
@@ -95,19 +99,11 @@ patternProperties:

       port-id:
         $ref: /schemas/types.yaml#/definitions/uint32
+        deprecated: true
         description: >
           ID of the port from the MAC point of view.
           Legacy binding for backward compatibility.

-      phy:
-        $ref: /schemas/types.yaml#/definitions/phandle
-        description: >
-          a phandle to a phy node defining the PHY address
-          (as the reg property, a single integer).
-
-      phy-mode:
-        $ref: ethernet-controller.yaml#/properties/phy-mode
-
       marvell,loopback:
         $ref: /schemas/types.yaml#/definitions/flag
         description: port is loopback mode.
@@ -132,7 +128,6 @@ required:
   - clock-names

 allOf:
-  - $ref: ethernet-controller.yaml#
   - if:

Best regards,
Marcin
