Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E663B580141
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbiGYPLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbiGYPLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:24 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3502919031;
        Mon, 25 Jul 2022 08:11:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibhG6odQYGIpk3yUj8PXNC3x1Uher1VdzcqTp9E8xbx7jXnXVEFL0M4zveaxsstMWortxXUXW0WRIzTCLQ3yUa9bwQ7ZseW4lE2mUSQfNps/BsxcYUzQzuenpc4v5NgmO41cwxc7aTcpbFJOQ0eQ9JCXq30uh/r+BH1WMD+XjqH64jfE7dL8OWtfIMP9hytLHHWgP1T1ZdX/FgojZAdHDK2tGe7RN4S/4/F6zzuBoa6CX9ea+IwyCsiOPTviDcGRKh34fIS9o4m1tbVEQtS3lQ2+VgHV4r7FvkOOa6Ytp0N5eagTxOme93P9gecccUCHSQ18SVyeEYyRculDeUBd2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocQkgqrX6Z35C99M2VgFT5kfphkMMnx1HLgZf9vIK4M=;
 b=H42JxlaUiI2QTBB3aziPE5e+yp3XMrP+CLpm7/F9/6nFxs6Cyvu4aQI/yHnX6W2icP+UkPoJly1rCOOrwSfe1tWb6HhDGKGaecM65UB6+cvL35rI47IaR/eZsbqOXPiEtxmGG2b5EgZMZxjrUYD+LEkhPoqfVCnH62xEPJBLzcE/dMGYUfsu0Hoks50626jNpW+4fkwUDpozASo+rFGsov/BMG9MaN4mroo0C0KQALNKBFBB7aSMjlJyXQl+IOD6ekDxz9WX14CsNgzov5EwkzMzczOEEJmAC0FTyZbl7Qk1kYtAWi1qQw2eCsaLT5ArhDZDF5CfIQSkrC+TGKD+2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocQkgqrX6Z35C99M2VgFT5kfphkMMnx1HLgZf9vIK4M=;
 b=prqE/BdQjl+7H5bvk7hVjx8L/pYKO9yYjEyb3i4dZcMDOYn298T2zB2Ep2rmJWJulRqeTrpN4RkiVXF9XnzkNLxQzDGRU4+4qPMLjPvj7EelbwS1sHPKi5Us0O5fmwbYOkYXcii/aFg28MTPCdOHO3bJKGnRKW6Rr8QJW6Rd12fcsaycze8/sz7Cnc3UmMgFlXcVUytH+FaiBZmbH11BSokrA5v3JpfsLyvKKBxlsvQhJcT2wYvpFnNGpP+stt/omxMd7YTUWKdaBaaIS4Ke8L/Brm1QaWVf5ktfEXDSBFwbMWkyzQfykVwy7HOZ314zFei7bAo6mHwQuwQEir63Ig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:10 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:10 +0000
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
Subject: [PATCH v4 07/25] net: fman: Store initialization function in match data
Date:   Mon, 25 Jul 2022 11:10:21 -0400
Message-Id: <20220725151039.2581576-8-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: aa0d351b-7c26-43ba-9227-08da6e4fe848
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ibkff2R0Tx/R9eH1ot2ZxbshKUaN+MPaXiqd/VwcxgF+f/ytXeC6EWv7euzzKwB3vr8dsDRqt9WWGjp9duurbTBj1mXsw7bmPrHB4g2ttAeoo29I4V+iE6wspwf0y4gxsvEMmSXcrxXf66mqEj0WyEsF169e8eKjwme7K+lh+UtJmCWBLY27wJ7ryMmrd9D+6oye0chWa+iQuh8HOvJVk60c/SNvmd40cRirUhvm8r9PgIqRpAmS0M5dUCRe6zTJZhRcBP5PPa4WDV65A9/Pxfa9gsL0dIARcX7SJ7eC0Lt3AwqvukPRAluNH2XLXHFs2U7+/pusTttLZG+nzAiah5NCoAJRilZjL5cguJRdxzvO7sRBDo8uW5KWSf36euVUvGyRNv1eUWpGlkFeJ0ZTGSjiAK7QI6+qB/bydd08U9OtStFbmXvkBf6WFF+8WXJrRotdC1UT9953DecPxqjg6ZG7sxmEAwl0Ozm/DoOiHKVF9o6ye21IgqGXdrBbk0RUKaw6igEOj4nz9Tggvsr1vgvpHzuBstvxskNwMGtFYwxBx27ydUMsliH1Hu6kq+ohV29D7N+0uRA4PanJzLZtLaX4fWzwPGWfIcEMS8Cb3FObj6fvUI9lBWNkrYWiQqmA3d/TFmN9JixUiMW4XmPH/BAfFC06dFDqP2InGII+S++AtqUxB752oDkXIibASCXZQuP7/0uodp1pRalDXGkqoc+SctzUQ+N9IvLD4gMvUBSBPW6ukGfBlJ4x1r9RI9IZKFjPLVmJOXmEOs4F2pqyKfGbKCUTSryki6MdqGS4n1Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(30864003)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RLhaj8rcWVQ54anJWpXboEDXh9msz84fizxPEovgSpcryPwifBJkUmj9rDHQ?=
 =?us-ascii?Q?b3TjKHMZhn72KIvLRkhoV9pyEla/Gzr4RJIUDjOfeE+bBuAvUY380CyvoTxo?=
 =?us-ascii?Q?rGMT7BNLYGOmANnUUceezEJ/v3kqhAB9d9s8sbbrLLphFH6lO/UQxdRdE6M/?=
 =?us-ascii?Q?s3CiMDuLMQ2fFTf5EaHERV5aOe/pquzmxPJNcyi+XpOneB5FLLefm/gOZj3U?=
 =?us-ascii?Q?Iale4Aew86TbN6fiG25Mygc65j7MONHlTM6ebGKbYAHA2djDDzg+I3TBZO/t?=
 =?us-ascii?Q?veWqWJ8RU2qf8P9l9nN1mOYphDnJxGj6sxfiBRZXFc6yHripbNKb/qw9eHge?=
 =?us-ascii?Q?R2cjbDRp2tf7Ygm8dvUVivjsy+lU5oXqVDr90mym8ova9MMjeCUbzcj1Moec?=
 =?us-ascii?Q?6dJ+A3JbqMBZmlxUyf3oTXf4kHPW9SGCXWpAiN2phGPQt0piKTnl3E1WNvKw?=
 =?us-ascii?Q?ofix79Or2aRAkj74KrV+tY0+rRwwIHddYABGI1IRXKZyAsvAstdI7k0OHWEE?=
 =?us-ascii?Q?TNrMRldqxmotWkHHr/LAMtUUpD7cLFvTv89UN3L9TuwyfVfHQQhVABuK5Ji4?=
 =?us-ascii?Q?P3O3FkLqRK630qDKQVvO6dqRwmUXh8memwadxfOfnCZ6YJPlpaFdVF56zSFr?=
 =?us-ascii?Q?k3VdWPS5LU4aDMlOCoiu0MtTZ+32U0AUJnXtQ4U7dLJxhNFcLS/rmvXaJnz4?=
 =?us-ascii?Q?PmNwQ+AhgrhpsN33KBUSfr3ZgmWIpyaCMAGCVRSekCpvdDQzm6bprdBwMrY7?=
 =?us-ascii?Q?v9gogAmq+EB3ZI6AWnYaxKs+qOZQvqoWMJEBLxJxiEdSjPgZeUUpjdi4ofYe?=
 =?us-ascii?Q?4HFMszOJIDvR+0+6U4lmlQfWdYHM+BDhVRwxQYI4JU8ikbr/c50RF19P2LJM?=
 =?us-ascii?Q?DCM5Sm5BouW+Ido/tGzgQsPglIkfvFHrIDJDspk6HqaYdE59rANsGdK+39wy?=
 =?us-ascii?Q?/PfLJV//rcZQmsiVuFQzp20H74IkC2tQGRmD+JtSNCgWKhWTH94v4rjys6um?=
 =?us-ascii?Q?IeyKU1Ww6fkFg4Twdk36V0k9xNJ8n8oN8uUMVSWm8OB7e2utnTQiKrA485Y8?=
 =?us-ascii?Q?94HvP/tOcrYYE4utBaBPpQslTh+eFXY5Bzj8ewVZda+vunEOG4m6K8nXgYeO?=
 =?us-ascii?Q?fIyga0ZoNuu3xUidM/GlAfySSCndfxX0JwCvU6R89JdnNjxm7/f3pSzzHgRI?=
 =?us-ascii?Q?93hhN3frBJMbUPmMP+bRBlV7CdB7rjt7pQPFOROK3IpPUnIag7+VBi7OAB2X?=
 =?us-ascii?Q?7LX/mBl7s6rSorDgbK2ztOG66lQc+5bRanqOCUyGs8mB2HXuegEkKyxb2KGq?=
 =?us-ascii?Q?4tt350cx9WZgNyC4n/obLAVnbZQ/fM7Hmi3F5asSEn1v7yB8Ss3Brc9X3AMX?=
 =?us-ascii?Q?5UV+dx1fRpfw/ZgXkauKGLAonx0rRHj3bQ773+i8n6velglgoJO3Tf+zFOOG?=
 =?us-ascii?Q?YIhQhcUNpY/CtECOf/DuezY7A1JM7e9YLCQVPHyv8hLNJhWNNYycRr2+2VJC?=
 =?us-ascii?Q?5yi4t4FmHkPbbMsdBjAFXerRH79n4kDMoxkDKYwSsdDABo0nZGF0yfhb2KXp?=
 =?us-ascii?Q?CpnDaA8CCVvWqVd/9EnpbrQ9yBTnYCXjGn3kG8uxBySGDzr8Gsth28cZ10Cj?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0d351b-7c26-43ba-9227-08da6e4fe848
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:10.6919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LK/TOR4YX8p48DiifedHViJvjmJfNKIvBV8NYoykxMd0dBkbJb5EO/bzZ4ew/olep+mJ8et5Wl0OlzZXZtkLQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of re-matching the compatible string in order to determine the init
function, just store it in the match data. The separate setup functions
aren't needed anymore. Merge their content into init as well. To ensure
everything compiles correctly, we move them to the bottom of the file.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

Changes in v4:
- Clarify commit message

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

