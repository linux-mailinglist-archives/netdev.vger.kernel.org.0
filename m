Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9535D2DCAC3
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgLQCA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:00:57 -0500
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:13120
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727337AbgLQCA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 21:00:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMdnnpE1JeUdaOYCshonIJuZo6kT9IFWFoGqmO/RTIHg+pptEflbW0rGvdIuLnuEWE3XfkZ0OsKvj9Nxdr2cKpse6PX9GEAsrkxhxzLYhaod+iu/K6csTB+TAKb8F00+fTJg5OUTRXKJZDiQYqqoFYnvyh/B5fmxdaFEXBoyJiMy59VIAEXDtgIGLzrmlJVnWr3mG24s8Yro6C5ZlFxNHRpDmqycLJD6RdnlKQbEx6XHXv8w45fypVHYVlSAb7hX80z0WJ0Nw9mH5ykgck2G004CUtQeQXaR6jLt0v7I3GVBuaNWGl2Gsf1bQYaS63pWWnUmiAm1Jsv6yOSVx3fK2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWlWq0Pfm42J1wKNzuIkNhiX8T3koBrInU3j3tmX42A=;
 b=MfKOT9wN/f3e6qVD/7TrJat56nLhdVS1rIgtw1N3PnKlbt6baHIb5n0Ydyyg1+y7Dd9pjLZyMisZ2KPSgnPQMU0K5aqnABkrrzCJ19FIaV2+3s6Q1DkwXFZuVzl2NalMn/epUMAhHDkQQeaqcjIuSXxeQFalm6MLf0rXCci3jxej4lFEOsWsjxRk2uFYtdxK64ZhSOyF46gNpKbPkBXOdYr+g3OiQ3wxlMy4FDAE35y27zmz2l9/48Da7g6NCxonxyGoCwdwo4FQ9x/PboYpOwA06ZJsuOB9l099GBcmMbMLSHPBF5VNFmGQ46ihFVMsiiqH+Lh8px72BJFINf6EZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWlWq0Pfm42J1wKNzuIkNhiX8T3koBrInU3j3tmX42A=;
 b=jXTVL6asxD6lqOdkcCP45O66RL/4JOXlBw+t6TfHfWU+DQuNNVYWLQrkLgM6ePaGIk8/1pGy+6eiFjLBMIWzoVqZkH4fZA8rV/JDJ4vqtDLEmdYgMM9jIzNy1OiZSx3ejdpZXbvQVX8fZmSAR59sdWcBQouUY+WiP1+jOkC53HY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:11 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [RFC PATCH net-next 7/9] net: dsa: remove obsolete comment about switchdev transactions
Date:   Thu, 17 Dec 2020 03:58:20 +0200
Message-Id: <20201217015822.826304-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:803:104::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 42a44f37-ef14-4bfd-e500-08d8a22f58d0
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69432AF34BE3D1D443851FECE0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkn8qBwfn9jB8dSYfDUCXrvNIle35nO5OnMe/7PVQJHc0uR2Hx1+YCUEslZ3i4RnZ5q3ghr6gayD9G43zjztqGlqwq4Jz4QgurSVEN7nGdXpj5HsKZ9nL+lDM0hdFiTrnHWBVEisk9K5e25b1rpy37WLw03YqEXjR8IFeHJPM2UsNtFJn8C6LGAYTW2xpUmHlfwNEyV/GwdT4SLaV1jHjBDV96f+cCW1g9EdfhLQ7RxrXj12Xb18EG2o/hcUVDw6hnh3aI4x5BhXolEMGhgkh1zzgt0SWH3avbLlBWOXGrrexRdoSgvZbGW3nubA6Gw9XVQ/TUe9A40l/CC76yG9vCFdVhL04hZXI6RngRDm9sxlqleIAb/ZHjHzeMnRLvq2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gY94dh4/IIKwCFbvfWlPdUhgcKfhheDqdAyNglke8M+3+jdPikoC1Zy/nyfg?=
 =?us-ascii?Q?0I2GktROrYdJ8+D/AIUjlfuxasBYzAxeYeJuzFhrLiUC5IJXxwywHOAQZ2kh?=
 =?us-ascii?Q?YdH97KEKG56UGmSZxO0qlKXAm3nkjnIcPwMNofY6Dtg6uuezd0zAzoVPlR84?=
 =?us-ascii?Q?Wuzxxuzli3DkJWUSLiayejTYPD8SHfGC7tN9H7ZJlftGi8WwCDJUX2v2MRJU?=
 =?us-ascii?Q?VoIMjfOsz+zOdv1PJOPqN7JvykaGedzm57JV3Ci1fB+y5MDi2M/Pg98cbcO9?=
 =?us-ascii?Q?1SXnpU52YXUTPUfgIBiDL4W+gR1Qh4kMnQbUKV0qrysm9P75W0L2ckL6yV1p?=
 =?us-ascii?Q?r0SWnJQ3yu/KXavnY/Sz2KMv6yumyYXOfM+reupvXCuvuqwzz8gsHpPlaILl?=
 =?us-ascii?Q?PyEvqX0P5V+cz5g1hS2dASz45XgKJ7mmne3TsT9W0aFO5x71PKFUeIPDV0v4?=
 =?us-ascii?Q?tKeMIA/+N5evnRjXmMrsjSTVKnDmUjhMMf9Mr+TUI0p0IWe8MpNaGT9znPm7?=
 =?us-ascii?Q?ofjna29V+r00IzHhO2XNXqiBkJ8aSoIqEPA5skk7KthRtoSuwifxatLJQaVv?=
 =?us-ascii?Q?88ZUaqVmc5+Ly2pbEW+Q0RJAjebKsC4oFiyCGSH61HbgoPbAmJllTSpZz5C3?=
 =?us-ascii?Q?0Gv4FeWXuZ3ojKwZFMJqQbkjE3Cz8xM2Khs/xlf5ntRXRZEzPX2KOsZ0mZqH?=
 =?us-ascii?Q?ugYkzxhYogi1t67MvkGdAIDz1/WN1x5arHMEPV9XcJVlYFEQYqUyx3kNtXDF?=
 =?us-ascii?Q?cw8HTnyT4Lj3vtlSlHYRHx4rgN1tsIEf3LJBHltofukbJwPFyTMY8/JDgZoI?=
 =?us-ascii?Q?i0KGw0xAANDcRYFEvPQVqb2etmMsmX+jG67K4XLCl2DEbq+MSTCMPZHxAaiC?=
 =?us-ascii?Q?R/Cj1HK6cx1DoSQk+R7xPjAlVM9bm1pXN2FvXPItJJL1mdXWU9kGpuaPRjA5?=
 =?us-ascii?Q?UNF+u6K9o/4v6v0V2/X7d7VFdHpcwPhOWTEYUTgePWI8LVXDs/kCSYpkUh8F?=
 =?us-ascii?Q?02F+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:10.8633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a44f37-ef14-4bfd-e500-08d8a22f58d0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8GWVLmmHnn/8MnolGFEAVL/dFfmQ+ynEv8L9ItcBepmIw0WPvqp2Pr7XeDrDQpEc3Su1cc6zRAlvRd9upm0Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all port object notifiers were converted to be non-transactional,
we can remove the comment that says otherwise.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ffad4324c736..c5f38bcaa5af 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -379,11 +379,6 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
-	/* For the prepare phase, ensure the full set of changes is feasable in
-	 * one go in order to signal a failure properly. If an operation is not
-	 * supported, return -EOPNOTSUPP.
-	 */
-
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		if (obj->orig_dev != dev)
-- 
2.25.1

