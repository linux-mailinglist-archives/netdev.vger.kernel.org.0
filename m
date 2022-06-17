Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B1954FEA4
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378864AbiFQUft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356454AbiFQUeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:31 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A855DA41;
        Fri, 17 Jun 2022 13:34:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4mClJUWCyzDjbBHQT+SqQKZzFvxIDTi71BAcHjuwRKLYg6/R+ey1Vi653zjd/7J9GwaT1Gm649iXYYagJONla9IxPIgzYfhhQR9UmRueO/iY5pvVMtXh8wZ5G+s5RjffuQbtLLwfbHnabr+7C9Mwr3sr9Pv7gqj7PEXVQDk7R6IsJ8qh7oxVMZ1bmQLxTK1cci3mrdpxwL1toBZvA10bxusL8D3oS8Z3NDq0Dc/uf2r5xS52q9XAHMx1dASQgCUlGwSnBYiD5MkqH0SKcMGzzBdGU9Wncuveo8INDSZgHvMEBe0p4vlkRJmSfaMWvlQHK+74H8IsdAoImuE2RJUgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9wX+FbafqZijEu4bhEoxE1curWdf7u58dsQfSiOL7M=;
 b=GHYEtLEIQII8lgq3CvEpUewo+XiV5/Byzk6/zLjtxGgK1Vly+iT0SeyvpzT3VUhwYdUONv18djKiNm9zlA8GnRZt4ajPek9uMQWVMouI9F6y+ZZCsbPw4z+vnyq1VJUK0hVeAraR1045xHNQq4m4mSUwm8o7xANKEV8E3vntezxOECjMCwaE3A6T8SIexOcuYGWW1w8/H+9VIQ6c+o0kpfdGJIxkN/vq4vjOoS8hoHvVDvJTrBq7ddpcEHhp0Rl9l4x3Ai00BkbVgJsVENNg3NgnnTWnzdY81A/y54Q4rBpUWWPnbtSuqTjsBFIlkQhZqsBPxWC55HBr8LEzJZixbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9wX+FbafqZijEu4bhEoxE1curWdf7u58dsQfSiOL7M=;
 b=Q1FGgDCkoGqySkzRE1dNebpgqh7PKb+mO56iNW2j5JFAogf5jm6nfgTXg2sh6OvQRaeuahLLujE1VPovhoZovrghORxMfgJ1lBEf/i4Zn0uGltsqTB6WdPvpceBQVGiqOo6N+URn5nLOgl64VQ3p2ZbLTZCZaHQ2BvFJoex/kSGe2r3r7Pcfx1MnIDJLxuk5DzyNlRuTdbDrnK9nr3HIg/5llZpqqhpXKlzpoBH852ycNgai779lYVEvPH/xsEQz8N547ZgO8gbbuPTqE3vwTHdu9yFWyUxA+8YbQHxlsh5AYvNoNmXvWaf/HDb2/+p1I8m3y/lXIhpttL3FRWIVrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:02 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:02 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 14/28] net: fman: Move initialization to mac-specific files
Date:   Fri, 17 Jun 2022 16:32:58 -0400
Message-Id: <20220617203312.3799646-15-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8fb4f27-d830-4505-6ee3-08da50a0b710
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB6838550946EB1E443267F50096AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XlppvSzmjlONjU5WncQA4mxATQ92qvxbJPf54nSF3rlFnujKImFVG3t8SqhCkkVzz8oVtEtVW994HrjKUHoKLoDiDg8pTWE3ocmC+QnNeO7qUeIA9ZT0x5ie6DGBfXVRtsPSvdEt+oWE0FqSTY0sxitp8ORc4x+PvG7STMwNRV2J/6zOesM9PwwDOnoKoJT8t0mUaGRf5tsAnSWXlhXzGePONSeOidHak00YvFknNCg4cGSkxGV3ffN/qpUsqLF6l2cXvowgQwnLwEqkMItrIDTs2XGEGz+blFfHK7z0wNAItV78rmCyI5FL8/ngS2F7w0IYUvHWlZrrGevWAjUxFgg+X4ha2oziN6YCQRdnx8DZNJ9zJHtRIPPjl7KA0b7R0RkW/eM+8DchXDDTRWxZMuv87eQmzerNqBQ9PZx9SW4fitFrRTjW+mxbo4OcE/Np0mR0jfrNlqSD22B3YEB2sTfZG2L9pXWeRk0T4elt19vtAjl40vkFvffBXaaNk7qpmZV0pVGwgktP5mQJdj4bFmmPIO3FM5HP2bCBK8cGwqJurfvrFhaAF2UUZppy4mMAPZajefHrsAovWa8wpbbqj2WMkRF4eNraSfGrcjuC7rRbZyJfJBWnIt2S9vsczRKQlxDDehAprgpF/q349AFZ0IEqM/GclU9jtva5P/R/YR/FyASURuBrKVoAQvNDV7IUFSffKJXEe8iXh991nxhS0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(30864003)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2JKcQSatY5nGMrsI89Um2FUdatQJzP4LOzou/YDQx1VvcGFY05ec8H147FVX?=
 =?us-ascii?Q?SurhizRfQ+mr14nE892YNlylVhsKcbmdA0pUd0TydLtBg7BZL3SLEQPSG3q3?=
 =?us-ascii?Q?ICHbp1ZEOEWFtIzT85SUgrgMj1N7vWFtRyoUiq9VmTYFybsKt/XJ9DBFRI7x?=
 =?us-ascii?Q?AZ8rvJjlpCVSTnG+jsisen+KbMlIQDmrcw5yaa6ZKyRAdBByaggGZUK7TgSd?=
 =?us-ascii?Q?ftHxyPQjA8t9sZ5DbfiptRHqLu2lQcm+pcpmk+pcqN5u9UN1qQyErx57LcHS?=
 =?us-ascii?Q?4MMjVPdaKrG40vyRJ5ggj0vktoOgmahkdB2LNhcF31pAS2frdpvC0HRZwAZq?=
 =?us-ascii?Q?QBNBH+NUDkN/nxvvUDaEAt81yQpVU/NpSQjPrhtHd7r4+Ku+Aav+as5HFbz0?=
 =?us-ascii?Q?5U3JFBvv9twaA4r9TVIYx/WBn5Q19wQ9wPB1n0yowW2YeW7dHFq5AR35BS63?=
 =?us-ascii?Q?sPjGng9gI5MJLFdDcIwZ0imRlhJsoeKRGiiExkjPJJRvadFgLkau61pnOlBp?=
 =?us-ascii?Q?8UWMDfNaRR0689Vn8VnG4Z+22iwF2ehpaPZ5P2VoalTvIu8nZeDWx6LMFfIe?=
 =?us-ascii?Q?9tDJGIIe16Yl9TP7cv63C05CIIvheezPQQgDM+sxnOjI2SOAt5+2/2I5OxAJ?=
 =?us-ascii?Q?HnmdKWAkSwRryr8fpLXpX/HnRJRPfYe4XmmklvJAne12iK51SuEot7tumnkr?=
 =?us-ascii?Q?pVSm4/EcKEzXEZa1e9RAqInjW+d2Z/diACGMTQmUhYiFr79Z9l3OWnKSR7TS?=
 =?us-ascii?Q?aZswsUbd0qgUqhf1ibeOMg7eildmjYBdsuknLnAzHOLMinq+Ympj4w6f8fcv?=
 =?us-ascii?Q?ooKaItMwibTIgJQ+k6dwUwmrZiBJc05A3Rmr9s6XpIx+ucw2nT6jARj/PZu0?=
 =?us-ascii?Q?0XDK5ZP/kiQlUU2rswwQ4IDNGmF11OrHFFxH4qTrtLVuGsXkeJp8Bqc55eDi?=
 =?us-ascii?Q?4Qac6s37WTC5yKPZPepL+tDFKD3D6DyPi7f8Jsk4ExSZ8GDk19I5qzBODFBB?=
 =?us-ascii?Q?aTPTP1m8SwXLDBDV2XnZscYEKXtL0dfQryI1my3AcK5rEf8iA8TrQHH5wPVm?=
 =?us-ascii?Q?ozla6iKaWR60w32r84SiHPbjFdRhKFxAWv4v50QmfrLaEqiXU9aJcU5qRx8U?=
 =?us-ascii?Q?WbMMfkoAsQYMgrM1Nl45Xi9iKSSWEA0/HGIWMlD00QwKpHTZAFRAujLup+UK?=
 =?us-ascii?Q?q3pRPypdDc9uJrNqMUgqFNKsFHcjOHdTg8C7jc2f/CpA3rgvyurTqB4w7P9W?=
 =?us-ascii?Q?XcO5VvGqoRZTOascdsSGLsQBuYFulh5AClLBI9upzuYFEzUy9LFm/2gEH1ff?=
 =?us-ascii?Q?F3hhufQoTS7AKwlCpKg/lkxjrvZ9lD+nJ0zbbPIS7zq8SOcgEbuLTOPG0zZB?=
 =?us-ascii?Q?+K70DAVimbOK6tERKAU/Cf9PcF6f5R5+X8sxNt7hb5GSxMqjge+l4j39qiXH?=
 =?us-ascii?Q?MoQUWN3M6dYF7VD8hKGyxtSx+6R5mrv59hQASvXrvWRVLGt34612B43/UvMl?=
 =?us-ascii?Q?PiZx8RWv1CDsQVAbd+vrmNXsuWp6uimVFsMez3xfub6Li/b3o1EYOmnKQkMp?=
 =?us-ascii?Q?Kvi7rS4GenQzYVCEGCoo7qxkIhmZF0c9PZEbzBNlHvStSHcHDWWTEWVaaXWX?=
 =?us-ascii?Q?zaGN/Rj615zzddmCRU2duG4n0IMAiCWiz3j5GrS/rMx2cPmAM2T/1C0ZPjok?=
 =?us-ascii?Q?9PdNaYrY7vBDLqh+suYCLOmppSy8U+Zg7u2oixFcj5LDfS3wkfTQI1Vk43Zc?=
 =?us-ascii?Q?QFC7O7tcKj8Zhc7eKmyk7C6IsOaYIQ4=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8fb4f27-d830-4505-6ee3-08da50a0b710
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:02.5455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXPcqrhn8R3NShxOW+RDbROQYGLwEVSnkvURR/trLrR7ntl5vKZMD/RVmZyqzeLpIQaiaMBI0BPzg8xCzfjDtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---

 .../net/ethernet/freescale/fman/fman_dtsec.c  |  90 ++++++
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  27 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 113 ++++++++
 .../net/ethernet/freescale/fman/fman_memac.h  |  25 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  65 +++++
 .../net/ethernet/freescale/fman/fman_tgec.h   |  22 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 267 ------------------
 7 files changed, 281 insertions(+), 328 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 7f4f3d797a8d..12ce079a356d 100644
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
@@ -1492,3 +1515,70 @@ struct fman_mac *dtsec_config(struct fman_mac_params *params)
 	kfree(dtsec);
 	return NULL;
 }
+
+int dtsec_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node)
+{
+	int			err;
+	struct mac_priv_s	*priv;
+	struct fman_mac_params	params;
+	u32			version;
+
+	priv = mac_dev->priv;
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
index f072cdc560ba..8c72d280c51a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -8,27 +8,10 @@
 
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
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params);
 
 #endif /* __DTSEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index c34da49aed31..4300a21a553b 100644
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
@@ -1178,3 +1196,98 @@ struct fman_mac *memac_config(struct fman_mac_params *params)
 
 	return memac;
 }
+
+int memac_initialization(struct mac_device *mac_dev,
+			 struct device_node *mac_node)
+{
+	int			 err;
+	struct mac_priv_s	*priv;
+	struct fman_mac_params	 params;
+	struct fixed_phy_status *fixed_link;
+
+	priv = mac_dev->priv;
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
index b3f947f071ee..e33d8b87f70f 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -220,273 +220,6 @@ void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
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
-	struct mac_priv_s	*priv;
-	struct fman_mac_params	params;
-	u32			version;
-
-	priv = mac_dev->priv;
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
-	struct mac_priv_s	*priv;
-	struct fman_mac_params	params;
-	u32			version;
-
-	priv = mac_dev->priv;
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
-	struct mac_priv_s	*priv;
-	struct fman_mac_params	 params;
-	struct fixed_phy_status *fixed_link;
-
-	priv = mac_dev->priv;
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

