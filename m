Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C5A434980
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhJTK6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:58:49 -0400
Received: from mail-eopbgr50059.outbound.protection.outlook.com ([40.107.5.59]:17134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230173AbhJTK6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 06:58:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRVQydCjAY/pOA23vfwaphDjue+nRlpyC6Dv/hUb3tgIgBq3fWiGNC/FbM493ZBu0f/qbNPgtMfDHAjEhaQY+NaHW8HOuoetyNkOqP2F4fgNOxA+GZ0WZxRLV1ADLnqRfWnFZD668eWQlAbvdUai9bL02XqdgYMmSQkI626yJc2nGFvFTL3sxYKwRQcagDDi1kyTVQzKbHFGJ4gD0TtZOCf1X6nwuvPqii5aOIvcCNzV1jC8TTk3sgDlmquA2knRekqd6mXb+6LmVkd8+v4FrtcQ1kCrh1U8ZB4+x2BScD5MixgiWgngULrsy6Xu5V59vOlpy8/oRAKa8nTWsYqa7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggB0pvW0iFG/eIrkDpZ+U6XLGn0WOPNIMmRlgcd51Jk=;
 b=MBxrR1zXeEcym36NyPDKM7IaUznMdvDQMFOqtimWqKPE174Bxq0c+cEHSAZe9jo6Wxzv0MzKBEkqd6CGcZ3Sv7g8bQRgI0YXmKlXIAaGc6kKKzBkE5Iy7vYT/SQR4ARPdRv9qT5FjQ5WL6JQbiz83+d/c8UzrA7zbYPGsXuWshte6ry5Mr+AlGypVdqkJAgxeiiVixHlw7kLpwVL1kSrD5xfr6OI4ncTNbB0fG6eeRYlyPn473UeSqGXpw56Rp3ZVBOg5KQic/ysKXQpKGRg6sDMHPP+IFuDAx5k9e8Xb93xMPca4+earz/qfpwj8HxkpXQwSaDJaP1W0JihF1ojVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggB0pvW0iFG/eIrkDpZ+U6XLGn0WOPNIMmRlgcd51Jk=;
 b=qD7ELwBcFHecvt1m6u0Ofj7nFXCnL/23EJRTtGRmQbYGnVvzoy5SZAwB5FcQ0pfbJ0Jv+lQ9Rh0B8lhzg0S2wG1kpQfTBe4saFtzISIrMOcV/WW8ENXfjucDbNZUgjdhCjfZIyEgqldNW3p3N8zOdxvIrcWfpZSnAz+twjo4lkA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 10:56:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:56:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 5/5] net: mscc: ocelot: track the port pvid using a pointer
Date:   Wed, 20 Oct 2021 13:56:02 +0300
Message-Id: <20211020105602.770329-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020105602.770329-1-vladimir.oltean@nxp.com>
References: <20211020105602.770329-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0111.eurprd05.prod.outlook.com
 (2603:10a6:207:2::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0111.eurprd05.prod.outlook.com (2603:10a6:207:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 10:56:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be0cff99-045a-4913-5546-08d993b8451d
X-MS-TrafficTypeDiagnostic: VI1PR04MB3968:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39684AD048072AB077C0C8DCE0BE9@VI1PR04MB3968.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gli84DKdxLhvzmyYCRcHeYkIylumliXv9BY/7/79QWVOJkUj7u5YC8viujT06R21/v3N6a+rXvNwEUqdwwNrJN7gsSHi71jKmhcW8i9BpDhmkAWt7LqATuNIV1DGGW0iTiqSOnpuJ9tLMog1brZSgDZg/3KaobvJ8sJQSC/4J/KjoW0O7wysmroCDwl7HVibvfmF4AppHllpu+teFoSAkZhwUrvgRnrjjQJIjzhr9CjB4JtgjCP2F5ipcT5JPy6EMchfcTIVstV7cLogCvWeuDAQA26iWRIPE7tvJQ2/VYO6WFTXtTptHx+0nP9FFhqA/BllQ56VMUmk36xeMGE1aBktLU59HpkoVfELM4tLoigMbZEwF9mO5NySvrkgwbClXjKN/JG9jBcodq7LucaR1Yqurn/bOnTeVlxp0ECnXgHBI9nzXYHlYxoe3ZZOU6WmglwcNvmpuO35EDiVAS91qMi/Z2cYzhxHQGrXi/w0Z3fgZdsLgIiKRZYI26KlsdrEUMZ70TU1oFpBm1Wcw+nzvkKfoqbTXU8gVNGRMZy+iW6SHgLOC7rPFNa7dscEaVo5ynjB2ikxuqLMVPBNH9EwR6C/rsij6NLcdZrwBs4J5QORF9bnl/BmzgdLK7znwsTEdKvIFJfNbWT2IgDsn5fMWSZfONTrzM2I2Yiw7q3IRG/zN/gFGxQZlbMe/yDG5BJkDHr6zD6BT6IO7K4m50rjvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8936002)(2906002)(8676002)(6636002)(66476007)(66556008)(4326008)(83380400001)(5660300002)(52116002)(6666004)(1076003)(66946007)(44832011)(38350700002)(38100700002)(26005)(6506007)(6486002)(186003)(956004)(110136005)(86362001)(54906003)(2616005)(508600001)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E5wQxhQfH8R3tEamiD2OFfk3AfkcjDhCsAUJ4AZ6pZ3McLHUbyn/cfl3tjJ5?=
 =?us-ascii?Q?LyCrhbH7MxGkp8zNXacYKWXOSj4s8EWCB9JHe5lRojF8+clm7gFMjH44FHo+?=
 =?us-ascii?Q?JWCD1z1Kl4td+hPAjFVgLcV+1otSUjEgBX0XvNE7eIO4jXQF0wuH141qOcOr?=
 =?us-ascii?Q?ODQIv4Pnr1n7MEk1GVn8iUKquMj/0mzV2y2ZRMLWZY4yM1KFNGxWTbf253v6?=
 =?us-ascii?Q?FA8FxbrSPpv3QOQlq+Olo7izQKxgjrQLyavsFtfP0NGqz//RpEl3NRdzDqvw?=
 =?us-ascii?Q?O0oRFtH9OW/C1DRQLVnXQf7mtRDlZldoN0b1j2QiYKkg+bCS1Uwav4M5aXPL?=
 =?us-ascii?Q?KhDCL2LAv0ctX0d7PODiNkQNW6bbqPOSIQPADdTkcVrpJgn8VG7P89Y0pdRS?=
 =?us-ascii?Q?R49zqBmmEWH++GFx7GoGuZLSZNqZZS9bqC5a5HAvZm7OmKo5lW7FO0ClD9v3?=
 =?us-ascii?Q?wd5645ZM6dt2qMgfCnyDiKHe6CApQ0vHzmdWXnu8AD2R6b8OGyM9QQGbFwr+?=
 =?us-ascii?Q?Y+TGBGP4m1Qcid+pfnhj9jcAs5jkuiRxQ5piRfX1cTQxdUTJx7sHe/iHF3O4?=
 =?us-ascii?Q?XqFLmDHtv1F9ekdhAy9OIIhmqfCTkC7EnngaVcNSQOVlGsUN+0M1ntgMnu7c?=
 =?us-ascii?Q?0roLbqqLpgulIGQwplk9hVjMvHs3+gy5B5GMPbUfSlMxLMwjnZ2bGvveW1NJ?=
 =?us-ascii?Q?kKPDAms1pb92Q13oR0fXK6u3pT9NCTMkVbv5Tdg5rm6kG94A5X5pSlc/Hd55?=
 =?us-ascii?Q?4RPnzny+MagGeEnuifqqsiAkOOeAE3P6erUaUHsMJBgbolSXT9dXUol0narE?=
 =?us-ascii?Q?zE8RiNQeXy4lPX0mOKrJm8Ik8xRyrqD62nOPWuaGblu036Nn6ylAtR/F6qOc?=
 =?us-ascii?Q?f7qdo/TkItESmc9Gok6+uWVa7c0xhqZdjRPiV08FeQS+8WQrzeHZFzfpQ04/?=
 =?us-ascii?Q?2cIUWYlgDjl/l3nsDEJ0p787wqv7ZxoX2l5ZB5WA36wBxLt6GKbsjn+wr1Hq?=
 =?us-ascii?Q?n91w78kVqp71I974Z8Jq3mbNejV+LTFrj5bHO/w04YYJw1bdZFxBn3XmW2aP?=
 =?us-ascii?Q?jDzzNcvHh7LOMAO5OpPMPJVvwI9hOW668uGffG7hAap95RR9mn5k9m2SiSIV?=
 =?us-ascii?Q?tk15OjWuT8CJp6yYv9OsaNoGlQdhAoFfVO9pv5IWcuxX5MU5Kaqgr9JEKa50?=
 =?us-ascii?Q?65MqMt+cwZEycXNJg3MLRC6AbE3m65DFp2ITWEEleigS3d06NDwOBpB8ghTM?=
 =?us-ascii?Q?tGFyaP3A/YDGwCyogLW8YoZF5acVPyrajxc3y1HlJ0ivVp2k8AkXvN1SHp2/?=
 =?us-ascii?Q?UMgP0bRsWhce5jUbHOoWhJs1dbf52bw5h6WGFudAAESHyOXLWTz5RQVcv3NW?=
 =?us-ascii?Q?3dt2DXvaf0NV0/sPTa9lR601gFxtwSERKjQGkjpG5FjO8N5q734R15C78vet?=
 =?us-ascii?Q?gV5/ZA6KzpqTJFmoP9njH09nS3yQlUVtCnTYkFIUi7BBVZ3kBUBQNS3DRFJT?=
 =?us-ascii?Q?AaRi4nBRACpsJPvzfWfD/3jp1CoaPSKSLUCQNQkdRPJH+ryqE7Bdk/nzTeIm?=
 =?us-ascii?Q?1AJik4MrYUrvmfxEzu+0LFhF+cA9SD4/cMJpZXdJ/XZK2aV4FxBOq9lAcyQX?=
 =?us-ascii?Q?HEz7cVtEZgBuYRPCWar1HaE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0cff99-045a-4913-5546-08d993b8451d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:56:29.4840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtYl/VT93xhZKMe7KFp1/3gIY/vbpUicL0SW2Fgf0/dqi1ifN6/kE3kpHZxUbHJZNWEDJNDZJHZ0j2NRb14+gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a list of struct ocelot_bridge_vlan entries, we can
rewrite the pvid logic to simply point to one of those structures,
instead of having a separate structure with a "bool valid".
The NULL pointer will represent the lack of a bridge pvid (not to be
confused with the lack of a hardware pvid on the port, that is present
at all times).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 31 ++++++++++++------------------
 include/soc/mscc/ocelot.h          |  7 +------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 30aa99a95005..4e5ae687d2e2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -260,18 +260,19 @@ static void ocelot_port_manage_port_tag(struct ocelot *ocelot, int port)
 
 /* Default vlan to clasify for untagged frames (may be zero) */
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
-				 struct ocelot_vlan pvid_vlan)
+				 const struct ocelot_bridge_vlan *pvid_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u16 pvid = OCELOT_VLAN_UNAWARE_PVID;
 	u32 val = 0;
 
 	ocelot_port->pvid_vlan = pvid_vlan;
 
-	if (!ocelot_port->vlan_aware)
-		pvid_vlan.vid = OCELOT_VLAN_UNAWARE_PVID;
+	if (ocelot_port->vlan_aware && pvid_vlan)
+		pvid = pvid_vlan->vid;
 
 	ocelot_rmw_gix(ocelot,
-		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid_vlan.vid),
+		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
 		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
 		       ANA_PORT_VLAN_CFG, port);
 
@@ -280,7 +281,7 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 	 * classified to VLAN 0, but that is always in our RX filter, so it
 	 * would get accepted were it not for this setting.
 	 */
-	if (!pvid_vlan.valid && ocelot_port->vlan_aware)
+	if (!pvid_vlan && ocelot_port->vlan_aware)
 		val = ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
 		      ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
 
@@ -445,13 +446,9 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		return err;
 
 	/* Default ingress vlan classification */
-	if (pvid) {
-		struct ocelot_vlan pvid_vlan;
-
-		pvid_vlan.vid = vid;
-		pvid_vlan.valid = true;
-		ocelot_port_set_pvid(ocelot, port, pvid_vlan);
-	}
+	if (pvid)
+		ocelot_port_set_pvid(ocelot, port,
+				     ocelot_bridge_vlan_find(ocelot, vid));
 
 	/* Untagged egress vlan clasification */
 	ocelot_port_manage_port_tag(ocelot, port);
@@ -470,11 +467,8 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 		return err;
 
 	/* Ingress */
-	if (ocelot_port->pvid_vlan.vid == vid) {
-		struct ocelot_vlan pvid_vlan = {0};
-
-		ocelot_port_set_pvid(ocelot, port, pvid_vlan);
-	}
+	if (ocelot_port->pvid_vlan && ocelot_port->pvid_vlan->vid == vid)
+		ocelot_port_set_pvid(ocelot, port, NULL);
 
 	/* Egress */
 	ocelot_port_manage_port_tag(ocelot, port);
@@ -1803,11 +1797,10 @@ void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			      struct net_device *bridge)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_vlan pvid = {0};
 
 	ocelot_port->bridge = NULL;
 
-	ocelot_port_set_pvid(ocelot, port, pvid);
+	ocelot_port_set_pvid(ocelot, port, NULL);
 	ocelot_port_manage_port_tag(ocelot, port);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b8b1ac943b44..9b872da0c246 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -563,11 +563,6 @@ struct ocelot_vcap_block {
 	int pol_lpr;
 };
 
-struct ocelot_vlan {
-	bool valid;
-	u16 vid;
-};
-
 struct ocelot_bridge_vlan {
 	u16 vid;
 	unsigned long portmask;
@@ -608,7 +603,7 @@ struct ocelot_port {
 
 	bool				vlan_aware;
 	/* VLAN that untagged frames are classified to, on ingress */
-	struct ocelot_vlan		pvid_vlan;
+	const struct ocelot_bridge_vlan	*pvid_vlan;
 
 	unsigned int			ptp_skbs_in_flight;
 	u8				ptp_cmd;
-- 
2.25.1

