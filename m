Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD92A2878A6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbgJHPzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731666AbgJHPzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:06 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A71C0613D4;
        Thu,  8 Oct 2020 08:55:06 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h6so4660526pgk.4;
        Thu, 08 Oct 2020 08:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nO/N7m1byIHurxzBJe3w3+nfoW89mKBEsALmOm5a94w=;
        b=aeyiHIxHqOShtTUx1q6W64L/nOkHPtysQ6OElHFZ5E/bCsHnEiNrCWVtpNWDBJEQ//
         3qsYGFpRN8urIvG1qs6EwT27Mws9hmynobpw8+A12SoxjiBtNhmiK7rnr5oUnVcHm5rG
         akWkMhN3N/QIAlmA2hyS2ahkyy+pZNXzpOA1wvXi7CjBAPrYCLcQfbhL4e1yTMGyljmA
         7i6tscNcHBuZ+UxKgWpwtwDRb0CTeWxqfTB6zJdgtsNQrJpl2Fg3XAdwKEALlB8IrmLa
         sH9KzKAF5AHpcqOMz4OGrfneK5pm6IfoBITya3EpBV/JS2OjuHIQKqda9Qe8sMaUmMD6
         Hhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nO/N7m1byIHurxzBJe3w3+nfoW89mKBEsALmOm5a94w=;
        b=i6LNiGGRCL5CC3sINcwJNe8OBzzPtpbmF9SMQXly1KkMyDnLAb2BaoF/BNFKl1j7Jh
         JSLUNSYDQP++LO25H6UgIuB+h+CNB/r2G37Lz+YR0IzvxUh2lI8o9xMhaPrNIiEHEIG1
         8jiOBZ4yp6912rtwaA7CtF80yLEhemkZr4IBn5lSyof1RlPZ7aErFjGtMHzfkwObVnYU
         afipUPd5yDzD0lEzqSgQHGtOXqfNFnUcqGQcjAFufb7mCXapp/hS5pXGe0poYJEaooo4
         O0VOEqIh75qnR8BkB3TJsf+nI1JHMbGgM1E+t5NqiuExq2zO3I5vIlpqIQ8uEm91CE9m
         XWdg==
X-Gm-Message-State: AOAM533WiAjvw//d/3NF4C02Ykksu8+QlhrAwZUjDX99g1WpBDaP0/Nk
        7Sf9RwKKg+fzCr9rv8GfvO8=
X-Google-Smtp-Source: ABdhPJzXQ4jQB/g6gn38BgvK/iGz5C+8M8bjTL9bDx9laXPDnWnThplqcc/KObS4fBkcgHfWhjyC/Q==
X-Received: by 2002:a63:5c07:: with SMTP id q7mr8170527pgb.222.1602172506343;
        Thu, 08 Oct 2020 08:55:06 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:05 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 053/117] iwlwifi: set DEBUGFS_WRITE_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:05 +0000
Message-Id: <20201008155209.18025-53-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index 03571066f580..9813d4b507e5 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -145,6 +145,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.write = il_dbgfs_##name##_write,			\
 	.open = simple_open,					\
 	.llseek = generic_file_llseek,				\
+	.owner = THIS_MODULE,					\
 };
 
 #define DEBUGFS_READ_WRITE_FILE_OPS(name)			\
-- 
2.17.1

