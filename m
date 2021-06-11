Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F23A4094
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhFKK6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:58:02 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:41504 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhFKK5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:37 -0400
Received: by mail-ed1-f47.google.com with SMTP id g18so34603309edq.8;
        Fri, 11 Jun 2021 03:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gbwVNa3S8li5NCVOh4mFUhXpgiQevg73Tb0jCktd9T4=;
        b=aUOrr0il8JxtyF4SJWqbAN+Yvnryyq3/lS1vMcJB8pA2R8zpVzedPXNMuQLn3JNqm2
         dBXuypz/2GvMjzTpyZr/8/b8V+1X+DWF1LyzFlnVfe3BkeNOTRoMptKjmRhHe8oAehLp
         R1J4pIpV4aRh7jRi7GKzcJQQQGLbzty0wjjDMsTfgAhHZ/iKf/C1l5IawOBaOtLvBiUL
         q8PxoKpJ4D9SZZZ4SnhAQitzZMf1vw5NlNq1Ea/fQyviafjNOlqZiulV9aGcixB7FFDI
         L0YPPt2e9R3IHB4I4cHCY3oiuOB+BzBiSwRfIKF07OWXUQ3YzoY/o3frhIC/ncDnZ3FJ
         jisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gbwVNa3S8li5NCVOh4mFUhXpgiQevg73Tb0jCktd9T4=;
        b=O3NeWyZ8F3PpZGn41RBYeTCE9WukVS6H2f+rHV/qGSNLHClUcx9/JSYtK/4wr+r1D0
         NsS4yj9d5IVvh3y+pXZjB9kVXmp4qEVOZCaSEyhy/JoQCJKGUmrXPCChA1jJGzjVO8EJ
         zsCXntH9UiOw5nW4XQgFy9dFWMytBmTkYcs3SGRjOceueF9pZuYUsowoJTe5W89B24O8
         3ts00IuSiQ7cNzbpWf+bpvEdS7w9rOlKF+S5il696kb0eTpW8Ouht1ZR9dU/YvGx/o2h
         NjAc9m6CYuCdlWiwG5sRq1EuNclJ5JDps+3BpOlg7qmqoa8vihjFSNanHHL9uGLqrVEY
         eWoA==
X-Gm-Message-State: AOAM532wKHegHfZtqAByzsQTphyEPgm2h7Vsd4kn+PkDXRJlwXnXSPX3
        yAaIRAnQ9+MfJR7+0uxrqtk=
X-Google-Smtp-Source: ABdhPJxIDJolZFi1bIHlyLHtY6oI64I2tnTaxEpyzIUhG0f81a9sJEc0/S9zrYtiGSfufK1XmJVOKw==
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr2954896edk.205.1623408878131;
        Fri, 11 Jun 2021 03:54:38 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:54:37 -0700 (PDT)
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
Subject: [PATCH net-next v9 01/15] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Fri, 11 Jun 2021 13:53:47 +0300
Message-Id: <20210611105401.270673-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Introduce a mechanism based on generic ACPI _DSD device properties
definition [1] to get PHYs registered on a MDIO bus and provide them to
be connected to MAC.

[1] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9:
- Reworded the commit message

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

