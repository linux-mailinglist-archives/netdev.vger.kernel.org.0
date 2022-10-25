Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAFB60D530
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 22:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiJYUFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 16:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiJYUFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 16:05:05 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA501789E;
        Tue, 25 Oct 2022 13:05:02 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1324e7a1284so17134601fac.10;
        Tue, 25 Oct 2022 13:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vB32b7hqffV8RKafvwJiZ3CGSQiM2gKHX903Imkipag=;
        b=7CWaIeyPm4So2PRofN762Ph8nOHdXOH5jdz3EIcrl8Ly1L1ClNGV387ksqUYcE3MJg
         Qq9AzjctbGHPHYWB9Bs/HLjuQcY7ysAhRHler4qeExAhVrasy41vpdpUVZ2ISDNoKumj
         LvQI1SkRvJmBU85nyaRfR8dAF9TS1PcnbWXE9Y3dYG22Rd7lWIe6lWHAByghTkHjFJrb
         WUtoKb3UtV7CYJ8Q7zZanamP9r7yoR/zcNuV2xkzlgM4oeNpnYM9CoFA1mZvmTZTTB1g
         /MOVQBa7D4zPiD1xWYKutbgYINrOIkmtDrEDXQ/K21oa5DkSw2znfafnk8mHr0CJy/Bv
         7h2Q==
X-Gm-Message-State: ACrzQf2dHDnJwD/a89e9DMxBFSr6rh3IHNmlqB7ONYyZ7wlocHpZT3UX
        F2eB5mJ4+7VnYWTlugQjww==
X-Google-Smtp-Source: AMsMyM7iCwd1pVTnVpkPrTHLBKLtE87bCuRGb8WUI6j5d80nFpJ5ZRoJ/yfU55Rkz4J4Cc2IC6FkKQ==
X-Received: by 2002:a05:6870:c185:b0:137:5188:d2d7 with SMTP id h5-20020a056870c18500b001375188d2d7mr6381oad.296.1666728301917;
        Tue, 25 Oct 2022 13:05:01 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t6-20020a056871020600b0010d7242b623sm2049596oad.21.2022.10.25.13.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 13:05:01 -0700 (PDT)
Received: (nullmailer pid 3155077 invoked by uid 1000);
        Tue, 25 Oct 2022 20:05:02 -0000
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     =?utf-8?b?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-mediatek@lists.infradead.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
In-Reply-To: <20221025050355.3979380-4-colin.foster@in-advantage.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com> <20221025050355.3979380-4-colin.foster@in-advantage.com>
Message-Id: <166672723142.3138516.12575129595346889697.robh@kernel.org>
Subject: Re: [PATCH v1 net-next 3/7] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
Date:   Tue, 25 Oct 2022 15:05:02 -0500
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 22:03:51 -0700, Colin Foster wrote:
> The dsa.yaml binding contains duplicated bindings for address and size
> cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> this information, remove the reference to dsa-port.yaml and include the
> full reference to dsa.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml         | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/qca8k.example.dtb: switch@10: Unevaluated properties are not allowed ('#address-cells', '#size-cells' were unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/qca8k.example.dtb: switch@10: ports:port@6: Unevaluated properties are not allowed ('qca,sgmii-rxclk-falling-edge' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/qca8k.example.dtb: switch@10: Unevaluated properties are not allowed ('#address-cells', '#size-cells' were unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/qca8k.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

