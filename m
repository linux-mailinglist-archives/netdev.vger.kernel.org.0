Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B76581DBC
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 04:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiG0CxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 22:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiG0CxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 22:53:04 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1461C3C8F4;
        Tue, 26 Jul 2022 19:53:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x24-20020a17090ab01800b001f21556cf48so780696pjq.4;
        Tue, 26 Jul 2022 19:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=oP5EcKUTnTotHqCr3RZjdU6N2l//ESkENxt8OIL1puQ=;
        b=e1VMT+MQCKBSorOASKzbpman+CU4Izb6XZ7qTSVB0yNsPwK0grZlXyL+KQ7KDti7m5
         Jn4PKkBdpBWwZsbcivSgI0Dq4w80Sv0siG0vpFGRlNT19s37s2s4Ff65mIwxisiHtzkK
         5DwTeYwcohOg1vUTj6cgFY1QEemY/RF654m0w0V7F0G7BVLqOQyxz4JqbgXRgsEY+xd5
         7aPhvtwW31XSKclhzTHPpRg4Y/wMuI3DDlB5Akx1IwteS1UEnmLeoX1AevJPZzWYrn4U
         2IkGqi33PaYgmOLSKpHb+NgGyG5s7C9bRmFZCgPa7NiGNEfBbJunYNpYgun5dbb733WN
         bp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=oP5EcKUTnTotHqCr3RZjdU6N2l//ESkENxt8OIL1puQ=;
        b=6u9Nlf7+lLiQz9arDoLV7qUiwHuYoS1pQXHf1aylnUZUQzPajoas72jMOE7lVFi+/t
         CdChGwQcIGHqoJXKrgJ7fxIhwPtNSizyxZXSZxadMefeGe9f4rHvtnP4iLsKY1nTlwrb
         0gDasMP1ZMFz5T2O0AEcM5pCVcYBWjhFXNvVE1dHF9hY01b85hPhz1FEM13LokjPyIW+
         CJ+fKGPeCpzi7sOtwmF4JPVPYqMUuDDqDadpTpc2Lf7RNo/bVRAEgutFrpxZJb7Smf8R
         WaJPgfSWCxxupyYz+SoEbZqkUmOSnnfegY6vJIeu0/5+ELEeud6XqEZ03q1wP9ovYruF
         C5iA==
X-Gm-Message-State: AJIora8UGN9m0q94oWUO/VdAiuvY7FnAISxUvlO4JJqfdLksMMAwofuM
        rkjBAlVZ3zXCMsiMvuyKHbA=
X-Google-Smtp-Source: AGRyM1uIT+u8rmBKWROAg/+c+QttLYk08s3kUbUZWuoS4KnuQ0LBg7naaCcAIqqGMKOMGLXYIDiaoQ==
X-Received: by 2002:a17:902:76c5:b0:16d:847b:a4d0 with SMTP id j5-20020a17090276c500b0016d847ba4d0mr9695493plt.148.1658890383475;
        Tue, 26 Jul 2022 19:53:03 -0700 (PDT)
Received: from localhost.localdomain ([122.172.90.97])
        by smtp.gmail.com with ESMTPSA id 186-20020a6215c3000000b0052536c695c0sm12743979pfv.170.2022.07.26.19.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 19:53:02 -0700 (PDT)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] net: dsa: microchip: remove of_match_ptr() from ksz9477_dt_ids
Date:   Wed, 27 Jul 2022 08:22:55 +0530
Message-Id: <20220727025255.61232-1-jrdr.linux@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>

>> drivers/net/dsa/microchip/ksz9477_i2c.c:89:34:
warning: 'ksz9477_dt_ids' defined but not used [-Wunused-const-variable=]
      89 | static const struct of_device_id ksz9477_dt_ids[] = {
         |                                  ^~~~~~~~~~~~~~

Removed of_match_ptr() from ksz9477_dt_ids.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 99966514d444..c967a03a22c6 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -118,7 +118,7 @@ MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
 static struct i2c_driver ksz9477_i2c_driver = {
 	.driver = {
 		.name	= "ksz9477-switch",
-		.of_match_table = of_match_ptr(ksz9477_dt_ids),
+		.of_match_table = ksz9477_dt_ids,
 	},
 	.probe	= ksz9477_i2c_probe,
 	.remove	= ksz9477_i2c_remove,
-- 
2.25.1

