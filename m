Return-Path: <netdev+bounces-11876-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 440ED734FFB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F376A281056
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DF7D2EF;
	Mon, 19 Jun 2023 09:24:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A4D2EB
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:24:23 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB18E197
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:21 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f90b51ab39so16629155e9.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1687166660; x=1689758660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMgaAHe76eIn3F9IB6JgFSErZkAha9wqjAecsB/W5Vk=;
        b=k6hUzsBdbW852NGN1tgRKfvV8+nCAhx6DYEPsgRjsWlZ0BTtUlFExnS/x1vqW5n848
         D4J1nktobWGcUq4l0hluW577VVrCeg+Py9HYgt4695ySSnSmkrlNnPc9RmtNwK1stwQY
         Jsx7XXRnhk6C5mQ9jTw5RboNB4higsW7c0F1HuaeZPTCaTdjtY3R4V+K7+KysIzkdj27
         0XuGEv7CgJ21CbJ9AhNl9A49Los6afD9v2IgckI0lgFJ5E1+v0rzd1bwrf/aPs16VOrY
         475v0VPp49d8KiURbla6ANCC2JIWJ7/gVEUG2XUk3sOD9fLBi9Si5IQtVkkJbLAR1T0L
         l8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687166660; x=1689758660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMgaAHe76eIn3F9IB6JgFSErZkAha9wqjAecsB/W5Vk=;
        b=klJN5tqPoL6WJm/7Gy2WHgj92j3B3vOQTqmGmI8krSXJc3BeolpTv2mrlhy0gShkCL
         OBjdlRiIfWYgSL8uhjoXJ3kbRbZl++eV5JJvTK/5GQifkp5nYmmn0cmasSG75MFvbIOt
         0yVqgqkUn/TVmeh4gj6sbI9tdOzGMreGc9oe73QTFnUKwxnLNyJ6f31C3Pexox6c02U7
         isnPO8XOjXzF6z33O036tlthCXqvBYao01MsRcH2XV+2prJc7YBRC2cLoqwN2iNRd2VM
         dCRYpDTMAyF93jj4T1Xpz1UXWMbdGaxsJMm1Pnsv3mtduoBYWVpx6vIUdUX5hxJMqeRQ
         Q/vw==
X-Gm-Message-State: AC+VfDy+fpTew8D6YOtZGbhjTd2Za4p05z4nPMYv52qlbJP0AD4p7NwJ
	Ebc3M7TG15QzYoLn052RtI8zZA==
X-Google-Smtp-Source: ACHHUZ6Nn/68uiujSBlIeSENzRMSR5Q+y8Y7jbVXv2vkfmhUq7+1i9cbhugLNdmWErDKVc9aUsPEZw==
X-Received: by 2002:a7b:cb56:0:b0:3f7:e48b:974d with SMTP id v22-20020a7bcb56000000b003f7e48b974dmr10384783wmj.27.1687166660443;
        Mon, 19 Jun 2023 02:24:20 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:d9e8:ddbf:7391:a0b0])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b003f7cb42fa20sm10045229wmj.42.2023.06.19.02.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 02:24:20 -0700 (PDT)
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
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Andrew Halaney <ahalaney@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [RESEND PATCH v2 07/14] net: stmmac: dwmac-qcom-ethqos: remove stray space
Date: Mon, 19 Jun 2023 11:23:55 +0200
Message-Id: <20230619092402.195578-8-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230619092402.195578-1-brgl@bgdev.pl>
References: <20230619092402.195578-1-brgl@bgdev.pl>
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


