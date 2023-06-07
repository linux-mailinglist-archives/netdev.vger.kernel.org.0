Return-Path: <netdev+bounces-8765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 981367259DE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02FBF1C20D41
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2BD8F68;
	Wed,  7 Jun 2023 09:16:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87758F4D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:16:07 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2082.outbound.protection.outlook.com [40.107.6.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460621FD4;
	Wed,  7 Jun 2023 02:15:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDdi8bJIuCY0PooDtKo3Ff+oH2YzXry6Chvu7G+gcl4Wbku3y+6BzSsSUlkhb77Y8SwJWN89v8DxhHRP0cc6SHYlIV65wgEFA9LFPMvL6zX47D6qYxjqxquV83Eald0V4Q86dFq+2zumxZP1BbcsS3X4RG3GbvRmUboGlkh7xuVWbhjyY8obq7+V8XYOMDZ/Mr82UyHujdFGs2TXf3U0CCV7MYnghgjyaaE8nzkjmCgnVhW0APQO1p1KZs/QPVcXcWejBauWlymUqwQZEEsw6tgalgIH+h7/YxVKhI0zY5Ro8iohswO1wL9L1yiq4eRRU0JCLD35Y0WX4accyTVUsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBA21zpFh5ePogyjv9Mx/j4eX5mYSJDLmgvIC1p+dIU=;
 b=O0fZymS57go5FVR6eFYg9ZUF6c8hzZac/FpBiKaoUGbfnYAaCMcdpv4f4byPnjyGrup9vVvVBG9ZakgYNL2G+CneObPB3hgMrd1+FCNYqa6JdTu9ZfQjFBw8hqGzBcZAf+W4vslYMaZ6/VnBkG0BcfbWoKHd3WG06Ekmtde/4zq6HPEsmy/aHRBYJZwwN4PNkfJ42vCLIXgC+YL304O0m48Uh2CoDs7gg7TsoSwEB0V9P+o+b1jHVQrhRG82HZlU2RuElZZ+P0GXY+kLn55bZD1K6BngfgZXM4Vd6dB5LGWbBr5D9xhiALe18lKJ3IF73x0hMvIaLf0FRUIVQDHGMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBA21zpFh5ePogyjv9Mx/j4eX5mYSJDLmgvIC1p+dIU=;
 b=WaJKhRuzFXpMDjqCps2O546UwlR91IbffJ5SH7Stc9JhzlWC9f5EaSSpWh8IHRmWyIbDRMEPgiZjlmNLUOSrXqrKUbpWf9rZA3b7SoJbBJbO7VEglD8Ip012fYiUfQbrtewJjKRuwijskBMH3FpglDahwJ7d5EFG9MJTXN0z2C0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by DUZPR04MB9897.eurprd04.prod.outlook.com (2603:10a6:10:4ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Wed, 7 Jun
 2023 09:15:43 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::1edd:68cb:85d0:29e0]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::1edd:68cb:85d0:29e0%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 09:15:43 +0000
From: wei.fang@nxp.com
To: claudiu.manoil@nxp.com,
	vladimir.oltean@nxp.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	maciej.fijalkowski@intel.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2 net] net: enetc: correct the indexes of highest and 2nd highest TCs
Date: Wed,  7 Jun 2023 17:10:48 +0800
Message-Id: <20230607091048.1152674-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|DUZPR04MB9897:EE_
X-MS-Office365-Filtering-Correlation-Id: 319fd7c2-b36b-40dc-9dfa-08db6737c4f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K593v0hu/WGX8jT7e420AUFwLY2LvY+pZl4i97T9xsryQ2snTxAEh1D65ukGLCnvC32/XC3b0rgNpZUxqMS5MCgqR4P5Ed/7aqc8Cr1HbXad8L++udPT2XCZLzrIdH/lo8IEOLcQc71Zrz8mBFTtF90mK+6EdBHdpxFurpb0iN1ctkiASXk40G51YLdYEEpBa86kpKDVZoGXI5uKY/4ToWQ35WuoDdxRmO2sQ1RZVP/Qk/AHsyPz26eugJnrjoPkgpYXP4BFtp/xyk7CaiYU7XHppK8uhhYWv55HhOaZBcsIwvhOuJEGaCe3lp3XJ5T+J0iZfws5ZlkDoEqezNpj5XgM4X5MrJY19VsOjoUAfJtum5OPRjXX8UZddN423ZSjKAb6mULq+qmIGIkM390QQvka8E+Lk/z5Z6Z4J3T/H8exu3dkq44/toj0cJjthwGsILsK8IpZJokbZ+UxFVuGGoBwPsPkEKbxLXg3+XRZA/HW/A9MPuEEAQU8ABMdDbTnfenWvVNS8FmukBm22D3L/j3ubAZ1eNZvKQFAo+U52nPcsBI80/g++QMbyiXHVv5pUx1PU38WCy3ewq4I+lKerZZ+7SWokB6n3A3QSbvdIn6rdjlbnVZnGdDHBeN+OZsh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199021)(38100700002)(38350700002)(41300700001)(8676002)(8936002)(4326008)(66476007)(66556008)(66946007)(5660300002)(316002)(478600001)(2906002)(2616005)(52116002)(6512007)(1076003)(86362001)(186003)(83380400001)(36756003)(9686003)(6506007)(6486002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5y83r8b+2hn95A7/Mo8DvOzkFy1P4mYfJR6+Y3KuXJn5he4f7imGVPr437Q1?=
 =?us-ascii?Q?+KHnzc04IXhDwCy24zRJHxf2dVQZr1/dRRfGZVR9YCjf1QKdmMouc05ifshY?=
 =?us-ascii?Q?MDEpiRCeZuwjTxaJKhOpKhnV/+JfH5Pca2MLeF6FxxRPgMfv30nx1UkSY9Qb?=
 =?us-ascii?Q?xuHYilXa/hV632bhCzFqvVKVgvvVhVkM0tlGM/7s8Xfr9xSZvRiRdjkG3BcW?=
 =?us-ascii?Q?7+nGrOMvl8hvi39HcDjYsGcNR3V7vydGGvejCeazc/5I34T+sQMXZ0zlEy1s?=
 =?us-ascii?Q?0S6+reHlteqKUyLXEn44ibw7snQFGDzISMWjk4SESnOviPjrzBU1G6pMOWhm?=
 =?us-ascii?Q?mB/elL/OC2rWueOkKsQeZ2QMeNWNXyDR4XCYKwkylQFXJvqxyUtvEvT/TQSo?=
 =?us-ascii?Q?+26dnFCbFU0m6ewC0A1Ey4+LcQJi1VBxncoT+zJIqAyedCV7TRCWVgIZLZTy?=
 =?us-ascii?Q?thpHX6gjkHHUj8yr7bD7vrWXTsaIxXUtohWCpa5mzbH/O80yAmDrx4X2dCQ+?=
 =?us-ascii?Q?LjjRPD5In+u+GbH+c8t/vakoS6r5U8t/Twbm0jsOhCcHm33jfFigkdBjAX2T?=
 =?us-ascii?Q?cJrdWAGno9aD8erERyCrXyNZBH6mquX82WMUfDcjTt9tYWFzpDuh+FPXJGjP?=
 =?us-ascii?Q?Y23c3bs1KlJVq+BQ36oMsN7QhjUL2RxKRMmjRU1kMcBzG2k/JPJRJfR63JQr?=
 =?us-ascii?Q?6bkC41Hbvxbbvpd00mlR13OE313dmS/Lv+nXs74Iw7GqQqN2BK+td6dDkwjM?=
 =?us-ascii?Q?kRYWd+zmce5o8K3oMt5H50dOBXx9tnEn/1Kx6l72vB4OYSLwGEqcpxIm99yl?=
 =?us-ascii?Q?8MpsZmMcQ+2K9P57GdgpQpdyYXTOJ3nWdJjjLrAIBq0iq+TjkZJQG/IfnjJh?=
 =?us-ascii?Q?xgM7N6/Lx56N9zgFh//aMZtsZ+nMgz4xYUXLGJTkUcEDOFGWt7NtATUs/uwT?=
 =?us-ascii?Q?VXkXlkta6Aky3guGeH1kXBZECR8rbgL+ZnHtMdR/i2U90lteKak9V2s+p6oo?=
 =?us-ascii?Q?qdCIrKPJhHr1VUdf6k9Zglpue/ztfmwZChyofaL/T8eNPLrf+qpush2cNmmw?=
 =?us-ascii?Q?OxuQdOCtnen1H7bJIqOrXh0NId5Z6JwqDUvHDXZ8s+plL6+r7cSh5hPmvVLb?=
 =?us-ascii?Q?H1kU29Wm+Ywi7mHWgCbsUwXNv5wu50RaJ37LXfTamazL9FFt79g4lz46eSdI?=
 =?us-ascii?Q?BLywk0iFpxRnaYod1AB6NOgpUVcynKajGipUlLh9+JMejxAAwmSKJmJIWFju?=
 =?us-ascii?Q?urhp0k3u7LSSb2sailI2C5ui0B2dWAg5i9jdOdavsZsDdX304Os37RVrAD/T?=
 =?us-ascii?Q?3fMAuy0AGfmhMSylb8ebO5DG21JskgeIxoD6qeOtiYG9/QtDUCVrvcLJ9+dJ?=
 =?us-ascii?Q?TwM1uPhIB++29LlLm9vT2alsDRhWu8QWCSMYs3CPAvlOqgjGczAf+WcbrSoG?=
 =?us-ascii?Q?7PAnrtkZu1XjoUbRIrkUgoNSXqUzYLYTHewC1XQ++jjNTxeVMXLPtqfrWPyL?=
 =?us-ascii?Q?IJ6k39GR5LwM5RsUzH+XrwjZpLwJfqNKKuXq9+bVuD/notuEDE8WdwOHK9vZ?=
 =?us-ascii?Q?WdrAQv+62QHwGn8s7P/V4iVAOQVy1eJPKp3jas/6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319fd7c2-b36b-40dc-9dfa-08db6737c4f8
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 09:15:43.0330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNNNZb+beArKew02UaQEoVtppWxOAv4OrlNkuHGliYZJN71LEGVXsTIR4n+Hr7IQvedJezwWdR4tKJwftkF0hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9897
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

For ENETC hardware, the TCs are numbered from 0 to N-1, where N
is the number of TCs. Numerically higher TC has higher priority.
It's obvious that the highest priority TC index should be N-1 and
the 2nd highest priority TC index should be N-2.

However, the previous logic uses netdev_get_prio_tc_map() to get
the indexes of highest priority and 2nd highest priority TCs, it
does not make sense and is incorrect to give a "tc" argument to
netdev_get_prio_tc_map(). So the driver may get the wrong indexes
of the two highest priotiry TCs which would lead to failed to set
the CBS for the two highest priotiry TCs.

e.g.
$ tc qdisc add dev eno0 parent root handle 100: mqprio num_tc 6 \
	map 0 0 1 1 2 3 4 5 queues 1@0 1@1 1@2 1@3 2@4 2@6 hw 1
$ tc qdisc replace dev eno0 parent 100:6 cbs idleslope 100000 \
	sendslope -900000 hicredit 12 locredit -113 offload 1
$ Error: Specified device failed to setup cbs hardware offload.
  ^^^^^

In this example, the previous logic deems the indexes of the two
highest priotiry TCs should be 3 and 2. Actually, the indexes are
5 and 4, because the number of TCs is 6. So it would be failed to
configure the CBS for the two highest priority TCs.

Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
V2:
Improved the commit message based on Maciej's comments.
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 83c27bbbc6ed..126007ab70f6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -181,8 +181,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	int bw_sum = 0;
 	u8 bw;
 
-	prio_top = netdev_get_prio_tc_map(ndev, tc_nums - 1);
-	prio_next = netdev_get_prio_tc_map(ndev, tc_nums - 2);
+	prio_top = tc_nums - 1;
+	prio_next = tc_nums - 2;
 
 	/* Support highest prio and second prio tc in cbs mode */
 	if (tc != prio_top && tc != prio_next)
-- 
2.25.1


