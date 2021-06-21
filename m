Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0715C3AEA59
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhFUNvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhFUNvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:51:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67A0C061574;
        Mon, 21 Jun 2021 06:49:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso10214814pjx.1;
        Mon, 21 Jun 2021 06:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xDbsgsugh71ao8Y6yea5NvWv35h64tsG9JYlXTC4X2E=;
        b=Bs34u2IQVoPUuboSu29SwNzeeXtm41TgzrzBMk1bm8bSocn2Y0MNuyxoDV3o8HkX61
         pDMjOMD5boamR/s/UdQ1oM1F3aSxLcoGN/rDvQvAQZ1VqRpfisZVO6a2dAsocARutAo3
         /zPjeGy8AcSuOmzZZSIl4IYU6QLInkhyL1nJycxuKQm0d4UZzgEImftURaIFdA1PICHf
         xApqK5dPA1YwAjDdJG1gD+iZZCyJ0g2EddTF96isJzlnSzX3brnwJEIZwneN1a9Cpmk5
         erim2+jQ+fzIt8mlOEDbSes8ZuTi+TBYXky1PrwTKGSzkQftWXR/90v3I4hPeM+d308D
         m6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xDbsgsugh71ao8Y6yea5NvWv35h64tsG9JYlXTC4X2E=;
        b=bOzb41u9UQBZVtqa6HqGBqFHTyw668zBGeI1m7YQLJNmLi9hBkuQse/L5KAtPru+EE
         gqHC5y151W6E/NIWItDxK63HjaFwa3QFp9ZfTOU0kXm+prxtr7wwzR1LQSTyOj/RmNVC
         zTUcyV9hue6OHryTu3kEBz8todVWSp2h4g/2xXq4AAE8JhXzqQPr1fB7SApruRAf7NnD
         U2p2aYCXQ8DJY/UVNk20tX/3wKtFT00lq6sNHuCIcX5FKLrEhKVluD81K8MkAlXR6A3d
         oRER0OlQ7dV9lj5cLJVaZHsUWjb1yXBBSkNdeI/Woqyl++j5fkvzUDfA6Dcrev7ZKMgt
         pSqQ==
X-Gm-Message-State: AOAM533v77QSLsDN0aZFV+G7DzxDxjpiiQLs5d9Jp+iJSQTKBmV+nMo6
        OnpPary4Kyh+JSSPwsu4/f8=
X-Google-Smtp-Source: ABdhPJxQfEFHZfiT7GkUBrNkZukPjstERXlXZ4ZyR9s8pLbDYwd8zlu+CFX157mIxWOY3suJ96ZXig==
X-Received: by 2002:a17:902:ba8b:b029:120:1d2b:f94b with SMTP id k11-20020a170902ba8bb02901201d2bf94bmr18026289pls.44.1624283371550;
        Mon, 21 Jun 2021 06:49:31 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n6sm16957370pgt.7.2021.06.21.06.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:49:31 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 02/19] staging: qlge: change LARGE_BUFFER_MAX_SIZE to 4096
Date:   Mon, 21 Jun 2021 21:48:45 +0800
Message-Id: <20210621134902.83587-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LARGE_BUFFER_MAX_SIZE=4096 could make better use of memory. This choice
is consist with ixgbe and e1000 ,
   - ixgbe sets the rx buffer's page order to 0 unless FCoE is enabled
   - e1000 allocs a page for a jumbo receive buffer

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO   | 2 --
 drivers/staging/qlge/qlge.h | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 449d7dca478b..0e26fac1ddc5 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -4,8 +4,6 @@
   ql_build_rx_skb(). That function is now used exclusively to handle packets
   that underwent header splitting but it still contains code to handle non
   split cases.
-* while in that area, using two 8k buffers to store one 9k frame is a poor
-  choice of buffer size.
 * in the "chain of large buffers" case, the driver uses an skb allocated with
   head room but only puts data in the frags.
 * rename "rx" queues to "completion" queues. Calling tx completion queues "rx
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 55e0ad759250..f54d38606b78 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -52,7 +52,7 @@
 #define RX_RING_SHADOW_SPACE	(sizeof(u64) + \
 		MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) * sizeof(u64) + \
 		MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) * sizeof(u64))
-#define LARGE_BUFFER_MAX_SIZE 8192
+#define LARGE_BUFFER_MAX_SIZE 4096
 #define LARGE_BUFFER_MIN_SIZE 2048
 
 #define MAX_CQ 128
-- 
2.32.0

