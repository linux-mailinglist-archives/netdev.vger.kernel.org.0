Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C299F57E06F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiGVLEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiGVLD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:03:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713B1BB8F6;
        Fri, 22 Jul 2022 04:03:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yu/DMPyq/gvbUjKS7wd32NGKTdV0yB7xPPep7KxakxgYVPOEM5e0EMJOdgg49c+gWm69uZRSp9MgsIYpGW7/svz7LD3km9dbbEPDvuMb7pCjboWo6muEwJTqsgohMA4sJDEZlaaM+PD9dAOZAYbgz4bT5hmU6zd+LyeIbu4z6I8MeN5VBnunpLKdjebk0DlSbO07ennOmCLK3ko0IVd21hUddb2h1PgbG7RIoKR9qYsFsP6xJxfbe2lscXyNAI22lhXxFO6LPL0b/e/un+xs3v0HCh+pt84yP6d80x1hOTtPCSJX8AMbg1EAy1kX4ALUktZkNEdVoviO8pn8vBiKCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJWdj6oZADibWeuAHVUN7FC7hit+EdIrlJ6sU9QIgn8=;
 b=hdgdZqHsqW8uKv8AAf9ZV8WY5Z+6zKV0nRqDKkmFS9igvwwJjDqcE/IKCq7d7f5dXn7cs6HP2a3hrnZ/Yh5jyafx1ry/XHe/MAFncH75mXu0ioixjCi1LR7FUNWBJW2PL14dO7ZhFPma18mxNSbTZtg21qTDsxZAn0FEzXDx4VCxCvX3ghefB3ZMlqaUafzDpunFNhB7jmkMlBpy9SCYTAqCfu8761cFLWxwzMze0XqvU0HTlnqaZ6eFV3pndBSw4AmnsGNIXwXanFgo+ZDp4jCaEddxuzGUl84l/G503ffw+8O3/p+mWmTcztUegaNrih36mazgOneOMx7O6Ks/PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJWdj6oZADibWeuAHVUN7FC7hit+EdIrlJ6sU9QIgn8=;
 b=lBugCoAykqGVELEWX1zb8htipkqXSSK4U2qrHwi7sWbKBTDxNSdBEFdEInWjkt8rq19ScatsXBcmTWu8vbuP65hKVs/80VNdw/AFbfoFixE1skGWRzkGsBWOzJ/8avZwdfIPXJdMGYA3sHSGcDfTicVXjk/4solLkK7d+u4fnJU=
Received: from SN4PR0501CA0026.namprd05.prod.outlook.com
 (2603:10b6:803:40::39) by BL0PR02MB5682.namprd02.prod.outlook.com
 (2603:10b6:208:83::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 11:03:55 +0000
Received: from SN1NAM02FT0058.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:40:cafe::a) by SN4PR0501CA0026.outlook.office365.com
 (2603:10b6:803:40::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1 via Frontend
 Transport; Fri, 22 Jul 2022 11:03:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0058.mail.protection.outlook.com (10.97.5.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 11:03:54 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Jul 2022 04:03:44 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Jul 2022 04:03:44 -0700
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
 harini.katakam@amd.com,
 devicetree@vger.kernel.org
Received: from [10.140.6.13] (port=33588 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oEqRb-0001lP-I8; Fri, 22 Jul 2022 04:03:43 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <harini.katakam@amd.com>,
        <devicetree@vger.kernel.org>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2 2/3] net: macb: Sort CAPS flags by bit positions
Date:   Fri, 22 Jul 2022 16:33:29 +0530
Message-ID: <20220722110330.13257-3-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220722110330.13257-1-harini.katakam@xilinx.com>
References: <20220722110330.13257-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b54c97eb-6b84-48a3-13d9-08da6bd1de2e
X-MS-TrafficTypeDiagnostic: BL0PR02MB5682:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +B96CFqKsJ2GrfvwP1i8Lw4QE6ASUWOdspxIAqt/O6Upzuz8/JPx9aGZQdlTDBMiuLKOzZhMKcmQNnLzLXhsPcjkD3ulAi+xNcW40f5WwIwfI3KB5FEKs2BbuAKa8+mOs7NluWGbKHHeshTls0xYhDg5zisicg/9GR1HAyGYQHMbwTYndOsnXDX5atCkDiS38ylTivchHKfFwlNbMOJ8r5UbTMDi4lcqX0s0+9nHD5qRGaqvDsYrxMimGGnub+VYRW01ZZWEoIhul1zFQwxbeEl1ZylM1fUidG4uvBCsFx6MZ7N876OqrEIu2pLXS5rdUxl4B02mdJK+yQA1/BLCzBrLleRCo3yRyY7kzAf4QITn8tjYjR2CLeLgrW59Xg2JLCB3TF2jgiuiPFBKmYCUb9mye8dXLIl+BljmTMOUFSlM8RRjZ5Yj/EUGbcRtyQU+qWemjXCJXNXd/6AjqSI6TDyGBmodOt//3gDpRycnaU1uxLsl7WOl7NqJVVyn50CGNMC1fmP1bzSs3JjXzfhmVWUWaYCgC9Xra2bO1YgneQc3pEfVJb2GN9a6uWFkF8SdxicZw+A5fIFlpexyJnhZdj3K9FXPh5U422vpcfEdMlkdCIPMqItd/NeV/LYekbzTj9qOzfIwtPl0dgh5ke8v1/cNULhPlxv8EY6yms+2KGSL5dq908Veyfw2ZDVnSbi8PhXBeoEFiNpvxcMF3vL+nhvEDKXT6IDeLVb52IM4GDJ3QW/oq4JGT2pHVWIf55yfHuKDY/L56ZZi1akc5AGnFFX84rKaaEtaihZiRRclnJ5Gy9HvzAQgrwZDPKYET9dnN+o5WT3l46yWl+ytscTaQA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(346002)(36840700001)(46966006)(40470700004)(1076003)(47076005)(26005)(186003)(336012)(2906002)(107886003)(2616005)(6666004)(7696005)(426003)(7636003)(82740400003)(356005)(40480700001)(83380400001)(36860700001)(41300700001)(316002)(70586007)(54906003)(110136005)(70206006)(478600001)(44832011)(4326008)(82310400005)(7416002)(8936002)(40460700003)(36756003)(8676002)(5660300002)(9786002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 11:03:54.5463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b54c97eb-6b84-48a3-13d9-08da6bd1de2e
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0058.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB5682
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sort capability flags by the bit position set.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
v2:
New patch to sort existing CAPS flags' bit order.

 drivers/net/ethernet/cadence/macb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 7ca077b65eaa..583e860fdca8 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -717,14 +717,14 @@
 #define MACB_CAPS_BD_RD_PREFETCH		0x00000080
 #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
 #define MACB_CAPS_MIIONRGMII			0x00000200
+#define MACB_CAPS_PCS				0x01000000
+#define MACB_CAPS_HIGH_SPEED			0x02000000
 #define MACB_CAPS_CLK_HW_CHG			0x04000000
 #define MACB_CAPS_MACB_IS_EMAC			0x08000000
 #define MACB_CAPS_FIFO_MODE			0x10000000
 #define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
 #define MACB_CAPS_SG_DISABLED			0x40000000
 #define MACB_CAPS_MACB_IS_GEM			0x80000000
-#define MACB_CAPS_PCS				0x01000000
-#define MACB_CAPS_HIGH_SPEED			0x02000000
 
 /* LSO settings */
 #define MACB_LSO_UFO_ENABLE			0x01
-- 
2.17.1

