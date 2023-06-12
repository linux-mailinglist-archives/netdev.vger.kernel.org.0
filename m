Return-Path: <netdev+bounces-10049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC3972BC95
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA92D281154
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7311B911;
	Mon, 12 Jun 2023 09:25:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825611B8E7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:25:02 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDFD4205
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:00 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f738f579ceso29736145e9.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561900; x=1689153900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4hcroDV0hdKX/DQDft+g0yZ5ckCppngKltjTy4swGs=;
        b=MAMjiLP/Ub2YMkZrYMQu9I+vzT6+M/KG3XopFjXfiAgrNHxfkR1XAmH5b8FPhTzsfl
         AqRdT7fKsLe1LsAM2ySEpkmdoZpmATyl8UlCZdD0WerCqDDnXfaLcu9TW+BsqAjtpDP3
         h4Y8lowLuAZMm8+6vaV2+O5tZ4JOtojf9TOohwrc3VXLVH0Lp62NqHuEEzvSQ7XMsIgJ
         FjwcfKOhlAEOQ+sWQqGMbhR8naVGQyOA17XnUN5/G+unqZS2uYPEfzRepIdPMJ3pNCJT
         C2VSAmBfiHnpDcna93MrdqjGaOpKmOoY5f4NTJ2Krkj/Qavu3TIAsxqxZqX2d9tNvUnX
         YUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561900; x=1689153900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f4hcroDV0hdKX/DQDft+g0yZ5ckCppngKltjTy4swGs=;
        b=UcmOY3YQeG7rfQjY7+DYthQzdMAODl1HaM9XM/joC2l0w1subakuS2xAds5n7sLSFv
         itmHgS/wq+EPm3VxntZrgpaL0oSSKtdHRmtdOZtj8gGkh1kxrKe+6z126T6UlU6I29SU
         tP1QqX8YA7W2cHUc2pCtNlkXRV5/cC4uhZuQcTZxMNWINB+O1ZPgVtep6lvnOlA5DlpK
         4hSE02Ms833eAstZx9tfRNoOhNzkinUkC8mUYFTn07k1SNxmDmT2Zxk+5snIdz4crvvC
         iSEzYkCTsjXJjOWA5XI4Wd4U+vJewBqanOs0S3cWx+GhJUsquhjV9itEX8cXrNtzS/BR
         o4kQ==
X-Gm-Message-State: AC+VfDwCrEud5GUfKQbpBtm5Pxv9XWDFWR4eprJLbw9Ef6D3BG4mtgXO
	oeEeffV8hMSfGjG5yYQzAVFzYg==
X-Google-Smtp-Source: ACHHUZ61vW/FRawgaaHnvQGC2M+qoPMGa2BJ9bPXYYT98KJ/c8JNEM8dFY2uCnSfW5vwruY6E+eizg==
X-Received: by 2002:a7b:c047:0:b0:3f8:1b55:ac08 with SMTP id u7-20020a7bc047000000b003f81b55ac08mr1200775wmc.28.1686561900531;
        Mon, 12 Jun 2023 02:25:00 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:25:00 -0700 (PDT)
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 24/26] arm64: dts: qcom: sa8775p-ride: enable the SerDes PHY
Date: Mon, 12 Jun 2023 11:23:53 +0200
Message-Id: <20230612092355.87937-25-brgl@bgdev.pl>
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

Enable the internal PHY on sa8775p-ride.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
index ab767cfa51ff..7754788ea775 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
@@ -355,6 +355,10 @@ &qupv3_id_2 {
 	status = "okay";
 };
 
+&serdes_phy {
+	status = "okay";
+};
+
 &sleep_clk {
 	clock-frequency = <32764>;
 };
-- 
2.39.2


