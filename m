Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B7445395
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhKDNNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:13:17 -0400
Received: from mail-am6eur05on2098.outbound.protection.outlook.com ([40.107.22.98]:56033
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231210AbhKDNNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 09:13:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIT/8puWC2N47257E6NAoRza7arQhehYXZq3sIqtoamxiLY6sU/i3A87O6aNPKyfncQDk/SPEDxV0sWqZa9DTdtMWloZzSGCCEaHFSgwc2ts25uV51SCYqt0kcFTBhsxjq1Jllr8OEGXR9P9OcYMBrVogfSL9r8qExL+F5qBzZlqknHq5gqA/id0CyCvgkJ0t8mYxULvpJs1/BPwmPb72kLdgzS6mMFQyW0OuNWmhfmembMuS88mffwwY85690ARAiVf5cw6wRLeSOH46yHBsPxj5JIpnBOK+r9L4VzcsmcWC6Kxtq/e5O/luFzMRPXnBtmh+ainq9eWLj3UeAqOaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LLGJdAoGLlzA16McImIsvTEg4ZX2rL9vcQkiG88G2Q=;
 b=W5nR/qD3d9yFfbyfTmLgFXssfThouMpZWIC0WG1mE1lYspgZTCi9o/ildhld92ojoyhDunB0YRwVpj/W6WUB4eIFsqe8n98ldbMRYcjtUaQMJ7uztu8aRHqZ1lOTAj+Fp+KBCoNPaUhwCpQWwOk+B0pSTGxbu72h4VLAFZqwZze4jZ8kdx2bs7LvzpoGKn6p1Pb926Z4v1QcVGQ3yOM2j39xLRmosl6XTqOGhSB0/1qixK4pVtrvoQvtJeqoYCLiJEgCa3Wb+JPApOITs9qaDP5/bV3Ez5gU7WiMIZ6IAUuPwCRTN5xAR29KSfrMo7VXqTMENUhAT9aoOdFRYs70Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LLGJdAoGLlzA16McImIsvTEg4ZX2rL9vcQkiG88G2Q=;
 b=lqsDqqJgHlMYjVq9RLl69+oLaGeZq98lT2UsKnWTfNWPSH7IvMmI0FF3Xh6yI3DcaGyBMGvkBohWZ3+aT3FoxrFIjiglD0si4hULm3kceqXLKELHrzNSjmq4SVLAlbIbQzOaHgk72QR8xZjJfVCUrR9aCb3USEYS5LXGSMONJR4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0560.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:3a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Thu, 4 Nov
 2021 13:10:30 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%5]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 13:10:17 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v3] net: marvell: prestera: fix hw structure laid out
Date:   Thu,  4 Nov 2021 15:09:58 +0200
Message-Id: <1636031398-19867-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4669.5 via Frontend Transport; Thu, 4 Nov 2021 13:10:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e0c13f0-9945-4189-fc52-08d99f947247
X-MS-TrafficTypeDiagnostic: VI1P190MB0560:
X-Microsoft-Antispam-PRVS: <VI1P190MB0560F054CEEDEEE4021BE9488F8D9@VI1P190MB0560.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujuW85fp4iOIbAX5VMSeTEuycDyX2v2h//mQ7I/mslcEfThvpR70DmnNzg7VBhwU4T93l2AncUG2X8ASFDfiGCdDF1bN1c9/oAO9lw06LfXrQ/5q1B/FftR9RdnHFYvaOec43vM2EXMqCVvlkFpXD8W6mr1JlT2ys6nrDgNW9NkcRgLhUjKaGi/vLYaYVsWTvLJfKKkJf21RLpFWB7mbHitdIuk3w9R8WFLPYFI06udWv/cX3ssKnaQvCopUYW+b0l7lPA5F6hwb9XAHjw0qPMNuDNVjotG+ldYl17hwbQZRbzoWQcLITQY6xqp2wk28lkC4emP77zIC18mqysssLVNWTvwEhqt6N/zPONoKG7eDHvdUbTBtAYtVHE3XNxwQ1UEX0oaKR2AXDssRcoNXWo2YKgyvaLXKowOwipF8AnZy/7S+h5doqxPGKWLlSPlTWgsOpYBj110zDWaJUrrAfpoQt6VRCVFUrMMUsKnCRWoRjbsgIC2cSSrO5gEThXqPGQkFIS4BC368HeXaFG8tS9+9v1ryqgypDHKJ1GisaD0CHQa08J1fOplk0DAWnetfLMh2vbgNWOGiqAL8nfKn1uSV28BCiLsNPA/PdN34VNRIX3hHBi5LbntgE5QhRnC2x5eL3MBBAXqk1DHfFXCImG6FG8+e+pk/BdKPAHHgEfB8Ioo00Ddb5JptkopAHMSJrIdgdqt1W5M0k/TyrzQFgQmVlS+AaUNne7whjiRIoBHrFbgNUFiTlm5ZD3izJH0L/Plw96oVAsFyUHuaHg/1ZSTm+n1LlUGw8AwYeh9IuBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(346002)(366004)(376002)(396003)(83380400001)(5660300002)(66574015)(7416002)(52116002)(2616005)(38350700002)(86362001)(8936002)(54906003)(6916009)(2906002)(316002)(4326008)(36756003)(956004)(38100700002)(6512007)(966005)(66476007)(508600001)(66556008)(44832011)(186003)(8676002)(6506007)(66946007)(6666004)(26005)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TY7F1NHzEsoRmicQ8+fHRh4XDZm8i+eNU8ABKZR6eBlLcEgDO3QAnczkHEho?=
 =?us-ascii?Q?4QXx8MeFI6T+H2Mx1udJvwwN+N18Qvu1Jovp3s8fVkolCAhQYF+odVnkdPO5?=
 =?us-ascii?Q?mwVPQfKGhDVBTvz3xG1qCTQiXkORp2Vy/O3wRVOSXmjyyCzyrjs2MR/YnqeZ?=
 =?us-ascii?Q?X2Ih+TYVsSNTCKFZ3xLRVnpatCZId3a+vDMin1VNwIrIQY7iX5BvN4XzwnnB?=
 =?us-ascii?Q?8aw9ZtY9V1gWw28eGXR5HdbGE6Fc4fXz8Ksas5OuIa5tkCoLKcJzvPd3nUbe?=
 =?us-ascii?Q?+Bes8fxKWhuLRBwSfghlvFzn3inJ+fJbGEe5Q29Xq4/C3c7SQgWsjmdG8+dS?=
 =?us-ascii?Q?GIFOadB+oqWfPmSAMx/e3coAsCGSYSX9oJHlN/TU5YecXnAc+LjmnUBfL/aK?=
 =?us-ascii?Q?q2EiPrrMqKVggWpo2n6luHxCkmML4pMQBSDTNQUq0aPXiKarwXBMg6hk4SSU?=
 =?us-ascii?Q?SKRjynCEYYnf7S+M2xuGTAOjtGBwIWG3fXdkqeeaAmyQByJZ2wFI4Ow5kvCY?=
 =?us-ascii?Q?YcCAqDghQWopmOGkKxu9JH2IxGNVh3JsUMycsanrrxjVqVCib6+25FdtZEfZ?=
 =?us-ascii?Q?Pq9pBxvZYwYfBC1Mo0dvk2d4rBAl6N/2GZ9EgWf6WrQGuow+HJa3qYioSHYN?=
 =?us-ascii?Q?Tj2VW9eY4J1qgh4SQY+raD01VtKsuL6c9GOYZ+4kiS5qkWK9B7crGlqxDauz?=
 =?us-ascii?Q?AAQTC6hb5pi7AByeUE3oRYZbcQkpa6W7jpJEimhgEqGBWU0EAQDAiUOwksxK?=
 =?us-ascii?Q?OBnj5iOjatH1j0NUWW7traGg1t93b90bn0mfxvF4ry4Px7vU04oAZM1yvv+K?=
 =?us-ascii?Q?u+c6IpHW3kwhcv83LFL7kuLTf0jBKYTxurj5Hx8bDvlkz/6Tqs45BTibuvCx?=
 =?us-ascii?Q?y3TEosHM/sRNqkygpU8obgZ45iwvUQc+zpvizRiMNFdMbzLp65aY3uS/IyAX?=
 =?us-ascii?Q?mJvCkzS9gl4fMw+bOcLMsClvvE9aI1dza/lmv+NLDx1mVsuhj83QSDIx+qXe?=
 =?us-ascii?Q?utt8VNdhA7Ql/xLepmVPU6RQiC4SEV2Wnpn2/iop8DXwcOrRR1DQlBnwVjD2?=
 =?us-ascii?Q?fd3TDwQJ6fl/6Fp0HklzmF++ZobKHnZ1rCeLICzGSU+ibTy2gRFdWW5NYB2j?=
 =?us-ascii?Q?ZkwRi0ydtEhJbcpA9BJOu54R5jra+So3lZecCiXxjC3NpH78JOOY2fwtbHMT?=
 =?us-ascii?Q?0BiF6uTwalodJyK78sfcfmWe6vFyJ/ADAzr0VLEpj/McnAD59RY3dAgsHQOp?=
 =?us-ascii?Q?mQxwxZS51pbtXnSdIjAPjL7DmxmuVlpkmU/HqCiAU+EUfc9xeSQvZ8D0MfSb?=
 =?us-ascii?Q?0W2MbQhvX1JAeXxlTCxobh6QCbd2/jN8LbBH+4r0qBTz/7Aod4Aq6BSmwA5G?=
 =?us-ascii?Q?o/1UPHoX9BuKgQWsjK8WU/BBRjAcNRcuA1bUh7oBM24jxb2GjZ37xcW7VSzD?=
 =?us-ascii?Q?K5+66rA4yZv4iES/N7AZ4XJsk2HbTCLeEx7meKOLVfudA7/uiJGG1Nq54YXf?=
 =?us-ascii?Q?NkTva0QL1/eZqDH/ZEhf5gc7rtBw2/iatOAAClm0/KRyuWzAfq0dTEotyyKA?=
 =?us-ascii?Q?ZAnc1uVhCf4JICNAlpa0sXPzvse6RJ2jgKnQb9gmr5JjvY0U5oAhxgLB4E9+?=
 =?us-ascii?Q?y7CHQ76BhxdAUjXx4KCREJSjriQ7BxfJ4Qk2oiZVWUocmK+e+68UF79Uh55/?=
 =?us-ascii?Q?z3H09g=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0c13f0-9945-4189-fc52-08d99f947247
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 13:10:17.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yOPk+85InBsEghV3ce3JunqN5r5eepdAedG9Po0eepDf7euSWA/C0HQPQ1xZtsx4g2yhni5c+/lFvzwONoPa/uannMDp6jpIDgFvpcWjUS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0560
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

 .../net/ethernet/marvell/prestera/prestera_hw.c    | 124 +++++++++++----------
 1 file changed, 64 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 4f5f52dcdd9d..f581ab84e38d 100644
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
-- 
2.7.4

