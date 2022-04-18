Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1721504F22
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 12:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbiDRLBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 07:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiDRLBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 07:01:20 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAF21A042;
        Mon, 18 Apr 2022 03:58:41 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id f14so1284789qtq.1;
        Mon, 18 Apr 2022 03:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBHLdf5+QvefwDR+UhIgZhMctiIYYUPTV5ht3ttk1gk=;
        b=acrUETUXsRb90NVKhjM5cMILzL7ERa5tJ8Ksj/KOX8YtBm9MKbkhG6x0n5PF7lF97w
         Zm58YAChUX7Xi0yWzJAS7XsJrTEt8qVpKLJXHQmZ4uamK1uknTJ/45hsygi7m2WljddN
         wGBLn1SOv9s0KOfQWrfCyyT9kLOaPXVOudu6DTMIh566ZMZkx1m+GG7YdZ8R/EJbhCNB
         zejgQ722ln4xapLL1BekXFHvbE6s8dPVj7lrJPOZGv1dMsxp9VGNKj37RZfUDRRbVaZM
         CLUTVR80ZW4MqYgklAcV4HN3ShbMeFXTqNrLxiJ0tlU6KmH25a9TYBDV1yv9bMMAdbNw
         eOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBHLdf5+QvefwDR+UhIgZhMctiIYYUPTV5ht3ttk1gk=;
        b=iifynv7LIIvTKcGF2XiXVbJk+IDDiw7LU9B17m403AT1lOwoXt1YzwoDxc0915Nb5+
         sz5fSbPPEfY0Y3+dy/2E4GzYSm3H13YSHLfnLmUbJlsIX2BkoVC7b+cM1/Nhv+hEe7Xz
         6nNofzTUfQpPhp3XGJ5syx3jt8ZYBP6rMQxZ5oBKdawkjbaShEZtjkiOeLTfSL7TvLtT
         STCAOBOpNs4Fy/MpbwbRzJPnx2gzPke1dJznFzUFo78vctrFf0mkkXhjbqfykDrDFCVJ
         J1yEkQa62v3nI6YoM8wkI6akmzobEp85OCYZ6wl/NNwbW/ME30VwitF7P07R9TsRjpW7
         HSdA==
X-Gm-Message-State: AOAM5301Os/yF9SkiUDYf9jT53DS8Vhbps5uCUcvvoMrl6lWTHzU4KCw
        pdrOhkLzldxRpHfr7wtH5bY=
X-Google-Smtp-Source: ABdhPJxB0KSRZZbyLt6TfSDJ4wxLwKuIblWJKAELuPfHGq6ZPmLo0AtCEWuTbKMg+NJK0UzqXmgQ5Q==
X-Received: by 2002:a05:622a:164a:b0:2f1:ffab:b3e0 with SMTP id y10-20020a05622a164a00b002f1ffabb3e0mr2430888qtj.553.1650279520751;
        Mon, 18 Apr 2022 03:58:40 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b9-20020a05620a0f8900b0069e84c5352asm2689907qkn.47.2022.04.18.03.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:58:40 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     kas@fi.muni.cz, davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: cosa: fix error check return value of register_chrdev()
Date:   Mon, 18 Apr 2022 10:58:34 +0000
Message-Id: <20220418105834.2558892-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

If major equal 0, register_chrdev() returns error code when it fails.
This function dynamically allocate a major and return its number on
success, so we should use "< 0" to check it instead of "!".

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/wan/cosa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 23d2954d9747..1e5672019922 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -349,7 +349,7 @@ static int __init cosa_init(void)
 		}
 	} else {
 		cosa_major = register_chrdev(0, "cosa", &cosa_fops);
-		if (!cosa_major) {
+		if (cosa_major < 0) {
 			pr_warn("unable to register chardev\n");
 			err = -EIO;
 			goto out;
-- 
2.25.1


