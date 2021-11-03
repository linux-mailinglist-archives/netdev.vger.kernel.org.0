Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B8C443FA8
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhKCJ5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:57:04 -0400
Received: from mail-eopbgr60114.outbound.protection.outlook.com ([40.107.6.114]:34625
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231278AbhKCJ5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 05:57:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOKWp3vf150tDm5fOMkGcK3ge5QSucNerxkfR1EC4YNQwt9zfu9NWV1HXJd9uAvHkmLPZEpzNsVUirVxrA6SNYouCipUEvhAxiZNnnhjQ04PPZnIZneiq2UnK5r1MW+55HqXMqwrYvAcFwyMopJnXqk12+g9bhH20eZVSR/OwxJOaWH1kd/aznW1NNSEy5VupwA7rc0IZ/4umHNRFe/QzfKdnexQhcfRR78bX1zVCbgkOFGXl6EGo51z4NLQ7T5k3HKN5IThd8/p/CZTGQsyPqeV+GJtTB5U/NgkS75SoGvmaKFE1C8IsFyh64KC6JsrAHPYE4SOyUzuKztrGAVX4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ai6sJfCCtMa1Oks0OWWRNRgu2G1ZESKsoootkyTHlaQ=;
 b=VVi5MdoGQFg1Zj5ksYdTWjxC+IpQinD9a9ITR9w1EhUYCgenZ8RwO+gVQg7DW2Wekbb3injmnobR75BGLn3D0ZDKQ2ebkw3pJQKwnwpmEXl7RmgS89oSZWOxORlp9vR38gRh2FwAJtXYLda9EXGxAw+kfp6uzwxCzAMoCji5UZ20DJL/EAFdN/mWFHP46eKvI2+SBsEvE2w/Q9TCDPLml0ARdB4IJUZBelezsYQ0gV8B+wQ6Koxik30wSV8DlvgcyIaCs46CFgqEKIF2piHKfYsy1Iy+vBOd47bzE4sUdWN35EgmZWWTK9SK+33tYma39Devl00+xFWlXl7GxVW5+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ai6sJfCCtMa1Oks0OWWRNRgu2G1ZESKsoootkyTHlaQ=;
 b=h7CWg34PuDCzBZyQT0Okjb0l25WrTWZU1KQOLxhKy6E6vPgL06OxupLWbjZ9ij8B1rQO2+Ql4IovyzvvJe+0+UVtKsQUwy8NmWoErPFOg1JAOXzd5BIsJzkXjZi4V3oCZNiZEhQYN2auauLOiNRViAKA+q0gSScCwMuNPBCQsHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0477.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:3a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 09:54:23 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%5]) with mapi id 15.20.4649.019; Wed, 3 Nov 2021
 09:54:23 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     kuba@kernel.org, andrew@lunn.ch
Cc:     mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: marvell: prestera: fix hw structure laid out
Date:   Wed,  3 Nov 2021 11:54:04 +0200
Message-Id: <1635933244-6553-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0087.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::12) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by FR0P281CA0087.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.4 via Frontend Transport; Wed, 3 Nov 2021 09:54:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd8cceab-1ead-4c59-116e-08d99eafea36
X-MS-TrafficTypeDiagnostic: VI1P190MB0477:
X-Microsoft-Antispam-PRVS: <VI1P190MB04771436898C30DE9983CBA98F8C9@VI1P190MB0477.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:411;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jBOqlRGq6YHqerXcJs7TdZilSlKxLhl9RiDkpvZve7+J0+gd+/gqNIbKWPND6CnwR3d9YT2xaSo1Lh9PQd2Jf13+f9nFVAhwNQ1USgLpdjH5cd/g7qcuO0wWzqmayAEvdg14H2BQi3o0NYbXaC7WsDrV/fwY3vyFm45LJo1WxZ7WAF1TOdc21dJV634Rr8st3awNjt0Kc0W1oWu9d2IO6CyJkPFghPorn0ISam8zXmNPDnobFBA45yIyFaFSORwoVw7by15epUKgEcZLCmqFq8IQQkOKTtHhaN/sikzE5mCrZ0IS/cFUM/HuF2dGkDLd8YucLokL5wI1C9lJ49/OQ/ZYz6TyUONMCQvceo8vGJGf4T5kk/MxYc7qWG2aut2A8lY5V6bNqvphqV5RMTcj2Lbyk0N14s/x1zkiktmG0maIspeLenpTf/ldouE13WHj02yRg/1RuwU6P4XGSntu5nC4P4HqnkG1qLIyNaFQ5L+k6GpTT+8cfch/dvG9pQbhe6X45irk/95X9CzFgdMbh6lfc3yYMuZzCIxmruSe+grGl3B5/3F+fJ5T2ljpSA9qkbWhA876DhiWmnt1YZ5SRIxcaXe3lZ1JeG6cXqttg6E5q6LkahXhY+TPAumutylynWBNlZvyS5/jyV4+OZHZAsFnmg17Kaz2XUBbweDVyU9uuUUDqIRm3153ubxbqlNJg6+QRnRt7KFEem2xbCkylQVGRcglxrEm2T9EdfHiyHGFZhkazZaBXiv38Bs/j4vepptST0J8XTtWi7OkC2vecvuCBvH72uYJt6cRUzhyDbQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39830400003)(346002)(366004)(396003)(136003)(2616005)(4326008)(956004)(8936002)(5660300002)(66574015)(966005)(6512007)(83380400001)(38100700002)(66556008)(6506007)(52116002)(38350700002)(36756003)(186003)(26005)(54906003)(2906002)(316002)(6486002)(8676002)(6666004)(508600001)(66946007)(66476007)(44832011)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6WJiTPnSsXqwX77Z2wg3nfdxBrzZylenAD3DfAjLCuxOZPcyEJFPk+/2jtR8?=
 =?us-ascii?Q?0mfQLWAwz+dYcjDZ0zVsPKlb6QFLoTOH16pn+QzDk2PhF6Zbx9dp3vYRnpC5?=
 =?us-ascii?Q?Od9GCuh5TPFcUEhlVMhOp5vXyf+GFARpEECxfqimq8dImChokfNqUAElGsBm?=
 =?us-ascii?Q?exJIRjb1TdeXsgz47487Hk3mrL9ufcDnh6i6mcr8fjgPsKAGMDuMeXbNiG0D?=
 =?us-ascii?Q?BJWVx+/kIMr4mZCc3opn/PJk5FV/h655YZuz6MJWEN8AsZP2rf/6/Uq91/FW?=
 =?us-ascii?Q?p6ss7V1TBUomJCgE5XqIuSuffN526/5AKEpvnd6JgqtC2zfzH6PMDnRH6CS/?=
 =?us-ascii?Q?81ZCUzTwST86fI3dvsg+lsqZyn/AX4DhPPa8ZB7D2UkmJJo5TCL9lJ8GEklw?=
 =?us-ascii?Q?Eg88cV5zJ/D87xi9uaujRBIt5/C+SXgOLFC49ZjHVYvs66WDUFtXlh0VILiw?=
 =?us-ascii?Q?TqHuWYtmyH5VebWqxaH4cs+SGj3WEpwUdR5qvETIJeiBIqnYFlsdFezPfKSp?=
 =?us-ascii?Q?RKhx8nJ5CRpfJdeNkilNL8tJZXoctSatOaML9uBa4Zj/0O1iwhSOZKGC9ift?=
 =?us-ascii?Q?MEXu9Aaa/wCEwUvymtyLUBIYZGD14S2ETt0BUCrVYFbn7+K5eWjribraFxAN?=
 =?us-ascii?Q?Ic1h895YBC54RquEKJZL2lAQTRP5DP5mj7FT9W8JzAYTk7NaVyvgl0VwnNQl?=
 =?us-ascii?Q?j8mCSJto2bfye4U0fXAmKH7ng8dEZaffYdF+GC3mld0iRw46oLBrjVSlW/0k?=
 =?us-ascii?Q?U0ODRD8o69HPlgntPzYDnDWHOolSs8pSC7CoWCwSxo3nMUXryyIW76MtXz+c?=
 =?us-ascii?Q?sM7XoB+sQ21lYWPlf7iE/nDNAg+a2dnLeTdBeT7JR7fa1K8x2xqwBs0Ssafg?=
 =?us-ascii?Q?ygo2+ZQcmwxgWULXqZW3r/AdND7aDuq6mYAoXBYECJEDhLikS6V+bj/G+a1v?=
 =?us-ascii?Q?HQ2+BmfI+RLQ1G0YceBSEBbIfLliqcQPovSdx8/I3BK4CKiNKxQ3V0yf8AoT?=
 =?us-ascii?Q?qDFXQN2VFdlFRToNC8dW49TXnQn9TVOTyC/Oe3U0ktOu6lVUtQTE/uvSuGRt?=
 =?us-ascii?Q?Q2qmnO0vhu6/I/5mD5WOzTZhm5FTpCWUcae6/R3llNI1PW5RCZ3NL09KHWIf?=
 =?us-ascii?Q?aFFg3wrTa05x3+qwF4QVtkXFsmqymbiYyKDG7rVHAZ92Fe4T9H+KEpxlcwSQ?=
 =?us-ascii?Q?zXj0jZL/AGVc7xD+5stKjTFOEheXwtXLxINumwCGFsaCULqi+K0FjxY9UjN3?=
 =?us-ascii?Q?q2rRteBltEM60k7KhLv4FbKgl0z1hRTFQmvvyNhVz2ZdERzwunrt93RjEkcD?=
 =?us-ascii?Q?330HF0vSRLDAHwqRiO15OiWkk9e9qWIusPqRKDVisAf7LidT3Mdel+Lh1E6+?=
 =?us-ascii?Q?xPwZnhoSXpcDTqesa9SBJQ4UMa33bsC4Ygx7kewj5wRs/eLcwTkLfhxbaFCt?=
 =?us-ascii?Q?7TFkQ/f3b2/Q1v7nNPlQeSgHOddtrm6K4d+PnnTSI3AtWKyirxEaPYcCMS2F?=
 =?us-ascii?Q?ZAyVAJRxaV8sOTFCG5jEkZiaBQtnOIw0TyUYJhxshtIabToLNxXFMY0RIobx?=
 =?us-ascii?Q?hGsmP7dTTWpA5WcCuO6h5gK416lJbJPG34khtdb1Sh7ER9Ltb5brpj5Oy+uR?=
 =?us-ascii?Q?VL7A+FKfz6ni5xsA18NF2WBKjaQbCrOZ+OHq6KkKaeTqfpOAezEJspF1qPRk?=
 =?us-ascii?Q?tKOOiQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8cceab-1ead-4c59-116e-08d99eafea36
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 09:54:23.7305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McI+bL52aqGW8J6nOM7doPnY/iLp7jJcrPyWeHlNxwncLnXsB1XhnugI6jW1UlZYxlhwgYC7DRIow7ihRtSnbQYC+O8B5oT56QeT+clxKzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0477
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

- fix structure laid out discussed in:
    [PATCH net-next v4] net: marvell: prestera: add firmware v4.0 support
    https://www.spinics.net/lists/kernel/msg4127689.html

- fix review comments discussed in:
    [PATCH] [-next] net: marvell: prestera: Add explicit padding
    https://www.spinics.net/lists/kernel/msg4130293.html

- fix patchwork issues
- rebase on net master

Reported-by: kernel test robot <lkp@intel.com>
Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_ethtool.c   |   3 +-
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 129 +++++++++++----------
 .../net/ethernet/marvell/prestera/prestera_main.c  |   6 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   3 +-
 4 files changed, 75 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 6011454dba71..40d5b89573bb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -499,7 +499,8 @@ static void prestera_port_mdix_get(struct ethtool_link_ksettings *ecmd,
 {
 	struct prestera_port_phy_state *state = &port->state_phy;
 
-	if (prestera_hw_port_phy_mode_get(port, &state->mdix, NULL, NULL, NULL)) {
+	if (prestera_hw_port_phy_mode_get(port,
+					  &state->mdix, NULL, NULL, NULL)) {
 		netdev_warn(port->dev, "MDIX params get failed");
 		state->mdix = ETH_TP_MDI_INVALID;
 	}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 4f5f52dcdd9d..fb0f17c9352f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -180,109 +180,113 @@ struct prestera_msg_common_resp {
 	struct prestera_msg_ret ret;
 };
 
-union prestera_msg_switch_param {
-	u8 mac[ETH_ALEN];
-	__le32 ageing_timeout_ms;
-} __packed;
-
 struct prestera_msg_switch_attr_req {
 	struct prestera_msg_cmd cmd;
 	__le32 attr;
-	union prestera_msg_switch_param param;
-	u8 pad[2];
+	union {
+		__le32 ageing_timeout_ms;
+		struct {
+			u8 mac[ETH_ALEN];
+			u8 __pad[2];
+		};
+	} param;
 };
 
 struct prestera_msg_switch_init_resp {
 	struct prestera_msg_ret ret;
 	__le32 port_count;
 	__le32 mtu_max;
-	u8  switch_id;
-	u8  lag_max;
-	u8  lag_member_max;
 	__le32 size_tbl_router_nexthop;
-} __packed __aligned(4);
+	u8 switch_id;
+	u8 lag_max;
+	u8 lag_member_max;
+};
 
 struct prestera_msg_event_port_param {
 	union {
 		struct {
-			u8 oper;
 			__le32 mode;
 			__le32 speed;
+			u8 oper;
 			u8 duplex;
 			u8 fc;
 			u8 fec;
-		} __packed mac;
+		} mac;
 		struct {
-			u8 mdix;
 			__le64 lmode_bmap;
+			u8 mdix;
 			u8 fc;
+			u8 __pad[2];
 		} __packed phy;
 	} __packed;
-} __packed __aligned(4);
+} __packed;
 
 struct prestera_msg_port_cap_param {
 	__le64 link_mode;
-	u8  type;
-	u8  fec;
-	u8  fc;
-	u8  transceiver;
-};
+	u8 type;
+	u8 fec;
+	u8 fc;
+	u8 transceiver;
+} __packed;
 
 struct prestera_msg_port_flood_param {
 	u8 type;
 	u8 enable;
-};
+	u8 __pad[2];
+} __packed;
 
 union prestera_msg_port_param {
+	__le32 mtu;
+	__le32 speed;
+	__le32 link_mode;
 	u8 admin_state;
 	u8 oper_state;
-	__le32 mtu;
 	u8 mac[ETH_ALEN];
 	u8 accept_frm_type;
-	__le32 speed;
 	u8 learning;
 	u8 flood;
-	__le32 link_mode;
 	u8 type;
 	u8 duplex;
 	u8 fec;
 	u8 fc;
-
 	union {
 		struct {
-			u8 admin:1;
+			u8 admin;
 			u8 fc;
 			u8 ap_enable;
+			u8 __reserved;
 			union {
 				struct {
 					__le32 mode;
-					u8  inband:1;
 					__le32 speed;
-					u8  duplex;
-					u8  fec;
-					u8  fec_supp;
-				} __packed reg_mode;
+					u8 inband;
+					u8 duplex;
+					u8 fec;
+					u8 fec_supp;
+				} reg_mode;
 				struct {
 					__le32 mode;
 					__le32 speed;
-					u8  fec;
-					u8  fec_supp;
-				} __packed ap_modes[PRESTERA_AP_PORT_MAX];
-			} __packed;
-		} __packed mac;
+					u8 fec;
+					u8 fec_supp;
+					u8 __pad[2];
+				} ap_modes[PRESTERA_AP_PORT_MAX];
+			};
+		} mac;
 		struct {
-			u8 admin:1;
-			u8 adv_enable;
 			__le64 modes;
 			__le32 mode;
+			u8 admin;
+			u8 adv_enable;
 			u8 mdix;
-		} __packed phy;
+			u8 __pad;
+		} phy;
 	} __packed link;
 
 	struct prestera_msg_port_cap_param cap;
 	struct prestera_msg_port_flood_param flood_ext;
 	struct prestera_msg_event_port_param link_evt;
-} __packed;
+};
 
 struct prestera_msg_port_attr_req {
 	struct prestera_msg_cmd cmd;
@@ -290,14 +294,12 @@ struct prestera_msg_port_attr_req {
 	__le32 port;
 	__le32 dev;
 	union prestera_msg_port_param param;
-} __packed __aligned(4);
-
+};
 
 struct prestera_msg_port_attr_resp {
 	struct prestera_msg_ret ret;
 	union prestera_msg_port_param param;
-} __packed __aligned(4);
-
+};
 
 struct prestera_msg_port_stats_resp {
 	struct prestera_msg_ret ret;
@@ -322,13 +324,13 @@ struct prestera_msg_vlan_req {
 	__le32 port;
 	__le32 dev;
 	__le16 vid;
-	u8  is_member;
-	u8  is_tagged;
+	u8 is_member;
+	u8 is_tagged;
 };
 
 struct prestera_msg_fdb_req {
 	struct prestera_msg_cmd cmd;
-	u8 dest_type;
+	__le32 flush_mode;
 	union {
 		struct {
 			__le32 port;
@@ -336,11 +338,12 @@ struct prestera_msg_fdb_req {
 		};
 		__le16 lag_id;
 	} dest;
-	u8  mac[ETH_ALEN];
 	__le16 vid;
-	u8  dynamic;
-	__le32 flush_mode;
-} __packed __aligned(4);
+	u8 dest_type;
+	u8 dynamic;
+	u8 mac[ETH_ALEN];
+	u8 __pad[2];
+};
 
 struct prestera_msg_bridge_req {
 	struct prestera_msg_cmd cmd;
@@ -383,7 +386,7 @@ struct prestera_msg_acl_match {
 		struct {
 			u8 key[ETH_ALEN];
 			u8 mask[ETH_ALEN];
-		} __packed mac;
+		} mac;
 	} keymask;
 };
 
@@ -446,7 +449,8 @@ struct prestera_msg_stp_req {
 	__le32 port;
 	__le32 dev;
 	__le16 vid;
-	u8  state;
+	u8 state;
+	u8 __pad;
 };
 
 struct prestera_msg_rxtx_req {
@@ -497,21 +501,21 @@ union prestera_msg_event_fdb_param {
 
 struct prestera_msg_event_fdb {
 	struct prestera_msg_event id;
-	u8 dest_type;
+	__le32 vid;
 	union {
 		__le32 port_id;
 		__le16 lag_id;
 	} dest;
-	__le32 vid;
 	union prestera_msg_event_fdb_param param;
-} __packed __aligned(4);
+	u8 dest_type;
+};
 
-static inline void prestera_hw_build_tests(void)
+static void prestera_hw_build_tests(void)
 {
 	/* check requests */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_req) != 4);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_attr_req) != 16);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_req) != 120);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_req) != 140);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vlan_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_fdb_req) != 28);
@@ -528,7 +532,7 @@ static inline void prestera_hw_build_tests(void)
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_init_resp) != 24);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 112);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 132);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_stats_resp) != 248);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_resp) != 20);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_bridge_resp) != 12);
@@ -561,9 +565,9 @@ static int __prestera_cmd_ret(struct prestera_switch *sw,
 	if (err)
 		return err;
 
-	if (__le32_to_cpu(ret->cmd.type) != PRESTERA_CMD_TYPE_ACK)
+	if (ret->cmd.type != __cpu_to_le32(PRESTERA_CMD_TYPE_ACK))
 		return -EBADE;
-	if (__le32_to_cpu(ret->status) != PRESTERA_CMD_ACK_OK)
+	if (ret->status != __cpu_to_le32(PRESTERA_CMD_ACK_OK))
 		return -EINVAL;
 
 	return 0;
@@ -1356,7 +1360,8 @@ int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
 int prestera_hw_port_autoneg_restart(struct prestera_port *port)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART),
+		.attr =
+		    __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART),
 		.port = __cpu_to_le32(port->hw_id),
 		.dev = __cpu_to_le32(port->dev_id),
 	};
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 625b40149fac..4369a3ffad45 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -405,7 +405,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
 	err = prestera_port_cfg_mac_write(port, &cfg_mac);
 	if (err) {
-		dev_err(prestera_dev(sw), "Failed to set port(%u) mac mode\n", id);
+		dev_err(prestera_dev(sw),
+			"Failed to set port(%u) mac mode\n", id);
 		goto err_port_init;
 	}
 
@@ -418,7 +419,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 						    false, 0, 0,
 						    port->cfg_phy.mdix);
 		if (err) {
-			dev_err(prestera_dev(sw), "Failed to set port(%u) phy mode\n", id);
+			dev_err(prestera_dev(sw),
+				"Failed to set port(%u) phy mode\n", id);
 			goto err_port_init;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 5d4d410b07c8..461259b3655a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -411,7 +411,8 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw, int qid,
 		goto cmd_exit;
 	}
 
-	memcpy_fromio(out_msg, prestera_fw_cmdq_buf(fw, qid) + in_size, ret_size);
+	memcpy_fromio(out_msg,
+		      prestera_fw_cmdq_buf(fw, qid) + in_size, ret_size);
 
 cmd_exit:
 	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_CTL_REG(qid),
-- 
2.7.4

