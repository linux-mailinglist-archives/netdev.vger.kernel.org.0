Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8841E2878FF
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbgJHP50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbgJHP46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:58 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A80CC0613D2;
        Thu,  8 Oct 2020 08:56:58 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 7so4640825pgm.11;
        Thu, 08 Oct 2020 08:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dGhGOobaPW2Yyn9FO3pZkXJcwxpE34qEOqDFXN5Yar0=;
        b=BW/x83GQ5BIPmEeHhu6wP2btnYsX+v1ajfZCdAJKn2bwpH6SqYwhTj2L9zAa1lvggo
         Bu4bKEjD4f9VRbRRzNGPdhzmm9Ytk+N7IhHxmK2EYOm8MYiS1naKOgE0gegMZz8mHXM1
         /zY5zvmACByJQEB7MmoQjjN1re9NQE10pcGbVpXm65lmULbqgwflps9bIQeNYj2v8IuL
         uDrq+c43yqQ1L2+Eu6LadfgpECj7gQuaFySJs5vIqw5YwP7BRdn1qC4YnW6OHVioGLxO
         UmrkJ74eRFmKThLsGyfYwcYdiv0AxgEI1R+PlAJB6R54JYug9yhIGF7m6Ee7LN1/Pns2
         JZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dGhGOobaPW2Yyn9FO3pZkXJcwxpE34qEOqDFXN5Yar0=;
        b=tG8Sk7u+ybHWPXI+IM/njxVsOsJvIA+lEoOFMnZ+daK1wYWkWTIbi6o3mAS51FUWOX
         +7ghFWQagy0wazU62VBBbbdWb8ORwo2V31NBo2qjzDgWJAc6X0jWw75pZc2wi2oHaick
         /AwlPHKlV6rmOC5rbf4hAqUOc/VigrhJDIqvZWM/LKNVxY57u3ipPOnsrEy2zuNIUkqv
         SBV+cYB0XFMiGg/WNdLtNEogHE0TBQWurHwghKuTWyJUvO+Gbm8QazDs9uEroEvoeXEX
         Bjg+ZYSaDzt3JV8xy/+L8l8Z8quVrkFJ8xZ8LghkwXoYcZp4qiKP/tGjGJJtEH6HOtr8
         2Pxw==
X-Gm-Message-State: AOAM530maBPhfK+jwAYAes5iaQTeE7ozty9a/EG1d8qmpN7UIimzrsQv
        1pkhEeSAToEKzFUdLBWKXIA=
X-Google-Smtp-Source: ABdhPJwUvCnBnfdq36DOYyGffop5ULex1O+HU0w/VlHR9graPsX0GcpOYSGs0N4qnd6qAHlm5AwpbQ==
X-Received: by 2002:a17:90a:a512:: with SMTP id a18mr9066491pjq.30.1602172617671;
        Thu, 08 Oct 2020 08:56:57 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:56 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 089/117] wil6210: set fops_led_blink_time.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:41 +0000
Message-Id: <20201008155209.18025-89-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 10d599ad84a1 ("wil6210: add support for device led configuration")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 54285e5420f6..c4c159656eb6 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2179,6 +2179,7 @@ static const struct file_operations fops_led_blink_time = {
 	.read = wil_read_led_blink_time,
 	.write = wil_write_led_blink_time,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /*---------FW capabilities------------*/
-- 
2.17.1

