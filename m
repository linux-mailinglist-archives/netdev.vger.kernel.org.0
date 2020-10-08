Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B5E2878B6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgJHPzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731752AbgJHPzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDFBC0613D5;
        Thu,  8 Oct 2020 08:55:37 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 144so4341020pfb.4;
        Thu, 08 Oct 2020 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DGOaXKZuYMRxXqw/nigolWlIyNCcj/It8YDCP3N+ZrI=;
        b=EatfWGQijW1G0IOoDyekMIhIJcBb/RrNQ2vGXKVIuRDkXTGrrNf9vqFTZeGoT8frUY
         0sH6R53YFyQKKpa3949Twg20JxrAG0AtRsBhglyLahBslHZeNJ0DxnQBxnOWTBUkXIo6
         QbagPMtJufS0H3x5z88K/leRtD+dskGqmBi4jt9CuM/O/fi7rBpHd4t6yYD2oEXY4/i+
         w93YSiBlwWaaWH9yti/NncKs+5nxLB3g6WtyWASANmxsmfUtGjbwVx1Q8vUMxeYNqNGj
         ovuhMnz+GW5usYugPTylX9XXCTYIF9t6Ud+wj7p2Pp95NToZebed2jL+VTpiKK09HoPW
         rD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DGOaXKZuYMRxXqw/nigolWlIyNCcj/It8YDCP3N+ZrI=;
        b=VVLvWsv5NYCgOEOpHq2yBNoh2Km7/zhk3RB8efiqb3KeYVnSh4N+Vmu1MFDKhXWTWt
         sFa1m2jm0p9PTGxSnxKtrWEW/hlNmf515H4N6zQyfTQwCOQ+jSqPYNKxZ/8029iiTHFt
         WY7wD/2kNTxUMvdFndp8u8af0zhdN0qYvY0b60TBFHR0A3R0pObwl8MJg6+hPDt5lvv7
         Xhim+MrUeq7GE4HsRLmp6FhUPUnaLa1vnH0BeO/C29jIqYCR5vuBgyBa9HC8w76hPiDu
         B5cPNPZSk2aOJ9bw0YjfdVgVKOYdNOHGIQnYpqAEYlGWHc2O8OUaCNIRsFcDBvD1/hai
         0XmA==
X-Gm-Message-State: AOAM530y7muvsPMWV+E1PF4Hx+UFr+GKhsvHwd6QW7nga5w19O+MFZ/b
        emcdnWeZJjvmZvKnNX2vy4M=
X-Google-Smtp-Source: ABdhPJxKXmIfHYCJzAX/yuHfNublcu97tDKzbzVvc0nTHUuaPVY/M/1Olf2xWmSi77Ol2KejeoMrSw==
X-Received: by 2002:aa7:9048:0:b029:152:883a:9a94 with SMTP id n8-20020aa790480000b0290152883a9a94mr8170865pfo.24.1602172537206;
        Thu, 08 Oct 2020 08:55:37 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:36 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 063/117] rtlwifi: set file_ops_common.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:15 +0000
Message-Id: <20201008155209.18025-63-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 55db71c766fe..0a368b1dd1b5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -89,6 +89,7 @@ static const struct file_operations file_ops_common = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static int rtl_debug_get_mac_page(struct seq_file *m, void *v)
-- 
2.17.1

