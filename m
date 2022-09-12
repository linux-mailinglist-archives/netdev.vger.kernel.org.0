Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50055B54F0
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiILHB7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Sep 2022 03:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiILHBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:01:55 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC20824965
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:01:52 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2048.outbound.protection.outlook.com [104.47.22.48]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-36-AoWTGfeNMCqUnBSmYmrIFg-1; Mon, 12 Sep 2022 09:01:50 +0200
X-MC-Unique: AoWTGfeNMCqUnBSmYmrIFg-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZR0P278MB0744.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:43::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.14; Mon, 12 Sep 2022 07:01:48 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 07:01:48 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        "Andrew Lunn" <andrew@lunn.ch>
CC:     Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH net 2/2] Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"
Date:   Mon, 12 Sep 2022 09:01:43 +0200
Message-ID: <20220912070143.98153-3-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220912070143.98153-1-francesco.dolcini@toradex.com>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
X-ClientProxiedBy: MR1P264CA0055.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::16) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZRAP278MB0495:EE_|ZR0P278MB0744:EE_
X-MS-Office365-Filtering-Correlation-Id: 8214c663-db57-47a9-5fa1-08da948ca8d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: fjfNG7dVfLDpbqlPVa/qJMcB+jWgBxhizM+wFaAHQUQY5V0rwSFvWpfDk6/q8Nq2hd6/jyvW0FsjijtV0pwxwTDKWzPztEigNfmKmv0KxRAgQk38pjPWONjX4+lBoc0hNt9s2yQPhQWORb7SQcNPjyrCa0WO9r48eifMT/bwTo2ad9tkIbNQxb49D4OAfIc33T/gMZbIOihOVjkRLckGbQPvDG88/9JxPRTOW+sDTcXB+SOcaBRAmLvkkITdQIo3cipE4YjicyAEEZwuROjAVGu3fgWh/UntcKcRQXPrjVKSYtf5u4m0glPxCA+xdQ3ZA5TaKlL4nx3xZxD/BoJuPpHYWmpD0bO1hwzZ0Ks5bi8xiysSUK0WKnTURCjo9Ab4udd9eJ2uIaajTzQdvxJ6J+B8cXsV5OblZn2FSa0HAamIYuMGW8o/WrrYVk5B9EBGDG+Wyw15BfU31mK5RyBhWF2qoUHvGy19r6Aun6KVZnt0rVWnz6wK9Uhekdq15CmJmwygYVaWSl1kBFGx+8pC6xYuSawS6A1tgZSB6iMrHtpa+tvjKgg+MPkn+qxoa1xp03WoHU+K+jyCpIc0BbP35SE5ZVdIIFqueeMpP1AP1VQqR1z9eZN51mCkZXC/9aYyorb2qP45BnYsqJHZjfZckKXiNAosjo2GXGpgsrbUNGNw33nusfBMwCkF5UT81n59Q/rG22oyk1JVrsRo14CxHIbgf7ehxdZ6A2Ls38svYh5LB+pF4YMuLvRKj//AzX2wQ5X7Oi7mW3rI6IdLoQzDoGMCI+O0643Jbsbq2yf8d22NgWKrAXpJ6OTQ0fhKT2Z4yDg+1pLZlz0A5bC9ANbwAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39830400003)(376002)(396003)(346002)(38100700002)(38350700002)(4326008)(86362001)(66946007)(66476007)(66556008)(8676002)(36756003)(921005)(107886003)(26005)(186003)(83380400001)(2616005)(52116002)(6512007)(6506007)(41300700001)(966005)(478600001)(6486002)(6666004)(316002)(110136005)(44832011)(2906002)(8936002)(1076003)(7416002)(5660300002)(81973001);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yk9Aia9Qaw/vJdQikAp3ObKkpsqSxOV6iSfbSlh75W0nsiDfHu566dGKWunY?=
 =?us-ascii?Q?D8LJIDjWNJY2yG0NPGDgOXgBUNhklA6lszZpxlFJItdhcryKnbB9zG8t+cPX?=
 =?us-ascii?Q?IsXd+vhWrMEpTiRfuiSJZvsDLGVoS1Dv4YR/kAuMXztorAddfEVOmDht38RR?=
 =?us-ascii?Q?2t6seDKP/o/o76gLAPl70POswjHhpsT9N9leWyqTRyrCsD4Vcx0+0jDb4qgw?=
 =?us-ascii?Q?yW52p94dDoAU/pQw6kFFiIGdq9hB6dBACRVJnMmPfKLaUh1hCj9vbF63lnCe?=
 =?us-ascii?Q?5TRVVld4ig98TK89PemZFaDMKxS4zNKU3YAa6j/i3sIvy6puLzMDGoQLJNuQ?=
 =?us-ascii?Q?qO7ymqaWOPdVTMT4G+jJSGegFf86XIaYaYqJIEJUy5YkcO9SHmS0TCi/xsA5?=
 =?us-ascii?Q?tbarsQ/z5wvm+zXyVMYur9WCqhvoSMGB1WPeC9IZHYEoTXoGC44pvhTDTqF9?=
 =?us-ascii?Q?U9evEWBZgAM0Wj7C+hWAHqra/9HZPuLhTiIJsUj0+1r3sgQLqxmYMS3T2VHr?=
 =?us-ascii?Q?jLXT5zbXn5UdjdnsIjGATawAxUnNMDbTY0pQXlafH/Nv0XSaAfPIn0H90KZn?=
 =?us-ascii?Q?Twq0X8CvREwhgcVx4fuYB9XcGqesbPFAReLTUDQ9d5QkVKts8ahqfR8WmNRl?=
 =?us-ascii?Q?2XwUWJ7Q8vGGLEOsQWbF5vYtX0BcFoF44hbK6J6HpJZHqovriz8YG9HmgG0v?=
 =?us-ascii?Q?dA48utcz0No4f1e5AhBjxOMQwN/DB2XVqKPc71TECwLMRyaDqsCSFAy/5AR3?=
 =?us-ascii?Q?b+rm4fMB19tprzRQcoDXt37Lh6u9h64P9IvomocmSOeJe2L3K3qahvO+DBN4?=
 =?us-ascii?Q?Eck0dGmTMwzDqX8/1/asC8rb60Jk4dIB5a6eo5eNd7W+OKvQJCEXTW35wfML?=
 =?us-ascii?Q?lgSxkC6KkSxsdNTHgOD90YnwMUEFC183gsQMeN9lglLKyJm6XmwaeR5XOiry?=
 =?us-ascii?Q?E2lrwZ6m/Xys21SzF3BzXYOnHkl5qaKWf7G+BuhAEPWJs1zQENthYNj87a5X?=
 =?us-ascii?Q?DWm9alO/JXwPY/TzgsMaB3mBEO9NX/PLmdqL7AigLHiRWxiOrt04OdLtmTDI?=
 =?us-ascii?Q?f3fKnql5kmXwN856QTJ78cV/cBRSFe8t5eSoC6OJeTQLByUAeF1zRcLISzgm?=
 =?us-ascii?Q?vwj42uIktpDpayQRnNucYb1rGCzm8vFl8pnWve9/1fiOvFB1cNa4z7idVl35?=
 =?us-ascii?Q?vF+SRfXlVyC96SMd0u2PxJohRR1c2Wi/ATtLWQvr2wPVcYwQtJ8l2WGqplaP?=
 =?us-ascii?Q?z3Kd0k6r65mlzemWYDkXBFG4+oczWgwVM2qnzqtoR0hZDLULHb2V//Yktige?=
 =?us-ascii?Q?CgK/8HKdDSBpZffyoaVwEYITHIdc75Tk7farJjJDwnsaerND63PQJfdwy/BA?=
 =?us-ascii?Q?zzHAGHo5Bbr85PplfG7sOTcMCgxjGQoivggdkTbIhdFN0ZcZnvqgXwHjUKPM?=
 =?us-ascii?Q?jKfwrSOw4106h2oj250W+lO6Wa/N0gM8FnNxLfcMhr8EMNFAeqCILk05yXU8?=
 =?us-ascii?Q?EPcK+EKZtu8sDUYMVkxfVIe2fx5S3hkJehVRlrPaC7TSCQG7n3Q4p7G4/RrC?=
 =?us-ascii?Q?dWmOAzR9YX/gQYQX6b+pB9b2IWDxtF+MvhC0iaVDA1xm4v5Cj5LkPzZmQa4K?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8214c663-db57-47a9-5fa1-08da948ca8d0
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 07:01:47.6470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4A8Ju3bicwfVR5rux6WsOdyeP8KeH9AN1ld09xcF61TvszXGCkVDU1PDCDIYefG/sAzRmCHXW4WoFN8VXMUJG4xn1plQkX8EZqXJ+LxnJPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0744
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b353b241f1eb9b6265358ffbe2632fdcb563354f, this is
creating multiple issues, just not ready to be merged yet.

Link: https://lore.kernel.org/all/CAHk-=wj1obPoTu1AHj9Bd_BGYjdjDyPP+vT5WMj8eheb3A9WHw@mail.gmail.com/
Link: https://lore.kernel.org/all/20220907143915.5w65kainpykfobte@pengutronix.de/
Fixes: b353b241f1eb ("net: fec: Use a spinlock to guard `fep->ptp_clk_on`")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 17 +++++++-------
 drivers/net/ethernet/freescale/fec_ptp.c  | 28 +++++++++++++++--------
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index dcfe63f9be06..a5fed00cb971 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -561,6 +561,7 @@ struct fec_enet_private {
 	struct clk *clk_2x_txclk;
 
 	bool ptp_clk_on;
+	struct mutex ptp_clk_mutex;
 	unsigned int num_tx_queues;
 	unsigned int num_rx_queues;
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4ccd74af09ae..92c55e1a5507 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1995,7 +1995,6 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	unsigned long flags;
 	int ret;
 
 	if (enable) {
@@ -2004,15 +2003,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 			return ret;
 
 		if (fep->clk_ptp) {
-			spin_lock_irqsave(&fep->tmreg_lock, flags);
+			mutex_lock(&fep->ptp_clk_mutex);
 			ret = clk_prepare_enable(fep->clk_ptp);
 			if (ret) {
-				spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+				mutex_unlock(&fep->ptp_clk_mutex);
 				goto failed_clk_ptp;
 			} else {
 				fep->ptp_clk_on = true;
 			}
-			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+			mutex_unlock(&fep->ptp_clk_mutex);
 		}
 
 		ret = clk_prepare_enable(fep->clk_ref);
@@ -2027,10 +2026,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
-			spin_lock_irqsave(&fep->tmreg_lock, flags);
+			mutex_lock(&fep->ptp_clk_mutex);
 			clk_disable_unprepare(fep->clk_ptp);
 			fep->ptp_clk_on = false;
-			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+			mutex_unlock(&fep->ptp_clk_mutex);
 		}
 		clk_disable_unprepare(fep->clk_ref);
 		clk_disable_unprepare(fep->clk_2x_txclk);
@@ -2043,10 +2042,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		clk_disable_unprepare(fep->clk_ref);
 failed_clk_ref:
 	if (fep->clk_ptp) {
-		spin_lock_irqsave(&fep->tmreg_lock, flags);
+		mutex_lock(&fep->ptp_clk_mutex);
 		clk_disable_unprepare(fep->clk_ptp);
 		fep->ptp_clk_on = false;
-		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		mutex_unlock(&fep->ptp_clk_mutex);
 	}
 failed_clk_ptp:
 	clk_disable_unprepare(fep->clk_enet_out);
@@ -3881,7 +3880,7 @@ fec_probe(struct platform_device *pdev)
 	}
 
 	fep->ptp_clk_on = false;
-	spin_lock_init(&fep->tmreg_lock);
+	mutex_init(&fep->ptp_clk_mutex);
 
 	/* clk_ref is optional, depends on board */
 	fep->clk_ref = devm_clk_get_optional(&pdev->dev, "enet_clk_ref");
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index af20aa237964..3dc3c0b626c2 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -365,19 +365,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
  */
 static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
-	struct fec_enet_private *fep =
+	struct fec_enet_private *adapter =
 	    container_of(ptp, struct fec_enet_private, ptp_caps);
 	u64 ns;
 	unsigned long flags;
 
-	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	mutex_lock(&adapter->ptp_clk_mutex);
 	/* Check the ptp clock */
-	if (!fep->ptp_clk_on) {
-		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+	if (!adapter->ptp_clk_on) {
+		mutex_unlock(&adapter->ptp_clk_mutex);
 		return -EINVAL;
 	}
-	ns = timecounter_read(&fep->tc);
-	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	ns = timecounter_read(&adapter->tc);
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+	mutex_unlock(&adapter->ptp_clk_mutex);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -402,10 +404,10 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	unsigned long flags;
 	u32 counter;
 
-	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	mutex_lock(&fep->ptp_clk_mutex);
 	/* Check the ptp clock */
 	if (!fep->ptp_clk_on) {
-		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		mutex_unlock(&fep->ptp_clk_mutex);
 		return -EINVAL;
 	}
 
@@ -415,9 +417,11 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	 */
 	counter = ns & fep->cc.mask;
 
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	writel(counter, fep->hwp + FEC_ATIME);
 	timecounter_init(&fep->tc, &fep->cc, ns);
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+	mutex_unlock(&fep->ptp_clk_mutex);
 	return 0;
 }
 
@@ -514,11 +518,13 @@ static void fec_time_keep(struct work_struct *work)
 	struct fec_enet_private *fep = container_of(dwork, struct fec_enet_private, time_keep);
 	unsigned long flags;
 
-	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	mutex_lock(&fep->ptp_clk_mutex);
 	if (fep->ptp_clk_on) {
+		spin_lock_irqsave(&fep->tmreg_lock, flags);
 		timecounter_read(&fep->tc);
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	}
-	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+	mutex_unlock(&fep->ptp_clk_mutex);
 
 	schedule_delayed_work(&fep->time_keep, HZ);
 }
@@ -593,6 +599,8 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	}
 	fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
 
+	spin_lock_init(&fep->tmreg_lock);
+
 	fec_ptp_start_cyclecounter(ndev);
 
 	INIT_DELAYED_WORK(&fep->time_keep, fec_time_keep);
-- 
2.25.1

