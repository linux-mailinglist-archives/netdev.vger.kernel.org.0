Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914C95ABA73
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiIBV6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiIBV6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:20 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA8DFB29F;
        Fri,  2 Sep 2022 14:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsccoqxlufET7g7YApV9bEm+KQlOdFu3PBZfZq8M3lQ1LrNTzhnl1a6FxvhI+rBZDbil3i7KSwqbNjypjFrcAEQJfQaMn7+yiQZDpctDAVHcg7yZ1xdFBIN5wBiSz8qIhpWhKilgpAeR7pu5C4Diac4W+//TPErtWJUXyJ1RuUmy39b7NdaRpuegiltJnGMgZCwte6Dr4cFKI8QIjuSsFw65+Tk93qwF/+tnr4+vDLwgOwIomvlGIPKDIfJKk6RqtlQ1VA6toDpOK8LkN4dF6YB8kvSLoJlEzK083IUpOd4B4T1XTGlVpJ3EccRDZ2SMZ6OoKlabtvZ7aBZYaDu44g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yA8N1Y23rKJ/MbRGzbvie3E8a4NB1oLpc/VHH++2zQI=;
 b=d9D7jE544I2zPWjbT0Ik+BYzfvf13wEdduIr4TGvi3jfUE/28+kV+vB9OxI5AvTTLU7NUSMMfkzHbvZOdmtJ3jWWMzkl6a/Ta2ReCeKH2yuJwAAZQ15SdOkUORcQOeu5QsSbLB54yBE1RHio64uJRZgfuHsm12U0fjX8FnSw2hiL0BjrJTvpt0GvBVpGBKEZkwSywFewgWKhwNniPxUer3aJcA72rdWXTp7aNBjGYi4ITGRx8W/4eaiJ+Ru+6+2OXcAT6MMLFWl/Ye76I/qgrO9eJvbGKBNm1FKAhHlMB41vd2wcEoXsfF0WsC0NDLLrg07+/JrF4KjZeeOGnh1fWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yA8N1Y23rKJ/MbRGzbvie3E8a4NB1oLpc/VHH++2zQI=;
 b=oVfnjHuk4vLU+n8eoOYTyBq/VsSj+XjDRyJWLXiwBBtPRB6o7/vnOHhlfMFd1GZ1ikHnjHNAZ4IqF4AoGtljIfooK/cj054lP1uGG8Ej4B2fzXx1IrQ3ZqbeA4V+WrzjEfB/JPRj0CeiPyNnZrzK0BwcrMD1SCtvXq3sQiRmIiyiiq1p+UntTUPDwisoPyM+McCqo+tbeLmXhHQCqk7ly81SwOxfI06kIUFMHXP8YDdwL3aMarGOFcqx/P6t3lZsDZFhoCM+dX0Xdq2PoFBZA3L4lGMw1tS1Pq+STYCF6syKYwqOsjzL8kqxXejZBEs3Oxh1mF+OdCuBK0oIlnCg7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:57:54 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:57:54 +0000
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
Subject: [PATCH net-next v5 03/14] net: fman: Inline several functions into initialization
Date:   Fri,  2 Sep 2022 17:57:25 -0400
Message-Id: <20220902215737.981341-4-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: abe469de-d58d-471f-d3d9-08da8d2e306b
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WcAO03vllsvSFAJhaY+xsZav4AJGGwHkiAmPPdOgpOopWSvsCUzCdIw4Bqz+c9P+/i9ZKSwMdflVQIDNqlKHhcU+ET7cRV8ZxpYQ1mN/K2iVmcGM6Tj5DPEAZItezSg/c51CYDJvyuPuFz1KEO/GF3nvGgKXRMTbZwLw1V3xlfyncvSTidMWpH3x6YoSWrtyLOVeLJ2OJO6vcy/4r8ezZqE7y0FRpa1VKyoCuw/NFU+ZNISVw1bnlMpuzZ4rc6QNzR1pMuD1K23TjZt70PTKG61+aMHy5dalkjokFbq7xSagdzD7uRa3g22imV1ZQRN//tkS0p2wigNnIkvbdYXoYNppOKkenKZynq7eIhndGXQz1sdaz9gY88z5gC6ZQqpVEDWUfGvuW6ejVp37ZrakY0NFaJZZ2skhFmAkKfRM+RBiRp78CTYIZismNwWoiy2yhdI2pP4iGb7sl6/38sE1k7SdlLE3C/gKMe9R9ZJuCte0KP1eN5WlTHG+21vDexPWLslI/GdKtuosLXbHBdu2gmP3Rg/w1j6Y3c7IjQTWP2Gv/q/eiZXmhtLYjxoyrOJdmkdOLYGNaXrDQJua+Hlo0DRtaMu3N2j9lT7LyUvxqZgrCGyv71jUNcxBnz0CTkDUH53saQkjY+9E327b0171XWMxRbhiCyrbUr4/n+0tE+WH+UyvjkFPs2qTG1wQByjGmP9PMTBAN+Oh57ZxXyDd0OXSfpJURdbTRo9kJNiBcvI2PSepcZ/aZ2slolupl3sbLiuviRJi0ZY5jqhfenUcrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+YkKL9udhWuw4J0yY7b0+ygltXrUjB1BpvIPNx+GMvaRsstY8ZFdGG4BR1i5?=
 =?us-ascii?Q?byMcutjb/vKhNuY35u4Ip9tlhZ0dkJE2wwctTZfbrN/jrMX40rdsPkuGbh55?=
 =?us-ascii?Q?FTyqcUmwDnKOhKuudmH708u42ICX9Tw7oyBhw6cKOxu64St5bcLTnc2UA4YH?=
 =?us-ascii?Q?yJzA+DL1HmWr4E2UhYCgP1RnPYfH0ZHa5QI18ekZ34x9OaocJFjU2KvYHoVq?=
 =?us-ascii?Q?78YUi90cGoTrbDO9sfJai0gI4hDvfF0M6/7uqF4v+dM5Jg+wLk0O0QVHVXcB?=
 =?us-ascii?Q?SfIbByQzNqq+cx1s/f/Tj3hjUdyxcTh21rlfGcZnS6W4NjxmEGsfKQEFE9R7?=
 =?us-ascii?Q?xcn0e8HBTr7kAjw9Mdi4f//z4qXLVlBasKfrrLgCm4bUlIJa0CAVV7UiegLD?=
 =?us-ascii?Q?jJIJ1IIgChcT4ULZr18Hz0n+nPyBznmUAB/YGdrWmgmmYjSh2oGYWMPg3s2I?=
 =?us-ascii?Q?vlbHbu+Q1nykjJkVfHBlHIj0NzjesXdFtgsa9qpPKGdS6HtYVuiAX6tx+DR+?=
 =?us-ascii?Q?b2ypcMQUK/i/NPCSXC/zCYQDLJxjQEgYdT7rO6kNF4/o37k8F1gUYW6sV7jA?=
 =?us-ascii?Q?hijTBljntvRCWPwYLlNNNaJGRB1X0j9Ci49YgoDSttmNuIrEWaeWt9vmh352?=
 =?us-ascii?Q?SQ08LhG4O9KxNDSVos+6aDh3EpgPCBLynT3F+2n0GNjI8fmazY6SO2Qecw14?=
 =?us-ascii?Q?puN6QXuxKmX87KhW/P7NkPQeUbbL3Utx2JoRiW+OG9+Cz34BS8uwlYUE7nNW?=
 =?us-ascii?Q?ptck3IoOWu01O8uBpqPll+7uQAv5zuUIJXx0/66TzqW4YCpYPcvz0izaYI17?=
 =?us-ascii?Q?R/u472dT7Ngw/a/w4tTQbV4KbAOSro4SeUFWuDBrPCbFYWepthiwAqrK30WH?=
 =?us-ascii?Q?/Qi4pZ8+XS/q1ZQgFBL7jO5iph03LOjpVyEswH8LvvgamKRC5VeZ1e/XMIsr?=
 =?us-ascii?Q?rt05BeyNWBseQO23htz4ge1VZ79OYcfCYTTQB/vOyldzZx2dVpZP2GCIHt8y?=
 =?us-ascii?Q?mxzkI5rbDedz+Egx/R5AB68ivyxbz8Tk9M6l50ARzBtrW3Ba+V49VwiiHbwT?=
 =?us-ascii?Q?5b2A4WXwEyc3vHtVGBSppSNEJVVAAYDwviBMR+RepMtD4q0sSJ4Cz6fufNK/?=
 =?us-ascii?Q?7dPdHLHe49kR7HSoDSD1h29hCFsScDEvS3xP/tvXCfUMtkSJI6K4sH5HNMs2?=
 =?us-ascii?Q?PbuVcsfLcfiqq2Ty54eLImHrOV998Ej/UlxMqF4K/H0bSTXPtm7NlWlq2mfv?=
 =?us-ascii?Q?QKtRk1kcLdUxe2ubYfOpLKxcwf9J5etkt4iBgu+s5UzOZA+G1wtaP514x31S?=
 =?us-ascii?Q?BtBKUYOTqGhRk1HRkda/qrU4XgzN5UsqgRefHCYnS8crNP9L2JGWmKB9Mffi?=
 =?us-ascii?Q?9+6HSYU2wOiTnZZxbia2HHlzsBG4xpvCiXKUWwjtV52zvlg+HG6dwl3Ywjns?=
 =?us-ascii?Q?IjiDlAnGYOW0Kce6q7E9LCJ/CEJpgQp62WI7xBfUawEEp5Y5U2ZAs/KQd56b?=
 =?us-ascii?Q?LVpWOdUeq70XtIuudMnjIEfAZo6a/8fUq0/tybUTlK0n15RhYvF5ib8IGOnr?=
 =?us-ascii?Q?HZrLcskCaG9nCpnIg20STdOiycXHWHuH4xXFVqumhTT4MuZo7aDPmU/7xalf?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe469de-d58d-471f-d3d9-08da8d2e306b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:54.8450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f+5f6haflVznecoAV2CsVXHprnv/wtdcmXexxpN7T+YKUak7WBvY6ufUqayYfpl46KOKjfEU6L8FO6iz4ZljqA==
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

There are several small functions which were only necessary because the
initialization functions didn't have access to the mac private data. Now
that they do, just do things directly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v4)

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
index d8e1ec16caf9..e5d75597463a 100644
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

