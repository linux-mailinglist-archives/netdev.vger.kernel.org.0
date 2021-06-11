Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11A63A4087
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhFKK5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhFKK5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5966BC0613A2;
        Fri, 11 Jun 2021 03:55:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l1so3913185ejb.6;
        Fri, 11 Jun 2021 03:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nD0FvHmxOFRRWKT1YrUDX8wRFZH1BwQpKvwiKOY2Wm4=;
        b=benHG22ahSfVkYfxO/0xdrFr9jO2kZiyud+VZo9+gm5/n0T0iJ2QvFFWMS1UVRlEO6
         J4JtrhdCn0VhxcThOECLR0XI71rW0vp5+N1xwMC/u0l/6LwgD//1bsvKN2RCPGWrzKHe
         /KTTxwJD8AC3SzPV/WzSSZw2+3lpuwlB/EMfVQeU4UGD4AnpJsvsV9m+l9GgaFEGxRPz
         VC8dwkD6jbhYDQKCUMqavXya+QgzRUFWt1OK8jyl6olZKADl9hKY0fH/Pkr1uH4ZpAyk
         XhYotwBdGyIeY2NpIcSghwBqJxiuiF7Ajafn/WwTsp2ctDCCGl66dAtZ/hOQsq/vddqc
         wSMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nD0FvHmxOFRRWKT1YrUDX8wRFZH1BwQpKvwiKOY2Wm4=;
        b=pOYaiV+jG1nE10UmoiqjsoezI6yzlHu5nsw2WB+DnDIEBLc19CzbrJONqVpH3I505I
         gBONKZDecYCxyJpcL3l0z977DBkvTZkAKDpfU7nzegeTlHxj7e4aK2dHocFMqTxqu9nn
         APHLqK58tSU3aJpZoqMDWKFHMHYjnzkAukpNOV6lYALEWAZgYdStNIQGbsIWViE5K9Kd
         tlCT4iudR5STPVkAzxfNXms8i+/DxxbSjOsY9/i+1OtRYfWPtWtHM+e4WHW0ndz1/Pxe
         sqiZDA0vIw8kphTtOeLArQ/Yn6eBITdahNwe4NuSw7Ih7fwRd4Lpznu6/t9+YVZBF953
         9Jzw==
X-Gm-Message-State: AOAM533ZBk8Mt9EOvpMSF7ovt0rhcNkdPvK0Ny37bkSg4UGXnhZc6PBx
        lRf9MHamxqQGzc3a+tZwp3o=
X-Google-Smtp-Source: ABdhPJw2/O82wbK7zKE8NB0q+0btIDMCmQPSgZ3WH5y7acwzCyJQOpi9+amaa4UTtBrYPVROxfDsLQ==
X-Received: by 2002:a17:906:f192:: with SMTP id gs18mr3192101ejb.114.1623408911861;
        Fri, 11 Jun 2021 03:55:11 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:11 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
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
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v9 10/15] ACPI: utils: Introduce acpi_get_local_address()
Date:   Fri, 11 Jun 2021 13:53:56 +0300
Message-Id: <20210611105401.270673-11-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
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
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: None
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

