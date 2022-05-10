Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8161522135
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347350AbiEJQcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347331AbiEJQcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:32:16 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A219D1C94F6;
        Tue, 10 May 2022 09:28:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4LBKPCk6r3vsTZ2XgyuVDVEzKCptJ1rw3fYj/hONA/8mY2D41+wNXObk+gpNBOBuHVsIwTvWlcif8DrqX+4DolqSxBRkIdgKdT7BUwaHpryx84yQF/3L0HcDBYDF/GB7fAhRr0eG0255BXCVu9unocv1yP0WHxKjkqEbV3xV6oOwBpVPKcwJo1jEGd/+XBv51RJ31SFgbGboLtEFkf2Lo6bEZ72hLvgKGa5GfUq1fzwzH6GPowZhP6XNUUzrFipSwF8Y4sN3VUSzlhzPBv6CZgDiuZyG/+84p7dbqH3A//tjrof/m0ll3fIpnQLczRxaOFJvrRzl1xGVL8YqUGFyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKPKkxsTHN2xChER14kCSKlhBmENaw5rEivdHTshy5c=;
 b=UWf7q+yFwdk7ENn2SCOFD4etbOmKMNGDvEsschRS7V5ezpiJ/1eEVlhhGlqRRMsg1KJ33weSBYpoTUENJFLai2O6kLdTcvESjTWcFYP5ufglLRvqNW2+rnuU9/HUNL2TiMRk/Qn7VfGgUCstWI2Zm2F7oK01t+fGX1JMeg29Xgn4pDvmJQbj4rQIkgPcqxrexCgeU0GkQshBgZWd+eO5hpkDSyFXTu5cfe/bCRYjhXSQEZ3MoM5+wA6rJRIgiMj0jYBhHzvBA6CjomdF0JhVRxZfdO6Xf9m4CGSttsAX+6N9PaVZc9A64eK8ihpxVRJEMcwPxWnb3gz4lFXt1wfVRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKPKkxsTHN2xChER14kCSKlhBmENaw5rEivdHTshy5c=;
 b=tHJq2KkhFCocSF2MqH7e/2T8pohCp65qeW1vn32nYXKcLYpYW+oCWz4R5vxDUXD4ZR/urCsl2Be/crvl1VJ/aYDOFJYQwlqwTB2jm5NfxGg1ekCTRBIf9H0oA6xst3Qo90+wRHSx9JK9vFWgsMT2oGtaLvC3Rr6tCxww/lt+fC4=
Received: from DM6PR02CA0073.namprd02.prod.outlook.com (2603:10b6:5:1f4::14)
 by BYAPR02MB4248.namprd02.prod.outlook.com (2603:10b6:a02:fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Tue, 10 May
 2022 16:28:15 +0000
Received: from DM3NAM02FT053.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::7b) by DM6PR02CA0073.outlook.office365.com
 (2603:10b6:5:1f4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Tue, 10 May 2022 16:28:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT053.mail.protection.outlook.com (10.13.5.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 16:28:14 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 10 May 2022 09:28:13 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 10 May 2022 09:28:13 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 dumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=60376 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1noSia-0009ES-PA; Tue, 10 May 2022 09:28:13 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <dumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2] net: macb: Disable macb pad and fcs for fragmented packets
Date:   Tue, 10 May 2022 21:58:09 +0530
Message-ID: <20220510162809.5511-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1b41183-8380-4fbf-5ebc-08da32a2154a
X-MS-TrafficTypeDiagnostic: BYAPR02MB4248:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB42488BBF855DAA9B0A4DF304C9C99@BYAPR02MB4248.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glMFiJovxuX6DtSNtp7dg3P+qqX6UNdpYhMd6yXHbPxFZ2o1kIHJ7GnYczEosjsx3bZ8OB0Pq3F7Ze+oPQsFBJtZ/S2Un14W4z+cPUM0A6SokDEPGofYuqlyoHwPQkQBhBV7hapsq+KzvSlZXqHRO5Xwkl9cKTJ6lbmo33gGtJd8k6ff1U69FvA/nDehLF1VcVwbjKp9X7o1WQizQptGvX82voHgSQkYQPCMO/i19fWGwhLLkFZby9vGgq7ndQpQfQ+ljR21zTCbWh6LStgxYYffyCiqYZEv79yMzfoIFwx4DGVzc5C35mJtdUsDRTGpBZOW0yyaRF36mu959TkbRdSDXi1rwSoBTyCRbS+i9kfSIsqheD1eguknX2Nb8npZCsyiflx/DRMmMBHpS3v1g1YxlLO/c0F++UVlrQxcodlJml61HH3Emgh7kQmAFuztLs4RIiSQwaRVU/4/5w3/W+rltPpB042W/E4egg2D1CnzMY7fnvOWepLuwUCOpGGynPXp/qjdrYvKweWDZvYOivVPIlSlYXrsGMru9RcjlPGvSWh0fgTIm29nJK9pYvV2jOC/Kw1vz8Q0+OWpvpDyzNvqelpZ2PNASfGbn4BzBIRHbH7nGAmJ/Y/KJiaf5tVwhjM6p3Qw5jpmrmwjx6YKRQdXC41OuE34mGf0Nywjq9Nm76PmCSGHv6xRamZQxXtU8OV9XLhEnNuHJrtYvnkWXA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7696005)(1076003)(40460700003)(83380400001)(316002)(36860700001)(186003)(2616005)(26005)(36756003)(110136005)(107886003)(54906003)(508600001)(8676002)(2906002)(5660300002)(4326008)(8936002)(82310400005)(70586007)(7636003)(70206006)(356005)(336012)(426003)(9786002)(6666004)(47076005)(44832011)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:28:14.8539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b41183-8380-4fbf-5ebc-08da32a2154a
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT053.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4248
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

data_len in skbuff represents bytes resident in fragment lists or
unmapped page buffers. For such packets, when data_len is non-zero,
skb_put cannot be used - this will throw a kernel bug. Hence do not
use macb_pad_and_fcs for such fragments.

Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
v2:
Add fixes tag and reviewed-by tag

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

