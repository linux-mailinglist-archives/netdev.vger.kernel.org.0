Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6505988AA
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344664AbiHRQSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344596AbiHRQRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:39 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A335BD0A6;
        Thu, 18 Aug 2022 09:17:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kt1QoqZzLm0atCuwrYmw/gE4L/ypLfv7s+AVlEFDEBCW1uT6PyL6HeIlwk9aGfjbpA4tXLzY9uFUAQ2UUxIpDMkE9yboXyO57IgBC6Pp8cKTdlPOPvLAvAJ/cEG1W6dJkVlche0I+FbKpdfcmnx3EIPohe9Tp9pVbeOQPA8k8aY9eqctprqOFVcXFImetH++9MNkt/DbJfL8e9V5jSZ88rTu7/7D5hpVh6L7EZC/8N+iabrO0hWBT4li0A+XiNMfS4LoOx10IrRphS5Q7fbTMqic1A7ydkSvisR3y98D7tjhtcGoKEaNTsuZZxHisO72UtV3As/yhhFBwJb7qXXYlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veD6HsB/zXZVLYUNWscbV7rOmgPddUpGNACYumEKmQ0=;
 b=QkcBxUI5uE833p8B40geL8eI9EtoJtM7MASO8uHUpSTONajVQkeFVv2o6usJPoyRW5qMftLa+gTNdfyLzDMw4yrsqqZJ4RPTRGcKevXYmSC5rUyhgXYYlU5aAawPO4G+BNgGsb6PNTciUtoEN2J4I514mUeS2diHIK2JsPBnMnoNSB7pYZjKgkcy0Nl4n4xxe6eS+foA7+cYXHR1vsbuEim+Sk5GewwlFTht2zwOAbuVZFS5NUawq6FKtIfzn6U5fryah6tqxsBTfvliCgloe9SdHjJMowoMMlACY79dVJNod27vrAXMGzqH3lrTaGX3yp/aN9P/DqbGCYO3VmQBKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veD6HsB/zXZVLYUNWscbV7rOmgPddUpGNACYumEKmQ0=;
 b=undjFUwGFJJJbqLjGfcCqhs5MRj+t+FLYQCjRmHHFKhFuBkCNh7hbQoWrg5i/dV/H3Oq2XDJuheKdMIhIUi4wfnU6NLGegQthQGFd7AMbnXt2gdc0j/FcqWvkBOFRmN1+Q+xQw2+I9GfsqePWR0axj6eQ+aKrJSiQ/cIK7ow3La0ji+i22Hd2azjK7B7q9i+BHPDATDPAXevJhfjzem0acwSMMFsl8kWOkOkGv5zIBAd1XALCxA4vhfvm200/O+Z6sSNONlRpqcb2Nckf6/2kmxs4WpmTPCQKCljTGIP/yYujToLpslwUBcW4iVCoEbi3ddjOHgGfSqEGFWrQGXIgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:25 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:25 +0000
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
Subject: [RESEND PATCH net-next v4 12/25] net: fman: Move initialization to mac-specific files
Date:   Thu, 18 Aug 2022 12:16:36 -0400
Message-Id: <20220818161649.2058728-13-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4ce84cb9-c9af-4c69-b8bb-08da813522f9
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVUh7laERLnc5Cx9YTp0fmO8bIBqqlDNuHvkZnsvK8Z9X/hSjDYeBRdzu2+Gl4OlR4ACb7ajvrMokTwvjJDL7uSoTpLBk6BqNIAzUyOvve2KeCJrCp7pzhVzewRHuvxuKYNLOvuVR7WBS2uum++EYg+uW/SXlleiOu5xTEkXwzbaKA8svO2HqpRuJra/D6QYS+3pNYoyBhg0nKALxZ8lwuBMcw00ZNX/EMKQjvyCVUfVL087/3gYQuEzWxOOplalHFrvg2uJiAuSnrHUtkVSngnem6xDehx9x0FQuoEZJ7OFnN3y6Kr/lCllthyPkl7vfX6oxfKBB2A5MoGwHqP+Y+pYtIwTExq3iKv8nudKCiWXKTxVak4s79epiCjiSinlJ8iNGyL+IQuWuqtYWqQ4n5Cw7x4+2PbfihQ2RcNGatmKmIELmtwjc+/ezXKNeVVa6LtuXoTpkSuLX6gPYSdJbk5LLniyPHHSih/tSxT5HK3xoaZBiRqOazUgBQAbEC1mvVlbSqJ84csG4ektALLrSRS/Mw7nO5RRGokJpNlCERpkkJtNNm/TBDt8aTYiySL+7khUMvXna9QTYrAEqgcSbPjdMMO8luloo3PP4c2upmYOiMoa0S4wyC0e7TcaviW00sKKOfFca0Y23a80/2t9v088VTzZKh5RQylOOMmpAELVlFXeBQBJvXNSytR93gwMCEjdpE/66P+SIegHKJFxohOqD2UU0lA8V115FKENsP92IDK2dvGetWcY4PLxNsmbHk6HepX92nBkqIG9Ch6gqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(30864003)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dIm3tPfrE+nwR38n1DeqzaqCjdB6cEc2Cv+embbgRtEGBKBlBljuYjuVzjXB?=
 =?us-ascii?Q?ITehf+GbBtIiYScgOdfx8R0mNvhPKvVSP/GyICHiX12a65g7fF3TFcgTNIRd?=
 =?us-ascii?Q?QynWE24pLUCDBKEIN7XIWl6Sn4HbHyjVmdPKVMmDm+MQCDGKWveAUrBiK/VB?=
 =?us-ascii?Q?yJg9XZIg+Ui+BisegONiihB1u/1r/rW4dNKPbiPrpXupsLXCVt7Cw4VSvSUP?=
 =?us-ascii?Q?Ckm6mOhVqjvQdrnfJ6GZO34RGEy6EEnUYduw4HHWupL2Uai4Y6Q14pI6m/ix?=
 =?us-ascii?Q?Wo46SqY+LhGJ7qPEwqME7k3mX7CoE2RSVnOS9DSxRIMrW9ZhQj70pg/hA+8O?=
 =?us-ascii?Q?ZIkuhIxeCS5Xb0s/fU1/V53xL8mC+p+OGLJ7TP0xtYvcDV7XCEGb6MeHt9IV?=
 =?us-ascii?Q?XeqhksNIMv/J5LcOklIBlBAVWpY9/By29ebk/BzOnFlA1HkggjP8a6lUKdhn?=
 =?us-ascii?Q?whxRgKrJT9QcZM2uDvZFOVjS0Miko1zcAOK3VXkrSJL8SU1w7dXwmki3FU8n?=
 =?us-ascii?Q?hbDGg8QYKgxC64d90k0ggLjjrgQi5o938u3JLs0HICb3QpLPfhYFf2BRCHxG?=
 =?us-ascii?Q?Jzc3ezYVe6A45kTpb36Oqdze0vfaFcfTtlfzE5CireDFBYud3BaDZekl+ZCu?=
 =?us-ascii?Q?cR5FiaSejnnBKb7jDow2PSQHHN3sH5Lw9x8s9YaROIXYzFqgJ1jtnygilLyd?=
 =?us-ascii?Q?9p1ruTFmvo2hcy/+/XBZzLPkszgts2YnaVjbH3n3X3ORvuXl9786fuov8hRi?=
 =?us-ascii?Q?ZaLu7fw9omNemSAYS6xjNKe8fCEePx4O4WfjJXOtn1zjFQ8S/MhsEvyjEvAV?=
 =?us-ascii?Q?NDLlzLiDS/BS6ivlgK0q+IE7GEcdBE5wGLDA9JJV+tCkSu+iCDKyv1IVlJyB?=
 =?us-ascii?Q?RsHmHPXNF1Uyl7a4UDvxbdcX79N35MbbWT4tgwL58hm9GVlPqRMgxOym+sbT?=
 =?us-ascii?Q?cajfOB9PjVOe7CsSs4Uxn5uV3pqel6aY2tUx8ESLKQTDmbFDrOJmyK2El1J8?=
 =?us-ascii?Q?QTRuRI4ecdI4uDzXDyAQ4XiY9iVAKwEr4eU+8ZV6VjnoMWnqAqo6OjnCEKFR?=
 =?us-ascii?Q?Tq9amypiceYn8caa7QYlyTyRxkPFoMXYOUKCuSUwKHTy+fNvhhIH7531cKKJ?=
 =?us-ascii?Q?0d0IzCdhc0jyCg3cJrADjgSzP09AQSlkJ4u0lPFX+H6mbbtasaifAusp++7H?=
 =?us-ascii?Q?9WuAjZ3ltPWLkTiq4z6787fRiM7id8Q3h60n5WjGQu5n139HRpDttiDYNQDj?=
 =?us-ascii?Q?1UzfMF93LlqchM4uDVuLiEF70To58gJ3NHPSq6wHUaG+8NdvkTwXbpxAHQCE?=
 =?us-ascii?Q?9ox7sOc6gKgxOpvHPjkTmdg3+5taXPFxwUJr+6hv3P2Mnkd1aRtgClr4ox2K?=
 =?us-ascii?Q?Lkt4bEZTKVgGgXS1U/J8l44u1JXn/ppTziZ7p/kkejsGePGmQamGhafLjuz+?=
 =?us-ascii?Q?3y+9hoj86J8tDDRhxL+ezYSsiKfJjXXPjHw6RBthYPPMZviULH2ZzuPNdwrC?=
 =?us-ascii?Q?NTEjXH5tvEvBusl4R+gumJJ8ZWP4qCTSRYSiNrBYeINlTvhBq5cSL8B7aFdR?=
 =?us-ascii?Q?cNKMpa5ZqMPHWi43OhpR+6gMKHopO+j/uC9nxQ39bSdSMWmPZmz76adqFUpn?=
 =?us-ascii?Q?kw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce84cb9-c9af-4c69-b8bb-08da813522f9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:25.1074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3j9L4MvN9aW3Gf5UC7tD54YTxNYSSDF953HktE3tHyO8ZR0LKEBPihh0R8mp+PeL0Co91m/Oliuo/kOqMT3XkA==
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

