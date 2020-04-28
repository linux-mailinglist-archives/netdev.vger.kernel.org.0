Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEC41BC153
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 16:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgD1OcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 10:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727790AbgD1OcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 10:32:00 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9CDC03C1AB;
        Tue, 28 Apr 2020 07:32:00 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id y6so1229284pjc.4;
        Tue, 28 Apr 2020 07:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IhyP4f8AVV1sqnFFlCsqGqgrzMt0SiM3qURiPJRq3p8=;
        b=aDyMaGyfZUMROiIb3/JW8nCVu4aOaUcQviH/y1F+ivZbVlOxsopjT8VcJJdfIq+XmB
         s+RCqL1jimk8ebYGKfPVdu2rjbo8lOS8flP5Hn/rIxFoRKaTWAVAWr2MDnZGkii8mh+q
         3wiudRc6CVIRmWNeJqBjgKzkvYCW80IW18Rqp5U2rci4AXVVJ6gggnyIuLmKwUpZt3rp
         CJ3O56QCbFSCv4f+lFBrCrRLF2OpCyDeBJm7JWZDWeY/+FNYhMN1LQx5YMT3cWYewNxr
         M5b7IsBC0SV3BtGH9NRfFxGrwMGXX+2R48k3r2okzHLKKyS9Xu3bUvvnnlV2iVazNfG4
         3fjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IhyP4f8AVV1sqnFFlCsqGqgrzMt0SiM3qURiPJRq3p8=;
        b=dzRsDrQVuoUD9um8JBP+syPm0s/rrJ3lf180OuWThjsBnJgW1KZuzVTrItNa53P1UQ
         7nkrsP50/ukmbdYRg0w147NfswXhhoq33ZKJgud22+HKfDaywFHjZIwhSi7k6KOWQ/wy
         kYXBZKYoGK4XFcWVCzlPv9Yvr0NaIq6byiNS1WqyR2Bb4RRpu47yTbxuKfUNI/Kw7mal
         GQyEyO/GvXqzYj6uLJrjpkZ0d4eLq490B85wbMfk8TgwQ9az6cYwcS6UyNVKKlBrFSTA
         crHtC/Ixcv+Sv6p85wN6vSKzhD4tiac/eLvC2UBUscxVCHnjlYLXSZT1F7tviVzjBmqz
         dL3Q==
X-Gm-Message-State: AGi0PuYNfgZbWoh4s8+1A6ZqjbPZdp1x/RSw27urGzRK4QI6CD3qmyE9
        /oy26v3GvxdBbr1MPgd/n/U=
X-Google-Smtp-Source: APiQypKfhzknU9mOLb2vJO4swAbCVUZu/KiJbCHayzvFpwL+Idv+LjNL8Xxm6iMN0zGwK370D7Ek5w==
X-Received: by 2002:a17:90a:d17:: with SMTP id t23mr5749260pja.77.1588084319572;
        Tue, 28 Apr 2020 07:31:59 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id b15sm15299195pfd.139.2020.04.28.07.31.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Apr 2020 07:31:59 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        royluo@google.com, kvalo@codeaurora.org, davem@davemloft.net,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net v1] net: mt7603: remove duplicate error message
Date:   Tue, 28 Apr 2020 22:31:52 +0800
Message-Id: <20200428143152.3474-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it will print an error message by itself when
devm_platform_ioremap_resource() goes wrong. so remove the duplicate
error message.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
index 68efb300c0d8..de170765e938 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
@@ -20,10 +20,8 @@ mt76_wmac_probe(struct platform_device *pdev)
 		return irq;
 
 	mem_base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(mem_base)) {
-		dev_err(&pdev->dev, "Failed to get memory resource\n");
+	if (IS_ERR(mem_base))
 		return PTR_ERR(mem_base);
-	}
 
 	mdev = mt76_alloc_device(&pdev->dev, sizeof(*dev), &mt7603_ops,
 				 &mt7603_drv_ops);
-- 
2.25.0

