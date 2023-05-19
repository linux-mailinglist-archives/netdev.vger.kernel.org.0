Return-Path: <netdev+bounces-3787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6439708D8B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F357281B12
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447F038F;
	Fri, 19 May 2023 01:53:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D70362;
	Fri, 19 May 2023 01:53:11 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2062.outbound.protection.outlook.com [40.107.105.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EE010F4;
	Thu, 18 May 2023 18:53:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Avhzmh3zGyeIzmdwacRh8CC8mHnbtmuMi+hRBa/r3FGMzTnOKC0qpWMf8gb7zqKwVBbu+94gDjXUGmvNNA+LuJrYYbgu3/8eeGjiaH2mvlIApH0iHSpJcYHcgRDRkuXyJAG2L8TmbyqJg94YobPTvX1RlyXmMTFhhvLA6w7sE1JvC8gqK9Em14tXalnovEp+DEZ8zu2LeK22/o8e+RxADNGoKuag+OEmkKWU7jSFXcrLLv1rlr/BoPEmDSrMubKAfF9T0GBitPEep7D/UOhe7rNwLcfXbuuun/S/TXoPL8vYDmQT+WLeVb+krZkNm1VgjSf2czj6IEpS1Or+xPcyKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfLyk3ljl1W2mwxZANOkwsxQFfXAcWFZduwf354sSfM=;
 b=Omtxxx0NPK+NxCIJLFH2jVjm7d3luSprhsOVRc/nrcJMfjnc8OeqWdcmpjEPfERnKRou/wX6FSNpLf+UnUeQhk/7mZfnMcCjMWph+6AWnNR1JCsTEBpY1Z3oxUAAdunKP5OAvs11mEfrZGw8aM7ingC7dShkfCenSiNowPHv4AUIcahqKmkUAQh58jzqMQj819NGT3cWu27+T4cJbzalxi9YU/5UjMGuzakqghLK+ky3vIrwLm2oQNW4FEUlQFiFCXj9yDoKncHsQd7S2lju+B89uWnPH0w2mA8VH6Eno0E8jr2I0TYlfKCRwDwlGlGPKtLtD2RCeTATh+Qm7mIteg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfLyk3ljl1W2mwxZANOkwsxQFfXAcWFZduwf354sSfM=;
 b=U96iONrEDda2h54KRE2IXJgCjaOLDceALP8bFu8U8eie3WAP8dp4nPpckNcPWTKHEDo1wAsma/qK4tDeZQmwUe2iQ8S96dLi11IcnB7XUKzwSGiE8EFQ6eaKPSD3EV7YeCmHgnwoM5E8Q2aYLFt1d7q/tF+bbUohClLVj0h7x58=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by PAXPR04MB9350.eurprd04.prod.outlook.com (2603:10a6:102:2b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 01:52:58 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 01:52:58 +0000
From: wei.fang@nxp.com
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com,
	simon.horman@corigine.com,
	lorenzo.bianconi@redhat.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-imx@nxp.com
Subject: [PATCH V2 net-next] net: fec: turn on XDP features
Date: Fri, 19 May 2023 09:48:25 +0800
Message-Id: <20230519014825.1659331-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::14) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|PAXPR04MB9350:EE_
X-MS-Office365-Filtering-Correlation-Id: 68c0a23e-8b20-458b-a90a-08db580bc530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	05gtidu9rO1+ywxlB41ltrWuaWeBQQ4SrkmEtx0NT8VSfufTy2U2OYBikVBFDrXo3zh0wIxfR+rDrU1STtFbjKXxd2UsvrRz6s5OZopKAWEfdHIGB+utkhO2PhXaObaPfn9fWQFbnrYOzENR/TmLLUmuFeKAbUw6ZmMG/uAwcd7sibKOYBly590mf/a0nEK1kgZFApiD4wzIU2sl5FILBjfjLeI1iDksKNPucb3WrpMCXkuaYQjOBvBnNNQLslSLHcnGaGBsRq9XzBXyTqWHRf9kmVUc62yPW80+FDq6KuU2EpJm9RAJc5zNTOVaGDekE4uWOaE95yzSOZRF9O1PoX5LNJzECbpaM26bp0QYzJ7JgK6tKrKCq9ySifGaTgeqibboJbupyjDhL6fnVu4QjXCazzAvl3ul3vUcV41uHF7+kXb8VMIE2UgHtxg/X1EamaolIin7uUGNq2DJq9OxigNXMzWvWU6NNvapPLYXNaz22f7OJVrRkyLX6BV18MDwr9Gx157ttcv5dA5o+O/odrvje+l5Ud77xAuBgyES2zReONIwJqBsPTjhIdUCowJd7jhFdKQQvrGVlwUB5EpeJ4g0LzFxkYQSOV8ou8GgtYCgB57W5MHEyinOpYvwTGBsjJlcDBQuep2si9nsZzUNwA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199021)(6506007)(6512007)(6666004)(26005)(1076003)(52116002)(6486002)(8676002)(921005)(36756003)(316002)(478600001)(38350700002)(4326008)(186003)(2616005)(5660300002)(66476007)(86362001)(7416002)(66946007)(66556008)(38100700002)(9686003)(41300700001)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mOg/WDQ8tw0rm6anBSQw0wHOUOfvYAsmNPrTQMn5bNGuz5pJ9OREzxevLD4v?=
 =?us-ascii?Q?V1A9BcqKYdgHd7/aIQOC4+E3ZLUbE62hCRKx3QsIXLzOzoZXiRtKSaypxGMd?=
 =?us-ascii?Q?jl6+wedBo04XWoYqwpwrWiPVDL7zeaOGKYc8/ICc9JyE12DkSaY9gk2Y+PZw?=
 =?us-ascii?Q?rbG4Jupt15dPfDfl3c0TvBPBgqf0+ch8RNUgFKdTjhlRE/NQMBrMoFiXroUN?=
 =?us-ascii?Q?+bNmk+zJIzf8NfchjJCAfEDEUVW46wIkADaajhdUR6SMr5fTDjEC9L/yaGBT?=
 =?us-ascii?Q?x5tj5LRyhk1/7WrBQM4drFPml15AVKWM92wfi+PX/itkXAnJwjvgOUgaiz3H?=
 =?us-ascii?Q?Hdti8RCoiTfYnBjYHsnviN4Zyovq4OI0asR2ecNJ7xR8Hf9yDz1i5x69/+i1?=
 =?us-ascii?Q?9cAFY9tbDHIliaLs9xO7pkb4JCvVPj4fCH2FnKpYHNBYZW9S4e5gxrkPYGom?=
 =?us-ascii?Q?yCy4BBADwzyN5lV6+oOh8k3grvM90z8E/+p3DdtgYF8OAuSY/FEwhS94ji3S?=
 =?us-ascii?Q?NZQm+4EGwUsGINr+ociPcTTDZ2RMltV97g56FqlpXyWNhUVNahEVcunUweRL?=
 =?us-ascii?Q?xr7khrY6wDDQ/XaqGiE34R2iI8n/WefTqKvAlNla3i6NnvUEnv66MorxmAhs?=
 =?us-ascii?Q?oi2S4qhW2yvZxb1fA1Cv+n7Iq2gq5Caqi2bCUkSzLw1KoCLZP4f/OGKlSDM5?=
 =?us-ascii?Q?FaKwi+lKCB0nBakhKriHFvvi2R3D/FGJNqt6IQKK7BFeo4wzFbmYJWdg5qZ2?=
 =?us-ascii?Q?S+W0izON6UmOtXYfSCb6U9CUJSXt+t3jkvnZ1nDB8WvduSQKdk9kodUwNzkz?=
 =?us-ascii?Q?AhgtECRE/q/PNTFDlEFDYR8WrrboFxGEc++cHLmv2GlwfklZDRsbsfRuUyDN?=
 =?us-ascii?Q?DnsU/6wWmkvdF4Oz6sETSK1MFFiABzIpSuB9cx8xFHrHbS9fcIgyOObgybo9?=
 =?us-ascii?Q?ioTMsEAPy4CsITt62hxpcoi6sT1bGRz9lc7d/ZbA51XZFrKx+v/muSH8Rwdn?=
 =?us-ascii?Q?bp1INrbKgaXEYFw9Bt8SAiKvnu+6HLRu54kKhrRq84uInA4Ybl0EiZBGef1t?=
 =?us-ascii?Q?Zjw11m7WczPuvf1eGsEPqu5DUJxAjJnE376X2NrH6yUkxtnGuzyiMS7G82Bk?=
 =?us-ascii?Q?a2dwYeXAYyfLqBqjaoNJFqzaz8+fQf9G5ptkIMpao1KFUiVxGcNGl99e0HkH?=
 =?us-ascii?Q?HxxaNygGh/h7YzzITvOwMRjU2ThThrR0Iv4pbNux3Q6ozDTEYVj8R0dOd4nY?=
 =?us-ascii?Q?PVyohaDqlHrdHqncmV1N4zWPvVvGrp+tRcIM+qrLHNEm5s50aNyl2L5ONn02?=
 =?us-ascii?Q?gIh/4Rh2qXUvGVQ5OQ4qjxm47r73JQx9RwuNB7dJgdMjHSlFfC3WkwOXyZFJ?=
 =?us-ascii?Q?OTg2FP1QU+r9HMx98IN/1qq6lpfm8Tpyt+MKa9FkUUrfsIuCIOolv+UiUdwW?=
 =?us-ascii?Q?35q09jAgOFq3T0tbv5mPoTU5ZlWTnwloiEnmY6MSbT3PFp1cY7Sv7UtcN91d?=
 =?us-ascii?Q?7kD19HZ8LkhsjkVJ22gYl67GkLrtWzqM2DVAxDIBeBBVZt898ASJeFbB14Aj?=
 =?us-ascii?Q?/YnYzo6gowsa9Md0FQrgXxxqprmkzdQ0Tgu01O9W?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c0a23e-8b20-458b-a90a-08db580bc530
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 01:52:58.2501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6p9+0FTNtR2S59medoB9ct9LtIwCH/feu1A4GBrjGR+ctwSjv0L7zRTkzW+uB3tnTNv5u8JqtecZQEYojZ4qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9350
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

The XDP features are supported since the commit 66c0e13ad236
("drivers: net: turn on XDP features"). Currently, the fec
driver supports NETDEV_XDP_ACT_BASIC, NETDEV_XDP_ACT_REDIRECT
and NETDEV_XDP_ACT_NDO_XMIT. So turn on these XDP features
for fec driver.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
fec with FEC_QUIRK_SWAP_FRAME quirk does not support XDP, so
check this condition before turn on XDP features.
---
 drivers/net/ethernet/freescale/fec_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index cd215ab20ff9..10cb5ad2d758 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4031,6 +4031,11 @@ static int fec_enet_init(struct net_device *ndev)
 
 	ndev->hw_features = ndev->features;
 
+	if (!(fep->quirks & FEC_QUIRK_SWAP_FRAME))
+		ndev->xdp_features = NETDEV_XDP_ACT_BASIC |
+				     NETDEV_XDP_ACT_REDIRECT |
+				     NETDEV_XDP_ACT_NDO_XMIT;
+
 	fec_restart(ndev);
 
 	if (fep->quirks & FEC_QUIRK_MIB_CLEAR)
-- 
2.25.1


