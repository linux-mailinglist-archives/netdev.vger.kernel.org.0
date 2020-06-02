Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000261EBA72
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgFBLcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:32:18 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:6161
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgFBLcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:32:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTHwUwO5pJdom4iUMtblH/oHOYYPb/vcX6WKrXn7J0TEFGulEivjgqOPmD4KAk8jmTyICZrLUmYUrSbsTO+vIPUNU20Ai+6QcCslS02JH3FJg4u8Lrv+e7hYGbU5R0GkUVA/2OZuI7n5lUYLjsIHsCABqrNJDFzlpLmn2PK4Bm1By0ycE3KdZCvZc/tN9KIhpwB8WBAmrTrPhm+dIqrWgd+mflN31jFsHMmNSI/2FS0nKgHiI0yNQhRZm9cWWjFV6UFUhfIfGzLC9O4rJbPE85/lCFT1vsoOllHy70bVBvJeHkswYnxbtODHFkxeWFVF2s7VT6NRq1xxwhu7+sdYzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gq5wth5oUugThJEeHkqYsiQPCoAg7LbBLQ4oyJNNruo=;
 b=UgwK/Pp1ha7GEDEcvEghacicBT2Vr+sw4R7rphRp0tmcJnoS+m1W3/e2sTnKJb6tUcaLpb2pNBnTnMzvHKaMVIscQl31Wwddic1Js3cf7JCmBhMCMx04f701WEbnXAvp9wrTAZXRTAOsbMJiupvFx8/iNNqMCJx1gsygt3laMU/FbT/M2xrMkXP6nmcGXKgS5GuD2fos4h7B58RnljHbAlCnNfz5pVP0d9Sb9rS4QBHA1p14PGmslV/XAMFlBRTnt5X/r1e+V8ssqs9qz/pfFIcBjfFVwwUmNfNHWKd/gLvK8lPRGbhonYV03xlXZ3DObrghvkbYlDKGxdPlEw5Cag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gq5wth5oUugThJEeHkqYsiQPCoAg7LbBLQ4oyJNNruo=;
 b=l/t6w3CMzf2dCCX5s1q4uDxMpXL9duSuoUJHVUF+c/bwkfePvukpq+/B/1XruS4EEM6QYLYlQzSQfFe594mU5xZh/4Dn0Xpr8ajfdDyQplLeSz9cqEJ0KXHblB2kOgnTRkc2ALLAPSHdN+FbuGoAltc6mMLAWnPBGKUk2JJZzDs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6628.eurprd05.prod.outlook.com (2603:10a6:20b:15b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 11:32:04 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:32:04 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next 7/8] devlink: Add a new devlink port split ability attribute and pass to netlink
Date:   Tue,  2 Jun 2020 14:31:18 +0300
Message-Id: <20200602113119.36665-8-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:32:03 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a1586650-8d97-4d06-89e6-08d806e8931f
X-MS-TrafficTypeDiagnostic: AM0PR05MB6628:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB662823E0CDA6AE2348EA5C77D58B0@AM0PR05MB6628.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KyxOvnc+fQh76cCgj4j2PxkJ+0RtMIw3zX4xG7zCB/s7m9pyluwnTw9dLBYhUBM/7SAIB5G/ObegoIuxrBruwA2T1wnbGi0cpxjiaY8KJVuV5mr3I4civ9YgGUH481XiRiEPbQzEdMAZvaSLbohuRAppNOFdSKAHPfD73VeLHKAcBTAo326k2tMv06otJ3enjjX6wcQUN9VBC3O+jQFPWxAhI0ZRkb0fFTkN8Sa3Tzg/W3uTxLUxR61ZLxuvnt5vNVXFjROyyyzAhkZ/VmONn/5pg8fpuPISiNDzY3blL/4HdtnCib+horsS9scvAaKq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(186003)(16526019)(26005)(83380400001)(6506007)(86362001)(36756003)(2616005)(2906002)(52116002)(107886003)(6916009)(956004)(6486002)(8676002)(7416002)(66556008)(478600001)(6666004)(6512007)(66476007)(66946007)(5660300002)(316002)(4326008)(8936002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eiwHYR7uJAy8EMBkOXHxMOby8rDHEAmX3kkJLK0tjWZ83Zscy64hxv0mfYLWqT4sU+yvFzwgJFEk/wOOq4iXqo1I8hM3HpLeiBcO8CWDPctCMU68j1l7CbMG7YbAC/+RiHqaIrWlI1Ljdv/FZCh9V16dQtobbXnZF6a8k516DTVQyDzmcFghKAvnOFEzfz9ij/sTAI5loKbKrya3BdC8MzKTv6fB2M0NcM390Vpbs3vGh9Z5ekof6j0OwAnWdLI6qVbDiQkLo6nST9dklFmUUGhs6TWTEdPkgQiH2JumwRf3wAe/6cvgvPoAWqCAdMXtav++oe0R9pk3qqhTJviQXLOTk/Drv80jtw5bFGYve99aonxNxYvBouSDvEC5MY6vGOiSPT+xvmvGYaPPA15kk4WAiQJh2i9mW3oZPx+r59lVrj5WI0yD2WgrxP1azKtC/MsJiA4vzQf5tzPPCOgAmmfBFJeEtDrMv99oAMHu0d0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1586650-8d97-4d06-89e6-08d806e8931f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:32:04.5211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VdTIL5No20yg96ssiEJ26p3q/x6ng518g16/qE0ROQgx0XWP9drSro2FznnBR6qGVy1JrVmgsnB+OECZ0buvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new attribute that indicates the split ability to devlink port.

Drivers are expected to set it via devlink_port_attrs_set(), before
registering the port.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c       | 1 +
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c | 1 +
 include/net/devlink.h                            | 3 ++-
 include/uapi/linux/devlink.h                     | 1 +
 net/core/devlink.c                               | 3 +++
 5 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f85f5d88d331..8b3791d73c99 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2135,6 +2135,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 
 	attrs.split = split;
 	attrs.lanes = lanes;
+	attrs.splittable = splittable;
 	attrs.flavour = flavour;
 	attrs.phys.port_number = port_number;
 	attrs.phys.split_subport_number = split_port_subnumber;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 71f4e624b3db..b6a10565309a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -367,6 +367,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 		return ret;
 
 	attrs.split = eth_port.is_split;
+	attrs.splittable = !attrs.split;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = eth_port.label_port;
 	attrs.phys.split_subport_number = eth_port.label_subport;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ee088cead80a..3eb5fd41731f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -65,7 +65,8 @@ struct devlink_port_pci_vf_attrs {
 };
 
 struct devlink_port_attrs {
-	u8 split:1;
+	u8 split:1,
+	   splittable:1;
 	u32 lanes;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 806c6a437fa2..22bd17ba8adb 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -452,6 +452,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_POLICER_BURST,		/* u64 */
 
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
+	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ce82629b7386..a47426941e21 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -530,6 +530,8 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_LANES, attrs->lanes))
 			return -EMSGSIZE;
 	}
+	if (nla_put_u8(msg, DEVLINK_ATTR_PORT_SPLITTABLE, attrs->splittable))
+		return -EMSGSIZE;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
 	switch (devlink_port->attrs.flavour) {
@@ -7409,6 +7411,7 @@ static int __devlink_port_attrs_set(struct devlink_port *devlink_port,
  *					   user, for example the front panel
  *			                   port number
  *			     @split: indicates if this is split port
+ *			     @splittable: indicates if the port can be split.
  *			     @lanes: maximum number of lanes the port supports.
  *				     0 value is not passed to netlink and valid
  *				     number is a power of 2.
-- 
2.20.1

