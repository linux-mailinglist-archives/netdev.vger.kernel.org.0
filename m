Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D804C44D9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbiBYMqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiBYMqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:46:15 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D71C8847;
        Fri, 25 Feb 2022 04:45:42 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id n25-20020a05600c3b9900b00380f41e51e6so1624604wms.2;
        Fri, 25 Feb 2022 04:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=yEIaiA1NrghZjzhXX/phdHm6hU4qtoJeEjNpAfp3xQk=;
        b=GRAW2ESqZRhIbGEt0brYw9neU3QBESbHgyv7Jorzhzpvlc2lbnSBZeUpuWjxH9fns3
         6OAFgtDuWu30vMR+mGD70Rbf8EP6kVolExq8qk7FjIoi/EnJM0kufvjYsRa0bdYgn2kL
         Xb7lBXVFNsf9+F8zD4aYiN+5YaUBRWsEyr+ntRaUPXc7t4c9kW7iAsO1YonrdqqRcUXL
         aI13Nuvhy8S71GqzWPVttdtIPn4OVNEMnwzqsadmlyAPdlCfE5XYtqNTP2911d9OJNcP
         EOOCGRX4hqyK9W0cPqEGJvL3RTQBlfYvOXsMzyN7XG+tOsJC09bdBmrkUSmnAtg9DirS
         xRQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yEIaiA1NrghZjzhXX/phdHm6hU4qtoJeEjNpAfp3xQk=;
        b=qAqvGfHqiuWC1PdoDXFZdRV2/cD4CjpaqVj2cchjrD4tgOxLk0JXk8NrcDQXxH5Ji8
         iYZqouLuZV0nyawjLCkUZ2Kc+KhWgno2QTinxDrwKjsNUtWpphbwWwt9UuAiFQFh+vBG
         OjGC8RNChr6T5WNByAQPeRFdX9un3w/lmL86bL1ZHR11JEBVQDcNGyLzPErQmwUuBw6s
         gWEHuOk8TIuubazO6irJgxCj+dw/HDx5AGB/DkGjanshtnkV7RZiZvWE88tQIWhYpTFY
         gzVM9YEX3me6t9JFvKCmOKB//CTlDqE2+4HYkn27gTyMnM5/o8MsoArlPlGJwR1f5gV5
         dXiQ==
X-Gm-Message-State: AOAM533qYwM1SfWgaYqj6uR4qMaHGzL3fr8Iq6QphXo6tdwnnAdE+wyi
        Y6yCmPTtjkzxAoBDsA5qdqY=
X-Google-Smtp-Source: ABdhPJxKuVmSaGrQtZpZ1TmKfNnnLRhT8ahvADdeF+oBeA0j8oOmrP2KTfxiTeqeGey83hSHJ4dlaQ==
X-Received: by 2002:a7b:c057:0:b0:37b:ebad:c9c8 with SMTP id u23-20020a7bc057000000b0037bebadc9c8mr2635494wmc.61.1645793141106;
        Fri, 25 Feb 2022 04:45:41 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.58])
        by smtp.gmail.com with ESMTPSA id x3-20020adfdd83000000b001e58c8de11bsm2316115wrl.39.2022.02.25.04.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 04:45:40 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] video: fbdev: via: check the return value of ioremap() in viafb_lcd_get_mobile_state()
Date:   Fri, 25 Feb 2022 04:45:28 -0800
Message-Id: <20220225124528.26506-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ioremap() in viafb_lcd_get_mobile_state() can fail, so its
return value should be checked.

Fixes: ac6c97e20f1b ("viafb: lcd.c, lcd.h, lcdtbl.h")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/video/fbdev/via/lcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/via/lcd.c b/drivers/video/fbdev/via/lcd.c
index 088b962076b5..9aa331a4a605 100644
--- a/drivers/video/fbdev/via/lcd.c
+++ b/drivers/video/fbdev/via/lcd.c
@@ -954,6 +954,8 @@ bool viafb_lcd_get_mobile_state(bool *mobile)
 	u16 start_pattern;
 
 	biosptr = ioremap(romaddr, 0x10000);
+	if (!biosptr)
+		return false;
 	start_pattern = readw(biosptr);
 
 	/* Compare pattern */
-- 
2.17.1

