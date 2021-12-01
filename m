Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60B84658CD
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353289AbhLAWHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:07:06 -0500
Received: from mail-eopbgr80105.outbound.protection.outlook.com ([40.107.8.105]:23047
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343550AbhLAWGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:06:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRRQ3zJ7ThKZV91vm1dkpXPHYB7/cQgWCC3PjyL58K5UZNF5SL6F7fRVE2JxKb+dCOPVBIIX9IDnjfsVpYBjUDGofgf4rw2vNfdFsYDjW9tVSE/OJVngIzse+UzAhTTYbxepKCj8aTbqPB3R9Bq8nvdDlnjlQhaR95B4wKu9tvf0ILbh9GHtkzBzhWomh8BYepBv93Tt4xBWOoKjBvWNsZCl7AdXe5CyFILI+7LQB6ttALXyku4ncb+Oa5qo+IQcAsum8EUn1Nr6CZH3IuEjFttNy5loB2Vlwe+fu3ojJSJ/17fiGMILlPpR4CP5J4iX5bzi2VIADR9v9/bEC61dUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPRz7pc+HDsdQ3tvYpsRCNceLWkCNESs0rzx4G2U7dw=;
 b=Ytw0Kke1/YjWlunwe3WW8tPxDSNx7SFqTSEY4Vp7ewNqnKfeVQkpGhgd2iD9zlqrLYa7cg3qdFAHbqbYHfE8lu6msZ+tUbwHqcT+Ez06781McITG7JsPbUoSAZly04YNB6BlX3PmIpIA+6LTg7y/cHz/miAO6MgNOGqXdxbKMaKebdqw2j1HpK95yhMcOFqDsHfrbiozRsm4xIOuramOil8juxwTL/X0Sjh2KDQiB3qucaFT8vLZRLtnNFJYk0SoH/NYrZ6puEph6xltVOoJ6RJMMKNark5Z77TYrXj2IQg/FMyo6+C7ogkKoPnNMgSqiYuWpMFOH1J3WTlQETZ1QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPRz7pc+HDsdQ3tvYpsRCNceLWkCNESs0rzx4G2U7dw=;
 b=MYlG0S84RuMMUixsZeWtjw7KDuMLYbus5ea59Wxtz1PF2+zUskZdykvJp2KMii/3Ikxbfh4UrkDHMEH0bbvrOfJCX63JRy0bADf8qLiF+SNB1496nvNN8S0eCzHAWH0VSh9UX4ayJD6fIrmhuPh4wg/zmQi3AdYjVO8dQL2C8iA=
Received: from DB6P195CA0024.EURP195.PROD.OUTLOOK.COM (2603:10a6:4:cb::34) by
 AM0PR03MB3826.eurprd03.prod.outlook.com (2603:10a6:208:6e::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Wed, 1 Dec 2021 22:03:29 +0000
Received: from DB8EUR06FT006.eop-eur06.prod.protection.outlook.com
 (2603:10a6:4:cb:cafe::d2) by DB6P195CA0024.outlook.office365.com
 (2603:10a6:4:cb::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Wed, 1 Dec 2021 22:03:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd;
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT006.mail.protection.outlook.com (10.233.252.108) with Microsoft
 SMTP Server id 15.20.4755.13 via Frontend Transport; Wed, 1 Dec 2021 22:03:29
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id D156E7C16CA;
        Wed,  1 Dec 2021 23:03:28 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 70D7C2E4542; Wed,  1 Dec 2021 23:03:28 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] can: esd_402_pci: do not increase rx statistics when generating a CAN rx error message frame
Date:   Wed,  1 Dec 2021 23:03:27 +0100
Message-Id: <20211201220328.3079270-4-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201220328.3079270-1-stefan.maetje@esd.eu>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de5dfc93-94e9-4394-c45d-08d9b516683a
X-MS-TrafficTypeDiagnostic: AM0PR03MB3826:
X-Microsoft-Antispam-PRVS: <AM0PR03MB3826DDBB1B413902BFD1A70081689@AM0PR03MB3826.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dL130r/SBIsle/zOuPgQe8to+NaZ3bX0TY5LGi7W+C+bFzeRqu/eLCQYooaRROFsAIV2tiA0cA/YIJyheukfAVFqg7O0nDmW66LgJTgu5FS6x45Cl/s9qXXFkPXrZ4efkJY5ZI+sMUM+T9nXoRqSpxYWNrCbHEGUsxJaq1V/OzXuhPystzXAXhgJZtV4ipZGTFb4+YHLzRBuCse3Px1M9/EI9Yf0sxw41Tjo+ql4/BNWsX3BZl0qzHTvNP+MxFNEmYJe+NDKxWC2MD2O3V8lEYUNEz3CvI/OXjBthrp8PBmQiPFLwTR6AgW45ovlqtE6O7S/OUxvAmsGEex73XKdbR8SIbxDL3pyS8IK5hSLBQeoT7+GvooEtSQg6QD4Qg0dZn9euh7nrc5sB7vop/ADfHhWuvcjkM3rK9v4h0lcy4+IEoKzRsltSomiSh3kY1b7ge9A/24huNMHwowdxkP60j8JxdP3B7QqLu4hFS3dDF5Arker97aYgh63DtZeJYsbuedL+pqDzatOAuFuOE5hj9tMNnb4n/GU06OKWQJXBUqqtBKLiGx3TOxIDvG6v0jj5tnkQ1/a+DeaEn0jyHo2eLQk1VQc5zg5mgrlhcm+Tj3zE+3oun7HnCQkPD3ZGi2dza04sFONIn6Ij4BKeZ+QulXV7CVyCoJCLhvhaKRGiRIXwpgb+wmRdBlw5lzKJJiV4QlFPFBzv0G2V80hUC//h8WgHlxdiGHZN6EcqzKJO3k=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(39830400003)(46966006)(36840700001)(1076003)(110136005)(356005)(5660300002)(2616005)(36756003)(86362001)(316002)(26005)(336012)(40480700001)(47076005)(186003)(8676002)(8936002)(508600001)(4326008)(70206006)(2906002)(36860700001)(82310400004)(70586007)(83380400001)(6266002)(15650500001)(42186006)(81166007);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 22:03:29.1132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de5dfc93-94e9-4394-c45d-08d9b516683a
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT006.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB3826
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CAN error message frames (i.e. error skb) are an interface
specific to socket CAN. The payload of the CAN error message frames
does not correspond to any actual data sent on the wire. Only an error
flag and a delimiter are transmitted when an error occurs (c.f. ISO
11898-1 section 10.4.4.2 "Error flag").

For this reason, it makes no sense to increment the rx_packets and
rx_bytes fields of struct net_device_stats because no actual payload
were transmitted on the wire.

This patch brings the esd_402_pci driver in line with the other CAN
drivers which have been changed after a suggestion of Vincent Mailhol.

Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
---
 drivers/net/can/esd/esdacc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/can/esd/esdacc.c b/drivers/net/can/esd/esdacc.c
index 13f7397dfc4e..f74248662cd6 100644
--- a/drivers/net/can/esd/esdacc.c
+++ b/drivers/net/can/esd/esdacc.c
@@ -555,8 +555,6 @@ static void handle_core_msg_overrun(struct acc_core *core,
 
 	skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
 
-	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -613,8 +611,6 @@ static void handle_core_msg_buserr(struct acc_core *core,
 
 	skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
 
-	stats->rx_packets++;
-	stats->rx_bytes += cf->len;
 	netif_rx(skb);
 }
 
@@ -668,8 +664,6 @@ handle_core_msg_errstatechange(struct acc_core *core,
 
 		skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
 
-		stats->rx_packets++;
-		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	} else {
 		stats->rx_dropped++;
-- 
2.25.1

