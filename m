Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC6D4A72DD
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344851AbiBBOTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:19:24 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:59650 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiBBOTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:19:23 -0500
Received: from localhost (127.0.0.1) (HELO v370.home.net.pl)
 by /usr/run/smtp (/usr/run/postfix/private/idea_relay_lmtp) via UNIX with SMTP (IdeaSmtpServer 4.0.0)
 id c727b483ca273e5c; Wed, 2 Feb 2022 15:19:22 +0100
Received: from kreacher.localnet (unknown [213.134.175.227])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by v370.home.net.pl (Postfix) with ESMTPSA id 3729B66B422;
        Wed,  2 Feb 2022 15:19:21 +0100 (CET)
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
Subject: [PATCH v3] drivers: net: Replace acpi_bus_get_device()
Date:   Wed, 02 Feb 2022 15:19:20 +0100
Message-ID: <11920660.O9o76ZdvQC@kreacher>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-CLIENT-IP: 213.134.175.227
X-CLIENT-HOSTNAME: 213.134.175.227
X-VADE-SPAMSTATE: clean
X-VADE-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrgeehgdeigecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfjqffogffrnfdpggftiffpkfenuceurghilhhouhhtmecuudehtdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkfgggfgtsehtufertddttdejnecuhfhrohhmpedftfgrfhgrvghlucflrdcuhgihshhotghkihdfuceorhhjfiesrhhjfiihshhotghkihdrnhgvtheqnecuggftrfgrthhtvghrnhephfegtdffjeehkeegleejveevtdeugfffieeijeduuddtkefgjedvheeujeejtedvnecukfhppedvudefrddufeegrddujeehrddvvdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddufedrudefgedrudejhedrvddvjedphhgvlhhopehkrhgvrggthhgvrhdrlhhotggrlhhnvghtpdhmrghilhhfrhhomhepfdftrghfrggvlhculfdrucghhihsohgtkhhifdcuoehrjhifsehrjhifhihsohgtkhhirdhnvghtqedpnhgspghrtghpthhtohepuddupdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhgohhuthhhrghmsehmrghrvhgvlhhlrdgtohhmpdhrtghpthhtohepihihrghpphgrnhesohhsrdgrmhhpvghrvggtohhmphhuthhinhhgrdgtohhmpdhrtghpthhtoheprghnughrvgifsehluhhnnhdrtghhpdhrtghpthhtohepuggrvhgvmhesuggrvhgvmhhl
 ohhfthdrnhgvthdprhgtphhtthhopehkuhgsrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvhihurhesohhsrdgrmhhpvghrvggtohhmphhuthhinhhgrdgtohhmpdhrtghpthhtohepqhhurghnsehoshdrrghmphgvrhgvtghomhhpuhhtihhnghdrtghomhdprhgtphhtthhopehhkhgrlhhlfigvihhtudesghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgrtghpihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-DCC--Metrics: v370.home.net.pl 1024; Body=11 Fuz1=11 Fuz2=11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Replace acpi_bus_get_device() that is going to be dropped with
acpi_fetch_acpi_dev().

While at it, rearrange the local variable definitions in
bgx_acpi_register_phy() and mdio-xgene.c:acpi_register_phy() so as
to put them in the reverse xmas tree order.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

v2 -> v3: Fix a build issue and avoid changing the lists of local
          variables (Jakub Kicinski).

-> v2: Put local variable definitions in two functions in the reverse xmas
       tree order (Andrew Lunn).

---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c |    3 ++-
 drivers/net/fjes/fjes_main.c                      |    5 ++---
 drivers/net/mdio/mdio-xgene.c                     |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
===================================================================
--- linux-pm.orig/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ linux-pm/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1409,7 +1409,8 @@ static acpi_status bgx_acpi_register_phy
 	struct device *dev = &bgx->pdev->dev;
 	struct acpi_device *adev;
 
-	if (acpi_bus_get_device(handle, &adev))
+	adev = acpi_fetch_acpi_dev(handle);
+	if (!adev)
 		goto out;
 
 	acpi_get_mac_address(dev, adev, bgx->lmac[bgx->acpi_lmac_idx].mac);
Index: linux-pm/drivers/net/fjes/fjes_main.c
===================================================================
--- linux-pm.orig/drivers/net/fjes/fjes_main.c
+++ linux-pm/drivers/net/fjes/fjes_main.c
@@ -1514,10 +1514,9 @@ acpi_find_extended_socket_device(acpi_ha
 {
 	struct acpi_device *device;
 	bool *found = context;
-	int result;
 
-	result = acpi_bus_get_device(obj_handle, &device);
-	if (result)
+	device = acpi_fetch_acpi_dev(obj_handle);
+	if (!device)
 		return AE_OK;
 
 	if (strcmp(acpi_device_hid(device), ACPI_MOTHERBOARD_RESOURCE_HID))
Index: linux-pm/drivers/net/mdio/mdio-xgene.c
===================================================================
--- linux-pm.orig/drivers/net/mdio/mdio-xgene.c
+++ linux-pm/drivers/net/mdio/mdio-xgene.c
@@ -285,7 +285,8 @@ static acpi_status acpi_register_phy(acp
 	const union acpi_object *obj;
 	u32 phy_addr;
 
-	if (acpi_bus_get_device(handle, &adev))
+	adev = acpi_fetch_acpi_dev(handle);
+	if (!adev)
 		return AE_OK;
 
 	if (acpi_dev_get_property(adev, "phy-channel", ACPI_TYPE_INTEGER, &obj))



