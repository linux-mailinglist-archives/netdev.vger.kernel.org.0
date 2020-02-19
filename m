Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37721647F9
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgBSPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:13:14 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53439 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgBSPNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:13:13 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10so1043740wmh.3;
        Wed, 19 Feb 2020 07:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1siZHdXNaBkFw2rS9GSsHRiEk1ELAmyftewPvXED4Ls=;
        b=TzK2azsUyUxFfoF3HlF7nIMC7bJ/FXVouyxM17lSbHna89caQmxbe3YWkhGmpHCaam
         Vya2jCyzfrsEx/G2NI6mqXcbhABH7xIGBqME7OV6641tAiPItALbLtpSaFUmSvgb6QVz
         UWoksRXDGnX8sik9RP4VQCZw755YoXTQH2TyrycOtB69+LqLg7XRs5wyfgCQ00j7W/lj
         /FLzb0yEeyVDp+4PHnd4g68e378qck3xcnRcEPGRSJwtAJpl9ldMw0DGH+CzEARGcn0m
         tMe9t7tRGPQT9db2SdUlIDo7RxfOPrwGeJ8bwPGnvfNXmj4H47pQLDcFqsUB0uJrhvDb
         KQMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1siZHdXNaBkFw2rS9GSsHRiEk1ELAmyftewPvXED4Ls=;
        b=P3qDMBUaQIcRxwgRjYU3KlWH3Plh8Ro4w3pFDshKXF0Z3e5vvvDpVjVWiPQRbHvl3R
         2gOeh9Dx9pEpuOWr1zpzf6mUyQRR1WrMOmR59dNC98Z3tPeeUyPIW3l2uJKS4HVi3xuf
         XVhv4Bv7Dm2Wd+bwQL+ZchTOTjGrngxJ00LeiWb1YXYLfuDWfDtJQsqf2XIK7hxORQbB
         j4Rgc/ffBZnpU8SNU1tKj42eaibisy3Lh495FEv1x16iqw2XGbclUMkDVbuOAQuY8NP+
         w6XITMJqlYw5h+i2eZ69NVIjty0/xc/yhJSsdc52+R3OPpV4Tuc6sOtzCoMRVYNnuiZx
         RS7A==
X-Gm-Message-State: APjAAAWMb+ZiCHX4PMvprTJhCvJjKDBgjwcbTu6ns2fEWmbvMZRMnadf
        547Du6fifqFFzlNtomFTivs=
X-Google-Smtp-Source: APXvYqwdCwAzCaozbkbv6ha96uV1jT92Ce4KkcBwQ9jzEwI6Fe9SA/aL23M2V/VyvgeGUnrFiGL4Qg==
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr10819075wmb.32.1582125191399;
        Wed, 19 Feb 2020 07:13:11 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id b13sm83137wrq.48.2020.02.19.07.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:13:10 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next/devicetree 5/5] arm64: dts: fsl: ls1028a: enable switch PHYs on RDB
Date:   Wed, 19 Feb 2020 17:12:59 +0200
Message-Id: <20200219151259.14273-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219151259.14273-1-olteanv@gmail.com>
References: <20200219151259.14273-1-olteanv@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v2:
None.

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

