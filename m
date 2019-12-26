Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8456412A9A0
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfLZCQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:39 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33279 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLZCQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id z16so12551211pfk.0;
        Wed, 25 Dec 2019 18:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JibM5raV/YAFw3oVHiGpDr4SxeM+CWDiIkx7ilTDLCM=;
        b=iy9FeWO03TjV0nYKRFh8HPHJtlb4XRV16kAb+kjdl+1IN2zVBv4Stx+2Z6LBDkWp99
         saBGXkbGtktIc/h0C5r6381bv95g5WQ9gjCI/CHrmC1bNih/YkiEx8FfqyNsPWLk2ngB
         rcHQKl2w/3BssGqszTSdqCWll5fITuy8il2mwbLx6s/AgWUb6psuHrKbL4tKu+tQ7y9l
         YOY3wBByQ0OMIBjUzZN4ravk8KawKDJqw3V73eW7svyhUCdl/WkH2BSZvR0Smtn2LQ+M
         F3KN8R3EuKYzjluAAqvMXhr4giUrYFzdZhewLfJPmW9dXSfqE/tmiAAT4AROJWwfyIU+
         Ny2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JibM5raV/YAFw3oVHiGpDr4SxeM+CWDiIkx7ilTDLCM=;
        b=NrpNbbRnpD3gxeAiS5oxQp/QR84qt7siHHDlrpIi4zGAD8Nv1IYhEtvuF9IvpSpAyM
         j9zlNwHuW021kySJXocpExWL0DDunVqu0u1AH07BHwBeDcYyZLD86mfYUOaW2iVZnB//
         Ww41wTAkw6ry3mRSEXrXt7jd6mE4/+OkdEPZ1iHleDgHFDP6iH98rtJTXvkURGtLF/5+
         snxAHzwPTqlJTvHqvXskWbEVwsE6wI5nwrysS45JQHf8yaO7l6bl2LAOYIgrQhobE7U9
         6+re/a8kI+52578tGsujvd5WqfQ+mBQjUXH4Oh6xUo8eWee38vHN20ghX08ng/fet3Ci
         x77Q==
X-Gm-Message-State: APjAAAXf9/FRYJddFiyXkDuvyTSlFZsR9LIBcTBfBzL143/GX83Sn+BN
        1qdoHcPfrLmhcfLOVj6Mcmd6rV/8
X-Google-Smtp-Source: APXvYqx6xrRVf7BK131KXKJwttAzrGsb+q04dtc8XOxFEhbcs8khIJ5nGvh/t6yhMMgP3TEtkJ3AfQ==
X-Received: by 2002:a63:5211:: with SMTP id g17mr47916262pgb.426.1577326595177;
        Wed, 25 Dec 2019 18:16:35 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:34 -0800 (PST)
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
Subject: [PATCH V9 net-next 09/12] dt-bindings: ptp: Introduce MII time stamping devices.
Date:   Wed, 25 Dec 2019 18:16:17 -0800
Message-Id: <ee2e7db95bfc8a30c7f398f051a073aaf38bb7f6.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
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

