Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00501E8726
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgE2TEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:04:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:32888 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgE2TD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:03:59 -0400
Received: by mail-io1-f66.google.com with SMTP id k18so525692ion.0;
        Fri, 29 May 2020 12:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l2RZz+6GuxvNjpeyZJkWBZVVO4iGwz6tayj5VLgfgkc=;
        b=AqjnYwwioMG5/MW4ABOBzh6Cb6lBmtD2X6AD6py+rutG6hjbMjIFERRGkfl3FJgiTs
         kfdQrbJVKAI/1C5iW9VSkVyDDO2zDPjEl44Pk2xDuAcGhadA+3TNAg5X7gU2wX85INRR
         CUiXHFq9tauFB1G1ttKmE0qEsaq/N5LGzGnpls/ALKa0uZc3N3kcLkjJGb+4d4ThVQBR
         r3sNWrAo604ipDjJ04OO0C9sxpORF6pZXitlaOg8ua/tF/wO0O1CAGdS6L6gmKr+MP+1
         gyEyRaftJflMSEimzsKzqBLiM7qeLgrY0jiCUslIDOF3d95tdptRmap+3AtOaOM01AXX
         OKtQ==
X-Gm-Message-State: AOAM533ZO45h+mdM3Z6FZVT6bQQhnnntiCVa8EMQFS/xigViwFcWa+gx
        +KApInTB8HmmLEevObzZWQ==
X-Google-Smtp-Source: ABdhPJynGVuna3BmTmeIk8V4t9AUMe7nA4T9Yip/KLyNpLizPAvXuuYAwJAxSTUTz4tbKORQVK+8+A==
X-Received: by 2002:a02:908b:: with SMTP id x11mr8217368jaf.41.1590779038686;
        Fri, 29 May 2020 12:03:58 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id n25sm4137090ioa.29.2020.05.29.12.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 12:03:57 -0700 (PDT)
Received: (nullmailer pid 2762082 invoked by uid 1000);
        Fri, 29 May 2020 19:03:56 -0000
Date:   Fri, 29 May 2020 13:03:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
Message-ID: <20200529190356.GA2758033@bogus>
References: <20200527164934.28651-1-dmurphy@ti.com>
 <20200527164934.28651-4-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527164934.28651-4-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 11:49:33AM -0500, Dan Murphy wrote:
> Add the internal delay values into the header and update the binding
> with the internal delay properties.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83869.yaml      | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> index 5b69ef03bbf7..2971dd3fc039 100644
> --- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> @@ -64,6 +64,20 @@ properties:
>         Operational mode for the PHY.  If this is not set then the operational
>         mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
>  
> +  rx-internal-delay-ps:
> +    $ref: "#/properties/rx-internal-delay-ps"

This just creates a circular reference which probably blows up.

> +    description: Delay is in pico seconds
> +    enum: [ 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000,
> +            3250, 3500, 3750, 4000 ]
> +    default: 2000
> +
> +  tx-internal-delay-ps:
> +    $ref: "#/properties/tx-internal-delay-ps"
> +    description: Delay is in pico seconds
> +    enum: [ 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000,
> +            3250, 3500, 3750, 4000 ]
> +    default: 2000
> +
>  required:
>    - reg
>  
> @@ -80,5 +94,7 @@ examples:
>          ti,op-mode = <DP83869_RGMII_COPPER_ETHERNET>;
>          ti,max-output-impedance = "true";
>          ti,clk-output-sel = <DP83869_CLK_O_SEL_CHN_A_RCLK>;
> +        rx-internal-delay-ps = <2000>;
> +        tx-internal-delay-ps = <2000>;
>        };
>      };
> -- 
> 2.26.2
> 
