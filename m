Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E978686ED9
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404788AbfHIAaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:30:01 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:35742 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHIAaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:30:00 -0400
Received: by mail-pf1-f176.google.com with SMTP id u14so45056663pfn.2
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 17:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/nXWpNSeGFIyklrLRRQT3xvMC4M56hj2D2gnIgpjGY=;
        b=U18YNFion7EFv5dCS362FUjpTMX9oGk3kSoV6JLLoX4xbzbsl5H83PgslrDhgTfmhL
         qpgsOWmD8UKGyWRkD6MUTsW8PbF2NrQ8MeOkmm4qDpeZIFt4XgObhjVub3ffBgabkKB/
         9l/alUmKWFJgVdSZeTggweaHh6luAJYRm/HQhNG7kKqE0DEVqSbAB9o2FOuFNn6eR26T
         bV79/ilm7xf/n/rnsWGpUEl22nJp6c5Sv2r7A8R6+oiKjZ5SbyFxlmRJBqpGKUSvq131
         CLW6DaEYpXHlsvLTwh2kMNd/wsXiLh/J0Z/NEM+W/pLwfv8FBAHKtEQE0fiuXHNEJ2f/
         xaKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/nXWpNSeGFIyklrLRRQT3xvMC4M56hj2D2gnIgpjGY=;
        b=FCCahZGUG6jwnLXGqa6ANbqGgYuXA8wLu5/ybkfTM5RItgmk+LxZh8aUEyKP7MNSbe
         paAJn0wxWX/lR2PacddJO+zYswN3Rcwfn5PXPd+gxQPhvrDunVYjxATRxDLfIw1Frei/
         hyo7wrzqMyBKUbTPw7SjoR+l38WJNHKx9iWwDuImzOsaWxmEenVIWDjV+gJfZE1xfFty
         yGQ4+NJdRgNFdthpGVRHwmbAem899Va6oZoHY6DRhnUQ0dcpyHpYQMrIHBDu3BgzTEfK
         Jv/X4SsjA1W2o7RuP1UNoqV4CtVyKX4pQKs8YIeUi25XstUvs12SMJjhUZyaJfBLiGgi
         xnmQ==
X-Gm-Message-State: APjAAAV5v19Fsr+c+TjkstWKTCSdlteBrRltz7iwSgsyrw+68Sn05TjF
        PzCoygRx1XkjSzi35PcGu5r1GcmA8QcDsg==
X-Google-Smtp-Source: APXvYqwcwTrsNoPOW1rp08d+2xha/WME97PevGijrVMxFM7LhNp/H3LpgKu5DmPniFBtuqvUiMvF8Q==
X-Received: by 2002:a17:90a:9bca:: with SMTP id b10mr6659352pjw.90.1565310599502;
        Thu, 08 Aug 2019 17:29:59 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 196sm103991808pfy.167.2019.08.08.17.29.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 17:29:59 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 1/2] netdevice.h: add netdev_level_ratelimited for netdevice
Date:   Fri,  9 Aug 2019 08:29:40 +0800
Message-Id: <20190809002941.15341-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190809002941.15341-1-liuhangbin@gmail.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
 <20190809002941.15341-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add netdev_level_ratelimited so we can use it in the future.
The code is copied from device.h.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/netdevice.h | 53 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..4e37065c6717 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4737,6 +4737,59 @@ do {								\
 #define netdev_info_once(dev, fmt, ...) \
 	netdev_level_once(KERN_INFO, dev, fmt, ##__VA_ARGS__)
 
+#define netdev_level_ratelimited(netdev_level, dev, fmt, ...)		\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		netdev_level(dev, fmt, ##__VA_ARGS__);			\
+} while (0)
+
+#define netdev_emerg_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_emerg, dev, fmt, ##__VA_ARGS__)
+#define netdev_alert_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_alert, dev, fmt, ##__VA_ARGS__)
+#define netdev_crit_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_crit, dev, fmt, ##__VA_ARGS__)
+#define netdev_err_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_err, dev, fmt, ##__VA_ARGS__)
+#define netdev_warn_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_warn, dev, fmt, ##__VA_ARGS__)
+#define netdev_notice_ratelimited(dev, fmt, ...)			\
+	netdev_level_ratelimited(netdev_notice, dev, fmt, ##__VA_ARGS__)
+#define netdev_info_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_info, dev, fmt, ##__VA_ARGS__)
+#if defined(CONFIG_DYNAMIC_DEBUG)
+/* descriptor check is first to prevent flooding with "callbacks suppressed" */
+#define netdev_dbg_ratelimited(dev, fmt, ...)				\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (DYNAMIC_DEBUG_BRANCH(descriptor) &&				\
+	    __ratelimit(&_rs))						\
+		__dynamic_netdev_dbg(&descriptor, dev, dev_fmt(fmt),	\
+				     ##__VA_ARGS__);			\
+} while (0)
+#elif defined(DEBUG)
+#define netdev_dbg_ratelimited(dev, fmt, ...)				\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		netdev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
+} while (0)
+#else
+#define netdev_dbg_ratelimited(dev, fmt, ...)				\
+do {									\
+	if (0)								\
+		netdev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
+} while (0)
+#endif
+
 #define MODULE_ALIAS_NETDEV(device) \
 	MODULE_ALIAS("netdev-" device)
 
-- 
2.19.2

