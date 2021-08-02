Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829683DDA69
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbhHBONb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:31 -0400
Received: from mail-vi1eur05on2115.outbound.protection.outlook.com ([40.107.21.115]:18525
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238094AbhHBOKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:10:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+6yOEStGZ1tm2DFonjq1eFWsuV+RvbavT2BEqpkcn9z1pl6jka0AKS4aEemZGT3ZLjiozAlXh+rfsPcea43wfmi3NrqR/3VIZIuU0PmZc76Dm/cztV+zJtin+csyuH6O81TIHrJ8dqB79bM7PpBGQbkgL/Gx9RVCGzjgo3Aa69lGna+/ANQKPMPv6hOAQVJDJj5k7NHa3qyCsWZsmfFHuX1aXqrbLo+6RHAOICl+7cOcibb/ba8rg80oR5U48Yy3yo85KQEoTGw4hnQ/QoRpYV5hSkc1RbO+9vTlAn7q/KuQ5AkVJO0JXwwIuiXnSZNnicH7H6CTKsFo6zJHeVFQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhIQKg3e+sAjl5xUMnlo6aA0gTaTnuJ/iSkCqIi//OM=;
 b=Z1nx+QXeFAbotll9ur+ijWMDlk3Ok20LUbPSd2B01u7DijfsrWG8ffQfykyOMqvMPdYQLJcxgtX+01XiHMmn+0jWL6tE9KUdoDklO7NR5Bsvr1x+ReTeo01x1hKZGYlXudsZouJF7MxieToBCBQrwb8OukCnPm5mjumnxOq6Kk1a+36OjEuUA9HNj6byLXnEuWfR+IK3Z0469nwJi2tZfTDc99dPcyDscRnX4U2OzLjyjY+ivu0JmJuF6TQUnG1OkrJSnq4bQ7F5Q5+V8sPEEge6LMu3cGYyCi9mZ42c0SZ4y690QCWXvm1VyvXUIXgb7Ikzk1LiegFnNc42efWnFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhIQKg3e+sAjl5xUMnlo6aA0gTaTnuJ/iSkCqIi//OM=;
 b=TZ0jEDw2KZscInWbU1qZobUCRvq80ZVOxrU76cjUYXYAdYmtNT44hk4sgsrhsi4+Hq4mfqj3WDbtUmh2ia7GFMjbtGQZnvYDUVW+Fy+b0liMMZuzY/wpfz5WDPSnu2K2BuvuW9lwV2BgMtOuOxejM4E/hM6HLOyaVVPKjPRj/oI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AM5P190MB0306.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:20::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 14:09:24 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 14:09:24 +0000
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
Subject: [PATCH net-next v2 2/4] net: marvell: prestera: turn FW supported versions into an array
Date:   Mon,  2 Aug 2021 17:08:47 +0300
Message-Id: <20210802140849.2050-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802140849.2050-1-vadym.kochan@plvision.eu>
References: <20210802140849.2050-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0066.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::43) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0066.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Mon, 2 Aug 2021 14:09:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9993f42b-7cb2-4fa8-be1a-08d955bf21b6
X-MS-TrafficTypeDiagnostic: AM5P190MB0306:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5P190MB03063D6F70A32C1D9BC5830295EF9@AM5P190MB0306.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aSlNoeQdPXY103+O4Ha3tG7M0Gpip0L+Rr4h/Ky5b27yIhBK+7RylMP8f6ono2FrJhOje3Ut24DAgYhMcJ5MOks2alKTBG4LDmHLxtj/njJLIpJqT/PxGcS4R1fyw0lUeaNBTBbq/MbelSnvE06+LKYQ/uw8/oYCOaxm6GipCRLw6mN0aqowUIYx3ZyaUk36T2CgpxHLlPDU2kwS4I0VnVFjlOiIANgMW9BODZSgJew6YAhU4KLWKx9FsDkms65J9iQQFXKot66qhOSBq7P+mxB1vVJynV8cAiWCBGU6j/vJk15Jjzq0tCpnGKQqp+z239WDmidS2k7KUIlTAnuF3thFeSV5xOzI8TPF8Lu1y6Cwb1F0v4QWUdG+0vpDIOpXlOP02KOuyrlH0YVj6x9s7AwvpnN0YzZtbQuRtELLDaYV7EPrWoiPn7mGW9hXGSOGZSPKUr0oo//5/oMnJgLW2MosjMHcqmLXoo2yfbhVbhYhtiTvgz5XUf49c8RNOdtUIkHnNnNuFQUpTddRLzBqxEdIt6xhmUvXa63G2Eq2g4mC0Z5iG+gGzSzm2OMyWkImLq6/X/YDM0RIzy2kxFRs/3y+n4hfN+SPJo5uu4GW6mtu2xDqY1bkAuJDZOLXlRc0YWiMIPjGksPbWzSumbwtVNo/aFIno+RDJB34HvClvrOixjAoEjlxAuAjaArCX3x2YQGD3KA9aIeGOTHKQpCVeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39830400003)(136003)(4326008)(44832011)(2616005)(478600001)(8936002)(956004)(186003)(6486002)(5660300002)(86362001)(66476007)(8676002)(6636002)(66556008)(52116002)(66946007)(1076003)(2906002)(36756003)(6512007)(6506007)(7416002)(83380400001)(26005)(110136005)(54906003)(38350700002)(316002)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dwe3V++7uCN2B/Odxq7jzbf+GZpAGRZcvmmbAWZDD6eOnJ2h2h07gdOM7Qzh?=
 =?us-ascii?Q?on0PAoleE/A5q3azQiak1QKkO9dTX3+DBhiaa2sGlErCJS8UmlhAmrxz9V9X?=
 =?us-ascii?Q?o+0fPlj5gynsT9uuNfusECXg/QIOU4kj3fqvL+vFtJXfnu4Im/5XzuzFWuyH?=
 =?us-ascii?Q?iEneVuCHhpW8/ciP5ZLA/N7p7JBixFdFdHUsSenQb00LnyQfGl//IppySqY4?=
 =?us-ascii?Q?/69Ua1MJA5UQx3XYGF0NVNWSUdsuDGjj/mrUUVqQIe/K4LwdJ0SsESZFYwCF?=
 =?us-ascii?Q?6Z8CWpT5+ov+iMu0tvwu5dz65py7PT4eXNsRDe4t7rGHpoYU9W0he/dEOh+E?=
 =?us-ascii?Q?FGX5StvWzzWUrX/owdb2yKzo2iI9ezQSIynC8WU6vKNakYs6cMRc3urlK+BZ?=
 =?us-ascii?Q?xAUBYhUgqfMTYizaDXQEMhxnbn3mWuDuZEKe0gGxmybA/J3/PBjKQ5V9FciU?=
 =?us-ascii?Q?4Ebs8nVxPhnTutKJMu1Vm2Pb4s4GT2oOAOxracoHrJ3yuYz8Ku4z5YjQnWvm?=
 =?us-ascii?Q?ggKc9sCNWaXDUp2RPY3ng/7j7hyRzIeDzqpfVIp94M3Zv0jVE+y6wEPOcn1v?=
 =?us-ascii?Q?GXG/EYDF2Ywq69UlHj1psdmbLpTE7u2dqGcnLm8DCv8qslNYVFLPc5xSVNnD?=
 =?us-ascii?Q?hAdHbcD8AjltlNPeMRDftklZYm2wvZwyvqHL7NHDn9UmUkhO00JWk2WdFFNY?=
 =?us-ascii?Q?fw+9Am6Qj4xGjX1zrTZm9meT2/vV0A6bJG8syqE0nYmxL3QWJRgWmIcwPEzX?=
 =?us-ascii?Q?rN7ZFFbIZImrmWXXcLj6rs6swiJzeGSa8+0idN3CutPTHBOGPnM9OW+mM9I4?=
 =?us-ascii?Q?fcIzBP8S8K+p1P5YGmFv0tFqwxhEnFGjeSyuEtqZs16b9X6pEXw8jKTg2yGG?=
 =?us-ascii?Q?tIEgE3A6KrqW4QnbEoFs2zWVaD4HrBWV+y9rnvsilj+pW45oP3dIWBbZaczt?=
 =?us-ascii?Q?Qw50bKC82UXxxF132HHTzWApXX1NKPLDZ+knwPhsQ7fsKehQFWd+wix16A4X?=
 =?us-ascii?Q?BVN14gDUCfEvaoAcd7IQbbD9aka/7bwjAcfxQU9DbLCMMaHvHP0G3Ofx6834?=
 =?us-ascii?Q?XD9UcCTP0T+7mPmjpshtOmIG6lNbKuVoWit0YBWXh5/3CUrav0nj/Jq879UQ?=
 =?us-ascii?Q?xdGaNOZ7EIG0Iyim4yjNWzOeXcIURBMqAxrwtt+42x/SPOyMrvfQlSaZsPkf?=
 =?us-ascii?Q?a0tEa7wZ4iw/dAoEg87ZwyaqzmPC/2kOBlLHdF/iWCKQKQ/8ApLlxac23C8p?=
 =?us-ascii?Q?eWnJZ5Upun1Irr72X8O6pxqMV1CWi5z1eBR6mbtqkHCPGpO8UPutnXtOdGxF?=
 =?us-ascii?Q?sgKD0WhxWyw2XacOqCa4loXD?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9993f42b-7cb2-4fa8-be1a-08d955bf21b6
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 14:09:24.3539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vs9ExKQd+I958RsGbS4p+0r4bWBgJmF/p7QyQVBiT9oWoPvpvtTT3/vM/2ziSkgxtn2zXPRkushYzq2482twR/YMttkdSncIBD+X4KqyMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0306
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

