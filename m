Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A664528A69A
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 11:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgJKJVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 05:21:03 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:38433
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbgJKJVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 05:21:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkOzEV2iyhU0PTWRha0MQjmkEgnZ7Nr7mc2SkkAq1K7y10R3vKuE8Zf7kTgMdcyeMf3iIwGPwhPUiIrPEC7/37BSZw+e18Hq2tV4qNjSquX7f7gMMmvfCP2oayYdGc2J9jASQXvXQdV/Pcx4n++HOtQGmZ2U4E61JMkI4cD1e4y+BrcXbvcMReSLqyoIBcL344KvrE0+2N2Bk7JFBpJKpSnU5QCUuSiK8LOQsmz+LUQOsYDuG40XLrb/yTVTTNccZLtP8ynTyFYbAFP1dNnIFjwEIZ62d5yKIXZ3cBrV2mSfJ/Gvu9fWigTEIxcdNV+pJipDFQjs8N8EyW0IsLPP2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSo+s6bDonMt5k9g1GY9GGBEwlbm81up4oeFDirFQiI=;
 b=lxGBz3OxrwoAjb5F1PC3pwdNblFUjxqLVj5/jicNzLi0YkWoy8AahdM4dEWT52j3/VYwgrP/izs/mzs02N87Rz0n/3Vo/Nz/yS67lBzWvDiOZEjqn+zbIUgGqQy6zIWIff9zGxbw8himQv2GkJAOvdGFEtpbw7rqbFpwsLxgLAB8iYcK2BIMYOp2onmB0Xq+4AavxHUtkRexRz7gAaw2Bv7cfPai1Y6LHCk/gsRneoRhN45GYmZOqrndif0EbgCkORPzdVad5V+zjOM6//x8qVeEoX2zZMJ2A/+BRhXT6Z1I60FQII56FPF8lsyrlZwd7EVfupXh5/ikeYc6wvjy4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSo+s6bDonMt5k9g1GY9GGBEwlbm81up4oeFDirFQiI=;
 b=oF8r9/NAbGlzZVnEekgAD94p/nFfa2PFVLBJ5QEe0b7P50j2Zst233qw5W/120j6m5BQyLEOs4am05NYKZ67PwZYdF7mOQaxJqSqr861skbVo8n5xRvzUm/9HS7JWLzDmMjzdhSZ4uzveCLsxzVCpd1aOLA6CWnMp7KkK4Kqe3I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Sun, 11 Oct
 2020 09:20:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3455.029; Sun, 11 Oct 2020
 09:20:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     alexandre.belloni@bootlin.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next] net: mscc: ocelot: remove duplicate ocelot_port_dev_check
Date:   Sun, 11 Oct 2020 12:20:41 +0300
Message-Id: <20201011092041.3535101-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: VI1PR08CA0100.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::26) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by VI1PR08CA0100.eurprd08.prod.outlook.com (2603:10a6:800:d3::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Sun, 11 Oct 2020 09:20:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 75bd18f2-fa49-4490-3f60-08d86dc6f569
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222C4F1D1EBBCF4C56B20F0E0060@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uf6PRbQc91y7FqDKE7cVn+xNeE0I7lbQUjvzHljmtASaAejxXQDmU+cZyp2lO8Ybob7TL98VNXZ+UTORyd9oINjZfIC64PVUc9qz3y2BmqR/ExlfMxjhlbDDvfteT19WepjuQ5AOT7mrMXcTa8FRQQ75F7Zz727sX2bp/A9g2pyHAU945/buIV67PeXS/QgSGW2RPU0AC5UW0Va8wB3ioDdi7OOiXhhO77+D/OncfB0quXWWYAsOAWhVDvHbvIzodq3Dnctv4O1NdpMpfui4POHKuSN6f4YlB3lmke2N7IVCOPbIMlnTx7pDnyOwZTUI8EbSiG2f7Hsqa843/VmQKJQ3krMU5zWXJlVzwRbYu0cQjqqDuzJFA+yjVg4g0MU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39850400004)(6666004)(16526019)(86362001)(44832011)(66946007)(186003)(8676002)(5660300002)(69590400008)(36756003)(8936002)(6506007)(316002)(1076003)(66476007)(66556008)(26005)(2616005)(956004)(83380400001)(2906002)(6512007)(478600001)(52116002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5KK7jFNUA69ARtNKxXco5ZefJ1Uk9n2IoNvEaPSyzakU5zW4ZJZh23sH8V3foixcCvKgH2fr62wvGwiLZ/vCFDsFesOUNQdKDumrJq+8OrIFdycM1hVUokbg5o5rBLG38SSzoAR5oCUrRp/ro0/kZfUYYl+P06CdHk7oaLv693C5K3vSDSNYJafUjVx1ShDJ0cDhPvjPFiMMQ0uN+JLjO1PnAWdncUmk7YMup1U8TvFwKUSFQkXdi2rMa62ISo3GG8AwNV7BvJhM5zPZNcPj3WxReH/ic4Q7ufGunVkb5/CfY0+cGq44p6kEdEvhTmeAmnv+Qk/bl2JbuIJNDTBBz0Ndl1Q8sNgeKxBKWrwIwi7ke8ijrOu8xKBOmWDcWNvJLokyx3tPRnJjL04IPwXdtpVHseKvC/0XZLrQyGxFECb+eTZksA0njl8Hk7p0hZPRXtogjOO9YOLojgZfAXzT5k7Nu+VLJA9kMohKFK2Z2jofzC2kHRTW6LkT+mPhcELkzcyGHplGXuNqb+NrwpTeRuORFk6t6kRHpsjwuaHkktxNT2EWQ5ZSd85iiVN2A38JiDqTK3mKaHIn48/zzil0WosbSHypumMeyzDHzEMIYj7cKf/0K+ABPud/2gHpzxYVBu+xcZG94pTr5CwK9ATQUw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75bd18f2-fa49-4490-3f60-08d86dc6f569
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2020 09:20:56.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8iNjF3E6BhTUQpYrUt3jZcjl6XGMO4sJGJokVREN6d3O9zv+mZ32GcZK3aUuLy6VXJBUvL7Ltsrx5oXNDoz4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper for checking whether a net_device belongs to mscc_ocelot
already existed and did not need to be rewritten. Use it.

Fixes: 319e4dd11a20 ("net: mscc: ocelot: introduce conversion helpers between port and netdev")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index d3c03942546d..b34da11acf65 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -669,7 +669,8 @@ struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port)
 	return priv->dev;
 }
 
-static bool ocelot_port_dev_check(const struct net_device *dev)
+/* Checks if the net_device instance given to us originates from our driver */
+static bool ocelot_netdevice_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &ocelot_port_netdev_ops;
 }
@@ -678,7 +679,7 @@ int ocelot_netdev_to_port(struct net_device *dev)
 {
 	struct ocelot_port_private *priv;
 
-	if (!dev || !ocelot_port_dev_check(dev))
+	if (!dev || !ocelot_netdevice_dev_check(dev))
 		return -EINVAL;
 
 	priv = netdev_priv(dev);
@@ -907,12 +908,6 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
-/* Checks if the net_device instance given to us originate from our driver. */
-static bool ocelot_netdevice_dev_check(const struct net_device *dev)
-{
-	return dev->netdev_ops == &ocelot_port_netdev_ops;
-}
-
 static int ocelot_netdevice_port_event(struct net_device *dev,
 				       unsigned long event,
 				       struct netdev_notifier_changeupper_info *info)
-- 
2.25.1

