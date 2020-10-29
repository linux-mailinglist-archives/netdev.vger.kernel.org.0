Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5FF29E29C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391151AbgJ2C2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:28:17 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:10036
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391116AbgJ2C2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 22:28:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwqQaU7t5s0Z1gCTV9hzIvOUQZ+BzVgu3L8c3zoaf9OgtjskpcgsiyCDSZlKs+n3HyVeg5y9Wygj6siTsQ/6SyoKoMGmSgbWgIfaWXdkJe40wCI2L6PUh+O6OuiHaZwLaFIzSLtHp+x8VTloXDPHQ7jykFbLu+KjgVk5eTkgtILiQz4mhZD0IN3XrRLm5C072HQjKg7nxcXqaW0jfUqGY8Y8t2wg4XeuAWqy4kti2m/viOBg/B/vvz1EKDi+LbkxbscGanS/ZCXK6S7gCVdiWYKRJlEjuS+Fi7knYA/q9UJRJRpGd+Wxi2SJxJgB+tuz9MSVlSDzoZ97W8a9bPGfvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfakWt6AbRiWt5GVH/0WC7bjj5arZFaLMJHVsWw2KB4=;
 b=BhCZfIUy1VUpkKEeKdqyVDJlVPMfGyNjG/YraPFZqULF+L1KSM7NGBOWOY7fRxiHVHnbpOp3ksCQCebqv7Doaa9nejz/I9u4muUUjn16axay0YZoHnkMBvmgk68PZ3Fn6B2QUyM7kW33qeez0uFwHIQZ81KnEzGABymY9wFFCogo/vNCIhtP9WVml90VjrTq+nZjK6cK6Cmrk3HAey0rD4NdMlWCRDLbcrWWyRQML55bTZRcTPmGZoTAjkKfJ5Mkb5KJwpditxBDyp8UbeXZI9VieyX+OEasx2YfnZQYFxXHut+A4fJvi9uxtjhN9UqsJTBnF87tvyaUUBUaUUOUtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfakWt6AbRiWt5GVH/0WC7bjj5arZFaLMJHVsWw2KB4=;
 b=nGpUuSYUHfcuBd2k8mos0o5a+lZ3mPRhabEdA+WEgrtUkl/qHdJryFEczNUy6bxGXi6U50B7IrzmkVmVgltUdwDkE/PyAX0lqTNUli8zhKFhTH+QBwvC5/shXO4MVI3UrDv9oKX8TchBuMdaQdLMk06aOiBkiSmoqHg256bzKVY=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 02:28:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 02:28:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net: mscc: ocelot: use ether_addr_copy
Date:   Thu, 29 Oct 2020 04:27:35 +0200
Message-Id: <20201029022738.722794-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201029022738.722794-1-vladimir.oltean@nxp.com>
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0101CA0052.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0101CA0052.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 02:28:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4303d807-16d4-462f-dcca-08d87bb24169
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB694267CC4A1E20BA57501CC8E0140@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nJ2xK/ML6LRz9SpFMy4JbHR6B9pgVggqR7fM6I5CUZGl4vZpHroanSE5NzbBoCVqV+PpCPLatT1GEk6/NmqiQyRn2gyo5MLL0is9uEF1ZjysSKug9Yihvfa1cU8Fp1quX8+8LPRRJrBXT7Ufn2pV5uvRYt9+WeoJeH5gtr4UAE83DENaHW0NvJGYxDkNbP6bn1cz8+/4egqXktpMfnZvjHqSybtC5tga3BTvyY0Y9wF2QIT9vuRe8fBQ2d4B8IZ2PiIWt4jk6ugwKK95jSYzNzaYC6P/BtD+e+aGHGv1gru6JfeQ7zns4xOXHkD8RLCwzI/ThAqydGr7reU4eAqujN8jqNxkYW0V7pBL+Dw+XTieIeFNEMA0MYq2fqAzOhBcZfCIlPiITbXgUoL6+yvxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(6486002)(110136005)(186003)(5660300002)(44832011)(83380400001)(1076003)(316002)(6666004)(2906002)(86362001)(69590400008)(26005)(8936002)(16526019)(6506007)(2616005)(66556008)(8676002)(66946007)(52116002)(66476007)(36756003)(4744005)(956004)(6512007)(478600001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DJNlrVZnlqN4D8pnCJZpktgjJDb2qX60nP6KjLBNWRLyMH7WecZ55t6b1/h0vkxkLXhCWqT1zU6H6UyRdt2wx9qyo+ldm0ltV2YJ03hEofdCOlD+ok0Xe3IW2o+ZOIbBtBMpOmSp+9CDP8OlXeDixtlMioFvej18WO/1oqjketzYxe7zu3HF4K2N5zJ+aecHw2B0mmqWm6JBNzhOY0ZbGvcAB1UowthqkMo9FZoKH6PQApYGGoadCXTLXciDIgkIRPNBeX5a92s4mm9nspaigI3YQhiNqEqlUOPsAITlYf24pHl8ec/WGJfh90lkLoblEE5aDvJlgSHm0NDYf9ylXLTHyoPRmZRBAhknjyUNJA3DsqIdL3dsHxdv+p0KLXsqBzD8sw1IQB1hQq0VrKajJmZ0dOuCW3uKv3FFIVn7y0CN/BzPaPoDYX2+EpGF7MTg/LKb4obwy6ZGa4obthbZEyp40TmiERDznb2yShqzlVs3HMgF/2ziBx0b8J524d6/FH5hZ1O6wzBDTxnvUeYzpFQQMdS7zlKxFf9lpMu3oddpyCKpYXgAY5SOCeqBqSMjksoykq4X4HTn5kCqXCdH37O7mxoMQgYrlfZlD2MpYKw0cVBlDrpuhn/lQ9TswhE73gndABWQVZrAbf3MWJn8rw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4303d807-16d4-462f-dcca-08d87bb24169
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 02:28:00.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzFNtShXgEdBjQT6dwNNwFmCOPUao5TffWS0c+8sIW6ya9+eMavbzHDmfl2Sr6Yhax5XKJrY7/2kELy5CVCgUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since a helper is available for copying Ethernet addresses, let's use it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 25152f1f2939..763d0277eeae 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -997,7 +997,7 @@ static void ocelot_encode_ports_to_mdb(unsigned char *addr,
 				       struct ocelot_multicast *mc,
 				       enum macaccess_entry_type entry_type)
 {
-	memcpy(addr, mc->addr, ETH_ALEN);
+	ether_addr_copy(addr, mc->addr);
 
 	if (entry_type == ENTRYTYPE_MACv4) {
 		addr[0] = 0;
@@ -1042,7 +1042,7 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 		if (!mc)
 			return -ENOMEM;
 
-		memcpy(mc->addr, mdb->addr, ETH_ALEN);
+		ether_addr_copy(mc->addr, mdb->addr);
 		mc->vid = vid;
 		mc->pgid = pgid;
 
-- 
2.25.1

