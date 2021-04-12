Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA1035D064
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245015AbhDLSau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:30:50 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:39788 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhDLSat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 14:30:49 -0400
Received: by mail-oi1-f174.google.com with SMTP id i81so14385495oif.6;
        Mon, 12 Apr 2021 11:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XUIi24mfZ9zrTsnjidCiRnOi8xgWfCPFT4wP7iFXs4I=;
        b=T6RcEO9Jr4RFv79hJzy6NKjuEhhWtuMFqUtlVGwUyxkzrgzgvv9s4v8dtEhScvNltD
         OXAO4YVTyi9UJOqXLHIHRk5FqoqThrrMonqMCwTh3p/4XAnJfG4KGItt4KeW20B2jr50
         W8rfgGicjuewLOmwUXiv3uxFvl3ekZd+mdNlHyxQhnWVeNF1IRRXbxA3FvT3PesFhJR0
         m5u+t57OmQXlEy8YaJs24i/stTWOEaHeLE8Oj394x8MmQlvQVjZtBNuOTF292cOvNr9w
         1s2v0B3ZB7KMgo0sErOKJO3zU3/lBWdo2QUEy0LMOoVoUrYN459o1Hc1Q97Bnk1mQXYQ
         qinw==
X-Gm-Message-State: AOAM533+C6nPuZgUIy3pU6nc2YQxbBVv8mTRAiiMrWUXMH/O9pmo1o9b
        trSO1Hw7Fctsmu5mgguEcw==
X-Google-Smtp-Source: ABdhPJztkh70A28YskkvtcR4u+o8/q4mU+at3zA1n/AAUaJY2Qz6rFozKuuwsrkhSsHzKvin1eK5og==
X-Received: by 2002:a05:6808:1150:: with SMTP id u16mr400123oiu.74.1618252229678;
        Mon, 12 Apr 2021 11:30:29 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h28sm289443oof.47.2021.04.12.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 11:30:29 -0700 (PDT)
Received: (nullmailer pid 4162519 invoked by uid 1000);
        Mon, 12 Apr 2021 18:30:28 -0000
Date:   Mon, 12 Apr 2021 13:30:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        vkoul@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com
Subject: Re: [RFC PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce
 dmaengine binding support
Message-ID: <20210412183028.GA4156095@robh.at.kernel.org>
References: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <1617992002-38028-3-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617992002-38028-3-git-send-email-radhey.shyam.pandey@xilinx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 11:43:21PM +0530, Radhey Shyam Pandey wrote:
> The axiethernet driver will now use dmaengine framework to communicate
> with dma controller IP instead of built-in dma programming sequence.
> 
> To request dma transmit and receive channels the axiethernet driver uses
> generic dmas, dma-names properties. It deprecates axistream-connected

Huh, you just added the property and now deprecating?

> property, remove axidma reg and interrupt properties from the ethernet
> node. Just to highlight that these DT changes are not backward compatible
> due to major driver restructuring/cleanup done in adopting the dmaengine
> framework.

Aren't users going to care this isn't a backwards compatible change?

> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>  .../devicetree/bindings/net/xilinx_axienet.yaml    | 40 +++++++++++++---------
>  1 file changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.yaml b/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
> index 6a00e03e8804..0ea3972fefef 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
> @@ -14,10 +14,8 @@ description: |
>    offloading TX/RX checksum calculation off the processor.
>  
>    Management configuration is done through the AXI interface, while payload is
> -  sent and received through means of an AXI DMA controller. This driver
> -  includes the DMA driver code, so this driver is incompatible with AXI DMA
> -  driver.
> -
> +  sent and received through means of an AXI DMA controller using dmaengine
> +  framework.
>  
>  allOf:
>    - $ref: "ethernet-controller.yaml#"
> @@ -36,19 +34,13 @@ properties:
>  
>    reg:
>      description:
> -      Address and length of the IO space, as well as the address
> -      and length of the AXI DMA controller IO space, unless
> -      axistream-connected is specified, in which case the reg
> -      attribute of the node referenced by it is used.
> -    maxItems: 2
> +      Address and length of the IO space.
> +    maxItems: 1
>  
>    interrupts:
>      description:
> -      Can point to at most 3 interrupts. TX DMA, RX DMA, and optionally Ethernet
> -      core. If axistream-connected is specified, the TX/RX DMA interrupts should
> -      be on that node instead, and only the Ethernet core interrupt is optionally
> -      specified here.
> -    maxItems: 3
> +      Ethernet core interrupt.
> +    maxItems: 1
>  
>    phy-handle: true
>  
> @@ -109,15 +101,29 @@ properties:
>        for the AXI DMA controller used by this device. If this is specified,
>        the DMA-related resources from that device (DMA registers and DMA
>        TX/RX interrupts) rather than this one will be used.
> +    deprecated: true
>  
>    mdio: true
>  
> +  dmas:
> +    items:
> +      - description: TX DMA Channel phandle and DMA request line number
> +      - description: RX DMA Channel phandle and DMA request line number
> +
> +  dma-names:
> +    items:
> +      - const: tx_chan0
> +      - const: rx_chan0
> +
> +
>  required:
>    - compatible
>    - reg
>    - interrupts
>    - xlnx,rxmem
>    - phy-handle
> +  - dmas
> +  - dma-names
>  
>  additionalProperties: false
>  
> @@ -127,11 +133,13 @@ examples:
>        compatible = "xlnx,axi-ethernet-1.00.a";
>        device_type = "network";
>        interrupt-parent = <&microblaze_0_axi_intc>;
> -      interrupts = <2>, <0>, <1>;
> +      interrupts = <1>;
>        clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
>        clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
>        phy-mode = "mii";
> -      reg = <0x40c00000 0x40000>,<0x50c00000 0x40000>;
> +      reg = <0x40c00000 0x40000>;
> +      dmas = <&xilinx_dma 0>, <&xilinx_dma 1>;
> +      dma-names = "tx_chan0", "rx_chan0";

Is there a chan1? Typical dma-names are just 'tx' and 'rx'.

>        xlnx,rxcsum = <0x2>;
>        xlnx,rxmem = <0x800>;
>        xlnx,txcsum = <0x2>;
> -- 
> 2.7.4
> 
