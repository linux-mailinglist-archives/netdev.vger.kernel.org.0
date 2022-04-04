Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE024F1ADB
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379242AbiDDVTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379193AbiDDQmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:42:52 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C6435855
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 09:40:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id u9so6700303edd.11
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 09:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qq86fHdQFBYDGBq4SciqKEleN++5Ao+l5cvatAfZpnA=;
        b=MXcyu0hReAsgYMSnOPJYIwUQWZ+3yaoTlqnh+LuV6Fi1mAfTSP42uaWZF28tQVEAlU
         GSa6/hkTgO3rM1JWDk6g+ZlIdIkGZpg7Kpho90bDt11+csYhNfKCR+vo39ykmdiA6PoQ
         HV8TcpEEkS86UgNzgEXZ+dbwt5FIshl2ChSa94xcqmUv9jtMEc0qMLDpWhUXV19zUdq5
         gD2gf6XTGYn5kuItDPRm13k498YiGMwk7g0459TO4MXsT6qsDBiVakN6H0n/dj23jOfY
         C9rr2hOkGPARNCvviaH9FVLETToBl6hrsCTj7Q3hkzr9It/69X4hUnC2IpB69sR6N/hk
         P1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qq86fHdQFBYDGBq4SciqKEleN++5Ao+l5cvatAfZpnA=;
        b=QT45A98OwZPHcZpnfbGDw3zbyZW4lZebpUFe3WGCGbx2hRYzXrJLX56/97Zvw3zsYM
         N/7p3Y8Mli/E6nWe+bFFhFZD0Hc56o7k62kovH6vrapmVW9/2K4pfYkAY+tKjuMLZS7i
         +mAWZoXlsnHtf/f1VsOhZoGz3i1MZcyBbJpQKxmddLVUes0dISdRZhnFhkxVlncDD3+0
         O2850b/ciWBxfj6Xe5AushGz5JTEgfP9AugMwRuzf0QrqDCskkkw53TVE8Koayl+07pJ
         sVkKKSDCG+/XJ3rEiAim/fV5FWGRA6Ck3GQnGEdZDKWi8D6YO2hG9oRbrMICx+bDJxhU
         MHHw==
X-Gm-Message-State: AOAM530F1O2T6kpurAqe0i4V+27GZAIyWra4x3sU0XRfJ8B5E6yvCK1y
        alTep/qNkA5SFZUlTJ83YTCSYw==
X-Google-Smtp-Source: ABdhPJxHomFt3udU8S52vNGunIJyDLh/iYqz7kTEBI2R9HydWYKbYF9COBXDA3ZXdy99PRqnekRhYQ==
X-Received: by 2002:a05:6402:438b:b0:41b:5212:1de1 with SMTP id o11-20020a056402438b00b0041b52121de1mr1080487edc.384.1649090453480;
        Mon, 04 Apr 2022 09:40:53 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id pk9-20020a170906d7a900b006e05b7ce40csm4548231ejb.221.2022.04.04.09.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 09:40:52 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Scott Branden <sbranden@broadcom.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: (subset) [PATCH v5 6/9] ARM: dts: exynos: fix compatible strings for Ethernet USB devices
Date:   Mon,  4 Apr 2022 18:40:48 +0200
Message-Id: <164909044624.1097466.6376427362225722252.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220216074927.3619425-7-o.rempel@pengutronix.de>
References: <20220216074927.3619425-1-o.rempel@pengutronix.de> <20220216074927.3619425-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 08:49:24 +0100, Oleksij Rempel wrote:
> Fix compatible string for Ethernet USB device as required by USB device schema:
>  Documentation/devicetree/bindings/usb/usb-device.yaml
>   The textual representation of VID and PID shall be in lower case hexadecimal
>   with leading zeroes suppressed.
> 
> Since there are no kernel driver matching against this compatibles, I
> expect no regressions with this patch. At the same time, without this fix, we
> are not be able to validate this device nodes with newly provided DT
> schema.
> 
> [...]

Applied, thanks!

[6/9] ARM: dts: exynos: fix compatible strings for Ethernet USB devices
      commit: 2e33a7b5fdb3930a9b1051bc792dbdc6a7490aae

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
