Return-Path: <netdev+bounces-10290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB1B472D96E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CACD1C20A8E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 05:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279CA361;
	Tue, 13 Jun 2023 05:43:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AA523CF
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:43:56 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2078.outbound.protection.outlook.com [40.107.212.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C491610B;
	Mon, 12 Jun 2023 22:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0KEW9bDfeUf+ni6Z6iMT01jE+NW8lyh8FQ1xiqi9iknc01Beu7zmXcL/qZCPilCvJDzwFSI+oVGBPGGxJ24ADtc4rVm2jmXQRq39w1BTF2cyjWy0OeJWnfqPs9t4NJteVLqdsP1DkQSRagVl/zpTfsb9MkH8jZCybYKHqLg+zDXwqSajH5vx6WlZmncGz2O/g5CGd9b+65TNEG0oS8bjdj6Vtt6lMh0nZa+5bvYbFST6TcLQOPeQYMsVG4EUezyizXKq9xb5uF2+6+LepAqJiM4NYxS9/BdJpzsrwY9EGpXJ5sjAxI0pTB93SMUm7tRCmnkojmRxRvksePXJSzutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYLTxX0l/jxO8pwuVApuh76rSCUtE8Nn5+Qauar02ls=;
 b=jJjqFQANfyRyXbXnYaWo5fs9m1bJrTYnV1+8XtlrwM5nfmu8UFgGXzngBwImu+RFETFfe66dsPhAiqTi2r/WNa+rlf7xkTmOs+QSxOZUvYMCkpN1ts/aGLdGft0gYSpvsA3F6AaWbCbbj+9eFpdzd/iQiUuI9QQ1DqcOA0+Zu4yWBZfKROa/eZ+nLTaYZfMatJKK2e53nJjFAbPPJOuwzmvzejWUmHXso8GcVNpN36qJn/7xtm2jyoZeZWAVjeN8j3Dh61d+uCKu+ZPKuL63Kp4CqS7hhwlKDFKlr4pXoVbATwFFxRXZAh2jLV+Vco0c5qm73MX5ULvd+X/2xomXKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYLTxX0l/jxO8pwuVApuh76rSCUtE8Nn5+Qauar02ls=;
 b=GOm6kYJUN0twJm2UR9aBmbHdN95L09HqWyML54CtfAHwyGJQYW6YHxumVqvuXMvbGHyDDjUYDRBnGm7SlRSVihWoSLwipVarwDdmysEOkmCzPpxPSA0tRpsNWBwLg+ZPpRyd7Fsa7IUegYqyY2s8T8GdvzIoS1iIa8ucHRY3+M8=
Received: from DM6PR03CA0044.namprd03.prod.outlook.com (2603:10b6:5:100::21)
 by PH0PR12MB7906.namprd12.prod.outlook.com (2603:10b6:510:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 05:43:52 +0000
Received: from CY4PEPF0000E9D7.namprd05.prod.outlook.com
 (2603:10b6:5:100:cafe::7e) by DM6PR03CA0044.outlook.office365.com
 (2603:10b6:5:100::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.35 via Frontend
 Transport; Tue, 13 Jun 2023 05:43:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D7.mail.protection.outlook.com (10.167.241.78) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Tue, 13 Jun 2023 05:43:50 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 13 Jun
 2023 00:43:50 -0500
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.23 via Frontend
 Transport; Tue, 13 Jun 2023 00:43:46 -0500
From: Pranavi Somisetty <pranavi.somisetty@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <nicolas.ferre@microchip.com>,
	<claudiu.beznea@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <pranavi.somisetty@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>
Subject: [PATCH net-next v4 1/2] dt-bindings: net: cdns,macb: Add rx-watermark property
Date: Mon, 12 Jun 2023 23:43:39 -0600
Message-ID: <20230613054340.12837-2-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230613054340.12837-1-pranavi.somisetty@amd.com>
References: <20230613054340.12837-1-pranavi.somisetty@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D7:EE_|PH0PR12MB7906:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d1d4a7a-0363-447c-21e3-08db6bd12aa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qerAZaiCEwPjBvhuz9ypoaW6PZKz0GU/oVWnud/a57r3zhKTMCdJQLnG1LCv1355eL6mt5KYLH9C5a0jiX3ofhjWpBCPvcWBHwpThYCRncjOJQ1FPXn0YnzD0HqUfXzSkhoYqAK87uYPZJlspAR6z1WpGP/l6H2bjP7MyLWoabeIlOONHJ55IJNHfzAAAK/QDxqQ9ZOtw3mQ1DY4hwR28eWc9yLRxIFVSOMk6duyN2D0RShc05/5mF9W9OGSrJDlqVlTM1KkyOkFSWKWz/2AXA4lg+BT325ks5TSiZQx1wq+wmsiKbaudKkNbZEB6AN9tEPOmxb4PXlvkP6wSuxrTpWsvwbWZkKUIdz21JL9CCTOMOWKFNPE0zFxjJ3mDrAM/Yc5HwN0ApFzmiv/MavtiG8xuYYVzSiLeQ5/A6B6mVFFe3IeJN1cbvwVBLgOj/kCMFRrR+a/whtOb2GVUYqutEiv1/2lqGQqt2aMY3SxBuI1suYcHvB4Tkrb0oz3krlC13ks5u+NG7lQ6bPbKlSeNHLEkmSmwgbSivUpfUrMq/ohrk6PUIYWuQH/aSPs9jD4eDV5yZvVOhQaQuATiVU3U0VcZGSBsx5Pn/xAeQoXWkEvkDDXbQwqx7pAz3pK7GuuKKVdw29ltGK+WrOH9fkUqI1/iOywcgVJCJB5II6VCc4GV02OE3MAZ4+/xYglGAw1R0kuias8LzdngZ8LD612JWrXD1Edq4dkN+CyOCGwmkfhgPaSa8la0HQh+UrKs+svp8X4CLAhf7/JKSN+7VaBHA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199021)(46966006)(36840700001)(40470700004)(40480700001)(40460700003)(110136005)(54906003)(82740400003)(81166007)(356005)(478600001)(70586007)(5660300002)(8936002)(41300700001)(8676002)(70206006)(4326008)(316002)(186003)(336012)(36860700001)(83380400001)(47076005)(6666004)(26005)(426003)(1076003)(2616005)(82310400005)(7416002)(44832011)(2906002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 05:43:50.9594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1d4a7a-0363-447c-21e3-08db6bd12aa0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7906
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

watermark value is the minimum amount of packet data
required to activate the forwarding process. The watermark
implementation and maximum size is dependent on the device
where Cadence MACB/GEM is used.

Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
Changes v2:
None (patch added in v2)

Changes v3:
1. Fixed DT schema error: "scalar properties shouldn't have array keywords".
2. Modified description of rx-watermark to include units of the watermark value.
3. Modified the DT property name corresponding to rx_watermark in
pbuf_rxcutthru to "cdns,rx-watermark".
4. Modified commit description to remove references to Xilinx platforms,
since the changes aren't platform specific.

Changes v4:
1. Modified description for "rx-watermark" property in the DT bindings.
2. Changed the width of the rx-watermark property to uint32.
---
 Documentation/devicetree/bindings/net/cdns,macb.yaml | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index bef5e0f895be..bf8894a0257e 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -109,6 +109,16 @@ properties:
   power-domains:
     maxItems: 1
 
+  cdns,rx-watermark:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      When the receive partial store and forward mode is activated,
+      the receiver will only begin to forward the packet to the external
+      AHB or AXI slave when enough packet data is stored in the SRAM packet buffer.
+      rx-watermark corresponds to the number of SRAM buffer locations,
+      that need to be filled, before the forwarding process is activated.
+      Width of the SRAM is platform dependent, and can be 4, 8 or 16 bytes.
+
   '#address-cells':
     const: 1
 
@@ -166,6 +176,7 @@ examples:
             compatible = "cdns,macb";
             reg = <0xfffc4000 0x4000>;
             interrupts = <21>;
+            cdns,rx-watermark = <0x44>;
             phy-mode = "rmii";
             local-mac-address = [3a 0e 03 04 05 06];
             clock-names = "pclk", "hclk", "tx_clk";
-- 
2.36.1


