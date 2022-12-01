Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFC063F1C5
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 14:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiLANgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 08:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiLANgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 08:36:37 -0500
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0691CCA165;
        Thu,  1 Dec 2022 05:36:33 -0800 (PST)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-14286d5ebc3so2163970fac.3;
        Thu, 01 Dec 2022 05:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1K37iH9iyFVta8stQEbIxav/5AtugtdvdeJC9IDIXZQ=;
        b=0J9OHi0lMhVLmfov4UiioChZX1LgF87fvqX0Ny756MRA9eUfC3+yXdQGMW4aWVtZJB
         7Qam6UO3+ZmwRAvPO9EhEQbcsuBNL0tepuBgylqYQTsYoivbvSxgaiQsHsc97seFki5E
         N10iiYYrX75FvSUsVgGN1BQzv5Ys5TOygxVJZdaTeSGAlw9PIVXZhvonBZBojn0n/s2x
         LEpMWwPkgherxOHjCQAe63TOk9c1JHYz+2KXtfNte3vD5VBkPC1GvKGpar3HVGW+UY9Y
         9p1ULkjUkEp8yTvgT1x0WgSWLwkbkFVu3WLsQT2E24h6A9ZoXIbVYy3Bk/laWfKHfBSJ
         8xHw==
X-Gm-Message-State: ANoB5pkiveuaV8vPoDjUvQB28ISY/ddcwRjLX8/o7sdQ/FDrX4NTU8R5
        VUX9JkMV99nb4YK/VC58XQ==
X-Google-Smtp-Source: AA0mqf7RpOe69UtxOJCyqspnx7PZpkYhph5UqVYXm2bLG4LGpD1UvyszRA+XWaFW+lK0FJ4kI4of6A==
X-Received: by 2002:a05:6870:7b89:b0:13c:e644:d7a9 with SMTP id jf9-20020a0568707b8900b0013ce644d7a9mr38397974oab.148.1669901792169;
        Thu, 01 Dec 2022 05:36:32 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d7-20020a9d5e07000000b0066c3ca7b12csm2059192oti.61.2022.12.01.05.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 05:36:31 -0800 (PST)
Received: (nullmailer pid 486292 invoked by uid 1000);
        Thu, 01 Dec 2022 13:36:29 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
In-Reply-To: <20221201090242.2381-4-yanhong.wang@starfivetech.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
Message-Id: <166990139276.476262.15116409959152660279.robh@kernel.org>
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Date:   Thu, 01 Dec 2022 07:36:29 -0600
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 01 Dec 2022 17:02:38 +0800, Yanhong Wang wrote:
> Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>  .../bindings/net/starfive,dwmac-plat.yaml     | 106 ++++++++++++++++++
>  MAINTAINERS                                   |   5 +
>  3 files changed, 112 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml:30:16: [warning] wrong indentation: expected 14 but found 15 (indentation)

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/net/starfive,dwmac-plat.yaml#
Documentation/devicetree/bindings/net/starfive,dwmac-plat.example.dts:21:18: fatal error: dt-bindings/clock/starfive-jh7110.h: No such file or directory
   21 |         #include <dt-bindings/clock/starfive-jh7110.h>
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[1]: *** [scripts/Makefile.lib:406: Documentation/devicetree/bindings/net/starfive,dwmac-plat.example.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1492: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20221201090242.2381-4-yanhong.wang@starfivetech.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

