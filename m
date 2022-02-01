Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C905C4A653D
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbiBAT6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:58:39 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:44428 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiBAT6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 14:58:39 -0500
Received: from localhost (127.0.0.1) (HELO v370.home.net.pl)
 by /usr/run/smtp (/usr/run/postfix/private/idea_relay_lmtp) via UNIX with SMTP (IdeaSmtpServer 4.0.0)
 id 48eb9971b89e43b8; Tue, 1 Feb 2022 20:58:38 +0100
Received: from kreacher.localnet (unknown [213.134.162.64])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by v370.home.net.pl (Postfix) with ESMTPSA id 0DC1266B390;
        Tue,  1 Feb 2022 20:58:37 +0100 (CET)
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     netdev@vger.kernel.org
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Subject: [PATCH v2] drivers: net: Replace acpi_bus_get_device()
Date:   Tue, 01 Feb 2022 20:58:36 +0100
Message-ID: <11918902.O9o76ZdvQC@kreacher>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-CLIENT-IP: 213.134.162.64
X-CLIENT-HOSTNAME: 213.134.162.64
X-VADE-SPAMSTATE: clean
X-VADE-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrgeefgddufeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecujffqoffgrffnpdggtffipffknecuuegrihhlohhuthemucduhedtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkggfgtgesthfuredttddtjeenucfhrhhomhepfdftrghfrggvlhculfdrucghhihsohgtkhhifdcuoehrjhifsehrjhifhihsohgtkhhirdhnvghtqeenucggtffrrghtthgvrhhnpefhgedtffejheekgeeljeevvedtuefgffeiieejuddutdekgfejvdehueejjeetvdenucfkphepvddufedrudefgedrudeivddrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddufedrudefgedrudeivddrieegpdhhvghlohepkhhrvggrtghhvghrrdhlohgtrghlnhgvthdpmhgrihhlfhhrohhmpedftfgrfhgrvghlucflrdcuhgihshhotghkihdfuceorhhjfiesrhhjfiihshhotghkihdrnhgvtheqpdhnsggprhgtphhtthhopeduuddprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsghhouhhthhgrmhesmhgrrhhvvghllhdrtghomhdprhgtphhtthhopehihigrphhprghnsehoshdrrghmphgvrhgvtghomhhpuhhtihhnghdrtghomhdprhgtphhtthhopegrnhgurhgvfieslhhunhhnrdgthhdprhgtphhtthhopegurghvvghmsegurghvvghmlhho
 fhhtrdhnvghtpdhrtghpthhtohepkhhusggrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvgihuhhrsehoshdrrghmphgvrhgvtghomhhpuhhtihhnghdrtghomhdprhgtphhtthhopehquhgrnhesohhsrdgrmhhpvghrvggtohhmphhuthhinhhgrdgtohhmpdhrtghpthhtohephhhkrghllhifvghithdusehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrggtphhisehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-DCC--Metrics: v370.home.net.pl 1024; Body=11 Fuz1=11 Fuz2=11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: [PATCH] drivers: net: Replace acpi_bus_get_device()

Replace acpi_bus_get_device() that is going to be dropped with
acpi_fetch_acpi_dev().

While at it, rearrange the local variable definitions in
bgx_acpi_register_phy() and mdio-xgene.c:acpi_register_phy() so as
to put them in the reverse xmas tree order.

No intentional functional impact.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

-> v2: Put local variable definitions in two functions the reverse xmas tree
       order (Andrew Lunn).

---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c |    6 +++---
 drivers/net/fjes/fjes_main.c                      |   10 +++-------
 drivers/net/mdio/mdio-xgene.c                     |   10 ++++------
 3 files changed, 10 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
===================================================================
--- linux-pm.orig/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ linux-pm/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1405,11 +1405,11 @@ static int acpi_get_mac_address(struct d
 static acpi_status bgx_acpi_register_phy(acpi_handle handle,
 					 u32 lvl, void *context, void **rv)
 {
-	struct bgx *bgx = context;
+	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);
 	struct device *dev = &bgx->pdev->dev;
-	struct acpi_device *adev;
+	struct bgx *bgx = context;
 
-	if (acpi_bus_get_device(handle, &adev))
+	if (!adev)
 		goto out;
 
 	acpi_get_mac_address(dev, adev, bgx->lmac[bgx->acpi_lmac_idx].mac);
Index: linux-pm/drivers/net/fjes/fjes_main.c
===================================================================
--- linux-pm.orig/drivers/net/fjes/fjes_main.c
+++ linux-pm/drivers/net/fjes/fjes_main.c
@@ -1512,15 +1512,11 @@ static acpi_status
 acpi_find_extended_socket_device(acpi_handle obj_handle, u32 level,
 				 void *context, void **return_value)
 {
-	struct acpi_device *device;
+	struct acpi_device *device = acpi_fetch_acpi_dev(obj_handle);
 	bool *found = context;
-	int result;
 
-	result = acpi_bus_get_device(obj_handle, &device);
-	if (result)
-		return AE_OK;
-
-	if (strcmp(acpi_device_hid(device), ACPI_MOTHERBOARD_RESOURCE_HID))
+	if (!device ||
+	    strcmp(acpi_device_hid(device), ACPI_MOTHERBOARD_RESOURCE_HID))
 		return AE_OK;
 
 	if (!is_extended_socket_device(device))
Index: linux-pm/drivers/net/mdio/mdio-xgene.c
===================================================================
--- linux-pm.orig/drivers/net/mdio/mdio-xgene.c
+++ linux-pm/drivers/net/mdio/mdio-xgene.c
@@ -279,16 +279,14 @@ EXPORT_SYMBOL(xgene_enet_phy_register);
 static acpi_status acpi_register_phy(acpi_handle handle, u32 lvl,
 				     void *context, void **ret)
 {
+	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);
 	struct mii_bus *mdio = context;
-	struct acpi_device *adev;
-	struct phy_device *phy_dev;
 	const union acpi_object *obj;
+	struct phy_device *phy_dev;
 	u32 phy_addr;
 
-	if (acpi_bus_get_device(handle, &adev))
-		return AE_OK;
-
-	if (acpi_dev_get_property(adev, "phy-channel", ACPI_TYPE_INTEGER, &obj))
+	if (!adev ||
+	    acpi_dev_get_property(adev, "phy-channel", ACPI_TYPE_INTEGER, &obj))
 		return AE_OK;
 	phy_addr = obj->integer.value;
 



