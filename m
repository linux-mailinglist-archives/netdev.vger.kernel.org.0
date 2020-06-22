Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB80203820
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgFVNgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:36:01 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:36110
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728431AbgFVNf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:35:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gB5BUJQgFiUCB4g/VgWAlzV9lsqjhDT7PDOZOnjAI1+8jOfo6QLpAUrY6bf6SlWFrDszwyDnxte03sekH6rEC5RnFJIMBKnOJrI8w4ZBTUB2tAobByonroChk7/4GgJBksAeq9U9PDsK/mOFdNZ6YNEcj32qeK6zSy+EDslIKs6/0PufmpySHRPxjyq5sSUcuLJarJr7EVD3zuROE/zDNeSPgBknFWM1h7ftc2knLDmIxwlHdKiYypjWejIrJsgArswhaKjY3n96y57HG6B7rAtwNASysokhAkMNqenB4MnnzsyZI32dm6OljYLznlw5X26oBV8hrO2wwIe81zPrZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vfHvB8BU1+CY48gtaYTZuh4XrxpoUkm9d/B4/qFB6I=;
 b=hX3E3H0ByFP0jDu9phy1+fQTMNBV6PUF+H1EA1n0Pgvom7YshKLX94o1IZuGMPGmvV8F3PjGdwEcmsTjWvsseJ6x7vxwW92YmpUjPHXjKxgZPhadBhqV/bNaO0fIxM3vzT6jXO9ylSr0bmxUWPx1mVR9mM0Fo4LvMNBkg+F0I7Jvr2+m63hbynDpfVOgcS/UyekLzG79m2VbXlECbKLPtKByU6RuJrK8X8d8NxcA3Wvy2u/9iGkw6Kuo8oiwNM3EcOZ0be7sQcRRV4jOqLBrJ67q5aCqeif7qnnZOxtCAh3+MZ3xrIyLvey7P/rHNw7w1JItgjAfwXDXSiE+5u6kiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vfHvB8BU1+CY48gtaYTZuh4XrxpoUkm9d/B4/qFB6I=;
 b=MXI2+V+j32lYtP9R2s49FSHdT58HdeUH1ikAIVDbolQdlkatuCZ/S4NX69+8/2Z+5uD584ucQytBB2eMjhSkp4Gh16ddyrmiYdAekFms8IEnti5NQPySZGKvdeCwfCwD7TOUrNyEBU4o8FoymzgqNGoEYvOPSnv/gdgpxtUh+4A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5075.eurprd04.prod.outlook.com (2603:10a6:208:bf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:35:52 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:35:52 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v3 1/7] doc: net: add backplane documentation
Date:   Mon, 22 Jun 2020 16:35:18 +0300
Message-Id: <1592832924-31733-2-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0086.eurprd07.prod.outlook.com
 (2603:10a6:207:6::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM3PR07CA0086.eurprd07.prod.outlook.com (2603:10a6:207:6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3131.12 via Frontend Transport; Mon, 22 Jun 2020 13:35:51 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db003716-9494-4648-8981-08d816b12ef4
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB50752DE1BB1DDD94BC24A435FB970@AM0PR04MB5075.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZHOaTPuFBgwpttIBfjtHcb7Qp6vZW5rmM6Qv4EcODujh/wXLmLurfyLSZAEf/48oeOGXg/DzVl08vNgzFIjvBnxZV9jWeMIjSc8B0xlzVdf1n/C6ST3PZxWdeppNFfK68Q4ot0rUr/n9k6QY64e1RwkurnrMHq9ZOWNFFrGTvQ5/t8CpNhtsFRFpuurtKrSE3QJF3OVKlLGXCrg3Qj8ZGC/tRIYdrqggy82rDe/pS5VnHVib1imEzlxxet/az6Dkl55CWc8EnQd+LI8xH4X3g0NJsy/OhO8oKSPyKEJytIgcrJdTqaOQ6GgeWfcMsgtcnmcQ9jhKbjYU+TexqMx5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66476007)(66556008)(66946007)(83380400001)(5660300002)(2616005)(956004)(44832011)(86362001)(6666004)(2906002)(8676002)(6512007)(52116002)(16526019)(186003)(26005)(3450700001)(6506007)(4326008)(6486002)(316002)(478600001)(8936002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Y6/DNVXO++JZvBoU7TBdGT+s7mU4KvElQxZMsRTPdWX0BwqXka9VIjfL5bb7dSHrM2ousBm3yIo/VEHDynO6r6+vZRnvAn79wF5L9hlGgNK1/xjwpJ/cNt8E6QwDJ9rippF1Rgmwxw5rOA2Cuf+K5sIr82F29Y6W12FEe1L2StO+xT0B9bjHsM9ynO8nH8QBdKTIPa7Ha/fccu3HTJxFG2HAULzhCBhHXGMfo3vUyFKPoowvH+q91wCItrGBZjCtYN5vMlCkGzT5tk7k4I2IRsGgUggmRJ2IqxXYjEThCCVG/s/oLBodXOKoYaE32wYqKtCCl6LTl3h3pA5iV1XOBGor1ur1+WMG+PcDFL0eZzFEGjNbOnAO5VGi09fPb6ilR9I5CoiTksemz2XL4fshqkhBslDNqbOcKAXkI9xfuyHBVuR00pa7CLgfe0qVv0VFDsTb3ZBLtjpry+ODoIfaEdxJBwtd6YjkeFPYp5aea6g=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db003716-9494-4648-8981-08d816b12ef4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:35:52.7234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0B4jUNiV2BZQzipMnlmP1hhPuLBQ93A7zG0bUmflSApAygwlWBS+mWnA9L7aDpYm0wzhyDbMmLCUKowRUlkWxuPKxaVBd1a36VqqSMq1z8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethernet backplane documentation

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 Documentation/networking/backplane.rst | 159 +++++++++++++++++++++++++++++++++
 Documentation/networking/phy.rst       |   9 +-
 2 files changed, 165 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/backplane.rst

diff --git a/Documentation/networking/backplane.rst b/Documentation/networking/backplane.rst
new file mode 100644
index 0000000..fb91ba8
--- /dev/null
+++ b/Documentation/networking/backplane.rst
@@ -0,0 +1,159 @@
+.. SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+
+=========================
+Ethernet Backplane Driver
+=========================
+
+Author:
+Florinel Iordache <florinel.iordache@nxp.com>
+
+Contents
+========
+
+	- Ethernet Backplane Overview
+	- Equalization
+	- Auto-negotiation
+	- Link training
+	- Enable backplane support in Linux kernel
+	- Ethernet Backplane support architecture
+	- Supported equalization algorithms
+	- Supported backplane protocols
+	- Supported platforms
+
+Ethernet Backplane Overview
+===========================
+
+Ethernet operation over electrical backplanes, also referred to as Ethernet
+Backplane, combines the IEEE 802.3 Media Access Control (MAC) and MAC
+Control sublayers with a family of Physical Layers defined to support
+operation over a modular chassis backplane.
+The main standard specification for Ethernet Backplane is: IEEE802.3ap-2007
+Amendment 4: Ethernet Operation over Electrical Backplanes
+which includes the new Clause 69 through Clause 74.
+Additional specifications define support for various speeds and 4-lanes:
+IEEE802.3ba-2010.
+Signal equalization is required based on the link quality. The standard
+specifies that a start-up algorithm should be in place in order to get the
+link up.
+
+Equalization
+============
+
+Equalization represents the procedure required to minimize the effects of signal
+distortion, noise, interference occurred in high-speed communication channels.
+The equalizer purpose is to improve signal integrity in terms of bit error rate
+(BER) in order to allow accurate recovery of the transmitted symbols.
+
+A simplified view of channel equalization:
+
+            LD       <======== channel =========>      LP
+       Local Device                                Link Partner
+
+         |-----|                                         ___
+         |     |     <======== channel =========>       /   |
+         |     |      witout signal Equalization       /     \
+         |     |                                      /      |
+     ____|     |____                              ___/        \___
+
+         |\   _                                        |-----|
+         | \_/ |     <======== channel =========>      |     |
+         |     |       with signal Equalization        |     |
+         |     |                                       |     |
+     ____|     |____                               ____|     |____
+
+      LD Tx waveform                                LP Rx waveform
+
+Auto-negotiation
+================
+
+Auto-negotiation allows the devices at both ends of a link segment to advertise
+abilities, acknowledge receipt, and discover the common modes of operation that
+both devices share. It also rejects the use of operational modes not shared by
+both devices. Auto-negotiation does not test link segment characteristics.
+
+Link training
+=============
+
+Link training occurs after auto-negotiation has determined the link to be a
+Base-KR, but before auto-negotiation is done. It continuously exchanges messages
+(training frames) between the local and the remote device as part of the
+start-up phase. Link training tunes the equalization parameters of the remote and
+local transmitter to improve the link quality in terms of bit error rate.
+Both LP (link partner/remote device) and LD (local device) perform link training
+in parallel. Link training is finished when both sides decide that the channel is
+equalized and then the link is considered up.
+
+Enable backplane support in Linux kernel
+========================================
+
+To enable the Ethernet Backplane, the following Kconfig options are available:
+
+# enable generic Ethernet Backplane support:
+CONFIG_ETH_BACKPLANE=y
+# enable Fixed (No Equalization) algorithm:
+CONFIG_ETH_BACKPLANE_FIXED=y
+# enable 3-Taps Bit Edge Equalization (BEE) algorithm:
+CONFIG_ETH_BACKPLANE_BEE=y
+# enable QorIQ Ethernet Backplane driver:
+CONFIG_ETH_BACKPLANE_QORIQ=y
+
+Ethernet Backplane support architecture
+=======================================
+
+Ethernet Backplane support in Linux kernel complies with the following standard
+design concepts:
+* Modularity:
+    # internal components are separated in well defined functional modules
+* Reusability:
+    # lower layer components provide basic functionalities which are reused by
+    the upper layer modules
+* Extensibility:
+    # architecture can be easily extended with support for new:
+    	- backplane protocols
+    	- equalization algorithms
+    	- supported devices
+It is designed as a loosely coupled architecture in order to allow the
+possibility to easily create desired backplane system configurations according
+to user needs by specifying different components and initialization parameters
+without recompiling the kernel.
+
+       ------------------            ------------------------------------
+       |  EQ Algorithms |            |    Specific device drivers       |
+       |  ------------  |            |       Backplane support          |
+       |  |  Fixed   |  |            | ------------------   ----------- |
+       |  ------------  |            | |     QorIQ      |   |         | |
+       |  |   BEE    |  |            | |    devices     |   |         | |
+       |  ------------  |            | | -------------- |   |  other  | |
+       |  |  others  |  |            | | | Serdes 10G | |   | devices | |
+  ----------------------------       | | -------------- |   | support | |
+  |      Link Training       |       | | | Serdes 28G | |   |         | |
+  |   and Auto-negotiation   |       | | -------------- |   |         | |
+  |    (IEEE 802.3-ap/ba)    |       | |----------------|   |---------| |
+  ---------------------------------------------------------------------------
+  |                   Ethernet Backplane Generic Driver                     |
+  ---------------------------------------------------------------------------
+  |                         PHY Abstraction Layer                           |
+  ---------------------------------------------------------------------------
+
+Supported equalization algorithms
+=================================
+
+Ethernet Backplane supports the following equalization algorithms:
+
+- Fixed setup (No Equalization algorithm)
+- 3-Taps Bit Edge Equalization (BEE) algorithm
+
+Supported backplane protocols
+=============================
+
+Ethernet Backplane supports the following protocols:
+
+- Single-lane:
+10GBase-KR
+
+Supported platforms
+===================
+
+Ethernet Backplane is enabled on the following platforms:
+
+LS1046A
diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 2561060..ec17c31 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -279,9 +279,12 @@ Some of the interface modes are described below:
     XFI and SFI are not PHY interface types in their own right.
 
 ``PHY_INTERFACE_MODE_10GKR``
-    This is the IEEE 802.3 Clause 49 defined 10GBASE-R with Clause 73
-    autonegotiation. Please refer to the IEEE standard for further
-    information.
+    This is 10G Ethernet Backplane over single lane specified in
+    IEEE802.3ap-2007 Amendment 4: Ethernet Operation over Electrical
+    Backplanes which includes the new Clause 69 through Clause 74
+    including autonegotiation. 10GKR uses the same physical layer
+    encoding as 10GBASE-R defined in IEEE802.3 Clause 49. Please refer
+    to the IEEE standard for further information.
 
     Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
     use of this definition.
-- 
1.9.1

