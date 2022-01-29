Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DEA4A323B
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353383AbiA2WC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:02:58 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353315AbiA2WCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RG3DW8U+hmkwnSybdoBuB16f+QiGiJX2g3dJS+uVnFUl2i4+qR3BzDj9pr/FHF2D96XLaW9tW86xgFShngzoSDo8dJQEiqSRC9FeRz8WpaQUc9PNrG4wSZWlX4NbjQzMBROZpJx6nbb36VjAtlaCXc9JEcQ9gYCRWwE9G9BlKte/84vJdjhYY49EIxGVBCM6I5LCQKn7a+fydBZlW4MsvobOMg8ri+5xIi97n6TdUinUvSsLcfEgpUwJ8CdBIJLO18Op+VZbcAXiq1pC7CfLv/lYGFBjGjrWLOrMh96RzBkQ1CaSm6WqHyPKvwCeeaKzFc4UYdHWgEeg/QkSDB4SlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiYSJxZF296PGKTY46nxIbaKb8v4eef04ouD3VD8xPM=;
 b=FR0QpEhWibTVBVAG7zEsi1ho8Cgd1ATiBcyQ63hfN8mlJAYzUqxcM76pN6KVNYZHx1QKXTA/uhtu/iUR8PFm2AOZVx18oIqULw+A7Pwz73/CTsIZ5NF1Y7juPLmeGhnU6cD2DSFZwvgNi5ThuBgOpA7P9xECzxpnKtLF4JHKH/sUxJ5sjk0jVx8JM2K0qXuJyoF+U5BG9c/aA4ftXOQXodG2DnjUi5+LeyteVzJre0sesWLUdjO/EGzHtS3qh6Nz/NCzQv6HUBz96uGihwtBao/hkaH9pBYac0DteGZx1UV8bG6DI5Hg7NIi2WFrIthHqyvQ9f4EgYrqyfMRyOIKJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aiYSJxZF296PGKTY46nxIbaKb8v4eef04ouD3VD8xPM=;
 b=Js9Oy1eeJzfG0ERYck3Vs50NffhZoVjJqbnB3nhjj4avit1V+272d9M2QdgLYann3/tSlqMQZYFuviKNfAGDHcF7wAbYuoOVJCin7tfZquwd/ZZpUKbnEdoHSJteir91MatPAd3BZaKI2mOOYeb2Nh9CeApgIQYX/hPBayeJYoU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:44 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v6 net-next 7/9] net: mscc: ocelot: expose ocelot wm functions
Date:   Sat, 29 Jan 2022 14:02:19 -0800
Message-Id: <20220129220221.2823127-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220129220221.2823127-1-colin.foster@in-advantage.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43c83174-7fa9-408f-06b1-08d9e37313f2
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2968D8F238F3A1115580245CA4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 647ghaljNp8PxQuUonSpA9jDLl66UacaB/W9Or7ukhhxqsGO8qCvKRHTIusO/U1qJiqWJ/TRjovfNc+u/hoQ3muLbOAc9RQd5fxTHBOj/MOnQH9xxav+QA+Z7f6QDnNm0o7nBPxS4Rsj9tnaPfeIH6ptpjgGIXPh6S14kXrQBkHcJEdg/35+OGS2XR8gcZup/LE8hiLTFNsUxGbco7gSTjJw/wfMRVBsNKWeEci3HekL6alqa+Otcr1DJwdYto29MI12hoqfE0EVKp2d73H5tT4TvwNpjQOD8cXkZ7vvAgrfnhEBE28iJevkC/nC7XGPMfEJvzi/CadB5qkZHDnyiqWhBhqrvr71K8O7fRV5wFxJs87cX1XEwL37KjL2ivT74/Qa4KV/lA+oGrbdOw4Vb9ndH3yRVjvobJXQeL8LmoxWpDJamKmIEMiX0MhVyooUcqVvRDO9bUjAcBlkRfMVLOlxCPqVceH/Gz6q7l3zXpvo7gnXcT2kQ4dk4e5nMShAVwkgzHVz0aeTrIMu0+QvbKV8vcnLWQ1VEjm3N8P5KmF/LG2SdMGc1jTbsq/G+tdmfPO55vuS/iSkkSJdjU/xx/sIP9qU+HrKmm4+KcN7t7ZNGi5QgPzxN6ujpwsSpyoRbzHkH7NaTT9kLManeD+ZcF0LUWoAyZNcyIPks5b1dQH4GXp6bgjScHZFBGGuTkA9qz7c2yEG+iJhAFUI7ubROA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39830400003)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ywiPSI29HSbdU2UDuvbn4Egih1S+NBTJPW606IG1vH54nvk3opgIPsrXFDX?=
 =?us-ascii?Q?jFamFkfCEBvsQYPiddskvmvll+DlKkjSqaxSjU3Ramuog1gbiu5D0N1wGeoQ?=
 =?us-ascii?Q?mdjdbasoAMdbR/C1IMToPGH8KH5dZHe1RxW/4o0dVmvmzAckScKThZwAipRA?=
 =?us-ascii?Q?kUJkHM5X9FjZeyr2vDCK5c/NHuV6Yyg7iLtpdQAAPlj02YOcDlVfccydwkQ3?=
 =?us-ascii?Q?grmrq+STJWSrnNkSrqhHItppSPmSjvJQCVa2FQvIXmpeB75uERK2Cfyzl2gs?=
 =?us-ascii?Q?VuT3D/6M/VYdwetw0SrvuPDApIEtm42hg6HVr3DFI9m2z5OD8EIaWRYdXg1l?=
 =?us-ascii?Q?tAQagKhWYmmxgsbzYjN5MbHMZM7toYulY0laZ63vtFs1g7ODr50xyXt+oYPd?=
 =?us-ascii?Q?XPlyw7DY+8uZSnf0WJkHYZMrItuVyxT6HUd1lm+E0c3T0nMURgZMqz8qlDFP?=
 =?us-ascii?Q?Qihj2SBM9XtlMZr94PT7yeO7uH8DxSmHm20F67tx5m8i4K9ZZiRCUTR40sDg?=
 =?us-ascii?Q?/R9JuuyLKLMG1/BjGM0vNKbNTuW7kJo/IabBZHjTeSiVHWW9QwOHRHTSQHJ7?=
 =?us-ascii?Q?qdErk2AwtQc+x2RrUeQ6YTnauXBUHw8a8ja8SU46/9mgTjZe2HLmMOVg3vwp?=
 =?us-ascii?Q?Mt5/ZcMl0UpF/RW6poZu8sI6ZKS5NRxnPR52cJJSvBVUVOKnQ4CTNR7eaJld?=
 =?us-ascii?Q?pj4n+NfMXRc83BvsLJPOdN49rNY24RB2zAaBdJoocjaTj9Q2A9oD72dT6nrD?=
 =?us-ascii?Q?oSGZBA2OmpcaptEZyu3X7MKOqohmcCq4FiObF1LpCbSWZ64QUnQE4xKmBR0c?=
 =?us-ascii?Q?YCuW3GRF1h6txkZXktGNx6NxiWM+Eod7aNGLqF+Aq6X5pG8BXrnhTveXRdW9?=
 =?us-ascii?Q?AOxHX8LNdtJ4WqGn7C2RgTDvhEJtfb67064l+koXEN6tWi72yBBc0XC9QO2O?=
 =?us-ascii?Q?gojNJZWhyEGGWAN6aenxrt1/Gcjcgc7jDbFSXe5bRZFRkmXwgv3EViIZtIDj?=
 =?us-ascii?Q?yVeZnSh8ICzShHqmuBHgu5g27Ba1Pz99xWjfbIxUW57nn1aMuHcDPfRWhSGm?=
 =?us-ascii?Q?o9wPg4UDx1+8cIL2wK9rU6/KmZBXkt6CJmf7F0wZFzeWkmiMcJM8jeyCY7oz?=
 =?us-ascii?Q?a49/ARsXW2UmTPpFZHMjU+hes49OiOdxTSu34fZfUC9dH92DjlHZUJYJuWzZ?=
 =?us-ascii?Q?obhcNTLdYSeTGtbhMgoPGbw6MNai/3cNLBI10sdTDTrhLqPgrN7jueY/PvqF?=
 =?us-ascii?Q?OPZg/fJVqaF9ajPaJp3fj+xocML3erikLnf0d6d2JUpTBMIZeWtFUuwKOtHT?=
 =?us-ascii?Q?Ppasr9EtOESam/KOatFlpm+xThVHV6fc52fY7zXFehOq0FRh28N65Xr0GpbT?=
 =?us-ascii?Q?J/8rbQm4NmJNW4XUhicTDbG7n8AIIPKuTAhDVbDO5wOgGPjXl8mffjTB66Kf?=
 =?us-ascii?Q?hE3Ida3esrJcvRvwH+yogUC9e6n8jhaMRjYR7XsugJABaArfPBnomcgTkVjX?=
 =?us-ascii?Q?bvYbDz6W3j9wkydOsXSXAu/0ExkrQQw4jQ66us3rySrTWec5PqRgdPwyBY59?=
 =?us-ascii?Q?dLPeamjt08p4oTaqAf4TtCD4BMvZxbQWS2pSU1bOivd37uANCnEacq0vt7Cy?=
 =?us-ascii?Q?VQzT6SmLC01dgCt4+0SchhLgmknq1hmmRsMWc8RT87JvB1v3RpinzrvrNKXP?=
 =?us-ascii?Q?Dr1//Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c83174-7fa9-408f-06b1-08d9e37313f2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:44.6570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PgOkL0J5Wr5QaI+xDVbmZSt8eWMs2ucx/2dIw6GFwQVv9SxhJjn/gGaUmvOKshcfRwU+ZxON/nNdsT3g90rdsRySUQ6mDFyPR2kmSn+MhS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_devlink.c | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 -------------------
 include/soc/mscc/ocelot.h                  |  5 ++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index b8737efd2a85..d9ea75a14f2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -487,6 +487,37 @@ static void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_setup_sharing_watermarks(ocelot);
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
+
 /* Pool size and type are fixed up at runtime. Keeping this structure to
  * look up the cell size multipliers.
  */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4f4a495a60ad..5e526545ef67 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -307,34 +307,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 70fae9c8b649..8b8ebede5a01 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -812,6 +812,11 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1

