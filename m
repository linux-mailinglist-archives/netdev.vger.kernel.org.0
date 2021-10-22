Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02DB4380A6
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhJVXdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:33:32 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:36681 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJVXd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 19:33:29 -0400
Received: by mail-ot1-f53.google.com with SMTP id p6-20020a9d7446000000b0054e6bb223f3so6270984otk.3;
        Fri, 22 Oct 2021 16:31:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a9MnZ3AT9qGvGmQ1Cslx6XmcG39lIU5g2B9khhh02Ug=;
        b=YPJs+bZ8MX6sM3yfQD/m0DMsZ3XFZAxGVXQbOVe6KoMz6xPmU0qFPMvEtH4IFV3noG
         8w5u1OsqniZ+nwgdtJHvShkAKzihvuhfTwgqZPGgEGpSuYULvd8nh7deMZvjRt0SGsDI
         iqCSZ+zXkE3CiWSxhsSIdrCwRgnHKpa3guWE08LqgkqgN3AKrbdV4tYxbCj81GNKqWsS
         Fm9mdDY/B1+l/h4129c8sQEv4qXf8Ji1etPVmWoxUGFFna5BLLh2pZYtOaRE0todhr+V
         IOddK0Z7QPejx31uXbvMb0DHL+9Wh/qOZ5N/CFPGxAwdqRY5Kovl30dUvtc946eTaBwO
         dhEQ==
X-Gm-Message-State: AOAM532SyCprIxPn6kSACxHp085spJtkXJoofqB84SwwLMq4mbpfcc0H
        9ZhwOYXQ23BI3b5VayhcBw==
X-Google-Smtp-Source: ABdhPJxTHl0+ev4Frm50xzB7lZEY4OSU9Mi8G5kbM6XjEmXbRKmRK7D0h/UafyOKWer+eQJD+TWC3Q==
X-Received: by 2002:a9d:60d9:: with SMTP id b25mr2226905otk.378.1634945471370;
        Fri, 22 Oct 2021 16:31:11 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w2sm1732262ooa.26.2021.10.22.16.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 16:31:10 -0700 (PDT)
Received: (nullmailer pid 3375337 invoked by uid 1000);
        Fri, 22 Oct 2021 23:31:09 -0000
Date:   Fri, 22 Oct 2021 18:31:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 2/4] dt-bindings: net: dsa: inherit the
 ethernet-controller DT schema
Message-ID: <YXNJvRg3nbNVUlKW@robh.at.kernel.org>
References: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
 <20211018192952.2736913-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018192952.2736913-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 10:29:50PM +0300, Vladimir Oltean wrote:
> Since a switch is basically a bunch of Ethernet controllers, just
> inherit the common schema for one to get stronger type validation of the
> properties of a port.
> 
> For example, before this change it was valid to have a phy-mode = "xfi"
> even if "xfi" is not part of ethernet-controller.yaml, now it is not.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index 224cfa45de9a..9cfd08cd31da 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -46,6 +46,9 @@ patternProperties:
>          type: object
>          description: Ethernet switch ports
>  
> +        allOf:
> +          - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"

$ref: /schemas/net/ethernet-controller.yaml#

And don't need 'allOf'.

> +
>          properties:
>            reg:
>              description: Port number
> -- 
> 2.25.1
> 
> 
