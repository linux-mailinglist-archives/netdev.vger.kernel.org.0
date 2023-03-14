Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAF66B9B29
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjCNQTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjCNQSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:18:02 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5849BB0495;
        Tue, 14 Mar 2023 09:17:38 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t15so14876016wrz.7;
        Tue, 14 Mar 2023 09:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=fERp4iruASNfxlqoL+2/uJaSk630G6zW0nonVIurn4lJbM7HvCO2FPDN8Ob+V1CMFx
         NFHbly9IqL8GUDuao2aY9Y3pEa11UIUNIVNWjKApIxBpmJDeola6BChjVoR4iBBrvm+h
         3wnajXUD3V0UTaaK680PyCyMGERWSJhZ27ubjRMPiDvGBpzZu0Q3xempGHjP3C/Nkih9
         k85bXltxGU8vURynM8WR5tAPLj2BSbi6qQJ3ZErR5YfxfTdBLG6zR6c3DTEjgNep6wkH
         PRiFDvmjqkDa2F2a8zbatHBaIChk/fx5cxfUcWEaEtymZJuiIDsSznlzQUE7JnzyytNt
         uxXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=GGNG/tbhNuUz6srqe77d9nCCI03g8hp1OQGF/ZyLB6VysxAI9scYhNM9ov87aXZA1h
         rLeTjQ4k33r1pMGHY3esZO5p17uxBvyN2IVsw38w/uStySdo6P06RlIKBpH3e6MhOtwl
         rUS2Q/ZIQ9ODKNAcH6f3xqULUKLsNjnKDh9iyPhVY8KVWO6407MXjsZHI+mZJc7daAw9
         XFHcJOgYyClCudoSU5stb61Nz5ZSiqy3HYXTTw5Wg05xgE6ZgKnV9sQd8joNFGQUCPQX
         Teb4GHjh7RnSLlux4nSJziwa09kT108uErZ0WE/DSMoGwmcyAk0NZUDv7bJ6lpK03/8m
         E4ng==
X-Gm-Message-State: AO0yUKXwfvTPiHJjMAC8q70p0wDkexpfNyVYpky4CfQt+0ZlIQ5aOadF
        qUR5mjSGIJRAbLqXlE4a/vk=
X-Google-Smtp-Source: AK7set8OmkyrcEEY5FRJaMu61OHDe2VDvEr3q/jSO2OWbisf89FSxvWA5j1zHZW+ngu9DyDZ2I/fvg==
X-Received: by 2002:a5d:6641:0:b0:2ce:a825:e0a1 with SMTP id f1-20020a5d6641000000b002cea825e0a1mr6915000wrw.14.1678810656579;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
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
Subject: [net-next PATCH v3 11/14] arm: qcom: dt: Drop unevaluated properties in switch nodes for rb3011
Date:   Tue, 14 Mar 2023 11:15:13 +0100
Message-Id: <20230314101516.20427-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314101516.20427-1-ansuelsmth@gmail.com>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
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

