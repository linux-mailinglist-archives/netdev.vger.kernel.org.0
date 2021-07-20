Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EBD3CFB38
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbhGTNLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:11:46 -0400
Received: from mail-eopbgr130055.outbound.protection.outlook.com ([40.107.13.55]:24446
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238669AbhGTNHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:07:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbIGEteKI417OYldQCu+yv3OUiuwZ1rAQYMNaNyoV4zt2YL6JpidJ7/yzlk1lUks0ptM4wyTodv5qMxyG36SnWf/woK1/x+Wvmv5L4+xEJj30Vb+FFEaUfCVzY2w1IZ4XcBOiJ4jlCGFU/QgbU907Ji0Yc3B1Y7a/+/e7qabKl+RPJY8gXbBc6QDrd0hX7IbRlqwrdcZKAw9flgRM5Sp/QDejSK73EHVriqn5bUDAPrEpe4mP1CnBpVG8UKXoQGD5xGT0ZDqbgDAFzCxRvr3rrUeZEPZn3q8s+9jUbmZaoUjuqS/0tB1Ip++fSYPeUkPEUMIsn8IJ48AobEGImpASA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q1vQsb3VRnY2UHX+xghpgNY5BAAoihfpHonvPT9jUk=;
 b=anLFJAav15TnZduuAldDD9KdNX5WYuLkmjOGth+9dqtIXaHKdRKMwpKDJBfXk96aaN0ifMbkZowemWA8FvtgCEn+8kYs5+4N8+GInTzFMpArCJOGXt3zFogsxfoLlglfNPekchvpTbpz3Kw/7gN9Imf7v9hIbs+dvedSeavkdaXiRbVOQ2Hjz80EP1QRLVcZtNq5lKh4TEV2M/5IZaTfpnQ3fH789AYr2w775pRudshwdHcoeSSOYuO7i5RkCs/hMR07F2YYKyd4UQvaUySLwpcNSwDA3K1QiQ1Fmr7m+qA/8Fo1/9Wvq8aryhh6vtXal0C90GDCnhkPEuTOf70TEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Q1vQsb3VRnY2UHX+xghpgNY5BAAoihfpHonvPT9jUk=;
 b=HWjPYa1eaEU07iYwtZS88TKnmpQHj5Ocr26TQ6eZn+Xe8PJU01eX1vXskBCe9yUPwZaFYVFtFJ5Cz4t0OEiJQqT0YXPR99n+Ru7GyBDWfliSO334MYnS6JcBQXBRqZOqx9QcUv8mivDDD5CJZvgn/27SI3rjlTjwsTABVvcRPMY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 13:47:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Subject: [PATCH v5 net-next 05/10] net: marvell: prestera: refactor prechangeupper sanity checks
Date:   Tue, 20 Jul 2021 16:46:50 +0300
Message-Id: <20210720134655.892334-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720134655.892334-1-vladimir.oltean@nxp.com>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a81ced0-9dd6-4021-e346-08d94b84e40b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3551:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3551D31064A9A5741EF8C46DE0E29@VI1PR0402MB3551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMY61+eLDFy6Demd23jV+FwUNDrHIFige83AVj4n3wuE6jQZNLSzv96fqHrpzcATE3pCDi/bcKCrcaACAoSvA/7T1VhDqxfxX04CmY10kKpTddC90SQRKAosTqT5B2cFeQkypLMAb/AHjfN56nPU/C0584tZ/m3nm9qDvB3SX4AheOiXmiTOXPd5tJFZATVYt4fyXVcbacaW4MNDmBvvi3H51Lo64DcAkpceIMbrJFT1bFzFub8AIo7HEusIqIWLqa61NY5Mt2f1vg94+01D/o3uwky9ItIly2Iwd4hHRaWP5J9g228BkjcuyHOgF0eBpPwFWucpshzVBeDeHv+Y4Q9QAA8oM7z7YgNkCGUFF+8pclO/Xzg3A/j2TrfEycMP5ETngzlFzTt3FaWr15UpJQqUABaSZEUsXlSaxaV1ZWx0mAnovLbB2Ly2NVmSKUbSw4gVCKNAMXXdDIulMCbeMOuAH3KmSNXBKBcntEWyYkRwMYsKLzqlmsHDP7exS/wa8/QJS0/yYHwatZ/MacYvS3A/TwsO23yL6YK2Fgx/y8dODCIDlYozn3CZQEraKMd2JHmRXrvKyQx+E3AX/BERqmBDmDPkovcTk3dy/c0KOS2B9xzA9bY9Uq/aahBZsh6HGXN3dZBzm8ez5f0VzPTxvfzGreATjNbB63jmF+uLhPEDre71/BjGCTL8XoUbOK5Qd6bXRovHl/LRZ2uzUVjOjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(478600001)(44832011)(316002)(38100700002)(2616005)(956004)(5660300002)(6486002)(54906003)(1076003)(38350700002)(2906002)(66946007)(6512007)(7416002)(110136005)(86362001)(83380400001)(66476007)(8936002)(186003)(4326008)(66556008)(6506007)(6666004)(26005)(36756003)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/fXnbp7WCBvbHBnyRwiauXDcUAWOvN9xGUCy+RAbTukU9xl8xUgH3jr9O6wY?=
 =?us-ascii?Q?MBoEWHHdPxCs67CKDsJs7kZmc0LpoIgXWoO3NGetGkHFNuKp1RUqnc5HfD4w?=
 =?us-ascii?Q?SIPrtWwJqCQktOuR5q5yVmXhXRsaiGnmGg3cSILbXiR6/jy2zreHYnMf74/z?=
 =?us-ascii?Q?ClhNS91+Vfkxyl0z8rAHPht1Mk4NC6DFH9JR9T8D7HM3w+wUlyJgby2Ohfy5?=
 =?us-ascii?Q?0lBH33sHPA2XWRy8pCblbABX87zgfMrWBLZq3aMnX7C/5NzhTJdAiDmXVvsM?=
 =?us-ascii?Q?2J9gMH8w0nc5P0yuQ9X7g62tvwVNZLlZ9aI496s+ud2q+vvNdgEXV95nvd2G?=
 =?us-ascii?Q?0cbC+CBmio4tJH5L/gPVo43K6kGqtjxQwIWo5og4inr2o0xAf+k3vo99yPxX?=
 =?us-ascii?Q?cxoDmIvdz4Es/HM+zy74B66czC4K/OUnJhLk/gmpZl1boiGC61xNJK/vtthW?=
 =?us-ascii?Q?CxoUSoI0Xs8hvqKjTAI98Um37FW9YLtGj5aqjn0kEWNv7cR010z80hihzXO3?=
 =?us-ascii?Q?Sg7HajR/JckWC9/RyOmDYpdPAq+ug+Ud283to1HjZKKXsvrQ+o5zxddmXE+5?=
 =?us-ascii?Q?fuDcazB5wkEcNXeigSjqQCvhlfuq74cY2RPtwUSnNDi1zHCXEjbQ4CUICHRu?=
 =?us-ascii?Q?SPfKNMdwPv9Ko6wPGvZZ517sX9b4TD7f8ilToBI/Cm6P7nMV4XKhClj7SS6Z?=
 =?us-ascii?Q?XvkQTN6d0nrwHzf1xPhhoysXQWqo38bnI6cibIwuDNIEWPqUNtzxSo6z3+Ze?=
 =?us-ascii?Q?zh94IqkJ4wDjEflV+YJOFYCCghqbDUyPgk5sQjrM2EMxmP1xPLX/Pn3/MfVW?=
 =?us-ascii?Q?8TGQbNEBdwHsDbfjizGpFceVX0hAHMWx1acV81P2mNA/j+yjIKPyIVXD8ay3?=
 =?us-ascii?Q?JyVLJNe2MzvsaNMOgAKrc3TOY3vz5FcKy34pO0Ux8wbClebvctGNL77SzocA?=
 =?us-ascii?Q?uJxqaACuKo1IxqbzyUta928Ut7fIvXsTboFP8FJ8UFG1CrjMvM9nBEJs+ySF?=
 =?us-ascii?Q?iLikLl0W+d8P9lBey7ApyRynMiEWeMRBLd7O6yNdihinDrRyvXiEv15OgbTQ?=
 =?us-ascii?Q?hey953x5Ze83xhb6MDf+u0qlRjcVYcZdBw/XHF7Uak1W+dye889zt9ccTU0A?=
 =?us-ascii?Q?jjf01TUrGUTqMG+SH+7H4cXeUiaVIyvWgykcWMEgLtKqheTHk5V3ingqbFDf?=
 =?us-ascii?Q?WI4K9xJbm5MOabfCf4sdUNEdFw2Q4AOufTn0N8czvtxPA7IaZo5WbyfLV7zU?=
 =?us-ascii?Q?kFR4UeWF3T3zAkL/yHNiUhrmu1JOEt6RrjgR7oCX3lp+TJrNMb8GgpOCrMvL?=
 =?us-ascii?Q?NcqHx4tmnA5N5IiL3SOk4x4L?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a81ced0-9dd6-4021-e346-08d94b84e40b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:18.4965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyLA1mO3YJ2KCxsqkBcV4NAEHHjoFoGFbWeK7VPDGrLgfBYpomEDaCq2K/EULwBZv0UyLkPtBhLjYT9vc4Wd1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of adding more code to the NETDEV_PRECHANGEUPPER handler,
move the existing sanity checks into a dedicated function.

Cc: Vadym Kochan <vkochan@marvell.com>
Cc: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2->v3: patch is new
v3->v4: none
v4->v5: none

 .../ethernet/marvell/prestera/prestera_main.c | 71 ++++++++++++-------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 226f4ff29f6e..1f3c8cd6ced2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -699,6 +699,45 @@ static bool prestera_lag_master_check(struct net_device *lag_dev,
 	return true;
 }
 
+static int prestera_prechangeupper_sanity_checks(struct net_device *dev,
+						 struct net_device *upper,
+						 struct netdev_notifier_changeupper_info *info,
+						 struct netlink_ext_ack *extack)
+{
+	if (!netif_is_bridge_master(upper) &&
+	    !netif_is_lag_master(upper)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+		return -EINVAL;
+	}
+
+	if (!info->linking)
+		return 0;
+
+	if (netdev_has_any_upper_dev(upper)) {
+		NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
+		return -EINVAL;
+	}
+
+	if (netif_is_lag_master(upper) &&
+	    !prestera_lag_master_check(upper, info->upper_info, extack))
+		return -EOPNOTSUPP;
+
+	if (netif_is_lag_master(upper) && vlan_uses_dev(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Master device is a LAG master and port has a VLAN");
+		return -EINVAL;
+	}
+
+	if (netif_is_lag_port(dev) && is_vlan_dev(upper) &&
+	    !netif_is_lag_master(vlan_dev_real_dev(upper))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can not put a VLAN on a LAG port");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int prestera_netdev_port_event(struct net_device *lower,
 				      struct net_device *dev,
 				      unsigned long event, void *ptr)
@@ -707,40 +746,18 @@ static int prestera_netdev_port_event(struct net_device *lower,
 	struct prestera_port *port = netdev_priv(dev);
 	struct netlink_ext_ack *extack;
 	struct net_device *upper;
+	int err;
 
 	extack = netdev_notifier_info_to_extack(&info->info);
 	upper = info->upper_dev;
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
-		if (!netif_is_bridge_master(upper) &&
-		    !netif_is_lag_master(upper)) {
-			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
-			return -EINVAL;
-		}
-
-		if (!info->linking)
-			break;
-
-		if (netdev_has_any_upper_dev(upper)) {
-			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
-			return -EINVAL;
-		}
+		err = prestera_prechangeupper_sanity_checks(dev, upper, info,
+							    extack);
+		if (err)
+			return err;
 
-		if (netif_is_lag_master(upper) &&
-		    !prestera_lag_master_check(upper, info->upper_info, extack))
-			return -EOPNOTSUPP;
-		if (netif_is_lag_master(upper) && vlan_uses_dev(dev)) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Master device is a LAG master and port has a VLAN");
-			return -EINVAL;
-		}
-		if (netif_is_lag_port(dev) && is_vlan_dev(upper) &&
-		    !netif_is_lag_master(vlan_dev_real_dev(upper))) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Can not put a VLAN on a LAG port");
-			return -EINVAL;
-		}
 		break;
 
 	case NETDEV_CHANGEUPPER:
-- 
2.25.1

