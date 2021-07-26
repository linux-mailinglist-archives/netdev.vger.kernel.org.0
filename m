Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A5A3D67AC
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhGZTG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhGZTG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:06:28 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3793CC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:46:56 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n11so6047069wmd.2
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxBs7tGPOu4jS0DaT4/JHFTY8Pd3KfeHgNoTwaqIVmg=;
        b=TgPiaaRdQRHTBlCjEtLL540H4rVutAjMjN2gWOtU749qWj7BH0kATZz/3WMlfr5QAN
         sGlgGwl797xOotYFQPpqwDQ8NjySTqX/AnQ7N/k0z//Ex//dp/BuzfEJDYlrnU+L5Ks1
         lZ53TPkCGHRvHFOVpGbYnOCdvoO7Mi//AAT/4qxTzp9+ioVHxXsHcbGe3lRa+thA1Fvl
         ifopGPYt47gKr61F/L/X8rpYf6LMRJmEBnRkbPXnsujOuXGzsuIcbXNQ2NOV3uIgMi/z
         lh0z/o5U35j2M2Gqx0S9XJ0fp8yIFSENgwBpZs/YBOWu0We3gsfKV2Ier0NYsZkWfHxR
         rV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxBs7tGPOu4jS0DaT4/JHFTY8Pd3KfeHgNoTwaqIVmg=;
        b=jAotsRs2SVl3HlAlPAq5aV3MXktcuTVh6ZjB5znYUB5UXF6xzxJk5ATY/PaThnwMa7
         Iu0BtGbLPmH8zKiV5lzvPc6VScGG3vZWBsF6GkLyGEFllYXfiMblV1Yov05wePuF0K2t
         teX7UIbLaPqrAnnpEsgq0s5+uIxxYqOX6XD6bPsFSo0VnYBTtFdYUV5OJ8dDtkmNpNgL
         r9akuftIclI4YyDGtoJGh2WK4FsFnopH5/OQCdyg/JTxZExpGimTiBzvSrxvlfO9eilx
         rCuDOyGeKLrYVMvVdGcyDK6Lbp8w5f6JzC+QECLQx+I5hXgEwmvdsyIRQzWnu+EhnNfF
         xzkQ==
X-Gm-Message-State: AOAM531aOkwI66/W7ySYAO+WGV9kIEAXNIsZs5Jbem2W6UKZThqx/w+Z
        rl9/3FHJe6ila2ie6LyJhzdnIw==
X-Google-Smtp-Source: ABdhPJzbSgkgYyR+WNF5viSgtAXOYDd6+9SM0yNiMCMne4DreZxfyk8+wJGMl+AhhTlQ0nNtPrXczQ==
X-Received: by 2002:a7b:c045:: with SMTP id u5mr530193wmc.158.1627328814910;
        Mon, 26 Jul 2021 12:46:54 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2f5ziwnqeg6t9oqqip-pd01.res.v6.highway.a1.net. [2001:871:23d:d66a:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id r4sm741528wre.84.2021.07.26.12.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 12:46:54 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 5/5] arm64: dts: zynqmp: Add ZCU104 based TSN endpoint
Date:   Mon, 26 Jul 2021 21:46:03 +0200
Message-Id: <20210726194603.14671-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210726194603.14671-1-gerhard@engleder-embedded.com>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Combination of Xilinx ZCU104 with Avnet AES-FMC-NETW1-G and TSN endpoint
Ethernet MAC implemented in FPGA.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 arch/arm64/boot/dts/xilinx/Makefile         |  1 +
 arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts | 50 +++++++++++++++++++++
 2 files changed, 51 insertions(+)
 create mode 100644 arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts

diff --git a/arch/arm64/boot/dts/xilinx/Makefile b/arch/arm64/boot/dts/xilinx/Makefile
index 11fb4fd3ebd4..d0f94ba8ebac 100644
--- a/arch/arm64/boot/dts/xilinx/Makefile
+++ b/arch/arm64/boot/dts/xilinx/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 dtb-$(CONFIG_ARCH_ZYNQMP) += avnet-ultra96-rev1.dtb
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-tsnep.dtb
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zc1232-revA.dtb
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zc1254-revA.dtb
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-zc1275-revA.dtb
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts b/arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts
new file mode 100644
index 000000000000..19e78b483f44
--- /dev/null
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-tsnep.dts
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-2-Clause)
+/*
+ * TSN endpoint on Xilinx ZCU104 with Avnet AES-FMC-NETW1-G
+ *
+ * Copyright (C) 2021 Gerhard Engleder <engleder.gerhard@gmail.com>
+ */
+
+/dts-v1/;
+
+#include "zynqmp-zcu104-revC.dts"
+
+/ {
+	model = "TSN endpoint";
+	compatible = "engleder,zynqmp-tsnep", "xlnx,zynqmp-zcu104-revC",
+		     "xlnx,zynqmp-zcu104", "xlnx,zynqmp";
+
+	amba: axi {
+		tnsep0: ethernet@a0000000 {
+			compatible = "engleder,tsnep";
+			reg = <0x0 0xa0000000 0x0 0x10000>;
+			interrupts = <0 89 1>;
+			interrupt-parent = <&gic>;
+			local-mac-address = [00 00 00 00 00 00];
+			phy-mode = "rgmii";
+			phy-handle = <&phy1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			phy1: ethernet-phy@1 {
+				reg = <1>;
+				rxc-skew-ps = <1080>;
+			};
+		};
+
+		tsnep1: ethernet@a0010000 {
+			compatible = "engleder,tsnep";
+			reg = <0x0 0xa0010000 0x0 0x10000>;
+			interrupts = <0 90 1>;
+			interrupt-parent = <&gic>;
+			local-mac-address = [00 00 00 00 00 00];
+			phy-mode = "rgmii";
+			phy-handle = <&phy2>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			phy2: ethernet-phy@1 {
+				reg = <1>;
+				rxc-skew-ps = <1080>;
+			};
+		};
+	};
+};
-- 
2.20.1

