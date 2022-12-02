Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C72640F3E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbiLBUm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiLBUm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:42:57 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2064.outbound.protection.outlook.com [40.107.249.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBA199538;
        Fri,  2 Dec 2022 12:42:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQiceoymYthugohsoUopYHJyPj5wINf7QqrnEspJ6PbGLaNuGwwgaKGBFurGIbzaDGpjSwOoTRRMP/2Y8wS4FrMIF8z09voW+4aaI9/kAjytr2IdzfB0t7vroTTRoskWcbIAcC2JO4MdEL2Lux2bE3Cd31C3k2e0l/exSi3rJA6BjV50EGrXCJkRXqNTa4waG3QHW7AjseP9EsOJUNBfR6L3IsSQrlAR52j71FAmqMdaJqd8CEcEZeIV+eCIgCe8/nIvT/GibzLMnNLGLJMxrODvK3jd3Ges/NxYG3clFqya1bFs97cMymZj188ClWWeIx3kPp1C5H2DRuCxN3G3FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4IktvmVS8mCR6mPaorRY7HtT3bTNbJB4gzWKI6n3d7Q=;
 b=hBqMqTipAbOpQ7J0otwflYFvJ39a1oSh1LPOvTJQfcIGWM38/dCaLinEpjTc2MExAZLIPiOWzSuOiojeHRllulbPeYV3kE7zP/VMc+6Wuh1WOROyLuVOUpihn/kv0HhiposVgBXMQTWEV6s8lrIyFQiDVo3SgG4mUbtqnEy4Q+k+Mdk0vPsr/jCa/Y0tQJIAdZGTit91CbeVC/HYYqT/p19CWrjgixSTQLs5NR24hzcJ2uPiPMBZIy4ye8VvJvx9G7busueI8wwki/di+um+IsA5A33C6zHu7isG3hxrUgBMHP/J/CX9bGwUNwBgJMjgSPuyopwr3oMzJXqywT7GJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IktvmVS8mCR6mPaorRY7HtT3bTNbJB4gzWKI6n3d7Q=;
 b=AW1/vnlJ39dkKdJY3hy+SSU5/n5TnzLkrOOrAqled2d5tFf8ngpdyhaWNdppbe+MI/J1d6kB8+ctE0Zx7Y3upMMV4hGDIH4Xl82M3hH1d/RFqtlGdGdDUL3mavCf2uE/3uaQblqEShWq3ZhfjIBOVuc5+Jj1+kclrEDVGt1KZuYdQZFUUmnvuDnTpTGMIEom6WgKQWyVXQ2wUUMqMYdbHcmBoE7qnMlzFy8VhdWzOy8VuIFVNmWaEYjgEPF0ZUY2W2zDh0iSGNBLfZQZhpRd6dj07d63wwOTA5G1EJBph/SdaLxKZW3CkpcJay30je8Ytv4uEe+2hwRXM8NT0ZARlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB6979.eurprd03.prod.outlook.com (2603:10a6:20b:285::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 2 Dec
 2022 20:42:50 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:42:50 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] phy: mdio: Reorganize defines
Date:   Fri,  2 Dec 2022 15:42:37 -0500
Message-Id: <20221202204237.1084376-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:208:32d::16) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB6979:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dce6e3d-fbf0-4504-b90f-08dad4a5c62f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LADWh50Z8W//z4y2qkXiajJ37RkOCwlYgnQ43kzH/o7Yo5ruKwOBTD6QkUdYjiOTgO4lsic66aUbVtPa2kCkC6radk7FQT1FxUgm/NU9HmjCh6ClccV1TWC7e3x32OLQvJ8oWJs2rip4SlG6aA/C9FnsCYoMHKkEJ9G/rkcFhJ5itOuAMPzDmFITkksJi95BSMhPvZiZ3IyeXLaJZoiOz93t8u6z830lyD7QV5v8oOsci9nm5mjA8N1RXkKwj5n1oatTcezeVw69mnTXriJ5aZ8DGadyMAeHnGNpq+OHGJB5xGcAOC3nbCcCK7GupRkAJVSJJsPw83yrQ0kyVLhwlY6P6cR1I/YG9xK27D3I0HP/VAeGgEmp32uV7yE0im9S+ukkM9g2ISCdKoYgzGsgCBviu+/NMrjori3GIipCxdCjEXkO9JcsHGINXxUhmjczakgID48j9Uwo+zFvFwB+FCR5G1b7jGp1z4VyW2qLlC0YrUp0iDxlsRVF31HDh41kfgHGNIv2v1AbNTOZd8qzAbXIoHSIHbtsGfJtC8i1wlQ58qhKCNhKs9sARDGlHYlv2BaCC+zT5i/41EI9HKdRbURyMaemL0qzlqSU40TGF3zuP+u0U/ZSOWKmQG7VIFoPiMwJHXjAv+uSAT8XS1U6Q3IACpPv7addGhS6dTHD8ClGIXO5Hhn3Q8HUbNSUwjCk6BxBw6AvtKEhYlbP/6vhN1kaH44BDkf80V8NcXGwUI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(39850400004)(366004)(451199015)(83380400001)(110136005)(316002)(54906003)(26005)(6506007)(478600001)(107886003)(6486002)(966005)(6512007)(36756003)(86362001)(2616005)(6666004)(1076003)(52116002)(186003)(2906002)(5660300002)(66476007)(41300700001)(8676002)(4326008)(66946007)(66556008)(30864003)(8936002)(38100700002)(38350700002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hZAw1730Af7vy6Aln2eOZ2EpmFsjc1UUFP2mciLXD6aKpgruJ3u5ZkejTJFb?=
 =?us-ascii?Q?aYPv0jSBML9MNMPQCIpA0W6Ti2w0MzXriJ3m46d4LuYk0JLhqdWUdtRrKr5r?=
 =?us-ascii?Q?gZXGTPe3EhMyDobncpHYnGhVsSXohXQ/wt2undFkZ/IDSlURzs/0ISjGYsV7?=
 =?us-ascii?Q?tT4q3qkYNQbNbbmEJpINoyEerWI/n/2N6wDiHGXtYjgdDN90An2p38GVioPt?=
 =?us-ascii?Q?hUDhUPtz/EFSCQJjrk+wi4yy6VlQR/kbG02JftjL/SMDR3Eaqr2TX7r4tfyH?=
 =?us-ascii?Q?zFFvDgfc+VsAhxG6Jb3vCIxDra3tJMVrTEJor48xvU2dGHN4vuNT+flUWTj+?=
 =?us-ascii?Q?GpvHq81K29ENswRLqdSEeclnhJGCBt1ArmPDrQy7zNAfUvnLntnkspjfp4WY?=
 =?us-ascii?Q?P8ZhauQRNIWGridS38Ca2q0S2Nh8l5pBkorCxL6l/8vZzeC3b4Q6iWUeEiqN?=
 =?us-ascii?Q?/6IJDvvP2nrvgL8nHv6Q8/vrCHLY85Jse7Z3i5hvkORFeV06D8dkH6EC7pYr?=
 =?us-ascii?Q?kZPXT7tE3czfhNYYsv05VJLhqVrh6Mase8IGvgeK75QmvSaJjURcWWtoVQkc?=
 =?us-ascii?Q?NP3zXou8q378hsAS92uyP1mtAMmSvRLMhd4GGkHxyNOranNrz3I6OhlAJ2eo?=
 =?us-ascii?Q?HSGiZa49GZ6MtX25BxdsZqcFnwxH2cKmB/BWwa0hggPCl0h/Kq1+sHxbK6hI?=
 =?us-ascii?Q?IrkE5DgALLJLAgdWlRDA68qu7qygpjW9a1+4PuO8WtsrHTrloWtuzj/W6IY1?=
 =?us-ascii?Q?Z8fUZPU/IF3rN9QQDe9/vtnO3l3pZUrE4IrQJGDaXxdNiZOwwgPuOTRYpnt0?=
 =?us-ascii?Q?o0/DimYY4/eX4eKGBAMhQqwymK4FXUNvBT+oTTbJ6Z2Kn2ZrXG6zQfPkz6ig?=
 =?us-ascii?Q?A/WBFic5W36oztbjv2O+xhNWQY9zM0CCPhCxSltEljc1iSGkdXhZJdQz+S2L?=
 =?us-ascii?Q?ugNqWX8fFpACxbFyVjd9/IGmqsaXITXAZFwsCy6F4WdN80X3B8zTaZPvVA0e?=
 =?us-ascii?Q?N9VnvKzdzvuH9UCQ9y8op034K6Kgie0oJ43NXPuJuGFR8HD+nmh4Hwh22a9X?=
 =?us-ascii?Q?9m8iQ7bS5stibmc9ycJb2iRAVpWO7UWIZH4T27lgLoZELrboiFvdY1ukRQHN?=
 =?us-ascii?Q?NLoTLGthtRtCZoyruxd4Tq23ZzZ8K4Fn7EYj1SarJFqfidYvs+o28+NkjWAw?=
 =?us-ascii?Q?pUu62ZcR0AEHj+wvNlenSlxBXBhatNd2ZE2lH+wSTD0glLMCRx2a4MGODqOj?=
 =?us-ascii?Q?cLRKqWLSxY6dD7K50kQKMqqUrFNNntjUcI6J+z1I/e2nb+vlAX56wD+B38hu?=
 =?us-ascii?Q?PvCxSFNfgSMy5c8t/G2QYC1Rk0x/oofvFOF/qzykVVzied3QNczxtARDglH8?=
 =?us-ascii?Q?jMZNwrhoGCwGOBwmYCFfjp2CoVRe8KUhXz4Fgf8e3fjOsuBGFT1lFrWrG/mh?=
 =?us-ascii?Q?7EGAVdn6ob/v78P0t6KmzMB0NlT6vHEgQKMI5USwsPLGUS5Fu85cepT3Yqk1?=
 =?us-ascii?Q?WqGOp/A7XSTtKtPB7wdhBB1YoVKS5egVj+/ivKVZ/RjGMMYycZ5f8InaSTRB?=
 =?us-ascii?Q?uEJqESU3VWTde3FiFTv2UdLj/6vPwUxKpL+CZJFtqJw2wvkJdjlTroj0K3Xy?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dce6e3d-fbf0-4504-b90f-08dad4a5c62f
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:42:50.2013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oj28IgKhYCmDLcRDMwgtsDPjOiLXm4cvQiRVz7Xib7pvDfE3rbJenDjXahBxEUr68KzfVo5Ntnp4Jw4xsbaujg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB6979
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder all registers to be grouped by MMD. Groups fields in
similarly-named registers in the same way. This is especially useful for
registers which may have some bits in common, but interpret other bits
in different ways. The comments have been tweaked to more closely follow
802.3's naming.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
prerequisite-patch-id: 53145a676b9582dde432d31e0003f01a90a81976
---
This is based on [1].

[1] https://lore.kernel.org/netdev/20221202181719.1068869-3-sean.anderson@seco.com/

 include/uapi/linux/mdio.h | 96 ++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 37 deletions(-)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index d700e9e886b9..a7058ff21e04 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -37,40 +37,47 @@
 #define MDIO_DEVS2		6
 #define MDIO_CTRL2		7	/* 10G control 2 */
 #define MDIO_STAT2		8	/* 10G status 2 */
+#define MDIO_PKGID1		14	/* Package identifier */
+#define MDIO_PKGID2		15
+
+/* PMA/PMD registers. */
 #define MDIO_PMA_TXDIS		9	/* 10G PMA/PMD transmit disable */
 #define MDIO_PMA_RXDET		10	/* 10G PMA/PMD receive signal detect */
 #define MDIO_PMA_EXTABLE	11	/* 10G PMA/PMD extended ability */
-#define MDIO_PKGID1		14	/* Package identifier */
-#define MDIO_PKGID2		15
-#define MDIO_AN_ADVERTISE	16	/* AN advertising (base page) */
-#define MDIO_AN_LPA		19	/* AN LP abilities (base page) */
-#define MDIO_PCS_EEE_ABLE	20	/* EEE Capability register */
-#define MDIO_PCS_EEE_ABLE2	21	/* EEE Capability register 2 */
+#define MDIO_PMA_PMD_BT1	18	/* BASE-T1 PMA/PMD extended ability */
 #define MDIO_PMA_NG_EXTABLE	21	/* 2.5G/5G PMA/PMD extended ability */
-#define MDIO_PCS_EEE_WK_ERR	22	/* EEE wake error counter */
-#define MDIO_PHYXS_LNSTAT	24	/* PHY XGXS lane state */
-#define MDIO_AN_EEE_ADV		60	/* EEE advertisement */
-#define MDIO_AN_EEE_LPABLE	61	/* EEE link partner ability */
-#define MDIO_AN_EEE_ADV2	62	/* EEE advertisement 2 */
-#define MDIO_AN_EEE_LPABLE2	63	/* EEE link partner ability 2 */
-#define MDIO_AN_CTRL2		64	/* AN THP bypass request control */
-
-/* Media-dependent registers. */
 #define MDIO_PMA_10GBT_SWAPPOL	130	/* 10GBASE-T pair swap & polarity */
 #define MDIO_PMA_10GBT_TXPWR	131	/* 10GBASE-T TX power control */
 #define MDIO_PMA_10GBT_SNR	133	/* 10GBASE-T SNR margin, lane A.
 					 * Lanes B-D are numbered 134-136. */
 #define MDIO_PMA_10GBR_FSRT_CSR	147	/* 10GBASE-R fast retrain status and control */
 #define MDIO_PMA_10GBR_FECABLE	170	/* 10GBASE-R FEC ability */
+#define MDIO_PMA_PMD_BT1_CTRL	2100	/* BASE-T1 PMA/PMD control register */
+#define MDIO_B10L_PMA_CTRL	2294	/* 10BASE-T1L PMA control */
+#define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
+
+/* PCS registers */
+#define MDIO_PCS_EEE_ABLE	20	/* EEE Capability register */
+#define MDIO_PCS_EEE_ABLE2	21	/* EEE Capability register 2 */
+#define MDIO_PCS_EEE_WK_ERR	22	/* EEE wake error counter */
 #define MDIO_PCS_10GBX_STAT1	24	/* 10GBASE-X PCS status 1 */
 #define MDIO_PCS_10GBRT_STAT1	32	/* 10GBASE-R/-T PCS status 1 */
 #define MDIO_PCS_10GBRT_STAT2	33	/* 10GBASE-R/-T PCS status 2 */
+#define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
+
+/* PHY XS registers */
+#define MDIO_PHYXS_LNSTAT	24	/* PHY XGXS lane state */
+
+/* Auto_negotiation registers */
+#define MDIO_AN_ADVERTISE	16	/* AN advertising (base page) */
+#define MDIO_AN_LPA		19	/* AN LP abilities (base page) */
 #define MDIO_AN_10GBT_CTRL	32	/* 10GBASE-T auto-negotiation control */
 #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
-#define MDIO_B10L_PMA_CTRL	2294	/* 10BASE-T1L PMA control */
-#define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
-#define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
-#define MDIO_PMA_PMD_BT1	18	/* BASE-T1 PMA/PMD extended ability */
+#define MDIO_AN_EEE_ADV		60	/* EEE advertisement */
+#define MDIO_AN_EEE_LPABLE	61	/* EEE link partner ability */
+#define MDIO_AN_EEE_ADV2	62	/* EEE advertisement 2 */
+#define MDIO_AN_EEE_LPABLE2	63	/* EEE link partner ability 2 */
+#define MDIO_AN_CTRL2		64	/* AN THP bypass request control */
 #define MDIO_AN_T1_CTRL		512	/* BASE-T1 AN control */
 #define MDIO_AN_T1_STAT		513	/* BASE-T1 AN status */
 #define MDIO_AN_T1_ADV_L	514	/* BASE-T1 AN advertisement register [15:0] */
@@ -79,7 +86,6 @@
 #define MDIO_AN_T1_LP_L		517	/* BASE-T1 AN LP Base Page ability register [15:0] */
 #define MDIO_AN_T1_LP_M		518	/* BASE-T1 AN LP Base Page ability register [31:16] */
 #define MDIO_AN_T1_LP_H		519	/* BASE-T1 AN LP Base Page ability register [47:32] */
-#define MDIO_PMA_PMD_BT1_CTRL	2100	/* BASE-T1 PMA/PMD control register */
 
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
 #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
@@ -89,7 +95,7 @@
 #define MDIO_PMA_LASI_TXSTAT	0x9004	/* TX_ALARM status */
 #define MDIO_PMA_LASI_STAT	0x9005	/* LASI status */
 
-/* Control register 1. */
+/* Generic control 1 register. */
 /* Enable extended speed selection */
 #define MDIO_CTRL1_SPEEDSELEXT		(BMCR_SPEED1000 | BMCR_SPEED100)
 /* All speed selection bits */
@@ -97,15 +103,6 @@
 #define MDIO_CTRL1_FULLDPLX		BMCR_FULLDPLX
 #define MDIO_CTRL1_LPOWER		BMCR_PDOWN
 #define MDIO_CTRL1_RESET		BMCR_RESET
-#define MDIO_PMA_CTRL1_LOOPBACK		0x0001
-#define MDIO_PMA_CTRL1_SPEED1000	BMCR_SPEED1000
-#define MDIO_PMA_CTRL1_SPEED100		BMCR_SPEED100
-#define MDIO_PCS_CTRL1_LOOPBACK		BMCR_LOOPBACK
-#define MDIO_PHYXS_CTRL1_LOOPBACK	BMCR_LOOPBACK
-#define MDIO_AN_CTRL1_RESTART		BMCR_ANRESTART
-#define MDIO_AN_CTRL1_ENABLE		BMCR_ANENABLE
-#define MDIO_AN_CTRL1_XNP		0x2000	/* Enable extended next page */
-#define MDIO_PCS_CTRL1_CLKSTOP_EN	0x400	/* Stop the clock during LPI */
 
 /* 10 Gb/s */
 #define MDIO_CTRL1_SPEED10G		(MDIO_CTRL1_SPEEDSELEXT | 0x00)
@@ -116,10 +113,29 @@
 /* 5 Gb/s */
 #define MDIO_CTRL1_SPEED5G		(MDIO_CTRL1_SPEEDSELEXT | 0x1c)
 
-/* Status register 1. */
+/* PMA/PMD control 1 register. */
+#define MDIO_PMA_CTRL1_LOOPBACK		0x0001
+#define MDIO_PMA_CTRL1_SPEED1000	BMCR_SPEED1000
+#define MDIO_PMA_CTRL1_SPEED100		BMCR_SPEED100
+
+/* PCS control 1 register. */
+#define MDIO_PCS_CTRL1_LOOPBACK		BMCR_LOOPBACK
+#define MDIO_PCS_CTRL1_CLKSTOP_EN	0x400	/* Stop the clock during LPI */
+
+/* PHY XS control 1 register. */
+#define MDIO_PHYXS_CTRL1_LOOPBACK	BMCR_LOOPBACK
+
+/* AN control register. */
+#define MDIO_AN_CTRL1_RESTART		BMCR_ANRESTART
+#define MDIO_AN_CTRL1_ENABLE		BMCR_ANENABLE
+#define MDIO_AN_CTRL1_XNP		0x2000	/* Enable extended next page */
+
+/* Generic status 1 register. */
 #define MDIO_STAT1_LPOWERABLE		0x0002	/* Low-power ability */
 #define MDIO_STAT1_LSTATUS		BMSR_LSTATUS
 #define MDIO_STAT1_FAULT		0x0080	/* Fault */
+
+/* AN status register. */
 #define MDIO_AN_STAT1_LPABLE		0x0001	/* Link partner AN ability */
 #define MDIO_AN_STAT1_ABLE		BMSR_ANEGCAPABLE
 #define MDIO_AN_STAT1_RFAULT		BMSR_RFAULT
@@ -172,7 +188,7 @@
 #define MDIO_DEVS_VEND1			MDIO_DEVS_PRESENT(MDIO_MMD_VEND1)
 #define MDIO_DEVS_VEND2			MDIO_DEVS_PRESENT(MDIO_MMD_VEND2)
 
-/* Control register 2. */
+/* PMA/PMD control 2 register. */
 #define MDIO_PMA_CTRL2_TYPE		0x000f	/* PMA/PMD type selection */
 #define MDIO_PMA_CTRL2_10GBCX4		0x0000	/* 10GBASE-CX4 type */
 #define MDIO_PMA_CTRL2_10GBEW		0x0001	/* 10GBASE-EW type */
@@ -193,17 +209,21 @@
 #define MDIO_PMA_CTRL2_2_5GBT		0x0030  /* 2.5GBaseT type */
 #define MDIO_PMA_CTRL2_5GBT		0x0031  /* 5GBaseT type */
 #define MDIO_PMA_CTRL2_BASET1		0x003D  /* BASE-T1 type */
+
+/* PCS control 2 register. */
 #define MDIO_PCS_CTRL2_TYPE		0x0003	/* PCS type selection */
 #define MDIO_PCS_CTRL2_10GBR		0x0000	/* 10GBASE-R type */
 #define MDIO_PCS_CTRL2_10GBX		0x0001	/* 10GBASE-X type */
 #define MDIO_PCS_CTRL2_10GBW		0x0002	/* 10GBASE-W type */
 #define MDIO_PCS_CTRL2_10GBT		0x0003	/* 10GBASE-T type */
 
-/* Status register 2. */
+/* Generic status 2 register. */
 #define MDIO_STAT2_RXFAULT		0x0400	/* Receive fault */
 #define MDIO_STAT2_TXFAULT		0x0800	/* Transmit fault */
 #define MDIO_STAT2_DEVPRST		0xc000	/* Device present */
 #define MDIO_STAT2_DEVPRST_VAL		0x8000	/* Device present value */
+
+/* PMA/PMD status 2 register */
 #define MDIO_PMA_STAT2_LBABLE		0x0001	/* PMA loopback ability */
 #define MDIO_PMA_STAT2_10GBEW		0x0002	/* 10GBASE-EW ability */
 #define MDIO_PMA_STAT2_10GBLW		0x0004	/* 10GBASE-LW ability */
@@ -216,27 +236,29 @@
 #define MDIO_PMA_STAT2_EXTABLE		0x0200	/* Extended abilities */
 #define MDIO_PMA_STAT2_RXFLTABLE	0x1000	/* Receive fault ability */
 #define MDIO_PMA_STAT2_TXFLTABLE	0x2000	/* Transmit fault ability */
+
+/* PCS status 2 register */
 #define MDIO_PCS_STAT2_10GBR		0x0001	/* 10GBASE-R capable */
 #define MDIO_PCS_STAT2_10GBX		0x0002	/* 10GBASE-X capable */
 #define MDIO_PCS_STAT2_10GBW		0x0004	/* 10GBASE-W capable */
 #define MDIO_PCS_STAT2_RXFLTABLE	0x1000	/* Receive fault ability */
 #define MDIO_PCS_STAT2_TXFLTABLE	0x2000	/* Transmit fault ability */
 
-/* Transmit disable register. */
+/* PMD Transmit disable register. */
 #define MDIO_PMD_TXDIS_GLOBAL		0x0001	/* Global PMD TX disable */
 #define MDIO_PMD_TXDIS_0		0x0002	/* PMD TX disable 0 */
 #define MDIO_PMD_TXDIS_1		0x0004	/* PMD TX disable 1 */
 #define MDIO_PMD_TXDIS_2		0x0008	/* PMD TX disable 2 */
 #define MDIO_PMD_TXDIS_3		0x0010	/* PMD TX disable 3 */
 
-/* Receive signal detect register. */
+/* PMD receive signal detect register. */
 #define MDIO_PMD_RXDET_GLOBAL		0x0001	/* Global PMD RX signal detect */
 #define MDIO_PMD_RXDET_0		0x0002	/* PMD RX signal detect 0 */
 #define MDIO_PMD_RXDET_1		0x0004	/* PMD RX signal detect 1 */
 #define MDIO_PMD_RXDET_2		0x0008	/* PMD RX signal detect 2 */
 #define MDIO_PMD_RXDET_3		0x0010	/* PMD RX signal detect 3 */
 
-/* Extended abilities register. */
+/* PMA/PMD extended ability register. */
 #define MDIO_PMA_EXTABLE_10GCX4		0x0001	/* 10GBASE-CX4 ability */
 #define MDIO_PMA_EXTABLE_10GBLRM	0x0002	/* 10GBASE-LRM ability */
 #define MDIO_PMA_EXTABLE_10GBT		0x0004	/* 10GBASE-T ability */
@@ -249,7 +271,7 @@
 #define MDIO_PMA_EXTABLE_BT1		0x0800	/* BASE-T1 ability */
 #define MDIO_PMA_EXTABLE_NBT		0x4000  /* 2.5/5GBASE-T ability */
 
-/* PHY XGXS lane state register. */
+/* 10G PHY XGXS lane status register. */
 #define MDIO_PHYXS_LNSTAT_SYNC0		0x0001
 #define MDIO_PHYXS_LNSTAT_SYNC1		0x0002
 #define MDIO_PHYXS_LNSTAT_SYNC2		0x0004
-- 
2.35.1.1320.gc452695387.dirty

