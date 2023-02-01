Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217C1686866
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjBAOgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjBAOgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:36:39 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2056.outbound.protection.outlook.com [40.92.52.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F3248A2F;
        Wed,  1 Feb 2023 06:36:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoWOYVCT0CEyjoZEu15OIfar8e2fHZjCCeVcYdnUGgzGh/ue+O253tQ20h55/ePgpiWJV0n/p98NH8HlaVsJlxIilKj5ki51xRdvHBafSoYa0lyLhCLZUhimpPbfxlAUiXHr0yw5FiAuJAJcjv1A0HbBNOLy5lWzsu7pJHaw2tpJcgn3V5wulFGBfeUN7ie+rOhC+gtENxHreouksdiup1eIqwJfRijMuvfv42vtVLcK7d/GDS1liFmN1BWvqHrOLJBHfLmpJGlUVAnKdq9OQ05myuSyMQq8+uTjK+jL0fWca1YQ1NWYWGRSajrwQm91i2SpTx+LK6KEhE5QcrI2Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYKupOZtwMuBbv41YyjxjqfNU6UW3v1R72omR9RD554=;
 b=nAj48hP1bEEWPw1aBxZc0SGyuvcxpHuG0D7g4RJfgZeYgm+XnJfetTYxFDxNImWFjEdGs6MRVgY7W/hMainBaWdRdTzlqKoGMziByrahiCAJoYpEkaCIRCt3mYYN+8m+SuuU0Owlib/bcM0Rhosfme6RYSxA3PzYBtso13p/debBHhcOwbliJDyriaa+ztw6kQKV8QJU1eLzuFTYQt0DAr9RS0Rpyo8yUDVx+nBiEzGpCMKapQOagshm1ikQZtIt2LOHYIaagTSHC7ErlIEIgU5aKMJZSdgjyO4IPYRUgHxMZHvYl4zpTfUnrJfI0ThFfwZdJZxVmHZpIBGAlObkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYKupOZtwMuBbv41YyjxjqfNU6UW3v1R72omR9RD554=;
 b=I3/mXpnVi5W+n4QmC3eXCEqRTGjRooZPp13nZ0IidU/wau8YAqAEiA8qt1ygjx1eQEM0974d8h6HnvdaUqA2JZmD+0sCSQPdk+4S6Nk9OwVex+GvFk6r4OosnZGFnwj/CvvSoUCHcTdZOgbSwoFCqpVo2Wz0iHlLZMpmrsjByJiZ8Av7b1uRNzOP7JlfnfK96pT9xFxiQ0iaS2pRTVqfe8onLvz2ug31dQDLv9h82ZmZgV0YT2b50gjtqDqa73XpHBiF7n4luWU83auwM7RANfqIQoCrfNh7SiRuwQp7sszJiqhjY0xs7ccNzS8ApbYpNUGty0KJal6Mg+tYoL4/JA==
Received: from TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::9)
 by TYCP286MB3130.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:291::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 14:36:33 +0000
Received: from TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
 ([fe80::82ce:8498:c0e9:4760]) by TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
 ([fe80::82ce:8498:c0e9:4760%3]) with mapi id 15.20.6064.022; Wed, 1 Feb 2023
 14:36:33 +0000
From:   Dawei Li <set_pte_at@outlook.com>
To:     mpe@ellerman.id.au
Cc:     npiggin@gmail.com, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org, linux-ide@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Dawei Li <set_pte_at@outlook.com>
Subject: [PATCH v3] powerpc: macio: Make remove callback of macio driver void returned
Date:   Wed,  1 Feb 2023 22:36:19 +0800
Message-ID: <TYCP286MB232391520CB471E7C8D6EA84CAD19@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [8UojfIz4u/aze2VEHss7+zSaaVuxS/0g]
X-ClientProxiedBy: TYCP301CA0001.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:386::19) To TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::9)
X-Microsoft-Original-Message-ID: <20230201143619.701881-1-set_pte_at@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2323:EE_|TYCP286MB3130:EE_
X-MS-Office365-Filtering-Correlation-Id: 766a21ba-685f-49d9-5934-08db0461b700
X-MS-Exchange-SLBlob-MailProps: mWtqiNqNgRtY1Ht/Jmetk2vy0uP0/BVTBEw8s21ZajGzyB8jX86wi0xYDafS97l1UkRpTY0fzADQ95+/3AXkO6dc+Qh21hyk+rh6dOspKghKSO/7E/c+0GV8HLfjLD9bCVprw1kx0f3aaxNfhPHSABnHJlP+BAlTd2mppxJPUCOzVaR80glhbDvZskyF8If3+NzdlTiErNiz/gsEObc0vEmhH0lPufM1RFB8RXoiTAnvszglKNmICugQ5UGaOqOGKZyXVrX5Wtr24XWyDi7w476wWhh0/QB2gThvLr/Q1yU+2hQO21FCSNh+k1DomwYrwvq6TiMAmUVvYXn4nw+30OssqmP1Pyo5t0ZZDberTSTbPxZNgIM447sURHJrNqC3VJr7RBlfjDNY6GZBbTQPFBCkYgvdVHCYbhvEXUJ39L8MU5C6tCl6E2aCgDjZVEIK0f77A3YjInRQoLtgswY54/uBlQ91SfiQOVri9OG9w0ecVcYZZf6ej2NX9ctuycpYjDKhy8EUsOnxbsQZFqirWqDhXbslrgSMEjDshcU3CYyVucsi+poyF9RSoWu0/UNqSRP9BbZgAgUTjQEkl2/5ihNwYNjeFE5EoXUdIY5X1QB/FOlSUrBbY5tg00Y2UulJ4DV93O81Pm80KKAsi2qZEbs+IJJglsrRUBuTInz4DMRfS6AyGCCARHYwgwWE0AZjR8Q1XminZoLSm9Yc2m1q5EGH/EVKoURHMf/xtXAQ7PhgQfKEExwmJHmTXPLC7LUm9x5KHtyiHIbtsMo+nRfHOvU7CB1RvuDWiP8NrQAWNAQ=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qd7YMtnzfHrYc1lSC1VBYhaXk2kR+Nyu1diuicGuRBtXjx18orUxJNQlBLMHD9WWS0f/4PDvMSv36tCYZaXbm2rs6c8Mprpefi5TXz3yWA60QdV7yasxYog7MK1RjkGwkrNH58eveSe3lPMLBBEQr5zGAli0szeK2L7LZsBPb7UAPaVNcZd+ZiR3/okw2tSuaA8jO7G2gE3gVARXE3OFrYSZPtzdkpuPqD6zsK5x12tNfNmb12dbX19SnzfPY74RDZ04e1AaL32+DgQ8o8PLO6dxphTk69i1U6zxos4j9yWt7u9nXhuaoRzlkCID+s/iLvL7zQ6zpjrz4EOV+rvF7W4GDq3SsoZEuyC5pTOQXJ7wAvhbyceY22KYyDzDOb+pBkdYrjJej0s9on1eeBIjLEqXoZuUgp4p5qPQsgDl9A5YlPK49mH0a+obRxZ3K0304QqOra6GjGtQh45CrCsPRXTqZ64bBlS7CL7bk7JCyyWW1SAegpGHPFKJLztZv+z4B1NVTwzQP73Z48rTrEEKnHUjQJeoo0Zg6EZPW85lg+vMli+EiAcdBU3ESZIR6DqHUGijRZnqWF8Z7OqR+Z4ASi2qNee8qNZvLnlbzf8VA9KaCDzzZA4TpddDJtmA7UfrNrm0kjqlC4WMf5BBWsg+jQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3LGcClyFMn4UGA1yT8QgY2qc9NtNQRRvborg4pM4ixtZfceBpPrX+WYokxTr?=
 =?us-ascii?Q?6s7Qa0oggg79bRd+NFmQ4CPDxMKN98bksUUVu9sm4nP13xYBiRvgUcaLy8Cr?=
 =?us-ascii?Q?1FmZpdRBXCIw0nWGgZpEYRaEQu/3ECTja8U1CNLFMJR+UMWKhouWzGB5c+LY?=
 =?us-ascii?Q?BTY7SgJAQECWi2CTiqqGKPEZRibCMKq/gFmt/Qfu1MqsdbTHyvUSg+BC5egd?=
 =?us-ascii?Q?n9HSZhtHOROopJqTy5wR8+MGN57x4SMiz/Qb6zOfQLqmtBmaGCT5MCwZkq9D?=
 =?us-ascii?Q?SpEIDcett2g434IYEdK/3vDVekmvtVCK9a/Qsr/Lw0WLpxteWrQqEd/lsMKi?=
 =?us-ascii?Q?47vRIdcKJgePE+mHvCsE+msm2zopCQkVhtJG3mpB/d/oiRdGerlQRYlZ8DO4?=
 =?us-ascii?Q?zLLsq5qiG6sUt5tjwpfc4ZuFFREz14Vj2ErrQ2+NnpSUqY+/1j5RU77COMbC?=
 =?us-ascii?Q?6BJRGEDoYKrRGtDiOwgCFvE17+a0jPusntbcOXZOrTA/0OOpfixOHwuUqlU1?=
 =?us-ascii?Q?qwjlGW4InyJl3oZrUI4vU/oeQNuHq+xtD8tSLieyPM9yw1epGQnqVByf6/nf?=
 =?us-ascii?Q?tw95G0m7KNREoauSUwfg/hsHZl8AvaNxXsAmIatEzKNgUW/BmrI/7wxgusJB?=
 =?us-ascii?Q?XmcZNT0X/k9qaqmpLKzlw0tNru0a9fVpRIg/baO5A5DHN6BKKXzbBPWIIEZv?=
 =?us-ascii?Q?Jat3JjE/OD0UDeCBcpR+GbIhc2yD+1DUO7V9jRTgATjZ0Xq4Dq2DIp0OL/vE?=
 =?us-ascii?Q?HeW5x13o0G5+rQEr1iZCIvySSLnZ226hjWzhP923KjgCqsFIgAGDNjibNuM6?=
 =?us-ascii?Q?XYN30ZRw5wpKAyxk0ZCtRcfjqLFkP0ZGKutDXxzN+O+WTdYJinXKdxmSBQ3J?=
 =?us-ascii?Q?zH5EBitBHihreLEiUaqNEH4b/Zrh6sAe4Y8/tnmWENzwrypy+u+14L8EhZox?=
 =?us-ascii?Q?F1ePO+V0V01fDsKDDBm7/6w0G3TuMV90UC3LBJmpbkzRfC8l81V+cPN1Sa80?=
 =?us-ascii?Q?oH3XkV3dh/IeaBf6qRTSKFMJv6LPaJG3uGNMBrUMaduz1qa+UFMpxpFiWqfI?=
 =?us-ascii?Q?ZaRBnXLCWKEHTHqZNxgOy3lMY8wA5CMN4Raln75Pgrs1TMZpIiQNXr61md1+?=
 =?us-ascii?Q?ot1w0rrsGKmVsiNG/OooJUe8khTcax3M5cK93jRNdWh877hKK8aPZyDCEZyB?=
 =?us-ascii?Q?+NjHEYQN6YlvE+cIADXcBZJ6guhzjGLv4ZQvwhtaPH1vs2afXGhtwRzkUtKX?=
 =?us-ascii?Q?zz/psie5Uqb9h0q0sKbSENQgaVNPb3GnnQARstqDKw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766a21ba-685f-49d9-5934-08db0461b700
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:36:33.5254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB3130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit fc7a6209d571 ("bus: Make remove callback return void") forces
bus_type::remove be void-returned, it doesn't make much sense for any
bus based driver implementing remove callbalk to return non-void to
its caller.

This change is for macio bus based drivers.

Signed-off-by: Dawei Li <set_pte_at@outlook.com>
---
v2 -> v3
- Rebased on latest powerpc/next.
- cc' to relevant subsysem lists.

v1 -> v2
- Revert unneeded changes.
- Rebased on latest powerpc/next.

v1
- https://lore.kernel.org/all/TYCP286MB2323FCDC7ECD87F8D97CB74BCA189@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM/
---
 arch/powerpc/include/asm/macio.h                | 2 +-
 drivers/ata/pata_macio.c                        | 4 +---
 drivers/macintosh/rack-meter.c                  | 4 +---
 drivers/net/ethernet/apple/bmac.c               | 4 +---
 drivers/net/ethernet/apple/mace.c               | 4 +---
 drivers/net/wireless/intersil/orinoco/airport.c | 4 +---
 drivers/scsi/mac53c94.c                         | 5 +----
 drivers/scsi/mesh.c                             | 5 +----
 drivers/tty/serial/pmac_zilog.c                 | 7 ++-----
 sound/aoa/soundbus/i2sbus/core.c                | 4 +---
 10 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/include/asm/macio.h b/arch/powerpc/include/asm/macio.h
index ff5fd82d9ff0..cb9c386dacf8 100644
--- a/arch/powerpc/include/asm/macio.h
+++ b/arch/powerpc/include/asm/macio.h
@@ -125,7 +125,7 @@ static inline struct pci_dev *macio_get_pci_dev(struct macio_dev *mdev)
 struct macio_driver
 {
 	int	(*probe)(struct macio_dev* dev, const struct of_device_id *match);
-	int	(*remove)(struct macio_dev* dev);
+	void	(*remove)(struct macio_dev *dev);
 
 	int	(*suspend)(struct macio_dev* dev, pm_message_t state);
 	int	(*resume)(struct macio_dev* dev);
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 9ccaac9e2bc3..653106716a4b 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -1187,7 +1187,7 @@ static int pata_macio_attach(struct macio_dev *mdev,
 	return rc;
 }
 
-static int pata_macio_detach(struct macio_dev *mdev)
+static void pata_macio_detach(struct macio_dev *mdev)
 {
 	struct ata_host *host = macio_get_drvdata(mdev);
 	struct pata_macio_priv *priv = host->private_data;
@@ -1202,8 +1202,6 @@ static int pata_macio_detach(struct macio_dev *mdev)
 	ata_host_detach(host);
 
 	unlock_media_bay(priv->mdev->media_bay);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index c28893e41a8b..f2f83c4f3af5 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -523,7 +523,7 @@ static int rackmeter_probe(struct macio_dev* mdev,
 	return rc;
 }
 
-static int rackmeter_remove(struct macio_dev* mdev)
+static void rackmeter_remove(struct macio_dev *mdev)
 {
 	struct rackmeter *rm = dev_get_drvdata(&mdev->ofdev.dev);
 
@@ -558,8 +558,6 @@ static int rackmeter_remove(struct macio_dev* mdev)
 
 	/* Get rid of me */
 	kfree(rm);
-
-	return 0;
 }
 
 static int rackmeter_shutdown(struct macio_dev* mdev)
diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index 9e653e2925f7..292b1f9cd9e7 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1591,7 +1591,7 @@ bmac_proc_info(char *buffer, char **start, off_t offset, int length)
 }
 #endif
 
-static int bmac_remove(struct macio_dev *mdev)
+static void bmac_remove(struct macio_dev *mdev)
 {
 	struct net_device *dev = macio_get_drvdata(mdev);
 	struct bmac_data *bp = netdev_priv(dev);
@@ -1609,8 +1609,6 @@ static int bmac_remove(struct macio_dev *mdev)
 	macio_release_resources(mdev);
 
 	free_netdev(dev);
-
-	return 0;
 }
 
 static const struct of_device_id bmac_match[] =
diff --git a/drivers/net/ethernet/apple/mace.c b/drivers/net/ethernet/apple/mace.c
index fd1b008b7208..e6350971c707 100644
--- a/drivers/net/ethernet/apple/mace.c
+++ b/drivers/net/ethernet/apple/mace.c
@@ -272,7 +272,7 @@ static int mace_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	return rc;
 }
 
-static int mace_remove(struct macio_dev *mdev)
+static void mace_remove(struct macio_dev *mdev)
 {
 	struct net_device *dev = macio_get_drvdata(mdev);
 	struct mace_data *mp;
@@ -296,8 +296,6 @@ static int mace_remove(struct macio_dev *mdev)
 	free_netdev(dev);
 
 	macio_release_resources(mdev);
-
-	return 0;
 }
 
 static void dbdma_reset(volatile struct dbdma_regs __iomem *dma)
diff --git a/drivers/net/wireless/intersil/orinoco/airport.c b/drivers/net/wireless/intersil/orinoco/airport.c
index a890bfa0d5cc..276a06cdd1f5 100644
--- a/drivers/net/wireless/intersil/orinoco/airport.c
+++ b/drivers/net/wireless/intersil/orinoco/airport.c
@@ -85,7 +85,7 @@ airport_resume(struct macio_dev *mdev)
 	return err;
 }
 
-static int
+static void
 airport_detach(struct macio_dev *mdev)
 {
 	struct orinoco_private *priv = dev_get_drvdata(&mdev->ofdev.dev);
@@ -111,8 +111,6 @@ airport_detach(struct macio_dev *mdev)
 
 	macio_set_drvdata(mdev, NULL);
 	free_orinocodev(priv);
-
-	return 0;
 }
 
 static int airport_hard_reset(struct orinoco_private *priv)
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index f75928f7773e..42648ca9b8ed 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -508,7 +508,7 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
 	return rc;
 }
 
-static int mac53c94_remove(struct macio_dev *mdev)
+static void mac53c94_remove(struct macio_dev *mdev)
 {
 	struct fsc_state *fp = (struct fsc_state *)macio_get_drvdata(mdev);
 	struct Scsi_Host *host = fp->host;
@@ -526,11 +526,8 @@ static int mac53c94_remove(struct macio_dev *mdev)
 	scsi_host_put(host);
 
 	macio_release_resources(mdev);
-
-	return 0;
 }
 
-
 static struct of_device_id mac53c94_match[] = 
 {
 	{
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 84b541a57b7b..cd2575b88c85 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1986,7 +1986,7 @@ static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	return -ENODEV;
 }
 
-static int mesh_remove(struct macio_dev *mdev)
+static void mesh_remove(struct macio_dev *mdev)
 {
 	struct mesh_state *ms = (struct mesh_state *)macio_get_drvdata(mdev);
 	struct Scsi_Host *mesh_host = ms->host;
@@ -2013,11 +2013,8 @@ static int mesh_remove(struct macio_dev *mdev)
 	macio_release_resources(mdev);
 
 	scsi_host_put(mesh_host);
-
-	return 0;
 }
 
-
 static struct of_device_id mesh_match[] = 
 {
 	{
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 13668ffdb1e7..d4640479c338 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1507,12 +1507,12 @@ static int pmz_attach(struct macio_dev *mdev, const struct of_device_id *match)
  * That one should not be called, macio isn't really a hotswap device,
  * we don't expect one of those serial ports to go away...
  */
-static int pmz_detach(struct macio_dev *mdev)
+static void pmz_detach(struct macio_dev *mdev)
 {
 	struct uart_pmac_port	*uap = dev_get_drvdata(&mdev->ofdev.dev);
 	
 	if (!uap)
-		return -ENODEV;
+		return;
 
 	uart_remove_one_port(&pmz_uart_reg, &uap->port);
 
@@ -1523,11 +1523,8 @@ static int pmz_detach(struct macio_dev *mdev)
 	dev_set_drvdata(&mdev->ofdev.dev, NULL);
 	uap->dev = NULL;
 	uap->port.dev = NULL;
-	
-	return 0;
 }
 
-
 static int pmz_suspend(struct macio_dev *mdev, pm_message_t pm_state)
 {
 	struct uart_pmac_port *uap = dev_get_drvdata(&mdev->ofdev.dev);
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 51ed2f34b276..35f39727994d 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -364,15 +364,13 @@ static int i2sbus_probe(struct macio_dev* dev, const struct of_device_id *match)
 	return 0;
 }
 
-static int i2sbus_remove(struct macio_dev* dev)
+static void i2sbus_remove(struct macio_dev *dev)
 {
 	struct i2sbus_control *control = dev_get_drvdata(&dev->ofdev.dev);
 	struct i2sbus_dev *i2sdev, *tmp;
 
 	list_for_each_entry_safe(i2sdev, tmp, &control->list, item)
 		soundbus_remove_one(&i2sdev->sound);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
-- 
2.25.1

