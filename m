Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D291552055
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243723AbiFTPNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243360AbiFTPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:15 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA9B12D1C
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:56 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j21so4602214lfe.1
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lWuaSG6HSKcvFGFyg+g82A5w5pDsH3NkEfBqjUDTkfk=;
        b=U6ZqexpWMwtNfy4fgrFqttD04y6IMahzDMMf5MP3BVVrG8OG0j4iKbznvGKRVKIH3x
         EbRPXFceUxsEy2hVgGms7e9b4L9Hvh53LP5Ga76s+m097zlmDDUUg+lLVsqajUGMSDlq
         j4orC0Fc6GDqnK49q0OJTmQfKv4I53zdBQ11H9R/d0lZgqJ13ku6CQtkA/AWQaRq7aih
         VmynjT9xCgHmfPyGaXlgPPCFcghOwgX1qxNvJTHwpNqc4F+wW5MYZY969bwMwoER4bco
         /o/bW3mJpIPeXmDoMvjJyweDcd6Cmfk7liDWCYmF1jO+pGGbH8dD+y2wEAVPaxF1UvHF
         7wpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWuaSG6HSKcvFGFyg+g82A5w5pDsH3NkEfBqjUDTkfk=;
        b=lT8h+B04aR+ZhLceUZc4FE19hHALExcI1DqRzKbs3AUiCTbFJ3rhYocTRCWHa7w31k
         4xfxc/ZMiIeds0g2vd0BZoi7uUd2uB+caP7APUtqxWV17dHvatmQHec8Y9O0WMwSyEdQ
         KWfTu5VNzAYsQGVwhu605tVtAlhJ+g+glKNqRSJ4NxEzfdxDR1dbU5cfWFDEAwZvATT2
         ZYxcg0a/wzU5ka34U4xxWVQht6TE8KVnbDGbK2PWAUP1CFG/yB+qyvjZQ0rDoxvCfyQ+
         jDzOfgF69JoVVtbW1dc8ApbNLJ5PjqBkTTXuBUNR3U+orXK/CqX1kv7ra+0EKGITYVeh
         4bqQ==
X-Gm-Message-State: AJIora8e/W0TUSCqUZJyLY9oojcT1ABHCCrzlpA0sskQZlnfLduYp9Kg
        VqAF7hbblyoAv+fRO7B5Qr5b/lCUKKJ1PA==
X-Google-Smtp-Source: AGRyM1uTGnXuPfk4GfByLJogKz1YnhnU1O9BZc/Qm5s2OM28A/6t4nD5tutEGUS8JHtjHKclXDPDwg==
X-Received: by 2002:a05:6512:3fa0:b0:47f:5758:1951 with SMTP id x32-20020a0565123fa000b0047f57581951mr8779287lfa.609.1655737374810;
        Mon, 20 Jun 2022 08:02:54 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:54 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        lenb@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA description
Date:   Mon, 20 Jun 2022 17:02:22 +0200
Message-Id: <20220620150225.1307946-10-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the Distributed Switch Architecture (DSA) - compliant
MDIO devices. In ACPI world they are represented as children
of the MDIO busses, which are responsible for their enumeration
based on the standard _ADR fields and description in _DSD objects
under device properties UUID [1].

[1] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 Documentation/firmware-guide/acpi/dsd/dsa.rst | 359 ++++++++++++++++++++
 Documentation/firmware-guide/acpi/index.rst   |   1 +
 2 files changed, 360 insertions(+)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/dsa.rst

diff --git a/Documentation/firmware-guide/acpi/dsd/dsa.rst b/Documentation/firmware-guide/acpi/dsd/dsa.rst
new file mode 100644
index 000000000000..dba76d89f4e6
--- /dev/null
+++ b/Documentation/firmware-guide/acpi/dsd/dsa.rst
@@ -0,0 +1,359 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========
+DSA in ACPI
+===========
+
+The **Distributed Switch Architecture (DSA)** devices on an MDIO bus [dsa]
+are enumerated using fwnode_mdiobus_register_device() and later probed
+by a dedicated driver based on the ACPI ID match result.
+
+In DSDT/SSDT the scope of switch device is extended by the front-panel
+and one or more so called 'CPU' switch ports. Additionally
+subsequent MDIO busses with attached PHYs can be described.
+
+This document presents the switch description with the required subnodes
+and _DSD properties.
+
+These properties are defined in accordance with the "Device
+Properties UUID For _DSD" [dsd-guide] document and the
+daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
+Data Descriptors containing them.
+
+Switch device
+=============
+
+The switch device is represented as a child node of the MDIO bus.
+It must comprise the _HID (and optionally _CID) field, so to allow matching
+with appropriate driver via ACPI ID. The other obligatory field is
+_ADR with the device address on the MDIO bus [adr]. Below example
+shows 'SWI0' switch device at address 0x4 on the 'SMI0' bus.
+
+.. code-block:: none
+
+    Scope (\_SB.SMI0)
+    {
+        Name (_HID, "MRVL0100")
+        Name (_UID, 0x00)
+        Method (_STA)
+        {
+            Return (0xF)
+        }
+        Name (_CRS, ResourceTemplate ()
+        {
+            Memory32Fixed (ReadWrite,
+                0xf212a200,
+                0x00000010,
+                )
+        })
+        Device (SWI0)
+        {
+            Name (_HID, "MRVL0120")
+            Name (_UID, 0x00)
+            Name (_ADR, 0x4)
+            <...>
+        }
+    }
+
+Switch MDIO bus
+===============
+
+A switch internal MDIO bus, please refer to 'MDIO bus and PHYs in ACPI' [phy]
+document for more details. Its name must be set to **MDIO** for proper
+enumeration by net/dsa API.
+
+Switch MDIO bus declaration example:
+------------------------------------
+
+.. code-block:: none
+
+    Scope (\_SB.SMI0.SWI0)
+    {
+        Name (_HID, "MRVL0120")
+        Name (_UID, 0x00)
+        Name (_ADR, 0x4)
+        Device (MDIO) {
+            Name (_ADR, 0x0)
+            Device (S0P0)
+            {
+                Name (_ADR, 0x11)
+            }
+            Device (S0P1)
+            {
+                Name (_ADR, 0x12)
+            }
+            Device (S0P2)
+            {
+                Name (_ADR, 0x13)
+            }
+            Device (S0P3)
+            {
+                Name (_ADR, 0x14)
+            }
+        }
+        <...>
+    }
+
+Switch ports
+============
+
+The ports must be grouped under **PRTS** switch child device. They
+should comprise a _ADR field with a port enumerator [adr] and
+other properties in a standard _DSD object [dsa-properties].
+
+label
+-----
+A property with a string value describing port's name in the OS. In case the
+port is connected to the MAC ('CPU' port), its value should be set to "cpu".
+
+phy-handle
+----------
+For each MAC node, a device property "phy-handle" is used to reference
+the PHY that is registered on an MDIO bus. This is mandatory for
+network interfaces that have PHYs connected to MAC via MDIO bus.
+See [phy] for more details.
+
+ethernet
+--------
+A property valid for the so called 'CPU' port and should comprise a reference
+to the MAC object declared in the DSDT/SSDT.
+
+fixed-link
+----------
+The 'fixed-link' is described by a data-only subnode of the
+port, which is linked in the _DSD package via
+hierarchical data extension (UUID dbb8e3e6-5886-4ba6-8795-1319f52a966b
+in accordance with [dsd-guide] "_DSD Implementation Guide" document).
+The subnode should comprise a required property ("speed") and
+possibly the optional ones - complete list of parameters and
+their values are specified in [ethernet-controller].
+See [phy] for more details.
+
+Switch ports' description example:
+----------------------------------
+
+.. code-block:: none
+
+    Scope (\_SB.SMI0.SWI0)
+    {
+        Name (_HID, "MRVL0120")
+        Name (_UID, 0x00)
+        Name (_ADR, 0x4)
+        Device (PRTS) {
+            Name (_ADR, 0x0)
+            Device (PRT1)
+            {
+                Name (_ADR, 0x1)
+                Name (_DSD, Package () {
+                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                    Package () {
+                      Package () { "label", "lan2"},
+                      Package () { "phy-handle", \_SB.SMI0.SWI0.MDIO.S0P0},
+                    }
+                })
+            }
+            Device (PRT2)
+            {
+                Name (_ADR, 0x2)
+                Name (_DSD, Package () {
+                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                    Package () {
+                      Package () { "label", "lan1"},
+                    },
+                    ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
+                    Package () {
+                      Package () {"fixed-link", "LNK0"}
+                    }
+                })
+                Name (LNK0, Package(){ // Data-only subnode of port
+                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                    Package () {
+                      Package () {"speed", 1000},
+                      Package () {"full-duplex", 1}
+                    }
+                })
+            }
+            Device (PRT3)
+            {
+                Name (_ADR, 0x3)
+                Name (_DSD, Package () {
+                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                    Package () {
+                      Package () { "label", "lan4"},
+                      Package () { "phy-handle", \_SB.SMI0.SWI0.MDIO.S0P2},
+                    }
+                })
+            }
+            Device (PRT4)
+            {
+                Name (_ADR, 0x4)
+                Name (_DSD, Package () {
+                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                    Package () {
+                      Package () { "label", "lan3"},
+                      Package () { "phy-handle", \_SB.SMI0.SWI0.MDIO.S0P3},
+                    }
+                })
+            }
+            Device (PRT5)
+            {
+                Name (_ADR, 0x5)
+                Name (_DSD, Package () {
+                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                    Package () {
+                      Package () { "label", "cpu"},
+                      Package () { "ethernet", \_SB.PP20.ETH2},
+                    }
+                })
+            }
+        }
+        <...>
+    }
+
+Full DSA description example
+============================
+
+Below example comprises MDIO bus ('SMI0') with a PHY at address 0x0 ('PHY0')
+and a switch ('SWI0') at 0x4. The so called 'CPU' port ('PRT5') is connected to
+the SoC's MAC (\_SB.PP20.ETH2). 'PRT2' port is configured as 1G fixed-link.
+
+.. code-block:: none
+
+    Scope (\_SB.SMI0)
+    {
+        Name (_HID, "MRVL0100")
+        Name (_UID, 0x00)
+        Method (_STA)
+        {
+            Return (0xF)
+        }
+        Name (_CRS, ResourceTemplate ()
+        {
+            Memory32Fixed (ReadWrite,
+                0xf212a200,
+                0x00000010,
+                )
+        })
+        Device (PHY0)
+        {
+            Name (_ADR, 0x0)
+        }
+        Device (SWI0)
+        {
+            Name (_HID, "MRVL0120")
+            Name (_UID, 0x00)
+            Name (_ADR, 0x4)
+            Device (PRTS) {
+                Name (_ADR, 0x0)
+                Device (PRT1)
+                {
+                    Name (_ADR, 0x1)
+                    Name (_DSD, Package () {
+                        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                        Package () {
+                          Package () { "label", "lan2"},
+                          Package () { "phy-handle", \_SB.SMI0.SWI0.MDIO.S0P0},
+                        }
+                    })
+                }
+                Device (PRT2)
+                {
+                    Name (_ADR, 0x2)
+                    Name (_DSD, Package () {
+                        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                        Package () {
+                          Package () { "label", "lan1"},
+                        },
+                        ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
+                        Package () {
+                          Package () {"fixed-link", "LNK0"}
+                        }
+                    })
+                    Name (LNK0, Package(){ // Data-only subnode of port
+                        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                        Package () {
+                          Package () {"speed", 1000},
+                          Package () {"full-duplex", 1}
+                        }
+                    })
+                }
+                Device (PRT3)
+                {
+                    Name (_ADR, 0x3)
+                    Name (_DSD, Package () {
+                        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                        Package () {
+                          Package () { "label", "lan4"},
+                          Package () { "phy-handle", \_SB.SMI0.SWI0.MDIO.S0P2},
+                        }
+                    })
+                }
+                Device (PRT4)
+                {
+                    Name (_ADR, 0x4)
+                    Name (_DSD, Package () {
+                        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                        Package () {
+                          Package () { "label", "lan3"},
+                          Package () { "phy-handle", \_SB.SMI0.SWI0.MDIO.S0P3},
+                        }
+                    })
+                }
+                Device (PRT5)
+                {
+                    Name (_ADR, 0x5)
+                    Name (_DSD, Package () {
+                        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+                        Package () {
+                          Package () { "label", "cpu"},
+                          Package () { "ethernet", \_SB.PP20.ETH2},
+                        }
+                    })
+                }
+            }
+            Device (MDIO) {
+                Name (_ADR, 0x0)
+                Device (S0P0)
+                {
+                    Name (_ADR, 0x11)
+                }
+                Device (S0P2)
+                {
+                    Name (_ADR, 0x13)
+                }
+                Device (S0P3)
+                {
+                    Name (_ADR, 0x14)
+                }
+            }
+        }
+    }
+
+TODO
+====
+
+* Add support for cascade switch connections via port's 'link' property [dsa-properties].
+
+References
+==========
+
+[adr] ACPI Specifications, Version 6.4 - Paragraph 6.1.1 _ADR Address
+    https://uefi.org/specs/ACPI/6.4/06_Device_Configuration/Device_Configuration.html#adr-address
+
+[dsa]
+    Documentation/networking/dsa/dsa.rst
+
+[dsa-properties]
+    Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+
+[dsd-guide] DSD Guide.
+    https://github.com/UEFI/DSD-Guide/blob/main/dsd-guide.adoc, referenced
+    2022-06-20.
+
+[dsd-properties-rules]
+    Documentation/firmware-guide/acpi/DSD-properties-rules.rst
+
+[ethernet-controller]
+    Documentation/devicetree/bindings/net/ethernet-controller.yaml
+
+[phy] Documentation/networking/phy.rst
diff --git a/Documentation/firmware-guide/acpi/index.rst b/Documentation/firmware-guide/acpi/index.rst
index b6a42f4ffe03..a6ed5ba90cdd 100644
--- a/Documentation/firmware-guide/acpi/index.rst
+++ b/Documentation/firmware-guide/acpi/index.rst
@@ -10,6 +10,7 @@ ACPI Support
    namespace
    dsd/graph
    dsd/data-node-references
+   dsd/dsa
    dsd/leds
    dsd/phy
    enumeration
-- 
2.29.0

