Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9B5664304
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbjAJORw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbjAJORm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:17:42 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C33F5688B
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:17:38 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g10so8903571wmo.1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eHZb7U5oDjEwOOYPDL1qKh2dxxJE4/1ANjgPMf5V1yY=;
        b=fTRvcYCK+eENINzdvpT5NHT0wfYm1n3I5kSok/46mEYtVclqXC7smkLGa3XIEa74h8
         pa7vm2MsAjsI/cBelw5bGsc9I2eqetFlYlumH4/lm4MrpkqG9t+Yo0qdg5Wnaa5ROnk+
         jk5if7eruDCSwTvNARxIO86xgemjnjk0GsLpdYo148YKsCWzHsOmV0v7ExzDydbgMmjB
         xBEDTBdANuYQT914B1YF5HhzI8DZFH0C2v3VudioXDxD6KAU63mcGUTJkptYXI3ghV99
         jzEBpM1Oh0TlusLugEYK7urTdrOuYWsOoldXD7wFgQwqC6XBXhxwFnxQYHc85Xv7KEWj
         Y/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eHZb7U5oDjEwOOYPDL1qKh2dxxJE4/1ANjgPMf5V1yY=;
        b=Z8g1+X4L5Jl/vlY5tbDwK8syJYkx+SpYqO2yODtcAHdI7cWAjxBLlQ84s4AkT6k/i3
         fxLbiJxeI7C70s5iBu9wW0KzPtSZjdzqwV1+jaqdfcFEw4bBu/uQxAHu/nHL1UY94lGZ
         NBSaHD1csrhUg3yH9UWQqQMGWc9TZ384xN0fHVkGdRtGZCst6YCL1JdQ2/igT1PmEDI3
         ncod51iNSpyo8TxQXQGFVspic0J+xBRnT46r8swz8OBdWYCqgGskzLztrsUYBmtJvVzg
         xhVqgZNSTBqXSjlcOv0eJtPNPDeToBq7KAHrN1WqwJeDucWqcNbO2sgZ20AlR5pR0kie
         3HtA==
X-Gm-Message-State: AFqh2kqkDaEUY6wwl06Kh9JvIEfylpn37OyQ1Bp6dPjC1E+LsU14hLW0
        Pwu2RGHQMZ0I/vm1rLLrPanFEA==
X-Google-Smtp-Source: AMrXdXuqOXk2/au6P9zSAZ1Xnbpze8DuH91lBlkaSOKHoQSBiUFp/tny1iYv4yZOeDxUI/obplpd0Q==
X-Received: by 2002:a05:600c:1f12:b0:3d2:267d:64bd with SMTP id bd18-20020a05600c1f1200b003d2267d64bdmr59388593wmb.3.1673360256638;
        Tue, 10 Jan 2023 06:17:36 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:26cc:e5e1:3044:b226? ([2a01:e0a:982:cbb0:26cc:e5e1:3044:b226])
        by smtp.gmail.com with ESMTPSA id t12-20020a05600c198c00b003d9de0c39fasm18780848wmq.36.2023.01.10.06.17.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 06:17:36 -0800 (PST)
Message-ID: <2037156d-5113-4b96-8f86-c8ef1c1fdf96@linaro.org>
Date:   Tue, 10 Jan 2023 15:17:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 09/11] dt-bindings: mmc: convert amlogic,meson-gx.txt
 to dt-schema
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v2-9-36ad050bb625@linaro.org>
 <e3d32fe1-9f2b-09fb-d7e0-2c8f42e5365c@linaro.org>
Organization: Linaro Developer Services
In-Reply-To: <e3d32fe1-9f2b-09fb-d7e0-2c8f42e5365c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 10/01/2023 11:17, Krzysztof Kozlowski wrote:
> On 09/01/2023 13:53, Neil Armstrong wrote:
>> Convert the Amlogic SD / eMMC controller for S905/GXBB family SoCs
>> to dt-schema.
>>
>> Take in account the used variant with amlogic,meson-gx-mmc.
>>
>> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
>> ---
>>   .../bindings/mmc/amlogic,meson-gx-mmc.yaml         | 75 ++++++++++++++++++++++
>>   .../devicetree/bindings/mmc/amlogic,meson-gx.txt   | 39 -----------
>>   2 files changed, 75 insertions(+), 39 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml b/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml
>> new file mode 100644
>> index 000000000000..30228964fd9c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mmc/amlogic,meson-gx-mmc.yaml
>> @@ -0,0 +1,75 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/mmc/amlogic,meson-gx-mmc.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Amlogic SD / eMMC controller for S905/GXBB family SoCs
>> +
>> +description:
>> +  The MMC 5.1 compliant host controller on Amlogic provides the
>> +  interface for SD, eMMC and SDIO devices
>> +
>> +maintainers:
>> +  - Neil Armstrong <neil.armstrong@linaro.org>
>> +
>> +allOf:
>> +  - $ref: mmc-controller.yaml#
>> +
>> +properties:
>> +  compatible:
>> +    oneOf:
>> +      - enum:
>> +          - amlogic,meson-gx-mmc
>> +          - amlogic,meson-axg-mmc
>> +      - items:
>> +          - const: amlogic,meson-gx-mmc
> 
> This does not look correct. Either gx is alone (not compatible with
> gxbb) or it is compatible with gxbb. Cannot be both.

This ishow it's used in DT:

arch/arm64/boot/dts/amlogic/meson-gx.dtsi:                              compatible = "amlogic,meson-gx-mmc", "amlogic,meson-gxbb-mmc";
arch/arm64/boot/dts/amlogic/meson-axg.dtsi:                             compatible = "amlogic,meson-axg-mmc";
arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi:                      compatible = "amlogic,meson-axg-mmc";

So I'll drop the amlogic,meson-gx-mmc in the first enum to have :
+properties:
+  compatible:
+    oneOf:
+      - const: amlogic,meson-axg-mmc
+      - items:
+          - const: amlogic,meson-gx-mmc
+          - const: amlogic,meson-gxbb-mmc

It's right ?

Neil

> 
> 
> 
> Best regards,
> Krzysztof
> 

