Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058571C2A17
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 07:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgECFWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 01:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgECFWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 01:22:32 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605DEC061A0E
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 22:22:32 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s20so5450754plp.6
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 22:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OFyrx6PpnSEM4JIQUWvZhg8s9oAf8apq2thy03m41rg=;
        b=CLDPsok+Qby6cSiU1gLlV6Sp7813rC+peIfkIG/npQMIbQYR+kNI4MGNHdx8b2qMPu
         z1T0u7ETVw/8eZGBYtVJ648zIjIYBZm6GdT96lcCWqkSEUzQqdt1namD9sABj/fLBcGi
         SolCgUWMYMENYcTEP44nhKnAmTt8q1HbRBW5pIVAmYl7eeOpW+DaEZoFTDqQJpP8JGnX
         u2V+kDkFDIh3xDP1zCaIJqv1zL5iKtZD0R9nSfMjLT2FaKeLSsPshvvhQEUq/SiR3ZEJ
         c5/L1W5hPy+poaO56c8puh7g1I6SeeHMMaL2XJeymbZx436P9gXscPNVWXRrfZabqd0d
         JIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OFyrx6PpnSEM4JIQUWvZhg8s9oAf8apq2thy03m41rg=;
        b=RzQUa65yWOaHg5y/evY/nGOewtsd+nEQEWcUW9EDbgAvEpGt8VRgxZNMyQChJ+1iNl
         b2mF/ivOVVYwlULYgWZoTNTA+oT1CnQ+EAg/6miBVdh2LAPMacYdQWTKKS8N4g1gtFZH
         X/55UUQGFPCctL7fpZo6ZpHNu7n5vcTI0/0TC1RJcxagir5g1Y4Cn5JPwaLG2tDTf9fL
         f/a4SfAkf92ZLQF0eh1kRmcvgCM409ypl3l31QvbddQOh/fAB3lNdGAbqO96rTxTZahI
         hU5XPjnTZqPttt54db8MsXRN0yppYP2eUevYeE9pZJyUl2bK2ryOCO2zXO/psz0RgMDf
         3/mA==
X-Gm-Message-State: AGi0PuajaPKee+o/o1clhaoY54yrJ23H9Ko6zGNqLLjM7Cbcj1O+t/k1
        bPMVk6kWjJ3a3IGw6ukovGd+wnZtI14=
X-Google-Smtp-Source: APiQypIX216u5FCOc6vEBHx3ic7az8vX/H5iRK4i06eBu1fukURwIs6adAnaoMSCh1bRhqtztcaM+A==
X-Received: by 2002:a17:90b:34c:: with SMTP id fh12mr9600529pjb.134.1588483351660;
        Sat, 02 May 2020 22:22:31 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id y3sm3499597pjb.41.2020.05.02.22.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 22:22:31 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com,
        Dmitry Vyukov <dvyukov@google.com>,
        Taehee Yoo <ap420073@gmail.com>
Subject: [Patch net-next v2 2/2] bonding: remove useless stats_lock_key
Date:   Sat,  2 May 2020 22:22:20 -0700
Message-Id: <20200503052220.4536-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
References: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit b3e80d44f5b1
("bonding: fix lockdep warning in bond_get_stats()") the dynamic
key is no longer necessary, as we compute nest level at run-time.
So, we can just remove it to save some lockdep key entries.

Test commands:
 ip link add bond0 type bond
 ip link add bond1 type bond
 ip link set bond0 master bond1
 ip link set bond0 nomaster
 ip link set bond1 master bond0

Reported-and-tested-by: syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com
Cc: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Taehee Yoo <ap420073@gmail.com>
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
2.26.2

