Return-Path: <netdev+bounces-11097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 470F97318C9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED1542817C7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29A815AC2;
	Thu, 15 Jun 2023 12:14:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DCE1548E
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:14:57 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CDB2948
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:14:49 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-30fceb009faso554484f8f.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686831288; x=1689423288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMgaAHe76eIn3F9IB6JgFSErZkAha9wqjAecsB/W5Vk=;
        b=v/JROUtIn1Fn9P10DPijytJUNeMgvE979wcEBNHrOGUdG6qtCKQ7nd6DTn78TsgPK9
         oUGOJElAik/a1BznjNO6USDB/u5nHsu/PStgHyApHHv40RgcfIHdXONrGyB4WGs3N9q2
         P63IyhbcJA1JqCZcROq+tanvqlpIehMj3UQRBQ+UlGU+jlpNfEMVUEz0MEtBoShEy4ZU
         AQ/i+SxJff++kZZD7Sf5WR8dfphK1E/o4XQNiVfem4vMTW3A/Bom43nQ69X1BXRfPwkq
         wfno0VaUOkbOKuWBS3EM/692Ilu/HgF+kCT3+x3uTUUE5d1uhem6sSeoZ6PbKoMXoxD3
         UQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686831288; x=1689423288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMgaAHe76eIn3F9IB6JgFSErZkAha9wqjAecsB/W5Vk=;
        b=HoR/dAxETuC4fYvVzlyCI1DXwIQj96LpEObrbq3br16COs/qBJKAlQDcH0OJpW9N2P
         8LhQQ8N1WcE3Dw87DStazduvUDrhC2JX5LaY7b0dNSGjKs+sUENrfAZHzywZwsYDIfKz
         44z3rThM2fqgGuNMljcPRBj7g3gGYSdiwdiQ/rKs5fEOPgwPxcgZKACInezjmWTrVMdF
         i76OS+JGxB05ivpmxTLP4lMo/LDKvFTumPnYLZnieCUsnk4MTf30fl4lraay7PyNnR+x
         WBCObSNJluC/WTpuqzVuPT09gl7Z2ONpgtAnczN42heqmaQ7VRYenEuMgMUHD9baqqOL
         a/DQ==
X-Gm-Message-State: AC+VfDwdswXE4UxlXwnBhzLc32ysVD0oz5wZi01aTOR9Tq54ln2n7mm/
	rZCTn0uxg8pFvZlFy4r4k3oB4Q==
X-Google-Smtp-Source: ACHHUZ7hpsGhA1APGWhKHqXJARHR7T/asvTIBCcezaYjJwRDKg1LmwDvqWkfZ7PEzsLAv9Oam4DVuQ==
X-Received: by 2002:a5d:6a88:0:b0:307:f75:f581 with SMTP id s8-20020a5d6a88000000b003070f75f581mr3870500wru.18.1686831288107;
        Thu, 15 Jun 2023 05:14:48 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:2ad4:65a7:d9f3:a64e])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d4291000000b003047ea78b42sm20918012wrq.43.2023.06.15.05.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 05:14:47 -0700 (PDT)
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
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v2 11/23] net: stmmac: dwmac-qcom-ethqos: remove stray space
Date: Thu, 15 Jun 2023 14:14:07 +0200
Message-Id: <20230615121419.175862-12-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230615121419.175862-1-brgl@bgdev.pl>
References: <20230615121419.175862-1-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

There's an unnecessary space in the rgmii_updatel() function, remove it.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index e3a9b785334d..ec3bbd199501 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -117,7 +117,7 @@ static void rgmii_updatel(struct qcom_ethqos *ethqos,
 {
 	unsigned int temp;
 
-	temp =  rgmii_readl(ethqos, offset);
+	temp = rgmii_readl(ethqos, offset);
 	temp = (temp & ~(mask)) | val;
 	rgmii_writel(ethqos, temp, offset);
 }
-- 
2.39.2


