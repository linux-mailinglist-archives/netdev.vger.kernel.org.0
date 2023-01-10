Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE19664320
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbjAJOVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbjAJOVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:21:02 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6C7D2D1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:20:59 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id az7so11919126wrb.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wOlYhsSTVgaYdm2eFZoziUvSeaqxeeC4ypm2ZU+u8E=;
        b=kszY69SppzG5Jtt72RWEpPxfZlA++8X+pe4zSpoGzWxZpDO7QjiSUYnre1WyViXAY7
         1iiWRER6HTf6S2w06VNjW9Ek+hfRQxFAU+/IYMI4W4YWwDhrsDtawi7DyBoI6gmGKm1Q
         0+M2MSORAbu8Ba6hwMxISTSe0WTxhTarMF2tgaST8lj4/7xgaDp2/UaXzPEnYNOvOUij
         EPtqNQR2mhoWaHmxONo3dIvRyX7TdO2y6b3ggnCU0qrh6EVfI1aR/JngbZyGd/hTd9+p
         fp43ISUfXPVH4FIk9xYvMeXzZgYFgvbb1N8ezsuiPAXvtlpEWMj2ixCYsKm1FqG4HLpU
         Mvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8wOlYhsSTVgaYdm2eFZoziUvSeaqxeeC4ypm2ZU+u8E=;
        b=TZbF/W96GoBuQJ/9NRAxJdliHhmt9+WJ78DYaXKZDV4uxWcu6mlCyKpw96ht1kms5K
         Z5LYqVj8bUOUeaM61S8Cn2CPKs1SoZbqUXibSJNqLfvDQQD33Xuo7uw+1/VF7cOlGeZS
         n6vAGaGkdclXtsBmBhIlq1Slq2WdfYmRwZp8vg4sKfksjWiek0PSZ8KWMtKIEEwOnHg3
         n6+Omb1acyjOcDxw4NYLMYkHQxRaSLZBSpF9H4LAfKACjsaPSPJD3YBWwbbe4fSzdgVX
         VizdmWtBR86sIXAqkTL4RprwTY1dnouCcSr7byA6lDrJ8yj/N2rG5KiZ2sGCxeXlTkhs
         5x9Q==
X-Gm-Message-State: AFqh2kpMLuJBGuBzd4eZPoRu5wV22750mPfyQnX2gpCxBMbP63iR4AIk
        9/1RHOH1dBW4Ce67eh+b3WZGIg==
X-Google-Smtp-Source: AMrXdXsGPm+Lqm6jdep1fxgzxJDhDVBWyqAyOyD8u4pWy8z+Ow8K31O4z7YtMI4EBCBZ0cS02zAcVQ==
X-Received: by 2002:a5d:4bc9:0:b0:2bb:ebaa:7ae1 with SMTP id l9-20020a5d4bc9000000b002bbebaa7ae1mr6343276wrt.50.1673360457917;
        Tue, 10 Jan 2023 06:20:57 -0800 (PST)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id z2-20020a5d6402000000b00297dcfdc90fsm11284992wru.24.2023.01.10.06.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 06:20:57 -0800 (PST)
From:   Neil Armstrong <neil.armstrong@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
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
        Neil Armstrong <neil.armstrong@linaro.org>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
Subject: Re: (subset) [PATCH v2 00/11] dt-bindings: first batch of dt-schema
 conversions for Amlogic Meson bindings
Message-Id: <167336045651.1961204.1502592666018702430.b4-ty@linaro.org>
Date:   Tue, 10 Jan 2023 15:20:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 09 Jan 2023 13:53:25 +0100, Neil Armstrong wrote:
> Batch conversion of the following bindings:
> - meson_sm.txt
> - amlogic-efuse.txt
> - amlogic-meson-mx-efuse.txt
> - meson-wdt.txt
> - meson-ir.txt
> - rtc-meson.txt
> - amlogic,meson6-timer.txt
> - meson-gxl-usb2-phy.txt
> - amlogic,meson-gx.txt
> - amlogic,meson-pcie.txt
> - mdio-mux-meson-g12a.txt
> 
> [...]

Thanks, Applied to https://git.kernel.org/pub/scm/linux/kernel/git/amlogic/linux.git (v6.3/drivers)

[01/11] dt-bindings: firmware: convert meson_sm.txt to dt-schema
        https://git.kernel.org/amlogic/c/658a8ef679435959f550a45f7312afaebb9e20a8
[06/11] dt-bindings: power: amlogic,meson-gx-pwrc: mark bindings as deprecated
        https://git.kernel.org/amlogic/c/bc5998b92b9ee8818cc0f7fe02604751389a154e

These changes has been applied on the intermediate git tree [1].

The v6.3/drivers branch will then be sent via a formal Pull Request to the Linux SoC maintainers
for inclusion in their intermediate git branches in order to be sent to Linus during
the next merge window, or sooner if it's a set of fixes.

In the cases of fixes, those will be merged in the current release candidate
kernel and as soon they appear on the Linux master branch they will be
backported to the previous Stable and Long-Stable kernels [2].

The intermediate git branches are merged daily in the linux-next tree [3],
people are encouraged testing these pre-release kernels and report issues on the
relevant mailing-lists.

If problems are discovered on those changes, please submit a signed-off-by revert
patch followed by a corrective changeset.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/amlogic/linux.git
[2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
[3] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

-- 
Neil
