Return-Path: <netdev+bounces-3396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA602706DCA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C650C1C20F8D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA60A111B8;
	Wed, 17 May 2023 16:15:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE2C171B0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:15:32 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2087.outbound.protection.outlook.com [40.107.249.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D521F1BD3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:15:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqugK0M3zCp4cNIh/nvAe3vAQSozcOgnTzYDpj7lA2WcNM57PEpwI2LQetv4oEycl3vcxtcys2inE3I3G8q83EUr6pF2sBUrjQnYkMF2CBWbGGwcCeBv8aSdckQNRn3TlcpqE7WMvLXW7hMbLPbO2F29YAChJqSwXL6MXWqznmSX+ztlL0+yzEYWJEL5uM2d9Uo2yXp42TGSibW3+tCLrVUVSIp5vNXEPPd6Pya6XOiIqxjqvfWFOZN3DyPddBfO8m28sWNNWQ2twcGftjuMF94G0rjOAWTcObh7sU/6hH8CdXB7IMhX67zpbeqjwIFYyWihEPUThRF0WTQyKyQeBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jp7Ax0RQtx5OVmqhHRqqx6aj7v+KYVroaES9mPVJ+xc=;
 b=L2q/jOpm0OngzgkwF9tJudEjGtZyApJgA/Mhb3jCtHsTIIZw6poD9aCO4yC0Ai2GIYzSxgVDQX044muxvxM544QiQdU/XEG5O8DBsbQVUmd6jJSBaTgRtxWmonv+4RizP83dBNGFgMwe/VupTkSFFDM01eqVSP9EfKQ2W3OLZWjTUAO+koY1/Kocsh1BZcpTpLx77EEftJoXAJIQtSSjdnB9cDTf4VU9S1z/itOEkQyrvOglmR7xVgsZJkM9l3f2vDfyro4ssVnhkeQUaFq3jYJcm0cfqghmfMDPqFJ0D2MMypoaYWoWWj8/5xwFt05+muGWSlwXGbIqLZFthBvWRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jp7Ax0RQtx5OVmqhHRqqx6aj7v+KYVroaES9mPVJ+xc=;
 b=EQrRo1+GE/aJDp0XqUbN9NlGwZe5Puj63bz1YStGTdjZqHeoiLhXsL6NGCO2I41Tc94VlloDrIFI469iL20i9exutsN9mhDsOkayVmx/AZScZb1WtHTaoaVSmWXXSlL4kYC0LRe1HliYrmiTAIpF1eS22Jo4Yoqbcic9CMD7gNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS1PR04MB9240.eurprd04.prod.outlook.com (2603:10a6:20b:4c4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.32; Wed, 17 May
 2023 16:15:20 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.034; Wed, 17 May 2023
 16:15:20 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	netdev@vger.kernel.org,
	imx@lists.linux.dev
Subject: [PATCH v2 net] net: fec: add wmb to ensure correct descriptor values
Date: Wed, 17 May 2023 11:15:02 -0500
Message-Id: <20230517161502.1862260-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0037.prod.exchangelabs.com (2603:10b6:a03:94::14)
 To PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AS1PR04MB9240:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad21bfd-4a62-46f0-8c21-08db56f1e94d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qN0yoxZnKbCoE6UWsvITUE9VnS+O5t7fElk9gYQaaM4t/Nm1WQwZ+2wpVSdruZ7PFWwpRJRgepu54yVbfMNJ0lUZiYbZSzJIneO8lV52Cn2WUfHgpfq9k3d7qwEBV0S/zBL2jD5gWeS2rBcotDsmxCTNKwoD2x+eEPDWWeIdyQ/pU/Q9FA5QPMxfN2LerFIdd+lOFaBfjOXv6K2F/sPYOn0qg61VB/LJ2Qg9Gz9LZFTo0onTuq/ZuEKhPb7bMCxrzthWMD4Fvyhdyk1vV4QsfrF13slACQvh+LCzPnStThqyaily5PQoAOTXhK3jq353hSMqgjXM/UoG7jVFFMMj8lvqXXDv/QpUCutG76CA51ZSXunaQM9l59ah8by/oIfzcGp9FXbivZ7JTtghKHTIibNpu8DwZ7Jy3f1SLttsz9nvx511H6YYVCjhz2//il2XG6KXEMQbZB63InWCCuffk4w7UoTy4tZaNlh1sOf0xtL852E7AmKPmmklSuUKceOfjnJ4lXdxw1h2LE5pJB+exhnbFrI3xMzm5cb7r2e58+pLj3JbniLa2hdK8mA9CHd0ZGv7fnXzIvLLxeYMW7NWDzVnbXPBEIvJ627NSBSuV9Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199021)(38350700002)(478600001)(38100700002)(186003)(1076003)(26005)(83380400001)(6506007)(55236004)(6512007)(2616005)(6486002)(6666004)(52116002)(36756003)(316002)(41300700001)(86362001)(4326008)(66476007)(66556008)(2906002)(66946007)(44832011)(5660300002)(8676002)(110136005)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p/TGkMiAAwIFqYA8F1UPAxTwGpgoyxFYzGwAv9uqr29Y2AUrV9FB6/wHR7JA?=
 =?us-ascii?Q?Mz1Hm3u9pLE2vuV2Ou44mdo1oDCR42dyoxPHld6oC9Ntr3igs6NO1iO6lGc2?=
 =?us-ascii?Q?lH8S1X46DsNCAQQyfU/G7VwW4AXCsok0eTRXUzve0/+v8+6WZwpkfcVLy3ij?=
 =?us-ascii?Q?PKxug4RJXWwcRXHxbnJHIL6JyubGSlUWIE1rJeqSTwgyD8VKq1vCo4MMzzQk?=
 =?us-ascii?Q?s8bFWK6iFLb/OyA9Gz39xBQr+rS6+sxySv+RYQS8SN6IxdEZCaK+fO4SV/R3?=
 =?us-ascii?Q?38bNJLK4q4ahzExqy0kctJBJ3sRkTJWF8SRLTxY1y0F916TowEuhiPjzY4c9?=
 =?us-ascii?Q?HigQJB6YeDO+e9+IPcH2N1BTF2VvVaK9SpuyJrrxsDkRfzl5auCe2n/gBQJ0?=
 =?us-ascii?Q?rCgxDY6nqCZyllPvTN0hf/mhIJJoKW2Dd+OyMIerzO37ofTGY3BcOrODAIbN?=
 =?us-ascii?Q?UuP0Tqgn+9jrxvgeE7Mk0ST+eHAW9AhySjtr7BgJXPCaxhTquzKo1PpW8D+H?=
 =?us-ascii?Q?0DXBxU3dSrHie5djnmRuCTHMfFYeFdv0xdVuOw/Lm46UCO7CklXYhcWDzIy9?=
 =?us-ascii?Q?5W2RJ87o3GxfUUG/nOU1x1Xs2vqKmVqBy5VXPxJ9dpeDRzcwQ49uJYZnxHDV?=
 =?us-ascii?Q?JevHphI7DsGZe6JjeRQpT70OnMMYwLNr7kOR0P+dyl1CW+OzBHyFplKkkx5K?=
 =?us-ascii?Q?4cego2gBuNw5/qKKKwK+myCU8osJZHemBbUTc9KNADsR/u7ijij/dZ0EWndu?=
 =?us-ascii?Q?M4aOuKbtkn4QVtxOwGG8d6uwfFnTM4nQTreLeSbpFT1T+PKZwTEE+Xatl88y?=
 =?us-ascii?Q?zF+gCAleb01gjUsU4rrBB3m9hwbE1bPridWmGn7GEVCjhQ/UF+H+kexXZt4l?=
 =?us-ascii?Q?4PDHMctzMMyYCzTJGxDfy36B2AjGjcPs5FJGNFhPFNDWRTOFn5wTnctktlcO?=
 =?us-ascii?Q?y4pGljzXrj95lJhiQZ9k/f4IWt1i9rui4AKxAAghKwBJC1SKZElPmEAH3zAY?=
 =?us-ascii?Q?ejVDjBhWVQkKpZnC3D9qq7y1JLO+hOH8enPZXFAvd5Rpq8keAwzBn1DVc0k4?=
 =?us-ascii?Q?OysxlSiubnYh6pC/ic/cQ6rCkCfWql0X3nCfw87kTsodUAt2yev3kmL1Cidw?=
 =?us-ascii?Q?DM7S/YbzzGfuLunCPgQToEFQtOAiry4cw4LX4sOllnfcyYrtGQ7DF53vEaq5?=
 =?us-ascii?Q?RogFw1IMhT1up4h6g0AqIjkhXjOGAoqeKMlc6R3OeK2jeLwjsqI4PnlnZe6I?=
 =?us-ascii?Q?OtS7BxjqEnYA4GkTkvocy4+RF6lZxNNtUBMyZ2AZr5tn9dYsDp7cwQDngjjc?=
 =?us-ascii?Q?HOLRam28NQfckbPHwneJrCdH0LgTc/0tyuuUIdj9UCZTi7jQNT/Tuci4Lc7n?=
 =?us-ascii?Q?8xsHvoptmE2hY7QqmppCRFf42LDj0ekRET0Wpqk5rdOHuZbNpgHZGzCTj8/y?=
 =?us-ascii?Q?0orwlYvw2OLAOalIMBXkujLgiT6kqV9DUnBxUB+PoHyQJdomnH8TKMh7xVKi?=
 =?us-ascii?Q?Pqbo7xO0eV3BIsmdw9KFcrs1RuB3Tn5R58OKbGf6HPEfwjY06mWrbRfkVeq6?=
 =?us-ascii?Q?ZncHTjNx2PlJvNSYgVUdonJ6/FRHRqxofv+DpuN1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad21bfd-4a62-46f0-8c21-08db56f1e94d
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 16:15:20.7365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQTkeMZPIptNpqMNl3ZzBjgu2jVRY4I9NwiPXgbS0XLsOG1/a0UPIjtw5zHA6fFrg4r9z7zapHq54ZT6S8M+xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9240
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Two wmb() are added in the XDP TX path to ensure proper ordering of
descriptor and buffer updates:
1. A wmb() is added after updating the last BD to make sure
   the updates to rest of the descriptor are visible before
   transferring ownership to FEC.
2. A wmb() is also added after updating the tx_skbuff and bdp
   to ensure these updates are visible before updating txq->bd.cur.
3. Start the xmit of the frame immediately right after configuring the
   tx descriptor.

Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 v2:
  - update the inline comments for 2nd wmb per Wei Fang's review.

 drivers/net/ethernet/freescale/fec_main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 6d0b46c76924..d210e67a188b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3834,6 +3834,11 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
 	txq->tx_skbuff[index] = NULL;

+	/* Make sure the updates to rest of the descriptor are performed before
+	 * transferring ownership.
+	 */
+	wmb();
+
 	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
 	 * it's the last BD of the frame, and to put the CRC on the end.
 	 */
@@ -3843,8 +3848,14 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	/* If this was the last BD in the ring, start at the beginning again. */
 	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);

+	/* Make sure the update to bdp are performed before txq->bd.cur. */
+	wmb();
+
 	txq->bd.cur = bdp;

+	/* Trigger transmission start */
+	writel(0, txq->bd.reg_desc_active);
+
 	return 0;
 }

@@ -3873,12 +3884,6 @@ static int fec_enet_xdp_xmit(struct net_device *dev,
 		sent_frames++;
 	}

-	/* Make sure the update to bdp and tx_skbuff are performed. */
-	wmb();
-
-	/* Trigger transmission start */
-	writel(0, txq->bd.reg_desc_active);
-
 	__netif_tx_unlock(nq);

 	return sent_frames;
--
2.34.1


