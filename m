Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1586BF126
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCQSzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjCQSys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:54:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44463928A;
        Fri, 17 Mar 2023 11:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMr8NKU5IA6ewurLyGFO693Y7GEIkGsENDaKEYVqf6OPcAeFkZ5gyCenbJp3Z3teqKyvJDrySyTG6lwWYZNqmwc7iAy+uO2ToJ/IS00Q+AE6VaD5nMud96X1YMP8rBjWUPRj7dmHdK6MU0eF0lrOxgOCbClxL+RuRjDJeIBaMrG7uzdeYklZqppjQMOBr+tGDH7zk7p/kOiVMOE0zhlN4e0b3KGCqlxbdTY/PoqwxAbg5gUPk5HfunzR+fGXSI36uoscjf15rF3bl6n0rEOxHd/+Fv7hcW6DLbpaRQiD4O0P7gTebG/40fBsitWN60oYck2LczlTO5fZBBVPscqopQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+0ufdUKS0RnlyM+q4OcDc8qdZPRU3YB4wxPLaAJjtxM=;
 b=g6X1PcqXnfXZh2PlifCnRk/YcWw4qrM4Zz1PIp2/MQ5gL/VNqKDGBJDGAZcp9reG8mOPtdMQN436uJb2aDPzACYgCaAuHLo5Wy5sVTN6JF1w5Dxryslo+rUCAZ6wZAiaFIeHGDOlYn7KjMay6T2qcEw9Hx+L7q7i1718uUw98qmvAFfemI/d63nfUa5JrlyFjthiuse09VU1As58afSwpKr0eSHGLKUbwrxSi/fv+8PsmdQkypNXh5rTLrmv7ZxxyY/TuKx8OANSTGly12p7AS68UlTAqjt6lRlQSOvrC/PcfZMrVXUDaPDEPJ4BHwkkptg6ZQ/7bRKfTubBsBuYmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0ufdUKS0RnlyM+q4OcDc8qdZPRU3YB4wxPLaAJjtxM=;
 b=YyezYYw84v/6OP5YSvPE76ufgy0PNJ0sWyJ+kiiIB6+0Wimxp/1IbJu0jKUThNF6aQLc2ZBwPhFRDdyw6+2R3JDJ53VMWIJPuwFQzvRfPeOngOLHbNki1TnRQsH3UJhm2/QjXPGxw7uIuB5Ucez1dvC5MUV+V3CkqQOTsps74u0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5289.namprd10.prod.outlook.com
 (2603:10b6:610:d8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:54:34 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:34 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH v2 net-next 4/9] net: mscc: ocelot: expose generic phylink_mac_config routine
Date:   Fri, 17 Mar 2023 11:54:10 -0700
Message-Id: <20230317185415.2000564-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5289:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d969a9d-5986-4a35-a3e6-08db27190c7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ss9/WuWuUcRlUEwiquVB47MHmZKl9g9GHz91K8MxTcU0OOqaEuh5+DzG5/XRyVZsdIYneyRfnmGiPJihNYY0yDsk83mlgyorvYHtW46ejyGE+xPTzgINgpcM0z9ga1zNGo+p7ZNWCrs5ReyXXO5RTksij5joJXl7RGok2YE1eQsw88Ycum27GaQr5eAe6bd+D5HBbliPhDHeuNHsUaHfotvUgCGvclutd1h5B+5IG8VswBZDOkVvgWNqFkoI7aB9jM8aaxg8DYM0j5W3V3TgVZkz/CJuiyYgzseyyvYUqR0mgS8udvr1qcFRrNW6MT7WqonGhfljfHBVzxmcjQ8zu5IUWORbCh9cxYnUrwgxs2GnCcfXBnT7if+/eQgvuCWpFVhVM27U6+NE/AIR2i1jf1ojbPECLhi+MBXZWfWrjL//suRe5gIOJGZCBu6JkYsLDq2FGkJ1K0n6mo06kdaF1f3EGOXTdhh5GlUP38oVryN9hDuEHZmwoXY7PTZOAX2q4hgy4Xt6vOxz+lYCN7QQGSfhmsJPkuBBSRCWEjqy/WLAgM8GBL2gLZm4Yv/fEjo9WRaaQxYS+EkElmZWHzaBRQU8MqR2W2qHbFaTX3VNKZ4kTFu7O4GGT36YIJNRaJkBV3MAZ3cFiNh24A56Wiub8RjQ4rcYK95Vo6dbi7uv5rI9QWYew4u/Zz7Tp9YhH/PiIARlC6blLVV+ae79B6dZ5KrzH1C6xBqsOxrWP0FedcM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(376002)(136003)(39840400004)(451199018)(44832011)(41300700001)(8936002)(5660300002)(2906002)(7416002)(86362001)(36756003)(38100700002)(38350700002)(478600001)(52116002)(8676002)(6666004)(66946007)(6486002)(66556008)(66476007)(1076003)(4326008)(83380400001)(54906003)(316002)(6506007)(26005)(2616005)(6512007)(186003)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E6/gKIXLXdVlJ+FS/53UwG0IV0CV/S9mKJoW9K+Dkmk+Ibb5S6ZWfOXzAKuy?=
 =?us-ascii?Q?I8LXxB5Ia9HTq6hJr7LIBKPtb3Mw9cRG8i3l3TuVjR1umlBcnpwKLdYYwTdS?=
 =?us-ascii?Q?U1egJPRy6DsIMfAs5GRSJxq4FZaQbiUG3bcAj1wRi0ggnWj/5bPBEKcCvZEQ?=
 =?us-ascii?Q?XQeBtJ3w+7mhV7Ub+75aPFJCP2+Mzxg+1COsIT09CVskInK9j7AdfIpHV5c3?=
 =?us-ascii?Q?ox/LVFYa35FV5I7M2W4+wN9BBSllXRIoVRh0hu8Jbu81eI7m+MWjak/UhLOP?=
 =?us-ascii?Q?dFsPBcXweUZXuPZqhvQ1KOQUXkqWdB6/mqlbsJW9/MWN4x/l6D8tcDnyuGEs?=
 =?us-ascii?Q?Pg/44lRoV6E7htoxsAaraSHnQ6RolwTRfRoFbxsOaNdTGL0ReVsASaNRhjF8?=
 =?us-ascii?Q?MDniq+S6590AIoGSkYs+VaTfMdubzMAKJixaC1kdtr89RVdFsgiRCyb+KH3M?=
 =?us-ascii?Q?Zb3Zo7A2HaYGugqYmbDoEW8oo3BlJkYASuFAmSVLk0sxIHMTBGUTBJYzncnT?=
 =?us-ascii?Q?0AiWy6JDJij0F/zXx6A4ZvwwSMcRXoBZHkYWYZUvLAIPxPglQ5Tal8OLBbCk?=
 =?us-ascii?Q?moUJDrUVMXlDUedpdPyHCOXViNujC0Yf8RhLO4x82b4w4i3fDlQkyfj2nHqB?=
 =?us-ascii?Q?J6Nl3MA4w81wufgg7GS/TiZI7kBd48vghOqzF0n4aZhS5mFErqT70s9KU+9V?=
 =?us-ascii?Q?jXqbDHW9r4VcDHnxu/IX2vqrWngwI+1YhQmqvDrQniQFfd7PAln+9c5Vr539?=
 =?us-ascii?Q?0nsEqhZJYpkSFGuOYEezVHvQ3Q0YV2q5foI6t95ykwxzUsDB5gAtXyPbCiQO?=
 =?us-ascii?Q?5rguRb4LLuA3BswP58opy7/+naW0UpbvQm6yfuO0G/j4RIgGS1MR6IEec975?=
 =?us-ascii?Q?lvrmTUkXMPLzQ1eKialRKqmH7FTL4xH+6mkstLEpL6UGOW2YuwkoceXMI0jd?=
 =?us-ascii?Q?ehyt3ud1pblhPZ0jLxEcUs7h6QqV7c8h2TVvrZt9CIQsQjtpR66G+udiCL+y?=
 =?us-ascii?Q?xrS88Ciwn0pjk3vD2Ow104xhJKo8IMQCuKQz/wVlP/G2lfy+FUzs7ipHKsc4?=
 =?us-ascii?Q?UyXhSXEDSz0iSLNEskwqoNpfyxzpSQhovzYCOXI5osnpl6rWRiN1YVjAbWLw?=
 =?us-ascii?Q?UmK4SxfpRBIu/rDQhwv8PCINn01dB5h2HIqEurSvOMoBZmIVV3qmjuG2afHE?=
 =?us-ascii?Q?VqaHr79kkkblW9PGGUUw+G5p6kxTnY2ItkCANUveprSb/i2KH7ft/+Xc30UJ?=
 =?us-ascii?Q?tjZJX/c4vDt4QC0zo6bn9lk8MafalB+9kjnOD4BYOZ3hHqj48PP6xRXnSHbf?=
 =?us-ascii?Q?/UKk3WPfAhzqVHeIawN8A+2tPfarAwaPuVovY4smEl4bqv0TglNzC7hX5tYE?=
 =?us-ascii?Q?hUArcessnJEyqIIBE0exk4GBuN7zTj3ZezJovaAvmKrapXKb/Mp6kNE2+2x1?=
 =?us-ascii?Q?JcxqZykOSTK0xpBpm63ltEzPLbXc6wt9ZbGygS2pfImwyseBwGKTwIffaEeD?=
 =?us-ascii?Q?9YkMF2X+B7BnyOO1MS8MHutMQlR9ZqcDZzyX5RbqRzj/eHLznwdORN2tLqad?=
 =?us-ascii?Q?/3BZhJDMUdBJ6Es2xKPm6LqOIZyoQOtlRqxEPI51RCbLItevGkK+0WOOXz5e?=
 =?us-ascii?Q?mZcz9LG0HF7O2aXwGye5ZUo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d969a9d-5986-4a35-a3e6-08db27190c7c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:34.2092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LllJtHX5OQFFSvI1WY0rLiLvlf2v+krwT8g0bhQAPAx2FcNwhPcz+MJAYhfo9k27rhjkTghwTcMQyqIpbHQlF8bDasGqhpefSBZzLj+iag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot-switch driver can utilize the phylink_mac_config routine. Move
this to the ocelot library location and export the symbol to make this
possible.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 -> v2
    * No change

---
 drivers/net/ethernet/mscc/ocelot.c     | 26 ++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c | 21 +++------------------
 include/soc/mscc/ocelot.h              |  3 +++
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9b8403e29445..8292e93a3782 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -809,6 +809,32 @@ static int ocelot_port_flush(struct ocelot *ocelot, int port)
 	return err;
 }
 
+void ocelot_phylink_mac_config(struct ocelot *ocelot, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	/* Disable HDX fast control */
+	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
+			   DEV_PORT_MISC);
+
+	/* SGMII only for now */
+	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			   PCS1G_MODE_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+
+	/* Enable PCS */
+	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+
+	/* No aneg on SGMII */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+
+	/* No loopback */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+}
+EXPORT_SYMBOL_GPL(ocelot_phylink_mac_config);
+
 void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
 				  unsigned int link_an_mode,
 				  phy_interface_t interface,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index ca4bde861397..590a2b2816ad 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1675,25 +1675,10 @@ static void vsc7514_phylink_mac_config(struct phylink_config *config,
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct ocelot_port_private *priv = netdev_priv(ndev);
-	struct ocelot_port *ocelot_port = &priv->port;
-
-	/* Disable HDX fast control */
-	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
-			   DEV_PORT_MISC);
-
-	/* SGMII only for now */
-	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
-			   PCS1G_MODE_CFG);
-	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
-
-	/* Enable PCS */
-	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
-
-	/* No aneg on SGMII */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->port.index;
 
-	/* No loopback */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+	ocelot_phylink_mac_config(ocelot, port, link_an_mode, state);
 }
 
 static void vsc7514_phylink_mac_link_down(struct phylink_config *config,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 751d9b250615..87ade87d3540 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1111,6 +1111,9 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 				   enum devlink_sb_pool_type pool_type,
 				   u32 *p_cur, u32 *p_max);
 
+void ocelot_phylink_mac_config(struct ocelot *ocelot, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state);
 void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
 				  unsigned int link_an_mode,
 				  phy_interface_t interface,
-- 
2.25.1

