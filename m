Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4E6128D95
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 12:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfLVL0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 06:26:48 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42634 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfLVL0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 06:26:47 -0500
Received: by mail-pl1-f193.google.com with SMTP id p9so6038753plk.9
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 03:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wsJ/k1zS6R6At8V+Z/9zrurZnoHJoUdXUgE3ZWpZ7Gk=;
        b=Pa2zmi+rlEkX+VG5zd1nngokwRWuS70hkQImtzZZghJco1zM7gAuxtUAk5rXCWn3Us
         3wgTzBbWCBOIulLdaA1T3u8OUmCEjfF+XXqDfsBogtzOTvqLRB0BPyNal4dPuvvpZeFf
         yrxwSN9X4W2mrO5d1NwnsmivK6UHtdXanB5V55SEbLSWNjjakcWdoL3POq+v0wSwWzXQ
         dhj8Sq7ORujlgQncmEWvZ6TWvS1HbJniDyxhKR6nMOyC703PoBEck11gr0o3bmnERmJ9
         X3oqQIZkNjJvJrCpeOA81l17vioGqDszrgOgx5Tos8KmSTaF8aefkUofv5r6rsHkPUJn
         eS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wsJ/k1zS6R6At8V+Z/9zrurZnoHJoUdXUgE3ZWpZ7Gk=;
        b=Rm1CINp3RxEM6+i8mAZeY7GNm4jzDOIuMHt8FyoILyUvY8na2GbSd0Rmvujby/XN52
         sdAK/xy/1QiVHku0ZLbymbox+8rTe93HiXOWJW/I9WLir97i9qr/loWmOPbVHJhHJhWq
         tR8HYqpCGjkLW9fgVxfdz1cMwkQ27WzPVPtzETv9zKxCwY+l5PY579tnWruzQSzizZgS
         1QzF2bjzS63qLIU3XQiRW1MT/NDkwoYTwmxN6yuv2jw9eJW+N0e96b81Reqq7sjJz39a
         7xZIBos29fzoab2E+mpOwJpk4bxRYnu0m/2PxA5CYIieIsHwTFnYF41D3NqP2WpoVmMi
         ohhQ==
X-Gm-Message-State: APjAAAXtycUTUVy35tuqm57UfEzWS6/JhmaD5GnExCcENzGhQKnPN8RA
        DeB6az3J0ZLwlH++d+nrPp8=
X-Google-Smtp-Source: APXvYqy8kBgZ+ij/AeTOrs31FX99Fl8T5zXLTH45YM2EEgrtts0UhUQ+wTjJlKQGlQyTy2p39nXvPg==
X-Received: by 2002:a17:902:b901:: with SMTP id bf1mr25296828plb.283.1577014007093;
        Sun, 22 Dec 2019 03:26:47 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id k21sm17900901pgt.22.2019.12.22.03.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 03:26:46 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 4/6] hsr: rename debugfs file when interface name is changed
Date:   Sun, 22 Dec 2019 11:26:39 +0000
Message-Id: <20191222112639.3241-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr interface has own debugfs file, which name is same with interface name.
So, interface name is changed, debugfs file name should be changed too.

Fixes: fc4ecaeebd26 ("net: hsr: add debugfs support for display node list")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_debugfs.c | 13 +++++++++++++
 net/hsr/hsr_main.c    |  3 +++
 net/hsr/hsr_main.h    |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index a7462a718e7b..d5f709b940ff 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -65,6 +65,19 @@ hsr_node_table_open(struct inode *inode, struct file *filp)
 	return single_open(filp, hsr_node_table_show, inode->i_private);
 }
 
+void hsr_debugfs_rename(struct net_device *dev)
+{
+	struct hsr_priv *priv = netdev_priv(dev);
+	struct dentry *d;
+
+	d = debugfs_rename(hsr_debugfs_root_dir, priv->node_tbl_root,
+			   hsr_debugfs_root_dir, dev->name);
+	if (IS_ERR(d))
+		netdev_warn(dev, "failed to rename\n");
+	else
+		priv->node_tbl_root = d;
+}
+
 static const struct file_operations hsr_fops = {
 	.open	= hsr_node_table_open,
 	.read	= seq_read,
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 490896379073..ea23eb7408e4 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -45,6 +45,9 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 	case NETDEV_CHANGE:	/* Link (carrier) state changes */
 		hsr_check_carrier_and_operstate(hsr);
 		break;
+	case NETDEV_CHANGENAME:
+		hsr_debugfs_rename(dev);
+		break;
 	case NETDEV_CHANGEADDR:
 		if (port->type == HSR_PT_MASTER) {
 			/* This should not happen since there's no
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 55d2057bf749..8d885bc6a54d 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -184,11 +184,15 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
 }
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
+void hsr_debugfs_rename(struct net_device *dev);
 void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
 void hsr_debugfs_term(struct hsr_priv *priv);
 void hsr_debugfs_create_root(void);
 void hsr_debugfs_remove_root(void);
 #else
+static inline void void hsr_debugfs_rename(struct net_device *dev)
+{
+}
 static inline void hsr_debugfs_init(struct hsr_priv *priv,
 				    struct net_device *hsr_dev)
 {}
-- 
2.17.1

