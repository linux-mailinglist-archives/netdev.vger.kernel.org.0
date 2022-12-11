Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231DD6494B9
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 15:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiLKOrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 09:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKOr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 09:47:29 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EA26362;
        Sun, 11 Dec 2022 06:47:28 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gt4so7790437pjb.1;
        Sun, 11 Dec 2022 06:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xyZZ+L/Y62MmgvSN94ik5NgXzZWoDImlIVEuvBQ7iD4=;
        b=NkA02UVATRw+n3p+5Vvo5BA2WBp570KQqI27fYT8PjmEAechLrUd9IBMWSIH5X/u9j
         K78qpBRwTOg1d3AqQjl1kbziAzVtGxvUveZItku0mk4UuTVKMpkh1UwNBC/X4cqX3Faj
         ivr4O73k5vVVddyQ0n0BY9jwqOxwN+wDFikOum0CdxqHeonrbX1fJG8cF2Ib6Dm8AUnM
         eGouubO2j+PyVQjQsd0/5kxX3rFbOBy7DWXtkDuXSOZs5ZPt/vGzb7R4kvQF62gbqrar
         +yrcr/2pSVMX0gu2YDr4BqCpc1NhzG+6FlSXa5+o8VMtSAUHnlnGbCSpRGHfg4mxRgwN
         962A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyZZ+L/Y62MmgvSN94ik5NgXzZWoDImlIVEuvBQ7iD4=;
        b=L0rmuETmp+Ozi9zWsEzZGpIiEbRKS9eDyGtpiQUjzBSJLEfqNktTsp6twQ18uGCyEI
         KKMaPpPcX3OR6bA4pfrR4NeSMfm5fpKKlT+MBk+rU7AysghTo13GypB8hPZuD0q2a5Ux
         jCguh7YRHmDAHN1lFQ6EMRV2bCUbDiNoKzQ9v1/U6kcHQBJVW0Vmsl4Absk0amWlH8bZ
         UgzV8SK5LQ1IE+VPV91eAVnNXdSPbWEV5mGwPVK47iYd5At+OPcn8WpRmcyAVIlT/SLX
         aGni4phWc/BKt7YrUDZnJ29CX3icXgizGEMCgrih3Lu6RXe4kl9jrYrSN91hFgsNaXOo
         j2cA==
X-Gm-Message-State: ANoB5pkC1QBCB2SnGQjLc7o8o/IOZdkJ1VFgimB1Y/iY19Fe5PNU7Db/
        ZdcmFgQxSouJHC4pGNVu60zkYrDTVeAzsbkFSbU=
X-Google-Smtp-Source: AA0mqf6lbByyEipkn6O5W7KOKS52frt5Bhws8DOEYUIgq8MUKmaHExdI0ykApyp1o9+TnNaOADE+Sg==
X-Received: by 2002:a17:90a:4707:b0:213:519d:fe81 with SMTP id h7-20020a17090a470700b00213519dfe81mr12859334pjg.38.1670770047745;
        Sun, 11 Dec 2022 06:47:27 -0800 (PST)
Received: from localhost.localdomain ([14.5.161.132])
        by smtp.gmail.com with ESMTPSA id hk3-20020a17090b224300b002194319662asm3877184pjb.42.2022.12.11.06.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 06:47:27 -0800 (PST)
From:   Kang Minchul <tegongkang@gmail.com>
To:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kang Minchul <tegongkang@gmail.com>
Subject: [PATCH] net: ipa: Remove redundant dev_err()
Date:   Sun, 11 Dec 2022 23:47:22 +0900
Message-Id: <20221211144722.754398-1-tegongkang@gmail.com>
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

Signed-off-by: Kang Minchul <tegongkang@gmail.com>
---
 drivers/net/ipa/gsi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 55226b264e3c..585cfd3f9ec0 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1967,11 +1967,8 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 
 	/* Get the GSI IRQ and request for it to wake the system */
 	ret = platform_get_irq_byname(pdev, "gsi");
-	if (ret <= 0) {
-		dev_err(gsi->dev,
-			"DT error %d getting \"gsi\" IRQ property\n", ret);
+	if (ret <= 0)
 		return ret ? : -EINVAL;
-	}
 	irq = ret;
 
 	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);
-- 
2.34.1

