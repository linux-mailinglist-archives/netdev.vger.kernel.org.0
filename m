Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D54759887F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344614AbiHRQRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245699AbiHRQRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:30 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31C9BD096;
        Thu, 18 Aug 2022 09:17:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzcACWhd+8JRw4HP/oZOe7IdAmoYzngYNdYzSPnlKx1EMjW9cwmi/3iZpSsMQLQCTBxf5jx5mfsZvP7quAl7XDxM1MOETpQ08Qv5eCSqx5yApRukMX4jfqgdqEKEHHq0CzIBWI7JYMd2ctL1KpZ0pANxXFvctQFtJZVnK5donGf58+tNr/r4ihbJmAEUGPc0FH0LaPiF/9E5g9KGDOnR848xkaHoh1Wst5izDCh1sSYNDZRvCsBDGSqJ9NB4KUHC1+B7ezWMn+SIf8eypEQ1Q+6uRAtmcC+ssF0c0/Yu5fX2Tibuv+BOs2jUe+FNQekOuwUmHWN0Gq+smnQkfJmwQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocQkgqrX6Z35C99M2VgFT5kfphkMMnx1HLgZf9vIK4M=;
 b=ZyOtIJMhuxjbR3QFDTHpx75OCmO+OfRK7bb25chQ8WV3r1zyXVXZky8ktNftNbxX4KR5NJwR0ZgDeNKI7aJFE3IJSDyab3Y0xEmt4ASBRg/3mmVD8Hxt32yQDZ+oAhFo9kUDTyVP4DT7pCCtW603+LnvdkoqQM/uPVoyWdK/Cfxfeg+EuXYvHHR+YOJXmFGxhs381QRT1Kz0pS/2KnWggema108qLktxmEoq4LqWRtQPu+Pd00VchirnmG1cD1sXqP6MlxH/UyLMXpVWlrkSgV4x0c09KuMvnpkdj6tmcWgxbqxJM4Vxos4qWdtE0X1S/LWf99tb5rtfMQL+WyUcMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocQkgqrX6Z35C99M2VgFT5kfphkMMnx1HLgZf9vIK4M=;
 b=yYC2QoxK+4FlrVOyUMrOduvwB2f2pTzyYmsQ4cdoGPQTpcu03e1ijQABM8FJQE5YavAt9AmvOubHD8/azyHU63PWbLsnVnP6RcWEKKxjr5o2Nz5HJlkbUHqpL7ZGcFgHIDFQ+aI492EUptBfKk6iWbHdfZ+jwF/J6vVHdDf2oy7Y6JmHcT8pOHdRrjVYu1Mwz4gtYYmkcOf1j7oir5EluAMYl53sMq+uk4+YjcmVfaySy1PG9rSBI8oBXT9S11m4ukoeAcozj1n+UHPrvo4Mo4b0JW81noelYUnWz44FI/otWDqES9nWkoZeicrz0C7m03CUXIWTgEeM3BPNh7nvEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:17 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:17 +0000
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
Subject: [RESEND PATCH net-next v4 07/25] net: fman: Store initialization function in match data
Date:   Thu, 18 Aug 2022 12:16:31 -0400
Message-Id: <20220818161649.2058728-8-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: f0b49e88-a972-4b76-86c5-08da81351ec6
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XX2zrTp/Z+IcOWL9xUNYfhNh3+2RB0TwaQDNRlgLeFeWiR9h5iP9DVB/yLOtnBE0neEgdpkAuqWljSVC+q0KZ9HkP/QBxzePv16xnwjkdekw6eQ5AHk1d/4+tf511ArL5zKlH1em3k4GwrOvnJ8PXbwH2Bq5legXddC20fJoUIl7HX0EIgcozHaJD8bbi60mEjQMlAziVQ7a5CzXdyy/CLyzXuvKtmWSCaEgkjjwiBI6++02fchQZsaCKRe8m4g33Ea7+PaR0ybgMjh4JBdLteBKjykuJj5kBFywpSgqV5BHsJifNhFn5xiZoctl+WVFHw83X3C9qhp1sgSRN0Z5uR0Xvu2aed6l8B1bo4ihNGCT+W0x41aLOZ25iZ/yQTg82eTpXcEERMBwrrCa/LNR4ea7JuX+ctPDh2+jUF08tEXu8GXW1h0BQ90uWS7PfH2lgygX2MmTl1RrvE/lvV64wWSKxtoOwcnG1HSks25EGNinhBjPaCnokvzklfTJ1Gt2F0jfSkbHpYhQGszJlhqlPtky3OiGHDk7NvdzzA3OXkHgXKIDouBFZ0z9YTfr6qpjc4Bt5JjgGHPJrn/tfpIpuAaM+/vrbjk+KlTOjq/rIO99vPBgORhEAuL0IfQxiprhm9DTiwWflzFT10iBrWeO03ykbrNsl6lCm7CdGUDJkbuEELQz6pQt2aGsz8lVaB8AdtIq0KD4QOL93DHbW3erFW8itBpKpkFRurNsjlfzZCKo1/KHYFItTpuC83M1JlMaN+EFUiMeKsyBV6xN85PLPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(30864003)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XrM+xZKfBjhfvVSSDmazbA/36p3K7bwEHOZ1UqKrCnx/0mb2uJ9aAS7X7vG4?=
 =?us-ascii?Q?6TClDfCowq1YfzHw/SV2XqrsrT5CN7G4u3nxg/zSCb7PrWODTSRBWcxIvuSE?=
 =?us-ascii?Q?LjAJlO68EkhkI6+nZJHZnpJISs2sciKMoLd3Rj0tkHIZ2q8Oii6vZoRrGlGx?=
 =?us-ascii?Q?hsfXDnD8PMXrSSg1+BTSwsU3plZU5JQnfgCiGyfD6nfCQ938gmGDYvRUkgDG?=
 =?us-ascii?Q?rCEF0aoNYGqZuR9QO3JS5hu4cNbVrr327YZ7/Dsw+OMfNXnPb6JsNvChL6wh?=
 =?us-ascii?Q?jgnx80TaTGiymE8l7TXCBEsVxpP7YO4N9D7/A/0BeQfMaKzHYgujT/9BXmvF?=
 =?us-ascii?Q?M4e+wclpjZ0nZK0kOx85qx98owh+HozNQQIu4WmgpRRS2gMgv2UrHWSIikWd?=
 =?us-ascii?Q?y8dYKEt+g5G4ecDvG1WaeL1BomPoQwGdoEFTDwptgPxu8BtY3T6H/MzLKtnE?=
 =?us-ascii?Q?UJfDZ00nZn6/lsy/agypwInnM/k11xRSmBjw1jkURWz2hpamqOvucbLRcDq4?=
 =?us-ascii?Q?IKcejZZliPzPFRxXr0wk9DT7rJ/0LOnzWSaotZpzD5ThynuC6wZHdfXNpnTA?=
 =?us-ascii?Q?A73uQHKbVK3cg7Q/FcI7NKSWlJ2S0K/c361K6IgSkzY0mrGcUesY3SuoalMG?=
 =?us-ascii?Q?gR+a/ahtQCFG7x+dhzmx39FjZPoHVF91ltdKgOuJSga/qh9vCjN14XRdXXxW?=
 =?us-ascii?Q?hUikZqgXHCXKhmaCktmdUAut0jQr9HlcxPK7sTJkQd/ypgsXWcp9UZvQqWKh?=
 =?us-ascii?Q?vlr2OCM61miReWfsbttbFjjDkycZQn3amNX9QDVpwGry9PiTC9Mpi58G3sbc?=
 =?us-ascii?Q?h8+fojY2qJUEI2aMLCskxYQeLfaqCABNnpLIuYmqGrc4bm05I8383Cd2PTTs?=
 =?us-ascii?Q?NCp/SGmn53D0nQS+4t5aiRQzeGFyf3wS39JWzOd3o+3InYZqqICvlq2sPFkt?=
 =?us-ascii?Q?GZq9LEa5nMlGQAiis/R2kDeJdDEW5BatN6Ux/YU/52esOasZWz9tKDJDa+UY?=
 =?us-ascii?Q?dkOFWh6hIdqdl9TVnrU+wKHW13tWYuus99O8XhadUdAOlpH6h5Ci8+ctO8KK?=
 =?us-ascii?Q?XX7HEmjPifsGLw6CaaNPQY78PgL6cXs6IgZ/ReR7fBrDlGRaycD+4fIjIEY+?=
 =?us-ascii?Q?pNZgCiFBbgnaIrqVJsJxq8I/P7L/BM+Tqs2fePyAloSJ7ePFqqs12VWIHyk+?=
 =?us-ascii?Q?QNbrMGh365/2N7Eg3ZbDLX8Ay74TXkSEkDnpgwoSXvPDd7KGHT4SjU794DBW?=
 =?us-ascii?Q?Yu0pJFeW8dkcK7eYgDdvItwh6YnvCvG0ZI1HVirF87WxaA+SvnzFNsYjQnc9?=
 =?us-ascii?Q?OP2cSPfSsZ9n0d2emkmiPq+VqkWCBCq9GOX3Rw0JDMtTDDSvNaBAqI4BkpbD?=
 =?us-ascii?Q?gV9nleH9Br+XNyqQmQB5gMXj0BzOM1h80hXS4thHm5MOAKf+Y9Ic6d892tAK?=
 =?us-ascii?Q?DsbDu+zOSYiHDMvMA/cuSPhirWhSDZDwdE8BZcEpfaRbTlcsIsmnTERDfc1K?=
 =?us-ascii?Q?zXwfTsTtLAvLjs9YFZ6/LCodpiHkP6sCxBNNtimAalDmskKYCx692r5Ujc+R?=
 =?us-ascii?Q?Y+8uZ8EGBrCRV433XCgdDMx2+ysFRy85DZQfi7uynqulbbCrf1Qnb7dTQ5Ku?=
 =?us-ascii?Q?Lg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b49e88-a972-4b76-86c5-08da81351ec6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:17.7798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Gs9pl/Ee8/j1lLRoSA9gx497G/vpQwLKK87k7aMZcr00lRRUlNlNPD++ix6ec9wAqONfBJQIqEn6pXCwxN1zg==
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

