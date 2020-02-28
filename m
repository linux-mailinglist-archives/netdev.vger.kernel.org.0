Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD26173EFC
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgB1SB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:01:28 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36945 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1SB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:01:28 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so2096132pfn.4
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 10:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WGt1LOtTJ38d9oY/wyO/YVJWKclgx0/xeYE6MF+b/As=;
        b=Htgle/fMjcKDmcjljxOpIgYZ4kdPOCYIHGIVfbMr5Xm7QEyX3N7jMK8y3rpNW5Zxtk
         sBfAI/+StL9e3g5VHShWMirbbQL1QcdoPfXQqcAAAY2K7uoRJL9MDT5dIxw9+ZgO50hZ
         Y8K5gSEYMDoEQQ6c25uAdRX8Pea7C9RHqtTgY2ic0LzjI4sp+xVfoxO/cE1E/GNHnycl
         bI8dh0O6rohHXuPV5Gb1TQD7IhpK3lMHbN8ijVlSGr0O99xI03/2IuldHGXPasX0UvST
         svaX9fr4MYJrrqCAGRCM7zUvkzINjOfDtulkKf2Dpxkf+vzycYtCUYHr+oc60O3bYc56
         F6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WGt1LOtTJ38d9oY/wyO/YVJWKclgx0/xeYE6MF+b/As=;
        b=hfxrIu277Qvpv+ZJDZlJkc2c/vHRjbiAndqBXhVZRtyXycFVY4l7VUyjKqqMZf1UhQ
         uOJBT2+J865Ac7t3Icp8QIngGoqViXir1vRQSLYqNsiQ0LWMDpq7PIy1vltf02A9vGyn
         Gu79qpVZFADvt8nCHCDAanFoakpYtrLeUXrCAriDfFlk6AxI2mnmtEEIMSrJat0X7y25
         ODwMRUQjXNuzLs6I9mtsRWNequ/C5yu6gm26hEmeDi+fFroOmTzBK+YhvEdonIngAKvF
         gaVKy5OSZpl1eYBmJxHRjbHYALvC/7ktEf9IiRcGsZX4O0GETX2WVSDXnbH2UbzUfv0v
         Wggw==
X-Gm-Message-State: APjAAAUS1V8c/ilwHXeFu+/ZhHIU8IMDfTUZGgyf9frw3VRQKvBwf8M5
        C/wWjwLIxOP06lUR1rewW7c=
X-Google-Smtp-Source: APXvYqy7c/F5FHo7a9kHFKM+aaO0nriSW7mZId0MNGQHubEZ0I7sy61b6o2vFXhsHT/meyA+rs8Qsw==
X-Received: by 2002:a63:450b:: with SMTP id s11mr5681731pga.45.1582912887337;
        Fri, 28 Feb 2020 10:01:27 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 7sm43119pfg.12.2020.02.28.10.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:01:26 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 1/5] hsr: use debugfs_remove_recursive() instead of debugfs_remove()
Date:   Fri, 28 Feb 2020 18:01:20 +0000
Message-Id: <20200228180120.27604-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If it uses debugfs_remove_recursive() instead of debugfs_remove(),
hsr_priv() doesn't need to have "node_tbl_file" pointer variable.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_debugfs.c | 5 +----
 net/hsr/hsr_main.h    | 1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index d5f709b940ff..9787ef11ca71 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -113,7 +113,6 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 		priv->node_tbl_root = NULL;
 		return;
 	}
-	priv->node_tbl_file = de;
 }
 
 /* hsr_debugfs_term - Tear down debugfs intrastructure
@@ -125,9 +124,7 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 void
 hsr_debugfs_term(struct hsr_priv *priv)
 {
-	debugfs_remove(priv->node_tbl_file);
-	priv->node_tbl_file = NULL;
-	debugfs_remove(priv->node_tbl_root);
+	debugfs_remove_recursive(priv->node_tbl_root);
 	priv->node_tbl_root = NULL;
 }
 
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 754d84b217f0..7321cf8d6d2c 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -166,7 +166,6 @@ struct hsr_priv {
 	unsigned char		sup_multicast_addr[ETH_ALEN];
 #ifdef	CONFIG_DEBUG_FS
 	struct dentry *node_tbl_root;
-	struct dentry *node_tbl_file;
 #endif
 };
 
-- 
2.17.1

