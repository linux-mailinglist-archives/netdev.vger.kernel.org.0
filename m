Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1692878F3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbgJHP5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgJHP4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0192C061755;
        Thu,  8 Oct 2020 08:56:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 7so4640323pgm.11;
        Thu, 08 Oct 2020 08:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bGDxJudMmp+5xnmNYJduBqUawI8Rys442oCjhT5MwPM=;
        b=Fp3XHjkJMcTw0ftGuVkJTjm+PGuLFli1NwNttSHLOxi0rxC5BFTTrPHg0tsfRMoKlp
         M1RCf5v1YuP1nwR847X5o2tOlHt2rkGKubkvJFHAU1iCvzur1OvKJI2r8frvgLlOCihB
         UTmOxVxNSt+jbSN2uWvQaJfDSZh3ZBBv44FO7UgFhJ3GsWfCa565dLxZjUt8WqilciDI
         OI9yrn/znn9E4DLYO9JraxXeqOuAETWt5zKSWi5/JtaujMkIJ7QcUYT31okXuWclsRjE
         xXgDYndqX3DVnxCg+VPyB8uYORvStTTMC8rwjVI7O5o+uyZbkq5bTZ6fIrBkn6AoB7Rf
         FIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bGDxJudMmp+5xnmNYJduBqUawI8Rys442oCjhT5MwPM=;
        b=avfP6ii0szGrPzQHTEL3rFy04KSNABdhqt2RqxpCb+8/OUr56zxw/dgK1lfV6iAIK9
         U1vt4O32YBlMY+wRfz3WAec+OVDHZ9mNfMpy6ayONW0irefsaTtOxHjahsmi/V2vwxlE
         LOArC43DoBdMKgPWbu0f9FJVhDXgB87TwywVJu/gkyi15e0xS2sPtx26bvVn0lo8KA0N
         aT9zBapetAIa3U9nDpaHaehx+U3joTZQBkhIIJL0LAMa4h749vdxjtaFB3eS7svQIN+T
         MmfE73SA69azu7WjPw/U2lK7OsQpdZHLZ8q6+pl9h2ZZSkKlWUpGnGWYBZie/AfTBdXr
         AG/w==
X-Gm-Message-State: AOAM531pCrA48rapqOQKQtU/HvUlhWsVW4rrpWO+Nqeeo86avDCMjr6i
        hoxVnPRj69cFC4ypIGkbMbrOFahgClk=
X-Google-Smtp-Source: ABdhPJwAo94pR/w0KOGMkoe9Onkv35HvB/74eTJki64sFBereOeayMEecfC9FTDf0vMXyX0fHxndWQ==
X-Received: by 2002:a63:570d:: with SMTP id l13mr7790785pgb.172.1602172605253;
        Thu, 08 Oct 2020 08:56:45 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:44 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 085/117] wil6210: set fops_tx_latency.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:37 +0000
Message-Id: <20201008155209.18025-85-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: a24a3d6abb97 ("wil6210: add TX latency statistics")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index e3ecdcb58392..67b2248e6b36 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1846,6 +1846,7 @@ static const struct file_operations fops_tx_latency = {
 	.read		= seq_read,
 	.write		= wil_tx_latency_write,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 static void wil_link_stats_print_basic(struct wil6210_vif *vif,
-- 
2.17.1

