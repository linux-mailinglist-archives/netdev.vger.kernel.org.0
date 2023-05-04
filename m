Return-Path: <netdev+bounces-254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 302946F66D8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68447280CE9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F5D4A31;
	Thu,  4 May 2023 08:09:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1964A2E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:09:50 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2062.outbound.protection.outlook.com [40.107.105.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4167448C;
	Thu,  4 May 2023 01:09:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIBM7SWA4ERZc15X9hD8khSPHQKb6BBXr84UXV9MNoPg0VxlkKkDVj6ax0pyjRHgzNBD2oh3advHrK4/SNO4fZBvA4ruoFabk92j0d75toPOs8PDCL4MToP4BuQ/sObRvBqWMsCgvALxpFGzKXCIcIVZyGZGC+k/bd3oDQLaUAGhzMcf5TKGINy//gCYmXsnO+ofs0Z5l6cvfPYu/zx5tGHHh/AUCVTiQDT6OSZjkacZ0aU8RmhdDkr/NSM0OvT8LLfqpuEdLOXwzljsI35jxnlJKehd1B0JpTzf+jvIeYqs9MVGcJKzIWfQJ6mkx1ApimQ+zbldbM47J8tYFUyjXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHIq+GJR8HtVKUjGFYRG1IaqZqVQFVcMcS1xAyAeam0=;
 b=KZel5r/t6+hX9fCMxLuWIUUyrKwn5+dLYANX7QFSSOSMfQPfaub80M9MbauV4NQdZdkjUQH5U+eC6C34qFSHHohzwv1fRZjrZ3JZUhoMJd7O594mXY8ayX8FHrgPO77tN/tPNkcCSj/v4huBnd5MdNv4bAXJeVTjiNovkv2aBsxVotskKBhwfFE/VTFhKAcsw8bS+XYy2IqBOcoGxW3uW0QId/yeWH4KZnsacQJQNzUznXbT0AFehyTZ4n7FdOFE3rC0bHmBff5x1a242kBVj4J2EmQxMahoCjdyDJbyKbFTK2ulIbd2Uk11zMYVSx+XODHyGbsmd3PXAMoRRNQvoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHIq+GJR8HtVKUjGFYRG1IaqZqVQFVcMcS1xAyAeam0=;
 b=FMIVqNDIMC7n9q3nwRGcbAErZusOIZkLVHk9cZXh2VTUsScj+hrNqMyOJdn6PYYHSxv3cWZrTgg44O5UdPQWq2fagFWrnL6cbxYeXi2G4xO5fUjHbWPiMGskBpblMwMci4/n3o1OC52kYer0KZt2Ku6knvJPSDKBi9zGPQ7ivVE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by PAWPR04MB9805.eurprd04.prod.outlook.com (2603:10a6:102:37e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 08:09:46 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::c559:9b57:14ef:ac7]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::c559:9b57:14ef:ac7%4]) with mapi id 15.20.6340.031; Thu, 4 May 2023
 08:09:46 +0000
From: wei.fang@nxp.com
To: claudiu.manoil@nxp.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net] net: enetc: check the index of the SFI rather than the handle
Date: Thu,  4 May 2023 16:03:59 +0800
Message-Id: <20230504080400.3036266-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:3:17::14) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|PAWPR04MB9805:EE_
X-MS-Office365-Filtering-Correlation-Id: 439bf16e-ca75-4fc3-9bf3-08db4c76ec7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Gx4CravZ0V5KMp0LSNFAeuO+KpMqFcKTqonnp7s7QqKXalvm0lNUqg3st5crhKsG23oEc4X7GiQlQAYGmd/plKm59qP5R4T0weI7yQdJ8vkaGORLGmM3osaHv6w7rCfEpi443/9xDtb6yIrCFednow/nIgdETzvHoyoAI/mher+0OzsXHdOF7vG+mrhzw50thsI9hDsocrwZb0MDUPObRmSDuhOmblrWB4FjIpMZ6uFLpW5LjfElp9mgFFh1DY4MmbgfInHrjPARZgC+j2Qc/FwpLONuutLTAhW+8aa082jsLH4ZfVXFwJt130LH5R35KaWfk8FhjgrnufyOX01gXd39/EcRIvhx3qbhCkuTQn8/Eg9McEm70sYscz1PxkYDoNOUvEiHBHrkN9buZYOMIU26z/I5QC9l9anQ6ryrZp6sIcMjbCWykgu2CV9Dt3ZArFus27fMW+B842qByIIn5XjOkwBgsKIMayzSdHT13MZzeD4+H0kEvxR1Mg5kgpk6BzpCRtijf/oGkBd0s3omjNcRaigOa82TCoiulhDBpHTj6WX4IWxpIzC6KgXTdfhKx30GWVozqeIc9+9gb9gBJpUCO2QlRJsaTvtVjiNEowGaL3CUXohk1YmFlQloFp/S
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(2906002)(38100700002)(38350700002)(9686003)(1076003)(2616005)(6506007)(26005)(6512007)(186003)(83380400001)(36756003)(8676002)(8936002)(5660300002)(316002)(6666004)(86362001)(478600001)(52116002)(6486002)(4326008)(41300700001)(66476007)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xb36fZhFQtDAckl8RAisjMOJNnrcA+TRm+kW0aRmcorNlbuIII+tR1G2ENwb?=
 =?us-ascii?Q?IJrYTnmYcK0OWka2VSuhoBV72BGC2nYTSDp1pXoYIu0T/NNcv3I+W925x4Gm?=
 =?us-ascii?Q?c2xjaeBUw/OlCciu0l79Cx3RbxBMvH4yjsnwHeg5r7Wr39wxGGPeMSwY911o?=
 =?us-ascii?Q?hoGvTFkXbe9yXthFjAtv6swScDV79h9Yb3vAfF+Bfc5xRWZFkZnSbNsjb27v?=
 =?us-ascii?Q?DhjUCunJrkJYqwWYlru+JCUqIV5eh9qfi50v44RsqPNbTEbrCsx/d2XVcxUL?=
 =?us-ascii?Q?NKAnX9REtBj7TB7K2sw5Rvb2vbnkKwwTh+Mtgp5Qrn2YDR2mTmRHVOkZ4+QJ?=
 =?us-ascii?Q?KDsxmZEH0WEPdBC1+GPHmoQ4Le6dOhLn+j7kv637903eUMepIFQjscdZcN3Y?=
 =?us-ascii?Q?0bPSQv+FeHyW3eoNbzGzmBgxxBTaWh2B0BE3z1+G2k1gfTmjuoD73PGV0+KX?=
 =?us-ascii?Q?aq2cp+cIQJObyyfbbvWKC7ZTPnp0FZYpF64HoMqBxanqYOSeJ8HnMyJ8mlG3?=
 =?us-ascii?Q?gC+JkcjbY9ppRM46Rb7Xov395CAGuOpW1ePpeaI/XJjqlL2Q+tBMqYeHGQ7Z?=
 =?us-ascii?Q?Mx64578c73ukICO6r4TzqKFNf/HMufekuYTVuijgLnUUdo6VsMXrTPPR+O/r?=
 =?us-ascii?Q?g1x6KQSiaiRzE7DQPYhE5PPF97uMHUd/sNb5rd8CUFyKrl0pvjqp6AdPzFej?=
 =?us-ascii?Q?ql0exIPqaRu9Qn80ZLltxSE/abpJjTpMFa1ns5Y7Ew37HnHdknr7cNSa4ohR?=
 =?us-ascii?Q?5ijFej0CBbjwLb5Gl0vHUt2PCAmpggKzDtjTh7T4kZFcM0XPQRsShWbfq5os?=
 =?us-ascii?Q?ngQ3njvYO+q4GCCOds7+ZaHZRCQy56A9WXViZcqRJKpZ/XaldG0zPTnfocZu?=
 =?us-ascii?Q?2iXsc757bMagd/24T9WPTSYORVL0l9cSsesb/rF+np7aVWoNAJb3+AXkIE0Z?=
 =?us-ascii?Q?IpzOWieEPvxDAj4uY1NMsfFXQzI2bPq6+iYvScH2B5OI3DV/RhZkL0CQUSVY?=
 =?us-ascii?Q?C7EtSPcImoIGqc8viAzFnGWjpGRL1E653dkogTdbZ3PglS8MjWf7bu2JppBS?=
 =?us-ascii?Q?t20FFQYDURMJnQbhAOLdGuSy9qHEVUhoQJfsJOLQYivPkxQRxs0u3bbdjjzy?=
 =?us-ascii?Q?jcTp9xjhd+etn3tsR9sS+cBG6+CWEvAODQLIA3vy/cNcZm3tD0I72LZyCrwy?=
 =?us-ascii?Q?GvrqE8Fm+VxUu7pbi1SXKQR+xLQb8V16NgAp9Mwutu5lAzorBAckvo1fK+ZH?=
 =?us-ascii?Q?nlLmufCLPE7xvy9/vU+DL0lWHGozJ0GTEMHZjeBzxCeYl/yvWbJV+2fjN4uO?=
 =?us-ascii?Q?oOgSWls/ZZRjRbgojseScJA/a7IKkWn6Ejcb8DlIbxu5USDCFF10VBuKSW0q?=
 =?us-ascii?Q?zQk9Y4NiLFDtqZEjWq5VRsvOSoNvh4c60JzaLGGfnmU+2agFz2n1L0PnVp65?=
 =?us-ascii?Q?ScWJxBuLK6J68Lz+9whoo3r3T6hlivMo4R8Sjt1LBD/GD0GbRx4JleiQaHBZ?=
 =?us-ascii?Q?v6hsxvnxO2r2fCOU1/glFu8zdPJ0xzlLZA7ZM2wp5pBhBnHNkVUisoFQqLLn?=
 =?us-ascii?Q?U/sudl1c80f/vNEI4GwEAcxY2xPMmrRXCl1SmTyB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439bf16e-ca75-4fc3-9bf3-08db4c76ec7b
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 08:09:46.3860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IwoCi5EYLQOdthe/tuKO7KqAgVIinY6FCa40IhozkWsvZfSXSqcg4btk5OMuvwtFpojWCtAbRBI1cAMA9+O35A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9805
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

We should check whether the current SFI (Stream Filter Instance) table
is full before creating a new SFI entry. However, the previous logic
checks the handle by mistake and might lead to unpredictable behavior.

Fixes: 888ae5a3952b ("net: enetc: add tc flower psfp offload driver")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 130ebf6853e6..83c27bbbc6ed 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1247,7 +1247,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 		int index;
 
 		index = enetc_get_free_index(priv);
-		if (sfi->handle < 0) {
+		if (index < 0) {
 			NL_SET_ERR_MSG_MOD(extack, "No Stream Filter resource!");
 			err = -ENOSPC;
 			goto free_fmi;
-- 
2.25.1


