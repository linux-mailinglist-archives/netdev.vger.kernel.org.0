Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575FD3EF76A
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 03:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbhHRBTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 21:19:32 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:45733 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbhHRBTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 21:19:30 -0400
Received: by mail-ot1-f54.google.com with SMTP id r17-20020a0568302371b0290504f3f418fbso747664oth.12;
        Tue, 17 Aug 2021 18:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YZdOGsqD+urHDCjHCdjJOrriltdQIdlSRawPeo4UfKY=;
        b=oOPUOI5d1xOz3IELLdsI/vcM8sClRqqmZ2nLdHYchaO9nvzFaF1jNEzxpmnAT7YC4m
         DfFfY2MXncbqxExI4qqSqOOBoaJj63pJPCtTfwxgRhDBpr0SzH8/evUlDkedXQeQI301
         xYkakZJw17psrRt67tIl3RI6MATTiKPri3Il/8Z36ld0vvyfzzTzc1nav5Zrr7Hh9fD3
         fSBBWP8nQROINjlG++nsQXUhawfhPwT/3cFGuy/3ZQLLEO9+JJCDaWoW18AFwDoeyLbr
         evqSWQHucS8P6iIpJs0E0ju9JX0ik3AN9AqyY6/q7GizIV9PLI7txxGdIj7iTfqeSGyx
         Y1GA==
X-Gm-Message-State: AOAM530icb1rA7cZkCUBWEZBL2QVMqTVdnqjdfKLSJGUFZgTjrOtAFMs
        9ym4tCLfKyPR7FVqsm0EWg==
X-Google-Smtp-Source: ABdhPJxCGAdPpbh79Ogzr6eYEZ2NJhmJScyvJnK9cm/Gv67ucaQYIk6J4BFKmjXeg3omKzi1oTrPBQ==
X-Received: by 2002:a9d:6490:: with SMTP id g16mr4882866otl.184.1629249536153;
        Tue, 17 Aug 2021 18:18:56 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id v11sm466308oto.22.2021.08.17.18.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 18:18:55 -0700 (PDT)
Received: (nullmailer pid 1180157 invoked by uid 1000);
        Wed, 18 Aug 2021 01:18:54 -0000
Date:   Tue, 17 Aug 2021 20:18:54 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH v2 1/3] dt-bindings: can-controller: add support for
 termination-gpios
Message-ID: <YRxf/gKvS3o+hq1/@robh.at.kernel.org>
References: <20210817041306.25185-1-o.rempel@pengutronix.de>
 <20210817041306.25185-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817041306.25185-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 06:13:04AM +0200, Oleksij Rempel wrote:
> Some boards provide GPIO controllable termination resistor. Provide
> binding to make use of it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/can/can-controller.yaml      | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/can-controller.yaml b/Documentation/devicetree/bindings/net/can/can-controller.yaml
> index 9cf2ae097156..298ce69a8208 100644
> --- a/Documentation/devicetree/bindings/net/can/can-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/can/can-controller.yaml
> @@ -13,6 +13,15 @@ properties:
>    $nodename:
>      pattern: "^can(@.*)?$"
>  
> +  termination-gpios:
> +    description: GPIO pin to enable CAN bus termination.

maxItems: 1

> +
> +  termination-ohms:
> +    description: The resistance value of the CAN bus termination resistor.
> +    $ref: /schemas/types.yaml#/definitions/uint16-array

Standard unit properties already have a type and are uint32.

> +    minimum: 1
> +    maximum: 65535
> +
>  additionalProperties: true
>  
>  ...
> -- 
> 2.30.2
> 
> 
