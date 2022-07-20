Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC27A57B57D
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241005AbiGTLaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240939AbiGTL3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:29:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956996F7C7;
        Wed, 20 Jul 2022 04:29:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6ikJquNSNpRwTAAw8z3gpTFQ++4CNtAYh9HBRwTvHZUygOFOmuVxS0UgbC8HGY9eAV2uKJM47B8U3BP0RirO/KdjRjUFu0U4Zf48V5Sr6KzKFL4tJDvkPn5czFiyNNPrJ7dBmCqTzkV1GABn6Td6NmmMTdagWv7mNLkV7/jTRhTWLRtXrnkQAHJlO1pNHinE6aSY3ZDU5SjOWLR5lxknTN+Qy48CRrU680YuIxrRVuOqivMlaLi30ENcs22eyr6630n1+sOGIlaNVTNtto6wGaJ0XhJSaiSpWD2RJvDGQy8cnYDU9dBM1QgHI0IEGe7IKPjkbX1hlxgOHbapcgtnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+e3/w20L9NCIu9gozG8xUe3oLHIvdUvwWRy8fKiaYM=;
 b=auGsOLI1N24YSMNBFJvSTXdb2976RnhMJGdSy08gNHuWaLAtdN5kjbZknIguKSR+DuXyK0Mdiu3Ymki5e/IwX/mPbW+tQ+79X55aOfIeIuI/9fmn5edLmY1+SMvb4g4/FLNdatm5gQdMvyCtFR7DS24zHIKABiZ1WHcfLGGGuKpnmefklIaUwBuGnP5NIRGPW+7dHGwTWZnVS/AuU8NiPST1rxRO75fZnfzZMbaeJLDDY1T+IjIrKhkORsKhSMb4UngPZBkWprQo6a1dLmU8oGNQBaRkOmt58PKTJMCooCPB2WSoPPtK++zXZiymfIfZO7oJn3XpYxCfAlOpPpqA2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+e3/w20L9NCIu9gozG8xUe3oLHIvdUvwWRy8fKiaYM=;
 b=k+amWdlwiT24SH+ezPKShPAS4dy0R/Spl0Tvs1CiXYz3rz/gaQ46s/im03XnZB24PJbpTc3R/lIJ6+6BMe+3LaY/vfBHd+nWqkD7G9gKcCW1DT5HJBEdWpwv5zmBGYYuLnsqwf+7R4isc6817YnBMMprw5PqXZptAzJIP8twsJs=
Received: from BN9PR03CA0587.namprd03.prod.outlook.com (2603:10b6:408:10d::22)
 by DM6PR02MB4714.namprd02.prod.outlook.com (2603:10b6:5:1a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 20 Jul
 2022 11:29:34 +0000
Received: from BN1NAM02FT024.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::98) by BN9PR03CA0587.outlook.office365.com
 (2603:10b6:408:10d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19 via Frontend
 Transport; Wed, 20 Jul 2022 11:29:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT024.mail.protection.outlook.com (10.13.2.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 11:29:34 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 20 Jul 2022 04:29:33 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 20 Jul 2022 04:29:33 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 devicetree@vger.kernel.org
Received: from [10.140.6.13] (port=60628 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oE7tU-0006pR-TH; Wed, 20 Jul 2022 04:29:33 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <devicetree@vger.kernel.org>,
        <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 1/2] dt-bindings: net: cdns,macb: Add versal compatible string
Date:   Wed, 20 Jul 2022 16:59:23 +0530
Message-ID: <20220720112924.1096-2-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220720112924.1096-1-harini.katakam@xilinx.com>
References: <20220720112924.1096-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09680e9a-42e9-4c44-478c-08da6a431f16
X-MS-TrafficTypeDiagnostic: DM6PR02MB4714:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cLa71g4q1H5j+TwOHbzyr4YvzVWndIAzgg5QpiiPnkK3XhRkiYa/nTNMwiO21yFJSSd07IXneFYVn4p1shb5IGWhws4LOTuLUE5T6koMLQ2sdneYpr/HEHYUicWnFkbzCmAMvCe6WG3qrCBZuy8n5wAM48kfVCiMd5inBNkzYFJRWRhROV6AG8eIxMnTCIcm4KtM6yFDd8XqQsqcfvypeqxDO4eukw64JR5l/IH6SeYf53egjB+mU5HC8yIYTIW3SYtgw9waShJrtKvwCLIPFPlzAIQzlJQ68FvMLB/ZKku1q3TT2lCezSiELqbWRbz8p8vu4Yzr62axFimdfLxfuYTQaLjpQDklEdL01aZPXC122Lqu3Twuq+bmP+SuJa/OlPqTm3qB/g+ttXwB76YN4oTfc7Z24vW/ukXnAnef7Ua8mOWOd7Z6r0fzmI3/lPe8kxaDU3uTlhSF5kPPBiH+YgAjGfByP5NlW1whPDfgFgYNFvvyWVV6t5FqlyLN9wtJQqxj0dbtawocTTkQhp7a3OQLq+dl5coirCCWyFvK2sZmOt7Wvn5okiUWzuNNeYPQbgmxa3TNyFm0vdKjBUY5vFb6FAVYb8Humto9K045NcM05f4bTm8hrBSHXYW7fAm7Tenxy97LxQtLWMhSM7A2Aj5LXOFjr7SeEUbIxWFBCRiKclBrLtU0/G1W35VY6hTGZVAfOANeBhBWkVDARNzQH86SiEdKGHM73RCaytqvbgzrJs+h0kv0SfN+w6z5zVypmnMrAFb26S4ikCCt5jV+WAhkfAoKS4XhlaRDJ+t0VyHb3E8GCQdpp+72iIhYgle4wUgVEJkhgGexu2R1OuHeLg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(136003)(39860400002)(46966006)(36840700001)(40470700004)(82310400005)(336012)(47076005)(186003)(426003)(54906003)(110136005)(7636003)(316002)(40460700003)(356005)(82740400003)(2616005)(1076003)(70586007)(70206006)(107886003)(4326008)(8676002)(478600001)(40480700001)(36860700001)(26005)(6666004)(7696005)(41300700001)(44832011)(5660300002)(9786002)(8936002)(36756003)(7416002)(4744005)(2906002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 11:29:34.1690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09680e9a-42e9-4c44-478c-08da6a431f16
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT024.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4714
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Add versal compatible string.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
 Documentation/devicetree/bindings/net/cdns,macb.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 9c92156869b2..1e9f49bb8249 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -22,6 +22,7 @@ properties:
           - enum:
               - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
               - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
+              - cdns,versal-gem       # Xilinx Versal
           - const: cdns,gem           # Generic
 
       - items:
-- 
2.17.1

