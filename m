Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297DB5988B9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344701AbiHRQTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344606AbiHRQRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:51 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB67BD0AA;
        Thu, 18 Aug 2022 09:17:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rx49yWR6/9RXa62SrQc9ozCIcyJTwpdxGpv99cn2IhoZM0WU0b9ZFAhiaPCgkMkVEXSh5KVyf521jZdZR2NPPkFUGxhp+0a4FJl01rGI1kB4BpSnJX68oHBJVv0o49mXrv+gMLBiSepofmo26WpVR2FneMnevo67JcUjtr8akeqNm6b4aMf2pVOP9Dl2rHDad4dZ/B7+pBYJRViMjAZv1+/9TfuWpIgWPgm5RagYiYR5l3SMbHVbebVnVY7+WFgTx2LLRjPcXQWfmnxRzrvctvjB8qxP9ErEkd60KtPWvggeSmkYqn3jhZ6YVbLBNzyd6MXIDSi9zrYue/ROpmMdIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTBd+07Ajx0H/fMKM+/8gZo/u28GTYMgGRAlmycrARs=;
 b=WAkybG2FN+jpmaiWkC8m7zp+BaSdxdEVvCIdwxtXeXEGrdqWmvVXTmYa1YXu1kouiw5pLVpWYQv+O1Ys5kwCCYaYv3Yb9iWZrxPRVX6FmHv0nanV7euLLBClcN8odfRbERQH3A1TdI2IJItOeFOLO41FiLOr2CtKobTfeLZOo86Hm/+zRuAou7rDjHidrKtAXeVAfcW3HA9/9W3Hu1pYiSRmG3Nhzb0d894OridlhOqtJjO+mPupjPuS19cap0ljsg+dZL6k4BYjdhgxfUeG13RBS54d23ByMkGcdQAx3cMIZX0rlRz1DkwvbrhiA2mVxqKL7XFGfQm9qTlAQ3lm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTBd+07Ajx0H/fMKM+/8gZo/u28GTYMgGRAlmycrARs=;
 b=nylDPjKPpc2LneTXa0pnpI4jPIlNui11jZ3ZMw+sfPOj1zwyRPwMj8uGeczSsFzSbKlj4UKqPXGLR9chF8AnZlGEhJ4JAlxyvMunvoZEjOSWNzv752wqZn36G4nuv7GA+PsmXBKATejwd7UwY18lGn+KS/7kiR894qQHQT5RP5L3/FjCzsxfRMn0jSO3k4Y8Ksn8CzeL6TiYQahnH0em8xk9mPzhlPXdGQ+pM+XJ3Wd9aiHEYvDu4Lw23TjygeR0yeNe7iX6WAnmPfqECFxA5YHcgnXKV9lZ+nS1hXxi9uuGBJ2nKlS8VWONgMdSqXlt3vCvh06tOZzcpczcyrkvQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:28 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:28 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 14/25] net: fman: Inline several functions into initialization
Date:   Thu, 18 Aug 2022 12:16:38 -0400
Message-Id: <20220818161649.2058728-15-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 516a3c84-8215-40d4-3505-08da81352506
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+nCNC3jftX3f1EIGgnR7PzYK2dCemGs4F7rAdKinVLRUz1CpZ6y1xtBExtwL59uFV2ODQAcz0NjfiUTpg9XeY6NXQnnr80Bd/u6RETmGciH7DJ7m2bHoBDb5nq0GOnEH+zu1DVzWJTMLSP2xjUXknMHza9Pgk43URAyV/BEaf3Q/pegiA3yYkPXuLKQdl61KrzngR0ubMZ62hBfqHN919KLBNMIol9hm1dPFMbZlZl/40EZ2Gvh5+2OzTKjICUVrtTvavxZZfzUvzc356PCEH+i+GmTmzw12Xyt08Ra64hFjnDmudZdJqsgZWufeytLsdfBBB4A80+Oi9JyDRk0ofqLfQnj+PFaRTP5TJbEBLU63HhKnlTbvkpuvcTxnscKOa6tg6/2H+I9v24p8n3JuGJcmIx3lkWtXGyf0to0+9ODAaSQ1o6dfUYRGqFv+xuu9E7OGQBN7Mzv31f/8QN5VmoUSClfcTShTnI+coOh5kfF6wjx4T105CTq/VgDm2T7eMpie2aDNSrj3ZDfSuN3X2v/QRxbn/yOgzSnkeXWM6WVlENkiDOagUE9wAca/eyWoXDmeuFln+nbhv+URH2RG0NRZ9XHwSsDyZfwTlEAxG911WTumPXEi6lzg/n8/iGW4vUA1PhtaPAUHBt0B53XegdzgCQ32oWMp8eWP+5NPhW4qE1WqV0Kw6mcI4gEfFrAMWADbrW6vEPqM2P3PDf7OHZIhl1eLV2Pbz/7tbUfH9Xn8MXn05UKm31lRlu1l4apDXhWPI5lrc6IsgUvgS2reg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KLk6g0sTidE8Qsama0sHyBQyKHnchQGw08+etNw8WRerdDkA6hzcjeIQ5gZ6?=
 =?us-ascii?Q?DODlC3pEhFSg8IDvQzIdpt7lNVCAdT1XzA1zpPRjb4HTxEo5DimetK9NkX6i?=
 =?us-ascii?Q?yjkjzpDm+V2L0l4CuTXH/95sHGWz+czt1jCP44yiQp9kZp8bHBa/b9isUZ4T?=
 =?us-ascii?Q?Vh7LW4LZoXdXt5hwMNsn9Trcv/y5LmRvrR7X8v2pMG16kHL4HY8FXEoosvaF?=
 =?us-ascii?Q?smUJdFss/QwioNXK8+IPx9LS7jildyEvG/VkbsYo4JfmUGniomgv57AMLWmb?=
 =?us-ascii?Q?glmRmnFmJAPcF3q8t4htE4OQFbiwEWB/Ft6ieDTAGsNHuy1okfk4uDXMs5+7?=
 =?us-ascii?Q?ozkkUmY+efwqgbo9p+V4ASZxqFWNa4cfDNeIQPJ6g1Y7OoV3965g/zKy0sGJ?=
 =?us-ascii?Q?32CAL5QsSfItlIb7BgRLFn3NcSBtNmYp1Nri1SoLBHZlTp9yLVUfRMhmys0M?=
 =?us-ascii?Q?sXYXCV6qc14eLcqKLMaL1JBl/mlfZGAgAsxl3UvJIDnhiD15AtrMcizbyUxk?=
 =?us-ascii?Q?KvxNnOMeooZkXIGEXxDEvUw9X9KwXkCcaascuT9Vihgpt5X3eCPc6C8NL9hd?=
 =?us-ascii?Q?bRGz87wcQekLUbhFU3VkNlDBWpfshmFNCiJ9dXNUeBUmIgwtRuVOzhmavJ6B?=
 =?us-ascii?Q?+khlA7QdWRz1HRLVd76Xk3ahAz8+3AajnFYdYl2D00ZkHF0O/D6/+aT+qeLo?=
 =?us-ascii?Q?g8afHFObWwgMFuM4SGl9wstKYz3T4J3OZTX5TiZeJFv52nR0VhTxVqVj+tUm?=
 =?us-ascii?Q?2nVWYcR1HyCsq14cLAt4SUyuAvnk2Ar/1E7eMVUpaGe8AzszCS2q2CT/Ybwg?=
 =?us-ascii?Q?92hOwySEfNQGOqGmen+zJDX29m9OAy0LFdsSwRALG95czcnVqj/Ss492eGsi?=
 =?us-ascii?Q?jncxcTSsGgDRx2GLRhjq/lvQN+k0dWF8VXyWGlqFHlFKY6P+TrQFiHicoHIo?=
 =?us-ascii?Q?Oi/FL2cdDwb5R4Wp7WszJ0CWyJ7+V6UlWxB9ani6SpqdNb4++IS73eqwWEDo?=
 =?us-ascii?Q?aL2+GSQOgwrgDDz/RI4crzzlin1E0n7T8xumjxViucfDun9Q2dK0JJ4haVoL?=
 =?us-ascii?Q?6dUaDRPZunnrjY8tLWaqamuM+akfRBYsZ+b80R0LaMg4b64ouzL1FZWL1ZU4?=
 =?us-ascii?Q?0tW3M4dM4M4egeiXLtuHp6Xiwq1Rtqvu85hitvK3GKlM+ZTyb9hI9n1lg4P9?=
 =?us-ascii?Q?EHoK/j6u3B7PgKtT8ieMNaNqXDBFVryBXtmWl1OIg+dRLDPsTGmqXnkDQRq4?=
 =?us-ascii?Q?/lqc+/gFYdY9qRdENEHuEqNhYPMa9P1gm/7L//Ec7Loca7o1SvLadSCT3Tlb?=
 =?us-ascii?Q?+0puTcgR/s3L8YT986dZ1OEcZGM3xPNNdK6Ylzjd1dz+4/CKqIGAp25v7TPE?=
 =?us-ascii?Q?QGkeRiv6BkXHIBv4FPrasmvCJwVMT6kQ2DNqRlG0X0QJmKiEkV94AnhvAeOo?=
 =?us-ascii?Q?m879WkHsZELxo3GtWPd4S2ZM30IizZZhI92cJChg+F6PJ7+RwrkJPzF3c+Q8?=
 =?us-ascii?Q?9I5paMPaT+Q6JMSjh0A2JaVuisME13HKmW6nVOlqnc1c7CDN+sDUkvEfqe2X?=
 =?us-ascii?Q?NXfrxF0qoiwTERiBOjI2IvPbjhkJtOgnhWaJKymn4ejZFis8eI3IamM/zhAh?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 516a3c84-8215-40d4-3505-08da81352506
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:28.4978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YlLqcNXE6xAvQMmGm/HlJZOuQqOaMzGsxKjJXCM3/RLCWzjA4mbZg5rcXh72qwaL7z0BfA3F5MHpPLb60vp8Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several small functions which were only necessary because the
initialization functions didn't have access to the mac private data. Now
that they do, just do things directly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

Changes in v4:
- weer -> were

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

