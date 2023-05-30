Return-Path: <netdev+bounces-6315-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 880AF715AB8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 419FC28029F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC61B168CC;
	Tue, 30 May 2023 09:52:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25841643F
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:52:14 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DA2109;
	Tue, 30 May 2023 02:51:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5nGQnbmeziG/LuYLogCufeRP3Bza/xk/icoqm64cvc72YrPsrYtK/1e5PQ4aeOvquTjTui6wWfizsexoUsDhSJYNw+lsMLB95nAgDlaX1Shu4EIh7t5rC/YXvdsr3oUAt/GL/fF2lCjK6/JloZuSPMEbz33RcWl2XokmqSdQn8r4XvX5Ww9m8+UtWjW2Q5eBNvHzDkNqMfs+2rP96LanMsQOC45it4DMhnO8uNYYE8REoCxcs7JAQivsmvcuGD35Xx8H5Ue2DgPgVv6bCF/TiJ/TfqkFbql/4euZehG+ssCxuhwK0ycNcU9mRkPj+KyKeyiHXoiKxotV69fjkEAGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pyl0CcVo3uY///PseVrNKwBtHCZzUEIj/JGsvMsJtHQ=;
 b=mQjrm2REZsU4LvxBqVQ3aehAmKeN7gJXOIQg+HOlcgHzLuBpSBE1YZZ5qjUawBDg8ITYGc4Xm693aKoCHNgQZ56F4Z4GLiVvzoCHM++IO9RpJK01G/jSlzkIhyoT9+czGNCCXmKs5SCXh7nfhDSKC4lCYojVTSfxNt6mMaaklE/+9oYfSNBCoT5QoqKC2MEOM8eH/Uz1vvZT1ZGIuuqLVDOQl+fzZkydMWEmkKVsCvXoijAOZUmPU6kstsNNM60YLnmlSS5xwjsFzVMck7dVr4BAX2pSCkFem+CqoNz17u17LWSiCwIVbJukQQfBT3CrhSXmdEIPPurPt3FvDFYjrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyl0CcVo3uY///PseVrNKwBtHCZzUEIj/JGsvMsJtHQ=;
 b=ahLePetiAiRGwk9nawN7das6gV+TFX0VyOX/06DCglCx78sNC5ETNEOFUEVNfvneVR+9U5V5nav5B/CYgCN813kUyZOzGFMtf2Xi6Jj5RR9pF1SUedkVNOfviFull79dvsVeg7/cE0LGat7o87ooESt+OIOdV8BxpavZgEIW1QE=
Received: from MW4PR04CA0230.namprd04.prod.outlook.com (2603:10b6:303:87::25)
 by BN9PR12MB5384.namprd12.prod.outlook.com (2603:10b6:408:105::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 09:51:50 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::90) by MW4PR04CA0230.outlook.office365.com
 (2603:10b6:303:87::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Tue, 30 May 2023 09:51:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.21 via Frontend Transport; Tue, 30 May 2023 09:51:49 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 30 May
 2023 04:51:48 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 30 May
 2023 02:51:48 -0700
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 30 May 2023 04:51:44 -0500
From: Pranavi Somisetty <pranavi.somisetty@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <nicolas.ferre@microchip.com>,
	<claudiu.beznea@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <pranavi.somisetty@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>
Subject: [PATCH net-next v3 1/2] dt-bindings: net: cdns,macb: Add rx-watermark property
Date: Tue, 30 May 2023 03:51:37 -0600
Message-ID: <20230530095138.1302-2-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230530095138.1302-1-pranavi.somisetty@amd.com>
References: <20230530095138.1302-1-pranavi.somisetty@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT065:EE_|BN9PR12MB5384:EE_
X-MS-Office365-Filtering-Correlation-Id: abb0f8f1-39b7-4a5c-7e7f-08db60f37d2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KDTsoS6IHsRdolWpulz2hVIgt7Z8DDDpOB+iZbehETZREIlzHh3HiyyO23HXuAD7rlVbZQ+UMwQ+pEbEuNKZ2cMPUN9g198nHls+yUzdcWChSzDSDUZOLkuy5j9OvEAXphvUST51qeczFmObA1alGyUxMEKZe10hd8cvzGfdrIU3CeB/DVFo40G7U/m8lotwtoiglugzTf/uANBjPmmILypj1X03uSNnfCCuSuFf9nZiibbKZeYzskwx9nPjokwomebVg5HPg/7KAShaGe6/wbsF9dT3sRduuZlWNKUNHBkmOJdZxo6vBY7ovc/ZZW/ZVxv6SJ8J+Dmv3JfmhQVpxBvN8xguUNxg2sgrxlvuZ+pXOSAkFu55ZDdfuNPgQjCKo+HekGcCKnGHt9YFj9YHEZB0s519GakKcVWA918GDde0V+0mrAqZrUISyEMgUi31mM1uzjm6OrQTKjndo5kw6vVrRRy4xBuJzir3wrKINs6j/qvGoIu86/gagTUViQowDt8pVyucyvRQXzGk1y6Dqu+YvjEaouLyZJ/xZleb58g8BN/ojTjvAkxmyG0kOG9ZL8YUQVLH9TTdQZVokKgc2e3pzL388QD+tfg3BaeUG00Sa96ZoDQrlswyfCe9Jlz1POpD3NhgBNsN7yz+uL1wJvaTHX2X8dBH8ByS4rr0qZGpU58CG2vB00q44am2RbT5N7C+6e++wDGrJpHJ3f00wovob32YgD8N8JfPlni6PLNV7My2G+3eFpoZINIwxd5EvRiOTuo1ZOLeKIUsiAYCbg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199021)(46966006)(40470700004)(36840700001)(186003)(2906002)(2616005)(54906003)(110136005)(426003)(478600001)(336012)(1076003)(26005)(44832011)(47076005)(83380400001)(40460700003)(36860700001)(41300700001)(356005)(81166007)(8676002)(82740400003)(8936002)(40480700001)(70586007)(5660300002)(70206006)(316002)(6666004)(82310400005)(36756003)(7416002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 09:51:49.4947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abb0f8f1-39b7-4a5c-7e7f-08db60f37d2d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5384
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
--- 
 Documentation/devicetree/bindings/net/cdns,macb.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index bef5e0f895be..2c733c061dce 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -109,6 +109,14 @@ properties:
   power-domains:
     maxItems: 1
 
+  cdns,rx-watermark:
+    $ref: /schemas/types.yaml#/definitions/uint16
+    description:
+      Set watermark value for pbuf_rxcutthru reg and enable
+      rx partial store and forward. Watermark value here
+      corresponds to number of SRAM locations. The width of SRAM is
+      system dependent and can be 4,8 or 16 bytes.
+
   '#address-cells':
     const: 1
 
@@ -166,6 +174,7 @@ examples:
             compatible = "cdns,macb";
             reg = <0xfffc4000 0x4000>;
             interrupts = <21>;
+            cdns,rx-watermark = /bits/ 16 <0x44>;
             phy-mode = "rmii";
             local-mac-address = [3a 0e 03 04 05 06];
             clock-names = "pclk", "hclk", "tx_clk";
-- 
2.36.1


