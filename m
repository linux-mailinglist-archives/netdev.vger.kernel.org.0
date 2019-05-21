Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E2C25A74
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 00:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfEUWrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 18:47:35 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45780 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfEUWrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 18:47:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id i21so217561pgi.12;
        Tue, 21 May 2019 15:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KPCQBC1rKCqFaAEIlFwql0LyVN8PELXsYd3kP67cssk=;
        b=Udmm5yg/ApuyfLp1rRhOukwfN3Z9W3ShMpcZwtqm2cs9ZXzod2Pv+fW2gZ28PxfdZQ
         4mmVi0pDzcNoC6e6IAU/M2C/AeCrtqPc8VsWiKVvRpRRRdmZJtixFkGMI4BR4Ri8mmWZ
         CL5qXZ1ugdMbGhR/ojayD0xEFdXiEVaWWiMCo08bmYYRowQLt/Cl/IhKtfjDIolOTTdQ
         fTp/66eVCYsm5/8skT+dALrkXytWhwPUdVwItzoBvfOD10p6uBCpvjOElB/LHtDqQAUM
         dnYYGNIb5GsbdRe0VSxuGdGenEa2Z2C1FVVLKJOBtKhtOACaqLeHD1GpS1my3271NYkr
         WTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KPCQBC1rKCqFaAEIlFwql0LyVN8PELXsYd3kP67cssk=;
        b=Crdg2mcgtTapGftZP/najrma70b8jMSsekuRiv4aq58hECBde1mrThL4gI2+xPLR2z
         6d+XxK+SCEPHGNceBiBoS8kSXy1ZBc2SctKQPBSklNnkxpNUwMxDMARJadYW76JZXTQl
         AvyNH4szpeq/9yNWkqaeqlGxf9KXICn0aUh0PKW2k0eghcg6kxs2B6wV7yGffIlH0QJZ
         xSqCgQNB6IwqTdwguRXX7YYS8iB+gm+oLW85EUyhVbU9Doq/Ip+ktVewKgsAqxM7OUmw
         KIseSGMLnNrg6eMD7kpeFD1O8ekPmyiLFQLvynKgjvQK3wUeHJV3YayBJtC3B2gt/RdJ
         MTBA==
X-Gm-Message-State: APjAAAUd+bU0akzSuvNOGWqyBBkH4ZBYAGP/cSTg02Q1i54f49Ugc/Cj
        wppnEso+tY4ZzvVrSIRb4w5agXW5
X-Google-Smtp-Source: APXvYqwVgHuPi6mP4qCf1V2SDZ7DbdqQSVsYuQJHxDAiyWa2o5ODHQb0rQCwxoDwOUSVIhc1M56GPw==
X-Received: by 2002:a62:2b94:: with SMTP id r142mr483032pfr.184.1558478851080;
        Tue, 21 May 2019 15:47:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id r29sm34122419pgn.14.2019.05.21.15.47.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 15:47:30 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V3 net-next 4/6] dt-bindings: ptp: Introduce MII time stamping devices.
Date:   Tue, 21 May 2019 15:47:21 -0700
Message-Id: <20190521224723.6116-5-richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a new binding that allows non-PHY MII time stamping
devices to find their buses.  The new documentation covers both the
generic binding and one upcoming user.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 Documentation/devicetree/bindings/ptp/ptp-ines.txt | 35 ++++++++++++++++++
 .../devicetree/bindings/ptp/timestamper.txt        | 41 ++++++++++++++++++++++
 2 files changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
 create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt

diff --git a/Documentation/devicetree/bindings/ptp/ptp-ines.txt b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
new file mode 100644
index 000000000000..4dee9eb89455
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
+			phy@3 {
+				...
+				timestamper = <&tstamper 0>;
+			};
+		};
+	};
diff --git a/Documentation/devicetree/bindings/ptp/timestamper.txt b/Documentation/devicetree/bindings/ptp/timestamper.txt
new file mode 100644
index 000000000000..88ea0bc7d662
--- /dev/null
+++ b/Documentation/devicetree/bindings/ptp/timestamper.txt
@@ -0,0 +1,41 @@
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
+		compatible = "bigcorp,ts-ctrl";
+	};
+
+	ethernet@20000000 {
+		mdio {
+			phy@1 {
+				timestamper = <&tstamper 0>;
+			};
+		};
+	};
+
+	ethernet@30000000 {
+		mdio {
+			phy@2 {
+				timestamper = <&tstamper 1>;
+			};
+		};
+	};
+
+In this example, time stamps from the MII bus attached to phy@1 will
+appear on time stamp channel 0 (zero), and those from phy@2 appear on
+channel 1.
-- 
2.11.0

