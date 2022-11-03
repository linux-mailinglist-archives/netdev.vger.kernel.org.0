Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B644618CD2
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 00:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiKCXd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 19:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiKCXdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 19:33:24 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713775FDB;
        Thu,  3 Nov 2022 16:33:23 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id 13so9348935ejn.3;
        Thu, 03 Nov 2022 16:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UQYI60HPFAeQV3YgrEAYhfzgwL+NL+uq4fz1h8XP5dY=;
        b=fVmN0B/VlowI6Xn6+GPMC+FIrSh+IcVpVD1CnIcvpBt4BaY+TeHDofCBqwtyTpYSj4
         mEXXoYTTIOazczI1l0VrX3UkYfaiPgetWGwxJhGetTpdEcmh8VHxewPtzb5JJflZbdvv
         VdDsQmCJnJkkA/UEZ1Xr9t+EpfU0UuUNwI+u3LQt6X7gVwsWjAk3PklTLgIiDJ8casoQ
         jUcJCc0uIBNSIWNxFMfH/Xtum0VUwO5r1vBNS5jqDkojQOrRuI8aJTJeZvY/aVhHFVPi
         teiZy9b9ebqaZuzNYQ8AGkCw84Af5WSkSfqv5PyZxU2XCae6TG5ZwpVTu/dFX5JRQrL0
         LlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQYI60HPFAeQV3YgrEAYhfzgwL+NL+uq4fz1h8XP5dY=;
        b=aLuIFkZMXNL6wvNeWs2V5ZnvqgKGaPnAuprbTkVDImWsV9dPNhDXo9YWVMNVRp3009
         2l8XO9tFij/YqX2DQNQHQBDEUS/QBMfItrc3R5kmnV8D6rEoamzIBNcaLnP9/SamyeIm
         yAe4TRRByVQIKhX1ufwcKqrxCbN3NsAmu1yvckepAgnMLN2XOrQ+ceTdu1hyk/xOAwzz
         HVF5vR7CHm9/9mvVbM3shscA56axQBDjCfJlsWKX5iCFi1TN0MMjHiq2+oIN3HvsJKXg
         +3YJ568vm+Owh/1Ote+/jlmo7KGutvsTgLKaXd7c/QcRf8oq47zuTGI5pNdhBCUIZ2W4
         fKTw==
X-Gm-Message-State: ACrzQf2Y/2j8Xzth2/DCze4bz6Ku4+QE5TGTCD50a8PET1OO6jHodf4v
        pqvokkdm9pis4Gf5dYdYj8hLsRtGXvHN6R4P
X-Google-Smtp-Source: AMsMyM558McdR6z3sk0s8EHwfqs7lwfHYIHx/lvR6x55rn3hWrQqaTXqK0OJ4I25i/zAejh+DDlvxQ==
X-Received: by 2002:a17:906:7d8c:b0:7ae:159d:1146 with SMTP id v12-20020a1709067d8c00b007ae159d1146mr6347842ejo.528.1667518401916;
        Thu, 03 Nov 2022 16:33:21 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id s28-20020a056402037c00b0045bccd8ab83sm1131934edw.1.2022.11.03.16.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 16:33:21 -0700 (PDT)
Date:   Fri, 4 Nov 2022 01:33:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20221103233319.m2wq5o2w3ccvw5cu@skbuf>
References: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Wed, Nov 02, 2022 at 02:52:32PM -0400, Krzysztof Kozlowski wrote:
> Some boards use SJA1105 Ethernet Switch with SPI CPOL and CPHA, so
> document this to fix dtbs_check warnings:
> 
>   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Changes since v1:
> 1. Add also cpha
> ---
>  Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> index 1e26d876d146..3debbf0f3789 100644
> --- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> @@ -36,6 +36,9 @@ properties:
>    reg:
>      maxItems: 1
>  
> +  spi-cpha: true
> +  spi-cpol: true
> +
>    # Optional container node for the 2 internal MDIO buses of the SJA1110
>    # (one for the internal 100base-T1 PHYs and the other for the single
>    # 100base-TX PHY). The "reg" property does not have physical significance.
> -- 
> 2.34.1
> 

Don't these belong to spi-peripheral-props.yaml?
