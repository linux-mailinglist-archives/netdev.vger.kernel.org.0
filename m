Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EF32B127C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgKLXHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKLXHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:07:35 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7CAC0613D1;
        Thu, 12 Nov 2020 15:07:35 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so10531652ejm.0;
        Thu, 12 Nov 2020 15:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e3ZgniTCA5H487G9tHsJ332rAm4rBS2NT56JLlTOViU=;
        b=s/KnB+4zXRgSXtc9rFY7vBedjcryRv4v/RM8f0pKwfjtMhwC6nv8exfkvdYb2rzdjg
         zwkJcbltgojvoJOMI5POaz63X2JCQqRJjW9mKmKmYtohlm/tdcYkpSw7f7C1WQKL1Ium
         Na1dQvknXlnf0416jx0UK+XRvA79bTjC1BtmsqJhr2LWVDCB9yGlISlAMbU5cHwF28sU
         1Sf4ougJVhgD2a/a8oBX+GnlLJD6mVWWGKz2eu8gxyE0r6fiMIdoaOkYuMEtp6wEQMr8
         /HluX23eMhf7629c3fKi9Dn+oEHP350DjdVneg+kZp+9VObFPlPaVdul+GZ8GIIMkEMg
         1WeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e3ZgniTCA5H487G9tHsJ332rAm4rBS2NT56JLlTOViU=;
        b=mwcvdxCcyxLkzIkevRxQErh5Px2HIRopv+vfmVn/WfpmMwJ81Hl9X7j7+kHjAiUow/
         mDkaeSQ/VXNbcia62Jd7fDZvNlnh96THznL5usELOr5+hZ7kh/4k3RAZXNa+HsQwNWYC
         X+LqoKkBFhBtc49BTeH80NoQQu5HyV+9YeAkRZcE6ju9LZn7zs8/bw6h4wDksxw4uSTV
         UqEntAJ0agnGF3BU/1DIxO1nXFowH9iu9fhDYiCgvgtgHFQbOff8JfeggkRU3y0aRZdo
         gUG+OUSKNv7FX+arpZUrsGauox07bJsHWKegecsCfEbw/J3G5c9S92+RNpPgbMf63V56
         aoeA==
X-Gm-Message-State: AOAM531htnotNqOTmc9QTki1wfz6U7YTdpLmj8PWN5wyLTfpLMoWdgIv
        CkANTOm4SYfgEIhTjYUDlhI=
X-Google-Smtp-Source: ABdhPJxH067wX0DdUQJ5mWZrmxQb9K8jwbmNQojuCMoHAeVNWSCZMYIVMCF2YO09Wsu3oGKRbyIhdQ==
X-Received: by 2002:a17:906:961a:: with SMTP id s26mr1786211ejx.211.1605222454071;
        Thu, 12 Nov 2020 15:07:34 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id z2sm2991535edr.47.2020.11.12.15.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:07:33 -0800 (PST)
Date:   Fri, 13 Nov 2020 01:07:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 05/11] dt-bindings: net: dsa: microchip,ksz:
 add interrupt property
Message-ID: <20201112230732.5spb6qgsu3zdtq4d@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-6-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-6-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:31PM +0100, Christian Eggers wrote:
> The devices have an optional interrupt line.
>
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  .../devicetree/bindings/net/dsa/microchip,ksz.yaml        | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> index 431ca5c498a8..b2613d6c97cf 100644
> --- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> @@ -35,6 +35,11 @@ properties:
>        Should be a gpio specifier for a reset line.
>      maxItems: 1
>
> +  interrupts:
> +    description:
> +      Interrupt specifier for the INTRP_N line from the device.
> +    maxItems: 1
> +
>    microchip,synclko-125:
>      $ref: /schemas/types.yaml#/definitions/flag
>      description:
> @@ -47,6 +52,7 @@ required:
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
>
>      // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
>      eth0 {
> @@ -68,6 +74,8 @@ examples:
>              compatible = "microchip,ksz9477";
>              reg = <0>;
>              reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> +            interrupt-parent = <&gpio5>;
> +            interrupts = <1 IRQ_TYPE_LEVEL_LOW>;  /* INTRP_N line */

Isn't it preferable to use this syntax?

		interrupts-extended = <&gpio5 1 IRQ_TYPE_LEVEL_LOW>;  /* INTRP_N line */
