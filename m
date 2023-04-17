Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA776E4CF5
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjDQPXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjDQPWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:22:33 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370AEC67B;
        Mon, 17 Apr 2023 08:21:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f09f954af5so11043765e9.0;
        Mon, 17 Apr 2023 08:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744889; x=1684336889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTKNAaQmPuBEEmm7r0M/hJa5foC7EUK457tHpsrXZIU=;
        b=Pz1ZG12LAfMDtTVcvyrH73KzKnUfvemue6XOc7e28NCjE+syX1XIim9sSnblhUIm6f
         JaTXeEhStfPUql4+uio4lJkx7Ft4iVyR1TeaQzwA9iwyq1+EBNzaTgJ9InZ1fY2rfC8i
         DXHcLrlFtN+h/bNxpvEdaxl6uBvCZKLmMrD5NTT52dExjMz6w90uajm60OSHuegjjGz0
         QLNDyfAsRQLjwK2yb5Z1ohuG90csdSkzrXlpobdskkviPEz1fP4JIkd67FugeRJMr+w4
         4iGk+Jfvhea1tf2J2rY6l8kOPc0OknFwc64yxh2e1dTjSMwqlU9qd/XXgq/Pn7SFF31L
         l5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744889; x=1684336889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uTKNAaQmPuBEEmm7r0M/hJa5foC7EUK457tHpsrXZIU=;
        b=UefPB8xYGXzyjngququWsNpx0l9aUyPNTndeqQkF9cgms9JXUb3jNtxXR7YJ3dnbu3
         onPWN9auHB8Ck9CE/hPBAPLNACUtOHHDmvQdYbHa41EeXtp4kYJPmV5cC00xGQYdXcOh
         0b12/mvzF63jsf+7hleV9lHGGmfOvXgtKV9I9pREprVr69mlNxQcpIi4kNy0mdQHRXcB
         tKZCn5t5lGmjVQABtZ11JIysGFrn0FT9q7uPtv9DukGght10DLFyxZ0DZ0GEm+PGy5HN
         NVdFpxhgiFXrA1rKng74fwRdBNhuu+EhM94FDk+4E6EIxtZK+MV57WryqM03mtZqH9XN
         beiw==
X-Gm-Message-State: AAQBX9c656HtqRi1kxAYRKVgbRbhlay8IG1R2v9883u6ri5Wcp6IAZzo
        fL2BcF/0MiKenhjMpf1keZs=
X-Google-Smtp-Source: AKy350Z1zkLcEctazd0wxeEfObLTI20cnhzReBwbbWQ5c6DqPtLWI6i51ks402Gf4aqHkIzDMBeZbw==
X-Received: by 2002:adf:e54e:0:b0:2e4:abb1:3e8b with SMTP id z14-20020adfe54e000000b002e4abb13e8bmr5261848wrm.25.1681744889263;
        Mon, 17 Apr 2023 08:21:29 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:21:27 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>
Subject: [net-next PATCH v7 12/16] ARM: dts: qcom: ipq8064-rb3011: Drop unevaluated properties in switch nodes
Date:   Mon, 17 Apr 2023 17:17:34 +0200
Message-Id: <20230417151738.19426-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPQ8064 MikroTik RB3011UiAS-RM DT have currently unevaluted properties
in the 2 switch nodes. The bindings #address-cells and #size-cells are
redundant and cause warning for 'Unevaluated properties are not
allowed'.

Drop these bindings to mute these warning as they should not be there
from the start.

Cc: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Jonathan McDowell <noodles@earth.li>
Tested-by: Jonathan McDowell <noodles@earth.li>
---
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
index f908889c4f95..47a5d1849c72 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
@@ -38,8 +38,6 @@ mdio0: mdio-0 {
 
 		switch0: switch@10 {
 			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			dsa,member = <0 0>;
 
@@ -105,8 +103,6 @@ mdio1: mdio-1 {
 
 		switch1: switch@14 {
 			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			dsa,member = <1 0>;
 
-- 
2.39.2

