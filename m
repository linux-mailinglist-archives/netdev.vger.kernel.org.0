Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D800A576971
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiGOWEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiGOWDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:00 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50080.outbound.protection.outlook.com [40.107.5.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8FF8CCBB;
        Fri, 15 Jul 2022 15:01:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBHBdd6tr46aixzVrChqyVBgWkrhriv5aAaD/z+PXujjAlT+zW9Y1biCyoiyJw/sVhsf1UbiiUufuh4jMWEynQdbthq0HDurbCKg2nVutPj6rlzfqP1QXDtI2eDdJ1eh290TfgvZcwI/4rsohpod64yxPyHjgR/sWL5MmitlTqWRBvMfyAvMt5qfIYu2BU2MuBBJRXtOn74M1eavFZPTUDySP3zuOLugaOKLwqFzIQxZtOPN0u1crNz34e6nImzrtt0DQT6zJkuCIMUbvL5ioifBydmMsF5v5NUp8u+B88Z2+w5N5+u5RD1vXz/KKbLPfyB62+355ZRyOmONzU4r9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KqRKo90qF5SMCwXEf7wvpeW8QFnS3p0uFt+0Hs09Vs=;
 b=S+7IdForRyO6Ll+fnFwDs1bAaJm+YcdIl6OxvRySOhoR7BCr5/VdOnx3lnwj62NxfVdF2U3/ScbG+KhYIGyf1Xez8JFnU4nvlFaoHvtIHcGUDgHf5jwqBWag2m8UwvcAru5a4p6Cnq7NHdjG0VLmJxa2Q6w1w31OFPJ+sVlaX/++uwXNJ7WNU0Aeo/6dQoNZic6wSOWlfzCk3EjG9DXvVtd8D5cUhsC++mI6bf76VjtCBp91ZIAUKifWf1UZZJ00PqaqH+AUxRF0ZuOytt8rQ7ZGUqVQRqGdPWfofJOYoK+gvbWWwswqTEcpdsgNMbkfVbKxMzFwPf2tsZ6NczEEZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KqRKo90qF5SMCwXEf7wvpeW8QFnS3p0uFt+0Hs09Vs=;
 b=jKNGd0od4M7ascnXJPZhhYyecoy+OJQykAdxBWb+lsQO1KqEcbHY4l6NdwJy6hJ6UDFnRby1xoRBaZZvmAcUl1/btcawMHFbkGZUL6g8uFdOHYYhXW4OE8hX/GcPV8CHLPuYta0SR1p+6C6PEL4IzTCEkg8yUyf6IDXUZZzbCT3QCSz5dbubMKRNpYn4V/ZBuw/BYAuZCvzygZZyTj9JKGDJyeJUzdiBgNBFM4sbDtMvrHp60s0/GcUXd84A49tcLeb0JkC3+Fzwzp3RdyaqTYW652uW+HTgbWpJ+wAVpwjjqIqqa/IXJ5CN34Jwj7utf6yb72coe1c6Qi6qSRjFJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by GV2PR03MB8607.eurprd03.prod.outlook.com (2603:10a6:150:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:00:59 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:59 +0000
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
Subject: [PATCH net-next v3 20/47] net: fman: Store initialization function in match data
Date:   Fri, 15 Jul 2022 17:59:27 -0400
Message-Id: <20220715215954.1449214-21-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 10e8b726-8f95-45fc-3cc4-08da66ad8054
X-MS-TrafficTypeDiagnostic: GV2PR03MB8607:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvF2YL2ghvM9s4n8BHJh4Cv2Fr8dAodWhhZs+NTS5b/z68g+lXaFCWx0/Gna3UJZa7zL/dlCbI5QzZXNbw62QUFUSxBUMHY84XLIuGYIQh/xpQQSVzVGcLKiuIYps/xeW+cIFu5s/sltFlGRhDUX0QD4wy/EFJstR7bzCSmxObQC5GeGq3fgkthzrwhigoPEovh9WDkLImb4in+guAV0Y0ycYNTw2QC7sYI4IEQ3E3I66qGmlJNIsGCitWxU5JHDpjkWtuG8Nic21nZCq6vEqi6/YgQxlwZ82Mt2zJBZS9+7yTbqqH6loYOU2Ygppe8YdqWszxZxHh/duri31kNcctkHuab0gtnlAYjI/x6KyB+W9p31pwVwCIzGQ1LvJCSMB8CgqCrG+5hbe/gNc0mElk8DKr+7B/pYMcu1HrjRIngHo+yU3geKomYEmgpTm4Clm5+ZHzwau2I81VOfZnZcNfICCz4i5JfYSTPcrt0UQeyUaNNdwdA77zUA7AzHwg/jHnIyPux3JXMQv8rUCmkoVLCGeN4dTwws8RiuhVooFs6FpekncRW+wSds3mr8BjZ0vQfQSMBX+WkK9GOQxvCOgBi3OXR+zwh+alKEkLCazBUS0tho9PsjsBKvCQjep7fd4GLFllxqIFXtUfHb7pdPLCgpKXpO2J8LJ/LYyP2iOTpRtKxGPeMJBEM06AQ+tv+ETLa9ge0Wtztkvy69S0JSOzhFFNdjU5cGu5pbH5pctERz8aTt9NgHYkVAZ6Ls0J4JYfQgJC3m57TMHzIvTN3t7OcmhTXFPa0qUTh72H27uVR3tcUU4QkS8SRHXIPl9uAm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39850400004)(376002)(346002)(186003)(38350700002)(66556008)(83380400001)(38100700002)(66946007)(110136005)(316002)(66476007)(36756003)(8676002)(4326008)(1076003)(2616005)(8936002)(30864003)(86362001)(44832011)(6486002)(478600001)(6506007)(52116002)(107886003)(6666004)(41300700001)(5660300002)(54906003)(6512007)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MEOnSXTQHZ4VGOsNmttLmeEdD29KcAOzZIPRlbynx2jCsHLpg5O2Sync5Ada?=
 =?us-ascii?Q?W4xwW0vUgp13eWz1V5LLJnuvGc/9fARpftDoJnbE3Ww7cLPU3Z7wpu6ON+g9?=
 =?us-ascii?Q?0cke6BuOPjNzxbrsnfAPK50XDQgkkIfOsKyQtMu3WRgQ2G9DMdKD9qO1IChn?=
 =?us-ascii?Q?R3A7JTDzEs6WWbcnrzfln9zDyyqF61ea97PV/uq7xF/oAwvq0MPJsDIdrh4z?=
 =?us-ascii?Q?GTZbJUsLDE4Xgo4ukPpBwDVpEXnjvaLWIzJCvPq/x1ofwnoIV9NnddMefB9J?=
 =?us-ascii?Q?KgZpE0I1Lmn/nj1elx5XA+830uK98xjyWvX35oq/HvCFvfBDczSaYoqehUC/?=
 =?us-ascii?Q?1Xpvbd1R/UQt/5GgK7Rs3QSYm9vtshINm25poLO5aVB3xLHfb4mO9RLFDJoL?=
 =?us-ascii?Q?qAla8ssRDkHJn+0EImWGwzzUzLRBxhlissPLJj7m87BqslzVjzFKhpU4VsQG?=
 =?us-ascii?Q?goaI1zcWxoL6mtNzXVb2GBvILKzPjvli1Ul2rPUWpj4YS1H0oSHZKCvkNaBA?=
 =?us-ascii?Q?aCHZx2ROKP2i+JOWLCmejLMrWCpp2YF3aLCzRtK5RZysH5OZE3Xfp7HRQ2gN?=
 =?us-ascii?Q?y+PEi/ZsZ6NpYMc0RQWqOTTY3NSWDzst2M7yny9LIZ1zhoH36GA9Opx/SSGr?=
 =?us-ascii?Q?Xhhyjzg4W9VnJJfbduy4U38dUSKEApabgHD0QzqNriHh/15QR1ZkqREKrD95?=
 =?us-ascii?Q?w33GWRKVq+93VkQq7O/40KdFIv2sZl6cjgLr7UqvMz+NLctg/nSRmvyNy4PV?=
 =?us-ascii?Q?aNwKGbjqMIzhMDjpCls2lFiiH11cZ/sH3lHHwQTmTTZ/zmBWCu6dfMIzDbcO?=
 =?us-ascii?Q?5tWOsob3ty+FnWqtETMUev6EgiZCuXlASmSag1DVSIE2ejRPCJ7glCBSXVaT?=
 =?us-ascii?Q?sFNB/RfaD6t6kxlu0XA6YOq64wLPA+sn5sOjBktCT7PxteCW3ZyX38Rc3xqx?=
 =?us-ascii?Q?wJKtbVtS1LzUUJ+cPrkfsTdxneXzWk5WCXMQUrM/8+m7EoP5mRoKvVoQBfOg?=
 =?us-ascii?Q?K2x0b/wjtjgARjWI+uiviQlR7SgxePdLXbEm9YlbaN7duZVzg/Zklm8pInFj?=
 =?us-ascii?Q?vUNm4jMs5BBnqnh9g8Z5yaM6WkDXEKBRS55KqFFpCbKSICg04YcTu0khzYjo?=
 =?us-ascii?Q?Sq3tlNIY4AwZ9CV4FLbZWZSJFyNAKOnx53e1llx0K8icocKVTmA8ibG5TAz7?=
 =?us-ascii?Q?3ko4OJ4blaFoLbdHLjqj/wMl23LvIncksAO7tu/nGC44Zn1TuO5NCM00p2fe?=
 =?us-ascii?Q?FcV4LqTZSV/MT6SwQx5ULWcqkZzj1s/uMUlbaaAjhbf7odTyW17sHbDi2Dbf?=
 =?us-ascii?Q?mg6yJ7y0KMaOuoukEEWbo0WhwMDIOnI8Ut5c0aaQBIxvFUixdE4n9GIt3zPw?=
 =?us-ascii?Q?WD/volr839uCJAaywJt5tEff62Dfiqu1daq8GwEXq2uNvGXzhg8bbP6Mr20g?=
 =?us-ascii?Q?u8d6RXqSXeN8Pf5bwAeY5wvRpxtKnQkZXp0H9aVYSJ6bUwL43X58rcN6ipk4?=
 =?us-ascii?Q?MSB1Te3/0UYYG4jKa6i0FHIpXdjcTrrR24fl8OWkI8y5TtHRGteQToWuIqhs?=
 =?us-ascii?Q?UvWDwfCFqscnB1Cj2AiBUX8L6Ww6SA0evRTC3ve+4FzvTV62MEzjWrRqDD4h?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e8b726-8f95-45fc-3cc4-08da66ad8054
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:59.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajiI4TNryIow/+31rs5IG8D4hmxJ1yf/P5Ewu41nsm0Y15yy6EXnqNfDZzbCIdnTzUc5Y7cXnM7sO2jHh4VXjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8607
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

