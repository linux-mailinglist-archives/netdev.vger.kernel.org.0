Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BEA3159BA
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbhBIWxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:53:05 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:41925 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbhBIW20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:28:26 -0500
Received: by mail-ot1-f44.google.com with SMTP id s107so18990644otb.8;
        Tue, 09 Feb 2021 14:28:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CpHUG6zmw18TNWXb6G+ZZ+TkFily+o9vxR1Gsb1g40M=;
        b=KIp2ikDZ+6o3PwSRZ8sGlvi96B4KazEDaTkXA34xRYp6hH4/l6263gqu65++AzKdI6
         Yytmx9yxdv4i6qFhKyvZbi9VCkR9DRCEoobGd7is2h4lf0sGTzlgGGSAUzvB3vr7d+xD
         ogFNXf4td+cehtxn8gw0FsP4ZM+3k3NwH6Wz3uNnWIUNKhbfZqCJ6Efxn++97xcs/z0x
         rHydIO9HZg0KxjaUXcRnMjM3wsi4VQfFtlKmyTVJtULRpqCKgG2U6zEhOcmInURNGOAt
         oa22qQtWqKUjVY5vrnWP1d3+yYMtgNhVlXnEsxxJcpK37gPwuC0sVKAmrzfbJAMZlj8D
         4Riw==
X-Gm-Message-State: AOAM533A0ZtM/OP7pBHLiDooq7nTPqE/QuGZvq3/yYu0kh/PcFfXrzJZ
        +qu8B5g9FSzd9fn3ubjWMg==
X-Google-Smtp-Source: ABdhPJzr2vknJRylFG+vJrIeAIlQaCsPUqumwuuZSexwlH+7rHvqFVgBEECiYUuNWu9rdahsJqXIfw==
X-Received: by 2002:a05:6830:4110:: with SMTP id w16mr17667575ott.102.1612909572989;
        Tue, 09 Feb 2021 14:26:12 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t14sm17724oif.30.2021.02.09.14.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 14:26:10 -0800 (PST)
Received: (nullmailer pid 324900 invoked by uid 1000);
        Tue, 09 Feb 2021 22:26:08 -0000
Date:   Tue, 9 Feb 2021 16:26:08 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/24] dt-bindings: net: dwmac: Refactor snps,*-config
 properties
Message-ID: <20210209222608.GA269004@robh.at.kernel.org>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
 <20210208135609.7685-5-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208135609.7685-5-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 04:55:48PM +0300, Serge Semin wrote:
> Currently the "snps,axi-config", "snps,mtl-rx-config" and
> "snps,mtl-tx-config" properties are declared as a single phandle reference
> to a node with corresponding parameters defined. That's not good for
> several reasons. First of all scattering around a device tree some
> particular device-specific configs with no visual relation to that device
> isn't suitable from maintainability point of view. That leads to a
> disturbed representation of the actual device tree mixing actual device
> nodes and some vendor-specific configs. Secondly using the same configs
> set for several device nodes doesn't represent well the devices structure,
> since the interfaces these configs describe in hardware belong to
> different devices and may actually differ. In the later case having the
> configs node separated from the corresponding device nodes gets to be
> even unjustified.
> 
> So instead of having a separate DW *MAC configs nodes we suggest to
> define them as sub-nodes of the device nodes, which interfaces they
> actually describe. By doing so we'll make the DW *MAC nodes visually
> correct describing all the aspects of the IP-core configuration. Thus
> we'll be able to describe the configs sub-nodes bindings right in the
> snps,dwmac.yaml file.
> 
> Note the former "snps,axi-config", "snps,mtl-rx-config" and
> "snps,mtl-tx-config" properties have been marked as deprecated in favor of
> the added by this commit "axi-config", "mtl-rx-config" and "mtl-tx-config"
> sub-nodes respectively.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> 
> ---
> 
> Note this change will work only if DT-schema tool is fixed like this:
> 
> --- a/meta-schemas/nodes.yaml	2021-02-08 14:20:56.732447780 +0300
> +++ b/meta-schemas/nodes.yaml	2021-02-08 14:21:00.736492245 +0300
> @@ -22,6 +22,7 @@
>      - unevaluatedProperties
>      - deprecated
>      - required
> +    - not
>      - allOf
>      - anyOf
>      - oneOf

Can you send me a patch or GH PR. There is another way to express. More 
below.

> 
> So a property with name "not" would be allowed and the "not-required"
> pattern would work.
> 
> Changelog v2:
> - Add the new sub-nodes "axi-config", "mtl-rx-config" and "mtl-tx-config"
>   describing the nodes now deprecated properties were supposed to
>   refer to.
> - Fix invalid identation in the "snps,route-*" property settings.
> - Use correct syntax of the JSON pointers, so the later would begin
>   with a '/' after the '#'.
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 389 +++++++++++++-----
>  1 file changed, 297 insertions(+), 92 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 03d58bf9965f..4dda9ffa822c 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -150,73 +150,264 @@ properties:
>        in a different mode than the PHY in order to function.
>  
>    snps,axi-config:
> +    deprecated: true
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description:
> -      AXI BUS Mode parameters. Phandle to a node that can contain the
> -      following properties
> -        * snps,lpi_en, enable Low Power Interface
> -        * snps,xit_frm, unlock on WoL
> -        * snps,wr_osr_lmt, max write outstanding req. limit
> -        * snps,rd_osr_lmt, max read outstanding req. limit
> -        * snps,kbbe, do not cross 1KiB boundary.
> -        * snps,blen, this is a vector of supported burst length.
> -        * snps,fb, fixed-burst
> -        * snps,mb, mixed-burst
> -        * snps,rb, rebuild INCRx Burst
> +      AXI BUS Mode parameters. Phandle to a node that contains the properties
> +      described in the 'axi-config' sub-node.
> +
> +  axi-config:
> +    type: object
> +    description: AXI BUS Mode parameters
> +
> +    properties:
> +      snps,lpi_en:
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: Enable Low Power Interface
> +
> +      snps,xit_frm:
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: Unlock on WoL
> +
> +      snps,wr_osr_lmt:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: Max write outstanding req. limit
> +        default: 1
> +        minimum: 0
> +        maximum: 15
> +
> +      snps,rd_osr_lmt:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: Max read outstanding req. limit
> +        default: 1
> +        minimum: 0
> +        maximum: 15
> +
> +      snps,kbbe:
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: Do not cross 1KiB boundary
> +
> +      snps,blen:
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
> +        description: A vector of supported burst lengths
> +        minItems: 7
> +        maxItems: 7
> +        items:
> +          enum: [256, 128, 64, 32, 16, 8, 4, 0]
> +
> +      snps,fb:
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: Fixed-burst
> +
> +      snps,mb:
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: Mixed-burst
> +
> +      snps,rb:
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: Rebuild INCRx Burst
> +
> +    additionalProperties: false
>  
>    snps,mtl-rx-config:

You could keep these pointing to child nodes to avoid driver changes.

> +    deprecated: true
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description:
> -      Multiple RX Queues parameters. Phandle to a node that can
> -      contain the following properties
> -        * snps,rx-queues-to-use, number of RX queues to be used in the
> -          driver
> -        * Choose one of these RX scheduling algorithms
> -          * snps,rx-sched-sp, Strict priority
> -          * snps,rx-sched-wsp, Weighted Strict priority
> -        * For each RX queue
> -          * Choose one of these modes
> -            * snps,dcb-algorithm, Queue to be enabled as DCB
> -            * snps,avb-algorithm, Queue to be enabled as AVB
> -          * snps,map-to-dma-channel, Channel to map
> -          * Specifiy specific packet routing
> -            * snps,route-avcp, AV Untagged Control packets
> -            * snps,route-ptp, PTP Packets
> -            * snps,route-dcbcp, DCB Control Packets
> -            * snps,route-up, Untagged Packets
> -            * snps,route-multi-broad, Multicast & Broadcast Packets
> -          * snps,priority, bitmask of the tagged frames priorities assigned to
> -            the queue
> +      Multiple RX Queues parameters. Phandle to a node that contains the
> +      properties described in the 'mtl-rx-config' sub-node.
> +
> +  mtl-rx-config:
> +    type: object
> +    description: Multiple RX Queues parameters
> +
> +    properties:
> +      snps,rx-queues-to-use:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: Number of RX queues to be used in the driver
> +        default: 1
> +        minimum: 1
> +
> +    patternProperties:
> +      "^snps,rx-sched-(sp|wsp)$":
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: Strict/Weighted Strict RX scheduling priority
> +
> +      "^queue[0-9]$":
> +        type: object
> +        description: Each RX Queue parameters
> +
> +        properties:
> +          snps,map-to-dma-channel:
> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            description: DMA channel to map
> +
> +          snps,priority:
> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            description: RX queue priority
> +            minimum: 0
> +            maximum: 15
> +
> +        patternProperties:
> +          "^snps,(dcb|avb)-algorithm$":
> +            $ref: /schemas/types.yaml#/definitions/flag
> +            description: Enable Queue as DCB/AVB
> +
> +          "^snps,route-(avcp|ptp|dcbcp|up|multi-broad)$":
> +            $ref: /schemas/types.yaml#/definitions/flag
> +            description:
> +              AV Untagged/PTP/DCB Control/Untagged/Multicast & Broadcast
> +              packets routing respectively.
> +
> +        additionalProperties: false
> +
> +        # Choose only one of the Queue modes and the packets routing
> +        allOf:
> +          - not:
> +              required:
> +                - snps,dcb-algorithm
> +                - snps,avb-algorithm
> +          - oneOf:
> +              - required:
> +                  - snps,route-avcp
> +              - required:
> +                  - snps,route-ptp
> +              - required:
> +                  - snps,route-dcbcp
> +              - required:
> +                  - snps,route-up
> +              - required:
> +                  - snps,route-multi-broad
> +              - not:
> +                  anyOf:
> +                    - required:
> +                        - snps,route-avcp
> +                    - required:
> +                        - snps,route-ptp
> +                    - required:
> +                        - snps,route-dcbcp
> +                    - required:
> +                        - snps,route-up
> +                    - required:
> +                        - snps,route-multi-broad

This 'not: ..." could be:

properties:
  snps,route-avcp: false
  snps,route-ptp: false
  snps,route-dcbcp: false
  snps,route-up: false
  snps,route-multi-broad: false

Not sure which one is better. Using required everywhere or more 
concise...

(Really, 'route' should have taken a value and the schema would be 
greatly simplified. Oh well.)

> +
> +    additionalProperties: false
> +
> +    # Choose one of the RX scheduling algorithms
> +    not:
> +      required:
> +        - snps,rx-sched-sp
> +        - snps,rx-sched-wsp

I guess this is the problematic one. The rest should be hidden behind 
conditionals (a common loophole in meta-schema checks). You could do 
that here:

allOf:
  - not:
      ...

But why not just make one of the 2 properties required? You're already 
changing things. 

Rob
