Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275B46289B8
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbiKNTr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbiKNTrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:47:46 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307E81DA5A;
        Mon, 14 Nov 2022 11:47:45 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s5so2638595edc.12;
        Mon, 14 Nov 2022 11:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0D7hYmWxMOtktKnG+ggFebq/O5+c5dEuQKnJ0LxuN4=;
        b=gR45i7+KvzT5jP0/lIxPmNVCWai+tRNTod1sjTUZx8BVPkjlyChFdBbK6PUQOzl3fw
         r47MKvc6KJ/Kmjr85S+merePtXs+s+yKUaqytkK36KgK2swnJcVCgVBPBdz0AGTRDZhj
         eRet/paI0d5z0ozlj1c6gSsHmSXgTa75o3RK01FMzR+yV6WW+Q4c7QHvZvnfgrQ4c+Yk
         x1/Yp8IYhJ1UJEguLYw7M0xXf2QTt0s3LpTfeVnE87GiJeQRIQpyye1vFQOmdqCGz+Ml
         WASIXGx2IdAk59Uc9RNLFNCZwxGrKQghxtvm83BJV8ElPfT3vCNJ+PWz70h+42O8FqBX
         57Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0D7hYmWxMOtktKnG+ggFebq/O5+c5dEuQKnJ0LxuN4=;
        b=f6UhLD0cuEzchv/Q9kwzeyrbkFng+wmE+Iu61giowC0jZfLxpSnLXRvHxAs8mX3o7x
         XJYda3+i6xgvHfFQWx3/hwpSIfHvj5eBPGRMx5hLcK9ONjWpWgEdaxh9oRwEoOVslI9t
         FnQKMXqDD9b/OcfIyawmy/ZI4QqwXxGrrtPaklFNRNsOMRQNNTKjicYUDLCd5jm8maQg
         1aqn34to6jbd+YJ598roygYlmsEpOeUZldiNZTXKGogaY/kCGEtiwzVaCsaU03U6mtuN
         7rkZv7X+cJYocYPkmAKrc/hyULSLoGs4Qi97jkvJFvhzsPWUHehGn0YlLUGqNYwDyS3P
         U8sw==
X-Gm-Message-State: ANoB5pl32H9cV2UFBHj8uehZOcknnVryESWkeoLjUqx5Bgcfx4MZh92Q
        q8Xy5ghOq2X02iySB8o3sAg=
X-Google-Smtp-Source: AA0mqf7w4sHb8RKj3Oe0o8FjnulwnnXsTmezWgQOnBefQW6jlUhCDCqGmmHKwWFrn7YL/kZe3HMfnQ==
X-Received: by 2002:a05:6402:70e:b0:459:7673:6f33 with SMTP id w14-20020a056402070e00b0045976736f33mr12461215edx.30.1668455263652;
        Mon, 14 Nov 2022 11:47:43 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id k8-20020a17090632c800b007a62215eb4esm4666405ejk.16.2022.11.14.11.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:47:43 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 5/5] arm64: dts: qcom: ipq8074: add SoC specific compatible to MDIO
Date:   Mon, 14 Nov 2022 20:47:34 +0100
Message-Id: <20221114194734.3287854-5-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114194734.3287854-1-robimarko@gmail.com>
References: <20221114194734.3287854-1-robimarko@gmail.com>
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

Add the newly documented SoC compatible to MDIO in order to be able to
validate clocks for it.

Signed-off-by: Robert Marko <robimarko@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index a0481c671faf..583871c29586 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -331,7 +331,7 @@ pcie_phy1: phy@8e200 {
 		};
 
 		mdio: mdio@90000 {
-			compatible = "qcom,ipq4019-mdio";
+			compatible = "qcom,ipq8074-mdio", "qcom,ipq4019-mdio";
 			reg = <0x00090000 0x64>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.38.1

