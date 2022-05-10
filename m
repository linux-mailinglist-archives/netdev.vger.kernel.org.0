Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F92520C7A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiEJEBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiEJEBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:01:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E0E2A975B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:57:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x88so3271181pjj.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qW7Is/QI3iQbuuzWT6xbPmVOxR+S49NUMee/eBkfZUo=;
        b=hK7Ab4WNqA9FkHGb09k7+80YlDUcc38CDO87vf+IZ8o+GOiaTqmx5BO4dqrKdiKDxn
         YE8+XFqSzwZjsyM6BI/ZEftgv2N4Nh4eGlj6b8VgdPl5c2emb7/Egs9kpLwJXO7dwhPj
         fz4BHCfmEgom3FSzu3+CK6cl4hKzWKbC22Aqc7EX9RoAVyo6GcpM1S9p1hcWt7hz1YZt
         31SGvMsn4jeYpA8FPAiDwHQV0ywBoNyJSA/b7znxuNNdeo+ci2IjxuzMluMtI4dnAg21
         eWxRdaqqvRrt/N4Ii6C4wuP4WtdzCc6fyYMjf0o4FbdqyPdfESNqU8GiJn6AwDpJ/1ba
         zKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qW7Is/QI3iQbuuzWT6xbPmVOxR+S49NUMee/eBkfZUo=;
        b=6tMDHnTxz7X8bSP46cyd4T35bLXPi0ThFg6HCrvi5/2ptW/pr3fnpwSYUfbg9Xtpw6
         EHjbTjc0OKMSfBOriLnCqdmqoQ8MSN3+EbAl0Cf6ikSIA3aBSajyakuvSkZp+Bh5sHlq
         Rip5hj2+4u9QYsRfpftagCQcNT5YypvgN9CPBd1ChtNN/rYYG/ErMFoDaARWsi9S8cvN
         v6wu29Z4Fxz0xMGnOmFShDATPtgL3z3H02ONd8naufIVd1zxISwwNCfCyh68WlMlZpq7
         DX7ztaNkUzDZ3WYbL0E9/dqoE+ol2XarGez8D79IMRdG5F59xTdww1nPML0RQCAmVnIw
         xp9A==
X-Gm-Message-State: AOAM533hTWJ4lI3XC3fiOmqMemEeL4w6QFIZG3fLno23BOb1Dmt13jQM
        6yfdOQo4UrDvBqa9+u/LtmjKv8KgY4w=
X-Google-Smtp-Source: ABdhPJwwPkE6adcIWcd1cdalBbTYny2EaQl2a0+YZ7OpxSDGRdM0Y2icMtRnO+ICag9yKgKjzCo1wQ==
X-Received: by 2002:a17:90b:17c3:b0:1dc:3f12:1dbc with SMTP id me3-20020a17090b17c300b001dc3f121dbcmr21045587pjb.169.1652155067465;
        Mon, 09 May 2022 20:57:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090ad3cc00b001d81a30c437sm568193pjw.50.2022.05.09.20.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:57:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 1/5] net: add include/net/net_debug.h
Date:   Mon,  9 May 2022 20:57:37 -0700
Message-Id: <20220510035741.2807829-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510035741.2807829-1-eric.dumazet@gmail.com>
References: <20220510035741.2807829-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Remove from include/linux/netdevice.h helpers
that send debug/info/warnings to syslog.

We plan adding more helpers in following patches.

v2: added two includes, and 'struct net_device' forward declaration
    to avoid compile errors (kernel bots)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 141 +----------------------------------
 include/net/net_debug.h   | 151 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+), 140 deletions(-)
 create mode 100644 include/net/net_debug.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 74c97a34921d48c593c08e2bed72e099f42520a3..5fb1de931bcb9d0caaa5449169012b192d69d892 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -50,6 +50,7 @@
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <net/net_trackers.h>
+#include <net/net_debug.h>
 
 struct netpoll_info;
 struct device;
@@ -5050,81 +5051,9 @@ static inline const char *netdev_reg_state(const struct net_device *dev)
 	return " (unknown)";
 }
 
-__printf(3, 4) __cold
-void netdev_printk(const char *level, const struct net_device *dev,
-		   const char *format, ...);
-__printf(2, 3) __cold
-void netdev_emerg(const struct net_device *dev, const char *format, ...);
-__printf(2, 3) __cold
-void netdev_alert(const struct net_device *dev, const char *format, ...);
-__printf(2, 3) __cold
-void netdev_crit(const struct net_device *dev, const char *format, ...);
-__printf(2, 3) __cold
-void netdev_err(const struct net_device *dev, const char *format, ...);
-__printf(2, 3) __cold
-void netdev_warn(const struct net_device *dev, const char *format, ...);
-__printf(2, 3) __cold
-void netdev_notice(const struct net_device *dev, const char *format, ...);
-__printf(2, 3) __cold
-void netdev_info(const struct net_device *dev, const char *format, ...);
-
-#define netdev_level_once(level, dev, fmt, ...)			\
-do {								\
-	static bool __section(".data.once") __print_once;	\
-								\
-	if (!__print_once) {					\
-		__print_once = true;				\
-		netdev_printk(level, dev, fmt, ##__VA_ARGS__);	\
-	}							\
-} while (0)
-
-#define netdev_emerg_once(dev, fmt, ...) \
-	netdev_level_once(KERN_EMERG, dev, fmt, ##__VA_ARGS__)
-#define netdev_alert_once(dev, fmt, ...) \
-	netdev_level_once(KERN_ALERT, dev, fmt, ##__VA_ARGS__)
-#define netdev_crit_once(dev, fmt, ...) \
-	netdev_level_once(KERN_CRIT, dev, fmt, ##__VA_ARGS__)
-#define netdev_err_once(dev, fmt, ...) \
-	netdev_level_once(KERN_ERR, dev, fmt, ##__VA_ARGS__)
-#define netdev_warn_once(dev, fmt, ...) \
-	netdev_level_once(KERN_WARNING, dev, fmt, ##__VA_ARGS__)
-#define netdev_notice_once(dev, fmt, ...) \
-	netdev_level_once(KERN_NOTICE, dev, fmt, ##__VA_ARGS__)
-#define netdev_info_once(dev, fmt, ...) \
-	netdev_level_once(KERN_INFO, dev, fmt, ##__VA_ARGS__)
-
 #define MODULE_ALIAS_NETDEV(device) \
 	MODULE_ALIAS("netdev-" device)
 
-#if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
-#define netdev_dbg(__dev, format, args...)			\
-do {								\
-	dynamic_netdev_dbg(__dev, format, ##args);		\
-} while (0)
-#elif defined(DEBUG)
-#define netdev_dbg(__dev, format, args...)			\
-	netdev_printk(KERN_DEBUG, __dev, format, ##args)
-#else
-#define netdev_dbg(__dev, format, args...)			\
-({								\
-	if (0)							\
-		netdev_printk(KERN_DEBUG, __dev, format, ##args); \
-})
-#endif
-
-#if defined(VERBOSE_DEBUG)
-#define netdev_vdbg	netdev_dbg
-#else
-
-#define netdev_vdbg(dev, format, args...)			\
-({								\
-	if (0)							\
-		netdev_printk(KERN_DEBUG, dev, format, ##args);	\
-	0;							\
-})
-#endif
-
 /*
  * netdev_WARN() acts like dev_printk(), but with the key difference
  * of using a WARN/WARN_ON to get the message out, including the
@@ -5138,74 +5067,6 @@ do {								\
 	WARN_ONCE(1, "netdevice: %s%s: " format, netdev_name(dev),	\
 		  netdev_reg_state(dev), ##args)
 
-/* netif printk helpers, similar to netdev_printk */
-
-#define netif_printk(priv, type, level, dev, fmt, args...)	\
-do {					  			\
-	if (netif_msg_##type(priv))				\
-		netdev_printk(level, (dev), fmt, ##args);	\
-} while (0)
-
-#define netif_level(level, priv, type, dev, fmt, args...)	\
-do {								\
-	if (netif_msg_##type(priv))				\
-		netdev_##level(dev, fmt, ##args);		\
-} while (0)
-
-#define netif_emerg(priv, type, dev, fmt, args...)		\
-	netif_level(emerg, priv, type, dev, fmt, ##args)
-#define netif_alert(priv, type, dev, fmt, args...)		\
-	netif_level(alert, priv, type, dev, fmt, ##args)
-#define netif_crit(priv, type, dev, fmt, args...)		\
-	netif_level(crit, priv, type, dev, fmt, ##args)
-#define netif_err(priv, type, dev, fmt, args...)		\
-	netif_level(err, priv, type, dev, fmt, ##args)
-#define netif_warn(priv, type, dev, fmt, args...)		\
-	netif_level(warn, priv, type, dev, fmt, ##args)
-#define netif_notice(priv, type, dev, fmt, args...)		\
-	netif_level(notice, priv, type, dev, fmt, ##args)
-#define netif_info(priv, type, dev, fmt, args...)		\
-	netif_level(info, priv, type, dev, fmt, ##args)
-
-#if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
-#define netif_dbg(priv, type, netdev, format, args...)		\
-do {								\
-	if (netif_msg_##type(priv))				\
-		dynamic_netdev_dbg(netdev, format, ##args);	\
-} while (0)
-#elif defined(DEBUG)
-#define netif_dbg(priv, type, dev, format, args...)		\
-	netif_printk(priv, type, KERN_DEBUG, dev, format, ##args)
-#else
-#define netif_dbg(priv, type, dev, format, args...)			\
-({									\
-	if (0)								\
-		netif_printk(priv, type, KERN_DEBUG, dev, format, ##args); \
-	0;								\
-})
-#endif
-
-/* if @cond then downgrade to debug, else print at @level */
-#define netif_cond_dbg(priv, type, netdev, cond, level, fmt, args...)     \
-	do {                                                              \
-		if (cond)                                                 \
-			netif_dbg(priv, type, netdev, fmt, ##args);       \
-		else                                                      \
-			netif_ ## level(priv, type, netdev, fmt, ##args); \
-	} while (0)
-
-#if defined(VERBOSE_DEBUG)
-#define netif_vdbg	netif_dbg
-#else
-#define netif_vdbg(priv, type, dev, format, args...)		\
-({								\
-	if (0)							\
-		netif_printk(priv, type, KERN_DEBUG, dev, format, ##args); \
-	0;							\
-})
-#endif
-
 /*
  *	The list of packet types we will receive (as opposed to discard)
  *	and the routines to invoke.
diff --git a/include/net/net_debug.h b/include/net/net_debug.h
new file mode 100644
index 0000000000000000000000000000000000000000..19cd2700c20ea9945ae7662bacfa50f5d2bed398
--- /dev/null
+++ b/include/net/net_debug.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_NET_DEBUG_H
+#define _LINUX_NET_DEBUG_H
+
+#include <linux/bug.h>
+#include <linux/kern_levels.h>
+
+struct net_device;
+
+__printf(3, 4) __cold
+void netdev_printk(const char *level, const struct net_device *dev,
+		   const char *format, ...);
+__printf(2, 3) __cold
+void netdev_emerg(const struct net_device *dev, const char *format, ...);
+__printf(2, 3) __cold
+void netdev_alert(const struct net_device *dev, const char *format, ...);
+__printf(2, 3) __cold
+void netdev_crit(const struct net_device *dev, const char *format, ...);
+__printf(2, 3) __cold
+void netdev_err(const struct net_device *dev, const char *format, ...);
+__printf(2, 3) __cold
+void netdev_warn(const struct net_device *dev, const char *format, ...);
+__printf(2, 3) __cold
+void netdev_notice(const struct net_device *dev, const char *format, ...);
+__printf(2, 3) __cold
+void netdev_info(const struct net_device *dev, const char *format, ...);
+
+#define netdev_level_once(level, dev, fmt, ...)			\
+do {								\
+	static bool __section(".data.once") __print_once;	\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		netdev_printk(level, dev, fmt, ##__VA_ARGS__);	\
+	}							\
+} while (0)
+
+#define netdev_emerg_once(dev, fmt, ...) \
+	netdev_level_once(KERN_EMERG, dev, fmt, ##__VA_ARGS__)
+#define netdev_alert_once(dev, fmt, ...) \
+	netdev_level_once(KERN_ALERT, dev, fmt, ##__VA_ARGS__)
+#define netdev_crit_once(dev, fmt, ...) \
+	netdev_level_once(KERN_CRIT, dev, fmt, ##__VA_ARGS__)
+#define netdev_err_once(dev, fmt, ...) \
+	netdev_level_once(KERN_ERR, dev, fmt, ##__VA_ARGS__)
+#define netdev_warn_once(dev, fmt, ...) \
+	netdev_level_once(KERN_WARNING, dev, fmt, ##__VA_ARGS__)
+#define netdev_notice_once(dev, fmt, ...) \
+	netdev_level_once(KERN_NOTICE, dev, fmt, ##__VA_ARGS__)
+#define netdev_info_once(dev, fmt, ...) \
+	netdev_level_once(KERN_INFO, dev, fmt, ##__VA_ARGS__)
+
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
+#define netdev_dbg(__dev, format, args...)			\
+do {								\
+	dynamic_netdev_dbg(__dev, format, ##args);		\
+} while (0)
+#elif defined(DEBUG)
+#define netdev_dbg(__dev, format, args...)			\
+	netdev_printk(KERN_DEBUG, __dev, format, ##args)
+#else
+#define netdev_dbg(__dev, format, args...)			\
+({								\
+	if (0)							\
+		netdev_printk(KERN_DEBUG, __dev, format, ##args); \
+})
+#endif
+
+#if defined(VERBOSE_DEBUG)
+#define netdev_vdbg	netdev_dbg
+#else
+
+#define netdev_vdbg(dev, format, args...)			\
+({								\
+	if (0)							\
+		netdev_printk(KERN_DEBUG, dev, format, ##args);	\
+	0;							\
+})
+#endif
+
+/* netif printk helpers, similar to netdev_printk */
+
+#define netif_printk(priv, type, level, dev, fmt, args...)	\
+do {					  			\
+	if (netif_msg_##type(priv))				\
+		netdev_printk(level, (dev), fmt, ##args);	\
+} while (0)
+
+#define netif_level(level, priv, type, dev, fmt, args...)	\
+do {								\
+	if (netif_msg_##type(priv))				\
+		netdev_##level(dev, fmt, ##args);		\
+} while (0)
+
+#define netif_emerg(priv, type, dev, fmt, args...)		\
+	netif_level(emerg, priv, type, dev, fmt, ##args)
+#define netif_alert(priv, type, dev, fmt, args...)		\
+	netif_level(alert, priv, type, dev, fmt, ##args)
+#define netif_crit(priv, type, dev, fmt, args...)		\
+	netif_level(crit, priv, type, dev, fmt, ##args)
+#define netif_err(priv, type, dev, fmt, args...)		\
+	netif_level(err, priv, type, dev, fmt, ##args)
+#define netif_warn(priv, type, dev, fmt, args...)		\
+	netif_level(warn, priv, type, dev, fmt, ##args)
+#define netif_notice(priv, type, dev, fmt, args...)		\
+	netif_level(notice, priv, type, dev, fmt, ##args)
+#define netif_info(priv, type, dev, fmt, args...)		\
+	netif_level(info, priv, type, dev, fmt, ##args)
+
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
+#define netif_dbg(priv, type, netdev, format, args...)		\
+do {								\
+	if (netif_msg_##type(priv))				\
+		dynamic_netdev_dbg(netdev, format, ##args);	\
+} while (0)
+#elif defined(DEBUG)
+#define netif_dbg(priv, type, dev, format, args...)		\
+	netif_printk(priv, type, KERN_DEBUG, dev, format, ##args)
+#else
+#define netif_dbg(priv, type, dev, format, args...)			\
+({									\
+	if (0)								\
+		netif_printk(priv, type, KERN_DEBUG, dev, format, ##args); \
+	0;								\
+})
+#endif
+
+/* if @cond then downgrade to debug, else print at @level */
+#define netif_cond_dbg(priv, type, netdev, cond, level, fmt, args...)     \
+	do {                                                              \
+		if (cond)                                                 \
+			netif_dbg(priv, type, netdev, fmt, ##args);       \
+		else                                                      \
+			netif_ ## level(priv, type, netdev, fmt, ##args); \
+	} while (0)
+
+#if defined(VERBOSE_DEBUG)
+#define netif_vdbg	netif_dbg
+#else
+#define netif_vdbg(priv, type, dev, format, args...)		\
+({								\
+	if (0)							\
+		netif_printk(priv, type, KERN_DEBUG, dev, format, ##args); \
+	0;							\
+})
+#endif
+
+
+#endif	/* _LINUX_NET_DEBUG_H */
-- 
2.36.0.512.ge40c2bad7a-goog

