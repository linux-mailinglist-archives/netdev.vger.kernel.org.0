Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063B55EF500
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 14:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiI2MNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 08:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiI2MM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 08:12:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64F0B6001;
        Thu, 29 Sep 2022 05:12:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZjUktVCl7MXpARXB9gC9QuIKjqh4oHt4PbYaDRmXjHrLiO7iLLwnv1C4ZdidpmKHyktCTcJbCmX11FHTOK8QBgP71RjF9FIz9lT6T6bgFqc+eypal5i60sRREvN5GXwk/xPo1rr/x4OgdQh1f/5B4IMZoWjmxFQglldOHFe3VcQcfFK4AHCx4M5MRNsEZNYytK0Xfcfj/kOIqCoPjDB+rwC/V7/7D5CSlrTputv+NAOKyIT0OwG6rXWSXAB+xjT4qKwHIpHmndWGVA1tUdx8+Dj8pcco6U6jMVEsEX8Av7lrOAwS8bGOrtuOP9fBCmwLUvnCVYDBkJ9bRc8S1XeAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0xgSxG5xRelKdbSWSnugMAMNWZQzmhPSoALGr9R3Yg=;
 b=iFGIXNLVy+FtjgJWia6xy9wplgoc1lQqnqER+ZmdXQFg1kTJ1GUxcSivOTRIv/jnGlKJZkGV8sHZBmH82amHtwnETB32KAbK+Zj3dn7zPIEOgUjKvCKUExrDAGcVE/B5YnPiiyfdM51RYQtQ8mNvnmRjYatfnT2UsYdvLbyrFLq8YkEJ8JdqqJzqWctBeOazUdHjfS17Ok3u0eo4JsRk+61eZMy98MT+n5ptkiAsQyT9kfyH+oTYquteD2ro/HfJ58JFbZnj9x9LTZFuILxXrBFjJLyl5c0PL3t3Swo+Zhkek9WaWo0lBbvJ/muN5Kj/Jz0Ohachy/omFTBcw4+8kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0xgSxG5xRelKdbSWSnugMAMNWZQzmhPSoALGr9R3Yg=;
 b=jVPOVu7gaAfhFac1qDkpfd1mnyOIvM2GB1iKxQDqrKCZRQwcvNkhliDct6tD3dk40bVHSPBZ0RQRwQ+A7ZhLnzsWLWFXmwr7k+OAukLJLmZqE1jjn0g/nhXdeSkpZwHR8EoyWtIjF8e/DdlnA/I2dS+W+rUpsFtlBb35nc3dTeE=
Received: from DM6PR08CA0007.namprd08.prod.outlook.com (2603:10b6:5:80::20) by
 CH0PR12MB5387.namprd12.prod.outlook.com (2603:10b6:610:d6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Thu, 29 Sep 2022 12:12:55 +0000
Received: from DM6NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::f8) by DM6PR08CA0007.outlook.office365.com
 (2603:10b6:5:80::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24 via Frontend
 Transport; Thu, 29 Sep 2022 12:12:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT110.mail.protection.outlook.com (10.13.173.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Thu, 29 Sep 2022 12:12:55 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 29 Sep
 2022 07:12:54 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 29 Sep
 2022 07:12:54 -0500
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 29 Sep 2022 07:12:50 -0500
From:   Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>
CC:     <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yangbo.lu@nxp.com>, <radhey.shyam.pandey@amd.com>,
        <anirudha.sarangi@amd.com>, <harini.katakam@amd.com>,
        <sarath.babu.naidu.gaddam@amd.com>
Subject: [RFC PATCH] dt-bindings: net: ethernet-controller: Add ptimer_handle
Date:   Thu, 29 Sep 2022 06:12:49 -0600
Message-ID: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT110:EE_|CH0PR12MB5387:EE_
X-MS-Office365-Filtering-Correlation-Id: f3127b5d-6987-4ca3-95b4-08daa213f0c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YoI+jDeULwJz2zVc1haodNXFV8QoxvZcfRaU3YYP13Qq9yNeoWNCvaPN4Zp6BzelTmt1kB4TO0DfRYqHA5cYCOsBdAF7u++Yjp34WsD3Sko+ghHcfeT0R7/HFBZ4lCNom3QaTndY66eYE5thEnui6jrLTavO/yEHwhTT1q/Tpi6eTOmNLJsh3Hb5E4P66zW+DhJYaLjWe96WlwLrkDofzcEsI+ThbfJz9kUTDXS6vD7gNzrV/kGk4un31jYVx1e8K9bByTxzGD74jJCD+4mrXAd/QbzWTcmOaDMNHNALYV2QobnHFjxoCayiU1hmbLaNnCK4L45t+grHrn7OrBITwP/WXV6yz24vSCHN/LLveeWyEVAS+rQWCZjbMBbtWZvQU9JhYmQXr14VF7VJe/6lfkRoCzLFs4sRCYVJPk1BPgt3HelxhfBsG+EgYzNG1jNgURv0pp2YvUwegFdCAryx3r9Vu5+jmC9CftyqTxE+Mfad5TxqeWaVDsdLs4lPK53hH/zQeiX3NWq/agxNCdN2UqJAcu4qpCESAs7GnyCLGl1FgINyxE0hJZdhE4UJWhOc9YkPcg/G6soIHCIJlV0ZcfQjJC2i9uJF33z2ACSuyskxYo3WXbAdgB4AvMU9DUVwYDAB/Fgjs4dAbHu6lggH1Fa5s7m8QDuFRR5fvkvU8LTZsxALjs/E/aWmhqEqfbQCTtHtJHeEE3bbWuZR8p3emE6Pbn8O87yduNya8H/LP9Y+/VCRiuR9SUMK2KsEID6rN2v+MkAgT8uH3EtYhBizL/zUtulqiIR1lUumjQ0s5utpHCw/V/sxLDt3THLPwFUadqrxw8+Gt33CMZvAhVuLcQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(2906002)(36860700001)(966005)(103116003)(54906003)(36756003)(83380400001)(478600001)(82740400003)(316002)(81166007)(8676002)(70586007)(40460700003)(4326008)(70206006)(356005)(41300700001)(82310400005)(86362001)(40480700001)(8936002)(110136005)(7416002)(5660300002)(66899015)(2616005)(186003)(1076003)(426003)(47076005)(336012)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 12:12:55.2539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3127b5d-6987-4ca3-95b4-08daa213f0c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5387
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently no standard property to pass PTP device index
information to ethernet driver when they are independent.

ptimer_handle property will contain phandle to PTP timer node.

Freescale driver currently has this implementation but it will be
good to agree on a generic (optional) property name to link to PTP
phandle to Ethernet node. In future or any current ethernet driver
wants to use this method of reading the PHC index,they can simply use
this generic name and point their own PTP timer node, instead of
creating seperate property names in each ethernet driver DT node.

axiethernet driver uses this method when PTP support is integrated.

Example:
	fman0: fman@1a00000 {
		ptimer-handle = <&ptp_timer0>;
	}

	ptp_timer0: ptp-timer@1afe000 {
		compatible = "fsl,fman-ptp-timer";
		reg = <0x0 0x1afe000 0x0 0x1000>;
	}

Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
We want binding to be reviewed/accepted and then make changes in freescale
binding documentation to use this generic binding.

DT information:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi#n23

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/Documentation/devicetree/bindings/net/fsl-fman.txt#n320

Freescale driver:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
tree/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c#n467

Changes in V2:
1)Added links to reference code snippets.
2)Updated commit msg.

Comments, suggestions and thoughts to have a common name are very welcome...!
---
 .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4b3c590fcebf..7e726d620c6a 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -155,6 +155,11 @@ properties:
       - auto
       - in-band-status
 
+  ptimer_handle:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Specifies a reference to a node representing a IEEE1588 timer.
+
   fixed-link:
     oneOf:
       - $ref: /schemas/types.yaml#/definitions/uint32-array
-- 
2.25.1

