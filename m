Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A291BA5FC
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgD0ONN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:13:13 -0400
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:27559
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbgD0ONM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 10:13:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzczKCbdsgMGvn0GBP5cKib8NeokEPWZZwMb1X4BHWVMfB1kxeFCdMkzwqmvBezbhjfRARuX9cqkBpALRjW0v4QwfY9U/ReH9uxyi00uv+Zh0UDoeSckvF1k1Xrd78x98OqdSIvXdJzA9TAuBra9dHOZ5gMUuKlEz6H2pehmvdkwQrVwQM+b6CFYbXimicL8V5EAs3FquLeLn7THNLtigh/1rTLope1oNY++1ICkmMHCAvArcVqgthJGXYDhCHirAUfWmzeDatsrUknCyCfLlCClYINqZN+2XeE1gNrI2auRY74T+MZeMyK+9YbnfAoELGt1j/anQgwJOiIpDhSLnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lnu5H78pgHKBUPNPIbTgqTSCENLDPgujBT5Gr70T5bM=;
 b=Xxk+jBlwFlCfUkJpHu1qeCC1ddxO+mb+8U1IUvIsm3ydfxejVEUzbnTQQm/tnDRGG9KDnCeogYDrBCQZlkQzI5ylHgOpDJDDn/tMUbpHNR8qSQcJMjPJSh7HKQntWtBpK5Wq4mKYyFDRUnUdPgV8t8CyUCAnWq4rTkHCWf+rMkToGKhribO6je+BZhim0hwaqFMV1A20WZvJeh/GTrB+G4wskD7D14uKJKXB5Lt02zKxGXVCp5JlP5DLGhqCDUnEy7z/enRM4RP442FB/RgpenicjNAtdzSme2d2OjN0yghzC2VqFzzXwe06tCSKQ5AnG8IK5xDUxi58U7AXnbywlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lnu5H78pgHKBUPNPIbTgqTSCENLDPgujBT5Gr70T5bM=;
 b=OhzhpnQMTPr/fmjgtwOhOUDr7gvnjszXGeeliyuwQwTMYHWSVL0BWjMx7chjw89Gf/7gEmOB+AC2KI0s+lkH+Ftg0I8RMvkakarg4+ZdbTj5x0ZNLAKAB+g06Iz/nxCx1YwqPhGsMDMwSanZ8Ms9aThlvDmmBeAYShsWvcxxB7U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB3467.eurprd04.prod.outlook.com (2603:10a6:7:87::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 14:13:07 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.020; Mon, 27 Apr
 2020 14:13:07 +0000
From:   Fugang Duan <fugang.duan@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, cphealy@gmail.com,
        martin.fuzzey@flowbird.group, fugang.duan@nxp.com
Subject: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
Date:   Mon, 27 Apr 2020 22:08:04 +0800
Message-Id: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0601CA0024.apcprd06.prod.outlook.com (2603:1096:3::34)
 To HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR0601CA0024.apcprd06.prod.outlook.com (2603:1096:3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 14:13:05 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1a223133-f46e-4e00-ff34-08d7eab51ba0
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3467:|HE1PR0402MB3467:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0402MB3467D48E715D565B75D3BF29FFAF0@HE1PR0402MB3467.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(86362001)(52116002)(4326008)(316002)(66946007)(2906002)(66556008)(66476007)(36756003)(6512007)(6506007)(6486002)(478600001)(8676002)(5660300002)(6916009)(16526019)(26005)(2616005)(956004)(8936002)(44832011)(186003)(81156014)(101420200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g3ju3BdLOXMZmrltAdDsX2voa4L60exhWNk+I++ehx/abbVMi9yFM4WW2wtoViq6VS7OaCxLdhtjFjqefTm0OOivcgDj5J/quuGEAAtMWcKtj5qwObNiZb9W2BD4inKlyb/k0D3/O3ZOP9qkx4jLYV2U460Jtm6bOijHeF80npfg5HVU7y2iykWZ67JTGYR1+NQ2J3UbWhZVwjI5YKdemdEqA0frGGhjctaHnKMgR8DEhsb2VJQ0czqXmwCHKD0PND1vJyFCsM7XZEpQdhu1sWNvkWHQ/YYTl6yygSP/BUZW/Bwl3u5dEwYcd9OuOklBBugUX/I9CFPaoPkRyXmfTsC/LpIZEEwotsiV2nhKDp/Jjm8d6kgy9HHuwkH6eyy5Y6Coyo3wbhBaWtXw2KdBn356HOl7O9Rhvq4d/TmkkI0gVbsTkPXD0U8vrzUvuoBBkjG9+f13nAmnUGGNLXbQTfv4LMjj1Mlihu+tzne1K0eHCCqm1Xht2xJc+4Q2//Ri
X-MS-Exchange-AntiSpam-MessageData: KzO06Jx4OQqjUp9WSUlDBZjvgHyw/1oYq6C7SMeOhSyfgIqdWIvzLNQqniaeukHVc7eBUcXFvKdBKaaAWN2qYpGblIPxQGBGRWhKoAlGeyibdqWOFTpV86LwFZBH+nYG2ew7yV9n+0rrXFF7/oyiQuYUVUcjTA4M4YzJntJN3ljJFr/7FfZT6WBsLnN0dSieDejBTyQ88JYeM26thjJtMPn87AxBiYCqpfbEEKy0bqPpHCjddoJpz3NcgqwDbNye3nC1BaHgCRAvZombJeb7OLdYXB2m6WKM70dG7Cz5OlQSi7TNiDvpDw1Kj/pJzUrlUfGzXIRtx4ODpcDmAPKbhC94BE+bZze9T3JPZcbadT29dUIKHGtvdSp2yxUN8wf39kBFxkNkQq7HOOnD3C3+urFF2KUrZ+2UGiRpVM537aYhK6KJEN5H/pjP34ftGTVtxhGV6Knlg538QIkPHMUWlqvAJrp4Atprqpdg3mljNlTcK9n2BNq9cXV5BptMutEpPyzAroPWKxCeJmAz3xKeXV6RFyBVuLjkMxM8sytzNsyAvOhom+nsJTdKTGSEtum21UtLxGwluW8ht8/M4EuXR4nxY/dUbnAwRbqz8LiSCiHxs/00PfzlUZJf9TOlefiO3x4h65tIVjKXSTYzFUlUyZ8aAsH7wQk2t6xxVlN3XJ5fPWpqNGeLwWkVAXbive6JieLZvWduylrfUDW6Jcl5GQSSnDCaOyp9B/NC0pEOtKI8bMZeIPJjj8dEWMwIEOBrWKTIiUsSw8iGC5dV/FjralIVCm1FQ/dZb3G9XkcyDo4=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a223133-f46e-4e00-ff34-08d7eab51ba0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 14:13:07.3858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HwHMx2XugUU5d3ehv2vanE3AcWGfDW+WErnMQwPmXrLU6Gbf5o/38yJz4xoj7XMdBwwaNejDIOX2oouYjYDIpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3467
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.

The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
rootfs will be failed with the commit.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index a6cdd5b..e74dd1f 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -376,7 +376,8 @@ struct bufdesc_ex {
 #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
 #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
 
-#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
+#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF | FEC_ENET_MII)
+#define FEC_NAPI_IMASK	FEC_ENET_MII
 #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))
 
 /* ENET interrupt coalescing macro define */
@@ -542,6 +543,7 @@ struct fec_enet_private {
 	int	link;
 	int	full_duplex;
 	int	speed;
+	struct	completion mdio_done;
 	int	irq[FEC_IRQ_NUM];
 	bool	bufdesc_ex;
 	int	pause_flag;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 1ae075a..c7b84bb 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -976,8 +976,8 @@ fec_restart(struct net_device *ndev)
 	writel((__force u32)cpu_to_be32(temp_mac[1]),
 	       fep->hwp + FEC_ADDR_HIGH);
 
-	/* Clear any outstanding interrupt, except MDIO. */
-	writel((0xffffffff & ~FEC_ENET_MII), fep->hwp + FEC_IEVENT);
+	/* Clear any outstanding interrupt. */
+	writel(0xffffffff, fep->hwp + FEC_IEVENT);
 
 	fec_enet_bd_init(ndev);
 
@@ -1123,7 +1123,7 @@ fec_restart(struct net_device *ndev)
 	if (fep->link)
 		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 	else
-		writel(0, fep->hwp + FEC_IMASK);
+		writel(FEC_ENET_MII, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
 	fec_enet_itr_coal_init(ndev);
@@ -1652,10 +1652,6 @@ fec_enet_interrupt(int irq, void *dev_id)
 	irqreturn_t ret = IRQ_NONE;
 
 	int_events = readl(fep->hwp + FEC_IEVENT);
-
-	/* Don't clear MDIO events, we poll for those */
-	int_events &= ~FEC_ENET_MII;
-
 	writel(int_events, fep->hwp + FEC_IEVENT);
 	fec_enet_collect_events(fep, int_events);
 
@@ -1663,12 +1659,16 @@ fec_enet_interrupt(int irq, void *dev_id)
 		ret = IRQ_HANDLED;
 
 		if (napi_schedule_prep(&fep->napi)) {
-			/* Disable interrupts */
-			writel(0, fep->hwp + FEC_IMASK);
+			/* Disable the NAPI interrupts */
+			writel(FEC_NAPI_IMASK, fep->hwp + FEC_IMASK);
 			__napi_schedule(&fep->napi);
 		}
 	}
 
+	if (int_events & FEC_ENET_MII) {
+		ret = IRQ_HANDLED;
+		complete(&fep->mdio_done);
+	}
 	return ret;
 }
 
@@ -1818,24 +1818,11 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 		phy_print_status(phy_dev);
 }
 
-static int fec_enet_mdio_wait(struct fec_enet_private *fep)
-{
-	uint ievent;
-	int ret;
-
-	ret = readl_poll_timeout_atomic(fep->hwp + FEC_IEVENT, ievent,
-					ievent & FEC_ENET_MII, 2, 30000);
-
-	if (!ret)
-		writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
-
-	return ret;
-}
-
 static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 {
 	struct fec_enet_private *fep = bus->priv;
 	struct device *dev = &fep->pdev->dev;
+	unsigned long time_left;
 	int ret = 0, frame_start, frame_addr, frame_op;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
@@ -1843,6 +1830,8 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (ret < 0)
 		return ret;
 
+	reinit_completion(&fep->mdio_done);
+
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
 
@@ -1854,9 +1843,11 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 		       fep->hwp + FEC_MII_DATA);
 
 		/* wait for end of transfer */
-		ret = fec_enet_mdio_wait(fep);
-		if (ret) {
+		time_left = wait_for_completion_timeout(&fep->mdio_done,
+				usecs_to_jiffies(FEC_MII_TIMEOUT));
+		if (time_left == 0) {
 			netdev_err(fep->netdev, "MDIO address write timeout\n");
+			ret = -ETIMEDOUT;
 			goto out;
 		}
 
@@ -1875,9 +1866,11 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
 
 	/* wait for end of transfer */
-	ret = fec_enet_mdio_wait(fep);
-	if (ret) {
+	time_left = wait_for_completion_timeout(&fep->mdio_done,
+			usecs_to_jiffies(FEC_MII_TIMEOUT));
+	if (time_left == 0) {
 		netdev_err(fep->netdev, "MDIO read timeout\n");
+		ret = -ETIMEDOUT;
 		goto out;
 	}
 
@@ -1895,6 +1888,7 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 {
 	struct fec_enet_private *fep = bus->priv;
 	struct device *dev = &fep->pdev->dev;
+	unsigned long time_left;
 	int ret, frame_start, frame_addr;
 	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
@@ -1904,6 +1898,8 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	else
 		ret = 0;
 
+	reinit_completion(&fep->mdio_done);
+
 	if (is_c45) {
 		frame_start = FEC_MMFR_ST_C45;
 
@@ -1915,9 +1911,11 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 		       fep->hwp + FEC_MII_DATA);
 
 		/* wait for end of transfer */
-		ret = fec_enet_mdio_wait(fep);
-		if (ret) {
+		time_left = wait_for_completion_timeout(&fep->mdio_done,
+			usecs_to_jiffies(FEC_MII_TIMEOUT));
+		if (time_left == 0) {
 			netdev_err(fep->netdev, "MDIO address write timeout\n");
+			ret = -ETIMEDOUT;
 			goto out;
 		}
 	} else {
@@ -1933,9 +1931,12 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 		fep->hwp + FEC_MII_DATA);
 
 	/* wait for end of transfer */
-	ret = fec_enet_mdio_wait(fep);
-	if (ret)
+	time_left = wait_for_completion_timeout(&fep->mdio_done,
+			usecs_to_jiffies(FEC_MII_TIMEOUT));
+	if (time_left == 0) {
 		netdev_err(fep->netdev, "MDIO write timeout\n");
+		ret  = -ETIMEDOUT;
+	}
 
 out:
 	pm_runtime_mark_last_busy(dev);
@@ -2144,9 +2145,6 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
-	/* Clear any pending transaction complete indication */
-	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
-
 	fep->mii_bus = mdiobus_alloc();
 	if (fep->mii_bus == NULL) {
 		err = -ENOMEM;
@@ -3688,6 +3686,7 @@ fec_probe(struct platform_device *pdev)
 		fep->irq[i] = irq;
 	}
 
+	init_completion(&fep->mdio_done);
 	ret = fec_enet_mii_init(pdev);
 	if (ret)
 		goto failed_mii_init;
-- 
2.7.4

