Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C50D128B1F
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLUTg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:36:56 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41980 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfLUTgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:36:55 -0500
Received: by mail-pl1-f196.google.com with SMTP id bd4so5534227plb.8;
        Sat, 21 Dec 2019 11:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JibM5raV/YAFw3oVHiGpDr4SxeM+CWDiIkx7ilTDLCM=;
        b=qUYmbyc3wvwfq+WzSe3ojeTh/xFwS9sMJR1HuJUGsyFayEqX++0GtMR4IPcXr+SB2n
         nSbggx41PNZsLAb+ynt8Sw5qW76hNbWvwxf0S/2XzdBHNnX9O5tJXYUXGryfMGLQJ2ft
         l4Jjb2iweErtMWtxTxRh4TYZmOljYgDqmYKCj5eznNxItIylq3EIREMQL0Rabuq0kWA6
         uQYZ+E7vxM3nGoN1KfCpZ8t+N7KB8R7QFBbudlEXFYmaEt7fRO8tzoe8v/I9/bSGBtnG
         TVifjLFIOYPUYBV3+BcZaNlyjz0nwL5OwbxC1Ngc/Txzbq6MsclHLicVKT0v1dEAp75Z
         cvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JibM5raV/YAFw3oVHiGpDr4SxeM+CWDiIkx7ilTDLCM=;
        b=m+tKtlReroUlrJ6a83gACnR8HpgPasNDAKgBenqxGq1Wk9bCnwwS9Hb1Op1wqLhLxO
         7krkK4Q7MmOlYCoN6s4EhnEb0J1wBOJBpbDGKjrPBX2sbKV70iW5hVGuBrEw/CCY2ETf
         naOuXMUm++rD/zittMGynlDrEP957QeX0s+nreQzazDOKPahm/wR+ASW9h5QlvHtjgNC
         tnvmzW3OUDpaGmwYEAmooqTy7RdTRvIM9hr0sDxMOqZhbTpuy0hgnNpfgVqsjDL72zaE
         MUyZuZYToJQYOq5jETgDJO3XpcfosRgWNuhfZrbjLusIa7lT6aWcaiGSu3bUFhB3JGCM
         TmqQ==
X-Gm-Message-State: APjAAAVHO+9ER/wejYqfu0bZw+mhjC0NmF1aIFq7u9DHr85vgVVC1Bjo
        Pdk47oW0QUSPcHubPnA1R2MZ3ms/
X-Google-Smtp-Source: APXvYqwx9DHa3YrBPG+gsYZ0uBqquM2cZEnFt1FYahORWDXVNEdnWL3YaGV5c4c0YgnksuDonjjpOw==
X-Received: by 2002:a17:90a:e291:: with SMTP id d17mr25019384pjz.116.1576957014100;
        Sat, 21 Dec 2019 11:36:54 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:53 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V8 net-next 09/12] dt-bindings: ptp: Introduce MII time stamping devices.
Date:   Sat, 21 Dec 2019 11:36:35 -0800
Message-Id: <40fce97d7717ce74bedf64a79f4b96ee07003de0.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576956342.git.richardcochran@gmail.com>
References: <cover.1576956342.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a new binding that allows non-PHY MII time stamping
devices to find their buses.  The new documentation covers both the
generic binding and one upcoming user.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../devicetree/bindings/ptp/ptp-ines.txt      | 35 ++++++++++++++++
 .../devicetree/bindings/ptp/timestamper.txt   | 42 +++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt

diff --git a/Documentation/devicetree/bindings/ptp/ptp-ines.txt b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
new file mode 100644
index 000000000000..4c242bd1ce9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
@@ -0,0 +1,35 @@
+ZHAW InES PTP time stamping IP core
+
+The IP core needs two different kinds of nodes.  The control node
+lives somewhere in the memory map and specifies the address of the
+control registers.  There can be up to three port handles placed as
+attributes of PHY nodes.  These associate a particular MII bus with a
+port index within the IP core.
+
+Required properties of the control node:
+
+- compatible:		"ines,ptp-ctrl"
+- reg:			physical address and size of the register bank
+
+Required format of the port handle within the PHY node:
+
+- timestamper:		provides control node reference and
+			the port channel within the IP core
+
+Example:
+
+	tstamper: timestamper@60000000 {
+		compatible = "ines,ptp-ctrl";
+		reg = <0x60000000 0x80>;
+	};
+
+	ethernet@80000000 {
+		...
+		mdio {
+			...
+			ethernet-phy@3 {
+				...
+				timestamper = <&tstamper 0>;
+			};
+		};
+	};
diff --git a/Documentation/devicetree/bindings/ptp/timestamper.txt b/Documentation/devicetree/bindings/ptp/timestamper.txt
new file mode 100644
index 000000000000..fc550ce4d4ea
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/timestamper.txt
@@ -0,0 +1,42 @@
+Time stamps from MII bus snooping devices
+
+This binding supports non-PHY devices that snoop the MII bus and
+provide time stamps.  In contrast to PHY time stamping drivers (which
+can simply attach their interface directly to the PHY instance), stand
+alone MII time stamping drivers use this binding to specify the
+connection between the snooping device and a given network interface.
+
+Non-PHY MII time stamping drivers typically talk to the control
+interface over another bus like I2C, SPI, UART, or via a memory mapped
+peripheral.  This controller device is associated with one or more
+time stamping channels, each of which snoops on a MII bus.
+
+The "timestamper" property lives in a phy node and links a time
+stamping channel from the controller device to that phy's MII bus.
+
+Example:
+
+	tstamper: timestamper@10000000 {
+		compatible = "ines,ptp-ctrl";
+		reg = <0x10000000 0x80>;
+	};
+
+	ethernet@20000000 {
+		mdio {
+			ethernet-phy@1 {
+				timestamper = <&tstamper 0>;
+			};
+		};
+	};
+
+	ethernet@30000000 {
+		mdio {
+			ethernet-phy@2 {
+				timestamper = <&tstamper 1>;
+			};
+		};
+	};
+
+In this example, time stamps from the MII bus attached to phy@1 will
+appear on time stamp channel 0 (zero), and those from phy@2 appear on
+channel 1.
-- 
2.20.1

