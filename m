Return-Path: <netdev+bounces-11875-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B196734FFA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 169E428100D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6647BC8F4;
	Mon, 19 Jun 2023 09:24:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0C6C8D1
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:24:22 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD13188
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:20 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-311153ec442so2298296f8f.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1687166659; x=1689758659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r1Ok1IYka1vb/vM8tvKH2bExKZHEfvi4JId7lcZB7pk=;
        b=kyHT8TL+2GSjjQREnvB3sDGmITerXPnmzkNogrnyC+QjJOC6XyLg2cdclezHjWaXPH
         zfGTSZePqXBZcCL5FKoRCWQsiHOxWONCURN9XFcfwFtqHLxK0VGUv47VJ/iKqP8ivnUT
         +0qyHmkDi8Ja6fQ+JssQeGdFGfISfMn2BCpDgdTrg6ogiAmIqnVsSn4odIrAeGc7XsIE
         UXGFFyF43iaDeIM/9rgTPFr5eN9CQwYmiTll65ySroOyumfs++eBFi/EYb5rTIQ+Napk
         IvKkDERUvy0JAY9sWgZUu3b1zF/YjGTGMOb6738nk6iU0q6Tj49q7Wz5E89jPFwxkD/Y
         5RYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687166659; x=1689758659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r1Ok1IYka1vb/vM8tvKH2bExKZHEfvi4JId7lcZB7pk=;
        b=Ru057+E3Tax/a0B9GhXPYBtkmauMQ5iSHkRUptC7RgT4YmCsbFqQArhc8ZYH+8vLRH
         aTbKJAGYNWxSBGdc2OJZ5+ECVK2csPwd6IXi1Vgy41RkgVQyqWSKxQsfGBAp94TS2mu4
         noWVodxMHXTGodcaeD1SPf8hXTsTj6SwA2ktULpe5pwmlRpqAa0Jq3xz9XFAcxdsHK/X
         7oyoMB4ZJl5lCuzCgpgGJqgX0AouQaGNbEcw673ciuaqsNm5Xpea3pLMRl89ey9zk6c0
         Oix8qaQo9gxlvCb4rhDks96vtbr3lQK41zHUfgjCqo8DdAp099eCqP4r5/O5uQEQaeWa
         VcKg==
X-Gm-Message-State: AC+VfDwnmvdlwPJr+a/pbUf+OmuzAOIok6NNQSU4hxs/56fsG5CWP8f8
	qcx3/y9I22ym+oPGEm8BsIE/dA==
X-Google-Smtp-Source: ACHHUZ4CVUlTIzAxN+LAPNfnxBCniWd6XVG9x7Oys2PrG/4EHzRom2BdwYzcTsWwhaF6q/GoKdWTkA==
X-Received: by 2002:adf:ce84:0:b0:30e:5bf2:ef1b with SMTP id r4-20020adfce84000000b0030e5bf2ef1bmr12363169wrn.25.1687166659271;
        Mon, 19 Jun 2023 02:24:19 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:d9e8:ddbf:7391:a0b0])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b003f7cb42fa20sm10045229wmj.42.2023.06.19.02.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 02:24:18 -0700 (PDT)
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
Subject: [RESEND PATCH v2 06/14] net: stmmac: dwmac-qcom-ethqos: add a newline between headers
Date: Mon, 19 Jun 2023 11:23:54 +0200
Message-Id: <20230619092402.195578-7-brgl@bgdev.pl>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Typically we use a newline between global and local headers so add it
here as well.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index b66d64d138cb..e3a9b785334d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -7,6 +7,7 @@
 #include <linux/platform_device.h>
 #include <linux/phy.h>
 #include <linux/property.h>
+
 #include "stmmac.h"
 #include "stmmac_platform.h"
 
-- 
2.39.2


