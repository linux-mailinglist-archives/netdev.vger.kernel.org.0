Return-Path: <netdev+bounces-5982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB3971420C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 04:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 997C0280DD2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 02:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A977D63B;
	Mon, 29 May 2023 02:31:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9737962D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 02:31:02 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2055.outbound.protection.outlook.com [40.107.6.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB10DA4;
	Sun, 28 May 2023 19:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bo8duciBBKt8XRBw6xKAWIfEiCsuVw5xy+GzUnWKD6OdSJgPts1kGHNOwFV+4f1RKcRVaVgEV1kRtgfUUkuTsuzi7ETajlQ/tDYfCEZ0ppT8PXd2kxDvyzQRYC/F62k9/rUFPB/vwJYfVeKhyHH3TwHDFwAeP5vzDrd+14Gu+ezUwiqSItc2NxEK/FIzgM0eXZdbRRT5QGLmorAJNwkN3oVSQbZ1Px6NtKr8mUDL0t9xCnoyXIm8827nh11uVhsRTWhWBLbAKaz9hseMzYyC0+dHjWqFDlCkNY1f1UI4I+N3jty2KljiqucijlB2G3bmqJmszqpIdXMfe88dbGnPvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zirLcE9thY8cVNMd8hJOD+7KPlbOPTKgqbjcmCyu9n0=;
 b=alEoRvJX0x34VMkXH+Yvg1mA2uJvR3d+fhCqwEOMPY1lJszT/rchV8GKmUQLEiLNLMrh5KosjFTH3Saw5IV16sWZlKPMmg4N56S+uWK8uVZaunte0B44ZKshVDThXsdlXi4xwvs5TEmKxZ3/XxXb9qamIuo5xgqLi9G0zjI/JJ1xJwjFUaAz9pckZmVQistVSHz3Av71nupsLee7ejSQ5W7dXABAOTnQ5nnW5vnWJlZKn/hqRv4ti2IBKS+l4WyF6rG3QBC+5+ZQthXHP1hJQbohtEnoWi96oLLGDglPnz5e3Xe29mHm45fufQ21EXxQsyO/kWcwW79rFlJHBjl27Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zirLcE9thY8cVNMd8hJOD+7KPlbOPTKgqbjcmCyu9n0=;
 b=PIF9i8qZB8vJfx0QTDLtIxPnu9KcZB/V2rgR9VH9v8qMIqxl3u6XRYdYs+//rdwiATi2vzY6j2ENIEub8Qfq2kuMZ9qtgq2LXcCn/UtUeovYwodVisZOAFculDBmgRNcMOJDPA6G9izr+KJiaT2rip6wOmkktQ+WYMc04u9ySPg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AM8PR04MB7825.eurprd04.prod.outlook.com (2603:10a6:20b:24f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 02:30:54 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6433.018; Mon, 29 May 2023
 02:30:54 +0000
From: wei.fang@nxp.com
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com,
	simon.horman@corigine.com,
	netdev@vger.kernel.org
Cc: linux-imx@nxp.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next] net: fec: remove last_bdp from fec_enet_txq_xmit_frame()
Date: Mon, 29 May 2023 10:26:15 +0800
Message-Id: <20230529022615.669589-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0247.apcprd06.prod.outlook.com
 (2603:1096:4:ac::31) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|AM8PR04MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: 209b156b-da5e-4381-873b-08db5fecb9ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oV8yBWUfDWwaE0IONZgy662cQSa9EZnuI6R6xOiPzEXqFlrgnG4YSyWsvOOlkjn+VPaKTWzRMNhiIn7MCyoUezW2cG6osZRmUG4tPRZIkKbDky8407zpS65kCw/c0GasAQjM1KJDwniSt611/g5y6UxxBbL5UHmvVTMg/RwV6mj9JfLOq+rwotnRBzUt/oGCVd9tA+op3mv7mP7TwSWIB3i5auSSQgkjnDvgLscaGE8RTDGuqCGI240WPuKldl5NDmGtuk9TKU8EmKTimmTqkwE6g2E415zmQOXyaCbOooaNKM0LhEux/V4ibxLGn/U1H3e/9B3lgttsMFRKXEeZjEB80S4fh6DkVRyFqJZKlXYtkBhH0Eft32Ye6XbDDxvlm4KVsV3ID/vDU8gWf9lUJ/Q7tzTCkoL1dfzFZeYryAw9MOknLRLj6S4OS9a8WyhAmcyJveNztMQzSqfbC07cKV+miEXRSf4mUNvjSFRaI4TutnGPzw1ikIYVTf9HYjgJIDaKgUKD+rbOr9errSvy1ugALni1u8c7EH+MZsCl5vGapkQZgkH4IYZ8mSnXKYrOgeLiau8wIAfiqt+NV3wyKNOmBEzwRewKLg79Fwv7tODvD5TVZqqw4Rj8gg8b/OH6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199021)(38350700002)(478600001)(38100700002)(2616005)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(2906002)(6666004)(6506007)(6512007)(52116002)(9686003)(6486002)(1076003)(186003)(26005)(316002)(41300700001)(36756003)(5660300002)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RidQOiXU7SJfcxfACQidgnMIYd1DLodgutSFxZ4thRa1YWeVGFnEBAthBzDr?=
 =?us-ascii?Q?Pxy1zJ8ZiUBqUmup4+fSxLiAxF0HSqDauP9B45EQ/pUG6D4klVFiNmKEVlIH?=
 =?us-ascii?Q?q5Fl1c909nehVYrIh1T9SMB/d9wOIFDq/tKkmQL33MyYRRoQJ9rcLYeEyCDw?=
 =?us-ascii?Q?55E41OGlfQtZ+Z38NuCRaKAPFr1IUCIpvoyLovGniUS26N7y3B6lFGoRhHrP?=
 =?us-ascii?Q?5OM8GE5FGe8r8fdOASAPCiCdh+naum3Gg7kEOqgqw2qign8tgrltr44rrJAR?=
 =?us-ascii?Q?JEvjgC62QNQU0IsUViVVoOot40huORs7LWtOXZr7t7dk1wShEuJxOMO0UP+u?=
 =?us-ascii?Q?lNlZX3hk9CPDUVDgX0CDiMeH69EpC+FcS7/32Eb0NzLxDdx8VD5bnlTnRFnM?=
 =?us-ascii?Q?2w0zNq2KtbXxkOTsRP9VjHC4BeKog2jD3LskLX+un9zI2rI/1iZ7DhBDPBor?=
 =?us-ascii?Q?0k1X0+P+fXj5F8IZrZnZl+82LeF0R+EpKGLQtiOTr6IpwCtQ67cMBd5t16dM?=
 =?us-ascii?Q?L2ubb2D2jLQ2ygrJxqlUabyeieHaE5Sq1pGmTVhKa78Zeoo9Tc6krzlpZwzo?=
 =?us-ascii?Q?k4lZbTUyeOOW1ZELdWz06Xq+v04ixKva9WuHsvYQLQb0lW/FvQT8Nt8T67yP?=
 =?us-ascii?Q?PPW9fGXRvOE8P0xg4TJc0F4Qr9O5ZRMOkfTYp/a62ZlovUCsV/FEK6SXd8fI?=
 =?us-ascii?Q?F7+fHuDRMqLp32FtnDYU9OCJPnSVq/vjgaAj+t1bE5lStG64UKcOCGFRE6MR?=
 =?us-ascii?Q?Xrtlih3IKUHtaLiqJoFU1jnEnE5bwj2u9Zc05CtZL2rqq7hT5AA2vVF3Pf5S?=
 =?us-ascii?Q?GfZoRqVlbTIzg7bixafMhxTRCcBa6eWWOOGzPjOMY7o/0EFRFHPcNeUYOYee?=
 =?us-ascii?Q?4Ixxan5ehGDrfWq96SblwRZF9wNQl+XletFD8CDDnbEzfEJIXJ4A9jRwXDOZ?=
 =?us-ascii?Q?TAy+obA3/q2BDX3FpLYQip8B1KXpSl2gD8M7jxA6M/OhbNK5ibfvG9cigGkp?=
 =?us-ascii?Q?ym50yhdK8m1DW2Nz88t+8mTa5uUxBxPiazxdFNOXw02bwOmpJG6dsKQCSgSB?=
 =?us-ascii?Q?AMPXR2XeyigpciEVDMp6W8xsNq77//WmmQi+uYpLAc5AYnhEn4G/pnuwCReY?=
 =?us-ascii?Q?KgjRFiCtwRCkkfcj0uFjpK/sgziYbt80vyiX9L8OE08iSohpkOauAu5Z2SZB?=
 =?us-ascii?Q?rCHokCiDtvuGhIu8V2AqUsPVFVjGHznZSJSSFA+zxG+leE6NF6x6dII+IFkW?=
 =?us-ascii?Q?n0tl5LYd8N4kZWzHI3smv2xdtP+1QuNJa+e0MGgUrLgPyyrBqDV96D365eiI?=
 =?us-ascii?Q?MIcGK/d0zY/nKB9H1WrEQUnuco8PSRDv5kSjN/8h/VyUsXjs4L1c+vBKukEi?=
 =?us-ascii?Q?X7MDvjwbQwPA0ZhovJ2Wn1HKrdDfOYSKM7Cu3kWt9hLDSMOiNOGMNMi6uMEZ?=
 =?us-ascii?Q?Q/dlHqViVsQZcyXKpPzzczLeO2QGDfASsyP32kCUiii13fvsaZpaBifzT4Uf?=
 =?us-ascii?Q?EgSzVwo1qbU4ScNXGNMPSElJn6eGeo/0haL83U0x60CGXSij4rLCjbh0GwPL?=
 =?us-ascii?Q?XMoXgtSqg6dVS0AurnwqImiE7keg7TKSCQtJBq9r?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 209b156b-da5e-4381-873b-08db5fecb9ce
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 02:30:53.9319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TRgTQiCU2xbpXbv14pEL6/Z6Zve5w3L6GvZWaLC1YPeao5AEDlmOStekjU/mE59162cMHkVjjaFyOL2+YSUjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7825
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

The last_bdp is initialized to bdp, and both last_bdp and bdp are
not changed. That is to say that last_bdp and bdp are always equal.
So bdp can be used directly.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Refine the commit message to make it more clear which is suggested
by Simon Horman.
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 632bb4d589d7..4d37a811ae15 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3770,7 +3770,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 				   struct xdp_frame *frame)
 {
 	unsigned int index, status, estatus;
-	struct bufdesc *bdp, *last_bdp;
+	struct bufdesc *bdp;
 	dma_addr_t dma_addr;
 	int entries_free;
 
@@ -3782,7 +3782,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 
 	/* Fill in a Tx ring entry */
 	bdp = txq->bd.cur;
-	last_bdp = bdp;
 	status = fec16_to_cpu(bdp->cbd_sc);
 	status &= ~BD_ENET_TX_STATS;
 
@@ -3810,7 +3809,6 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 		ebdp->cbd_esc = cpu_to_fec32(estatus);
 	}
 
-	index = fec_enet_get_bd_index(last_bdp, &txq->bd);
 	txq->tx_skbuff[index] = NULL;
 
 	/* Make sure the updates to rest of the descriptor are performed before
@@ -3825,7 +3823,7 @@ static int fec_enet_txq_xmit_frame(struct fec_enet_private *fep,
 	bdp->cbd_sc = cpu_to_fec16(status);
 
 	/* If this was the last BD in the ring, start at the beginning again. */
-	bdp = fec_enet_get_nextdesc(last_bdp, &txq->bd);
+	bdp = fec_enet_get_nextdesc(bdp, &txq->bd);
 
 	/* Make sure the update to bdp are performed before txq->bd.cur. */
 	dma_wmb();
-- 
2.25.1


