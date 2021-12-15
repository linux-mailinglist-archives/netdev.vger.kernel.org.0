Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82259476508
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 22:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhLOV6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 16:58:46 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:41512 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhLOV6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 16:58:42 -0500
Received: by mail-ot1-f48.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so26613403otl.8;
        Wed, 15 Dec 2021 13:58:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3zeH0igIgZ6N61ry9PolPct9kSJDrAAlOGtWEn9bXBI=;
        b=I0uuPr6kaVSOr2ym8k+QvJ9fS/XmH4d33DHbo0vPNEmDNabU+kEKx7tTEdTBRSk9wD
         gJMBnESVk0Oxv8D702oPobw708+a/ipXWmjYbDT8bcAgIvpvq2TbBZJyrwqhDliu0R+2
         q1fvNarngwysK7D1wg2e665E0mc8COmF01aQMAf/asDFMQ6Xd4IEw+oNXU5C45lh9kmh
         usQ8EYCy8bL2S35msCysJYDmTHfprl7hiqrfpr+8BMciUxl/2OJuZlsoXds8Nmn3Qf/r
         wZjZdeqi6K926EqRQ3T+Luvol3jyuxW8MkA/LQDo0FdlQLLJ3qrEQIY5UyKGfaQzKJLc
         Wm8A==
X-Gm-Message-State: AOAM530xejQynOi7KY6rxoi1q+2nF7uUYND6/x0RoQLXWqnIZlvu0S2b
        S5HGfeZM/6ydUyHYNSpSrtdM+a0mPA==
X-Google-Smtp-Source: ABdhPJyP3vZ+Tj2Gy8J86y1uH0mdljg2WPYllUbHy5rGzBVwVXxn18MCmp5018CoYtlcAAw74T5Ovw==
X-Received: by 2002:a9d:1b0:: with SMTP id e45mr9906224ote.23.1639605522293;
        Wed, 15 Dec 2021 13:58:42 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a6sm590039oic.39.2021.12.15.13.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 13:58:41 -0800 (PST)
Received: (nullmailer pid 1913087 invoked by uid 1000);
        Wed, 15 Dec 2021 21:58:40 -0000
Date:   Wed, 15 Dec 2021 15:58:40 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree 2/2] dt-bindings: phy: Add
 `tx-amplitude-microvolt` property binding
Message-ID: <YbplENKCcjCUdwke@robh.at.kernel.org>
References: <20211214233432.22580-1-kabel@kernel.org>
 <20211214233432.22580-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211214233432.22580-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:34:32AM +0100, Marek Behún wrote:
> Common PHYs often have the possibility to specify peak-to-peak voltage
> on the differential pair - the default voltage sometimes needs to be
> changed for a particular board.

I can envision needing this, but I can't say that I've seen custom 
properties being proposed for this purpose.

> 
> Add properties `tx-amplitude-microvolt` and
> `tx-amplitude-microvolt-names` for this purpose. The second property is
> needed to specify

Is the amplitude peak to peak? You just said it was, but perhaps make 
the property name more clearly defined: tx-p2p-microvolt

> 
> Example usage with only one voltage (it will be used for all supported
> PHY modes, the `tx-amplitude-microvolt-names` property is not needed in
> this case):
> 
>   tx-amplitude-microvolt = <915000>;
> 
> Example usage with voltages for multiple modes:
> 
>   tx-amplitude-microvolt = <915000>, <1100000>, <1200000>;
>   tx-amplitude-microvolt-names = "2500base-x", "usb", "pcie";

I'm not wild about the -names, but I think outside of ethernet most 
cases will only be 1 entry.

For a phy provider with multiple phys, what if each one needs a 
different voltage (for the same mode)?

> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
> 
> I wanted to constrain the values allowed in the
> `tx-amplitude-microvolt-names` property to:
> - ethernet SerDes modes (sgmii, qsgmii, 10gbase-r, 2500base-x, ...)
> - PCIe modes (pattern: ^pcie[1-6]?$)
> - USB modes (pattern: ^usb((-host|-device|-otg)?-(ls|fs|hs|ss|ss\+|4))?$)
> - DisplayPort modes (pattern: ^dp(-rbr|-hbr[23]?|-uhbr-(10|13.5|20))?$)
> - Camera modes (mipi-dphy, mipi-dphy-univ, mipi-dphy-v2.5-univ)
> - Storage modes (sata, ufs-hs, ufs-hs-a, ufs-hs-b)
> 
> But was unable to. The '-names' suffix implies string-array type, and
> string-array type does not allow to specify a type for all items in a
> simple way, i.e.:
>   items:
>     enum:
>       - sgmii
>       - sata
>       - usb
>       ...

Works here: Documentation/devicetree/bindings/arm/samsung/pmu.yaml:56

The requirement is you need to constrain the size with maxItems. It can 
be a 'should be enough for anyone' value.

> Such constraint does work when changing ethernet controller's
> `phy-connection-type` to array, see
> https://lore.kernel.org/netdev/20211123164027.15618-2-kabel@kernel.org/
> 
> But it seems that string-array type prohibits this.
> 
> ---
>  .../devicetree/bindings/phy/phy.yaml          | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/phy/phy.yaml b/Documentation/devicetree/bindings/phy/phy.yaml
> index a5b6b04cff5b..8915065cf6c2 100644
> --- a/Documentation/devicetree/bindings/phy/phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/phy.yaml
> @@ -31,9 +31,29 @@ properties:
>        Phandle to a regulator that provides power to the PHY. This regulator
>        will be managed during the PHY power on/off sequence.
>  
> +  tx-amplitude-microvolt:
> +    description:
> +      Transmit amplitude voltages in microvolts, peak-to-peak. If this property
> +      contains multiple values for various PHY modes, the
> +      'tx-amplitude-microvolt-names' property must be provided and contain
> +      corresponding mode names.
> +
> +  tx-amplitude-microvolt-names:
> +    description: |
> +      Names of the modes corresponding to voltages in the
> +      'tx-amplitude-microvolt' property. Required only if multiple voltages
> +      are provided.
> +
> +      If a value of 'default' is provided, the system should use it for any PHY
> +      mode that is otherwise not defined here. If 'default' is not provided, the
> +      system should use manufacturer default value.
> +
>  required:
>    - '#phy-cells'
>  
> +dependencies:
> +  tx-amplitude-microvolt-names: [ tx-amplitude-microvolt ]
> +
>  additionalProperties: true
>  
>  examples:
> @@ -46,6 +66,8 @@ examples:
>      phy: phy {
>        #phy-cells = <1>;
>        phy-supply = <&phy_regulator>;
> +      tx-amplitude-microvolt = <915000>, <1100000>, <1200000>;
> +      tx-amplitude-microvolt-names = "2500base-x", "usb-hs", "usb-ss";
>      };
>  
>      ethernet-controller {
> -- 
> 2.32.0
> 
> 

