Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1343DB979
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbhG3NkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:40:25 -0400
Received: from mail-eopbgr20123.outbound.protection.outlook.com ([40.107.2.123]:37764
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238970AbhG3NkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:40:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkzDVd30uICIfvUO9REXpJeg3ucvHR1Dg5d8VQHdFaGGhhHWOtHVIoAKBSa8RF4+veQLQiRpv1brHZnZ83YUCyF5aOTyLS8uAESNWvdoQqkMSDdNY4WJHIbBdcqTjhB0NnNFjJ0fXEfv5dIJKbDll8tudGLrjTTGCZvf2DeMFNOhgHxVeAK0mDyHQEeO7R7InPa0HRdX3epzakUIrA2Y7uDTsj4TbPAUkPssTRyo0cRagMz1s5zUef2UfxE9ZJXWa1v12rv706ZoDVlzvF+8hIQ5stIJza0YSJZ1jdrRHKf8h0sqGLm9cGZHO2Q0GP6U4n2Kr8yCSkhTR4yghFbz7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhIQKg3e+sAjl5xUMnlo6aA0gTaTnuJ/iSkCqIi//OM=;
 b=j2D9Ie+n6ooFR9WjfDF8ky8V8inOWaaqjwMp5vSEVAvcXfHxgTanbL+CDLtEkJkTON/xALln1Q1gXiGsKveQR+qWjzIyN2JQmumkFy0lDj+zWYiaVGtIRkuLmGh8B/3v7gb6uC6DI55A7A3ScVaSx2K6av+Iwesjg1F5R/d9Lu520nnEuxrChFkcXbnLAK0W9LGzzJuqMnbtQlIl8TxoStP7/23VEiXODCxxTy1rwAKrm4/HXWj12N8akaJgAeQvfw0j4zeqKQbwv9nOTYIz0lb0GYNFiYiTq+Otfx0SfyrSQHQmnE36Rln1nxg23DJTQwlShYXUDhV5nnNrsGIxjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhIQKg3e+sAjl5xUMnlo6aA0gTaTnuJ/iSkCqIi//OM=;
 b=CqSieUAKBAs72N1PPldeXPtxKQGDCD0sQt7aGrMEJJm46882q07BIXjrE/zcIoyZwkEyuhIXvy8vNO3b9SfkbyOjQcYLCK83Z0Gt/lbcqjf823X2XwPPdzRpuCYOls/+DGSodiFYhXUNHm8v3IflualQ94OSXohNsfLPyy1KdmQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AS8P190MB1271.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 13:39:43 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 13:39:43 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 2/4] net: marvell: prestera: turn FW supported versions into an array
Date:   Fri, 30 Jul 2021 16:39:23 +0300
Message-Id: <20210730133925.18851-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730133925.18851-1-vadym.kochan@plvision.eu>
References: <20210730133925.18851-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0012.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::25) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P194CA0012.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 13:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2ffb3e4-a20e-43b4-3fdd-08d9535f7d32
X-MS-TrafficTypeDiagnostic: AS8P190MB1271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8P190MB12715CE425A4CFC53521A72D95EC9@AS8P190MB1271.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: weMuVEqQwFpjo/5vxi6Xu/PNzgn6ijHp355p2MuET44ufLgdhMjO+ehVz4hAC7+MjYxQUR89KJJZceZuIT6kUPJWuiivFd6y18FcM0AqrsNH42V4qMA5vWQ3Y3jI1jsQ8lW3yGV9QBjqasl+v+++IOQdqvlZ42UMC7FR41Fh+G/VZYgA/T8p0ISv0BzYuLFkudpk1wBFsDbqnI+V9cgWCTzcszP+GBAeAMz0clvIaovMZkBijElVs38kri3UL/2FSAEbet8awyNEw9bsADFrX8os11vzzX1FeSOzZF4Dza0Ifg8KKXoH0+yTDjBVe4Nl7frZCrVHMjqT8z0YFKE9C2qEolybo4NdtjjUFh5gGLdpoPM/u+WBtZ3whVjGdnJ/37kdlwyhyO7BTlTIlMMrH9flSksxFSGnn6x3SUtjM/IxTWacOLdm1kqWFtFYocy+kw8UTJr9VkvTxXC3MVta01CQWmuxAQwYjZR/cz8O46XjIphbyt8hVqXgm3ER38soGA4HclPOJ+/fkjEOYq1kMCgfT0rigtyaqAcZAzSbdnqViEgwac57Q869r+bFgWd/53tl/S2AdHsfFQS0hb02qH5YGfJe4Uch4Zmxrc/V9Nrz9KwRFBsC8G0rRnJxw2sz7RM1rhgVLKulh+Ip9h8l4Nnmsjuhol+8Lz/Tn2S7JoPpQD8eQzpM8+RgveYtq78tJChDI6yTuiO9u0aJK4jqCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(366004)(396003)(376002)(52116002)(8676002)(83380400001)(5660300002)(36756003)(54906003)(26005)(186003)(110136005)(6636002)(6666004)(8936002)(44832011)(2616005)(956004)(478600001)(6486002)(2906002)(6506007)(1076003)(6512007)(38100700002)(86362001)(38350700002)(66946007)(66556008)(7416002)(316002)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g862kYPUJb3bDup7SIpN8pjbVceUUI0v6XOccjXOHIZU+oObF/OnB5SLAEtz?=
 =?us-ascii?Q?MEo5PP5n3AGzoQ3FNTw1Hk5CBd3/zn8zz+8tfmqWPNhCVpdPBbOKHHHx7Qc0?=
 =?us-ascii?Q?cS96nGUdveyqAJGOvOf+I6ZciytbzAXPPUl5Sc/fLDhiYWwdN5hdHaVwzbuF?=
 =?us-ascii?Q?QVC7JhiL6htbFWsOsj+r1oKLRXDiHsdjqIuYLQOvSHjEwlpOyq3/bZwW4Jpm?=
 =?us-ascii?Q?u0guosZbr7wIXCZ1IXQHC53WvLgKeoq6YAbX/+QqVsipwol+vhAc+QwZqmFh?=
 =?us-ascii?Q?uVHeviteyruG5nuZmmMEIJ6nxcmUIsvEaloeqNgl4WrftgIPfs7GXLlErpJH?=
 =?us-ascii?Q?97qsnyBoTm/aLXD3a2JrvSeMurmfVZ3pkPqNul9DYNwQZdXU8NKgdhJ2/M3b?=
 =?us-ascii?Q?8Gb16cuTrvF4uKJWHUy0ZDS3Z0qkL4f7NxfwM7rzkHIliw8VlvwtuP9ENnac?=
 =?us-ascii?Q?8jkQ9cW2kLkyBFZTaODd9Vc/e1WFlt5HdHezqX1IrC11AJcVtlUK3d+UkHXx?=
 =?us-ascii?Q?Nh8OOEfMALbsXMC6mdeKSjjfyKiatAaoGzrS4nc+MPcxEwWH+tURlZ6ZCpPP?=
 =?us-ascii?Q?3sFqds4dv0JLqM8mSF4to3CkZRcBmoWZRhflewYLcqMtXa0JW5/PRvETEawG?=
 =?us-ascii?Q?cwAh1EZDRIlPudEGw95V0I4aeWjbVfQYbPUdWdLo+j/GzBeautJStm9I097p?=
 =?us-ascii?Q?KzQPUd7n1+n4EPzWc703JwiSC889K3cGD4qAgS57ibC2m3Vvg+XOzQuNO9dB?=
 =?us-ascii?Q?ju96Rri+LEAUc//wKLCUGmQKRPVbPgMYxSzXJNJNGCvaICtP71tw4MpwkGY9?=
 =?us-ascii?Q?ftBFjcdAuZ357JRYnc3TFe1u6wjZ/HGvtjCqmRyxuKJ+Qmnk4Ev0KRLfAl6u?=
 =?us-ascii?Q?1TnH80wgs/M9o2G8kwNYfnYPY0dXCwSvJjacHnGuT+sSCZV6FY5TTVHa7TS8?=
 =?us-ascii?Q?dCcS3pgqxtP3gH0KXQPMBIUZW2omJ113FKEO0DEzM4ONX2Den2LLSU5cruKx?=
 =?us-ascii?Q?E0rOPYI9CgCZKB3crOvWQGQZCWapBMp19AWNVuqGnA2N8cH0fCWnf7SwqUsD?=
 =?us-ascii?Q?dYkGyEzWRpqgTRlygttgJhROz0iCUM6R1b2ql/XofbaKVrGDb8J4LhSnU8qJ?=
 =?us-ascii?Q?p0xhxw2W34IboNSunQVsyZY38p/kO6RL54tvf3o4s0nG7fviA2aMG4Yswm8V?=
 =?us-ascii?Q?dzaxPKILAifv63424vmhjYIVFcqWAV5n0i74z8+u0PGHXEMsw4/QtBs2vQG2?=
 =?us-ascii?Q?4Cv+BLIWZt2iAOeT5Z7fv9GqcF5xOmPNRn6X5M8sInWM3Pb2uVRHHoK4Wh3p?=
 =?us-ascii?Q?susazNj1MTCu4EpS4t1NOTfg?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ffb3e4-a20e-43b4-3fdd-08d9535f7d32
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 13:39:43.8194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybRj6w2eLktmluE29aj/1OAY2YmYXgteoXDG3H5u91lYG+aVagJO4GZPdQJK6Mn/Fl7HEfNCHzw2ptwtbVqU2937ATG0w0NonwEtl86cqzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

In case of supporting more than 2 FW versions it is more flexible to
have them defined as array.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_pci.c  | 55 ++++++++-----------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 58642b540322..ce4cf51dba5a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -14,11 +14,10 @@
 
 #define PRESTERA_MSG_MAX_SIZE 1500
 
-#define PRESTERA_SUPP_FW_MAJ_VER	3
-#define PRESTERA_SUPP_FW_MIN_VER	0
-
-#define PRESTERA_PREV_FW_MAJ_VER	2
-#define PRESTERA_PREV_FW_MIN_VER	0
+static struct prestera_fw_rev prestera_fw_supp[] = {
+	{ 3, 0 },
+	{ 2, 0 }
+};
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
 
@@ -629,40 +628,34 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw)
 
 static int prestera_fw_get(struct prestera_fw *fw)
 {
-	int ver_maj = PRESTERA_SUPP_FW_MAJ_VER;
-	int ver_min = PRESTERA_SUPP_FW_MIN_VER;
 	char fw_path[128];
 	int err;
+	int i;
 
-pick_fw_ver:
-	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
-		 ver_maj, ver_min);
-
-	err = request_firmware_direct(&fw->bin, fw_path, fw->dev.dev);
-	if (err) {
-		if (ver_maj == PRESTERA_SUPP_FW_MAJ_VER) {
-			ver_maj = PRESTERA_PREV_FW_MAJ_VER;
-			ver_min = PRESTERA_PREV_FW_MIN_VER;
+	for (i = 0; i < ARRAY_SIZE(prestera_fw_supp); i++) {
+		struct prestera_fw_rev *ver = &prestera_fw_supp[i];
 
-			dev_warn(fw->dev.dev,
-				 "missing latest %s firmware, fall-back to previous %u.%u version\n",
-				 fw_path, ver_maj, ver_min);
+		snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
+			 ver->maj, ver->min);
 
-			goto pick_fw_ver;
-		} else {
-			dev_err(fw->dev.dev, "failed to request previous firmware: %s\n",
-				fw_path);
-			return err;
+		err = request_firmware_direct(&fw->bin, fw_path, fw->dev.dev);
+		if (!err) {
+			dev_info(fw->dev.dev, "Loading %s ...", fw_path);
+			fw->rev_supp = *ver;
+			return 0;
 		}
-	}
-
-	dev_info(fw->dev.dev, "Loading %s ...", fw_path);
 
-	fw->rev_supp.maj = ver_maj;
-	fw->rev_supp.min = ver_min;
-	fw->rev_supp.sub = 0;
+		if (i == 0)
+			dev_warn(fw->dev.dev,
+				 "missing latest %s firmware, fall-back to previous version\n",
+				 fw_path);
+		else
+			dev_warn(fw->dev.dev, "failed to request previous firmware: %s\n",
+				 fw_path);
+	}
 
-	return 0;
+	dev_err(fw->dev.dev, "could not find any of the supported firmware versions\n");
+	return -ENOENT;
 }
 
 static void prestera_fw_put(struct prestera_fw *fw)
-- 
2.17.1

