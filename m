Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFC4287941
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732017AbgJHP7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbgJHP53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:29 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF87C0613D4;
        Thu,  8 Oct 2020 08:57:29 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so4648939pgb.10;
        Thu, 08 Oct 2020 08:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hPliT890mbJ5bRvZSxNfpybizEbQNJRv1wlZIAFTGLM=;
        b=P/kdRczr6kK7YPFrUwbPWIq21on3eMDIQQ4xwR8gsOnCzffLwWoXjhBnSyFdfaMhKh
         CRnINi2jER4wFSGIRBRjcZpWu7M+BzSb5fIFoygWDf1DwQYioywMmT5IEq1KI/Bslasl
         e2tdB2cil7OvfJ28Hy3Aar0mzvoM4XgsRcMtw8kWiHkCU/4Wd/EtMwUCiFeA1iQooSWw
         PkmnWoG71bscY5B/ZUbRmcskNWNvbQlWNZOOmDFonpF5y3BkUfywrsyGHCX5msq+HBok
         KSr+8tgvau2KScbjDgwZDkPkOeGOqRS1ZSPANwRn7mSW4jsI2jqNVTZjouV8xSj1dDam
         Z2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hPliT890mbJ5bRvZSxNfpybizEbQNJRv1wlZIAFTGLM=;
        b=AzAJLEp3cB+ZY1swSxEe+qOx97OrVxUrI8pWi/IUy/B0hIKY1gcdFGXE7jmNhTP+S2
         wp6XS1lLoBx/2WvXIs3VRApx+iMywadRe6NF9ehN5ozJ+wZDwiopvRY14R2O6XEExlkK
         SRzETpR0otPev+mJ5OF4rxDiDwCuPOkjiYP1ZL6dpfdxcaYGWpA369H90lKrfdw8t8cL
         wamXeDNvKuxKcwry5jigTRgEl7ofeJ9K4Xh3sBmBrW7TdFdGVa36I/BUskLqkKL+s40S
         uhqGgSb104Y61hTFNCOuO0QsvoI9IMqZE/Zyphll7JtFdL41GHpZXoFBV3dtxkjWu0Yu
         CcuQ==
X-Gm-Message-State: AOAM533dDG05J+E9wC5njKO8/gV3bt5075pQL6LCne7PNhSyIq3VvS7l
        AGrHrCZM07+IC1W3aPruC34=
X-Google-Smtp-Source: ABdhPJxDzkN6ZWJ7vZjzCOp7Nwq97h9hg6R6AzOKUx0tMszkjMUR3I7sPiYpi+z10EBguv5WvojvNQ==
X-Received: by 2002:a17:90a:9415:: with SMTP id r21mr8958738pjo.180.1602172648689;
        Thu, 08 Oct 2020 08:57:28 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:27 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 099/117] net: mt7601u: set fops_ampdu_stat.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:51 +0000
Message-Id: <20201008155209.18025-99-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c869f77d6abb ("add mt7601u driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/mediatek/mt7601u/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index 300242bce799..03f7235a90ab 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -84,6 +84,7 @@ static const struct file_operations fops_ampdu_stat = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static int
-- 
2.17.1

