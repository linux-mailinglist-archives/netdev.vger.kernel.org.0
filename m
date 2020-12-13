Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE782D8DC9
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436548AbgLMOJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:09:39 -0500
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:33084
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395465AbgLMOJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:09:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOll8Y78N1nV/bSK0vnatohme858dRQ7pdiiJS19pMjuATe1cTBBvRquRzHn7W6vxP5vMZMLT5uGrYvCV5FgA8u0QCkPVwemNpJhPxVpGa2i7xebZgZRAqiokc1inT6pQCHnNwvZMRSQMMBbPIMxku7ijKirCcnkqgV0os3OtTrhVI0qIeSftYVljjvhgMX/U87oDKkiTYa0/7I4kXopzskj8kFZRHDFLfqyX4Bnw42mwFImt1tPmYIpcjIP0RhrSUD+xtn0MIosMD7noBZpvDF/EluueTZz6H0sOYDu38Rk/u9ddQfupXJMuZKCQTeG/Ta3/kiQruozOa1BjWk0kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmHYirXK33GyxusjLAaD8CyLjHaTwwDweljcY6s/nYw=;
 b=gjhjhBslIkepOwOFJRUhsyu6ebsOGSbP8Jm+OFZhTMcfZoUlx8rdS7m+e8KOrBB4Drge3MgpKT0Wqf3MElMvMqmi3CIq5HlPJJj3I4VvYV4jIN0tb/S99i02e29S1cY5xhVxTcSdn1SX4X7toGozkwLiPE+mj0EzXVOXZXRaF9PiQ2yAdsSlGjCCJBfsjxIfwPORVkdWHNqeGfG+0R8UeQe17on3HA5sltRCMYJGSkrxai1lAHeWnKvIS53fUWpbuLsEorDM+yPQ73A22fV1gG3Q31WYJvmFOuRKtoM2gxOPE9LGZw99pjAgkHMpjgPPTi2x7PohEd0jKs9rr1nhnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmHYirXK33GyxusjLAaD8CyLjHaTwwDweljcY6s/nYw=;
 b=NWU9FYIBOlr8HosUEyCeWaRYAFEnlA9Wxx53utxOGglrR2gfsIrAUnBBPzUo28kEcNBprOUyQomcmkkd26ZKaN7TGU4e0HiLCY9nTWERgDxMvQ7aUto9Kek8cNAv5hlJkAfqAWYp/nLfDDv7EGOyQgKL4F+ZTaGn+4Awrf3jJqw=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sun, 13 Dec
 2020 14:07:42 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 14:07:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 7/7] net: dsa: ocelot: request DSA to fix up lack of address learning on CPU port
Date:   Sun, 13 Dec 2020 16:07:10 +0200
Message-Id: <20201213140710.1198050-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0235.eurprd08.prod.outlook.com
 (2603:10a6:802:15::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0235.eurprd08.prod.outlook.com (2603:10a6:802:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:07:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56f6a446-2f8f-4835-af2a-08d89f7074f4
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB734127015601176159E0517CE0C80@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U7VL1hFXPddt26sHBvvP2GTaadOsS8Cj76iqwY81dCW7pHvlzcTnNaeiaFr+A4VwOFYbI9J/H6CDZ+A+HewDUOVl1gV0+NFqu+WCBDmTLo7rcfb+TwpoN4gBrcn2Mij9znnngzGs++wv5Obdi1ab6+bjhD790HrXVoNF0Y5ZNDKudX5xXPvb9eT0db9jd7rPetmMf59OGpeZb+CQ5lQssAmsRtB9lxBoNoIL2ZP3LAgqc/VmeOzSXQqY1HuAePfbfDEWxeyxbqnbHYeD05j4jNbSlVxgMIxqcqUxvqZmqti20yAxZcFyt1Yx0AQgIkaVSocCXprQQvvXeBp9pWyts2QjVzAcvhkteDVr1C3Nteb7n+M2cd0LXHXbg4M12VFZDPGo9b7bYZwKUMPtRVX5zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(478600001)(52116002)(7416002)(5660300002)(1076003)(6666004)(316002)(16526019)(186003)(86362001)(83380400001)(8676002)(26005)(6506007)(44832011)(2616005)(956004)(69590400008)(2906002)(4326008)(8936002)(921005)(66556008)(66946007)(66476007)(54906003)(6486002)(110136005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?98KSCJtOD4TNjTYwG8YeWjl27qQjtwDCS2Pu/OByUHi7a93KBcgq9Rr8cXxj?=
 =?us-ascii?Q?yBx/6Nc4kc8f5AbXkaWfnYZ/y6Nw1oEc6SnZCFPv5vi7a79FW94af48Bg46D?=
 =?us-ascii?Q?sXRmTouz8t8Anw/K7Afr6XDdbAWIoouEh5LGg53NuFkFUogMfDL5dggelKsX?=
 =?us-ascii?Q?NEnr6qeZxvT2c+FjWGThIvtTxUp7pmdMCe+KJYR/GDuaMgQByKqK1lIisZZv?=
 =?us-ascii?Q?acsvBH1C9I33FPnuNPbjflCI++Chby8J7k9b5049gEbEdW3suDE/5awBzzRf?=
 =?us-ascii?Q?Vom4/x9cb6S8lV/bHtRn6PJDd5qDMTHAWj2tpJKMwIF0lu183WOF1u4Udha1?=
 =?us-ascii?Q?F6AvymTMlxDYviMex929vpxE97rbh35WOgQoSxMTFT9r713hw9x/jWGaKyn0?=
 =?us-ascii?Q?K3pBjE/nSFpMmvDRh1+fyP6lKiUH/qaYfJaEUEGMk4rApokkrzcPmAQEXURW?=
 =?us-ascii?Q?PNRggQPrzeH+vbLoSng43EWyedHis/x6063OGSnpOQyyJPiaWJJq6SaxXdrz?=
 =?us-ascii?Q?woWY5x0OFU+SY7zlT1AOTfAhU9FdkixmgoMyQi8aXG7ZFZhDWRnMEPSa7uFU?=
 =?us-ascii?Q?ukmcys2VY60oeLDAyu6ddOiVmlH2Gjf6aMDJXxR8gme79AX7UvapdQmKPj/0?=
 =?us-ascii?Q?ss1lZ1bJIC0/wxZ4j4ZFTCjminru2eZNBDN5cAxlew/athryBWyLPCF3twFU?=
 =?us-ascii?Q?Jgs4p49pVuDQQlaPBytK27lHi/DCkG8/dlVf0ptPlqqI2G+r7yC4hNkZuJFQ?=
 =?us-ascii?Q?TJm2gYmbmYgcincz5QTkdpgoviHpzYeSJWevOZBDn6nSyZdY204H7Hz8JqTz?=
 =?us-ascii?Q?Ep7h+WaIkpLJmTJhuLUtOSspYcLlq6tGmeDHGWJ6SV3J4DY6s8TtBLxY+5ru?=
 =?us-ascii?Q?QBfzz/0skogfLGicAGqcBpdsjA1BXsz4KJcce2DAn+pQBkowXXEqpzWP/Cye?=
 =?us-ascii?Q?WVYZRCPH/hhnRWuGHNf+qK632NmdCymR+CgAPrkcJRxnPnu3RNCx9ey0SgAH?=
 =?us-ascii?Q?33xp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:07:41.9861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f6a446-2f8f-4835-af2a-08d89f7074f4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3Cyh6/wghJoMnvfdmg4Fuu7pEWl58uZGGTbHwpP5Fym527TICZ6eTtUh/L5iZzngpMuKFw7t7iapNXxluy15Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given the following setup:

ip link add br0 type bridge
ip link set eno0 master br0
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp2 master br0
ip link set swp3 master br0

Currently, packets received on a DSA slave interface (such as swp0)
which should be routed by the software bridge towards a non-switch port
(such as eno0) are also flooded towards the other switch ports (swp1,
swp2, swp3) because the destination is unknown to the hardware switch.

This patch addresses the issue by monitoring the addresses learnt by the
software bridge on eno0, and adding/deleting them as static FDB entries
on the CPU port accordingly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
s/learning_broken/assisted_learning/

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7dc230677b78..90c3c76f21b2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -629,6 +629,7 @@ static int felix_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
+	ds->assisted_learning_on_cpu_port = true;
 
 	return 0;
 }
-- 
2.25.1

