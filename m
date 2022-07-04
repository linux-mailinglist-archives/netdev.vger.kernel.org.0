Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18CF5652E1
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbiGDK7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiGDK7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:59:01 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A97A1027
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 03:59:00 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o16-20020a05600c379000b003a02eaea815so6471841wmr.0
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 03:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LLYbxrZtIqfELBGb4abToz3pncc8eBo0EcrsRbqn6h4=;
        b=E/BApPeUVGI9ICTP2Guwsd/BSF96qPqrw1LrbDKXmQPx/xE/ig3iSHH9yjwSQxCQF6
         TaS750DYCNsRX19zIOvD18HYg3dfm4i5FDtgweNj3a/ksI81HJL45czbU9wn43ICs4EH
         t7hc0LvBEJebbUgPC09uNlHHUlhWkrIkGu5Fr7IMhV73OjrwyI5AS02uZcMK6fOnWLM4
         NHz2ZOHg2R117kAr3iK/paeworG0WrP3zxmacu7l7DV/i08n5lFCuBuSDxmf55ZVqdIw
         8x7wwugGuGfunM0S7iaZR5PT8+W1o8t8cG/VJRyegt4ZjqcqqUdJOANn9lel30jnx3NL
         yo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LLYbxrZtIqfELBGb4abToz3pncc8eBo0EcrsRbqn6h4=;
        b=B1RkeyMU1uoE61124+F4gacj25vlqUFhoNn1pIUI3AZwa6GNIWM0QaMgkdgsdpWtr8
         b3itmpoVaSqRicHNCqiSiX+S0RiiMRSk1HDu4RsJxvlPDMlevZc/DcEBjxFqrCQXQaM6
         4+37YFRYvzkdRgV+cdWaRfFfo4r3byN86qgDBwC3TLTPLB/WuUEa20zZI6TjlFsZmAHn
         nDt5ugm9cB5AbncMUNH8jZ6rNFJO0tGeL+0SjFUasoE6EQutZuf3ondRZRKdtb0PDnTp
         hwSCQ4l1DRxjVr3IIvmifJwV4HI+8Z7K41JdAeOW9E5x8VgZl0sMw69uttYXQLOfjm+z
         TQZw==
X-Gm-Message-State: AJIora8a75zhA7i3Oq5KQ+wOB3OXSM3zSwACz3ewPAdG/VmPhv8LbMNo
        iEy/nViTwMH9VMFOGx9EgmU85e+oUGX4Iw==
X-Google-Smtp-Source: AGRyM1sVgWrqJrM6Wz6XZqjJEMcIpjkNMYwcvTKHCtG3UbEwjJ7tiIlfsNRw9XaVGLgoWIX0Xt0YsA==
X-Received: by 2002:a05:600c:203:b0:3a1:9726:ad85 with SMTP id 3-20020a05600c020300b003a19726ad85mr11247742wmi.180.1656932338677;
        Mon, 04 Jul 2022 03:58:58 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id x2-20020adfdd82000000b0021d62e30a62sm5901474wrl.50.2022.07.04.03.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 03:58:58 -0700 (PDT)
Date:   Mon, 4 Jul 2022 11:58:56 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: Fix spelling mistakes in documentation yaml
 files "is is" -> "is"
Message-ID: <YsLH8EOwVG+oqFGS@google.com>
References: <20220704105307.552247-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220704105307.552247-1-colin.i.king@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 04 Jul 2022, Colin Ian King wrote:

> There are several occurrances of duplicated words "is" on the documentation
> yaml files. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml   | 2 +-

>  Documentation/devicetree/bindings/mfd/ti,lp87524-q1.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/ti,lp87561-q1.yaml       | 2 +-
>  Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml       | 2 +-

Can you separate these out please Colin.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
