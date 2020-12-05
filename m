Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4AE2CFE48
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgLETWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:22:22 -0500
Received: from mail-am6eur05on2101.outbound.protection.outlook.com ([40.107.22.101]:29825
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbgLETTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:19:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnE0bVK1Nv0U7j9TTmn7cEQAAwSSmYM2/MT3Z02rk3R1ePtjPTOVygEzh5lRuPDs1jEhfBoqTJolchzN3P9ipd0yO95qnNjxSCu5wIeWh9Bkoui/zqCElEdQ5Ta136BLRUw0wPVrf/X1rfvQplR9JweRmbgzxmT6qYHX8d+KiK9lJChQf8ZNrsvFR6sFLJDgJ6JFpAI6/lc79aiQmAeiu9chSNIf71634Q1V8wHkK62iSdax7zfbuzxGHesOG8EOmbt9Xna54TSGEbBoyezJuwo8jeLCrBR+OGYpDvHk+BNXE3NSFPGJ5/0CcP2ORJ/L08irslSjah56onZWgZfp8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKYTTJjfAYq2SHbpf0pgwGx+PpevNL4ulj/gk7Gdwr4=;
 b=YybYd/QKcYXzpxsH6WAuoQJ1aP+HeAPF4swfpdpFSP6GBIhgToX29tWfIi2t6bujAAUCoQaK4ZnehrN0e6zBWGI361d9SnuqYFMbY3Fkfz/ZKuCE0rc9ypKhzt6wU99L1wuL39vW3Mi/6M/0cnSonajJU1yOvM4sTDWEpRLVJKIUkoDdIuPyFgm0sH7n7uvxXUCxCJ8NNALjDC9JLpEp/CFp0J5EDUnNh7exd5Bk0/UulAQAIywrjfjTZGYvKa+X7FWl0WSWbDiPIfog4pjjkL1zEjv0BWYMCypFWnAJNbm6sH4aen5naCABGxw0Uj1+7N3+4dJcxobBJhPBmwnxFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKYTTJjfAYq2SHbpf0pgwGx+PpevNL4ulj/gk7Gdwr4=;
 b=BFWn2pGWVhht7Y+aMLeN2dV3aEIdqdPVPkBKppCYlLxvQUIqXhV1TB8ucKVKKnHoZ19NtXJn6JqDrCFyF9QSdbaGIr7cxmXPsVi4M57HNEZpnhoc+rpT/ra76vA4T8yT4RtXhEqAsfnu/jdwkoncdzJ9V/CbXgkMuv9fzmiBALA=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:18 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:17 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/20] ethernet: ucc_geth: set dev->max_mtu to 1518
Date:   Sat,  5 Dec 2020 20:17:24 +0100
Message-Id: <20201205191744.7847-2-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55ed57e5-51ce-4b10-7060-08d899528567
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB13638A572901BAFA70A9EA1193F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uX0ygCh4xAy1OsUAKag9n7X8+icikxLzMJh9bcCUTmCx1QrIIX/PcnRt68TUxa2hKm66K73QquHNDmvMqTlAtkvFVfIKplU01Dk8V4BCv4IVOoS9/GVD7q8cHbLB9I/CZYfVqLkiJW81UNI52bWg1VtzJ8m6k+k0cnQ4zDlPCfk7IBkP/350wzDTbq7ufCORNewwhfULCcY+5uifv8RBZu9G/RNbT7NmCUcgLtqkXlc0JETKitC/cnHk9e+WgOVnFv5Yb9ry+7F4bBvSMcBBVAL5eU2CB1f/uUVPDEV2+EyuFqCxWBfTjIYwhacfC9df43yD5dqcZHN/REcf+/snWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(7416002)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+KnOMDX2SE8w3VxPbTCxSFRExjqaxMD5y4FpExYaT0Ym7+6YFloEi17/1nTX?=
 =?us-ascii?Q?AwN/bnOEL4ObZuSESci7F1yJMn2+LDpNliha2l2pWrR+vkdrFyNveFCwGJ6I?=
 =?us-ascii?Q?KV91dZ6aUwq0KvFhLbH1UbKTQpC6KNhckBwUGSicPfRfbdz6ZeaDM6Pdjyql?=
 =?us-ascii?Q?7w1uzbQLbqnwEspQ/VyZnnbRY/dLkfboYRbpwvV3yF3bV1lbMRemupnyiFBj?=
 =?us-ascii?Q?e5+71Pk/T0AclStWJO473ADOJsyFTJs+zwdPPiGoXm3bgiloPrd120AUiVak?=
 =?us-ascii?Q?2JMxOXWpgWmS1Dyj1QWzvYT17ysSFL7bhtNCbyY26/5qo9zleY4nADPfzMZN?=
 =?us-ascii?Q?kS9MCcj1jSGN0odC7OntmubgbHvlKBZhVz4TBxC8DKxFSZyVGRwRdR32udg6?=
 =?us-ascii?Q?7UqxIeSS7maOwUOMiuo1lBmivUnuIEPb8CsXLHO/jO4N2RAn2UNNZBSzDUu/?=
 =?us-ascii?Q?6oNPF9hPYW4YpSSg1cBiNrJ3qQi1E7arihiPFonS/Y1ajPOfeEWy2xXXekZH?=
 =?us-ascii?Q?Rj11mki7V500aeyqcEJfMIWI/MnL6eRBW0SedZVZS6nbvwB6rstgQggll83G?=
 =?us-ascii?Q?QRnTL7S8Py4kiScBXRN1aXjpQBdcoRsRjqUYmSsUWmZ4mMsZfVt29PVOC6UO?=
 =?us-ascii?Q?fdvPZ9F9mltxHsxtzewH6Knauk7WYzFdt/I7VAM175yyxbZp+gwZApQIu3iD?=
 =?us-ascii?Q?uX8gTz3k2/UtNAV0BvAZlGQWi2zW9YUiMop3iFqeSU8HqWn3VZuVHrQKTAKX?=
 =?us-ascii?Q?v+lzXpxPNwff1kyuXY2tlnPHvXWY75e3MT0ORLLD/Ohh0niBKau7q1wB+fVi?=
 =?us-ascii?Q?qRVcBRvddDSVcS/dV5iBsAZMcEU/MUWO5b0lzUtv5Ris9fSprLbJfX4i3I0E?=
 =?us-ascii?Q?ma8lMS1JL+pVXQNrwb38LpHCgvK4iW/RozWsrghpJFHKRJ6KDnPskmwBYPnF?=
 =?us-ascii?Q?WMad449kfh6i/U5DfixTLy2iyIEoR5aKVqqO18JVipVGm7zvLcucqqWQaPnt?=
 =?us-ascii?Q?8xxp?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ed57e5-51ce-4b10-7060-08d899528567
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:17.9070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tERVoIkKN6pLidz+awmXi7a14UAzx2Z0V2iAwbFGsfSb69x8pjAFfScf3kpdCCgGJK8aFxrtnQDiVrBB+O/rkA0E+1wOTAGEhbsqg+r7rFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the buffers and registers are already set up appropriately for an
MTU slightly above 1500, so we just need to expose this to the
networking stack. AFAICT, there's no need to implement .ndo_change_mtu
when the receive buffers are always set up to support the max_mtu.

This fixes several warnings during boot on our mpc8309-board with an
embedded mv88e6250 switch:

mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 0
...
mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 4
ucc_geth e0102000.ethernet eth1: error -22 setting MTU to 1504 to include DSA overhead

The last line explains what the DSA stack tries to do: achieving an MTU
of 1500 on-the-wire requires that the master netdevice connected to
the CPU port supports an MTU of 1500+the tagging overhead.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 714b501be7d0..380c1f09adaf 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3889,6 +3889,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	INIT_WORK(&ugeth->timeout_work, ucc_geth_timeout_work);
 	netif_napi_add(dev, &ugeth->napi, ucc_geth_poll, 64);
 	dev->mtu = 1500;
+	dev->max_mtu = 1518;
 
 	ugeth->msg_enable = netif_msg_init(debug.msg_enable, UGETH_MSG_DEFAULT);
 	ugeth->phy_interface = phy_interface;
-- 
2.23.0

