Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF254AEDF2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiBIJZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:25:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiBIJY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:24:59 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5606AE056C2B
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:24:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRTduzcZWRlbei+45w757DPqDa7g+VwVwgcWV6htecRfp6hTq2NiiAqNdvvoa+kjzCsYSPzkTVcfaUNNTvju1P7bYA7VA+Jcs/V7RQpDvKkh6SLqpfNFk5DlkJZgZA+gV+QEXQrxTuIkHIQN8kkqDFziZjBsdNMoUiaTI/pTGQXS/4SxXs74pGAIOlHcxDbTzR8XyfwqhsS/8Jz6LUDHnYNJD3hn+irkkj/dBEhnetkHcq6sZPF/xGAuG/Vbfu64NZkxaKzUw/xSLyzjXgZv1qMtcsZt8yZInRz16Ak9V9nL7jN1E+W/UYSY6rjh9S5AR+tfJKygGsrWvjIbExxJGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5SrKGU8FD/c8zDy2feLrobaOzgObo/7cgs6hUnPEXw=;
 b=ExEQU5hzynV7ptUocNGUoUnfFshOgFY7u8a51kQmDQQkHTyFAH+5a2nrulEyy4IfqSGVfErjIeYaNZ/c+hvysZMTo04zIpW8ZQPhLWAChOTPkktBZYsRC3JOjSeSopYFrrGJV1mF4Aqntyv2lfGoq6TK9EA5QT3lpHdQcd4/wSxNJk9pL6m6R5A5bReq0xkgKXtQ9+OVFnHu5Pk/ye9Q44mCv+xz+HFFBQOZXlxQyRnBtQR3oOYbFOCAfW2e+qh5a/NNnJQlyxl/QkSRnu+g6npezK46bZMpVnOZ+5h53W+uKEYkavsAgFVIdDXTkhy+qEwm2zIVX7wjq0Kb1VkuhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5SrKGU8FD/c8zDy2feLrobaOzgObo/7cgs6hUnPEXw=;
 b=dIWEFlXl3WEriVX9hTowiSQxrIl7Ki2GBuooBAVQP1U/7/I1941maxuJJnB6ohAMaqwgsJtoyt3jMq+7TJ5sl2qxEzdJTZ74BopCO+E2JIgBg8Eoq0DVQSYjI1FgLyBH/uSzy4ckLVtt3QB7ObPKZx48WC4oLZQGR7h5xXMtWSA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB5423.eurprd04.prod.outlook.com (2603:10a6:803:da::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 09:24:00 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 09:24:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/7] dpaa2-eth: rearrange variable declaration in __dpaa2_eth_tx
Date:   Wed,  9 Feb 2022 11:23:29 +0200
Message-Id: <20220209092335.3064731-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
References: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae3f8a96-b795-44a1-8b62-08d9ebade7df
X-MS-TrafficTypeDiagnostic: VI1PR04MB5423:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5423E05C45C75AAA6DAE1615E02E9@VI1PR04MB5423.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MlvmuOXSTGCLAJdIZczemU6X8VtyJnvVjijcTImc/VJrfhgrnImus9EumjVbhO1HZqyaTKuQnfB4MHyOE4uRKrzvEIFZglAnq0RUfoSueUHioEYmsoWi1MZ5LNAqYbDGH1Ff/EZmNfDhY8lp88S+D+uNDHVqmjLzIVxQ8RiBemMPPhP21APuLyygSilL8qrZEjdMBg315F82P9ClsoZjU8PXAqmC16mr1vmklV16VO8owxrIYxEnSoXOnTf4y6X/9/FIaCAF+parhawd6G2xP9JZ+56WErRqXHc2HgUsQwyLxWyLUUBqyT7HPdOfxK4dpL2GJ6RdyjII9ixi7jGwo57RIuJqOpgYTVEUUpI1dXoqQ7M5woslmMnJEpM4P0yqRZBauDasyAKSNEs8fcJUB8+4IpPNMhR3OV7CgSrGeKGsM/5YGMO/O75qD5LAo709aJxLUpCnFbwn2WLT2t214tF+lMzAHYSY9lnm+Q04rqZmbMayMwjQOjuyrohSkQkSPiDEc3Qix2GH88VcjeRGD1HTw4FSCfr8GEw5pg98CkbcVynIj+mt/bnRZdP98B4o1nrTjJ2w1y2kV9ST6kYD9foomRm/cCrOgZJBnpPzV07WiAhdQM7N33BvwR6qWxE7R/zI8A09DnDzTpNy5dx91JI541RoPQSEhGHS8g2quHxVXoU7UmWlxYLVEiTrnbyFB/I0+NiKiN1fVFKJGQhtPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(83380400001)(66556008)(66476007)(8936002)(4326008)(8676002)(2906002)(1076003)(26005)(36756003)(6486002)(5660300002)(44832011)(52116002)(66946007)(86362001)(38350700002)(508600001)(38100700002)(186003)(316002)(6506007)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jpN7fZSssi0xomPR8uDheZhXOCkKftG8xCodFGb7fqcVFM1ekSi7J/ZmbmhK?=
 =?us-ascii?Q?LNQcstlT1dTP083XtAnax0RWsJvRMQnp0RRgMtctwT+E46AXpXkKWaWQLFcQ?=
 =?us-ascii?Q?Gt3zN/EKpbyqisaQFJteQN5El6Z3yeglPVjnTv6u+X23XOgHOmW9Qjbj8bir?=
 =?us-ascii?Q?zU0Lb+MQt/XNoSIBbI6r54y2JdqfdYQS4lTBEGy2py6sVnE2CncQhFbgcB9L?=
 =?us-ascii?Q?3MzwkKxu01WLc2rKE0JEfJm4cLcI+qACZJUAvzaVCWENqQNvTvpqCrabLA9k?=
 =?us-ascii?Q?oWFPGbcQ8AdqosVpk6PZqut+n2tp7HxeCU/OxUB+DRfj35/Ygv9RZKX+uhRi?=
 =?us-ascii?Q?joIhxn9A8g0GygL2lPE1+E3NUtMwFlwI9VWG6DsNgA/E7Dwu4bYyO5FSQ5jb?=
 =?us-ascii?Q?x63sOEqanPRD5RUXRp80uC5Jn3p71n9TNxY40E4uTgmNKjdxw3V8tZgBi5kC?=
 =?us-ascii?Q?f/hpzZYstF9YYQG38ba2FviVZVy8rRVab5WEC+zrgpIp/RuS5UEJAra+JJUc?=
 =?us-ascii?Q?p6ukmUj8NF8Tmf/FWqpnYER9lCQ9r693fVjHEahjO36U+MxXh6lUX0WdR9mi?=
 =?us-ascii?Q?JFGwTgD5eVuR/8DZc1CsWXyH50XZB1tpLJMf2Sh4JFzNaxdCNuyKqChgfErv?=
 =?us-ascii?Q?ajGrmSu0jWMybV0M59sCS+vHRmGH/G4r/4TON5w0Bxz2ivev0AOse3AHZUa8?=
 =?us-ascii?Q?K3R1omyPjnD5c46QhXIRHfcXO2/5njYC4s7tbnx0T1nx7zjhzb/FcqIO7fot?=
 =?us-ascii?Q?bWp8ECjmEMPhs3btbRayaaNIPacxdKCEmp1ckbRG6kNfuRp8XMHmePaIHAsB?=
 =?us-ascii?Q?gH+D7Rtg5z1okn3PC0b3MhEyTAP3PvpB87WDfKi/K2OO48tDheCMko4zykej?=
 =?us-ascii?Q?XWyF7PFYX8qlZIMXiOHhwrK5t32Pg1Ta2BRzhkYYEsn2vpNOl6EBOo34+5Ly?=
 =?us-ascii?Q?3OATXwY5cMoM+9+ef5U0O3yj3/2CMShkvOHhliywSrmaG1CScjTDTDfPnK6j?=
 =?us-ascii?Q?BppGizy+VFHB1QjIEivfaxJhY7KPQEpUebq6bWinNEzPH8PmfYEVK5eCbM7A?=
 =?us-ascii?Q?a5riP2MUyIVfvcDWkPNR3Y4P0dQpNZ1YbvlYmGYENTJXl0Ws9vMQrEo+ai58?=
 =?us-ascii?Q?vm/vAQPY7VUMurFO1A+PYdaTestvDZm5Qc2+RxeymfX4vr9qyOp1p8eCuTYW?=
 =?us-ascii?Q?XntsNx8lipVA0rtWK0TkuyzIfqH6ZYORumUgToWoYMnRwngN3y8vXtLc8Zf+?=
 =?us-ascii?Q?4tt0cG/36Wp67VwBjNJ3RJXdGiV83Kf1W2PYG50IHETB32qEH9XuZhm93lFK?=
 =?us-ascii?Q?O3vWu3kRT2j45cGbqFM7RHlHJiveXTv0CYHfoEtYjCbC/BoRYbsUAZ2RhmaF?=
 =?us-ascii?Q?G3B0B9qEk7+XRhw6PkwzXbsVNuXulShJfLpxVFiNJcuYabjBY7raUm03WMSM?=
 =?us-ascii?Q?2FxYv7EKuorrawu995bsxDPrqUHB1uWFC6OMGxtWvOOZUhR9tIYC0DShPFT/?=
 =?us-ascii?Q?yjZvQWhXspX4m+tDdC7PVYe/nkuEVPY8ynT08ONLU/fLWwNRz7Ju4vZHZRsd?=
 =?us-ascii?Q?0ejBnT8woTS6wV5oXdD7gSPk0v2vpb2vYCS4QO6cZ9FNxAC1HKVTSw2n8GMi?=
 =?us-ascii?Q?M4c7cVd2u+Ac0DY9FaJSqqA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae3f8a96-b795-44a1-8b62-08d9ebade7df
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:24:00.4660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUOKn08VsGlIxjA17P3HJ+aZsmvaGVF9IAI0rl28TV2WN1wNZbk+/Droy6+w0f5WI3scH7fznvR5tQd85Bwx3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the next patches we'll be moving things arroung in the mentioned
function and also add some new variable declarations. Before all this,
cleanup the variable declaration order.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index e985ae008a97..218b1516b86b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1102,16 +1102,16 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 				  struct net_device *net_dev)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	struct dpaa2_fd fd;
-	struct rtnl_link_stats64 *percpu_stats;
 	struct dpaa2_eth_drv_stats *percpu_extras;
+	struct rtnl_link_stats64 *percpu_stats;
+	unsigned int needed_headroom;
 	struct dpaa2_eth_fq *fq;
 	struct netdev_queue *nq;
+	struct dpaa2_fd fd;
 	u16 queue_mapping;
-	unsigned int needed_headroom;
-	u32 fd_len;
 	u8 prio = 0;
 	int err, i;
+	u32 fd_len;
 	void *swa;
 
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
-- 
2.33.1

