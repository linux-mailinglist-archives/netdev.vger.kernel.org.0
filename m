Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447DF6570EB
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiL0XNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiL0XNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:13:06 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2069.outbound.protection.outlook.com [40.107.105.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF83F101D1;
        Tue, 27 Dec 2022 15:10:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkzZChnA9v+9P8EpAykEQAiptTbZc5+J/mE6hLQOpkn+z4s+kedErU3KgBcxYzVP7yEqlicS3D56x60Y0i9dXfhNDEPE4Xnct8ojUDkMxzz4QJP4iGMYgkfudJEaIGOH1PmUuOt6G5mJQf8TcmmKqfOtljc2FLmJExPViy7tCGSENqmPJjv5tgmgDjkBj3s+pCDPAB9vhLUnh9CYPGg64j5CAkB9cIa2U2sivtNvReUzvOYapsmVHwPbf6KyPozvelzjT/mbwiYQRbbjaa8mQWYoNchw1obpRPnLUnnZjs+C6DwAeOhkafKeAOuLUdcBrajZCfo1WPs13GARd3HDRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thyWbRt3kKM/EVFjOZm9QUujBvzsWYrtg7iYkxRD3qQ=;
 b=ACBip2sNx82Ez1Rl1phMkJlpXrMlqkfeu+HH/CpDIisvbGudeMcI0HnyGJ6ZTn3GZ9vKnQyzypDKVRoyPdytRhj2dQL3y2BLCcHZYbHrPRV+dzSnNFCINBx4nNZfyVIYFbe6ttE/6t/CBOYRAluQRxcO7gjf5WCOzVj4hpPqbU7pWL/059US/4CcSk0FzgqG8cQg619bjtZS0+zWbGE8s9KK2C+ZfzesQIhpGpbo3xs87CDZu0CVMiufd2riMm4z1DBu9rp+ggndFcxAzXODWlPA3CIHl2/wklPFUu67jVeWlmHcT+88HXb+4tduSR7v/yZD+rIGCACGt879omB5Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thyWbRt3kKM/EVFjOZm9QUujBvzsWYrtg7iYkxRD3qQ=;
 b=EXQ2Dj06/kUUPyxXJe1RDcBIZgW5p5EyrU4PiIbJt/H5pme+0tfVQ8ZYLIEA4N4IMqaO/VoPkZHQniTT4HQMcTzZlWHAbMs9qH8B4uqnbAD9bxTcj45E3iJ91hsBxYeu6y/ANHXJfyLQuPR/Ooc8t6Q9RFkjSZuFbO4Ud7Sh19DRGrPBTc84tA2lJsTAf6x8Er1h2xlBz/04lzPjryR+o7R9Tq9/mUeslNgpcmmz8olzmA6T/2VSHshubBvtu/FrUOU2DUA9hOX6i4KIJuo3x0th6o1BvM8wZ9M7++BkuYqhQ84xGeo3T0XYx/mBPCBKqgYWgZJY7Acrx2nvSU8KfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by GV1PR03MB8840.eurprd03.prod.outlook.com (2603:10a6:150:a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Tue, 27 Dec
 2022 23:09:29 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.016; Tue, 27 Dec 2022
 23:09:28 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net] net: dpaa2-mac: Get serdes only for backplane links
Date:   Tue, 27 Dec 2022 18:09:18 -0500
Message-Id: <20221227230918.2440351-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0279.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::14) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|GV1PR03MB8840:EE_
X-MS-Office365-Filtering-Correlation-Id: 353e07a1-291f-4c66-d633-08dae85f677a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y4KgARAbjJzdO4yhhFRhPjG7idDyH7zuGD5RsXhLA8svt4juF/C8Glxvt5TISMcX5Xrb+Ytw+Hx3VFOMip5MqPgwmlTIcixFVhbyTB7EzSZW7XPf2ELn3ZK2uB+KjA45T46LEx12BlNc1fMD0dNrf774TcaVLXeexyteJ2P2ALq/xn/UUr/sUsDHuIZwJa82+4ZWc2KlXoXmSbnR3uoo8jHxEGZvP6u+lv+iOGhJXRnKtDUtaMnQkT52MYhSW+hfTztsNDNqiOw2CZipLppvN9HoTBB+IVo1cYRwLcDB/nd/CADAij9OvOiN5tq9ARpXWjHxl2+Wh6/XMUD+nvhqEiVRNX7NbQNn3zXJ4u9B/52il7migiOsyXNOfAAu0E6yOUoTN7LWYkJ3yIyCaerGmtgQAj/MK9Cp0xXHiTZTb0ZZuDuD6zIPzyA1pcCGshYGxrq94a46PTqcrzz544qLZowwO6EcAOjmOpMDPt+2i6hY4L9HxzXydLPkZbFen/wDa8b/Hbn+Fmp950rnodbt31oG46nWPvwLxXcUSKZiJz0hrY6pXNtsOluPTM47SsGhP0n8ffRN37BmCJn0D6yTu2GpC9pZrJd07KCDaR2MHWCtbirZc4F2Q7XmVc2rCVWExqLqvuniiNQHJv3uOLVGe+958CdUl9hmo6o6kTNuOA7BkxZBjHQVOpgixPNnIEfwxVKyD32HjrStxf7iMzd6bkCi9uDA/idSr1ZliTpOf9M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(346002)(366004)(39850400004)(451199015)(83380400001)(52116002)(186003)(6512007)(36756003)(478600001)(966005)(6486002)(86362001)(26005)(2616005)(1076003)(38100700002)(38350700002)(5660300002)(41300700001)(66556008)(66476007)(66946007)(6506007)(6666004)(107886003)(4326008)(44832011)(54906003)(8676002)(316002)(8936002)(2906002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EbL4ZDRFQ7/zyX9iDa53LqG4YPYGtf2ASFaf9YVCuVnv1E8UL/Wvse7AJxSB?=
 =?us-ascii?Q?8MeMDjAXNKD6agA4HqOYV557kVVou4S6CLnYpHFBkHSzhVOvuVSsNXumGxvI?=
 =?us-ascii?Q?H98A2SzGToq9UBG8fpcLrgNGvmVCv84Hq5R9GRL/pxuj17HOXh7aVmLKtVtz?=
 =?us-ascii?Q?Rc0mLwrPhCKVkxe0ihr/Kyhx4cNZOzjMCXQpvcURcTVkEizXFHOjE2JwW/ee?=
 =?us-ascii?Q?Qb34hUJbH10QgVeoC8zDNsA0u4lPrUoPKchFMx4Z6FEolt7C8JeMUJamDYuY?=
 =?us-ascii?Q?phZHhaXMbeYLVvzqmnBM+kdsFKfwCRc/fSMXbrjMJtHEpOemF3r7imAqubBL?=
 =?us-ascii?Q?9vT1PNfdwcsAPEGyWqduJXwKY4+LD47bVYpuJCApocV1X+FDochqInUAoeZj?=
 =?us-ascii?Q?3Efi8P+CSqVyfg27ZdDafkmiS4DxpumC74YbHDuxIR2iSirzk4xJ4aLJxZV1?=
 =?us-ascii?Q?Ly5YZPNCnNqPoxb1Gr3Faue2D5B9zEBXYryMGhqGqOb4e16Io/+BafXIUqdm?=
 =?us-ascii?Q?Y0xKOu5Hay2eF288XBR3zmnrCq9ZlQrAzolZbLIq+CCWWIxO6u+oM4JB788/?=
 =?us-ascii?Q?BcNdQXLcsFTL0H9hkvt6ijMw1uqwf5iiSmAx5+KrFuvrBVjmFyN7zBANOG7V?=
 =?us-ascii?Q?T0EhWffUomGbtu0Ixpcqu2Up+9lgTP5Y1Ft9If7y013Mz6aHgGgP19fmnoU+?=
 =?us-ascii?Q?Id5WE4nj2Ky0VVbR6bmceSJdVXkB3wzVvGQZnZPXns9E/FrNwvJ025XpIKYn?=
 =?us-ascii?Q?lJ6v5HdJpUpPQ6SYeIhcivpvSmUGZbpRm9sG6VsJLb8xMYQPhi1RToailQUQ?=
 =?us-ascii?Q?Rt3WkT4U3JqAnb4CMZq63CAAGRrI8Nv67+9A+fGbDIlVACHn1cd6fkqofvc2?=
 =?us-ascii?Q?PrUUEKGPEw/k34gbqEUpsGqQ3VpBg0mS7oiiJ9NA7v5oFYaX9tvIsD4a37U5?=
 =?us-ascii?Q?9zTS9F3ScQeIOiBV5uWnvsetLVQ6xlX8Uc/g7LLf12GwaGAz/zzC9irvHjWA?=
 =?us-ascii?Q?eHw3xsiCeSRCOfsZ31OgKOxLBFUtVMB4p/rK0IZ0EYSVZKPufgNSm5Hm7vDU?=
 =?us-ascii?Q?qFcFQz1cdtGG5XpP8kAeVIekqOKsVb8yMlIDtLEMAqXwT35YtqiRW/XGDxVC?=
 =?us-ascii?Q?fdM3yA1tO7RtfTkcqEwwlKTjDIS8xorOxacPRi1615kS5eYBgvgclyFloDI5?=
 =?us-ascii?Q?SIZiasFaJFio0I9luJB9mFpGS8yWJI1jjd3gujd3TcZvkztvI/sT7VmYpqJW?=
 =?us-ascii?Q?PkIwcpVgVsSWZI3M2gXk44D5Zxhfb1/dpmbPSiUCs6/YKRiBZcCh7vdZskJQ?=
 =?us-ascii?Q?bzXViMcechT9Pb7Lb6BAZTuD7fjhW2r7Ejdal8OixTycRDOXqWIM2RaTsYW0?=
 =?us-ascii?Q?lOiHRAkEr8SEAhzB+OAiHeHXkkZgPZBz44VgvCY7R6VDfAsi5BNFyqPDzI+I?=
 =?us-ascii?Q?jKwBD4G+68+N8LYa67uI9aHpyWfQWZe7Od24GIzxjAiIJ0PvrsnmJLc7mNrk?=
 =?us-ascii?Q?2lZwTybpuRdDJ+y/3MNdjOW+/2+kTFHSR8a59uVmeIiZubPwSsBwTtnyNQp5?=
 =?us-ascii?Q?Y7UvqfgZY4VaQ3knDV2gyBEZYSGIjefqSHuaBIlhxxy1kvzTlDlFcniDWh8Z?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 353e07a1-291f-4c66-d633-08dae85f677a
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2022 23:09:28.3237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eofMNOX78T//25Wh+7vwAXLxFGElmpMKHzqAp01zAHORzZZEPrE8SPMJDXKdrk+bcZqhr4yKv46msTYMn9mXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8840
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
add backplane link mode support"), Ioana Ciornei said [1]:

> ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
> by Linux (since the firmware is not touching these). That being said,
> DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
> also have their PCS managed by Linux (no interraction from the
> firmware's part with the PCS, just the SerDes).

This implies that Linux only manages the SerDes when the link type is
backplane. From my testing, the link fails to come up when the link type is
phy, but does come up when it is backplane. Modify the condition in
dpaa2_mac_connect to reflect this, moving the existing conditions to more
appropriate places.

[1] https://lore.kernel.org/netdev/20210120221900.i6esmk6uadgqpdtu@skbuf/

Fixes: f978fe85b8d1 ("dpaa2-mac: configure the SerDes phy on a protocol change")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
I tested this on an LS1088ARDB. I would appreciate if someone could
verify that this doesn't break anything for the LX2160A.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c886f33f8c6f..0693d3623a76 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -179,9 +179,13 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
 	if (err)
 		netdev_err(mac->net_dev,  "dpmac_set_protocol() = %d\n", err);
 
-	err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET, state->interface);
-	if (err)
-		netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n", err);
+	if (!phy_interface_mode_is_rgmii(mode)) {
+		err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET,
+				       state->interface);
+		if (err)
+			netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n",
+				   err);
+	}
 }
 
 static void dpaa2_mac_link_up(struct phylink_config *config,
@@ -317,7 +321,8 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
 		}
 	}
 
-	if (!mac->serdes_phy)
+	if (!(mac->features & !DPAA2_MAC_FEATURE_PROTOCOL_CHANGE) ||
+	    !mac->serdes_phy)
 		return;
 
 	/* In case we have access to the SerDes phy/lane, then ask the SerDes
@@ -377,8 +382,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		return -EINVAL;
 	mac->if_mode = err;
 
-	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
-	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
+	if (mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE &&
 	    is_of_node(dpmac_node)) {
 		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
 
-- 
2.35.1.1320.gc452695387.dirty

