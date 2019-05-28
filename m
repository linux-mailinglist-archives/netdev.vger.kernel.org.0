Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223452BDA3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfE1DWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:22:18 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40028 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbfE1DWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 23:22:16 -0400
Received: by mail-pl1-f193.google.com with SMTP id g69so7721861plb.7
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 20:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=babayev.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RvnS22Vw7XAhcXt2zuvExhCK61h5x09YzuI3QGbrOW0=;
        b=HxAJo2zLBzwF1O7ErXAMOfbWfvTV5o46g54d2wLULjNOEzi5SCXQfiX8ZBLZNeFDBp
         8u0WgXz819r92LQtuj6oD9/ZRabFXwhcphsl+GSDGvexJrhKZvuekyR373KQOHIBTe7l
         O2fSc2wkVgte+kgh842w0NG0OM8W2CGgYdbVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RvnS22Vw7XAhcXt2zuvExhCK61h5x09YzuI3QGbrOW0=;
        b=m8aAYZRRCSv/8uKPuiXArOsnB0gcsWr51uksVgziMUKk2Wyc69gvEv+eaXP8SYWHbd
         dr0GikbW/XrrhE/gmAJnegK55EjHgykUEgh4gVhYp1RbQ1DfQch/L1yCt7sSZoPlkX14
         BQ/9HLBMHCuPDEGwxBgTL9tyXKEDPEcE7QyQQW+gAmLGHgxeYqS1BUdpEJrXOD+tFqxw
         ycvsPAozetb0EdI5u7C4t1jgX2JyFS+EsY+kjnKYNRl/elHVzh1XRzHoZ0BndCcLUQRW
         /Ap3IGWyzn5MQ7FxvanAK93QSicTudoRNC8M6tsxXvkbl5Qj6sTqmiHo/gfMYQvl5ZYn
         Bdhg==
X-Gm-Message-State: APjAAAWe8VBTfgUCCdEVXxwNJpCQgaFbqFnTdmJ+i+XBRJ2MGb8W1Sqa
        2MdHtPuAQ5LZhSkJkRX6AxHnUw==
X-Google-Smtp-Source: APXvYqydaduSxme2jAQxP9C5+Efspfe8LRxLwVc0bz1+Yo10ZAYE8+GH3z+GE5psQ9C1F+0q3OghTA==
X-Received: by 2002:a17:902:8a8f:: with SMTP id p15mr38042032plo.157.1559013735699;
        Mon, 27 May 2019 20:22:15 -0700 (PDT)
Received: from p50.cisco.com ([128.107.241.177])
        by smtp.gmail.com with ESMTPSA id h71sm933042pje.11.2019.05.27.20.22.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 20:22:15 -0700 (PDT)
From:   Ruslan Babayev <ruslan@babayev.com>
To:     mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: [net-next,v3 1/2] i2c: acpi: export i2c_acpi_find_adapter_by_handle
Date:   Mon, 27 May 2019 20:22:12 -0700
Message-Id: <20190528032213.19839-2-ruslan@babayev.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190528032213.19839-1-ruslan@babayev.com>
References: <20190528032213.19839-1-ruslan@babayev.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows drivers to lookup i2c adapters on ACPI based systems similar to
of_get_i2c_adapter_by_node() with DT based systems.

Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
Cc: xe-linux-external@cisco.com
---
 drivers/i2c/i2c-core-acpi.c | 3 ++-
 include/linux/i2c.h         | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 272800692088..964687534754 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -337,7 +337,7 @@ static int i2c_acpi_find_match_device(struct device *dev, void *data)
 	return ACPI_COMPANION(dev) == data;
 }
 
-static struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle)
+struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle)
 {
 	struct device *dev;
 
@@ -345,6 +345,7 @@ static struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle)
 			      i2c_acpi_find_match_adapter);
 	return dev ? i2c_verify_adapter(dev) : NULL;
 }
+EXPORT_SYMBOL_GPL(i2c_acpi_find_adapter_by_handle);
 
 static struct i2c_client *i2c_acpi_find_client_by_adev(struct acpi_device *adev)
 {
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 1308126fc384..9808993f5fd5 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -21,6 +21,7 @@
 #include <linux/rtmutex.h>
 #include <linux/irqdomain.h>		/* for Host Notify IRQ */
 #include <linux/of.h>		/* for struct device_node */
+#include <linux/acpi.h>		/* for acpi_handle */
 #include <linux/swab.h>		/* for swab16 */
 #include <uapi/linux/i2c.h>
 
@@ -981,6 +982,7 @@ bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 u32 i2c_acpi_find_bus_speed(struct device *dev);
 struct i2c_client *i2c_acpi_new_device(struct device *dev, int index,
 				       struct i2c_board_info *info);
+struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle);
 #else
 static inline bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 					     struct acpi_resource_i2c_serialbus **i2c)
@@ -996,6 +998,10 @@ static inline struct i2c_client *i2c_acpi_new_device(struct device *dev,
 {
 	return NULL;
 }
+static inline struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle h)
+{
+	return NULL;
+}
 #endif /* CONFIG_ACPI */
 
 #endif /* _LINUX_I2C_H */
-- 
2.19.2

