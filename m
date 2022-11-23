Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775F2634D26
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbiKWBfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbiKWBfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:35:37 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A34CEBA6;
        Tue, 22 Nov 2022 17:35:35 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id j12so15320490plj.5;
        Tue, 22 Nov 2022 17:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aMXbvTa4szYt2+pP730kENx9BC6mONDNIAJzOhCO5eY=;
        b=HP7scXWGWUuUAQpBHAbYGT9Ro4FSzBvlteLDZXmRtKIZTW83yQz3QCmZa2e1V2+0x2
         Pw8YRUKvoQ4DiaSm/YAu6wmnyNScBLJZbD3KIrABeA6kImnOgusYWOUmR/kcS0XT8B9P
         1cL+hQNaxyuve1DQLJxDEdiV3tM0KQavM9pnRQl5dkjJUDRmOiJmgk/Snwqtq9fbneJ6
         501XaE1hYWbuRd4jlIvX1PvZl9pGuG5KgjbXC0nzOtGgAQfzAquf1FCtOSuDF4D8vTiR
         HsFLOv794pyzG5OBIwR2N/Q8Yj34VkSutSr3XEu/KkJ6LoDgNdzwSB8kRI/bCqRFYG1b
         9wQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMXbvTa4szYt2+pP730kENx9BC6mONDNIAJzOhCO5eY=;
        b=YlUPdXzbgZYqF1RcSosrSg4MfBXlfGprXal93ClY7Me1E2ssWrnI5XN8VyF95S5Z6+
         X8UfD/Kgm8SbeStM/lcF83hZRfrWTpNnWT7Lu9O/1MFSJxQyFxTnt51WtSFzstjdFEuF
         BGCwQ6nshnPf1eL8UUsEWm1q25vPktaOpAGDfNzU9szYX5MU2/ctqK73WeFpTiR2SItB
         YfvJTr1fTMOMwtP32IDuc7+0FyDcFB6MwEsmtfK2fseF+vSwngSuluc38nKYER+Rt5lb
         D35erwDZxkZ3/5EBQnKQbDBbyxM+dKdsZzbCo5RJvenXdVeB6K1JuOyP4KV5G3IXnmcx
         iG1Q==
X-Gm-Message-State: ANoB5plE5kuIIpuHVdoYYjAXH81OF9pDFoXOdLQI2ValWlCaZj+glU7q
        u982P24odlkIVKtp1kqyUMY=
X-Google-Smtp-Source: AA0mqf6x4fc4IKvIExC1o1e46QIsOPFQfVNfDh9OQF6vDoU8m9LQB2uyX84qmPAg+ZnqxdiG9ViVXg==
X-Received: by 2002:a17:902:f391:b0:186:ac81:2aa9 with SMTP id f17-20020a170902f39100b00186ac812aa9mr6832869ple.95.1669167334579;
        Tue, 22 Nov 2022 17:35:34 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:af8d:6047:29d5:446c])
        by smtp.gmail.com with ESMTPSA id d7-20020a17090abf8700b00218e5959bfbsm52591pjs.20.2022.11.22.17.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 17:35:33 -0800 (PST)
Date:   Tue, 22 Nov 2022 17:35:29 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v2 6/9] dt-bindings: drop redundant part of title (end,
 part three)
Message-ID: <Y3144aAtCaejFDAC@google.com>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-7-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-7-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:06:12PM +0100, Krzysztof Kozlowski wrote:
>  .../bindings/input/touchscreen/cypress,cy8ctma140.yaml          | 2 +-
>  .../bindings/input/touchscreen/cypress,cy8ctma340.yaml          | 2 +-
>  .../devicetree/bindings/input/touchscreen/edt-ft5x06.yaml       | 2 +-
>  Documentation/devicetree/bindings/input/touchscreen/goodix.yaml | 2 +-
>  .../devicetree/bindings/input/touchscreen/himax,hx83112b.yaml   | 2 +-
>  .../devicetree/bindings/input/touchscreen/hycon,hy46xx.yaml     | 2 +-
>  .../devicetree/bindings/input/touchscreen/imagis,ist3038c.yaml  | 2 +-
>  .../devicetree/bindings/input/touchscreen/melfas,mms114.yaml    | 2 +-
>  .../devicetree/bindings/input/touchscreen/mstar,msg2638.yaml    | 2 +-
>  .../devicetree/bindings/input/touchscreen/ti,tsc2005.yaml       | 2 +-
>  .../devicetree/bindings/input/touchscreen/touchscreen.yaml      | 2 +-
>  .../devicetree/bindings/input/touchscreen/zinitix,bt400.yaml    | 2 +-

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

-- 
Dmitry
