Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6521C4A5797
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbiBAHQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:16:34 -0500
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:65217
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234590AbiBAHQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 02:16:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIcpc0KrMVcCOlerM1rYvgEfnCDe19Tb/VS3yhVtBnvxZM3+PeQxYEl9XNQ02yfWSXSyKSwdpxBiQXyocGtv2QvL65RCsTI2+5dxu/lqBzPhN7Vsu/QRFsfQzPRxn7IlCNPoLD5MxK8sZnHNnO/s9OLrG1ERnQ5zhMyLTdKBc1lqscVDTgyQpueZNowKGdwHcuDh63E/7hpHl5gdnvZ3xgMEC/cUCLAs/2C3pjYgoNFbjRdxrlcuwyiOStecSzEJfdPzljKjNci+9Sm2Z/OBxv3Jvt04beGmWMNROCNJtpBimHRTpakqxX7GLjqel9aH8M9+FZPgPABZF9zgykd7uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6nKj64t+rKGP9Ks+0eihHBka4tTvMidteY7PgV051M=;
 b=CQDy5HvInQ+PvIeWYi7knu0W0UhgH8X8x7f516EIYcw6KUAK+8QEyqy/c5Wo9C2WYKdFlBKrWa2W9heC6Q/ygMkpdkXsCTn8zJKCLbcwtWd79L67eAd77XGzD7e7DDCXpWFHk8+TAIIi4MwFo0RwVI2K5N9gHjxpY7RbVW5rdYqA+Iv7lVrYQuGmc+EHEnn5ofHgGnQqlHfacDruUvnpN+iHmMygyx1nf6LDL/0Y0SGtyslJ10gFO6tK2K/0knQkP4R6+owGyP8iglikkdpiKboAT9Cv9RXmQKOeHqxiWXku3jVzNeiX6oR0XvtWOwTjh5W+DHxUHYvJPzzGk6pIiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.70) smtp.rcpttodomain=kernel.org smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6nKj64t+rKGP9Ks+0eihHBka4tTvMidteY7PgV051M=;
 b=pirbHiL1RB2AHgovVE0prj/5/uZ8uxeywMW7DK1M9nB3y/3cZd/J0z+oQ2DKxToJDbjET/42/mfM2tBteIr1CsuNG3a5v88LmMYvXmREpLEkkoOTr34WuLnGU/VH/JOhpjK65cWkGjsb/bW3XZ8fpfHIGQpVuK9w/OWHvjOQEnyrO1DGJI+/PtVkxH/cklcIBC2IUH1TCSiMwDVQCZ4NW9KQX52hy8l/bnIdYx9G41roDuD4+re8IlZpm1dMJW6dzeF+dIfheh1kPSWKYZ0zURMr5ZRJ/anvwa78e25gzMkzKFk86doONj4Dfrnbu2joqDCDOJUcZAqFHkKwL7ma6g==
Received: from AS8PR05CA0020.eurprd05.prod.outlook.com (2603:10a6:20b:311::25)
 by DB7PR10MB2187.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:4f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Tue, 1 Feb
 2022 07:16:30 +0000
Received: from VE1EUR01FT018.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:20b:311:cafe::cf) by AS8PR05CA0020.outlook.office365.com
 (2603:10a6:20b:311::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22 via Frontend
 Transport; Tue, 1 Feb 2022 07:16:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.70)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.70 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.70; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.70) by
 VE1EUR01FT018.mail.protection.outlook.com (10.152.2.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Tue, 1 Feb 2022 07:16:30 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SJA.ad011.siemens.net (194.138.21.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 1 Feb 2022 08:16:29 +0100
Received: from md1q0hnc.ad001.siemens.net (167.87.32.84) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 08:16:29 +0100
From:   Jan Kiszka <jan.kiszka@siemens.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Georgi Valkov <gvalkov@abv.bg>
CC:     linux-usb <linux-usb@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable @ vger . kernel . org" <stable@vger.kernel.org>,
        Yves-Alexis Perez <corsac@corsac.net>
Subject: [PATCH v2 1/1] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Date:   Tue, 1 Feb 2022 08:16:18 +0100
Message-ID: <24851bd2769434a5fc24730dce8e8a984c5a4505.1643699778.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643699778.git.jan.kiszka@siemens.com>
References: <cover.1643699778.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [167.87.32.84]
X-ClientProxiedBy: DEMCHDC89XA.ad011.siemens.net (139.25.226.103) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a10c0781-9420-4f61-4cf7-08d9e552c4eb
X-MS-TrafficTypeDiagnostic: DB7PR10MB2187:EE_
X-Microsoft-Antispam-PRVS: <DB7PR10MB21871FC5ED117AA99AAF804195269@DB7PR10MB2187.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQae3n8ePmi8YPjQnlMoEjUr147hYvs1V2fyvDtiAwBN3850lDIpr0F23rjCNz4WCdv9sdoOlJXvdxGLmqtWBHzxADcb3axdUipi6veI81x4vEqaVDM9756ZimCGH0k6LmpOFTZFdbXClQOxUPpHWDJMuXqvsPJ9qe4dGnBAtsOUajRawvKjNXP3OqsUZPek49J3LmiXm4Gyke29Eh0VCFmj6zteAfUxRl7vKq2HijV1hh7mn3mlHxExoaqy4+hdaBzAwiYD4NWRXveYyJHPtORZphK1zl/PZFt1Ej5fxbYdsLEtzeOM5LyIx3+EuXmNUAQUeEcj8JKA+rzIZr0AnmReXxBP0RskwaWOHjHUZrypl5aUpyhOx7Zr5uYWyiAoaBFcYTAaZIn9fpfA7IwbiGcjdtzsIGuMTaYutUh9UCKxj8B1QtSXFxAZe+bLU6sX60KqNysmXSDY2dKK5Ra7Bt4BOAVikTcBx0xZEDmFa2AFFhAAacLCFVedQNJOcycgKIqn1cIk28mAEuSqGzwBVpLOShNXxs8gXqI5RypR4OYSpIwHFl+WgQ+i7rrTD56xQv6yabaAGw9LTOa1FziOuqCTczOKX2XVvIPSYByufODL4k1AMuVcD2bMXsoNrJNJQ0I2aZ32P3DdTT+ZbKhlBGRJzUhdSiXJ6GpgAmi08jB6ZtnWdhcy15Wcke2ZakFU
X-Forefront-Antispam-Report: CIP:194.138.21.70;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:hybrid.siemens.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(5660300002)(2616005)(956004)(356005)(44832011)(82960400001)(8676002)(7596003)(498600001)(36756003)(110136005)(54906003)(40460700003)(8936002)(4326008)(70206006)(70586007)(7636003)(16526019)(186003)(26005)(47076005)(6666004)(82310400004)(2906002)(86362001)(336012)(83380400001)(36860700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 07:16:30.2844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a10c0781-9420-4f61-4cf7-08d9e552c4eb
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.70];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT018.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR10MB2187
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Georgi Valkov <gvalkov@abv.bg>

When rx_buf is allocated we need to account for IPHETH_IP_ALIGN,
which reduces the usable size by 2 bytes. Otherwise we have 1512
bytes usable instead of 1514, and if we receive more than 1512
bytes, ipheth_rcvbulk_callback is called with status -EOVERFLOW,
after which the driver malfunctiones and all communication stops.

Resolves ipheth 2-1:4.2: ipheth_rcvbulk_callback: urb status: -75

Fixes: f33d9e2b48a3 ("usbnet: ipheth: fix connectivity with iOS 14")
Signed-off-by: Georgi Valkov <gvalkov@abv.bg>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/net/usb/ipheth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index cd33955df0b6..6a769df0b421 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -121,7 +121,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf == NULL)
 		goto free_tx_buf;
@@ -146,7 +146,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
 	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
@@ -317,7 +317,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_BUF_SIZE + IPHETH_IP_ALIGN,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-- 
2.34.1

