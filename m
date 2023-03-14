Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265216B9755
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbjCNOKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjCNOKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:10:34 -0400
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF62B64861;
        Tue, 14 Mar 2023 07:10:30 -0700 (PDT)
Received: by mail-il1-f175.google.com with SMTP id r4so2711617ilt.8;
        Tue, 14 Mar 2023 07:10:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678803030;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jH1SOi85K699n5gOfmS0IKz7KMvDRC6FpXntoUDhE8s=;
        b=6NVEk08Q362IL6aCBMfIsUgTmbRprSAaoue0IDOyumt4oWmH/SCQMUH9o9kuLV0ROx
         nKaEITCqjTR+mQ8p3AKzN/PYTDAnLVX5ZBNjZQM4Pa9VwhCLnOskaG5j7G+Is45VDADk
         8ta/jPkgVQTW6OhF/Z71aapOHBGe0QpTMllxJVcoKktezBnVyeBGmZxZqSqOtTJMuGJL
         e6v3zTXQKJJDnxtc6l97rR4Mcxz3TR+J8Gu2gtW/A4MmIPgcmA2AzcY91sdFSqM5jyvM
         tFMvbqfTKGDkDt109lN+5OQj3UDekxF3dKjenm2FgRz5oW3hEnow7yI3HliDsDN5wF5U
         3A/Q==
X-Gm-Message-State: AO0yUKXw4RuFKDkXC64dnOJGwQMsxY+IZk7Irq7SrVWjCNl/ZPZGjq6l
        e8w+5DTZALYhsF/5eIZTSA==
X-Google-Smtp-Source: AK7set97Yuhz44i0lH7n9ZIMLWNIgKj/fvYuQB9FFs3g1CeDCxrOCx6cMMtgpjYvzcNDqtmwzf3pLw==
X-Received: by 2002:a92:c10f:0:b0:311:13c1:abd4 with SMTP id p15-20020a92c10f000000b0031113c1abd4mr2181500ile.24.1678803030034;
        Tue, 14 Mar 2023 07:10:30 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id g15-20020a056e02130f00b00318a9a35341sm818199ilr.79.2023.03.14.07.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 07:10:27 -0700 (PDT)
Received: (nullmailer pid 83791 invoked by uid 1000);
        Tue, 14 Mar 2023 14:10:19 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        Christian Marangi <ansuelsmth@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
In-Reply-To: <20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru>
Message-Id: <167880254800.26004.7037306365469081272.robh@kernel.org>
Subject: Re: [PATCH net-next 01/16] dt-bindings: net: dwmac: Validate PBL
 for all IP-cores
Date:   Tue, 14 Mar 2023 09:10:19 -0500
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 14 Mar 2023 01:50:48 +0300, Serge Semin wrote:
> Indeed the maximum DMA burst length can be programmed not only for DW
> xGMACs, Allwinner EMACs and Spear SoC GMAC, but in accordance with [1]
> for Generic DW *MAC IP-cores. Moreover the STMMAC set of drivers parse
> the property and then apply the configuration for all supported DW MAC
> devices. All of that makes the property being available for all IP-cores
> the bindings supports. Let's make sure the PBL-related properties are
> validated for all of them by the common DW MAC DT schema.
> 
> [1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
>     October 2013, p. 380.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> ---
> 
> Changelog v1:
> - Use correct syntax of the JSON pointers, so the later would begin
>   with a '/' after the '#'.
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 77 +++++++------------
>  1 file changed, 26 insertions(+), 51 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: Unevaluated properties are not allowed ('interrupt-names', 'interrupts', 'mac-address', 'phy-mode', 'reg', 'snps,reset-delays-us', 'snps,reset-gpio', 'snps,rxpbl', 'snps,txpbl' were unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

