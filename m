Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1A42D8DD8
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395496AbgLMOJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:09:28 -0500
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:33084
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395337AbgLMOJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:09:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlTVdD1d4kJ8eAhtTZR8fCTiQPH90VuAxFH4i4qP4APCjxaLkrxsKqhHoapsBeKF3sVHr/jI5Obfho04rgx0up5uw76aukZfklRHI/YsRjraromOfYlYo595ylqc8X55WWi3zyKCUmbMsjeJ4HeHHaBdM9sg2MeSfkas5XX+A3wMpw8480qmZyw83l67CjQUsVYA7+ovBiFkgv9Pb9kgx5+Vv9YQanuTW9XT/RlRs9RsPRDfqBEINinVfBFEaTvYtzlilNgK5ghRkBy/solBiD/VSMYcafRVx2vbIOgCyIlaF6InvVfkRdIx+PTB2dYXgOvYTlAyRFvgywDO83O/hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fp5VKzBanPZiLMF4KMu2uBH38U+PHeRxncpXAVmPHw4=;
 b=FhMqQAtyyjiOHrGe5JuAj1KiYTaGqVCPzBqxtJ7cCnUJuZk/CA7gQUo9Xb0Om9JD6G2q7NG+oNFfSlsBKA18RBkd92diWY+I1jAMADJTyxQ60g9iHPM97U96MBD/veW+WUAHUaZ0E18xKt+A2RTwG+l0xTQTLInPXS2hMH6WFMKqaFOtcgBoYGKOl2eisXxmQLzqydNRZoCyRFYqX+kKHEO7abKvjHzwYyZ6MZYwXnCwV74MSfT8VdtRz050WjQ6t9K+Pof9yqpjv393F86kuqjPeMmH9EFc50iNI8spUWSxSVGE+RFrllGaLqIGln3iz1fWRU0XuU5oDg3ODk7bIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fp5VKzBanPZiLMF4KMu2uBH38U+PHeRxncpXAVmPHw4=;
 b=dpFZ7L17oVirKNnds8so1Fhkhjzu2yHQceR7WOUWYpZyF8CbXSSWK5v8g/vDpDFvnz09MU1qrpBwj4T+TisCzwsszzCdgiiT/GXyZQE/4WY+SusvlJGWxIpMohhjx3VdjEwSpRwqrQiuWyckLX93ft9uWzD9onAgIbRn6V1d0M4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sun, 13 Dec
 2020 14:07:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 14:07:37 +0000
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
Subject: [PATCH v3 net-next 2/7] net: dsa: be louder when a non-legacy FDB operation fails
Date:   Sun, 13 Dec 2020 16:07:05 +0200
Message-Id: <20201213140710.1198050-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0235.eurprd08.prod.outlook.com (2603:10a6:802:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:07:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e4de9cc3-5feb-47ef-4186-08d89f707285
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341F88D8BFC49468C1D27FAE0C80@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMvV0nDcvEJGt9ePdfWtF/zItHY4PrJQLzlIB9K2O2oughnUHvtC8lgPrxb3Dq0XE3y+KDCk8XvCCWp/JGK88eqJ5R22YyJlNJOegwlvR81G0j79Nnr2DOdTein8Nix1Ovysmmt8TZhWmoiYHyXa92SLvGUtNUU7wOvLdfP2afahmVuOgSxRfEWp699/Yzq4bWnDtGVOsJtvXy8QdlUT8tQx2Vp+L7J5Inns3YQb9d0rVG2QLMwP/e8ApZXLXZcI0zWWXtzNmWQ4w9/hMhv/LsJ2NbASlRU21i1jUEQggvGK1TIZ+VF6yGOlgtLCZJ0NInrPCten+EWCYUnNHI+lCA5sJr6ZoaeTH6ZgIXnb6J3+VuU9EyghLDYVPEjqgCh+vXfAKWIW+IiSY3n6RysghA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(478600001)(52116002)(7416002)(5660300002)(1076003)(6666004)(316002)(16526019)(186003)(86362001)(83380400001)(8676002)(26005)(6506007)(44832011)(2616005)(956004)(69590400008)(2906002)(4326008)(8936002)(921005)(66556008)(66946007)(66476007)(54906003)(6486002)(110136005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DD3zvcUmQgzBjPx4b4W8ElApbKcKc1ere/1YaA7PXi7eRiX579qegr9dO1tr?=
 =?us-ascii?Q?OQ63i8NlSonEH1rF6h24s8QCaaJ0gy1LmAsZAe/ma3d8RAU71Bg2P5RU6Lsb?=
 =?us-ascii?Q?h5YTjrsqbLZsnlCwwCSLSldFduGZx86G161rUPCkw6TXC5PvaDYc97awZ1Cp?=
 =?us-ascii?Q?p2fXDafNQAWSmU6RZTDwD/5ZKl0tb4MSq0Nfwy2xJ7JpJNqN3RBLCgsSIA7d?=
 =?us-ascii?Q?zHDhtZeENC0WkSqbiD9ujj8xmeNbkOYuT0NEsZYnClCHYVqk0elofO24FiJW?=
 =?us-ascii?Q?H6Rv4j8/yQuz3jcQsaszRgM9GkcoygdTYQwXQQjK/jpsgc4D4sCQGcMbLP7D?=
 =?us-ascii?Q?gEhTuptIgrIj6e0/rmHnFsrMwXGeKZLGqm3UF2ud+dIyoOJuP0IbHoV57u8v?=
 =?us-ascii?Q?Q+DztSPKOd+x0inVrh3U/fdyDNUhyBO3fgOT2MNl7hh+bLAURm4y6VBQ1rgK?=
 =?us-ascii?Q?7VMGE16qNB/E3SIQ7jz3NX2ymkrJkj1Lw7KxBMhlxB7oKnO0QOAabMiiRILA?=
 =?us-ascii?Q?AyN/TtyynbsZNnP/CjpQHjIYn2ZZo4gk/xGFkxpMGlL8X/mj5yzCF7QvSC6Z?=
 =?us-ascii?Q?VEk3bFlJGer7wkfUfJX0tNtpQaUV9PR7/Y3nMqbUPEaNLc/eCQfCuiXYCVft?=
 =?us-ascii?Q?if+vJ4lqp2kERlmPJWKmKgG/s4WJEVZaWCjl1+2TSQdtSshqzXeyjBfATYfQ?=
 =?us-ascii?Q?LEV/gGLTVnhwYfyv5JXN/EFV99eHYu/I4F2x3hrpUKD+ydNNHPGPUm+F5pNq?=
 =?us-ascii?Q?rtsD4RIGiWF5VlGzQZ4AxPR6D0JLzj809L4pI2lwUzIQ7AhODuVf1od8gQdJ?=
 =?us-ascii?Q?oCBRt0FFkXuE3hlScotj4m6hCFIuZJd+93D9mN1NYjUSih2xQQO+jiQM8TxJ?=
 =?us-ascii?Q?vPeUxMBC3m3Hi8HL82b6fHeeSU8Wg9NF9ig2QqkhuywoDZ7uBewOQ0sGtnPZ?=
 =?us-ascii?Q?TVM1YN8GUaGBB3Oxsp1Eh39PLsT1tOOZt1quWSOEryVlt6QdiWtJRiuSRAtT?=
 =?us-ascii?Q?XopL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:07:37.8554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: e4de9cc3-5feb-47ef-4186-08d89f707285
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNc9YrK6C/Wg0XcdMghzgLNKPiw/h1y1Kqv3Wy37tzXJ0hT6gkNukdv9wVm5DuouLFaAUi5Fpd6K5wP551BrEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_close() call was added in commit c9eb3e0f8701 ("net: dsa: Add
support for learning FDB through notification") "to indicate inconsistent
situation" when we could not delete an FDB entry from the port.

bridge fdb del d8:58:d7:00:ca:6d dev swp0 self master

It is a bit drastic and at the same time not helpful if the above fails
to only print with netdev_dbg log level, but on the other hand to bring
the interface down.

So increase the verbosity of the error message, and drop dev_close().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Patch is new.

 net/dsa/slave.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a0498bf6c65..d5d389300124 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2072,7 +2072,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 		err = dsa_port_fdb_add(dp, fdb_info->addr, fdb_info->vid);
 		if (err) {
-			netdev_dbg(dev, "fdb add failed err=%d\n", err);
+			netdev_err(dev,
+				   "failed to add %pM vid %d to fdb: %d\n",
+				   fdb_info->addr, fdb_info->vid, err);
 			break;
 		}
 		fdb_info->offloaded = true;
@@ -2087,9 +2089,11 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 		err = dsa_port_fdb_del(dp, fdb_info->addr, fdb_info->vid);
 		if (err) {
-			netdev_dbg(dev, "fdb del failed err=%d\n", err);
-			dev_close(dev);
+			netdev_err(dev,
+				   "failed to delete %pM vid %d from fdb: %d\n",
+				   fdb_info->addr, fdb_info->vid, err);
 		}
+
 		break;
 	}
 	rtnl_unlock();
-- 
2.25.1

