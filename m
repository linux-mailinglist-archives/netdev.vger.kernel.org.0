Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF073443625
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhKBS7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:59:31 -0400
Received: from mail-vi1eur05on2091.outbound.protection.outlook.com ([40.107.21.91]:27185
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229764AbhKBS7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 14:59:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7kFT0q73fUREpaqXjLxLCQuMTM34kd+P+oTleewRN3CiQcnVZBDq3IwnIRj/lkPUXeI/805mOJ8us8+1cAuPVSEL/9d2psWSRO97vonq7eJUDSORfg+Ha5nF0XdFbAz7rTTrshwFcSq5MuX2MmgJJw/lEcYCnB+RS0Hzsc4g7dn92dNJkBtH899EZU+32fbuFzw2Ej6abPIqL+XPHZIqlNypzVXl0frsUDmwk3/xzpJo4Mf8lkazK/4YHgO81uomOFerHOmZAEMpvMOFeuWAzXn9gBzCQAKJEEYmZOk8eBFf/7E5+5YNbh/S8+oMAT2bEocAOXLdtcZSbWQO0zTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6y9D4RIrSZfK8agmiOB63n2Xlj0mPN/ROLxjad1rW/s=;
 b=LVACIkGuiyhJfLVMgooMEzkDFS7Tza4W+5T29/V5nyG1pw5B0qK3bZa4EKsuqRUYfnE5OU4LY/evCnmnROOeNedyK5bJVD4/fwkri0bL8nElC9t5H6Fjlgw0gwJ1CjYxkFp8wA+QAGxFxcjT9Uc2DyHqsfvgN9uCEcnV12XSSgh3PmktryHDBZj0KIqqB9uya7JoRsih3XeqYMy6f/QJ/qFtcHzUE03TAMP1/grVyn7hYLO6yF+/0SBAVSdm2biKri7xC4TlU5ZgC5/be6cLFHeMVQGYe98cXQqK2yTGCHrGRnoCXGvo3+EmL4YO+ZNQE4eLAoxDVelf8UDol1rmgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6y9D4RIrSZfK8agmiOB63n2Xlj0mPN/ROLxjad1rW/s=;
 b=OaBSnvQcKtb/+opuELMOnCA2xyR/iNOZJAPtHwOXJ5fbJLyIZ6y9V53Oe4l1EBWi4L3kyQV0qVuLqp+4LMyZa/tG0QR3XBSZItEQePfVuniFq96NNd+LjXhsGPfqBxmmuv9X6tLjn543BYDvsxfEAFcQpbP59Dxzl1MGUpAQd6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0397.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:36::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Tue, 2 Nov
 2021 18:56:51 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%5]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 18:56:51 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: marvell: prestera: fix hw structure laid out
Date:   Tue,  2 Nov 2021 20:56:05 +0200
Message-Id: <1635879365-19235-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0101CA0014.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::27) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AM5PR0101CA0014.eurprd01.prod.exchangelabs.com (2603:10a6:206:16::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4649.15 via Frontend Transport; Tue, 2 Nov 2021 18:56:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59205f9c-e542-48ce-3fb2-08d99e3287a7
X-MS-TrafficTypeDiagnostic: VI1P190MB0397:
X-Microsoft-Antispam-PRVS: <VI1P190MB039770E8BAD7F49D04155C448F8B9@VI1P190MB0397.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:69;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s57WvgNETZ8lDiwl0h+ZHh40vatxvR8BZDFAL5VGC7OhPFsvEcoiXGmYCXtmYhjmRgPL2vKdqyXjwcWwPescc1NmdZZVgqBWxTlGegKr9d1cYgLExB1FDS5HjmxcWImTVxmCzxZpQhI/1B2TfJLWq0EN38aMT1LMW3n939x1V8xtqYpxYYN6E+vz6+BE32rYtJfwk10OOdqavrnuGh+DwSRg3V3WK80fUDzP0eSyCvsEQ08/8k40P+53xHSYSxmaGIwK8EaXqOCq8rkpCxKZqkRianq08DOnXzEbEaMfbruYuuXoMLLNikvwmRNU/cFqKUtcxbmLdq5phi15FcebgWOABM8P76k9k27DeXIn4etcZ29ccNxb7BljVGClrdD5WdnOko6UThfkrI5GbuUMnFb7FzXQZk7dASpb2WsI2/qZeFDGkp0+XDlXmdtDFckE5znnmCe9dTY9VpXPeVvu5eA3HVZ5Oa82kOfz0Ca4QT7wqtg5iMQkpRN71J2Xtn1UyodRy/5MNJtC7MPUP+K2/8JHUDVwcTqSmpi6fj6mkk4/QBbbgRkIts4GoxJH3QY+zWLw6PzuWgrsr06jLveWtjEiMpqyjcxiWDHYd6CTsCpnkm590uu6Vr0uQo17MihSgujW/w8KQ2DR+2XRPVN/NRfBDKeLpTnfgRcamKegHWd7THJ5VSNntfFgo5thEIxUdeeg4dE6ayJ97pIY7Ymevi0N2ayV1VXw3EQYyyw/RWk3KUnz9gYX13GPWwDLST9R9v3f6re6jYAhvZIQyEmB210F3JJNKrjvhuM4xpepuzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(39830400003)(396003)(376002)(136003)(8936002)(38350700002)(7416002)(2906002)(6916009)(8676002)(4326008)(38100700002)(54906003)(86362001)(316002)(66556008)(508600001)(83380400001)(6512007)(186003)(52116002)(44832011)(6666004)(36756003)(5660300002)(2616005)(6486002)(956004)(66946007)(6506007)(66574015)(26005)(966005)(30864003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UY6cu/EvEv9gLFOBwekKj8MEJlMr/QwEijHO+lpJ9IbSRURGDirSTUNo8mIa?=
 =?us-ascii?Q?wTPbmJlLvOfukQWEBdXBRWGccddnzNXhmMfVl+BuhGbiWxcX6VslmPJFqNU5?=
 =?us-ascii?Q?e8mfaW2V5lTC+ushT6naPWbTQno+srmERpgvyzC5nFKYHOB9Q2VQNabzYoEf?=
 =?us-ascii?Q?JFOIlmWekPOC3BfP6wiGFyuBUTPxTzG+xEt17GXt4PH0LYQd3M5jhU19MGGS?=
 =?us-ascii?Q?jIdyuCY3914MLQUtzJv6xPbKTrCzWJub4Lj09NK5jnK/8d7kuIDHmIErWMc1?=
 =?us-ascii?Q?f3AgBWPrGhirgZoG4Uyt66+xkkmxXb5cbfC8p4Erd785H/rvT6Pq83F7MHga?=
 =?us-ascii?Q?SeN5JIp1c+VASxRPLAkhcLRzaKi4qzQqXsH5OKowQ/8Zvi4TYyKD5ql8ln90?=
 =?us-ascii?Q?qlPAHdZyZVMtOOjtn7XMDz9Jd1+ijChWVg2HPz+sYCi5ZRvh4y9S1Lr2LNUF?=
 =?us-ascii?Q?ajL9oY1g+rQSVNMIPtLlen8fdDoQpsB+cvwuRofV9GxggXJWpm/CJKJ2YH5e?=
 =?us-ascii?Q?W0SZpZXEO/Pz6/pBDK+dU7p6/HKdcQBwbXgUk8+GqsTeNCDR4/KeBcxmMuDg?=
 =?us-ascii?Q?5O/xtmN/nWNWB/LGf9WbzA2B012CySnvdnr2fhEQlHq5r9V5kdsDS1jaDH/q?=
 =?us-ascii?Q?GKNBRnNIcwuOXq1tNRf+h0voyLwh3NymuGwareaQRPyIWFiL1GhbQUOn7rFm?=
 =?us-ascii?Q?Cqyl1kVoB0WZN8QKj+VBPuNbpib9inDRzPTGgPRhk5F3u+n3dm8RffqQA32C?=
 =?us-ascii?Q?zfgqTBE3g3Mda458v8V8ouhKrQ4YrTz1C8b4IPHa/NehNUwFsFtWyZwukXuR?=
 =?us-ascii?Q?fPc62Z4KrvHgqnEIpaKtKaKbiMpkPVC4xw9ryF4VxFllQaWIfzzffnbQ3TMJ?=
 =?us-ascii?Q?QPfMKl/dQQDw8aL9oNY4jygsHk+YMRcneeAU7kUiQbdFFqclx2Sy+FybOzvS?=
 =?us-ascii?Q?lhpfZ3t1ObolGjWmvG/aDjENV+gJd5u82el2nAPEF280/bKlsIMpEnWKUCz0?=
 =?us-ascii?Q?tHJkWVFcIi/fJg0ZEyjdnn4uYIRv4fn1xMIt3VhJ7Hdkev+485hdYccSsHvC?=
 =?us-ascii?Q?q4sTP6wQ5xJDRcvSfUaf5MPKKrBSc8Ja30b/2UnzFr5Hzop3MAQb/y+JES6X?=
 =?us-ascii?Q?j1UUdhClCCKv9TXAmcvczdln3rtS+FOxUnrnATwV+ZPEHMT3aWsraDaI9xZQ?=
 =?us-ascii?Q?feVLl9GkOVD2jiFimIYhIb2+B0xMKXw8Yn76//xvg1YOr8Aa45o90Kjbms4s?=
 =?us-ascii?Q?RptuwI1hBZ82bb52aSbu4gXT9xgeEWJT1wTnq3Ma5esgjB86H8EGgin4oRMW?=
 =?us-ascii?Q?U7iceM5kO1PKWxNRF106hIO+3Z+tlmov/WHFVTlyJCMCysmi/nsqmpF1Nphf?=
 =?us-ascii?Q?YW3TjvA9eK0aOROrrVx2kBh9zbjJPBNmdFNDzpWwqcDP3MAvzJooh70dihGq?=
 =?us-ascii?Q?lWpKJIkUki3gvmpbKNtiITtJ/Wa6nFXdXcaHjQJGZKn4QwL2FGhVeG2Y21nP?=
 =?us-ascii?Q?8jUVz1RDytjNXmfwzeKFaoqINmC5tK0X5n7X+v1lTG2PP4jXvO1WwivJ1qmC?=
 =?us-ascii?Q?D0SUiftZgG09wZIgP1zAVL8sqbkbfMAhFpPNnyE+3DwsPapsk0ddIkW8bSoS?=
 =?us-ascii?Q?iKWubGBcelIcdX2zjJwPt6k6LkQud39CsGsd3La29ak7TFfaoxzydUUogZA3?=
 =?us-ascii?Q?doH9eg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 59205f9c-e542-48ce-3fb2-08d99e3287a7
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 18:56:51.3334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36vY6mrRIiINUyb7kj8YLFaTNe4NmNF90UjGdu7VmFS3KS1jatNaQ6Zwyr4xbPjQScSUUpFP3y1A3FW0K6G0veXWDHZvFArMmHb2UxZyFH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0397
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

- fix structure laid out discussed in:
    [PATCH net-next v4] net: marvell: prestera: add firmware v4.0 support
    https://www.spinics.net/lists/kernel/msg4127689.html

- fix m68k compilation problem caused by commit above

- fix review comments discussed in:
    [PATCH] [-next] net: marvell: prestera: Add explicit padding
    https://www.spinics.net/lists/kernel/msg4130293.html

- fix patchwork issues

Reported-by: kernel test robot <lkp@intel.com>
Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_ethtool.c   |   3 +-
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 139 ++++++++++++---------
 .../net/ethernet/marvell/prestera/prestera_main.c  |   6 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   3 +-
 4 files changed, 86 insertions(+), 65 deletions(-)

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
index 41ba17cb2965..1a460d3c85ad 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -180,108 +180,113 @@ struct prestera_msg_common_resp {
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
@@ -289,14 +294,12 @@ struct prestera_msg_port_attr_req {
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
@@ -313,6 +316,7 @@ struct prestera_msg_port_info_resp {
 	__le32 hw_id;
 	__le32 dev_id;
 	__le16 fp_id;
+	__le16 __pad;
 };
 
 struct prestera_msg_vlan_req {
@@ -320,13 +324,13 @@ struct prestera_msg_vlan_req {
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
@@ -334,22 +338,25 @@ struct prestera_msg_fdb_req {
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
 	__le32 port;
 	__le32 dev;
 	__le16 bridge;
+	__le16 __pad;
 };
 
 struct prestera_msg_bridge_resp {
 	struct prestera_msg_ret ret;
 	__le16 bridge;
+	__le16 __pad;
 };
 
 struct prestera_msg_acl_action {
@@ -379,7 +386,7 @@ struct prestera_msg_acl_match {
 		struct {
 			u8 key[ETH_ALEN];
 			u8 mask[ETH_ALEN];
-		} __packed mac;
+		} mac;
 	} keymask;
 };
 
@@ -408,16 +415,19 @@ struct prestera_msg_acl_ruleset_bind_req {
 	__le32 port;
 	__le32 dev;
 	__le16 ruleset_id;
+	__le16 __pad;
 };
 
 struct prestera_msg_acl_ruleset_req {
 	struct prestera_msg_cmd cmd;
 	__le16 id;
+	__le16 __pad;
 };
 
 struct prestera_msg_acl_ruleset_resp {
 	struct prestera_msg_ret ret;
 	__le16 id;
+	__le16 __pad;
 };
 
 struct prestera_msg_span_req {
@@ -425,11 +435,13 @@ struct prestera_msg_span_req {
 	__le32 port;
 	__le32 dev;
 	u8 id;
+	u8 __pad[3];
 };
 
 struct prestera_msg_span_resp {
 	struct prestera_msg_ret ret;
 	u8 id;
+	u8 __pad[3];
 };
 
 struct prestera_msg_stp_req {
@@ -437,12 +449,14 @@ struct prestera_msg_stp_req {
 	__le32 port;
 	__le32 dev;
 	__le16 vid;
-	u8  state;
+	u8 state;
+	u8 __pad;
 };
 
 struct prestera_msg_rxtx_req {
 	struct prestera_msg_cmd cmd;
 	u8 use_sdma;
+	u8 __pad[3];
 };
 
 struct prestera_msg_rxtx_resp {
@@ -455,12 +469,14 @@ struct prestera_msg_lag_req {
 	__le32 port;
 	__le32 dev;
 	__le16 lag_id;
+	__le16 __pad;
 };
 
 struct prestera_msg_cpu_code_counter_req {
 	struct prestera_msg_cmd cmd;
 	u8 counter_type;
 	u8 code;
+	u8 __pad[2];
 };
 
 struct mvsw_msg_cpu_code_counter_ret {
@@ -485,21 +501,21 @@ union prestera_msg_event_fdb_param {
 
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
@@ -516,7 +532,7 @@ static inline void prestera_hw_build_tests(void)
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_init_resp) != 24);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 112);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 132);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_stats_resp) != 248);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_resp) != 20);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_bridge_resp) != 12);
@@ -549,9 +565,9 @@ static int __prestera_cmd_ret(struct prestera_switch *sw,
 	if (err)
 		return err;
 
-	if (__le32_to_cpu(ret->cmd.type) != PRESTERA_CMD_TYPE_ACK)
+	if (ret->cmd.type != __cpu_to_le32(PRESTERA_CMD_TYPE_ACK))
 		return -EBADE;
-	if (__le32_to_cpu(ret->status) != PRESTERA_CMD_ACK_OK)
+	if (ret->status != __cpu_to_le32(PRESTERA_CMD_ACK_OK))
 		return -EINVAL;
 
 	return 0;
@@ -1344,7 +1360,8 @@ int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
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

