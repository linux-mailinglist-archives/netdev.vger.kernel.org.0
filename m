Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1EC44674B
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhKEQwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:52:47 -0400
Received: from mail-eopbgr70099.outbound.protection.outlook.com ([40.107.7.99]:6211
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233425AbhKEQwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 12:52:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An2Pw4oEuu3aLGMrULke+ezFXBYOTVTqDMpBYIA0CklzBf81Z8xH9wqgat9uy9FPGJuxjhHFtjsYj81hqbkzlm8BbrzCB5RdaAiy72Xq8n6n1TedWRPwDga0Tve3AmAubzqcCiRcZ3XhuZ5c4VA0ABMjV1WuoueGTsUXLKwZBvIAybDz4MGhT3pOAT6IkXHCVyU5GB69cwmHMjUSN1+dObsdS59JGi13X1Pe5mw5GT5CI5NY35cnu8gyP70WCjttpN2v1V5/Ev3eu/EPvRUD3CzZ8h6DKGi9VFtDZm5NsfY5bNmkxkMOEAso9NxvYkjcM3e2+vxrdsgvnus/jmTksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0rb/r8f7lXN41pY4jxmCxserVQedMs0F+chpQ1Oe0E=;
 b=NukFeITPGbRSlR5LmwP54tcUqfHt7NzWTsuIN0RSrCi5ePKsX7Nvi8WWFUnNXJRKqSey/le9oqyAL7CNE2kUUZLabI0Qm1W7z/vaIkJkF11pv18eT/VlHT8SKbvvK8xplBW6L7d+ZxjkC1BDg6ykbPChLShGLCvkJZj56Vv4rSY6FxTxrwYHRaDT6I0yTUa8Mr8obFKCkw8tBIlmIlsQnPbYiwj6S7wl0jcVdKxom9s95Yj2UQtLLef2+/Yo/CMTKygJHfVzxeWhcmvtVBar8q4S1xoPbD4ljfA+iFxJ/mKDhr0bBjnix/0Hx2itIje3Pyz2oJS9rKhQxAxAwlz9NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0rb/r8f7lXN41pY4jxmCxserVQedMs0F+chpQ1Oe0E=;
 b=xV1ihLuoGBm4L1B4r/T5YYqzSmS4bzmqs+4QcexsaVjyGVKwVmAuK2p04f6cz5GeNVjJKmLmmHNCFHuCOb0PCi3fh6pnCmG9Dx4v4t7ZQYoPqYYSh41sa8kmvl9C8tvHEBFQzKFQzKiTzPwobL+BRwzZKoNwWmn9ZKHn9P79uLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0624.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:124::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 16:50:04 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%6]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 16:50:04 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4] net: marvell: prestera: fix hw structure laid out
Date:   Fri,  5 Nov 2021 18:49:24 +0200
Message-Id: <1636130964-21252-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0048.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::20) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by FR3P281CA0048.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4690.4 via Frontend Transport; Fri, 5 Nov 2021 16:50:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bcbe093-c7f0-4ec9-dfad-08d9a07c50d0
X-MS-TrafficTypeDiagnostic: VI1P190MB0624:
X-Microsoft-Antispam-PRVS: <VI1P190MB06243481FA97C4B323F4893A8F8E9@VI1P190MB0624.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+yhu8XgwlVgF3v6WW0/aDkkxL2LHzCzAiG6G/h9vTHC981Fm+QGEc5wX7FM/mFooaY7IZxyRCm0xy9yxxg4B6eW7FuO8AyG0e1qUMeAhel40Sjr8i2vrj9vQPXCYwv+IiVKxLqRUtLfjiyL3BXtmBhjUiOkw8EBRunEHilId3k/EQDlmWCxyfszc73UGXqx6lYB+D/+un345rQGa6UG83M1jjMIjK8Lp0/gvsPK13ypnsaXvAdx9r2ZCIQuYJDDhMqyoc/tw24dUaZGkD/KqVBMmR0cq1cXa8RaLygL8jV1sNavx1fxqvAxsrqKbswfUNhFozCgNLWfQ2WbBtpIQEzKgeaJufXR7qig/hUC9k8HwMDhM/EIfItjjIMxFXbG+Dq3oygOV3+PKayWjBo8noVOFYHv6dQh0YT6o6RirqYjJOLADZo2fejYCUlFhHPrs3swdYY1PwnwxnCZXJ9ocKpWrkRG6WLQuk7kTd6dFQeG6wizT9yg/CV/TgJ/nUegSCouAzrVckIijWiY3ZQfk1f2at8S5Kw6qAO4EFWEWqSvTS50c+uazIHKfqncX9tpRhJQZ0JKMmPD1Q7BF9/Gh3WKEcqMhZ8dIn6SybI2nrcWVyuxXbDyAmCDhtU/OBM5bDWIsXgoQZn6wh8TjT70GDMVA7Xh7sWwW/9sx2/CcVbVn3E0LrcHf3pF0/PnntA/9Wq+5077z2OuKDrBZQmEE1f8Ccv2awhm1KrUbS5LNhRSW08RUauyX3Ujg9NPVaBZofhyB40HxXULjbS+1qZXY2jxip/WdcPBK/4P8O388nE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39830400003)(366004)(346002)(6666004)(6506007)(6916009)(54906003)(8936002)(86362001)(7416002)(316002)(5660300002)(26005)(6486002)(44832011)(6512007)(4326008)(2906002)(8676002)(508600001)(38100700002)(956004)(83380400001)(2616005)(186003)(38350700002)(966005)(66476007)(66556008)(66946007)(52116002)(36756003)(66574015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4+18inbpC4gOhf60AWAL8lWvfOfpPdb2wzjIKsCNEZi2nS/JSi38D/VyASYz?=
 =?us-ascii?Q?cJ9G3BqZPtP3TeaphbLNR6RlTr6kR1tkVp4vpNyAxBDwKjym21f1YPPjYGSK?=
 =?us-ascii?Q?gPOsMihVS01gUU98N3JqCKkUz6zB2THufkA9EZsH6G0JngsWWS8Ui7Ds6PWn?=
 =?us-ascii?Q?fmFhY7y6PwbwYqrWJ9oziJuqYZDArDXlY73FQvo6JnufjeLDRb/hF6UrPPk5?=
 =?us-ascii?Q?P7/VDiUD7VDR5lRhHv0np/wyZzZT42hvN26S9jnkLS5iXOhhIMv9Y8YgCAh7?=
 =?us-ascii?Q?hNjr05Q4QDg8+u/IXSjRQ6Myh5O1nBoVljQCbJNS5k7GQjQhP85hFhfaYoEg?=
 =?us-ascii?Q?fu7j8HVPthjNj0KO5/tavtOl2lYyR1tTorfCrPIQSg2JsgKc0opZkLoO90ad?=
 =?us-ascii?Q?xICKzO+97UxQt3+kAti7U1yTFK1Ffl7Uczct7o+uuEYC3SuGnTbeXXpycjfC?=
 =?us-ascii?Q?oAcFZ1JfhRzeImmYFQHaAxKUawMg5gWI/RwwZ3Z/KMMFon09teKFgP7J31yh?=
 =?us-ascii?Q?wSP/fouCzJERoTnqaVUd+hKYIuaMwvaiERx2jr/RT2Wis0PScBBU8dROR2zS?=
 =?us-ascii?Q?OTwsX9GkhMldkZXfwP/bBvQeHpXJVDjpI/K0VB5OqZN9B9cykbHrAOC3Ivnv?=
 =?us-ascii?Q?PfswcC1P3OI/DUXSzrsKAj806n7d61P1IdFKI8y9SrGhvzoVfIKtueGkTr00?=
 =?us-ascii?Q?NOoDDmwolD7gs+lABbj3Jqmg9nKQk7BesddWG94ZR+DYvwSnQZWkHoSuDwVL?=
 =?us-ascii?Q?UbIP1+Ww3euDnzfAZNIb2E8bOQOpnZBnJzL/cD5QbZd2uAmEBtCSP4geUZcq?=
 =?us-ascii?Q?G5/oaaQlZM47vYd1k8Yy3W5e+rsru8mX0GJLD/pwFmZHeCEf/q4IzJ4/7CwC?=
 =?us-ascii?Q?TPBUJs1NV/rcWSLPPzmJY8aNAHTXkQrE8DXFS7pGr3RCAxN2+SAMIaaSmNFs?=
 =?us-ascii?Q?dPA/qxneG5Fa/2RnYNAIu2KD7ju94WmfymAQKJ6dI12QQ0eOj0lYII39iQX9?=
 =?us-ascii?Q?5BZDLv7TTSjYDvauDPsEIYLgNk4sxkYi4hrLyod9n+TxV0ZC2vcVsPpSbuZ+?=
 =?us-ascii?Q?VR5umWopj7aEgnTp+hPlOoNyoeKFDYiE7wXbZji5x0xPdpdgCAYczZ52Cl9m?=
 =?us-ascii?Q?N6FEixGexrYKF3ZFOngHJvr09FbTXEMl9FDcUIxaKB0vAW3pFazNrjDcT+QR?=
 =?us-ascii?Q?PiJXGqTISsNRxL/K+zlhs6rwZeOhOPGrZybcDhSqH84muNrlj13aPM++fG+A?=
 =?us-ascii?Q?ggJwQPZD2Eyr8yVYqYEaB1cLwvhyimhMQyPQtCF17lhr2/9sxHkj+MfK1dta?=
 =?us-ascii?Q?cijorUyW+70GqjjYV/atiZNULQQbM8nGa61lc4m8UyMqTQGFyyKBzhneGQ9m?=
 =?us-ascii?Q?+RwsvX4F8kgLylcI7dsYruxphE1wzNNTUXsvrXbPCI8XOKOwVT7zhJ3glCWS?=
 =?us-ascii?Q?8nvQwtVnfbP0dIgyPa5ut+pEW1zIzfhX4gn/HjtJ3/H5t6nNWULa9HdZQsls?=
 =?us-ascii?Q?itWEzZFzo9Zf4yPYBC9VFdxGhDFumFhwsKL5xFbf7937WLdxurA/2fw2L1Tk?=
 =?us-ascii?Q?o4Z6mtzUHWd7NnFm25qhDZy84LBNJppN2YcNuZlcZp3EZXVUPmaGTPT/4sWC?=
 =?us-ascii?Q?MVOAtCy4XKXNynHewzDdbr8IvmAqzljIDzZnKiARMJTFWofljHUFJPZXp2HY?=
 =?us-ascii?Q?MqFnxA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bcbe093-c7f0-4ec9-dfad-08d9a07c50d0
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 16:50:04.4135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xt91lbGKCnTn6NKtenqbeCLs/erIspYnX1NH4RChEi2zGNsZ3xG1r80X/DuOn2g6Nd+reLZ3niCT3kXygmyAGOrQpEpsgUYbcVz1d87w8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0624
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

The prestera FW v4.0 support commit has been merged
accidentally w/o review comments addressed and waiting
for the final patch set to be uploaded. So, fix the remaining
comments related to structure laid out and build issues.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

Changes in V2:
  - fix structure laid out discussed in:
    + [PATCH net-next v4] net: marvell: prestera: add firmware v4.0 support
        https://www.spinics.net/lists/kernel/msg4127689.html
    + [PATCH] [-next] net: marvell: prestera: Add explicit padding
        https://www.spinics.net/lists/kernel/msg4130293.html

Changes in V3:
  - update commit message
  - fix more laid out comments
  - split into two patches suggested in:
      https://www.spinics.net/lists/netdev/msg778322.html

Changes in V4:
  - removed unnecessary __packed attr
  - get rid of __packed by adding alignment field
    to prestera_msg_port_param.
  - fix prestera_msg_acl_match alignment

 .../net/ethernet/marvell/prestera/prestera_hw.c    | 131 +++++++++++----------
 1 file changed, 68 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 4f5f52dcdd9d..5550c0a8bec3 100644
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
-		} __packed phy;
-	} __packed;
-} __packed __aligned(4);
+			u8 __pad[2];
+		} __packed phy; /* make sure always 12 bytes size */
+	};
+};
 
 struct prestera_msg_port_cap_param {
 	__le64 link_mode;
-	u8  type;
-	u8  fec;
-	u8  fc;
-	u8  transceiver;
+	u8 type;
+	u8 fec;
+	u8 fc;
+	u8 transceiver;
 };
 
 struct prestera_msg_port_flood_param {
 	u8 type;
 	u8 enable;
+	u8 __pad[2];
 };
 
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
+			u8 __reserved[5];
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
-	} __packed link;
+			u8 __pad;
+		} phy;
+	} link;
 
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
@@ -363,11 +366,12 @@ struct prestera_msg_acl_action {
 
 struct prestera_msg_acl_match {
 	__le32 type;
+	__le32 __reserved;
 	union {
 		struct {
 			u8 key;
 			u8 mask;
-		} __packed u8;
+		} u8;
 		struct {
 			__le16 key;
 			__le16 mask;
@@ -383,7 +387,7 @@ struct prestera_msg_acl_match {
 		struct {
 			u8 key[ETH_ALEN];
 			u8 mask[ETH_ALEN];
-		} __packed mac;
+		} mac;
 	} keymask;
 };
 
@@ -446,7 +450,8 @@ struct prestera_msg_stp_req {
 	__le32 port;
 	__le32 dev;
 	__le16 vid;
-	u8  state;
+	u8 state;
+	u8 __pad;
 };
 
 struct prestera_msg_rxtx_req {
@@ -497,21 +502,21 @@ union prestera_msg_event_fdb_param {
 
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
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_req) != 144);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_req) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vlan_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_fdb_req) != 28);
@@ -528,7 +533,7 @@ static inline void prestera_hw_build_tests(void)
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_init_resp) != 24);
-	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 112);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_port_attr_resp) != 136);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_stats_resp) != 248);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_port_info_resp) != 20);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_bridge_resp) != 12);
@@ -561,9 +566,9 @@ static int __prestera_cmd_ret(struct prestera_switch *sw,
 	if (err)
 		return err;
 
-	if (__le32_to_cpu(ret->cmd.type) != PRESTERA_CMD_TYPE_ACK)
+	if (ret->cmd.type != __cpu_to_le32(PRESTERA_CMD_TYPE_ACK))
 		return -EBADE;
-	if (__le32_to_cpu(ret->status) != PRESTERA_CMD_ACK_OK)
+	if (ret->status != __cpu_to_le32(PRESTERA_CMD_ACK_OK))
 		return -EINVAL;
 
 	return 0;
-- 
2.7.4

