Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7D95B54F2
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiILHCL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Sep 2022 03:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiILHB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:01:59 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05A824BE0
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:01:53 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2041.outbound.protection.outlook.com [104.47.22.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-32-r2zqvNjcMfKchLRYGNdouQ-3; Mon, 12 Sep 2022 09:01:51 +0200
X-MC-Unique: r2zqvNjcMfKchLRYGNdouQ-3
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
Subject: [PATCH net 1/2] Revert "fec: Restart PPS after link state change"
Date:   Mon, 12 Sep 2022 09:01:42 +0200
Message-ID: <20220912070143.98153-2-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220912070143.98153-1-francesco.dolcini@toradex.com>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
X-ClientProxiedBy: MR1P264CA0204.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:57::20) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZRAP278MB0495:EE_|ZR0P278MB0744:EE_
X-MS-Office365-Filtering-Correlation-Id: e5ba9e4a-cc77-4359-5fa1-08da948ca8d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: rou6ghUsd9tWB0PYsVf5JRgfkDqTI7f1uZjAEoKsd0iTjpVFMRRYVCdWgI+BhCQegmPBnBXLtkd0s5nzjuSSQQZuU+B3VWzSqUMExNUooJHE7t8Gs7GYuyzvSdOKyK38IncXjnxkCHzhkvZawe0XI4N906i3h9RL3oaCA6o8O0EZV/ju+F/hSQxEfPnbcXnC6AC+wApYccboVKWdcN0MFu4b7hWpeu96LvlO3Je8dNnDGagpSYz3MC35PJMifNyCSYz3LWCNT03JVshF7kKWY/zqYJk0boXYJakPKL25JvImtCA93coTQs5kBobGNHyzWjjzJXjIPiZPjKi8nVoMhNILu77Uq/3nosDFnBA8+SaffjOmFozb4KCPPPlGmPZ3J7FURmXzE/ztPKHf4ETX+YfN0dACReEFDdPLOdv/a35392GlQU04UaK5cesXHUQ9/8qnt6NlWVBQ3yWgNxmDgSGYOg/CMkQa3irRMChTqJ1Uwlf4cUxiZ+CfNxrWJnPIkukjd7Dbee0/rOoSxi4BC+BG5EHX8qAweNeEbb+jQ9jdnMkj4y4FNNXHtVSRVgAzXHPhvgQHYwUKFbWAEwZjcG4gmHGS+hg1wi3bVorNVxaDROem8P+jRnCxt3WNxhQBQ4IRCsJrNG5d0xZiDvNK4C13Fy/wzhFWyvgyQ7jDNKFXIYNs2Zb6BJeC+ndXy7Y0vtN+WAsN13XngCzRGT2Gun2BbWL6i1aOGT/ujrCeuxURz/9ekZ2/626sgtfXTYRbR21E6nnBHinkAjpcu48Zpsz+ELdrxyCIbez6ulYSdi0O2BN95R5mGeKuqsHlcXTn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39830400003)(376002)(396003)(346002)(38100700002)(38350700002)(4326008)(86362001)(66946007)(66476007)(66556008)(8676002)(36756003)(921005)(107886003)(26005)(186003)(83380400001)(2616005)(52116002)(6512007)(6506007)(41300700001)(966005)(478600001)(6486002)(6666004)(316002)(110136005)(44832011)(2906002)(8936002)(1076003)(7416002)(5660300002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XCf+dxxLFqFhcfIyPVZl+QrgBwRu9XwwNXpY3gW3RId8N/APLB4+ZNGSlaEy?=
 =?us-ascii?Q?ae6vP1WCFwh2OfokoCEA2+7ZeL7r1iZYeerdsYecBj+Y+u26tvOKQqbhauSP?=
 =?us-ascii?Q?oYD4cWC36Y1piPbWNPY/jgz9OgTRmXIrlADLARtE5EiaNno9Q/jfAO7ERaXt?=
 =?us-ascii?Q?USUMU4dm5vf+qbR1TL4rKKrM7ELnwvg4LmUee9vg8+fmNzfUKgpjtspUIDlu?=
 =?us-ascii?Q?D7NVXVMnzKgqwlVxmFkTMVd7JxvN8ezdKZ+ksD7mOvTFIzU1Vhlsn4Al7Zwx?=
 =?us-ascii?Q?ixImbPAN5vd+rLdJypRi7+NWC4Dtq+Xdg07NngfC9bC/fo740HMgispe3n8v?=
 =?us-ascii?Q?2L9M1jnOHXsUCWEOppY3dvDsShdIwlxcJIZyLu0Wcm4OL9mOS9W5+HGDlkbo?=
 =?us-ascii?Q?pgzeHug/eaJJd8Yu5LukOs65szevVcNan8k2mFtjyXmybdhVEab/jd5oJEVf?=
 =?us-ascii?Q?4NR1w2HsJbHJjZj0jaqT6sJqSZpYf9jq4drfb40T4FS4ZccitSDQ3hO6+Btc?=
 =?us-ascii?Q?VdGNfOAFL96RBLjbS9DrU44oqbDDJcoP/nbe6OyH1ShaxEctfZBhsSh1ue39?=
 =?us-ascii?Q?t2D38VOR1VM9Vgl1PqilQf/OgwyNnmoyBb3251swRhLUFYlZFFY+FDxnX+0M?=
 =?us-ascii?Q?9VmKzhyyZEkV5qYVETXPKP3WRqmGdMAaSkzq3cLHo9O7lU7DNx4GNqAxOwIU?=
 =?us-ascii?Q?m0CdWNbkfTF+rzzD0gioKfXrCqbE+3n7JXLYCpp0dLE364ywPBqQrRuPi36V?=
 =?us-ascii?Q?l2qKaaw+v1wx+G6/5YE6Rq37j29vFPxp12oQN/MHbemtxHP2H/gnDedwkJi/?=
 =?us-ascii?Q?LF+UjIPqe0zMcUkw8b/Ie3RQphx+AXo/VB0wlykmxmA6pWGqaeUAZ/Bc+Fbd?=
 =?us-ascii?Q?m8Jw2r2j7Y+lMGNQMS8kPdoz4c+lT1GmFq5dpK/MweC29/ALaqvtIFtD4oIK?=
 =?us-ascii?Q?rIeMvmHqv25V/EfnMlLmDthx4VuNZSaihG8dfr0yLVYde/0SOr1FedZH2eyv?=
 =?us-ascii?Q?NxLgmVYp06xNhHMzceOHpgEX2Pt7i7aY2gISXMGTjTKBUmgUITU43FymSPyS?=
 =?us-ascii?Q?RH29MQFqyR699yshGU5t6IE6hN+LdtX259bNs6G9hKsOswl6N2ypBk0NXAB0?=
 =?us-ascii?Q?GkQljkdu4U5HlVaV1YrdTmWoWtxqdOrwvXoELomJWsIRDLZeVLZYqEIhpF3y?=
 =?us-ascii?Q?EZuuV9/35oIQLvH6g2P2KwMzGvYz+Wxaxj7SzBKGX9bMAATQmQvoKAOaDHIP?=
 =?us-ascii?Q?YU2n3qOK5/l+OPo1H9prwM8nk347oekFrr0c+HQZrC+B8YTlDFVHDM5pzw3W?=
 =?us-ascii?Q?tXMyfWBAK3xYZJ5CxNzaGdMdE96EDk3/uFx3lVVcTD+o1AghMYi5ibp8+DPx?=
 =?us-ascii?Q?LayJosPV/v7YCZAPQD0bqcJ8zRSMjMDby6n1VbkMw0iE3SrMRqdoPGV37P60?=
 =?us-ascii?Q?SdDOp2nWgkLPQYVV1yKzjk01CO5N/Xsm5FNM0FfHwxjZaUgXkragVO0xd4K0?=
 =?us-ascii?Q?k1cbYnK70snA1JYvePmABspF/xSZUywnFNVAPki2YjZJv9jcQ/5zvqHJtSMh?=
 =?us-ascii?Q?cX3VeQYELpjAx8RU27sYXJnQnOEzqvCzAzPSjQJDEsQVSKZImfwinigMAQV7?=
 =?us-ascii?Q?DQ=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ba9e4a-cc77-4359-5fa1-08da948ca8d0
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 07:01:47.6781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tsaE0mMe13q0+sBB46wMmdjOY31O2sDsQwYG5IdYFw7IYsP+EquHQ1VEZiZmPBfc1lKaGbHLZzIEgd+urvCgetndms4LE3X8UeSenJbcZxw=
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

This reverts commit f79959220fa5fbda939592bf91c7a9ea90419040, this is
creating multiple issues, just not ready to be merged yet.

Link: https://lore.kernel.org/all/20220905180542.GA3685102@roeck-us.net/
Link: https://lore.kernel.org/all/CAHk-=wj1obPoTu1AHj9Bd_BGYjdjDyPP+vT5WMj8eheb3A9WHw@mail.gmail.com/
Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
 drivers/net/ethernet/freescale/fec.h      | 10 ------
 drivers/net/ethernet/freescale/fec_main.c | 42 +++--------------------
 drivers/net/ethernet/freescale/fec_ptp.c  | 29 ----------------
 3 files changed, 4 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index d77ee8936c6a..dcfe63f9be06 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -638,13 +638,6 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
-	struct {
-		struct timespec64 ts_phc;
-		u64 ns_sys;
-		u32 at_corr;
-		u8 at_inc_corr;
-	} ptp_saved_state;
-
 	u64 ethtool_stats[];
 };
 
@@ -655,8 +648,5 @@ void fec_ptp_disable_hwts(struct net_device *ndev);
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
 
-void fec_ptp_save_state(struct fec_enet_private *fep);
-int fec_ptp_restore_state(struct fec_enet_private *fep);
-
 /****************************************************************************/
 #endif /* FEC_H */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6152f6dbf1bc..4ccd74af09ae 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -286,11 +286,8 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define FEC_MMFR_TA		(2 << 16)
 #define FEC_MMFR_DATA(v)	(v & 0xffff)
 /* FEC ECR bits definition */
-#define FEC_ECR_RESET   BIT(0)
-#define FEC_ECR_ETHEREN BIT(1)
-#define FEC_ECR_MAGICEN BIT(2)
-#define FEC_ECR_SLEEP   BIT(3)
-#define FEC_ECR_EN1588  BIT(4)
+#define FEC_ECR_MAGICEN		(1 << 2)
+#define FEC_ECR_SLEEP		(1 << 3)
 
 #define FEC_MII_TIMEOUT		30000 /* us */
 
@@ -986,9 +983,6 @@ fec_restart(struct net_device *ndev)
 	u32 temp_mac[2];
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
 	u32 ecntl = 0x2; /* ETHEREN */
-	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
-
-	fec_ptp_save_state(fep);
 
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
@@ -1142,7 +1136,7 @@ fec_restart(struct net_device *ndev)
 	}
 
 	if (fep->bufdesc_ex)
-		ecntl |= FEC_ECR_EN1588;
+		ecntl |= (1 << 4);
 
 	if (fep->quirks & FEC_QUIRK_DELAYED_CLKS_SUPPORT &&
 	    fep->rgmii_txc_dly)
@@ -1163,14 +1157,6 @@ fec_restart(struct net_device *ndev)
 	if (fep->bufdesc_ex)
 		fec_ptp_start_cyclecounter(ndev);
 
-	/* Restart PPS if needed */
-	if (fep->pps_enable) {
-		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
-		fep->pps_enable = 0;
-		fec_ptp_restore_state(fep);
-		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
-	}
-
 	/* Enable interrupts we wish to service */
 	if (fep->link)
 		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
@@ -1221,8 +1207,6 @@ fec_stop(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 	u32 val;
-	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
-	u32 ecntl = 0;
 
 	/* We cannot expect a graceful transmit stop without link !!! */
 	if (fep->link) {
@@ -1232,8 +1216,6 @@ fec_stop(struct net_device *ndev)
 			netdev_err(ndev, "Graceful transmit stop did not complete!\n");
 	}
 
-	fec_ptp_save_state(fep);
-
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
@@ -1253,28 +1235,12 @@ fec_stop(struct net_device *ndev)
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 	writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 
-	if (fep->bufdesc_ex)
-		ecntl |= FEC_ECR_EN1588;
-
 	/* We have to keep ENET enabled to have MII interrupt stay working */
 	if (fep->quirks & FEC_QUIRK_ENET_MAC &&
 		!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
-		ecntl |= FEC_ECR_ETHEREN;
+		writel(2, fep->hwp + FEC_ECNTRL);
 		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
 	}
-
-	writel(ecntl, fep->hwp + FEC_ECNTRL);
-
-	if (fep->bufdesc_ex)
-		fec_ptp_start_cyclecounter(ndev);
-
-	/* Restart PPS if needed */
-	if (fep->pps_enable) {
-		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
-		fep->pps_enable = 0;
-		fec_ptp_restore_state(fep);
-		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
-	}
 }
 
 
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 8dd5a2615a89..af20aa237964 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -625,36 +625,7 @@ void fec_ptp_stop(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
-	if (fep->pps_enable)
-		fec_ptp_enable_pps(fep, 0);
-
 	cancel_delayed_work_sync(&fep->time_keep);
 	if (fep->ptp_clock)
 		ptp_clock_unregister(fep->ptp_clock);
 }
-
-void fec_ptp_save_state(struct fec_enet_private *fep)
-{
-	u32 atime_inc_corr;
-
-	fec_ptp_gettime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
-	fep->ptp_saved_state.ns_sys = ktime_get_ns();
-
-	fep->ptp_saved_state.at_corr = readl(fep->hwp + FEC_ATIME_CORR);
-	atime_inc_corr = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_CORR_MASK;
-	fep->ptp_saved_state.at_inc_corr = (u8)(atime_inc_corr >> FEC_T_INC_CORR_OFFSET);
-}
-
-int fec_ptp_restore_state(struct fec_enet_private *fep)
-{
-	u32 atime_inc = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_MASK;
-	u64 ns_sys;
-
-	writel(fep->ptp_saved_state.at_corr, fep->hwp + FEC_ATIME_CORR);
-	atime_inc |= ((u32)fep->ptp_saved_state.at_inc_corr) << FEC_T_INC_CORR_OFFSET;
-	writel(atime_inc, fep->hwp + FEC_ATIME_INC);
-
-	ns_sys = ktime_get_ns() - fep->ptp_saved_state.ns_sys;
-	timespec64_add_ns(&fep->ptp_saved_state.ts_phc, ns_sys);
-	return fec_ptp_settime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
-}
-- 
2.25.1

