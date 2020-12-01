Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729252C938A
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgLAACp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:02:45 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:46111 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgLAACp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:02:45 -0500
Received: by mail-il1-f194.google.com with SMTP id b8so13099915ila.13;
        Mon, 30 Nov 2020 16:02:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x+vU33C5twxuQ+gl2xId1FzTRHdN1feLBu/jqhnvoKc=;
        b=GHNAS2SqNpOt9h5ZbgM1kHwSipHtxGjN39oIWrBuVvTjMIgSJHJ9x1BsmCZylAOGC/
         wOlG4srVT8bk/kU5mtMqxUhNz75SJ/EEkvAhMFhW7/266nbimjs0Hu32AWGN29Z/v99R
         ckH1HS3i152z5GCUmjzgwADzNQEIsjMncAx49y+Ldwq7h6QqxHrunv0aroHxB40Nmeg3
         V0Pk8A44hRI4aFl8twhjeSQXO0qRJ1UOG+K7CQG7OXOohsJIXS87CIsqamqvlq2KsWd8
         nFU1laQbY35UfwSejOs0n2HhkJIxRwFnpGO3VZlqQrM27Pr5zkZywHYXqySNQsZ8WOEi
         t8Og==
X-Gm-Message-State: AOAM531kn2W0hFaRcsxpTuDJwYsEIt1Dg5LLCcxHv0H/jXhsJaO24D3m
        V3jIwLI8vQ9inQErzHhsWw==
X-Google-Smtp-Source: ABdhPJx0o/uvQUwF2q2l2tJUuBSKDHDM+OZ40hNwLRM8YThuYL1/8/EFpzli9WUmHvbkiWC9e0nM1g==
X-Received: by 2002:a92:aa8b:: with SMTP id p11mr188890ill.5.1606780924118;
        Mon, 30 Nov 2020 16:02:04 -0800 (PST)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id w12sm81905ilo.63.2020.11.30.16.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 16:02:03 -0800 (PST)
Received: (nullmailer pid 3297076 invoked by uid 1000);
        Tue, 01 Dec 2020 00:02:01 -0000
Date:   Mon, 30 Nov 2020 17:02:01 -0700
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, ciorneiioana@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/4] dt-bindings: net: Add Rx/Tx output
 configuration for 10base T1L
Message-ID: <20201201000201.GA3293113@robh.at.kernel.org>
References: <20201117201555.26723-1-dmurphy@ti.com>
 <20201117201555.26723-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117201555.26723-3-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:15:53PM -0600, Dan Murphy wrote:
> Per the 802.3cg spec the 10base T1L can operate at 2 different
> differential voltages 1v p2p and 2.4v p2p. The abiility of the PHY to

1.1V?

> drive that output is dependent on the PHY's on board power supply.
> This common feature is applicable to all 10base T1L PHYs so this binding
> property belongs in a top level ethernet document.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 6dd72faebd89..bda1ce51836b 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -174,6 +174,12 @@ properties:
>        PHY's that have configurable TX internal delays. If this property is
>        present then the PHY applies the TX delay.
>  
> +  max-tx-rx-p2p-microvolt:
> +    description: |

Don't need '|' if no formatting.

> +      Configures the Tx/Rx p2p differential output voltage for 10base-T1L PHYs.
> +    enum: [ 1100, 2400 ]
> +    default: 2400

Aren't you off by 1000?

> +
>  required:
>    - reg
>  
> -- 
> 2.29.2
> 
