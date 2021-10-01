Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754F841F36B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353560AbhJARol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355429AbhJARoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:44:30 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CF1C0613E5
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:42:46 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id q17-20020a7bce91000000b0030d4e298215so1518679wmj.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6EIACl5M4v5UwJrM1j1H8fCICeUUt7tDN7R9RKi7N6Q=;
        b=FXDaEEBL1WWge9xvDgFWP9qi9X2Qoe2qF7bpn4pAm00gFspAVlmC/X5UNtvF/6lAO5
         IxQgF9Pp+V+Mt+9lsScURRgAJSJ1kHgpP4qwKlj4zhjqyCE0bgY8apSDthhw+MJzuazf
         kt9n0+dWsJXcvQMB5nUOXf3qXpUNGMAern7nu+PYBaqo3Kev8FkuBLtx10+EOz35nm3F
         GOPzj7bzd0j/k6LJvmB0F+9wT5AHgbI5macBJqRR6lB84FNGCpVB5gQCN5Cpndwo2BHO
         FNVk31Ja6yyq+iiXZ5cnxkXY7G5oNg8k9afrzVF9kgNyaX4eEyWSwqK6f329I3HSCcss
         Oa0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6EIACl5M4v5UwJrM1j1H8fCICeUUt7tDN7R9RKi7N6Q=;
        b=c8aAcTVwmLbl2uGrimzFvDe3k4zl+ZQVpQr8CqIAukHHaH2BZ1r4r4Awnv5Elf+KPH
         /s2nmJzxNwGtGkWkBCFwa4fcvpz8Df8cu20y6w8XaBG/FEIvUjVTa1Lzp+CH4Z49NLZK
         ghYyTi2hs1rBaP5R020TLv2Mtuukg51cV91fFnalcI6rBZuovgHUEq/16Jr9fMUXxhjI
         oSivK154Mj5VSYYID96Y226JDmi4dgyhscerVea0Ue6MHZg3b1n3/oKVUcq/UBFMn/Ip
         EaSx2FhowBR6TNr6W7CueQJC6HfOfuOQK13fjhCeGbGGkal7ODYH/R6PUU0e/e5c/ny2
         Tf2Q==
X-Gm-Message-State: AOAM531vAhDFF4ASd0nEFGiML2P6HCz/PuNpgh5QnA9irK/OB4YfvVAU
        TzGGafr4oSpsKlfhL9EIIoa0wQ==
X-Google-Smtp-Source: ABdhPJyxMdiI8yKOS50Ns7vPDrKY2HGuQAFgmN7gLZqYJoDsBNxOtviiKuECjY2gh9CRlL6KDTclvQ==
X-Received: by 2002:a05:600c:a08:: with SMTP id z8mr5929463wmp.165.1633110164624;
        Fri, 01 Oct 2021 10:42:44 -0700 (PDT)
Received: from localhost (p54ac5892.dip0.t-ipconnect.de. [84.172.88.146])
        by smtp.gmail.com with ESMTPSA id t126sm7973920wma.4.2021.10.01.10.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:42:43 -0700 (PDT)
Date:   Fri, 1 Oct 2021 19:42:43 +0200
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: renesas,ether: Update example to match
 reality
Message-ID: <YVdIk0fme05AyUeU@bismarck.dyn.berto.se>
References: <a1cf8a6ccca511e948075c4e20eea2e2ba001c2c.1633090323.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1cf8a6ccca511e948075c4e20eea2e2ba001c2c.1633090323.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thanks for your patch.

On 2021-10-01 14:13:20 +0200, Geert Uytterhoeven wrote:
>   - Drop unneeded interrupt-parent,
>   - Convert to new style CPG/MSSR bindings,
>   - Add missing power-domains and resets properties,
>   - Update PHY subnode:
>       - Add example compatible values,
>       - Add micrel,led-mode and reset-gpios examples.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  .../devicetree/bindings/net/renesas,ether.yaml  | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
> index c101a1ec846ea8e9..06b38c9bc6ec38e4 100644
> --- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
> +++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
> @@ -100,15 +100,18 @@ additionalProperties: false
>  examples:
>    # Lager board
>    - |
> -    #include <dt-bindings/clock/r8a7790-clock.h>
> -    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/clock/r8a7790-cpg-mssr.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/power/r8a7790-sysc.h>
> +    #include <dt-bindings/gpio/gpio.h>
>  
>      ethernet@ee700000 {
>          compatible = "renesas,ether-r8a7790", "renesas,rcar-gen2-ether";
>          reg = <0xee700000 0x400>;
> -        interrupt-parent = <&gic>;
> -        interrupts = <0 162 IRQ_TYPE_LEVEL_HIGH>;
> -        clocks = <&mstp8_clks R8A7790_CLK_ETHER>;
> +        interrupts = <GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>;
> +        clocks = <&cpg CPG_MOD 813>;
> +        power-domains = <&sysc R8A7790_PD_ALWAYS_ON>;
> +        resets = <&cpg 813>;
>          phy-mode = "rmii";
>          phy-handle = <&phy1>;
>          renesas,ether-link-active-low;
> @@ -116,8 +119,12 @@ examples:
>          #size-cells = <0>;
>  
>          phy1: ethernet-phy@1 {
> +            compatible = "ethernet-phy-id0022.1537",
> +                         "ethernet-phy-ieee802.3-c22";
>              reg = <1>;
>              interrupt-parent = <&irqc0>;
>              interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> +            micrel,led-mode = <1>;
> +            reset-gpios = <&gpio5 31 GPIO_ACTIVE_LOW>;
>          };
>      };
> -- 
> 2.25.1
> 

-- 
Regards,
Niklas Söderlund
