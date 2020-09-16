Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1258426C0F2
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgIPJqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:46:14 -0400
Received: from mail-eopbgr140083.outbound.protection.outlook.com ([40.107.14.83]:45697
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726243AbgIPJqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 05:46:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmeK8e2pLE3Gx/4SOYSZ9ZvxlrwXDCSm3gdVrRexCYxT9n0+uHHDgYINcnDB3emgE4kjmQwGYiIs5TpBAQQLlyDMeQ+JwkafWXQMAeLySRsncudjAFusbSHVYVGUyrLi9mxEVC+BIUpyw9TzP4tfIUL30+siedFbv7azV6AohTuMUR7gaKNoTKh16xqmL6KcOVie1jV/miO5/RGXxJYCTffe6TMqTtMxQ7TpZ84hluMROdo6S3c4M7ZKJ4AVbO/h/yhqxFuF6vX2TkhJqwpLJQA9Km5JzdCHHS7EektlOh7F+AgT7BOO6Knsc8sLdJvYKo3Lp/6wpJp3ER9ytJX9Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dVPayfLk31g+O3S8HOzWIcj4tReGB9qrvlqDXc4wMQ=;
 b=DFDWhxdk6Tj+zBTAVY4ttHyGDPXgkQDrDCeAqmfQTsuo57kzg0Hyus7n2mrewfAG9sH698NbhgDomKui8MR7nCKgR5xFfotvv/QhnQFvIoU//X/2IKeNnQ46MMlC1HB4duvD0D9eGBd/6pZNenP2OjraLHMYht3yonIjOGjOvwJaGZn6IiILZzCb02EZHfag+vdWobDvRxPY5YGUtm1mO9V/ZlGifYEWsmmaBAoV8ucl+2+ZkXZSbKKrukVKw3MFPFu1ylQO5ofUQrQU6rlm0D5CkM2opTnKvJnWLP8zakgBy6kZur10rFq0GdYuJRku2wFXiufo0qFD6PDnV7O+Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dVPayfLk31g+O3S8HOzWIcj4tReGB9qrvlqDXc4wMQ=;
 b=DbcFzJEOhBfsTSsTJh+N0lHH73oFZ5cy7u09k3jINAw2QHEwAwcaj8pU4XcHxtv6gUwe8C7Wp9Cb309qN7sPd7hoXvzO3+OXnG9MGW6DVO5dlzX3Brb0H6VvLmE3KgO4Mw8B9qsqkvDoYychGlnLHZSTP8l6IQejzGYHD2N3rmg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR0402MB3453.eurprd04.prod.outlook.com (2603:10a6:803:6::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 09:45:59 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f%5]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 09:45:59 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, mingkai.hu@nxp.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v6 1/3] net: dsa: Add protocol support for 802.1AD when adding or deleting vlan for dsa switch port
Date:   Wed, 16 Sep 2020 17:48:43 +0800
Message-Id: <20200916094845.10782-2-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916094845.10782-1-hongbo.wang@nxp.com>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::44) To VI1PR04MB5677.eurprd04.prod.outlook.com
 (2603:10a6:803:ed::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 16 Sep 2020 09:45:49 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f0aac4af-0647-481e-321a-08d85a2550b8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB345336C4E7A58A63298BE4B2E1210@VI1PR0402MB3453.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFT6A7fdPw3PbjuG5i4dJGe0IneceCPuDJ8hkLJMEafZGUmF7KfxhT0IEFErhMoiG15UgcvA4iuF5GEuwO6IM3z9LUTkOrKGpSMWA0aKrAGQuMFXz/nPe06lZd5xf7hIY/VlDEh/4PCrHvfjlpoM3l3vYHRj4rNBBr8iujomxJbu4xip1DDARDAlIDWGH5aUo2Lhew51qwSPRLY4pVWWJKsZzZagP3Z9MAZQNsooNeleDoj8W03AOf4L0cRKiQvMeKGbe6LVgS6let3ovlxx0T5oTdG3TraxAXFPUdw5ego+ghxglFI8WQRKTuwEnhxKCC+5TwK+ywtyk8anyJkRnQhzwAe9yS3h+UlSi+zalMr4ACv/k+byxeAmGZXSmdHI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(346002)(376002)(136003)(316002)(86362001)(6666004)(16526019)(186003)(8936002)(8676002)(83380400001)(52116002)(7416002)(9686003)(1076003)(36756003)(5660300002)(6512007)(2906002)(26005)(66946007)(6506007)(4326008)(6486002)(66556008)(956004)(2616005)(478600001)(66476007)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YagdgLyuz38R8F+ffN/Rk9XO7LwGA/5hxOuvneouJhyHJ6lWme2zt7sr+AntNjCvCaISA6P6BEpGlwTdf/qNTZP9UqP6/IuYhfZcK5SfMY59ht+ueFza+tPlyQwDnX9Rnv4ThzuwMHI263IsgZuZWbuC6JFXH/Njk7RUqVnfwVZF7pugGf50AjBA2Q66YDCTKD3EKPuaVjiQheJMCc9IDUqo/c22IzGHDEHDvuFSvnH/+c2gqfjTlmQkHzUzpCmxgUaBKwuiRLYCVqIh4VpUM8QfLvDuypavbx/qzhdLL01upgz6Irle+r4fAX87OCFHDVP5tDbjqQdUAtpSSq1O2MAOyamhUHkDDGf4CFMWN4Ni82csT4Mn+D/zz5Yl0W8NMeQoyI62OTUMvizo/2D6OOEReSCQf+kFVcvLh0Rjjs26+SVt+hBT/L7bftdI2ghI0jt1dy/Msc0K5kP7eO3qCUgUx7XEXNgqboagClBy8NPwdE74d8hXU2wZEu+pr4s/GVhzdu0GBp7il1V96aARMjtpgSaxigwuTvgHRAdANGZPNx9o9h5MajXpgqFw2aFnCSGb7nPTLEJ57a34eSffEHfJtVStZEMo9/oNuBXCpyeGxAj1y/mv+ac1uigaVbTEegp6Ze8LiCs9FPPNd+tcsg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0aac4af-0647-481e-321a-08d85a2550b8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 09:45:59.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wc4lO4YCm4NujKZdhRaISiPsQrTR/wv6Ldc4VShzZcJwNlCMoJBQ//+leovAiPftzCuTV3pOmUqQEC+WMoGyOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3453
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

the following command will be supported:

Set bridge's vlan protocol:
    ip link set br0 type bridge vlan_protocol 802.1ad
Add VLAN:
    ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100
Delete VLAN:
    ip link del link swp1 name swp1.100

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 include/net/switchdev.h |  1 +
 net/dsa/slave.c         | 51 +++++++++++++++++++++++++++++------------
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 53e8b4994296..d93532201ec2 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -97,6 +97,7 @@ struct switchdev_obj_port_vlan {
 	u16 flags;
 	u16 vid_begin;
 	u16 vid_end;
+	u16 proto;
 };
 
 #define SWITCHDEV_OBJ_PORT_VLAN(OBJ) \
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 66a5268398a5..731ab9e2aacc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -328,6 +328,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	 * it doesn't make sense to program a PVID, so clear this flag.
 	 */
 	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
+	vlan.proto = ETH_P_8021Q;
 
 	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
 	if (err)
@@ -1229,18 +1230,46 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 	return ds->ops->get_ts_info(ds, p->dp->index, ts);
 }
 
+static bool dsa_slave_skip_vlan_configuration(struct dsa_port *dp,
+					      u16 vlan_proto, u16 vid)
+{
+	struct bridge_vlan_info info;
+	bool change_proto = false;
+	u16 br_proto = 0;
+	int ret;
+
+	/* when changing bridge's vlan protocol, it will change bridge
+	 * port's protocol firstly, then set bridge's protocol. if it's
+	 * changing vlan protocol, should not return -EBUSY.
+	 */
+	ret = br_vlan_get_proto(dp->bridge_dev, &br_proto);
+	if (ret == 0 && br_proto != vlan_proto)
+		change_proto = true;
+
+	/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
+	 * device, respectively the VID is not found, returning
+	 * 0 means success, which is a failure for us here.
+	 */
+	ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
+	if (ret == 0 && !change_proto)
+		return true;
+	else
+		return false;
+}
+
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u16 vlan_proto = ntohs(proto);
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.vid_begin = vid,
 		.vid_end = vid,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
+		.proto = vlan_proto,
 	};
-	struct bridge_vlan_info info;
 	struct switchdev_trans trans;
 	int ret;
 
@@ -1251,12 +1280,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		if (dsa_port_skip_vlan_configuration(dp))
 			return 0;
 
-		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-		 * device, respectively the VID is not found, returning
-		 * 0 means success, which is a failure for us here.
-		 */
-		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
-		if (ret == 0)
+		if (dsa_slave_skip_vlan_configuration(dp, vlan_proto, vid))
 			return -EBUSY;
 	}
 
@@ -1271,6 +1295,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	if (ret)
 		return ret;
 
+	vlan.proto = ETH_P_8021Q;
+
 	/* And CPU port... */
 	trans.ph_prepare = true;
 	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &trans);
@@ -1289,14 +1315,14 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u16 vlan_proto = ntohs(proto);
 	struct switchdev_obj_port_vlan vlan = {
 		.vid_begin = vid,
 		.vid_end = vid,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
+		.proto = vlan_proto,
 	};
-	struct bridge_vlan_info info;
-	int ret;
 
 	/* Check for a possible bridge VLAN entry now since there is no
 	 * need to emulate the switchdev prepare + commit phase.
@@ -1305,12 +1331,7 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		if (dsa_port_skip_vlan_configuration(dp))
 			return 0;
 
-		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-		 * device, respectively the VID is not found, returning
-		 * 0 means success, which is a failure for us here.
-		 */
-		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
-		if (ret == 0)
+		if (dsa_slave_skip_vlan_configuration(dp, vlan_proto, vid))
 			return -EBUSY;
 	}
 
-- 
2.17.1

