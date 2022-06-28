Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F144D55F12E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiF1WPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiF1WO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:57 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161B0393EB;
        Tue, 28 Jun 2022 15:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNy/vjZEdo8EaqcmO4HY7M3VB4hytftKojgcmfLxHcj9jUFleDvmkoEaJSeGKHHOV1pzOj/6XDU1sGvaDz3GMfpMzrG7AbrH1tn2sMgV1a1o69KAdNvk7FVhv5saUnTRhhXER300uEMRDs29Bnub156MA92iLIIY/velQLigxzlNEvUyEx3+FaKKw2Rzez1ytiSzCSxro/sKSwUdw7nghI1O5t/ioX6B7lMF9sCSswnXFOdGKRz1NXNmjGUrLmuyAq1V77EK/fqvL3Bbn/ae/W8bt8CEwlTEp6GipLZR3J12AbBHb304kvNAA0GMkewqtCGR4TjS/0nGrMQfXIXWQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KqRKo90qF5SMCwXEf7wvpeW8QFnS3p0uFt+0Hs09Vs=;
 b=f03sVNAPfdqBt7kENE5QfxwAC79o5Nt/3GRGzb5tYTFLo+ta79rl1HL+6FONJMAIotjW+QJJu4tyqFmPTC2yIIS4bzUSkqXU6LKtwDWC6F+LI0G1RiNiTc5xiA4spmFpKZ2NWcrWsu0JnHXzBOHPtjpASO7ItnbA8MH5OfPTs26wBzx0xrNJjDbTfqpKYQKcVCZl0Yof4dNGBDg9g4SpiIzcO1g05ysQS7Im3jLEs3XtToJyIS6tu6sOCf/ODbmU+vq3EGmsF9iolvtIU234XUd8xlD6ATswiH+YFeqS34FvylQ9ItutLio7KYbfco/N6wLlsmz1pFPcNDDw1R/RJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KqRKo90qF5SMCwXEf7wvpeW8QFnS3p0uFt+0Hs09Vs=;
 b=PXwYAEGh6SQivcn6wK6HUCnAIayXNTwgqBX9/FRuZs1LMN/Ka72yyTnHvL5jIW1CSnB/s9rkfrTyPcd9iFT7wj29RJ3JJCqpi0Rc7TOOHBW5GhTc5/bZG6GAbtmEceRiTOVJAeFzkizkzJsp6ZwvAKDhD+Mb7K4bh976BEKX4YAPpu/RFBFCNc+FFa/qRPxEKqGe/EIrg1mD8+zNHDHIE8CsMgTd9rIGrjtRITMQZRI+l87K66L6PFWOhf5s9WV1kBALNiNLvtdTPkDKeklisJ0C106ZYGC6PrZ9iFj1UcWk3PmFd+p1ymYFu4WuNJv649Yprd9dkl8Tag5KdhIRug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:35 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:35 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 10/35] net: fman: Store initialization function in match data
Date:   Tue, 28 Jun 2022 18:13:39 -0400
Message-Id: <20220628221404.1444200-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f11d1d2b-50a7-42b8-29bb-08da595395cf
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nz1I6x2JLvPkmIBZ64mGETQ1qcW2dXceBNi6SF1mIGy0qdGMeDpPo/a1k1x/xKoPpXIbE3rDvIn1cow9HkL2PnyrsJxrF5SBBBwUxOseY7qYSj/2ezDQKhJOGYAiNpLoWKavwLpNhE9TKzM/I/z4bJZQPOrRktx3T32XgjKuidHRQlWngSOKWPPFSmEAcsTptEva+pgj8VneD0MydhlaFw2rqEFjSXsytx4N6LWPMyx0dd9m/fko3+g9kT66rBsEyTR36sB/j5IGbTAt1uW9tl3q2eBCxhK+M9ecTU8kISXVKj8ZLKoDJ+ot9/gCE4vhytBLmoCBfW/+zgMuyKmtaNvEV4g2XjbLbZ6Jm4r5wdwFk/3pUT36CxErsrH3AngGuySM8TuVRJfRO9NzYBpd2oo0C+P0bfd6Kr7UaEV0H1Mng2snuUWcsohBnuDGxXkWD3lOyyNWGZ6F+zhAVH/2ktMuewhqvTiG3mLAlCsT4vqSmz/uEuX5brkCpc0VNzRtIWZyvxtSbLuezG0ynUwqeFsmaIT1y3jrWNu10FCWXJ9/9ru7KflxVljbPpwG6GG7gkfdjKl0ik1J3OMyYEziEPeO2R87a7OzeCcpWya4fy7jf26CFxyhZKR+jp1nWQ57IDtZWHpeOHnzcLALJUWQBtrfB4vKpUXxyNbTgkCWoX0v7ok2Pm4VZzMew9QJC206WGeQp6Hh1N0p+s7QdeSDAaHLHRuglniSUjerVDUxxgtnef3YWVhsnQtLP+lqoNE8syFd849RVQFeLl8l1Qdj0lsN63jyj4DTxg9gkEU8STQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(30864003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z/PoKoCh5BWDOaZUEoWloY/09ac/Nyi4LVMkO9hOm2r0QQyG01ayMZFVTdG9?=
 =?us-ascii?Q?ILnmw2DA4hB1btAfORlEYBBUkpxHoAoGnkeaQbuKRVwCOz5e5blrNZ1kqUQX?=
 =?us-ascii?Q?g2dfZFDdiHC8UWv/bDSOkVRQdQXCU/2q/yUXEIrDvjX5LkzOo9mF+DHGl2os?=
 =?us-ascii?Q?ZD7CdE6OpilWhqgJglfrYVyhYrs1PLhv14K2aiasQShkbYZ+NqT1C15+JlhV?=
 =?us-ascii?Q?0XgySbYiRyXB+a8i9MVaJ8fMn1xQXgvePTlI1ML+Can7vIbOrUVmS7ZDYm8T?=
 =?us-ascii?Q?ez7fOdtESb12GHMI5KZkzaNYzHuNN1W4iFn7C4dZC62E+NwU0NkkPWHQ+aJv?=
 =?us-ascii?Q?m4SD9crSE9H4Ud2FVhWfvCFwF/gzxkGAJldXIr2btLmavlTDCIhrkD7hDKUj?=
 =?us-ascii?Q?pFRYmFLJu5RlntOo6Xi3AbinhF26602R7GEPaX4kuKCgzOEC3g8KrXctHb/d?=
 =?us-ascii?Q?SiNywN7KYlAj1Kby6j53yBJyeSMlDClStuGxCv6LFBdiBe5W7r8+2M/SeRJX?=
 =?us-ascii?Q?J5tayiZbTr2YbeuzwKpTgiSly22pV0XLRm9YsvPg1FXCdjO2czwJR/zf0hBs?=
 =?us-ascii?Q?qsvNMZi204ywJtWshWbDLTpMtWqPI98DHMYK2Hrrk/V4CSHQ0qX1yA/4z78/?=
 =?us-ascii?Q?X2iVJWGX5VuhHhw2p6DG5/xZF2aQ7WqEkuROtIz4Uw4HGwZrNAtUd4uWfhaX?=
 =?us-ascii?Q?/D1BCDbV+4LcwygEPrzZUHcX5ms2h3E6dekmFXM6wgMXGpuchGcf4saat3QF?=
 =?us-ascii?Q?Sn7S8wH1A3WhieSkAw7lKYCzo0rh3r6yD+6gEM9lrn23smMoLrwWY1H4DhuV?=
 =?us-ascii?Q?Da0NSdj8dIA9Mt6GwHZgqC/sahx7KyrfN09UUo/z/39kpuf5tMyaD2QE1mF4?=
 =?us-ascii?Q?ncGLMO45aklA7ry8bUXuCs3N2YWRll4BogqtRCQvdza/zN+kc2JB9sR2ci6s?=
 =?us-ascii?Q?wT6qzrOpdwi48wL/VpfhlNgcfP5/NDz+E4ElzY9y5wUX56i3+wWSd564ez9B?=
 =?us-ascii?Q?vm+uavKjGRGunDOIE9aDkm+Avg7qfcAqR0ewhaA/wE1xeEQT5V1ykl7/SaVo?=
 =?us-ascii?Q?jyiLzO+AuYSuEhIHl/pH71VT7XGl7X1Qi8z+AtjYyj9CYTC1Vh3tvgDxAHjA?=
 =?us-ascii?Q?cLlOpF1WvvAYCefVKb9FYiXosWFL92vcVZpxGEQxVE8iGfyq0++t2/NLjham?=
 =?us-ascii?Q?tkTeKxwuOMaeVJpxmViYdnczrUOCj0I8Mdsl83eEXKI1VPCeNq9RRaMF2O3Y?=
 =?us-ascii?Q?9k/9LMiauOYkuxdCyd7IeDXoB+kD/FHnEayLqyjpLsQ+SekBUQDKHB3fGYFE?=
 =?us-ascii?Q?87MmpB2ieNeB2Jhje09hoGD6TpabjMAAK5g5a4xOFJlqiyl7XzXhgEefOSBF?=
 =?us-ascii?Q?xaqGpyQ8fkDUNQLGRilpvErTKzAZbwjijxX7sGttieTD91GTv+99yPjT2fOX?=
 =?us-ascii?Q?rXJRWzz6I3R+XwmLUAUaewcrK+UXFghegTTCS1xbf8IWIJ6J+l+N/ujtsUAx?=
 =?us-ascii?Q?0uVpSh03Zhy/qy7rBHDT13s2+k1nOt2dTVAAXlN9xVCx0dNKyk8OX0PO546o?=
 =?us-ascii?Q?6TTjBnGDNmOnyswGuk+bikPhHFywLo0TTLtKHeYYTQGDFVYISGF8LLVrrKyB?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11d1d2b-50a7-42b8-29bb-08da595395cf
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:35.8292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dh9AuNVuhMQwbK6m59KCkxhHg+yNqsNXQtXpF8th6hUEJr8vS3bc9kaK10a2Fc3m5lcegxAX4OLz6PKrp3chwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of re-matching the compatible string in order to determine the
init function, just store it in the match data. This also move the setting
of the rest of the functions into init as well. To ensure everything
compiles correctly, we move them to the bottom of the file.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 356 ++++++++++------------
 drivers/net/ethernet/freescale/fman/mac.h |   1 -
 2 files changed, 165 insertions(+), 192 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0af6f6c49284..8dd6a5b12922 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -88,159 +88,6 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	return 0;
 }
 
-static int tgec_initialization(struct mac_device *mac_dev,
-			       struct device_node *mac_node)
-{
-	int err;
-	struct mac_priv_s	*priv;
-	struct fman_mac_params	params;
-	u32			version;
-
-	priv = mac_dev->priv;
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
-	dev_info(priv->dev, "FMan XGEC version: 0x%08x\n", version);
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
-	dev_info(priv->dev, "FMan dTSEC version: 0x%08x\n", version);
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
-
-	priv = mac_dev->priv;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
-
-	if (priv->max_speed == SPEED_10000)
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
-	err = memac_cfg_fixed_link(mac_dev->fman_mac, priv->fixed_link);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(priv->dev, "FMan MEMAC\n");
-
-	goto _return;
-
-_return_fm_mac_free:
-	memac_free(mac_dev->fman_mac);
-
-_return:
-	return err;
-}
-
 static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -418,27 +265,15 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 			err);
 }
 
-static void setup_dtsec(struct mac_device *mac_dev)
+static int tgec_initialization(struct mac_device *mac_dev,
+			       struct device_node *mac_node)
 {
-	mac_dev->init			= dtsec_initialization;
-	mac_dev->set_promisc		= dtsec_set_promiscuous;
-	mac_dev->change_addr		= dtsec_modify_mac_address;
-	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
-	mac_dev->remove_hash_mac_addr	= dtsec_del_hash_mac_address;
-	mac_dev->set_tx_pause		= dtsec_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= dtsec_accept_rx_pause_frames;
-	mac_dev->set_exception		= dtsec_set_exception;
-	mac_dev->set_allmulti		= dtsec_set_allmulti;
-	mac_dev->set_tstamp		= dtsec_set_tstamp;
-	mac_dev->set_multi		= set_multi;
-	mac_dev->adjust_link            = adjust_link_dtsec;
-	mac_dev->enable			= dtsec_enable;
-	mac_dev->disable		= dtsec_disable;
-}
+	int err;
+	struct mac_priv_s	*priv;
+	struct fman_mac_params	params;
+	u32			version;
 
-static void setup_tgec(struct mac_device *mac_dev)
-{
-	mac_dev->init			= tgec_initialization;
+	priv = mac_dev->priv;
 	mac_dev->set_promisc		= tgec_set_promiscuous;
 	mac_dev->change_addr		= tgec_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= tgec_add_hash_mac_address;
@@ -452,11 +287,121 @@ static void setup_tgec(struct mac_device *mac_dev)
 	mac_dev->adjust_link            = adjust_link_void;
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
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
+	dev_info(priv->dev, "FMan XGEC version: 0x%08x\n", version);
+
+	goto _return;
+
+_return_fm_mac_free:
+	tgec_free(mac_dev->fman_mac);
+
+_return:
+	return err;
+}
+
+static int dtsec_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
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
+	mac_dev->set_multi		= set_multi;
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
+	dev_info(priv->dev, "FMan dTSEC version: 0x%08x\n", version);
+
+	goto _return;
+
+_return_fm_mac_free:
+	dtsec_free(mac_dev->fman_mac);
+
+_return:
+	return err;
 }
 
-static void setup_memac(struct mac_device *mac_dev)
+static int memac_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
 {
-	mac_dev->init			= memac_initialization;
+	int			 err;
+	struct mac_priv_s	*priv;
+	struct fman_mac_params	 params;
+
+	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
@@ -470,6 +415,46 @@ static void setup_memac(struct mac_device *mac_dev)
 	mac_dev->adjust_link            = adjust_link_memac;
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
+
+	if (priv->max_speed == SPEED_10000)
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
+	err = memac_cfg_fixed_link(mac_dev->fman_mac, priv->fixed_link);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = memac_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	dev_info(priv->dev, "FMan MEMAC\n");
+
+	goto _return;
+
+_return_fm_mac_free:
+	memac_free(mac_dev->fman_mac);
+
+_return:
+	return err;
 }
 
 #define DTSEC_SUPPORTED \
@@ -546,9 +531,9 @@ static struct platform_device *dpaa_eth_add_device(int fman_id,
 }
 
 static const struct of_device_id mac_match[] = {
-	{ .compatible	= "fsl,fman-dtsec" },
-	{ .compatible	= "fsl,fman-xgec" },
-	{ .compatible	= "fsl,fman-memac" },
+	{ .compatible	= "fsl,fman-dtsec", .data = dtsec_initialization },
+	{ .compatible	= "fsl,fman-xgec", .data = tgec_initialization },
+	{ .compatible	= "fsl,fman-memac", .data = memac_initialization },
 	{}
 };
 MODULE_DEVICE_TABLE(of, mac_match);
@@ -556,6 +541,7 @@ MODULE_DEVICE_TABLE(of, mac_match);
 static int mac_probe(struct platform_device *_of_dev)
 {
 	int			 err, i, nph;
+	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
 	struct device		*dev;
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
@@ -568,6 +554,7 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	dev = &_of_dev->dev;
 	mac_node = dev->of_node;
+	init = of_device_get_match_data(dev);
 
 	mac_dev = devm_kzalloc(dev, sizeof(*mac_dev), GFP_KERNEL);
 	if (!mac_dev) {
@@ -584,19 +571,6 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_dev->priv = priv;
 	priv->dev = dev;
 
-	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
-		setup_dtsec(mac_dev);
-	} else if (of_device_is_compatible(mac_node, "fsl,fman-xgec")) {
-		setup_tgec(mac_dev);
-	} else if (of_device_is_compatible(mac_node, "fsl,fman-memac")) {
-		setup_memac(mac_dev);
-	} else {
-		dev_err(dev, "MAC node (%pOF) contains unsupported MAC\n",
-			mac_node);
-		err = -EINVAL;
-		goto _return;
-	}
-
 	INIT_LIST_HEAD(&priv->mc_addr_list);
 
 	/* Get the FM node */
@@ -782,7 +756,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		put_device(&phy->mdio.dev);
 	}
 
-	err = mac_dev->init(mac_dev, mac_node);
+	err = init(mac_dev, mac_node);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index e4329c7d5001..fed3835a8473 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -35,7 +35,6 @@ struct mac_device {
 	bool promisc;
 	bool allmulti;
 
-	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
 	int (*enable)(struct fman_mac *mac_dev);
 	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
-- 
2.35.1.1320.gc452695387.dirty

