Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0138D28790F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731858AbgJHP4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730970AbgJHP4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B235C0613D3;
        Thu,  8 Oct 2020 08:56:36 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y14so4322739pfp.13;
        Thu, 08 Oct 2020 08:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mOKjcCQno8Q2MDioiuy0iymihTx8Qw64HFe1w8XjD64=;
        b=hyj4XwowV6j+CddPQQ8Y0DDsJj5ilPP7rY/TQ7KSIlK1EgChd8lkyDIrsuzWGzZt3m
         YVViuHDDk7dInewW54VS6FEQiVs+UzH9Vi7kUWFfAtc3KVgVlibJnXtQszhdwrgsHcNa
         0VtX9CjkSbAD7aPtTeTlgrG37CWBR/kncsM3HkyxCfswa8mNA81+GHBmBIWtj9vPOkKe
         w8dUoxYncWGG6sLIArioaTZTlXVEiKcQ9T7Ts/llDQbaGh0/8WtafKz+ZhzgACnQVtbD
         6PLNXqSeDptKwBf11riRBzvcN0OoDOh2xEVDcvZkgTTIJ30IpIfa+xpWdZC4Dzzu9TJ0
         C/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mOKjcCQno8Q2MDioiuy0iymihTx8Qw64HFe1w8XjD64=;
        b=KIoWCtJNhCCvErU7lH68mRzP/D05RTL5vjKUes0CQWub0aTXHBJ6FK1JHcXoqp15LI
         sea+wbq0CQ7DYA/gGc8t/jnXcSyTiazO8TFI4phR8MfKKT+xqowbmVO/S/Iq592iMUwl
         5nGKVU3chqDMB5uBhwiWAMTvE0nqUt2gSrpQVNASzXTcEsYeAyHEWWEjUgGVGVuNdz4j
         CgZgouxptDexq6kK4+aRFE1QV4td5LiuuoKmgHNr6YoC7QHDAVZeUFc+2Xo1/67v30dQ
         G0oqf91a7eE3UGTB/r9U/+EoP15O7xZ8UVvJz4OpTN3TNnJyDQdHIJsViK2sHdvzUgIF
         taKw==
X-Gm-Message-State: AOAM533YsQFz8OVEubH8jGBVW500Ge63S0mxuOvwFclKkoat2/W1YLmA
        DsIyw3Tx/TyJrQprIVG2yUE=
X-Google-Smtp-Source: ABdhPJzavurkDw8oa5qGlCyCLUVpvzSS54vVNhqFeTAzWBwOWGR9Q7NgkQ+ruVqM3BkZDMFYeXfhFg==
X-Received: by 2002:a17:90a:6443:: with SMTP id y3mr8721818pjm.150.1602172596122;
        Thu, 08 Oct 2020 08:56:36 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:35 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 082/117] wil6210: set fops_txmgmt.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:34 +0000
Message-Id: <20201008155209.18025-82-ap420073@gmail.com>
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
index 4891cb7aaea4..182185a34071 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1003,6 +1003,7 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
 static const struct file_operations fops_txmgmt = {
 	.write = wil_write_file_txmgmt,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /* Write WMI command (w/o mbox header) to this file to send it
-- 
2.17.1

