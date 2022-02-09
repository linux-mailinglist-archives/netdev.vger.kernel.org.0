Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB66D4AF5E3
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbiBIP6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiBIP6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:58:02 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA8AC0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 07:58:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ii5tCBKYxVrSYhy3Ai4Ok4jNvsJlWd3dbXRH9NNAwbFwcCZl0q067ytcsPdLlsLcB554/ZXFpIEeVErxDTIF1QbZB9ju/HQq4qZQj0ydDlXYhvCU2jjas5dMsN1OHB0QMvk+/d8lyhTw2rznLFrGLSDgcrwxPJAJwnlMtb3YknCFUXwDBfZVzOK2EpgubqjyHtwc80a+Lt2Bm4L20JO5114iqxavv0e2CiQucbrYkuP6uv7wzcAvfJjQqhHdXgejz/srV7/KnggcpRbvbyU9M4EBSJeZfQ9k1e2gLFMxSNG7Q2+jIaKG9GZzUsOVIjY8C58h1cmEjy0TxAYb/er/RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIgKjKncb6RQGSybjhXtdAQqhtuPt0m3wBiUsrM2WUI=;
 b=St7/bOMlJiSyXM7YchPp+15Nk5eIlkjrxpn7u2mpsc2OBVZrFlbV3/4yM2VWKgUMSnghBmW3XomPC9UW0Dv2OQX1TgZLKP/BJ85MoonqNbSYDwBNPXxpYtuYShs4/iJTsg8lvGUwuvaw5/5prjeSRdvbUknvr99tksEtNeJ+SMmHrKwUU5y+JM82TP2G3d+we+FNWn0wUysjM2n8IufubxDzFcqu1yV52xNRW3of9MeceYXCB8atP4QJFe6jhD71w+U9fWZ4aFLtvxR3oj3O1rV1IaBMUCdgU9y6DDr0bErPHfZPZxZq9loKg/Ex9YXHIdBVTEuTBnbuz9WhAE4rEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIgKjKncb6RQGSybjhXtdAQqhtuPt0m3wBiUsrM2WUI=;
 b=AzEmWx4Cy2A3JjoLn2T7wwjjLxiFb4fmGxbpTyvLldFcG1jbtE9PUZY55A7yNG37YSP6dIwbWufMrlpBSzZ69WsLfMSijbVG++cKazFhC2W0rcBbQbkOQg1ONc8InumDh4kwRxNvL3fZ1hM7Y/9qYKO/ShQ8hLr7uchgPL0vEnA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VE1PR04MB7248.eurprd04.prod.outlook.com (2603:10a6:800:1aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 15:58:02 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 15:58:02 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-eth: unregister the netdev before disconnecting from the PHY
Date:   Wed,  9 Feb 2022 17:57:43 +0200
Message-Id: <20220209155743.3167775-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0022.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::32) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3295a93f-0092-4600-4f08-08d9ebe4f3ce
X-MS-TrafficTypeDiagnostic: VE1PR04MB7248:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB724826219514C2BAC868AC67E02E9@VE1PR04MB7248.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R1KOJt+hrKmQRAd+FGfpVy7HbJBmgMDZqNzL1HGTtIpH4rXi3GFVlzPKiP2mvVZ2Gn7XbjWZr/Y16RiMf/9pMzrYSOS4kxJCGlFGro0JMFAEdGiFnOWe3fmY5WhqhSOpY2UBiwbdavWlSgh5ulEyAO2EHe7dhJLQQO0zJ/kSRKmItIDZ23djXFfmN74IOBi0ICPr39I7sG0pi9V3FBDfd1j0u30zWMHX1P35tMT74oCaVLSKd1rS4kmwFrotOtytb+/l82nrbe72GGfzR4CbLWgnyIcRrlAYzULrpAw/ImP7YbeJEaT18l+R9KsRz2VmNCBqCnq8zZSwUStCrJkVy5/PqZqhTniZLxZtsWdlFXK9Ubz8LHv8ngzFU8E3tcDf2U+kH0IDCqto7HycbfqCODdRRQyqwGRffNgmXjdqfQCKbMw7aNKr+dAPGXmG9zFLnWcZuGHlWfrpJUuhelCtMyUANSKYT35DbCUf0bq9hoPPj0uUBLbY4viJMUKZGtB8z2P/Uj3uzQbAT5n3am0gSlovtuL781/dl+WVWhf0icxOD3P9p33cXFjgI6l908nO5kSYBDR2x1MZLOsH0kI6JAheeS+3E8KYP2zU0fjqGJc5BVTrfXCOQnSjZ+PJeurluU4cm7HVDELTIDomrc7kPhgNw2GOu2QTBYxd5LZuQOHp6vnSX4fn8X8DYne3XOCJuDnMRgvQPLDtAbe1TEAnRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(26005)(6486002)(1076003)(52116002)(6512007)(6506007)(86362001)(6666004)(83380400001)(66476007)(66556008)(66946007)(38100700002)(38350700002)(4326008)(8676002)(316002)(54906003)(36756003)(44832011)(2906002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cU1zKE64lKly4i5pvTifl8cpxxQHekAel7/tSUJGwwmXOfq0iWPAbbU4S0Fu?=
 =?us-ascii?Q?nfvZzwe/gwquEXX/BqYAFiQ8ckVgbRhbJCATAl/sZJSFxtmxClEX9xEu0ygi?=
 =?us-ascii?Q?06t60HCD72/7TKPAORs8QB03mJv9v8u8m0YbF6AjP9OrcbnMHid59BhHwLGA?=
 =?us-ascii?Q?p5ZIpUjpcpQ8T04T0G9m2O6bYVLvQJHmBYsPqU3j2O1M2IO0ZOJKh2+yDTiC?=
 =?us-ascii?Q?xmxxDrC50ha2f+ZtjWY5ekL9cHVK4Zcucm8DWReUQ6zLLY6MYb5pG2QMIv0k?=
 =?us-ascii?Q?QmdMZln45IA2tww5ag8d6iDDAEdPe5JgzBPgUuXsMccF6UN3pI5epegRBWid?=
 =?us-ascii?Q?WTqXCbdBEYWmz9l0/b4qWT5zTNqoMFKHPN5P/JCa5OBEG+lnYy7tTSYA1EdW?=
 =?us-ascii?Q?vGZ9Eu8DQz5OOz5ehBBsvybo//Cri3iCggfUKZEY9Yc9h5S18zvTTB0NGffY?=
 =?us-ascii?Q?iqqWy/TJrPn7TUXKTYxIQFZUmXrWGKCCTJ15SjUOlUFYgYJ5h7rMlti3khGl?=
 =?us-ascii?Q?uXmOwf+jKA2UcWmcWP7IF9QWFzniY24Z0kln20oFEd8zJO4q7tU8KmO8UtdZ?=
 =?us-ascii?Q?uQcaXLrs8z32HmgjYoFmVcKOG0vDCJEVOyw2DHuaKNaSZppuxBj/CJzaMhoR?=
 =?us-ascii?Q?ONqGeHvxuMAVBq59j5PjM2I+jFryTu7AtXVPNZJlfsxCKRoH0/ReRGNkiUzj?=
 =?us-ascii?Q?aQMwCo2wpauoRFIiZ1I4cbbgejqxPAzu24XrUMhLC0tlbPlqPTBtju4kWaks?=
 =?us-ascii?Q?fEq519ky9s9TLJOai83IQY5Vq+i4OhLlT5p+zrDax98lSg7fkQZqQQMkUvqH?=
 =?us-ascii?Q?dulQb9KnQBxtDX8uFBOtGaqg2AFhN00GaFaP3Z2D2yIZ1F2Inn5VJa8O7gCE?=
 =?us-ascii?Q?ilocyaCEIhQ6q1zMDWylCSN2dhjMgsdnvNZUmUZO1OW/l6GZ+yBZ3UP9zbSG?=
 =?us-ascii?Q?i+WqHC9rBq2VF7CmgKoGJmXBx7Vy0emrMh2I42Eys4/QvHbO8fBOoHdquw4c?=
 =?us-ascii?Q?sSaR0LKXjrS3HX21XrYxBxoorilJGZ/+DxLF04l/yvXXfsG309YKmVutTaVE?=
 =?us-ascii?Q?qmfft54q1C+37Ow80NtFghX1HHPUgoUmihPkkNmtDXASIBPomDnW3i52TfOb?=
 =?us-ascii?Q?TK/18TFcAxQZnyO0F3ySRV8sJrWWAqe1sCvKn8f8879Emdyw10XsOcbI1OAg?=
 =?us-ascii?Q?4D3gLrSEtEu86QiOM5yzzDWeqUGGKQkC6GnzqwVK8uRC1HaaEDlzdVEP77R3?=
 =?us-ascii?Q?106e15bG1jXP0OdEotLcqS7wE1z7GKjuMXjO+J0fsMW8bG3digvJoiwgG42b?=
 =?us-ascii?Q?H3tF8Psx4FWcd3UjhUHH1U+NBoPHWxQho79hfWgGLX4qKQ1X0iX6M8pGklMP?=
 =?us-ascii?Q?tuxQUoz6Kt+T9ZuPAYNkRZR+69KgEVDXCX2uBsGT8FrI8ruBIgN/mpbke/k1?=
 =?us-ascii?Q?FabPVelQ6BzQPbtwrvV7RHW1BzYI1dIp12HABJmI8SV1YJkZIQty2+IhJnfG?=
 =?us-ascii?Q?bw2xyccF1GKKjQuyS94mHWcVLs/gi9GNdcMkY1/pCAlK0ln6M/ueG2I/iIbI?=
 =?us-ascii?Q?qzRPL82f9Y1vpn+qeWhvaL281UXxobd9dayfDvZaeb5zsz2mDszlTWbrm9Md?=
 =?us-ascii?Q?h8vqtph31PknOPhG5EU9SMs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3295a93f-0092-4600-4f08-08d9ebe4f3ce
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 15:58:02.6965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRLXPx2nytJm+Doke9mnOK7jxwbUkFzXR4TPiI3Khgoma9FYFOEhns7Jpp/tC1iJFiPTyap5niKC15uvhIBJrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7248
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

The netdev should be unregistered before we are disconnecting from the
MAC/PHY so that the dev_close callback is called and the PHY and the
phylink workqueues are actually stopped before we are disconnecting and
destroying the phylink instance.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index e985ae008a97..dd9385d15f6b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4523,12 +4523,12 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 #ifdef CONFIG_DEBUG_FS
 	dpaa2_dbg_remove(priv);
 #endif
+
+	unregister_netdev(net_dev);
 	rtnl_lock();
 	dpaa2_eth_disconnect_mac(priv);
 	rtnl_unlock();
 
-	unregister_netdev(net_dev);
-
 	dpaa2_eth_dl_port_del(priv);
 	dpaa2_eth_dl_traps_unregister(priv);
 	dpaa2_eth_dl_free(priv);
-- 
2.33.1

