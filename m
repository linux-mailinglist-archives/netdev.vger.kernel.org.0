Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8129D31D2BA
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhBPWfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:35:30 -0500
Received: from mail-eopbgr100121.outbound.protection.outlook.com ([40.107.10.121]:3010
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230332AbhBPWf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:35:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrxSxw8BgKHr/oo4/6gRX7j0H+3iHfjvOdLSls+JLcKG4xdL5SZamUzDqSiFFWcpyP6Q9xkT4nhlbkaiMZA62Tdd1EWMlX6WvGv9ABWXAA1AZyNL+eZZbQNSPkbixzAvcUZh+Ut+cpZvdi6rKTD9Dxt/v62YT25HJVaUl3pHzQDH8ramYEPLouiPiQkmqdUJZ9olZHhBA1G7BjVg7lLJel3IDBO2J3PLvr4ojgSoA4dLVCy28JNEEW/RsmnwbFIg3CbCY6xkxc99wwz7cCILC9ScvDw2F+AmlyiHbv+u2c2u/HX9TBq+DTEjSRyqfREbf5Tv65GYiZKcqEBk/Zbq8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqBVXNnuNXFjxKQtPxq+L5erj25/eXcAoJ45iba1INo=;
 b=QoBx/tT+aPBihA7eikhhmrJEhxEc8Yu9LSsrV25/LkaSW5cv0+2j1+USg6zpRlbboEZ2e5aM/xWN3x48UnnUyUWujkiSgI+/bX3tk+rAIX2p0pCI5fNGnOAlvwLIPIXRh8l3z+XGDRW55iNJyVBWB370fngjC7oucuqH+2m50kkYSml6jsGspsyE8h6N2BexuU66MUJ/CS2V71ECAR39HYeMUeu8OuOVmFJWOLALoLADiHXa1fZW0JMMotQmBXQDTXQa8uxa+YwE/HnElb/97bB2aDTQ7sziq5VuMBYP2Ul0zUNg0+KsAMJTIZFYu5PCpHc6f0W2h586UMd9j6L6xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqBVXNnuNXFjxKQtPxq+L5erj25/eXcAoJ45iba1INo=;
 b=tUdj56wFwEXhg9iXhnuRj6xdwxVPldwE2b2rYND88w2p9eZ4oh6bQsUg4ggMFvym3rTqxOWUwwuDvfdvUbgs9hQsMulCsFvZQZ1MFe+o+dElNczkMioKDuBXpYMgJrahmK0xudovkaG/DQN417jqWyy0hav0RRiaGEFbNzK+D3M=
Authentication-Results: garyguo.net; dkim=none (message not signed)
 header.d=none;garyguo.net; dmarc=none action=none header.from=garyguo.net;
Received: from CWXP265MB0744.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:d::23) by
 CWXP265MB1829.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:35::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.36; Tue, 16 Feb 2021 22:34:37 +0000
Received: from CWXP265MB0744.GBRP265.PROD.OUTLOOK.COM
 ([fe80::d4fe:4dc4:65f1:b066]) by CWXP265MB0744.GBRP265.PROD.OUTLOOK.COM
 ([fe80::d4fe:4dc4:65f1:b066%7]) with mapi id 15.20.3825.039; Tue, 16 Feb 2021
 22:34:37 +0000
From:   Gary Guo <gary@garyguo.net>
Cc:     Gary Guo <gary@garyguo.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: net: xilinx_emaclite: remove arch limitation
Date:   Tue, 16 Feb 2021 22:33:42 +0000
Message-Id: <20210216223346.4198-1-gary@garyguo.net>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2.99.171.246]
X-ClientProxiedBy: LO2P265CA0121.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::13) To CWXP265MB0744.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:401:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Gary-PC.localdomain (2.99.171.246) by LO2P265CA0121.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.35 via Frontend Transport; Tue, 16 Feb 2021 22:34:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a4786ef-cba7-4898-6e26-08d8d2cb0b00
X-MS-TrafficTypeDiagnostic: CWXP265MB1829:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CWXP265MB18298946A00C6D861F0DF4C4D6879@CWXP265MB1829.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mhqVMTXzL7elbPUS9hVBh0bHoXBmkLRckdtTbcSvjHfV2OHWyDJ//And+C35ZwSDaA+VILBtAl2q0mlxxmKsUO1X0VKwxkE4UV4w1jNWo+MLx2NqIB7vPOBGe8l7PI0w6bJj3W42SNONK8d/YMlwaW1BMDc4Z8PfnjR6mJSV0sl9hjxy/7lH/k7Hu4uQIVCZvYuVLVnJF2QjxbZl1Nr3kvuLNhvFewteM+x4YlVjrRHAXc6ho2ZJVYB6qSBuYWTf0pc//3z3HYnN/Ffq7A/MD3Oie7I1eaVi3pepD0+IaiqVeEa/2D1BT0HKgD/pdSt3UjjOlvGC9man0ovU2J3/z2ZOGvEuzxjCMt6KQTzDaovKumPkoAdPbzYIWAdkzwM92mTlcoSHvhoe7PPoqNgPVJbngp5EuPMz5jWansVs7PXROlU6Y++b01N8NNe2XEHgcCozBKj7ia8VqBbzhREYZ/lei8mCGvYVL6JbttzsynfO866I4n2d8T1ePCnm+64/eAecdoJZ6OsH1P69wk1LNkgy9ZxOS3RIfiJqzniVXWVkwvrsP7diL0d1FB2FRCTM4f7l/46327pmobE7JdsfQZoZy7hF+1GB/46oHGF9KqA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB0744.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(66476007)(66946007)(66556008)(86362001)(5660300002)(1076003)(8676002)(2616005)(6486002)(956004)(6666004)(36756003)(26005)(55236004)(7416002)(6506007)(186003)(54906003)(508600001)(109986005)(8936002)(4326008)(2906002)(52116002)(16526019)(83380400001)(6512007)(266003)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nNPJyzWemWbVG4McYoqcgscdwLK0a/BSZNAvCCzuZFZ8L6WaBsyAqeQG1eUz?=
 =?us-ascii?Q?MMdA65KGUahtkojFfpuBG67apYw+MTfnBbCT+sbB6E6yFYhYLf+gSh7PtvvY?=
 =?us-ascii?Q?kcd/44pwYN2lj4dpDeAuGFX/4zQNlT5vjePvc+Lv34otmXPzClsIqx7NzwZo?=
 =?us-ascii?Q?evRwA3rA6aCMuqxDifOfvPcjQOkw9uxQBfzp+kGuNW/k/Gmr2ShGWyJ2SruU?=
 =?us-ascii?Q?uewoxNuRVM3qsO7hJ98ZBhQ1Ir9zvsJ1XsLSdBXKFdWf4vKLQtZ28l8YM9dt?=
 =?us-ascii?Q?6EFqVnnAJTOXIGSFJsB427/y7Ph77koMqFrXZJVEGebbIWx36nl5rcKgWQx9?=
 =?us-ascii?Q?cJ+uMr7O/qnwAOfjhp95PQhz2OcI0yn7sN3qKHoXEbby3eEZltkD8/P9tMOB?=
 =?us-ascii?Q?Yz3D4Y7E/3h5evER2vJq7qNqG0NSwSJBiyerLKI8ilmFuJjNDNNnNkyvKcuV?=
 =?us-ascii?Q?PrZh9f/wV48cHjHs8OMq1QOV3VgxX8iaw2UlZVuMifbTmIrV8hpHsOpRPsBA?=
 =?us-ascii?Q?m0HsdG6Tu8lP1wjA5H0VSCrVpe5opVUzSNybSWj41WkWX9N/HnxpSiQNHSjA?=
 =?us-ascii?Q?EInHrUmMgNtK44Dh0ontgGbWYBVGNnblg6mEQ5BHMUkUXc3iPpMkYJRY9Fgz?=
 =?us-ascii?Q?Hs/w0brFKGzL9nK/xWrP1iwTXZVtb3ymVJrVkJ255vwKFXHe4Bo8ap4euI2u?=
 =?us-ascii?Q?O500p2BH2l3WDO0fE1rTiWrJC0ZZrCBqUnTAWqFHJezRRuvMwvLGfMSCbh2C?=
 =?us-ascii?Q?fKTZt7xkUFVagb7zLoKIUm06Nb9kddNBn3jvStplXJUgpht4xygG+gj5d/du?=
 =?us-ascii?Q?fLYtRvccXTZ5cSwlukbZXWSLlE14UIdxEGRneWvaS8wCkpLZWCL6+YeWReby?=
 =?us-ascii?Q?bdDkTnCks93X9a9W5KzmTmDBCvzBVbQWj3Mk8l4bXik2htwgmLH/6+TqSuf9?=
 =?us-ascii?Q?tCBqFuiY+SyEsRSD9qNOHHHwHYXwJqIAQMnmHcEAfy6h1coh7I6HHkrmFN5r?=
 =?us-ascii?Q?V+I1odTHPOsgWT2GO7rkxPbZan1F/g7rWi2iVHkIR/OPc/IsEVm1uj1IByJo?=
 =?us-ascii?Q?XGf+xqahv7G+zJhXobKHfQhWPoydYK9H5LzCWAhppKKdQa3nS5WJp9ihi5up?=
 =?us-ascii?Q?QD0tPFwdon3Ooz3ZYJbyMpr8S1CEgs2bQW7p0uqR4Lk8D3LTLE/2TfPkQC4e?=
 =?us-ascii?Q?khdFS612ofH0BGi+s35OUMSClGbAw2u0299nW6yBPl5U9gDX15UV+BR5JTmr?=
 =?us-ascii?Q?VTOKub5RI2AoXl6eUXFj/K7bSddNbVaJk1iOk48uCbnJ7bp3ZI2fmgg95Nmk?=
 =?us-ascii?Q?cMh5Rnd0f5phGI9HYWQtsDdx?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4786ef-cba7-4898-6e26-08d8d2cb0b00
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB0744.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 22:34:37.9175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kI3inpGIN1dwBX5XamEz2oANbRaUzt1hYmNJGtULOkTONiV35jS6uGiJy1vipPlWWhtXmCZ/QD4U5/PSS8MCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB1829
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The changes made in eccd540 is enough for xilinx_emaclite to run
without problem on 64-bit systems. I have tested it on a Xilinx
FPGA with RV64 softcore. The architecture limitation in Kconfig
seems no longer necessary.

A small change is included to print address with %lx instead of
casting to int and print with %x.

Signed-off-by: Gary Guo <gary@garyguo.net>
---
 drivers/net/ethernet/xilinx/Kconfig           | 1 -
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 3b2137d1f4c6..c6eb7f2368aa 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -18,7 +18,6 @@ if NET_VENDOR_XILINX
 
 config XILINX_EMACLITE
 	tristate "Xilinx 10/100 Ethernet Lite support"
-	depends on PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || COMPILE_TEST
 	select PHYLIB
 	help
 	  This driver supports the 10/100 Ethernet Lite from Xilinx.
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 008b9a40faad..007840d4a807 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1193,8 +1193,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	}
 
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08X mapped to 0x%08lX, irq=%d\n",
-		 (unsigned int __force)ndev->mem_start,
+		 "Xilinx EmacLite at 0x%08lX mapped to 0x%08lX, irq=%d\n",
+		 (unsigned long __force)ndev->mem_start,
 		 (unsigned long __force)lp->base_addr, ndev->irq);
 	return 0;
 
-- 
2.20.1

