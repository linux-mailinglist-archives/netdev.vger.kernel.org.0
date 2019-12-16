Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B2120F02
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLPQNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:52 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33813 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfLPQNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:41 -0500
Received: by mail-pf1-f194.google.com with SMTP id l127so4046891pfl.1;
        Mon, 16 Dec 2019 08:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gNjZcUwKUjRa7miXTrI/NIdreYjpCL3WhfJBhtULN3w=;
        b=Yyv1WBkvKxAUTEmx4+5OFRML8+yYpsxJUoHdJ1O31KGLthO4avZ7sa292NDNSP9s4P
         MyxVfrokSaIrpfWRbKed/yPoGbeny/vEf1NoWzf0PuxfI/ugfkLXeVzj2rT/zPKwMxLf
         059yBjNdTBg6Np+szxaa+y5gYZ1WyKZqx/ih2V2JhzMFhlVMjRzKA9vNBcqoXJSPThBy
         Oyg4v/Ze5MUQPqM8N3xwOIufjKp5GQrwnI5zl2GZ/aue5ZwnuGR6Z3/wcsRJccbeZNVG
         hhVScOCs1yTlPejiRqItZdey4hp3awlX6tXT2uKsYaO5uVXTt2Wuolv9exmj2JcjOxZI
         jTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gNjZcUwKUjRa7miXTrI/NIdreYjpCL3WhfJBhtULN3w=;
        b=Ya66DNFlDnF3FxVyDRBvxRrGXxX2iPwBa5Evgw+HWESkzqr0VFT2Y6em67WC+B2T72
         JoveRDj1slP2jWcvFLiXfG68fQIsbraWK38QSv7BavFuOHO56G2tZzYEGwb7i1er3L/5
         TGvn9y2U1iA5XEKZnijJINJ9ixpvaG6patB7KsRw6/Tgs7y79szEDp2JNinrC14kx6rF
         QAButwks2Aw7jbzCYnc6lnm4tgFp4ZGxTlBwSO3bTTAxM9GJDrnR6klGuKXydqDSQCJP
         0XJNA9+0DUbWs/vckDZKEC1IDvdmL7ASKL9azo4KhjZFhcCThaYx68dFn3hhvQcbdgOs
         BaNQ==
X-Gm-Message-State: APjAAAV4LKj7vB8CDvbA+d4laBwPkOmak+0c6rMdHo1QUfrH7GJtCRF2
        uTL7Ch9yJoGu2i+S0qxaJR4oVGKw
X-Google-Smtp-Source: APXvYqyQfWdi7OyrMcxaX+obzTfnOtz+HZqTX9hE403DAhNYO9d6lVKKGALS9q9KljWvpcCq/qgJrw==
X-Received: by 2002:a63:6b82:: with SMTP id g124mr19195452pgc.418.1576512820581;
        Mon, 16 Dec 2019 08:13:40 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:39 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 08/11] dt-bindings: ptp: Introduce MII time stamping devices.
Date:   Mon, 16 Dec 2019 08:13:23 -0800
Message-Id: <f74e71626f6c9115ab9cf919cc8eaed10220ecb2.1576511937.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576511937.git.richardcochran@gmail.com>
References: <cover.1576511937.git.richardcochran@gmail.com>
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
 .../devicetree/bindings/ptp/timestamper.txt   | 41 +++++++++++++++++++
 2 files changed, 76 insertions(+)
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
index 000000000000..70d636350582
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
+		compatible = "ines,ts-ctrl";
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

