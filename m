Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF0C2878FD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731919AbgJHP5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbgJHP5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:15 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840A2C0613D7;
        Thu,  8 Oct 2020 08:57:13 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id i2so4657484pgh.7;
        Thu, 08 Oct 2020 08:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=evyKndbwepYrq5KDuUy+JWXd6ewoiEHFeL5yHKdiEYs=;
        b=FyYsqgpdQ2UtIaBo4TFEggOY770uBR/Ddn+dxBZlaquA+gamDmwrOuq7JccoCcKmFr
         RCX+ue/pfhAsa7+Xt3RRaOdilacmWHPAzvKQWfaSv88LXDf+tsrY5crXxDJ9rtxzODM7
         dBa4/CrpE1c5aT7q7ixiyZcujDpH3NGoPmOaF10tP2PDpOe/3xiLX3p1aUoT8XEojD3/
         PrxKPwFAuIbn745ktcPE+Slp65a8Z8NlPhf886OtudoiDGn1dess2/0rJuEyleDVuI9V
         4+5zTgyC9bt4RPWVM3Cw6wHa5FYvk4PtbcuDp7swwSnw2HaL1woMZHWb+VOHkIhOG5Iz
         EwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=evyKndbwepYrq5KDuUy+JWXd6ewoiEHFeL5yHKdiEYs=;
        b=qtN3luVolYeBZ0JNuS2y6YTudetk6OSJ853SwWOlnzUS3jVkd/zAyIneUgAbLI5PsH
         D3vFxAMA1SRJIwLk68X7zfPRUmrvtJ90TigsUvjMNvziV6Jhup0Kunsj/2ufa3SxX6UI
         WsEQn3v0+wGdcVOUvNkBJ3kHhFHH6aJmFMNMFUII57Ov2ZuNnF68Yvj2SaQEW6r+44mU
         7m5GlWsQ77BOAy0aLrA5KSlt5Zrmar3mQxfdhQ/uLwORGtDz53EpRd1R5h5Q7ZXvxYPd
         cehHrCWEjcX7+WbVquitjoYw77WBL1ncv2c+AnxmorxvFihUEG1kKUeOKbuyJZvA6KOp
         PnaQ==
X-Gm-Message-State: AOAM532vUUo9wf5A9x5y8n8Q/TTeMemut3qNIcsu5Wsf82rGq8496UyF
        NyutHmMDFYHVx7VeWY55kpg=
X-Google-Smtp-Source: ABdhPJwESH4h3miSObDUehJuAA8T74d94kZXzEuI2P0OkTB/PfkP0mJLdViTHTiY9OWWeAsi4wBbYw==
X-Received: by 2002:a17:90a:2e89:: with SMTP id r9mr9348978pjd.82.1602172633106;
        Thu, 08 Oct 2020 08:57:13 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:12 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 094/117] cw1200: set fops_wsm_dumps.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:46 +0000
Message-Id: <20201008155209.18025-94-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/st/cw1200/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/st/cw1200/debug.c b/drivers/net/wireless/st/cw1200/debug.c
index 8686929c70df..bcb8757c34ae 100644
--- a/drivers/net/wireless/st/cw1200/debug.c
+++ b/drivers/net/wireless/st/cw1200/debug.c
@@ -355,6 +355,7 @@ static const struct file_operations fops_wsm_dumps = {
 	.open = simple_open,
 	.write = cw1200_wsm_dumps,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 int cw1200_debug_init(struct cw1200_common *priv)
-- 
2.17.1

