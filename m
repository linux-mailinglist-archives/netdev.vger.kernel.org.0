Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F526CB36C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 03:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjC1Bxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 21:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjC1Bxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 21:53:33 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5321FEF;
        Mon, 27 Mar 2023 18:53:31 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id cm7-20020a056830650700b006a11f365d13so4306928otb.0;
        Mon, 27 Mar 2023 18:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679968410;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NyEuKekF3ixV/ghMaaLEPqxVbnElSx+vXvln8EpC1Ds=;
        b=isef8aMUVBmV5qCgCYmD0UJsh5UHkZ5GA5e435jrpkRn2nzSuGp+HqLpivwC9F7bT/
         R0X25/WEtn6Bn3RADj2ybq5GE3+4isqcNnM5gzLkAJF06a+CKtai8ldGggNYjXG+eFPq
         89vKvS/41qNvphEkteTmm804kI7Ls4Cp+x53WPb67p7F5T4UX+39FkKWNvH6HaV1GtG5
         oN6rDOzMdYuamAxpfLeH5EmJBw76ahLNVJujwJcCCU3fNqgqKc901Kdt2qYXI/DmFY9M
         rg5cvO/gtae9z9+p+Q4gJ1OUvx0sbQh4slDx45BEyz5KdtDBS9+bPQe97/NMprmEGSpk
         fwEg==
X-Gm-Message-State: AO0yUKUppPFDuc1fknYJOX/aF9EAq8QjM22/Cg/Oc4iMe+TLDiScO/sP
        F1+AQOptaBfnWy8iBsZ7+A==
X-Google-Smtp-Source: AK7set+Ie7ktWPg++zt8jVvHXo1cAdbhkTlL7d3DAQDJwRSvs1eNXGTNVwfZwfNY7AhS2272o09lOA==
X-Received: by 2002:a9d:7441:0:b0:69c:639b:330e with SMTP id p1-20020a9d7441000000b0069c639b330emr6956689otk.3.1679968410464;
        Mon, 27 Mar 2023 18:53:30 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i18-20020a056830011200b0069fa6ca584bsm6331858otp.40.2023.03.27.18.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 18:53:29 -0700 (PDT)
Received: (nullmailer pid 1306389 invoked by uid 1000);
        Tue, 28 Mar 2023 01:53:28 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        michael@amarulasolutions.com, Rob Herring <robh+dt@kernel.org>,
        linux-can@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        linux-arm-kernel@lists.infradead.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org
In-Reply-To: <20230327201630.3874028-3-dario.binacchi@amarulasolutions.com>
References: <20230327201630.3874028-1-dario.binacchi@amarulasolutions.com>
 <20230327201630.3874028-3-dario.binacchi@amarulasolutions.com>
Message-Id: <167996718762.1276051.14765835681406438651.robh@kernel.org>
Subject: Re: [PATCH v9 2/5] dt-bindings: net: can: add STM32 bxcan DT
 bindings
Date:   Mon, 27 Mar 2023 20:53:28 -0500
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 27 Mar 2023 22:16:27 +0200, Dario Binacchi wrote:
> Add documentation of device tree bindings for the STM32 basic extended
> CAN (bxcan) controller.
> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> ---
> 
> Changes in v9:
> - Replace master/slave terms with primary/secondary.
> 
> Changes in v5:
> - Add Rob Herring's Reviewed-by tag.
> 
> Changes in v4:
> - Remove "st,stm32f4-bxcan-core" compatible. In this way the can nodes
>  (compatible "st,stm32f4-bxcan") are no longer children of a parent
>   node with compatible "st,stm32f4-bxcan-core".
> - Add the "st,gcan" property (global can memory) to can nodes which
>   references a "syscon" node containing the shared clock and memory
>   addresses.
> 
> Changes in v3:
> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
> - Add description to the parent of the two child nodes.
> - Move "patterProperties:" after "properties: in top level before "required".
> - Add "clocks" to the "required:" list of the child nodes.
> 
> Changes in v2:
> - Change the file name into 'st,stm32-bxcan-core.yaml'.
> - Rename compatibles:
>   - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
>   - st,stm32-bxcan -> st,stm32f4-bxcan
> - Rename master property to st,can-master.
> - Remove the status property from the example.
> - Put the node child properties as required.
> 
>  .../bindings/net/can/st,stm32-bxcan.yaml      | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml:27:11: [error] syntax error: mapping values are not allowed here (syntax)

dtschema/dtc warnings/errors:
make[1]: *** Deleting file 'Documentation/devicetree/bindings/net/can/st,stm32-bxcan.example.dts'
Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml:27:11: mapping values are not allowed here
make[1]: *** [Documentation/devicetree/bindings/Makefile:26: Documentation/devicetree/bindings/net/can/st,stm32-bxcan.example.dts] Error 1
make[1]: *** Waiting for unfinished jobs....
./Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml:27:11: mapping values are not allowed here
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml: ignoring, error parsing file
make: *** [Makefile:1512: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230327201630.3874028-3-dario.binacchi@amarulasolutions.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

