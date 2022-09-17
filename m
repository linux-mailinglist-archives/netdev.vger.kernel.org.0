Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1335BBA3E
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 22:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiIQUSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 16:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIQUSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 16:18:12 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9575F2E9F0;
        Sat, 17 Sep 2022 13:18:11 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id o7so14439671qkj.10;
        Sat, 17 Sep 2022 13:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=rA1J3wNnURwjVaQRzDPJJFo52izXeQrMGO3evzyuiQ0=;
        b=KxoD7xykKYyawuxkaTKHAsD+UHEKwbfX7XWCNBZe6i7Mgrw0YCsTjl+qKqObCTg6p0
         Act4uRMpeCSYfygeT7s2GPeEMjBiZx2NKzesoXaO38hnh+dFLYZeuerbOgD0h7aQpNpA
         BE4nMBe9E5K6ppuDhZupAYJkurPuEAOIjfUZ3+DIvrYkNz1HBb92lc8uK22slSLy1SkN
         K4enAfXoM/6wWBxcp/GQlLS2x0PwMU9qyFLWxt9HMB5rFG9TCu0npvbhSMJ6bSsDJQbL
         VAFQv4WIJnvs+PQX1jJ0r3ctc7FpQRnlvPxkuOLp2BkxE+s7ZRcARsOyU0XsW5DugsVW
         drZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rA1J3wNnURwjVaQRzDPJJFo52izXeQrMGO3evzyuiQ0=;
        b=IOX6Ow5BxJNwiZTEDdZqbXKg/svCFq68o6I+YwOj8qU2ibpH3GTRXgcrV2Gv05XYXv
         mrC959nLvp4fbekBXZGOCAd0HianQtglbEJH2wmH7lkOjaLl8/NS16tgMluyTzu997aw
         r0i4rx/p9HRLDX/F9qULiNgrhKmSRgKVei7UH0HJW0ZZZrzVKUqNJsBAZDGEJCmfAH2t
         dSVF0aM5ZX5oUFeNg9q/d0TYtdCo+uZpdimtbJ3GSpjdMvNsmJUFbKYGdN8/T9+g/Zbp
         OgXfsC15PpI3QmQUNWeMTOCF2L5CBay0TxzuQNkXSLMMZ0+NQnNoyaZMuKfq3oM/jbf5
         6SzA==
X-Gm-Message-State: ACrzQf2kTILqB/88KuEPmxPgzolfSkyqcdWm2uFm8x8x8YiUpCPRapog
        qUEUPX7OstR9Kv+rbnFKPAI=
X-Google-Smtp-Source: AMsMyM5ob17a28YWQup5oSo+fcrgZBzZZvGQMtPbfQahiNyXRukM2fBEkogohQnFZJLUANcC9Ea8Nw==
X-Received: by 2002:a05:620a:1aa4:b0:6ce:6105:dc3f with SMTP id bl36-20020a05620a1aa400b006ce6105dc3fmr8340523qkb.632.1663445890697;
        Sat, 17 Sep 2022 13:18:10 -0700 (PDT)
Received: from euclid ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id y30-20020a37f61e000000b006a6ebde4799sm8579191qkj.90.2022.09.17.13.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 13:18:10 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, aroulin@nvidia.com,
        sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH RFC net-next 1/5] net: core: export call_netdevice_notifiers_info
Date:   Sat, 17 Sep 2022 16:17:57 -0400
Message-Id: <d6eaa0453446118ead2912bea6ef7b25c136b01c.1663445339.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
References: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function call_netdevice_notifiers_info will be used by the vlan
module for sending link-type-specific information to other modules.

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/dev.c            | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f0068c1ff1df..56b96b1e4c4c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2906,6 +2906,8 @@ netdev_notifier_info_to_extack(const struct netdev_notifier_info *info)
 }
 
 int call_netdevice_notifiers(unsigned long val, struct net_device *dev);
+int call_netdevice_notifiers_info(unsigned long val,
+				  struct netdev_notifier_info *info);
 
 
 extern rwlock_t				dev_base_lock;		/* Device list lock */
diff --git a/net/core/dev.c b/net/core/dev.c
index d66c73c1c734..e233145d1452 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -160,8 +160,6 @@ struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly;	/* Taps */
 
 static int netif_rx_internal(struct sk_buff *skb);
-static int call_netdevice_notifiers_info(unsigned long val,
-					 struct netdev_notifier_info *info);
 static int call_netdevice_notifiers_extack(unsigned long val,
 					   struct net_device *dev,
 					   struct netlink_ext_ack *extack);
@@ -1927,7 +1925,7 @@ static void move_netdevice_notifiers_dev_net(struct net_device *dev,
  *	are as for raw_notifier_call_chain().
  */
 
-static int call_netdevice_notifiers_info(unsigned long val,
+int call_netdevice_notifiers_info(unsigned long val,
 					 struct netdev_notifier_info *info)
 {
 	struct net *net = dev_net(info->dev);
@@ -1944,6 +1942,7 @@ static int call_netdevice_notifiers_info(unsigned long val,
 		return ret;
 	return raw_notifier_call_chain(&netdev_chain, val, info);
 }
+EXPORT_SYMBOL_GPL(call_netdevice_notifiers_info);
 
 /**
  *	call_netdevice_notifiers_info_robust - call per-netns notifier blocks
-- 
2.34.1

