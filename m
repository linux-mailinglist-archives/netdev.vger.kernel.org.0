Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD973649971
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiLLHTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiLLHTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:19:02 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071AD9FE6;
        Sun, 11 Dec 2022 23:19:01 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so11195747pjd.5;
        Sun, 11 Dec 2022 23:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ONPGMnh5Fw6BHhCbkE+h8VCgmMNVmswppWLHb8DLMc0=;
        b=J4CnII2++jeFhoVoNvnz2oqJMGphS6VvsVJGds6/470KDoUSx6Fjr42pHWCvWBeGw7
         Ur8AzJdN1F4HclDOoX0Y8GwVCbqx8NoC5ffqHAVzyKH7zg3JhLdPoqfK7r9W/Enn/Prg
         MGS7L3eRuiNPpJMm8GsGogZ5K/EXyfYGHMPZR2O4HewDAZrNlM8/GjW2aSZkP47ZrpGH
         MDPyuKrBK8m6DQgNEUncJBLOgOKA0/EGcHgEIbROhS1+O2lUtcV2OOo9gePTANcDGAuF
         nBzBNZkx6WHO/KSZoZoXnYnyuMUQUGGyAzRdVc43CXsUo1PtQVIMg7XTk48N+cE4yTcj
         BoEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONPGMnh5Fw6BHhCbkE+h8VCgmMNVmswppWLHb8DLMc0=;
        b=rtK3hAuiv5yDcF6WhQpT39N7NtYVMb92EyKU/veqiU/MxJBEwmAHO/C4lWgGNKRyXT
         3hwdojZix27fF2iRhV65eExzCI0LtsZJZK4uRv3AgsxA4mff0R/TnOtz4QlrriqV8DxA
         MC3LNi9t9EN6YWqa/MR0XG9kWymMzlyg16zAQJaTt6o0f1tUg+vVm+q9uMMl0TY+hZrM
         Wuk5X0x1vyDR8Wb3kTNx8Nt+W9xhoqSxgbhVhoPHtqVxr6UaTR3UXWde1wGehZMEHPA/
         SczTJtU7gF4KZfS7gMdAG3NKdO4w/YQar/fQdWLHwaOMtKiN3x40idPI3jCR7+EGqjAw
         g2AQ==
X-Gm-Message-State: ANoB5pnn0SC9VR8WqU9awBX8zWa5kqqwAZqCZktomO5BXWr9Ftl+ixrz
        8dT1PhKdQK0XSnL5OX7sBKE5Mn9LSDtnjOEsavY=
X-Google-Smtp-Source: AA0mqf5o5zwwUUwGpad1CNAV/g6prR+zs5qMP1puOfEZv3wIOZKxS+69dp8yoluxnHeGzthLAd/izg==
X-Received: by 2002:a17:903:18c:b0:186:b069:98d5 with SMTP id z12-20020a170903018c00b00186b06998d5mr19429149plg.69.1670829540400;
        Sun, 11 Dec 2022 23:19:00 -0800 (PST)
Received: from localhost.localdomain ([14.5.161.132])
        by smtp.gmail.com with ESMTPSA id n8-20020a170903110800b001865c298588sm5522080plh.258.2022.12.11.23.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 23:18:59 -0800 (PST)
From:   Kang Minchul <tegongkang@gmail.com>
To:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kang Minchul <tegongkang@gmail.com>
Subject: [PATCH net-next v2] net: ipa: Remove redundant dev_err()
Date:   Mon, 12 Dec 2022 16:18:54 +0900
Message-Id: <20221212071854.766878-1-tegongkang@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Function dev_err() is redundant because platform_get_irq_byname()
already prints an error.

Also, platform_get_irq_byname() can't return 0 so ret <= 0
should be ret < 0.

Signed-off-by: Kang Minchul <tegongkang@gmail.com>
---
Changes in v2:
  - Annotate patch with net-next.
  - Remove unnecessary comparison with zero.

 drivers/net/ipa/gsi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 55226b264e3c..a4f19f7f188e 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1967,11 +1967,8 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 
 	/* Get the GSI IRQ and request for it to wake the system */
 	ret = platform_get_irq_byname(pdev, "gsi");
-	if (ret <= 0) {
-		dev_err(gsi->dev,
-			"DT error %d getting \"gsi\" IRQ property\n", ret);
+	if (ret < 0)
 		return ret ? : -EINVAL;
-	}
 	irq = ret;
 
 	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);
-- 
2.34.1

