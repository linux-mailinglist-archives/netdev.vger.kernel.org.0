Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1803D233043
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgG3KWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:22:24 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:31652
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgG3KWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 06:22:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHDmItlMHs2eyw5D4ialBMdL1UtW8/UyO9tcKEpJANV3Erlfz7g3rkrncIw30z8m/JlVvgcM4rUPRliOf7ZA6ruQDR/wHrfpCnXZpfOH0telDjqP9mSwF6WfTWD6V1UVCSnDNIzCHk5zljQWinJN5uu1Z5USbTUYOjbQvJYnN8Qg1f/pGyKdWGy0VSHcYrYDrJyQdKLLbLWxHLZVKGwxHFQRlLJsdkCOZWeDZNmoN589wbtyymztOYFZi4WlZ2QfsrdepllkTkQnReQD03YITQOj1QelaotwBxjReJAFNKuqgGoi0eegZFoquM4QRtGGVGztj6NTv9fPrrmIYwIxDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Of4U4XOHDr+xMSmd+ykLhYWk8MZOY/1WCY7NtLT108o=;
 b=lIHdx+MRroKoS8Ado0t34LUSDSyQIFaIBFNXfOgas2ocDz75CYrMTuqWsdh9indg2UDjvpo0+wS+80FaFnmNUMQ+wdNAt9UEFGyAWq0kVb9djsnY0UIWk7eO1ifLrT/lFmBnHTKvrvZixx3InAtUP8LnyEj2yZlpAkZdkulmK4A2QMwSPw0+RCazbEYCrkEoBMf67oZsQ5/CyJMuelcOmeBgY7b7yxYAk78+EyTWzLTXhzFmXNbJXt70tkCvAH8YcrpdfEtDMninfGdHazqRLBkiSrTsImLtJL3oeWdjRUCe3fkr7Hxl8AL3DJSJeT67WcaSjT08fvKtGkw8chSj5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Of4U4XOHDr+xMSmd+ykLhYWk8MZOY/1WCY7NtLT108o=;
 b=Xz+kI6H3dIhP+Mh3illw4A6TketKBC2QTY0NrqycIO2d+W6qMiCu32IVtwUrWYTl+7UjW5xVGspaT7kwHnTmv4qkbjRFhOIoYddYfgEsYGiWTP3X/AVCzu1BQn6Nxl21Cosy1APrrN5KrOL6fs98cz7ToH1d8wQ//wvFnQwgyxk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from DB7PR04MB5099.eurprd04.prod.outlook.com (2603:10a6:10:18::30)
 by DB8PR04MB6924.eurprd04.prod.outlook.com (2603:10a6:10:11e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 30 Jul
 2020 10:22:19 +0000
Received: from DB7PR04MB5099.eurprd04.prod.outlook.com
 ([fe80::f801:51e:28:f2a3]) by DB7PR04MB5099.eurprd04.prod.outlook.com
 ([fe80::f801:51e:28:f2a3%4]) with mapi id 15.20.3239.019; Thu, 30 Jul 2020
 10:22:19 +0000
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
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v4 1/2] net: dsa: Add protocol support for 802.1AD when adding or   deleting vlan for dsa switch port
Date:   Thu, 30 Jul 2020 18:25:04 +0800
Message-Id: <20200730102505.27039-2-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730102505.27039-1-hongbo.wang@nxp.com>
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31)
 To DB7PR04MB5099.eurprd04.prod.outlook.com (2603:10a6:10:18::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Thu, 30 Jul 2020 10:22:12 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52bbf67a-6b4a-42e4-088b-08d8347270b6
X-MS-TrafficTypeDiagnostic: DB8PR04MB6924:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB692420704B876D9E09ADA944E1710@DB8PR04MB6924.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gv3X271q/znAYrAv9RU3urXTJSySwzWud5BCkCD1uUJhgmi6VLUWJpBlIbrT6qlL6R6cNFKh2qQNpYpCHaObI2+rGHHc/CdQP+FTEytClkFzZ8Yap0c6mFYhKEfCt+Dx9HPc51NvqvvtLkQ1ASwDNICTMV97gfgHfn3xh4Bvcz1Tjpdjr+dLJ4qZREMdB0RAJsE4RvKv8BpAQk56FvZA3CxdGtD9OGk84ZG75zCT4ZkHtegb2bOMXrrd26EfTF873n7wUaHPdutokcEcmbazZKTOkiOC+e5foYPMbo4wvQSTSX1HWTksfVmpm3A0XzYKX7k0ftyikUCV0poNqtNd0X939aiDnv18abMdPSV74LoU04YZaCpOuk/715V7uxeg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5099.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(83380400001)(36756003)(66476007)(66946007)(4326008)(6666004)(66556008)(6486002)(7416002)(52116002)(8676002)(316002)(86362001)(6506007)(6512007)(9686003)(1076003)(26005)(2616005)(956004)(478600001)(186003)(5660300002)(8936002)(16526019)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lBm/Yz4evaVGvYI6Kbe5UxDbpu3ZpMAFM78/D42nM+fvrP74tAQwn0W6xT/aR+nvG65A67bnEcD/AZPoo36HDnOvkqRTNbLrKFXCNYB/gyAJ57wUGsQ5YhJvlihWxHtenAnrbFQZ4+CdfqPa3GjY58owCi0o8SoQWoHUwNv5HBhJy90XbH7X5ZBMJ3LplZNFCkzUK2BQta9CIZAuiTIOdQi6fcewWy4Q4mwozxpmoVRK/twJk4Wj1P9chyNrsX8J9yEzTfnljV7sH0RVdJRz+uMYUphHVEom5nSrxKhMQzPSNaRKT82u41wWmKBTRyknmBg/HhvLHOOgfowgOhKB7BHk1gPHGd5SqvJPWIRrChEOEk6whToXf0tuzM6b0BdqI2d8vQaJmX5QUHJ3nUq/0RbQ0tyuWMH7CVkXeUiMapYuc9ERW+eZOR0TNNAMy/WmyCbRt9pOdoPzBLZALb29msQ5m84VgrAPTQCIHybFAaKseXRKSQb5WGy3TytbeaP/mXEI1RN+0MbHWfQQ7y649XLLnfjhgF66UL9x/p8DJo+0rpEoPCdCBY4CbnwSbRznZmN1kwoUa1Nf2gDFcATmWmmcEOuEMLJLSh466qKC95+aDwNRS9Yld3F4/CVOECPTGTwm63au8VYlUBTpDkOpmA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bbf67a-6b4a-42e4-088b-08d8347270b6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5099.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 10:22:19.7737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7s+kMFc6cQyZ0z4HEjFd7PAxqLo7v2/v+NngP/3hh2J6ificXosCM3g+UMsz+McqlpPY0MKJ2kv2VMeKmck3wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6924
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
 net/dsa/dsa_priv.h      |  4 ++--
 net/dsa/port.c          |  6 ++++--
 net/dsa/slave.c         | 27 +++++++++++++++++++++------
 net/dsa/tag_8021q.c     |  4 ++--
 5 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index ff2246914301..7594ea82879f 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -97,6 +97,7 @@ struct switchdev_obj_port_vlan {
 	u16 flags;
 	u16 vid_begin;
 	u16 vid_end;
+	u16 proto;
 };
 
 #define SWITCHDEV_OBJ_PORT_VLAN(OBJ) \
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 1653e3377cb3..52685b9875e5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -164,8 +164,8 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		      struct switchdev_trans *trans);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
-int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags);
-int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
+int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 proto, u16 flags);
+int dsa_port_vid_del(struct dsa_port *dp, u16 vid, u16 proto);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e23ece229c7e..c98bbac3980a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -433,13 +433,14 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
-int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
+int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 proto, u16 flags)
 {
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.flags = flags,
 		.vid_begin = vid,
 		.vid_end = vid,
+		.proto = proto,
 	};
 	struct switchdev_trans trans;
 	int err;
@@ -454,12 +455,13 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
 }
 EXPORT_SYMBOL(dsa_port_vid_add);
 
-int dsa_port_vid_del(struct dsa_port *dp, u16 vid)
+int dsa_port_vid_del(struct dsa_port *dp, u16 vid, u16 proto)
 {
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.vid_begin = vid,
 		.vid_end = vid,
+		.proto = proto,
 	};
 
 	return dsa_port_vlan_del(dp, &vlan);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 41d60eeefdbd..2a03da92af0a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1233,7 +1233,10 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u16 vlan_proto = ntohs(proto);
 	struct bridge_vlan_info info;
+	bool change_proto = false;
+	u16 br_proto = 0;
 	int ret;
 
 	/* Check for a possible bridge VLAN entry now since there is no
@@ -1243,20 +1246,24 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		if (dsa_port_skip_vlan_configuration(dp))
 			return 0;
 
+		ret = br_vlan_get_proto(dp->bridge_dev, &br_proto);
+		if (ret == 0 && br_proto != vlan_proto)
+			change_proto = true;
+
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
 		 * 0 means success, which is a failure for us here.
 		 */
 		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
-		if (ret == 0)
+		if (ret == 0 && !change_proto)
 			return -EBUSY;
 	}
 
-	ret = dsa_port_vid_add(dp, vid, 0);
+	ret = dsa_port_vid_add(dp, vid, vlan_proto, 0);
 	if (ret)
 		return ret;
 
-	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
+	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0, 0);
 	if (ret)
 		return ret;
 
@@ -1267,7 +1274,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u16 vlan_proto = ntohs(proto);
 	struct bridge_vlan_info info;
+	bool change_proto = false;
+	u16 br_proto = 0;
 	int ret;
 
 	/* Check for a possible bridge VLAN entry now since there is no
@@ -1277,19 +1287,23 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		if (dsa_port_skip_vlan_configuration(dp))
 			return 0;
 
+		ret = br_vlan_get_proto(dp->bridge_dev, &br_proto);
+		if (ret == 0 && br_proto != vlan_proto)
+			change_proto = true;
+
 		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
 		 * device, respectively the VID is not found, returning
 		 * 0 means success, which is a failure for us here.
 		 */
 		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
-		if (ret == 0)
+		if (ret == 0 && !change_proto)
 			return -EBUSY;
 	}
 
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vid_del(dp, vid, vlan_proto);
 }
 
 struct dsa_hw_port {
@@ -1744,7 +1758,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
 	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
-		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+				       NETIF_F_HW_VLAN_STAG_FILTER;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
 	slave_dev->features |= NETIF_F_LLTX;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 780b2a15ac9b..848f85ed5c0f 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -152,9 +152,9 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (enabled)
-		return dsa_port_vid_add(dp, vid, flags);
+		return dsa_port_vid_add(dp, vid, 0, flags);
 
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vid_del(dp, vid, 0);
 }
 
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
-- 
2.17.1

