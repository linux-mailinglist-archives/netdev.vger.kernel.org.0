Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2FA42A37A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhJLLnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:14 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:6177
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232665AbhJLLnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xyjnc0lUUnjMcFM7kwboOYT5yjoZP/2XBVTSQmznQZpC1Z3fJV5WK9kjF58qLUtnnUmIbjAtPB6rj36uZLW7EuXlTHndY2UHKQh2gJ8/W1oWQjtHfFM0mQQLSqSDScDO44SMkE/6k53YmMixDcqjhGnRqIkVk+42FquUDsIncCebDohT5Su61SSVWIsPnGz+XK0f43jw7yBa71mn6SbE+qaRO+Gy6hvUOmdKnSRJBzBE85WUfh0VmUiJlcm+25Te8oyp1aYsv3pzuv1HktdcRqid8OAJqi+wVjap1BItswJ7sNPXxqF8XDGiKroNp7QWOIJbaMKGNm7fqHqoyTJnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzaIVjPCSiPCf5QFWTDyo/kyRzd79Pt3B2B66RgrB3Y=;
 b=b1W42EhNN4hIs+kUIjSCmzmlYcWjpcim/VgzZla3DehkZml+7YAob+XIkNoEtfQyOWSnXNlLog8+0QF1pgdgKc6NtPWScdPfYstDpqrefmiqwOPP7acFpn5v8oNoswCSet1at1zh9NyrwQmSycL2GZQtE3epP6AmZ2Vut2R9cwszyDQCfLioujOadGyOsOoFWz9tFiGF2Rv9hxY0joUV4VJkReyxJmDhuKfyPfjPo6RIMTUotz9LEO+hr5FPwHdZMMlZya9HODdw+3f8vt41iZnavTlRuCu71fbnzSZ4qyBJQb48oRJX8NxAHf5LMfh3n5Ln51lSVxgW07HPNEPRnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzaIVjPCSiPCf5QFWTDyo/kyRzd79Pt3B2B66RgrB3Y=;
 b=K/aCLG7f7fWFeugD2xBwHsCN9ZuGEsK9rAKvBVed6/qXFnFbxzfYR2AvAYG5dBijJqGRjnMkc5Pc+CRcGKYHe/yRs8OOljwMNF1VRG4kYR5X+dbpeyq3yK8AiJP7ejVyMMxCqGp8lmMZZjhC+upnFY/u5fXI8+8O94jEu9qaJdU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:40:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:40:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 03/10] net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
Date:   Tue, 12 Oct 2021 14:40:37 +0300
Message-Id: <20211012114044.2526146-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:40:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acbc7a47-ee34-411a-7c79-08d98d752851
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3709366B2BEBF0CA07BE43A9E0B69@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMd8MoB7a+jnJm66iFrDDhM7mICS9nuueqQmJpEN7DfHPxBqJO05lXzkeA27I9LHlEpwiTSIHG6jtYnkd/DtP+IA02E9/lmfdtAGmv2ZLlVU///tj7JSFflFeJmzmLGK5Te456C2PYXAQYI8rJE7GKHH4KwhEGpp22yNvlXdE7HD5Ck/QbMRvV2p1hA7SRyfiTIqZHm/pl3r0kBaQPtlJGaMrOWQkihbXMfYYYikCxtKWcAY0vpK5X7m/QCzsjt9yrFQij2PWcpKWdASKgGfbDp9Uu+LWFyxIMTGgTOhquhY3GrBEmx64GgLmLY1x8T2U4Sqjy3a9vyFFoAj3iypJDNeSegI24/sVBpa6bb6hYlx1RnzYemR606NIcmVlK3OQDZ9efF0xqmOyQXW0k+BTeJ67VLoIGG8VxwP6NimVNQJB9wDbU/5KBhu7JCCMcbmaIf1MNtO/FmYD6XaQtmu9o1VssKbKcReoqza0zo7I2GpskFSYmVrPpNMnxPSDABK9eLld+ymL3aSnyCwCXlqySHyGuX3YVT9kkwQpBhWtn47T//Z/s0NnV885TI11S8yvTBExtAyoNxuZD3pnyIg7OZBQWvUEITxO9wCQDZ0c//Yh/BOQH/XKuICV0p5y83eXLeU8jQqlEmkG2yj7gkIHPLioc2KqU+57MjdBjpeRYKP8EIFqXi1tFxj8jll4GOTJA14NRwJKOCfc0SH67Dcyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(83380400001)(2616005)(44832011)(38350700002)(38100700002)(956004)(508600001)(52116002)(4326008)(6486002)(6506007)(66946007)(36756003)(6512007)(1076003)(186003)(26005)(8936002)(8676002)(54906003)(110136005)(6636002)(5660300002)(6666004)(66556008)(66476007)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hsv8hSi5PZ4k7Ex4N0zkfcbXnAM3E5/K0/tNaP7DtOJLrMyCt7XVR4UUncsl?=
 =?us-ascii?Q?1dS0vPTjMjOtEDR1mBKSBuBJgtiwu3BfhuFRzVm0yEY7+Fike6ZiW3d1kaIK?=
 =?us-ascii?Q?D0k9IqERU4XFNTpAqGdWsbJ4N6kJShZUG5/EB5dvDYDv0OsYpWfsHryzpIBS?=
 =?us-ascii?Q?vTm4ZHSx8k/kOWAzqKrf9XVausVTe0usE8DmyEknwByzwc99fipBhvfA2ti7?=
 =?us-ascii?Q?sDO8TI2+eWS+0/mJ5yzCzelawHmr8N+sY2DT6viG9hz56VBOfXh7LSgahkBu?=
 =?us-ascii?Q?tQ0mJpZoceejDvLBgy9ttoPka+RpuZ/Ma6uBExsGXuQbWlklJHC8XcJ61N//?=
 =?us-ascii?Q?/xKDFu2pVKzGBrp8Kke9FEyv5rMi2r/5yWLV5vS2bLdxZJLQEBFO28Y4NkPO?=
 =?us-ascii?Q?1xL8b71XRyM/aq6Qd/h0XCEYkZA5zVMXcS348vVsWQW3qtSvUui7GUCDuose?=
 =?us-ascii?Q?QSZn3T6fWbxr6Iv1T7gjjLKmSWqCa0F41sYySMWYUon39W0Tp/YDPkBYk3n7?=
 =?us-ascii?Q?oFc8bJDylxv2M+TImgIZc16qWaNefMsSRf4fJt03gx3boDEfsRQWK6vENBgP?=
 =?us-ascii?Q?Vblk3zbxKxj6AsxKHqZ/EKVPpOWVyYiwARWKPJPSQWw/V9Gms+VhTqxzCNb0?=
 =?us-ascii?Q?nvWqNlaue/DgGF1HYc4CKFdsexN19S7XX1zQhOj8N5oYbuosp2Y16i1wz08v?=
 =?us-ascii?Q?hLL+++RizN4T9qEKM316baU29T77WSr6MlCoqaaIxp/MAxg+Y7FZQxc6g99I?=
 =?us-ascii?Q?QYvTusOgVxwOU11CyJbHGAbDp8X8mJUge75S/jBx9zNO3wJHw+V/wAnrTEB6?=
 =?us-ascii?Q?Tlr2aOhaECIiJb2bUCy2/4bG2Q6l4m/TJVh5utMjkhGMEM3TZMzLkTTqWoPR?=
 =?us-ascii?Q?MU9fYfK4n5lPzxQyE5OmCV1dpA9p6v5CPrr+oKhQXxVUbhDYvNqz5cJChsia?=
 =?us-ascii?Q?Pd1Txz6jHkpjZVODq+q8av6UI7xV+saEcChZTlLAW72I8N6k9hSuSQfNBIk6?=
 =?us-ascii?Q?ee7wIQ5kawFElTf2JzB2MuU8j77J5f8R8rNAklLN5W3fQKhpUMSOTd4NBtRU?=
 =?us-ascii?Q?INIDGP2wzBozQDwgodxpFRxa2czZ9f6/dzovNQ+yeqjEpf65Tj8pfmAy+V8L?=
 =?us-ascii?Q?mhrp0Wc8T2VX83PAAYxFVR/ObW27OmCtWYMeYx3gc71CXpSOSCpOxzThHQXr?=
 =?us-ascii?Q?d5w1EHxgOOQdTAztLHB34x4rWJYtjr/SuiZ6CQgl3ZE9SZJDAbXPXQW7bx/4?=
 =?us-ascii?Q?1hlP8HAxCZpS1nebCA9KwvBG2pQW2c2IRqV2LJg++6z3QRHuQX+ukzIZ/RyI?=
 =?us-ascii?Q?t/+EK5afz/LD6Nox9bk6jdLJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acbc7a47-ee34-411a-7c79-08d98d752851
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:40:57.8223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +uGLnVFcx0fMvQZDJqP/Pg/PegUcMHaX0b20Awgm52+nl2ksLY805dkbzIHqklCkkUwdmGoXvaP6K873jcy9vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When skb_match is NULL, it means we received a PTP IRQ for a timestamp
ID that the kernel has no idea about, since there is no skb in the
timestamping queue with that timestamp ID.

This is a grave error and not something to just "continue" over.
So print a big warning in case this happens.

Also, move the check above ocelot_get_hwtimestamp(), there is no point
in reading the full 64-bit current PTP time if we're not going to do
anything with it anyway for this skb.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 82149d8242ba..190a5900615b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -747,12 +747,12 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 
 		spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
 
+		if (WARN_ON(!skb_match))
+			continue;
+
 		/* Get the h/w timestamp */
 		ocelot_get_hwtimestamp(ocelot, &ts);
 
-		if (unlikely(!skb_match))
-			continue;
-
 		/* Set the timestamp into the skb */
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
-- 
2.25.1

