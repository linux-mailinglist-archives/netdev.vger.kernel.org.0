Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6DD5ABA78
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiIBV65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiIBV6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:20 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E559BF63E1;
        Fri,  2 Sep 2022 14:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nH5e+Yh4irqGDToZWjNmfflzMwzxBxVeGVAEs5KhPMv9K0D2J/fq4MztsqwDVV7W1LcLfWzLLnT+KsNBpGLN2u1tLqIraBOqQUzaPewbdPhlbWY/BYJ74E3Z4Qku63M436tqyfTIAkubP35Ce6CbEl2j2DjR95tukbV2oUr8646Aqt+VjWS8wHhstFKgV/0yKZQbayJB8nj+jT3lHIaqrxh5CP0vUJgTfqAJmJdag7sgWl4fOGYAF0dEO/HjxqtacRACaMQW0c9y9y7QjCk/cCC+ieZ0ttIvfC0daPv5cFSLlt6vBlSH8h6GfOnOSzGeohnP8genAxH9UmrG6gwOfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acLe4Wk915HW3eBewjGOe74OkfM4KNtKFmTP75fpf+E=;
 b=Xzz/HbVuo0aLXm2dM42OSqaIaGDHejHKyjtDHHViEbiGWzA1nztWO4nSXlufpZukAvI8xRp1GHNUCc20WzqZnsnhGf6U+ZRwJAGPA9p1ySnAJ9rvG2b82aZt090Iv1jFq9W5W35MKbu9WYiYt6pDccJGD89MnV3yFyZbqd9JgDawC5Bkusww4KzvMPJP+bEaSPNeB21/1vbsDwgzRzipUDd4aLVroYsXrunPGHChngRzvbo57TTbselgiHNZcgLeHZ/ufys+6RQw59oDJMcLmgHTa/xQlvBCg/pF7DwbghSQplk2UNWFBygcpgC2GUQfN+UOdSL+8ghrur/G/puS5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acLe4Wk915HW3eBewjGOe74OkfM4KNtKFmTP75fpf+E=;
 b=fwMn0aL+JRtCgWZsz2bFHYt4UjvwTrJ+l3rm0J71s3uL/oY+f8MG69qCYmKOXHb1RlsK4vmGPEPEN/IKu2fFRRKZk5ZW+H4PcV1kll4BTRkJES77dS6uHh3t56E8D5x69bVxk38YnuCKzBj/l8A4q9io9NU7NUFzeQiW4XyBTfh7li5tFKtwqzG5w7GLkjicO5rYGQfj9FWh41jK6w1tcJz9u2kSL53BvfVy7P6887uIe1f/fuolWMYpFyjI9FqIwAe/Bi5RZOyyoUaCnbxEw+qK3TZqQ7ImqLt6Z+5oiIh/Mn5Cfyky+eUWmplD70PSa8yZ+fvHbatw+MG+H/BqCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:57:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:57:57 +0000
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
Subject: [PATCH net-next v5 04/14] net: fman: Remove internal_phy_node from params
Date:   Fri,  2 Sep 2022 17:57:26 -0400
Message-Id: <20220902215737.981341-5-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 24bfdac5-5d73-4a3a-1019-08da8d2e3191
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MuxUO7Nmif/eaf6psa9ow51pOyrciw8yls9C+shsrrtSMkIV12r5zTo9cuNaDuS6mnT0RH7pVRj29zW190J6XSDWDgxuryG2pkIvPblhzIkTDA1JPeyp2QECXnNIk03E4WZ1LH5llSoQpVmsPHElsPiCtOXnlJFA8uhSoxrNT8VuJw0QjeYWsCDKDCeH0dDdzA5016rpK5DIE7e8oHOm8/dv+PpJeP/3RgaG+L1GRNUdOsIYfW9dTUszNJwpQQ5Dh5jyyushTZF/KFob1RtdB/l0Cn1eNtPKvNtbA4ohL9OJWUpjyOOa1IM0tIYz40UpBvNwCYGlyOcfB2yLlYXjwKgFdTRVPu6Z0zq84gpRM84sboNhSxyl/jqGKSDVXx91yehPvx2gYXrZTA4CFOovsHP+pObwlA7To7zPV++OT6ltVq3GtH79oKeFe0qSs1EGLKbEA7Ce/b5y/4YlWlIDw9kxE0jbssayW7R/Cp2VTsOAaBRDcQYN8OZ6PkyHIuNMkCbDIYd01mR9IrL3/P2L/r+Vrv+lWIkndELNR90NIsZjfFP2xYxAwdSJZ15bZ3A3CXLING2NSfvBsAFsbhpsoepIDRtwW3+2UspngMkdz7EeANWy97oQdiFpV/OnQkdl1Mfu3v73lWln5ZQhop6sejeTKaK9oXEYfaJ8F6+ZUniIO6Suaotl21+4kXX6pMgD/KKUBjy7WohJ3JjMrNAKmEtpUAu/Sti4TqH71sRuNEnPZgApb3PKP3gP/a6ysDTPGBcFKACiT3UCaREpKuG21Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WXXPgaV3+1yl+mqdTi1LhK/bZX96iNjK8RvJpXCdRIJJuRbJoi2pXKuzLPu0?=
 =?us-ascii?Q?QjzgxQ5dESXU/qr1e108CLssDT2fg9/OXoHmKMZ6FuL30rBoOR0nHVexNbrB?=
 =?us-ascii?Q?F2hB20mIe2jzF59oeQhCnrS+c/3SHcjlTgxu0fONzgKnWR67iEKtfAUk7f7/?=
 =?us-ascii?Q?a/ABTuAR4kVK+nXRnADadUz7x/DPVEMWRA2+r7JL5eTGnqQuzGCmHCwZdyiH?=
 =?us-ascii?Q?uyAqZIpVxL/5N5RyBdmSYz+xgRxLi3Urv/v/45sgnhE0h/18QTgWI1FwRbkR?=
 =?us-ascii?Q?MoUjEtKdGL5iJgwDlcpzRHXozjbNaLttVMCeOOD0lgvXp6Fv/YMCP+uS9/Ja?=
 =?us-ascii?Q?xUvtvsJaFj1eNVbsVldyRFXlK1cCbTznxCgvbw1suDJPyykagunhdN3fngg8?=
 =?us-ascii?Q?GxYkWetF3M5yMrRGsamuJD2FD+o1rB3Yh8ezcLLncbsc7GUqSkd4unS09Tot?=
 =?us-ascii?Q?hPAenAyxWyYINK21s0PJV36LOT4u+mUoIERN5SFd2lAHN7g9UGU9jF0y8mRz?=
 =?us-ascii?Q?Iu6c5u3flK07a3w10fuv0Us9a7y7atTuAwtQalMSAaEk2zgUXdzaSdbTO5zh?=
 =?us-ascii?Q?SKtxxRrcx/HEgKGThCgjBRVyUxWwmzIPvNWas3aze9V/C0FgAn9PnTbOJmuB?=
 =?us-ascii?Q?/xdlO2AyEn3sCgIW3QN3xtMhsp0rfty41Jcvch6N/sDZCACT2IDZyDxdCGF2?=
 =?us-ascii?Q?fUkTLpiHtjgFG8cijhkgsTPYvfkfKs+r3cj9w2pRo6ou+NB/vv3K5Bs29bqz?=
 =?us-ascii?Q?+cFMF0/K7xuOSOwh8nQqinNS5oHxv23QIX5TkhrL3sqG3TVFvVCmbntCpeLm?=
 =?us-ascii?Q?ACvOno7+bfqxUHUuv3iEn+hV1L4NT3oSRaIyWsqL8Yo3KxO5phA48qPBe8+L?=
 =?us-ascii?Q?yJuv5O/A2YFydOm6TisMI8edPJKNZ2K0qB+ATjvb/Ra4CbZN9jeVA5JNUQXJ?=
 =?us-ascii?Q?pgRYPmES2CIHWRKTDrXzMvq8jBfAT6dhwhGkh88Wy3cGgqsXTkyjWhhfJLto?=
 =?us-ascii?Q?3DL6+u8zvCs2+SKeFy42CSLC99TZg6vJnlPmX01q+90QBCeofdbLYCdxtp6w?=
 =?us-ascii?Q?MYmkD2tAFPFycTywwCdCGtDYkGjo1Xt5BeP0G3wMbY1MFbLh20UHz3VKEQvt?=
 =?us-ascii?Q?ibu6vv5y0XhDq6RR1QkfSsYSQWPCs0MUOZlzuMRYpijf27K44ubsE2D1R/TD?=
 =?us-ascii?Q?0RruGvAwk735ONODv5ZY9pOObCwB7ILMrUzADMcCVsz4NBkEIN2tPdAPdTSh?=
 =?us-ascii?Q?OKTiUoGDQ3KV8Q8ZHDO6NiofidaRgSXUg5LSRnKY/v4JdrKZWx4YJtCi3xVm?=
 =?us-ascii?Q?ty+d6LKcO67U+rrCslXPtD/2C0xGHOx3BlM2KqfXcG6CgosZRY23oX5LyO/Z?=
 =?us-ascii?Q?/GMtoAWiDSmJkl2V743/0wiZJg4ZFk0SSuJGEdkCl5W7/zJq9+obYUSe4DGQ?=
 =?us-ascii?Q?wCImzgHLJ7bUJ2SE5BuCPN0LHhnYGGxNMDwkN/rkid9xRwqyQC/BjI6aVxwc?=
 =?us-ascii?Q?5MtVKXyBzc66Smf7xGy3wan8S1R6r5GiUUdnnI4rSGvekTOmIr0YdCcLF8f+?=
 =?us-ascii?Q?fcJzONlMIuBdJX5YPsXsK2TdAMcAK11ylZIsNoY+P7EAaqm2lhOdSL8sQOoC?=
 =?us-ascii?Q?tg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bfdac5-5d73-4a3a-1019-08da8d2e3191
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:57.2979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpUD5YhDTHo6Wafbu8844vC3/OdJ27rE6ar56KjBJ/54dXQnmrEwPa7uJVnqTAeYnc1EiJ23L/cBnVujRXs6Jg==
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

This member was used to pass the phy node between mac_probe and the
mac-specific initialization function. But now that the phy node is
gotten in the initialization function, this parameter does not serve a
purpose. Remove it, and do the grabbing of the node/grabbing of the phy
in the same place.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 33 +++++++++---------
 .../net/ethernet/freescale/fman/fman_mac.h    |  2 --
 .../net/ethernet/freescale/fman/fman_memac.c  | 34 +++++++++----------
 3 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 84205be3a817..c2c4677451a9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1463,26 +1463,11 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 	dtsec->fm = params->fm;
 	dtsec->basex_if = params->basex_if;
 
-	if (!params->internal_phy_node) {
-		pr_err("TBI PHY node is not available\n");
-		goto err_dtsec_drv_param;
-	}
-
-	dtsec->tbiphy = of_phy_find_device(params->internal_phy_node);
-	if (!dtsec->tbiphy) {
-		pr_err("of_phy_find_device (TBI PHY) failed\n");
-		goto err_dtsec_drv_param;
-	}
-
-	put_device(&dtsec->tbiphy->mdio.dev);
-
 	/* Save FMan revision */
 	fman_get_revision(dtsec->fm, &dtsec->fm_rev_info);
 
 	return dtsec;
 
-err_dtsec_drv_param:
-	kfree(dtsec_drv_param);
 err_dtsec:
 	kfree(dtsec);
 	return NULL;
@@ -1494,6 +1479,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	int			err;
 	struct fman_mac_params	params;
 	struct fman_mac		*dtsec;
+	struct device_node	*phy_node;
 
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
 	mac_dev->change_addr		= dtsec_modify_mac_address;
@@ -1512,7 +1498,6 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -1523,6 +1508,22 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	dtsec = mac_dev->fman_mac;
 	dtsec->dtsec_drv_param->maximum_frame = fman_get_max_frm();
 	dtsec->dtsec_drv_param->tx_pad_crc = true;
+
+	phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
+	if (!phy_node) {
+		pr_err("TBI PHY node is not available\n");
+		err = -EINVAL;
+		goto _return_fm_mac_free;
+	}
+
+	dtsec->tbiphy = of_phy_find_device(phy_node);
+	if (!dtsec->tbiphy) {
+		pr_err("of_phy_find_device (TBI PHY) failed\n");
+		err = -EINVAL;
+		goto _return_fm_mac_free;
+	}
+	put_device(&dtsec->tbiphy->mdio.dev);
+
 	err = dtsec_init(dtsec);
 	if (err < 0)
 		goto _return_fm_mac_free;
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 418d1de85702..7774af6463e5 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -190,8 +190,6 @@ struct fman_mac_params {
 	 * synchronize with far-end phy at 10Mbps, 100Mbps or 1000Mbps
 	*/
 	bool basex_if;
-	/* Pointer to TBI/PCS PHY node, used for TBI/PCS PHY access */
-	struct device_node *internal_phy_node;
 };
 
 struct eth_hash_t {
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index e5d75597463a..19c2d657c41a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1150,22 +1150,6 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 	/* Save FMan revision */
 	fman_get_revision(memac->fm, &memac->fm_rev_info);
 
-	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
-	    memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
-		if (!params->internal_phy_node) {
-			pr_err("PCS PHY node is not available\n");
-			memac_free(memac);
-			return NULL;
-		}
-
-		memac->pcsphy = of_phy_find_device(params->internal_phy_node);
-		if (!memac->pcsphy) {
-			pr_err("of_phy_find_device (PCS PHY) failed\n");
-			memac_free(memac);
-			return NULL;
-		}
-	}
-
 	return memac;
 }
 
@@ -1173,6 +1157,7 @@ int memac_initialization(struct mac_device *mac_dev,
 			 struct device_node *mac_node)
 {
 	int			 err;
+	struct device_node	*phy_node;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
@@ -1194,7 +1179,6 @@ int memac_initialization(struct mac_device *mac_dev,
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
 	if (params.max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
@@ -1208,6 +1192,22 @@ int memac_initialization(struct mac_device *mac_dev,
 	memac = mac_dev->fman_mac;
 	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
 	memac->memac_drv_param->reset_on_init = true;
+	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
+	    memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
+		phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
+		if (!phy_node) {
+			pr_err("PCS PHY node is not available\n");
+			err = -EINVAL;
+			goto _return_fm_mac_free;
+		}
+
+		memac->pcsphy = of_phy_find_device(phy_node);
+		if (!memac->pcsphy) {
+			pr_err("of_phy_find_device (PCS PHY) failed\n");
+			err = -EINVAL;
+			goto _return_fm_mac_free;
+		}
+	}
 
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
-- 
2.35.1.1320.gc452695387.dirty

