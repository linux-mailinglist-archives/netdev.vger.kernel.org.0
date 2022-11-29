Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF5F63C21A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiK2OOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiK2ONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:36 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154BF62057;
        Tue, 29 Nov 2022 06:13:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDATt6u9kPXerY8IC4eAS6hR+MPICxQY6p3uNaa6XjrmifuMwiYppn0MhWo93MGmaHahNSPuj8ktR/OrvtamDezfnroC4X0wkJut3Jf9kVsY0vLpfJVKNjUlp5xxNv5KSN47NIZeSC1r71WMbOPUwOKLmRGHk4s5hIqdSch+YiVTkx8wmFy6QtN7iNvJqzvILznb6OlAnRZ1RnS12VRYsVNmE304d9gAImi/hqDUBR8FQU9lNVzhjxP5bE0hho4mZDR/5o/D1YgmCfGJ3DzBvfugPQAl+l9MrBSXo2RvSFgCQo5QgtgOVpqlfI1fjcLK2gIkTmu3OprFawvUUm9uWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OL7cN229WgYN1n34DlcBKSHuHNhmJvQ06ZayZTOX02s=;
 b=XJrlF98BNq6FBPsXe2Mv9CB5UWAAIU/oS0wFR542pj6H3XhOu0C3OQ7SLtZJRTVl2UvPxmzWb9Ls9WxBbc8dMLKHmbtIfX4vfidGh+7uo9RYpL5mnhgbVsTMI5FlO+34m3Y6RIDMRb0XCpbBeUHsGgRwThBIZYJy9DU9B7s/f9EMJyYOdmWX0XKsSbar+pGA+Bik6WUqoHWlYFIrlxmviNquVxbPHhnv4PR68VY4B0qpObs1O9cMjcqhRr2roNSLQ21ncD0Ntef4vSLV09YeGVh0hYh9Fv9E/a6uLGK04GWZF7/lmcN5Xm4s1aF+iaFEe+WyiKARLPbj/mxHC+t6Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OL7cN229WgYN1n34DlcBKSHuHNhmJvQ06ZayZTOX02s=;
 b=qr9n3JUGT4vbI1JpF/4ybjkDxFUrrVZZOSMAHxqa9mZ8F/6dar02HEX7cvez/alN6FVE0WzcFJpfb2VzyfiRN4Xf57gEsJFpL1yTI7E56y24sXBzLBnBMGHAtsAPfkqu0lE1rN1/JKqen2HxdMfq3Vapa6L1nNZDA49MkM1wEZg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/12] net: dpaa2-eth: assign priv->mac after dpaa2_mac_connect() call
Date:   Tue, 29 Nov 2022 16:12:14 +0200
Message-Id: <20221129141221.872653-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: e33fb400-03e8-46ee-f2f8-08dad213c4ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8i9sQ7H3YS7AXnt7D/WVNoZvNh9d00iZ9oLddJ6M34aWv94vyy25FY70nya3MJr4dr63T874VquRdV9Cy+PAmUENd/xur/u8xS2I7hXtciPdlRAjrOO35dVbah4ZOSlETH2r/PhowYHixDq+wWEnRGA0mUqpW2lWqgK0P6TSx6eSisrEx9dhY9dOQiQfV9w7Enz8sTVTZawH0OyVF+mpcPD4CDqQPXS3cstj2n3/YQ8579AflzNrqvsIdB3yBoUxDcQGIS9oEEOwO6T3cKOcSOJKh+NNoYkXGNNXXEWkzydrJ51nDu+AaZTyD2uEAQc9IAQGqZ8LexodRztSovRl7QLB4gQpVrhfDZO3+u6lzixTx8ItYrIhAZiYA850KsIDoQm7e06XSmp1qtj90OMSQKD/5uuWQjjjsVq7zvua1iDS7frY/ogrWJ/MfnrWS18sY1QODwo/8QA2zDqMcDSRiEFmMNvloaRZsn2XHPGb9/6zpkWOAdQU2Ou+Az2sAf25S63bSgtTN8cPfBfTVInE2QfJJr7Mykq/Q59Euc2lEOBGhkICiDDfBvBcyJ/uJGSdM+aghxF/9WccLPwh/t676gQyS6jo7zMoFQ1rCp4Cdroia+0/o9Fjg9aRupk4LNiybW38AODvALNl/9PyXkFDfRoUR5bj2r7VW+kRvYlPts6UXag/IpsTEy4ARxHM+NYNE3LXjzI3gFtObW/AQK0jAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gWZjMvs84Wa+j6FRH8T9HdAi16VotA6emdxrf3i9VPeA4eCHhCeQ7TS/m3b?=
 =?us-ascii?Q?retMkzsy9CYvWvwqpeufs+UYkrpOFoaYACb8/HwZea+dngqFYGobupHFZSYk?=
 =?us-ascii?Q?A23yecDDBExpH7PMfb/l0od7R4OaZKPvVNwiyy2IGXNlGgtieRUjL6DkkV/I?=
 =?us-ascii?Q?JukGnW7rUDcuzcIRsu9xXrGFPaplubHCwcW4EZiU2Fjo/I421lC69jRTVseQ?=
 =?us-ascii?Q?up9agKL/UsRazN8LshfZJP4Nd1nZ3Jrx+uM9J20UdxhOMvy7GFczyt4KtI4j?=
 =?us-ascii?Q?Vy8vNMbSjvARhFSdYzVReES7zXSzCPocvGe5YlAmG8JrgBuD4hryeWgFQzLL?=
 =?us-ascii?Q?z39/XIBYoNpzgoNVJY+SX/1sZzVW6a3mCzvYc/3V4s3UkeKkMbO51haVWnO9?=
 =?us-ascii?Q?SZMCKJdGW6Co7RSmMtdjof3lTkXwHKn001slk7vg0aB4y8xjMfrNw0LmGGPa?=
 =?us-ascii?Q?RtLdSUkQ4KeUJQznnMz2cidakbPemG+QXC8FWCgL7Tx+FCmI+/SHg583L6Vn?=
 =?us-ascii?Q?C9J3pBXQQLAJYFtZRxNvHO0tP4tK2/nOrJlQx43TJpQSh0JA7T403iC+zM96?=
 =?us-ascii?Q?XXWY4fsZM0FKe/Z2Vc+bTvClvhGATrDLjm1x2PbOPuys9Db0s58ufU3amnT3?=
 =?us-ascii?Q?Y2rHpKGJcJICz1xOnLFISYXZDRT8MX47bzK7dbihZ3iJ2HLccrsdcpEc5PlR?=
 =?us-ascii?Q?0DyntRgINqgWMAVnZgilx9akNwj7sJR/Bg1Qa3ffDzHZrylCpdip7UeH1R1x?=
 =?us-ascii?Q?Pf7TFhbbRx1DAhvjsZpnd1pbJ2dhPRtR8WcCyrmWQHbCXAjIeAJFXPt5FDtA?=
 =?us-ascii?Q?bqiOhEQVLOA9FkwsUqjI7UKcr+j68cUMTZyOH37fK83iqSdyg9jwdGTG0j6/?=
 =?us-ascii?Q?YSqX6+bERa25mh9o2a/eu4n8b7BD6kOj+uJ2RpD+XSpcyLJ88BXav/kb4jj4?=
 =?us-ascii?Q?qZh+mhSWnO+LsAhcsemnPWKHFwoIPjXjWvQ5yQK1McY/202DRrVHW4A196Ui?=
 =?us-ascii?Q?sw9nO91YTOiWHe1N8Ak6X5sB+f3eILXK0t24YqT8GgVaX2tBh5lygsrHQQhh?=
 =?us-ascii?Q?dcyatSaUnMeMjvZzpu8zgjYEdyKTHr0ew2Amcz82iAOlcFXLwxTvS2X1pnPq?=
 =?us-ascii?Q?bi+DwoMhStGQ8jcxqqb7wF/WSQmdFgVTtOkMmdebWbOUhyNxZBtpOpmjiZ+D?=
 =?us-ascii?Q?GBxE+ZDP/g2PENzWCrDc7u39NRVBT+Gvl+PmUn4KcghPJUCCyVtEegH4nsnq?=
 =?us-ascii?Q?36kT6EBroOPH1PhbIdTtfckxqohWonTEPzK09JFpxK9+djJnvi8B6fFRhH5v?=
 =?us-ascii?Q?wu4iBt5aR/YkzZZIuhEbl4jv4mqxLke+SH9dORypCl75/PHcS+F4UdzKsx47?=
 =?us-ascii?Q?8G3FbMsK0gUfTlSc9H1eP9dVx6uOAQol9TtzvD0rf59d79HerHr27e16XoFD?=
 =?us-ascii?Q?zYSa8MSv4Q21y1sNSFAM0yaI9gcBafa5wK7fURWooAjGwPLQRARjU7emQ93p?=
 =?us-ascii?Q?RFlTqmpYROn5AavazExLtUfLr0CD2tyFAnCt8NheImnuzvFSSekdqqd3/gIU?=
 =?us-ascii?Q?VjinPU3VWwhD+8GuKDSvfOg+YSbi+7xU0nNnSxjWaGtYCLYc9lSQTMy/vsNm?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e33fb400-03e8-46ee-f2f8-08dad213c4ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:37.3567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WaId8kosgqSVZsHplNVGHWSAfD2CtN6u5xGuFjjfjLu9S38wlTgxdKbBXC0FDwppIFkYl9S1ItJcKtry1lt51w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 requirements for correct code:

- Any time the driver accesses the priv->mac pointer at runtime, it
  either holds NULL to indicate a DPNI-DPNI connection (or unconnected
  DPNI), or a struct dpaa2_mac whose phylink instance was fully
  initialized (created and connected to the PHY). No changes are made to
  priv->mac while it is being used. Currently, rtnl_lock() watches over
  the call to dpaa2_eth_connect_mac(), so it serves the purpose of
  serializing this with all readers of priv->mac.

- dpaa2_mac_connect() should run unlocked, because inside it are 2
  phylink calls with incompatible locking requirements: phylink_create()
  requires that the rtnl_mutex isn't held, and phylink_fwnode_phy_connect()
  requires that the rtnl_mutex is held. The only way to solve those
  contradictory requirements is to let dpaa2_mac_connect() take
  rtnl_lock() when it needs to.

To solve both requirements, we need to identify the writer side of the
priv->mac pointer, which can be wrapped in a mutex private to the driver
in a future patch. The dpaa2_mac_connect() cannot be part of the writer
side critical section, because of an AB/BA deadlock with rtnl_lock().

So the strategy needs to be that where we prepare the DPMAC by calling
dpaa2_mac_connect(), and only make priv->mac point to it once it's fully
prepared. This ensures that the writer side critical section has the
absolute minimum surface it can.

The reverse strategy is adopted in the dpaa2_eth_disconnect_mac() code
path. This makes sure that priv->mac is NULL when we start tearing down
the DPMAC that we disconnected from, and concurrent code will simply not
see it.

No locking changes in this patch (concurrent code is still blocked by
the rtnl_mutex).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8896a3198bd2..4dbf8a1651cd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4624,9 +4624,8 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 	err = dpaa2_mac_open(mac);
 	if (err)
 		goto err_free_mac;
-	priv->mac = mac;
 
-	if (dpaa2_eth_is_type_phy(priv)) {
+	if (dpaa2_mac_is_type_phy(mac)) {
 		err = dpaa2_mac_connect(mac);
 		if (err) {
 			if (err == -EPROBE_DEFER)
@@ -4640,11 +4639,12 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 		}
 	}
 
+	priv->mac = mac;
+
 	return 0;
 
 err_close_mac:
 	dpaa2_mac_close(mac);
-	priv->mac = NULL;
 err_free_mac:
 	kfree(mac);
 	return err;
@@ -4652,15 +4652,18 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 {
-	if (dpaa2_eth_is_type_phy(priv))
-		dpaa2_mac_disconnect(priv->mac);
+	struct dpaa2_mac *mac = priv->mac;
 
-	if (!dpaa2_eth_has_mac(priv))
+	priv->mac = NULL;
+
+	if (!mac)
 		return;
 
-	dpaa2_mac_close(priv->mac);
-	kfree(priv->mac);
-	priv->mac = NULL;
+	if (dpaa2_mac_is_type_phy(mac))
+		dpaa2_mac_disconnect(mac);
+
+	dpaa2_mac_close(mac);
+	kfree(mac);
 }
 
 static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
-- 
2.34.1

