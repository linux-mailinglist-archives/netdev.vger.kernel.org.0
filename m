Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B0C6E7A08
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbjDSMxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbjDSMxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:53:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B673B10CA;
        Wed, 19 Apr 2023 05:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=zKyJB0bMffVw+uqLT2iaN4oPdi9O8zgltsCaZEEKjZk=;
        t=1681908782; x=1683118382; b=ikoHNqFs4TLikxDsG4ZcMuwPSKb7YCZGUcaqcDpD+4zG1ut
        hZFPqbNm9sTwWEAv2Pj4bT2lxTH/5tdgtFlGDXDQ+GU5pK+MtVRKGjwSL9romkTQ6xhVemLo6HEUL
        BT3gXVTfYnZbin/Ay704s+mE+vBpWqKmJ/pWz/t+5gpnXkZk17CGxHJarbV1btxYoLZzvQfvsTixN
        tyVTJ6UXa+5WvQ4O1K7MVbb94iKYD98/BvFeS8jo25zDxgBNJqmt48fiBg7f+f7RGV50pksr/9bxV
        d61+CB+xegSAgnmH2kRk4tnvAyoTG66hWMVWTUnIOdiqnn3kQJXrUEXkAEaHZnpQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pp7Ix-002YjR-09;
        Wed, 19 Apr 2023 14:52:59 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net-next v4 1/3] net: move dropreason.h to dropreason-core.h
Date:   Wed, 19 Apr 2023 14:52:52 +0200
Message-Id: <20230419145225.5b5e0b8acb95.I14d12f483727910cddb776e5a84f75ed4e1d8b3e@changeid>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419125254.20789-1-johannes@sipsolutions.net>
References: <20230419125254.20789-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This will, after the next patch, hold only the core
drop reasons and minimal infrastructure. Fix a small
kernel-doc issue while at it, to avoid the move
triggering a checker.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v3: new patch
v4: fix a kernel-doc issue
---
 include/linux/netdevice.h                       | 2 +-
 include/linux/skbuff.h                          | 2 +-
 include/net/{dropreason.h => dropreason-core.h} | 7 ++++---
 include/net/inet_frag.h                         | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)
 rename include/net/{dropreason.h => dropreason-core.h} (98%)

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
similarity index 98%
rename from include/net/dropreason.h
rename to include/net/dropreason-core.h
index c0a3ea806cd5..ade6d5b9186c 100644
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
@@ -334,7 +334,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_IPV6_NDISC_BAD_CODE,
 	/** @SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS: invalid NDISC options. */
 	SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS,
-	/** @SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST: NEIGHBOUR SOLICITATION
+	/**
+	 * @SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST: NEIGHBOUR SOLICITATION
 	 * for another host.
 	 */
 	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
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
2.40.0

