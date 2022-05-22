Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E3253032C
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344663AbiEVMx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345368AbiEVMxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:53:19 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E8C245B2
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 05:53:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqahMnaUWZLs/ClZlrDKVnNQDczSZWpYjvGT+9ZclFlbL7uPmguH8TeCtyV53Ja8iN61AEERIcoYO8EHgK3vvPZxsA/o4J3Zbfm2PcXbqjob89OJbNqWvq+4MvmGWl8d1BRcAm+kQzO7kRGxbsftd/iXeJilSzUVj1d9NikCEVBfGLkKULEJx9GGY7HieCdK43vTMlErv1EqHrUnRKdXTvk8mkOfzSC5bBxovV9LSFSYtvKVrCK4qadEbF4VF+ZQam2JUprF3M5VVoponTa/WcaihFf3PX0U8ySKCraE5wKkteRHz77Cek8M3hhYhdjUHr8Sy79myaL2fu4BeS4KRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gm4maMoYMzs7AusjpRCV83EZa264bR4z/hZZ9hlDxLQ=;
 b=HIb7A5Ukuelyv0k9x1ZOkByb3GWBrZGOPLq7PsYEvuuprF91EiTZs1Y8GsYdMOcQ1Y/OeM7gRYBs68RGBVLH4Ei+Fn4fx9iW6H2So2NJpJZvsb2J0PpvImu3N4Pg89Wd2phCrLbhMp2nL53Op/xYPvnbD30uCfXgdf9NoWI+T7k38Uk2QtUnYjaJv9PCojmD1fy7irmQmi9qVoajsqn8LlzjHDo1uzyf3kLo0RWNa5uvlBfC46E2YDz6HdhJOYch6JDQdI3SDWsCRjkqbf/s4wmiRSpfaXpQ9VsuQCflY+LI0afEgnamy0DSLBFHm9Ic7mdvXRnCicqE1azEY1FclA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm4maMoYMzs7AusjpRCV83EZa264bR4z/hZZ9hlDxLQ=;
 b=dvr2nyNGn8OasKfX/KXHayhPwY5yRoonNMvWX50CNba2nnDk/ZQxseDL0OkaiR15NhI5jNv1yXuMAlMJp0w0zQESr3WJ2GqkmXOv+UGI0ZKWdl42xaFIIlN6NCq2aBOCmCrs78E/0/gPZ9ER6w3gTvlYPqrW5ntcrMen7MyhlBI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM0PR04MB4385.eurprd04.prod.outlook.com (2603:10a6:208:74::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Sun, 22 May
 2022 12:53:14 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%5]) with mapi id 15.20.5186.021; Sun, 22 May 2022
 12:53:14 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net 2/3] dpaa2-eth: use the correct software annotation field
Date:   Sun, 22 May 2022 15:52:50 +0300
Message-Id: <20220522125251.444477-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220522125251.444477-1-ioana.ciornei@nxp.com>
References: <20220522125251.444477-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0008.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::21) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bfa04b7-274a-416c-b62f-08da3bf208ac
X-MS-TrafficTypeDiagnostic: AM0PR04MB4385:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4385FCEBFBCB71DA85124054E0D59@AM0PR04MB4385.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXMSZhZMbX1DlgyDkSDOVAmcQ9K0tUJi7UQNIdamCg1ilDL0agPJs8j1dOD+SpiMARl57lFySKdebasZ10c76r1x3Q3Mic3HbfFIxordG+MW4C/+5a48zvDxkFeVqveRFr6coi6GrXTRYsmGE39qyg2+N6ozSpbRIegLwmrUZ249SbT5LiDCfIMpssK70nvuhHbg69nsC5Mazcl3ySpoe4h2LDCP3IjMoj3VtEIxPVFNK62mwIfMLzdCZ7ocDqkizNCO9/pjuNGxHXH2uC+XyLxk69GX2L3jQhjtyglLAMgo4ZPGT+KT+7nO/U9EughHLPPjsLuNjYQIg+NUhk9NG8o+NpZPu1gVZ54H97WfVR1AkYhnWpzNAy0Bgf41FZxtMDEz2ytHZrFMoTYOXzRcSAeUlgHi0keFNUoSsGGJEBExhZmdZlwgg6iITE3ouxFQMStEco0/71ZnY0plh1F8bX9+HIdw3Q56DOv7eIQd/FrESHO/kBLP5AheC8H9O0XdnceRDVxVCSKlbR2B8NkDhrdqD9oeDfx9oBB6i/78Cv4KoJZDR4uVPIXF0OqhFpyhU+x/5jQzCJYAZK+k3iH1+JXythaxMH/7gkjw0+/TcCWvv6RYoJ0fjRWJt179U+hD1Esp051+pMmK1BKr1SIKldwLNRcVWMqNlvsioepo2qS++epBYfJ2rYBC4how4nUsi0LdP6G1pPcVVMezljyoWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(45080400002)(44832011)(186003)(5660300002)(4326008)(2616005)(1076003)(38350700002)(38100700002)(83380400001)(2906002)(6506007)(6512007)(26005)(52116002)(36756003)(6666004)(6486002)(8936002)(316002)(8676002)(508600001)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ofwQcas39f58UTtqJmmkjMzp5XQdSiEZVc1VLyo/kgCAXLMSny6+C16GIsEg?=
 =?us-ascii?Q?YR2M/j/V4aiQIum6q5aERDD/tXOd5Mt3erBQbqvJiJNEXTlQhvdNByQeKhFu?=
 =?us-ascii?Q?DF4CIiNdlYjLcDwCYSOHvFzFtIy3ARobiUyfN6h3we4TdW1ZhQyLsBArHOKT?=
 =?us-ascii?Q?cN7xoyvOC45bEw6Zr5rUcWeLn8rzPhu9ydWYS5lbq/1CxbOIEZywLDXnEIUT?=
 =?us-ascii?Q?3fx6aVDG/wCXAGlLwIjbMZFaPpfOpIkALhQhR+NH5YfrPNnYEoM87HN1L+pa?=
 =?us-ascii?Q?GCikjIh1YhAcXqVVgvhVtibcPSt5cl/UkgH/HsVeZf360SXjRCxIb5mtwLi2?=
 =?us-ascii?Q?iPCd7B7C3rrOg0rZFRP+UxfFjtsyDEKUBfpShkIkfRTSOnL+txx7fsP8G8ZG?=
 =?us-ascii?Q?6YUrgEGt4uikS1yZJE7BhMBwhaH/a1pHTcyqH6cpUneAx6b8ailHn1g0j+HO?=
 =?us-ascii?Q?+a64SxWIALM6qpVh66YBIc9kGv1XgaxNEUrxbRjrYQXZeFQkwJgNQuG2uOaU?=
 =?us-ascii?Q?85NC/lm8N9YS/J7vu/M8zPF6r8xIOpYFHb5K2CbVljm2VAoRdNHZRqk90fht?=
 =?us-ascii?Q?hqWuzlNK3lLCJTOuLverhjusR2rPSgXb2mukU8XAm+Sxk2q83ZF9FvVgq04s?=
 =?us-ascii?Q?yyY5whAZGpp3awxazVQTINVxVUQ0q+/gtrhLbAteE0TKMqfJD9FAPy4WvEfJ?=
 =?us-ascii?Q?RsSNV7RAy0cMD0FNaFyOaWfuX2eBpEqvoXuNNNm/kjDeGFotfEEraQg7oiNw?=
 =?us-ascii?Q?d4wAeuaRXWWP1bqVPE1pVApC65/LcP+QM8xD29WYccFmH+YrsjtJCH/4i5Mj?=
 =?us-ascii?Q?IS4kht6vxQ8dzrAomF44/FTsaXNDXo+YsEPUSdnZW575rIhaKGhgwji+md7o?=
 =?us-ascii?Q?8OuRRkY6F2uHK6eG3dD1o1KmoJvktFA7/AqLIOjYrLz4Lksowdo62288dKFf?=
 =?us-ascii?Q?b2Gnc4LRFJDSiZ/hNybBEQ0VqxpBHe30S0Z7voHXIxKguJww/N+z/id+Pk1V?=
 =?us-ascii?Q?NpcL3N39J07LjjxnBP5apQ2xM/4khlo8LdaWjJyaJ9w5Bf3W4lLit+ypgp1Z?=
 =?us-ascii?Q?hbVGde3L5x11EQV6C6SogT4Z1SBWabCr8ZubVZIS0CBEqIU8GoVcTPinAK5Z?=
 =?us-ascii?Q?e8DjUXVOTW0gbZn3X0DVp28HuBH7TMR/T1j2de3RQyNm29t/aOIW7iXcXTDe?=
 =?us-ascii?Q?as25bCjLoiwnsukor+AIuzfUnmrXw3tSf3FV3t0u0KQzlOpRLeZNadkHygcA?=
 =?us-ascii?Q?2oe4E8a2CzpB/+lPXrhzR6yPbFSn7O4y/7E9fyQonVHhmPfciVZVkJjrR923?=
 =?us-ascii?Q?LlBMcSmrUz3W3osfHi80wgeeTPMlzb71cC/wtGvkrIgq2pmpAaLDUZIxNbOh?=
 =?us-ascii?Q?0PRee5Xh6C7lt1fKo4dXnuh2tOMVbTHH/c4hiKKt/1Yg50m4Cv/fRHujlveE?=
 =?us-ascii?Q?6H32PNHwKV88MK/W0GD2urWdv2WB9XCkYPs15y00oH+hR3ifEW2rA+iWNTbS?=
 =?us-ascii?Q?BfaSyckeI0kSnKUKjTIXJCsA2a1QxlNekW6GcT6vGd/vS2SBQF40m+BvWeAn?=
 =?us-ascii?Q?8klkwcL5jvYFV0CsDDO12grrA66U1rBU1dxMklcnue5jwBhfQ5P45lT3Hr0u?=
 =?us-ascii?Q?5WtGZdzVZYPoKgDvI72THQ2WKzl68j2C/bqQps/5IeQJwdyRorWisMjOurMs?=
 =?us-ascii?Q?fYyZopsD0Vkt+m/YGzeou/21VYpcABNRdz56pcBgxmzWGYTrAUZy3G+6x77O?=
 =?us-ascii?Q?cu+kDznPAuzRlJfLDIL3u/7g1ZskC34=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bfa04b7-274a-416c-b62f-08da3bf208ac
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 12:53:14.1413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjv6ohSYyuK/1Cztleb87WofPeZybpjwL45H+WvRJSE/7WL/oxJmuRHvI6rvrJiG/pa99IoTwmsHOOyN2dyKdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The incorrect software annotation field was being used, swa->sg.sgt_size
instead of swa->tso.sgt_size, which meant that the SGT buffer was
unmapped with a wrong size.
This is also confirmed by the DMA API debug prints which showed the
following:

[   38.962434] DMA-API: fsl_dpaa2_eth dpni.2: device driver frees DMA memory with different size [device address=0x0000fffffafba740] [map size=224 bytes] [unmap size=0 bytes]
[   38.980496] WARNING: CPU: 11 PID: 1131 at kernel/dma/debug.c:973 check_unmap+0x58c/0x9b0
[   38.988586] Modules linked in:
[   38.991631] CPU: 11 PID: 1131 Comm: iperf3 Not tainted 5.18.0-rc7-00117-g59130eeb2b8f #1972
[   38.999970] Hardware name: NXP Layerscape LX2160ARDB (DT)

Fixes: 3dc709e0cd47 ("dpaa2-eth: add support for software TSO")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 766391310d1b..f1f140277184 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1148,7 +1148,7 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 						 dpaa2_sg_get_len(&sgt[i]), DMA_TO_DEVICE);
 
 			/* Unmap the SGT buffer */
-			dma_unmap_single(dev, fd_addr, swa->sg.sgt_size,
+			dma_unmap_single(dev, fd_addr, swa->tso.sgt_size,
 					 DMA_BIDIRECTIONAL);
 
 			if (!swa->tso.is_last_fd)
-- 
2.33.1

