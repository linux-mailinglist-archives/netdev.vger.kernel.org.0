Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283DB1F389A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 12:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgFIKts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 06:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbgFIKrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 06:47:43 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ED9C00862C
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 03:47:38 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l12so18015283ejn.10
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 03:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4/0Vkm5vDfo1bNDCqLsz+PhAJXt0YTLeInxH19lPC3A=;
        b=QhdV7PMawCedJj6lnvoPx0JPU8A93/u1U0uXlVTjpCXvh5CxZKNLOPT/mYxcCWE/A1
         Y1RnVAXRL5dikNKzGKX40hNXN8gniQqI8orbHE5fEG9HpiM+hHCBGDkvCR4kjgifAMnX
         qL9apEeFsd4xVmR8MqopEemPmnGTqCDmt7lhrSnQg5H9GC5khbx9GttIWiZo3VYjK58l
         +IYSN4R6LZWlY66jV79ZjQStPnNZ9k3CNQ4NJrN4wKa4xvaz/kcxPDHePCEGZ00KZuX6
         G7f41RyhV/v33Ocp/09xS45klC7rXm2t86Y0tPAKwsSnFiu1yWXUIsFy2NIABrrw+aqT
         XwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4/0Vkm5vDfo1bNDCqLsz+PhAJXt0YTLeInxH19lPC3A=;
        b=GPE6bSggXYsWFrnJWoOdWIybWSP+Qu4mFizdQiiOM4NonbtegkoJjyCE0UD0QMuiow
         HCbyDX5k8hJR6X3E5sYG9d+r4kba7NpQiKlRKZPEGDdQQpIMkM06n9c8bfBC8N4G9YsE
         rV4t+nbKu5U/AF6g/zWtO2B22HEwu1VysbDQpNatmzfHXmwFdi57I6w2BU0ioX9Tp0Rs
         4oDKmOBqQ6M77AIjSA1l415aTIn0NVJsSIDRTvFdIacPY0ydwyUq3f+EdPYrYPgK0K6B
         RILHwrlNBiNwRgrj+MTLq+ZVtQPYv4oFhXkszU79gek1Y1k2xk1Uqu4PHHq/HG0kLnXQ
         7yMg==
X-Gm-Message-State: AOAM533L+d9driX63Xm2guErezxRW7G0iUhIa0wlizt6CjIGdUI5Zpcb
        DS+n8bkV/Ci+Kgpinbjx2tAgzA==
X-Google-Smtp-Source: ABdhPJypj4I58d5TLz8Xdh5fIHk7lhmauggjZSsXsMJ+fyzaf+ai9uzB3MPfXxtvkYH9C+7Bn3qKGw==
X-Received: by 2002:a17:906:7712:: with SMTP id q18mr859739ejm.140.1591699657572;
        Tue, 09 Jun 2020 03:47:37 -0700 (PDT)
Received: from localhost.localdomain (hst-221-69.medicom.bg. [84.238.221.69])
        by smtp.gmail.com with ESMTPSA id qt19sm12267763ejb.14.2020.06.09.03.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 03:47:37 -0700 (PDT)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 2/7] dynamic_debug: Group debug messages by level bitmask
Date:   Tue,  9 Jun 2020 13:45:59 +0300
Message-Id: <20200609104604.1594-3-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will allow dynamic debug users and driver writers to group
debug messages by level bitmask.  The level bitmask should be a
hex number.

Done this functionality by extending dynamic debug metadata with
new level member and propagate it over all the users.  Also
introduce new dynamic_pr_debug_level and dynamic_dev_dbg_level
macros to be used by the drivers.

Cc: Jason Baron <jbaron@akamai.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 fs/btrfs/ctree.h              | 12 +++++---
 include/linux/acpi.h          |  3 +-
 include/linux/dev_printk.h    |  3 +-
 include/linux/dynamic_debug.h | 55 ++++++++++++++++++++++++-----------
 include/linux/net.h           |  3 +-
 include/linux/printk.h        |  3 +-
 lib/dynamic_debug.c           | 30 +++++++++++++++++++
 7 files changed, 84 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 161533040978..f6a778789056 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3081,16 +3081,20 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define btrfs_debug(fs_info, fmt, args...)				\
-	_dynamic_func_call_no_desc(fmt, btrfs_printk,			\
+	_dynamic_func_call_no_desc(fmt, _DPRINTK_LEVEL_DEFAULT,		\
+				   btrfs_printk,			\
 				   fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_in_rcu(fs_info, fmt, args...)			\
-	_dynamic_func_call_no_desc(fmt, btrfs_printk_in_rcu,		\
+	_dynamic_func_call_no_desc(fmt, _DPRINTK_LEVEL_DEFAULT,		\
+				   btrfs_printk_in_rcu,			\
 				   fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl_in_rcu(fs_info, fmt, args...)			\
-	_dynamic_func_call_no_desc(fmt, btrfs_printk_rl_in_rcu,		\
+	_dynamic_func_call_no_desc(fmt, _DPRINTK_LEVEL_DEFAULT,		\
+				   btrfs_printk_rl_in_rcu,		\
 				   fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl(fs_info, fmt, args...)				\
-	_dynamic_func_call_no_desc(fmt, btrfs_printk_ratelimited,	\
+	_dynamic_func_call_no_desc(fmt, _DPRINTK_LEVEL_DEFAULT,		\
+				   btrfs_printk_ratelimited,		\
 				   fs_info, KERN_DEBUG fmt, ##args)
 #elif defined(DEBUG)
 #define btrfs_debug(fs_info, fmt, args...) \
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d661cd0ee64d..6e51438f7635 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1043,7 +1043,8 @@ void __acpi_handle_debug(struct _ddebug *descriptor, acpi_handle handle, const c
 #else
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define acpi_handle_debug(handle, fmt, ...)				\
-	_dynamic_func_call(fmt, __acpi_handle_debug,			\
+	_dynamic_func_call(fmt, _DPRINTK_LEVEL_DEFAULT,			\
+			   __acpi_handle_debug,				\
 			   handle, pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define acpi_handle_debug(handle, fmt, ...)				\
diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
index 5aad06b4ca7b..7b50551833e1 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -188,7 +188,8 @@ do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
-	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt,			\
+				      _DPRINTK_LEVEL_DEFAULT);		\
 	if (DYNAMIC_DEBUG_BRANCH(descriptor) &&				\
 	    __ratelimit(&_rs))						\
 		__dynamic_dev_dbg(&descriptor, dev, dev_fmt(fmt),	\
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 4cf02ecd67de..95e97260c517 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -38,6 +38,8 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_DEFAULT 0
 #endif
 	unsigned int flags:8;
+#define _DPRINTK_LEVEL_DEFAULT 0
+	unsigned int level:5;
 #ifdef CONFIG_JUMP_LABEL
 	union {
 		struct static_key_true dd_key_true;
@@ -78,7 +80,7 @@ void __dynamic_ibdev_dbg(struct _ddebug *descriptor,
 			 const struct ib_device *ibdev,
 			 const char *fmt, ...);
 
-#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
+#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt, lvl)		\
 	static struct _ddebug  __aligned(8)			\
 	__attribute__((section("__verbose"))) name = {		\
 		.modname = KBUILD_MODNAME,			\
@@ -87,6 +89,7 @@ void __dynamic_ibdev_dbg(struct _ddebug *descriptor,
 		.format = (fmt),				\
 		.lineno = __LINE__,				\
 		.flags = _DPRINTK_FLAGS_DEFAULT,		\
+		.level = (lvl),					\
 		_DPRINTK_KEY_INIT				\
 	}
 
@@ -119,16 +122,16 @@ void __dynamic_ibdev_dbg(struct _ddebug *descriptor,
 
 #endif
 
-#define __dynamic_func_call(id, fmt, func, ...) do {	\
-	DEFINE_DYNAMIC_DEBUG_METADATA(id, fmt);		\
-	if (DYNAMIC_DEBUG_BRANCH(id))			\
-		func(&id, ##__VA_ARGS__);		\
+#define __dynamic_func_call(id, fmt, level, func, ...) do {	\
+	DEFINE_DYNAMIC_DEBUG_METADATA(id, fmt, level);		\
+	if (DYNAMIC_DEBUG_BRANCH(id))				\
+		func(&id, ##__VA_ARGS__);			\
 } while (0)
 
-#define __dynamic_func_call_no_desc(id, fmt, func, ...) do {	\
-	DEFINE_DYNAMIC_DEBUG_METADATA(id, fmt);			\
-	if (DYNAMIC_DEBUG_BRANCH(id))				\
-		func(__VA_ARGS__);				\
+#define __dynamic_func_call_no_desc(id, fmt, level, func, ...) do {	\
+	DEFINE_DYNAMIC_DEBUG_METADATA(id, fmt, level);			\
+	if (DYNAMIC_DEBUG_BRANCH(id))					\
+		func(__VA_ARGS__);					\
 } while (0)
 
 /*
@@ -139,35 +142,49 @@ void __dynamic_ibdev_dbg(struct _ddebug *descriptor,
  * the varargs. Note that fmt is repeated in invocations of this
  * macro.
  */
-#define _dynamic_func_call(fmt, func, ...)				\
-	__dynamic_func_call(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
+#define _dynamic_func_call(fmt, lvl, func, ...)				\
+	__dynamic_func_call(__UNIQUE_ID(ddebug), fmt, lvl, func, ##__VA_ARGS__)
 /*
  * A variant that does the same, except that the descriptor is not
  * passed as the first argument to the function; it is only called
  * with precisely the macro's varargs.
  */
-#define _dynamic_func_call_no_desc(fmt, func, ...)	\
-	__dynamic_func_call_no_desc(__UNIQUE_ID(ddebug), fmt, func, ##__VA_ARGS__)
+#define _dynamic_func_call_no_desc(fmt, lvl, func, ...)			\
+	__dynamic_func_call_no_desc(__UNIQUE_ID(ddebug), fmt, lvl,	\
+				    func, ##__VA_ARGS__)
 
 #define dynamic_pr_debug(fmt, ...)				\
-	_dynamic_func_call(fmt,	__dynamic_pr_debug,		\
+	_dynamic_func_call(fmt, _DPRINTK_LEVEL_DEFAULT,		\
+			   __dynamic_pr_debug,			\
+			   pr_fmt(fmt), ##__VA_ARGS__)
+
+#define dynamic_pr_debug_level(lvl, fmt, ...)			\
+	_dynamic_func_call(fmt, lvl, __dynamic_pr_debug,	\
 			   pr_fmt(fmt), ##__VA_ARGS__)
 
 #define dynamic_dev_dbg(dev, fmt, ...)				\
-	_dynamic_func_call(fmt,__dynamic_dev_dbg, 		\
+	_dynamic_func_call(fmt, _DPRINTK_LEVEL_DEFAULT,		\
+			   __dynamic_dev_dbg,			\
+			   dev, fmt, ##__VA_ARGS__)
+
+#define dynamic_dev_dbg_level(dev, lvl, fmt, ...)		\
+	_dynamic_func_call(fmt, lvl, __dynamic_dev_dbg,		\
 			   dev, fmt, ##__VA_ARGS__)
 
 #define dynamic_netdev_dbg(dev, fmt, ...)			\
-	_dynamic_func_call(fmt, __dynamic_netdev_dbg,		\
+	_dynamic_func_call(fmt, _DPRINTK_LEVEL_DEFAULT,		\
+			   __dynamic_netdev_dbg,		\
 			   dev, fmt, ##__VA_ARGS__)
 
 #define dynamic_ibdev_dbg(dev, fmt, ...)			\
-	_dynamic_func_call(fmt, __dynamic_ibdev_dbg,		\
+	_dynamic_func_call(fmt, _DPRINTK_LEVEL_DEFAULT,		\
+			   __dynamic_ibdev_dbg,			\
 			   dev, fmt, ##__VA_ARGS__)
 
 #define dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
 			 groupsize, buf, len, ascii)			\
 	_dynamic_func_call_no_desc(__builtin_constant_p(prefix_str) ? prefix_str : "hexdump", \
+				   _DPRINTK_LEVEL_DEFAULT,		\
 				   print_hex_dump,			\
 				   KERN_DEBUG, prefix_str, prefix_type,	\
 				   rowsize, groupsize, buf, len, ascii)
@@ -202,8 +219,12 @@ static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
 
 #define dynamic_pr_debug(fmt, ...)					\
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+#define dynamic_pr_debug_level(lvl, fmt, ...)				\
+	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
 	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dynamic_dev_dbg_level(dev, lvl, fmt, ...)			\
+	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
 #define dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
 			 groupsize, buf, len, ascii)			\
 	do { if (0)							\
diff --git a/include/linux/net.h b/include/linux/net.h
index e10f378194a5..bcf6f010bc67 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -267,7 +267,8 @@ do {								\
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define net_dbg_ratelimited(fmt, ...)					\
 do {									\
-	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt,			\
+				      _DPRINTK_LEVEL_DEFAULT);		\
 	if (DYNAMIC_DEBUG_BRANCH(descriptor) &&				\
 	    net_ratelimit())						\
 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 3cc2f178bf06..ceea84aa705b 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -542,7 +542,8 @@ do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
-	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, pr_fmt(fmt));		\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, pr_fmt(fmt),		\
+				      _DPRINTK_LEVEL_DEFAULT);		\
 	if (DYNAMIC_DEBUG_BRANCH(descriptor) &&				\
 	    __ratelimit(&_rs))						\
 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);	\
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 8f199f403ab5..5d28d388f6dd 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -55,6 +55,7 @@ struct ddebug_query {
 	const char *function;
 	const char *format;
 	unsigned int first_lineno, last_lineno;
+	unsigned int level;
 };
 
 struct ddebug_iter {
@@ -187,6 +188,18 @@ static int ddebug_change(const struct ddebug_query *query,
 
 			nfound++;
 
+#ifdef CONFIG_JUMP_LABEL
+			if (query->level && query->level & dp->level) {
+				if (flags & _DPRINTK_FLAGS_PRINT)
+					static_branch_enable(&dp->key.dd_key_true);
+				else
+					static_branch_disable(&dp->key.dd_key_true);
+			} else if (query->level &&
+				   flags & _DPRINTK_FLAGS_PRINT) {
+				static_branch_disable(&dp->key.dd_key_true);
+				continue;
+			}
+#endif
 			newflags = (dp->flags & mask) | flags;
 			if (newflags == dp->flags)
 				continue;
@@ -289,6 +302,20 @@ static inline int parse_lineno(const char *str, unsigned int *val)
 	return 0;
 }
 
+static inline int parse_level(const char *str, unsigned int *val)
+{
+	WARN_ON(str == NULL);
+	if (*str == '\0') {
+		*val = 0;
+		return 0;
+	}
+	if (kstrtouint(str, 0, val) < 0) {
+		pr_err("bad level-number: %s\n", str);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int check_set(const char **dest, char *src, char *name)
 {
 	int rc = 0;
@@ -375,6 +402,9 @@ static int ddebug_parse_query(char *words[], int nwords,
 			} else {
 				query->last_lineno = query->first_lineno;
 			}
+		} else if (!strcmp(words[i], "level")) {
+			if (parse_level(words[i+1], &query->level) < 0)
+				return -EINVAL;
 		} else {
 			pr_err("unknown keyword \"%s\"\n", words[i]);
 			return -EINVAL;
-- 
2.17.1

