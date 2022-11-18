Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F45462F821
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241158AbiKROtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241657AbiKROtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:49:07 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECCD193C3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:49:05 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b3so8576734lfv.2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+xECLjM+1wJ3tyU5u/WQawVGRXnB8gHjb6MLiqzOmuE=;
        b=Zs12YmMMSavyYzmNqKcCRYMCcx5tO7qpQ0VvE7hyvFNBku6wyFMWhXNVMlF+Sqg0KT
         WoIA+w4A8iuBJ/Z1AAHH4aIRydfpKhe7bF24gwy0bRzlEk0jYncnokHI+00AlKhVfGXV
         JIIp3E5uA+gM7soG5wopEU+Lv1q63Zy9Cg91suTl/dBPE5V24XVYczE01kWsKEHVfQGb
         dBT162Z4F1TG+7XSK0OcZOSsHy+CA846o55K/WA07GJriE9bcEJQUbPZyZbcV94cF4R/
         VfK+gBKT/TkzM9E9oq25330xsTCuei+8omVXqqLIW5R7KPXHwfeYtmnlKBMLd61OMOgq
         UpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+xECLjM+1wJ3tyU5u/WQawVGRXnB8gHjb6MLiqzOmuE=;
        b=MCJXJPpmk+MDRXzzRhq/6+j3SzbBrYFtcbHP2zdDxW+feWAX8o7lPhwuSnLn+I8kI9
         SgGWr8LerI/Fyw4GtU+3LpB9Myw+wbshrM5VOpJ5cm1UytYz8muCurtuT2f31Lnn9ddK
         sTmKdbptM8s7x3zIiOaUZVWlUwR9xc4lnhgbjytwB8Dy1661i0rpy63PDeiutZ7ypYTM
         vbcqsoPX4YSJPgpYCAOzPJYfGdKO81/qgbpnOUXRCIzOHyAchyBoPFRWCBTb4K+AvRKS
         c6pMVfzV31EnbEVPyqFUMCipthmSwvDl48SYDzXtA/IqXIiK6Slt9EdNy0oTzRAFici+
         XfLw==
X-Gm-Message-State: ANoB5pkk48Fn+Yhx62BinvUdrHlZcsB0JXk6TJa+VzCcwKIbiTIhiea9
        PVTzJ/DkgqbR5M2wVOoxj9pz0Q==
X-Google-Smtp-Source: AA0mqf7ZXIKPBh9Rz/8NI/J74R1K82UMSY4YzepugR6KIDjTrCZkpyZFe0babnYb4sjivNlfYP6QJQ==
X-Received: by 2002:a19:5019:0:b0:4b4:8d47:7057 with SMTP id e25-20020a195019000000b004b48d477057mr2868955lfb.376.1668782943480;
        Fri, 18 Nov 2022 06:49:03 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id h3-20020ac250c3000000b00492c463526dsm685909lfm.186.2022.11.18.06.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:49:03 -0800 (PST)
Message-ID: <24296f7d-416d-e5f5-ef6a-c960b59513cb@linaro.org>
Date:   Fri, 18 Nov 2022 15:49:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 04/12] dt-bindings: watchdog: convert meson-wdt.txt to
 dt-schema
Content-Language: en-US
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-4-3f025599b968@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-4-3f025599b968@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/11/2022 15:33, Neil Armstrong wrote:
> Convert the Amlogic Meson6 SoCs Watchdog timer bindings to dt-schema.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

