Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2D45ABA70
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiIBV6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiIBV6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:19 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477EBFB0E8;
        Fri,  2 Sep 2022 14:58:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5eMySqUnZoitF17GEFJPrZ0oMnuUdFPBGTa/ROdYr5xuaQ4BEqJn3U1DP+QCre97JUcWDHctn8UAl2FpzQBYauuQHrgMzZ7iw9VwImevM6Pb0l0SeGHfyW+ISCaIraXTMNQrt3Fb78gLdLrwMzl/gYysRv4YHzskmnN+ECj0oPtKGrKWa/NfMAzZtl/QHWUq9oMWDYJYwFYhALSdxBhQM/CBCqhXFZlTWLpVY3SU6DctqFuy9f99Wf5x6uJnDkQAwHfniIMzFM0N4CuamhD0KyDuEyRi2nzjHNT54LMp/zsvOx1z4FIJzED9WSYN/mo5EOqMWoUzf5onBKWAI7gsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOR3if54A6X5VAfYoNFEwrmCWpwdssdCPzhpYtyRIs8=;
 b=MvGjXY8M02WW2O/YZHwNJsUawQXpStRdHv1mloRpMhBJJALqH9PJ4V6VltmHRhS/XdTDgrzIIRU+dzZB1f3CXP4Q+r+PGLub5KLz22gaF6YEXcnRdA49ffBYdb/BnB++iTIDJSHdBnb6upkAYvwbsxaU97lLZMUuB1nUgoblWZmUT7cD6j6p55Lf/c7gb2bJzh28PNn4kO/g8p8uM4Vivo9nKeFaCiH9QUSj94JUj7eZMSPIzrcgdCxIht5NpRMhm0hQdV4duTQeonBFmGfF21PfgfU1lhuzKgNDm1K2W44nqp6E/AB6mk/vUNl1A7/mO2CHZXOiWRC4D3tTl/GgyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOR3if54A6X5VAfYoNFEwrmCWpwdssdCPzhpYtyRIs8=;
 b=Xqt00V7CCyP9QrJ6X9x7r2gIUBxQdIebGeHv6pndcqCLovABNXDoNnkDFTaSFVal503XeLF/burA48TQ1fkPjQZS4GFDiC8HGWOeKjxk5qC9COGOtVN4nH06npwlHmO+TUKzGVXvUHmnrRlOCn/lWE2SEFZV9TB0WOr6RkoD1RDoSWPLfYJB8geiKQL9oCpUTc20nG/YkX6ohjByrf5Id6UEhg3SPxrVQ+OQyaamKw/w0r+EiHv3m3FvcFKJ3woRMOMACTEjmgfFM0ZN5SKuhBLU4ixEkLH2jPl/hFtIxJsz2pO2Tg/VooW4Vs6uvJ4AW4Fs9JIykr22/r+fxB60Hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:57:52 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:57:52 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 02/14] net: fman: Mark mac methods static
Date:   Fri,  2 Sep 2022 17:57:24 -0400
Message-Id: <20220902215737.981341-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b777966-2b17-4549-f122-08da8d2e2e9a
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYv8kLGMUKy/L7hGJoBPJO7PH+C4NJIgHKBWe253H9233yi0zpq18o9VsbzS+r/KjfWsYkSfNN/wGn7jGwavNkdw95bEahQFejnJ9G4m6HQzw+EcK+3hPS/M8WaockPZO0TYTBIZweF19o9Ym65vtOUSksKzF2aO2SYp1OQNw6sgTu0srOEdcvtKVmkd3bynpfe1WIK7mxlULoBtl9hAglvUelUR9C94GspLUmp5s6YWiYWPevzNkSlsz5AbINaPLXXuFNHUDjzfIXM/Gk2kpqRr1f1i6uWJ6QQq11TByZhx6qx7e/hWYngtKbDrtv+ohDPY4VjRXIcO2OwJeIeQ0zlR44LOCmTo1Po2mCkOIerYG3RmIE5AEg72Vjp8cTev0QsDapsN0drh/B9Nqcle82YsgIIYHL98X8Hspq0U2a9xGugJMVZ2Wdc05yyd7CeoDQZuzDwyrKevw+57iz/l2GxuTH+rLDDp6HlFOWP5gbVR/RgmH4FoPagDNgzVVv/kVCgwJ6KypgCvYgntoRZrG3ni32SXJzi3i/2bCDvjdD2tveio2kZMkWIowy+nZnQ/PJ9xF0ltub87+bSlyWXh6+JjuCfpz2Cww6on+VGxNkg5iDgdxV7tM7RvNPx5VqyUUncK01f5L/wUqiO6xUlC4arLeST8VIGU8JLNtxtBdAtO+bVgaP7fVakuVe0F4Nc76znZuq3zpD1/q+j8tGfu60sN7W1xdNm32sEzhBln14r/oIF1bEQQ+SpEHjBxo7aGbxnCb3oagBo1W14NeXzxxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(30864003)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hH1uP7PGVXVf52uqxrpaBwFf7Z6ZuRFTWzxhGvzv77d14IA1MxdwtUInXoRF?=
 =?us-ascii?Q?yDD1/J1oyI6UVoHyAWlPK4aYwkGKjIuyfHgTeedXXXSPa27RCxnIh6Pyv/EG?=
 =?us-ascii?Q?iSVjK2EIvOu2D3DF8B0blAHn4HcYjZRbUzVWRGDHLMLZk/CIhzAu1vUPr1He?=
 =?us-ascii?Q?8Ko+qX2kcc6xG3xqXoM6mbmZvuD9z0hNVPFiT3L8co/co5gjtOs7xA3JSMk3?=
 =?us-ascii?Q?whAxIYlkNDBd889aqXgOIhsvi/AoE1up0E6K0y/x+G77b5yL2StQ2zWNd9H1?=
 =?us-ascii?Q?peX8jq8KZcuBnq9V9RlfJ/tFYb1NYEl/AKTCC+2B9hHBGklzWlbWeSPOHyYz?=
 =?us-ascii?Q?RMvC+HhHHIM93/rUlJ0pi2CLyPIt0pfR/ZDhj+PmcRXdUZqbTMiWeClLJ3BB?=
 =?us-ascii?Q?dNAduRlWDJymDV5UN7bvDtlnA2EfpFpgBUeE6GxL9prdqR4Qm7YNLAwbsXt9?=
 =?us-ascii?Q?3PZeBjuUU+IIzPW5IXJ1rEHHtrAccMtY2tegCnaeBZdnORCoyqnVg7Ot2Gcc?=
 =?us-ascii?Q?ygCFY2qICBSEWa4L0/UB2eNunGSWkf5eSPKrUrpNxqOxSF6mceSKXJcUscEY?=
 =?us-ascii?Q?pZjzMdleA+8KyTBabmoI20kLtYPTqSsVobUKQa5Wj+XjZI0ham+HGRQooF0q?=
 =?us-ascii?Q?+Jq6xc01QFDeS4bxDNXDmeS2nbuNrzNGO57Q17kISUnWXBI28QosImSwiQ0/?=
 =?us-ascii?Q?EUXK9gLyBbFQlyMx54rS2blPYLQXz9kW/Ab5C23RGHZIRiIDMgetpb+LiqLZ?=
 =?us-ascii?Q?9WvxYTpuJWImbBzxILG/5YqICj+ItaeiH9w7NlhPXXf2euPEF+2ih0fw6mID?=
 =?us-ascii?Q?2hDOfx7dqqbrKsOVciYkjK9JybuOM2KTfnr6UizS0EIaCoPvS40B0wAqyB/F?=
 =?us-ascii?Q?PyIihZmiQ5WruDm8P+Q0R2L/7B//VbpAL010DLZMoSczsFeprWUdIQFvhwhl?=
 =?us-ascii?Q?UNK9Vy4QS7Ie2HAu06M7yQYd6w7zRXTN3Lybbudbdtx10895mEe3rhuJ3nci?=
 =?us-ascii?Q?5JQjGhe3paGZaKEmWJ+XVL+Tuud9wgmXU3FR06vSFzfUoIKkIaEKZKVig7Hk?=
 =?us-ascii?Q?loED47GnwBp9pt3UP7kER1wc9Ng3tyKY7QvjwLHOFXOYN5AiN5UdvEnprUnr?=
 =?us-ascii?Q?9mhs+PMbgif08VT6SIqeXl908ikXWWjHJlS9jgjA8/HnNQDxTREQMXgB6F7+?=
 =?us-ascii?Q?zd1Bt1SRlJTSP0jooNKM0+hUXVQByUd8vIS0wi5pQjKBp+jRa5ra4gKmCHjT?=
 =?us-ascii?Q?v4F7uEAl92ebPoM5OlY7n5YpAPKqByah+XMxqx2mFfF2ezyFulZwxbymLfl7?=
 =?us-ascii?Q?b/sCXLS3M1f2nPDu4NFmphVDHwanGrdv1sIEQe13YMCvBlN/XwfUM3bTZ3In?=
 =?us-ascii?Q?IlUOmSO87PqwcujIJjzYAy10moJ3Kh3jE2rVb4l/My5Lz2s7x6HHYWowsIvW?=
 =?us-ascii?Q?hF012Bk2nLY6xt3wx5acupxaJVCFlWD/bKfoynaKDdwzAzGPucSk3foM0Mnt?=
 =?us-ascii?Q?oreJw4Ed+A5hZUU0LfZJgL9M7N85/MB7E5w5yaeuibARSZ6jLHqWzybJDDIU?=
 =?us-ascii?Q?mtg2HPspccXceQVyS+ohZ6QF8xAPkwagk5eVenFeFpMaeyvgwfvbgQPmbgH+?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b777966-2b17-4549-f122-08da8d2e2e9a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:51.9077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: opQEWUXNv6B6HBGmpVGwXxoHwGqRvrCPHg7J9sYvrFkc7iq1iqS4kLuW0gYxv39DIOZGRVzro9syzSLFd4q+bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These methods are no longer accessed outside of the driver file, so mark
them as static.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 48 ++++++++++---------
 .../net/ethernet/freescale/fman/fman_memac.c  | 45 +++++++++--------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 40 +++++++++-------
 3 files changed, 72 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 92c2e35d3b4f..6991586165d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -814,7 +814,7 @@ static void free_init_resources(struct fman_mac *dtsec)
 	dtsec->unicast_addr_hash = NULL;
 }
 
-int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
+static int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
 {
 	if (is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -824,7 +824,7 @@ int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
 	return 0;
 }
 
-int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
+static int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
 {
 	if (is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -872,7 +872,7 @@ static void graceful_stop(struct fman_mac *dtsec)
 	}
 }
 
-int dtsec_enable(struct fman_mac *dtsec)
+static int dtsec_enable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -891,7 +891,7 @@ int dtsec_enable(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_disable(struct fman_mac *dtsec)
+static int dtsec_disable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -909,9 +909,10 @@ int dtsec_disable(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
-			      u8 __maybe_unused priority,
-			      u16 pause_time, u16 __maybe_unused thresh_time)
+static int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
+				     u8 __maybe_unused priority,
+				     u16 pause_time,
+				     u16 __maybe_unused thresh_time)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 ptv = 0;
@@ -946,7 +947,7 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 	return 0;
 }
 
-int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
+static int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -968,7 +969,8 @@ int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 	return 0;
 }
 
-int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr)
+static int dtsec_modify_mac_address(struct fman_mac *dtsec,
+				    const enet_addr_t *enet_addr)
 {
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -986,7 +988,8 @@ int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_add
 	return 0;
 }
 
-int dtsec_add_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
+static int dtsec_add_hash_mac_address(struct fman_mac *dtsec,
+				      enet_addr_t *eth_addr)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct eth_hash_entry *hash_entry;
@@ -1052,7 +1055,7 @@ int dtsec_add_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
+static int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
 {
 	u32 tmp;
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -1071,7 +1074,7 @@ int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
 	return 0;
 }
 
-int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
+static int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 rctrl, tctrl;
@@ -1096,7 +1099,8 @@ int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
 	return 0;
 }
 
-int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
+static int dtsec_del_hash_mac_address(struct fman_mac *dtsec,
+				      enet_addr_t *eth_addr)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct list_head *pos;
@@ -1167,7 +1171,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
+static int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -1196,7 +1200,7 @@ int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 	return 0;
 }
 
-int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
+static int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -1230,7 +1234,7 @@ int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 	return 0;
 }
 
-int dtsec_restart_autoneg(struct fman_mac *dtsec)
+static int dtsec_restart_autoneg(struct fman_mac *dtsec)
 {
 	u16 tmp_reg16;
 
@@ -1270,7 +1274,7 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 			err);
 }
 
-int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
+static int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 
@@ -1282,8 +1286,8 @@ int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
 	return 0;
 }
 
-int dtsec_set_exception(struct fman_mac *dtsec,
-			enum fman_mac_exceptions exception, bool enable)
+static int dtsec_set_exception(struct fman_mac *dtsec,
+			       enum fman_mac_exceptions exception, bool enable)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 bit_mask = 0;
@@ -1336,7 +1340,7 @@ int dtsec_set_exception(struct fman_mac *dtsec,
 	return 0;
 }
 
-int dtsec_init(struct fman_mac *dtsec)
+static int dtsec_init(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct dtsec_cfg *dtsec_drv_param;
@@ -1430,7 +1434,7 @@ int dtsec_init(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_free(struct fman_mac *dtsec)
+static int dtsec_free(struct fman_mac *dtsec)
 {
 	free_init_resources(dtsec);
 
@@ -1441,7 +1445,7 @@ int dtsec_free(struct fman_mac *dtsec)
 	return 0;
 }
 
-struct fman_mac *dtsec_config(struct fman_mac_params *params)
+static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 {
 	struct fman_mac *dtsec;
 	struct dtsec_cfg *dtsec_drv_param;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index fc5abd65f620..d8e1ec16caf9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -686,7 +686,7 @@ static bool is_init_done(struct memac_cfg *memac_drv_params)
 	return false;
 }
 
-int memac_enable(struct fman_mac *memac)
+static int memac_enable(struct fman_mac *memac)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -701,7 +701,7 @@ int memac_enable(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_disable(struct fman_mac *memac)
+static int memac_disable(struct fman_mac *memac)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -716,7 +716,7 @@ int memac_disable(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
+static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -735,7 +735,7 @@ int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 	return 0;
 }
 
-int memac_adjust_link(struct fman_mac *memac, u16 speed)
+static int memac_adjust_link(struct fman_mac *memac, u16 speed)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -792,7 +792,7 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 			err);
 }
 
-int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
+static int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -802,7 +802,7 @@ int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
 	return 0;
 }
 
-int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
+static int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -812,8 +812,8 @@ int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
 	return 0;
 }
 
-int memac_cfg_fixed_link(struct fman_mac *memac,
-			 struct fixed_phy_status *fixed_link)
+static int memac_cfg_fixed_link(struct fman_mac *memac,
+				struct fixed_phy_status *fixed_link)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -823,8 +823,8 @@ int memac_cfg_fixed_link(struct fman_mac *memac,
 	return 0;
 }
 
-int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
-			      u16 pause_time, u16 thresh_time)
+static int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
+				     u16 pause_time, u16 thresh_time)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -861,7 +861,7 @@ int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 	return 0;
 }
 
-int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
+static int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -880,7 +880,8 @@ int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 	return 0;
 }
 
-int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_addr)
+static int memac_modify_mac_address(struct fman_mac *memac,
+				    const enet_addr_t *enet_addr)
 {
 	if (!is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -890,7 +891,8 @@ int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_add
 	return 0;
 }
 
-int memac_add_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
+static int memac_add_hash_mac_address(struct fman_mac *memac,
+				      enet_addr_t *eth_addr)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	struct eth_hash_entry *hash_entry;
@@ -923,7 +925,7 @@ int memac_add_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int memac_set_allmulti(struct fman_mac *memac, bool enable)
+static int memac_set_allmulti(struct fman_mac *memac, bool enable)
 {
 	u32 entry;
 	struct memac_regs __iomem *regs = memac->regs;
@@ -946,12 +948,13 @@ int memac_set_allmulti(struct fman_mac *memac, bool enable)
 	return 0;
 }
 
-int memac_set_tstamp(struct fman_mac *memac, bool enable)
+static int memac_set_tstamp(struct fman_mac *memac, bool enable)
 {
 	return 0; /* Always enabled. */
 }
 
-int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
+static int memac_del_hash_mac_address(struct fman_mac *memac,
+				      enet_addr_t *eth_addr)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	struct eth_hash_entry *hash_entry = NULL;
@@ -984,8 +987,8 @@ int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int memac_set_exception(struct fman_mac *memac,
-			enum fman_mac_exceptions exception, bool enable)
+static int memac_set_exception(struct fman_mac *memac,
+			       enum fman_mac_exceptions exception, bool enable)
 {
 	u32 bit_mask = 0;
 
@@ -1007,7 +1010,7 @@ int memac_set_exception(struct fman_mac *memac,
 	return 0;
 }
 
-int memac_init(struct fman_mac *memac)
+static int memac_init(struct fman_mac *memac)
 {
 	struct memac_cfg *memac_drv_param;
 	u8 i;
@@ -1124,7 +1127,7 @@ int memac_init(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_free(struct fman_mac *memac)
+static int memac_free(struct fman_mac *memac)
 {
 	free_init_resources(memac);
 
@@ -1137,7 +1140,7 @@ int memac_free(struct fman_mac *memac)
 	return 0;
 }
 
-struct fman_mac *memac_config(struct fman_mac_params *params)
+static struct fman_mac *memac_config(struct fman_mac_params *params)
 {
 	struct fman_mac *memac;
 	struct memac_cfg *memac_drv_param;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2f2c4ef45f6f..ca0e00386c66 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -393,7 +393,7 @@ static bool is_init_done(struct tgec_cfg *cfg)
 	return false;
 }
 
-int tgec_enable(struct fman_mac *tgec)
+static int tgec_enable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -408,7 +408,7 @@ int tgec_enable(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_disable(struct fman_mac *tgec)
+static int tgec_disable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -423,7 +423,7 @@ int tgec_disable(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
+static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -441,7 +441,7 @@ int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 	return 0;
 }
 
-int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
+static int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
 {
 	if (is_init_done(tgec->cfg))
 		return -EINVAL;
@@ -451,8 +451,9 @@ int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
 	return 0;
 }
 
-int tgec_set_tx_pause_frames(struct fman_mac *tgec, u8 __maybe_unused priority,
-			     u16 pause_time, u16 __maybe_unused thresh_time)
+static int tgec_set_tx_pause_frames(struct fman_mac *tgec,
+				    u8 __maybe_unused priority, u16 pause_time,
+				    u16 __maybe_unused thresh_time)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 
@@ -464,7 +465,7 @@ int tgec_set_tx_pause_frames(struct fman_mac *tgec, u8 __maybe_unused priority,
 	return 0;
 }
 
-int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
+static int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -482,7 +483,8 @@ int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 	return 0;
 }
 
-int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *p_enet_addr)
+static int tgec_modify_mac_address(struct fman_mac *tgec,
+				   const enet_addr_t *p_enet_addr)
 {
 	if (!is_init_done(tgec->cfg))
 		return -EINVAL;
@@ -493,7 +495,8 @@ int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *p_enet_add
 	return 0;
 }
 
-int tgec_add_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
+static int tgec_add_hash_mac_address(struct fman_mac *tgec,
+				     enet_addr_t *eth_addr)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	struct eth_hash_entry *hash_entry;
@@ -530,7 +533,7 @@ int tgec_add_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
+static int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
 {
 	u32 entry;
 	struct tgec_regs __iomem *regs = tgec->regs;
@@ -553,7 +556,7 @@ int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
 	return 0;
 }
 
-int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
+static int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -573,7 +576,8 @@ int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
 	return 0;
 }
 
-int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
+static int tgec_del_hash_mac_address(struct fman_mac *tgec,
+				     enet_addr_t *eth_addr)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	struct eth_hash_entry *hash_entry = NULL;
@@ -614,7 +618,7 @@ static void adjust_link_void(struct mac_device *mac_dev)
 {
 }
 
-int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
+static int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 
@@ -626,8 +630,8 @@ int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
 	return 0;
 }
 
-int tgec_set_exception(struct fman_mac *tgec,
-		       enum fman_mac_exceptions exception, bool enable)
+static int tgec_set_exception(struct fman_mac *tgec,
+			      enum fman_mac_exceptions exception, bool enable)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 bit_mask = 0;
@@ -653,7 +657,7 @@ int tgec_set_exception(struct fman_mac *tgec,
 	return 0;
 }
 
-int tgec_init(struct fman_mac *tgec)
+static int tgec_init(struct fman_mac *tgec)
 {
 	struct tgec_cfg *cfg;
 	enet_addr_t eth_addr;
@@ -736,7 +740,7 @@ int tgec_init(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_free(struct fman_mac *tgec)
+static int tgec_free(struct fman_mac *tgec)
 {
 	free_init_resources(tgec);
 
@@ -746,7 +750,7 @@ int tgec_free(struct fman_mac *tgec)
 	return 0;
 }
 
-struct fman_mac *tgec_config(struct fman_mac_params *params)
+static struct fman_mac *tgec_config(struct fman_mac_params *params)
 {
 	struct fman_mac *tgec;
 	struct tgec_cfg *cfg;
-- 
2.35.1.1320.gc452695387.dirty

