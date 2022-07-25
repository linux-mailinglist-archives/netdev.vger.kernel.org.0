Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C491A58014B
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbiGYPMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiGYPLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:30 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5188265C9;
        Mon, 25 Jul 2022 08:11:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJeDduocSEToxAVOejT8vQ8HTzav6SK5VkanIcIt0Zan+aRxv/UPZjFT9rBBXA71zuqTv/U52pklFPPMKqpzk+Y3T6diIqsVONKKN4mgERUcxXks00I312ojMyBjVUSn/irlE4//1SUmGqy0CZMJKakgddpR96OSKxn8uxbuvy3tNlwSMbMbxsIk2TFx9nej30wgAWWMbApeDyjzMTA95BZ3cLZXDkkD5c5ai07Sxwe/iZuzexRXNlLHslGu78KGO0D4jI9wPPoPXMZ0hIWQ8fbl5urgzw396JMNGYMCjyEhQUk/8v/eytknmtG6jDahpUrMWmD1do4TEtugcnHMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veD6HsB/zXZVLYUNWscbV7rOmgPddUpGNACYumEKmQ0=;
 b=RQ4QvALjJc9Z7FUrqvWhvaGJhvUUKh3MC6QhnCenxxxrt3EZmNydXejbfR9QS6SQxwk1Pvl5OpcN+mZlKs6QS97NwRjABZeKGv5SR71Hit9xbadDa3DEGkoYGTQVIRxx2TABrmGiW66ShbLmezhhhnDVsiuaBPQC67BeAybCT6V9E/3kVDB8+Krw7yBE4nhQktReoQOQ00FBVhYHmtQYvMI+WOOILZe8/0kYxI5KXYQ8rkxkEYbwyQ2xtoBcTMpOxXIyDQPcC+WUNqSoy3McXqV+F//QVhrNczSzNqhUw0th8olHzKoJaZuVeMgOuCg/4yiCffBvdAsS9IcxbvC9xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veD6HsB/zXZVLYUNWscbV7rOmgPddUpGNACYumEKmQ0=;
 b=WECPIPS6rmlepmShmi9ZBWiXtrzPzOcknAwLW6221t3zJoValfbocu8cEmqoENkYwyzrgA65cfznMkdWzJRu04o5YzcnanrtzfG7k9CWxMgwOFiws6Mb0ZXa+DMIBs7PEaXZXrf3sK14zdJ4mc/UfSLlL3uzzVRUyduEIqUhsYNFuaP7SVUIg9D3Ux8CGbzxtdBmRaSVA/chBP9bbL8ogF6DxNhe66k4e7bKUiStzmRkoigN+IlOXw9zf2Y9OHWNYvC7hoSW8EJO2SOYFy0F4dVJWgLitt5/g/MoYgyPlLQPOOTvkRxnqccIeiwf2cJskk9/f/CNMk4LUbnv7gR6uQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:20 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:20 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 12/25] net: fman: Move initialization to mac-specific files
Date:   Mon, 25 Jul 2022 11:10:26 -0400
Message-Id: <20220725151039.2581576-13-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 613d4469-9fc0-4733-104c-08da6e4fedf2
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R9BTgdrwZcow9D/JgWtMyO9Kqyt55g4WsTil+RAv3gXBwq9Of4G7BAc338lZLtIMkUGez93MA/IatZdTVdLKWZ0IEO9084vUTGtstGz2XJsc3JbWgSANmTUrvaQQAYYL19OL0NH/hSZmHPECrqKwQ8vaT/xgQ+v5PRyJ4GmYxpY424rCqOeyAU639z1hrvPbwTHUJmwAHfCA1IaGznR1XasbQ8xkO8bvCwDciQ375wcfBqZ3FK6nP//0oZuuHOAFRPVI/pjz9EXittIEJfbj4c/zXFgI4RKu/BmdcXWcur/vWlK7b8zxOPPxKUqIG30FppuQmnm6STMRPP/VCPJoEPgY/NSqwVaNak7VAp51mzcL/N921hxmCcLnbkZ2eqinWs//PwMgVD2dH9L7Z7JClhxgkDHYuZiZN8XxLWEa6BsNrZzFM5cIGQ4Ap0LgUn/oH9+FCRorAwC/HuE81ED1Q08EjfMbKV6P1Wg6Khi2qvRsUVLFii1uKu7j8ewBqmNaY0qcBRtGYubbPimJjMnQxzOGC8fmPB6C+PaLbnhr8t8vJubMpjqbJr70n0x0Zi6pv5SmKGFadgNSDC5vcN4Kc86tpm5uSApXcjyKzIsSZu8lP7GbMz9SuT0fjAE9j7YfJc9JiYp8gNuPkQBhnjHgQcjUBTl5DXVQqZ6QHq4L6FTjwg8LVZjP0Xemi9geGPAT8otWciQ5Sz3sY1SZUpYgO4fCpBdWayrl87Pmz+VEG01fsosA4FTkCgN4OEI59j8qa/LCYg4s3O5m4WR/aWQWER3D/2n97x1hSTez7+XCKiQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(30864003)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?65e+REeM/GOI0W3GIXOVW2AgP5Eq3ax7SEo91s7F7MK/B7m883z6N6WNv9yz?=
 =?us-ascii?Q?PGbld13+9c/j1xUY/8l4uQ6y5hj694EdtCRP3vHtUV6u0TaP2eGhj3cub2hi?=
 =?us-ascii?Q?jDeLSTxT2kLGSjOj3bh3cw7zB7THfx43+XBnZmJ9diDUjTb7RESyF2O8PjV0?=
 =?us-ascii?Q?igHT7rnE8C+WtmPVZ7J1KTtdwJpizl7GE59FoMO9ftbr8PSsS2zHpj2DofgL?=
 =?us-ascii?Q?umYs7H/hJ+Ea08TA5c7T2eyAnGDicuk0RAZo6Im/UxrAgucXn5vdXcPio088?=
 =?us-ascii?Q?oTwnrojxXlNsSdpRHrD6ybTHwJgaQQdMC09o17oOvh7Dz8dSVCFZkF2NfvEf?=
 =?us-ascii?Q?5BWI817JnLO1h62uSX/UlAQwzkFeB0LQigdQYuFiLVnhGtMyB3qKSEVffNcR?=
 =?us-ascii?Q?SynKopw1H2HoNm7lsKF7GsUIAmOWTPzW9gPSlGc9sbidehzUzWaoAD3qXjBn?=
 =?us-ascii?Q?SJpsnR7p4D8qP/jFCToB/ixGndc7eYNipBX+XriW5LsBSPibQc7HmU43Z9hl?=
 =?us-ascii?Q?G2R0flhYBG96IzrvYw46GKQOU3QseIUhp4bGEDNMu4AGUWkbmOx71R0eauLL?=
 =?us-ascii?Q?xdX1Rwk9CTIlOBUXd5EqyKTeSgoXc+hWaxH/4yFaoZhi+LDLmjCzLFr/OBUT?=
 =?us-ascii?Q?ZlBlBC+aAxpTm0geZdibhSKSDICgPeyXRV5MISTeu2ljFJB/hzbTA5NpBvl1?=
 =?us-ascii?Q?nTlH8xo1gkS02PLgxFfwUhI/qtBQef/4/5dOt2OaE8/XGsDxUCntmcrrqRZ9?=
 =?us-ascii?Q?3aonhJyaF9X2cLvA9Qhqh/54G7NgClBhnmgkVrIHEOs7WzfTFzUedRDfcgoa?=
 =?us-ascii?Q?QF874Nxr7PITKXzT48Ioz8zekAUW1ScguIWN2jx18UZ+Bz05i9wPDo7FhWIr?=
 =?us-ascii?Q?ApPbZD1SD7uDd5cll71DDqlu1Yz3XIHuflwtU/qXLOCZsGVtE8Sgf6xQUYwl?=
 =?us-ascii?Q?4Lem5npc8J10FGcAi2TyqBTg3kHH2yrDYlDi4nGZyrg9K0a/q6RCQe4FBiT3?=
 =?us-ascii?Q?sm5prXyIfsNs3suS241eTawf3lrL+SDLxuezGfd7GIZO4xzkM6wS6QJZDSKY?=
 =?us-ascii?Q?pR5CT0I89amRjuBk+VwEPKkhD9WD/zE9eCWwzhMqtci4MV22DjlDoH/CtaCt?=
 =?us-ascii?Q?7PzztiH1uuy3heghe8UK/opPNA6K3Hus6jNXbYNaBYlg8O7S1vtzgR4iGDYd?=
 =?us-ascii?Q?BeYkf5b42Q3U8rvv6V/0fGX1t6q7qXF8jQEl71g6+VUP+4GTm6zJJfBquGLb?=
 =?us-ascii?Q?laZ5oHCJER/8YqZvwORUgtVjFKgHFPn7JbUxUuoCSg+vpgNYeAZm7M5RzBPF?=
 =?us-ascii?Q?1Bm0+55KGtYnJ/Jz1mwKytXLKA6wly3CnMMDxhkioMoeozf1VjhWnVCnRam+?=
 =?us-ascii?Q?GJCngNxCsmb1YchiF4Cz9RHD16DxqC8wX71GKaDvEJ+ujbCyyHXUz3RF4Mje?=
 =?us-ascii?Q?rv7RBbR1XsxUw5FgoGRO2vzMZnl/uznxYclI1Q/4GqwY1zxL64/WtpsDfYLX?=
 =?us-ascii?Q?r6ucsy28RDXm/53k1YQZuyOar/METqXLeCGTEs13ruBU5NX9aScKtO1/0le8?=
 =?us-ascii?Q?2kQOVqlqwYucjaNNZGemmSaIGzyefsgZdRolMfJDWAs6v7qIRbBkuW2QFN/1?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 613d4469-9fc0-4733-104c-08da6e4fedf2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:20.2069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1xq2MkuTUSLBLDxR/UwrGSmV2Kh9bP6fNW1YrPsDdo6i71tVwTa8i15GAkYkrAVnVoQqljenj+gd1PDNv/bhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves mac-specific initialization to mac-specific files. This will
make it easier to work with individual macs. It will also make it easier
to refactor the initialization to simplify the control flow. No
functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v2)

Changes in v2:
- Fix prototype for dtsec_initialization

 .../net/ethernet/freescale/fman/fman_dtsec.c  |  88 ++++++
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  26 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 111 ++++++++
 .../net/ethernet/freescale/fman/fman_memac.h  |  25 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  65 +++++
 .../net/ethernet/freescale/fman/fman_tgec.h   |  22 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 261 ------------------
 7 files changed, 276 insertions(+), 322 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 7f4f3d797a8d..92c2e35d3b4f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -7,6 +7,7 @@
 
 #include "fman_dtsec.h"
 #include "fman.h"
+#include "mac.h"
 
 #include <linux/slab.h>
 #include <linux/bitrev.h>
@@ -1247,6 +1248,28 @@ int dtsec_restart_autoneg(struct fman_mac *dtsec)
 	return 0;
 }
 
+static void adjust_link_dtsec(struct mac_device *mac_dev)
+{
+	struct phy_device *phy_dev = mac_dev->phy_dev;
+	struct fman_mac *fman_mac;
+	bool rx_pause, tx_pause;
+	int err;
+
+	fman_mac = mac_dev->fman_mac;
+	if (!phy_dev->link) {
+		dtsec_restart_autoneg(fman_mac);
+
+		return;
+	}
+
+	dtsec_adjust_link(fman_mac, phy_dev->speed);
+	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
+	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
+	if (err < 0)
+		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
+			err);
+}
+
 int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -1492,3 +1515,68 @@ struct fman_mac *dtsec_config(struct fman_mac_params *params)
 	kfree(dtsec);
 	return NULL;
 }
+
+int dtsec_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node)
+{
+	int			err;
+	struct fman_mac_params	params;
+	u32			version;
+
+	mac_dev->set_promisc		= dtsec_set_promiscuous;
+	mac_dev->change_addr		= dtsec_modify_mac_address;
+	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
+	mac_dev->remove_hash_mac_addr	= dtsec_del_hash_mac_address;
+	mac_dev->set_tx_pause		= dtsec_set_tx_pause_frames;
+	mac_dev->set_rx_pause		= dtsec_accept_rx_pause_frames;
+	mac_dev->set_exception		= dtsec_set_exception;
+	mac_dev->set_allmulti		= dtsec_set_allmulti;
+	mac_dev->set_tstamp		= dtsec_set_tstamp;
+	mac_dev->set_multi		= fman_set_multi;
+	mac_dev->adjust_link            = adjust_link_dtsec;
+	mac_dev->enable			= dtsec_enable;
+	mac_dev->disable		= dtsec_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
+
+	mac_dev->fman_mac = dtsec_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
+	err = mac_dev->set_exception(mac_dev->fman_mac,
+				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_get_version(mac_dev->fman_mac, &version);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
+
+	goto _return;
+
+_return_fm_mac_free:
+	dtsec_free(mac_dev->fman_mac);
+
+_return:
+	return err;
+}
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.h b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
index f072cdc560ba..cf3e683c089c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -8,27 +8,9 @@
 
 #include "fman_mac.h"
 
-struct fman_mac *dtsec_config(struct fman_mac_params *params);
-int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val);
-int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr);
-int dtsec_adjust_link(struct fman_mac *dtsec,
-		      u16 speed);
-int dtsec_restart_autoneg(struct fman_mac *dtsec);
-int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val);
-int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val);
-int dtsec_enable(struct fman_mac *dtsec);
-int dtsec_disable(struct fman_mac *dtsec);
-int dtsec_init(struct fman_mac *dtsec);
-int dtsec_free(struct fman_mac *dtsec);
-int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en);
-int dtsec_set_tx_pause_frames(struct fman_mac *dtsec, u8 priority,
-			      u16 pause_time, u16 thresh_time);
-int dtsec_set_exception(struct fman_mac *dtsec,
-			enum fman_mac_exceptions exception, bool enable);
-int dtsec_add_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr);
-int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr);
-int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version);
-int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable);
-int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable);
+struct mac_device;
+
+int dtsec_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node);
 
 #endif /* __DTSEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index c34da49aed31..b2a592a77a2a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -7,6 +7,7 @@
 
 #include "fman_memac.h"
 #include "fman.h"
+#include "mac.h"
 
 #include <linux/slab.h>
 #include <linux/io.h>
@@ -774,6 +775,23 @@ int memac_adjust_link(struct fman_mac *memac, u16 speed)
 	return 0;
 }
 
+static void adjust_link_memac(struct mac_device *mac_dev)
+{
+	struct phy_device *phy_dev = mac_dev->phy_dev;
+	struct fman_mac *fman_mac;
+	bool rx_pause, tx_pause;
+	int err;
+
+	fman_mac = mac_dev->fman_mac;
+	memac_adjust_link(fman_mac, phy_dev->speed);
+
+	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
+	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
+	if (err < 0)
+		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
+			err);
+}
+
 int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
 {
 	if (is_init_done(memac->memac_drv_param))
@@ -1178,3 +1196,96 @@ struct fman_mac *memac_config(struct fman_mac_params *params)
 
 	return memac;
 }
+
+int memac_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node)
+{
+	int			 err;
+	struct fman_mac_params	 params;
+	struct fixed_phy_status *fixed_link;
+
+	mac_dev->set_promisc		= memac_set_promiscuous;
+	mac_dev->change_addr		= memac_modify_mac_address;
+	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
+	mac_dev->remove_hash_mac_addr	= memac_del_hash_mac_address;
+	mac_dev->set_tx_pause		= memac_set_tx_pause_frames;
+	mac_dev->set_rx_pause		= memac_accept_rx_pause_frames;
+	mac_dev->set_exception		= memac_set_exception;
+	mac_dev->set_allmulti		= memac_set_allmulti;
+	mac_dev->set_tstamp		= memac_set_tstamp;
+	mac_dev->set_multi		= fman_set_multi;
+	mac_dev->adjust_link            = adjust_link_memac;
+	mac_dev->enable			= memac_enable;
+	mac_dev->disable		= memac_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
+
+	if (params.max_speed == SPEED_10000)
+		params.phy_if = PHY_INTERFACE_MODE_XGMII;
+
+	mac_dev->fman_mac = memac_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
+		struct phy_device *phy;
+
+		err = of_phy_register_fixed_link(mac_node);
+		if (err)
+			goto _return_fm_mac_free;
+
+		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
+		if (!fixed_link) {
+			err = -ENOMEM;
+			goto _return_fm_mac_free;
+		}
+
+		mac_dev->phy_node = of_node_get(mac_node);
+		phy = of_phy_find_device(mac_dev->phy_node);
+		if (!phy) {
+			err = -EINVAL;
+			of_node_put(mac_dev->phy_node);
+			goto _return_fixed_link_free;
+		}
+
+		fixed_link->link = phy->link;
+		fixed_link->speed = phy->speed;
+		fixed_link->duplex = phy->duplex;
+		fixed_link->pause = phy->pause;
+		fixed_link->asym_pause = phy->asym_pause;
+
+		put_device(&phy->mdio.dev);
+
+		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
+		if (err < 0)
+			goto _return_fixed_link_free;
+	}
+
+	err = memac_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fixed_link_free;
+
+	dev_info(mac_dev->dev, "FMan MEMAC\n");
+
+	goto _return;
+
+_return_fixed_link_free:
+	kfree(fixed_link);
+_return_fm_mac_free:
+	memac_free(mac_dev->fman_mac);
+_return:
+	return err;
+}
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.h b/drivers/net/ethernet/freescale/fman/fman_memac.h
index 535ecd2b2ab4..a58215a3b1d9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.h
@@ -11,26 +11,9 @@
 #include <linux/netdevice.h>
 #include <linux/phy_fixed.h>
 
-struct fman_mac *memac_config(struct fman_mac_params *params);
-int memac_set_promiscuous(struct fman_mac *memac, bool new_val);
-int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_addr);
-int memac_adjust_link(struct fman_mac *memac, u16 speed);
-int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val);
-int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable);
-int memac_cfg_fixed_link(struct fman_mac *memac,
-			 struct fixed_phy_status *fixed_link);
-int memac_enable(struct fman_mac *memac);
-int memac_disable(struct fman_mac *memac);
-int memac_init(struct fman_mac *memac);
-int memac_free(struct fman_mac *memac);
-int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en);
-int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
-			      u16 pause_time, u16 thresh_time);
-int memac_set_exception(struct fman_mac *memac,
-			enum fman_mac_exceptions exception, bool enable);
-int memac_add_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr);
-int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr);
-int memac_set_allmulti(struct fman_mac *memac, bool enable);
-int memac_set_tstamp(struct fman_mac *memac, bool enable);
+struct mac_device;
+
+int memac_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node);
 
 #endif /* __MEMAC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2b38d22c863d..2f2c4ef45f6f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -7,6 +7,7 @@
 
 #include "fman_tgec.h"
 #include "fman.h"
+#include "mac.h"
 
 #include <linux/slab.h>
 #include <linux/bitrev.h>
@@ -609,6 +610,10 @@ int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 	return 0;
 }
 
+static void adjust_link_void(struct mac_device *mac_dev)
+{
+}
+
 int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
@@ -794,3 +799,63 @@ struct fman_mac *tgec_config(struct fman_mac_params *params)
 
 	return tgec;
 }
+
+int tgec_initialization(struct mac_device *mac_dev,
+			struct device_node *mac_node)
+{
+	int err;
+	struct fman_mac_params	params;
+	u32			version;
+
+	mac_dev->set_promisc		= tgec_set_promiscuous;
+	mac_dev->change_addr		= tgec_modify_mac_address;
+	mac_dev->add_hash_mac_addr	= tgec_add_hash_mac_address;
+	mac_dev->remove_hash_mac_addr	= tgec_del_hash_mac_address;
+	mac_dev->set_tx_pause		= tgec_set_tx_pause_frames;
+	mac_dev->set_rx_pause		= tgec_accept_rx_pause_frames;
+	mac_dev->set_exception		= tgec_set_exception;
+	mac_dev->set_allmulti		= tgec_set_allmulti;
+	mac_dev->set_tstamp		= tgec_set_tstamp;
+	mac_dev->set_multi		= fman_set_multi;
+	mac_dev->adjust_link            = adjust_link_void;
+	mac_dev->enable			= tgec_enable;
+	mac_dev->disable		= tgec_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+
+	mac_dev->fman_mac = tgec_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = tgec_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	/* For 10G MAC, disable Tx ECC exception */
+	err = mac_dev->set_exception(mac_dev->fman_mac,
+				     FM_MAC_EX_10G_TX_ECC_ER, false);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = tgec_get_version(mac_dev->fman_mac, &version);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	pr_info("FMan XGEC version: 0x%08x\n", version);
+
+	goto _return;
+
+_return_fm_mac_free:
+	tgec_free(mac_dev->fman_mac);
+
+_return:
+	return err;
+}
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.h b/drivers/net/ethernet/freescale/fman/fman_tgec.h
index 5b256758cbec..2e45b9fea352 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -8,23 +8,9 @@
 
 #include "fman_mac.h"
 
-struct fman_mac *tgec_config(struct fman_mac_params *params);
-int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val);
-int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *enet_addr);
-int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val);
-int tgec_enable(struct fman_mac *tgec);
-int tgec_disable(struct fman_mac *tgec);
-int tgec_init(struct fman_mac *tgec);
-int tgec_free(struct fman_mac *tgec);
-int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en);
-int tgec_set_tx_pause_frames(struct fman_mac *tgec, u8 priority,
-			     u16 pause_time, u16 thresh_time);
-int tgec_set_exception(struct fman_mac *tgec,
-		       enum fman_mac_exceptions exception, bool enable);
-int tgec_add_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr);
-int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr);
-int tgec_get_version(struct fman_mac *tgec, u32 *mac_version);
-int tgec_set_allmulti(struct fman_mac *tgec, bool enable);
-int tgec_set_tstamp(struct fman_mac *tgec, bool enable);
+struct mac_device;
+
+int tgec_initialization(struct mac_device *mac_dev,
+			struct device_node *mac_node);
 
 #endif /* __TGEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index c376b9bf657d..7afedd4995c9 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -216,267 +216,6 @@ void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
 }
 EXPORT_SYMBOL(fman_get_pause_cfg);
 
-static void adjust_link_void(struct mac_device *mac_dev)
-{
-}
-
-static void adjust_link_dtsec(struct mac_device *mac_dev)
-{
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct fman_mac *fman_mac;
-	bool rx_pause, tx_pause;
-	int err;
-
-	fman_mac = mac_dev->fman_mac;
-	if (!phy_dev->link) {
-		dtsec_restart_autoneg(fman_mac);
-
-		return;
-	}
-
-	dtsec_adjust_link(fman_mac, phy_dev->speed);
-	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
-	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
-	if (err < 0)
-		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
-			err);
-}
-
-static void adjust_link_memac(struct mac_device *mac_dev)
-{
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct fman_mac *fman_mac;
-	bool rx_pause, tx_pause;
-	int err;
-
-	fman_mac = mac_dev->fman_mac;
-	memac_adjust_link(fman_mac, phy_dev->speed);
-
-	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
-	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
-	if (err < 0)
-		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
-			err);
-}
-
-static int tgec_initialization(struct mac_device *mac_dev,
-			       struct device_node *mac_node)
-{
-	int err;
-	struct fman_mac_params	params;
-	u32			version;
-
-	mac_dev->set_promisc		= tgec_set_promiscuous;
-	mac_dev->change_addr		= tgec_modify_mac_address;
-	mac_dev->add_hash_mac_addr	= tgec_add_hash_mac_address;
-	mac_dev->remove_hash_mac_addr	= tgec_del_hash_mac_address;
-	mac_dev->set_tx_pause		= tgec_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= tgec_accept_rx_pause_frames;
-	mac_dev->set_exception		= tgec_set_exception;
-	mac_dev->set_allmulti		= tgec_set_allmulti;
-	mac_dev->set_tstamp		= tgec_set_tstamp;
-	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_void;
-	mac_dev->enable			= tgec_enable;
-	mac_dev->disable		= tgec_disable;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = tgec_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	/* For 10G MAC, disable Tx ECC exception */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_10G_TX_ECC_ER, false);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(mac_dev->dev, "FMan XGEC version: 0x%08x\n", version);
-
-	goto _return;
-
-_return_fm_mac_free:
-	tgec_free(mac_dev->fman_mac);
-
-_return:
-	return err;
-}
-
-static int dtsec_initialization(struct mac_device *mac_dev,
-				struct device_node *mac_node)
-{
-	int			err;
-	struct fman_mac_params	params;
-	u32			version;
-
-	mac_dev->set_promisc		= dtsec_set_promiscuous;
-	mac_dev->change_addr		= dtsec_modify_mac_address;
-	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
-	mac_dev->remove_hash_mac_addr	= dtsec_del_hash_mac_address;
-	mac_dev->set_tx_pause		= dtsec_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= dtsec_accept_rx_pause_frames;
-	mac_dev->set_exception		= dtsec_set_exception;
-	mac_dev->set_allmulti		= dtsec_set_allmulti;
-	mac_dev->set_tstamp		= dtsec_set_tstamp;
-	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_dtsec;
-	mac_dev->enable			= dtsec_enable;
-	mac_dev->disable		= dtsec_disable;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
-
-	mac_dev->fman_mac = dtsec_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
-
-	goto _return;
-
-_return_fm_mac_free:
-	dtsec_free(mac_dev->fman_mac);
-
-_return:
-	return err;
-}
-
-static int memac_initialization(struct mac_device *mac_dev,
-				struct device_node *mac_node)
-{
-	int			 err;
-	struct fman_mac_params	 params;
-	struct fixed_phy_status *fixed_link;
-
-	mac_dev->set_promisc		= memac_set_promiscuous;
-	mac_dev->change_addr		= memac_modify_mac_address;
-	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
-	mac_dev->remove_hash_mac_addr	= memac_del_hash_mac_address;
-	mac_dev->set_tx_pause		= memac_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= memac_accept_rx_pause_frames;
-	mac_dev->set_exception		= memac_set_exception;
-	mac_dev->set_allmulti		= memac_set_allmulti;
-	mac_dev->set_tstamp		= memac_set_tstamp;
-	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_memac;
-	mac_dev->enable			= memac_enable;
-	mac_dev->disable		= memac_disable;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
-
-	if (params.max_speed == SPEED_10000)
-		params.phy_if = PHY_INTERFACE_MODE_XGMII;
-
-	mac_dev->fman_mac = memac_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
-		struct phy_device *phy;
-
-		err = of_phy_register_fixed_link(mac_node);
-		if (err)
-			goto _return_fm_mac_free;
-
-		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
-		if (!fixed_link) {
-			err = -ENOMEM;
-			goto _return_fm_mac_free;
-		}
-
-		mac_dev->phy_node = of_node_get(mac_node);
-		phy = of_phy_find_device(mac_dev->phy_node);
-		if (!phy) {
-			err = -EINVAL;
-			of_node_put(mac_dev->phy_node);
-			goto _return_fixed_link_free;
-		}
-
-		fixed_link->link = phy->link;
-		fixed_link->speed = phy->speed;
-		fixed_link->duplex = phy->duplex;
-		fixed_link->pause = phy->pause;
-		fixed_link->asym_pause = phy->asym_pause;
-
-		put_device(&phy->mdio.dev);
-
-		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
-		if (err < 0)
-			goto _return_fixed_link_free;
-	}
-
-	err = memac_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fixed_link_free;
-
-	dev_info(mac_dev->dev, "FMan MEMAC\n");
-
-	goto _return;
-
-_return_fixed_link_free:
-	kfree(fixed_link);
-_return_fm_mac_free:
-	memac_free(mac_dev->fman_mac);
-_return:
-	return err;
-}
-
 #define DTSEC_SUPPORTED \
 	(SUPPORTED_10baseT_Half \
 	| SUPPORTED_10baseT_Full \
-- 
2.35.1.1320.gc452695387.dirty

