Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891D262185C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiKHPet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiKHPeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:34:12 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855202B613;
        Tue,  8 Nov 2022 07:34:11 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o7so14146984pjj.1;
        Tue, 08 Nov 2022 07:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/1UBpn76RjCMIQ8KtZxAm1Y4uAaGqo2SqX2i500J9Q=;
        b=mDpa5KdqLWlgDttMDfQjPtPD5VtdiKj96KTlbreXdMXxN2Z2V5qV7hUXZeEOA/npz/
         TQ7KplgLbgJYUalYzrJQEMHtpQfZT6QyrofeHFl8Cx2mMaLRM5fgK57GC1dPd9HRgwy/
         eyoUgUhoEYc2H9kWGqfvVF1BQIiT0BP0lbtzMKqnrskf/GgcsDFzXR7E+JpvSr4ENJLF
         Q/XIXUiuHXXBEFJPs54AA2akbXj5Epp/VWQoyIqSL7vR/dnzBJ/gsLnJAYadzcBLD/y6
         0EQz/T3/5eoShspiB3lNYiqXtdrTv45LurUnl5LfUOnpqb0Y/+9EB41TGvqutORVUH2L
         gHTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E/1UBpn76RjCMIQ8KtZxAm1Y4uAaGqo2SqX2i500J9Q=;
        b=7lZE7y2jiLvNiZT1R+8Bg77hCrWKpg1RVQDGDupJf/3NYciSuyiVEcYH5/U/l26jr4
         FfbRJPN72lIGBsWMPJ6Jd/wLe4ujPk2sHoVGUynWRZwHqMDD7nk3LJKx/UxxlPWjGm01
         sQxIyyW3OFfww70X7Oqni5wyRWjwqAXXk/bnEq1Jb9aGoUXHQB4GqJD69nKuPZIC7spi
         TUIpBcTd9Ecr6EEqt6zimL0tUa7S66xpqdTHCd/74Ek1cVGnCNr6Z6iGO3vIOLKbck/6
         oYyugDIOV+pfsIUdn6NL5tBOk7yCrKGYJVE69+PqCHcHLlEvlOmXgZ5IjxZvreAOL8MC
         QPbA==
X-Gm-Message-State: ACrzQf2JKYeL+dhlcbK3JUf3IgUDPcjD4ORgnhEV8kz5qau7MT9oV9CI
        b2vhTyWJcPxj33yQZSdwoqVFN+TBlN1mWA==
X-Google-Smtp-Source: AMsMyM73OlwzUKdMUAZWS1t1/hYolYeBX6ymAWcO7WSVEfyZATw8+eaTQosDRAfYMGUbuP3BsHM1Jw==
X-Received: by 2002:a17:903:244a:b0:187:10f1:9f91 with SMTP id l10-20020a170903244a00b0018710f19f91mr53777522pls.37.1667921651070;
        Tue, 08 Nov 2022 07:34:11 -0800 (PST)
Received: from localhost.localdomain ([203.158.52.158])
        by smtp.gmail.com with ESMTPSA id w10-20020a17090a460a00b00213202d77d9sm6243412pjg.43.2022.11.08.07.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:34:10 -0800 (PST)
From:   Albert Zhou <albert.zhou.50@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next RFC 4/5] r8152: merge header into source
Date:   Wed,  9 Nov 2022 02:33:41 +1100
Message-Id: <20221108153342.18979-5-albert.zhou.50@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221108153342.18979-1-albert.zhou.50@gmail.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 0d5072029433 ("r8152: remove backwards compatibility"), the
header r8152_compatibility.h is short enough to be merged into r8152.c;
in addition, the duplicated include <linux/acpi.h> was removed, as well
as the now unnecessary <linux/version.h>.

Signed-off-by: Albert Zhou <albert.zhou.50@gmail.com>
---
 drivers/net/usb/r8152.c               | 52 ++++++++++++++++++++++-
 drivers/net/usb/r8152_compatibility.h | 61 ---------------------------
 2 files changed, 51 insertions(+), 62 deletions(-)
 delete mode 100644 drivers/net/usb/r8152_compatibility.h

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 85a3b2a7e83b..10dff6a88093 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -35,7 +35,57 @@
 #include <linux/suspend.h>
 #include <linux/atomic.h>
 #include <linux/acpi.h>
-#include "r8152_compatibility.h"
+
+#include <linux/init.h>
+#include <linux/in.h>
+
+#if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
+#include <linux/reboot.h>
+#endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
+
+#include <linux/mdio.h>
+#include <uapi/linux/mdio.h>
+
+#ifndef FALSE
+	#define TRUE	1
+	#define FALSE	0
+#endif
+
+enum rtl_cmd {
+	RTLTOOL_PLA_OCP_READ_DWORD = 0,
+	RTLTOOL_PLA_OCP_WRITE_DWORD,
+	RTLTOOL_USB_OCP_READ_DWORD,
+	RTLTOOL_USB_OCP_WRITE_DWORD,
+	RTLTOOL_PLA_OCP_READ,
+	RTLTOOL_PLA_OCP_WRITE,
+	RTLTOOL_USB_OCP_READ,
+	RTLTOOL_USB_OCP_WRITE,
+	RTLTOOL_USB_INFO,
+	RTL_ENABLE_USB_DIAG,
+	RTL_DISABLE_USB_DIAG,
+
+	RTLTOOL_INVALID
+};
+
+struct usb_device_info {
+	__u16		idVendor;
+	__u16		idProduct;
+	__u16		bcdDevice;
+	__u8		dev_addr[8];
+	char		devpath[16];
+};
+
+struct rtltool_cmd {
+	__u32	cmd;
+	__u32	offset;
+	__u32	byteen;
+	__u32	data;
+	void	*buf;
+	struct usb_device_info nic_info;
+	struct sockaddr ifru_addr;
+	struct sockaddr ifru_netmask;
+	struct sockaddr ifru_hwaddr;
+};
 
 /* Version Information */
 #define DRIVER_VERSION "v2.16.3 (2022/07/06)"
diff --git a/drivers/net/usb/r8152_compatibility.h b/drivers/net/usb/r8152_compatibility.h
deleted file mode 100644
index 5f3eca6ee9ec..000000000000
--- a/drivers/net/usb/r8152_compatibility.h
+++ /dev/null
@@ -1,61 +0,0 @@
-#ifndef LINUX_COMPATIBILITY_H
-#define LINUX_COMPATIBILITY_H
-
-/*
- * Definition and macro
- */
-
-#include <linux/init.h>
-#include <linux/version.h>
-#include <linux/in.h>
-#include <linux/acpi.h>
-
-#if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
-#include <linux/reboot.h>
-#endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
-
-#include <linux/mdio.h>
-#include <uapi/linux/mdio.h>
-
-#ifndef FALSE
-	#define TRUE	1
-	#define FALSE	0
-#endif
-
-enum rtl_cmd {
-	RTLTOOL_PLA_OCP_READ_DWORD = 0,
-	RTLTOOL_PLA_OCP_WRITE_DWORD,
-	RTLTOOL_USB_OCP_READ_DWORD,
-	RTLTOOL_USB_OCP_WRITE_DWORD,
-	RTLTOOL_PLA_OCP_READ,
-	RTLTOOL_PLA_OCP_WRITE,
-	RTLTOOL_USB_OCP_READ,
-	RTLTOOL_USB_OCP_WRITE,
-	RTLTOOL_USB_INFO,
-	RTL_ENABLE_USB_DIAG,
-	RTL_DISABLE_USB_DIAG,
-
-	RTLTOOL_INVALID
-};
-
-struct usb_device_info {
-	__u16		idVendor;
-	__u16		idProduct;
-	__u16		bcdDevice;
-	__u8		dev_addr[8];
-	char		devpath[16];
-};
-
-struct rtltool_cmd {
-	__u32	cmd;
-	__u32	offset;
-	__u32	byteen;
-	__u32	data;
-	void	*buf;
-	struct usb_device_info nic_info;
-	struct sockaddr ifru_addr;
-	struct sockaddr ifru_netmask;
-	struct sockaddr ifru_hwaddr;
-};
-
-#endif /* LINUX_COMPATIBILITY_H */
-- 
2.34.1

