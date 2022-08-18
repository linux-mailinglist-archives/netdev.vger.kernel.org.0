Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B9F5988B4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344705AbiHRQTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344605AbiHRQRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:51 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35510BD4DD;
        Thu, 18 Aug 2022 09:17:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Leas3HLCYkNsZgpNHE68z9PUFMhd0g0dJNYQPkeWoJc1pNoLq1tlBHTRJe46Yt2Zti+iRzsoFxOM6t36sgsBJQJWoiLN2rp4RX1HE/ELDsAeJKiSqNmVqv5q2HOJvzYw9AHJjo5NfBZlb+gxmxNZNnOtwQKPIs4GVjLsyIpIoP3yxv9aOmA3G27W4P3Au86aVc11BAUtJW/L/Vfm5TWiDzQBSRs/ifFJn39zMyXhNVyOxPUNMzwCkxLWwwI+cxYg18YHeVb0FpNhHEgiTNWdKxKS+tbdi/tZQq8VzOx9TAhm/RAxURJCC2vQS0SQaqPz/pBXpTI0+Zv2S1R/Ul/qrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uF6t3FMJH8eO9mFKLCWfuB6lgblJYlx+5+0EOJAwDQ=;
 b=O/zoJmR16zKaX7h2O0zXmqTNfJJsEpQMxmCelsKJwDoM3ULnBBrsZ8kLOfVUIEGANb/YlRl2Q3GcYRO0BcX7a4SlBhNgJWuRMdRzO2MFXK70oj9LsT5HZbL08KCb8F4hcq3bypG3p+rMRAso6rRqMf0PofbBQ0WwaYyYk7oVbtMiqtFS4U9OKmoCBpokqojenEmN2G83TfSctZnxetIaFbrr0Y5qGDfJEDrlCGVKdvgGgtagrxlFcjbYHx+Z6SfaDeAUwBdJ8AeP9NH3VX9bGehryHfw3QXePz03T9sRLT9ZEgV2vY0IpH7xe1J7ka/FQMb8/dCE8AyN3Y7SCEiebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uF6t3FMJH8eO9mFKLCWfuB6lgblJYlx+5+0EOJAwDQ=;
 b=sTwRgDhuE391j+tpGwaWbhcQluIIL9gzg6EGlHjfwKIYpBbFKiVTEG8NlK7nS9XOi47R0B1peVhbbQHIee3NGOUlofTJNk5+/V1qCJHnERdYNTEA+ScRt1RdTBiMW9ebypa1L4IcDhxuSECMAY55+h0Bkb0lejeSHpexfYw+Gc7RoFRirLTFU1+9KlD1C+KKYBkPBC01sMOpBOq7a/shG9Umoc+UFBrAngHp16vF8k0imE25B/TvnOPGnlXWmvIePt3ebLvVDuCF5nIpAUBqW9qlchjNE6BbvZcUtXekU1h8GkTz0I7lXUGJdnPCGBomTgzMX/MemTRXUc+D4hXDbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:30 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:30 +0000
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
Subject: [RESEND PATCH net-next v4 15/25] net: fman: Remove internal_phy_node from params
Date:   Thu, 18 Aug 2022 12:16:39 -0400
Message-Id: <20220818161649.2058728-16-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4f42b438-29e6-4d16-4c2d-08da81352605
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGwuHjazAIyZCJvzXs1R3G5TVnNDTrplYXGuhH6XIu6MYqK++PL0C4f5sXgFBDaEgAPqj+kLG+PM04EM3eyz0ZAYDjbgQDURrTWtBsbvuG0bLT/TiwpUEUFEOstju2uJId1WnszKGLg697U4b2JFu/7hgl9dS6RLNpzFTHcOW7GvTN5Ea4MU+UCuL5sfoJkWfyL2wrMIXoz3qkF10+H+bJXaMBFbUmoTMKsO7iQkuQAGForfv8PZkJcZrj8ozJp0gA02cydjgJa4KTB1LgOtpGfqG8JWSQ1Xo/KjlXgjCfC7ILZ6AZozlP+dVslptD8ckV4QDZRZPWvAnuAdzXA0js9Pcze1N2KtHP9swBJPv+J//s3g4XkQF705W4LlYMKR2jbcU/2JSvPVQohWxy5J/Fa/j7nrQWKe4SZ9kbA1QKMp8CVT30QFngXuRsvNzDyKBJ+hJWh1McCzAImVovpi6FJPnpK5BmV5mhAZMJXut4upN630MMeKSbO8VQZBPtL1bBgULd4MU40Qx584UeDPSYM8pN9XWarwFgVnU4JLiSJp2+AyFd6zuffMWahaJwHW5n9yBg5DLOEG1RckjgKaqDcc5/0R5hBzR6MWPNp7gcx1fATdMN+EUdkmSNaFNiYR4dar5eDOW5T2IHWc7LxfdDFaa8jILid/WLIMgAucao3Z4gZuRAyWYQJyo4vAgT/FyX/fI86wQPhfFOrEu+fdif18yIx6VNCq0Z5DQy5FcLLKdTuaMzMLRJ3Zl5M+47IIO/7iblFOai7dsQgp1lXmIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZbIWzX4AV1WcNrysUOek7XsQM5aLs77qSBfXGIpjsuYMHhKhGUoiW/O4H/Wr?=
 =?us-ascii?Q?RpGRrK8w/QYeQKlxHj69HxV/JZR9+wEtscf/LUJcg6oKOEUxbNb6dR2OrRIw?=
 =?us-ascii?Q?XQBtWLEkDC4El/Ia7soI1b4Yr0dP91NQzKxuYX6r7Qf1UE9KIS4EZo1vtzww?=
 =?us-ascii?Q?DYUjTkfuJQudQIhdraUdOP5COkVqQqy4dZDSEoQZoVLdhWUFgnsr3o4QCN06?=
 =?us-ascii?Q?z/BEIavcbq2efyu/zHlV3E03axKVKboFwHPfWsxb8pWN+0H1B+c2FZ4/kGb/?=
 =?us-ascii?Q?p+SvCzA150E89otyEqDlU7AomOsspL4FOcgoDNn35qvF37W032ai3hoqheWD?=
 =?us-ascii?Q?Bz454v60RNMLzKHm11dPZUfcteKyU+7/co3E3gB1zMfq4e+S6DIjmlyjNPlz?=
 =?us-ascii?Q?2L08waCo4YrqdXjCoApiqncwpMvILZJKOjR46O7Ov+3FHXKb4B96jfcxhHly?=
 =?us-ascii?Q?Cct5cIBLotBfiSXlhLX2QetgStfdV/VOkCg32ukyv9hUnZPTMfP3sF+Rd9Qz?=
 =?us-ascii?Q?NJJxl5lQLZE9rVn2TxJif9PI/BSRuZFcFA8e0JDEeZravAg+qGuIoTOfNcoy?=
 =?us-ascii?Q?yh006yfDJTz1yVh+mOOwgayPoCPkONkbGp5ginoRDbfNHRtEfT3Gnh63138K?=
 =?us-ascii?Q?Z4PcAeX/pzX2V5WpPGbJ13NtI8UIttKUhfH9BThgc2eopUPPme6hYpfOHqz2?=
 =?us-ascii?Q?LeDYWEZmixBDEWqpOqwROCl26Z7r/D/vGyMNJsHZ79Cyu8x2EtqI09U7rmEI?=
 =?us-ascii?Q?q02p5buvN2sxbevsC4Rnhn0UiFsydrqEAQq0dBw/ASXHdOqXMlUXBUNJZPGx?=
 =?us-ascii?Q?11FzPO3UjiC2yDZ2fU4F8j4XSFXNqucR91N3qoAdYXDuQx5zf8T7gPduPMPv?=
 =?us-ascii?Q?q7Hw7tmoKs/4L8nkQC8ReYIHT/DFzBSYXpS2nk1WetdqmFlOsby5/qTVWIai?=
 =?us-ascii?Q?lxBhP+HhUlrd1fj0Hw3NOvPoA7wMcLtfDR1RVOO9w5GwW9B2hU4+17OMx7az?=
 =?us-ascii?Q?Q8nLMd6YIWf5U804C82xeib2oGPbQkRiDizcO0sl6frbZ2nBLM0aAExdRf71?=
 =?us-ascii?Q?ZWWSMM/suQ3dhbha7Nb1TQm62OpYMOT02Jyd3trLSeuODOEBTE3QbiGZbEtM?=
 =?us-ascii?Q?dexecaihZXeHRDD4dLu/F7KGecpplFbZQj84ERLjw9Bjtns/QQP/ajqKtRXN?=
 =?us-ascii?Q?XlydMW6DoaNoXqk8SJu5aOctwDnN418vL2NDyICI1d26MBYlA0YLq/cw+Mnu?=
 =?us-ascii?Q?sD1ZMPEXHc9hV/zQIoTa/8gdQ0bqUUXtYEThDZbXsPLnErZKyfnKoPT+inry?=
 =?us-ascii?Q?U1Uv561gITpibiSESj+mJXpdQhck+jPJ3s8393QVD98ypWeU0LwgbjTewWgH?=
 =?us-ascii?Q?x+m1kVJPz7ut8YrlCuq8XOu7WOWL27BfXGp2V8lhbbAno/q2fOB5FpCZJ97L?=
 =?us-ascii?Q?nqTaYBVdsP8StWLR0jS7mGXlwZ2/2/Rqy3ewA0RyL0ILw19j9dCqPH0kR5Hw?=
 =?us-ascii?Q?6qB3Exn60I3rxtyVDEMCSOXqD4KQi8j/2yqyFRdtGID1+D4gpd7Pnz6NAHs1?=
 =?us-ascii?Q?SuZgHZyZBi7rTpXR/Kh3YnlXTGMKzcGDghRsLO0F3AVPcmct4mJmNcDiYMYJ?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f42b438-29e6-4d16-4c2d-08da81352605
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:29.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctW/rZdvajuk+0Q3n2EU547gVbgVyY6+lwMLGINqTNUTazgnWaoQ7opy5XhTMwoDzDMW1iSKP3e+eM6bLOVoOg==
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
index 039f71e31efc..5c0b837ebcbc 100644
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

