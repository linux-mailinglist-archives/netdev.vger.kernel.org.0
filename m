Return-Path: <netdev+bounces-11394-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB2C732EA7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C221281798
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C236613B;
	Fri, 16 Jun 2023 10:34:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9531990A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:34:10 +0000 (UTC)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B8F55B4
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:33:50 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-983f499fc81so71555066b.3
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686911495; x=1689503495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l7UUUCEiDOQDFLQBmgYOU/VRB87rfpeTkrh78SXewlQ=;
        b=cYdvibiK6wuol8x9Bae5L8jbyUJor2BFpQ+IvmqbrkyV4XE169xtPQhWFeCJVy2mZC
         S1y8KJWNQoZ6Tt6f61tdQZ17mQ7/Khy4qJ4/OOfzg99RWHHtZG3revanHGAsMpz4agYc
         qmEGJ8aps2q7Vq/Hyyr8/f36b/dmAxKdaqAClpriOsphBx8XklyaUzYZWOfDx1tG+lGE
         Uog6nTn+xvetwk9YuYQwHqu8XtxyrP0JyAdaPWm+3GxY1hIbxEL8GU56nKx/B4FxfXVm
         FRRIYZKC5eguyHZXHgMEpGAqpfN8O4w7/L2gSsigMBEWNLeTPNevOvV3B+Y4AVR9XOFd
         rwDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686911495; x=1689503495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7UUUCEiDOQDFLQBmgYOU/VRB87rfpeTkrh78SXewlQ=;
        b=Vr4WPLkU7hGKBtLm6QW6SyGoUWZ3jDlodJ9BtoU5xlGRKfdUi/dWup+1OhsNkKOnNI
         Gmt9bbILfhMcpeWzL+7Gf0ue5kSuE19q6AeqDXmWwWYsw7a6SlowAmrTqghZ1aUZeluU
         n6M128vdH0nvH9PFDgDrsowvLWv8YMCwE5X44WwggPDjNdM2uEdf6pEtsapgiqoJUpO3
         gXgGXS0cYiY4+FtuIVADuEa7LK2mqtp2LhCvEABEhNZM1GJJ+Uy6xbboAJrJcg3MZefT
         XcwywZ7Bf9DOEKoWv8rz0/Yj8JxcZk2C9DcPEhm4lIdKW0Bn0lDVtd8w7MYgMLmqESuo
         FjGQ==
X-Gm-Message-State: AC+VfDxdOpCMc1JWkITN8Ij1O5IG56uaN0X+R/cw9r7+i98SYmFVg1fc
	bQ4GShRcsxMGjRJpbOlNmgwf5A==
X-Google-Smtp-Source: ACHHUZ79+WHZQfcfy/frvys94Lo80cA+tl2FV9KD8MCaSKzol/5ipwbVMZ3T04P7GsrXRUhcD5vRDw==
X-Received: by 2002:a17:906:da8a:b0:96f:e45f:92e9 with SMTP id xh10-20020a170906da8a00b0096fe45f92e9mr1493906ejb.16.1686911495167;
        Fri, 16 Jun 2023 03:31:35 -0700 (PDT)
Received: from krzk-bin.. ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id s20-20020a170906961400b009829d2e892csm2251098ejx.15.2023.06.16.03.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:31:34 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	devicetree@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [RFT PATCH 1/2] stmmac: dwmac-loongson: drop useless check for compatible fallback
Date: Fri, 16 Jun 2023 12:31:26 +0200
Message-Id: <20230616103127.285608-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Device binds to proper PCI ID (LOONGSON, 0x7a03), already listed in DTS,
so checking for some other compatible does not make sense.  It cannot be
bound to unsupported platform.

Drop useless, incorrect (space in between) and undocumented compatible.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index a25c187d3185..900972521b59 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -59,11 +59,6 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		return -ENODEV;
 	}
 
-	if (!of_device_is_compatible(np, "loongson, pci-gmac")) {
-		pr_info("dwmac_loongson_pci: Incompatible OF node\n");
-		return -ENODEV;
-	}
-
 	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
 	if (!plat)
 		return -ENOMEM;
-- 
2.34.1


