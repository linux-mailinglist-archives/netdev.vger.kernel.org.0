Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3486668B31D
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 01:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBFAQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 19:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBFAQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 19:16:44 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACD91ADCC
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 16:16:41 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id o66so8516097oia.6
        for <netdev@vger.kernel.org>; Sun, 05 Feb 2023 16:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vf1rdFY0mBBSEcQfkZO+NJqi84L+MOrWCpzsYM4y6TE=;
        b=iyBWvsOrErhEQUMtqXF272zLpX4yEkJVfWQ7N6WVPaFKMTRTzabrICeelj5RpPCiwm
         5VK4Dri/KQ/h/e3DXChm6EneGGmEd8cDO4hdOzPKsxD0OAq/v+TARDfq+aT2tHB/gYy6
         F7a45tIp9I9MEqej+T54q6NJSKKDY/78cBTo/ApN+QfNlheQU6FkDiGIeUlthnZ3lzcq
         HF/BNH8zNAhUQiC5ejL37WKYMUMq7AFoSLnaDtLKzWCuupEk82eW1dD3GdexMqC8htWr
         P4audA/EKQ7OzZO+R0VwlsxiEvX8GMtSalhKb8t7Efxbw9Ac8xY2SPb4a3+2VSR56Ndk
         MtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vf1rdFY0mBBSEcQfkZO+NJqi84L+MOrWCpzsYM4y6TE=;
        b=II9Zhff2izB78oI8lXiYFqqObhUOhOU91c8RqOdjopYshNlClxCtUGujq6hBH5FyEO
         H7shjc3zu+nYuierenAxMUT1Q0M/HZbIqVLdaZavzH6FN5dENlbbXjhniPXOvkEopRyX
         m4Iff/tWm8dyNySt/Cu8LSf1Sypy92L2cEJoHIDudRHyvLWV5DLZCsM83B1A9k7FFfa3
         gDbRTWSjY+9sSbyEcHaKN3rY927G/tu5Nba1kTyrV2adBd3oeNe0gEQXyQNNnkmy/skd
         YO0gPgTYgHRVEdY40NCRy5lyMGl9KMF5J2rbvkG4AUll5u32l1ENx8hnAp4sxMlRKPaG
         ZgWg==
X-Gm-Message-State: AO0yUKVgxs2XheHfndDEKbvUghsmd8BUb1XA1ojz8DoON0DgP6AamtAS
        Bm0lm7G3KppR0SvtHmzgGe5ouw==
X-Google-Smtp-Source: AK7set8LmIs/PnalDUCkOyLjtJZK0PbhxJCqCQ/RD5qyU4Tks3YUyAJYaa9EovbhNT5BzE+Lca8e4Q==
X-Received: by 2002:a05:6808:2890:b0:378:2279:9f43 with SMTP id eu16-20020a056808289000b0037822799f43mr8147330oib.29.1675642601130;
        Sun, 05 Feb 2023 16:16:41 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id o63-20020aca5a42000000b003780facc45esm3417461oib.50.2023.02.05.16.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Feb 2023 16:16:40 -0800 (PST)
From:   Steev Klimaszewski <steev@kali.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Brian Masney <bmasney@redhat.com>
Subject: [RESEND PATCH v3 3/4] arm64: dts: qcom: sc8280xp: Define uart2
Date:   Sun,  5 Feb 2023 18:16:33 -0600
Message-Id: <20230206001634.2566-4-steev@kali.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230206001634.2566-1-steev@kali.org>
References: <20230206001634.2566-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

---
- v3 No changes since v2
- v2 change subject line, move node, and add my s-o-b

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index fa2d0d7d1367..eab54aab3b76 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1207,6 +1207,20 @@ spi2: spi@988000 {
 				status = "disabled";
 			};
 
+			uart2: serial@988000 {
+				compatible = "qcom,geni-uart";
+				reg = <0 0x00988000 0 0x4000>;
+				clocks = <&gcc GCC_QUPV3_WRAP0_S2_CLK>;
+				clock-names = "se";
+				interrupts = <GIC_SPI 603 IRQ_TYPE_LEVEL_HIGH>;
+				operating-points-v2 = <&qup_opp_table_100mhz>;
+				power-domains = <&rpmhpd SC8280XP_CX>;
+				interconnects = <&clk_virt MASTER_QUP_CORE_0 0 &clk_virt SLAVE_QUP_CORE_0 0>,
+						<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_QUP_0 0>;
+				interconnect-names = "qup-core", "qup-config";
+				status = "disabled";
+			};
+
 			i2c3: i2c@98c000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0 0x0098c000 0 0x4000>;
-- 
2.39.0

