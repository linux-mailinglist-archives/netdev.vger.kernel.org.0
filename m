Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50726663DD2
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbjAJKQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238093AbjAJKQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:16:25 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330254701
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:16:23 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id i17-20020a05600c355100b003d99434b1cfso9460990wmq.1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3L27Tq0zbzDL8sJQqF4D7IRFPQYRZAeU4qqoSPa895w=;
        b=u+x71yWS7I4oEXf8ozRcyFMecHvQvUknvdG2mG0PJAu04pG9XXthULtoY1W0q94kCT
         d7DlnxcZ3zXHjz3tCvR+V7R0vGgabFih7QQ0ZICKmNK25Xx2KCBWdHBglGa2TtcHvYCw
         i1PHi3FscBHvdfF7v25N/FENMcx3/FGjIcJPuxqpp59Gwq+y/MyNXqKi9sWENqwmpXxK
         3BgfTBvTCcEcYxPkKgaNIsrgcjekdnRmViT/flYASi8HCn7wPiReR5wTM6Y4C1n9IE+9
         Lo/Ham7HrbuO9nRWnGB1VygmYL7yBAlKmKoLq0hm1fTGQcolWwK9CMshzO2w8/ekD6g2
         shmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3L27Tq0zbzDL8sJQqF4D7IRFPQYRZAeU4qqoSPa895w=;
        b=O5oSStCs+QDwFbWhvVCDtaa6hWHd82iXhQSuUuh/WYi5NX77zD/88XZVr+tCPe78a7
         JpfhyelaKUTA+3SgJoAepB7y9e7zNZHtAIVSV0/gEp4nj/603oqD53jU+Ll/pd9SS1Im
         nW1mLQo9ScH0p/+p5KZKXyupKfXnXV/wdY1jokvMpN0L0tXmCqJ+qcn66+ev1aMVDLBZ
         ohWN8GDvaJgYYJbh6C3/rxbQv81SNIJ7DK2dhnqPNDy0KrDxirLMRmOgzbekteXNx2gM
         JQRLlQTktU+vYH8ufLEFmArnR2Z0BP5xMzDWjV7wDdbdleD1jtTmAysA+aNInh0KkFl+
         gHFg==
X-Gm-Message-State: AFqh2kr7vXt24C8PcBB80seuZq5TMTqtOgTeJI5ampLaoM/eYFncSjMP
        OUiw91sMjUg5PQf9gyTwxAL7Ww==
X-Google-Smtp-Source: AMrXdXuMfssSJSDgb250kz9/lLtQ3vu6O7DHG+aAwgcWVuQ1GLx8a400gxZwi0nru+BFE3w6dTyBEQ==
X-Received: by 2002:a1c:4c0e:0:b0:3d9:f836:3728 with SMTP id z14-20020a1c4c0e000000b003d9f8363728mr1386982wmf.11.1673345781647;
        Tue, 10 Jan 2023 02:16:21 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id l14-20020a05600c4f0e00b003d96c811d6dsm20468474wmq.30.2023.01.10.02.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 02:16:21 -0800 (PST)
Message-ID: <39bf0a6f-6e43-c7e1-07c2-c5c5113c1e50@linaro.org>
Date:   Tue, 10 Jan 2023 11:16:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 06/11] dt-bindings: power: amlogic,meson-gx-pwrc: mark
 bindings as deprecated
Content-Language: en-US
To:     Neil Armstrong <neil.armstrong@linaro.org>,
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
 <20221117-b4-amlogic-bindings-convert-v2-6-36ad050bb625@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v2-6-36ad050bb625@linaro.org>
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

On 09/01/2023 13:53, Neil Armstrong wrote:
> The amlogic,meson-gx-pwrc-vpu compatible isn't used anymore since [1]
> was merged in v5.8-rc1 and amlogic,meson-g12a-pwrc-vpu either since [2]
> was merged in v5.3-rc1.
> 
> [1] commit 5273d6cacc06 ("arm64: dts: meson-gx: Switch to the meson-ee-pwrc bindings")
> [2] commit f4f1c8d9ace7 ("arm64: dts: meson-g12: add Everything-Else power domain controller")
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  Documentation/devicetree/bindings/power/amlogic,meson-gx-pwrc.txt | 4 ++--

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

