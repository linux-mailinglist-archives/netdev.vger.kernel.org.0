Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49B33115FC
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhBEWrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:47:22 -0500
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:25949
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232435AbhBEND4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:03:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/L8XfAKlAA7/LtDGv5cklJ+QVF6HxKuU1iwR8rCDHB+Y3QK+Nsza73sgb9KlX+lCADjhNtPQ8jrypihv7N4A3D33bauyLgCsF3MM5DxKd456tXBtvvHSgfJG3/cXO82VXDb6e5arwJ2GxUBsk7e625d3yLgbVJGLCgqZ+EFTx/1xGncUi1OM80UIIkqpWW8YNCZWipRQ2IXBJoT9Hm66fFv7tD2HSYvjbr2kY8u1++u0i2q1+u27nzdV0gfr2npfiY9iKb6DF1JQ0pooy+evQvh36idfiNEjet4Y67mx8uLi+sz4VC+/oeWhrYKywjstaZgjzB2paNe7CGE2iVyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd2qH3cXEC0nns1qm0IfyyAfe/mCopRCedrtK9XDYZU=;
 b=SibgqWAaMJmEZw8KilgJWOUdX4RxOSpfW70XeB8dhkNK6nXgogHE8R7/xc1Xe68oHo2E9wUufzEZtdnyaM5YkgBsEiQM/F5EFpWTIUfFj0UBFNymHm7gYgslJCxeewbbL8gw2yea4AvJCWg/nbUvAnw17fzHhZltFXCXCYYFjDoPUGfXboboBSf3yxmD/3R/bokGjhKQE4xtq4CcSLStv+AVkR3FHJmOijuJMcqYcPvP9iVmy3mPJk4u3XhaAL/N86ganqUaI6nNZoxcMhLqwt/euphF7rsOI1b1PAH1CYP2jNnqVDhajSIkTy0jRYNMfJa/4x6HEPChAuI5dGNYcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd2qH3cXEC0nns1qm0IfyyAfe/mCopRCedrtK9XDYZU=;
 b=I9yu6elV8ZeCDXyun/fxJoWO54hC1Ec2nbGv21SwZuj6DJBdiDUI/6D41jqSNTOCnzsyE7IBQT/3NVK4u9yeSSTb/97H2dl3vs6IagxPVc4LPNqo15U/3dYK/gaDwKOYwpvJT23tzDJEWRPVXVwsGZGpLCzGcI2PqYeC5sfoQxw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:02:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:02:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 01/12] net: mscc: ocelot: rename ocelot_netdevice_port_event to ocelot_netdevice_changeupper
Date:   Fri,  5 Feb 2021 15:02:29 +0200
Message-Id: <20210205130240.4072854-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
References: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:02:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 181a0af9-77cc-430a-a2aa-08d8c9d65ca5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2863B675211FFBCC219719F0E0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBPXWXr9kI9oZwbmAtQOrdr7x10BqvetX5vUyKDozFyfbmaXFAHZ4lXu6UJBDnIG1lIwyrCP79zopauZ87sBoRX7H2xliyzjXlaADRSMHHAkk4Iu88bX8KO21TMzv7EQaTuhQNQWofqHfxlYVXozfDCP8ch/tmJTOLG5DZbv3V0K1xsl3wYXPXd62TR5tyt6muVlqBOaliruVAWINgJ7n3XD29dm+Qdk2WE2CyyCwE7608BTAWvKgyHSJIQz+quY2mtlZ0WuVS3xFtrXj4F7atjaRotIUnw47D1u3X0A/qpnLyNjqaO6nAqxvKjBhqgjPv2ZIlcEMvbFa7OnwVh/s2wb2I4zmcipbQLHYKJvZFeKXJT473dXws1AxqD+2vJdwGnpKOvNMdoNMBvtPrvWHlQw9HNStgKSwkeA89eEJJJy2ksPxZFTZtMW9yNhdid8ZMnWzBLI/yKORXlQpOgrA0B7hG9F5vUMe8W26MNqwTxxjS2+jioIXbYqVUbbeqCiBSmSCqhHIk+w16vRR6d1G6bCdKP1jKPOSLPureksIkdkYKPlFWHRqA2bfBKwMcNL+nF3lkPNz17UyapOU1veCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TiCPPg2GC/2DL1TmIdaY6J13zzUafT0x7MviYgtk4Lc+zsDx2iSAGHHdrG2k?=
 =?us-ascii?Q?fqi5mGXn1fCEpMMyDup5ALphIc4zP5RiaqmjrcLT4e8dsfJve83+W+6OXHI2?=
 =?us-ascii?Q?YJp+r/3uTq5/wJezn9Y0G71ZRvGEVE0AixjRbxDcg8AkxmN4hfSs9hfshsjT?=
 =?us-ascii?Q?ealS6E6Ay65xZYdQaPVHY1kaUz3DHbSwCZyYd8jQSF+0lnvBgjQ0gc6jZkqc?=
 =?us-ascii?Q?AwyKwc67gO0Ac3iDmLhPAkJLaCk7mkKOW2Jj2C8Un9ApolgkyfwADCq8VfRw?=
 =?us-ascii?Q?auC5ziKOXW01TQIN6FQwLwqRFwi7j+k3X8QfJ7p9BAKGBUamvZ7egUx+wVrx?=
 =?us-ascii?Q?Yc6aPkScUz4UofUgjk7sKghVNCp5WH9NpaP8VEFH0H7pkSE7oVWvsjycJHVb?=
 =?us-ascii?Q?gYAW6kE6aQeuJ2sZ9xbd/hcjbgND/N4RbhnQXkYs3jZSvXBWVMHrHbirjGqc?=
 =?us-ascii?Q?IAAVJq5/NLGS5xjTrYGYxhIH6aIc4z+qtnLQePx/eo5fncSCU2HdV72rUvrp?=
 =?us-ascii?Q?nSZDFJy8iWaSDL1W6SDPdQoyGgOHweXIW1+qSHUkDTBjwV4NBdc3JYgqEfiT?=
 =?us-ascii?Q?Sr7t7K3FvuiyNODnxvVfT+qbw121CQGjEzlc6LRsnRnjbEs7odg8j+nPlSyl?=
 =?us-ascii?Q?HAYC2I3w0YX9E/OhwOOmFFb0rp7w8VTrISwCJ3rPcMhsiOK/5mq5TE3kmhHr?=
 =?us-ascii?Q?xIfy+Wgs5PGWG848jM7lNb6UjSl/WYhu+ZS+fiWux2VrvtlnDwzcGRJGs1fH?=
 =?us-ascii?Q?QkXonuO0ipog5dCicaoGCK2fxqbpGOdFk5eHEqmftB/N4u1yrkbn07kqKQC6?=
 =?us-ascii?Q?RXvy0hnB9ATVwfy/ohjKR8UTOKTjx2G6Q0FyCJBFwPw3FDMQFCVEhaHcRnA7?=
 =?us-ascii?Q?IUKk0HgiZWr4RRhPnBmE5o8WZu3xEz+9sD0MMGTc3swUdky5h1Aba+uQTWez?=
 =?us-ascii?Q?urpwH+vvmZjofxZHxugKoXRFW1DktDiWKhPWuFkHyJddHk8WjI9V4VJya6Er?=
 =?us-ascii?Q?wLVQFgf0MMET9a9RwwaLyhdRHNCecz5iFZQEKElxADR+8dV48UusDKG4yy47?=
 =?us-ascii?Q?zujUcFDLsw/XSiZnDvIAqQxIou4Bj6kNAsxaavV7QNmZP0ov7I6ZEvxq4foQ?=
 =?us-ascii?Q?nhI2+PsC8z7kMEIsrsMjSKZkUxnFoxhmX+QTwlsHI7X5gKCUh09fLvlm0RON?=
 =?us-ascii?Q?DQ/P0Rxy4sJOsn9JQc5wd2YrENDdsZ+fon0M3WjGigbpc1p3RLwHd9oR/c3Q?=
 =?us-ascii?Q?Q/14T9JwhVYf1+AIZDRxraYyE1lfIR7mG7MJP1LVz/Ai3DJ2r8stnElwz483?=
 =?us-ascii?Q?AZkrS870Fnzp5mOft3/JJta/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181a0af9-77cc-430a-a2aa-08d8c9d65ca5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:02:59.0436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1U84zgbkLPrTqGY+IHC7c+2HY4Fi6yp5pVDveP2K6vW8brNGhtmh9AlJ9ZLN/InPXaAB+AVjs+tFNNa0jWAOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_netdevice_port_event treats a single event, NETDEV_CHANGEUPPER.
So we can remove the check for the type of event, and rename the
function to be more suggestive, since there already is a function with a
very similar name of ocelot_netdevice_event.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Fixed build by removing the "event" argument of ocelot_netdevice_changeupper.

 drivers/net/ethernet/mscc/ocelot_net.c | 59 ++++++++++++--------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e6b33d9df184..c8106124f134 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1110,9 +1110,8 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
-static int ocelot_netdevice_port_event(struct net_device *dev,
-				       unsigned long event,
-				       struct netdev_notifier_changeupper_info *info)
+static int ocelot_netdevice_changeupper(struct net_device *dev,
+					struct netdev_notifier_changeupper_info *info)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
@@ -1120,28 +1119,22 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 	int port = priv->chip_port;
 	int err = 0;
 
-	switch (event) {
-	case NETDEV_CHANGEUPPER:
-		if (netif_is_bridge_master(info->upper_dev)) {
-			if (info->linking) {
-				err = ocelot_port_bridge_join(ocelot, port,
-							      info->upper_dev);
-			} else {
-				err = ocelot_port_bridge_leave(ocelot, port,
-							       info->upper_dev);
-			}
-		}
-		if (netif_is_lag_master(info->upper_dev)) {
-			if (info->linking)
-				err = ocelot_port_lag_join(ocelot, port,
-							   info->upper_dev);
-			else
-				ocelot_port_lag_leave(ocelot, port,
+	if (netif_is_bridge_master(info->upper_dev)) {
+		if (info->linking) {
+			err = ocelot_port_bridge_join(ocelot, port,
 						      info->upper_dev);
+		} else {
+			err = ocelot_port_bridge_leave(ocelot, port,
+						       info->upper_dev);
 		}
-		break;
-	default:
-		break;
+	}
+	if (netif_is_lag_master(info->upper_dev)) {
+		if (info->linking)
+			err = ocelot_port_lag_join(ocelot, port,
+						   info->upper_dev);
+		else
+			ocelot_port_lag_leave(ocelot, port,
+					      info->upper_dev);
 	}
 
 	return err;
@@ -1170,17 +1163,19 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 		}
 	}
 
-	if (netif_is_lag_master(dev)) {
-		struct net_device *slave;
-		struct list_head *iter;
+	if (event == NETDEV_CHANGEUPPER) {
+		if (netif_is_lag_master(dev)) {
+			struct net_device *slave;
+			struct list_head *iter;
 
-		netdev_for_each_lower_dev(dev, slave, iter) {
-			ret = ocelot_netdevice_port_event(slave, event, info);
-			if (ret)
-				goto notify;
+			netdev_for_each_lower_dev(dev, slave, iter) {
+				ret = ocelot_netdevice_changeupper(slave, info);
+				if (ret)
+					goto notify;
+			}
+		} else {
+			ret = ocelot_netdevice_changeupper(dev, info);
 		}
-	} else {
-		ret = ocelot_netdevice_port_event(dev, event, info);
 	}
 
 notify:
-- 
2.25.1

