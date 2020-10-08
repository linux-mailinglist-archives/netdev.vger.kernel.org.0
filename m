Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6D028785C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbgJHPxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731507AbgJHPxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8465DC0613D2;
        Thu,  8 Oct 2020 08:53:39 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n14so4335060pff.6;
        Thu, 08 Oct 2020 08:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gaL//GthQ5zy0g5RXcHR8ALlsqiA25WTt3ZIyvHxpwo=;
        b=scKlVHPaAtCAvoYmDS6YnwBZAG8gz9G9kO705o9tJSSmrELqlyD+a2oB7GSkCaMYPB
         7yztrm83ZtCloN65wG6TRxCWLYno5mAY/l4wSyQaz/u/5Z6P33luarnKEkZ2HfkZxWlp
         Oz+xST25XJiBzUk4uyCmuviWdjrRD+WPHuCZbxvDnNeBXX63RyTz8RWKhy1pdfbKB0nV
         M0oiLdyIHAy26CIv2aSFakHCZdBkTS403o/HN1p8LFlHH1RhW6GQZaUJwoRnGZXVuGby
         4kVZ/yknK68Yjgl8KqcDsF86pvmvJ4GHiBGXAB0pPY0gm3/EIsQuksQYrCWl+7brmx1C
         dogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gaL//GthQ5zy0g5RXcHR8ALlsqiA25WTt3ZIyvHxpwo=;
        b=rtLBfmANyQNNVZwsDAfpYH459E0XginmjBlv4NaYHkoSqngRs4ancVNkda4fNk1okf
         xXPnEGJJVK1WB0lbojIyBnftgD2cuybQwwAZVcvCtQ/1t0s14/FGjZxAnc0GQh/VhxDA
         kO4EHSFM3dEdei/7eaGUHZsAkBHCZO8KWtkCNAeqJWWOIiSDoQhD7CYSw7z0p9aLNB/7
         zLdL/hEVSZm3pU5Yg/1lUPQND55ocpuCRm3dxPKwezDCHsrfVpecAUk3Q7ZlncFSRltT
         6KPrIkjy6vweKhD5FCW5e8qeeXnvIOZv0sQbImL/FN+9qRg9jjMxRGyV9A0M8FKGWbix
         X6EQ==
X-Gm-Message-State: AOAM533bIRbFpnuCtirFGWvTefi2mXlol1e8SFSK95KciLzih43p6Cko
        zLf4gnm/7PKL2MwVGN1RWyY=
X-Google-Smtp-Source: ABdhPJy9X9bCuhbzImVr8xR5hIegq2IGKc/i/oy8g/UrTFm8PoehRDBlH1poHPvtenYlczdPlrhrRw==
X-Received: by 2002:a63:e804:: with SMTP id s4mr7652141pgh.165.1602172419073;
        Thu, 08 Oct 2020 08:53:39 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:38 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 025/117] netdevsim: set nsim_dev_trap_fa_cookie_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:37 +0000
Message-Id: <20201008155209.18025-25-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/netdevsim/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 9c867d08e04a..1ae83ea4adbe 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -187,6 +187,7 @@ static const struct file_operations nsim_dev_trap_fa_cookie_fops = {
 	.read = nsim_dev_trap_fa_cookie_read,
 	.write = nsim_dev_trap_fa_cookie_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
-- 
2.17.1

