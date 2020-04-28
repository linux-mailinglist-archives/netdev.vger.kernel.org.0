Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B101BB622
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgD1GCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726375AbgD1GCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 02:02:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF03C03C1AA
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:02:12 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 145so10147024pfw.13
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6CaOya9o+eKb0kXGur8wf3Fkq+UwRk62Vi2OcCGtXWA=;
        b=IlbsG6V8kV4VWG1U57UMemxeNHxMRKTf7b2w2/gAwIpxYKInLfFjTzTBTZ/KhO7ZBA
         kONrjI8RHXzW3K8Qso4xwVEFzTL72HroMw2qvQv7QqzX/yo8J+4q3bZinwaPbs0odFsx
         QFAD5OzAhbSUWpmZQGwX0mq28z4tWkkt2uPOCjotqW/5FYEgpssoYJW+dYNhARE6Gk8p
         +j7oGQLb+gz8NLKgE5zf+IVlLFhrFSxzPOPBXkQ4hHYAJkEMf64TXS2R/ds076park4B
         nc7LQkPDPMjdr7Gd+U+lmT6YE9rjgpYSeC88pCDMMoe/idzmQTq1l1VT8mX+Eh3isnHw
         i0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6CaOya9o+eKb0kXGur8wf3Fkq+UwRk62Vi2OcCGtXWA=;
        b=bV+zgsA1hT9SslxQjFhM2yfXbVGzzsMDIeAEH5LpJ7kRhcRYcSVePR9X2B85pTpnr4
         lZ/Ft23I7HpIxosmmRQ/ZygnPOyqe+L1ClkjUNbz4acXcyQlLhb1eio9DZIzn7n8f31h
         KmynEpJDUVavxOgsW9Zq4N0ARDuLGohdrdvx5sXXPfIDw18NAzAvmMOBG376WbAHDah1
         XOCQNZedgBXEnajD3Uttd9w6szcABRdO5QdcK8SAPXhyl92kcpUpyOEqm4WrGB/j3++g
         /gUEwyZc/krmBKT9P3F2SQt9jQu0ix3892JzmlRVgzeq3gaHwMLXf0VAnN02k+t3tR3F
         8S9A==
X-Gm-Message-State: AGi0PuZhCD2iilLUP8rgaLGBIfJG//4yhNy3prxhTgzrpMPSK+BSuroF
        QfWiW/hT3QOGd4SdYrt5BuALbvu2+6M=
X-Google-Smtp-Source: APiQypI1ABWz0ysWQ9pmxzE1pmxEUWffejDLzrn9PPE2HrItLyBGywQayTVrEdyI7oHWX0cMJe+YFQ==
X-Received: by 2002:a62:1984:: with SMTP id 126mr27998974pfz.158.1588053731899;
        Mon, 27 Apr 2020 23:02:11 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id a12sm14006751pfr.28.2020.04.27.23.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 23:02:11 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [Patch net-next 2/2] bonding: remove useless stats_lock_key
Date:   Mon, 27 Apr 2020 23:02:06 -0700
Message-Id: <20200428060206.21814-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200428060206.21814-1-xiyou.wangcong@gmail.com>
References: <20200428060206.21814-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit b3e80d44f5b1
("bonding: fix lockdep warning in bond_get_stats()") the dynamic
key is no longer necessary, as we compute nest level at run-time.
So, we can just remove it to save some lockdep keys.

Test commands:
 ip link add bond0 type bond
 ip link add bond1 type bond
 ip link set bond0 master bond1
 ip link set bond0 nomaster
 ip link set bond1 master bond0

Reported-and-tested-by: syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/net/bonding/bond_main.c | 3 ---
 include/net/bonding.h           | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d01871321d22..baa93191dfdd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4491,7 +4491,6 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	list_del(&bond->bond_list);
 
-	lockdep_unregister_key(&bond->stats_lock_key);
 	bond_debug_unregister(bond);
 }
 
@@ -4896,8 +4895,6 @@ static int bond_init(struct net_device *bond_dev)
 		return -ENOMEM;
 
 	spin_lock_init(&bond->stats_lock);
-	lockdep_register_key(&bond->stats_lock_key);
-	lockdep_set_class(&bond->stats_lock, &bond->stats_lock_key);
 	netdev_lockdep_set_classes(bond_dev);
 
 	list_add_tail(&bond->bond_list, &bn->dev_list);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index dc2ce31a1f52..0b696da5c115 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -237,7 +237,6 @@ struct bonding {
 	struct	 dentry *debug_dir;
 #endif /* CONFIG_DEBUG_FS */
 	struct rtnl_link_stats64 bond_stats;
-	struct lock_class_key stats_lock_key;
 };
 
 #define bond_slave_get_rcu(dev) \
-- 
2.26.1

