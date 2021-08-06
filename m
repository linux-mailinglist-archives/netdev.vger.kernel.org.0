Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD37B3E1FED
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbhHFAVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:21:00 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:14702
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229997AbhHFAUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 20:20:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjfaBZSXxv1D91sWxucHBnSdrznuCbFG9L3vYZM1QY4aWoFXq7cAkOz6Ztg5GmEY2qHB77fLJYq1KsNWIgB+uDCEudBLNcgSh4q/Bp9aVn9cqAhXceNX9m7MwKMSHwi6ZQJc13QocWUvbjOHSwIWhAJKQMVSH2qaxyNuB5mkTHzdc5Q6yLRvgGhl+FqBsnjEx7klVuiiJQ4/D4ISK7rI9JRgO0VohuvwSRIWCt/3jtUuWC7JN8sj+jsH3ozA5bxilNQNfMRA5aIdIpVak+llMikW5CN4cAgiICM8FaC0k97cHnxaxNdy1IjNovq0cMnlYIwhN6Hp2EQ4Ugt4vYn3mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9XfE+bvt9Wenz8opiU3lBKNTxMh/881U8eLtN+csRs=;
 b=MZKIwZOYC624HETvsxpTPhzTdINiKosGDLBU4OO9R+H4Yi3yBzDpfLl2lwiwxc98ssYiSJM3TIbETb0eSVmHdPrFAGis89gpfJF07qraUx4t7aiTkaHVML2ndJ62+KRD/zYRpBPeo/hSMbHlgdrWYq+IblSp7b8biSno/7rbl1YsiAJYjgABmfyiXS+6n9w/D7Fq03zXaMDomqktMBj1J8hJBWQPP7WR6g3sDYtzaiidyCzxoPCy0c1F2UNbSpVSTP3XkDbIttFJ9tx+8YliEXEtCM44FAGdU7uwCCdPlNbxCaxtE7D8P9QikP9I+17G42K4qSyZrTAiooI85AK7oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9XfE+bvt9Wenz8opiU3lBKNTxMh/881U8eLtN+csRs=;
 b=aHFY0HlfXOV/pfCyantxrYMlrFlUkpSwCZmkHW19XDFpXCFD45TMZ+idrMpQe3JYLFecaHD/LmXp4z05ZQJAShYJj+35HUfMbJn0Rr/7vSmCVUx1tCbnOYfsWaE9xvkWEDRjAwNMWf3aIciHgt3QCtBnR3h6klKrUZ0X9+d7RyE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Fri, 6 Aug
 2021 00:20:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Fri, 6 Aug 2021
 00:20:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 2/3] net: dsa: mt7530: remove the .port_set_mrouter implementation
Date:   Fri,  6 Aug 2021 03:20:07 +0300
Message-Id: <20210806002008.2577052-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806002008.2577052-1-vladimir.oltean@nxp.com>
References: <20210806002008.2577052-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0087.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0087.eurprd08.prod.outlook.com (2603:10a6:800:d3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 00:20:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70d794c9-b821-4a09-059a-08d958700422
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341E3E6C29BDA7428B98BD3E0F39@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZTmkXIDVOuJJuzBm+e8y+uqR5K18Nxoz3aZ9MT0MEBSXELXcp8UAKDPm0ye2HTRrBFqv/B46sY0Fk2DEnJGfSTV0Yam4sNHjr6t/yS3z1kPkQV87e83CMJsGCV/YrJ8xPH4nqVOAasJdhWlmoTp10S6ZEth8SkZ/wMFWvYFkZLc8ABzd9kcvglaRxKmAkYPg9pdVhNM+ZfdzQr8MOASW8iEZRZXSxzPc/1YBkryQul2pRZdHpIWxiVrKohpDo5tzCYn3PREkd71vYUkqZoVUkS653mratlcP+39/Gy+Ss88bdT41oGQ2W4s9LFQSD2LiAbjALAsiP2QNv9XA1ZM18/Nuo0UjgbgeAjwYDmtKYkNei7tpp/V6OFyZ9YrJvbAfSQVoPD+lcFNsIoN2eAOfjmjNe9hs+cSzSaBzsFDsTU/jgeOrIs+Cix71aufLTW4BHu4oViEGqbh+pPSiFwdpgBhdA1XCqQSJynwHLswVcszraHULboCZ04U5+NsG7VbJm+SFClmy+Aat3tj7OBKJqq+qy+cDA9JRDITJrVN1P8f7lsTGnoOvfD2QU5bAQEamHvuhY0YI5IcswO+PU6RKSTSZVmzQRtxVVbGBZrVKyLhzIiKEHTU/KfRJ844L+pNn+ldlkyaT59eM/ETVOvqfQzDjPrTpoIACpKi4xtXVc+sXgSixL8gj4Z4exAvhFATZNyi3WA6f62G7ugQFXNdfQJG9nEE1NRd/5h9lB1Wifo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(8676002)(44832011)(478600001)(8936002)(6506007)(5660300002)(110136005)(86362001)(316002)(4326008)(54906003)(26005)(186003)(1076003)(2616005)(6512007)(66946007)(956004)(83380400001)(66476007)(6666004)(6486002)(52116002)(7416002)(38100700002)(36756003)(66556008)(2906002)(38350700002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HL0MpiDFU88zMhvV8B5UH8zl1rsKmW7PXcXWJiB7MyCQZzyGt+YTUSdz94to?=
 =?us-ascii?Q?2wLKjXMnKCoNN/qmuqWDCfTOOqeljN1KulHvx8w5P8Pbz6TtRu/8qfvPOMbq?=
 =?us-ascii?Q?WCVgQGyLNbV1FCw58fi29HWlLYyyClqhadBn2GFMfgb58pa3AKB9WmNdfI8X?=
 =?us-ascii?Q?uTHZYTDKI5GrVqrl2RUZWdEv8VDawnvRd+wGVOFaMGwSgqfhHs3XCM0IFUxY?=
 =?us-ascii?Q?GNtO6NVV2CSk/gWLcewxyyLUx1FaucMq3GXFw/608QbqcVwgOyfxCplS4gcJ?=
 =?us-ascii?Q?arXaHVQ9bvqasBXqRnSHyKg6B1WYpPEYx7lvX9e6EZ7HNQhza1htGdmIc1jB?=
 =?us-ascii?Q?+gPeoVHUnzyUxHXn+zOJOYlJ5LT5gIgHsdVh4cAWiNpgpFtzslQkCxMhLTYQ?=
 =?us-ascii?Q?O1uxRouZpOSHUQlCpAUktrgfAEmYlSAMbtUFWbWWinuS00V231TDf9B/M0f0?=
 =?us-ascii?Q?Z1CxehwMXteCilZoZnExCjfbLOTVgUfL6qrTwhs0KS2JJxNlTAjevSf4G+4O?=
 =?us-ascii?Q?EyapPwK4SYdIJQxcWmdDNKv16yvyilEvkhyf6c2wHo7J1X4kRMt7DOkGe8m4?=
 =?us-ascii?Q?FBV6a2XyWP+T+u7YhMU6YWOc+YdGPZRo8UlhjgV/LqS7DAQRIHiRLLTORBcD?=
 =?us-ascii?Q?UHd2xMBmYVZ9R4GbOXujIbF2/atYnrK15VBysq7G2crKlqEqF+rSgMWMevNE?=
 =?us-ascii?Q?fPo0fCYCGVE6Te2Iplo0pP6UFJhivQceRAJW3bkRgD8NPEfIFcfVGCMY8nns?=
 =?us-ascii?Q?dC9ynlzSnyaQJDeipxBY8eeZ3FcpkQGXHtYYG0mC2pC+sHpcMOrxRBb0GrdT?=
 =?us-ascii?Q?E8oeNLYuSKnViLEE63zOQAm2vEbIkyZ7O6paVIs1CbmvZxHrdefhAzon4zE3?=
 =?us-ascii?Q?VHAGxKbdkMPbNPhddk4vY4s19ut6dmOj6/9oNtwtXBqAgOtge1/D58Dm2ejV?=
 =?us-ascii?Q?yoFeWeM45kwahI16k6a/47FIMC1rAgs1cX/HjFLpYFxowoRWRuUYBN4yxueV?=
 =?us-ascii?Q?YQe1yJNlyOyK8BlyleYJipTs7FSFiNw1cc7znfkXur1LcWFF4VjbA4C16dLw?=
 =?us-ascii?Q?w/Kvygw4aMs6OLT7+d0Si09mwsJ6rNjQeydrO+AnB3FX1oqy2EZzmY79Rr53?=
 =?us-ascii?Q?gHzo8OYRNbBZRdd53ELidJRrdtMPHoICdjAoDeZNd+rKLU5FJLrNwAuKdrb9?=
 =?us-ascii?Q?M4ewCwxeUvEQ55l76Ytx/LLbid90n++S9dbLON+2xR1Z9Ne4Mb1DS3MDCAxv?=
 =?us-ascii?Q?1ffuLqGJhDjdm87mUB64H3N1kcXa4m6ve7nlwaRhHP5eqPbnVNMTekYblUma?=
 =?us-ascii?Q?+Eu11OvoQkoxznpDxe4q0eOm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d794c9-b821-4a09-059a-08d958700422
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:20:37.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9plMpO49bXCBePXuZXYA9n9GXpU1rSwFg56NGs1L2kFv8nPNIIiTFY29MZfSdK896Idk+4LDsrA4HtFAFmiWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
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
v1->v2: none

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

