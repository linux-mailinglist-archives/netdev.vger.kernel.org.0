Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE631287857
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgJHPxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731520AbgJHPxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:36 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5079DC061755;
        Thu,  8 Oct 2020 08:53:36 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y14so4315389pfp.13;
        Thu, 08 Oct 2020 08:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p5IvPVKBTU7Ycj9qQJiUspy71ULY4yDvauv4FygkH+k=;
        b=l3uxU4v8E3W1qGadCt6P0zJch5KFrcpSspoQ4UqZpAbx+3FaTZbvYjSxnB+RgMizPe
         ubdewtVo0ihY9ELoVg0DQ8pP/yuUfd2sO8wnXw9AgoxGT8u//VR6UlQmkaIGnilZR76x
         6A0MCXdK/v28phPv21XePV6ucG+ltH6Js71ul3n56droVa42mfAB2Zch4LEoMTyMESUa
         m0JRjfQNDH45PC8VPeLzToXo+kq9jEJPljp9sk8TPQ7vNblU0rk0aK0k79BPwtK3KJw1
         4s9O7k3+c5Xl8W8pREKn17oQH6/lX5/r6RfeiJY+rrFDN9tqrb06yE2r38I6Y2ytH/gt
         6MOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p5IvPVKBTU7Ycj9qQJiUspy71ULY4yDvauv4FygkH+k=;
        b=czjNR95yvwflW/4EdQ5Rgl8ujoDiVqMx7sGzNi+QGgCYEJXzeoS5xEaRSBQalXkNXQ
         DRwxoF6izTTXozMC6Bd5BuP3HS+kAR1xAiMd2x6ygXkOW628GHmWg4cPxRoKSxMFM6Pk
         S5R1WeQZB8agzj6G41Fix/3khXlj190410eLzrLe80FvqZtmZF+yilEU/ArSHnIB0nKk
         2BjycmvPRcPNv9Y4fszhi+FsRczn+3PlbAEkbAyQRZmeNrUzuA4ouB5Gy7oDkwiYNz75
         yQ68ONbkU4OagcDiJiR51NSD8kUfE2pMG7bBpcEbW1zbsuv7yDTGfasG2e9z3bAgZLW6
         T6dw==
X-Gm-Message-State: AOAM530OvR1Ew9760f5v+Al8BgUIJ/2sswjHJlc7EM+2W6vdlsa3pzZS
        xe/q+piuL1qRXiuYg9rPJH6CvX16Q8I=
X-Google-Smtp-Source: ABdhPJzDbaVD8e6aeknwdzVm9lGUKksdwX2pU96DAebWu5oavOuENRi0mED+cKac1DOONOlyK+LqPw==
X-Received: by 2002:a63:4c43:: with SMTP id m3mr7768488pgl.19.1602172415903;
        Thu, 08 Oct 2020 08:53:35 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:35 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 024/117] netdevsim: set nsim_dev_take_snapshot_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:36 +0000
Message-Id: <20201008155209.18025-24-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 4418f862d675 ("netdevsim: implement support for devlink region and snapshots")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/netdevsim/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 32f339fedb21..9c867d08e04a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -94,6 +94,7 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
 	.open = simple_open,
 	.write = nsim_dev_take_snapshot_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t nsim_dev_trap_fa_cookie_read(struct file *file,
-- 
2.17.1

