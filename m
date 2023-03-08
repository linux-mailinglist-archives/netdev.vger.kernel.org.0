Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742906B0AE6
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjCHOUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjCHOUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:20:18 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C111D8B309
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 06:20:16 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZueM-00027d-9b; Wed, 08 Mar 2023 15:20:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] netlink: remove unused 'compare' function
Date:   Wed,  8 Mar 2023 15:20:06 +0100
Message-Id: <20230308142006.20879-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No users in the tree.  Tested with allmodconfig build.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netlink.h  | 1 -
 net/netlink/af_netlink.c | 2 --
 net/netlink/af_netlink.h | 1 -
 3 files changed, 4 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index c43ac7690eca..3e8743252167 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -50,7 +50,6 @@ struct netlink_kernel_cfg {
 	struct mutex	*cb_mutex;
 	int		(*bind)(struct net *net, int group);
 	void		(*unbind)(struct net *net, int group);
-	bool		(*compare)(struct net *net, struct sock *sk);
 };
 
 struct sock *__netlink_kernel_create(struct net *net, int unit,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c64277659753..877f1da1a8ac 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2097,8 +2097,6 @@ __netlink_kernel_create(struct net *net, int unit, struct module *module,
 			nl_table[unit].bind = cfg->bind;
 			nl_table[unit].unbind = cfg->unbind;
 			nl_table[unit].flags = cfg->flags;
-			if (cfg->compare)
-				nl_table[unit].compare = cfg->compare;
 		}
 		nl_table[unit].registered = 1;
 	} else {
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index 5f454c8de6a4..90a3198a9b7f 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -64,7 +64,6 @@ struct netlink_table {
 	struct module		*module;
 	int			(*bind)(struct net *net, int group);
 	void			(*unbind)(struct net *net, int group);
-	bool			(*compare)(struct net *net, struct sock *sock);
 	int			registered;
 };
 
-- 
2.39.2

