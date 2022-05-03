Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD855188BA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiECPkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238631AbiECPkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:40:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D385F2F003;
        Tue,  3 May 2022 08:36:31 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i19so34135774eja.11;
        Tue, 03 May 2022 08:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fyfBTzh+nFyMbqlorBpW+/oFJj2msf8ut26TogSSvvM=;
        b=pyhVKH4+3uZ6d9PttQPabTkfKS4X+4dWF25oJfqzuF0UBWLi0Qh3PD311mse3/+kJT
         MCIynAmMpEf7lKJfA264W06se7hD8mlEht1GJrvBiLo/4remn4u23N/Oy2GX0TV3mwLw
         cXAvk4U8DSo9EXYZS/5j4li449394sKNYq7599SJWuvpeCI5SHbQCVfc1/gUC4PLKZ68
         VsOcDsoJplveU10eAHGclfyJaTAfmIuNzURqgCUGWUj/1Gfbpx345BZR36v9M2bzXvYJ
         tKSkDEBNFKTHL/KnvYwNDaiYG9m2ascw2Mzt0eWxChGPW2tlniVnpaEVOIFDxfspyWxZ
         1OyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fyfBTzh+nFyMbqlorBpW+/oFJj2msf8ut26TogSSvvM=;
        b=AgA/lkb2y35fPgdkBxIETP4ffE/rsc468rHgTy6pV/hiCOO+6mFq1BP2TSbri/0IUD
         sa3hk+1nwEqhyPuZSEhvpzrXEUgu2T6MgiBlKCdSnKwiO/ThJxTqky5LV1vJ7Gs+F705
         lzlysFimiLhLO0Vid/gJwVAB2Ium14LaCmG5en1H4HKhtWzKSJnI9HWeaR5CFpXe4xIP
         bsk4JnXlKW3ArsTGigoSLgPo0MAUujXiFMpZTqh/0F6yox4lE5J9gealb5TMgO4o5FL4
         4YYQzNpU9afaH0gQApt/qpwgg0ij4NWYHm5XNfHp7FhCbLNIg1nlwaKYIDB4S7y6LvxC
         QMjQ==
X-Gm-Message-State: AOAM531iHkWnVtE3x56y28AqJtH91xdaBvftzfZQugKuBZNPUgyLgxAz
        sALjpDm0dLby03jifnxBZwU=
X-Google-Smtp-Source: ABdhPJyAwf9o8XkpMsr1BZVKZJk9YsDNXz5DWxkF2Si8Xaj+V6Au0RL65+l7FDCQ9n9Y6rTD8QEvJg==
X-Received: by 2002:a17:906:d552:b0:6f2:408c:e0bf with SMTP id cr18-20020a170906d55200b006f2408ce0bfmr16004655ejc.143.1651592190360;
        Tue, 03 May 2022 08:36:30 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id yl1-20020a17090693e100b006f3ef214dd1sm4693395ejb.55.2022.05.03.08.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:36:30 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/4] dt-bindings: net: allow Ethernet devices as LED triggers
Date:   Tue,  3 May 2022 17:36:11 +0200
Message-Id: <20220503153613.15320-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503153613.15320-1-zajec5@gmail.com>
References: <20220503153613.15320-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This allows specifying Ethernet interfaces and switch ports as triggers
for LEDs activity.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 817794e56227..ec4679e23939 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -226,6 +226,9 @@ properties:
           required:
             - speed
 
+allOf:
+  - $ref: /schemas/leds/trigger-source.yaml
+
 additionalProperties: true
 
 ...
-- 
2.34.1

