Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25F345EF3E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377476AbhKZNkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348782AbhKZNiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 08:38:17 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD73C061D62
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 04:50:28 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id e3so38561094edu.4
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 04:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Afb6GY02tUx/or7e8nmWuuGEmUs40Pdlk3IO3jzyn4=;
        b=hGsYHWrmrxjXHVizHiyGTkB3IGtwdY5e8kfIOoYGUTG+iEM7R5OyF868lJ4iLZBizI
         JcOvorlYR4m1LZ1IkV9S3QgvuULRROe4yfooC5QIGUr/nGf1qwganqOG72Eg4BBoSlhY
         sWaUTKHO59MyE/wrkPm1SpE/ql9eJYYTk0w6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Afb6GY02tUx/or7e8nmWuuGEmUs40Pdlk3IO3jzyn4=;
        b=MSqTaEf3FTiNOmUbNhr/RRPpg9MKftswcArmZDbXcXoHnv3qYZXgMwMAMDWk9Q2FUl
         3ZSjATUwfpZUoR9gXOM0Dret15p2dQc7tRR7GJDAsOjh7qdXQfDMD20YeWKTR0+knts+
         2fjgsthepXa9WSDYkXlVK6I3R8fyoQ3JyyLVtorYbIHKv69SFfli1VaJYaDvW6/n7eLV
         LbF8SOeWibOyIMtUVbrHhkqX40YvjflgpYiBDdBaC/6LDP8jShCxABSKPWfV7yQ3nQBC
         57aGbVGrHVG5U9jZ7FEjnusGu28ceIbXnDYUH0QIhAA//tjUQwi6nmLJJNfnYBQz5ZUz
         2Wrw==
X-Gm-Message-State: AOAM531iKpw2zxdgNnJYKWyDrwuhbxqLkxHZ8Nhh3vF4APSbz/+tez0w
        p1wxvJRb3TqRTzLoUnVnp4YaRJf79q8FnQ==
X-Google-Smtp-Source: ABdhPJzB1O3yxArDdDcg7vwMZO6/+HCC1MFGCsWbSLe7V2Z5hNE/N5CExqJuEUB0MLEs0HOcIO9rpg==
X-Received: by 2002:a05:6402:270d:: with SMTP id y13mr47141871edd.362.1637931027437;
        Fri, 26 Nov 2021 04:50:27 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id b7sm4435378edd.26.2021.11.26.04.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:50:26 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net 1/3] net: dsa: realtek-smi: don't log an error on EPROBE_DEFER
Date:   Fri, 26 Nov 2021 13:50:05 +0100
Message-Id: <20211126125007.1319946-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Probe deferral is not an error, so don't log this as an error:

[0.590156] realtek-smi ethernet-switch: unable to register switch ret = -517

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek-smi-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index c66ebd0ee217..9415dd81ce5a 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -456,7 +456,9 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	smi->ds->ops = var->ds_ops;
 	ret = dsa_register_switch(smi->ds);
 	if (ret) {
-		dev_err(dev, "unable to register switch ret = %d\n", ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "unable to register switch ret = %d\n",
+				ret);
 		return ret;
 	}
 	return 0;
-- 
2.34.0

