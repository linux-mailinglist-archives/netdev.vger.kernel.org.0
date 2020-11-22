Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E4D2BC783
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 18:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgKVRiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 12:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727567AbgKVRix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 12:38:53 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7300C0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 09:38:51 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id y16so15536319ljk.1
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 09:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vs/JqfFSXnDtiJPI2Etoc132bkNG7hBDTRipjIiBSdo=;
        b=ggown8aIWEBB1UjKgr4EhcxEL8muiGbZysM2mOPivs2jCX2jogyxfoZrJWEqbab8E3
         bRhn9Qt+I/Q+F0CGqj9eKCxH2wrUFFQ3y8jrdVeTlb8XgpHPoYvfF1T+Uc9jMr/dOisi
         e5WaLovb3HodkFkWgeE6fq2EKc5axkjv5kaY+/uCwL4S5/tYm3zmFzudtXT+sU/mfO3j
         gdWJnH4O/0it7CyzRRHULLs8d7WESM6xTL6BvZLqCZXm0cOCn5OZkyDyDFJD1WH4+VmO
         OdjPfjD9d72RlNheUuiAHGobn6oRxsXaBU7/4qeae9rIHHD+XL/kSKrMwmlhK6PrcFhV
         Ip+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vs/JqfFSXnDtiJPI2Etoc132bkNG7hBDTRipjIiBSdo=;
        b=AMf2qIE5NmypSfb4C2ShgcXM/AxKU5jCwIHxOEmebiN0+6DSx5f3F2EfULXZtm6EDj
         SvgNLMV3h8dTz4DdKH7nNHxYVtkl6Pufl3MD6r8Sl/Dy/aGGYMizN8ZLeEV02aPUcxp2
         Vheuw0qKStodML+5kZvbjiaTfjOuNIAtNy9Y78Y6hshhPBBVXUhFKysEe45UCGAsbwv0
         bchLO2h8L+8QGMZ/kpOAdLrryueKD01ZlM6vqIshMd+3Ut6VJx0xPq/3pJ/xRk3DlaKE
         5wxEFDGGtWYnTj8eumc7tQat2cFpnWeC7tMGS+EdipXpgeAONQQY9gFaCQ4XinGyve+g
         jhnA==
X-Gm-Message-State: AOAM532NdQ3XOh4G/3fUkTzeWB8uHcf6LLlPLjogOYbxc81waNWQrWhA
        yISRwNm6T7nzBTd9whbkIAA=
X-Google-Smtp-Source: ABdhPJz8nkHih6bPT5puWlI7ODWupZQJHfwgnsJWcwI8ykQ0qZJhtGs1v72BDcefoOY+xSVnVqCCyQ==
X-Received: by 2002:a2e:730c:: with SMTP id o12mr11162345ljc.376.1606066730028;
        Sun, 22 Nov 2020 09:38:50 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id m84sm1098390lfd.46.2020.11.22.09.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 09:38:49 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2-next] ip: add IP_LIB_DIR environment variable
Date:   Sun, 22 Nov 2020 20:39:21 +0300
Message-Id: <20201122173921.31473-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not hardcode /usr/lib/ip as a path and allow libraries path
configuration in run-time.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 ip/ip.c        | 15 +++++++++++++++
 ip/ip_common.h |  2 ++
 ip/iplink.c    |  5 +----
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/ip/ip.c b/ip/ip.c
index 5e31957f..38600e51 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -25,6 +25,10 @@
 #include "color.h"
 #include "rt_names.h"
 
+#ifndef LIBDIR
+#define LIBDIR "/usr/lib"
+#endif
+
 int preferred_family = AF_UNSPEC;
 int human_readable;
 int use_iec;
@@ -41,6 +45,17 @@ bool do_all;
 
 struct rtnl_handle rth = { .fd = -1 };
 
+const char *get_ip_lib_dir(void)
+{
+	const char *lib_dir;
+
+	lib_dir = getenv("IP_LIB_DIR");
+	if (!lib_dir)
+		lib_dir = LIBDIR "/ip";
+
+	return lib_dir;
+}
+
 static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
diff --git a/ip/ip_common.h b/ip/ip_common.h
index d604f755..227eddd3 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -27,6 +27,8 @@ struct link_filter {
 	int target_nsid;
 };
 
+const char *get_ip_lib_dir(void);
+
 int get_operstate(const char *name);
 int print_linkinfo(struct nlmsghdr *n, void *arg);
 int print_addrinfo(struct nlmsghdr *n, void *arg);
diff --git a/ip/iplink.c b/ip/iplink.c
index d6b766de..4250b2c3 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -34,9 +34,6 @@
 #include "namespace.h"
 
 #define IPLINK_IOCTL_COMPAT	1
-#ifndef LIBDIR
-#define LIBDIR "/usr/lib"
-#endif
 
 #ifndef GSO_MAX_SIZE
 #define GSO_MAX_SIZE		65536
@@ -157,7 +154,7 @@ struct link_util *get_link_kind(const char *id)
 		if (strcmp(l->id, id) == 0)
 			return l;
 
-	snprintf(buf, sizeof(buf), LIBDIR "/ip/link_%s.so", id);
+	snprintf(buf, sizeof(buf), "%s/link_%s.so", get_ip_lib_dir(), id);
 	dlh = dlopen(buf, RTLD_LAZY);
 	if (dlh == NULL) {
 		/* look in current binary, only open once */
-- 
2.26.2

