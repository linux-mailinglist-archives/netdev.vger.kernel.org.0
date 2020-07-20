Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9795225CC0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 12:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgGTKil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 06:38:41 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:52395
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728273AbgGTKik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 06:38:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlDNi9UgeK4JxwWcKWA+uvkVjUpeNfP6fMsVnM7N5DBYLGuWhIAbEigna5Rki5xuvavHW0DWFvpNKDLVEQSYmHwrtxC3j3plQ4weZgoQe71cIrm0J4l3LZCQLVZ60n++xTSsWbWfDh8zpPSE4ILv3BNKZXhYTUy3y0Mlzyz+geWr6ZHSQThMpKhGqtZ6tlcbzygmXYJfxxVjsSghVSR/gorw3AaokBM3e835Nfi3PefQcx9gLfmWab7KMThaJt/JZPM5aMdPKYS/gDPLV7gex21ZuY+vEObzxUItujy8w7i1RD3P4Z6wE2TjSG5nInsW4QUi6odtzV03lSfVjmMV+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q24WVoc2ZJ7kurQdO+/TODmFq9VAGIpvbuXMnLkYVk0=;
 b=CaikOugZxAWYVQXn5bwZSjDl8O5bFsdXTg6l5xkaWSYWP3e7Wlde93ZaylukfXegwcz/aVwr+4ZwUhYs1xktooZk0Pul69mHDz0AmblTpE1JGkigEzsFJrUXpJv0Rwx/sDAfPPTai+HbfeKb1eR+PS+J0/VXCj9+PA1BJRVyg8QqTAwhl8CNJHb1+3/VMt+KlCK/VFhusr/u6Uwdkmbsg6GDhFxoFwhailBCTAGFWn41a8Y6pKTMbJnZZWQrALZCj/adKNejplyvyMkDP75Y9bigISdnJRvAVqLOuxdEgS7nyr7j65SX0P3zqULFc7iMD8djvWF1HVrgCnS1ul7Gmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q24WVoc2ZJ7kurQdO+/TODmFq9VAGIpvbuXMnLkYVk0=;
 b=rIjOLrpGmav2t1BqifjS+x2YstEX4OF6yXDRwnoU22FYEtcn9C9jlhlH9HVEXsAVRbO3juWePFJUcMuzXtJd8J1+2WJRUUVtlr9mX75gPRrpe0G8oEr6ll6jep2N5gJ9SjKLF122hvqWfTaQFVkUYMJpBiiYE9UE2+YmTJBnifY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5005.eurprd04.prod.outlook.com (2603:10a6:803:57::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Mon, 20 Jul
 2020 10:38:37 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3174.030; Mon, 20 Jul 2020
 10:38:37 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH 2/2] net: dsa: Set flag for 802.1AD when deleting vlan for dsa switch and port
Date:   Mon, 20 Jul 2020 18:41:19 +0800
Message-Id: <20200720104119.19146-2-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720104119.19146-1-hongbo.wang@nxp.com>
References: <20200720104119.19146-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21)
 To VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Mon, 20 Jul 2020 10:38:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 18860973-a711-42e4-430c-08d82c990f4d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5005:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5005CFFF60465741FD2502F2E17B0@VI1PR04MB5005.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nbscx/u9+gTMEY3Dxicaqzb3O5z4J/T3pjfMDWCnL8jcw4w/FLLHaeKqMlSS8kOXURDk2Ead/myCFjZz/XelfyG+8bcVfw1urUJyyX0JJNGwejjhkNZ4Uhk3wJnnf6wfxA6vCiM3trizkRXhsSg7qXPjFzIbvKysvoP2hF8RudwjrwSGebQfithoBbow8Ja7xO7dGIW/a2et1IhS4SGn5YyH1ZlxBJaxOTAHcICtP5gQrxfUPYR2PZT/n/ySrNQd4H0tykVPn/ANnK2WHORn7UHmGcceYziDsaUaZkCgk98PPuQag6ipPoWpwpiyZL2jxcUopadkb4NgU7wS9ukGH+niPYG72ijzTsr8fbwLPHuM2/GY3d/3nWFW+IQaE+pk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(26005)(2906002)(316002)(36756003)(7416002)(83380400001)(86362001)(186003)(16526019)(52116002)(66946007)(6506007)(66556008)(66476007)(6486002)(2616005)(956004)(6666004)(9686003)(6512007)(8936002)(1076003)(5660300002)(4326008)(478600001)(8676002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hImW8UNM58SdswF+zx7hEOi+nlRsaCHe7Dfxi/BsTp7yrrOiMpGuMGvhqPpAgA5Y6RhMs6Ehcm2AaPTG/h6cAFPSQKCdt+MIFVh8tc1ZtgZhg6H9oBCwawHHV/m3y2hi2js5/4+JLRHN/wbYgYiTpMi4qFJTWxyt/l2eW/5ZPOTLvTrDdNhjPcwIKK9vFpo9f7MjTyPQKJFmIg2o0DTK8OI0tm1bptS5Z8/HQOPUEVyVV6qlBdycbyMrDbvUHDjaVipp7aK0Py38CdxJujRL75pz2ftO8ftinnrCciGOkxNUTW7NZoOoXWIRRsOkooLUj3UdUXLzHaQgGhF6lpSpg2UqpaUQ6GPIy8YSxGdN4Ki2bjjc0KX7CSPlHUw2qmdnS2XdUyKJp3V879uDETyYdDEODD+Nkql3+A4i0FfAsfHkYAKRstwBvX7aMUJ3R5MWnUDv0HYvHBu0i7dXo/FikjqUULoTvNnCW/yi60PsZIg=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18860973-a711-42e4-430c-08d82c990f4d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2020 10:38:37.4243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxDuDfVqeyIJeabrqxABrRNZrFB0ezB09b2hb8c+pCFpF06HdpiV7cQpBV6g+YKRhbRPvwVjro+hAowkFv6Www==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

the following command will be supported:
Add VLAN:
    ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100
Delete VLAN:
    ip link del link swp1 name swp1.100

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 net/dsa/dsa_priv.h  | 2 +-
 net/dsa/port.c      | 3 ++-
 net/dsa/slave.c     | 6 +++++-
 net/dsa/tag_8021q.c | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index adecf73bd608..5cd804c1d7e3 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -165,7 +165,7 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags);
-int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
+int dsa_port_vid_del(struct dsa_port *dp, u16 vid, u16 flags);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e23ece229c7e..8a8ecb91a030 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -454,10 +454,11 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
 }
 EXPORT_SYMBOL(dsa_port_vid_add);
 
-int dsa_port_vid_del(struct dsa_port *dp, u16 vid)
+int dsa_port_vid_del(struct dsa_port *dp, u16 vid, u16 flags)
 {
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
+		.flags = flags,
 		.vid_begin = vid,
 		.vid_end = vid,
 	};
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 376d7ac5f1e5..14784a6718a9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1270,6 +1270,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
+	u16 flags = 0;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct bridge_vlan_info info;
 	int ret;
@@ -1290,10 +1291,13 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 			return -EBUSY;
 	}
 
+	if (ntohs(proto) == ETH_P_8021AD)
+		flags |= BRIDGE_VLAN_INFO_8021AD;
+
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vid_del(dp, vid, flags);
 }
 
 struct dsa_hw_port {
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 780b2a15ac9b..87b732c5cccf 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -154,7 +154,7 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
 	if (enabled)
 		return dsa_port_vid_add(dp, vid, flags);
 
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vid_del(dp, vid, flags);
 }
 
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
-- 
2.17.1

