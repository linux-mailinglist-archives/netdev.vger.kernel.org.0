Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD35E6ED93E
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 02:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbjDYANV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 20:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDYANU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 20:13:20 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3883B4C16;
        Mon, 24 Apr 2023 17:13:19 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-38e4c98e5ceso1738347b6e.1;
        Mon, 24 Apr 2023 17:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682381598; x=1684973598;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pFwtgW0wvfFjibNHY+PyADwbRVqhSb57mZWqoTJnZz4=;
        b=NtQ83Wkc0rMiMEIdF7D5L1qpsogTz9NbZR4moigHipQhtkKpIxF2lmkqwlvxkpsiPb
         CsRu0nSA2Q2Ce+81W++eJfAZU8ZY0/c2iDeGkaUawYOKaMRX86fetaP38HLUqFTIlsOJ
         lBdXTe+2A2QgzMxVGG962NRacgqoUE4d/k3O/t9vayN5lNLMB66k1LTAxwa2eAopcR7K
         8laTmKU4AB/WS/tpR2GBueO0wPSGfSUtwy5QpIyxQ4EiDkcqP5QAaL0skCRvDmdriwvy
         MrwrNCPv2YT8nHadBVJXJ5yL4Om3WsIiZbihGXj0jCg7iXy7f4cRLCpvbnV//RAMzbTW
         NPgQ==
X-Gm-Message-State: AAQBX9cMLyRo6Jd2MU4TZ4SxK3rGeKLrS3SeTwrurzLPD0iysUOAwDHD
        I7GOWhD79BZR30Tln/Ku5Q==
X-Google-Smtp-Source: AKy350ZBoEkCK7vqTj0PueqwGaZpxLzKNT2QhoPIdll+DNVILUuxcLSXtlVd1pmbxqFa/wSrqUeXjg==
X-Received: by 2002:a05:6870:a706:b0:17e:dc2b:f4b4 with SMTP id g6-20020a056870a70600b0017edc2bf4b4mr11693226oam.15.1682381598317;
        Mon, 24 Apr 2023 17:13:18 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id n3-20020a056870e40300b00172ac40356csm4963304oag.50.2023.04.24.17.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 17:13:17 -0700 (PDT)
Received: (nullmailer pid 4124744 invoked by uid 1000);
        Tue, 25 Apr 2023 00:13:16 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Judith Mendez <jm@ti.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Nishanth Menon <nm@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Tero Kristo <kristo@kernel.org>,
        Schuyler Patton <spatton@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vignesh Raghavendra <vigneshr@ti.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20230424195402.516-3-jm@ti.com>
References: <20230424195402.516-1-jm@ti.com>
 <20230424195402.516-3-jm@ti.com>
Message-Id: <168238155801.4123790.14706903991436332296.robh@kernel.org>
Subject: Re: [PATCH v2 2/4] dt-bindings: net: can: Add poll-interval for
 MCAN
Date:   Mon, 24 Apr 2023 19:13:16 -0500
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 24 Apr 2023 14:54:00 -0500, Judith Mendez wrote:
> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
> routed to A53 Linux, instead they will use software interrupt by
> hrtimer. To enable timer method, interrupts should be optional so
> remove interrupts property from required section and introduce
> poll-interval property.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
> Changelog:
> v2:
>   1. Add poll-interval property to enable timer polling method
>   2. Add example using poll-interval property
> 
>  .../bindings/net/can/bosch,m_can.yaml         | 26 ++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with interrupts' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with timer polling' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
	from schema $id: http://devicetree.org/meta-schemas/base.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230424195402.516-3-jm@ti.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

