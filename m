Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7D251FC71
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbiEIMTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbiEIMTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:19:18 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2086.outbound.protection.outlook.com [40.107.212.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8A9102745;
        Mon,  9 May 2022 05:15:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmTumVib2YC3ig8vHdQHpGnxiq+gy4nTtkjd5kYluxBWYXpeGvarMdG10qGchcU/122rYtDKGU8KYO1bO+WuaqbCvcDWEdLzGGuYmBVaFdSSMHO6kElw+8yM0gr0i3dDWC+xjTqRzrQwn6T3BBB3jp0pYuFjVvV7CKwIheSOlprEcTcvH7pWYU7nuPCEhiPw6ChKIS6l9IvOvFys3lbqLiy+hDF/TGuC1N6nwJIqyRTOSpW4dEDoPY9QFm5IkrHPgyb8rge5mTGivfS6HCF4A8+bXUQOqC35ms5ByFUHIOr4zifAyBb/I61w/LWALeLovyMS4MkV06cSrQqebYo8Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLVYYAbl+tXjs07LoIkuHUi1pxH6H9NU5B5wc0rR0DU=;
 b=CYTHIoA72nawTkNUP2e156SKGFTHVQolyQaz5iWQ0Lu0WgqqOgwEyJDSdACaRuud36L9gnUPm3lMWojmqkugXrsTcbBtOlAVwYK1qOo5fO5n7m3To6lkB7XfNNFnomDSTPJ7/YCCc6xepI240pWATSBuvGtpD/zgoGg+1TpQ0RfpUEz1iyYPEbsmccHGIwNeEFS/H6w0rx0pL307TIeH2oxCP/gZAktLLplnX2pyHyfTv/hMnAwkUMM7kSXKhzT5qJKWCATScQml0mlBjke+TrZyA/V11kxGSzQHAhcdXb+pBhHyifyGQmdrYwolzWGn7xhgL9hOUuU6ctTRjG22/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLVYYAbl+tXjs07LoIkuHUi1pxH6H9NU5B5wc0rR0DU=;
 b=jCho9z4YAtz5N9/47eHcR2ju3sVUw9hWUvfbH44r0coYAvCpRCoKOZMu+oBjXgwoIbcfn2Didyp/lmkM+73aT0CnRtbuy6/fH3rBcDV7PsZSxz4gkSGfIvKdVv9f+6Nxpvi5fXpxxf3+jT+5pmYrKY7c0wD5vYY4dScxJ8y4ZP0=
Received: from DM6PR05CA0040.namprd05.prod.outlook.com (2603:10b6:5:335::9) by
 BYAPR02MB5592.namprd02.prod.outlook.com (2603:10b6:a03:9b::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.23; Mon, 9 May 2022 12:15:18 +0000
Received: from DM3NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::3f) by DM6PR05CA0040.outlook.office365.com
 (2603:10b6:5:335::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.14 via Frontend
 Transport; Mon, 9 May 2022 12:15:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT033.mail.protection.outlook.com (10.13.4.101) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 12:15:18 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 9 May 2022 05:15:17 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 9 May 2022 05:15:17 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 dumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=58186 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1no2IH-00029q-17; Mon, 09 May 2022 05:15:17 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <dumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH] net: macb: Disable macb pad and fcs for fragmented packets
Date:   Mon, 9 May 2022 17:45:13 +0530
Message-ID: <20220509121513.30549-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 404f98a3-edab-4cf7-2069-08da31b594cd
X-MS-TrafficTypeDiagnostic: BYAPR02MB5592:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB559234A1FC0BE8812EB0287CC9C69@BYAPR02MB5592.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5/S3GIXpNbeP87GsmWQUcvOdlDuUQiGQ1vZfZhw9WBgfdzr3zX/jAdduYlQ72uiYCbqRoUU6UTJl90IeL+gEvEqQCTvKXvKtgtsv8Ma6zupJfYa5+b6li5rGHaNHgsc7VXcdnzjlZupMkwxNugjrlIH5vrUMlspsYWVM/Xd6PCXhJD3yOQG8uQkD+TBQ/PvooYftNNBBcEx1h71a5zbdLyHscOx5c6pCqtHesbKp6FwjMIfa2JGRzcXgWT0M1PTgSJtyKP0n1EFv/EZoq617NOdsnc+qPjz7KtS/s5qnHamkslZq0actUt1nufq5UBA3gv44D5INRmuOZy/5loUIS7EDcljF2Ope9MWAHHyEHqq/Q5rQaHEQY0UGQfmv4dbJPXV2TkJp2uHu38rqChgI37SJNsq76Z6Tl51avYP0gxJGElPud82gg2WrTNPORtng+LVzQSmDKGTt74MsL8zAid2SB0STp+R99lV9PmKLymj3Z4q/gdFcUmkw3xZbB03QNB8dhHGdu7Yj9mIRRt+68nX+VyclPnU9A2wmuKzSnyBWDJn08ub5cc+qjkGBhGPJApANNzuWghXMEfzkd7YjAy8uujV5ijZeNIk2zevV0O3qB0RFBjnESBHdw5Gj5+4ok7fI5smsaStZ9VlU/UxRqei4leNvxC4G9dDZtRj6iLbJQMhbL5A+VZi4WrN+Ru3EF9OjyUHV5CV6Fkf9Rrt5tQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(2616005)(82310400005)(9786002)(107886003)(186003)(356005)(1076003)(5660300002)(8676002)(44832011)(70586007)(47076005)(4326008)(70206006)(54906003)(36756003)(2906002)(316002)(110136005)(83380400001)(8936002)(7696005)(6666004)(508600001)(7636003)(36860700001)(40460700003)(426003)(336012)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 12:15:18.0878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 404f98a3-edab-4cf7-2069-08da31b594cd
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT033.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5592
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

data_len in skbuff represents bytes resident in fragment lists or
unmapped page buffers. For such packets, when data_len is non-zero,
skb_put cannot be used - this will throw a kernel bug. Hence do not
use macb_pad_and_fcs for such fragments.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6434e74c04f1..0b03305ad6a0 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1995,7 +1995,8 @@ static unsigned int macb_tx_map(struct macb *bp,
 			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
 			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
 			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
-			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
+			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl &&
+			    (skb->data_len == 0))
 				ctrl |= MACB_BIT(TX_NOCRC);
 		} else
 			/* Only set MSS/MFS on payload descriptors
@@ -2091,9 +2092,11 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	struct sk_buff *nskb;
 	u32 fcs;
 
+	/* Not available for GSO and fragments */
 	if (!(ndev->features & NETIF_F_HW_CSUM) ||
 	    !((*skb)->ip_summed != CHECKSUM_PARTIAL) ||
-	    skb_shinfo(*skb)->gso_size)	/* Not available for GSO */
+	    skb_shinfo(*skb)->gso_size ||
+	    ((*skb)->data_len > 0))
 		return 0;
 
 	if (padlen <= 0) {
-- 
2.17.1

