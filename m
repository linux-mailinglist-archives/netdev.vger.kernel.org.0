Return-Path: <netdev+bounces-1371-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 712DC6FD9F1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45565281021
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D1D811;
	Wed, 10 May 2023 08:50:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD67F65C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:50:46 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C9D171E;
	Wed, 10 May 2023 01:50:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LY4BwX9k2mqJsvMwio5t8R6o89Ppt78mEgBs6dsdbNID9wZK1ElyZPxnSTWP2c18/6BcOwxvodwxKEcrryhommYlqFnVICVbzK7jumsvB93uZ6qgGEYDJo7yQ/VGDbb7KfYaibVQiaaZEtS5prDLYZCE4hJWMUUs/t5YqM2qaOfCT6/4R65C99B+X8Hi5Cz1fP+h77sneVOBTOstdSSuJHPoHqLzV3KL1YrdqPTybIb7fnM9XpyNr+aMvuLI5AmB0hHTSvinGLKf+PdY71i07sha8kLGnRVyiDQZ7dgRFXJppO5hO2RTckpIdG8gTJiclXUsLmHpKBKX1wwfNRo0oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c70SCFcmfADdfpRoYecHjhZq8JdWgY2xCAPL8Ijmf10=;
 b=Mgo+NAXxsW4noBEqM1d4K2czTYEK+GzK+Zt/VpTLrO3R3A9RQRgO9JV2ciPBXqTy4bTiUa1cVhLDc6twSo0O4EedDQMSwqD3s5sQqATUlVgq25EXCkQxS5sUPWcyR7pwLs44d1y1ADxqClFwaOio6rDubXZFZo7EqaXh3OAGl8rMQnPzZFjntZ8Qh69YPP9VfFEnu5gIAangQ6I20UbLu8z8sDHZHjIViKebe97vkqUA9HEgJJdF7JzmDlNx1HJCajEbbTt+JMWXodcZiPlxiVovUQRrhrySQBDS5XSJrVC1Nngd5FQVYoAdj1W6M3HwqVgizqyN1PswYjEKuwKjHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c70SCFcmfADdfpRoYecHjhZq8JdWgY2xCAPL8Ijmf10=;
 b=PYuD1MTWjRePfFxgRLZ6zUehsaGKa6dkg//yEkR3M+Qanabe1cmtkRSnTUH4QX/193rClWT2iIoyWgQCaIzW4PMK9cSNLXAe6npFuXLOrpHFU/DUksoSsfjy/3fDcpgyIb70oQQOWTys3sbnsjbhsRHHsN4FZyW1sprFaf6DJ5g=
Received: from DM5PR07CA0066.namprd07.prod.outlook.com (2603:10b6:4:ad::31) by
 IA0PR12MB9045.namprd12.prod.outlook.com (2603:10b6:208:406::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 08:50:42 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::97) by DM5PR07CA0066.outlook.office365.com
 (2603:10b6:4:ad::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20 via Frontend
 Transport; Wed, 10 May 2023 08:50:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 08:50:41 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 10 May
 2023 03:50:40 -0500
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 10 May 2023 03:50:36 -0500
From: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>
CC: <linux@armlinux.org.uk>, <michal.simek@amd.com>,
	<radhey.shyam.pandey@amd.com>, <netdev@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <anirudha.sarangi@amd.com>,
	<harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>, <git@amd.com>
Subject: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet: Introduce dmaengine binding support
Date: Wed, 10 May 2023 14:20:29 +0530
Message-ID: <20230510085031.1116327-2-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|IA0PR12MB9045:EE_
X-MS-Office365-Filtering-Correlation-Id: 7de78640-2ce4-46a6-21ce-08db5133a2b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RoHaSZOFCKHcCQape8WBezju62EKq9pDi/6wXGqC9fdqKq2jAhvwWWgQyXa0LaHFzZT60V4a0LHBRsPQMnNGk7nWsYTpG9Fl0K6W1cS3uZ9QhRph1/oTFRip9/vR2iAGVMLYN0PKlnQ2KWAMonlrcb5D9VLPXfQSjq54T+kGg9aFNnskwv+lBT8cxtYm2PTWVyXz7KqKaVdGA8wb9alXLvhT9iAVNbzeUxfenNZLz2BzR9POpcFk2iGJXRZYxQbtqu/GSulXUSKdz9aParEMJ4xOOIs5O2gS4xUVHX0vJDG6d9pSL0LlYwtLc2GZWUFZWPLo5TkqQnWAkDJjcMTIw37QJTcspJTo+uNBTi+HS04VJmvtXVvttcMSakhH3q9ijfTCh9ke/7Hj02wh12dGFsCFtoHFtpRiKDyCsceb2yDxjp5KwzT9wffX746NE0kUpuVL6r0VWvNe0LInrkMYhEkMt6Mi/frvxOAGSurE742VJv/p83rwyte2eMxmsYEHbu70ar8zji9LabIAB1jfVSiKKfSgkkJ7TuYYbHSgqNpWrR0XqLmqa1Pe3/cHWVTB4W+UhQC/p99dLnm02RgYqlYHSK3RU7M+RU7HUhCawp4a/OzPlHbX8pEg2TYyY9rpmdkqEKH4DdjaoQ7NQ7kAa20JULRyQ4NRU2saFJ5qdgA6noErLxQ//4o5foiLBRfj8nAJfDNTfRkZZ+kjr5n4NuJOdoxQVEjiwbK6MKt4QEM=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199021)(46966006)(40470700004)(36840700001)(70206006)(8676002)(36756003)(103116003)(86362001)(4326008)(316002)(54906003)(70586007)(110136005)(6666004)(966005)(40480700001)(82310400005)(41300700001)(5660300002)(7416002)(2906002)(81166007)(356005)(82740400003)(1076003)(36860700001)(83380400001)(26005)(47076005)(426003)(336012)(186003)(2616005)(478600001)(8936002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:50:41.7368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de78640-2ce4-46a6-21ce-08db5133a2b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9045
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

The axiethernet driver will use dmaengine framework to communicate
with dma controller IP instead of built-in dma programming sequence.

To request dma transmit and receive channels the axiethernet driver uses
generic dmas, dma-names properties.

Also to support the backward compatibility, use "dmas" property to
identify as it should use dmaengine framework or legacy
driver(built-in dma programming).

At this point it is recommended to use dmaengine framework but it's
optional. Once the solution is stable will make dmas as
required properties.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
These changes are on top of below txt to yaml conversion discussion
https://lore.kernel.org/all/20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com/#Z2e.:20230308061223.1358637-1-sarath.babu.naidu.gaddam::40amd.com:1bindings:net:xlnx::2caxi-ethernet.yaml

Changes in V3:
1) Reverted reg and interrupts property to  support backward compatibility.
2) Moved dmas and dma-names properties from Required properties.

Changes in V2:
- None.
---
 .../devicetree/bindings/net/xlnx,axi-ethernet.yaml   | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
index 80843c177029..9dfa1976e260 100644
--- a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
@@ -122,6 +122,16 @@ properties:
       modes, where "pcs-handle" should be used to point to the PCS/PMA PHY,
       and "phy-handle" should point to an external PHY if exists.
 
+  dmas:
+    items:
+      - description: TX DMA Channel phandle and DMA request line number
+      - description: RX DMA Channel phandle and DMA request line number
+
+  dma-names:
+    items:
+      - const: tx_chan0
+      - const: rx_chan0
+
 required:
   - compatible
   - interrupts
@@ -157,6 +167,8 @@ examples:
         clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
         phy-mode = "mii";
         reg = <0x40c00000 0x40000>,<0x50c00000 0x40000>;
+        dmas = <&xilinx_dma 0>, <&xilinx_dma 1>;
+        dma-names = "tx_chan0", "rx_chan0";
         xlnx,rxcsum = <0x2>;
         xlnx,rxmem = <0x800>;
         xlnx,txcsum = <0x2>;
-- 
2.25.1


