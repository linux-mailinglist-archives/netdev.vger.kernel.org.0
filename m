Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6417D3E1487
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbhHEMQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:16:29 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:63492
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241166AbhHEMQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:16:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVQlZik6Jqoiz81fxmIz9dRO0elUsz7xSJ7T6GJnRvdM2fTJzm5IEiFujrIPhxhkPrJdlGIJa4djODiKIaPJLYcHuUJ3gD4dXQYKcDSOu6DXGfYNVHOiT8sEn/GeSXwQDMo2ZZMERbFcR4OsnetCCYrXJQEClpNWWnTZGkUu1BBPPf5Yon4VOG7jSzYYBxeTDLRqKg2dqeamkBRqeNlT53xWE+ywwrvVsrx5hRFjnsCcvFUI3ITTMnjlJ7x8b4N5lejP5O9wTVQA41i2UIWoKlSDLJuZtSNyz5vp5OPy8InKIy2kLwQZrOE8UNcY0Af/0qME48AeDM2zohHp7ZWskA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxkQqjzSzB5QOr5a4q5pTQPF62SSAHlGLkdSSXovWFs=;
 b=lJrjZH49nAxQa3RQxPcvMbMklGsRG1cnl28B/rK+kRrOUGlZLaaiMbX6H5/KPQ5H5Ip0uRz6KbOTTS25b8++Kef8pArN0zPthkaEn/FdutY8Zx4bYTphBg5O/dOd2yPBZ1nWgSHMHaA48jgRZBE9eAAJeT9tFo/QIH204XKU5E5UIcCPnrCoguTPuQeiFM02+qW/TDG+2TfxYKoEM4EQz5IPJSkEzqnY4qnljbybgerNkavUpq7uAQahef7wGhDCuOPT55rvUT4XBpN5M3z6Jx+93zy3H3nzD/NDSobhan6+6eWsOP5X/696gTpvXNdet+9kbJYFW7nrYWr+0zzWeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxkQqjzSzB5QOr5a4q5pTQPF62SSAHlGLkdSSXovWFs=;
 b=SoX3ID0Fllp7Af4dcsGKXHnj3cuB88gYSzU4XnjkIyVaSw++e2fgkb13JOEl3jZNTITWvqIAq6xs02xUkoDJ85WWlzM/p3Q6vxblyN031NtZejGI54Db/WLzOq8fSk39Ks6AOZaahzlCNBtE51zoBOOOUQgCQUMWCIr9VkamI30=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 12:16:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 12:16:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net 2/3] net: dsa: mt7530: remove the .port_set_mrouter implementation
Date:   Thu,  5 Aug 2021 15:15:50 +0300
Message-Id: <20210805121551.2194841-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805121551.2194841-1-vladimir.oltean@nxp.com>
References: <20210805121551.2194841-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR0101CA0080.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 12:16:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c5e81f5-3bd0-4cbc-971b-08d9580accc0
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62696944A932455BD7CBC1C9E0F29@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkfbnVOrVavgqTXcgn8+RK26fqfLAa80ZFI3deS2oF1s6wE+e6ts39sdpgm3d25cdsBn29vZufl7ASoE29XFHdUrxTRK2qyV+yZmYas2GyU5gLbnkTE5L+KqkxdEpJHKxS4rXMqy/7qDp7cHnzqnWcay7RLFa7cKiR/jFvZ1ecqqE/uKPMGbyV6YKrkegVw5q5VGxplUtmcfEwVw3wMKd4FqOdSWAR1ZwhbG8RLSVjgFYugotcBu1y83pFZeMaPevl/PhWFLUKAb+2eJkvV+jKjpfhNqdTVXmDpB/e26eoxAxUwMqxq1OWLhWqeejdCQ7uG5SgY4Ze3I8U+nfp6a2zYf07Hb0Ikm4NjwkfpMzoufo3Jai+J3vi5KTDJIk0tZqxLgOdkoRnh1y33LbLSYUuc0iJxbe39CW30byaY5wTnv/XU5goFkpHbS+3ZFiyAWmaPrK2bT76I8k6dHciIRJLfqabhXWckq2mshmqikLmKTyUxdbG8gqb+gs5l2nShkzX+uN86pBWnfHAEbEdB3Fow9VyEButTuXrEwz0t7srRMxeNq/U3qUurBe9d8U5TUBm90COUda+adlRYdwMooyuv5TyKd9zgWyQfNJUws9J8YnbH0msnTNqCcFgdJTk5TFjenEdgehkVsTkp0ca6Vc4QPLgM1zt22OM2MPXN7bBDGFTBBuXaZnDfef1/5qwuhXIOiwj/gqdONvXiIQPcEhmVXMA7mvwmpvnPUjs2wopI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39850400004)(396003)(2616005)(110136005)(6506007)(956004)(44832011)(66556008)(66476007)(478600001)(36756003)(54906003)(5660300002)(316002)(52116002)(6512007)(83380400001)(38350700002)(86362001)(2906002)(38100700002)(66946007)(6666004)(186003)(6486002)(8936002)(1076003)(4326008)(8676002)(26005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mQvw4KInQd41Pok9RT97qc/9LKIVseUz5KNt+HtXnnQZ+a/gFsthQCnjwp5U?=
 =?us-ascii?Q?flA5hQecX/CYUWxfQTceS97Ms8o/jiCPzfzO2E3qBmMX4e00uJ7elKAUYRH9?=
 =?us-ascii?Q?kJWm4C4aFQ1SXn4aEDXr03ZrSYSGpCqqu2pPA4GUmHvhNndOmtx095rxuNFU?=
 =?us-ascii?Q?SPdCGol1B5h+09NDJthEigyK3q2F1fx4GHfHxGn6tKCYu3KkHYTfq9o+fEZV?=
 =?us-ascii?Q?RoKEXN4fuetXlqukL8XhCZWF3VE99VQaSmYlbo+wxY5LgyCTnrMApe+jTfL1?=
 =?us-ascii?Q?385DArVRtAXj8uW2CNyzvLdUbSO1IheyJ96aV8FmxWJ8+a3oN5n8/BCjeT7O?=
 =?us-ascii?Q?h2uwD3snaSaTykB/8hxNxZIfZAriOBm+GiyuBbmm7fomej/L9Z8AhnJIj7nr?=
 =?us-ascii?Q?cDonM96bCKxlkV1B9BG8LvlIL575f/4ZXqUmdxVbF0O3c0TDC+1VdtKdFJmZ?=
 =?us-ascii?Q?vL5aTd7LHcIx4+mfZWAQWr4h7Fpt5I+zS344GCY2wPqWFEZEcQogvkbcg4oM?=
 =?us-ascii?Q?V75jXEQxVmFHkP4gfK0Z4ag5TrjQ+T+agivgc8LU74Pe4aYan3b09hk7qHZU?=
 =?us-ascii?Q?sjDaWTONVffFim8K6w93+LZwBQ/ZbF15Fw4KnxAxfMQhpwPpxjDFNL3hi4WB?=
 =?us-ascii?Q?gaSMdGiugogfa6vZ/k135p39dhrtVO91S+IIZxSVbkPGMjC7GTMwxduZp7VC?=
 =?us-ascii?Q?IhNq7gVBNTnPGviWgdGcZhVpfpt/OZLPcErkoOBVNtbBauIyVCWWHWMqvIO+?=
 =?us-ascii?Q?ERIhqsnm2DEeevC2rEyN6zmllEEEVmV+7wV5fjQjRju6BgalfRoJ8nvW62f6?=
 =?us-ascii?Q?irhEdAEN8GLMNj0V4Wg+Jj4wH8L9L7h3XbMzMk8EsPXCr2xCEw6IbA6d/y7z?=
 =?us-ascii?Q?TNe7xR7LB9JwYKFqpTXNs2h62UrnFWQUwK1b2koCImtpMe1dHYTS8u78sqP1?=
 =?us-ascii?Q?qrrId5Z04MttMemoILAnfq9Mb7LNNNMIq5y2rKjyNwF3xJWVCcNZLs72mLN/?=
 =?us-ascii?Q?8TrzQn7OhvuAioeU6p8Z55i5l2ACZAZssRbp2cJaiKuDaTf3JzkFg+J55eJm?=
 =?us-ascii?Q?WFoOqU1PVWY1L8mSn3ZVt3kKezdqnQrM+QKKzJ5LO0nEli+Vh2o3eRoO6o+i?=
 =?us-ascii?Q?S9nk56JAjVyat4iwYaXmafkOjdY2Z8xuxdzYgci1Z9+l7iySX/1Daf0rtZ9V?=
 =?us-ascii?Q?IR1Gy9qRtkjkVdd890IMMpochHRDDCdXbhTUwlh4wzd/H1E7b+AfEzuUKMuJ?=
 =?us-ascii?Q?cZs63G+WhU+3+X4yB0qzNj2c2l/7wP4lEJhBUClFIW9v3gSpQ+kZnKZ1ssRU?=
 =?us-ascii?Q?20xqSZbmRu2pfXyzxPSY2KM8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5e81f5-3bd0-4cbc-971b-08d9580accc0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 12:16:05.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +o4xjcwMGG7MeBvJRDCKsgc+YW80H4oCs1MeeAqWJXmYoOctkDCnUdsT8Yybe19Owegg/o1q01Akg/JThlM9ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA's idea of optimizing out multicast flooding to the CPU port leaves
quite a few holes open, so it should be reverted.

The mt7530 driver is the only new driver which added a .port_set_mrouter
implementation after the reorg from commit a8b659e7ff75 ("net: dsa: act
as passthrough for bridge port flags"), so it needs to be reverted
separately so that the other revert commit can go a bit further down the
git history.

Fixes: 5a30833b9a16 ("net: dsa: mt7530: support MDB and bridge flag operations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mt7530.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 69f21b71614c..1f9a6b12bc7c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1184,18 +1184,6 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int
-mt7530_port_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-			struct netlink_ext_ack *extack)
-{
-	struct mt7530_priv *priv = ds->priv;
-
-	mt7530_rmw(priv, MT7530_MFC, UNM_FFP(BIT(port)),
-		   mrouter ? UNM_FFP(BIT(port)) : 0);
-
-	return 0;
-}
-
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			struct net_device *bridge)
@@ -3060,7 +3048,6 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_stp_state_set	= mt7530_stp_state_set,
 	.port_pre_bridge_flags	= mt7530_port_pre_bridge_flags,
 	.port_bridge_flags	= mt7530_port_bridge_flags,
-	.port_set_mrouter	= mt7530_port_set_mrouter,
 	.port_bridge_join	= mt7530_port_bridge_join,
 	.port_bridge_leave	= mt7530_port_bridge_leave,
 	.port_fdb_add		= mt7530_port_fdb_add,
-- 
2.25.1

