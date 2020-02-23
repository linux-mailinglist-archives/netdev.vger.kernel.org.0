Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9297C169A0A
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 21:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgBWUri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 15:47:38 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54749 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgBWUrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 15:47:33 -0500
Received: by mail-wm1-f67.google.com with SMTP id z12so3809615wmi.4;
        Sun, 23 Feb 2020 12:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nlEamf3Bb75llXd1Mhw/lOhQJYbINGDlRtFSVygDuDU=;
        b=gon4KZhzPKlehdd0aPjjxxDnjn7tFM/owUqv/JfmkGPd6K0fNde3p7dUyOImYCLoh+
         c6nmG5tT4DpwnqSgHS75lzDybHm/p1TshgeQOt0cjnQZLav6IcfBjjw9A+Gz6D9Z0W6A
         bSaLikGpID0JGmsAvtl2atuaOZPZCkRe4GJxT27Eg+eUL84g53pmb8+d5nMTy+pRsQBw
         u6zOTnAysaALtKAZINy2yup3zcdwu+0QT8jeGEU9/m/qu1CFLn0j64iMwsXKuioQBMR9
         97+Z8nZuOjaLC2SuIfOoCW2tTK/imCMEvZ/Fute2lvMU7bxKGxEhE60gpM12cHMZ5SgP
         NV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nlEamf3Bb75llXd1Mhw/lOhQJYbINGDlRtFSVygDuDU=;
        b=cJ9Z0mAW8AsNmOdVmvh8hTOn6m50O66Kau+miiYhffWqI4sx2r48+5ayCGrsIP73Et
         d3b2ltVqVFOXqVEq64ahkigOCgL6vTghgbon9feLewROupusiXe0UZuPmuMRxWSMoz3j
         lca6T3R6Xzy9bPsF/QCw9aiNCuJHqH4WL4jCHqE2fMXCMVVEw9Ws0eKEd0nuhvzpgnaq
         FkuGzHOXno54bySXO0q95knXdmu0CV897OA7v4XKNFrcYcRTqV0EfSruZyxdW7FTyOt7
         TiAmQw97vVUX45XURWnp+MYMsPBLyDw4Bzh924oHYsu43AdGBbn0sSELI4hDI58P7XYI
         qzDg==
X-Gm-Message-State: APjAAAUX++RTXfT0gmgz4I5FKyxRmJ7xZzFNmHtVRPkWr73d/fHEqglN
        btpJD3LdwQqwEHfhXtdusbM=
X-Google-Smtp-Source: APXvYqz/cf1PBssq3BPpoP9LiziohZ60js7tzpnfBEbSAsDu30hCL3wVYhOkSpBgx2WVvxjB0CNi1g==
X-Received: by 2002:a1c:4c8:: with SMTP id 191mr17418212wme.148.1582490850929;
        Sun, 23 Feb 2020 12:47:30 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z8sm14817927wrq.22.2020.02.23.12.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 12:47:30 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 devicetree 6/6] arm64: dts: fsl: ls1028a: enable switch PHYs on RDB
Date:   Sun, 23 Feb 2020 22:47:16 +0200
Message-Id: <20200223204716.26170-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223204716.26170-1-olteanv@gmail.com>
References: <20200223204716.26170-1-olteanv@gmail.com>
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
Changes in v3:
- Set and enable the CPU port and DSA master from the board-specific
  fsl-ls1028a-rdb.dts.
- Move the "status" property to last.

Changes in v2:
None.

 .../boot/dts/freescale/fsl-ls1028a-rdb.dts    | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index 14efe3b06042..6d05b76c2c7a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -177,6 +177,25 @@
 	status = "okay";
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
 &enetc_port0 {
 	phy-handle = <&sgmii_phy0>;
 	phy-connection-type = "sgmii";
@@ -191,6 +210,47 @@
 	};
 };
 
+&enetc_port2 {
+	status = "okay";
+};
+
+&mscc_felix_port0 {
+	label = "swp0";
+	managed = "in-band-status";
+	phy-handle = <&qsgmii_phy0>;
+	phy-mode = "qsgmii";
+	status = "okay";
+};
+
+&mscc_felix_port1 {
+	label = "swp1";
+	managed = "in-band-status";
+	phy-handle = <&qsgmii_phy1>;
+	phy-mode = "qsgmii";
+	status = "okay";
+};
+
+&mscc_felix_port2 {
+	label = "swp2";
+	managed = "in-band-status";
+	phy-handle = <&qsgmii_phy2>;
+	phy-mode = "qsgmii";
+	status = "okay";
+};
+
+&mscc_felix_port3 {
+	label = "swp3";
+	managed = "in-band-status";
+	phy-handle = <&qsgmii_phy3>;
+	phy-mode = "qsgmii";
+	status = "okay";
+};
+
+&mscc_felix_port4 {
+	ethernet = <&enetc_port2>;
+	status = "okay";
+};
+
 &sai4 {
 	status = "okay";
 };
-- 
2.17.1

