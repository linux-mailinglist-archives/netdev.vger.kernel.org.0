Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEBD66C97E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbjAPQuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjAPQtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:49:39 -0500
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADAC2A9B9;
        Mon, 16 Jan 2023 08:36:22 -0800 (PST)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1322d768ba7so29331495fac.5;
        Mon, 16 Jan 2023 08:36:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uNqcgfsqzvT4hYSE9tmwyaCcZuoHrn7TWnuHqh3zmXw=;
        b=pYFM0WM0g+OJzPikSaKWVcl8tEttFe97TQKcZja+xJBAW46r1AELH7eod4kVKx9zP4
         VBi5sUZfjPbWwdw9tzuIycFfr1YbNceeN5IAZ2TCA6fi4kl718AA+PhSi/G6Cyfi7cb1
         aAEedBIM/lqGgKS+Bbt4R7rclnM9G9ugQCvl50nwGy4bcDbIkyXvfLcd7Tl94SxHknra
         2E1WxsgsaTM+AOvSTxfZS98PX/z7hb4N1M/s3ztQi8ihka5QM6y6ltWC9Onk/feXjCmA
         7u/83rI4RyJceDb3Ph1kO8wg9gT6HPjA06BkCwYEAtYbJEb44Jt06uuBg2mOeBlKwnwL
         uMwQ==
X-Gm-Message-State: AFqh2krJisilrp79oEvQR6SNkGspPlumGdOTIk8pfDkgcuLLeO/7a3Eg
        L3Rpp4xDYusJHxLCiTgKiQ==
X-Google-Smtp-Source: AMrXdXvfezfraQ6Rq29LStDso8y0eL9XBGMaLRCAZ8gl9g52Xip9qYzqJKCjohBq7pOVMFKayI8TyA==
X-Received: by 2002:a05:6870:c194:b0:158:7b1d:e9a3 with SMTP id h20-20020a056870c19400b001587b1de9a3mr13040474oad.6.1673886981775;
        Mon, 16 Jan 2023 08:36:21 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h24-20020a056870171800b0014f9cc82421sm14778754oae.33.2023.01.16.08.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:36:21 -0800 (PST)
Received: (nullmailer pid 606186 invoked by uid 1000);
        Mon, 16 Jan 2023 16:36:12 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Herve Codina <herve.codina@bootlin.com>,
        linux-arm-kernel@lists.infradead.org,
        ", Thomas Petazzoni" <thomas.petazzoni@bootlin.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        ", Pascal Eberhard" <pascal.eberhard@se.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>
In-Reply-To: <20230116103926.276869-5-clement.leger@bootlin.com>
References: <20230116103926.276869-1-clement.leger@bootlin.com>
 <20230116103926.276869-5-clement.leger@bootlin.com>
Message-Id: <167388663912.594183.16249688377425648606.robh@kernel.org>
Subject: Re: [PATCH net-next 4/6] dt-bindings: net: renesas,rzn1-gmac:
 Document RZ/N1 GMAC support
Date:   Mon, 16 Jan 2023 10:36:12 -0600
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 16 Jan 2023 11:39:24 +0100, Clément Léger wrote:
> Add "renesas,rzn1-gmac" binding documention which is compatible which
> "snps,dwmac" compatible driver but uses a custom PCS to communicate
> with the phy.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/renesas,rzn1-gmac.yaml       | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.example.dtb: ethernet@44000000: compatible: ['renesas,rzn1-gmac'] does not contain items matching the given schema
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230116103926.276869-5-clement.leger@bootlin.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

