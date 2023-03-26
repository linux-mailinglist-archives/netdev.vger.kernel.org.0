Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764386C98C9
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 01:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjCZXi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 19:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjCZXiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 19:38:21 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506EE4EE2
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 16:38:19 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id bi31so5093941oib.9
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 16:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1679873898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyjm8xwjyXdrTzccWIYekqBKSSvXIWZ4VILah+OHJQU=;
        b=Zjr9YBrWyCkw0kvQprnmgJ0oQwQJ5L1dgz9oBHiipffdfpIhNy5Mr6QgkfpkrCPDuU
         F0+9imaXQJ8aP0JnoWwbeE45Jc5+nrwrTHMkMVaWc6G1ynrAmT6vpBROQhCh99UgrNEQ
         xGzFWNp1MQeqzv+cP05aP4yZIVsedmQd/5WaeSaVDGApPMhUuPz28SCHuWrsEEZ7/7RC
         /UgZxrSHpmE4DXT1wM6Xjq3qAOzuWbAIzzYi7sexMqvQJj0jyYwAeKAQ6/XErA7/hSSI
         MMIngKwRB5774UZU4uSXM9mwIaf9h1hFeM0rIfzfdNd2cM2YbT1SvcrtOdr2htD45Wk3
         +awg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679873898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hyjm8xwjyXdrTzccWIYekqBKSSvXIWZ4VILah+OHJQU=;
        b=hetW36lbMJ+RMIpd7CR1bxi0eEBC95/OEr/pi/rbRQW7lscTCSKlAztqW7KIPp598K
         J2wecITEe5yCL/mHEdK5LyvU8+1kMnWtc3/esMX7tZxqPtilCI59ern4MF1IKXBkzIdE
         rtEw0Q6xJd408Nkh3GuSEqHq5v4dxOls+DswPuOamexfIfr+eZ4uX4AoFvCconV+AO6e
         fWudgS97DohDUJhd1tonRDK2ohjOSka1nq4FnmfzB6Qhl/zV1HbT4VMaer6KGq6/vr05
         XRgqQLkJmO9DHLvLGTyUwy3BGyV193BsQaSAIt9nE1LX76aXT3Af2MrzXWmu1QtkpjaA
         dmvQ==
X-Gm-Message-State: AO0yUKVORGTp3h2yLHl/kzT7IDwG3MGvW+9TVlhlXvwbfLrEMjqzNTG9
        eZQLre+SH/TND9d15Xqx3FjnHg==
X-Google-Smtp-Source: AK7set8ZF/d9NZwhaAaDw7UCAbqdsKen13v9Zd4+61Y2KUZASbwOpKr2hf0K52ClpDT0SUa5+8mbhA==
X-Received: by 2002:a05:6808:616:b0:387:38f:9cf0 with SMTP id y22-20020a056808061600b00387038f9cf0mr4075067oih.33.1679873898582;
        Sun, 26 Mar 2023 16:38:18 -0700 (PDT)
Received: from localhost ([2600:1700:eb1:c450::35])
        by smtp.gmail.com with ESMTPSA id i206-20020acaead7000000b003874e6dfeefsm4848501oih.37.2023.03.26.16.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 16:38:18 -0700 (PDT)
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
        Brian Masney <bmasney@redhat.com>,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH v8 3/4] arm64: dts: qcom: sc8280xp: Define uart2
Date:   Sun, 26 Mar 2023 18:38:11 -0500
Message-Id: <20230326233812.28058-4-steev@kali.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230326233812.28058-1-steev@kali.org>
References: <20230326233812.28058-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

Add the definition for uart2 for sc8280xp devices.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
---
Changes since v7:
 * No changes

Changes since v6:
 * No changes

Changes since v5:
 * Add sentence to git commit description.
 * Add Johan's R-b

Changes since v4:
 * None

Changes since v3:
 * Fix commit message changelog

Changes since v2:
 * No changes since v2

Changes since v1:
 * change subject line, move node, and add my s-o-b

 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 05544a6c1b21..f1d0e8d5edd2 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1209,6 +1209,20 @@ spi2: spi@988000 {
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
2.39.2

