Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53193444F60
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhKDG4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhKDG4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:56:41 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF44C061714;
        Wed,  3 Nov 2021 23:54:02 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b13so5718820plg.2;
        Wed, 03 Nov 2021 23:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AmqWbFtMRKjP/RYJLNtNwVoR7JKadqFB+epBPQPtrdE=;
        b=j8q3HYWXl0/V6GEchczRjUTymFAGpd8AEm4NLL1XFtGllfhMZn+ll7hWRKjuuKcBfS
         Yz2UEWnPILR872/9x4gocwZMDoOhl3GQEizfYBvUzX/UQt73M1k3FvlZStAEzB0JMYV+
         UeBZG1fiOb7CWRcfEdY0wvl2G4haNN77SryH9Db5/yWgz1q/GrCbxvpxqQ+AB2FsaIEC
         YtlwM2jn2S43PA9ccfCsQZzoMNZJ3Dhf71IFUrzop9uI6SysBPCigmsXo2D1y0mubDov
         KpRwU+QO/PPHAZUXxXsqri/NnILV//ejQA97lu4t3V99Ra4hVAntb7RDAp+SwMMmreLt
         DY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AmqWbFtMRKjP/RYJLNtNwVoR7JKadqFB+epBPQPtrdE=;
        b=28GjoCyB1fa8OkObjbf3Cbneluyyl9DnzrrF9B3hdX1DenStOfSVPA9v/dPGY5Q3BZ
         PFUSR/JpbVmMejM+OSreU0AVe6KDGJcphItKw7ZttY8A0Cvz0rXM8V8BBpOF3rpZHOsO
         5KLSoUzEZYq95ZBEY0U71Dtk6i8AOf1WKieQno12XLFwOfcb0Jm7k5w7PWP2j9n74b7v
         Oca0HIQHws4MISWwKOZz7x0YhL+1ewQ9xksvprKtuyNzDZEKZoVSHehtnrCftuiwsaCB
         xZOTvVz/11tnIzGUEBHyYrLJrgrP21mgp3mmqvPGZOUc44hbF2zX7v9GlxKMlJHXPp0q
         V6OA==
X-Gm-Message-State: AOAM53288Am9sw2xJUqQR05SCWz6NJGoeudwLu6GC+qudTMwvGAlsyvc
        bfAyBDDlXYGixmMgkw4c9Xw=
X-Google-Smtp-Source: ABdhPJzLGg5lDHAALjn0FUrZCg7vkYrG8lygeOc21XjYBZ08S7udKhTeB/ebTpGKAuqxWBj6BEFO7Q==
X-Received: by 2002:a17:902:b597:b0:13e:9ba6:fed with SMTP id a23-20020a170902b59700b0013e9ba60fedmr43743350pls.32.1636008842559;
        Wed, 03 Nov 2021 23:54:02 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id o1sm6638518pjs.30.2021.11.03.23.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:54:02 -0700 (PDT)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     ecree.xilinx@gmail.com
Cc:     davidcomponentone@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        bhelgaas@google.com, yuehaibing@huawei.com, arnd@arndb.de,
        yang.guang5@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] sfc: use swap() to make code cleaner
Date:   Thu,  4 Nov 2021 14:53:50 +0800
Message-Id: <20211104065350.1834911-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 drivers/net/ethernet/sfc/falcon/efx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index c68837a951f4..314c9c69eb0e 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -817,9 +817,7 @@ ef4_realloc_channels(struct ef4_nic *efx, u32 rxq_entries, u32 txq_entries)
 	efx->rxq_entries = rxq_entries;
 	efx->txq_entries = txq_entries;
 	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
+		swap(efx->channel[i], other_channel[i]);
 	}
 
 	/* Restart buffer table allocation */
@@ -863,9 +861,7 @@ ef4_realloc_channels(struct ef4_nic *efx, u32 rxq_entries, u32 txq_entries)
 	efx->rxq_entries = old_rxq_entries;
 	efx->txq_entries = old_txq_entries;
 	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
+		swap(efx->channel[i], other_channel[i]);
 	}
 	goto out;
 }
-- 
2.30.2

