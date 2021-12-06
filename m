Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4963146933A
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 11:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhLFKR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 05:17:27 -0500
Received: from mail-zr0che01on2133.outbound.protection.outlook.com ([40.107.24.133]:8033
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232885AbhLFKRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 05:17:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZ8ftWdIVu2ILCsULKYHkB9cFqk99MYZ+KjbiF24qz+br5ZGXRy4oEFoori4SLnGUzEdtH8x4lCuqr44MaFA8lvhLvc2BJLsSOVcVE2ktw97lxzUVRMrDw7U/BYOelUxCd1LnMJxUkcx46NheBsnRpPy7g2ZdPMUR6Nirze0QajB4mRwRHG/nijrzFzyOa75n0zYadXYgP7C4LhWo7IzLoHAOMegyJM32bUWF7uYmCa33ADlsF+Bpwvjq9I6VVR7IGCOgIDrrHJnJimbVar6i4bmNoSHnoQo9AOB1QkaSZZ13dLgJYSVk9fTaeSYv2NbbHrARodOEy1DA0GzJc0wfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+irxxapgyAdUzTjT30xR4zk5SBor4MMHOghpyk5E3k=;
 b=D2FMzth3OnAw/l7Kpvx7u9J+poRReqkSBT5tYY8lz2103CuAsTFxgET2XEi28YiLxplBnYTd8pjFpx4Iurb6Ng2qFvv9LFYujYyE9Yq8rI77qNuzBB0l4PERNZ6Oo4PjUFwgfGyKh32eTkaimSXdEf/xJdrnz8J/p1tv1tPbz+FyoGDQypJJlDx2AC9YEMehJYsxStyqsF0W+1f7F8tAznhbS1JUGFiVzeDHoWAKOQizlqOyh6frpIxXVdr2Eo2QWEFpWUBEjtbBCxCrYn4lHjzFwVGWh15ZNk6yYOcSqCb1yu7mN3I1B0aGHNGLzdBVBiAl/HtbkoXOBn8e9Te+bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+irxxapgyAdUzTjT30xR4zk5SBor4MMHOghpyk5E3k=;
 b=r6LTDTYiz1a0TWkpmz/P25tw5pIqXAxIJ/sPoEHf/liK9+Yy4p1yJW5FtEUGiuJ9lwlhizhiRfF5UHtGPYD76Tz90VntvORhtpTc9/CgOSNRwDkH9hk4EYQSwtQrELrjlrfGf0+x7R0sTHUazc7K7+S6URCiHH6B936MfmqeVjg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZRAP278MB0206.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Mon, 6 Dec
 2021 10:13:53 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%9]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 10:13:53 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] net: fec: make fec_reset_phy not only usable once
Date:   Mon,  6 Dec 2021 11:13:25 +0100
Message-Id: <20211206101326.1022527-2-philippe.schenker@toradex.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211206101326.1022527-1-philippe.schenker@toradex.com>
References: <20211206101326.1022527-1-philippe.schenker@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0183.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::13) To ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:34::14)
MIME-Version: 1.0
Received: from philippe-pc.toradex.int (31.10.206.124) by ZR0P278CA0183.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Mon, 6 Dec 2021 10:13:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 437b888b-9efd-4a74-59d4-08d9b8a11abf
X-MS-TrafficTypeDiagnostic: ZRAP278MB0206:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB02068BAB1FDF00ABFF5BC98CF46D9@ZRAP278MB0206.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZjdJBLMBq0hwsAaHf83znpf+Mxr7E92G8vXN+z0aMvwTn1Zb4R/83BgV85WZibUyCroiJgIVnPHc5W+HW89PHfsX7Iiu8CHEL0ta3BH+ItTKY4xNFn3C4NWKUc0l2ZorqXM7bOgj1dq6W8vaUMAyzumNvY5LCQ/hp2L0FCJ1VpCgcojexuDANbGLkwXQBHzdI1KRmRLzarqp4bgJNjBMT8M5xGJMrCdRbkrhZ7ZLBbGkS2ndlHfUKPFs0xoGjubqear4Q6LJwK48m3yucezEdy75aSkfZkVE8AzmN8Jp5rs9SRnJlpy8dbbMFe1FRnQzIbKKRMVAoMRaSRlXymSM2Wf+hQg6TPgNGfH0FPRBssQdz/zrMyo+K7BFeu9T+L2ITPiMmnAWXmUWlHUvJw1UTGuNxw+YuNGKkIMNGB7VgvrvO1LrwM/D5s9rhGF2PYzARtJVTq8jVEN8f7Cxzluq5usbkNAFD+z+eLjtZqQu5RD0mDDJEmySSQv0MZFSSQ8DxUGpinEZBW4ClKJWXttJBZkcX12+8yGcZTdmwMD5ol/61sExBKgZ2JIZ8RynanuFCIDKXU2+o8U5IDfptXwsUzZ9tu9GBs68RPeUQMoV6a9F07UfCY1m1Qy9y8hRlN6veEzD88J/oFzxpewpcGShTzsbiImYk8Vf6VKhxKC648qacMwRp5mDv9JCk3qtoQzruSVcUF6kYvG7GczgsATDRjpl07MJpICeFs+fSylgAM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(83380400001)(2616005)(66946007)(1076003)(86362001)(36756003)(2906002)(26005)(44832011)(956004)(6666004)(6512007)(66476007)(66556008)(4326008)(8676002)(6486002)(110136005)(508600001)(316002)(186003)(6506007)(5660300002)(38100700002)(8936002)(52116002)(38350700002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g9olbxBYL3L/nLFnh9XXUHrwxkXLCkggstr8uGdxbII+o7oOKmM/zGlcah0t?=
 =?us-ascii?Q?RpVQDvlsIrrTXQC6E+zxcZTXGAxPY3FjJHgwNgejsPcRFyayMiCdexGNO99e?=
 =?us-ascii?Q?o4JwvM6WFebVuWjm1jaO8tdWPAOCHvFq5jG6iEZw5V7G3PccIwTxmwXSXzmy?=
 =?us-ascii?Q?kNeqnzD+WgWirI+i2qYwKth1kCkoavYapMqfYcIOAqwZx5IIivs1UoYlcCGO?=
 =?us-ascii?Q?OQakHyBGjTq5fLSVHLtWYlU5BaHH07kvJF98m31FkCD/sZVizZApA+MEVFo9?=
 =?us-ascii?Q?s7B/qBZoOoISqb/zKCSba59eLdnv/p/lyU3fSMRQUlkL4jVQ7B1CdFU9xQsC?=
 =?us-ascii?Q?+xH/Z8ROqoHFeDOGjK1iidETVn+eNwu1OYIbhyyN7r+tqvGujo8nW775R84M?=
 =?us-ascii?Q?Rwb8g2gAGf7Vv4/02H5cr/1AQDlGBNgaT2y9x6sNSm7gAYnhDNRpcw7GcmjV?=
 =?us-ascii?Q?U/uPKtHkwX9yVdfzNBVDPADX4+5tDh1bJkyoYSdFg6ue9MD/liIcWvLB39kE?=
 =?us-ascii?Q?8W0Pe+QQbaf+HRi/7GvDg/9QQV6lVdzP5CzaUpzkUVsQC2x/QjTsxd9tEmxD?=
 =?us-ascii?Q?mQmeO9kV7LlgfFxqXZVC5noivZOpqX+72n8GjBeM6qyUKqIC37kY2BS1KuNM?=
 =?us-ascii?Q?Ktkx29RUtNu37xzMPvm74FRHYA6O9IJdNS5cPSfCCunnfJ4PDqDH3B9ERHox?=
 =?us-ascii?Q?jzcj2ugE7wfIYWBabq2Wcuf/l5viJuoekv6Wcgu20od3+hURTc4O3fC8TP5n?=
 =?us-ascii?Q?DsLKhrfvZ6lJvC5DjuYhybGwQggm0UuHQZIjJwyHt1frs3Gy2v4lUOwXPito?=
 =?us-ascii?Q?5lPIXfwgk073s/5dzpCCLJOAQVxk0Hw84PEvHAtc1+bxf/cxa5A6zmFKhJdh?=
 =?us-ascii?Q?YaSus8LoPkamt4l3cyzZ481kHrFe3CpVFKNC+CWBvGDrrV+AoZvxBlhF5hKz?=
 =?us-ascii?Q?E4Vlo4S81WHSKVQ2C4Elo4ZWqRzArFvgtoNXr72ZaUnKeGn17CFV/L9hejN6?=
 =?us-ascii?Q?O7hJM5pAthPkHAWo6gfv79odN42eCKm8nZIV5jLOIYBOix0yHLTFPeZm4pGT?=
 =?us-ascii?Q?stVVkwmW8RFRTZVARUJDUD/wA7dpp2JjyOOMOaHetelkrR0uJFjKbeQ6HcsL?=
 =?us-ascii?Q?9u/FMU1ijYWwXirTlT+aUiziCWeXJvExn7xzqLA50Zh1MSPzr3V8eutfJtBy?=
 =?us-ascii?Q?QENbCcHlPPFzBHpd2T7ScS7vucN9pADK5v8kHh/hvpHYoKCrC7/f5H+wawUz?=
 =?us-ascii?Q?c9Flu39vCEu7mfheKUiF7cIepGWdyfRo6TUvW85RDZOeYaiD8q58XrV+U1Hp?=
 =?us-ascii?Q?oY9dwlA3fdzpDz5vUmT9DWjHzbMGBjYVxops5rYH1CwCdFjQL8kNeRXgZLvb?=
 =?us-ascii?Q?cpXdJrJ/fcwsRIiJ8RX/G4tVKsOTbyT3TqhJvLl9DTia1uioTeUN/lKnOwIE?=
 =?us-ascii?Q?M4OYAQkHL20mcPgHI8weeAEzsyybnmTSLa2J5S7G1710lNznLzgu7cfIOBF5?=
 =?us-ascii?Q?HM+xcn5QpSq7OU23kwbqT+DCXge9r4cC8lf6dsgDsvxqH6Jow5OXQIG2t2He?=
 =?us-ascii?Q?iDGPvcy8quw3rC0hq6ExNsESFebsOJ/f53Yx5mDUsfiRFcPCWaFNrdVpbAH/?=
 =?us-ascii?Q?TYKarBqP+e7fGrL4xabWKp0MxSLtWvvssrpPqLlNF7NMCy8DXWEe3/T54Eap?=
 =?us-ascii?Q?5KqBig=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 437b888b-9efd-4a74-59d4-08d9b8a11abf
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 10:13:52.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12Oivof6pY4Rh3GT9vUTl4azPOqTtfyu3wM7V8N8+WIxK/6MjyAij65HDwEPO43FFzllFgGTOIs5tcvsckBThZmVsFIPxGMf2ijBWtXSXPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

inside fec_reset_phy devm_gpio_request_once is called hence making
the function only callable once as the gpio is not stored somewhere nor
freed at the end.

Create a new function to collect the data around phy-reset-gpio from
devicetree and store it in fec_enet_private. Make fec_reset_phy use
the data stored in fec_enet_private, so this function can be called
multiple times.

Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
---

 drivers/net/ethernet/freescale/fec.h      |  6 ++
 drivers/net/ethernet/freescale/fec_main.c | 94 +++++++++++++++--------
 2 files changed, 69 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 7b4961daa254..466607bbf9cf 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -631,6 +631,12 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
+	/* PHY reset signal */
+	bool phy_reset_active_high;
+	int phy_reset_duration;
+	int phy_reset_gpio;
+	int phy_reset_post_delay;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bc418b910999..92840f18c48f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3588,62 +3588,90 @@ static int fec_enet_init(struct net_device *ndev)
 }
 
 #ifdef CONFIG_OF
-static int fec_reset_phy(struct platform_device *pdev)
+static int fec_reset_phy_probe(struct platform_device *pdev,
+			       struct net_device *ndev)
 {
-	int err, phy_reset;
-	bool active_high = false;
-	int msec = 1, phy_post_delay = 0;
 	struct device_node *np = pdev->dev.of_node;
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	int tmp, ret;
 
 	if (!np)
 		return 0;
 
-	err = of_property_read_u32(np, "phy-reset-duration", &msec);
+	tmp = 1;
+	ret = of_property_read_u32(np, "phy-reset-duration", &tmp);
 	/* A sane reset duration should not be longer than 1s */
-	if (!err && msec > 1000)
-		msec = 1;
+	if (!ret && tmp > 1000)
+		tmp = 1;
+
+	fep->phy_reset_duration = tmp;
 
-	phy_reset = of_get_named_gpio(np, "phy-reset-gpios", 0);
-	if (phy_reset == -EPROBE_DEFER)
-		return phy_reset;
-	else if (!gpio_is_valid(phy_reset))
+	tmp = of_get_named_gpio(np, "phy-reset-gpios", 0);
+	if (tmp == -EPROBE_DEFER)
+		return tmp;
+	else if (!gpio_is_valid(tmp))
 		return 0;
 
-	err = of_property_read_u32(np, "phy-reset-post-delay", &phy_post_delay);
+	fep->phy_reset_gpio = tmp;
+
+	tmp = 0;
+	ret = of_property_read_u32(np, "phy-reset-post-delay", &tmp);
 	/* valid reset duration should be less than 1s */
-	if (!err && phy_post_delay > 1000)
+	if (!ret && tmp > 1000)
 		return -EINVAL;
 
-	active_high = of_property_read_bool(np, "phy-reset-active-high");
+	fep->phy_reset_post_delay = tmp;
 
-	err = devm_gpio_request_one(&pdev->dev, phy_reset,
-			active_high ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
-			"phy-reset");
-	if (err) {
-		dev_err(&pdev->dev, "failed to get phy-reset-gpios: %d\n", err);
-		return err;
+	fep->phy_reset_active_high =
+		of_property_read_bool(np, "phy-reset-active-high");
+
+	ret = devm_gpio_request_one(&pdev->dev, fep->phy_reset_gpio,
+				    fep->phy_reset_active_high ?
+				    GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
+				    "phy-reset");
+	if (ret) {
+		dev_err(&pdev->dev, "failed to get phy-reset-gpios: %d\n", ret);
+		return ret;
 	}
 
-	if (msec > 20)
-		msleep(msec);
+	return 0;
+}
+
+static int fec_reset_phy(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	gpio_set_value_cansleep(fep->phy_reset_gpio,
+				fep->phy_reset_active_high);
+
+	if (fep->phy_reset_duration > 20)
+		msleep(fep->phy_reset_duration);
 	else
-		usleep_range(msec * 1000, msec * 1000 + 1000);
+		usleep_range(fep->phy_reset_duration * 1000,
+			     fep->phy_reset_duration * 1000 + 1000);
 
-	gpio_set_value_cansleep(phy_reset, !active_high);
+	gpio_set_value_cansleep(fep->phy_reset_gpio,
+				!fep->phy_reset_active_high);
 
-	if (!phy_post_delay)
+	if (!fep->phy_reset_post_delay)
 		return 0;
 
-	if (phy_post_delay > 20)
-		msleep(phy_post_delay);
+	if (fep->phy_reset_post_delay > 20)
+		msleep(fep->phy_reset_post_delay);
 	else
-		usleep_range(phy_post_delay * 1000,
-			     phy_post_delay * 1000 + 1000);
+		usleep_range(fep->phy_reset_post_delay * 1000,
+			     fep->phy_reset_post_delay * 1000 + 1000);
 
 	return 0;
 }
 #else /* CONFIG_OF */
-static int fec_reset_phy(struct platform_device *pdev)
+static int fec_reset_phy_probe(struct platform_device *pdev,
+			       struct net_device *ndev)
+{
+	return 0;
+}
+
+static int fec_reset_phy(struct net_device *ndev)
 {
 	/*
 	 * In case of platform probe, the reset has been done
@@ -3918,7 +3946,11 @@ fec_probe(struct platform_device *pdev)
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = fec_reset_phy(pdev);
+	ret = fec_reset_phy_probe(pdev, ndev);
+	if (ret)
+		goto failed_reset;
+
+	ret = fec_reset_phy(ndev);
 	if (ret)
 		goto failed_reset;
 
-- 
2.34.0

