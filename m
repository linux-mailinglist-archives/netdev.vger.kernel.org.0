Return-Path: <netdev+bounces-10036-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 289A072BC49
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDC31280D68
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C5318C00;
	Mon, 12 Jun 2023 09:24:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D2C18AE4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:24:43 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA1C210E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:41 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f6e4554453so29315965e9.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1686561880; x=1689153880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6Qql4lmrRc6orjCzbHdO+X/jI0p6UbXCT7w4xaPn70=;
        b=r3C+LN0I7FtVIMevczG2G4gXnrbL8tV0VWh6EO722HqR8GSaE0sIdbfNRfxVxFLZ5B
         KBIgDCk8KbY3A1fU3rbQm5hg/qG9fiu/Qh5osa9r5C1dsQA0Xew8j5mZNyLKuBNimXuJ
         6e0x0WmGekpMepRjwxkoNwMoSWLpFysA/e7TXwQ9HxvqKKEmDAkTMxo6WGY5DU3VlT33
         NHaWsB9EL8reOpnI+0F5kohXV0fYBfz9i83cHE6asArFI1iLJgt+h16f1Yd5ENreccvG
         guXlbNPG/FuHocWDWvE5pg2eRqhyFAu+oxb9QULwsW/TV/ONDHrPilSk3mWzsETb+yPC
         RCfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686561880; x=1689153880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6Qql4lmrRc6orjCzbHdO+X/jI0p6UbXCT7w4xaPn70=;
        b=aF08zGsWTmsASkVdXLekzt9qXnlW8R1/RSNtMlViPlmhR5bPE02TeaYSuo+OAjwsoZ
         U+nMfcfgZRdh0QS9Fc9wCebkZLlj8VHFxU+qv0Dm+/KbpsTrYk+/yBODJYCASEbA++hA
         zffWzttMw8H1/KYhOBf5TZ/pNbxO5iIn+xwqoyXGY7p/VZ5PbdnCqDOWSYDoMoN6spwz
         B8VLwkPAmefvXu4lzmvipOsp0o34icj3mF2AaKqB7Rk53Qju4wt92C5vebjxZzpoXFer
         QA/7vvMKn4U9crvVirLDmzR1xDVSvrAFSrBVWbMOA6OTK6bVunP6uuHrrNpo9axtFlfQ
         hpag==
X-Gm-Message-State: AC+VfDyM4HKmN7UeJvDKyZAOT7sCA+Qy0kCx7D3JIu4/900VxWwIlGPB
	d+pHnp0gJ3ALozKh2uqwmlZnTA==
X-Google-Smtp-Source: ACHHUZ4pVmMwHGX7bNbtVfB97Jl65MLcpOZps2ubdvFDgRPuGgLyhLlZQF10mQYnesEmUQW2Dqf8YA==
X-Received: by 2002:a1c:7c19:0:b0:3f5:ff24:27de with SMTP id x25-20020a1c7c19000000b003f5ff2427demr5380405wmc.32.1686561880266;
        Mon, 12 Jun 2023 02:24:40 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:a222:bbe9:c688:33ae])
        by smtp.gmail.com with ESMTPSA id p14-20020a7bcc8e000000b003f727764b10sm10892044wma.4.2023.06.12.02.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:24:39 -0700 (PDT)
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
Subject: [PATCH 10/26] net: stmmac: dwmac-qcom-ethqos: add a newline between headers
Date: Mon, 12 Jun 2023 11:23:39 +0200
Message-Id: <20230612092355.87937-11-brgl@bgdev.pl>
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

Typically we use a newline between global and local headers so add it
here as well.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index ecb94e5388c7..5b56abacbf6b 100644
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


