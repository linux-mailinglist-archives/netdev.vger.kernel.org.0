Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C3D287947
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgJHP7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731923AbgJHP50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1213DC0613D3;
        Thu,  8 Oct 2020 08:57:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 144so4345336pfb.4;
        Thu, 08 Oct 2020 08:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ASI6wH+LVV7iTtr5dwHBwqJyLXzURutB+W9jf+xwR/E=;
        b=FeGsgG5Q7E5CM4RBYmrnBjYW+0i3TPfkuKavrfI98XHsSqyHWrqos2nmTyXgwwa1vw
         poxktwlq14I+FqycSKin7JkYi4fvhemd0AawwpuQnRv9UMPp7C3JefH8FJ3nQzXg5SJe
         UpIUEI7Z+dq+MQi3bekJLfV+/eipJZCBZRldS63gsSEKR9/9kkOy/+W17gF6g+NBSlQo
         CsphCzgqqA0fm4ofiH3LybLrgoO8z3QZlt2yCYIxvE2Sol8l4SIy2ChKF77dGJx4PDhL
         PXJsZ1euZPglTA6LfwXtDPUyRXm+/DuiPo6OttMww7C24CpFg+GcpJQostdZrNd7icZH
         buwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ASI6wH+LVV7iTtr5dwHBwqJyLXzURutB+W9jf+xwR/E=;
        b=Th0cpY+/d0kJkmLA4bsjrpUij9vhMm3uFIAKiWI7InHkngKj+pn1jfA5VoYY5oLxxC
         XLyj0VHHGVk8UsDGPNFRQHzvNfHjRCS7r2t99SYDLYapwighHDOvwcIJZ/qIaojBX+Cd
         13h0RxNxCmxyoEOCthC1y00zVxBeRlZrtYUOLvzd+g+gb8rDDqz6g9NmA8JqpMG1S1yU
         puhmG+wk2qK8pXpRFCxdF5axQQqp+MqowB+64km+88s/tqihmHKkYrI/lo9LGfIVzE6N
         x0yvrvCgjohZLwcQj4nT4OiZC328UQABAZ2c+U2n5ETOTiNmY0ErhVk/mUaBT6gMUXJ7
         iQBQ==
X-Gm-Message-State: AOAM530KM0flsH797jfuGLHaw3PJe1xpruyfMY/bxQfCtogLFFcFPi9s
        B77S47TD6ozkK/g3zxFWvlw=
X-Google-Smtp-Source: ABdhPJwWADfef58g8/KwxAc4cXnxkoiPyYfYEb3d2rOWB0n4k/4PP/oRbJXBUSG3TJb17glV92R4bg==
X-Received: by 2002:a63:d6:: with SMTP id 205mr7788791pga.309.1602172645650;
        Thu, 08 Oct 2020 08:57:25 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:24 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 098/117] wireless: mwifiex: set .owner to THIS_MODULE in debugfs.c
Date:   Thu,  8 Oct 2020 15:51:50 +0000
Message-Id: <20201008155209.18025-98-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index dded92db1f37..641113260439 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -931,18 +931,21 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.read = mwifiex_##name##_read,                                  \
 	.write = mwifiex_##name##_write,                                \
 	.open = simple_open,                                            \
+	.owner = THIS_MODULE,						\
 };
 
 #define MWIFIEX_DFS_FILE_READ_OPS(name)                                 \
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.read = mwifiex_##name##_read,                                  \
 	.open = simple_open,                                            \
+	.owner = THIS_MODULE,						\
 };
 
 #define MWIFIEX_DFS_FILE_WRITE_OPS(name)                                \
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.write = mwifiex_##name##_write,                                \
 	.open = simple_open,                                            \
+	.owner = THIS_MODULE,						\
 };
 
 
-- 
2.17.1

