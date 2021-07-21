Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987E53D1421
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhGUPpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:45:55 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:37513
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233883AbhGUPow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:44:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQL9tYbK6yWLBM6FMtLoSNNPvLN9IB4gRNGw0yfXeJZnttPrh3yKaUvEFPpRO57bMyHbwhrVyLKerNmypCwQdJqGZbo4rWFDc/axeoEUPjs/aeUakAeBEHbOEK3FN13k20X4hYSvs1bDuNEoPyoiaizzlwIXtAT98f2BwDqU2Decn0nZd3eWiGl8U+4xf5UGrnwErYeGeb4kzqd1X2EE6saqyViUWOFxyNZ0OMiitVmklDO7GTTobtpLmnXAVtb+uu81/3n7CWPIVB/P4DkZ/2nqGbDGAMhS8XPchlCgaCwYQ9WChX/6CHOYf7bxXyiB3gaJcSyAJPeTA2JkdroQ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUxTbf3JtxuyJ0p3rblKd2v5U40FCgK76Qq5ey4tTh4=;
 b=ZC2DPr+0Jl6Ct1lmAqiK3x9oQHiirlMEsVG91AO2ZCsC7drYJk+YHeM0PyzWc2B4KsC6/Tjh0jNaJSigwxpCtKApInwo026tYsX4BgijgNy3whszw1m7PX00yb0H/2QAdZWTHVMziByyCksG8PFthR60sRKi9B4Q+k7WNhnejR1zPGxHDsA6ev24U/7rMTbK4sGrb/KCX0U4Kj2VHhc/daPHcYWal9xxc//Rfh1+lBeMgZ5kLRzIKuK8/v7YxRE/HdIqWTrfr2Atp/KfAPzuC5zBP9qT6LekJdHQid0RtKGSEkY2XWja0OdMAsBvjWS203pa8N2TBFjSlSdDEFlLyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUxTbf3JtxuyJ0p3rblKd2v5U40FCgK76Qq5ey4tTh4=;
 b=KmPXio+SbQsC1AwiuiwCwWuKCh5aiEdIlPvqAXqd0zPOgRkzyb6yKZXIDjSj4kwf1SS+0J1v34wRaASwvHIVejpVJsN7BvajzSbixl/XXOlm5QDtexnIu2sjoQK6ddswcDVmObwAJPEITWABdofrEg+CDTJADbUT71NpntCakDc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:25:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 16:25:19 +0000
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
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v6 net-next 1/7] net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
Date:   Wed, 21 Jul 2021 19:23:57 +0300
Message-Id: <20210721162403.1988814-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 16:25:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 345f548e-eade-48f6-eaf3-08d94c642164
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7343A4E2FCC4F6E5101E541AE0E39@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYtAkcG0mS2xzpVXyYHK9Cc4WiIrvZsFTgkdBkpzL0zmgDFmjfNkt4aNfe6Zvx6tzKZJH10IWIuoCbnqlbLH2eA04J7Afe1q8CEUi2yaojCYtLrWjJs0D3R/89+i/3qBc5VweaZIMNh/jNWgKTyQkbPAcNZQV5lwklRCBIVzONilouwPf/g+hnnvS1xAJaZ6DuokHYHY1I2ONMDxRUWBy1MR8KR5SVdw2f+eDGTXmlFzzPGz0VlUFxuFhQHYjZ0m5e+TKDGPKveAzqcS+d8jShGUya4WGQX4DX+BuV6g1gqk2oFiKorAwGgtI4wJbaroaY3f4lpM1s9WMLFEy/t5KyEM/ULTs9b+tF/VWGHBO084dqGiIYGUcKagA4QLmxmCjxSxIPfpXcT6nJjG7rZWkZh5F4bvrRzN3cWgWBjXy7rD53oNiRrNgZBuNm35SVbAfSxZt18jF0LXCyiHlhbIuY5Dc4bV2bfKenhOIuBjmC+TzYXZkkG3Dtuh1pp6AjQArJwBeR6VHBKxNYH2yWV4GcDRpH8gBvU8Wfff3m9J35iLPzDysqJH5uWYlmQ3gWFdbtX4MycybZjI6ISXvFalqFVo2CCMeMSv7rjzJDygCD2WfLz0/eWX9wpHf6WLwKpKgjVprPDxgpp4V4eyBkF2SOwc/lkwU3upuVVbv0WJi0WSZUEULruOKG3Bd1rvDxmtAWehJ190XzXB4YwhsZ5SCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39850400004)(366004)(186003)(110136005)(956004)(4326008)(44832011)(316002)(2616005)(54906003)(8676002)(8936002)(478600001)(83380400001)(36756003)(7416002)(2906002)(6486002)(6512007)(52116002)(1076003)(5660300002)(66946007)(66476007)(6666004)(38100700002)(6506007)(66556008)(38350700002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?760c8a7PDhZsvO9aTh69rNeeZ/0IA7JIjVwwGgp5gEgOf1lM+pWa0cmZ6Q5L?=
 =?us-ascii?Q?+RPQFkaTT7wQD+L1IXho57u97y2PXj8VltERhGEKOmGLv47T7UgvBwh1ZYpl?=
 =?us-ascii?Q?OfcFQ3Pqahpz9TVv42d+lySikRZytdtS8dLxScU2rSIx58m1LwarQpuig8vY?=
 =?us-ascii?Q?hQVodXdKZEg9zDJccdgbfOPGODPIZdTOcyiOHZYhCdX+5QGWemt8TaE/kKKb?=
 =?us-ascii?Q?eHpC+8srm8BK+vmmyq7UPyUwllvdVAtQJC0uULsiXx28cRTLJJINXTAAeOcy?=
 =?us-ascii?Q?sD1NTPPB0N5NUU+I9CRElKqNwG6kFkKIe+qTuv47CZaxi86lIfuzpuGnNqLF?=
 =?us-ascii?Q?dz3LE4T40w3ZxzcF2uwfM//hdZjCCNzkgnKIuPgBNp+nMneDiX39JoRcg3YN?=
 =?us-ascii?Q?0rqHUMav3lWrNdu/uoT1C11YVbApSImvTd4iavAbOjmJH2enu4DUjQbtl4jB?=
 =?us-ascii?Q?zF3wvau7+oRqsGc2YiG3XbaR9tZWJrY4j0kL3qR+z+AQQAgWxzOzBgdiaII8?=
 =?us-ascii?Q?DY8Gt2qNY+XmQIuj6qrd1DtoNzntMFIvsCcQIxJaLhkKm4in4eoHiB+ljYGc?=
 =?us-ascii?Q?19gtFovy66QUdMYtKYiXW/Yclsl8b/gbbzCcRW4rohAHf6HWMhLKdarUHmOL?=
 =?us-ascii?Q?kcdF1mKdlEptcNvTfXVLPzpmWGfSde/DPJWBL2m5H+Jj9UwR2cwN4RO+yQn4?=
 =?us-ascii?Q?6/dIPxXA3IpZfSTOfrzxCu47lpUEgNrcVmpjzNfyY0yIJLU/hTL8wSXQEzTc?=
 =?us-ascii?Q?uCuPj1qW8CtI3u8/iFgXw+5oeRk9Av7T6SoV3rXCF081R1IalPdcHFmP2Qvd?=
 =?us-ascii?Q?gZEqJQNP+9rQ4g6vb/kaJjKXlvxg87sq6KoBDGzPP7Nfj2/Wp8OR+PLl4JBq?=
 =?us-ascii?Q?X35iPQx3OgXE9FyRhlk95thOJYXv83DIntXxZqrxswUvjnf4U91WbwSkAHZc?=
 =?us-ascii?Q?GN0YWuQ/cZyDlwNyY2oiPjCAl0kaTlCtL3rGJ8M2n2xHmF8/v8Nh9Mkl+Gwc?=
 =?us-ascii?Q?rh6Ve/hOWFZz9OAwwLvwJKU+BIDT56CrMrSfTBWYZlpR6RpfAfJhVtd01lOE?=
 =?us-ascii?Q?Jme/TIqAbmcYn/j/bSbiFcByv9sp7xzWmVZv6bb/ch5A3Pa6l6Gmz4ZDvCTa?=
 =?us-ascii?Q?/83sOKS06QpKSWgJCGL0OVdPuug4hX9WPT/gxrnjR3ZzJNHmHIULb8aWD2+f?=
 =?us-ascii?Q?M1H1C8pBKMuIfSS8ONqb1kUIt9ow2o7oT/26LbARn/ynIJE0S4x5B190cV2i?=
 =?us-ascii?Q?O8xbiTxlN0GcKlXfuLShuJaoVlCrYT7yPjQaluhWQPF5dKLWCugzY+r1D6CT?=
 =?us-ascii?Q?87RWMLHrCNYMWc5LvI75xOCn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345f548e-eade-48f6-eaf3-08d94c642164
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:25:19.1647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nywU0/srbUiiaznGfiPWJfVZuWndQv2a8eT3WKyR3cY6tBHterxMnvcP25k5wQapIgR22i5lQQWheSMHd81daA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to propagate the extack argument for
dpaa2_switch_port_bridge_join to use it in a future patch, and it looks
like there is already an error message there which is currently printed
to the console. Move it over netlink so it is properly transmitted to
user space.

Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
v2->v3: patch is new
v3->v6: none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index f3d12d0714fb..62d322ebf1f2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1890,7 +1890,8 @@ static int dpaa2_switch_port_attr_set_event(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
-					 struct net_device *upper_dev)
+					 struct net_device *upper_dev,
+					 struct netlink_ext_ack *extack)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
@@ -1906,8 +1907,8 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 
 		other_port_priv = netdev_priv(other_dev);
 		if (other_port_priv->ethsw_data != port_priv->ethsw_data) {
-			netdev_err(netdev,
-				   "Interface from a different DPSW is in the bridge already!\n");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Interface from a different DPSW is in the bridge already");
 			return -EINVAL;
 		}
 	}
@@ -2067,7 +2068,9 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 		upper_dev = info->upper_dev;
 		if (netif_is_bridge_master(upper_dev)) {
 			if (info->linking)
-				err = dpaa2_switch_port_bridge_join(netdev, upper_dev);
+				err = dpaa2_switch_port_bridge_join(netdev,
+								    upper_dev,
+								    extack);
 			else
 				err = dpaa2_switch_port_bridge_leave(netdev);
 		}
-- 
2.25.1

