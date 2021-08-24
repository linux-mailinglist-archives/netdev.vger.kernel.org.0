Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBD73F5BC2
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhHXKNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 06:13:36 -0400
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:62529
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236023AbhHXKNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 06:13:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXwU20lqfnRcuNBKfqlRkGMsUI9OxlAoj4FrznmOrjKROp2ODEKa/RFFPIXSjZ5I5hVtF5Bw8ODYMjwMC1xgj0N1orCdROMuLRRuUXOHyQkZT7dxHnyKLWaPzRQKNHPj+c6C7ZsyKC9QHIRJfrrtfGOeuaQmpC1IUVhNoqsWbi4Dy2e1icD9PTYly7h37iEHQkfspXMFCozi+bb07yR+fEvdyq6/H8W/J4P5RC2mxpyXtbEYA6683C+UV7D/Sk65W3W2l43gW4JiaDkL/iuOlGOKG+/rAc2gFGh/tj8vHmhEBAwqaSaQO6GVNnlKXLXRIWMclEsnAToB2DbdNTz1fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VaHEtZVAE5l3wF0eTHPwRrBhHJ7VYDxhLGJTEHl7PSo=;
 b=kZK4qkBPzuaWyiRH3ENi9sktgGRY0RnhLUjwQgVraLxZTEN/WU9SIZWOTt8n3l8c8PwkbtGOvaoHmqbwEK9HueFvjTLEN4WOf7K189JEafx7FgplaaIebuP35dsPZY2EWOzHYyPYIfrtMx2TXollsjKNnNszjStp4f4MmOhHbr7TBWlTeETAj3nB7KZaJic1o0QaBhIef+a9iMpGcuutEVdAUkF3AG0dech9VN+nMm/TStt2b7GV5R+fhgGPCGaeN8E50ZEL58jYKHAmerQ+IK0vi2KeioBHcyhtmXSEsnxOt3CBIgbPIbaudUdyyOX2tcMkz6OUl+9vShYD1Yc4vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VaHEtZVAE5l3wF0eTHPwRrBhHJ7VYDxhLGJTEHl7PSo=;
 b=S19hSZJCvd3oNPV5WEC4KioU4DuwFj85434Qn469uLk4mUywj3LiYtG5hyU6hF17glgtUy2sxV62vCGjZMtaGvUsFs7kIDCpDYU4pimGLL1Jz7PnaBMHFXCh89ahr0f9cpAH53ZyiqzkamEppSv16xr+IaCD+6Nj1NCHvvVJSDE=
Received: from SN4PR0701CA0015.namprd07.prod.outlook.com
 (2603:10b6:803:28::25) by BL3PR02MB7940.namprd02.prod.outlook.com
 (2603:10b6:208:357::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 10:12:43 +0000
Received: from SN1NAM02FT0064.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:28:cafe::d8) by SN4PR0701CA0015.outlook.office365.com
 (2603:10b6:803:28::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Tue, 24 Aug 2021 10:12:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0064.mail.protection.outlook.com (10.97.4.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 10:12:42 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 24 Aug 2021 03:12:42 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 24 Aug 2021 03:12:42 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 andrei.pistirica@microchip.com,
 kuba@kernel.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=53514 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1mITQ9-000CJ2-MR; Tue, 24 Aug 2021 03:12:42 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>
Subject: [RFC PATCH] net: macb: Process tx timestamp only on ptp packets
Date:   Tue, 24 Aug 2021 15:42:38 +0530
Message-ID: <20210824101238.21105-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea8bb374-d9f0-498d-0c7c-08d966e7b604
X-MS-TrafficTypeDiagnostic: BL3PR02MB7940:
X-Microsoft-Antispam-PRVS: <BL3PR02MB79406FAEBAA59F3018D6F992C9C59@BL3PR02MB7940.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FroJSsHvMEUIeaWKX21gNon4NnOkJklB+EnaaEIHqV6Ct5MhpVKpdUfMRAeZWR0Qgxy9YJ3ZgGMwOHvHw0cJfE1eDYCMvKKrdAlJdH/nZvXJw7cwt4gTe488z958wlX8BBLM97RkPe1cXcnZ10Q3GTb8PJKHhDl8hwqeKChdwTEIHDOgVXSTpgzprkdxNpXcKbY2NKnhgwzDwUqZvPQBwrlBZt53mipH7QMhMRTtP6+c15mj4FI2Tx+fc82IIO+9IQnoX+wXMwT46YBfaa5MURCUEAIDzoH+TjzMRHUqpOS0XpmucyeNFQ0wtOYPltHZ8FLRqJddpNT1wt/LHmbf5RXGYo+mH4Pf6I9epHzfKagagr9NQfbOJjXXgyY0v/7AbPeHT9y1hkTeA1YbhTlcj2LA0GWxL4dbrweTl+6Tjwo7+Ix95aGpHEKN6O3byFPNKfYtCBe279HnyVsVLIe8JRjg9N8XgQtt3NuxQsF6dv1tTcsTabwn31LbKTdNNR3v7wPnt2aPGA8bAQgWb9C0GeIaNgHyVCEGDoqqKydg04NN+jB7SHSsjdLxUFmjt9EQz7WvDL5puneUHpTVpvSX9kWC1Mtmc3KMSeVnITR+C9AFP2uEQtlx4JFVjemwAquijuUxkzCRlPhhJZbOWgNEZNZhNEKU1EC0vClcu69R8+gK8VA2w7c+ufjRVrlzYFumdpnmp6ITuMJOxPovFJZnZvtNurbher60DnCP+7Yjc54=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(46966006)(36840700001)(426003)(47076005)(336012)(110136005)(5660300002)(478600001)(316002)(7696005)(36906005)(44832011)(8676002)(6666004)(7636003)(26005)(4326008)(82740400003)(2906002)(356005)(2616005)(82310400003)(36860700001)(186003)(9786002)(70206006)(70586007)(83380400001)(54906003)(1076003)(107886003)(36756003)(8936002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 10:12:42.6023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8bb374-d9f0-498d-0c7c-08d966e7b604
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0064.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB7940
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation timestamps all packets and also processes
the BD timestamp for the same. While it is true that HWTSTAMP_TX_ON
enables timestamps for outgoing packets, the sender of the packet
i.e. linuxptp enables timestamp for PTP or PTP event packets. Cadence
GEM IP has a provision to enable this in HW only for PTP packets.
Enable this option in DMA BD settings register to decrease overhead.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Acked-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index c2e1f163bb14..e4f26d972219 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -471,7 +471,7 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd)
 			return -ERANGE;
 		fallthrough;
 	case HWTSTAMP_TX_ON:
-		tx_bd_control = TSTAMP_ALL_FRAMES;
+		tx_bd_control = TSTAMP_ALL_PTP_FRAMES;
 		break;
 	default:
 		return -ERANGE;
-- 
2.17.1

