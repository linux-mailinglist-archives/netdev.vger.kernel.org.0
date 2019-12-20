Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28C1128214
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfLTSPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:15:39 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35259 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbfLTSPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:15:38 -0500
Received: by mail-pg1-f194.google.com with SMTP id l24so5335563pgk.2;
        Fri, 20 Dec 2019 10:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JibM5raV/YAFw3oVHiGpDr4SxeM+CWDiIkx7ilTDLCM=;
        b=cESvWSgkrIy8f/s6Yulz4lh8rk6GronUeIYbl1ZJ6TEOm70trRvYLRYiQdVm/Bw58g
         FzmzMCHl0YN/Awr6aJdvcMcQMZy6GNDDXJ2f9sE9Iz7sYTi1hrMGdXBwteNfhRkbQI9Z
         CWz4BGReW8Btz7RzrEtUii4TyhkyJBsunAFUPH/m/xEe9vMOa5+3LYrWak9ZJTXBc9Qv
         XW8+PrYv5eu1q9w2JDrA/GQwZfhjqza+adCbmDRczAIQmqYxv8HOYIL51Rzn2GadpVQ1
         Zfnl1Hq+SYfq+I2FWaZj1iWVIVZ4S6nFat/IMbq8W5F4f27eSibWwQngF+cYwmoLK5RS
         N73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JibM5raV/YAFw3oVHiGpDr4SxeM+CWDiIkx7ilTDLCM=;
        b=C5rifeT+skmxsBOX6Pdw/Yy10YjiQMXJoeVAXoZXgeyIhhQXI8itsIssJ52lhgqpDu
         FQ0/JYDMxYFA22Q2o7E2KFuLZxR5oLU5pnGJsVCP5uZI2rTdtdLT1XFf1zeDhmcUciWS
         lExYTiDoPiAHGPCnYVF+0tALdSYNX4EJWx1APNtZl3osw9hyPqJojh8du2kLjr5gYKOD
         xjpGb5+hQ3XinrdSndm0UFUQJTR0zsEDwUZyGEPk+EoLviggSsTWkXlPWyt39yFN84bS
         C74osfcnUeUKpniWVCwHfH6EjQmvRYGDiYy9zRCwI/vCXaJBNDh2E3yC5AbmYYW+8173
         lUzg==
X-Gm-Message-State: APjAAAVQje7ESszE+RZ5Zc+r4kIxxL20+9DO0mxGJzmjkUX5H+kyuCfq
        VoTsC4vwirafu3jIo7NOg462Ogoz
X-Google-Smtp-Source: APXvYqxWUbqUGtyBg1r6hj9shUPVFGvI07iD5tPN4AicdSXxEVzBqTbakqK7ev4O92JJalNrHJM35g==
X-Received: by 2002:a62:1746:: with SMTP id 67mr1027441pfx.45.1576865736982;
        Fri, 20 Dec 2019 10:15:36 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j28sm11833869pgb.36.2019.12.20.10.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:15:36 -0800 (PST)
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
Subject: [PATCH V7 net-next 08/11] dt-bindings: ptp: Introduce MII time stamping devices.
Date:   Fri, 20 Dec 2019 10:15:17 -0800
Message-Id: <3c9a3c7cd94a8667c88bbbef25eb6fe500a0663a.1576865315.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576865315.git.richardcochran@gmail.com>
References: <cover.1576865315.git.richardcochran@gmail.com>
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

