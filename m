Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B7E3A3112
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhFJQoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:44:21 -0400
Received: from mail-ej1-f45.google.com ([209.85.218.45]:36688 "EHLO
        mail-ej1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbhFJQnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:47 -0400
Received: by mail-ej1-f45.google.com with SMTP id a11so227553ejf.3;
        Thu, 10 Jun 2021 09:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WYaGnISu1YfOE/7UiWGOnu7UNyMRUmG6vqNEYiYQnuw=;
        b=oOrrc83d8TfIoeXmdiRoiQg6glDODRsfbpbGcLCinVvDPPg4EwsRnclPpJGstuwomD
         Loe/4iW8ArsQULGi5DaAxbHMvjJ13BPDnbOvZFsEIy2ZPqa51dMbtxYcG4fAawlfR5Jw
         gKTx7B4SvmEIZY4c0R/PpJdoCQghcoPfzZVhxZ7hdlYVA+oiAlarlUZJGfRfK2IWs1Td
         UZzn1wJtbaW8kK82d/ly2IcvdtRmbDm2YUKBIz3x6xvsxQcsRVk/ALJGw+GQysJYmabr
         kg3GsAnLtefhEN7Mwo92YkIbiYiaolH7vbQ77mxVB7Hn9LPpR2OIxhHZvc1a34OC2264
         AXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WYaGnISu1YfOE/7UiWGOnu7UNyMRUmG6vqNEYiYQnuw=;
        b=tUixhB4BaaXSXiKsn+NiKFjlDVpgxidpzcGY4SC6jpNLQSITaHvgYlLU/yBhct4ZKK
         y/AkoXfHf+DFDPgbAi6nV6tvJGZxVDsHYoWNhE0gcvmL51H4sr1IbKimphu0TqyTaNcT
         MugTHXVjKPV3KBI8Dy0XmCjzgdYPOUIPReBym5bU0NNwFcNAMqsl0aVX3FCNV8/O8TOZ
         MppJfESDO+6xINqwuM+LBUiHt7SG/I9oEMa1cUanjs7JbUD+g7QYSWhh0w/2C7F2T+3r
         A0emKUlewr9vSYJMu3hpDPzx/FSKvNRMqNn3fH4fYhAu7NrfZI3rkT39si8ciN1c1Ldx
         ZeqQ==
X-Gm-Message-State: AOAM5319UDdUvzCAUiJIg47d+eivf5FlUIGvzSAUbCvOi6KxVq7WRIoQ
        9ewHvJ/TJ+rKt/Rd04Rihnw=
X-Google-Smtp-Source: ABdhPJwO+2kntI2vKAnq2EhOGIoStYyq0+AsQrrHaXncx6UCvB7nJNv9I6rRDQY/bNNB9TrVGooJag==
X-Received: by 2002:a17:906:714d:: with SMTP id z13mr515845ejj.48.1623343236264;
        Thu, 10 Jun 2021 09:40:36 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:35 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v8 10/15] ACPI: utils: Introduce acpi_get_local_address()
Date:   Thu, 10 Jun 2021 19:39:12 +0300
Message-Id: <20210610163917.4138412-11-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Introduce a wrapper around the _ADR evaluation.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5:
- Replace fwnode_get_id() with acpi_get_local_address()

Changes in v4:
- Improve code structure to handle all cases

Changes in v3:
- Modified to retrieve reg property value for ACPI as well
- Resolved compilation issue with CONFIG_ACPI = n
- Added more info into documentation

 drivers/acpi/utils.c | 14 ++++++++++++++
 include/linux/acpi.h |  7 +++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 3b54b8fd7396..e7ddd281afff 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -277,6 +277,20 @@ acpi_evaluate_integer(acpi_handle handle,
 
 EXPORT_SYMBOL(acpi_evaluate_integer);
 
+int acpi_get_local_address(acpi_handle handle, u32 *addr)
+{
+	unsigned long long adr;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &adr);
+	if (ACPI_FAILURE(status))
+		return -ENODATA;
+
+	*addr = (u32)adr;
+	return 0;
+}
+EXPORT_SYMBOL(acpi_get_local_address);
+
 acpi_status
 acpi_evaluate_reference(acpi_handle handle,
 			acpi_string pathname,
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index c60745f657e9..6ace3a0f1415 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -710,6 +710,8 @@ static inline u64 acpi_arch_get_root_pointer(void)
 }
 #endif
 
+int acpi_get_local_address(acpi_handle handle, u32 *addr);
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -965,6 +967,11 @@ static inline struct acpi_device *acpi_resource_consumer(struct resource *res)
 	return NULL;
 }
 
+static inline int acpi_get_local_address(acpi_handle handle, u32 *addr)
+{
+	return -ENODEV;
+}
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
-- 
2.31.1

