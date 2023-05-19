Return-Path: <netdev+bounces-3788-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0B0708DA1
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:05:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADB5A1C21197
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 02:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE80E38F;
	Fri, 19 May 2023 02:05:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550A362
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:05:47 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08DA194;
	Thu, 18 May 2023 19:05:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2V9ciIbDLLW2/NvHDI/YBQQm098HEEHj2L+O/G2sIAPC3A/Poh32R9ZxtoC5zWmkrJv8J0Bp/+fHmsVklHqC1lSLYZWLzfRDTmF8KYSFuRJvm44QIJnzJl0Qk4s4XOwkwMMwO5I271S3IC0JpBaVqes1voqQekQA0g+YFzD9f7LGpko/rPEFfVZs9pAmhB5UN30Abl2mtFp3OOU4nnRYZf+/lMVRRH3H+LP/5kGrTrhbFasva5nomdVRzLFUW27TYWq0XeFKmSPtuTyBOgGvKkSDYCXxaujoH9OWJwSdDWxp4GRAA/+2ekT2RebiGXhJNKxKqvJxzkRCefrAHcYwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pI7RMzzQIfplPS8sT705zsU+WpFrFiAugm+rGZViQNE=;
 b=LjhA5GKq+Y77fxaPbjbBExOjQ+xjE1qZrtlSDnEhnki8ak3P2f0d8LFS8qu0Ga+gr+B728Z3EtysVf/6ePCdgy885IfH5JxEL0V0Xi1MIm4Ih46hEYG26hQidrKRtHi529O0ezXul67qjUfLOnqlWwRg3RXG4i1I5IJxBPUk0XAnUVhr1RblBKG2s+19GBuTihkaim9/neB6bOi5kPXlf2cRRbvIDmntAYsowZ8JDywdYarYuomG8STfyGQp33L0T/7wpTszV2JDIiC+PVn4myXbTXkPh3wrJWxbxopvn5QXXXveFHhAJu0SNleErRNIjZnSX9d/mIdptPqqXYhfQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pI7RMzzQIfplPS8sT705zsU+WpFrFiAugm+rGZViQNE=;
 b=fT4VAST/OYgzv40XymrZANFOWwpVxOSI2vd/hw4tjyJZSzSV4MB6UcVlsilQJcy1j6CzQbIJ1CNA4MHR3+SAcrhGTSxJs3nBxZwioSCuXQeww7MniP8csh0u6zDOqjZZZZfdjE4LZpR9nHNnwlsIAx5DwGs751sVRM2Vs93oN4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by PA4PR04MB7664.eurprd04.prod.outlook.com (2603:10a6:102:f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 02:05:43 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 02:05:43 +0000
From: wei.fang@nxp.com
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Frank.Li@freescale.com,
	shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com,
	simon.horman@corigine.com,
	netdev@vger.kernel.org
Cc: linux-imx@nxp.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next] net: fec: remove useless fec_enet_reset_skb()
Date: Fri, 19 May 2023 10:01:13 +0800
Message-Id: <20230519020113.1670786-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0138.apcprd02.prod.outlook.com
 (2603:1096:4:188::12) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|PA4PR04MB7664:EE_
X-MS-Office365-Filtering-Correlation-Id: 436f0903-81c3-4545-a277-08db580d8d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	y1jQPMCHDXjYVUAlN8REyN5xcdO1pYW74x8jgc1NHm50k0cKYX+WCHDuvagRww5EsMx/kC6/N0krkf0Hre3B4m3bjXeAdlK3qHtsaWMFZ4nhPhjUl7XrURjHDFduRDeT/4TdUiB2cPto4NGlDfZN6Zmhkw0fxv6J9lgtjXDPM/SEtVLNTpJlAaG7WJe6mF4K4TEpjq6JKjY4dQa9NNwgo/Y6eJousQBtcX/Nq5WVRpldFXWKgkpLzstVyo1o5JVjaFymv+GIKxfGRLP5rIVblcar8djrBoVg/M6j1CPx/O1zwnmUh/HlVg0B3U6hkAAOPH0JglaFX0tOn6wq3L7RkWo90MIdqxrvyS7mSkSvW47PCAgpjYhcIPRocVyiZ5mlipeV2ucjOZkNlybIiWigwGgZvo6LmNmrpTflcbumDKeJrCiNxtyF7u2d99d1EsrvhzlfzFgi3DbL5eXticvK9/asPqfl/8BLIdN4PfB/ayLHXIz2F0/xyBYDC9gARHAA3FeVdf3R5K+YFifv4U4/CNpP50mg7RiAo6Bq7yOGQBxHqWAnAKikUdnRgeVYxhoSPKGDNzORCegcv/ZDKpE56UR7u6keUxJzWoH0T3oscD3bTfcYNVDlhdRyvdVefKn8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199021)(66946007)(2906002)(5660300002)(83380400001)(8936002)(8676002)(66556008)(6666004)(52116002)(41300700001)(66476007)(4326008)(478600001)(36756003)(316002)(6486002)(186003)(26005)(9686003)(6512007)(6506007)(2616005)(86362001)(38100700002)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dSap+fJMtCgpNxD8hE+juN03rtD7ycF2ZAZm+hHzRKlUSXSQainS40a7u7Y+?=
 =?us-ascii?Q?yEL4ZkPzk4NuyWgEpFIOvYADWIiOD0WlbdpC4TqVAXS0MQvAQtIaA7PRhA/R?=
 =?us-ascii?Q?MVnvNRriIpPuCaSTmnSmil0OQruba3c3Ycg4LwRVhuKzuguu/ackuT0Rt0hO?=
 =?us-ascii?Q?Cq8t6a+1PQpdmA/YyrWS3w1YP8wZPWG5/v/SnN1A4xLDo2nOOBMbjAxI/X2G?=
 =?us-ascii?Q?ePg9yDcKlyyqdE9a4qDDGasxiPcbAv9+NNVsUPVimyz3dmLm7pZXZM7rTBI0?=
 =?us-ascii?Q?3IocT5XFDWa7Ug+7qlXP5Y/hgEq2GTq5LHmHnfoss6OiOzsK2gWDNE21fWHw?=
 =?us-ascii?Q?yFYGQDEa8jhfge+QgCxP1Yl5r2lYgOajyi53Hmhpw9rxPlwg4jSI1WCyk8/C?=
 =?us-ascii?Q?2cmzfUdL8rND6c0xZ3I4//hymBHru3mIuxM9aCyTqaYSketxCbpZnC+h1jYX?=
 =?us-ascii?Q?nW5f9dXTvK1R2tHbbHnpoag6TpBc9MCCRnCxDdEbvLUuZbK94ZukqNaCv59u?=
 =?us-ascii?Q?fEoE0xTas+f7ZxOldKXvt4dRWY0bjROcbJhZKJGWdMZ7JeMDfu1fDlprgNYt?=
 =?us-ascii?Q?uirRIxhsTNN83WEjMyj4DpMjqrrqjH+QVUGamAi7YmI00+ZVPC1Su4Lc+LsG?=
 =?us-ascii?Q?fFI8DaPQuCsnawjZmxerh7kI8JPVPYyHY866QJSt34F3RnMpN5Rt+iFhZ8q2?=
 =?us-ascii?Q?lsczgAPSHFmu37wZi2WnyoXA5qE2QCS0gMPJ5y5nBqz//ZxxFxDrbbu2cMW6?=
 =?us-ascii?Q?v0/gGU59h9bbHDac1nosvVYlAK3nwlJnjBJe6CUkAPycz8S5zqyXBEtlBujT?=
 =?us-ascii?Q?F43rn5v7+o5Gc41gGBdpvMPbJ9v1BrGrfxW1YxyItRyKJhoJ6kR4bY3kQK23?=
 =?us-ascii?Q?ih6AOTuXsLIb+kxswFYtqABipBWoLbSoBmrD9mAf6f4ja9Pgo61NA5fQ/Gpo?=
 =?us-ascii?Q?AbIkWdJQvoW693ziOmlcS3wMrFnAMgwwciJy2BOPrVqYHYN+5YQUf9t0vE8N?=
 =?us-ascii?Q?/wKDBURlfAT927M/x5KHPVIXRdN2K8QcRkgG8YvFkMlJmsJLXzsvMQlcifFb?=
 =?us-ascii?Q?7WofMM5RdPsGyKJg0PR7XnT31I9TopEmtO4sQ4H8c5u6zhmBFGYjHgs19qQ9?=
 =?us-ascii?Q?HtPaZHHfw+h2zbSkWsimcULyZeQJpkncao3e2MKISDF74xsjYGHb8CQuLfVx?=
 =?us-ascii?Q?50+7JNtaVgbmb/U+m29A10oFeafglQiHVyQb8TIako9Xi4asqj6rdNvOZbtb?=
 =?us-ascii?Q?93pbTB5RZFDKq8GyOCW3gyoefTk+Ua1Ta9s+df2pPaT3dvtbt/lZtrgvj5Rr?=
 =?us-ascii?Q?X1nqcc6A5u5yI/Rtq3eZnAl3tTHa86Ld0l7CQ/B3f+prXMvXDNow65AfbZyS?=
 =?us-ascii?Q?HM9BYprdnlQRrWhXNFhQ/31uLppiHpjZpTEPa1Role8Ebz7/UUkLmNWCxNJl?=
 =?us-ascii?Q?WcjLtq7kMHKi/6SYXNRmX88mNIBr3MTgojkjjoUM78M9/fdARh56n5eNlPPq?=
 =?us-ascii?Q?54e+LTBn87iD5vMqXVs8tY/J7hI1vemC8LmXjz44XBqHK9FOmLqfCPqSO4za?=
 =?us-ascii?Q?ZiEFsCWP2Te424G2Kktr5uApXFTLjatdRShrgG1K?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436f0903-81c3-4545-a277-08db580d8d17
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 02:05:42.9760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boUYd3vxQz2l44OPmumXdEJ/a1+l9hf5UXPNkDTPnQogLI3ka9uh++3sZHJrsm74AfbnlRJGRkmW8Ekkc3vmQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7664
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

This patch is a cleanup for fec driver. The fec_enet_reset_skb()
is used to free skb buffers for tx queues and is only invoked in
fec_restart(). However, fec_enet_bd_init() also resets skb buffers
and is invoked in fec_restart() too. So fec_enet_reset_skb() is
redundant and useless.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
According to Simon Horman's suggestion, it's just a cleanup and without
user-visible problem, so change the target tree from net to net-next.
---
 drivers/net/ethernet/freescale/fec_main.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 10cb5ad2d758..e1975a3c7234 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1011,24 +1011,6 @@ static void fec_enet_enable_ring(struct net_device *ndev)
 	}
 }
 
-static void fec_enet_reset_skb(struct net_device *ndev)
-{
-	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct fec_enet_priv_tx_q *txq;
-	int i, j;
-
-	for (i = 0; i < fep->num_tx_queues; i++) {
-		txq = fep->tx_queue[i];
-
-		for (j = 0; j < txq->bd.ring_size; j++) {
-			if (txq->tx_skbuff[j]) {
-				dev_kfree_skb_any(txq->tx_skbuff[j]);
-				txq->tx_skbuff[j] = NULL;
-			}
-		}
-	}
-}
-
 /*
  * This function is called to start or restart the FEC during a link
  * change, transmit timeout, or to reconfigure the FEC.  The network
@@ -1071,9 +1053,6 @@ fec_restart(struct net_device *ndev)
 
 	fec_enet_enable_ring(ndev);
 
-	/* Reset tx SKB buffers. */
-	fec_enet_reset_skb(ndev);
-
 	/* Enable MII mode */
 	if (fep->full_duplex == DUPLEX_FULL) {
 		/* FD enable */
-- 
2.25.1


