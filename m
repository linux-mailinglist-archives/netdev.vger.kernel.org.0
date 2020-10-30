Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376A72A067D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 14:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgJ3Nc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 09:32:58 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35832 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726646AbgJ3Ncy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 09:32:54 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 86DC04139F;
        Fri, 30 Oct 2020 13:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1604064771; x=1605879172; bh=jqvEA3AoaceEE2lNjSnZv77OE5smrgHBaHn
        uj5fmqlM=; b=FVWDuFVP6QiZYITr9DtLxT3YWQlN8ljJ6Ighj3Fhh8IrVTfn5bI
        HciRL3h/LycwKIGEq70UjeeET7DClQouBO24BguNHdBSh5V/bSjpZgZBgieDJ/E3
        rjIENV1Kt4vi6GhOaQ4p0YAGjtY6yxdCQKZLZEZxC/vBLteBsq56/Vo4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id POV1PvMtJLWi; Fri, 30 Oct 2020 16:32:51 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7E9004137E;
        Fri, 30 Oct 2020 16:32:51 +0300 (MSK)
Received: from localhost.dev.yadro.com (10.199.0.28) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 30 Oct 2020 16:32:42 +0300
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>
CC:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>
Subject: [PATCH v3 3/3] dt-bindings: net: ftgmac100: describe phy-handle and MDIO
Date:   Fri, 30 Oct 2020 16:37:07 +0300
Message-ID: <20201030133707.12099-4-i.mikhaylov@yadro.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201030133707.12099-1-i.mikhaylov@yadro.com>
References: <20201030133707.12099-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.28]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the phy-handle and MDIO description and add the example with
PHY and MDIO nodes.

Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
---
 .../devicetree/bindings/net/ftgmac100.txt     | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
index f878c1103463..accb1b1e07b3 100644
--- a/Documentation/devicetree/bindings/net/ftgmac100.txt
+++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
@@ -15,6 +15,7 @@ Required properties:
 - interrupts: Should contain ethernet controller interrupt
 
 Optional properties:
+- phy-handle: See ethernet.txt file in the same directory.
 - phy-mode: See ethernet.txt file in the same directory. If the property is
   absent, "rgmii" is assumed. Supported values are "rgmii*" and "rmii" for
   aspeed parts. Other (unknown) parts will accept any value.
@@ -32,6 +33,9 @@ Optional properties:
       - "MACCLK": The MAC IP clock
       - "RCLK": Clock gate for the RMII RCLK
 
+Optional subnodes:
+- mdio: See mdio.txt file in the same directory.
+
 Example:
 
 	mac0: ethernet@1e660000 {
@@ -40,3 +44,24 @@ Example:
 		interrupts = <2>;
 		use-ncsi;
 	};
+
+Example with phy-handle:
+
+	mac1: ethernet@1e680000 {
+		compatible = "aspeed,ast2500-mac", "faraday,ftgmac100";
+		reg = <0x1e680000 0x180>;
+		interrupts = <2>;
+
+		phy-handle = <&phy>;
+		phy-mode = "rgmii";
+
+		mdio {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			phy: ethernet-phy@1 {
+				compatible = "ethernet-phy-ieee802.3-c22";
+				reg = <1>;
+			};
+		};
+	};
-- 
2.21.1

