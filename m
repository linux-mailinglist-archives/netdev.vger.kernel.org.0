Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BADE1E8694
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgE2SZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:25:48 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:43834 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgE2SZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:25:48 -0400
Received: by mail-il1-f193.google.com with SMTP id l20so3396072ilj.10;
        Fri, 29 May 2020 11:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RepKSadxVLPOnr4s22M6tXbcQ3t0H5ceA8/dUh0fqas=;
        b=iDHil1LddmmV7JALIuauqX0rUTY67E9pJ25vZ46IERa9FCpW21hODqfXIGGrOIgjuH
         fn6qlXAKLHezvozwHR/zztreOQI1julK5gEuPsDSYtXCf3LHKWeBb9WsYFEt1PBnNRUM
         skUip02m8m7HxomOURTP/O0pI9Tf83A/6TbhGzTkdwBVaOd4BsKS+eOfJm52/lzL8+KY
         mgwgez7zkcYxMlPnqUjPvB7gMXa3xenAgRjkB8q5q7cV/MlPIi4AS5C4OCo3cquGANJD
         7lVXyWaleKpcIIC1hGLHbNDjv5gpLT2y6hWXxHFGoycwjOa59FcK8YP0j8Iu5PGwdc25
         ReSg==
X-Gm-Message-State: AOAM533a6Tb+1U9Aa6OO/QntNLNi6q7nWla8AXMhRSHC/UtpzSG2wr7J
        /loutdIpwKU+PnJQYlFbl+M4wq6caA==
X-Google-Smtp-Source: ABdhPJzmQ2Je3XeGl2oNSzphQ0kirFYFeAGrBx5ngsUNmG4mc9hVYpv/dAR3ujj1Ciyrrncy7xuQlw==
X-Received: by 2002:a05:6e02:ea2:: with SMTP id u2mr8636655ilj.202.1590776747252;
        Fri, 29 May 2020 11:25:47 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id m5sm4029358ioj.52.2020.05.29.11.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 11:25:46 -0700 (PDT)
Received: (nullmailer pid 2702525 invoked by uid 1000);
        Fri, 29 May 2020 18:25:44 -0000
Date:   Fri, 29 May 2020 12:25:44 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/4] dt-bindings: net: Add tx and rx internal
 delays
Message-ID: <20200529182544.GA2691697@bogus>
References: <20200527164934.28651-1-dmurphy@ti.com>
 <20200527164934.28651-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527164934.28651-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 11:49:31AM -0500, Dan Murphy wrote:
> tx-internal-delays and rx-internal-delays are a common setting for RGMII
> capable devices.
> 
> These properties are used when the phy-mode or phy-controller is set to
> rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
> controller that the PHY will add the internal delay for the connection.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index ac471b60ed6a..70702a4ef5e8 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -143,6 +143,20 @@ properties:
>        Specifies the PHY management type. If auto is set and fixed-link
>        is not specified, it uses MDIO for management.
>  
> +  rx-internal-delay-ps:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
> +      PHY's that have configurable RX internal delays.  This property is only
> +      used when the phy-mode or phy-connection-type is rgmii-id or rgmii-rxid.

Isn't this a property of the phy (this is the controller schema)? Looks 
like we have similar properties already and they go in phy nodes. Would 
be good to have a standard property, but let's be clear where it goes.

We need to add '-ps' as a standard unit suffix (in dt-schema) and then a 
type is not needed here.

Rob
