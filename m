Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AAF6C326D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCUNRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjCUNRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:17:48 -0400
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3A83B3D3;
        Tue, 21 Mar 2023 06:17:47 -0700 (PDT)
Received: by mail-oo1-f51.google.com with SMTP id f6-20020a4ace86000000b00537590ae0a2so2383504oos.8;
        Tue, 21 Mar 2023 06:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679404666;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z+bw9uWVkGzQiCESlzI/1AS8Gr6ronwYEU0kEQhW2Io=;
        b=M7imSlsDR1CqZ0cXiU/1xwIKhqdl/uX8GItyJ/xsd9d/NxSklQiNXha+PLKrKNTvGG
         cbAJ9Xn7DbdnMk7UkoYqFGRPqrISGIbhW3eUtL4eP5MsNhsM7v94X63+TYO9dVGBkRGE
         v43RENMxYdkIqgdM0p024oFZug1OCuCsGQfOx1G77rz8nmnyHZArBsnUjUmYhg+IlT8W
         g4aEY4wrj3o0Y72zama2WGu4zX3ttYogKP/7UrUWXc3h2orypg/RyqFJ123oro22Dg6N
         P861NNaI48DmTQqPdSOSZUS6XIMOGVieh/8ms3PDsmvHV4bj2LVPeOKm5CQAWzrAkV/t
         RfLw==
X-Gm-Message-State: AO0yUKXKerce7WIslprwNaDtF0H99OYzJl1VvpnljJ0fcY4yjaqmLjep
        H3R2RLItS60dK+HRNBOCFA==
X-Google-Smtp-Source: AK7set9zkfWwc7X0rtHtNOCeqnm7TEO0gLY54wqZimKCDFlf1NpV8xssLoeC1yHWNAQSg8fvxF91zQ==
X-Received: by 2002:a4a:410d:0:b0:53b:4b21:2345 with SMTP id x13-20020a4a410d000000b0053b4b212345mr957043ooa.2.1679404666427;
        Tue, 21 Mar 2023 06:17:46 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r8-20020a4a9648000000b0051134f333d3sm4910366ooi.16.2023.03.21.06.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 06:17:46 -0700 (PDT)
Received: (nullmailer pid 582074 invoked by uid 1000);
        Tue, 21 Mar 2023 13:17:45 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     daniel@makrotopia.org, netdev@vger.kernel.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        sean.wang@mediatek.com, devicetree@vger.kernel.org,
        edumazet@google.com, davem@davemloft.net,
        krzysztof.kozlowski+dt@linaro.org, lorenzo.bianconi@redhat.com,
        Mark-MC.Lee@mediatek.com, john@phrozen.org, nbd@nbd.name,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org
In-Reply-To: <c9b65ef3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org>
References: <cover.1679330630.git.lorenzo@kernel.org>
 <c9b65ef3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org>
Message-Id: <167940235606.530981.2024563505368619498.robh@kernel.org>
Subject: Re: [PATCH net-next 06/10] dt-bindings: soc: mediatek: move ilm in
 a dedicated dts node
Date:   Tue, 21 Mar 2023 08:17:45 -0500
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 20 Mar 2023 17:58:00 +0100, Lorenzo Bianconi wrote:
> Since the cpuboot memory region is not part of the RAM SoC, move ilm in
> a deidicated syscon node.
> This patch helps to keep backward-compatibility with older version of
> uboot codebase where we have a limit of 8 reserved-memory dts child
> nodes.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 14 +++---
>  .../soc/mediatek/mediatek,mt7986-wo-ilm.yaml  | 45 +++++++++++++++++++
>  2 files changed, 53 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.example.dts:63.59-60 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:419: Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.example.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1512: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/c9b65ef3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

