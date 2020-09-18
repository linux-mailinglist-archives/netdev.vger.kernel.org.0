Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1BD26EA58
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgIRBNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIRBNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:13:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DACAC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bd2so2084092plb.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x7I6DKKt5XXvViK8VVBo6bFZjJI17Xcxw2BqRR/ZhHY=;
        b=SbEXOfLFJJuXXFsAjgUvUjJvk+9aFVrULLk/MqSuFhaR8zwtXUxTkc+X3xAggRsXSD
         ayPVyRG1tLD/TctczfYszw4BJpN0OBU5UFBMr4tJ9qxrJryT1YMrvzqjlkDscPgHuB7/
         +W2CLpVfvc/Y6N2S3TWtD8eWKt9HUBIcraBJJ5dqJV/UwF2ffC7NRXQmbF+1v8Rr7G6U
         G5UB8FW3iPuETqL3kfvVhElHXkC1zpnUvN4+/ptKc/gfjxixaHxglEYrC6hHw7EbIT+z
         XXLjJQ1yK9bSzNPmS8a9JVO29n/GQEgPSaoa6pa/5B+POHJkjd8YtnTvAU1HQ4LXg5qD
         mWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x7I6DKKt5XXvViK8VVBo6bFZjJI17Xcxw2BqRR/ZhHY=;
        b=q7/NUSJALWU6pk2ikzOJCckdUcMHwsFXhfC5+o7fkcqtUSd/LUlP4/bnOyJqgvmnNI
         ahtAHrHbd+WNRhcXp08PgZM4NHCrWscS++ZsbjG/BoePHnM986XBFeRw1XO0+sELjsgD
         Q5Uibf4PQko1wlkph/aPskulkkYN4xJDhwjnuFHbavR3vM8ZHu2Iy0pz4y/MMxU5Q0vA
         +6SLuK5xrcn3kMHs5UciXLGjaxesBqptzC8aijO4BwQBPoCqP8xmN2lBU9mL5aR2t5H4
         5R0ri9bTLqD4HdNt1lKZAR2odhqGf73VRTEBg35IvCr1RGVITn/L5UVViMZ6/oCongxw
         uCYg==
X-Gm-Message-State: AOAM530WbdOoaDcrqDA7jRILv7nLRbUujpZ4GGPsyENXty9i/T2UXp+o
        ew4jjFEne0ZgdbjloQAze7ILVbCwLaNonQ==
X-Google-Smtp-Source: ABdhPJxqITYAtHfA+MUwEdEryT1n+5Csqe+zzwBu/6q+87QWZN5ixej0U/50ptaSmpTB9XcjXU2T2A==
X-Received: by 2002:a17:902:b70e:b029:d1:e5e7:be58 with SMTP id d14-20020a170902b70eb02900d1e5e7be58mr13143991pls.50.1600391614831;
        Thu, 17 Sep 2020 18:13:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id e19sm955701pfl.135.2020.09.17.18.13.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 18:13:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v5 net-next 1/5] devlink: add timeout information to status_notify
Date:   Thu, 17 Sep 2020 18:13:23 -0700
Message-Id: <20200918011327.31577-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918011327.31577-1-snelson@pensando.io>
References: <20200918011327.31577-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a timeout element to the DEVLINK_CMD_FLASH_UPDATE_STATUS
netlink message for use by a userland utility to show that
a particular firmware flash activity may take a long but
bounded time to finish.  Also add a handy helper for drivers
to make use of the new timeout value.

UI usage hints:
 - if non-zero, add timeout display to the end of the status line
 	[component] status_msg  ( Xm Ys : Am Bs )
     using the timeout value for Am Bs and updating the Xm Ys
     every second
 - if the timeout expires while awaiting the next update,
   display something like
 	[component] status_msg  ( timeout reached : Am Bs )
 - if new status notify messages are received, remove
   the timeout and start over

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/net/devlink.h        |  4 ++++
 include/uapi/linux/devlink.h |  3 +++
 net/core/devlink.c           | 29 +++++++++++++++++++++++------
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 48b1c1ef1ebd..be132c17fbcc 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1403,6 +1403,10 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
 					const char *component,
 					unsigned long done,
 					unsigned long total);
+void devlink_flash_update_timeout_notify(struct devlink *devlink,
+					 const char *status_msg,
+					 const char *component,
+					 unsigned long timeout);
 
 int devlink_traps_register(struct devlink *devlink,
 			   const struct devlink_trap *traps,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 631f5bdf1707..a2ecc8b00611 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -462,6 +462,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
 	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
+
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,	/* u64 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e5b71f3c2d4d..a32e15851119 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3024,7 +3024,9 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 					enum devlink_command cmd,
 					const char *status_msg,
 					const char *component,
-					unsigned long done, unsigned long total)
+					unsigned long done,
+					unsigned long total,
+					unsigned long timeout)
 {
 	void *hdr;
 
@@ -3052,6 +3054,9 @@ static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
 			      total, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
+			      timeout, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
 
 out:
 	genlmsg_end(msg, hdr);
@@ -3067,7 +3072,8 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 					  const char *status_msg,
 					  const char *component,
 					  unsigned long done,
-					  unsigned long total)
+					  unsigned long total,
+					  unsigned long timeout)
 {
 	struct sk_buff *msg;
 	int err;
@@ -3081,7 +3087,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 		return;
 
 	err = devlink_nl_flash_update_fill(msg, devlink, cmd, status_msg,
-					   component, done, total);
+					   component, done, total, timeout);
 	if (err)
 		goto out_free_msg;
 
@@ -3097,7 +3103,7 @@ void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE,
-				      NULL, NULL, 0, 0);
+				      NULL, NULL, 0, 0, 0);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
 
@@ -3105,7 +3111,7 @@ void devlink_flash_update_end_notify(struct devlink *devlink)
 {
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_END,
-				      NULL, NULL, 0, 0);
+				      NULL, NULL, 0, 0, 0);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
 
@@ -3117,10 +3123,21 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
 {
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
-				      status_msg, component, done, total);
+				      status_msg, component, done, total, 0);
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
 
+void devlink_flash_update_timeout_notify(struct devlink *devlink,
+					 const char *status_msg,
+					 const char *component,
+					 unsigned long timeout)
+{
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
+				      status_msg, component, 0, 0, timeout);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
+
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-- 
2.17.1

