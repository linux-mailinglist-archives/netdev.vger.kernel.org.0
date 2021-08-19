Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A813F1F47
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhHSRlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:41:12 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:62067
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229728AbhHSRlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 13:41:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmtSvOtCCGlxNfEToKByN7MY5r/5thBx7ctBhG4qfxm9nvxnnMEm7XNjbt19LUHHs4Hb+IlDX92oN1RmZyTb67nmUaReoWooIzUaGzoCOL8FDcUmg0DgS0n4HJ5Al3d1903OqHcmqFODtP4Ew7sLkvnSWSAkyOk+PMZCYWpOb3uvA/yS/quX819OuuPkeK5kFnXFBy9Qgm9bfVklxIXS7pSLNVxZbP81RvITRrZnkej6XC8Sxg40cImN1/ypLHeudJsERLra4WKYsAuYD81Q8gnCG/tOcuV3KXSRa8l8MO4NtA0BcXSCedEpRkXWcIN3/NT27u2PG8WPzdgkwWgbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pc+jvJzJUl7qOi21ZEvSC0rZojwOthvCFeOFeDO5nYs=;
 b=XZ7pO5JmYI+yOJ05OVfDflUB8lQ+SXaDODuoZDhl+vWbpjaUqY61PhBS0SE/Vek/i0NzMi+pShnMGXsEnpq9GOyOS+3tj0UnRQ9mwaKdGdOW93cNxWPvY9e43CJ7aX+Q9RmRa56du6XziutZojmeXJNGkUzL9OacmdNftHwn95oEdMFjpGlpVVXnHsVROUbhtd3GZMkjwlJ39Rmv/2UbtJ1ML1uXHFBqny1umMFPtFAf6OhOLwVIRg7z5dM2SbVgkI482CGatRnvonZWMsBtoRnJ3C9QvjkvwocMsCNfyQgHs5n8olaHIrqcVJoKzTZGjQr7Q11ObBf2OC7/5lqDOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pc+jvJzJUl7qOi21ZEvSC0rZojwOthvCFeOFeDO5nYs=;
 b=apaj1gukLUZACcN9i6/SaEa5ELWA6AQLf0RHVrvJUgnIkFSFVhbvhVtZt61sJsXUISjFdKPyGASFLB3njDRDEqldhyu3RK5Y9nWSzNuBBHklGdYPcyQ8mKgGtzZjBdX6uzHU92OwHyQ9HMO4WL5ZPDlgFO2Qj4R2vCbvytE+8OA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 17:40:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 17:40:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 0/3] Small ocelot VLAN improvements
Date:   Thu, 19 Aug 2021 20:40:05 +0300
Message-Id: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0191.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0191.eurprd02.prod.outlook.com (2603:10a6:20b:28e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 17:40:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 930a1eef-92fe-4f30-8809-08d963387138
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26866DFC6D1C8C30990D9204E0C09@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6F6c8vR6YDKC3F/dZ4WymG0JWFZE+jgS20CgRANLN5cePyNOY6FZMv2R1/PIlJuYJ3DIXDg9IMqNYdy8MJgP5pYgD+cp1d0w0aqbuPehWaxb4SkR+mRlSOM2NwK8D/5OT4kqe/jOdEqrvlw2rgoiJW2XpnmfgloePnR42KIIFITQ4mlaaYjccEMc15d9nna8m5Xi3lq11wQiHqTc65SYGlIt/FfjOKsP+MZ1h5RWGd4JDEfFj4uYhOGmfaVQYNBd4khn7e1e6Z8BxMFcJpvE3OSG0Hcbm4ganNa+WfXPCbzdGrmVHQ3gK8SgGn4YfyjtxRfltQjcIKlOpcvP9yh9LXngZGTr57W5Y6cG+0cvl76lLz3PXiyahQwM59Zd8liLji/8pm8FXag/k1SohA0GYl/3HRexqzQ7ztVn9fdM9AfnhNy6gmjPgwRIRLo9QBJRhcJD7UdGtd9qVGF1DvR3npgVJPt573on+bpXPvn8esXbPnttqFji+EJBeBlmsfuGCdtyimddoXCdJjfrea4T5V6wNJDWYnjlQve1cBLwBh33PA0oXdzbHjJAwp6k+yGXkvwK1n/BycKUais3oMZx1LZewTkjJhbPLgzszFETkJxLGStBYwQF1e7SzEJlAt82T/MHrjryrOlQbGfY5lZXvvnDeSgRZkgkhxB2mZTIU5SgDeux/bjPVOXIWNLJpye+4bqrZ9593oVpBgostt2+gi0qUh8f6gQY+BJfINJBT6J8DgkWY0qlIkB3IApzH7Ay8O9Dgwyf5hheZs6bx4PlEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39850400004)(376002)(6486002)(966005)(316002)(6666004)(44832011)(4744005)(83380400001)(110136005)(54906003)(1076003)(8936002)(36756003)(186003)(26005)(38350700002)(8676002)(5660300002)(6506007)(6512007)(86362001)(38100700002)(4326008)(956004)(2616005)(478600001)(66476007)(66556008)(66946007)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kTUnhYxUzAGZH8bTc5lepG4RrpS4MseCgsyeCdVgUynrUGVzcNtzerXZFhBS?=
 =?us-ascii?Q?npmwrCaWkp55L2EgaokHd3dE3mCX1f5DfD/sCpJddZbzFTTooa2E+PdFsoga?=
 =?us-ascii?Q?xwF6pU/MP1EbhBC2smvUMRHrbmqSKbxNwSTsnOk9SNf/uPb7as0f9rcHHOW6?=
 =?us-ascii?Q?dv2MmQoX2mqUuhO2wppOFD+RwOjp9Jycs6RdEhenSJQQHRAHA/m6qJUsZE9j?=
 =?us-ascii?Q?1jLoP2Bag7OU7nJ6m1V9g/G1pNcuF8+j+nQtn2jmILA89iXe74dLs4nxwmsK?=
 =?us-ascii?Q?hScX93xmStJcsiQYMVnWgPD+P8nB8HmcJorTQj8CtOiVNmmLq+5SPLk6YIY7?=
 =?us-ascii?Q?3Z0d37dmJeWf5VqynGHaky9x6U3K2DCHOrU2Rtjh1FsavizXXV/sAwSGxNid?=
 =?us-ascii?Q?LUdsX9GQ8V+s2Zshdq6rYdHKO4EXjwwPhYkdZKf5wFtfIaHgys4VGCFNvH6K?=
 =?us-ascii?Q?nVTEqo4QIkGbQjKQ1KMApWJrl37AV2LnJ//6foJqO1EHQQ6xDqwfKyzwK6Fp?=
 =?us-ascii?Q?MKp2H1a4MLgKw2u4B+RS+OlQ09ugOXLBy8VTEn4hDngXTvfOmKuUqaRlEFjI?=
 =?us-ascii?Q?k5vh8XoBhREtpV5BPvRrZPmNgFFJ7ouv3a6vwkyXo3T2OKT1sdaoT421UJD5?=
 =?us-ascii?Q?5DEoNKAOrmp9eAKs7tamKUnraJ6oJfubhwBF0kPLi0A4LgsfKClcvRFTWddK?=
 =?us-ascii?Q?QiJ86n55I7q182T/2kd6woxJ2zFHAqapwxhJYNJWF6jd0nPDNu0rzgwksMbU?=
 =?us-ascii?Q?w6w3PdgQyBN97FQGf/wS+sgAQlcq0vTSHqqflQgN02STv/f/hGSbbpNS8f6/?=
 =?us-ascii?Q?6T2xrhqD1DpoYH/XvSm495hHqJ57WmrLlsfarnbWvZjkswmE7gXKs1nGiuAb?=
 =?us-ascii?Q?uZFLnaK++QahxJ1/XAqwLxncH6OJ+NZ57JxZM2TQTefO0pt/dki87DY77zFW?=
 =?us-ascii?Q?R0qy5e42SJoTkUjXct8fTyLkWriPCammVAor846a20BS9CvQzwwaiStwJ0Mb?=
 =?us-ascii?Q?8/pQigt4BzdqBgVPmtfOF8q+VAV+KaUI1x7b1LOO6EGgjYBeHmkE/5vK29I3?=
 =?us-ascii?Q?tQT847jOz5yaqPpda3k/OFuYagxQllvNdSBoRvnPq3AX5q+fbzk7W60A4AMs?=
 =?us-ascii?Q?Tw/GGIS8PE808/5phvwuVP1TdFEf/m93B1N7z/W0q6iw/5PIdJKrU/Ll6gJY?=
 =?us-ascii?Q?/ejox4V2SCnZpbOO2ucPSsN7uSG3fUswh7c/whnlSLIoh+M6/No0A+GwUkeB?=
 =?us-ascii?Q?vhUboaY3C4ONZF1CWrm7O+VsjfKsQVmuDle6KyISG0Ev0ZftHakAHAUx6vVT?=
 =?us-ascii?Q?T1efJ8hGtver5N5cwiwkKQTs?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 930a1eef-92fe-4f30-8809-08d963387138
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 17:40:31.9863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HpgZBUFuuPpRRrT9vBx346mg6nZD4z2cW2k/dr9jMO8vH3sfR059xurtgfZaC6ss9xBhi5Vjjli/kXIuGCPG1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series propagates some VLAN restrictions via netlink extack
and creates some helper functions instead of open-coding VLAN table
manipulations from multiple places.

This is split from the larger "DSA FDB isolation" series, hence the v2
tag:
https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/

Vladimir Oltean (3):
  net: mscc: ocelot: transmit the "native VLAN" error via extack
  net: mscc: ocelot: transmit the VLAN filtering restrictions via extack
  net: mscc: ocelot: use helpers for port VLAN membership

 drivers/net/dsa/ocelot/felix.c         | 10 ++--
 drivers/net/ethernet/mscc/ocelot.c     | 73 ++++++++++++++++----------
 drivers/net/ethernet/mscc/ocelot_net.c | 38 ++++++++------
 include/soc/mscc/ocelot.h              |  5 +-
 4 files changed, 76 insertions(+), 50 deletions(-)

-- 
2.25.1

