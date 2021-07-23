Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D263D41C4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 22:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhGWUMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:12:25 -0400
Received: from mail-il1-f169.google.com ([209.85.166.169]:39485 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhGWUMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 16:12:23 -0400
Received: by mail-il1-f169.google.com with SMTP id r1so2727328iln.6;
        Fri, 23 Jul 2021 13:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/AvCVAOPmzcCvwso3MEXLVk+T/5PwdgBQwVXHtVRXLQ=;
        b=oWIJBerd44fkYcRajHOtmSiA4F+zX58JY8MBU/mFlb9Ec0NVLHjYD8AgzdnqehSfmy
         tEYu7NSHSqHHEtF7/OM/UtNBkMrTzGsfNNvqAzv9Z432gFiVVq1RtRJshsIxXVgk8pIL
         JcIPFgdLAmAiZjge65ehaz1c2hCteIvE9k+9PqAVWj1VFKOeYGfmW3Nms+cDADLkLn84
         oTIVThvC0lKN/ouWCjqddvzivFHy9nXOZMtmUmwdxfB/RjJeAalDyj1O/3x0KGvZ2n8P
         JzXICfYde7quGLNxbkmN9Oozu5PHgziv8OVcCsp0acWHKGcv2M5fDT/+vGHISb6r7s83
         gm0Q==
X-Gm-Message-State: AOAM53273Z27WEZOvAy1GTChH6ampyUM6k45so0MJ5Blhj6C08QwufKT
        65aqsRgYT7V/EcqBwzeMwQ==
X-Google-Smtp-Source: ABdhPJxvyJlQGFCcyKOtEJ0bf1BBxsJ28bUJFu7YWDYae3GdTeNkSKQFyAoEaqUht/s6+GRgsvUV4A==
X-Received: by 2002:a92:d5cf:: with SMTP id d15mr4618870ilq.194.1627073575770;
        Fri, 23 Jul 2021 13:52:55 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id m26sm18982919ioo.23.2021.07.23.13.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 13:52:55 -0700 (PDT)
Received: (nullmailer pid 2560560 invoked by uid 1000);
        Fri, 23 Jul 2021 20:52:52 -0000
Date:   Fri, 23 Jul 2021 14:52:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: qcom,ipa: make imem
 interconnect optional
Message-ID: <20210723205252.GA2550230@robh.at.kernel.org>
References: <20210719212456.3176086-1-elder@linaro.org>
 <20210719212456.3176086-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719212456.3176086-2-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 04:24:54PM -0500, Alex Elder wrote:
> On some newer SoCs, the interconnect between IPA and SoC internal
> memory (imem) is not used.  Reflect this in the binding by moving
> the definition of the "imem" interconnect to the end and defining
> minItems to be 2 for both the interconnects and interconnect-names
> properties.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  .../devicetree/bindings/net/qcom,ipa.yaml      | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index ed88ba4b94df5..4853ab7017bd9 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -87,16 +87,18 @@ properties:
>        - const: ipa-setup-ready
>  
>    interconnects:
> +    minItems: 2
>      items:
> -      - description: Interconnect path between IPA and main memory
> -      - description: Interconnect path between IPA and internal memory
> -      - description: Interconnect path between IPA and the AP subsystem
> +      - description: Path leading to system memory
> +      - description: Path between the AP and IPA config space
> +      - description: Path leading to internal memory
>  
>    interconnect-names:
> +    minItems: 2
>      items:
>        - const: memory
> -      - const: imem
>        - const: config
> +      - const: imem

What about existing users? This will generate warnings. Doing this for 
the 2nd item would avoid the need for .dts updates:

- enum: [ imem, config ]

Rob
