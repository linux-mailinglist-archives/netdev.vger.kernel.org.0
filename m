Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605E96CA213
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 13:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjC0LG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 07:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjC0LGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 07:06:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBFF468E;
        Mon, 27 Mar 2023 04:06:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca7Uqam4WVgjArgeV3TaTjiSa42xxi/8A4YUatFjqZvy65Cj6ZlYQCjX1vrVaqFgBnbBcK/UfCgsEvzd8Z9QBATAgwT5fLppUoQr/fAQdL7YTeac0ee3zbceql6VRaJp5YUpp7lLBWi33/c0wEo4EKRc+y9cHw1OIUrjB/sfQFCJtqaqWnC6Ak1L9xNIYvcwQNRRfUH7RZ7ZtfjJejD0vXg276x/zxftd18kCiakuYkFG/UmsGVXTOpkTfn3d/9DZpctKvkzOdKa8jPmwuyeXy9GaYyORlF5gnrbmW4QjXO8g5jQaC1eg5CJl2iNfCxYF4R6nO75FzBlOu1zF5ClvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Spn8Pi1i4yafXE9SaGQap1MRbPwCW9izTJUcHEd7LXY=;
 b=mXevP6NeQxZ1CTQ+oL7Y8XnI+xHs1n3nQrtv3VOdv71Y59NaiQgMVMV+ceJuPb931rp1VG5URJY9eK2dPXYDAxer88H9vpaCiNuGhiT826ml13Ym4Y6GrQkAq5p+k5hKdkFmnIq2X3wcIoGixyKUyeG14mXje5reVLIV7zGX9Jx1LhzYqTx6DjMjmnNVi9z0YHbr8Hgt08g68b8jpdUBPFatqWL4v7Xa+8tgANZKlu47dbUHdtbheFggDFfAtwFkleV5VX3TCBd7dCLbykq2qq/Kh7W5Wyrn9gFe/c4niL3L8M+cjsNVUhj/QcLmVcLbg1BsN3QxykblUtUr3BfFfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Spn8Pi1i4yafXE9SaGQap1MRbPwCW9izTJUcHEd7LXY=;
 b=Xm9St+q1z971fTfqCifzDL/1/9ys3YHdtOPltW12siQFvGKwi7tcGT4msPdLWjUXeJKO5FHr1rqsL/7Yc191V7A5VdLkoJtKJQoU+EugTCYPwsaDPSta9MXsmRjagyvnUbodUDr9aV9TJ1MrU/QVUzdol26cJmKPMRRFuALf6uE=
Received: from BN8PR03CA0033.namprd03.prod.outlook.com (2603:10b6:408:94::46)
 by DS0PR12MB8480.namprd12.prod.outlook.com (2603:10b6:8:159::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 11:06:20 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::81) by BN8PR03CA0033.outlook.office365.com
 (2603:10b6:408:94::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 11:06:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Mon, 27 Mar 2023 11:06:19 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 06:06:15 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 06:06:12 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v3 1/3] net: macb: Update gem PTP support check
Date:   Mon, 27 Mar 2023 16:36:05 +0530
Message-ID: <20230327110607.21964-2-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327110607.21964-1-harini.katakam@amd.com>
References: <20230327110607.21964-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|DS0PR12MB8480:EE_
X-MS-Office365-Filtering-Correlation-Id: b5f1dc5d-7f66-4137-9b1c-08db2eb34b24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TAQIxwf3xz668imLXIKW6jUbi+dD+Uf1LGqDm3Bs35MdysjG27g55GI/CkwST0WwCats2Gt1CJVbOw8ZOMWxJuIZWa8Dnr5qMOjYb2J3be6F/d4UW8Zpyp2hDlLLsOiAK8lYLBmYOYRLy2G3XQ0BClk8U0CIM24sN8ugJPw1SDGB9ZQ4ygwkbF7rA8z9fRHCmPwvI4uAhEX3WvhK0oJm0rVmc/iLYlVnl/FP5rg8ri9AulO2JWQs1tGa5N7tzd1ZiujydrXcPFGSAjNaiISnRT/wAXMZ1NhRoCw+K4R39gtyqysK/1FFOMb8+NvpfQ79IBE1RuPCHbP5BcKXwrviApf1M2v+sni9ysYJNCVP+ipsm2Q8WVFezXdP6vX0n6op05FX+kxvmrxLP8wZEWxtDZe/UJC485dr1I4aMY2FRbaljNt6+XZROewshApIwTGtNQ5JrDkjidZLpVAwa9BEcSoG7xeHVZzfQCZ7LhsJykfTu9y52HFQ/bvw6OgFlCHIUMMAUm2IBnnV1+X0/7AF+lcmo2UoewVT2hwzUW7CXKuOQKOMH2U1KzES0e74uuxNMIuHuF+0ssM9aAE652WBhNHhtrRH+rjVL1ZT21ZDQi6ZuGfYYz0FzFF5dro44LGSttO/AFpx2zEWqJ6Yry7T223xBOW7k7hhDzvNrYDFdKN7d4xQ6Zt4kuMV1lsTuDJkeaJrQYcO2sRwj9ueW8jKD9DxRp9i2ellB3TT0q7Ug8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199021)(46966006)(36840700001)(40470700004)(356005)(81166007)(7416002)(8936002)(5660300002)(82310400005)(186003)(1076003)(36756003)(26005)(2616005)(2906002)(40480700001)(6666004)(47076005)(86362001)(36860700001)(83380400001)(426003)(336012)(44832011)(40460700003)(82740400003)(4326008)(8676002)(54906003)(70586007)(70206006)(41300700001)(478600001)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 11:06:19.6052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f1dc5d-7f66-4137-9b1c-08db2eb34b24
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8480
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently two checks for PTP functionality - one on GEM
capability and another on the kernel config option. Combine them
into a single function as there's no use case where gem_has_ptp is
TRUE and MACB_USE_HWSTAMP is false.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
---
v3:
New patch

 drivers/net/ethernet/cadence/macb.h      | 2 +-
 drivers/net/ethernet/cadence/macb_main.c | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index c1fc91c97cee..b6c5ecbd572c 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1363,7 +1363,7 @@ static inline bool macb_is_gem(struct macb *bp)
 
 static inline bool gem_has_ptp(struct macb *bp)
 {
-	return !!(bp->caps & MACB_CAPS_GEM_HAS_PTP);
+	return (IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) && (!!(bp->caps & MACB_CAPS_GEM_HAS_PTP)));
 }
 
 /**
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f77bd1223c8f..bcda6a08706f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3889,7 +3889,6 @@ static void macb_configure_caps(struct macb *bp,
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
-#ifdef CONFIG_MACB_USE_HWSTAMP
 		if (gem_has_ptp(bp)) {
 			if (!GEM_BFEXT(TSU, gem_readl(bp, DCFG5)))
 				dev_err(&bp->pdev->dev,
@@ -3899,7 +3898,6 @@ static void macb_configure_caps(struct macb *bp,
 				bp->ptp_info = &gem_ptp_info;
 			}
 		}
-#endif
 	}
 
 	dev_dbg(&bp->pdev->dev, "Cadence caps 0x%08x\n", bp->caps);
-- 
2.17.1

