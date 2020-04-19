Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2312A1AF9BC
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 14:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgDSMDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 08:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725841AbgDSMDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 08:03:02 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20075C061A0C;
        Sun, 19 Apr 2020 05:03:02 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k18so2857837pll.6;
        Sun, 19 Apr 2020 05:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mUMGk88U5GL86FJoQ9V9Sy5+QGtoY7CINQIBYemngGk=;
        b=mGNCuOkJ1DqqRMQ/kQKpBjTPFmssVItDq4hi+RubmRd6V25lx3Rlg66wUxHjukAQVy
         bCenWKIJuovAwd+EFIq0SDw43317uVGcOtk68a/qD7oXB7fvoLZZGIui2IXzfhHLFsNa
         szLPWiuh7pEgXqIFo8oZcckGIN1oqCU+LYmgywWly6hTqsBsmf5zAI8lvIfmfe69IQiM
         0faeVDeZCtz8aiNltK/ErIa/P/+R5mtt0sLHphidTBKyZjqs5/6jj4mrMLg5PVcOjI8a
         ajNl9joot/hgx2AUPLp6u6fp7OfjisdoK0yOZFmMJfQTJEtTgjDAxCNRa9h/KPgF+BcK
         CIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mUMGk88U5GL86FJoQ9V9Sy5+QGtoY7CINQIBYemngGk=;
        b=QN6yRyC3sPCf6J8Uwv5eOCy9Z6Natyr+erFbvbUQlIefh1N+C6EhrGoCj63QjxUe9C
         ++7SrTQQfs8d8SyWLOLr/AvGkdbKm1Kh6XeV9vYTtknvDS2vPu2mwgepdNo6+KJseDyE
         cRUtkPcwVoEV+B5TqLgqjqqtcXGjGOWzVFCjC7qAcDCbt97NwAAyuvdoZf5ckNylKm8C
         b/YH0wlLzAj9F2U2TeONR91UqzT0f05uwsRv0CLUjqFpTh5gwQb3WfjrhxkzfzT392aO
         3TEcbvejhTUVhNZyRbJ0WTmnXRRRYH9/LwbzXAT4yO8wmRxwP1HFc1LWQjUoHnChFPhv
         YHhQ==
X-Gm-Message-State: AGi0PubMogSTLY4fkfjTtvixdXtfm+MoFy/eKWzfO/T0IQHbB0a4f5KP
        YJCKWmCxEgbrwJyYaY/z79I=
X-Google-Smtp-Source: APiQypJ/bZH9MaTcH3mji4rprQa0VyYDHahZTEsbrXAoIJQXeW5SfXA+4idYBGMyIfl6i6Su2wVDSA==
X-Received: by 2002:a17:902:b487:: with SMTP id y7mr4856941plr.230.1587297781641;
        Sun, 19 Apr 2020 05:03:01 -0700 (PDT)
Received: from localhost ([89.208.244.140])
        by smtp.gmail.com with ESMTPSA id o11sm16358199pgb.71.2020.04.19.05.03.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 Apr 2020 05:03:00 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     davem@davemloft.net, f.fainelli@gmail.com, timur@kernel.org,
        kstewart@linuxfoundation.org, hkallweit1@gmail.com,
        tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v1] net: ethernet: dnet: convert to devm_platform_get_and_ioremap_resource
Date:   Sun, 19 Apr 2020 20:02:53 +0800
Message-Id: <20200419120253.25742-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use devm_platform_get_and_ioremap_resource() to simplify code, which
contains platform_get_resource() and devm_ioremap_resource(), it also
get the resource for use by the following code.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/ethernet/dnet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 057a508dd6e2..db98274501a0 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -776,8 +776,7 @@ static int dnet_probe(struct platform_device *pdev)
 
 	spin_lock_init(&bp->lock);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	bp->regs = devm_ioremap_resource(&pdev->dev, res);
+	bp->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(bp->regs)) {
 		err = PTR_ERR(bp->regs);
 		goto err_out_free_dev;
-- 
2.25.0

