Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DDD678D59
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 02:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbjAXBYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 20:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjAXBYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 20:24:07 -0500
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76613757B;
        Mon, 23 Jan 2023 17:23:31 -0800 (PST)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-15f97c478a8so16017091fac.13;
        Mon, 23 Jan 2023 17:23:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GLVto5yh3pJz6zu6tYjZ+M6kKyH93aiMkaD5/MTlBWE=;
        b=flznn8Vx665lOgJN6Q6Co3YtZZ0YZS6Bw2KgwlcAG3yF6vctEmde6gSl/u/Hwkkpfc
         7jVXidLQSgXObawA0hjA6GwVKhQDFc8WiePuZBmjZ2BpeKvbl7MfTbTlA7eFmX6Z2GP6
         Ot7HfgHWud1YmGWnCrcAR2wxkhPWSRIe2Dai/+vIxuyUqdDr07dVtZUxtkgP69no0log
         qYAyDolHV3aoHI0+WQHaj30d1ioYl5J31+R2dKqmGoc/uofOpjx2L5EqPiWvAubWPoNV
         zr//c/xarRc5o92DuCOP3ZhrWzoHvlodQrSSvXm9hru+5+dbIg3OBM1rt68TMJKfDtIU
         4iDg==
X-Gm-Message-State: AFqh2kq87X/p6+bP03MaNAER7856jM97W3umDx8v769NlN611tRJlF8+
        YOwwTtFGyGbBUkcP4SslCQ+0DTV1RA==
X-Google-Smtp-Source: AMrXdXtytUFc/3CGNMl4vK4INEEhyGrE/0xGZ7ONnXHIP1hzrgKo4K1R2LtegXWqsO91zJ+MQU6vBA==
X-Received: by 2002:a05:6870:9b09:b0:15f:456:6b98 with SMTP id hq9-20020a0568709b0900b0015f04566b98mr13453079oab.7.1674523364347;
        Mon, 23 Jan 2023 17:22:44 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id eb44-20020a056870a8ac00b0014fb4bdc746sm210523oab.8.2023.01.23.17.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:22:43 -0800 (PST)
Received: (nullmailer pid 3121716 invoked by uid 1000);
        Tue, 24 Jan 2023 01:22:42 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        devicetree@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
In-Reply-To: <20230118122817.42466-3-francesco@dolcini.it>
References: <20230118122817.42466-1-francesco@dolcini.it>
 <20230118122817.42466-3-francesco@dolcini.it>
Message-Id: <167452324070.3116911.2276760222144588940.robh@kernel.org>
Subject: Re: [PATCH v1 2/4] dt-bindings: bluetooth: marvell: add max-speed property
Date:   Mon, 23 Jan 2023 19:22:42 -0600
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 18 Jan 2023 13:28:15 +0100, Francesco Dolcini wrote:
> From: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> 
> The 88W8997 bluetooth module supports setting the max-speed property.
> 
> Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  .../bindings/net/marvell-bluetooth.yaml          | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/marvell-bluetooth.yaml:29:8: [error] empty value in block mapping (empty-values)

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml: allOf:0:if: None is not of type 'object', 'boolean'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml: ignoring, error in schema: allOf: 0: if
Documentation/devicetree/bindings/net/marvell-bluetooth.example.dtb: /example-0/serial/bluetooth: failed to match any schema with compatible: ['mrvl,88w8897']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230118122817.42466-3-francesco@dolcini.it

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

