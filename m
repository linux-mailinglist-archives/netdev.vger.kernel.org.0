Return-Path: <netdev+bounces-10029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CBC772BC2A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04831280A9E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B34C174E3;
	Mon, 12 Jun 2023 09:24:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A617ABD
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:34 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1256E62
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:32 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f62d93f38aso4816533e87.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561871; x=1689153871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=su4Ml188NZQl7/ApV7N4YWW8KD5ToBDayqEyMhucvL0=;
        b=wTReWTESrXF8MQdnFv0BcbECvhA5k1jp/UpUNoz5an+amSVMTnDq4zSy8OhgF+QIHP
         VxqnfBT6c8Gc9esMda2ao0ri3AX9tE/Rej1L2iPODh3z23iryd54EdmTxXf8Akqd40iz
         UUREr/Vua1XefWoHpGHQw9UxoR0Aktnkb6PKHg6zaQXmUGDFO6+IDX5d1DXhwizay6wi
         Sd3rbsJxq7tmZEsN+gMmSOGdFdNh6xTDJfT5ymd+QoUGgf0D1fTFl1R9WITy+EMgUGVI
         c3WesnH2AJ3Dw4o2uhkFqpDxTeAZJc1xoHaxEpGONEJDz97NZzhNi6uUAzStEDQHePL+
         Mdaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561871; x=1689153871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=su4Ml188NZQl7/ApV7N4YWW8KD5ToBDayqEyMhucvL0=;
        b=XBgIDUYADMy+76wSyu/pJxOR6CSS8W8DG2sELY/r0TSR8nL2iEm5jMvyGUXzdZXQQS
         r6+VraQ1NZ2KdzQEdYc3Ibpq8BUseKNbZE/Onwhy9HwJ/oxuk5fmsiG4YLWxZ+jlD/D7
         PGIhRnh45RYFPv2HxP/ML1k3v2UlA8UL2j9hYwgHfnDBaLWnjTtuaasCoWbmiYVG2AMX
         oUdMg0AOFJDZfhryPELieUrEJGhGjbRgGfnUMh/rgOyjo6EhWNkJZjtKiRgS6m1QlTB3
         43QdvWkiO23FGxls+gBM1HLgw892lb0vHdOGYm9ybvFg/g5WmPUpNdHB3EuDJ3jyQtfP
         FlXw==
X-Gm-Message-State: AC+VfDys0PoIYUEd4wXTMgVTK9XLn/IkvQZoHMFbJ0CS+3tNlrJI7Md5
	RXTgfOooJjgNO+Y2SauRM8sROQ==
X-Google-Smtp-Source: ACHHUZ6avE4dbfTuPulQJx5CHawnorQOK0WS0NUfFL8AJner9iIRg49w5a0WkmL8BvBwi9Ny+W3Ubg==
X-Received: by 2002:a19:6601:0:b0:4f6:5bf2:63bc with SMTP id a1-20020a196601000000b004f65bf263bcmr3203042lfc.3.1686561871076;
        Mon, 12 Jun 2023 02:24:31 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:30 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
To: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH 04/26] arm64: defconfig: enable the SerDes PHY for Qualcomm DWMAC
Date: Mon, 12 Jun 2023 11:23:33 +0200
Message-Id: <20230612092355.87937-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612092355.87937-1-brgl@bgdev.pl>
References: <20230612092355.87937-1-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Enable the SGMII/SerDes PHY driver. This module is required to enable
ethernet on sa8775p platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 8d850be05835..f62c96fd4335 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1367,6 +1367,7 @@ CONFIG_PHY_QCOM_USB_HS=m
 CONFIG_PHY_QCOM_USB_SNPS_FEMTO_V2=m
 CONFIG_PHY_QCOM_USB_HS_28NM=m
 CONFIG_PHY_QCOM_USB_SS=m
+CONFIG_PHY_QCOM_SGMII_ETH=m
 CONFIG_PHY_R8A779F0_ETHERNET_SERDES=y
 CONFIG_PHY_RCAR_GEN3_PCIE=y
 CONFIG_PHY_RCAR_GEN3_USB2=y
-- 
2.39.2


