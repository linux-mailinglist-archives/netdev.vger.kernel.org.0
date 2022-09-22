Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26515E69A3
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiIVR30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiIVR3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:29:24 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630F5105D4F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:29:22 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id b6so11810463ljr.10
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=CvZGODSHXfe2qDQBF8M0YqQ7IJQUTtK3MjZMfL5pJoU=;
        b=wyxLufnOxJgOp9zOszeHuEx4JwfK3vKMV8AkSc+h4Vn5LHGX7nt31zfR9uA48gGZX1
         aO/ZnG2uDhDAIXqL/XDfngkbXbLa7XJbwR71f5rkcq9rICmzHxWg2vo/ccATfw4iPYTm
         iBAs4JQ492Si5hZGH5hfwmNRpk7lpnz+c4/2MkXScoqRDxipV+CeMFFbFUvzR1v9QWea
         N8v7BJfkQ9N+ykvby0qiLGlD3mPqiS0TQepb6ZXsXxPz/XBZoMBmYPBYzVAhXEFvH8uP
         GfC08+c6tTRKnPJxBBfhoZzUuUPeIklTSqLrFiMZvVkLxJrFkdtgH43x+t3AvGII4YC1
         1tSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=CvZGODSHXfe2qDQBF8M0YqQ7IJQUTtK3MjZMfL5pJoU=;
        b=fyZRMwtVyW2Xt+PQ8mRqivR3DUL3NZsP91TgjxyAXdL2G6T1Md/JGPie8B8UEK4dIW
         qsHCujAvzlzSeZDO6xFm3+7NpVgoXdmzTJQU8xWG9X0wLGFALimAAp390QdFSxiUEmgV
         oGX/4KADc+7Vnl1igha3yUhNBDaaFzD7V/T7zYUSASZ1JJwFTsxVGnbpIb6wKZ4rg1X3
         mnww6TsJuvF3Dbs9NQFhALWeevkkzqKiEyRGQQwC6F4Q1X/ODvFmCHPwwh4e4ldKQCFx
         F7lOhxIKsmRIooGmBRCKP+L9EaoshcQzao30jE8Hbpov98wmEbl598HGSJC55wFnqt1Z
         Ku4g==
X-Gm-Message-State: ACrzQf3oEHVdMP4IH216grsorcWLACnbDgSHYjmv5uvmUVFYnVkgm34e
        U75XApTTT/G0Dr7tYjAsFGXmYg==
X-Google-Smtp-Source: AMsMyM47meZ9OSO5xTf8YhjmWCydR+psTRg8aw/prbjr/EGxY8a51Szfl1ryDQSMv61sDC5b9YA5iQ==
X-Received: by 2002:a2e:bc04:0:b0:26c:5e:c186 with SMTP id b4-20020a2ebc04000000b0026c005ec186mr1564145ljf.118.1663867760677;
        Thu, 22 Sep 2022 10:29:20 -0700 (PDT)
Received: from krzk-bin (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id u16-20020ac248b0000000b00498f871f33fsm1032905lfg.86.2022.09.22.10.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 10:29:20 -0700 (PDT)
Date:   Thu, 22 Sep 2022 19:29:18 +0200
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [internal][PATCH] dt-bindings: dsa: lan9303: Add lan9303 yaml
Message-ID: <20220922172918.hsvqgiipj5wiuz5k@krzk-bin>
References: <20220922152438.350-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220922152438.350-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 10:24:38 -0500, Jerry Ray wrote:
> Adding the dt binding yaml for the lan9303 3-port ethernet switch.
> The microchip lan9354 3-port ethernet switch will also use the
> same binding.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
>  .../devicetree/bindings/net/dsa/lan9303.txt   | 100 +-----------
>  .../bindings/net/dsa/microchip,lan9303.yaml   | 143 ++++++++++++++++++
>  MAINTAINERS                                   |   8 +
>  3 files changed, 152 insertions(+), 99 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/microchip,lan9303.example.dtb: switch@0: Unevaluated properties are not allowed ('mdio' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1681194

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.
