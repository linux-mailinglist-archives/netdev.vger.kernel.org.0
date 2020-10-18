Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15058292023
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgJRVcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgJRVb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 17:31:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F79C22280;
        Sun, 18 Oct 2020 21:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603056719;
        bh=TanqdjBUf0rjKInxfQwL21fLYLSWFj3b+In8ojzGMdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5x9DMyoBPU8yk/sBSaneUzMwROZ32jPfWf0QXFvwYnE/H8rxMjdWazQSUqdww7Hz
         Lyyuf8MR3V+GCeSh3mNCteGlJDS5dtSh8Zqo/BhxYdz4zwOqPkJ+V7d4Vjk+qIcSAV
         FfdoEUL8EYGyCzNuEq53waIIp/azBOojQpSTlvxY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool v3 1/7] update UAPI header copies
Date:   Sun, 18 Oct 2020 14:31:45 -0700
Message-Id: <20201018213151.3450437-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201018213151.3450437-1-kuba@kernel.org>
References: <20201018213151.3450437-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 9453b2d4694c.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 uapi/linux/genetlink.h | 11 +++++++++++
 uapi/linux/netlink.h   |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/uapi/linux/genetlink.h b/uapi/linux/genetlink.h
index 7c6c390c48ee..9fa720ee87ae 100644
--- a/uapi/linux/genetlink.h
+++ b/uapi/linux/genetlink.h
@@ -64,6 +64,8 @@ enum {
 	CTRL_ATTR_OPS,
 	CTRL_ATTR_MCAST_GROUPS,
 	CTRL_ATTR_POLICY,
+	CTRL_ATTR_OP_POLICY,
+	CTRL_ATTR_OP,
 	__CTRL_ATTR_MAX,
 };
 
@@ -85,6 +87,15 @@ enum {
 	__CTRL_ATTR_MCAST_GRP_MAX,
 };
 
+enum {
+	CTRL_ATTR_POLICY_UNSPEC,
+	CTRL_ATTR_POLICY_DO,
+	CTRL_ATTR_POLICY_DUMP,
+
+	__CTRL_ATTR_POLICY_DUMP_MAX,
+	CTRL_ATTR_POLICY_DUMP_MAX = __CTRL_ATTR_POLICY_DUMP_MAX - 1
+};
+
 #define CTRL_ATTR_MCAST_GRP_MAX (__CTRL_ATTR_MCAST_GRP_MAX - 1)
 
 
diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
index 695c88e3c29d..dfef006be9f9 100644
--- a/uapi/linux/netlink.h
+++ b/uapi/linux/netlink.h
@@ -129,6 +129,7 @@ struct nlmsgerr {
  * @NLMSGERR_ATTR_COOKIE: arbitrary subsystem specific cookie to
  *	be used - in the success case - to identify a created
  *	object or operation or similar (binary)
+ * @NLMSGERR_ATTR_POLICY: policy for a rejected attribute
  * @__NLMSGERR_ATTR_MAX: number of attributes
  * @NLMSGERR_ATTR_MAX: highest attribute number
  */
@@ -137,6 +138,7 @@ enum nlmsgerr_attrs {
 	NLMSGERR_ATTR_MSG,
 	NLMSGERR_ATTR_OFFS,
 	NLMSGERR_ATTR_COOKIE,
+	NLMSGERR_ATTR_POLICY,
 
 	__NLMSGERR_ATTR_MAX,
 	NLMSGERR_ATTR_MAX = __NLMSGERR_ATTR_MAX - 1
@@ -327,6 +329,7 @@ enum netlink_attribute_type {
  *	the index, if limited inside the nesting (U32)
  * @NL_POLICY_TYPE_ATTR_BITFIELD32_MASK: valid mask for the
  *	bitfield32 type (U32)
+ * @NL_POLICY_TYPE_ATTR_MASK: mask of valid bits for unsigned integers (U64)
  * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
  */
 enum netlink_policy_type_attr {
@@ -342,6 +345,7 @@ enum netlink_policy_type_attr {
 	NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
 	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
 	NL_POLICY_TYPE_ATTR_PAD,
+	NL_POLICY_TYPE_ATTR_MASK,
 
 	/* keep last */
 	__NL_POLICY_TYPE_ATTR_MAX,
-- 
2.26.2

