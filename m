Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9066777A1
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 10:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjAWJqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 04:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjAWJqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 04:46:20 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A598621946
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:46:18 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id q5so5534650wrv.0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=60INGmxwRr+8yD/I9JtxQHZJy+MthHAPjebxgVXSq4A=;
        b=F1RmlI6Jr+ymKyy8lqwEzZBkmqqB13nNXYBYvHtOeWRGeqsuz7xzXBmaWhSw3I8Ebm
         TcBhF+tktlNXSXYa7GGd+4cSp7Mx1MA292zlI/YBhsesf8m2OPtOBU4CzkRYYDY+VJKD
         rZKktCGYO6MieFBnhFrnXP96yNjjCazN4NtubEGY3US83//z/ammPRj/L4Pxrc2Z6tmr
         QKPZ+KdqFIhF4uxc434VoygrrqrdBU0wTWSgMlQyI+fyCqgR08BCpwX5nBT4NXsRkGFu
         8nu27yExklJVwN9h22VU1oVuSZqcQ+pTlG/IoT6VZa6i92mv0KfUGLb3dqJ4/aHoExHh
         cArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=60INGmxwRr+8yD/I9JtxQHZJy+MthHAPjebxgVXSq4A=;
        b=hwkgT8qmfuihVQF9vq0xfPNsE4YTKRLxUAG+UzclTxYQ+F9yLYcNiU1DCCAVp/TKZ6
         1QZuuqurlFiuBckrcYm7YjGnts56GEerqSlhPy2ZHo+0kTFdZj6AZN/m3g7H8HwcSA1f
         Un3ohk+9TNTBXUiEK6ANS7pbvQN7dVEiiJDqWhsIFFGQgnpQ2ojV7QzDKuXxvgHt1pMJ
         v6KkyC9Lcx58QBFGflGNlWMgq+OngdW/8gnD6CPpwC0xInpijm7VcqoDwgrg9OA7zu+U
         N6SbvtyJlgThQOoa1RF48aaGzSDC6rVMIhkuvJsUALVCvH/zDE1cVfNtMluABfmTCmSA
         /zkg==
X-Gm-Message-State: AFqh2kqyV/Moz8j3HAemQGpWGX7zto3+M9pSodHror8dDrgbdv/JJTRx
        ZWALdEtqV+dJ7WLPj2QKJIGBxw==
X-Google-Smtp-Source: AMrXdXuHEVHo54bmjGJT3gC7SenPuHW6sVZSyn52AJ8UqKixwTSKOJoGk+qB0zPe/lhc1Ohi58pW5Q==
X-Received: by 2002:a05:6000:98d:b0:2bd:c6ce:7bfb with SMTP id by13-20020a056000098d00b002bdc6ce7bfbmr23917833wrb.28.1674467177213;
        Mon, 23 Jan 2023 01:46:17 -0800 (PST)
Received: from [192.168.7.111] (679773502.box.freepro.com. [212.114.21.58])
        by smtp.gmail.com with ESMTPSA id q12-20020adff50c000000b002bc83b85180sm7139415wro.114.2023.01.23.01.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 01:46:16 -0800 (PST)
Message-ID: <c590a842-0074-8f19-6bc7-5de101a88661@linaro.org>
Date:   Mon, 23 Jan 2023 10:46:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 10/11] dt-bindings: PCI: convert amlogic,meson-pcie.txt
 to dt-schema
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
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
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20230110150328.GA1502381@bhelgaas>
Organization: Linaro Developer Services
In-Reply-To: <20230110150328.GA1502381@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2023 16:03, Bjorn Helgaas wrote:
> Is this the same sort of conversion done by one of these?
> 
>    e4dffb674cfd ("dt-bindings: PCI: tegra194: Convert to json-schema")
>    075a9d55932e ("dt-bindings: PCI: qcom: Convert to YAML")
> 
> It's helpful to non-experts like me if the subject lines use similar
> style (capitalized) and similar terminology ("dt-schema" vs
> "json-schema" vs "YAML").

Yes and honestly, I don't know what's the right name to use.

I use dt-schema since it's the "official" name of the tool
used to validate those.

> 
> On Mon, Jan 09, 2023 at 01:53:34PM +0100, Neil Armstrong wrote:
>> Convert the Amlogic Meson AXG DWC PCIE SoC controller bindings to
>> dt-schema.
> 
> Some references here and below are "PCIE" (inherited from the
> original) and others are "PCIe".  Could be made consistent here.

Ack

> 
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
>> ---
>>   .../devicetree/bindings/pci/amlogic,axg-pcie.yaml  | 134 +++++++++++++++++++++
>>   .../devicetree/bindings/pci/amlogic,meson-pcie.txt |  70 -----------
>>   2 files changed, 134 insertions(+), 70 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/pci/amlogic,axg-pcie.yaml b/Documentation/devicetree/bindings/pci/amlogic,axg-pcie.yaml
>> new file mode 100644
>> index 000000000000..a08f15fe9a9a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pci/amlogic,axg-pcie.yaml
>> @@ -0,0 +1,134 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/pci/amlogic,axg-pcie.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Amlogic Meson AXG DWC PCIE SoC controller
>> +
>> +maintainers:
>> +  - Neil Armstrong <neil.armstrong@linaro.org>
>> +
>> +description:
>> +  Amlogic Meson PCIe host controller is based on the Synopsys DesignWare PCI core.
>> ...

