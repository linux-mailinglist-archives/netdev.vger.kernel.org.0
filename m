Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1AA4A64A0
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242321AbiBATHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:07:12 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:45970 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241933AbiBATHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 14:07:12 -0500
Received: from localhost (127.0.0.1) (HELO v370.home.net.pl)
 by /usr/run/smtp (/usr/run/postfix/private/idea_relay_lmtp) via UNIX with SMTP (IdeaSmtpServer 4.0.0)
 id 21f654da68e8f2ef; Tue, 1 Feb 2022 20:07:10 +0100
Received: from kreacher.localnet (unknown [213.134.162.64])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by v370.home.net.pl (Postfix) with ESMTPSA id 7735366B3BC;
        Tue,  1 Feb 2022 20:07:09 +0100 (CET)
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Subject: [PATCH] drivers: net: Replace acpi_bus_get_device()
Date:   Tue, 01 Feb 2022 20:07:08 +0100
Message-ID: <3151721.aeNJFYEL58@kreacher>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-CLIENT-IP: 213.134.162.64
X-CLIENT-HOSTNAME: 213.134.162.64
X-VADE-SPAMSTATE: clean
X-VADE-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrgeefgdduvddtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecujffqoffgrffnpdggtffipffknecuuegrihhlohhuthemucduhedtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkggfgtgesthfuredttddtjeenucfhrhhomhepfdftrghfrggvlhculfdrucghhihsohgtkhhifdcuoehrjhifsehrjhifhihsohgtkhhirdhnvghtqeenucggtffrrghtthgvrhhnpefhgedtffejheekgeeljeevvedtuefgffeiieejuddutdekgfejvdehueejjeetvdenucfkphepvddufedrudefgedrudeivddrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddufedrudefgedrudeivddrieegpdhhvghlohepkhhrvggrtghhvghrrdhlohgtrghlnhgvthdpmhgrihhlfhhrohhmpedftfgrfhgrvghlucflrdcuhgihshhotghkihdfuceorhhjfiesrhhjfiihshhotghkihdrnhgvtheqpdhnsggprhgtphhtthhopeduuddprhgtphhtthhopehsghhouhhthhgrmhesmhgrrhhvvghllhdrtghomhdprhgtphhtthhopehihigrphhprghnsehoshdrrghmphgvrhgvtghomhhpuhhtihhnghdrtghomhdprhgtphhtthhopegrnhgurhgvfieslhhunhhnrdgthhdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepkhhusggrsehkvghrnhgvlhdrohhrghdp
 rhgtphhtthhopehkvgihuhhrsehoshdrrghmphgvrhgvtghomhhpuhhtihhnghdrtghomhdprhgtphhtthhopehquhgrnhesohhsrdgrmhhpvghrvggtohhmphhuthhinhhgrdgtohhmpdhrtghpthhtohephhhkrghllhifvghithdusehgmhgrihhlrdgtohhmpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrggtphhisehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-DCC--Metrics: v370.home.net.pl 1024; Body=11 Fuz1=11 Fuz2=11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Replace acpi_bus_get_device() that is going to be dropped with
acpi_fetch_acpi_dev().

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c |    4 ++--
 drivers/net/fjes/fjes_main.c                      |   10 +++-------
 drivers/net/mdio/mdio-xgene.c                     |    8 +++-----
 3 files changed, 8 insertions(+), 14 deletions(-)

Index: linux-pm/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
===================================================================
--- linux-pm.orig/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ linux-pm/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1407,9 +1407,9 @@ static acpi_status bgx_acpi_register_phy
 {
 	struct bgx *bgx = context;
 	struct device *dev = &bgx->pdev->dev;
-	struct acpi_device *adev;
+	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);
 
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
@@ -280,15 +280,13 @@ static acpi_status acpi_register_phy(acp
 				     void *context, void **ret)
 {
 	struct mii_bus *mdio = context;
-	struct acpi_device *adev;
+	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);
 	struct phy_device *phy_dev;
 	const union acpi_object *obj;
 	u32 phy_addr;
 
-	if (acpi_bus_get_device(handle, &adev))
-		return AE_OK;
-
-	if (acpi_dev_get_property(adev, "phy-channel", ACPI_TYPE_INTEGER, &obj))
+	if (!adev ||
+	    acpi_dev_get_property(adev, "phy-channel", ACPI_TYPE_INTEGER, &obj))
 		return AE_OK;
 	phy_addr = obj->integer.value;
 



