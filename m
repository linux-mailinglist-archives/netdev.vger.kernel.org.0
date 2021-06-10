Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B53A30DF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhFJQmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhFJQmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:42:16 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACE1C061574;
        Thu, 10 Jun 2021 09:40:19 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ce15so216836ejb.4;
        Thu, 10 Jun 2021 09:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ekhkiQ/ajaml1kkzZn9VuscWuNkh/PE4KZAYXzMIVnE=;
        b=LBjQHRUBy/eSAUVhN05Z3w4cUT4qOfjlCzuiJV3c/eOyEqnWk9A0r6HBF/Mso1iktB
         FonlMGy2EP0SGjxQw3Z3rCdElScXasBWjfcd+4f/tekaorUWnuoYh8Z3lNRBPQoGXh7f
         ds7P21wY8G0fkLaX9XZnS4ozPllkvQLMIB6ak1khU0fGQbaVx8IbrIGFZHkYGLE8YUSo
         oOg8dFA+dxWg0EoWBuuz8GUkIaaCI6Ypi4YsxmNtj5G95H21BdTz9tL08lzz1J5YpWGA
         dbPeHwVWCslDNH1dgBxGKjfEJvKBLsDuYWCf006hGm0g8rdwpwwijRBcZjujAYVxhPNk
         fVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ekhkiQ/ajaml1kkzZn9VuscWuNkh/PE4KZAYXzMIVnE=;
        b=DqCvsad8A4dZVTnQj+BBEkJ0ME5skVD7vyGmf4r+/lqTC6r9FIrp9feVXSRCmCABx5
         7K0XVGXmC6+aJRz54cGtSKOwnsbPFesuEUj1penex3Kbjufj239vM8rXEzPEcL0+bV+n
         milzqM0ZudsCvhsvK0gV/OYYGJlrpejlTVzqyBgOotXTtMxuGFqnsJP+crZcQwvSJnBW
         Y2cJDGCGhUWwmjhFgMIkaQ4F1pwo9ctUiO85/xta43vK4o3L5+4AMrJX+0/9Eb0nJric
         7NMUKASBQ0YlBPsDzyCjhAx/B/fBBAxF1gwPmyVdHhhE2JR1it7o5JRFoEeov6ZAO9O+
         mxbg==
X-Gm-Message-State: AOAM533jLxhARLGcbkulRcSNM1I7R0vi2pcmVppeXBONbq38hHDOlSid
        2vQME8uSTKpE1PrzVUB94e4=
X-Google-Smtp-Source: ABdhPJzft5i0ZiOR+rf9TO8ZlJg/BGluC2Y4GAupGRxA5UnS62OO68Rx+K5ILcCy/8s8hEkUbG+q+A==
X-Received: by 2002:a17:906:49c8:: with SMTP id w8mr445104ejv.497.1623343218154;
        Thu, 10 Jun 2021 09:40:18 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:17 -0700 (PDT)
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
Subject: [PATCH net-next v8 01/15] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Thu, 10 Jun 2021 19:39:03 +0300
Message-Id: <20210610163917.4138412-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8: None
Changes in v7: None
Changes in v6:
- Minor cleanup

Changes in v5:
- More cleanup

Changes in v4:
- More cleanup

Changes in v3: None
Changes in v2:
- Updated with more description in document

 Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
 1 file changed, 133 insertions(+)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
new file mode 100644
index 000000000000..7d01ae8b3cc6
--- /dev/null
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -0,0 +1,133 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+MDIO bus and PHYs in ACPI
+=========================
+
+The PHYs on an MDIO bus [1] are probed and registered using
+fwnode_mdiobus_register_phy().
+
+Later, for connecting these PHYs to their respective MACs, the PHYs registered
+on the MDIO bus have to be referenced.
+
+This document introduces two _DSD properties that are to be used
+for connecting PHYs on the MDIO bus [3] to the MAC layer.
+
+These properties are defined in accordance with the "Device
+Properties UUID For _DSD" [2] document and the
+daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
+Data Descriptors containing them.
+
+phy-handle
+----------
+For each MAC node, a device property "phy-handle" is used to reference
+the PHY that is registered on an MDIO bus. This is mandatory for
+network interfaces that have PHYs connected to MAC via MDIO bus.
+
+During the MDIO bus driver initialization, PHYs on this bus are probed
+using the _ADR object as shown below and are registered on the MDIO bus.
+
+::
+      Scope(\_SB.MDI0)
+      {
+        Device(PHY1) {
+          Name (_ADR, 0x1)
+        } // end of PHY1
+
+        Device(PHY2) {
+          Name (_ADR, 0x2)
+        } // end of PHY2
+      }
+
+Later, during the MAC driver initialization, the registered PHY devices
+have to be retrieved from the MDIO bus. For this, the MAC driver needs
+references to the previously registered PHYs which are provided
+as device object references (e.g. \_SB.MDI0.PHY1).
+
+phy-mode
+--------
+The "phy-mode" _DSD property is used to describe the connection to
+the PHY. The valid values for "phy-mode" are defined in [4].
+
+The following ASL example illustrates the usage of these properties.
+
+DSDT entry for MDIO node
+------------------------
+
+The MDIO bus has an SoC component (MDIO controller) and a platform
+component (PHYs on the MDIO bus).
+
+a) Silicon Component
+This node describes the MDIO controller, MDI0
+---------------------------------------------
+::
+	Scope(_SB)
+	{
+	  Device(MDI0) {
+	    Name(_HID, "NXP0006")
+	    Name(_CCA, 1)
+	    Name(_UID, 0)
+	    Name(_CRS, ResourceTemplate() {
+	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
+	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
+	       {
+		 MDI0_IT
+	       }
+	    }) // end of _CRS for MDI0
+	  } // end of MDI0
+	}
+
+b) Platform Component
+The PHY1 and PHY2 nodes represent the PHYs connected to MDIO bus MDI0
+---------------------------------------------------------------------
+::
+	Scope(\_SB.MDI0)
+	{
+	  Device(PHY1) {
+	    Name (_ADR, 0x1)
+	  } // end of PHY1
+
+	  Device(PHY2) {
+	    Name (_ADR, 0x2)
+	  } // end of PHY2
+	}
+
+DSDT entries representing MAC nodes
+-----------------------------------
+
+Below are the MAC nodes where PHY nodes are referenced.
+phy-mode and phy-handle are used as explained earlier.
+------------------------------------------------------
+::
+	Scope(\_SB.MCE0.PR17)
+	{
+	  Name (_DSD, Package () {
+	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		 Package () {
+		     Package (2) {"phy-mode", "rgmii-id"},
+		     Package (2) {"phy-handle", \_SB.MDI0.PHY1}
+	      }
+	   })
+	}
+
+	Scope(\_SB.MCE0.PR18)
+	{
+	  Name (_DSD, Package () {
+	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		Package () {
+		    Package (2) {"phy-mode", "rgmii-id"},
+		    Package (2) {"phy-handle", \_SB.MDI0.PHY2}}
+	    }
+	  })
+	}
+
+References
+==========
+
+[1] Documentation/networking/phy.rst
+
+[2] https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
+
+[3] Documentation/firmware-guide/acpi/DSD-properties-rules.rst
+
+[4] Documentation/devicetree/bindings/net/ethernet-controller.yaml
-- 
2.31.1

