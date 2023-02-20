Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FAD69D1FC
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 18:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjBTRQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 12:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbjBTRP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 12:15:57 -0500
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A05199D9;
        Mon, 20 Feb 2023 09:15:56 -0800 (PST)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-17211366c6aso1748733fac.13;
        Mon, 20 Feb 2023 09:15:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=03mvMv3OBvjG3ElAvQ4qRAwM8DjYRN7O/uLbM3eCM4s=;
        b=Cs0ta0mbFWAmPKoH4bLZGhY3+H4zBC4Gjjju24QvsftIqM4KBmMVg0tPMvnhi8PGBQ
         ckzoezy6BJe8j0EHfJJY0k5liuFEYGvj2V/r+joWjSQYLV41ZEElr2G0wNNyyH1PZx28
         93uQPv5CQqv/e0DqO3ciAa7rHCBRcCpHq32TvHpIZdZxBri1TUV8oWDyW5N5jDI1MLPg
         JKblSoC0XSWMmFwuTSaBvVWP7He0F3mEEJgo9Z33WztgdumsBS+iA6T35PkDxLhEtSMq
         UgweP3CzRKu+EFOroPpLsUC+aoqhyLQ03eaOF3p+KwOR05tGQ1EAwN/AOIrG8WvGTB0t
         93Xg==
X-Gm-Message-State: AO0yUKX9PQQsJI4F6zpT7UQHgy4MR30cyzn5UiReluZM3j52EWzNFwcw
        pnw4qjZOkWj5VBxwuaZTo46JVV5+rw==
X-Google-Smtp-Source: AK7set8/7ONpY57pYHX9q0jBRtphSUDrp2r2g2sZBQkEX8p9zdLPkp5DBfMT0w2yng2j+2hTBvaInA==
X-Received: by 2002:a05:6870:d1d4:b0:16f:389a:d97b with SMTP id b20-20020a056870d1d400b0016f389ad97bmr6347136oac.46.1676913355649;
        Mon, 20 Feb 2023 09:15:55 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ec21-20020a0568708c1500b00143824af059sm4587738oab.7.2023.02.20.09.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 09:15:55 -0800 (PST)
Received: (nullmailer pid 3973202 invoked by uid 1000);
        Mon, 20 Feb 2023 17:15:54 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Jianhui Zhao <zhaojh329@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Felix Fietkau <nbd@nbd.name>,
        Russell King <linux@armlinux.org.uk>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        John Crispin <john@phrozen.org>,
        Paolo Abeni <pabeni@redhat.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
In-Reply-To: <03f9d40849dd2d563a93b27732a7b5d7dd1defc5.1676910958.git.daniel@makrotopia.org>
References: <cover.1676910958.git.daniel@makrotopia.org>
 <03f9d40849dd2d563a93b27732a7b5d7dd1defc5.1676910958.git.daniel@makrotopia.org>
Message-Id: <167691325732.3971281.4378006887073697625.robh@kernel.org>
Subject: Re: [PATCH v9 03/12] dt-bindings: arm: mediatek: sgmiisys: Convert
 to DT schema
Date:   Mon, 20 Feb 2023 11:15:53 -0600
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


On Mon, 20 Feb 2023 16:41:16 +0000, Daniel Golle wrote:
> Convert mediatek,sgmiiisys bindings to DT schema format.
> Add maintainer Matthias Brugger, no maintainers were listed in the
> original documentation.
> As this node is also referenced by the Ethernet controller and used
> as SGMII PCS add this fact to the description.
> Move the file to Documentation/devicetree/bindings/pcs/ which seems more
> appropriate given that the great majority of registers are related to
> SGMII PCS functionality and only one register represents clock bits.
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../arm/mediatek/mediatek,sgmiisys.txt        | 25 ----------
>  .../bindings/net/pcs/mediatek,sgmiisys.yaml   | 49 +++++++++++++++++++
>  2 files changed, 49 insertions(+), 25 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
>  create mode 100644 Documentation/devicetree/bindings/net/pcs/mediatek,sgmiisys.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/pcs/mediatek,sgmiisys.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/net/pcs/mediatek,sgmiisys.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/03f9d40849dd2d563a93b27732a7b5d7dd1defc5.1676910958.git.daniel@makrotopia.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

