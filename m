Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11B22D194A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgLGTSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:18:05 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36836 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgLGTSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:18:05 -0500
Received: by mail-ot1-f68.google.com with SMTP id y24so13580133otk.3;
        Mon, 07 Dec 2020 11:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fCRZf27KCzHad5WZLnZkBV55sQARhbTu3t54+W99mFA=;
        b=CLBJhQpKrMvl0SArzBg8++7hU4NC3RZ2KmLz+73bborzHVoBURRIVka3cTOgU8+Wji
         T8QSsXsQ9I3io+IkVwo26YQMVTm3WUrMDJ0ke8wu7USxgoG1SIYWJcb5SHbnn1eUIuqy
         dMFArCdOu29OpNHr1wY2Q+MdQSOMuYn+GvGzjilFmNa80BqXpjz1YEj3kE1kgSAp91yp
         9v0EKFLTdXnA7dVJbp9vRIXaqs+4HWwfxs6f1epYuXcKnQ4LGKhp2VuIS6L5g18OF8+d
         re/+NE579ZcIrsh10gfWMcnW9InnW7zfsS2+MxYoiAEr2DnVrIjnKWoBKzGJ2sF/RPLG
         LJvA==
X-Gm-Message-State: AOAM531OzcW2tAuJjWrQ7ju4yibyfJc320HoCuhvn2pn4JSWqfGIaffY
        jqzflQNqqxOv9aUi7y0gDg==
X-Google-Smtp-Source: ABdhPJxOcM2rTcPsyK/KYZTCJtx3mitXqFETRnqOhCLb+UY5aC/5c20oRk/sXbC1WHrbkoN5evIjFg==
X-Received: by 2002:a9d:10d:: with SMTP id 13mr14224641otu.8.1607368638252;
        Mon, 07 Dec 2020 11:17:18 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k10sm3019614otb.81.2020.12.07.11.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 11:17:17 -0800 (PST)
Received: (nullmailer pid 650679 invoked by uid 1000);
        Mon, 07 Dec 2020 19:17:16 -0000
Date:   Mon, 7 Dec 2020 13:17:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, jianxin.pan@amlogic.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@baylibre.com, narmstrong@baylibre.com,
        jbrunet@baylibre.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH RFC v2 1/5] dt-bindings: net: dwmac-meson: use
 picoseconds for the RGMII RX delay
Message-ID: <20201207191716.GA647149@robh.at.kernel.org>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
 <20201115185210.573739-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115185210.573739-2-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 07:52:06PM +0100, Martin Blumenstingl wrote:
> Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
> delay register which allows picoseconds precision. Deprecate the old
> "amlogic,rx-delay-ns" in favour of a new "amlogic,rgmii-rx-delay-ps"
> property.
> 
> For older SoCs the only known supported values were 0ns and 2ns. The new
> SoCs have 200ps precision and support RGMII RX delays between 0ps and
> 3000ps.
> 
> While here, also update the description of the RX delay to indicate
> that:
> - with "rgmii" or "rgmii-id" the RX delay should be specified
> - with "rgmii-id" or "rgmii-rxid" the RX delay is added by the PHY so
>   any configuration on the MAC side is ignored
> - with "rmii" the RX delay is not applicable and any configuration is
>   ignored
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  .../bindings/net/amlogic,meson-dwmac.yaml     | 61 +++++++++++++++++--
>  1 file changed, 56 insertions(+), 5 deletions(-)

Don't we have common properties for this now?

> 
> diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> index 6b057b117aa0..62a1e92a645c 100644
> --- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
> @@ -74,17 +74,68 @@ allOf:
>              Any configuration is ignored when the phy-mode is set to "rmii".
>  
>          amlogic,rx-delay-ns:
> +          deprecated: true
>            enum:
>              - 0
>              - 2
>            default: 0
> +          description:
> +            The internal RGMII RX clock delay in nanoseconds. Deprecated, use
> +            amlogic,rgmii-rx-delay-ps instead.
> +
> +        amlogic,rgmii-rx-delay-ps:
> +          default: 0
>            description:
>              The internal RGMII RX clock delay (provided by this IP block) in
> -            nanoseconds. When phy-mode is set to "rgmii" then the RX delay
> -            should be explicitly configured. When the phy-mode is set to
> -            either "rgmii-id" or "rgmii-rxid" the RX clock delay is already
> -            provided by the PHY. Any configuration is ignored when the
> -            phy-mode is set to "rmii".
> +            picoseconds. When phy-mode is set to "rgmii" or "rgmii-id" then
> +            the RX delay should be explicitly configured. When the phy-mode
> +            is set to either "rgmii-id" or "rgmii-rxid" the RX clock delay
> +            is already provided by the PHY so any configuration here is
> +            ignored. Also any configuration is ignored when the phy-mode is
> +            set to "rmii".
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - amlogic,meson8b-dwmac
> +              - amlogic,meson8m2-dwmac
> +              - amlogic,meson-gxbb-dwmac
> +              - amlogic,meson-axg-dwmac
> +    then:
> +      properties:
> +        amlogic,rgmii-rx-delay-ps:
> +          enum:
> +            - 0
> +            - 2000
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - amlogic,meson-g12a-dwmac
> +    then:
> +      properties:
> +        amlogic,rgmii-rx-delay-ps:
> +          enum:
> +            - 0
> +            - 200
> +            - 400
> +            - 600
> +            - 800
> +            - 1000
> +            - 1200
> +            - 1400
> +            - 1600
> +            - 1800
> +            - 2000
> +            - 2200
> +            - 2400
> +            - 2600
> +            - 2800
> +            - 3000
>  
>  properties:
>    compatible:
> -- 
> 2.29.2
> 
