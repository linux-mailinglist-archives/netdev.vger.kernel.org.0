Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E097194060
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgCZNvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:51:49 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:56129
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbgCZNvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:51:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ac7o1d5pdk04pvgaO4ebw0BMxonQT+/qrErGT0ib/HHCXW+ElDt6f31mDdkKuVkiimNa5/ugKhhYvTi909mT9casNSR5es+uzqS1sTdMmKUqFrbzdBr2yU9NnYNMFT8OgkkdxAsikwUQELT531FO9B2mU0KPe6aQ2DX5h1PCB14WK4YJxOt0xiQb7myYp/2YTPayLKC+wWdr6n/bmNb6ar0bnCwUa7JmWYFasTWNsJ9oI86hzaEmSQ14LNtdg5yrkVuYRh5OPDfhaPmvRgfoAfduJJlwjIl+x1ogna7HmRULZeJYcK3yg17G0SR8MTfe/XYZWVDOdz+8qHUrkslCaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpvrJhfAnSsDLKpkCWQXafkQxI3fC3uXMs7q1r34UW0=;
 b=dWSFyVifbAk+Kbqkt0DYVe8LbL3DUtmoT835Vl7Qo1vaphlZLcSs2B6jog55LmSSre3310VnHqLGotgQzPr20QYw+0DsAEOnAft8j27vFfX9oJ6QsNOjkn6Mg7XoggzrVa7OsdV/lmIFTp1JM67W7Z3zWL2vlwLnvMEyPgg/OmJjlSi0S/8oSDwVN3D8dp2R7UNspV4vNKV+UJ3iLgh1dOML70BUL1XsGszx5GRvry2RDZAd/XqFi3OJbx4IZf78GI/Y1x58vxkmMzhyB2RxWLHRop0DC7AFwJ2fuC1l9NPVIRNZDpV/DDqDVYXC8P9DASdr9nDjJfE5WuKV0sGdyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpvrJhfAnSsDLKpkCWQXafkQxI3fC3uXMs7q1r34UW0=;
 b=KvmAiZPnBm8LZEmS8P4E0Mm09P5YNdX/frjHdrR013odyIiMa3knela1llzToooROQakBnJgvdCNOLjKcwl/kvK5bls1Lrd+tQULxv4W02zbom+OF9aLRMXMkIad3et5yplMllDd65tH8Ju3YHaUfXz+BpqZwwN8W52vii4bmmc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:51:44 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:51:44 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 1/9] doc: net: add backplane documentation
Date:   Thu, 26 Mar 2020 15:51:14 +0200
Message-Id: <1585230682-24417-2-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR04MB5454.eurprd04.prod.outlook.com
 (2603:10a6:803:d1::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:51:42 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee97d36c-fb14-497b-462d-08d7d18cd192
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4272124CD0DEACFB757DE1CCFBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(66556008)(316002)(6506007)(6512007)(6666004)(66476007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRJa2k77bLC9FagSr36ElixShm/3/eG8BJqbj/rcNy8QRcjMqkwB8uJCsgmwv4zLMIiR08QBgmRiQxNUv9N4VIehe0ROUY+Y77gjuLa8pqf2QYZ1kyZIOfqEyh6y9h9NNDYSpM9sgVnVMJ8lI4a1RpsZvCyCK29ePHdwY87lXP/FSEbmqyOGN7Vsp8/ti6mQ3ZUvNoBpiSxbE3vHlHo0XBtUeKMPR+B9cQZ/DhOXKiAl+kBRS5pdtMxAyWC16M8VwDCQivS9/XKnGCckP7Fz00X1dm6q7etnwIPQInlvbOJaflGEZ700XPksFIR1tmeC1bfVUyVSbn/tOVDx/fhVCk+vb7uhsRXygx5Bak5g/hTlqmiUaLFJvyHKwenztLVH0lzGVQJxpKcTKe8+A6UGCNkYpQw/KXTsTtqAmt4AoRi6+E9cRNDdoyE4ktNnMEzy
X-MS-Exchange-AntiSpam-MessageData: dcuVwOnLJIJguVw+d+H9hzDfquKuuZLuxuvWRKJapN7ofaE7hWKHgQRXnTwEwJG4MMiwqsjdgfe0Aws+sSEx1Z+fxv0qYECvH2M5pweO470Kfcxv1gLJOKArnVMPabelVgvTkAOUijSGgGsEj7/SAw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee97d36c-fb14-497b-462d-08d7d18cd192
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:51:43.9364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmQKZwh3SglJOh2IlgjQsohqe0nevW/9rx95fqA1pwWhhb+j55sZ14YKaqHiLqTkLKXLlNUvjUbWMestL9sNhP7XeYiFh134+VyaZ+dpZg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethernet backplane documentation

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 Documentation/networking/backplane.rst | 165 +++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)
 create mode 100644 Documentation/networking/backplane.rst

diff --git a/Documentation/networking/backplane.rst b/Documentation/networking/backplane.rst
new file mode 100644
index 0000000..951c17e
--- /dev/null
+++ b/Documentation/networking/backplane.rst
@@ -0,0 +1,165 @@
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
+- Multi-lane:
+40GBase-KR4
+
+Supported platforms
+===================
+
+Ethernet Backplane is enabled on the following platforms:
+
+LS1046A
+LS1088A
+LS2088A
+LX2160A
\ No newline at end of file
-- 
1.9.1

