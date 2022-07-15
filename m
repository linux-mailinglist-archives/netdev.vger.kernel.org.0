Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F5C576995
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiGOWE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiGOWDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:30 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60048.outbound.protection.outlook.com [40.107.6.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372FD8E1F5;
        Fri, 15 Jul 2022 15:01:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OruaT6+gWP3FnVEmZw+Nwyk7wwCdSqlJQHRXpS/RvQjUwWUAwEKn893k7f9zil7X7jFvtGNIQ/lV+DaYuip/iUvObZPU86CPghbBFpNGM9y0Rl0w1N88YXUUZIE0joFMB4OwfWVosPThEJkMjWaYhKTRgpQ85fAk+hmdF+JvjrNrkZgZJAfEgkM52aS/HZ0pdgMqy10DuB+3NfTWEmbQLF16V5VVJV5R7uNT3pSxgk8zqMQHtasEr5zjkKPoFvcF/53Dzlpk4LvJfVJ5C/hXLrcA7A5S4YrR3VnEQDbhmdHbnIcXBucb4OMMuI8AsEEy33DPk/Q2S/Nret/7ukvsvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qd7EzQyq3QvpjHXKrDtvYwf5S4MGKCtL3v+EBh//8M=;
 b=eaiXxHmvsTOYjMKby9Eqa9a3rwk+P9twm7tG3rD3sScbjwpq5Iq/j1sMurZHI161XRbEjcOyNIbMVb8sK8ppPTaCn1DBXECovojKJXcgXzpom7b5ABU2JSWAQQwDIWXOSS8X9xDZuNnqA4ITnMdvEtDdHQ1P3BTwqyXM1HedvZ7DzgHQ4QtOsKh7yR6/jpEFD7cMduQCQVdNWIO9sdCksNdQSPHbPBAqHqJHZ5dtHjr8eMJrL8kd73e/0iwvQMl0LMIkxbvjeMtMTevDm6nvqoOy6suX0sJsBMHZtClOnnSGqtO+Gslk8uMfg5qbdA/Uvd8W0BSq8e5TEeEunOAF7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qd7EzQyq3QvpjHXKrDtvYwf5S4MGKCtL3v+EBh//8M=;
 b=IZvrN9qZ0ZD7ATSa4UJmuCGgtK0Eho9Mua33/ZuRHmldveCCCOhoD30teyXqef46pHzpIkk5jhV+mI9NyYNFV6ylwFquZoKewomGpk7dw03xA5+Hwe3AdD1vZvdWPFxRnA8jgerv1L1FyktP1VU6XnsN+QA+2hbN4nLccJDLYqZb/tJMNTBx1m2iPCc6PlEh15qIl0l7waoltNWGaV4NXjZOJTrDr7Yp5yv2cSc/5JKM0r5NbNGN9xi96MRl4ogUIhZ3VfhoMuY+XBpgMGtIqQru4o1H2XlV2kPnjQzprQ/A0Ps3ca4X1DSCC2lPrTPsndC7ylc1sp9jTTiLNqP/3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:14 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:14 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 27/47] net: fman: Inline several functions into initialization
Date:   Fri, 15 Jul 2022 17:59:34 -0400
Message-Id: <20220715215954.1449214-28-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b2a055f-7a3d-40e3-0819-08da66ad8958
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C42+Y/N3L0pFJ1OhRJOwrNFjVievITWv4kbr7BYR1zRK+dkRZe/8DFpC5e16HGmCRCMKBSCOLsiTfocVZGMzTI0rYO8b6K+4R5CAG5DwWPDYPAfPk5SQW+lRXWalfB5OcXjhADPElRWgFJGwkGwiOfv0qPcamaoKyjVXaX613UAojOn6pzxi653NOY8yO4GPCECJruMn4x3sbl1XqE1ANPqxfzKneEX1S6R9LKSthxMZ7ZaHch/PshTBtZPkQ0/wPAnqYyWuM3RakX9PLRhw8w0As/TAUy4qb8e4tWsOJOqmV381Qmj8J8hCi6G+szByFcQxiPRVx/0vrgFazAGTPZjoNmiMrWqV53nc2d8ZKxiXOqXkVA6NzbMUh+yeBbzfC2Zb1AlJR4MDhpY8TrIC4cAX1quWNl7p2Xld0Lwu05LtwkjUQmiyfQcDK2FXrjWCEHNVRgzsP6pqJ9p+Pce1CykOdTcL8QMQacTUqs9fYLqE+KZ0L/HQ7oXLlo5cqQfeUwqdI1sEDmnUuvc0XBbDAl9YNMz5p2ad/xWzhCC3EMbrcLf9HKXzu0yAI1CifvclYvhhZ34r8/NPV9LL7+rdQaUxDZs7prkysE7opvkiT5xOxgSHgn2IoQcxMIeN9WCenglnhNZCCLB23/w39xFa4RiPhjyreFkM1N01CFV7Hzd7NtRYhYqUgAQCGqnuqy27eNoahud1bGmyQ9egOggkJX6uR39qEaS2ZqIyd0z0fxW97A3m/supIqLDvoF3iRsEW6NXwL0LbLdp6pLcBGqb0qDGS0BauTsD11ZstXLTvCEgXE6nDR27OrVMpLrC3xFv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VmX1B9V4lEvLkOZNA5cPqppNzbSoxG/Y+3qZhDsvVyQoCN0Ahmu2WNAGl8n5?=
 =?us-ascii?Q?R1+LlMWKVZMWfompicY4gKrkcpfTc/CjbbPCx2eMp/2Eh/y2wSulEQs92hLY?=
 =?us-ascii?Q?EkADfvmVtFmmDNBLdzycNF79/kUg3E++b8oDNZiYRFcBE2can1Ro58KSP63y?=
 =?us-ascii?Q?/Kea4xXB9ZpEZwv8deYJ+HYiYGbV7SoCVUJAs1K3TEk9t8yjfY/IZ0DO7x1T?=
 =?us-ascii?Q?8Ho1bGZOxHcYq++wgVi3D+5fs+Mjnh2pgzvhjd8bEw6DTgZYUIVsEqeJGZ+S?=
 =?us-ascii?Q?qR5EyTLHpr5jSSmVWexT7B7szyY5hQ68sUIf44+jRx82JzWV2f1ZYzME+PJS?=
 =?us-ascii?Q?NVpfD1E7+wUDAeB3Wd6RV0EttrV9cPAIioxz69qiNpp+AKprK9KLmpLau17v?=
 =?us-ascii?Q?6SiPTEFJye68P+MlxIBcleQAKYylAuVNgIGNyaZFT/FvqWIwLEL5+DIApKyk?=
 =?us-ascii?Q?M698AclE6cF8cgNA+VbfecZDSjGwJuuVSJKoA4WApz+qZ4O0sFnm2/xJvfUd?=
 =?us-ascii?Q?sMZVsqB0uR+Fb+EL+Zpi23xTmUx9okhWYxlDyq54zH4fll1DM+vJmgl6cb9T?=
 =?us-ascii?Q?+lTtStRE0DsDLL+w4EfPqi433v+D6TrrqScq8EWNSsmamvqoXWHmGzZtzLNd?=
 =?us-ascii?Q?5O4aUW1b4r5+V5LWSNuu2Ttef3H0+jJqJkHKa0eCCbg2Sqs4f04FUFWdEWPz?=
 =?us-ascii?Q?3C+/AGEVf14KHypxROpXDSWT9WL06axTa82gmY/RTJF4xRV0iO925a7qb6kp?=
 =?us-ascii?Q?4/PGjYncGwlBRRrTGO7wQDlOxlnAK/8kTD6IXtZTwP3pl4BpyjVGxfwmBSiO?=
 =?us-ascii?Q?YYZJoZLbnOvPgZ71vZgSAZ7oUBrluH5Yc8icUrUc0lcnw9RTzOnp2twnV7oY?=
 =?us-ascii?Q?uv2z9w9dXDBJif4rPyea/2+Ks7zft9xSAXw56Uidgze3gXvGH5TDdNzh/1hd?=
 =?us-ascii?Q?yOiSD/nCYNfnRh4RwKopG7XJzmAQe4to7BuCEE2Rkc9ofqf+MU8NFQQ0sjKP?=
 =?us-ascii?Q?aKS/wrnmd5DOLBajD29ltkfwbgL+OX4dmwS2mXBxDyFRJ+2uv4ryY6zhEfoM?=
 =?us-ascii?Q?Jb1xflHaB9Dw6FZhCB9W6cnJY4oHYzFiFjM52zZzz1FDtARcXR0TLEqNnNH7?=
 =?us-ascii?Q?QZKVeufpGUg+zVxmy6xs/ZjqqIsHhibJmjIh3a9n/hsYb5RVuN8gpTFrH1b8?=
 =?us-ascii?Q?H1DR9iIHVu8LnEI47ff7r73R+tsUQw/NDtTYbXEz0IMuDbS4L2K/Lq9LskNc?=
 =?us-ascii?Q?h/yADCsVPb4aWCkVOzAiPvtTR1RxNkOmKCLYMyWjudt64giEKVsmcTMc53G2?=
 =?us-ascii?Q?LKvdH3BU5MlAONiCSMMZCmt9ix6+6VxjBemQ+ES8jy3gPtISeknA0KJtRwb5?=
 =?us-ascii?Q?Ccq1/Lm3S2Afyl/RKOmuBV3Y1T/qRGzIG1JCEb0a06f4E/H0DwwDCDRrhMTZ?=
 =?us-ascii?Q?JWWy9xbFE59xpAGYWDe1WlDmJ3XkeRhbchpceB7GZ3SgsPu6Ivamu/R6MTFb?=
 =?us-ascii?Q?nxi/D+o45zfAlXOu15nAlmE2xwry/+Bx1mtXKg1ufhyOl4m6dhds8yTddV6S?=
 =?us-ascii?Q?QEhdel3Gok7lsGwSAXD/4lKa4/dtSWO8WT2uYwI9udLOHudjwarLwWsbR9mv?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b2a055f-7a3d-40e3-0819-08da66ad8958
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:14.8000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ur1uIDifC2w3D0NwMtwEJ0Qi2axkNJFONAsg1GEK9PehBeYk8gnJZvmOyvKZEsHuEMfwfh7EiMu82QxPJNkxRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several small functions which weer only necessary because the
initialization functions didn't have access to the mac private data. Now
that they do, just do things directly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 59 +++----------------
 .../net/ethernet/freescale/fman/fman_memac.c  | 47 ++-------------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 43 +++-----------
 3 files changed, 21 insertions(+), 128 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 6991586165d7..84205be3a817 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -814,26 +814,6 @@ static void free_init_resources(struct fman_mac *dtsec)
 	dtsec->unicast_addr_hash = NULL;
 }
 
-static int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
-{
-	if (is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	dtsec->dtsec_drv_param->maximum_frame = new_val;
-
-	return 0;
-}
-
-static int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
-{
-	if (is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	dtsec->dtsec_drv_param->tx_pad_crc = new_val;
-
-	return 0;
-}
-
 static void graceful_start(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -1274,18 +1254,6 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 			err);
 }
 
-static int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
-{
-	struct dtsec_regs __iomem *regs = dtsec->regs;
-
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	*mac_version = ioread32be(&regs->tsec_id);
-
-	return 0;
-}
-
 static int dtsec_set_exception(struct fman_mac *dtsec,
 			       enum fman_mac_exceptions exception, bool enable)
 {
@@ -1525,7 +1493,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 {
 	int			err;
 	struct fman_mac_params	params;
-	u32			version;
+	struct fman_mac		*dtsec;
 
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
 	mac_dev->change_addr		= dtsec_modify_mac_address;
@@ -1552,34 +1520,25 @@ int dtsec_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_init(mac_dev->fman_mac);
+	dtsec = mac_dev->fman_mac;
+	dtsec->dtsec_drv_param->maximum_frame = fman_get_max_frm();
+	dtsec->dtsec_drv_param->tx_pad_crc = true;
+	err = dtsec_init(dtsec);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
 	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
+	err = dtsec_set_exception(dtsec, FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	err = dtsec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
+	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n",
+		 ioread32be(&dtsec->regs->tsec_id));
 
 	goto _return;
 
 _return_fm_mac_free:
-	dtsec_free(mac_dev->fman_mac);
+	dtsec_free(dtsec);
 
 _return:
 	return err;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index d3f4c3ec58c5..039f71e31efc 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -792,37 +792,6 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 			err);
 }
 
-static int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->max_frame_length = new_val;
-
-	return 0;
-}
-
-static int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->reset_on_init = enable;
-
-	return 0;
-}
-
-static int memac_cfg_fixed_link(struct fman_mac *memac,
-				struct fixed_phy_status *fixed_link)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->fixed_link = fixed_link;
-
-	return 0;
-}
-
 static int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 				     u16 pause_time, u16 thresh_time)
 {
@@ -1206,6 +1175,7 @@ int memac_initialization(struct mac_device *mac_dev,
 	int			 err;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
+	struct fman_mac		*memac;
 
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
@@ -1235,13 +1205,9 @@ int memac_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
+	memac = mac_dev->fman_mac;
+	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
+	memac->memac_drv_param->reset_on_init = true;
 
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
@@ -1271,10 +1237,7 @@ int memac_initialization(struct mac_device *mac_dev,
 		fixed_link->asym_pause = phy->asym_pause;
 
 		put_device(&phy->mdio.dev);
-
-		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
-		if (err < 0)
-			goto _return_fixed_link_free;
+		memac->memac_drv_param->fixed_link = fixed_link;
 	}
 
 	err = memac_init(mac_dev->fman_mac);
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index ca0e00386c66..32ee1674ff2f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -441,16 +441,6 @@ static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 	return 0;
 }
 
-static int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
-{
-	if (is_init_done(tgec->cfg))
-		return -EINVAL;
-
-	tgec->cfg->max_frame_length = new_val;
-
-	return 0;
-}
-
 static int tgec_set_tx_pause_frames(struct fman_mac *tgec,
 				    u8 __maybe_unused priority, u16 pause_time,
 				    u16 __maybe_unused thresh_time)
@@ -618,18 +608,6 @@ static void adjust_link_void(struct mac_device *mac_dev)
 {
 }
 
-static int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
-{
-	struct tgec_regs __iomem *regs = tgec->regs;
-
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
-	*mac_version = ioread32be(&regs->tgec_id);
-
-	return 0;
-}
-
 static int tgec_set_exception(struct fman_mac *tgec,
 			      enum fman_mac_exceptions exception, bool enable)
 {
@@ -809,7 +787,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 {
 	int err;
 	struct fman_mac_params	params;
-	u32			version;
+	struct fman_mac		*tgec;
 
 	mac_dev->set_promisc		= tgec_set_promiscuous;
 	mac_dev->change_addr		= tgec_modify_mac_address;
@@ -835,26 +813,19 @@ int tgec_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_init(mac_dev->fman_mac);
+	tgec = mac_dev->fman_mac;
+	tgec->cfg->max_frame_length = fman_get_max_frm();
+	err = tgec_init(tgec);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
 	/* For 10G MAC, disable Tx ECC exception */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_10G_TX_ECC_ER, false);
+	err = tgec_set_exception(tgec, FM_MAC_EX_10G_TX_ECC_ER, false);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	err = tgec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	pr_info("FMan XGEC version: 0x%08x\n", version);
-
+	pr_info("FMan XGEC version: 0x%08x\n",
+		ioread32be(&tgec->regs->tgec_id));
 	goto _return;
 
 _return_fm_mac_free:
-- 
2.35.1.1320.gc452695387.dirty

