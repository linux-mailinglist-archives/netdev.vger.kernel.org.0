Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E68508689
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 13:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377875AbiDTLGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 07:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377887AbiDTLGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 07:06:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230CB4131A;
        Wed, 20 Apr 2022 04:03:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjYvpoqnP9NQRAUR4mh++dnHXC0WSrHmtnyKOtyQd7PpLTcrUpPc1DrAemFOO/XrJ71ADWetsPM5UhNggX4BQba35LbBEGm+bDVGWVaFFXSij4dwoNnxMH7dwgNylRq9lPBLTwolTsEa1ndonDGyHwoi0fj71qyfSyiWQiFPS/iO4d//HRJJCkkZx/bZOzb6cqljGzqi26ALPzFiGjwwUalJ0ilPptEJSQ8Q5PJ/6jgOPz6DQnoOs8ZTKJ5qtlIYVrRN88emLfTB9m5Dw2DruPQtPPBzW0Q9l9lYcHTLk1S1enaSZXoNG+A9qLffm75tvt34W/u1HwNB0+i3khTsgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/OwiQ1ahucjlSTC78SiXPLIdjaJizBZnaUlPfgl16g0=;
 b=N4kHM9rNtcMUy327hrm03z15xgXo19vLHm6YYeirS/IoLFe8/ox1Aw6amEIkKxxRTibKObHOmrm4gTzvETOpKMDp3xXlfCo3WcYPS2C2i6W9ChByxwb8iOqlxb433ef+SvF1demrZP5tW+jABcUjYfv7RFra6Zg5CeQHoCKqaC4CZG0ugI1c08PW6c1R95kAIAiDWROqHanHfzwowfjOREdMsblG63XxnLT+HvVbXciFOCl6u1YdTMNNFqawnO+Z02ZFL1+Fngb/RXYB/TDYqlR+lenatbit4UfgLsV+/wW7nTe5udRYzMlczyBw0mG+ryU6rwCI4ra9pXH/Hqwq1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OwiQ1ahucjlSTC78SiXPLIdjaJizBZnaUlPfgl16g0=;
 b=XzZi9NKzQuTgEhD6XqAgVOnx366tCzr3NXzfkZybrMUeq2cQeCOntaMNvq0lk76AQZGuMDXMmeCSDjnrLHL1tOuntnb1fH5b4NEabkXwQGnF4SlG6KuGObF2tV+fyJxPzrASkT+D3vSRs66s4gqEKkgqL9UoZAyOD+xYbqq6cG8=
Received: from SN4PR0501CA0002.namprd05.prod.outlook.com
 (2603:10b6:803:40::15) by DM6PR02MB4937.namprd02.prod.outlook.com
 (2603:10b6:5:1a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 11:03:53 +0000
Received: from SN1NAM02FT0039.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:40:cafe::b0) by SN4PR0501CA0002.outlook.office365.com
 (2603:10b6:803:40::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.8 via Frontend
 Transport; Wed, 20 Apr 2022 11:03:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0039.mail.protection.outlook.com (10.97.5.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Wed, 20 Apr 2022 11:03:53 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 20 Apr 2022 04:03:51 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 20 Apr 2022 04:03:51 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 krzk+dt@kernel.org,
 kuba@kernel.org,
 robh+dt@kernel.org,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.63.71] (port=44648 helo=xhdvnc211.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nh87j-000GIv-Bm; Wed, 20 Apr 2022 04:03:51 -0700
Received: by xhdvnc211.xilinx.com (Postfix, from userid 13245)
        id 4A60B60544; Wed, 20 Apr 2022 16:33:37 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzk+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michals@xilinx.com>,
        <harinik@xilinx.com>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 1/2] dt-bindings: net: cdns,macb: Drop phy-names property for ZynqMP SGMII PHY
Date:   Wed, 20 Apr 2022 16:33:09 +0530
Message-ID: <1650452590-32948-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1650452590-32948-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1650452590-32948-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef6603e3-536e-483c-516d-08da22bd7508
X-MS-TrafficTypeDiagnostic: DM6PR02MB4937:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB49373FE5CFF5B26F82243DC4C7F59@DM6PR02MB4937.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kmg9OsVHvXkegjdx4hkkTSUXf74Cwt0tGp+/xdDe5kTLm+STn8GU4Xrsn5j2Liy/NmfV8rYO2x2y0awCpiAhip5nYje15NU2IoKcGMe+SGD9N35omrwEFpOgq4pQ5fCAtreJjW7c6Ctgabt/9XCWrQUrSNiRaq9hyeJ6nLeMGn1zsVOOmPGN+iBcYM/Vuq0CEJeM5DmEK02xYidrZUWLSaHrPrET7h06BFsP19mCxvZD09S1P9aUBkzIkklnZlYVRD+CfAXjNMt6EqbOq6hqesQiHMU3qjgvBDBBLiXWf4eJb/6ba3gGkpKcEnM2Cev9PhXO2rRnIXSDNnpayeE4L1920JiNHXShRtyoDFAVCZSU8vVaGi2LAh5ojLnHLr2nHwaEM85eoPoJaP850V1h7mV80kSI+jp8EzNFpYE5X3PEfeP87Xe6POp7So78Vc0GFisFSiVoPDMCgvkig4sqEiBiad70p66nt4FYQS37q8SV7RF12piVCO7jmiFbqo8gQkxEfWkDRg+AvWN3bRnYTz4jftugmRT/PL7/gH4Y+DgaUQvpjQpbXEF7xXI1issGDFL/lzWiIbeXa1YEGo63ybYpQUzo0AMGNSFMKSV75QxedTfUOvOxBg32K/PuBIWCKKvVfUqcjMIgIDub5SdA3/zFoCHAkdLf3bH+u2+BxjFkDHSuEHnulVUQq50F/AuFeX0G1ruiwfYqbc2VMsnk4oOfUKef0vSLnW0+ol0m6VVyMYcfA8/j1Amvpw4C2LHW3hX0CF3Xb1kh7liXbEuZymz4U0v2NUeZvtelEylwIM0=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(316002)(2616005)(36860700001)(107886003)(82310400005)(70586007)(36756003)(356005)(8676002)(4326008)(42186006)(54906003)(110136005)(70206006)(83380400001)(40460700003)(47076005)(186003)(7416002)(6666004)(7636003)(5660300002)(26005)(966005)(6266002)(2906002)(508600001)(426003)(336012)(8936002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 11:03:53.3208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6603e3-536e-483c-516d-08da22bd7508
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0039.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4937
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In zynqmp SGMII initialization, there is a single PHY so remove phy-names
property as there is no real need of having it.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
Note: For this change taken reference from upstream commit (8a917813cc74)
phy: Allow a NULL phy name for devm_phy_get().
https://lore.kernel.org/r/20210414135525.3535787-1-robh@kernel.org
---
 Documentation/devicetree/bindings/net/cdns,macb.yaml | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 6cd3d853dcba..e5b628736930 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -84,13 +84,6 @@ properties:
   phys:
     maxItems: 1
 
-  phy-names:
-    const: sgmii-phy
-    description:
-      Required with ZynqMP SoC when in SGMII mode.
-      Should reference PS-GTR generic PHY device for this controller
-      instance. See ZynqMP example.
-
   resets:
     maxItems: 1
     description:
@@ -204,7 +197,6 @@ examples:
                     reset-names = "gem1_rst";
                     status = "okay";
                     phy-mode = "sgmii";
-                    phy-names = "sgmii-phy";
                     phys = <&psgtr 1 PHY_TYPE_SGMII 1 1>;
                     fixed-link {
                             speed = <1000>;
-- 
2.7.4

