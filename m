Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC3E6E4987
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjDQNMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDQNLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:11:34 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAD7BB8C;
        Mon, 17 Apr 2023 06:10:59 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id d1so6542819oiw.13;
        Mon, 17 Apr 2023 06:10:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681737035; x=1684329035;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VxzMSlWJqp0jC6TDxAVrz9kAacy8nE6CyreWMpO82qY=;
        b=TbEeth/d+Lh7X3cP079eim5YXZH1gp/ubS+M/EdEEmEr3ismKJZrQsYApY76Yeus+f
         7StSEJj7qqXVXAIRiy9mHUpd3+6TT7VKt/oLuAoOUZpMvSzBsrVR4K9cwWjBsZNRtVJf
         vgJ/AloTEGeaTVUNFc18nVMbG5lRQ6GY9FhXDaKaDQMBQ+yG0DgRQabKAh+CK5pQ87KE
         mk0MzNpOIzftWWojKTVbyIZyw4O8CpN3q56Hs1dXhcflfRl4ndhDkx6LICDJ+3Z58vmm
         idZim2BiOGErFZUOEo6Aym0tfv7tRo1Td/tQrOoleoQLcmR6F3jYIX9MUQbhMVdamNuK
         pPNQ==
X-Gm-Message-State: AAQBX9ce+Jc253AwUtTvXM9EJ1zngxWmgPvNT8u6Hc9EqPB3GBrYOdg1
        hqL72O3Ibfuee4J/0OlBSA==
X-Google-Smtp-Source: AKy350ZlGphdnLNiDveQNO6I/GKvTFb/FnKDX5Ft9E5IDzE2uMM2gZ+a2HIyvJqu2MA7klFBfhkVoQ==
X-Received: by 2002:a05:6808:bd5:b0:38d:e9e4:1ebd with SMTP id o21-20020a0568080bd500b0038de9e41ebdmr3351197oik.8.1681737035239;
        Mon, 17 Apr 2023 06:10:35 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r7-20020acada07000000b003895430852dsm4607496oig.54.2023.04.17.06.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 06:10:34 -0700 (PDT)
Received: (nullmailer pid 2588774 invoked by uid 1000);
        Mon, 17 Apr 2023 13:10:27 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        devicetree@vger.kernel.org,
        =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Eric Dumazet <edumazet@google.com>
In-Reply-To: <20230414212356.9326-1-zajec5@gmail.com>
References: <20230414212356.9326-1-zajec5@gmail.com>
Message-Id: <168173527510.2535500.15269428530497246338.robh@kernel.org>
Subject: Re: [PATCH 1/3] dt-bindings: net: wireless: qcom,ath11k: allow
 describing radios
Date:   Mon, 17 Apr 2023 08:10:27 -0500
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 14 Apr 2023 23:23:54 +0200, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Qualcomm ath11k chipsets can have up to 3 radios. Each radio may need to
> be additionally described by including its MAC or available frequency
> ranges.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../bindings/net/wireless/qcom,ath11k.yaml    | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.example.dtb: wifi@c000000: radio@0: Unevaluated properties are not allowed ('reg' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.example.dtb: wifi@c000000: '#address-cells', '#size-cells' do not match any of the regexes: '^radio@[0-2]$', 'pinctrl-[0-9]+'
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230414212356.9326-1-zajec5@gmail.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

