Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928F753477F
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 02:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbiEZAcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 20:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237109AbiEZAcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 20:32:36 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EC3B0424;
        Wed, 25 May 2022 17:32:20 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id wh22so203149ejb.7;
        Wed, 25 May 2022 17:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tBXCIHb4qO8VHE6VmKjrYwTNzuBx6iQC8DAUSK/i1Bg=;
        b=cyNAEaMDlQzWgLKBudLnvNUcsoNyt10eIOeTK7Y2Lt0uV7BmaIyrJ4n2cRHr+qq/aW
         mFphYOMRHbz3EevPZy5lnZnemP8TQldIedQlOeJxmLoJirujqkyzbFep0cnRoobPNEEz
         5sdXrRfnHZVnNy2nVlc1Dzdio9A7LF4YSM1bozIvVAYVbhyy4xDCeBT1LzBSc60lPvk6
         NK2DTT/aLjacr5p7rA8amGXhZmlGlUhvP4aHckhOX+QaC2NMEkJNxJvEv3s5XDkJL+Gi
         ENdxTej6Ru+Vz/gUkhwkQA4rxQN+Ya33S9hllkvgbBpoWga3cxn9VJxWLfU4TTVWoj+N
         a+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tBXCIHb4qO8VHE6VmKjrYwTNzuBx6iQC8DAUSK/i1Bg=;
        b=kghKZTzhOslPAbsJkkK+53G0ROUtEFyLPqz0sU/76rIgONNLg3iCcqESbZbDD6fmiJ
         Nvdpo5W9vITctpFjy1fbXhZsEwrt6E0mcun8E8fQmwvLJRKTo8Yb8tmqZkRwRP9qjldb
         m084Pje5+GnL+IFc/6u7TTlIZ9Yqb7frKgp+ivCsvoboZ+nm+j0duOZ3e2FqJMBHbOLy
         Jhv441+NOsgAH3Zk491R8E0ZIZPifH8BeLJJ2zJQ5jHXE8rxWdw9PNYtkIzBc4XGCgwF
         eOwAdvWDPPVttvTsjpSAoBuuiIeAcgBCH3FI66zctaeqFB+hb/oHZKOsepLmouhoAE3f
         tqzA==
X-Gm-Message-State: AOAM530dFtJXhRTDzoIqEGfd3CkoUlXS5ELmIHtSCBALK2amjKPqRYN3
        IzSjVvAt150R4UdfGGs3tSk=
X-Google-Smtp-Source: ABdhPJw03Up8flLPvxOIgpUAg6dl93ZyvmvVjLa56m/Cpy2CfskqyfS3o+8FfaX1MwwK7EhZC+JChA==
X-Received: by 2002:a17:907:2cc3:b0:6f8:5a21:4d62 with SMTP id hg3-20020a1709072cc300b006f85a214d62mr32485376ejc.256.1653525139035;
        Wed, 25 May 2022 17:32:19 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id v19-20020a170906339300b006f3ef214e05sm31072eja.107.2022.05.25.17.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 17:32:18 -0700 (PDT)
Date:   Thu, 26 May 2022 03:32:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net/dsa: Add spi-peripheral-props.yaml
 references
Message-ID: <20220526003216.7jxopjckccugh3ft@skbuf>
References: <20220525205752.2484423-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525205752.2484423-1-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 03:57:50PM -0500, Rob Herring wrote:
> SPI peripheral device bindings need to reference spi-peripheral-props.yaml
> in order to use various SPI controller specific properties. Otherwise,
> the unevaluatedProperties check will reject any controller specific
> properties.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 1 +
>  Documentation/devicetree/bindings/net/dsa/realtek.yaml       | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> index 184152087b60..6bbd8145b6c1 100644
> --- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> @@ -12,6 +12,7 @@ maintainers:
>  
>  allOf:
>    - $ref: dsa.yaml#
> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
>  
>  properties:
>    # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
> diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> index 99ee4b5b9346..4f99aff029dc 100644
> --- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> @@ -108,6 +108,7 @@ if:
>      - reg
>  
>  then:
> +  $ref: /schemas/spi/spi-peripheral-props.yaml#
>    not:
>      required:
>        - mdc-gpios
> -- 
> 2.34.1
> 

Also needed by nxp,sja1105.yaml and the following from brcm,b53.yaml:
	brcm,bcm5325
	brcm,bcm5365
	brcm,bcm5395
	brcm,bcm5397
	brcm,bcm5398
	brcm,bcm53115
	brcm,bcm53125
	brcm,bcm53128
