Return-Path: <netdev+bounces-2163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE428700948
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ADF3281A3F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6EE91E51C;
	Fri, 12 May 2023 13:39:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E751DDF7
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:39:05 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2082.outbound.protection.outlook.com [40.107.15.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1748A11DAB;
	Fri, 12 May 2023 06:39:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iL250IhjW9+tZCbxKXpnXOlmZXEhyg9EnFkYah/W2P4KRdfhwOzXHo2aL8jVoolaR3qyNFfkHFrbCwyMnrcncUM7UVDPXni/nG0W/5XZvEkT8NU0Q/1j24bAOd1COpus5Ge2Gqqfr1xHnuzlIBUUOFMcM0Xgjdq0xUSe7ipjv7dH94oqb//bNB84ryi55MaRpYK+d3Z12yGf11yrdN7NY1C2BIKct0czz6hDBZ0RfZYfRN2TbebTjsV3MYYLU81OwZ3i+HkB2Qhds5VCF9nD9pv3JZI+VtuA47HOeW7bO7b44cafhkUlAC91mw9k/y+MN9KIPdpmoyD8LmU5VYKNzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7o1olkSVX7f7WMt24WHnKppcpCJKudMgi/Q8/GkPu1c=;
 b=kUumWRD2rEDNxZ92CpSx9NINnjqEI53JEt48Ied1fPKCc9K0VepQmrH/omL6vwWEP3NIPD5J8yuWxbny1ZW44YhKSWnkF+rQV0691bKSqir86GBJ+ELmunGfFKYYxMnvCM45kvzWVtQMWNRmXRzC0sKjptGWDYriHoe6FC1BwinMi3pMdzrEUwf2fiIZAFMsLDFKC2P9FSm7ThXtKo046C0jLEufjPdrZOATBcKV772pTbsuWJ+dJkdJwOCKNxHqJZtT4UJ6xYxkr6NA6z1YbKrAkTk31qsPjG2kJybcqG4TDqK5n6BOmtdVjxOpd4QokxGmeUoGCicSgvJZrnQomw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7o1olkSVX7f7WMt24WHnKppcpCJKudMgi/Q8/GkPu1c=;
 b=YQ5S+vmcnwxkrr2pFcXIe1nvOhN9ANbH/LNHjHhZLR/yR9lToNctHNevLGIb58gtyUjOdzr7xf7STXbtPfbM3b6fYZ7Sj5F0beqfssj2m50szhelk13kKdvMsbKm8waQOSmgVF5xBBlK2DSwypBVkKriyM3CqFvb0bdK0VgjyyM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM0PR04MB6803.eurprd04.prod.outlook.com (2603:10a6:208:187::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Fri, 12 May
 2023 13:39:00 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.020; Fri, 12 May 2023
 13:39:00 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev
Subject: [PATCH net] net: fec: remove the xdp_return_frame when lack of tx BDs
Date: Fri, 12 May 2023 08:38:43 -0500
Message-Id: <20230512133843.1358661-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::22) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM0PR04MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cd2ab4b-ec52-49f5-86d5-08db52ee3e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oP5mzx5YYz3l7It6dHbmu7Npxlqp1Ggd24gxfHN067x5N/yjiz2IiCzUF+xgPTlzPy8UHey27eSC25H0QWuomE3O0SgeaR9QsNPpB+gFa6YMZyB9q7HxaqJfXHFBdKNDNg/WKyxdZNkLoN/8D0Wn8IP5uZ8y5AsotWvcVkEzuDicYJnoVaxA1iP+uP6cRVB8DliDoNvqYmrsoUOrdTKbOsCiL9Qen3sxbOIfaGuxaV9RVhniIXEcT4JBDzk820PK49iuMMZfEj56pcP8yvnlSWHC0MivXwx4dihbxGCkedhxbTSkjAiCIJwqvpzL/L2/N45+qlofexa9O3GX8LZdTV+8gXhkDMPz0oKp+QSuh0bjHkq0F3zBNwpZhh+KLP62dpbyz13AsdSX0Ce6QNX1Qp10EaPqKT5tJMt8c014N3pfcju2nidKpFCau4wTtawb89WlryHGPJlrkqYBKM9SR8pgpYPycFQjSbO5jDOlt48PxI6QfDQQvWvEh4OHMUzitbUpI5N36obsSTCMMc8SvwWbdPF0jSnX5v8CjRSbJUj4N+l6gTcpGoaRVGGNRzmofEmiuUdZstA5cYGx/h0c4ykvD5StsbPqLAQ6MB8L++rmQEJWXfnXBNuNWPNlcXRs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(451199021)(7416002)(41300700001)(6666004)(6512007)(38350700002)(44832011)(5660300002)(55236004)(6506007)(26005)(38100700002)(1076003)(8936002)(8676002)(6486002)(2616005)(83380400001)(186003)(2906002)(4744005)(52116002)(86362001)(66476007)(316002)(478600001)(36756003)(66556008)(54906003)(66946007)(4326008)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vgfHDpayGZQFKKr1q7H3kSNKLny/GM9Q4+Of//U7LLuxCwUM7GmHj1FjUC//?=
 =?us-ascii?Q?+82FHJE8/hx37y3ELi4lQqug/BCUPfPsJygQ8PafMjlbd/6eKVrl/gxf7rSo?=
 =?us-ascii?Q?TNXUSx1e0IcMWfYZO7re5ljTRq6Rx1fiHD3xYjIruhqxsCGR2vEH/YxDNnKU?=
 =?us-ascii?Q?MJUWKAG48CoEDTS2Mdtf5gvigQIkI++O9+PYduZ0m9tw3AcoD67ga+rSMi5U?=
 =?us-ascii?Q?mKS5sfrQW8/GyXSHvuOEh4CZddSB1RDY4tgcKxJKYRJxeo6RO1YV1zpDA9cq?=
 =?us-ascii?Q?V+KrQYJn+p7ibFXo/fcICVFKCAuasm6xBox2b0RBDJcbTzc5MGOLiay7IW8x?=
 =?us-ascii?Q?9aVrGV4vHgVcpt0j6Z7VN9M1EB9aVhZyiYx1YwZDXcFZkQbI8VS4Q1+UAnZU?=
 =?us-ascii?Q?QJaArD2uSBh0nM1ZMo7tQYsKf5vhANFJs2i0VzOvuu2McCzJN942rDoqAqXh?=
 =?us-ascii?Q?ou4QwrjDoPIASmpDk0tf1GetrfWuIkRE5tevz7J2WTxRcznnmnThKPBqkhng?=
 =?us-ascii?Q?GCTDtkWMHrcGmSVbdYZ9tz3FtP3uzhfre/hldav3eFmjoQN/tDVIlNSPN4rc?=
 =?us-ascii?Q?FoslTNlfj8a9IQqAjjjshAdipBXYmYT7cgy3IIuojc8l4c8yiAkZWYMzL9gR?=
 =?us-ascii?Q?R4YR5ZwQaxNxTwHniwlT8w9v64CR0V8IdVWTFLunLfFidZIkUIP2NZ5dlqOm?=
 =?us-ascii?Q?LfD2zzXr2qb4litYlV9j5bHun+Xe34N/PzgauHCrLnGNBnhBHlvE2qABL84b?=
 =?us-ascii?Q?3Dph/8Nrd/xp1Ge6dxNBuGTUcB8/Cjp9s2t9pT6ci0A2YpTrEu7APjRRF6gE?=
 =?us-ascii?Q?cmBAQvkQ3tFWIbqjsgeoTXIPNVwzH4YieokxtIjVZzUGrAucnp0HltRI68fj?=
 =?us-ascii?Q?NzOltBOMiAbcCJNTwsQaXKcMHVw8HEvx8JxA/ZhQf6lpIxis6GF6a8k5siKe?=
 =?us-ascii?Q?FFTKznANvKDbHeHDms3IK5lzGZKYcNpn/CN9qlKsz9xJyFndvPGiz4QDXflr?=
 =?us-ascii?Q?PHo58ZHVyyi+zBtHjzc7MhlS9rp2uSh67e53XR9uyKBk6COpVz4U83bbHB24?=
 =?us-ascii?Q?2XXz1CK4CmjasP1F8G/9L+NkGThwzROD0VHioGiGJOuUNe43z9WCo65lKl4L?=
 =?us-ascii?Q?8MsyQp8//Mk1488PH2dDf+02ReW+yBWbpfGaeqtSVj8qmArOYmyzws5r6C69?=
 =?us-ascii?Q?MijmvK+OktZelNY5eNfwGUH9e3fV3kvrNP/8uLSad+8d8+Z83WU8EvXcSqGE?=
 =?us-ascii?Q?eUgLNpoMFN82RteO9zD/yVnCRlARQ2uAZLA8NCjY5RmTidnoR8UeQjbdA+7n?=
 =?us-ascii?Q?C5QVf+z7GiL2xzmtOaQ4fCVXh0NEzAsm2DgByrIQWw/flcSIM57iPfcTWf1E?=
 =?us-ascii?Q?CNjjGJhEBS45yVcw70dC5acBJdor2LMU+Y38qOwGGex85wgiZ2T8Ew13bZHX?=
 =?us-ascii?Q?PHtkc/pkH45V8Sb4sf8FAxZ07ywQj8bI6yeF3MdSYV0pxdYHx/FzEtpA27O5?=
 =?us-ascii?Q?9Oe/tuhOMeBVK/c/uHJ6yq+Y/xTikC8P42mrX/zoq3rj43bM2jBY6ignVoIx?=
 =?us-ascii?Q?NQInbHQralbDRVUY4nV4kQgit9EUgoHTlhhoGzmH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd2ab4b-ec52-49f5-86d5-08db52ee3e04
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 13:39:00.2357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DI801lf9p7pjeC1mLgO8IGM/ei+M9WpuPDH3H+qfiMSHJc1ly0OUb2kwJGM2aaidWpunCEtqy7BNZA8PTY52iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6803
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the implementation, the sent_frame count does not increment when
transmit errors occur. Therefore, bq_xmit_all() will take care of
returning the XDP frames.

Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent frames")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 42ec6ca3bf03..2a3e8b69b70a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3798,7 +3798,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	entries_free = fec_enet_get_free_txdesc_num(txq);
 	if (entries_free < MAX_SKB_FRAGS + 1) {
 		netdev_err(fep->netdev, "NOT enough BD for SG!\n");
-		xdp_return_frame(frame);
 		return NETDEV_TX_BUSY;
 	}

--
2.34.1


