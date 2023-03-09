Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5ABA6B30E6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjCIWkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCIWjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:39:23 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634EFF4D91;
        Thu,  9 Mar 2023 14:38:14 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso4765769wmq.1;
        Thu, 09 Mar 2023 14:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678401493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=VMC1fBG5a3K5yvny/yfu3vMpe9zjjlud0NIygPwpOwT+VmqcbqoYNNCZxsIPj/Nkuq
         jDubkkDElPJNacWO6eQo1YxK8ryxwUlumbImj/ewzzLtsH21D1JQQvlNtzDyykixSXvz
         VK0bWIJ4nGy52WHPf2xccFng1l8E3ro6+469igHmB3pLmFce92kjl9gWcp1LfuvXXwEe
         vMEOXCYzGomnd+SLjdXS109KmDr7J6TAjcmjoRvobRWlQo8BbcpdPAK7H26VtO7hps9r
         RNrhz15q+v9p5mpE8Lj4XPTHHz9I1x9wA8fcXsIvvxoETMv70L2PjDZfhpn7ET4UTBt8
         Y+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=4o/3tnwfNXveZkbj2NZ+FxxuZD7wrmA/rUQ+xJyQdHykNDLvNli5y9QgDwY4WR4HbF
         nQQJYZT0PiR+0xV1Pbc5RkoF8KkQjXUW7lUGyGrvBlAiLpgQeMwua5IaUehdR76g1eg6
         olauaG01CIZWjFcxBbXxgc+K7TdFjxXh23HL+fvZpK0qI3Ch7qlcV8l2jsTg7TsiSCAi
         yx96FDKs1EUYf0lR4ugaOgJ7RQ8SgHmjS2SRxSvgUv/ZtZDuOt+V0rxztYBrmq7LbxL+
         SuPrgfG05w/iBQoS6ZKf6hx6O6qpsN5d32dQTGsvOnUQmGYL2/7cmleaKTpnFf/L+XPJ
         NQrg==
X-Gm-Message-State: AO0yUKVtJ34QeZyQ5UiE2RhmklA53aWCPhElmBo7QHxGNK6M9wW9u3e2
        G8it9N+s2UOgKR0QTBRV2LNTd83uX8s=
X-Google-Smtp-Source: AK7set/hspK7iiGUhSEhbZ7lBCAIa01AEehft+SmrwN5cdKBZQ33aj/4jlkrWC+H2tLRXXaVLFFptg==
X-Received: by 2002:a05:600c:b8e:b0:3e0:98c:dd93 with SMTP id fl14-20020a05600c0b8e00b003e0098cdd93mr707470wmb.29.1678401492562;
        Thu, 09 Mar 2023 14:38:12 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003e209b45f6bsm1183981wmo.29.2023.03.09.14.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 14:38:12 -0800 (PST)
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
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>
Subject: [net-next PATCH v2 11/14] arm: qcom: dt: Drop unevaluated properties in switch nodes for rb3011
Date:   Thu,  9 Mar 2023 23:35:21 +0100
Message-Id: <20230309223524.23364-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309223524.23364-1-ansuelsmth@gmail.com>
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

