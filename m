Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C4F26C0F5
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgIPJqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:46:19 -0400
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:4297
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726737AbgIPJqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 05:46:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTR4zJgIwMFITGGICnQ0a7gQUrV7I7V0qo/BOI0QItwbh943hk7ecg4ART5PexaGetRLJA4VOiQQZ0rssvNvhUEHRCNzye8wgMSNkGWp7u/k+/v7hkWY0crN7uJdyW/dc4F1n3G5RUzQAVEoGqqXy1hlucJzXeerJ1mq0PvyumHI2jZJXHVPLGXbKLfSYd4DMpzRHzNIJsTrI0PFGFsFxJh561peTRVtqp1uU6VaN8y5gapGveI2ODHQgoXixtVUUWlVdmkK7813P2bBBcC7Cg0j82u8dHSvZKpD/+kGLFO+1eXcx/BFhnU3pImqSioK3nNqGwUKREkr9iMfElVu+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJ546LEOH2d55Cj13U0K9xzotjrw+D1wlzXV3vPj170=;
 b=Q35ba5ae9eae0bj3AhvzlEbfHRcHSjtzxAUt9ueE9mUawpWrPV1WRy6+bGwNQ9ZwspFjXl4kIxxUt8YcZbv/QOQtjFjaVi8ARulVVDddrto1Mw1BqGEA8q7S0ZNsN79KktibRSMJckhqsp2+/8q+JrPBnaTvjaSbm9p3LxluTIRiHIOhuLduTA5ofnl377YdeZR8uhYU5yp+rnXECA+2Md0tlqaFEyzyFQbvdSlZAi1/euyo5lKCnz5MhNXtaHR/9NGMWCbHUbZ1IZQFoHVjXCDbgc33bj0d7ecgURh5qpfaFMxV2rXWQ13MRNfYfPjBbc5DY1XlWPuj8A8B8d9Olw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJ546LEOH2d55Cj13U0K9xzotjrw+D1wlzXV3vPj170=;
 b=PT5Ac2vbdN3VrE/V+134UG6dl5AdbGaF9yvQ4oTxaSnAqPGdFQzKWdRUR7X9sPLD9fLn36/UDdrQmRf7ELpueXhQBmr7aJGq+zHq6/HJjvnycejqpLNJ8u9vWgZA91ygY4klFTJaMaUMXHaxGTJvrPNgoTmi/83tZ1dOxnyL2ec=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR04MB6078.eurprd04.prod.outlook.com (2603:10a6:803:f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 09:46:09 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f%5]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 09:46:09 +0000
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
Subject: [PATCH v6 2/3] net: switchdev: Add VLAN protocol support for switchdev port
Date:   Wed, 16 Sep 2020 17:48:44 +0800
Message-Id: <20200916094845.10782-3-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916094845.10782-1-hongbo.wang@nxp.com>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::44) To VI1PR04MB5677.eurprd04.prod.outlook.com
 (2603:10a6:803:ed::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 16 Sep 2020 09:45:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cbcd7832-c464-4d1e-d75c-08d85a255699
X-MS-TrafficTypeDiagnostic: VI1PR04MB6078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6078DD58AB7B1010842A6A2FE1210@VI1PR04MB6078.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BwXokNDPdLuUCCxk6uu7sc2k0NrErIl2nZMtVYC9Npz0BI/HUkUyTnUNeP7HO24ZtU5BbF/sTBN0aWed1qBiaENEbygYtOl2toGNqOTEWNXhnxG8kOawjv2vtuQbQCcPciWqZJtXuin6zSFU+v4DOACVbJR+7+gSXOQMEISq2WecpYyrrq/adQ+5EptVm+pXf9ws1yvW1nbij6FWi2j09eDw/SH//14hbTaVSAjWeVTANa40W/2OGWWpEUIDI5hyDFV3+K09quBdAg1UVmZ6ukEoagbzOMJzr4dad88pPQn7TJAF/eY+V/mSsQf37lt/rNSAw8Y4h3mA9Fss6nj0alWzfFJ+vIpwB/Nj3v6uBWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(346002)(396003)(366004)(136003)(8936002)(6506007)(9686003)(186003)(16526019)(52116002)(8676002)(36756003)(316002)(66476007)(66556008)(66946007)(6512007)(478600001)(2906002)(4326008)(7416002)(1076003)(26005)(6666004)(6486002)(86362001)(5660300002)(956004)(2616005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: svr/75BHqGCj3MIACYKtn4ZFCALq+HJYHPRPlVZrH9G3N0RRcz6ZcLsAxVwHjr1EGHNkdtTj7FCKAWzdIkBV9/95TNa84/X9ZN5b8yyW4UmBTLAiklUjJ5MalP43fSC9wZcdmb2Ghq238G/2nmFHDgkVFRJYbkeQHsaHJJAOKvGpqh5fVmrWuZJaujgTIKwWfOMGHziqqHi+HdM/yNp0L5mUuX1yPf+5qYIvY8AOJl4EV+x9ilu95/DJjLZJ2vmMnFjU1cAReyD/7vvmhuwaHOdUtLtAkKt2r7+lpcsw+Z6wDY0u5Wb48SNx92R+iaT3VeP6Gj8KKhaxFFtNqkEicviqT3JfK4m4ALoGkaK6WC1y1qArBhyfqrF2rR3bGZye0NwSw1MIz7mGQNkQtILUCwTu99znrqGCy2+nrjqsuOBOM7j8QhF8qz7ATGmv+QOvJW3lTy7mLM+U0mAbISfFpkGfd2UE8iqFXiijWPpVoMh/baeMmrLVxwPPhsfTm5OAURtj+pyJO5iKtFh5DwxBzvv3XCshYoNSlgFJJBkNPexu+noarKZO3c0gD4u0CUe5kniHLrGuWjInk8GWG6XfIeMq/DufY2k+cKR1QHlXkukAaUrSBP2lTbKhgfiaRW7UKR8hF74ZKhj860+6J/EBLA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcd7832-c464-4d1e-d75c-08d85a255699
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 09:46:09.1124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGDu5ClN87CUqFVchz4s+KWEWnuaxdJXKvJef+5JIYTZjzfi8KMyzxSJ86UlstQq+O7E03wbHBISDjQelJAbqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

Add VLAN protocol support when adding or deleting VLAN for switchdev
port, get current bridge's VLAN protocol and pass it to port driver.

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 net/bridge/br_switchdev.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 015209bf44aa..7712da3e7912 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -146,6 +146,26 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 	}
 }
 
+static u16 br_switchdev_get_bridge_vlan_proto(const struct net_device *dev)
+{
+	const struct net_device *br = NULL;
+	u16 vlan_proto = ETH_P_8021Q;
+	struct net_bridge_port *p;
+
+	if (netif_is_bridge_master(dev)) {
+		br = dev;
+	} else {
+		p = br_port_get_rtnl_rcu(dev);
+		if (p)
+			br = p->br->dev;
+	}
+
+	if (br)
+		br_vlan_get_proto(br, &vlan_proto);
+
+	return vlan_proto;
+}
+
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack)
 {
@@ -157,6 +177,8 @@ int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 		.vid_end = vid,
 	};
 
+	v.proto = br_switchdev_get_bridge_vlan_proto(dev);
+
 	return switchdev_port_obj_add(dev, &v.obj, extack);
 }
 
@@ -169,5 +191,7 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 		.vid_end = vid,
 	};
 
+	v.proto = br_switchdev_get_bridge_vlan_proto(dev);
+
 	return switchdev_port_obj_del(dev, &v.obj);
 }
-- 
2.17.1

