Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6500D2DB277
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgLORXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:23:43 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41783 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729671AbgLORXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:23:24 -0500
Received: by mail-ot1-f66.google.com with SMTP id x13so20151969oto.8;
        Tue, 15 Dec 2020 09:23:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TPedXdl2PY6JHGKX0f/qlnbwmUVBy3y2nBUN43lCo10=;
        b=nJNCWAlWyr4xD4AjsDCNw30CGHyNZlFvZFyZKWqt/Xzglp9lpC1vW7u2Jize6+bdbc
         DnXplec11VZaP5Xg8YQMcP+pgkLPQlOh7lFDiG6UOTfwayI2uEHBtnfBj24HvOPRAndb
         /cIcFlpfod6sWORwYNoL35km+mQDn0ZplJSz1VqOiB7ssOWUuqu5C+U1rI8DKaq5cJ2r
         vbV9J/a9xrnhBu8FOrWVrTr5RILDuCoWo0D8x3UcECouLPxyoaGhDu2ySeqVnQ14p+15
         q0AX0r3lD+35LYjeH2oVaUyQvNoHKZXpUauVBOYEx0FtDha4OpgNOJWITd3eCUDe8ccI
         IjRw==
X-Gm-Message-State: AOAM531TcOi/f4awTr/fq9GCqr1H/9RzLiv3GmVlpbBULSMSVKNUwFPH
        9y3AzPH02Kk4VVhx54tUmw==
X-Google-Smtp-Source: ABdhPJzYe/1d+PtO64iiDzUljskow3Y88N+EV3ueO8nk0GUixOHeB/tzaf6tSb2hz8UTo5IMx0i3NA==
X-Received: by 2002:a05:6830:159a:: with SMTP id i26mr23203338otr.315.1608052962799;
        Tue, 15 Dec 2020 09:22:42 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l132sm5125659oia.23.2020.12.15.09.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 09:22:42 -0800 (PST)
Received: (nullmailer pid 4059538 invoked by uid 1000);
        Tue, 15 Dec 2020 17:22:40 -0000
Date:   Tue, 15 Dec 2020 11:22:40 -0600
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
Subject: Re: [PATCH 03/25] dt-bindings: net: dwmac: Fix the TSO property
 declaration
Message-ID: <20201215172240.GA4047815@robh.at.kernel.org>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
 <20201214091616.13545-4-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214091616.13545-4-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:15:53PM +0300, Serge Semin wrote:
> Indeed the STMMAC driver doesn't take the vendor-specific compatible
> string into account to parse the "snps,tso" boolean property. It just
> makes sure the node is compatible with DW MAC 4.x, 5.x and DW xGMAC
> IP-cores. Fix the conditional statement so the TSO-property would be
> evaluated for the compatibles having the corresponding IP-core version.
> 
> While at it move the whole allOf-block from the tail of the binding file
> to the head of it, as it's normally done in the most of the DT schemas.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> 
> ---
> 
> Note this won't break the bindings description, since the "snps,tso"
> property isn't parsed by the Allwinner SunX GMAC glue driver, but only
> by the generic platform DT-parser.

But still should be valid for Allwinner?

> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 52 +++++++++----------
>  1 file changed, 24 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e084fbbf976e..0dd543c6c08e 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -37,6 +37,30 @@ select:
>    required:
>      - compatible
>  
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - snps,dwmac-4.00
> +              - snps,dwmac-4.10a
> +              - snps,dwmac-4.20a
> +              - snps,dwmac-5.10a
> +              - snps,dwxgmac
> +              - snps,dwxgmac-2.10
> +
> +      required:
> +        - compatible
> +    then:
> +      properties:
> +        snps,tso:
> +          $ref: /schemas/types.yaml#definitions/flag
> +          description:
> +            Enables the TSO feature otherwise it will be managed by
> +            MAC HW capability register.

BTW, I prefer that properties are defined unconditionally, and then 
restricted in conditional schemas (or ones that include this schema).

> +
>  properties:
>  
>    # We need to include all the compatibles from schemas that will
> @@ -314,34 +338,6 @@ dependencies:
>    snps,reset-active-low: ["snps,reset-gpio"]
>    snps,reset-delay-us: ["snps,reset-gpio"]
>  
> -allOf:
> -  - $ref: "ethernet-controller.yaml#"
> -  - if:
> -      properties:
> -        compatible:
> -          contains:
> -            enum:
> -              - allwinner,sun7i-a20-gmac

This does not have a fallback, so snps,tso is no longer validated. I 
didn't check the rest.

> -              - allwinner,sun8i-a83t-emac
> -              - allwinner,sun8i-h3-emac
> -              - allwinner,sun8i-r40-emac
> -              - allwinner,sun8i-v3s-emac
> -              - allwinner,sun50i-a64-emac
> -              - snps,dwmac-4.00
> -              - snps,dwmac-4.10a
> -              - snps,dwmac-4.20a
> -              - snps,dwxgmac
> -              - snps,dwxgmac-2.10
> -              - st,spear600-gmac
> -
> -    then:
> -      properties:
> -        snps,tso:
> -          $ref: /schemas/types.yaml#definitions/flag
> -          description:
> -            Enables the TSO feature otherwise it will be managed by
> -            MAC HW capability register.
> -
>  additionalProperties: true
>  
>  examples:
> -- 
> 2.29.2
> 
