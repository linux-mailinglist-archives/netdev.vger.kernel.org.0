Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E096EAC80
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjDUOMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjDUOLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:11:51 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119A8B76B
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:11:46 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94ef8b88a5bso233888366b.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1682086304; x=1684678304;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m46VLD2JzGlramKy/E9COqcajcCIODXlIHm11HTuzOE=;
        b=zkCuK8CQwZrSK4X+CfJq5XsJyphe5C+bUQ0PXube+pfE42fImAdmk4sATOhnWhNqdA
         f9dSC/KiADF8A/jn0l1ZrE1HWBxYtq/nvBWyJ+8+vhwlJOSIdkbYN/ekOMHwpsz2cG4e
         lk72ujRuCwnV2bNcLwtXE02SR0hHQGRwkZIUqJAQBvkTvOeVD1EsH66dhGH1J+9ylKL6
         pjmM4LjT7piQvr2hmuq6jPtpILy2WB2fq5BvhD5boYSxMJ3B9s30v4pyh9M/4VaO2mwe
         bZMDwucBGAvgNj3qe+4l4P8MPclvP7pssxJKb5LtbRv8ZKt7qjAEt+ViLBL1MPlBkwJT
         suDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682086304; x=1684678304;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m46VLD2JzGlramKy/E9COqcajcCIODXlIHm11HTuzOE=;
        b=jA2WxGbq99ZX/MqZqIUPvMyKDR0GFDd9PXPSHUBPcz2OSgzfHMZvDmtvJk6B16+NuG
         QecEVFdt3hgyZli0RlFcOPn3quPshUtEnZFq/RHHx7TTgJzwUtf0HgAJG9F5dtAmCixo
         4Abk1wAhPFtHVpTAJLTBaZWqSMOHy4C3rXFU+XAzc6PPjvV+AnDPgefyank9OC44Vb5i
         eSn18C4gUIEu+9K9Eteq5iBh1GYaoPvk7xQdk+TZ4PNIjhYAGdOmV6OBkwpRb+SWC0zR
         dy7y3Mvaps7YwRzIfGEPEOEU7nQYBL0bBTxuVHWKUAbtfo0Mt9oHwjM4uXkDveqv1XIa
         qQ3g==
X-Gm-Message-State: AAQBX9dUSzuY72LoQ5GpQqPc9M6pJomtNdiPIqJv3igCVt2ohj2k2vfb
        wfwcQ/U31W0D5c+711Et2AonoQ==
X-Google-Smtp-Source: AKy350ZfxB3umaKd0NpZrYC31H42nosmXh8NeMizQGxgz4awVYGG2fe6OEvQDPjdhBhb44RnANeVLQ==
X-Received: by 2002:a17:907:7888:b0:94e:6f2d:d1c9 with SMTP id ku8-20020a170907788800b0094e6f2dd1c9mr2654828ejc.68.1682086304455;
        Fri, 21 Apr 2023 07:11:44 -0700 (PDT)
Received: from [172.16.220.31] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id mb20-20020a170906eb1400b0094f432f2429sm2104299ejb.109.2023.04.21.07.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:11:44 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Fri, 21 Apr 2023 16:11:40 +0200
Subject: [PATCH RFC 3/4] arm64: dts: qcom: sm6350: add uart1 node
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230421-fp4-bluetooth-v1-3-0430e3a7e0a2@fairphone.com>
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
In-Reply-To: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the node describing uart1 incl. opp table and pinctrl.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 63 ++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 18c4616848ce..16c5e9a6c98a 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -378,6 +378,25 @@ opp-2073600000 {
 		};
 	};
 
+	qup_opp_table: opp-table-qup {
+		compatible = "operating-points-v2";
+
+		opp-75000000 {
+			opp-hz = /bits/ 64 <75000000>;
+			required-opps = <&rpmhpd_opp_low_svs>;
+		};
+
+		opp-100000000 {
+			opp-hz = /bits/ 64 <100000000>;
+			required-opps = <&rpmhpd_opp_svs>;
+		};
+
+		opp-128000000 {
+			opp-hz = /bits/ 64 <128000000>;
+			required-opps = <&rpmhpd_opp_nom>;
+		};
+	};
+
 	pmu {
 		compatible = "arm,armv8-pmuv3";
 		interrupts = <GIC_PPI 5 IRQ_TYPE_LEVEL_LOW>;
@@ -741,6 +760,22 @@ i2c0: i2c@880000 {
 				status = "disabled";
 			};
 
+			uart1: serial@884000 {
+				compatible = "qcom,geni-uart";
+				reg = <0 0x00884000 0 0x4000>;
+				clock-names = "se";
+				clocks = <&gcc GCC_QUPV3_WRAP0_S1_CLK>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&qup_uart1_cts>, <&qup_uart1_rts>, <&qup_uart1_tx>, <&qup_uart1_rx>;
+				interrupts = <GIC_SPI 602 IRQ_TYPE_LEVEL_HIGH>;
+				power-domains = <&rpmhpd SM6350_CX>;
+				operating-points-v2 = <&qup_opp_table>;
+				interconnects = <&clk_virt MASTER_QUP_CORE_0 0 &clk_virt SLAVE_QUP_CORE_0 0>,
+						<&aggre1_noc MASTER_QUP_0 0 &clk_virt SLAVE_EBI_CH0 0>;
+				interconnect-names = "qup-core", "qup-config";
+				status = "disabled";
+			};
+
 			i2c2: i2c@888000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0 0x00888000 0 0x4000>;
@@ -1726,6 +1761,34 @@ qup_i2c10_default: qup-i2c10-default-state {
 				drive-strength = <2>;
 				bias-pull-up;
 			};
+
+			qup_uart1_cts: qup-uart1-cts-default-state {
+				pins = "gpio61";
+				function = "qup01";
+				drive-strength = <2>;
+				bias-disable;
+			};
+
+			qup_uart1_rts: qup-uart1-rts-default-state {
+				pins = "gpio62";
+				function = "qup01";
+				drive-strength = <2>;
+				bias-pull-down;
+			};
+
+			qup_uart1_tx: qup-uart1-tx-default-state {
+				pins = "gpio63";
+				function = "qup01";
+				drive-strength = <2>;
+				bias-pull-up;
+			};
+
+			qup_uart1_rx: qup-uart1-rx-default-state {
+				pins = "gpio64";
+				function = "qup01";
+				drive-strength = <2>;
+				bias-disable;
+			};
 		};
 
 		apps_smmu: iommu@15000000 {

-- 
2.40.0

