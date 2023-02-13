Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11953694119
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjBMJ2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjBMJ2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:28:16 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E113918A9E
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:26:09 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id o18so11425668wrj.3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WSLZ3ZKzsvIefT199tYWo7cJEGZZJgm6+X6WVzrQDEk=;
        b=SLdab1UEWactdNcB1w+n5yvxgRExwZc1qv84xdAEmwynljSRSQ3Ci8uC20Xp/xeoD2
         VcW8RjLygpG/Vic1xrzk4LDrIIMHbU5ZCL2mTNqqQxqHyySDCkzOMi6skSPVhjxbFAJ6
         3DPVNXzwHenU7oA4LlRJtv8bRQvl2NnK49jTekMoOgvOxDyXD4JjwZz3VEia5N2TbEHd
         alyvyJ9GKaXrYxDN1TK7s/oRyizZXJMwt7yhcCe6Cfn+JSZOtuP/y5FcqHjwfutiChlk
         oSzGGpQtdmV40tjToqhFWJKA9xVuUvfPEujfkAglf75PmL72M99ijvPCErk58Kr6zLUz
         Hm5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSLZ3ZKzsvIefT199tYWo7cJEGZZJgm6+X6WVzrQDEk=;
        b=kX7HJaXm5uAcH00zoe22vJCH6oIlmDq1C4qGumi90xNgjm93RgtcU1eD6jh6l0hJ0y
         I2+aVMjI8LwDFvY23LfvRrB7QEQ/ytYHaVmqf9etXicKLTm0EoLNNEFDSITrggBfFF0K
         mdwj3h9IWZU7SgbvySBhG4lDst5HF1PTOVflKG2T20kP2FesujodLkL2+vGt8yiua2NF
         /NpM3I0lH8vgzEowOontnG+Tn18HFo4lX+gDHX1vV7CSkM3+yJR4Pwb5GbwygUdUw7g2
         TZQAEmOFzHomjLWHHj1sFe51K8drqslKs4gAPOaTTY8E54T48qx84nZ/4WlBDEv3SzZJ
         cOAQ==
X-Gm-Message-State: AO0yUKXz6wyXOT4wd8Im4k98QVlvJzpjd8qvTNv1gSz15OdsjwlvULzR
        fV3YhszbfIGK5C8uDDKfFv0FwA==
X-Google-Smtp-Source: AK7set/7w+SNxBNKti9FoZehdW/4irYGNDTCvC0R2xc487VgVY69FMUVdWPnhCVD0GvgBt0CK5LIuA==
X-Received: by 2002:a5d:6707:0:b0:2c3:d4b0:6d8 with SMTP id o7-20020a5d6707000000b002c3d4b006d8mr21318493wru.23.1676280369540;
        Mon, 13 Feb 2023 01:26:09 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id r2-20020adff702000000b002bddac15b3dsm9806893wrp.33.2023.02.13.01.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:26:09 -0800 (PST)
Message-ID: <dbf26e3f-6a4f-cd15-c7d3-b0c1c482b83b@linaro.org>
Date:   Mon, 13 Feb 2023 10:26:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 08/12] net: stmmac: Add glue layer for StarFive JH7100 SoC
Content-Language: en-US
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2023 04:18, Cristian Ciocaltea wrote:
> From: Emil Renner Berthing <kernel@esmil.dk>
> 
> This adds a glue layer for the Synopsys DesignWare MAC IP core on the
> StarFive JH7100 SoC.
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> [drop references to JH7110, update JH7100 compatible string]
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> ---
>  MAINTAINERS                                   |   1 +
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 155 ++++++++++++++++++
>  4 files changed, 169 insertions(+)
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d48468b81b94..defedaff6041 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19820,6 +19820,7 @@ STARFIVE DWMAC GLUE LAYER
>  M:	Emil Renner Berthing <kernel@esmil.dk>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/starfive,jh7100-dwmac.yaml
> +F:	drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>  
>  STARFIVE JH7100 CLOCK DRIVERS
>  M:	Emil Renner Berthing <kernel@esmil.dk>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index f77511fe4e87..2c81aa594291 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
>  	  for the stmmac device driver. This driver is used for
>  	  arria5 and cyclone5 FPGA SoCs.
>  
> +config DWMAC_STARFIVE
> +	tristate "StarFive DWMAC support"

Bring only one driver.

https://lore.kernel.org/all/20230118061701.30047-6-yanhong.wang@starfivetech.com/

Best regards,
Krzysztof

