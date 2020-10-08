Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE82878D4
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgJHP4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730659AbgJHP4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2792DC0613D3;
        Thu,  8 Oct 2020 08:56:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x16so4672282pgj.3;
        Thu, 08 Oct 2020 08:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZKzLL1gkV+MTFKanUALSDuPpwF8pnbzU9p2D7eFvecM=;
        b=JiOh8pE+3WtSALoSEneezMNMQdScJ/dbnJCmShp0UpypzS+ogF5t9qpg9QKRnIkpv2
         qfXNRSlbrFtW0w6Zz/45fuhYd/PZuRZw3WEsIsHTyEPoB1A8ua7q2bMuQq8F3i0FYE14
         akzYZ7M0ySzeQ59XdhA1pjlF0ZuVFHkfrw/5iDPWU57jlQRHULEsORBTVkwhkHOHgC/p
         FSSlGS7qF72U4UHHcmSO+moC7qgZcJXkC5bQbYcFJFQY8s0G1H1BheG18izM7ey1HeSs
         Em8fKHJAsXFF4Yy9sBImK9jtABkCNJm7CrIRnbH+4tGjlHwXO2hKsvcG04wm2MBlzZDR
         hVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZKzLL1gkV+MTFKanUALSDuPpwF8pnbzU9p2D7eFvecM=;
        b=YpLRVvxmlI/wD0IbLyCkvo9ykIXbpQzZMQ1vArMruLJDMihbUIfbGWIUHW4tTWpb9C
         7VBC5IMVtMlijV/uXmud9W0WLAn5cikyeCFVno/HseFOmKXTnQ071GOCxqiQ9NhWFNF9
         tLRuULpq2uW2pNQ4UQY5lVgNQHaram9JP2BPNJQqdJ3mveAGvkD5V1j5ZtLVscjve09/
         nT6el7OCUuwi2yQziCTkvWIYmq+DpH0G+U8rCk6TFi+RmD6w7tgdM3Lnwr4cP9YzkHeC
         jY4nBJzDMSmQzADmJYGxdxyOCPAhd3ukcOlDtyah2wSGM+Y1C3uSfZRRLz3HCrNL8OWZ
         2KPw==
X-Gm-Message-State: AOAM532McE2HLVAd1fU79xsuhW+wYnDoVf8nmH7eSftmBDUlby+P1PDt
        2GqBJjONHU+FyipmHxk1Bt0=
X-Google-Smtp-Source: ABdhPJy+Ey0d7sYJGG98XHUcT+5W/3+WSUvIeOHu4CQGAj/REF+Udt8D2PiXyb1KlOEKvNDHY9rj5w==
X-Received: by 2002:a63:ef4f:: with SMTP id c15mr7956030pgk.140.1602172577689;
        Thu, 08 Oct 2020 08:56:17 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:16 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 076/117] wil6210: set fops_rxon.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:28 +0000
Message-Id: <20201008155209.18025-76-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 0b39aaf2f203 ("wil6210: Tx mgmt frame from debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index c155baa3655f..914954cb9b0b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -730,6 +730,7 @@ static ssize_t wil_write_file_rxon(struct file *file, const char __user *buf,
 static const struct file_operations fops_rxon = {
 	.write = wil_write_file_rxon,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t wil_write_file_rbufcap(struct file *file,
-- 
2.17.1

