Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BCD347EE4
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhCXRKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:10:09 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:42619 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbhCXRIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:08:11 -0400
Received: by mail-io1-f54.google.com with SMTP id r193so22263914ior.9;
        Wed, 24 Mar 2021 10:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a8bjI7Bk9OnAORWR+J42MRi1jqglN8fzJASn6WCvgUg=;
        b=N+SaTllxxb2KiJS7tLYG9ilJKr4LGwsd3gKb5MoRAa6o72/fIpJdi+Lr2fXCLULS6b
         CiOMN8Oouc5AkjL1IsKsSUgiy10pA0XvZN37fBeDaVlQX63YAJEooN8ozoOnf/UT0/na
         6m6bu5AYdn4Um91c5ZZi6Ci7mi99KHGdzQb0DNCrS2GrR1QP2muHeOq2T4i4fDvKz1TP
         ADuPth4bpE6GcQchJokR9MDTkgzNT/jDg/n6mNE8/GjVAeIFMS1eJtZStUQofSzCy642
         CYN+mjeWICk8yPwj3fRbTGNu0uhG3h7VtgTwY1EgcG8ltnTbILCb2rLY67WOUfuV6HGZ
         g75g==
X-Gm-Message-State: AOAM531ZC5KnuT48s6W7FoZtD1LSBMic4lE3XsDP8obOCfkpKilBF7oK
        CtIzjzDF7ypuYUW1Ieuq7Q==
X-Google-Smtp-Source: ABdhPJwwBNBkugbGEvRLMhf4o5WxFOf66ehFG+f3jn6AAx5yDtPTy6lNYIvwZHtqB06/7R0je7ErzA==
X-Received: by 2002:a05:6602:17cd:: with SMTP id z13mr3298765iox.109.1616605690365;
        Wed, 24 Mar 2021 10:08:10 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id l17sm1426286ilt.27.2021.03.24.10.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 10:08:09 -0700 (PDT)
Received: (nullmailer pid 3257036 invoked by uid 1000);
        Wed, 24 Mar 2021 17:08:06 -0000
Date:   Wed, 24 Mar 2021 11:08:06 -0600
From:   Rob Herring <robh@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 v3 1/2] dt-bindings: net: xilinx_axienet:
 Document additional clocks
Message-ID: <20210324170806.GA3252450@robh.at.kernel.org>
References: <20210312195214.4002847-1-robert.hancock@calian.com>
 <20210312195214.4002847-2-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312195214.4002847-2-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 01:52:13PM -0600, Robert Hancock wrote:
> Update DT bindings to describe all of the clocks that the axienet
> driver will now be able to make use of.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  .../bindings/net/xilinx_axienet.txt           | 25 ++++++++++++++-----
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> index 2cd452419ed0..b8e4894bc634 100644
> --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> @@ -42,11 +42,23 @@ Optional properties:
>  		  support both 1000BaseX and SGMII modes. If set, the phy-mode
>  		  should be set to match the mode selected on core reset (i.e.
>  		  by the basex_or_sgmii core input line).
> -- clocks	: AXI bus clock for the device. Refer to common clock bindings.
> -		  Used to calculate MDIO clock divisor. If not specified, it is
> -		  auto-detected from the CPU clock (but only on platforms where
> -		  this is possible). New device trees should specify this - the
> -		  auto detection is only for backward compatibility.
> +- clock-names: 	  Tuple listing input clock names. Possible clocks:
> +		  s_axi_lite_clk: Clock for AXI register slave interface
> +		  axis_clk: AXI4-Stream clock for TXD RXD TXC and RXS interfaces
> +		  ref_clk: Ethernet reference clock, used by signal delay
> +			   primitives and transceivers
> +		  mgt_clk: MGT reference clock (used by optional internal
> +			   PCS/PMA PHY)

'_clk' is redundant.

> +
> +		  Note that if s_axi_lite_clk is not specified by name, the
> +		  first clock of any name is used for this. If that is also not
> +		  specified, the clock rate is auto-detected from the CPU clock
> +		  (but only on platforms where this is possible). New device
> +		  trees should specify all applicable clocks by name - the
> +		  fallbacks to an unnamed clock or to CPU clock are only for
> +		  backward compatibility.
> +- clocks: 	  Phandles to input clocks matching clock-names. Refer to common
> +		  clock bindings.
>  - axistream-connected: Reference to another node which contains the resources
>  		       for the AXI DMA controller used by this device.
>  		       If this is specified, the DMA-related resources from that
> @@ -62,7 +74,8 @@ Example:
>  		device_type = "network";
>  		interrupt-parent = <&microblaze_0_axi_intc>;
>  		interrupts = <2 0 1>;
> -		clocks = <&axi_clk>;
> +		clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
> +		clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
>  		phy-mode = "mii";
>  		reg = <0x40c00000 0x40000 0x50c00000 0x40000>;
>  		xlnx,rxcsum = <0x2>;
> -- 
> 2.27.0
> 
