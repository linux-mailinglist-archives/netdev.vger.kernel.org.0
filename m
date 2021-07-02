Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E2D3BA3F4
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 20:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhGBSc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:32:27 -0400
Received: from mail-vi1eur05on2124.outbound.protection.outlook.com ([40.107.21.124]:46816
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230119AbhGBScV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 14:32:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UB+og3lebGB8DQLfUCvqnurrTzekQNXpvfDfwFJ+51nPFjAwn78xJ5CWBPFm8K+K7XvxXWbOuZDKJ3mAMdWsp/3pJvmHD7WnFzJyX6MDtX+2Ljz8DM88Rwbl4GFCp0cMd4z/zJkHyzzp/uMMKwhFC13SWOybQIT7tZn6cXiUI58XgqiLtb0JeHzDLTOnByMbyw6ujaYTXctUfBpZxbThFKmQgpBVFsWgqAGVWcBy/qXQ9wxEqSCuPKZLV86bO8qyaP9wxYmfuH8IGM+7rt3ZXKYBV+mkVhte6kz2LM04ZBa4/oqb9B1F2PhxCz33pPvIMopvFqGMPruieMwMiVoPzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhIQKg3e+sAjl5xUMnlo6aA0gTaTnuJ/iSkCqIi//OM=;
 b=ed6pFY+YBLB+LbVtoREdK5GZn2zLXZtk6CeO5dUczRQQx7pyG52e+GtZCeQbnoX4MElK6UayPfFuFEFxp9lOtY/3PBK4cXuxjydp8HNU+rKnDy38psVClkaw+roYmgHf9xQ0MGGYjQbwMzfkut0fF1LJAmZXkmTSX7+IYbcVZoSbO/tmCCXx0J1o0nno1kanTh4f6+OHPFQVPivW2COzswyN2NkYGQK4/bvxuEF1OqUroWyTl4PsQaAtaPdGbdytgDgqR+dLcp0eIy5WK4ZCI3CgTXwp3zy2M9PBhTHOrbuSkwIzbqz+NPN1Kvht4tTadIc+mtaWE8xu1uXDrI6utQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhIQKg3e+sAjl5xUMnlo6aA0gTaTnuJ/iSkCqIi//OM=;
 b=wM+aYHKeZ+YPVcin5Ok3N3GkfrwegIxyKPay7XhDB7PwAF7GHJxfy7w1BeM50o/Fqr3XQC7T5bxYWXnBlt8IMG6y3ozmWDXogW7h5tKAkCxjhEmYA1lI7w6l5VNfHfZt+tO8Z+ynyKN3bbLIOdfe6hv4ng+8v/F1f787Bm1I1Yk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0394.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Fri, 2 Jul 2021 18:29:46 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38%5]) with mapi id 15.20.4264.032; Fri, 2 Jul 2021
 18:29:46 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 2/4] net: marvell: prestera: turn FW supported versions into an array
Date:   Fri,  2 Jul 2021 21:29:13 +0300
Message-Id: <20210702182915.1035-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210702182915.1035-1-vadym.kochan@plvision.eu>
References: <20210702182915.1035-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::23) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:20b:31e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 18:29:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d465d096-d4ff-4dd6-b8f9-08d93d875e4c
X-MS-TrafficTypeDiagnostic: HE1P190MB0394:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0394622F1957A35066CA9ACD951F9@HE1P190MB0394.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZIZn5pw21+97dZZiBJkGzFzAkRVoXX82LCfwoIAAwyp3X9ZMBV9IE96G5yrfAXNM/qYzGJfSw+w8XpRKr1j9/rHgVtM+17YSDDlw3UY0wZvpF1wisZtCPtKyz8XUilh2rsnWXNzEXBlSFbC7DHcEJPfgmF88TSYPx8lymDaR/0y6MvZWjnW/T/PWSiuFwcJII1ad/Txes1YrRCidkV/3mKzpQIqslstnm6CQDX1Tewj/Jsh1Nkk8kCK/fIL11hFxx6ergYcsOG87L5MJ8zMAgyFMIB/cE2PN2GRxfqqgec9J1Lyu9SJZIV7ptjKVd67foZyj2G56LktB6Cu7AznAhybIYADVOUO3GUjzMR7QTy+7T1bzpSMHTlzyxEcScWx77i07pERSNxieEBJqpDo52WsmOlut5aabs8ouFhA3A3nKMPbBcUSwllW8Annovvjyj/9MVCylOMJyIQZL3CU/A2TOvf8Q7kt1Pss7gfk/ldsoGIQ+tMAyoztIXHTS8z8Hr1yVClM0Wt+RX8yPUkyifKa+kwCqmpxaIamOpbrD7m1KXm7Lb9IzlATgnyjmkoE7TG+8qSVXSL5rCRGAR95mHX/MkkegMHPQnQ8q6WO8Q0suuIgCtH2CyG6elGzhxYAvRepJxmSB0eKIcDP7X4smJfXo2Kz4LAtikzopjmTQU7j4a1h0QtTXEvk+00h2Rg7QSXn0RF3kS0XY9LDCuljRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6636002)(7416002)(2906002)(316002)(110136005)(54906003)(44832011)(2616005)(956004)(38350700002)(83380400001)(86362001)(6666004)(36756003)(38100700002)(66476007)(4326008)(1076003)(6506007)(8676002)(8936002)(5660300002)(52116002)(16526019)(66556008)(6486002)(26005)(478600001)(66946007)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gmY1UpY7m513fOVW2f09PmzR9C/NzTq5oyW+/d+CZepOMMr3M3BtsXy5Ih9k?=
 =?us-ascii?Q?4tHdivi+DodmCiPgQG6TnUqVS7pRBwazvlLBN+H5FMAYVskmnZUWlNjf1XrS?=
 =?us-ascii?Q?4nI86ZxhIwMyfZadpIdGLTAKNUYGoUqKlZTjOYj7h737zgtdUieuKRNwRSjT?=
 =?us-ascii?Q?SAuuvw+OvwPpjuNrWrIPeaJI+nNXn9jNFh2Oyr2knY8ufdCEhfWml0O4XW7F?=
 =?us-ascii?Q?Rc2KorKas+BAuf3PnCFHA651BhVhCRlXCTOqycZGMxD0BAcrntF+N8TJ/ms0?=
 =?us-ascii?Q?JzxoMF5WbPCcDoLuz6cse1kMLpc0SoZVyhPSxeQT4h0lTZfz1RrB3V2tRqYG?=
 =?us-ascii?Q?+aOuDLBEAomCkrBRddW7eIRsohdGnFyrtKtJ041cCZwiveztE5g1ZKh2Y2LH?=
 =?us-ascii?Q?KX1FBXrNHleCLpKXl9zIMloZYVKtAiEyvXduQKaz/f4QKthPiXygfXa98sZK?=
 =?us-ascii?Q?UB5UVstzHnz6SQUKEm452AzQFukHG3EB/KetjznpAsgMhH9w9ByI4TMMskFE?=
 =?us-ascii?Q?KoRHMiEpmVHzhOnMlAFpIoaYLe3/yDWpayI4LwAgXy2sFvN8Bs2OLELUMK3n?=
 =?us-ascii?Q?Igs6qEFR5myUBBwqKicVtNUbZ6r/9qhQ9dla05TiYC9MsCsxLvwvTirutJIa?=
 =?us-ascii?Q?po8xaaU8BbL2HbJKG19cpRJKqrLG7hjfKRcyitQzt2+N977Ud4Vf5iCmeRqB?=
 =?us-ascii?Q?H6YwyVa1HCyRo6CQiNnlwRbfQa80abFSd5Uf8lkeILzQmvL1Gs5YjQr8FNvo?=
 =?us-ascii?Q?a0h6V5TsHyPOaHre0zuHkuIlkNHj078SHZTO0UcfFgx1S7GAUQXfj/0fASgo?=
 =?us-ascii?Q?MmmgFEeQnXP7b8mA9aFugFWI0BqdD9m9o2ABfuajMWI4hHiaoBq1RMZYyjrT?=
 =?us-ascii?Q?As25l2Ea5LSITN3BgDMAOwc8ax23skt2LxlzBY5ui6KTV4sDamWy6uGeIr5f?=
 =?us-ascii?Q?KUWrknWx3Uca9VPc49XVxJZ6Iif74USPDP7QhNMPK2gvmgRikHnA6eZOrOOF?=
 =?us-ascii?Q?OionOTCFDWH2uw9nvLrspNaaMKSxSm2RU6JLZb2dxU5CdZWvztt7fT/M+Zh1?=
 =?us-ascii?Q?ULDn1dsfdW4CpzzYLGHYN9FeEtzAb8dF/VX8X8NIV17tojjV2oHA/1+l+IEE?=
 =?us-ascii?Q?mAMW0xzLX4U9NInB/4GUtWT2TEqt6LSqFv8Emqf7OmHun6KyjxPwJS2E103b?=
 =?us-ascii?Q?wXsqElHh7SuPK/iJSKxyfUPi318pI0ouLwCYaPwFoDaSyE46XAVfqjY9wR10?=
 =?us-ascii?Q?h7/3Y6rcwwllPZ7PUqLuynpL5g4G4PDZ51ji5sPznez7lHqpoTTv2bW+014Z?=
 =?us-ascii?Q?g0vywZ4Wb7O5UOjJxGw1MHEb?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d465d096-d4ff-4dd6-b8f9-08d93d875e4c
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 18:29:46.3050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/BbmvnTQda8NIJ9LaeCOjxzlFNyK+Pyp+5Wgu3RXlflHwdphXfFbOl44aykdLcKCEE8/GGEuOteTehyICZ63eB9IjasMmNYDkigONdUPn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0394
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

