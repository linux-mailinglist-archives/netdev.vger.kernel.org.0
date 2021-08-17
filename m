Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581293EF23E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhHQSss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:48:48 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:44785 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbhHQSsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:48:45 -0400
Received: by mail-oi1-f181.google.com with SMTP id w6so496934oiv.11;
        Tue, 17 Aug 2021 11:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nzIgJMa9X2S8j+5qu6QKB3OfU1LS75XPiAFcEXr7Uv4=;
        b=tXcZr2FcpGIEQAeUcgFP9nxsCMi79b5mg9wjFcGx21KV7intnrhJLQVQev4rNCk5AP
         PdUgFOj/SOdlqhjQoxtRD91y/1dX0fTCtqPXVc9/8L93zbGUaXgVVIjInB72MgMz8gex
         aqBxAopZjPRkJwEgvGK0F3Vib9mLkq3QujYCPzFEq9/+4RKuN+saCoRAtP2hc9KfJ5z/
         3iqr9yWvWonama2eQmajUUrXrL9l6D0NLg3e22fIkgIeRdPtjLZDvHqVG+FE8e6Nmz/P
         6XqUj65skFQUc+Z8GD4VVWWoc4sAFq03hrzV6ZhEaYhHVABMx+02FAI2rIvjpixAKKt4
         dU6Q==
X-Gm-Message-State: AOAM533KL3d8ScLWrvSStJF6+z0I/hcsQI/KlCrxv4PmVGAuf6QLXfhq
        P7chOXGqb2/IOJlUgmnbMA==
X-Google-Smtp-Source: ABdhPJwImY4DZXklw6KIc/1fnibzeDWipJdCH7U+fkrAF8vgvcXjIuK+N7h1N3Uq0nTasi65mtFgAw==
X-Received: by 2002:a05:6808:81:: with SMTP id s1mr3670441oic.130.1629226091436;
        Tue, 17 Aug 2021 11:48:11 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q20sm638233oiw.58.2021.08.17.11.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 11:48:10 -0700 (PDT)
Received: (nullmailer pid 643472 invoked by uid 1000);
        Tue, 17 Aug 2021 18:48:09 -0000
Date:   Tue, 17 Aug 2021 13:48:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     chaochao2021666@163.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Zeng <chao.zeng@siemens.com>
Subject: Re: [PATCH 1/2] dt-bindings:dp83867:Add binding for the status led
Message-ID: <YRwEacEuiAuPzA0E@robh.at.kernel.org>
References: <20210809085213.324129-1-chaochao2021666@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809085213.324129-1-chaochao2021666@163.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 04:52:13PM +0800, chaochao2021666@163.com wrote:
> From: Chao Zeng <chao.zeng@siemens.com>
> 
> The phy status led of each of board maybe different.
> Provide a method to custom phy status led behavior.
> 
> Datasheet:
> http://www.ti.com/product/DP83867IR/datasheet
> 
> Signed-off-by: Chao Zeng <chao.zeng@siemens.com>
> ---
>  .../devicetree/bindings/net/ti,dp83867.yaml    |  6 ++++++
>  include/dt-bindings/net/ti-dp83867.h           | 18 ++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
> index 047d757e8d82..a46a437818f2 100644
> --- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
> @@ -106,6 +106,12 @@ properties:
>        Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h for applicable
>        values.
>  
> +  ti,led-sel:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      This configure the status led. See dt-bindings/net/ti-dp83867.h
> +      for different status led settings,select different configures

There's ongoing discussions about using the LED bindings/subsystem for 
this type of LED.

Rob
