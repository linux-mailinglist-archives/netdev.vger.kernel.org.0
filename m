Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0498657D432
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 21:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiGUTf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 15:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGUTfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 15:35:24 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5511115D;
        Thu, 21 Jul 2022 12:35:22 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id e69so2147643iof.5;
        Thu, 21 Jul 2022 12:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wELlNsbxx1+JCD9yf/xGA7zb/NOKO+vQi/OmtkVLBls=;
        b=vFJBPG4Y+An9/WyTBNgDAdNXiwfKwXBJMrRS39tMIj4k8O5GoP/o0f5F6isbPfMtfM
         O7ZryzZO/WsB5yqDa0+21vAGidp0B5FE7XI3DC8AXvc3StAzVGhDku6+MQwP1XJ6BZ8F
         5Xnr/d+DyYcLm3dgtvoJQpzZuajC6rDs0uWUMUk6A6lplBoAJcX9mzsxv0HWyitxDB+h
         J1y9oSd7//jUNuOFpmiLSiZwsuHKLJTduG2LS9Dqewzk0TeKL6rmtPtJVLGn2mih5PT6
         +Q6nzsRShoGKsP9COCBQ7BPGPivGo/rbCAeotgODMoNw0oECvnpYJpxERyMlaUjY5Z99
         hEVw==
X-Gm-Message-State: AJIora/ObO0uqo64xB5uzpk2eZgVL7eX/mNOmyay8bPf1+TN7eby4zJt
        Mf070N4RpyW74AJ66Sbf7g==
X-Google-Smtp-Source: AGRyM1sZvXpaofV6KHrP6nEJBBOrB/+dB8AwbfGYEa2h8d3D2/C7aFPfZcwL3IFjDFf1dLcaryTpdg==
X-Received: by 2002:a05:6638:15ca:b0:33f:594a:52ba with SMTP id i10-20020a05663815ca00b0033f594a52bamr35159jat.217.1658432122023;
        Thu, 21 Jul 2022 12:35:22 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id a70-20020a021649000000b003415545d938sm1107557jaa.166.2022.07.21.12.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 12:35:21 -0700 (PDT)
Received: (nullmailer pid 1799145 invoked by uid 1000);
        Thu, 21 Jul 2022 19:35:16 -0000
Date:   Thu, 21 Jul 2022 13:35:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Markuss Broks <markuss.broks@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Tomislav Denis <tomislav.denis@avl.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Nishant Malpani <nish.malpani25@gmail.com>,
        Dragos Bogdan <dragos.bogdan@analog.com>,
        Nuno Sa <nuno.sa@analog.com>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Christian Eggers <ceggers@arri.de>,
        Beniamin Bia <beniamin.bia@analog.com>,
        Stefan Popa <stefan.popa@analog.com>,
        Oskar Andero <oskar.andero@gmail.com>,
        =?UTF-8?Q?M=C3=A5rten_Lindahl?= <martenli@axis.com>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>,
        Cristian Pop <cristian.pop@analog.com>,
        Lukas Wunner <lukas@wunner.de>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Matheus Tavares <matheus.bernardino@usp.br>,
        Sankar Velliangiri <navin@linumiz.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Stefan Wahren <stefan.wahren@in-tech.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 5/6] dt-bindings: net: explicitly list SPI CPHA and CPOL
Message-ID: <20220721193516.GA1798385-robh@kernel.org>
References: <20220721153155.245336-1-krzysztof.kozlowski@linaro.org>
 <20220721153155.245336-6-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721153155.245336-6-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:31:54PM +0200, Krzysztof Kozlowski wrote:
> The spi-cpha and spi-cpol properties are device specific and should be
> accepted only if device really needs them.  Explicitly list them in
> device bindings in preparation of their removal from generic
> spi-peripheral-props.yaml schema.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../devicetree/bindings/net/nfc/marvell,nci.yaml     | 12 ++++++++++--
>  .../devicetree/bindings/net/vertexcom-mse102x.yaml   | 12 +++++++++---
>  2 files changed, 19 insertions(+), 5 deletions(-)

This too should not be needed.

Rob
