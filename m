Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FE2B222A
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 16:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387643AbfIMOgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 10:36:18 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:32886 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730680AbfIMOgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 10:36:15 -0400
Received: by mail-oi1-f196.google.com with SMTP id e12so2834231oie.0;
        Fri, 13 Sep 2019 07:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=UP4LyBZtja8yOBRdHcIkyNeFR6QjS9+iEtVblnpjuyY=;
        b=e8Y2bOs6zYmQz5xB+xSJ6b600FvY+atgP2eY5jqjfDF4SNTBVIQNyvv+BnlEYcGGw7
         DUurBO+i9xYegYVgkaoT8DyMUOr54NDZ54bvKy/LcvLQ+tCm8kG86BbWV5J5CE8MGe4o
         fWBtTUoE2CYjXgAxk/B4AfSpd8jUk5um7JKS8SvQ7PLA7BMr8k3HtcfUhL3MIUXBrRUf
         nHXdaBQ3bhkjeDOd312ora886KWEKldMxcNh0T+Lwk3KPbtlYDQfhUNdKWUm4NuFzXTf
         S1u9u5RlBl3IiQKsERLPdnqxe/Gx0cgePeFiT9RV8WztYneIHzg5EOtX8DKwqNNIagGr
         79MQ==
X-Gm-Message-State: APjAAAXA9mCKynpuTMthHdPe/yzEdNCdOviQqWPlVZUssCrMjK1aCzQP
        BK4ggmJ1gKf1Sb70qpFlYA==
X-Google-Smtp-Source: APXvYqzP1VXv0J4uktgJBC21kz8j76TfYxkR5gba3uZ868WL6Ruc+iWxBjHhaWJLDP7vH3miYFpvdw==
X-Received: by 2002:aca:4406:: with SMTP id r6mr3656555oia.175.1568385374280;
        Fri, 13 Sep 2019 07:36:14 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i47sm10585317ota.1.2019.09.13.07.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 07:36:13 -0700 (PDT)
Message-ID: <5d7ba95d.1c69fb81.dabe4.8057@mx.google.com>
Date:   Fri, 13 Sep 2019 15:36:13 +0100
From:   Rob Herring <robh@kernel.org>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        --cc=andrew@lunn.ch
Subject: Re: [PATCH 2/2] dt-bindings: net: dwmac: document 'mac-mode' property
References: <20190906130256.10321-1-alexandru.ardelean@analog.com>
 <20190906130256.10321-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906130256.10321-2-alexandru.ardelean@analog.com>
X-Mutt-References: <20190906130256.10321-2-alexandru.ardelean@analog.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 04:02:56PM +0300, Alexandru Ardelean wrote:
> This change documents the 'mac-mode' property that was introduced in the
> 'stmmac' driver to support passive mode converters that can sit in-between
> the MAC & PHY.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index c78be15704b9..ebe4537a7cce 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -112,6 +112,14 @@ properties:
>    reset-names:
>      const: stmmaceth
>  
> +  mac-mode:
> +    maxItems: 1

Is this an array because {min,max}Items is for arrays? It should be 
defined as a string with possible values.

As this property is the same as another, you can do this:

$ref: ethernet-controller.yaml#/properties/phy-connection-type

Unless only a small subset of those values are valid here, then you may 
want to list them here.

> +    description:
> +      The property is identical to 'phy-mode', and assumes that there is mode
> +      converter in-between the MAC & PHY (e.g. GMII-to-RGMII). This converter
> +      can be passive (no SW requirement), and requires that the MAC operate
> +      in a different mode than the PHY in order to function.
> +
>    snps,axi-config:
>      $ref: /schemas/types.yaml#definitions/phandle
>      description:
> -- 
> 2.20.1
> 

