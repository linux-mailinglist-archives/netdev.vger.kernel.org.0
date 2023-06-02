Return-Path: <netdev+bounces-7544-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58E5472097F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04766281A94
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349931DDEA;
	Fri,  2 Jun 2023 19:05:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2633619E45
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:05:24 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C380E77
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:05:13 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30ae69ef78aso2883328f8f.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 12:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1685732712; x=1688324712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=If31y072xq4e6P4sxZ7wENONrwovu6qw7j2QcnCLwYM=;
        b=iw2od1eb1LLnTIiTck7tEolOQHlCSsiuiuK5Az1wQSsyQuGpmGKl+Ddz6oaTtYMOzE
         T5Pnesq+GFxqESCem3TjpoUlvFNgtO2PKO1B0wmLT590vpkWUz+hZIgTV49nhewaoPhO
         /R3iGhEYJouZbX9L1pxez8SCfqDXal7HKVE7A29/lYBlkkB14Z+itAmcRkIA7BlSJAZl
         iooncu6iVfqshI8TqaN7O8K152pq1VBbizt+FTAQSLTp9nsQ2Srm5C/AJJlUFwbKsC1K
         s3o/b2T4EwBTJ8ng314F/99Imw/npLH8nX8MwWUCryUxytFt+vMpaQRNOed9724L0UZZ
         LKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685732712; x=1688324712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=If31y072xq4e6P4sxZ7wENONrwovu6qw7j2QcnCLwYM=;
        b=iLxHsXACkogyrCYOJnmuTOgfhZT1veS2HmwHmF25cqAtjwh/BValBE7OuHAhmAu3jG
         SSEHmkbNxwpXq/Rbmdqc27WjZj6sKpMGgMP8HLEkDenz4GJ+uKj0EWGvGVi+PE82r40D
         Gt5yYCOpnCEsmYhztEUUN6p7HJDemYMtRlTdt7FxG29OYHdkbrCI/4DiltW9QKZz2GpV
         cU8JRwsUPzgMde5zExTb0ywmSwAlu9G118GRZqt53oLcERNIkzl6hyVtu3wLOMEHD4WN
         BD7oVlXrZQ8dWIvFSzCnJQTdw4mp7tbXZfVotb/qfHLnsV0kvBo0450P6OgeYtu5b+JH
         XS8w==
X-Gm-Message-State: AC+VfDwMHpqzACvBuwzI2MstUY/dWvA1lEBg+A3yHH5NQz22Aa2z7tsb
	6CACmS+kMbA6MTk3SZYKcj+Ysw==
X-Google-Smtp-Source: ACHHUZ49cV0H3yp9vW9BOannfVeKeUwyqy/UKFpf4uPItZATZzhUiTC+cpJxJ2yN3zr/xYJXdhwL5w==
X-Received: by 2002:a5d:6b0a:0:b0:2fb:92c7:b169 with SMTP id v10-20020a5d6b0a000000b002fb92c7b169mr585237wrw.10.1685732711749;
        Fri, 02 Jun 2023 12:05:11 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:7569:c0c0:3a0e:c54d])
        by smtp.gmail.com with ESMTPSA id y8-20020a056000108800b002ff2c39d072sm2361029wrw.104.2023.06.02.12.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 12:05:11 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
To: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH net] net: stmmac: dwmac-qcom-ethqos: fix a regression on EMAC < 3
Date: Fri,  2 Jun 2023 21:04:55 +0200
Message-Id: <20230602190455.3123018-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
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

We must not assign plat_dat->dwmac4_addrs unconditionally as for
structures which don't set them, this will result in the core driver
using zeroes everywhere and breaking the driver for older HW. On EMAC < 2
the address should remain NULL.

Fixes: b68376191c69 ("net: stmmac: dwmac-qcom-ethqos: Add EMAC3 support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 16a8c361283b..f07905f00f98 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -644,7 +644,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	plat_dat->fix_mac_speed = ethqos_fix_mac_speed;
 	plat_dat->dump_debug_regs = rgmii_dump;
 	plat_dat->has_gmac4 = 1;
-	plat_dat->dwmac4_addrs = &data->dwmac4_addrs;
+	if (ethqos->has_emac3)
+		plat_dat->dwmac4_addrs = &data->dwmac4_addrs;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
 	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
-- 
2.39.2


