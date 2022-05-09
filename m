Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA65E5204FD
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbiEITM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240413AbiEITMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:12:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6862C2C479E
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:08:57 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j10-20020a17090a94ca00b001dd2131159aso211636pjw.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 12:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85QckvXFMUdmWYQBYCLBCt4jXsUMYPpZ5c6TS69VDrE=;
        b=Z6Xaa1sSIwWt1nWffnc2+inmIO3i3Xeh/Ll9GG98QFjzyO4cigtEMnKJ524lxEQELE
         zyuiERHnfgTpdfh0IDG2UxRzvB35PC0q0hUtjMSm5ZP+5gcjMtI4eKAMi+C4Uv83Hy/v
         Xh1iDJQ30E/Dr2TQz0cA2DjzP69zVvJJQxAbAl3j/iW+Jnfn/NmVen2vPiiV3JDZLOd7
         p2Mif0EHp4UXSn/9HDKlDT+qn7+Jt+l5xmmRvyOzyRK/3ppp2Gqk3kNcCT1ook8Jg3+V
         k5vxZN6KCY7PDA9/BZ9KjoMcR0mKImm+WofEXX9Lg3CgYpwQuVWBNWxTgpGGRRi3I2vG
         M+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85QckvXFMUdmWYQBYCLBCt4jXsUMYPpZ5c6TS69VDrE=;
        b=FsMhSvp5G0Q6hnlkDloPPL/JF+EZZ2o3soer6R0+S+ELOdQqjTOiGKwRWo1x6PYLac
         +6rdIgV4CkwergbYEUsgIXbID/tOoJnNCQHt2k7AIzbbuafSmXtm7A17I5RNAf9sRtSE
         5DtgeaYZYiPnOM1UQ7EZS1tyCsIEKR5zyqaeELcN5K5JEns7ImYSguO40m20DM1rJPPd
         yyzysrNRCawAahHqvPmRXqZGkkH6xPf+lDe9HE+JPGqhf4tXbH/iCO5xqtXWeEUMinkJ
         hk3Flx1IgSDY+MeWPaL7hMj9W0QUXUKJ5UeU6+9p+5UzK5eEeORk6eC3GlSELGJISHTo
         4rwg==
X-Gm-Message-State: AOAM530GGfPweATyWg3avX4gFryQnRMSQeCQ+xZcGfS1pi3ne3t7c2Z8
        pZPMdGLxjKS5iB6ERZIYupc=
X-Google-Smtp-Source: ABdhPJxLvDX+Yir1SvwAxE2/LV1tO/OttDurvN3HKz7zkVBGsUvlMsE+pvHGMvKlK8svJrot3F+10A==
X-Received: by 2002:a17:903:41c9:b0:15e:ae15:294f with SMTP id u9-20020a17090341c900b0015eae15294fmr17215988ple.44.1652123336863;
        Mon, 09 May 2022 12:08:56 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id a6-20020aa79706000000b0050dc7628174sm9032631pfg.78.2022.05.09.12.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 12:08:56 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/4] net: add include/net/net_debug.h
Date:   Mon,  9 May 2022 12:08:48 -0700
Message-Id: <20220509190851.1107955-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509190851.1107955-1-eric.dumazet@gmail.com>
References: <20220509190851.1107955-1-eric.dumazet@gmail.com>
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

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 154 +-----------------------------------
 include/net/net_debug.h   | 159 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 153 deletions(-)
 create mode 100644 include/net/net_debug.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 74c97a34921d48c593c08e2bed72e099f42520a3..88ee2bcf35cf5f48fa41dc98e840802fbd81b36a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -50,6 +50,7 @@
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <net/net_trackers.h>
+#include <net/net_debug.h>
 
 struct netpoll_info;
 struct device;
@@ -5050,162 +5051,9 @@ static inline const char *netdev_reg_state(const struct net_device *dev)
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
-/*
- * netdev_WARN() acts like dev_printk(), but with the key difference
- * of using a WARN/WARN_ON to get the message out, including the
- * file/line information and a backtrace.
- */
-#define netdev_WARN(dev, format, args...)			\
-	WARN(1, "netdevice: %s%s: " format, netdev_name(dev),	\
-	     netdev_reg_state(dev), ##args)
-
-#define netdev_WARN_ONCE(dev, format, args...)				\
-	WARN_ONCE(1, "netdevice: %s%s: " format, netdev_name(dev),	\
-		  netdev_reg_state(dev), ##args)
-
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
index 0000000000000000000000000000000000000000..d8769ee7bced92decf126fe6c521db75e458565c
--- /dev/null
+++ b/include/net/net_debug.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_NET_DEBUG_H
+#define _LINUX_NET_DEBUG_H
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
+/*
+ * netdev_WARN() acts like dev_printk(), but with the key difference
+ * of using a WARN/WARN_ON to get the message out, including the
+ * file/line information and a backtrace.
+ */
+#define netdev_WARN(dev, format, args...)			\
+	WARN(1, "netdevice: %s%s: " format, netdev_name(dev),	\
+	     netdev_reg_state(dev), ##args)
+
+#define netdev_WARN_ONCE(dev, format, args...)				\
+	WARN_ONCE(1, "netdevice: %s%s: " format, netdev_name(dev),	\
+		  netdev_reg_state(dev), ##args)
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

