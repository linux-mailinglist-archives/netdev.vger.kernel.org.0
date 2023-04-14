Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7877C6E2688
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjDNPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDNPMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:12:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA625E4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=AjtXr2NQkSTCw/YswGj2vPPDSPRxp09Jw7I3LBJxTS0=;
        t=1681485157; x=1682694757; b=Sq/UBOttVMVypJum7KFByesjxajleQP/jTcanIaQmlidgPj
        qmwO2QopXyMywHVAOwuBt1ZgXxF7cFEzApsuRrAu9nW/Rdxudbb/JTkffNwcPUcc7cz3K6V4WWx2f
        vzYZY5ZTD4V7GVYlh+CgGuIJ8fYEx3l4UBqevMhJqnYOvT8owPRRij0Ku69GiF4SL74QS00fDWhsX
        ApFmKHKygVdipFYN0ts9m7CwZ7I75NOE9/D19jvdvsY9BebWKblIy2qqlIsD9HooIdVHr6l+ivpsf
        n3O7rLVjvjYWWWhtx78f7j0RPSufm3aRy8toTGjDuJ5tiru1rHCl5oWApg4Hql6w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pnL6J-00Fdii-37;
        Fri, 14 Apr 2023 17:12:36 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH next-next v3 1/3] net: move dropreason.h to dropreason-core.h
Date:   Fri, 14 Apr 2023 17:12:25 +0200
Message-Id: <20230414171112.a848bf0a89f0.I14d12f483727910cddb776e5a84f75ed4e1d8b3e@changeid>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414151227.348725-1-johannes@sipsolutions.net>
References: <20230414151227.348725-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This will, after the next patch, hold only the core
drop reasons and minimal infrastructure.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v3: new patch
---
 include/linux/netdevice.h                       | 2 +-
 include/linux/skbuff.h                          | 2 +-
 include/net/{dropreason.h => dropreason-core.h} | 4 ++--
 include/net/inet_frag.h                         | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
 rename include/net/{dropreason.h => dropreason-core.h} (99%)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a740be3bb911..c7e05e6352a1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -52,7 +52,7 @@
 #include <linux/rbtree.h>
 #include <net/net_trackers.h>
 #include <net/net_debug.h>
-#include <net/dropreason.h>
+#include <net/dropreason-core.h>
 
 struct netpoll_info;
 struct device;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 82511b2f61ea..795b091e6d7d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -37,7 +37,7 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
 #include <net/net_debug.h>
-#include <net/dropreason.h>
+#include <net/dropreason-core.h>
 
 /**
  * DOC: skb checksums
diff --git a/include/net/dropreason.h b/include/net/dropreason-core.h
similarity index 99%
rename from include/net/dropreason.h
rename to include/net/dropreason-core.h
index c0a3ea806cd5..e775f9f7d384 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason-core.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 
-#ifndef _LINUX_DROPREASON_H
-#define _LINUX_DROPREASON_H
+#ifndef _LINUX_DROPREASON_CORE_H
+#define _LINUX_DROPREASON_CORE_H
 
 #define DEFINE_DROP_REASON(FN, FNe)	\
 	FN(NOT_SPECIFIED)		\
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index b23ddec3cd5c..325ad893f624 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -7,7 +7,7 @@
 #include <linux/in6.h>
 #include <linux/rbtree_types.h>
 #include <linux/refcount.h>
-#include <net/dropreason.h>
+#include <net/dropreason-core.h>
 
 /* Per netns frag queues directory */
 struct fqdir {
-- 
2.39.2

