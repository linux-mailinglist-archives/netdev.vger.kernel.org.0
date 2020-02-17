Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905891614F3
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgBQOo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:44:28 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40824 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbgBQOo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:44:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id t3so20038269wru.7;
        Mon, 17 Feb 2020 06:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7ajCGkVnCsu2o/jk1mxZ1ZRCgmjy42S+xK0+fwsP2U8=;
        b=pWSk4gezvzftCgHA2ES8n4gY0eoSV2iHGq9G1VVMLbKZ+iUn78nMzG2SMX/fe45829
         nzCZ9miREsuUR2aO+OyOQ0nNWyruqYEYrdLAPhSohHTITSWFOKX5Mtwtn+giH+lRxD0F
         vBdlIePISxjEekbx2rYx8adTwIxX/e9qGhqD+iirJqdkuJvCfUzS+OPESvnF7wceZVRK
         a/ihGGRhq7QMmIGAnxzMKnAkgPkgLmdv445b2Fp5k08+lGJ2ALj/X3m6yjXRoaACC2xJ
         FTycGY3ew1mibRteMvzs+fR0QxbW6xOWvTThIlI8wTWQzhZsGoXNnDhEhJ9TfEjEigRj
         IgTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7ajCGkVnCsu2o/jk1mxZ1ZRCgmjy42S+xK0+fwsP2U8=;
        b=b0qGBklNuySaATH0zia7yuvmybnzOIL1Z4Uh79/cXf6TIFcp5z+AMMMflz6uEmw7Oe
         DD1l5YGWf5japF6HB+4HMiHd+J0FSDQcG0TtjeyEsBls8fPz4P1aOEN8GRfNi2Aobfk2
         SXFJOoi6vc9gFpL3lzQ+BryKw5Aur/lCLgBGVW5p/CNv/mvg5fyXetE9OSWRhH27cXKm
         OvHCtE2/z1AUF04yy6PJmblsvxfWyo8p2Y4Por6gAvxcAzYb+uoLX50CFYqNihvoOGvt
         UHQvRarVC4gBH6ige9/keexOpnDrNuwvir3+PgE90opZD0ksR1AMk+IH14LMk1ly9fJ1
         VD4A==
X-Gm-Message-State: APjAAAXRBkYCNyAFnm5G7qEO3n5UHTWvPFUC23fCXJLellrFvNKpgDdc
        VLBX2skOuRTiYnrAubiAdyU=
X-Google-Smtp-Source: APXvYqxAj36qn37m4nQawOW10OvmiC4FO4AnRRWCAoWtbyT/MO8zNBPR9KqFAggRQc28YDwbmReWCg==
X-Received: by 2002:a5d:4a89:: with SMTP id o9mr21690026wrq.32.1581950664466;
        Mon, 17 Feb 2020 06:44:24 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id j5sm1381699wrb.33.2020.02.17.06.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 06:44:24 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH devicetree 4/4] arm64: dts: fsl: ls1028a: enable switch PHYs on RDB
Date:   Mon, 17 Feb 2020 16:44:14 +0200
Message-Id: <20200217144414.409-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217144414.409-1-olteanv@gmail.com>
References: <20200217144414.409-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

Link the switch PHY nodes to the central MDIO controller PCIe endpoint
node on LS1028A (implemented as PF3) so that PHYs are accessible via
MDIO.

Enable SGMII AN on the Felix PCS by telling PHYLINK that the VSC8514
quad PHY is capable of in-band-status.

The PHYs are used in poll mode due to an issue with the interrupt line
on current revisions of the LS1028A-RDB board.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../boot/dts/freescale/fsl-ls1028a-rdb.dts    | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index afb55653850d..9353c00e46a7 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -194,6 +194,57 @@
 	status = "disabled";
 };
 
+&enetc_mdio_pf3 {
+	/* VSC8514 QSGMII quad PHY */
+	qsgmii_phy0: ethernet-phy@10 {
+		reg = <0x10>;
+	};
+
+	qsgmii_phy1: ethernet-phy@11 {
+		reg = <0x11>;
+	};
+
+	qsgmii_phy2: ethernet-phy@12 {
+		reg = <0x12>;
+	};
+
+	qsgmii_phy3: ethernet-phy@13 {
+		reg = <0x13>;
+	};
+};
+
+&mscc_felix_port0 {
+	status = "okay";
+	label = "swp0";
+	managed = "in-band-status";
+	phy-handle = <&qsgmii_phy0>;
+	phy-mode = "qsgmii";
+};
+
+&mscc_felix_port1 {
+	status = "okay";
+	label = "swp1";
+	managed = "in-band-status";
+	phy-handle = <&qsgmii_phy1>;
+	phy-mode = "qsgmii";
+};
+
+&mscc_felix_port2 {
+	status = "okay";
+	label = "swp2";
+	managed = "in-band-status";
+	phy-handle = <&qsgmii_phy2>;
+	phy-mode = "qsgmii";
+};
+
+&mscc_felix_port3 {
+	status = "okay";
+	label = "swp3";
+	managed = "in-band-status";
+	phy-handle = <&qsgmii_phy3>;
+	phy-mode = "qsgmii";
+};
+
 &sai4 {
 	status = "okay";
 };
-- 
2.17.1

