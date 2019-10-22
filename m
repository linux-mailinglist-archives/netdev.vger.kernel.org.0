Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B47E0946
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732806AbfJVQjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:39:42 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:37442 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfJVQjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:39:41 -0400
Received: by mail-pg1-f201.google.com with SMTP id u20so9000747pga.4
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 09:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qaI3IIutZxXxnrFA253ho/yI9cM/1Sfh0xG25NT/3ak=;
        b=jsfKVl5CpIEwAkhG8aQ4Onl3KGZtWEnyZvanp3UReq1sL7MBKLhiGPuBB6VQriNwC5
         2CFEgNmpiIfbdwHYLvEBNKSUsF7KsUoxGAvnQa4ZcTcOlWg+GSASuNqj/Wmg0wuvInQA
         ZivwH/YVH7GaXxxRCwv0n9jaaLrNZbsI0joSXnwQtJ8TXqmARTsf8GmJF7FQRwOsPXFT
         K34TfuoRoFROtMeRMUBbQ+tOraN09jSnUWbFe+bPoOKRlIgHGhqPBXddhg0D6vYLJW9T
         cuKOz6f5jFr3ta/d3sc6BRNo2Z220Q/+ItQxZDnaySAvlADFEMASBw7F0tSC7TiZGA72
         8dJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qaI3IIutZxXxnrFA253ho/yI9cM/1Sfh0xG25NT/3ak=;
        b=amiesnX+ECR/wEcRpR+Dj/RLwWdOUOdPDnLhufqIYupQUwwoKHZxU/yeEX5BcH55tI
         zZsbRwdqz7lr2x3ZCuzLf28ryAtuwc5jCxaccNRHU/WbW8Gor1840AOR+qMzYVSwWCCh
         uPBDHif687rJmpjvIXK/Tu+VSVBAvp83P2kH0LzoiCLbmrXH4lNi7LOAwcjtd+1rb9gD
         CVCBMGWQA8bW8JTtgn1xQEWV9jvtRn3xz3lny1UFC8voKshR4C9pnloL8ufWgTKuRFa/
         Ms9O3Gg4SaLwN630OHj9tiUbqY7Odama5CqcHUV+mU80RWY8qO4Je6EkWpxgcv+Qbz1Y
         mDcQ==
X-Gm-Message-State: APjAAAWrV5ZvfRNVN58o2kltJhvx7orx54ldOsCQ2sAYLdO31/CzLfdz
        b4Y+O32UJvXtj0At7Z1STkVrwkDE6S4e+A==
X-Google-Smtp-Source: APXvYqwBcG092ZizGt+rI0szSSSNm4k7YD760VRkeSqoiJavUaxmzkc6v9N6AofhI0H5ePwgnZJc/jV0k7RwRQ==
X-Received: by 2002:a63:d0f:: with SMTP id c15mr3746800pgl.313.1571762379596;
 Tue, 22 Oct 2019 09:39:39 -0700 (PDT)
Date:   Tue, 22 Oct 2019 09:39:36 -0700
Message-Id: <20191022163936.33220-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net-next] fq_codel: do not include <linux/jhash.h
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 342db221829f ("sched: Call skb_get_hash_perturb
in sch_fq_codel") we no longer need anything from this file.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq_codel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index c261c0a1886824ca38e8fb4297f9ca23a4c4863a..968519ff36e97734e495d90331d3e3197660b8f6 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -14,7 +14,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
-#include <linux/jhash.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <net/netlink.h>
-- 
2.23.0.866.gb869b98d4c-goog

